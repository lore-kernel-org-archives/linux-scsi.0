From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: [2.6.27.25] Hang in SCSI sync cache when a disk is removed--?
Date: Tue, 7 Jul 2009 13:45:07 -0700
Message-ID: <20090707204507.GA21213@linux.vnet.ibm.com>
References: <1246551772.9022.7192.camel@psmith-ubeta.netezza.com> <20090702174151.GA17414@linux.vnet.ibm.com> <1246903453.9022.7246.camel@psmith-ubeta.netezza.com> <20090707062543.GA2459@linux.vnet.ibm.com> <1246975126.4522.5.camel@mulgrave.site> <1246977232.14322.615.camel@homebase.localnet> <0D1E8821739E724A86F4D16902CE275C141A311654@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:33030 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755580AbZGGUp2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jul 2009 16:45:28 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e38.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n67KgC16000929
	for <linux-scsi@vger.kernel.org>; Tue, 7 Jul 2009 14:42:12 -0600
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n67Kj960044456
	for <linux-scsi@vger.kernel.org>; Tue, 7 Jul 2009 14:45:09 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n67Kj88W031708
	for <linux-scsi@vger.kernel.org>; Tue, 7 Jul 2009 14:45:09 -0600
Content-Disposition: inline
In-Reply-To: <0D1E8821739E724A86F4D16902CE275C141A311654@inbmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: "paul@mad-scientist.net" <paul@mad-scientist.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>, "Moore, Eric" <Eric.Moore@lsi.com>

Desai, Kashyap <Kashyap.Desai@lsi.com> wrote:
> Regarding Jame's comment I want to add some info.
> When we enter sd_remove() which tries to flush the
> cache with SYNCHRONIZE CACHE We are seeing system hung. In my guess, MPT driver is not even receiving command for synchronize cache. (If I refer back trace provided in first mail, scsi_dispatch_cmd() might not be called. Back trace suggests hang in scsi_get_command() just before scsi_dispatch_cmd() )
>  
> 
The SYNCHRONIZE CACHE is blocked by the host being in error recovery.
Since the SYNCHRONIZE CACHE is being driven off the mpt work queue it will
block the scsi error handler thread from completing as the
mptscsih_host_reset leads to calling flush_workqueue which leads to this
deadlock.

In my previous email I listed the lead up events. 

We start with blk_abort_queue scheduling error recovery (Issue previous reported). In theory the hang issue could occur in other error handler / device delete scenarios, but with much less probability. The Linux version also does not contain support for DID_TRANSPORT_DISRUPTED so this work around cannot be used.

The second issue is that we continue through progressive error handling
steps when we do not need to as we believe the device needs further error
recovery. Leading the host reset routine being called.

> Even if synchronize cache command reaches to mptsas, mptsas will return with DID_NO_CONNECT since hostdata is no more valid. 
> Here is snippet of mptsas code.
> 
> ------------------------------------------------------
> mptsas_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
> {
>         VirtDevice      *vdevice = SCpnt->device->hostdata;
>  
>         if (!vdevice || !vdevice->vtarget || vdevice->vtarget->deleted) {
>                 SCpnt->result = DID_NO_CONNECT << 16;
>                 done(SCpnt);
>                 return 0;
>         }
> ------------------------------------------------------
> Thanks,
> Kashyap
> 
> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Paul Smith
> Sent: Tuesday, July 07, 2009 8:04 PM
> To: James Bottomley
> Cc: Mike Anderson; linux-scsi@vger.kernel.org; Mike Christie; Moore, Eric
> Subject: Re: [2.6.27.25] Hang in SCSI sync cache when a disk is removed--?
> 
> Hi James; thanks for that examination; it's very helpful.
> 
> Unfortunately Eric is on vacation until the middle of the month and we
> really need to resolve this issue this week if possible.  I'm forwarding
> your message to the LSI developers we've been working with.
> 
> MikeA: we're working on getting the sysrq "t" output in the meantime,
> just in case it's revealing.
> 
> On Tue, 2009-07-07 at 08:58 -0500, James Bottomley wrote:
> > On Mon, 2009-07-06 at 23:25 -0700, Mike Anderson wrote:
> > > Paul Smith <paul@mad-scientist.net> wrote:
> > > > 
> > > 
> > > I was expecting a little more output from the error handler thread, but
> > > the log does show a few things.
> > > 
> > > It would be good if in the failing case you could provide a sysrq "t"
> > > output so I could understand where the reset handler is waiting.
> > > 
> > > It appears there are a few things going on.
> > > 1.) The dm deactivate calling blk_abort_queue is leading to error handler
> > > activation. Similar to a previously described issue.
> > > http://permalink.gmane.org/gmane.linux.kernel.device-mapper.devel/8543
> > > 	- This kernel does not have DID_TRANSPORT_DISRUPTED so that
> > > 	  avoidance method cannot be used.
> > > 2.) The task aborts are completing, but the tur is most likely being
> > > failed with a response of DID_BUS_BUSY leading to continued recovery.
> > > 3.) We appear to be inside mpt_HardResetHandler, but need more info to
> > > understand where in the call chain.
> > 
> > Actually, isn't the problem much simpler?
> > 
> > The mptsas driver calls sas_port_delete() when the event occurs.  This
> > deletes the rphy and invokes scsi_remove_target().  It looks like the
> > device had a write back cache, so part of scsi_remove_target() goes to
> > scsi_remove_device() which triggers sd_remove() which tries to flush the
> > cache with SYNCHRONIZE CACHE.
> > 
> > This is the point at which the hang occurs.  It seems that the mptsas
> > goes out to lunch when it sees a command to a device on a deleted port.
> > The remainder of the log is error handling trying to get the attention
> > of the mptsas firmware back again.
> > 
> > This is a pretty huge problem because any set of commands can be racing
> > with surprise ejection ... there's no way we can gate it in the mid
> > layer.  The behaviour we expect is that after surprise ejection, a
> > driver/device will automatically error (with something like
> > DID_NO_CONNECT) all commands for the ejected device.
> > 
> > James
> > 
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
