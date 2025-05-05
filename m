Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1411D3679AD;
	Mon,  5 May 2025 22:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746485720; cv=none; b=rJMRev8QP31MmJg/dIUjhQS6QbLNFwCgliZdzuq4fe8t3ZRstP6mBGVDvRGQr18Q6B+6E3+5K7aA9bx6SPnmmEDO3E/bBHEWgMJPANHH4WGxIYvQ+ENEsoiNL+WcF5M2gMRg3utK7oRZ1uCVqa/6kaAla8z5iQSXGThn0nGeAnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746485720; c=relaxed/simple;
	bh=l8Zy72d4X/xvqkb6aby5A1P3K5rRonIL80CZhWrtsPc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=V4FVysy+QTNihSlIbUsrLxudSeLGTWxJLxhGJaeisdiOnwiW29cd/YfqIQB22akyzpSWZAVtbNF4xB28Q+0HNwfLiR6vOXyRkkGT3hTiqLP20T/8rY9pHasrwD76zcZ3nGPMAxE/2974txZuGBpByzKsnCn3LfCmiGv8yDVaPKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U2filjIY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U2filjIY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8779C4CEEE;
	Mon,  5 May 2025 22:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746485720;
	bh=l8Zy72d4X/xvqkb6aby5A1P3K5rRonIL80CZhWrtsPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U2filjIY7nQ6SSK7BxCoqNyYQHLb1dhGeLrQTM4VSB933uSjQKBWvb9+W/92CWwox
	 04/zkSj6mCErmeR4MK2UzdhkvYZcdJaJKu1gDVIGHsfQy82/p4NCK7UtTWJHzZcSMb
	 0FDXQF0bOcRLxzkXrW6Sc7KdnkrubE1zZZgUwgl87ocfxL700KlR5OH6UFwGDpEsyX
	 qk38tkYqxIq49OT4gZraAZqOACducrLvgJAw03JVn0w2ak4sHuPwaIBmna1KgEBqh1
	 VRYTnVdYxo0IHIbp+ohHCEpNPOhwWFc0CLZGT9wqMbxOqlfDZsTDggk+dOlWRtbJp+
	 XyI1fgs5QfV5A==
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
Subject: [PATCH AUTOSEL 6.12 442/486] scsi: lpfc: Ignore ndlp rport mismatch in dev_loss_tmo callbk
Date: Mon,  5 May 2025 18:38:38 -0400
Message-Id: <20250505223922.2682012-442-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505223922.2682012-1-sashal@kernel.org>
References: <20250505223922.2682012-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.26
Content-Transfer-Encoding: 8bit

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit 23ed62897746f49f195d819ce6edeb1db27d1b72 ]

With repeated port swaps between separate fabrics, there can be multiple
registrations for fabric well known address 0xfffffe.  This can cause ndlp
reference confusion due to the usage of a single ndlp ptr that stores the
rport object in fc_rport struct private storage during transport
registration.  Subsequent registrations update the ndlp->rport field with
the newer rport, so when transport layer triggers dev_loss_tmo for the
earlier registered rport the ndlp->rport private storage is referencing the
newer rport instead of the older rport in dev_loss_tmo callbk.

Because the older ndlp->rport object is already cleaned up elsewhere in
driver code during the time of fabric swap, check that the rport provided
in dev_loss_tmo callbk actually matches the rport stored in the LLDD's
ndlp->rport field.  Otherwise, skip dev_loss_tmo work on a stale rport.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20250131000524.163662-4-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 31dcabebc9b6d..f2e4237ff3d99 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -227,10 +227,16 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 	if (ndlp->nlp_state == NLP_STE_MAPPED_NODE)
 		return;
 
-	/* check for recovered fabric node */
-	if (ndlp->nlp_state == NLP_STE_UNMAPPED_NODE &&
-	    ndlp->nlp_DID == Fabric_DID)
+	/* Ignore callback for a mismatched (stale) rport */
+	if (ndlp->rport != rport) {
+		lpfc_vlog_msg(vport, KERN_WARNING, LOG_NODE,
+			      "6788 fc rport mismatch: d_id x%06x ndlp x%px "
+			      "fc rport x%px node rport x%px state x%x "
+			      "refcnt %u\n",
+			      ndlp->nlp_DID, ndlp, rport, ndlp->rport,
+			      ndlp->nlp_state, kref_read(&ndlp->kref));
 		return;
+	}
 
 	if (rport->port_name != wwn_to_u64(ndlp->nlp_portname.u.wwn))
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
-- 
2.39.5

