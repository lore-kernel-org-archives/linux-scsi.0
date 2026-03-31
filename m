Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF0444E043
	for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2026 20:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774988589; cv=none; b=GN5dawN228NbUfd8SzcsPVbC1Oi4OmAobNC8ZF083KUst36oWdlZ8ebTz/lO9JyS8211kdC7TXdOUYej66IaDOe6+gxCsLe0758YPC+Lb4bhQ5f6ojTC0z4F//xfroEiOSd6KUl3nhrnGizyVccGuI4vYSmi2nzgtNKtwQvMZnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774988589; c=relaxed/simple;
	bh=wvFXFxXkfzlx7RQL3hRDqFoPQ8pYJore2Nffw2r4YJk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TmsZhpfFrAgE4ufBMiiloEmR5/IeIOsPHvrwpjceG8+/Hto9GzcjTnokd5ld+XAvioeI2EPXhecNThPOJTDoAYtB2P0CuhvtkiV5ebaiHrMG92m/0aYnkFzHwbJ4qs8+su4BK/SfpWFNyrvlNMONgSogrS4SWkCVlYmMeX3Fs7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=phzd/QLg; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="phzd/QLg"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-8cfc497a604so778968385a.3
        for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2026 13:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774988586; x=1775593386; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p+i+Wuc8aEwStNUWCOugGvHFd5vQQ5lvbWRTIIT+JcU=;
        b=phzd/QLgaCTZlg03fRfLjN4zV6IzSCfHqPWZfjP+ggNBh5UX4kytND/EsBpknUtyst
         WVste9hfAROLVVLj9L6vX3JFbCgAPX5Bw22ywN/5xyHAlf1LQFPW58jqXtCu+R5Ky0PF
         D1HkVDkDcRFPsjYkThRbS1zcrU2XQtpgObFswSfXE/GnaX9Ju0LLkzSaV4PkFuFrMgIw
         UD+ChZV85MvvhskrVLj5C/79L1b4p/cpW5rKJtpwdIUR59jcxxyDmRhtVCkXce0ybqzY
         ohCRiW/bwHdqWcKZYpKLAugAZ7uGMVnR/TERs0+Hl79sy4l6yyXTrhPAK2bJYXIKLzQ4
         1alw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774988586; x=1775593386;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=p+i+Wuc8aEwStNUWCOugGvHFd5vQQ5lvbWRTIIT+JcU=;
        b=SDOvriW2l8FHwKoMz6/WJv+DPN7uDhQZ4ygQfUUbL0Fv3ZRTNNMphXzqCvnp3Ws1BZ
         ifHkF5J0z8JCv+pON2k5L6MiqCtBo0LEYfq6AvNIUOv5hQWYX9RBOHZ6cbM1MY4uVOCa
         3P6vBNpFOVKM4vNEo1VT+VzJaUBgwJ5vVZl/LLLw9DDxMB6P3PbZtk10+3+tw5DxFjCk
         NeaJgz16kS4mzGOk61FODry05HBkPxjjkm4ia92OrJXVgIdfCkKpXIcpilfg6IwPpSWi
         hMmgeviHSUr92VBuXaNCsY9MQd3BljdNjaarlSHMTyo6u/hlgYvY1aR6BxSq1OW8yMjS
         u56w==
X-Gm-Message-State: AOJu0YzdjJJfCJPfXtn5jZs1NtGoiZSCQFm/Nn3Cc/nz0VUUHJa6TDQh
	wcmOXuQhROXUR8RpvNe7ZjjnjT5EOrBL0lbHID2V9yn+Gm8+oDUl0TV6wNHQtg==
X-Gm-Gg: ATEYQzx+SIze+V1fhFVSVodMCn0NRfxh3nHPdxZWeMC6gN7ToG2qjwoaUOYz4FjObE1
	GNC+Qp6xftkCQKeNzrL2Zo5EBzAqZoEJ0Wt7MOBwdeICAWdLMdD2vzvCwhqAXvJvrU6BHUpAaXn
	T2cdRsjLKw3k0QI0n4SV5aBMRVAgd1DsJe/2k2wXPVcxK2wjm8ckPsvxLfb/mm3cI7cIgqRptM4
	QY+zB0uyYVLBTFXB3yz5c57Kgrz0QKXa75DeQgbmM6d/5wYXJGFGvSbHYg5KLfFBAIJQ1dtRkh7
	ebvWXWizVUxalNtqZ6I8gK2P9nodUiWuK0t++pDwgdwZTT3x5GZlmkaNnjNFUIfPUiVqkjQTqVN
	MbzHEfdWzYZXUtPBE969pF7IXTcH4nuOO3HPmfkOf5c8tRjBKp1jcZf4FX+B33tXn/riSo7z/gM
	j57UTnOYII30Kj9PzfXVSHzICGPVl2zOEeOyfsvJDtnbk4dZJtk177ebbKiZeArOnPacqbg0M3m
	KVK2sf12ghz2Q4dRDAbvGiE2wKMoSIKsGHxy8uRzBI=
X-Received: by 2002:ac8:5914:0:b0:50b:3ec7:ed16 with SMTP id d75a77b69052e-50d3bb92f1fmr14012761cf.13.1774988586603;
        Tue, 31 Mar 2026 13:23:06 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89ecf865ccesm96685616d6.39.2026.03.31.13.23.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 31 Mar 2026 13:23:06 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 03/10] lpfc: Log mcqe contents for mbox commands with no context
Date: Tue, 31 Mar 2026 13:59:21 -0700
Message-Id: <20260331205928.119833-4-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260331205928.119833-1-justintee8345@gmail.com>
References: <20260331205928.119833-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update log message to display the entirety of an MCQE for which there is no
submission context.  This log message is not expected to occur and hence is
tagged as a LOG_TRACE_EVENT.  As such, move the hbalock release to before
this log message so that the trace event process does not hold the hbalock
for too long.

Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index bd71292e7480..b32a1870eec2 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -14337,13 +14337,15 @@ lpfc_sli4_sp_handle_mbox_event(struct lpfc_hba *phba, struct lpfc_mcqe *mcqe)
 	/* Get the reference to the active mbox command */
 	spin_lock_irqsave(&phba->hbalock, iflags);
 	pmb = phba->sli.mbox_active;
+	spin_unlock_irqrestore(&phba->hbalock, iflags);
 	if (unlikely(!pmb)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
-				"1832 No pending MBOX command to handle\n");
-		spin_unlock_irqrestore(&phba->hbalock, iflags);
+				"1832 No pending MBOX command to handle, "
+				"mcqe: x%08x x%08x x%08x x%08x\n",
+				mcqe->word0, mcqe->mcqe_tag0,
+				mcqe->mcqe_tag1, mcqe->trailer);
 		goto out_no_mqe_complete;
 	}
-	spin_unlock_irqrestore(&phba->hbalock, iflags);
 	mqe = &pmb->u.mqe;
 	pmbox = (MAILBOX_t *)&pmb->u.mqe;
 	mbox = phba->mbox;
-- 
2.38.0

