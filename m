From: MAEDA Naoaki <maeda.naoaki@jp.fujitsu.com>
Subject: [RFC][PATCH] MPT fusion driver recovery failure fix
Date: Fri, 27 Oct 2006 15:16:13 +0900 (JST)
Message-ID: <20061027.151613.-1300545365.maeda.naoaki@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <fastboot-bounces@lists.osdl.org>
List-Unsubscribe: <https://lists.osdl.org/mailman/listinfo/fastboot>,
	<mailto:fastboot-request@lists.osdl.org?subject=unsubscribe>
List-Archive: <http://lists.osdl.org/pipermail/fastboot>
List-Post: <mailto:fastboot@lists.osdl.org>
List-Help: <mailto:fastboot-request@lists.osdl.org?subject=help>
List-Subscribe: <https://lists.osdl.org/mailman/listinfo/fastboot>,
	<mailto:fastboot-request@lists.osdl.org?subject=subscribe>
Sender: fastboot-bounces@lists.osdl.org
Errors-To: fastboot-bounces@lists.osdl.org
To: linux-scsi@vger.kernel.org
Cc: fastboot@lists.osdl.org, Eric.Moore@lsil.com
List-Id: linux-scsi@vger.kernel.org

Hi,

MPT fusion driver access uninitialized pointer if ioc recovery
is initiated while kexec second kernel is booting. Oops message is
cited at the end of this mail.

Since the second kernel is booted while adapter is still operating,
MPT fusion driver possible to initiate ioc recovery. In this case,
the driver access uninitialized pointer on reset.

I've created a patch to fix the problem and tested it with
53c1030 controller. Your suggestions are welcome.

Signed-off-by: MAEDA Naoaki <maeda.naoaki@jp.fujitsu.com>
---
 drivers/message/fusion/mptspi.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

