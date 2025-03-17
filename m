Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63CF11ADC8F
	for <linux-scsi@vger.kernel.org>; Mon, 17 Mar 2025 16:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742229461; cv=none; b=C8gJWPYaigjDXG5N1Unn04cjEXWfNDGK2F3rFAXJ3vSISQ0SH7iM8zR/2H6s1dd5dKNvf+v5BPVkxOKnuUUQYcLAOKvGkVf4qZZetyq7MSqipYvxORVz/O+SoA6U0zqkuCrFQ9HjSSDTr+gDXaoH5mHR2G9w5VW5PTyAQEo5NEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742229461; c=relaxed/simple;
	bh=+zjMRwtnJoFYsTIrrOH49WYcLsdZmb34DFcwG8oz95I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FspUdkWVw8vO+7M6MyaIJDjlDcYZ1XDCSz8/kChQrzbN9ieTTt9fauml91XCQ1UTqw3XAAuSTJ/HhKyY0xPiboJJAGgUol1mabt7bK1hqz/9oUaIxElIrMm7LtQpUDf29m6QBY8ontNTSu6JNJyrXdJFZn4uFBYkgvy7n68BDxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ey4Jp5uB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ey4Jp5uB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742229457;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=JgCKR/jWI6a2eg3LR/tYG4alryPu/oPMyg/iDPvlsM4=;
	b=Ey4Jp5uBgKK6XckYW32ixsiLedqrubz8qJ/f7mQZLz7tEhoNHk+hPOaGpFHCJQ4C5GTq2C
	bj6DiZ86Q2IKiy9oMAeGQzaDzKDrH1GVHaTfGi+tSnw/2hBQnw/cPB78f+BhgMxsqaLduY
	F753B63/HqH3qUSydRsfjY3jCzNAffc=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-323-95lC8Bv-N0-Z2tdZk-mMWQ-1; Mon,
 17 Mar 2025 12:37:34 -0400
X-MC-Unique: 95lC8Bv-N0-Z2tdZk-mMWQ-1
X-Mimecast-MFC-AGG-ID: 95lC8Bv-N0-Z2tdZk-mMWQ_1742229453
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 967701955E98;
	Mon, 17 Mar 2025 16:37:33 +0000 (UTC)
Received: from emilne-na.westford.csb (unknown [10.17.16.209])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AEA1619560AD;
	Mon, 17 Mar 2025 16:37:32 +0000 (UTC)
From: "Ewan D. Milne" <emilne@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: dick.kennedy@broadcom.com,
	james.smart@broadcom.com,
	justin.tee@broadcom.com
Subject: [PATCH] scsi: lpfc: restore clearing of NLP_UNREG_INP in ndlp->nlp_flag
Date: Mon, 17 Mar 2025 12:37:31 -0400
Message-ID: <20250317163731.356873-1-emilne@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Commit "scsi: lpfc: Remove NLP_RELEASE_RPI flag from nodelist structure"
introduced a regression with SLI-3 adapters (e.g. LPe12000 8Gb) where
a Link Down / Link Up such as caused by disabling an host FC switch port
would result in the devices remaining in the transport-offline state
and multipath reporting them as failed.  This problem was not seen with
newer SLI-4 adapters.

The problem was caused by portions of the patch which removed the functions
__lpfc_sli_rpi_release() and lpfc_sli_rpi_release() and all their callers.
This was presumably because with the removal of the NLP_RELEASE_RPI flag
there was no need to free the rpi.

However, __lpfc_sli_rpi_release() and lpfc_sli_rpi_release() which calls it
reset the NLP_UNREG_INP flag. And, lpfc_sli_def_mbox_cmpl() has a path
where __lpfc_sli_rpi_release() was called in a particular case where
NLP_UNREG_INP was not otherwise cleared because of other conditions.

Restoring the else clause of this conditional and simply clearing the
NLP_UNREG_INP flag appears to resolve the problem with SLI-3 adapters.
It should be noted that the code path in question is not specific to SLI-3,
but there are other SLI-4 code paths which may have masked the issue.

Fixes: 32566a6f1ae5 ("scsi: lpfc: Remove NLP_RELEASE_RPI flag from nodelist structure")
Cc: stable@vger.kernel.org
Tested-by: Marco Patalano <mpatalan@redhat.com>
Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 3fd9723cd271..92f3d4423729 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -2923,6 +2923,8 @@ lpfc_sli_def_mbox_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 				clear_bit(NLP_UNREG_INP, &ndlp->nlp_flag);
 				ndlp->nlp_defer_did = NLP_EVT_NOTHING_PENDING;
 				lpfc_issue_els_plogi(vport, ndlp->nlp_DID, 0);
+			} else {
+				clear_bit(NLP_UNREG_INP, &ndlp->nlp_flag);
 			}
 
 			/* The unreg_login mailbox is complete and had a
-- 
2.45.2

