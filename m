Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B2C3679D9;
	Mon,  5 May 2025 22:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746485719; cv=none; b=e2PQQTEDZkY/yUE8UP3qnNVzIYLOdLQKSFlZbR/ez9ncN0N01czkc0JFxwhqK8YdVltLMo8rGJRv4aT9zXzaNEVONnxClBSUYw/0+gmSyBQOsfgcrUMGFpFoHcqdZoAblIt22XVDrzKknYSisiXtQPaQrp/tQpg/77tS41RZUtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746485719; c=relaxed/simple;
	bh=dYFiojUUXBACEeNTTadNaDNxVu7HjpYUe1/WEBsn/7E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aIBUkQ21udKlvLVQ7UVNdkBbTtcA5efYzahcVTfKvEF/+Vo0G4tHiaUYlVJB0dMKfDxBxfZPuJokvjyiZNnwqrR2k5I6YibhRaKL3A/a2p/WVg6da4rCLKDGwrWRC7GMU3LvNr6jsTS6fleAEk/gQLSYyPiw9ke08Q9DywWU32c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kPbFLHGy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kPbFLHGy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B9DAC4CEE4;
	Mon,  5 May 2025 22:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746485718;
	bh=dYFiojUUXBACEeNTTadNaDNxVu7HjpYUe1/WEBsn/7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kPbFLHGyrdgyVatp1wx4IxqYZ+bW5FClTFZOYAdYGXr8zooWEf1FZST4yppzr9jp2
	 2Du2e/rUcyg15lv7fFbgycubRoz2qrz8APRek5vzY4ka7QZNQWWT+GnCqYjdqLndbD
	 i9Cmhkyq7G8fFviNtLL/IjN6sWbK6se5oFdYI6rShMFVXJJMqi3zLdHTuMHZoTuiVz
	 V63Oc8UIv7Va4htobyURxh5tYwsQHvD+pZGZVIIoXd6RK4Xpik9KX7WYUGf+MqD/RO
	 6e8XYmAa1EusQ7saYUObBYpQSqkXV77JLdkFb6/Yzi69+wOJ0JmvHxNKBOqfxe7xH7
	 N03AmJrEytXCA==
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
Subject: [PATCH AUTOSEL 6.12 441/486] scsi: lpfc: Handle duplicate D_IDs in ndlp search-by D_ID routine
Date: Mon,  5 May 2025 18:38:37 -0400
Message-Id: <20250505223922.2682012-441-sashal@kernel.org>
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
index 6e8d8a96c54fb..31dcabebc9b6d 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -5622,6 +5622,7 @@ static struct lpfc_nodelist *
 __lpfc_findnode_did(struct lpfc_vport *vport, uint32_t did)
 {
 	struct lpfc_nodelist *ndlp;
+	struct lpfc_nodelist *np = NULL;
 	uint32_t data1;
 
 	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
@@ -5636,14 +5637,20 @@ __lpfc_findnode_did(struct lpfc_vport *vport, uint32_t did)
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

