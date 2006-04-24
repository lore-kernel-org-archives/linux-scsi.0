From: Gustavo Guillermo =?iso-8859-1?q?P=E9rez?=
	<gustavo@compunauta.com>
Subject: SCSI trow USB-STORAGE or SBP2 Debug for buggy device Kernels 2.6.X
Date: Mon, 24 Apr 2006 10:29:14 -0500
Message-ID: <200604241029.14932.gustavo@compunauta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from compunauta.com ([69.36.170.169]:16780 "EHLO compunauta.com")
	by vger.kernel.org with ESMTP id S1750836AbWDXP3W convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Apr 2006 11:29:22 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org

Hello, list, I've tried to figure out why my external DVDRW Device has =
a=20
problem using UDF, SCSI subsystem reports "Device not ready" when burni=
ng=20
with growisofs, the media is being written perfect, no defective media =
or=20
sector errors ater burning. I've tried diferent DVDRW and I discover th=
at=20
only pioneer has this issue DVR106D /107D/108D/109D/110D (I have a lot =
of=20
them) but only trow usb-storage or sbp2 device converters I have this e=
rror,=20
and with this error UDF system show bad sectors, there is not bad secto=
rs,=20
and it happens only when writing big files about more than 1 or 2MB, no=
t=20
100Kbyte files or many small files, Then is cause I guess the drive nee=
d some=20
time to get ready again and I guess scsi system can resend the=20
command?!?!?!?.

Then going more far away, I see there is a black list on SCSI system,=20
scsi_devinfo.c that has a list of vendor and product identifications.
I've tried to add this line:
{"PIONEER", "DVD-RW  DVR-106D", NULL, BLIST_RETRY_HWERROR},

With no effects, Cause this error looks like not hardware error, is jus=
t not=20
ready.

Then I have an Idea, what happen if on scsi_lib.c where resides the fau=
lty=20
code:
if (!(req->flags & REQ_QUIET))
              dev_printk(KERN_INFO,
              &cmd->device->sdev_gendev,
              "Device not ready.\n");
              scsi_end_request(cmd, 0, this_count, 1);
              return;
I change scsi_end_request(cmd, 0, this_count, 1);
by a comparison about vendor ID and Model
and then if is a buggy one executes scsi_requeue_command(q, cmd); inste=
ad of=20
scsi_end_request(cmd, 0, this_count, 1);

Can I use this vars to deal only the same situation and not sata, nor u=
sb-card=20
reader, etc. etc.?!?!?!??!?!?!?!?
&cmd->device->vendor
&cmd->device->model
&cmd->pid
&cmd->sc_magic

How can I print it with prontk, I should use ?!?!?!
printk("Vendor: %s Model: %s Pid: %s Magic %s DevNotReady_Error\n",=20
        &cmd->device->vendor,=20
        &cmd->device->model,=20
        &cmd->pid,=20
        &cmd->sc_magic);

This device seems to require more patient to get ready...

this is my log USB-STORAGE generic adapter

Apr  3 18:13:30 g kernel: usb 4-1: new full speed USB device using ehci=
_hcd=20
and address 2
Apr  3 18:13:30 g kernel: scsi2 : SCSI emulation for USB Mass Storage d=
evices
Apr  3 18:13:35 g kernel:   Vendor: PIONEER   Model: DVD-RW  DVR-106D  =
Rev:=20
1.08
Apr  3 18:13:35 g kernel:   Type:   CD-ROM                             =
ANSI=20
SCSI revision: 00
Apr  3 18:13:35 g kernel: sr0: scsi3-mmc drive: 32x/32x writer cd/rw xa=
/form2=20
cdda tray
Apr  3 18:13:35 g scsi.agent[14695]: cdrom=20
at /devices/pci0000:00/0000:00:10.3/usb4/4-1/4-1:1.0/host2/target2:0:0/=
2:0:0:0
Apr  3 18:13:53 g kernel: cdrom: This disc doesn't have any tracks I=20
recognize!
Apr  3 18:14:42 g kernel: sr 2:0:0:0: Device not ready.
Apr  3 18:15:13 g last message repeated 21 times
Apr  3 18:16:14 g last message repeated 31 times
Apr  3 18:17:16 g last message repeated 31 times
Apr  3 18:18:17 g last message repeated 31 times
Apr  3 18:19:19 g last message repeated 31 times
Apr  3 18:20:20 g last message repeated 30 times
Apr  3 18:21:21 g last message repeated 28 times
Apr  3 18:22:22 g last message repeated 30 times
Apr  3 18:23:24 g last message repeated 31 times

