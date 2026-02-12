Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7732E2ED84C
	for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 20:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770929742; cv=none; b=eEKn2QbKb6rvvdID1AEEQlZFw1r1Hn09c0P/253/FJldrxuisILXez9iNX+ehtAdezvdGE7Ri7C6CHdTYL0Z9TNOLYlrbPx5OoRc1krOJMfTCsJsAIVA5Pp1ImDcv4oFH5t+nvLY7SiMzM7vSxpzT4lQFqm6a3ygrF1JDHamvpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770929742; c=relaxed/simple;
	bh=Ivv0zj28P1I0Ep+H+80TNMjN0tFf1A/7QprVylhho18=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EJ1kjozawPqdUjf48btr+/H7A7gkdzCt0ghUnEQWl0+FrzCIsFh8nCFy67XKfGBypOkRXNvBd50+MRGPCjo44kQNEinlFZ1wyeh5hgCL39ITnHUFcU2tYghawZxmA1vpvXAkTn+OuUnQfFIY7okfqhcoLO5XzqsgPjeJ4UEmbfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m0vBU8Zv; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m0vBU8Zv"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-8c533228383so20595185a.3
        for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 12:55:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770929740; x=1771534540; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+Di4AVhm56TU07ql39j66lxUcy6NgZxParhW1Pokv5U=;
        b=m0vBU8ZvAv6U+rFafEvd0zzzw9CQ6PlNeyDfKY3YiZMxbXiZCTQ9QSk2RlGEG5HPeX
         mHSzWUU5qvReLfjCHKVlNtUY2o0V9nNY6Kq+ILpZ/O7BpOV1nnZwSIx09oZNSklw+K7r
         lqycHuCRZi3qQJfMvErilNlVBLpPo04Qq94ulqHiw8ASbQYr6KhmOfnK32cKz+3sQG/H
         c1Z4UrgoqFZFmU9JuCLq6Z+wPBRRabJM4j3Ewgf5R5n6/c+meOwlZEs5THyTm9TntfGp
         Rt/K3AfVFWcOIE/9wI/9ymx2hiU5rt67IRZCzMo+U7VohgUjqy/tsilVdAa96Y+dS/lo
         zCww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770929740; x=1771534540;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+Di4AVhm56TU07ql39j66lxUcy6NgZxParhW1Pokv5U=;
        b=aTvEnIPAkXe7exYMVblEWBJmpEzkd9Dd+r+qKHuWsbybw+/L+haiOPyT4D6EvvNHer
         +VNj0vRB79vu2MoYfRwiW696TljIxeyLCX8qzOXh0L2nYtPZVuThTOAqNoidUmYWM/Gp
         1rz7RJV8I4k2b2TtrAataz7BFujTOSGaL9q9Lt0ECyMci2Z1AqO7jNhVFgxZ2kz3WPWF
         EB3qrSm787MF/5zsI09AX+7u37Zc7fx1vg+jibmmbkOFbNen0eRj1MIk4tCKrU4y1VFy
         /I5kB49CpbhDEmxVPc+Z+FkoXBdpuluIOjMnPU7R2lxYkF6SbU5K3z42CnwxUUb1pgqt
         6p2Q==
X-Gm-Message-State: AOJu0YxiLSY/7TXYH0qBzfIz+PUeG6HRsAxObkgBmmPKFX0ERD8Um9Ai
	nufoIKzoPGribjuuBHjrtYBRfBt9zh0DSB98A6YpzC9kSC94g90UBZ5K63xC9uV1
X-Gm-Gg: AZuq6aLBLX6nszHYKb7IVD98WjNyHjaqz0+nBeRIfSNuBEO/nPYBEbGi87916koJY4n
	Olr+nGy8ylksgBy4NUbq8TTu0nXc43j/tEVxZ0tCs6fgwuFraErgO36FiPIAcepmIY3aDMki4e+
	KINX145CH+DLClvnmdSty0obt43wtsPoWWnl0f2TAlEYligjJb0NLjTkXjkeAc/d/X9uvICOGoO
	PIYtwbBmsbRUKqcop77efhLSNPV0q9zhA7B5N3JRyAhUueqOsyx9iAjhZ7JDIbQZUQaImH8j3GH
	Bm9yj00UCHsDaxu/eNAu6R2vqBmj0qe79w4QjFyU6R0qB7PSQmHgXODqTfRNwCy+3zqNSgX/uCp
	ulG0dEQ2uPpeMqRQunj5bFLZnS5AT2EO9tbxrfWC4raRliVmyYqCl7YpWTIVekCais2fqi2niQl
	cWSzbM1HXv9Vs2F9KMOTKJrweIH8YBc2ws9B64Vgz9HHWr81g3wcEnhj7NOeaoDweNKes6c9+8Y
	4EI3nBN7Yw=
