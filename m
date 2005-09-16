From: Jan Dittmer <jdittmer@ppp0.net>
Subject: Re: [linux-usb-devel] Re: 2.6.14-rc1 load average calculation broken?
Date: Fri, 16 Sep 2005 23:56:28 +0200
Message-ID: <432B3F8C.9050709@ppp0.net>
References: <Pine.LNX.4.44L0.0509161702480.5838-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.portrix.net ([212.202.157.208]:29845 "EHLO
	zoidberg.portrix.net") by vger.kernel.org with ESMTP
	id S1750703AbVIPV4q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Sep 2005 17:56:46 -0400
In-Reply-To: <Pine.LNX.4.44L0.0509161702480.5838-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mike Anderson <andmike@us.ibm.com>, James Bottomley <James.Bottomley@SteelEye.com>, Pavel Machek <pavel@suse.cz>, Greg KH <greg@kroah.com>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern wrote:
> On Fri, 16 Sep 2005, Mike Anderson wrote:
> 
> 
>>>This makes me suspect that the condition about host_busy == host_failed is 
>>>wrong.  Unfortunately I don't know why it's wrong or how to fix it.
>>>
>>>Perhaps somebody on the SCSI list can provide the answer.
>>>
>>
>>What condition are you thinking would happen if this was wrong (we are
>>getting woken up too early?)?
> 
> 
> Yes, that is what would happen.  Or failing to go back to sleep when we 
> should, which might be even worse.
> 
> 
>> I did a quick look and could not see changes
>>between 2.6.13 and 2.16.14-rc1 that would make these values wrong. This is
>>just a check to ensure the eh is not woken up to early. Historically in
>>older scsi eh code there used to be a panic if the error handler was woken
>>up to early. In scsi_unjam_host and a quick look at ata_scsi_error getting
>>woken up early should not cause a panic.
>>
>>I built a listfile (libata-scsi.lst) and it is probably not an exact
>>match. ..but..
>>
>>These lines in ata_scsi_error(..) appear to be close to the failure and
>>edx being zero as shown above in the oops would not be good.
>>	ap->ops->eng_timeout(ap);
>>	499:       8b 50 04                mov    0x4(%eax),%edx
>>	49c:       ff 52 48                call   *0x48(%edx)
>>
>>Since I do not know the libata code it is unclear from doing a short
>>search how an ops pointer could get altered or if my observations are
>>correct.
> 
> 
> Maybe the wakeup occurred before ap->ops was set correctly, or after it 
> was unset.  Jan, at what point did the oops happen?  Was it right after 
> the device was detected, during removal,or some other time?

On startup, loaded by hotplug, I don't have any devices on that bus.
CONFIG_SCSI_SATA_VIA=m

> 
> Can you put in some debugging printk's to see what values are in ap, 
> ap->ops, and ap->ops->eng_timeout?

Where exactly? Patch would be appreciated.
Is that what you mean (hand edited)?

--- linux-2.6/drivers/scsi/libata-scsi.c.backup 2005-09-16 23:52:21.000000000
+0200
+++ linux-2.6/drivers/scsi/libata-scsi.c        2005-09-16 23:52:29.000000000
+0200
@@ -387,7 +387,9 @@
        struct ata_port *ap;

        DPRINTK("ENTER\n");
        ap = (struct ata_port *) &host->hostdata[0];
+       printk("ap: %d %d %d\n", ap);
+       printk("ap->ops %d\n", ap->ops);
+       printk("ap->ops->eng_timeout %d\n", ap->ops->eng_timeout);
        ap->ops->eng_timeout(ap);


I'll reboot with these changes, we'll see.

-- 
Jan
