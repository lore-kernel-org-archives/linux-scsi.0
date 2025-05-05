Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755FA3C10D3;
	Mon,  5 May 2025 23:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487440; cv=none; b=As0Apmf8X5Adzpa42YOv87kpfZ258ZyUrOXqgQLMI+K16e+9wjR3R01H/P37AsTYRoLCj1UowjewgkiYZ0+bSfoxgQkwjAHeifpYEX4DEqwtKfoAMztssw58noZe6UPhzw3bqaS5ochOByghts84jGN3mV1YefU2t+eVR6lbAOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487440; c=relaxed/simple;
	bh=5FHVkciLYMbBd8XlPHAl2XYzPawIaEyJ4RSuwnbM2RM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UDtZ/cxnn/Z/yFlsiyMJp2gjeboH2nnzYEGmvO3f900j7bfep2OGdiUvVxT8lm9mDPYr9vfL6Mx8OsBjs03r9nHV7vTDt4mckA14J9XMG6Mpdrv5G9Bxqqjn6nIjUADNoJsiiXZUZQIoEYhVj2iyBx/0L3CAK3zxdBH+2BkrCIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jPX0B9/d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jPX0B9/d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09077C4CEEF;
	Mon,  5 May 2025 23:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746487439;
	bh=5FHVkciLYMbBd8XlPHAl2XYzPawIaEyJ4RSuwnbM2RM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jPX0B9/d2siMpy8dvfzSx02+dzjlnRekPbs3aHXS1R2/bGajlILM/GEjbB9frA12w
	 WK47Ea95IaWWkn26ic0RUmA8wU12Is2Tvo+K8hNUA5HoALFOLQTT53hgdx1e+GmCU0
	 CRlBDafFmf2gQh4tX46FqQOz13WKrJi2aWTYnx9icSW/NIUvxmoszfVcvVakf/bs2W
	 bJ4e8DVZbOgamqhSZ8ZZFX4gUP72jsCnatzkSW+BCcd48jZRwFU5OuWgiywrd8l8nT
	 KET6sS7ZOGujfhKdj70+CKxoQcRoGVCud93oQkDNLwGvqKNwl3qq0GDpUwN75Xc58H
	 gyXViRC/pjh+A==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Justin Tee <justin.tee@broadcom.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	james.smart@broadcom.com,
	dick.kennedy@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 72/79] scsi: lpfc: Handle duplicate D_IDs in ndlp search-by D_ID routine
Date: Mon,  5 May 2025 19:21:44 -0400
Message-Id: <20250505232151.2698893-72-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505232151.2698893-1-sashal@kernel.org>
References: <20250505232151.2698893-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.4.293
Content-Transfer-Encoding: 8bit

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit 56c3d809b7b450379162d0b8a70bbe71ab8db706 ]

After a port swap between separate fabrics, there may be multiple nodes in
the vport's fc_nodes list with the same fabric well known address.
Duplication is temporary and eventually resolves itself after dev_loss_tmo
expires, but nameserver queries may still occur before dev_loss_tmo.  This
possibly results in returning stale fabric ndlp objects.  Fix by adding an
nlp_state check to ensure the ndlp search routine returns the correct newer
allocated ndlp fabric object.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20250131000524.163662-5-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 0abce779fbb13..3238222b89fa8 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -5357,6 +5357,7 @@ static struct lpfc_nodelist *
 __lpfc_findnode_did(struct lpfc_vport *vport, uint32_t did)
 {
 	struct lpfc_nodelist *ndlp;
+	struct lpfc_nodelist *np = NULL;
 	uint32_t data1;
 
 	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
@@ -5371,14 +5372,20 @@ __lpfc_findnode_did(struct lpfc_vport *vport, uint32_t did)
 					 ndlp, ndlp->nlp_DID,
 					 ndlp->nlp_flag, data1, ndlp->nlp_rpi,
 					 ndlp->active_rrqs_xri_bitmap);
-			return ndlp;
+
+			/* Check for new or potentially stale node */
+			if (ndlp->nlp_state != NLP_STE_UNUSED_NODE)
+				return ndlp;
+			np = ndlp;
 		}
 	}
 
-	/* FIND node did <did> NOT FOUND */
-	lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
-			 "0932 FIND node did x%x NOT FOUND.\n", did);
-	return NULL;
+	if (!np)
+		/* FIND node did <did> NOT FOUND */
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
+				 "0932 FIND node did x%x NOT FOUND.\n", did);
+
+	return np;
 }
 
 struct lpfc_nodelist *
-- 
2.39.5

