Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126135478E
	for <linux-scsi@vger.kernel.org>; Wed, 16 Oct 2024 21:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729113153; cv=none; b=jNoxILzN79C9mlhVcwqmTKq3dDl+RsZnWjLzKpgnIju8w7+H3m+PiHmxYpmMZFf6MN3YIMEJNr8DH43vCWo/CRHCDhjW0pR36nZhcJNQDNBZSLSqjGmCudHrm1DfXxwF1PFj4nSrmBG0pLOdYvlh9yf/1F3fpTl+4snocvnbLgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729113153; c=relaxed/simple;
	bh=lLTwkuh7N9doUUCx86jYTBjOPmNXhUQP3v3fF0opHlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UaXsiY46eHhQnxGIm8OnWKdYnV2U4vJWnU3FMj8OiqnXoqmYT4MS2QvYhX5iInYI+JseDmOqXSEw8efWqHWugqMVO9sFrX+fje6gkcIhfWMJFB/tk5mljfTJ9Co95ZUGhjn2dvxrk9uO7KswxNfpirLQK6yUZyFn3g36NIos5bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Zyq8B5wU; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Zyq8B5wU"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XTNvz4TqXzlgTWP;
	Wed, 16 Oct 2024 21:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1729113147; x=1731705148; bh=uJCuw
	gswvqXnoAl5hmqAkiv+YbhAKq6vLarB/lFbeSI=; b=Zyq8B5wUgFOHmkCnzIjh0
	LRmWZmBHKvduTWfHOlQ4vMscXOBfGNtrvRIx7jrizkxG0+mC8XBkWp2X28EKJl8P
	c8n3LhtiiSRLlebFBQkx8yn1zUw33WGCVAprV5YbvZ/HB6lBorqmxs4bFjnynLvo
	auWSdeltohhMxLGX47Jyoj+ZfO3czczm6MNnxkhj9hmD2DC6tiIxi25n/nShWJJB
	m+9TxB+3Oel3HKLmjLyBqxx1Sc1FWVeNwe5q+vEcFkkZC2gzHCfvC1CAqR4vyKVO
	g48kY1F1JNhd3I+pQ+Df20aTrtFPmiJKFIet1XXIUA7JSvho8I69IscTn0jEjq9N
	g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 6IWzXs2iXM9y; Wed, 16 Oct 2024 21:12:27 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XTNvs2LtpzlgMVr;
	Wed, 16 Oct 2024 21:12:25 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	Bean Huo <beanhuo@micron.com>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>
Subject: [PATCH 3/7] scsi: ufs: core: Simplify ufshcd_try_to_abort_task()
Date: Wed, 16 Oct 2024 14:11:14 -0700
Message-ID: <20241016211154.2425403-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
In-Reply-To: <20241016211154.2425403-1-bvanassche@acm.org>
References: <20241016211154.2425403-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

The MCQ code is also valid for legacy mode. Hence, remove the legacy
mode code and retain the MCQ code. Since it is not an error if a command
completes while ufshcd_try_to_abort_task() is in progress, use dev_info()
instead of dev_err() to report this.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 32 ++++++++------------------------
 1 file changed, 8 insertions(+), 24 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 57ce1910fda0..76884df580c3 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7489,7 +7489,6 @@ int ufshcd_try_to_abort_task(struct ufs_hba *hba, i=
nt tag)
 	int err;
 	int poll_cnt;
 	u8 resp =3D 0xF;
-	u32 reg;
=20
 	for (poll_cnt =3D 100; poll_cnt; poll_cnt--) {
 		err =3D ufshcd_issue_tm_cmd(hba, lrbp->lun, lrbp->task_tag,
@@ -7504,32 +7503,17 @@ int ufshcd_try_to_abort_task(struct ufs_hba *hba,=
 int tag)
 			 * cmd not pending in the device, check if it is
 			 * in transition.
 			 */
-			dev_err(hba->dev, "%s: cmd at tag %d not pending in the device.\n",
+			dev_info(
+				hba->dev,
+				"%s: cmd with tag %d not pending in the device.\n",
 				__func__, tag);
-			if (hba->mcq_enabled) {
-				/* MCQ mode */
-				if (ufshcd_cmd_inflight(lrbp->cmd)) {
-					/* sleep for max. 200us same delay as in SDB mode */
-					usleep_range(100, 200);
-					continue;
-				}
-				/* command completed already */
-				dev_err(hba->dev, "%s: cmd at tag=3D%d is cleared.\n",
-					__func__, tag);
+			if (!ufshcd_cmd_inflight(lrbp->cmd)) {
+				dev_info(hba->dev,
+					 "%s: cmd with tag=3D%d completed.\n",
+					 __func__, tag);
 				return 0;
 			}
-
-			/* Single Doorbell Mode */
-			reg =3D ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
-			if (reg & (1 << tag)) {
-				/* sleep for max. 200us to stabilize */
-				usleep_range(100, 200);
-				continue;
-			}
-			/* command completed already */
-			dev_err(hba->dev, "%s: cmd at tag %d successfully cleared from DB.\n"=
,
-				__func__, tag);
-			return 0;
+			usleep_range(100, 200);
 		} else {
 			dev_err(hba->dev,
 				"%s: no response from device. tag =3D %d, err %d\n",
