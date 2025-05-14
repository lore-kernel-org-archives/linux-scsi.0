Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6B51BD035
	for <linux-scsi@vger.kernel.org>; Wed, 14 May 2025 09:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747214550; cv=none; b=Khavr2JI+wixNu9uiLGbiftmpvybzILUoZ9BNcZfc5UYktjx6eNwdOTtVCczKhx8HmqxvTplPbQ/HcVm5k73Xg4r4b57AW4bjqigWfph1pMmcggPzXFGwMmRFICHhAphzHz9TGfeXMhRt/5iHK5bAf0/csqYigwJfuL3ug1TcSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747214550; c=relaxed/simple;
	bh=0wKRSIgrcwImqI/EytYibq+829+ctq66LH+QlVN9npM=;
	h=From:To:Cc:Subject:Date:Message-Id; b=U8l6s0nTlUKOTFkUgCK7fsuRazscfxcfTBAlsBQblJah0a3V0rNIjyxatJNGDaw1TlgSTt7ya706aEYiWWSIyrXOpMFRMqyh8Ohi+7xj2vaLD9+7opZmTieh5pIjxR1OtPSb5uIsr/KRveZbbm/6dQkFxTT+SehlkDPpKYs8lHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=E76rsk2r; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="E76rsk2r"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-30e390ec275so322353a91.2
        for <linux-scsi@vger.kernel.org>; Wed, 14 May 2025 02:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1747214547; x=1747819347; darn=vger.kernel.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ot5hp+G84RuhoMwWaSCfnLKGIWnY+ySmLEzThtVglvs=;
        b=E76rsk2rPZpnOGhL5n5a+xBzS/Dl06e3fFIzggm7C6ghV3/kmNS1GOKZ4jt1gHNLnR
         kikfIPPEHycbYi+UCt8xXbaks3HiZv0MZr/kOVZHtU/q4h4E1aGs4IR/eH5oHkPerdb6
         dDCqQdh7LISWI0MM24NTmcVjqn0oeuLgUz+XA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747214547; x=1747819347;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ot5hp+G84RuhoMwWaSCfnLKGIWnY+ySmLEzThtVglvs=;
        b=wvvD2l9UpElU0e1/GWxawu65z3XXTAqtW9klbbpCG8Pt7K2zNMVFR3zju/B62z/LC8
         CkKomF1yKI1QDfIuvbMv6k32eL9UXZMB+a1femu4SeVG1scY/s5TWmuRMsz8CPcfvHWN
         pSVabuV+zUkIIOUtJ/2TM3x5S78xKiE6Es84d1W+y5P2jIAM4ea6kTLuybfEYqbhke3F
         kEEILDq1sEvrqBJ5jI1JaUSgp6E6fDmsgasZ50wdKGeIvZbiWgKBViqlmAY8ffNIWssZ
         xaiYjTOvfgsF+b5ze8FjN8YgzdJyEvvHw1ASIkDzEF09SPqjFFZAAguZpYKr9fIh6e58
         nddA==
X-Gm-Message-State: AOJu0YxxL1qKDc3S8Zg5H6xRabSWMmOApQuc435xQljZfUChwjQZe8x+
	5hKMHLIFqBmGqCOW78Kh3HshAy/QZ8OPfw7pGRKMvY76C+ol3q8TP4PlWSyEaYzbzSZFTik9N/G
	nEIztUoym8N2oQYAAvHhkW5OpYVtfsRv0HeldzdsogG9QNXTt7+rw8dbSQbbkdKB0e7MMB2oMMH
	OZC4p6BD+LBSZebwkRLC+gggj+QsomL/tCdkfgkLAqHlp4Zo7sJ1w09Wa/XlwZw0CE
X-Gm-Gg: ASbGncs1IadkmcYzpaMeyqPUt+p577pU4FwZDw2njUgw/mzU1ZE8Fn+h48XFEETOkeu
	rxu4idzunHMag7CMFDz6x708C6nU7iaQjT451NMf65kah5K/3RmBhxIjJAl2zteCY6jXADAwsNu
	TN6PxYJJvCY/3m05yuHJdTw/unEbwxwMiBp8C3LM987wP9+4FxNcI0ey+GNulJ2f3CWwXh1EPiJ
	PoQIGXXzIDPSHcqjgB+DZcYxAMFkGNg8s2LN2ly6hTyoI3wVoySxe8o6DNFqBZii4yswqwvCZSy
	xDi7ey9kaixwdWZOPQ/nIamO6T2ZE3NJDdQenkqzRanVHIX6CFmIuMPQ8461dsGgP/JhaqeV4Qc
	kp+0/U6mLUHQx54hQb1UJsXOyhAC6YMaLHgkdt+70kuf1HLzYQ0+4el8lAUY=
X-Google-Smtp-Source: AGHT+IGdxn+L7GwNbQHJ2oFCn6hF4cx7V/ue65mOCRTo7EtW9PIdBuHtyionKKjlopnashp814Rm7A==
X-Received: by 2002:a17:90a:e7cf:b0:306:b78a:e22d with SMTP id 98e67ed59e1d1-30e2e5df0d9mr4231444a91.20.1747214546906;
        Wed, 14 May 2025 02:22:26 -0700 (PDT)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b2350ddb820sm7224701a12.48.2025.05.14.02.22.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 May 2025 02:22:26 -0700 (PDT)
From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	suganath-prabu.subramani@broadcom.com,
	sumit.saxena@broadcom.com,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH] mpt3sas: Fix _ctl_get_mpt_mctp_passthru_adapter to return ioc pointer
Date: Wed, 14 May 2025 02:09:41 -0700
Message-Id: <1747213781-31545-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
X-Mailer: git-send-email 2.4.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Fix _ctl_get_mpt_mctp_passthru_adapter() to return the correct IOC
pointer to caller based on dev_index.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 063b10dd8251..02fc204b9bf7 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -2869,8 +2869,9 @@ _ctl_get_mpt_mctp_passthru_adapter(int dev_index)
 		if (ioc->facts.IOCCapabilities & MPI26_IOCFACTS_CAPABILITY_MCTP_PASSTHRU) {
 			if (count == dev_index) {
 				spin_unlock(&gioc_lock);
-				return 0;
+				return ioc;
 			}
+			count++;
 		}
 	}
 	spin_unlock(&gioc_lock);
-- 
2.43.0

