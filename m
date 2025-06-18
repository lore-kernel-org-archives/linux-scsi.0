Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AEA53085C7
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jun 2025 18:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750272980; cv=none; b=VE3JAISMxoNjlevtUgc1DLXxMyFhgcdbun5b7YRMp7l58pWapwt2njy3bqvqdaiO7NYXtdc0THPfYR1GCCmLSUyImXjY+KvmUin55GGlPt4xouPS5uzGfXXWWjAQxrGGs9+im6OWjJ5HmwsQw0Pnp9tMexuDaeuLbuBoL00JIMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750272980; c=relaxed/simple;
	bh=yWjt6K6H8NuykPGDyswXd44BymFfH4tydTCx01DNLCY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=f7N/dMkVKExo4yFu3a9ckTNeZBnaweqfUV1BuPbntXcr/+Et2nFXG7U9jDtbp09C8kiaYLx4jeE/bgCdh8/jfHWXnGWnuZF/BVMcedGrlXou0ulnZqqb7xMYeAb9xnKxrQDZT4dKNTZWHhBR8G77MEpQkMZnKaKu9/r0c0n29Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NS3FheKm; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NS3FheKm"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-b31cd61b2a9so19778a12.3
        for <linux-scsi@vger.kernel.org>; Wed, 18 Jun 2025 11:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750272978; x=1750877778; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7nKWLj+c41vehlSePgZtgqybPwZxyTwCGM+2O7brVac=;
        b=NS3FheKmkwJJ0dxiyyxAEb8IlZWdtCAeduSH1lahdDZvipnKWFv4OBZC6kBcxGKno0
         +IaoY9L0byv+xLerjHNUkVLNaoMtP9di0JKOfda0t1aeRMhUIPluZu9YvYZVoMA6rWqU
         t6WQpe5ZxiUQqUvdguqSLLUeQtmG95xeSf1Jk+KNCir66k8vJr9+zEqfg0cR/8Slj3rS
         GyfjVaFYomK64cYA5DFfaBf9mtaEiYhwxN7o7cKOJBEyQYxJxfD3yxaiTX04g5CkM6gT
         HzjBH119Ju1k5NaxgjMYbCYyyrL22C/lExsEX6tmv11E48PQ7YCKPttQ/nz8/UPx0nWv
         77GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750272978; x=1750877778;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7nKWLj+c41vehlSePgZtgqybPwZxyTwCGM+2O7brVac=;
        b=sgCWrhkp9n5jybRR49Q/EYlvf6DtBj7Fr7OkxNgvM+blTFYvYTbbcP0edTEl2DKVbD
         nSglJa0n2P72134sq6+jjCeCZSunl2/HYjZ5VM3Y4+cXLoGVr9xLnACPLsbjFZUwivmG
         T3kbb+yMmEth3RnSFIIDUiJKkUmRLBFw2iahHWc4Hh/o4yAvpZc1YrfpwYElWlIuZ6J2
         DXfYX5Fn562OIbGtb0yCT7l8iD45/bGQOyuJg104byZjDDw8uJ5OfqXmfRExfhVADDTl
         zZSblSI1J1ABKLr3TbT2wsfZcVgm5cH7Y4qimt5HHOgINIyJuDumS65P/fwH9DWwyjCT
         YPaQ==
X-Gm-Message-State: AOJu0YxmJixTFHZNnZKIbrEjQIikWZQ0lf9GhEgxQt00TMu5a+hy3pdq
	7EGPrNCGC6HwzlLatK7tQlb+nmO01CYKKGHj0g9cBJE2mN00v3AM7qGuA4TTmw==
X-Gm-Gg: ASbGncsdbv+zabF+YYYRPsXwtUsWJmOAMrAg4gWDdvyhdiPjrctYbiKRq6UQSQIKUCc
	6S7jIgYVFPdHI1x2jo7RvDYtFrtAwARiBCcrlQ/CY4gMIzqviTlKq6PXZlEQS5l4flyX8XGif9D
	/RHQlvx4th0nDqa1rBdFbGttpaeYTqRTBknpiksPdr/mrFmUxBDiOP0qZthRkIJCfc+Uqq1QfIR
	ZxtAjQcWsr2+nijZnl2DVO5oO8dCF/DKInoq6pHWalhN/bD7CdVtjguTNh0y8RGNSA20KnPMbZh
	Sz5YT5iq6zk02JzoMf5pbqwAilcdKhM8iudr2Rm7d+i5XwR5Q18xnqGtogiCMFilJLv7c1Aeae+
	MkW4VF0d7L6vssXP6AVXTPwiGMDSBLfAM1mVdzBqAYkOsV49AkEGpyGXOcQ==
X-Google-Smtp-Source: AGHT+IHs3CIXyuLxJz6TLVq09yeUlmSgCyB2yl5KT1TtIc10Fgz1m6ZLXQrdOJS6i3WO8fR8TmH4xw==
X-Received: by 2002:a05:6a21:3986:b0:1f5:8cc8:9cbe with SMTP id adf61e73a8af0-21fbd494fc1mr23102624637.5.1750272978502;
        Wed, 18 Jun 2025 11:56:18 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-748900b75a8sm11798834b3a.133.2025.06.18.11.56.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Jun 2025 11:56:18 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 09/13] lpfc: Move clearing of HBA_SETUP flag to before lpfc_sli4_queue_unset
Date: Wed, 18 Jun 2025 12:21:34 -0700
Message-Id: <20250618192138.124116-10-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20250618192138.124116-1-justintee8345@gmail.com>
References: <20250618192138.124116-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move clearing of HBA_SETUP flag out of lpfc_sli_brdrestart_s4 and
before lpfc_sli4_queue_unset.  lpfc_sli4_queue_unset kfrees phba queues, so
clear the HBA_SETUP atomic flag to signal that the phba struct is no longer
initialized.

Also, add a check for the HBA_SETUP flag in the lpfc_sli4_io_xri_aborted
routine before dereferencing the ELS WQ.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 3 ++-
 drivers/scsi/lpfc/lpfc_sli.c  | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 31a9f142bcb9..46bc7b8041df 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -536,7 +536,8 @@ lpfc_sli4_io_xri_aborted(struct lpfc_hba *phba,
 			psb = container_of(iocbq, struct lpfc_io_buf, cur_iocbq);
 			psb->flags &= ~LPFC_SBUF_XBUSY;
 			spin_unlock_irqrestore(&phba->hbalock, iflag);
-			if (!list_empty(&pring->txq))
+			if (test_bit(HBA_SETUP, &phba->hba_flag) &&
+			    !list_empty(&pring->txq))
 				lpfc_worker_wake_up(phba);
 			return;
 		}
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 47bbcb78fb4d..372907debbe0 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -5167,7 +5167,6 @@ lpfc_sli4_brdreset(struct lpfc_hba *phba)
 	phba->link_events = 0;
 	phba->pport->fc_myDID = 0;
 	phba->pport->fc_prevDID = 0;
-	clear_bit(HBA_SETUP, &phba->hba_flag);
 
 	spin_lock_irq(&phba->hbalock);
 	psli->sli_flag &= ~(LPFC_PROCESS_LA);
@@ -5284,6 +5283,7 @@ lpfc_sli_brdrestart_s4(struct lpfc_hba *phba)
 			"0296 Restart HBA Data: x%x x%x\n",
 			phba->pport->port_state, psli->sli_flag);
 
+	clear_bit(HBA_SETUP, &phba->hba_flag);
 	lpfc_sli4_queue_unset(phba);
 
 	rc = lpfc_sli4_brdreset(phba);
-- 
2.38.0

