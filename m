Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C5C3090E2
	for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2025 09:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763114180; cv=none; b=lVbhW9IjYB6duhs3nOLhrm5hPM3rHFzHbxlLUPTf46Fs1MDwUfbYlPGJgo4+M1FlDcT7c52Ggky41J1u5tmNN/XbTPquzN9UvxymP8UPp/1LA9FDrmQ7ugs+0xRm6/abalc4dOke4l3gHmFU1AVm4nmpnFPNa891vSUfTvMU51k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763114180; c=relaxed/simple;
	bh=OwQdfd1L5YejtUvaw1EPGVKku9bMYl/Ibrd7rjua6ek=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MXPVdjGUtGv7PJ1CSz7yicgRmZOx9moLgY5fjNRoloDmHNh82IKdX94Oco/oXZrLtDHxhtp8MJY3gKvAJX+Xa3b7+cyUZp/JFM/0dhZuRw2HcNsVSDo/FWVCejLjoH0XGOzc/5TwNTO7ppLJ8RblJdZ4vu1wmh7e8v/BWxOd09s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kMpB/6ZY; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kMpB/6ZY"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7ade456b6abso1566514b3a.3
        for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2025 01:56:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763114178; x=1763718978; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bBVOoNqFhwsPHm7ZfvVyx4joY9OcOopeLcICnJu5J8c=;
        b=kMpB/6ZYXsCbKTOi69CXtHV0h/WMR0CzwKTP6TauwelvPAdIv7BuG+K8rPTV4M0saK
         J1qFcHbKs72U5/05wyOehP/ND0ehfan0iN63JYCNUB+4JU8naNS1Q2uWKjBjcxCgrvs9
         V3GJZR+h8lLz7xJvOX4dHIR1rNRF4+kOLqPHPSsBZu35lQdhMBhZLVUT36M+YQx0tECc
         3fgbGftSKCtqNbBdkx49DJ75NGkj51lucvDv20l9SMKDNHv4+8URQOU6OkQT2lASZZWP
         ZP5NN3kRxKOMYDgoKWvTSYLksomOI+r5nqx1NUZsnuiHjv5e90SWEK3mQDKcD6A4Ya6k
         K6yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763114178; x=1763718978;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bBVOoNqFhwsPHm7ZfvVyx4joY9OcOopeLcICnJu5J8c=;
        b=Et6R2tqK1qIRDQinARTahq+DuP9qkzStfTwfpADPEK+H/abmlzN2J71BLNKNNHsT9v
         7NGCksJgxFKAlVHtlUtHWGDWlrPYsBUysPLEfUyVQN6wu5AiX8TB1X8236k/vupPT2CU
         dLiofM6SsnqwmqcignNozxSrkIEsCbTyxBR7PAfZ0NavU1hPdcbz0AXHL4hERc3RFok0
         AEGdVNKxBq3mgnpitJH/XwmF1rlMgCFnVie6+oGE5OsQZhAB7tUqcr7txhENm2bdY9dg
         8KGWbhV+tFvcyB0yf3BFKNYl+aL0uQ1SS/a4N5Ffv2VZTUAnSd7V7JfLx3MtjdUZ+TAG
         F9wA==
X-Forwarded-Encrypted: i=1; AJvYcCWpdD2U18eaqqx7rI9IaZcRje8K3SJckK9aCSiJGaBoT9cloIpp6Pk10YWuoje+7vAp/WuxK62U8QTm@vger.kernel.org
X-Gm-Message-State: AOJu0YwYOj7F/Pn2EJg/20zmvn0k/z8Qwv0ot+/6QXYNt+yuQY7bzbwc
	jQmjTaGsRFK5g6S8Lgf5RNxSBE7Zp4IrlTTIGUaS94wuPFAGgFr87lrg
X-Gm-Gg: ASbGncsk0ZT7yO3pjY6EVU/guPdClrUuSDNi3c5bLwWeksT5HaIRW4i2BAol2OEHrPt
	sPBaC5p0aMdATGAIe/M4qq/tnnEb062ZPQci6JmIGLVPwm+NLbSIQ6E1wJgcyH4QriROI+n9buD
	WNrcsTXWFdBllqwAvXPlICtHeSlZlIzz9amJuSXWGLMZ6XKNAYWfkpr8dA36nQvvCOQIkTXGmaR
	8fieoxqpI+fOpqrcyT2V7TzrwtIm4etio4WIfpZGZNTztvo1+IxA/dcUtmAst8LCrdx2REHtDHm
	bFFoUWbNJL1UzEDoqMtzITSi9r1gJ1DAytoGVGzLQQkxoIYYjar/uc1d4IjSxULeJ3/e/zr1te5
	JQTUKNzI+IqqoyvLyisU57Q6dQhY3CTpq3fAKxRgzExKKt9zxbdEkgUjRkWk+O2+e77n69+MPqP
	8=
X-Google-Smtp-Source: AGHT+IHHgGCKOF9tFpKzfW6+qqauv+4Hrft6r6ZUIP6DlXKFggTMTtID0iUlF642FmhABUIh0q3EwA==
X-Received: by 2002:a05:6a20:258c:b0:2fa:516e:26ca with SMTP id adf61e73a8af0-35ba22a5d94mr3353857637.39.1763114178299;
        Fri, 14 Nov 2025 01:56:18 -0800 (PST)
Received: from fedora ([110.224.242.132])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bc36e8a58c4sm4337741a12.9.2025.11.14.01.56.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 01:56:18 -0800 (PST)
From: Shi Hao <i.shihao.999@gmail.com>
To: martin.petersen@oracle.com
Cc: James.Bottomley@HansenPartnership.com,
	MPT-FusionLinux.pdl@broadcom.com,
	i.shihao.999@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	sathya.prakash@broadcom.com,
	sreekanth.reddy@broadcom.com,
	suganath-prabu.subramani@broadcom.com
Subject: [PATCH] scsi: mpt3sas: fix spelling of "support" in comments
Date: Fri, 14 Nov 2025 15:26:02 +0530
Message-ID: <20251114095602.22222-1-i.shihao.999@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Two comments had misspelled 'support' as 'suppport' by adding
an extra 'p'. Remove the extra letter as it improves code
readability and maintains professional code documentation
standards.

Signed-off-by: Shi Hao <i.shihao.999@gmail.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 3b951589feeb..396bf1dc9bcc 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -3830,7 +3830,7 @@ host_trace_buffer_enable_store(struct device *cdev,
 }
 static DEVICE_ATTR_RW(host_trace_buffer_enable);

-/*********** diagnostic trigger suppport *********************************/
+/*********** diagnostic trigger support *********************************/

 /**
  * diag_trigger_master_show - show the diag_trigger_master attribute
@@ -4133,7 +4133,7 @@ diag_trigger_mpi_store(struct device *cdev,

 static DEVICE_ATTR_RW(diag_trigger_mpi);

-/*********** diagnostic trigger suppport *** END ****************************/
+/*********** diagnostic trigger support *** END ****************************/

 /*****************************************/

--
2.51.0

