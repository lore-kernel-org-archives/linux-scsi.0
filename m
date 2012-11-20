From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v9 06/10] ata: zpodd: check zero power ready status
Date: Tue, 20 Nov 2012 16:59:57 +0800
Message-ID: <50AB468D.1060902@intel.com>
References: <1352443922-13734-1-git-send-email-aaron.lu@intel.com> <1352443922-13734-7-git-send-email-aaron.lu@intel.com> <20121112191303.GE5560@mtj.dyndns.org> <50A2FF6F.3080603@intel.com> <20121118150004.GJ7306@mtj.dyndns.org> <50A9A2F4.3020006@intel.com> <20121119145605.GC15971@htj.dyndns.org> <50AB1C78.9060905@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:16893 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752556Ab2KTI7p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Nov 2012 03:59:45 -0500
In-Reply-To: <50AB1C78.9060905@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org

On 11/20/2012 02:00 PM, Aaron Lu wrote:
> On 11/19/2012 10:56 PM, Tejun Heo wrote:
>> I really think we need a way for (auto)pm and event polling to talk to
>> each other so that autopm can tell event poll to sod off while pm is
>> in effect.  Trying to solve this from inside libata doesn't seem
>> right.  The problem, again, seems to be figuring out which hardware
>> device maps to which block device.  Hmmm... Any good ideas?
> 
> A possible way of doing this is using pm qos.
> 
> We currently have 2 pm qos flags, NO_POWER_OFF and REMOTE_WAKEUP, and we
> can add another one: NO_POLL, use it like the following:
> 1 Set the NO_POLL pm qos flag when the underlying driver thinks it is no
>   longer necessary. In the ZPODD's case, it should be set when the
>   device is to be powered off;
> 2 Clear it when poll is necessary again. In the ZPODD's case, when power
>   is re-gained, this flag will be cleared.


> 3 In the disk_events_workfn, check if this flag is set, if so, simply
>   return.

It should be, skip calling disk->fops->check_events, but still queue the
work for next time's poll.

-Aaron

> 
> The disk->driverfs_dev can be used to host the pm qos flag, ATA layer
> can access it through ata_device->sdev->sdev_gendev.
> 
> Is this OK?
> 
> Thanks,
> Aaron
> 

