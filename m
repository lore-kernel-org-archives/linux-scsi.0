From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH RESEND v11 0/4] block layer runtime pm
Date: Sat, 23 Mar 2013 11:37:13 +0800
Message-ID: <514D2369.2010200@intel.com>
References: <1363338305-4987-1-git-send-email-aaron.lu@intel.com> <20130322150958.GK25978@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20130322150958.GK25978@kernel.dk>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>, Tejun Heo <tj@kernel.org>, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Shane Huang <shane.huang@amd.com>, Oliver Neukum <oneukum@suse.de>
List-Id: linux-scsi@vger.kernel.org

On 03/22/2013 11:09 PM, Jens Axboe wrote:
> On Fri, Mar 15 2013, Aaron Lu wrote:
>> In August 2010, Jens and Alan discussed about "Runtime PM and the block
>> layer". http://marc.info/?t=128259108400001&r=1&w=2
>> And then Alan has given a detailed implementation guide:
>> http://marc.info/?l=linux-scsi&m=133727953625963&w=2
>>
>> To test:
>> # ls -l /sys/block/sda
>> /sys/devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/0:0:0:0/block/sda
>>
>> # echo 10000 > /sys/devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/0:0:0:0/power/autosuspend_delay_ms
>> # echo auto > /sys/devices/pci0000:00/0000:00:1f.2/ata1/host0/target0:0:0/0:0:0:0/power/control
>> Then you'll see sda is suspended after 10secs idle.
>>
>> [ 1767.680192] sd 2:0:0:0: [sda] Synchronizing SCSI cache
>> [ 1767.680317] sd 2:0:0:0: [sda] Stopping disk
>>
>> And if you do some IO, it will resume immediately.
>> [ 1791.052438] sd 2:0:0:0: [sda] Starting disk
>>
>> For test, I often set the autosuspend time to 1 second. If you are using
>> a GUI, the 10 seconds delay may be too long that the disk can not enter
>> runtime suspended state.
>>
>> Note that sd's runtime suspend callback will dump some kernel messages
>> and the syslog daemon will write kernel message to /var/log/messages,
>> making the disk instantly resume after suspended. So for test, the
>> syslog daemon should better be temporarily stopped.
>>
>> A git repo for it, on top of v3.9-rc1:
>> https://github.com/aaronlu/linux.git blockpm
> 
> I think it's about time we get this in, but the patchset isn't very
> friendly from a scsi vs block perspective. Can you re-shuffle the REQ_PM
> change, just do a separate patch for that. I'll get it queued up for
> 3.10 then.

Thanks Jens.

I'll spilt the first patch into two patches: one to introduce the REQ_PM
flag in block layer and one to use that flag in SCSI layer. Will send
out v12 soon.

Best regards,
Aaron

