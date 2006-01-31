From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH] add SPI transport class to fusion
Date: Mon, 30 Jan 2006 19:18:28 -0600
Message-ID: <1138670309.3283.54.camel@mulgrave>
References: <F331B95B72AFFB4B87467BE1C8E9CF5F22140C@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:45747 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S965057AbWAaBSn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Jan 2006 20:18:43 -0500
In-Reply-To: <F331B95B72AFFB4B87467BE1C8E9CF5F22140C@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, hch@lst.de

On Mon, 2006-01-30 at 17:48 -0700, Moore, Eric wrote:
> I'm not sure what is getting broke when these GEM workarounds are being
> removed.  These hacks were added by someone else.  

What they do is force the negotiation to narrow asynchronous for all
processor devices (and, in fact for every type above medum changer),
which is a bit drastic---actually it will probably drastically limit IP
over SCSI if anyone is still doing that because the HBA's appear as type
processor.

If we can get the inquiry strings of this GEM device, we can blacklist
only it (presumably it lies about its capabilities in its inquiry page
and then goes out to lunch when people try to negotiate with it).

> > +	if (sdev->channel) {
> > +		VirtDevice *vdev = sdev->hostdata;
> > +		sdev->no_uld_attach = 1;
> > +		vdev->vtarget->tflags |=
> MPT_TARGET_FLAGS_RAID_COMPONENT;
> > +		/* The real channel for this device is zero */
> > +		vdev->bus_id = 0;
> > +	}
> 
> Id rather we being creating a virtual channel for the RAID volumes on
> channel=1, and leave the hidden disks on channel=0 along with all other
> real devices.   That is what we are doing in mptsas.c, and I would like
> to keep similar logic so we are not confusing the customer where the
> raid
> volumes are located.

I'd love to do this ... unfortunately, that will change the existing
numbering for RAID arrays (for instance, my current IM raid is 6:0:0:0,
if I follow this it would now become 6:1:0:0, which wouldn't be the same
as the fusion bios).

>   For instance, the 1068 has upto 8 ports, so we
> put the virtual channel out on channel=8.   I'm not sure how the
> sdev->no_uld_attach flag works, e.g my concern is whether this flag
> would work when we mix real exposed devices and hidden disk on 
> the same channel? If that works, would it be possible for you to change
> this?

The gating problem is that we have to have unique numbers for H:C:T:L
regardless of the flag and the fusion bios seems happy to have a logical
device and a physical device on the same number.  If the bios would
assign non overlapping target id's then we'd be fine with a mixture of
hidden and exposed devices on one channel, but as it doesn't there has
to be an artificial way of differentiating them.

> > +static int
> > +mptscsih_quiesce_raid(MPT_SCSI_HOST *hd, int quiesce, int disk)
>  
> I would like all the raid related functions, such as this one,
> and mptspi_get_resyn, mptspi_get_state, and mptspi_is_raid moved
> out of the mptspi driver, and over into a generic api, such as inside
> mptscsih.c.  These same functions will be needed for SAS RAID Transport
> Class, and I don't what to have to replicate the code over there in
> mptsas.c

Yes, that's fine ... the RAID patch actually removes this in favour of a
more generic raid event API, anyway.

> >  		/* 4. Renegotiate to all devices, if SPI
> >  		 */
> > -		if (ioc->bus_type == SPI) {
> > -			dnegoprintk(("writeSDP1: ALL_IDS USE_NVRAM\n"));
> > -			mptscsih_writeSDP1(hd, 0, 0, MPT_SCSICFG_ALL_IDS
> | MPT_SCSICFG_USE_NVRAM);
> > -		}
> 
> We  can't be removed !!!!  
> If you do host_reset - via eh_threads or IOCTL = MPTHARDRESET, 
> all the devices will go to asyn-narrow.  The
> negotiation parameters need to be updated.   My suggestion is we can
> hook
> the reset handler chain from mptspi. This is done by over riding the 
> mpt_reset_register() call with local function.  Then from it during 
> the correct "reset phase", call mptspi_dv_device.

Yes, that's more or less what the 53c700 driver does.

> > -	pScsiReq->Function = MPI_FUNCTION_SCSI_IO_REQUEST;
> > +	if (vdev->vtarget->tflags &  MPT_TARGET_FLAGS_RAID_COMPONENT)
> > +		pScsiReq->Function = >
> MPI_FUNCTION_RAID_SCSI_IO_PASSTHROUGH;
> > +	else
> > +		pScsiReq->Function = MPI_FUNCTION_SCSI_IO_REQUEST;
> >  	pScsiReq->CDBLength = SCpnt->cmd_len;
> 
> YOur only queise io when commands are issued in the context of
> mptspi_dv_device,
> meaning  mptscsih_quiese_raid() is called over there.
> But what about someone opening a /dev/sg0 handle, and sending data
> across?  Do you think
> we should be queuiese io for all io doing RAID_PASSTHRU from
> queue_command entry point,
> instead of only handling the dv case.  But what about the performance
> hit of loading
> driver when dv is going on.  Any thoughts on this?

Yes ... it's the job of whoever is issuing passthrough I/O to ensure the
RAID is quiesced (if they need it ... there are plenty of commands that
could be usefully executed even with the RAID running), so really, we
only need it for the DV because additional I/O could interfere with
that.

> 
> > -	/* F/W not running */
> > -	if(!CHIPREG_READ32(&ioc->chip->Doorbell)) {
> > -		/* enable domain validation flags */
> > -		for (ii=0; ii < MPT_MAX_SCSI_DEVICES; ii++) {
> > -			ioc->spi_data.dvStatus[ii] |= 
> > MPT_SCSICFG_NEED_DV;
> > -		}
> > -	}
> 
> You have deleted the code in mpt_resume() that issues domain validation.
> Are you handling power managment from transport layer?  There is no
> gareentee
> that device were removed and added during standby/hybernation, thus
> what happens when initiator is running packatized, and the device having
> power cut off is running non-packatized?

OK ... that's a consequence of the code transforming to nothing.  It
probably needs to be resurrected as a spi_schedule_dv() call.

> Attached is a patch that apply over your patch.  What this does it addes
> the SAS and misc fix' patches that were missed from two weeks back. I
> also:
> (1) deleted the spi performance bug code "mpt_bringup_adapter", which is
> not 
> need for generic dv
> (2) changed the RAID events to KERN_DEBUG, as you requested earlier
> today.
> 
> James: I would like to get this pushed thru this time. Your help is
> greatly appriecated.

OK, give me a while to look over it.

James


