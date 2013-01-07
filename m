From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v6 0/4] block layer runtime pm
Date: Mon, 7 Jan 2013 12:11:24 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1301071200420.1658-100000@iolanthe.rowland.org>
References: <1357461697-4219-1-git-send-email-aaron.lu@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <1357461697-4219-1-git-send-email-aaron.lu@intel.com>
Sender: linux-pm-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Shane Huang <shane.huang@amd.com>
List-Id: linux-scsi@vger.kernel.org

On Sun, 6 Jan 2013, Aaron Lu wrote:

> In August 2010, Jens and Alan discussed about "Runtime PM and the block
> layer". http://marc.info/?t=128259108400001&r=1&w=2
> And then Alan has given a detailed implementation guide:
> http://marc.info/?l=linux-scsi&m=133727953625963&w=2
> 
> To test:
> # ls -l /sys/block/sda
> /sys/devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/0:0:0:0/block/sda
> 
> # echo 10000 > /sys/devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/0:0:0:0/power/autosuspend_delay_ms
> # echo auto > /sys/devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/0:0:0:0/power/control
> Then you'll see sda is suspended after 10secs idle.
> 
> [ 1767.680192] sd 2:0:0:0: [sda] Synchronizing SCSI cache
> [ 1767.680317] sd 2:0:0:0: [sda] Stopping disk
> 
> And if you do some IO, it will resume immediately.
> [ 1791.052438] sd 2:0:0:0: [sda] Starting disk
> 
> For test, I often set the autosuspend time to 1 second. If you are using
> a GUI, the 10 seconds delay may be too long that the disk can not enter
> runtime suspended state.
> 
> Note that sd's runtime suspend callback will dump some kernel messages
> and the syslog daemon will write kernel message to /var/log/messages,
> making the disk instantly resume after suspended. So for test, the
> syslog daemon should better be temporarily stopped.
> 
> v6:
> Take over from Lin Ming.
> 
> - Instead of put the device into autosuspend state in
>   blk_post_runtime_suspend, do it when the last request is finished.
>   This can also solve the problem illustrated below:
> 
>       thread A				      thread B
> |suspend timer expired			|
> |  ... ...				|a new request comes in,
> |  ... ...				|blk_pm_add_request
> |  ... ...				|skip request_resume due to
> |  ... ...				|q->status is still RPM_ACTIVE
> |  rpm_suspend				|  ... ...
> |    scsi_runtime_suspend		|  ... ...
> |      blk_pre_runtime_suspend		|  ... ...
> |      return -EBUSY due to nr_pending	|  ... ...
> |  rpm_suspend done			|  ... ...
> |					|    blk_pm_put_request, mark last busy
> 
> But no more trigger point, and the device will stay at RPM_ACTIVE state.
> Run pm_runtime_autosuspend after the last request is finished solved
> this problem.

This doesn't look like the best solution, because it involves adding a 
nontrivial routine (pm_runtime_autosuspend) to a hot path.

How about this instead?  When blk_pre_runtime_suspend returns -EBUSY,
have it do a mark-last-busy.  Then rpm_suspend will automatically
reschedule the autosuspend for later.

> - Requests which have the REQ_PM flag should not involve nr_pending
>   counting, or we may lose the condition to resume the device:
>   Suppose queue is active and nr_pending is 0. Then a REQ_PM request
>   comes and nr_pending will be increased to 1, but since the request has
>   REQ_PM flag, it will not cause resume. Before it is finished, a normal
>   request comes in, and since nr_pending is 1 now, it will not trigger
>   the resume of the device either. Bug.
> 
> - Do not quiesce the device in scsi bus level runtime suspend callback.
>   Since the only reason the device is to be runtime suspended is due to
>   no more requests pending for it, quiesce it is pointless.
> 
> - Remove scsi_autopm_* from sd_check_events as we are request driven.
> 
> - Call blk_pm_runtime_init in scsi_sysfs_initialize_dev, so that we do
>   not need to check queue's device in blk_pm_add/put_request.

I think you still need to have that check.  After all, the block layer 
has other users besides the SCSI stack, and those users don't call 
blk_pm_runtime_init.

> - Do not mark last busy and initiate an autosuspend for the device in
>   blk_pm_runtime_init function.
> 
> - Do not mark last busy and initiate an autosuspend for the device in
>   block_post_runtime_resume, as when the request that triggered the
>   resume finished, the blk_pm_put_request will mark last busy and
>   initiate an autosuspend.

If you make the change that I recommended above then this is still 
necessary.

Alan Stern