diferent USB-STORAGE+ieee1394:
Apr  7 23:28:54 g kernel: sbp2: $Rev: 1306 $ Ben Collins <bcollins@debi=
an.org>
Apr  7 23:28:54 g kernel: scsi2 : SCSI emulation for IEEE-1394 SBP-2 De=
vices
Apr  7 23:28:55 g kernel: ieee1394: sbp2: Logged into SBP-2 device
Apr  7 23:28:55 g kernel:   Vendor: PIONEER   Model: DVD-RW  DVR-110D  =
Rev:=20
1.37
Apr  7 23:28:55 g kernel:   Type:   CD-ROM                             =
ANSI=20
SCSI revision: 00
Apr  7 23:28:55 g kernel: sr1: scsi3-mmc drive: 1x/351x xa/form2 tray
Apr  7 23:28:55 g scsi.agent[9237]: cdrom=20
at /devices/pci0000:00/0000:00:14.0/fw-host0/0050c50250004101/0050c5025=
0004101-0/h
Apr  7 23:28:56 g fstab-sync[9271]: added mount point /media/cdrom=20
for /dev/sr1
Apr  7 23:28:56 g kernel: cdrom: This disc doesn't have any tracks I=20
recognize!
Apr  7 23:32:11 g kernel: sr 2:0:0:0: Device not ready.
Apr  7 23:32:42 g last message repeated 290 times
Apr  7 23:33:45 g last message repeated 182 times
Apr  7 23:34:46 g last message repeated 92 times
Apr  7 23:35:47 g last message repeated 87 times
Apr  7 23:36:48 g last message repeated 103 times
Apr  7 23:37:50 g last message repeated 128 times
Apr  7 23:38:51 g last message repeated 140 times
Apr  7 23:39:52 g last message repeated 157 times
Apr  7 23:40:06 g last message repeated 65 times

SBP2 with another DVDR107
Oct 11 10:53:52 g kernel: sbp2: $Rev: 1219 $ Ben Collins <bcollins@debi=
an.org>
Oct 11 10:53:52 g kernel: scsi0 : SCSI emulation for IEEE-1394 SBP-2 De=
vices
Oct 11 10:53:52 g net.agent[8231]: add event not handled
Oct 11 10:53:53 g kernel: ieee1394: sbp2: Logged into SBP-2 device
Oct 11 10:53:53 g kernel:   Vendor: PIONEER   Model: DVD-RW  DVR-107D  =
Rev:=20
1.21
Oct 11 10:53:53 g kernel:   Type:   CD-ROM                             =
ANSI=20
SCSI revision: 02
Oct 11 10:53:53 g kernel: sr0: scsi3-mmc drive: 62x/62x writer cd/rw xa=
/form2=20
cdda tray
Oct 11 10:53:53 g scsi.agent[8285]: cdrom=20
at /devices/pci0000:00/0000:00:14.0/fw-host0/0050c50250004101/0050c5025=
0004101-0/h
Oct 11 10:56:21 g kernel: XFS mounting filesystem hda6
Oct 11 11:00:09 g kernel: Device sr0 not ready.
Oct 11 11:00:40 g last message repeated 145 times
Oct 11 11:01:41 g last message repeated 178 times
Oct 11 11:02:40 g last message repeated 174 times


any thougts?

--=20
Gustavo Guillermo P=E9rez
Compunauta uLinux
www.compunauta.com
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