Index: linux-2.6.19-rc3/drivers/message/fusion/mptspi.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.19-rc3.orig/drivers/message/fusion/mptspi.c
+++ linux-2.6.19-rc3/drivers/message/fusion/mptspi.c
@@ -816,11 +816,17 @@ mptspi_dv_renegotiate(struct _MPT_SCSI_H
 static int
 mptspi_ioc_reset(MPT_ADAPTER *ioc, int reset_phase)
 {
-	struct _MPT_SCSI_HOST *hd =3D (struct _MPT_SCSI_HOST *)ioc->sh->hostdata;
+	struct _MPT_SCSI_HOST *hd;
 	int rc;
 =

 	rc =3D mptscsih_ioc_reset(ioc, reset_phase);
 =

+	/* reset may be called before scsi host has been attached */
+	if ((ioc->sh =3D=3D NULL) || (ioc->sh->hostdata =3D=3D NULL))
+		return rc;
+	else
+		hd =3D (struct _MPT_SCSI_HOST *)ioc->sh->hostdata;
+
 	if (reset_phase =3D=3D MPT_IOC_POST_RESET)
 		mptspi_dv_renegotiate(hd);
 =



---------------------------------------------------------------------------=
---
Fusion MPT base driver 3.04.01
Copyright (c) 1999-2005 LSI Logic Corporation
Loading mptscsih.ko module
Loading mptspi.ko module
Fusion MPT SPI Host driver 3.04.01
GSI 816 (level, low) -> CPU 0 (0x8604) vector 54
ACPI: PCI Interrupt 0000:44:01.0[A] -> GSI 816 (level, low) -> IRQ 54
mptbase: Initiating ioc0 bringup
ioc0: 53C1030: Capabilities=3D{Initiator,Target}
scsi0 : ioc0: LSI53C1030, FwRev=3D01032700h, Ports=3D1, MaxQ=3D255, IRQ=3D54
  Vendor: FUJITSU   Model: MAP3735NC         Rev: 5207
  Type:   Direct-Access                      ANSI SCSI revision: 03
 target0:0:0: Beginning Domain Validation
 target0:0:0: Ending Domain Validation
 target0:0:0: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI PCOMP (6.25 ns, o=
ffset 127)
SCSI device sda: 143374741 512-byte hdwr sectors (73408 MB)
sda: Write Protect is off
SCSI device sda: drive cache: write through
SCSI device sda: 143374741 512-byte hdwr sectors (73408 MB)
sda: Write Protect is off
SCSI device sda: drive cache: write through
 sda: sda1 sda2 sda3
sd 0:0:0:0: Attached scsi disk sda
  Vendor: FUJITSU   Model: MAT3073NC         Rev: 3701
  Type:   Direct-Access                      ANSI SCSI revision: 03
 target0:0:1: Beginning Domain Validation
 target0:0:1: Ending Domain Validation
 target0:0:1: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RTI WRFLOW PCOMP (6.2=
5 ns, offset 127)
SCSI device sdb: 143550456 512-byte hdwr sectors (73498 MB)
sdb: Write Protect is off
SCSI device sdb: drive cache: write through
SCSI device sdb: 143550456 512-byte hdwr sectors (73498 MB)
sdb: Write Protect is off
SCSI device sdb: drive cache: write through
 sdb: sdb1 sdb2
sd 0:0:1:0: Attached scsi disk sdb
  Vendor: QLogic    Model: GEM359            Rev: 0204
  Type:   Processor                          ANSI SCSI revision: 02
 target0:0:6: Beginning Domain Validation
 target0:0:6: Ending Domain Validation
 target0:0:6: asynchronous
GSI 817 (level, low) -> CPU 0 (0x8604) vector 55
ACPI: PCI Interrupt 0000:44:01.1[B] -> GSI 817 (level, low) -> IRQ 55
mptbase: Initiating ioc1 bringup
ioc1: 53C1030: Capabilities=3D{Initiator,Target}
scsi1 : ioc1: LSI53C1030, FwRev=3D01032700h, Ports=3D1, MaxQ=3D255, IRQ=3D55
GSI 864 (level, low) -> CPU 0 (0x8604) vector 56
ACPI: PCI Interrupt 0000:47:01.0[A] -> GSI 864 (level, low) -> IRQ 56
mptbase: Initiating ioc2 bringup
ioc2: 53C1030: Capabilities=3D{Initiator,Target}
mptbase: Initiating ioc2 recovery
Unable to handle kernel NULL pointer dereference (address 0000000000000500)
events/0[5]: Oops 8813272891392 [1]
Modules linked in: mptspi mptscsih mptbase

Pid: 5, CPU 0, comm:             events/0
psr : 00001010085a6010 ifs : 8000000000000287 ip  : [<a000000200131b20>]   =
 Not tainted
ip is at mptspi_dv_renegotiate_work+0x40/0xe0 [mptspi]
unat: 0000000000000000 pfs : 0000000000000287 rsc : 0000000000000003
rnat: 0000000000000000 bsps: 0000000000000000 pr  : 0000000000005641
ldrs: 0000000000000000 ccv : 0000000000000001 fpsr: 0009804c8a70433f
csd : 0000000000000000 ssd : 0000000000000000
b0  : a000000200131b10 b6  : a000000200131ae0 b7  : a00000010000c220
f6  : 0fffefffffffff0000000 f7  : 0ffe3f100000000000000
f8  : 10007f100000000000000 f9  : 0ffff8000000000000000
f10 : 10007f0fffffff0f00000 f11 : 1003e00000000000001e2
r1  : a00000020013bd58 r2  : a000000100aab800 r3  : e00000000cededf0
r8  : e0000000170fc028 r9  : 0000000000000078 r10 : e000000017e02900
r11 : 0000000000000010 r12 : e000000017f77d80 r13 : e000000017f70000
r14 : 0000000000000000 r15 : 000000000000000f r16 : e00000000cededf8
r17 : e000000017e02884 r18 : 000000000000000f r19 : e000000017f70f90
r20 : e000000017f70fa4 r21 : a000000100aab800 r22 : 0000000000004000
r23 : 0000000000004000 r24 : e00000000cd9c000 r25 : 00000000000285b9
r26 : e00000000cd9c001 r27 : 000000000002e1f8 r28 : 0000000000005c3f
r29 : e000000008ae4000 r30 : 0000000000000000 r31 : e000000017f77d80

Call Trace:
 [<a000000100014720>] show_stack+0x40/0xa0
                                sp=3De000000017f77930 bsp=3De000000017f71208
 [<a000000100015020>] show_regs+0x840/0x880
                                sp=3De000000017f77b00 bsp=3De000000017f711a8
 [<a000000100037560>] die+0x1c0/0x2c0
                                sp=3De000000017f77b00 bsp=3De000000017f71160
 [<a0000001000614f0>] ia64_do_page_fault+0x810/0x940
                                sp=3De000000017f77b20 bsp=3De000000017f71110
 [<a00000010000ca20>] ia64_leave_kernel+0x0/0x280
                                sp=3De000000017f77bb0 bsp=3De000000017f71110
 [<a000000200131b20>] mptspi_dv_renegotiate_work+0x40/0xe0 [mptspi]
                                sp=3De000000017f77d80 bsp=3De000000017f710d8
 [<a0000001000b7680>] run_workqueue+0x1c0/0x280
                                sp=3De000000017f77d80 bsp=3De000000017f71098
 [<a0000001000b9620>] worker_thread+0x1a0/0x240
                                sp=3De000000017f77d80 bsp=3De000000017f71068
 [<a0000001000c1470>] kthread+0x230/0x2a0
                                sp=3De000000017f77dd0 bsp=3De000000017f71020
 [<a000000100012a50>] kernel_thread_helper+0xd0/0x100
                                sp=3De000000017f77e30 bsp=3De000000017f70ff0
 [<a0000001000094c0>] start_kernel_thread+0x20/0x40
                                sp=3De000000017f77e30 bsp=3De000000017f70ff0
 <6>mptbase: Initiating ioc2 recovery

Thanks,
MAEDA Naoaki
