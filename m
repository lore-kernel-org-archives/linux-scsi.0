Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD1A29345D;
	Mon,  5 May 2025 22:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746484620; cv=none; b=Gr1o+EVMIX6vS/hpL5Gn7aqSCUHRdL+IoXO5cb6daeMAZgQUld9qKWKEGPsV+tCxNnYh1KGGVb6LznKE5BkCY4cg9WdTs09CZgVw2+k1dInMUQ2wioJu/1kECAZZ+fAn746JAOyTp0Q1jQDHNXZk1o05Z1xndquyBw2LYg99nUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746484620; c=relaxed/simple;
	bh=8LTGkNLc5YdbaSd8snXO+EkqkMFRHJLMNMHHjI9/bgc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mzbuEWvKnXs/jENiQeu7S7arRVq4C6i0DeAvLd141kYlg4DuA4SN/VIw9k91ZlS7Ln5/+ne24+8Dris826ZpJ1H+KUUhxcUQrkyKudC0Bw+fp9TZjhgR/ibkYTCkgn8pg7DuurCMKps+yXGBKKNzr23UvnWd5x6nW1sXamlLrlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hawgVMYC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hawgVMYC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A15B3C4CEE4;
	Mon,  5 May 2025 22:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746484619;
	bh=8LTGkNLc5YdbaSd8snXO+EkqkMFRHJLMNMHHjI9/bgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hawgVMYC1QdXB6qpqmXhGwC+qIe9KFcF1c/V5yi4fgQiTmS50ioyb+JO9wK1eLiKB
	 z4WuDqBDzpD3Ssuc0VkRnVRZFJDYJbY3+kYpv3kAx4bAtzJgs7QMWOa5/HIvWR+RtC
	 3gepOhGGOUiduwEGi4O8lBmc7GGAodBJ6CNJXlcOLnV06+vhPZru63dzi3Uqy64AIr
	 wZQpfY4og22alv1Po66CrTsbUKjMUYci391fHatGHt8ZBiOAf9lkEM8ttzl0Nrv8CV
	 x21W1sWYd3Vn37GS1ZDteKjLJiuXVNEcdKsFMD3ryHcwlVj2+E+zsHhiIkOFK4UbSo
	 mQZ+aH7zmBrZw==
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
Subject: [PATCH AUTOSEL 6.14 565/642] scsi: lpfc: Ignore ndlp rport mismatch in dev_loss_tmo callbk
Date: Mon,  5 May 2025 18:13:01 -0400
Message-Id: <20250505221419.2672473-565-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505221419.2672473-1-sashal@kernel.org>
References: <20250505221419.2672473-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.5
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
index 45d268d49060e..07cd611f34bd5 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -228,10 +228,16 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
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

