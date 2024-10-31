Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EEC819D089
	for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 22:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730412930; cv=none; b=j/0r5nsDXjRJ6UbbO6k4RkzWi2yxpDBtquLrRoMKBCxtyimm6g016Jg3kQ6VHR+zyVHZWAJJZbvk9SlvBnObTFItTwJ/k9xeDmmmYXeHnQrUwGDvK+lCeJnmC7RkP2+Xan/mJ8OkSSz0zwq1SgEDbbce1SpVohoMEF4AfIQSNFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730412930; c=relaxed/simple;
	bh=BL5J5sLCQXv/V9HbynxaMZC9QtDak3EZRlHyINCrgU0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HI/cxrxAkkdMajq3uPkxdnnFkf/AoDvTZPQMtCAEtNXwRkaL6r3VrcF+iLgYwrwTzbt4sFVHRKKia1zobok2spzKYEox3XJpQBLQtpogDBaj62RX86vWiccp3gXFMjHX/X2lsisPSPrflglTxykNeFWnpDHp3Eu1ZId6kyTn9jQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AtdF0Wct; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AtdF0Wct"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2e3010478e6so1058728a91.1
        for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 15:15:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730412924; x=1731017724; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cLNfLwmLHYSuq2t7DEdLYS/LMzev5XQve2jdKDXujCA=;
        b=AtdF0WctMFM9eZ+Lmh6Av1lgj3dLJP6R+MIi30XASMigpGiw4YsGioos8X9Cn9B5dU
         Ahr4iFYJhnFKTo7LE+re70OQmhDaJLGTcjIRHkOT6tB8kE3kFJv7U/HQJVMDEd5f2N/w
         TMGTP5KIc6UXQjvSTH/od+Wp1Z3JMi1rNNd/szFHocrRWcAuUDwYywB9oARvzwhCwqUm
         M29G8VjYxfOcGAOgzOyZ36hvPq2gBIvGGQL12/uh7ao7sjweUjPYpb2iMuCMeVMQHTtD
         fcWYwRqMRqNOoIlRzV7Qi8p5+FdP7zDRAWbZuTQxVLN6Loi9yg4igWI4jmdxiF6BBpR3
         vPPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730412924; x=1731017724;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cLNfLwmLHYSuq2t7DEdLYS/LMzev5XQve2jdKDXujCA=;
        b=O+I7Eh/FCQ9dgXJtui3sRsiWlLCXZgQUj+eOoUp9xslCjDi0GB9EW6jKruoXhQ9MeX
         I362oulXtoT8Of7NT6jwwHbovDEZF+RB955k9xKbYNV5m5nTzgTtQj9ZCPcyxhvVFbj1
         47PqoeFJvsHiRl4a5XA6HzBmHXaVTBvNoBDWgGCewqKQwlWeOp7gtj7pghYfW81fYvW3
         DBawyTG9ND3st6/qckzJRIcFYIwpE0NR8biWw9pMtItxMpNYhZ42tCnh+b7cmTxsdlAS
         mKIzMqIfGAEvCzgqJUQ3aJf8HA9AHNTe/XSuALsAecQmIKgP35xL8/M0mI/2XBFO1y+l
         fGlw==
X-Gm-Message-State: AOJu0Yxncbberr3LAHx97ZCgjOVoRRooXXcxcKT7uKjN/XZpcMhkylBF
	PGDyZljMlHbEut50qgRH/vqe0a4t3yVGqgevGfW2oAu/0JAQKgOZWls9dg==
X-Google-Smtp-Source: AGHT+IEO7OJ+P5E0upGb4ROURYiaxGd0x0vTmBk0LwNJrNMTwRKqDpn7dItxbiKliUtW5p2RJoSWtQ==
X-Received: by 2002:a17:90b:4d06:b0:2e2:a2f0:e199 with SMTP id 98e67ed59e1d1-2e94c29ec6fmr1861985a91.8.1730412924466;
        Thu, 31 Oct 2024 15:15:24 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e92fa25742sm3916528a91.19.2024.10.31.15.15.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 Oct 2024 15:15:24 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 01/11] lpfc: Modify cgn warning signal calculation based on EDC response
Date: Thu, 31 Oct 2024 15:32:09 -0700
Message-Id: <20241031223219.152342-2-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20241031223219.152342-1-justintee8345@gmail.com>
References: <20241031223219.152342-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

CGN warning signals are currently statically fixed to a passed in driver
parameter called lpfc_fabric_cgn_frequency.  However, CGN frequency should
be more correctly based on EDC responses from the fabric when available.
Otherwise, still allow the driver to fall back on user configured
lpfc_fabric_cgn_frequency driver parameter.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 2ec6e55771b4..80a43fd40af2 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1932,7 +1932,7 @@ lpfc_issue_cmf_sync_wqe(struct lpfc_hba *phba, u32 ms, u64 total)
 	union lpfc_wqe128 *wqe;
 	struct lpfc_iocbq *sync_buf;
 	unsigned long iflags;
-	u32 ret_val;
+	u32 ret_val, cgn_sig_freq;
 	u32 atot, wtot, max;
 	u8 warn_sync_period = 0;
 
@@ -1987,8 +1987,10 @@ lpfc_issue_cmf_sync_wqe(struct lpfc_hba *phba, u32 ms, u64 total)
 	} else if (wtot) {
 		if (phba->cgn_reg_signal == EDC_CG_SIG_WARN_ONLY ||
 		    phba->cgn_reg_signal == EDC_CG_SIG_WARN_ALARM) {
+			cgn_sig_freq = phba->cgn_sig_freq ? phba->cgn_sig_freq :
+					lpfc_fabric_cgn_frequency;
 			/* We hit an Signal warning condition */
-			max = LPFC_SEC_TO_MSEC / lpfc_fabric_cgn_frequency *
+			max = LPFC_SEC_TO_MSEC / cgn_sig_freq *
 				lpfc_acqe_cgn_frequency;
 			bf_set(cmf_sync_wsigmax, &wqe->cmf_sync, max);
 			bf_set(cmf_sync_wsigcnt, &wqe->cmf_sync, wtot);
-- 
2.38.0

