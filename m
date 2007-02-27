From: Andre Noll <maan@systemlinux.org>
Subject: Re: qla2xxx BUG: workqueue leaked lock or atomic
Date: Tue, 27 Feb 2007 11:11:00 +0100
Message-ID: <20070227101100.GA22572@skl-net.de>
References: <20070226133153.GC4095@skl-net.de> <20070226182617.GC9968@andrew-vasquezs-computer.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from systemlinux.org ([83.151.29.59]:52117 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932240AbXB0KLQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Feb 2007 05:11:16 -0500
Content-Disposition: inline
In-Reply-To: <20070226182617.GC9968@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 10:26, Andrew Vasquez wrote:
> You are loading some stale firmware that's left over on the card --
> I'm not even sure what 4.00.70 is, as the latest release firmware is
> 4.00.27.

That's the firmware which came with the card. Anyway, I just upgraded
the firmware, but the bug remains. The backtrace differs a bit though
as now the tg3 network driver seems to be involved as well.

Thanks for your help
Andre

[   67.511167] qla2xxx 0000:05:08.0: Allocated (64 KB) for EFT...
[   67.511434] qla2xxx 0000:05:08.0: Allocated (1413 KB) for firmware dump.=
=2E.
[   67.531231] scsi0 : qla2xxx
[   67.854344] qla2xxx 0000:05:08.0:=20
[   67.854346]  QLogic Fibre Channel HBA Driver: 8.01.07-k4
[   67.854347]   QLogic HP AE369-60001 - QLA2340
[   67.854348]   ISP2422: PCI-X Mode 1 (133 MHz) @ 0000:05:08.0 hdma+, host=
#=3D0, fw=3D4.00.27 [IP]=20
[   67.854881] ACPI: PCI Interrupt 0000:05:08.1[B] -> GSI 33 (level, low) -=
> IRQ 33
[   67.855230] qla2xxx 0000:05:08.1: Found an ISP2422, irq 33, iobase 0xfff=
fc20000012000
[   67.855645] qla2xxx 0000:05:08.1: Configuring PCI space...
[   67.855907] qla2xxx 0000:05:08.1: Configure NVRAM parameters...
[   67.862486] qla2xxx 0000:05:08.1: Verifying loaded RISC code...
[   68.106663] qla2xxx 0000:05:08.1: Allocated (64 KB) for EFT...
[   68.107058] qla2xxx 0000:05:08.1: Allocated (1413 KB) for firmware dump.=
=2E.
[   68.126759] scsi1 : qla2xxx
[   68.196783] Adding 6540152k swap on /dev/md2.  Priority:-1 extents:1 acr=
oss:6540152k
[   68.260645] qla2xxx 0000:05:08.0: LIP reset occured (f8f7).
[   68.296027] qla2xxx 0000:05:08.0: LIP occured (f8f7).
[   68.298214] qla2xxx 0000:05:08.0: LOOP UP detected (2 Gbps).
[   68.326627] qla2xxx 0000:05:08.1:=20
[   68.326628]  QLogic Fibre Channel HBA Driver: 8.01.07-k4
[   68.326630]   QLogic HP AE369-60001 - QLA2340
[   68.326631]   ISP2422: PCI-X Mode 1 (133 MHz) @ 0000:05:08.1 hdma+, host=
#=3D1, fw=3D4.00.27 [IP]=20
[   68.504335] EXT3 FS on md1, internal journal
[   68.524627] PM: Writing back config space on device 0000:03:06.0 at offs=
et b (was 164814e4, writing d00e11)
[   68.524644] PM: Writing back config space on device 0000:03:06.0 at offs=
et 3 (was 804000, writing 804010)
[   68.524650] PM: Writing back config space on device 0000:03:06.0 at offs=
et 2 (was 2000000, writing 2000010)
[   68.524657] PM: Writing back config space on device 0000:03:06.0 at offs=
et 1 (was 2b00000, writing 2b00146)
[   68.532665] BUG: at kernel/lockdep.c:1860 trace_hardirqs_on()
[   68.532784]=20
[   68.532785] Call Trace:
[   68.532979]  <IRQ>  [<ffffffff8024b877>] trace_hardirqs_on+0xd7/0x180
[   68.533168]  [<ffffffff80511f5b>] _spin_unlock_irq+0x2b/0x40
[   68.533295]  [<ffffffff88032747>] :qla2xxx:qla2x00_process_completed_req=
uest+0x137/0x1d0
[   68.533457]  [<ffffffff88032862>] :qla2xxx:qla2x00_status_entry+0x82/0xa=
40
[   68.533577]  [<ffffffff8024b17f>] __lock_acquire+0xcdf/0xd90
[   68.533693]  [<ffffffff80511ff2>] _spin_unlock_irqrestore+0x42/0x60
[   68.533816]  [<ffffffff880343fe>] :qla2xxx:qla24xx_intr_handler+0x4e/0x2=
b0
[   68.533942]  [<ffffffff88033551>] :qla2xxx:qla24xx_process_response_queu=
e+0xc1/0x1c0
[   68.534102]  [<ffffffff88034584>] :qla2xxx:qla24xx_intr_handler+0x1d4/0x=
2b0
[   68.534224]  [<ffffffff8025e950>] handle_IRQ_event+0x20/0x60
[   68.534339]  [<ffffffff802604ad>] handle_fasteoi_irq+0xbd/0x110
[   68.534459]  [<ffffffff8020cf62>] do_IRQ+0x132/0x1a0
[   68.534574]  [<ffffffff8020a236>] ret_from_intr+0x0/0xf
[   68.534687]  <EOI>  [<ffffffff803ad15c>] __delay+0xc/0x20
[   68.534862]  [<ffffffff803ad1a7>] __const_udelay+0x37/0x40
[   68.534982]  [<ffffffff88006737>] :tg3:tg3_chip_reset+0x547/0x670
[   68.535103]  [<ffffffff8800df2d>] :tg3:tg3_reset_hw+0x5d/0x1790
[   68.535218]  [<ffffffff803ad1e7>] __udelay+0x37/0x40
[   68.535333]  [<ffffffff8800408d>] :tg3:_tw32_flush+0x6d/0x80
[   68.535451]  [<ffffffff88012196>] :tg3:tg3_open+0x2d6/0x610
[   68.535569]  [<ffffffff8800f6a2>] :tg3:tg3_init_hw+0x42/0x50
[   68.535687]  [<ffffffff880121a3>] :tg3:tg3_open+0x2e3/0x610
[   68.535804]  [<ffffffff804b36e3>] dev_open+0x43/0x90
[   68.535917]  [<ffffffff804b2814>] dev_change_flags+0x74/0x160
[   68.536034]  [<ffffffff804f3e66>] devinet_ioctl+0x2e6/0x730
[   68.536149]  [<ffffffff804b4bc2>] dev_ioctl+0x302/0x340
[   68.536264]  [<ffffffff803aa71b>] __up_read+0x9b/0xb0
[   68.536378]  [<ffffffff804f42fc>] inet_ioctl+0x4c/0x70
[   68.536494]  [<ffffffff804a73ec>] sock_ioctl+0x1fc/0x230
[   68.536610]  [<ffffffff8029c701>] do_ioctl+0x31/0xa0
[   68.536722]  [<ffffffff8029ca2b>] vfs_ioctl+0x2bb/0x2e0
[   68.536836]  [<ffffffff8029ca9a>] sys_ioctl+0x4a/0x80
[   68.536948]  [<ffffffff80209cee>] system_call+0x7e/0x83
[   68.537059]=20
[   68.712832] scsi 0:0:0:0: Direct-Access     transtec T6100F16R1-E     34=
2I PQ: 0 ANSI: 5
[   68.713384] sda : very big device. try to use READ CAPACITY(16).
[   68.713594] SCSI device sda: 11714863104 512-byte hdwr sectors (5998010 =
MB)
[   68.713976] sda: Write Protect is off
[   68.714079] sda: Mode Sense: 9b 00 00 08
[   68.714483] SCSI device sda: write cache: disabled, read cache: enabled,=
 doesn't support DPO or FUA
[   68.714876] sda : very big device. try to use READ CAPACITY(16).
[   68.715080] SCSI device sda: 11714863104 512-byte hdwr sectors (5998010 =
MB)
[   68.715436] sda: Write Protect is off
[   68.715539] sda: Mode Sense: 9b 00 00 08
[   68.715944] SCSI device sda: write cache: disabled, read cache: enabled,=
 doesn't support DPO or FUA
[   68.718244]  sda: unknown partition table
[   68.718707] sd 0:0:0:0: Attached scsi disk sda
[   68.718945] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   68.719413] BUG: workqueue leaked lock or atomic: scsi_wq_0/0x00000000/2=
138
[   68.719556]     last function: fc_scsi_scan_rport+0x0/0x90
[   68.719754] 1 lock held by scsi_wq_0/2138:
[   68.719878]  #0:  (&shost->scan_mutex){--..}, at: [<ffffffff80510325>] m=
utex_lock+0x25/0x30
[   68.720380]=20
[   68.720381] Call Trace:
[   68.720616]  [<ffffffff80248319>] debug_show_held_locks+0x9/0x10
[   68.720757]  [<ffffffff8023eb49>] run_workqueue+0x149/0x1a0
[   68.720891]  [<ffffffff802427c0>] keventd_create_kthread+0x0/0x90
[   68.721030]  [<ffffffff8023edc1>] worker_thread+0x151/0x190
[   68.721167]  [<ffffffff80227e80>] default_wake_function+0x0/0x10
[   68.721307]  [<ffffffff8023ec70>] worker_thread+0x0/0x190
[   68.721443]  [<ffffffff80242a2a>] kthread+0xda/0x110
[   68.721575]  [<ffffffff8020ab08>] child_rip+0xa/0x12
[   68.721709]  [<ffffffff80511f5b>] _spin_unlock_irq+0x2b/0x40
[   68.721842]  [<ffffffff8020a28c>] restore_args+0x0/0x30
[   68.721973]  [<ffffffff80242950>] kthread+0x0/0x110
[   68.722106]  [<ffffffff8020aafe>] child_rip+0x0/0x12
[   68.722240]=20
[   68.762666] qla2xxx 0000:05:08.1: LIP reset occured (f7f7).
[   68.797954] qla2xxx 0000:05:08.1: LIP occured (f7f7).
[   68.800134] qla2xxx 0000:05:08.1: LOOP UP detected (2 Gbps).
[   69.127937] scsi 1:0:0:0: Direct-Access     ADVUNI   OXYGENRAID 416F  34=
1B PQ: 0 ANSI: 3
[   69.128528] sdb : very big device. try to use READ CAPACITY(16).
[   69.128777] SCSI device sdb: 9370656768 512-byte hdwr sectors (4797776 M=
B)
[   69.129220] sdb: Write Protect is off
[   69.129326] sdb: Mode Sense: 8f 00 00 08
[   69.129878] SCSI device sdb: write cache: disabled, read cache: enabled,=
 doesn't support DPO or FUA
[   69.130342] sdb : very big device. try to use READ CAPACITY(16).
[   69.130585] SCSI device sdb: 9370656768 512-byte hdwr sectors (4797776 M=
B)
[   69.131006] sdb: Write Protect is off
[   69.131110] sdb: Mode Sense: 8f 00 00 08
[   69.131660] SCSI device sdb: write cache: disabled, read cache: enabled,=
 doesn't support DPO or FUA
[   69.131843]  sdb: unknown partition table
[   69.132401] sd 1:0:0:0: Attached scsi disk sdb
[   69.132624] sd 1:0:0:0: Attached scsi generic sg1 type 0

--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFF5AO0Wto1QDEAkw8RAj0/AJ9k/twJfDkO5+2Jci556jszmw7SIQCgkUAn
Uu2pbmYVYWvXJPpDn40nfdo=
=7xsD
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
