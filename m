From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: [patch 3/8] mptfusion: streamline queuecommand
Date: Fri, 19 Nov 2004 08:37:51 -0700
Message-ID: <91888D455306F94EBD4D168954A9457C5468A9@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C4CE4D.BAA5D3D0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:32448 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261468AbUKSQMK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Nov 2004 11:12:10 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id iAJGAVcq006816
	for <linux-scsi@vger.kernel.org>; Fri, 19 Nov 2004 08:10:31 -0800 (PST)
Received: from nacos172.ad.lsil.com (cos1.co.lsil.com [172.21.35.122])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id iAJGC70Y030499
	for <linux-scsi@vger.kernel.org>; Fri, 19 Nov 2004 08:12:08 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C4CE4D.BAA5D3D0
Content-Type: text/plain;
	charset="iso-8859-1"

This cleans up mptscsih_qcmd function.
This patch previously submitted by hch@.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>


------_=_NextPart_000_01C4CE4D.BAA5D3D0
Content-Type: application/octet-stream;
	name="mptfusion-3.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="mptfusion-3.patch"

diff -uarN b/drivers/message/fusion/mptscsih.c =
a/drivers/message/fusion/mptscsih.c=0A=
--- b/drivers/message/fusion/mptscsih.c	2004-11-18 10:39:56.000000000 =
-0700=0A=
+++ a/drivers/message/fusion/mptscsih.c	2004-11-18 11:41:44.000000000 =
-0700=0A=
@@ -1688,11 +1688,7 @@=0A=
 	u32	 cmd_len;=0A=
 	int	 my_idx;=0A=
 	int	 ii;=0A=
-	int	 rc;=0A=
-	int	 did_errcode;=0A=
-	int	 issueCmd;=0A=
 =0A=
-	did_errcode =3D 0;=0A=
 	hd =3D (MPT_SCSI_HOST *) SCpnt->device->host->hostdata;=0A=
 	target =3D SCpnt->device->id;=0A=
 	lun =3D SCpnt->device->lun;=0A=
@@ -1791,72 +1787,66 @@=0A=
 	/* Now add the SG list=0A=
 	 * Always have a SGE even if null length.=0A=
 	 */=0A=
-	rc =3D SUCCESS;=0A=
 	if (datalen =3D=3D 0) {=0A=
 		/* Add a NULL SGE */=0A=
 		mptscsih_add_sge((char *)&pScsiReq->SGL, MPT_SGE_FLAGS_SSIMPLE_READ =
| 0,=0A=
 			(dma_addr_t) -1);=0A=
 	} else {=0A=
 		/* Add a 32 or 64 bit SGE */=0A=
-		rc =3D mptscsih_AddSGE(hd->ioc, SCpnt, pScsiReq, my_idx);=0A=
+		if (mptscsih_AddSGE(hd->ioc, SCpnt, pScsiReq, my_idx) !=3D =
SUCCESS)=0A=
+			goto fail;=0A=
 	}=0A=
 =0A=
