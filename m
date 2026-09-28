Received: from mail-dy2-f43.google.com (mail-dy2-f43.google.com [74.125.229.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA604E50BF
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 17:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790618093; cv=none; b=JpYGNLztGRk3Hn5KWRpC/+1bsVAiSvfFFo57iGdD0kBYo/c7p045DNDunqjaSXGYOsgW5J07AU3yu+e9jYhGkUilbMaHjRDrUYbnqOgKdjnMEEqqhaNKwzuWNFbMWfsCZrih4NoGkV7/JpuRv0YqIb+mD+/cMBuRCmqosFHk6bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790618093; c=relaxed/simple;
	bh=4g9LB1Elq4AWDSZRLkj7+f9uRCd1aVgGHY2gPihztT0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=krguvNz6GTnD0V7Ntj7ZEL6uSDiem9TfHnpJDnowgr81fCNlFJccEabYVGvpj4xMmgypwAoybhebbwPvh8dKKCdriw9z//dl7cpf6wVs2wR1vfKj7/SuXgefvHuExVTnSuH3FLy20CM723Jvp5ZgS9Mjdc9EPeUY+tIam7PuLNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ApDdhyTc; arc=none smtp.client-ip=74.125.229.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ApDdhyTc"
Received: by mail-dy2-f43.google.com with SMTP id 5a478bee46e88-33e46a156f4so1880859eec.0
        for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 10:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790618091; x=1791222891; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=W5vMK2oZztz9uc2ethBOyt/7g5II8co/MONK3cmBCVA=;
        b=ApDdhyTcDWCxeR5cCutNr2xcmsVcaKB5bXcAVV1kmGMBTLTv/GLlkU9036ozLPThTr
         0qK+LjMr755M3ZRCNyN4Ni3MA92E8OWqcFzsBdAJ/xbKZNANhf1EpjqvGjIuRfzeVLUs
         3RbKx2cnD2A0aYz3cHeZGTh7PCsnWGsXh7rFylp5a6e1+io+McR4vM75Zsnm1bDX1tQ2
         dR4OxUOYzvOQddoaPo36QjgIdcf9VgrZ0XUEyypWyRKS93PYil8k8UNET7jA/G+ekm2/
         15102H/0Bp6ZaXHwoTYj3UJ1V+v3GdMuTVjyh9KIbpKI7vX5gTgMKtxPSjq5yrVFKM4P
         smtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790618091; x=1791222891;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=W5vMK2oZztz9uc2ethBOyt/7g5II8co/MONK3cmBCVA=;
        b=tWipN8RVpvbcZyJnR+3QawaEXDBn8/mPaAo7q8t6dRksGBy+gr1iCm8IC5GZUVXsQO
         MesJK5hS9JsBoXbbpL5dZMNnYPYQIuatJTdb6URqQt2w/GTHzqe7OuA8lW8GS3GPVnAR
         +CCR2rQLJoAn8FTG+Qgh3z6vd8uYBKAwhQK/dQF7xUyVAq7LnyUdo76A8TsXZb7KUSt/
         R035tXq0vGK+e7Iisn2ncXNRZcbI9AdsXeztrjOaFfJInq3SvUDcHAlIsZVNVYFNOo1e
         jK+m9jxyQ5fdNwKHq/S4tCKJ6lyozcL01lDDuHK3zGNIe0Bkwfo3UcW4DNUT/zVnkeGX
         EbWg==
X-Gm-Message-State: AFuF++mjbIpMU+Z5+kueq9YvTlVtc/U6zfKYLYDwNEnAIKRNWmX4Qihm
	8H8xLp+u2V8UapNmtPzxhWx3KKzFrgTSo7FEO1nEIFguZQrwa3tlO0N99qS9VsKd
X-Gm-Gg: AYBFou1fX0iqERT996J69YCDJFMEc54gJm/gCptJ+7Dk4CUKx5/9/yKbAtuVKlUeOT7
	GiFc2bkCfF3SYwoAldVLWld5MUaRkMg0tJCaahlwFtGZ4qy+DXj3wkItivard/rTBm5qnxVT5in
	IG4LVgO1Ob5sz5tHRM8Pmi30xqsmStRcVGtIYVg2DtiWyk7weWy0GULtf5EuDrolo/OGPX66fT9
	HDQQN5MC5KRNViaudvJk9mRMxYKeTAS3SE6JtrYW1LrkN1BVLnHJY4F0j1Omb2WphDY0xQEbYbB
	CmxXsH4+G4y+m750wcqMPCzQ1Bk6NQod6e7D1cKw6Vu6JvthfLMXgpDQZRcA92ucsjBbj73Yces
	yjTUaVO0lglEs/nWACtcY9k7RwBcGI0hOMiaZa74uRNGeoYwxVSzMuL6+7vebEj18mRibSvRuoH
	P46ALeBKKXASve/3Qwe6S0Xpgrr2XldjjmGSC6d4tKPkk2PvSSquuW7DEWbMlnN7l+2o6ZsV6Rq
	nyPi6YKxk8D/+EuaEyi4qAEsdtpcC0Lc3HtqWjVan4EmGZMhdgZqeMVVBDMy3Fa6TeA
X-Received: by 2002:a05:7300:b90a:b0:343:4dcc:d29a with SMTP id 5a478bee46e88-3434dcce606mr12547077eec.28.1790618090745;
        Mon, 28 Sep 2026 10:54:50 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-342c9c245a7sm21189418eec.11.2026.09.28.10.54.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Sep 2026 10:54:50 -0700 (PDT)
From: Nigel Kirkland <nkirkland2304@gmail.com>
To: linux-scsi@vger.kernel.org,
	nigel.kirkland@broadcom.com
Cc: paul.ely@broadcom.com,
	nkirkland2304@gmail.com
Subject: [PATCH v5 02/10] lpfc: Early return out of lpfc_els_abort when HBA_SETUP flag is not set
Date: Mon, 28 Sep 2026 11:17:49 -0700
Message-Id: <20260928181757.21959-3-nkirkland2304@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260928181757.21959-1-nkirkland2304@gmail.com>
References: <20260928181757.21959-1-nkirkland2304@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It is possible that a dev_loss_tmo callback fires during an hba reset.
The ELS pring structure is cleared by the hba reset path and the
dev_loss_tmo callback executing lpfc_els_abort could be using a stale ELS
pring pointer. To significantly reduce exposure, check if HBA_SETUP flag is set
before proceeding to use the ELS pring pointer in lpfc_els_abort. There is
no point to issue aborts when the sli port is not setup anyways.

Signed-off-by: Nigel Kirkland <nkirkland2304@gmail.com>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 9c449055a55e..2c8d995a45bf 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -227,6 +227,11 @@ lpfc_els_abort(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 	struct lpfc_iocbq *iocb, *next_iocb;
 	int retval = 0;
 
+	/* Exit early to prevent race with queue teardown. */
+	if (unlikely(phba->sli_rev == LPFC_SLI_REV4 &&
+		     !test_bit(HBA_SETUP, &phba->hba_flag)))
+		return;
+
 	pring = lpfc_phba_elsring(phba);
 
 	/* In case of error recovery path, we might have a NULL pring here */
-- 
2.38.0