X-Received: by 2002:a05:620a:2986:b0:8ca:105a:298e with SMTP id af79cd13be357-8cb408fea9fmr26742885a.63.1770929740291;
        Thu, 12 Feb 2026 12:55:40 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8971cc823a4sm44446646d6.8.2026.02.12.12.55.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Feb 2026 12:55:39 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 08/13] lpfc: Fix incorrect txcmplq_cnt during cleanup in lpfc_sli_abort_ring
Date: Thu, 12 Feb 2026 13:30:03 -0800
Message-Id: <20260212213008.149873-9-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260212213008.149873-1-justintee8345@gmail.com>
References: <20260212213008.149873-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a port is offline in lpfc_sli_abort_ring, the phba->txcmplq is cleared
but the phba->txcmplq_cnt is not reset to zero.  This can sometimes result
in a phba->txcmplq_cnt that never reaches zero, which hangs the cleanup
process.

Update lpfc_sli_abort_ring so that txcmplq_cnt is reset to zero and also
ensure that the LPFC_IO_ON_TXCMPLQ flag is properly cleared.

Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 66 +++++++++++++-----------------------
 1 file changed, 24 insertions(+), 42 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 3d88888d8ee8..e6e138064a7e 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -4573,59 +4573,41 @@ void
 lpfc_sli_abort_iocb_ring(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
 {
 	LIST_HEAD(tx_completions);
-	LIST_HEAD(txcmplq_completions);
+	spinlock_t *plock;		/* for transmit queue access */
 	struct lpfc_iocbq *iocb, *next_iocb;
 	int offline;
 
-	if (pring->ringno == LPFC_ELS_RING) {
+	if (phba->sli_rev >= LPFC_SLI_REV4)
+		plock = &pring->ring_lock;
+	else
+		plock = &phba->hbalock;
+
+	if (pring->ringno == LPFC_ELS_RING)
 		lpfc_fabric_abort_hba(phba);
-	}
+
 	offline = pci_channel_offline(phba->pcidev);
 
-	/* Error everything on txq and txcmplq
-	 * First do the txq.
-	 */
-	if (phba->sli_rev >= LPFC_SLI_REV4) {
-		spin_lock_irq(&pring->ring_lock);
-		list_splice_init(&pring->txq, &tx_completions);
-		pring->txq_cnt = 0;
+	/* Cancel everything on txq */
+	spin_lock_irq(plock);
+	list_splice_init(&pring->txq, &tx_completions);
+	pring->txq_cnt = 0;
 
-		if (offline) {
-			list_splice_init(&pring->txcmplq,
-					 &txcmplq_completions);
-		} else {
-			/* Next issue ABTS for everything on the txcmplq */
-			list_for_each_entry_safe(iocb, next_iocb,
-						 &pring->txcmplq, list)
-				lpfc_sli_issue_abort_iotag(phba, pring,
-							   iocb, NULL);
-		}
-		spin_unlock_irq(&pring->ring_lock);
+	if (offline) {
+		/* Cancel everything on txcmplq */
+		list_for_each_entry_safe(iocb, next_iocb, &pring->txcmplq, list)
+			iocb->cmd_flag &= ~LPFC_IO_ON_TXCMPLQ;
+		list_splice_init(&pring->txcmplq, &tx_completions);
+		pring->txcmplq_cnt = 0;
 	} else {
-		spin_lock_irq(&phba->hbalock);
-		list_splice_init(&pring->txq, &tx_completions);
-		pring->txq_cnt = 0;
-
-		if (offline) {
-			list_splice_init(&pring->txcmplq, &txcmplq_completions);
-		} else {
-			/* Next issue ABTS for everything on the txcmplq */
-			list_for_each_entry_safe(iocb, next_iocb,
-						 &pring->txcmplq, list)
-				lpfc_sli_issue_abort_iotag(phba, pring,
-							   iocb, NULL);
-		}
-		spin_unlock_irq(&phba->hbalock);
+		/* Issue ABTS for everything on the txcmplq */
+		list_for_each_entry_safe(iocb, next_iocb, &pring->txcmplq, list)
+			lpfc_sli_issue_abort_iotag(phba, pring, iocb, NULL);
 	}
+	spin_unlock_irq(plock);
 
-	if (offline) {
-		/* Cancel all the IOCBs from the completions list */
-		lpfc_sli_cancel_iocbs(phba, &txcmplq_completions,
-				      IOSTAT_LOCAL_REJECT, IOERR_SLI_ABORTED);
-	} else {
-		/* Make sure HBA is alive */
+	if (!offline)
 		lpfc_issue_hb_tmo(phba);
-	}
+
 	/* Cancel all the IOCBs from the completions list */
 	lpfc_sli_cancel_iocbs(phba, &tx_completions, IOSTAT_LOCAL_REJECT,
 			      IOERR_SLI_ABORTED);
-- 
2.38.0

