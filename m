From: Gustavo Guillermo =?utf-8?q?P=C3=A9rez?= <gustavo@compunauta.com>
Subject: Re: SCSI trow USB-STORAGE or SBP2 Debug for buggy device Kernels 2.6.X
Date: Mon, 24 Apr 2006 16:30:07 -0500
Message-ID: <200604241630.07453.gustavo@compunauta.com>
References: <200604241029.14932.gustavo@compunauta.com> <1145903888.3528.21.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from compunauta.com ([69.36.170.169]:63429 "EHLO compunauta.com")
	by vger.kernel.org with ESMTP id S1751313AbWDXVa1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Apr 2006 17:30:27 -0400
In-Reply-To: <1145903888.3528.21.camel@mulgrave.il.steeleye.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org

Ok, this is what I've got.

PLUGGING DEVICE
Apr 24 16:11:15 gusgus kernel: ehci_hcd 0000:00:10.4: EHCI Host Control=
ler
Apr 24 16:11:15 gusgus kernel: ehci_hcd 0000:00:10.4: new USB bus regis=
tered,=20
assigned bus number 7
Apr 24 16:11:15 gusgus kernel: ehci_hcd 0000:00:10.4: irq 20, io mem=20
0xe3005000
Apr 24 16:11:15 gusgus kernel: ehci_hcd 0000:00:10.4: USB 2.0 initializ=
ed,=20
EHCI 1.00, driver 10 Dec 2004
Apr 24 16:11:15 gusgus kernel: hub 7-0:1.0: USB hub found
Apr 24 16:11:15 gusgus kernel: hub 7-0:1.0: 8 ports detected
Apr 24 16:11:16 gusgus kernel: usb 7-1: new high speed USB device using=
=20
ehci_hcd and address 2
Apr 24 16:11:16 gusgus kernel: scsi1 : SCSI emulation for USB Mass Stor=
age=20
devices
Apr 24 16:11:16 gusgus kernel: usb 1-1: USB disconnect, address 2
Apr 24 16:11:21 gusgus kernel:   Vendor: PIONEER   Model: DVD-RW  DVR-1=
10D =20
Rev: 1.37
Apr 24 16:11:21 gusgus kernel:   Type:   CD-ROM                        =
    =20
ANSI SCSI revision: 00
Apr 24 16:11:21 gusgus kernel: sr0: scsi3-mmc drive: 62x/62x writer cd/=
rw=20
xa/form2 cdda tray
Apr 24 16:11:21 gusgus scsi.agent[8940]: cdrom=20
at /devices/pci0000:00/0000:00:10.4/usb7/7-1/7-1:1.0/host1/target1:0:0/=
1:0:0:0
Apr 24 16:12:14 gusgus kernel: sr 1:0:0:0: Device not ready: <6>: Curre=
nt:=20
sense key=3D0x2
Apr 24 16:12:14 gusgus kernel:     ASC=3D0x4 ASCQ=3D0x8
Apr 24 16:13:03 gusgus kernel: sr 1:0:0:0: Device not ready: <6>: Curre=
nt:=20
sense key=3D0x2
Apr 24 16:13:03 gusgus kernel:     ASC=3D0x4 ASCQ=3D0x8
Apr 24 16:13:03 gusgus kernel: sr 1:0:0:0: Device not ready: <6>: Curre=
nt:=20
sense key=3D0x2
THIS ABOVE MESSAGES REPEATED TOO MANY TIMES LIKE ALWAYS

This Other is cause I left the print outside the brackets, cause I want=
 to see=20
on closing session.

Apr 24 16:13:03 gusgus kernel:     ASC=3D0x4 ASCQ=3D0x8
Apr 24 16:13:10 gusgus kernel: : Current: sense key=3D0x2
Apr 24 16:13:10 gusgus kernel:     ASC=3D0x3a ASCQ=3D0x0
Apr 24 16:13:10 gusgus kernel: : Current: sense key=3D0x2
Apr 24 16:13:10 gusgus kernel:     ASC=3D0x3a ASCQ=3D0x0
Apr 24 16:13:10 gusgus kernel: : Current: sense key=3D0x2
Apr 24 16:13:10 gusgus kernel:     ASC=3D0x3a ASCQ=3D0x0
Apr 24 16:13:10 gusgus kernel: : Current: sense key=3D0x2
Apr 24 16:13:10 gusgus kernel:     ASC=3D0x3a ASCQ=3D0x0
Apr 24 16:13:10 gusgus kernel: : Current: sense key=3D0x2
Apr 24 16:13:10 gusgus kernel:     ASC=3D0x3a ASCQ=3D0x0
=46INISH WRITING

El Lunes, 24 de Abril de 2006 13:38, escribi=C3=B3:
> On Mon, 2006-04-24 at 10:29 -0500, Gustavo Guillermo P=C3=A9rez wrote=
:
> > Then I have an Idea, what happen if on scsi_lib.c where resides the
> > faulty code:
> > if (!(req->flags & REQ_QUIET))
> >               dev_printk(KERN_INFO,
> >               &cmd->device->sdev_gendev,
> >               "Device not ready.\n");
> >               scsi_end_request(cmd, 0, this_count, 1);
> >               return;
> > I change scsi_end_request(cmd, 0, this_count, 1);
> > by a comparison about vendor ID and Model
> > and then if is a buggy one executes scsi_requeue_command(q, cmd); i=
nstead
> > of scsi_end_request(cmd, 0, this_count, 1);
>
> Let's actually debug the problem before trying to fix it.  It would b=
e
> helpful to know what type of not-ready this is (and whether it's
> internally generated in usb or firewire, but that comes later).
>
> Try this addition and see what it tells us.
>
> James
>
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 7b0f9a3..cd9df1b 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1074,9 +1074,12 @@ void scsi_io_completion(struct scsi_cmnd
>  				scsi_requeue_command(q, cmd);
>  				return;
>  			}
> -			if (!(req->flags & REQ_QUIET))
> +			if (!(req->flags & REQ_QUIET)) {
>  				scmd_printk(KERN_INFO, cmd,
> -					   "Device not ready.\n");
> +					   "Device not ready: ");
> +				scsi_print_sense_hdr("", &sshdr);
> +			}
> +
>  			scsi_end_request(cmd, 0, this_count, 1);
>  			return;
>  		case VOLUME_OVERFLOW:

--=20
Gustavo Guillermo P=C3=A9rez
Compunauta uLinux
www.compunauta.com
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