-=0A=
-	if (rc =3D=3D SUCCESS) {=0A=
-		hd->ScsiLookup[my_idx] =3D SCpnt;=0A=
-		SCpnt->host_scribble =3D NULL;=0A=
-=0A=
-		/* SCSI specific processing */=0A=
-		issueCmd =3D 1;=0A=
-		if (hd->is_spi) {=0A=
-			int dvStatus =3D hd->ioc->spi_data.dvStatus[target];=0A=
-=0A=
-			if (dvStatus || hd->ioc->spi_data.forceDv) {=0A=
+	hd->ScsiLookup[my_idx] =3D SCpnt;=0A=
+	SCpnt->host_scribble =3D NULL;=0A=
 =0A=
 #ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION=0A=
-				if ((dvStatus & MPT_SCSICFG_NEED_DV) ||=0A=
-					(hd->ioc->spi_data.forceDv & MPT_SCSICFG_NEED_DV)) {=0A=
-					unsigned long lflags;=0A=
-					/* Schedule DV if necessary */=0A=
-					spin_lock_irqsave(&dvtaskQ_lock, lflags);=0A=
-					if (!dvtaskQ_active) {=0A=
-						dvtaskQ_active =3D 1;=0A=
-						spin_unlock_irqrestore(&dvtaskQ_lock, lflags);=0A=
-						INIT_WORK(&mptscsih_dvTask, mptscsih_domainValidation, (void *) =
hd);=0A=
+	if (hd->is_spi) {=0A=
+		int dvStatus =3D hd->ioc->spi_data.dvStatus[target];=0A=
+		int issueCmd =3D 1;=0A=
 =0A=
-						schedule_work(&mptscsih_dvTask);=0A=
-					} else {=0A=
-						spin_unlock_irqrestore(&dvtaskQ_lock, lflags);=0A=
-					}=0A=
-					hd->ioc->spi_data.forceDv &=3D ~MPT_SCSICFG_NEED_DV;=0A=
-				}=0A=
+		if (dvStatus || hd->ioc->spi_data.forceDv) {=0A=
 =0A=
-				/* Trying to do DV to this target, extend timeout.=0A=
-				 * Wait to issue until flag is clear=0A=
-				 */=0A=
-				if (dvStatus & MPT_SCSICFG_DV_PENDING) {=0A=
-					mod_timer(&SCpnt->eh_timeout, jiffies + 40 * HZ);=0A=
-					issueCmd =3D 0;=0A=
+			if ((dvStatus & MPT_SCSICFG_NEED_DV) ||=0A=
+				(hd->ioc->spi_data.forceDv & MPT_SCSICFG_NEED_DV)) {=0A=
+				unsigned long lflags;=0A=
+				/* Schedule DV if necessary */=0A=
+				spin_lock_irqsave(&dvtaskQ_lock, lflags);=0A=
+				if (!dvtaskQ_active) {=0A=
+					dvtaskQ_active =3D 1;=0A=
+					spin_unlock_irqrestore(&dvtaskQ_lock, lflags);=0A=
+					INIT_WORK(&mptscsih_dvTask, mptscsih_domainValidation, (void *) =
hd);=0A=
+=0A=
+					schedule_work(&mptscsih_dvTask);=0A=
+				} else {=0A=
+					spin_unlock_irqrestore(&dvtaskQ_lock, lflags);=0A=
 				}=0A=
+				hd->ioc->spi_data.forceDv &=3D ~MPT_SCSICFG_NEED_DV;=0A=
+			}=0A=
 =0A=
-				/* Set the DV flags.=0A=
-				 */=0A=
-				if (dvStatus & MPT_SCSICFG_DV_NOT_DONE)=0A=
-					mptscsih_set_dvflags(hd, pScsiReq);=0A=
-#endif=0A=
+			/* Trying to do DV to this target, extend timeout.=0A=
+			 * Wait to issue until flag is clear=0A=
+			 */=0A=
+			if (dvStatus & MPT_SCSICFG_DV_PENDING) {=0A=
+				mod_timer(&SCpnt->eh_timeout, jiffies + 40 * HZ);=0A=
+				issueCmd =3D 0;=0A=
 			}=0A=
-		}=0A=
 =0A=
-		if (issueCmd) {=0A=
-			mpt_put_msg_frame(ScsiDoneCtx, hd->ioc, mf);=0A=
-			dmfprintk((MYIOC_s_INFO_FMT "Issued SCSI cmd (%p) mf=3D%p =
idx=3D%d\n",=0A=
-					hd->ioc->name, SCpnt, mf, my_idx));=0A=
-			DBG_DUMP_REQUEST_FRAME(mf)=0A=
-		} else=0A=
-			goto fail;=0A=
-	} else=0A=
-		goto fail;=0A=
+			/* Set the DV flags.=0A=
+			 */=0A=
+			if (dvStatus & MPT_SCSICFG_DV_NOT_DONE)=0A=
+				mptscsih_set_dvflags(hd, pScsiReq);=0A=
+=0A=
+			if (!issueCmd)=0A=
+				goto fail;=0A=
+		}=0A=
+	}=0A=
+#endif=0A=
 =0A=
+	mpt_put_msg_frame(ScsiDoneCtx, hd->ioc, mf);=0A=
+	dmfprintk((MYIOC_s_INFO_FMT "Issued SCSI cmd (%p) mf=3D%p =
idx=3D%d\n",=0A=
+			hd->ioc->name, SCpnt, mf, my_idx));=0A=
+	DBG_DUMP_REQUEST_FRAME(mf)=0A=
 	return 0;=0A=
 =0A=
  fail:=0A=

------_=_NextPart_000_01C4CE4D.BAA5D3D0--
