Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D46470106
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 09:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789117845; cv=none; b=Y0mxYns85m5mJ1ZlMuROwj8yQhloUNvaCDOEa93cDRqkScu3mSflMWjFItD4b4tKipaHSGIYVS3a5g5oifGH5ldrM+wa3/ooH+VUXRGYpIpXVMEi1zv4l36T2XZfUTtN7kz6HGEhi82p4eFp7Gd9V/uNMrmapg1Jsz68ElvIaOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789117845; c=relaxed/simple;
	bh=AGg6S4AMjsE5W7AWkjJFV5z4wU1p9d6Na83XsrH5Fzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l7ZdHUjBJcT0GERIhiqNCM3WkOR/wVEJjomcw82rc9ELUaE2Big//pZ9H46LBEtX34NF+4IWuWS/1hOiTq8MogBpkBipPtDLuvHyW/ConPLE+8l9MBdZV17SWBdE9pllhcQ5LJyZ0eZvR3di/M/DE0T1dzdw5JAUSyMYydqMX84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XNCpy2QL; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XNCpy2QL"
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-85469b2e1d5so618915b3a.1
        for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 02:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789117840; x=1789722640; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hBTMBrYc9oEfOzXDBLhTExzFtkEu2YKRe7Pr/T23JSA=;
        b=XNCpy2QLLv1PArvTPFKMRz3mrJOreWlijTDAzE79OGESaIBRFAG5zHepQ+e4oxDLiV
         TwONknaBVZJeV+17YnydMwYVGzYzcxxJQsV/F0NHhzEv+MzBlfp9oTOgyD+67L1GZyQn
         Sz2YSt3D3GVCOzXx2foQhcvNq60fOTsEbn9YDUVULWjGRaG51MAXeKzR6/ZtdRqvt61l
         ctx2B4jNWVOlrsF+QZsjgl2KGMlgCNhbmJIS69uBP7WDmDRgxl0jweMTwEzQLvmfKSPM
         2TMNzFE3hOWg6NtuPIB3munCbtMJ3Fdh95GkDlEw23WAgDOc2KdaYKKO8Q/WTye+1IL+
         olCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789117840; x=1789722640;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hBTMBrYc9oEfOzXDBLhTExzFtkEu2YKRe7Pr/T23JSA=;
        b=Q/uArUYTkgCXK05s87fGJL6HH+Jdwghu/o/JD0ENLsKoAAh966JrkJIPO6hdJdk/xx
         jdOgm/q/+IR/e1F5yE+qKpEfI16bL9hzKlFT6y+kLllhIEVMJevYzPmM3PFsqvbOV7+V
         d0KJCjoQyX17z+ZEP0FCH+f3ESvXTrrci8ASDUXJxHU6cq2fuOZJeMVzwohfqQ1SoA0f
         F3h2VG1wHLp+4VjO5iJkX9Si8YXkCiPVfxpwBR69dOSjbLtNBC2l9VlbzGtTVcMHdngV
         jZbZ16xJ1Aaajf+eO0LdAc8g22KnMUIFIz5drEG6TfRsq8baFJXixycD2/BIRhvoZ0CV
         6Qtw==
X-Gm-Message-State: AFuF++ldQBfRBytqp8ciYB+bSmyJBKsOr9zOVMZ2FnREmCD/HXkG6DD2
	XLf3vvENH1hRJ8WjPqgXdV/E6fyZuyyY6Afc6snKWSArxS+5d6FaS+yG
X-Gm-Gg: AYBFou0NjUbs/OgYTqihAjRWzYdLYOpdSRRFoPPPYzi8Wk/X+yrH/ovfY9qoKtqInPd
	6l99NhNbJ6Y6K3uGTGpt9sxQ12Kj7WO68+fPztqyUzqA8N2qkn0mqiz8yN7rswhIkewRWcpYU84
	2zDXlbmEY+JawWHIZFXq3bppnwvUIoLOTNlkQcM4Rh7IvmtvbXmBVROhhpabpVw/0WkZ5j25Kc1
	4N903S+AT2ddFBrwljc1q25tYxvLuVlUReXC6qlL7j0puB9a+m3pVZ+jPccPSAzg2Iz4KoBMkHd
	X5TuzSqeQNMxh2XOn/2+8BfOIr9M1b9vjgWaCkjqUA7iPSNGhAyoSX7wQG01iDvy70Y0d5KPtha
	jN1Z+iE15TlHbiZfmxQiR2TbGitKNeBNKUtF27NdD2Fkds+waO6m6j3jbz0bdmqCbXHLYuYeRne
	Fp254j3zqzyplhTh9McJDS9Wx3Dk7UnIOOwDeC7KSh2rdd+FArR2Zsrq9wgKXhFGPxwxg2WQCfm
	Fw34RRlIw4H2NhZwxQLirBPC6K1BOJUIyPAlrg/2w==
X-Received: by 2002:a05:6a20:6a1c:b0:3c3:a3fd:db0a with SMTP id adf61e73a8af0-3daed2e2e68mr5740110637.16.1789117840501;
        Fri, 11 Sep 2026 02:10:40 -0700 (PDT)
Received: from FLYINGPENG-MC2.tencent.com ([43.132.141.21])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc4c6572ecasm822522a12.22.2026.09.11.02.10.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 11 Sep 2026 02:10:40 -0700 (PDT)
From: Peng Hao <flyingpenghao@gmail.com>
X-Google-Original-From: Peng Hao <flyingpeng@tencent.com>
To: jinpu.wang@cloud.ionos.com,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org
Subject: [PATCH 4/4] scsi: pm8001: free MSI-X vectors before INT-X fallback
Date: Fri, 11 Sep 2026 17:10:11 +0800
Message-ID: <20260911091011.94676-5-flyingpeng@tencent.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20260911091011.94676-1-flyingpeng@tencent.com>
References: <20260911091011.94676-1-flyingpeng@tencent.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pm8001_setup_msix() may allocate MSI-X vectors before
pm8001_request_irq() decides to use INT-X. The fallback currently leaves
those vectors allocated. It also leaves max_q_num set to the MSI-X
vector count even though only one legacy interrupt is used.

Free allocated vectors before requesting INT-X, clear number_of_intr and
restore the single-queue configuration. Clear number_of_intr as well
when MSI-X IRQ registration fails after the vectors have been freed.

Signed-off-by: Peng Hao <flyingpeng@tencent.com>
---
 drivers/scsi/pm8001/pm8001_init.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 594f8c0595e9..65bf10caa327 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1050,6 +1050,7 @@ static u32 pm8001_request_msix(struct pm8001_hba_info *pm8001_ha)
 					 &pm8001_ha->irq_vector[j]);
 			}
 			pci_free_irq_vectors(pm8001_ha->pdev);
+			pm8001_ha->number_of_intr = 0;
 			break;
 		}
 	}
@@ -1087,6 +1088,12 @@ static u32 pm8001_request_irq(struct pm8001_hba_info *pm8001_ha)
 	}
 
 use_intx:
+	if (pm8001_ha->number_of_intr) {
+		pci_free_irq_vectors(pdev);
+		pm8001_ha->number_of_intr = 0;
+	}
+	pm8001_ha->max_q_num = 1;
+
 	/* Initialize the INT-X interrupt */
 	pm8001_dbg(pm8001_ha, INIT, "MSIX not supported!!!\n");
 	pm8001_ha->use_msix = false;
-- 
2.43.7

