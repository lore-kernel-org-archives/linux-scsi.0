From: florin@iucha.net (Florin Iucha)
Subject: Re: [linux-usb-devel] USB Storage oops in 2.5.69-bk8
Date: Fri, 16 May 2003 12:25:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030516172538.GB11884@iucha.net>
References: <20030516155621.GB11432@iucha.net> <20030516162250.GB1654@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1UWUbFP1cBYEclgG"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iucha.net ([209.98.146.184]:29558 "EHLO mail.iucha.net")
	by vger.kernel.org with ESMTP id S264518AbTEPRMq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 May 2003 13:12:46 -0400
Content-Disposition: inline
In-Reply-To: <20030516162250.GB1654@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi@vger.kernel.org


--1UWUbFP1cBYEclgG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 16, 2003 at 09:22:50AM -0700, Mike Anderson wrote:
> This might be a case that the scsi_error handler never reclaimed or
> canceled the command (i.e., this is a lost command) and probably should
> not update the fields.
>=20
> Could you get me a little more data on what the error handler actions
> where by doing the following:
> 	1.) Ensure SCSI logging is enabled in your config.
> 	CONFIG_SCSI_LOGGING=3Dy.
>=20
> 	2.) Prior to the mount of the Compact Flash card.
> 	echo "scsi log error 4" > /proc/scsi/scsi
>=20
> 	If this is getting set dmesg should give a line that scsi
> 	logging level set to ...
>=20
> 	3.) Mount the Compact Flash card and send me the output when it
> 	fails.

Here it is:

scsi logging level set to 0x00000004
SCSI device sda: 31232 512-byte hdwr sectors (16 MB)
sda: Write Protect is off
sda: Mode Sense: 02 00 00 00
drivers/usb/core/message.c: usb_control/bulk_msg: timeout
Error handler scsi_eh_1 waking up
scsi_eh_prt_fail_stats: 1:0:0:0 cmds failed: 0, cancel: 1
Total of 1 commands on 1 devices require eh work
scsi_eh_1: aborting cmd:0xedac3080
scsi_eh_times_out: scmd:edac3080
scsi_send_eh_cmnd: scmd: edac3080, rtn:2003
scsi_eh_tur: scmd edac3080 rtn 2003
scsi_eh_1: Sending BDR sdev: 0xee133c00
drivers/usb/core/message.c: usb_control/bulk_msg: timeout
scsi_eh_1: BDR failed sdev:0xee133c00
scsi_eh_1: Sending BRST chan: 0
scsi_try_bus_reset: Snd Bus RST
drivers/usb/core/hub.c: USB device not accepting new address (error=3D-22)
scsi_eh_1: BRST failed chan: 0
scsi_eh_1: Sending HRST
scsi_try_host_reset: Snd Host RST
scsi_eh_1: HRST failed
scsi: Device offlined - not ready after error recovery: host 1 channel 0 id=
 0 lun 0
scsi_eh_1: flush finish cmd: edac3080
usb 5-2: USB disconnect, address 2
Unable to handle kernel paging request at virtual address 544150a6
 printing eip:
c02aa5e8
*pde =3D 00000000
Oops: 0000 [#1]
CPU:    0
EIP:    0060:[<c02aa5e8>]    Not tainted
EFLAGS: 00010002
EIP is at scsi_host_busy_dec_and_test+0x18/0x8a
eax: ed9f8000   ebx: 00000286   ecx: 54415056   edx: ed9f8000
esi: edac3080   edi: 54415056   ebp: ed9f8000   esp: ed9f9f24
ds: 007b   es: 007b   ss: 0068
Process scsi_eh_1 (pid: 604, threadinfo=3Ded9f8000 task=3Dee15d840)
Stack: c036db3b ee133c00 c02a93fc 54415056 ee133c00 edac3080 edac3080 ed9f9=
fa8=20
       ed9f9fa8 c02ad2bb edac3080 ee15db26 edac3080 ed9f8000 edac3098 ee8a0=
008=20
       ee133c00 ed9f9fb0 c02ad49c ed9f9fa8 ed9f9fa8 ed9f9fa8 00000000 00000=
000=20
Call Trace:
 [<c02a93fc>] scsi_finish_command+0x1c/0x110
 [<c02ad2bb>] scsi_eh_flush_done_q+0x5b/0xe0
 [<c02ad49c>] scsi_unjam_host+0x15c/0x230
 [<c02ad6af>] scsi_error_handler+0x13f/0x1b0
 [<c02ad570>] scsi_error_handler+0x0/0x1b0
 [<c0108abd>] kernel_thread_helper+0x5/0x18

Code: 0f b7 41 50 48 f6 81 92 00 00 00 01 66 89 41 50 74 16 0f b7=20
 <6>note: scsi_eh_1[604] exited with preempt_count 1

Thank you,
florin

PS: this trace was obtained on 2.5.69-bk11.

--=20

"NT is to UNIX what a doughnut is to a particle accelerator."

--1UWUbFP1cBYEclgG
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+xR8SNLPgdTuQ3+QRAkJQAKCACEGVQgz22Et5iH4wvttfhs0jgACdHJB/
4e1ZSjaEAw+03OGrT3tIXGs=
=QLyJ
-----END PGP SIGNATURE-----

--1UWUbFP1cBYEclgG--
