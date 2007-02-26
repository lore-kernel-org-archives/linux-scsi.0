From: Andre Noll <maan@systemlinux.org>
Subject: qla2xxx BUG: workqueue leaked lock or atomic
Date: Mon, 26 Feb 2007 14:31:53 +0100
Message-ID: <20070226133153.GC4095@skl-net.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WplhKdTI2c8ulnbP"
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1030262AbXBZOA0@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Vasquez <linux-driver@qlogic.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>
List-Id: linux-scsi@vger.kernel.org


--WplhKdTI2c8ulnbP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi

On linux-2.6.20.1, we're seeing hard lockups with 2 raid systems
connected to a qla2xxx card and used as a single volume via lvm.
The system seems to lock up only if data gets written to both raid
systems at the same time.

On a standard kernel nothing makes it to the log, the system just
freezes. So we tried a lockdep kernel which reports two BUGs during
boot, see below.

Could this be related to our problem?

Thanks
Andre


[   64.150773] Loading iSCSI transport class v2.0-724.
[   64.151096] QLogic Fibre Channel HBA Driver
[   64.151405] ACPI: PCI Interrupt 0000:05:08.0[A] -> GSI 32 (level, low) -=
> IRQ 32
[   64.151821] qla2xxx 0000:05:08.0: Found an ISP2422, irq 32, iobase 0xfff=
fc20000006000
[   64.152231] qla2xxx 0000:05:08.0: Configuring PCI space...
[   64.152498] qla2xxx 0000:05:08.0: Configure NVRAM parameters...
[   64.159088] qla2xxx 0000:05:08.0: Verifying loaded RISC code...
[   74.169623] qla2xxx 0000:05:08.0: Firmware image unavailable.
[   74.169737] qla2xxx 0000:05:08.0: Firmware images can be retrieved from:=
 ftp://ftp.qlogic.com/outgoing/linux/firmware/.
[   74.169902] qla2xxx 0000:05:08.0: Attempting to load (potentially outdat=
ed) firmware from flash.
[   74.760935] qla2xxx 0000:05:08.0: Allocated (64 KB) for EFT...
[   74.761186] qla2xxx 0000:05:08.0: Allocated (1413 KB) for firmware dump.=
=2E.
[   74.776988] scsi0 : qla2xxx
[   74.961451] qla2xxx 0000:05:08.0:=20
[   74.961452]  QLogic Fibre Channel HBA Driver: 8.01.07-k4
[   74.961453]   QLogic HP AE369-60001 - QLA2340
[   74.961454]   ISP2422: PCI-X Mode 1 (133 MHz) @ 0000:05:08.0 hdma+, host=
#=3D0, fw=3D4.00.70 [IP]=20
[   74.961970] ACPI: PCI Interrupt 0000:05:08.1[B] -> GSI 33 (level, low) -=
> IRQ 33
[   74.962296] qla2xxx 0000:05:08.1: Found an ISP2422, irq 33, iobase 0xfff=
fc20000172000
[   74.962662] qla2xxx 0000:05:08.1: Configuring PCI space...
[   74.962914] qla2xxx 0000:05:08.1: Configure NVRAM parameters...
[   74.969494] qla2xxx 0000:05:08.1: Verifying loaded RISC code...
[   75.353426] qla2xxx 0000:05:08.0: LIP reset occured (f7f7).
[   75.385670] qla2xxx 0000:05:08.0: LIP occured (f7f7).
[   75.388282] qla2xxx 0000:05:08.0: LOOP UP detected (2 Gbps).
[   75.778656] BUG: at kernel/lockdep.c:1860 trace_hardirqs_on()
[   75.778771]=20
[   75.778772] Call Trace:
[   75.778967]  <IRQ>  [<ffffffff8024b877>] trace_hardirqs_on+0xd7/0x180
[   75.779154]  [<ffffffff8052bc1b>] _spin_unlock_irq+0x2b/0x40
[   75.779271]  [<ffffffff804605d7>] qla2x00_process_completed_request+0x13=
7/0x1d0
[   75.779424]  [<ffffffff804606f2>] qla2x00_status_entry+0x82/0xa40
[   75.779541]  [<ffffffff8024b17f>] __lock_acquire+0xcdf/0xd90
[   75.779657]  [<ffffffff8052bcb2>] _spin_unlock_irqrestore+0x42/0x60
[   75.779775]  [<ffffffff8046228e>] qla24xx_intr_handler+0x4e/0x2b0
[   75.779892]  [<ffffffff804613e1>] qla24xx_process_response_queue+0xc1/0x=
1c0
[   75.780012]  [<ffffffff80462414>] qla24xx_intr_handler+0x1d4/0x2b0
[   75.780131]  [<ffffffff8025e950>] handle_IRQ_event+0x20/0x60
[   75.780270]  [<ffffffff802604ad>] handle_fasteoi_irq+0xbd/0x110
[   75.780411]  [<ffffffff8020cf62>] do_IRQ+0x132/0x1a0
[   75.780545]  [<ffffffff80208430>] default_idle+0x0/0x60
[   75.780682]  [<ffffffff8020a236>] ret_from_intr+0x0/0xf
[   75.780818]  <EOI>  [<ffffffff80208467>] default_idle+0x37/0x60
[   75.781021]  [<ffffffff80208469>] default_idle+0x39/0x60
[   75.781156]  [<ffffffff80208467>] default_idle+0x37/0x60
[   75.781294]  [<ffffffff802084f1>] cpu_idle+0x61/0x90
[   75.781429]  [<ffffffff806d6f8b>] start_secondary+0x51b/0x530
[   75.781569]=20
[   75.781873] scsi 0:0:0:0: Direct-Access     transtec T6100F16R1-E     34=
2I PQ: 0 ANSI: 5
[   75.782532] BUG: workqueue leaked lock or atomic: scsi_wq_0/0x00000000/3=
62
[   75.782678]     last function: fc_scsi_scan_rport+0x0/0x90
[   75.782878] 1 lock held by scsi_wq_0/362:
[   75.783008]  #0:  (&shost->scan_mutex){--..}, at: [<ffffffff80529fe5>] m=
utex_lock+0x25/0x30
[   75.783517]=20
[   75.783518] Call Trace:
[   75.783754]  [<ffffffff80248319>] debug_show_held_locks+0x9/0x10
[   75.783896]  [<ffffffff8023eb49>] run_workqueue+0x149/0x1a0
[   75.784036]  [<ffffffff802427c0>] keventd_create_kthread+0x0/0x90
[   75.784180]  [<ffffffff8023edc1>] worker_thread+0x151/0x190
[   75.784322]  [<ffffffff80227e80>] default_wake_function+0x0/0x10
[   75.784463]  [<ffffffff8023ec70>] worker_thread+0x0/0x190
[   75.784600]  [<ffffffff80242a2a>] kthread+0xda/0x110
[   75.784737]  [<ffffffff8020ab08>] child_rip+0xa/0x12
[   75.784875]  [<ffffffff8052bc1b>] _spin_unlock_irq+0x2b/0x40
[   75.785014]  [<ffffffff8020a28c>] restore_args+0x0/0x30
[   75.785149]  [<ffffffff80242950>] kthread+0x0/0x110
[   75.785285]  [<ffffffff8020aafe>] child_rip+0x0/0x12
[   75.785417]=20
[   84.980341] qla2xxx 0000:05:08.1: Firmware image unavailable.
[   84.980455] qla2xxx 0000:05:08.1: Firmware images can be retrieved from:=
 ftp://ftp.qlogic.com/outgoing/linux/firmware/.
