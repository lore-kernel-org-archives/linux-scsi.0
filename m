Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60CB60DEC
	for <linux-scsi@vger.kernel.org>; Tue, 20 Feb 2024 09:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708423030; cv=none; b=c7z/PM2NnpFeQxOAQ3WwpXRS8qltEBHs899RfnOL/ct+ULmTLUzK4kuMYpEuJxp9NO9MH/i3FSXAcIaiKaEB1kWNakJHWD+1juMrYr8mZ4YDKcmxYkYEZlG1NZbcZbPmuzYMPaF/yFCh1UQZBSEOV/BSMDfh1g68d0B2cxumyIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708423030; c=relaxed/simple;
	bh=5i6IUnS3HBED35I/Esul/eXWCBL7mQMHTbaMIBPY3/I=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=XRed4CWGUWLLO0S7WNfT5X/Q18HtRIP+4uRO/jae7ET6dvovJQT5wA6+B0cC0dv8hrKNPhIpvHERkHeDjXZd0wi+PD4aUbsQwNphRqU87ENgwDH/atTtgMDV3EDgYFVvpparFjpke3wC6tB/K+rp3TCgtIucwtW33w7lrSDnFO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rohitner.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EFDKxKR7; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rohitner.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EFDKxKR7"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dcc05887ee9so5590828276.1
        for <linux-scsi@vger.kernel.org>; Tue, 20 Feb 2024 01:57:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708423027; x=1709027827; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tsP9YAs3ATUDlmKMnOUj5SyinmDzqfFQjHSuoj373s0=;
        b=EFDKxKR7D4dtUIB7j/QVOZychSCpZUP0V7KNJiVwvDdJwi/Hoxx0TVnJUQ+ECoU//n
         Z8mcScSdvHPqqFOSpibOh5l3v2iKE8Xesop9jIL77tM95Z2Rl9LfqQwXfSH2ySdagqYI
         EM581J0scyOA8wR7Mc0BX25P0SvqChLAzad5fzS7rE02aobncF6RfwF81Lzvj0Zkq4V2
         N+eZIRDyv3HVCmEjKXraVE1k9B01CfAscK9Sveli8AjeLTiNARH+WJicvBjA4Rbqdeod
         0d7yEFWe5YZBntyv0naRPIIGPw6up2LmJztkDdRISfBPhvSGErxWLennWPHHpPS8ootu
         SugA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708423027; x=1709027827;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tsP9YAs3ATUDlmKMnOUj5SyinmDzqfFQjHSuoj373s0=;
        b=dh5XKH4IwOaN+goKD2U0XlMfjeB/LlFDNoZRzWxHWgBM5SJgCWU6rK1EabEh3CQmr6
         QsSkd12Jyc+qqt75noYS8/TT8wy0bOaEtPOd/J/GwPXkAQY5i+l3qBjTzZHDV1HEOaco
         lzP2xBs4o/s/suNzm61F+TSwTwq+EQiZf1FikiNqM/V0wBjAeDsulslMiTCpMXiiBeAc
         0dw6lhmFw/naXcu7ruqiChtSVWcgF9h/+7ZqpxgHBjRZXrVqd1SY554PjN7AfagyE1JQ
         ZTgIVN8wuYQioogJSyoAOnGfS1hkXuThgjAhuREi4kui5FQT9UKTOVVxdAnzmtKJCkvg
         R/GA==
X-Forwarded-Encrypted: i=1; AJvYcCW45uo40RCWoiz7CwBHdk2/MMLVPy0XXbL9Y9J1PG0qi6tqQep39FuimG8Fpa4Ycc1I+tU4OFYC9qswIGFY0coh/kfSXHPiFxLrUA==
X-Gm-Message-State: AOJu0YwaGQig2ZCgOILvY0GYQ1nkJHO/xIxm+D+37txf8P3uOQAuGPX+
	jHNtdebRffyahjclh7LrUxLkwoyHKuLwWFIoovXmbMOy1c8/VaSOtCFsXQ/ouz44A2vHIblkoNU
	BeO/K1ttgRw==
X-Google-Smtp-Source: AGHT+IGWHnoKqIgrolTQgf5G9nztGiC237V0zeGlvpymEJ4Z2eYkitdQni1bkFaWyx8oCaZUqO6kFe8y2fm/cw==
X-Received: from rohitner.c.googlers.com ([fda3:e722:ac3:cc00:4f:4b78:c0a8:413])
 (user=rohitner job=sendgmr) by 2002:a05:6902:1547:b0:dc7:3189:4e75 with SMTP
 id r7-20020a056902154700b00dc731894e75mr552327ybu.3.1708423027641; Tue, 20
 Feb 2024 01:57:07 -0800 (PST)
Date: Tue, 20 Feb 2024 01:56:37 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240220095637.2900067-1-rohitner@google.com>
Subject: [PATCH] scsi: ufs: core: Fix mcq mac configuration
From: Rohit Ner <rohitner@google.com>
To: Can Guo <quic_cang@quicinc.com>, Bean Huo <beanhuo@micron.com>, 
	Bart Van Assche <bvanassche@acm.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Avri Altman <avri.altman@wdc.com>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, 
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Rohit Ner <rohitner@google.com>
Content-Type: text/plain; charset="UTF-8"

As per JEDEC Standard No. 223E Section 5.9.2,
the max # active commands value programmed by the host sw
in MCQConfig.MAC should be one less than the actual value.

Signed-off-by: Rohit Ner <rohitner@google.com>
---
 drivers/ufs/core/ufs-mcq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 0787456c2b89..c873fd823942 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -94,7 +94,7 @@ void ufshcd_mcq_config_mac(struct ufs_hba *hba, u32 max_active_cmds)
 
 	val = ufshcd_readl(hba, REG_UFS_MCQ_CFG);
 	val &= ~MCQ_CFG_MAC_MASK;
-	val |= FIELD_PREP(MCQ_CFG_MAC_MASK, max_active_cmds);
+	val |= FIELD_PREP(MCQ_CFG_MAC_MASK, max_active_cmds - 1);
 	ufshcd_writel(hba, val, REG_UFS_MCQ_CFG);
 }
 EXPORT_SYMBOL_GPL(ufshcd_mcq_config_mac);
-- 
2.44.0.rc0.258.g7320e95886-goog

