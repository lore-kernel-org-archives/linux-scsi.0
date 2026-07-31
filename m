Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07880334C3D
	for <linux-scsi@vger.kernel.org>; Fri, 31 Jul 2026 21:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785534784; cv=none; b=F4gqj6t1kPzgTMZOR0H2BUg9c97KSiF1ecdZwBCREaTewG291d6Lb7MVijRyBYpo3y6HsfCUS5/pGHP7+1VRPquifWJgIx4SM3PbpNVY0sldOJuHZXqJNum4L2zjZZAZhRmAdDF1DzeG0tw1IzB+GWIIkm6G8y0XW20GduQ4XbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785534784; c=relaxed/simple;
	bh=1ip9lsBw+EzhjCNW3qE7t2aTNgbXGjjLuhJyXANJyRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IhNw1AbNp7FddJo92ztD53EeVjXgIRJdrC1xXUW3EJ6tEcHqPIOqyqqresPH80Eoj3rvKTyf3C5RP6dMFGSNMugmVmntA/K9Iu8BvjF9aV4fbNrGy+nTWXkinDuBMHdGaCaIb56RreBTTWUv5fJOIB1ZqX8b3lQTYoozJnIFBX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=luxVahaX; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="luxVahaX"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hBfvL4NxDzlfpMV;
	Fri, 31 Jul 2026 21:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785534776; x=1788126777; bh=oovCK
	gtl4eYb4ESfTIDLvY7gfvBD/vrRIAlgnN+Z3ug=; b=luxVahaXBcRq5822zgWAs
	mg/Ub+6ZBetY0mxMRI2DWo4D7sbtW+kXWLtjs/idx6I9S8szwbHUjxwmx94+bzQb
	QcyK5qkiv2ahiWtFD8Y1tU/PUs80fKGbUc51fogyi1yNM1HnKxn88EH7RHw+BJAF
	w7W7dTWJXQiQSp89DmnfV/GoasfsvsCguDDIB5qqCQS1Ikg2oacVjEINH6QQj8/P
	ug6zcaREXYiBfHbq+VtXUsOuHO6x3nZbtY/cOWW5zhVu5xb0+WocvKNsPkutEEU9
	Uk39B0MrDw3t5NIWkLjojk9wZbhJNK7nc5Pb2oH3/LdcE0oBlIcWdmut4fHQb3R0
	A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 18xqUb1w--On; Fri, 31 Jul 2026 21:52:56 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hBfvC480dzlfpMK;
	Fri, 31 Jul 2026 21:52:55 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v4 3/6] scsi: core: Pass the SCSI host pointer directly
Date: Fri, 31 Jul 2026 14:52:08 -0700
Message-ID: <0f417deef926f1574c555ec44fb2036e997a727c.1785534721.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
In-Reply-To: <68f3346cab2be570839350831f82b6c9233832ed.1785534721.git.bvanassche@acm.org>
References: <68f3346cab2be570839350831f82b6c9233832ed.1785534721.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

