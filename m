From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/3] Unblock SCSI devices even if the LLD is being
 unloaded
Date: Sat, 18 Mar 2017 07:44:59 -0500
Message-ID: <1489841099.2917.3.camel@HansenPartnership.com>
References: <20170316205650.3322-1-bart.vanassche@sandisk.com>
         <1489704797.4650.8.camel@HansenPartnership.com>
         <1489706379.2574.24.camel@sandisk.com>
         <1489755268.2373.11.camel@HansenPartnership.com>
         <1489768812.2826.2.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:46174 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751397AbdCRNmD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 18 Mar 2017 09:42:03 -0400
In-Reply-To: <1489768812.2826.2.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "maxg@mellanox.com" <maxg@mellanox.com>, "israelr@mellanox.com" <israelr@mellanox.com>, "hare@suse.de" <hare@suse.de>

On Fri, 2017-03-17 at 16:40 +0000, Bart Van Assche wrote:
> On Fri, 2017-03-17 at 05:54 -0700, James Bottomley wrote:
> > So it's better to use the module without a reference in place and 
> > take the risk that it may exit and release its code area while 
> > we're calling it?
> 
> Hello James,
> 
> My understanding of scsi_device_get() / scsi_device_put() is that the 
> reason why these manipulate the module reference count is to avoid 
> that a SCSI LLD module can be unloaded while a SCSI device is being 
> used from a context that is not notified about SCSI LLD unloading 
> (e.g. a file handle controlled by the sd driver or a SCSI ALUA device
> handler worker thread).

Not just that: it's so the underlying module is pinned for every
potential user as well.  the unblock code is called in places outside
the actual hba driver module, so it needs that protection.

> Does your comment mean that you think there is a scenario in which
> scsi_target_block() or scsi_target_unblock() can be called while the 
> text area of a SCSI LLD is being released? I have reviewed all the 
> callers of these functions but I have not found such a scenario.
> scsi_target_block() and scsi_target_unblock() are either called from 
> a SCSI transport layer implementation (FC, iSCSI, SRP) or from a SCSI 
> LLD kernel module (snic_disc). All these kernel modules only call 
> scsi_target_*block() for resources (rport or SCSI target
> respectively) that are removed before the code area of
> these modules is released. This is why I think that calling
> scsi_target_*block() without increasing the SCSI LLD module reference
> count is safe.

The transport code is above the HBA module code and in that code
unblock could be racing with module removal.  The original premise was
that once the dev/target/host goes into DEL, nothing can call into
queuecommand or get a reference to the device, so nothing halts removal
after that, but you changed that with your code, which is why it's now
unsafe.

> > diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> > index 82dfe07..fd1ba1d 100644
> > --- a/drivers/scsi/scsi_sysfs.c
> > +++ b/drivers/scsi/scsi_sysfs.c
> > @@ -39,6 +39,7 @@ static const struct {
> >  	{ SDEV_TRANSPORT_OFFLINE, "transport-offline" },
> >  	{ SDEV_BLOCK,	"blocked" },
> >  	{ SDEV_CREATED_BLOCK, "created-blocked" },
> > +	{ SDEV_CANCEL_BLOCK, "blocked" },
> >  };
> 
> The multipathd function path_offline() translates "blocked" into 
> PATH_PENDING. Shouldn't SDEV_CANCEL_BLOCK be translated by multipathd 
> into PATH_DOWN? There might be other user space applications that 
> interpret the SCSI device state and that I am not aware of.

Given it's very short lived, I don't think it much matters, but if you
think it does, that can become cancel.

> Additionally, your patch does not modify scsi_device_get() and hence
> will cause scsi_device_get() to succeed for devices that are in state
> SDEV_CANCEL_BLOCK. I think that's a subtle behavior change.

Yes, otherwise device unblock wouldn't work (on the off chance the
device is unblocked before we get to the sync cache).  Again, it's like
the open race: you could have got the reference just before the device
went into cancel and you're in the same position so there's actually no
substantive behaviour change at all, it just elongates the window where
you get a reference to a device you can't send commands to.

James


> Thanks,
> 
> Bart.
