From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: build #308 failed for 2.6.23-rc1-gd941cf5 in
	linux/./drivers/scsi/libsas/sas_ata.c
Date: Sat, 28 Jul 2007 11:07:36 -0400
Message-ID: <1185635256.11492.18.camel@localhost.localdomain>
References: <200707271253.27881.toralf.foerster@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:34604 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750764AbXG1PHi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Jul 2007 11:07:38 -0400
In-Reply-To: <200707271253.27881.toralf.foerster@gmx.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: djwong@us.ibm.com, linux-scsi@vger.kernel.org

On Fri, 2007-07-27 at 12:53 +0200, Toralf F=C3=B6rster wrote:
> Hello,
>=20
> the build with the attached .config failed, make ends with:
> ...
>   CHK     include/linux/compile.h
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> drivers/built-in.o: In function `sas_queuecommand':
> (.text+0x932af): undefined reference to `ata_sas_queuecmd'
> drivers/built-in.o: In function `sas_slave_configure':
> (.text+0x934a4): undefined reference to `ata_sas_slave_configure'
> drivers/built-in.o: In function `sas_target_destroy':
> (.text+0x92317): undefined reference to `ata_sas_port_destroy'
> drivers/built-in.o: In function `sas_ioctl':
> (.text+0x92fa4): undefined reference to `ata_scsi_ioctl'
> drivers/built-in.o: In function `sas_slave_destroy':
> (.text+0x92fcd): undefined reference to `ata_port_disable'
> drivers/built-in.o: In function `sas_slave_alloc':
> (.text+0x9307f): undefined reference to `ata_sas_port_init'
> drivers/built-in.o: In function `sas_ata_init_host_and_port':
> (.text+0x942c6): undefined reference to `ata_host_init'
> drivers/built-in.o: In function `sas_ata_init_host_and_port':
> (.text+0x942d4): undefined reference to `ata_sas_port_alloc'
> drivers/built-in.o: In function `sas_ata_qc_issue':
> sas_ata.c:(.text+0x9445d): undefined reference to `ata_tf_to_fis'
> drivers/built-in.o: In function `sas_ata_task_done':
> sas_ata.c:(.text+0x9473c): undefined reference to `ata_tf_from_fis'
> sas_ata.c:(.text+0x9479b): undefined reference to `ata_qc_complete'
> drivers/built-in.o:(.data+0xafc0): undefined reference to `ata_port_d=
isable'
> drivers/built-in.o:(.data+0xafe8): undefined reference to `ata_noop_d=
ev_select'
> drivers/built-in.o:(.data+0xb008): undefined reference to `ata_noop_q=
c_prep'
> drivers/built-in.o:(.data+0xb044): undefined reference to `ata_sas_po=
rt_start'
> drivers/built-in.o:(.data+0xb048): undefined reference to `ata_sas_po=
rt_stop'
> make: *** [.tmp_vmlinux1] Error 1

This is a Kconfig cockup.  If you have the libsas with ATA support, it
needs libata to function.  The problem is that if you compile in libsas=
,
you can't build libata as a module (however, vice versa you can).

About the only way I can think to code this in current Kconfig is the
attached rather ugly code.

James

diff --git a/drivers/scsi/libsas/Kconfig b/drivers/scsi/libsas/Kconfig
index 3a3c1ac..c01a40d 100644
--- a/drivers/scsi/libsas/Kconfig
+++ b/drivers/scsi/libsas/Kconfig
@@ -32,7 +32,8 @@ config SCSI_SAS_LIBSAS
=20
 config SCSI_SAS_ATA
 	bool "ATA support for libsas (requires libata)"
-	depends on SCSI_SAS_LIBSAS && ATA
+	depends on SCSI_SAS_LIBSAS
+	depends on ATA =3D y || ATA =3D SCSI_SAS_LIBSAS
 	help
 		Builds in ATA support into libsas.  Will necessitate
 		the loading of libata along with libsas.


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