In the functions scsi_probe_and_add_lun(), scsi_sequential_lun_scan(),
scsi_report_lun_scan() and __scsi_scan_target() the SCSI host pointer is
derived from the SCSI target pointer. Pass the SCSI host pointer
directly. This patch prepares for enabling lock context analysis. No
functionality has been changed.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_scan.c | 47 ++++++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index e27da038603a..d7e0e9393194 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1169,6 +1169,7 @@ static unsigned char *scsi_inq_str(unsigned char *b=
uf, unsigned char *inq,
=20
 /**
  * scsi_probe_and_add_lun - probe a LUN, if a LUN is found add it
+ * @shost:      SCSI host pointer
  * @starget:	pointer to target device structure
  * @lun:	LUN of target device
  * @bflagsp:	store bflags here if not NULL
@@ -1188,7 +1189,8 @@ static unsigned char *scsi_inq_str(unsigned char *b=
uf, unsigned char *inq,
  *         attached at the LUN
  *   - SCSI_SCAN_LUN_PRESENT: a new scsi_device was allocated and initia=
lized
  **/
-static int scsi_probe_and_add_lun(struct scsi_target *starget,
+static int scsi_probe_and_add_lun(struct Scsi_Host *shost,
+				  struct scsi_target *starget,
 				  u64 lun, blist_flags_t *bflagsp,
 				  struct scsi_device **sdevp,
 				  enum scsi_scan_mode rescan,
@@ -1198,7 +1200,6 @@ static int scsi_probe_and_add_lun(struct scsi_targe=
t *starget,
 	unsigned char *result;
 	blist_flags_t bflags;
 	int res =3D SCSI_SCAN_NO_RESPONSE, result_len =3D 256;
-	struct Scsi_Host *shost =3D dev_to_shost(starget->dev.parent);
=20
 	/*
 	 * The rescan flag is used as an optimization, the first scan of a
@@ -1334,6 +1335,7 @@ static int scsi_probe_and_add_lun(struct scsi_targe=
t *starget,
=20
 /**
  * scsi_sequential_lun_scan - sequentially scan a SCSI target
+ * @shost:      SCSI host pointer
  * @starget:	pointer to target structure to scan
  * @bflags:	black/white list flag for LUN 0
  * @scsi_level: Which version of the standard does this device adhere to
@@ -1346,13 +1348,13 @@ static int scsi_probe_and_add_lun(struct scsi_tar=
get *starget,
  *
  *     Modifies sdevscan->lun.
  **/
-static void scsi_sequential_lun_scan(struct scsi_target *starget,
+static void scsi_sequential_lun_scan(struct Scsi_Host *shost,
+				     struct scsi_target *starget,
 				     blist_flags_t bflags, int scsi_level,
 				     enum scsi_scan_mode rescan)
 {
 	uint max_dev_lun;
 	u64 sparse_lun, lun;
-	struct Scsi_Host *shost =3D dev_to_shost(starget->dev.parent);
=20
 	SCSI_LOG_SCAN_BUS(3, starget_printk(KERN_INFO, starget,
 		"scsi scan: Sequential scan\n"));
@@ -1412,14 +1414,15 @@ static void scsi_sequential_lun_scan(struct scsi_=
target *starget,
 	 * sparse_lun.
 	 */
 	for (lun =3D 1; lun < max_dev_lun; ++lun)
-		if ((scsi_probe_and_add_lun(starget, lun, NULL, NULL, rescan,
-					    NULL) !=3D SCSI_SCAN_LUN_PRESENT) &&
+		if (scsi_probe_and_add_lun(shost, starget, lun, NULL, NULL,
+				rescan, NULL) !=3D SCSI_SCAN_LUN_PRESENT &&
 		    !sparse_lun)
 			return;
 }
=20
 /**
  * scsi_report_lun_scan - Scan using SCSI REPORT LUN results
+ * @shost: SCSI host pointer
  * @starget: which target
  * @bflags: Zero or a mix of BLIST_NOLUN, BLIST_REPORTLUN2, or BLIST_NOR=
EPORTLUN
  * @rescan: nonzero if we can skip code only needed on first scan
@@ -1438,8 +1441,9 @@ static void scsi_sequential_lun_scan(struct scsi_ta=
rget *starget,
  *     0: scan completed (or no memory, so further scanning is futile)
  *     1: could not scan with REPORT LUN
  **/
-static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags=
_t bflags,
-				enum scsi_scan_mode rescan)
+static int scsi_report_lun_scan(struct Scsi_Host *shost,
+			struct scsi_target *starget, blist_flags_t bflags,
+			enum scsi_scan_mode rescan)
 {
 	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
 	unsigned int length;
@@ -1448,7 +1452,6 @@ static int scsi_report_lun_scan(struct scsi_target =
*starget, blist_flags_t bflag
 	int result;
 	struct scsi_lun *lunp, *lun_data;
 	struct scsi_device *sdev;
-	struct Scsi_Host *shost =3D dev_to_shost(&starget->dev);
 	struct scsi_failure failure_defs[] =3D {
 		{
 			.sense =3D UNIT_ATTENTION,
@@ -1594,7 +1597,7 @@ static int scsi_report_lun_scan(struct scsi_target =
*starget, blist_flags_t bflag
 		} else {
 			int res;
=20
-			res =3D scsi_probe_and_add_lun(starget,
+			res =3D scsi_probe_and_add_lun(shost, starget,
 				lun, NULL, NULL, rescan, NULL);
 			if (res =3D=3D SCSI_SCAN_NO_RESPONSE) {
 				/*
@@ -1641,7 +1644,7 @@ struct scsi_device *__scsi_add_device(struct Scsi_H=
ost *shost, uint channel,
 		scsi_complete_async_scans();
=20
 	if (scsi_host_scan_allowed(shost) && scsi_autopm_get_host(shost) =3D=3D=
 0) {
-		scsi_probe_and_add_lun(starget, lun, NULL, &sdev,
+		scsi_probe_and_add_lun(shost, starget, lun, NULL, &sdev,
 				       SCSI_SCAN_RESCAN, hostdata);
 		scsi_autopm_put_host(shost);
 	}
@@ -1763,10 +1766,10 @@ int scsi_rescan_device(struct scsi_device *sdev)
 }
 EXPORT_SYMBOL(scsi_rescan_device);
=20
-static void __scsi_scan_target(struct device *parent, unsigned int chann=
el,
-		unsigned int id, u64 lun, enum scsi_scan_mode rescan)
+static void __scsi_scan_target(struct Scsi_Host *shost, struct device *p=
arent,
+			       unsigned int channel, unsigned int id, u64 lun,
+			       enum scsi_scan_mode rescan)
 {
-	struct Scsi_Host *shost =3D dev_to_shost(parent);
 	blist_flags_t bflags =3D 0;
 	int res;
 	struct scsi_target *starget;
@@ -1786,7 +1789,8 @@ static void __scsi_scan_target(struct device *paren=
t, unsigned int channel,
 		/*
 		 * Scan for a specific host/chan/id/lun.
 		 */
-		scsi_probe_and_add_lun(starget, lun, NULL, NULL, rescan, NULL);
+		scsi_probe_and_add_lun(shost, starget, lun, NULL, NULL, rescan,
+				       NULL);
 		goto out_reap;
 	}
=20
@@ -1794,14 +1798,15 @@ static void __scsi_scan_target(struct device *par=
ent, unsigned int channel,
 	 * Scan LUN 0, if there is some response, scan further. Ideally, we
 	 * would not configure LUN 0 until all LUNs are scanned.
 	 */
-	res =3D scsi_probe_and_add_lun(starget, 0, &bflags, NULL, rescan, NULL)=
;
+	res =3D scsi_probe_and_add_lun(shost, starget, 0, &bflags, NULL, rescan=
,
+				     NULL);
 	if (res =3D=3D SCSI_SCAN_LUN_PRESENT || res =3D=3D SCSI_SCAN_TARGET_PRE=
SENT) {
-		if (scsi_report_lun_scan(starget, bflags, rescan) !=3D 0)
+		if (scsi_report_lun_scan(shost, starget, bflags, rescan) !=3D 0)
 			/*
 			 * The REPORT LUN did not scan the target,
 			 * do a sequential scan.
 			 */
-			scsi_sequential_lun_scan(starget, bflags,
+			scsi_sequential_lun_scan(shost, starget, bflags,
 						 starget->scsi_level, rescan);
 	}
=20
@@ -1851,7 +1856,7 @@ void scsi_scan_target(struct device *parent, unsign=
ed int channel,
 		scsi_complete_async_scans();
=20
 	if (scsi_host_scan_allowed(shost) && scsi_autopm_get_host(shost) =3D=3D=
 0) {
-		__scsi_scan_target(parent, channel, id, lun, rescan);
+		__scsi_scan_target(shost, parent, channel, id, lun, rescan);
 		scsi_autopm_put_host(shost);
 	}
 	mutex_unlock(&shost->scan_mutex);
@@ -1882,11 +1887,11 @@ static void scsi_scan_channel(struct Scsi_Host *s=
host, unsigned int channel,
 				order_id =3D shost->max_id - id - 1;
 			else
 				order_id =3D id;
-			__scsi_scan_target(&shost->shost_gendev, channel,
+			__scsi_scan_target(shost, &shost->shost_gendev, channel,
 					order_id, lun, rescan);
 		}
 	else
-		__scsi_scan_target(&shost->shost_gendev, channel,
+		__scsi_scan_target(shost, &shost->shost_gendev, channel,
 				id, lun, rescan);
 }
=20
