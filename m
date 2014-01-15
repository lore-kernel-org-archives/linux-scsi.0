From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: Suspend issues with a LaCie USB hard disk connected
Date: Wed, 15 Jan 2014 12:19:14 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1401151215420.1587-100000@iolanthe.rowland.org>
References: <52D669EF.30405@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52D669EF.30405-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Mack <zonque-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Oliver Neukum <oliver-GvhC2dPhHPQdnm+yROfE0A@public.gmane.org>, Aaron Lu <aaron.lu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "James E.J. Bottomley" <JBottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sven Neumann <s.neumann-5g8ninUHluJWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 15 Jan 2014, Daniel Mack wrote:

> Hi,
> 
> Sorry for the long, primarily holiday-related delay on this.
> 
> On 12/18/2013 09:46 PM, Alan Stern wrote:
> > On Wed, 18 Dec 2013, Daniel Mack wrote:
> >> I'm facing an issue putting an embedded system to sleep while a Lacie
> >> external USB hard disk is connected. Relevant kernel messages that occur
> >> at the attempt are:
> >>
> >> [   13.834731] PM: Sending message for entering DeepSleep mode
> >> [   13.846575] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> >> [   13.858818] sd 0:0:0:0: [sda]
> >> [   13.862432] Result: hostbyte=0x00 driverbyte=0x08
> >> [   13.867349] sd 0:0:0:0: [sda]
> >> [   13.870626] Sense Key : 0x5 [current]
> >> [   13.874602] sd 0:0:0:0: [sda]
> >> [   13.877879] ASC=0x20 ASCQ=0x0
> >> [   13.885053] dpm_run_callback(): scsi_bus_suspend+0x0/0x20 returns -5
> >> [   13.901130] PM: Device 0:0:0:0 failed to suspend async: error -5
> >> [   13.907507] PM: Some devices failed to suspend, or early wake event
> >> detected
> >>
> >> What happens is that in sd_sync_cache(), scsi_execute_req_flags()
> >> returns 0x08000002, so driver_byte(res) evaluates to DRIVER_SENSE and
> >> host_byte(res) is DID_OK, which is an unhandled case that leads to -EIO
> >> eventually.
> >>
> >> I have admittedly not much clue about the SCSI layer, so I wonder what
> >> would be the best way to fix this. Should DID_OK just be handled as
> >> non-error condition in the switch? Should the suspend call chain ignore
> >> such errors from sd_sync_cache()?
> >>
> >> I'm open to suggestions and happy to test patches.
> > 
> > The Sense Key and ASC values indicate that the drive did not understand
> > the SYNCHRONIZE CACHE command.  A usbmon trace would verify this; see
> > the instructions in Documentation/usb/usbmon.txt.
> > 
> > Assuming that really is what happened, we have to decide how to handle 
> > the situation.
> 
> Ok, this is the usbmon trace that I captured when the system goes to
> suspend with the USB storage media connected but unmounted:
> 
> cebe5e00 3629314504 S Bo:1:003:2 -115 31 = 55534243 10000000 00000000
> 00000a35 00000000 00000000 00000000 000000
> cebe5e00 3629315214 C Bo:1:003:2 0 31 >
> cebe5e00 3629315413 S Bi:1:003:1 -115 13 <
> cebe5e00 3629315492 C Bi:1:003:1 0 13 = 55534253 10000000 00000000 01

That's the SYNCHRONIZE CACHE command, with an error return status.

> cebe5e00 3629315571 S Bo:1:003:2 -115 31 = 55534243 11000000 12000000
> 80000603 00000012 00000000 00000000 000000
> cebe5e00 3629315606 C Bo:1:003:2 0 31 >
> cecd4580 3629315681 S Bi:1:003:1 -115 18 <
> cecd4580 3629315744 C Bi:1:003:1 0 18 = 70000500 0000000a 00000000
> 20000000 0000
> cebe5e00 3629315772 S Bi:1:003:1 -115 13 <
> cebe5e00 3629315817 C Bi:1:003:1 0 13 = 55534253 11000000 00000000 00

And that's the sense data, confirming SK=5 and ASC=20.  This means the 
drive doesn't understand the command.

There's more stuff later on in the usbmon trace that I don't 
understand.  But if everything else works okay, it won't matter.

> FWIW, the following patch seems to work fine on our machines, but as I
> said, I'm uncertain wrt to whether that's the right approach.
> 
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 69725f7..ec99787 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1469,6 +1469,7 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
>                                 return 0;
> 
>                 switch (host_byte(res)) {
> +               case DID_OK:
>                 /* ignore errors due to racing a disconnection */
>                 case DID_BAD_TARGET:
>                 case DID_NO_CONNECT:

I don't think that is the right thing to do.  Try this patch instead.

Alan Stern



Index: usb-3.13/drivers/scsi/sd.c
===================================================================
--- usb-3.13.orig/drivers/scsi/sd.c
+++ usb-3.13/drivers/scsi/sd.c
@@ -1463,8 +1463,8 @@ static int sd_sync_cache(struct scsi_dis
 			sd_print_sense_hdr(sdkp, &sshdr);
 		/* we need to evaluate the error return  */
 		if (scsi_sense_valid(&sshdr) &&
-			/* 0x3a is medium not present */
-			sshdr.asc == 0x3a)
+			(sshdr.asc == 0x3a ||	/* medium not present */
+			 sshdr.asc == 0x20))	/* invalid command */
 				/* this is no error here */
 				return 0;
 

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
