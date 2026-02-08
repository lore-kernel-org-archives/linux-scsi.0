Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2CD22F01
	for <linux-scsi@vger.kernel.org>; Sun,  8 Feb 2026 03:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770522832; cv=none; b=RYbiHCeiw36pz0HeNJiBrrc5gd8jfaZg/RGz34saRF6J69wyExpAP66ANO+BGmfCpnv2ubmXhqJQN+wHOR+xfsNan1GzQ5DSHS7nC1EoUkXAh9x4K/Y6wb/XmjGlFy6ngzcTXbbvSQLN6gPvPZ8i5FXWY3l23x5gng8COyQLulE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770522832; c=relaxed/simple;
	bh=IAG5hEnEbNpHR7VILo/dgAe3AccnKofEghqYHX5gO0w=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jSLsUao/HRW4ZF0JcaN07wCDKbYXLeSgCmzmb4dFowkz43L9/OYS3em++VJiQkteUkFRr/vEVVOkPbPgG7bPGjvuE3/mBNoFHBfOm6IzI0ZkPJqHg/5h0nF1i++aDp/i9z5LRf0eON9UZ1h/tipR+SRBuz4DCC6wMzHCJPfdgas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=u.northwestern.edu; spf=pass smtp.mailfrom=u.northwestern.edu; dkim=pass (2048-bit key) header.d=u-northwestern-edu.20230601.gappssmtp.com header.i=@u-northwestern-edu.20230601.gappssmtp.com header.b=DfSNL8yH; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=u.northwestern.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=u.northwestern.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=u-northwestern-edu.20230601.gappssmtp.com header.i=@u-northwestern-edu.20230601.gappssmtp.com header.b="DfSNL8yH"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-8c5265d06c3so492349585a.1
        for <linux-scsi@vger.kernel.org>; Sat, 07 Feb 2026 19:53:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=u-northwestern-edu.20230601.gappssmtp.com; s=20230601; t=1770522831; x=1771127631; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zsiMnCWsDue3HgjqSN6ua103luAgmACwCAaDl9Hd5SU=;
        b=DfSNL8yHRyJm3N96qXAu2D9+RREl2w2HA8VkuP+78cktk/yr8doB4xh1Kpm1SJvG5x
         nN6tIEhkeQ0wfcAxeV7vDZL1c9x+Lwk24Zkz4GcR3wF4IP0IxmRUF6QLGHT71ZMFqXrt
         cxUaJuQvNOxdE4qpo7242eQxXRVQKnPRI8+pVVYb+NaT86C4ir6PvjYgIysVJBN40vxh
         CVpuWQ8nUVbKrZi0upDla9ZrgLj44o3ZKGEJRECA1hrnmyBHgrEBhtdSkkyEEY2HEqNn
         k7jaqYXl+S0esdfWYHUk8nCfsAJUhLC/n/9uQ/1fOrIV6Vn51N8xA1pQ/FuvrBu1o3WN
         9kRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770522831; x=1771127631;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zsiMnCWsDue3HgjqSN6ua103luAgmACwCAaDl9Hd5SU=;
        b=jCxx8oFmzmwbxLdoWtXk6qZcerkyhKPCcRd3A5GLWvZm/9qHts12UeiNdbcbeYckS/
         EEwA7hEFSv0tpmewMe5aZoQzM1sHU10yS92BIP2CdbCLq5+nwhq2k0WIOxKBqEWqQQns
         fkx7PdBJGRJ8x9tw69ejabwPqO/Evvyb73iONUd9A53Ya/+2ExRwxNifutEepUo0UDYh
         wUW1/SOX29AxSmDu12BIdExTKTcmwQgtcrYZwQb4aDUPYM3uGJlpOQM040HazV+INyIc
         txFK5euSMzhzqvb5fKhxdZS8IvakKfbYnjKgdIqQjeQkQJdx3V+s3KZyv/t+t9xCV+eF
         APjg==
X-Forwarded-Encrypted: i=1; AJvYcCWAwezED/uNSXYeBg4sqE2yni3ESbhzOyKKxvtXiBQGFXIOwdYduveuErl0Zn1kEp6Rkuuh8ov25pH1@vger.kernel.org
X-Gm-Message-State: AOJu0YyaE8BmTQTOG7h7oLP9IWVVnkIrxVoBzucDprORRzF+csAEeLoy
	MJF1qvCF0pmfcjt/kyFy0X1U+Ai+cmaeByiACu+uZAdpX0N3+TeX3A/WXPdieRTir/4=
