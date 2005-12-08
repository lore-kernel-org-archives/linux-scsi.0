From: Andrew de Quincey <adq_dvb@lidskialf.net>
Subject: Re: linux kernel panic when ejecting ieee1394 ipod
Date: Thu, 8 Dec 2005 02:09:17 +0000
Message-ID: <200512080209.17757.adq_dvb@lidskialf.net>
References: <200512072358.15398.adq_dvb@lidskialf.net> <200512080119.48740.adq@lidskialf.net> <200512080159.10913.adq_dvb@lidskialf.net>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_NX5lDp++UKOY3AZ"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lidskialf.net ([62.3.233.115]:4228 "EHLO mail.lidskialf.net")
	by vger.kernel.org with ESMTP id S932464AbVLHCJT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Dec 2005 21:09:19 -0500
In-Reply-To: <200512080159.10913.adq_dvb@lidskialf.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux1394-devel@lists.sourceforge.net
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-scsi@vger.kernel.org

--Boundary-00=_NX5lDp++UKOY3AZ
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday 08 December 2005 01:59, Andrew de Quincey wrote:
> On Thursday 08 December 2005 01:19, Andrew de Quincey wrote:
> > On Wednesday 07 December 2005 23:58, Andrew de Quincey wrote:
> > > Reposting to the -devel list since there was no response on -user.
> > >
> > > Hi, I'm using linux kernel 2.6.14 with an generation 1 ipod connected
> > > via ieee1394/sbp2.
> > >
> > > I can mount/unmount it and use it fine. It even works with HAL now.
> > >
> > > The problem comes when I want to remove it. If I do:
> > >
> > > eject /dev/sdb
> > >
> > > The kernel panics with the following error:
> > > Kernel panic - not syncing: PCI-DMA: high address but no IOMMU
> > >
> > > I'm using an nforce 4 motherboard (Asus A8N-SLI Deluxe). The ipod is
> > > attached to the ieee1394 port on a creative labs Audigy2 sound card
> > > (uses OHCI-1394).
> >
> > More info (I'm on an AMD64 in 64 bit mode BTW):
> >
> > eject sends a CDROMEJECT ioctl first of all. It is this IOCTL that kills
> > my system. If I hack/tell it to just use a "SCSI eject", it works and
> > actually makes my ipod show that tick thing showing it is safe to remove
> > it.
>
> Yet more info:
>
> eject -s sends the following SCSI packet command to the sbp/ipod device:
>
> 1b 00 00 00 02 00 with a direction of DMA_NONE
>
> eject -r results in the same via the CDROMEJECT translator in
> scsi_cmd_ioctl(), but with a direction of DMA_TO_DEVICE. Thats what crashes
> it - looks like its trying to set up a DMA transfer for 0 bytes or
> something. I just added a really horrible hack to the start of
> sbp2_send_command() to check, as follows:
>
>    if (*cmd == 0x1b) {
>       SCpnt->sc_data_direction = 3;
>    }
>
> Now, eject -r works perfectly. Though thats obviously not a good way to fix
> it :)

Possible "proper" patch attached - no idea if its a good way to do this. 
Basically if it gets a command with a scsi_request_bufflen of zero bytes, it 
forces dma_dir to DMA_NONE.

The ipod works perfectly with this now.

--Boundary-00=_NX5lDp++UKOY3AZ
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="possible-sbp2-eject-fix-1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="possible-sbp2-eject-fix-1.patch"

--- linux-2.6.14/drivers/ieee1394/sbp2.c	2005-12-08 02:05:27.000000000 +0000
+++ linux/drivers/ieee1394/sbp2.c	2005-12-08 02:06:18.000000000 +0000
@@ -1760,6 +1760,10 @@
 	command_orb->misc |= ORB_SET_SPEED(scsi_id->speed_code);
 	command_orb->misc |= ORB_SET_NOTIFY(1);		/* Notify us when complete */
 
+	/* check for duff DMA transfer direction with a zero length buffer */
+	if (scsi_request_bufflen == 0)
+		dma_dir = DMA_NONE;
+
 	/*
 	 * Get the direction of the transfer. If the direction is unknown, then use our
 	 * goofy table as a back-up.

--Boundary-00=_NX5lDp++UKOY3AZ--
