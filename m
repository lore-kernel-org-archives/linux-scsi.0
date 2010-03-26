From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Fri, 26 Mar 2010 11:40:21 -0700
Message-ID: <20100326184021.GA4350@xanatos>
References: <4BA9D74F.9040507@gmail.com>
 <4BA7797F.8060605@gmail.com>
 <20100324155917.GA4382@xanatos>
 <59ca64281003241107x40c5d83co29d1ee03d8d3a0d1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga10.intel.com ([192.55.52.92]:49868 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753542Ab0CZSkY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Mar 2010 14:40:24 -0400
Content-Disposition: inline
In-Reply-To: <59ca64281003241107x40c5d83co29d1ee03d8d3a0d1@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jonas Schwertfeger <jschwertfeger@gmail.com>
Cc: linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org

On Wed, Mar 24, 2010 at 07:07:58PM +0100, Jonas Schwertfeger wrote:
> On Wed, Mar 24, 2010 at 4:59 PM, Sarah Sharp
> <sarah.a.sharp@linux.intel.com> wrote:
> > Despite the fact that this device probably won't work for 2.6.31 or
> > 2.6.32, the xHCI driver shouldn't be hanging the system. =A0The res=
et
> > device API probably shouldn't be back ported to those kernels, but =
I can
> > allow the USB core to disable the device's port instead.
>=20
> In 2.6.31 the drive would show up as /dev/sdb and be mountable. The
> system froze when I mounted it and then tried to partition it. In
> 2.6.32 however the drive does not even show up in /dev/. Thus, I
> cannot reproduce a system hang here.

Hmm, ok, I would rather figure out why 2.6.31 is hanging, since 2.6.32
does not.  Can you compile the latest 2.6.31 stable tree and use
netconsole to capture the crash with CONFIG_USB_XHCI_HCD_DEBUGGING and
CONFIG_USB_STORAGE_DEBUG turned on?  (I assume you know how to use
netconsole, but if you don't, I've posted how I setup netconsole at
http://sarah.thesharps.us/2010-03-26-09-41)

> I configured USB storage debugging and attached another log file. If
> there is not enough information in it let me know I will proceed with
> Alan's suggestion of using usbmon.

I think the amount of information is fine, but I'm not sure why the
device would respond with a stall to this particular command, so I'm
CC'ing the USB storage list and SCSI list.  Does anyone know what the
third command is?  The USB storage driver reports it as an "unknown
command".  I can see from scsi.h that 0x85 is the code for ATA_16, but
I'm not sure what that command actually does.

Mar 24 18:53:36 js-workstation kernel: [  253.403792] usb-storage: Comm=
and BLANK (12 bytes)
Mar 24 18:53:36 js-workstation kernel: [  253.403794] usb-storage:  a1 =
08 2e 00 01 00 00 00 00 ec 00 00
Mar 24 18:53:36 js-workstation kernel: [  253.403800] usb-storage: Bulk=
 Command S 0x43425355 T 0x2d L 512 F 128 Trg 0 LUN 0 CL 12
Mar 24 18:53:36 js-workstation kernel: [  253.403802] usb-storage: usb_=
stor_bulk_transfer_buf: xfer 31 bytes
Mar 24 18:53:36 js-workstation kernel: [  253.403969] usb-storage: Stat=
us code 0; transferred 31/31
Mar 24 18:53:36 js-workstation kernel: [  253.403972] usb-storage: -- t=
ransfer complete
Mar 24 18:53:36 js-workstation kernel: [  253.403973] usb-storage: Bulk=
 command transfer result=3D0
Mar 24 18:53:36 js-workstation kernel: [  253.403975] usb-storage: usb_=
stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Mar 24 18:53:36 js-workstation kernel: [  253.409708] usb-storage: Stat=
us code 0; transferred 512/512
Mar 24 18:53:36 js-workstation kernel: [  253.409709] usb-storage: -- t=
ransfer complete
Mar 24 18:53:36 js-workstation kernel: [  253.409710] usb-storage: Bulk=
 data transfer result 0x0
Mar 24 18:53:36 js-workstation kernel: [  253.409711] usb-storage: Atte=
mpting to get CSW...
Mar 24 18:53:36 js-workstation kernel: [  253.409712] usb-storage: usb_=
stor_bulk_transfer_buf: xfer 13 bytes
Mar 24 18:53:36 js-workstation kernel: [  253.409854] usb-storage: Stat=
us code 0; transferred 13/13
Mar 24 18:53:36 js-workstation kernel: [  253.409855] usb-storage: -- t=
ransfer complete
Mar 24 18:53:36 js-workstation kernel: [  253.409856] usb-storage: Bulk=
 status result =3D 0
Mar 24 18:53:36 js-workstation kernel: [  253.409858] usb-storage: Bulk=
 Status S 0x53425355 T 0x2d R 0 Stat 0x0
Mar 24 18:53:36 js-workstation kernel: [  253.409859] usb-storage: scsi=
 cmd done, result=3D0x0
Mar 24 18:53:36 js-workstation kernel: [  253.409861] usb-storage: *** =
thread sleeping.
Mar 24 18:53:36 js-workstation kernel: [  253.413870] usb-storage: queu=
ecommand called
Mar 24 18:53:36 js-workstation kernel: [  253.413874] usb-storage: *** =
thread awakened.

Mar 24 18:53:36 js-workstation kernel: [  253.413876] usb-storage: Comm=
and (unknown command) (16 bytes)
Mar 24 18:53:36 js-workstation kernel: [  253.413877] usb-storage:  85 =
06 20 00 05 00 fe 00 00 00 00 00 00 40 ef 00
Mar 24 18:53:36 js-workstation kernel: [  253.413882] usb-storage: Bulk=
 Command S 0x43425355 T 0x2e L 0 F 0 Trg 0 LUN 0 CL 16
Mar 24 18:53:36 js-workstation kernel: [  253.414229] usb-storage: Bulk=
 Command S 0x43425355 T 0x2f L 512 F 128 Trg 0 LUN 0 CL 16
Mar 24 18:53:36 js-workstation kernel: [  253.413883] usb-storage: usb_=
stor_bulk_transfer_buf: xfer 31 bytes
Mar 24 18:53:36 js-workstation kernel: [  253.414031] usb-storage: Stat=
us code 0; transferred 31/31
Mar 24 18:53:36 js-workstation kernel: [  253.414032] usb-storage: -- t=
ransfer complete
Mar 24 18:53:36 js-workstation kernel: [  253.414033] usb-storage: Bulk=
 command transfer result=3D0
Mar 24 18:53:36 js-workstation kernel: [  253.414034] usb-storage: Atte=
mpting to get CSW...
Mar 24 18:53:36 js-workstation kernel: [  253.414035] usb-storage: usb_=
stor_bulk_transfer_buf: xfer 13 bytes
Mar 24 18:53:36 js-workstation kernel: [  253.414179] usb-storage: Stat=
us code 0; transferred 13/13
Mar 24 18:53:36 js-workstation kernel: [  253.414180] usb-storage: -- t=
ransfer complete
Mar 24 18:53:36 js-workstation kernel: [  253.414181] usb-storage: Bulk=
 status result =3D 0
Mar 24 18:53:36 js-workstation kernel: [  253.414182] usb-storage: Bulk=
 Status S 0x53425355 T 0x2e R 0 Stat 0x0
Mar 24 18:53:36 js-workstation kernel: [  253.414183] usb-storage: scsi=
 cmd done, result=3D0x0
Mar 24 18:53:36 js-workstation kernel: [  253.414186] usb-storage: *** =
thread sleeping.
Mar 24 18:53:36 js-workstation kernel: [  253.414217] usb-storage: queu=
ecommand called
Mar 24 18:53:36 js-workstation kernel: [  253.414222] usb-storage: *** =
thread awakened.

Mar 24 18:53:36 js-workstation kernel: [  253.414223] usb-storage: Comm=
and (unknown command) (16 bytes)
Mar 24 18:53:36 js-workstation kernel: [  253.414224] usb-storage:  85 =
08 2e 00 00 00 00 00 00 00 00 00 00 40 ec 00
Mar 24 18:53:36 js-workstation kernel: [  253.414229] usb-storage: Bulk=
 Command S 0x43425355 T 0x2f L 512 F 128 Trg 0 LUN 0 CL 16
Mar 24 18:53:36 js-workstation kernel: [  253.414230] usb-storage: usb_=
stor_bulk_transfer_buf: xfer 31 bytes
Mar 24 18:53:36 js-workstation kernel: [  253.414378] usb-storage: Stat=
us code 0; transferred 31/31
Mar 24 18:53:36 js-workstation kernel: [  253.414379] usb-storage: -- t=
ransfer complete
Mar 24 18:53:36 js-workstation kernel: [  253.414380] usb-storage: Bulk=
 command transfer result=3D0
Mar 24 18:53:36 js-workstation kernel: [  253.414381] usb-storage: usb_=
stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Mar 24 18:53:36 js-workstation kernel: [  253.414458] xhci_hcd 0000:03:=
00.0: WARN: Stalled endpoint
Mar 24 18:53:36 js-workstation kernel: [  253.414529] usb-storage: Stat=
us code -32; transferred 0/512
Mar 24 18:53:36 js-workstation kernel: [  253.414530] usb-storage: clea=
ring endpoint halt for pipe 0xc0008280
Mar 24 18:53:36 js-workstation kernel: [  253.414532] usb-storage: usb_=
stor_control_msg: rq=3D01 rqtype=3D02 value=3D0000 index=3D81 len=3D0
Mar 24 18:53:36 js-workstation kernel: [  253.414894] usb-storage: usb_=
stor_clear_halt: result =3D 0
Mar 24 18:53:36 js-workstation kernel: [  253.414895] usb-storage: Bulk=
 data transfer result 0x2
Mar 24 18:53:36 js-workstation kernel: [  253.414896] usb-storage: Atte=
mpting to get CSW...
Mar 24 18:53:36 js-workstation kernel: [  253.414897] usb-storage: usb_=
stor_bulk_transfer_buf: xfer 13 bytes
Mar 24 18:53:36 js-workstation kernel: [  253.414902] xhci_hcd 0000:03:=
00.0: WARN halted endpoint, queueing URB anyway.
Mar 24 18:53:36 js-workstation kernel: [  253.415168] usb-storage: Stat=
us code 0; transferred 13/13
Mar 24 18:53:36 js-workstation kernel: [  253.415169] usb-storage: -- t=
ransfer complete
Mar 24 18:53:36 js-workstation kernel: [  253.415170] usb-storage: Bulk=
 status result =3D 0
Mar 24 18:53:36 js-workstation kernel: [  253.415171] usb-storage: Bulk=
 Status S 0x53425355 T 0x2f R 512 Stat 0x2
Mar 24 18:53:36 js-workstation kernel: [  253.415172] usb-storage: -- t=
ransport indicates error, resetting
Mar 24 18:53:36 js-workstation kernel: [  253.415174] usb-storage: usb_=
stor_pre_reset
Mar 24 18:53:36 js-workstation kernel: [  253.415204] usb-storage: usb_=
stor_post_reset

I'm trying to figure out if this device would benefit from any USB
storage quirks being set.

Sarah Sharp
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
