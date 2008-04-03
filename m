From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: build issue #466 for v2.6.25-rc8-119-g9597362
	drivers/scsi/mvsas.o
Date: Thu, 03 Apr 2008 09:04:31 -0500
Message-ID: <1207231472.3048.19.camel@localhost.localdomain>
References: <200804031406.02976.toralf.foerster@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:51381 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758281AbYDCOEf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Apr 2008 10:04:35 -0400
In-Reply-To: <200804031406.02976.toralf.foerster@gmx.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux-scsi@vger.kernel.org

On Thu, 2008-04-03 at 14:06 +0200, Toralf F=C3=B6rster wrote:
> Hello,
>=20
> the build (.config attached) failed, make ends with :
> ...
>   SHIPPED drivers/scsi/53c700_d.h
>   CC      drivers/scsi/53c700.o
>   CC      drivers/scsi/sim710.o
>   CC      drivers/scsi/dpt_i2o.o
> drivers/scsi/dpt_i2o.c:169: warning: 'dptids' defined but not used
>   CC      drivers/scsi/aha152x.o
>   CC      drivers/scsi/aic7xxx_old.o
>   CC      drivers/scsi/ips.o
>   CC      drivers/scsi/g_NCR5380.o
> drivers/scsi/g_NCR5380.c:942: warning: 'id_table' defined but not use=
d
>   CC      drivers/scsi/NCR53c406a.o
>   CC      drivers/scsi/qlogicfas408.o
>   CC      drivers/scsi/qlogicfas.o
>   CC      drivers/scsi/dtc.o
> drivers/scsi/dtc.c:180: warning: 'dtc_setup' defined but not used
>   CC      drivers/scsi/gdth.o
>   CC      drivers/scsi/3w-9xxx.o
>   CC      drivers/scsi/mvsas.o
>   CC      drivers/scsi/st.o
>   CC      drivers/scsi/osst.o
>   LD      drivers/scsi/sr_mod.o
>   CC      drivers/scsi/sg.o
>   LD      drivers/scsi/built-in.o
> drivers/scsi/mvsas.o: In function `sas_ata_init_host_and_port':
> mvsas.c:(.text+0x0): multiple definition of `sas_ata_init_host_and_po=
rt'
> drivers/scsi/libsas/built-in.o:(.text+0x37f4): first defined here
> drivers/scsi/mvsas.o: In function `sas_ata_task_abort':
> mvsas.c:(.text+0x7): multiple definition of `sas_ata_task_abort'
> drivers/scsi/libsas/built-in.o:(.text+0x37fb): first defined here
> make[2]: *** [drivers/scsi/built-in.o] Error 1
> make[1]: *** [drivers/scsi] Error 2
> make: *** [drivers] Error 2

This is because of some missing static inline declarations in a header
file.  The attached should fix it.

James

---

diff --git a/include/scsi/sas_ata.h b/include/scsi/sas_ata.h
index dd5edc9..c583193 100644
--- a/include/scsi/sas_ata.h
+++ b/include/scsi/sas_ata.h
@@ -47,12 +47,12 @@ static inline int dev_is_sata(struct domain_device =
*dev)
 {
 	return 0;
 }
-int sas_ata_init_host_and_port(struct domain_device *found_dev,
+static inline int sas_ata_init_host_and_port(struct domain_device *fou=
nd_dev,
 			       struct scsi_target *starget)
 {
 	return 0;
 }
-void sas_ata_task_abort(struct sas_task *task)
+static inline void sas_ata_task_abort(struct sas_task *task)
 {
 }
 #endif


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