[   84.980620] qla2xxx 0000:05:08.1: Attempting to load (potentially outdat=
ed) firmware from flash.
[   85.571726] qla2xxx 0000:05:08.1: Allocated (64 KB) for EFT...
[   85.571956] qla2xxx 0000:05:08.1: Allocated (1413 KB) for firmware dump.=
=2E.
[   85.587766] scsi1 : qla2xxx
[   85.718476] qla2xxx 0000:05:08.1:=20
[   85.718478]  QLogic Fibre Channel HBA Driver: 8.01.07-k4
[   85.718479]   QLogic HP AE369-60001 - QLA2340
[   85.718480]   ISP2422: PCI-X Mode 1 (133 MHz) @ 0000:05:08.1 hdma+, host=
#=3D1, fw=3D4.00.70 [IP]=20
[   85.719505] sda : very big device. try to use READ CAPACITY(16).
[   85.719727] SCSI device sda: 11714863104 512-byte hdwr sectors (5998010 =
MB)
[   85.720114] sda: Write Protect is off
[   85.720219] sda: Mode Sense: 9b 00 00 08
[   85.720608] SCSI device sda: write cache: disabled, read cache: enabled,=
 doesn't support DPO or FUA
[   85.721008] sda : very big device. try to use READ CAPACITY(16).
[   85.721206] SCSI device sda: 11714863104 512-byte hdwr sectors (5998010 =
MB)
[   85.721552] sda: Write Protect is off
[   85.721680] sda: Mode Sense: 9b 00 00 08
[   85.722088] SCSI device sda: write cache: disabled, read cache: enabled,=
 doesn't support DPO or FUA
[   85.722298]  sda: unknown partition table
[   85.722897] sd 0:0:0:0: Attached scsi disk sda
[   85.723205] sd 0:0:0:0: Attached scsi generic sg0 type 0

--WplhKdTI2c8ulnbP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFF4uFIWto1QDEAkw8RApQFAJ95spAIkenXJ1P8go+fw0X95yVUGQCfVhyT
Z8PhdKYLysDdGTqIrWqt14U=
=SNzL
-----END PGP SIGNATURE-----

--WplhKdTI2c8ulnbP--