X-Gm-Gg: AZuq6aInEUcdMAHR+QP2Gl5rN/cBto61FWfad3WYLmagvOitfu3XgQgT+TRuSUwD1sW
	eJ2i2kBtk4OyvlvD88xpJPb6nlIVaVrAxiPb+Dz82s4mYdNebHE30BnfBiD+7duCyAHIGDJE9od
	xa5pzT9t2PuwnzOHec6WZoizdS9uwP6D4uprsrQisDwP817KyoitY+3HZC2Bb98uN14OUMj1ZF1
	O3rAppZ7Slfq11ndvboafqWXgukGAtYYG3Mkak3nBbIOJWopDVzKr20Tu2gMytjwb+QhldkDTw6
	K45Vtj6ALqWGLvnRdmZC7nTZHFco/i5oyXuh0AIYxiVdoDxBn6dYpFPZ71hlmFlfSTkkNMIzULK
	9gYHit0/CwhPSFIpGFT1TViNNbirchPVgw/W5+iTgTz7YVgNvrT+4Zi3p+/cbJdVut8dyBjnNrx
	MWJVau3LUX1V4glqzCKYVcI+Xf1sWbMlu/+31PTzOdMPDvrX/9eGCl5nwhSo5BaFdtaX+sYXZpJ
	4p+r5dl6dOR4IBoD77F5pEyhx27vqX8kjuhZjTmLQ==
X-Received: by 2002:a05:620a:4486:b0:8c7:1b3f:1d02 with SMTP id af79cd13be357-8cae3388853mr932093585a.40.1770522831259;
        Sat, 07 Feb 2026 19:53:51 -0800 (PST)
Received: from security.cs.northwestern.edu (security.cs.northwestern.edu. [165.124.184.136])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8caf7be4366sm509430785a.16.2026.02.07.19.53.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Feb 2026 19:53:50 -0800 (PST)
From: Ziyi Guo <n7l8m4@u.northwestern.edu>
To: Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	megaraidlinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ziyi Guo <n7l8m4@u.northwestern.edu>
Subject: [PATCH] scsi: megaraid: add mega_proc_dir_entry check when proc_mkdir fails
Date: Sun,  8 Feb 2026 03:53:47 +0000
Message-Id: <20260208035347.276181-1-n7l8m4@u.northwestern.edu>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

megaraid_init() calls proc_mkdir("megaraid", NULL) but only logs a
warning and continues when it fails. If pci_register_driver()
subsequently fails, the error path unconditionally calls
remove_proc_entry("megaraid", NULL) for a directory that was never
created, triggering a WARN at fs/proc/generic.c:736.

The same issue exists in megaraid_exit(): if proc_mkdir() failed during
init but the module loaded successfully (pci_register_driver succeeded),
module removal unconditionally calls remove_proc_entry("megaraid", NULL).

Guard both remove_proc_entry() calls with a check for
mega_proc_dir_entry being non-NULL, aligned with the check of 
`if (!mega_proc_dir_entry)` during megaraid_init() creation stage

Signed-off-by: Ziyi Guo <n7l8m4@u.northwestern.edu>
---
 drivers/scsi/megaraid.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index a00622c0c526..ab901ad6c480 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -4589,7 +4589,8 @@ static int __init megaraid_init(void)
 	error = pci_register_driver(&megaraid_pci_driver);
 	if (error) {
 #ifdef CONFIG_PROC_FS
-		remove_proc_entry("megaraid", NULL);
+		if (mega_proc_dir_entry)
+			remove_proc_entry("megaraid", NULL);
 #endif
 		return error;
 	}
@@ -4619,7 +4620,8 @@ static void __exit megaraid_exit(void)
 	pci_unregister_driver(&megaraid_pci_driver);
 
 #ifdef CONFIG_PROC_FS
-	remove_proc_entry("megaraid", NULL);
+	if (mega_proc_dir_entry)
+		remove_proc_entry("megaraid", NULL);
 #endif
 }
 
-- 
2.34.1

