Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296E42139AC
	for <linux-scsi@vger.kernel.org>; Thu, 27 Jun 2024 20:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719518484; cv=none; b=jJCAvBUbX6z5erLw7DA3yPpsu8VWdJ2oCJnyxQz+ObYtszsdxL05bYGhlNOcwXN6rV/1/PUrFb/fBp5hXLTX/jzt9DDqIC1NbY3Mx5fJUswNHThuzatAf9V2V1Qdkwg+kHj9AqgBxqXIoiQs7rlP1e7NHoTI57hXXAS77s/V018=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719518484; c=relaxed/simple;
	bh=mI/VLaLXE+ikgj0plpNTsJl5hjqAMj/p67no7inxiy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r+Tt9wR/28QTuU7A4uvDM8EDdBSFW46TiLGT9ofFDSThRDpDX+Xt5WT5/DcBkiXiu+0fGMJu29iZnVyGjFu5KzWY+1tDYi73IUdDHwZgFNCUhOJpZ+dAp6mlhK0nOCuPxXA92KmjG1SxYAJQ6ciF+YWTUrHAOsvZH4loosjzhj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=wd3TOzrP; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="wd3TOzrP"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4W98b64f3Szll9bw;
	Thu, 27 Jun 2024 20:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1719518475; x=1722110476; bh=LLAf6
	j958tUPL7FLJ5lCn3fYqs8gcr/tbTW1Lg3olrA=; b=wd3TOzrPKm5dxHBT7PxxR
	vqzDJFJWZ4Lo4L3O1mb2KBGYH5UymWK6pFAVVOWzTdSqp929s1BRDqZI6tt0lsN7
	+AKL483+MPMnL4SyqY/ApP3JGjJ/kv+wu1v7wG0/zVoW7LPjXTK1417ctvxljDP0
	Vwmn37Z4mjCbFqp/GjMhWONYGn2GOStlQpMZvOCmgxGyXfHiXsgq2CNUu6TEv2zy
	1K/JMsAnjKlhhqCBRBisOdAcfyHHYFj3eZKizrd6iLfdrFd5mhbJu/wMuaEMgMGH
	0aL0fpFAniBEUmLGFVu0Qfs1bogFD8T+Szr/d+1DnMgrul2QX3KXMuWiOvJs2dD8
	w==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id UOgpwT4Xyu_J; Thu, 27 Jun 2024 20:01:15 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4W98Zv5B55zll9bx;
	Thu, 27 Jun 2024 20:01:11 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Daejun Park <daejun7.park@samsung.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Minwoo Im <minwoo.im@samsung.com>,
	Stanley Jhu <chu.stanley@gmail.com>,
	ChanWoo Lee <cw9316.lee@samsung.com>,
	Yang Li <yang.lee@linux.alibaba.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Avri Altman <avri.altman@wdc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v2 7/7] scsi: ufs: Make .get_hba_mac() optional
Date: Thu, 27 Jun 2024 12:58:33 -0700
Message-ID: <20240627195918.2709502-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.803.g4e1b14247a-goog
In-Reply-To: <20240627195918.2709502-1-bvanassche@acm.org>
References: <20240627195918.2709502-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

UFSHCI controllers that are compliant with the UFSHCI 4.0 standard report
the maximum number of supported commands in the controller capabilities
register. Use that value if .get_hba_mac =3D=3D NULL.

Reviewed-by: Daejun Park <daejun7.park@samsung.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufs-mcq.c | 15 +++++++++------
 include/ufs/ufshcd.h       |  4 +++-
 include/ufs/ufshci.h       |  1 +
 3 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 0482c7a1e419..f4cc4b0676f7 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -138,18 +138,21 @@ EXPORT_SYMBOL_GPL(ufshcd_mcq_queue_cfg_addr);
  *
  * MAC - Max. Active Command of the Host Controller (HC)
  * HC wouldn't send more than this commands to the device.
- * It is mandatory to implement get_hba_mac() to enable MCQ mode.
  * Calculates and adjusts the queue depth based on the depth
  * supported by the HC and ufs device.
  */
 int ufshcd_mcq_decide_queue_depth(struct ufs_hba *hba)
 {
-	int mac =3D -EOPNOTSUPP;
+	int mac;
=20
-	if (!hba->vops || !hba->vops->get_hba_mac)
-		goto err;
-
-	mac =3D hba->vops->get_hba_mac(hba);
+	if (!hba->vops || !hba->vops->get_hba_mac) {
+		hba->capabilities =3D
+			ufshcd_readl(hba, REG_CONTROLLER_CAPABILITIES);
+		mac =3D hba->capabilities & MASK_TRANSFER_REQUESTS_SLOTS_MCQ;
+		mac++;
+	} else {
+		mac =3D hba->vops->get_hba_mac(hba);
+	}
 	if (mac < 0)
 		goto err;
=20
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index d4d63507d090..d32637d267f3 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -325,7 +325,9 @@ struct ufs_pwr_mode_info {
  * @event_notify: called to notify important events
  * @reinit_notify: called to notify reinit of UFSHCD during max gear swi=
tch
  * @mcq_config_resource: called to configure MCQ platform resources
- * @get_hba_mac: called to get vendor specific mac value, mandatory for =
mcq mode
+ * @get_hba_mac: reports maximum number of outstanding commands supporte=
d by
+ *	the controller. Should be implemented for UFSHCI 4.0 or later
+ *	controllers that are not compliant with the UFSHCI 4.0 specification.
  * @op_runtime_config: called to config Operation and runtime regs Point=
ers
  * @get_outstanding_cqs: called to get outstanding completion queues
  * @config_esi: called to config Event Specific Interrupt
diff --git a/include/ufs/ufshci.h b/include/ufs/ufshci.h
index 8d0cc73537c6..38fe97971a65 100644
--- a/include/ufs/ufshci.h
+++ b/include/ufs/ufshci.h
@@ -68,6 +68,7 @@ enum {
 /* Controller capability masks */
 enum {
 	MASK_TRANSFER_REQUESTS_SLOTS_SDB	=3D 0x0000001F,
+	MASK_TRANSFER_REQUESTS_SLOTS_MCQ	=3D 0x000000FF,
 	MASK_NUMBER_OUTSTANDING_RTT		=3D 0x0000FF00,
 	MASK_TASK_MANAGEMENT_REQUEST_SLOTS	=3D 0x00070000,
 	MASK_EHSLUTRD_SUPPORTED			=3D 0x00400000,
