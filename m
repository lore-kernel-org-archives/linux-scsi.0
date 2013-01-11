From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v12 7/9] libata: scsi: no poll when ODD is powered off
Date: Fri, 11 Jan 2013 10:44:57 -0800
Message-ID: <20130111184457.GQ20454@htj.dyndns.org>
References: <1357809870-18816-1-git-send-email-aaron.lu@intel.com>
 <1357809870-18816-8-git-send-email-aaron.lu@intel.com>
 <20130110195610.GL20454@htj.dyndns.org>
 <20130111021110.GB26270@aaronlu.sh.intel.com>
 <20130111021701.GA2513@mtj.dyndns.org>
 <20130111031626.GA26613@aaronlu.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130111031626.GA26613@aaronlu.sh.intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello,

On Fri, Jan 11, 2013 at 11:16:26AM +0800, Aaron Lu wrote:
> OK, will make it atomic in next version, thanks for the advice.
> 
> Perhaps I can add two scsi helper functions in scsi_lib.c like:
> 
> void sdev_disable_disk_events(struct scsi_device *sdev)
> {
> 	atomic_inc(&sdev->disk_events_disable_depth);
> }
> 
> void sdev_enable_disk_events(struct scsi_device *sdev)
> {
> 	if (WARN_ON_ONCE(atomic_read(&sdev->disk_events_disable_depth) <= 0))
> 		return;
> 	atomic_dec(&sdev->disk_events_disable_depth);
> }
> 
> And call them in ATA layer. Do you like this?

Sounds good to me.  James, how does the series look to you?

Thanks!

-- 
tejun
