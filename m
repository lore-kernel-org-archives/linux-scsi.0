From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: Mptlinux crashes on kernel 2.6.22.1
Date: Tue, 7 Aug 2007 13:11:11 +0200
Message-ID: <200708071311.16207.eike-kernel@sf-tec.de>
References: <62DDBB9E5E23CC4A929EE46F9427CEAF1F8007@BUDMLVEM04.e2k.ad.ge.com> <62DDBB9E5E23CC4A929EE46F9427CEAF1F829D@BUDMLVEM04.e2k.ad.ge.com> <62DDBB9E5E23CC4A929EE46F9427CEAF1F8475@BUDMLVEM04.e2k.ad.ge.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart9649716.QQs4P9nIDk";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:57758 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933425AbXHGLSE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Aug 2007 07:18:04 -0400
Received: from pd907f0e2.dip0.t-ipconnect.de ([::ffff:217.7.240.226] HELO donald.sf-tec.de) (auth=eike-kernel@sf-tec.de)
	by mail.sf-mail.de (Qsmtpd 0.9) with (DHE-RSA-AES256-SHA encrypted) ESMTPSA
	for <linux-scsi@vger.kernel.org>; Tue, 07 Aug 2007 13:11:19 +0200
In-Reply-To: <62DDBB9E5E23CC4A929EE46F9427CEAF1F8475@BUDMLVEM04.e2k.ad.ge.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Hommel, Thomas (GE Indust, GE Fanuc)" <Thomas.Hommel@gefanuc.com>, eric.moore@lsi.com

--nextPart9649716.QQs4P9nIDk
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hommel, Thomas (GE Indust, GE Fanuc) wrote:
> Here's a record of driver initialization with debugging enabled. I can't
> figure out what goes wrong, but maybe sombody else can...
>
> Any help is appreciated

[...]
> mptbase: ioc0: WARNING - mpt_timer_expired complete!
> Unable to handle kernel paging request for data at address 0x00000542
> Faulting instruction address: 0xa01d93b8
> Oops: Kernel access of bad area, sig: 11 [#1]
> SBS CM6
> NIP: a01d93b8 LR: a01d93b8 CTR: a000c2ac
> REGS: bffcbea0 TRAP: 0300   Not tainted  (2.6.22.1)
> MSR: 00009032 <EE,ME,IR,DR>  CR: 82004028  XER: 00000000
> DAR: 00000542, DSISR: 40000000
> TASK = bffc0030[5] 'events/0' THREAD: bffca000
> GPR00: a01d93b8 bffcbf50 bffc0030 bfffd0c0 bfff7800 00000001 004971e0
> 00000000
> GPR08: 0001c7d0 00000010 a039c000 bfff783c 00000000 ff9f6b57 0fffbd00
> ffffffff
> GPR16: 00000001 00000000 007fff00 00000000 00000000 007ffeb0 00000000
> a034dd74
> GPR24: a0350000 a034dd74 a0030000 a034dd74 a02e0000 bffca000 a01d93a0
> 000002c4
> NIP [a01d93b8] mptspi_dv_renegotiate_work+0x18/0x120
> LR [a01d93b8] mptspi_dv_renegotiate_work+0x18/0x120
> Call Trace:
> [bffcbf50] [a01d93b8] mptspi_dv_renegotiate_work+0x18/0x120 (unreliable)
> [bffcbf80] [a002d33c] run_workqueue+0xac/0x158
> [bffcbfa0] [a002d7a8] worker_thread+0x6c/0xd0
> [bffcbfd0] [a0030e74] kthread+0x84/0x8c
> [bffcbff0] [a00115c4] kernel_thread+0x44/0x60
> Instruction dump:
> 4bffd6d1 80010024 83e1001c 38210020 7c0803a6 4e800020 7c0802a6 9421ffd0
> bf810020 90010034 83e30010 4be83521 <a01f027e> 2f800000 419e009c
> 813f0000
> mptbase: ioc0: Sending Config request type 4, page 1 and action 0
> mptbase: ioc0: mf_dma_addr=1fe82922 req_idx=3 RequestNB=2
> mptbase: ioc0: WARNING - mpt_timer_expired!
> mptbase: IOC setup_reset routed to MPT base driver!
> mptbase: Initiating ioc0 recovery
> mptbase::MakeIocReady, ioc0 [raw] state=24000000
> mptbase: ioc0: IOC operational unexpected
> mptbase: whoinit 0x4 statefault 0 force 1

Looks like a NULL deref.

Find your mptspi.o, fusion.o or fusion.ko (all of them should work), and do

gdb fusion.o
l *mptspi_dv_renegotiate_work+0x18

That should give you the faulting line.

Eike

--nextPart9649716.QQs4P9nIDk
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGuFNUXKSJPmm5/E4RAqMPAJsFcETwNAHBk3NJCB4v9YJIbR6ZjwCgogrg
yzyi1YG/Ut4xMIiBQAWksaY=
=XK40
-----END PGP SIGNATURE-----

--nextPart9649716.QQs4P9nIDk--
