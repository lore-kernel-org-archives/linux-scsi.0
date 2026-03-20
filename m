Received: from mail-yx1-f99.google.com (mail-yx1-f99.google.com [74.125.224.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931B536EAB7
	for <linux-scsi@vger.kernel.org>; Fri, 20 Mar 2026 09:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773997825; cv=none; b=pMbFNQ8aQQBD6QqSE0gyDhXsmUJsSo3rTsbVJMieszZGHaL8M+Gl/6+NQ90s/S4NhrylYECb3vCj43tER7BxnGQHw8XCUOrqSmY4qIDv7pkzsNTz65mMLmUmeDw40mkPwpxEIm+0CwaVRQSlUTesuFMDh8LyATgalLPaezTgeek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773997825; c=relaxed/simple;
	bh=W4bU6InNhIzdjIOOIR/z6p8Vsbpn5ZxVEaFlSSzEkXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yu3ywXSipr5X6DT3e2UU3kUCz//O+KoXMc1XGDG4LTbP8AzWBHzuWr5K6zjuz8QeUwtO5cvEgMHyQetNjtOXNSUK8JEQUdmQhK7JYuu+Q9n43HFWyltx9yn9t3z2AdzD7JxZK1DPwWCrAfuVQUjFJYWCd2lFIqGbeS/HIy6+eVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Gnzv+QJq; arc=none smtp.client-ip=74.125.224.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Gnzv+QJq"
Received: by mail-yx1-f99.google.com with SMTP id 956f58d0204a3-64ca4dfdd88so364787d50.0
        for <linux-scsi@vger.kernel.org>; Fri, 20 Mar 2026 02:10:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773997819; x=1774602619;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t4P1QvTCJ8BdYWXWowJhKAlk/qQowHX9TMHnRrSNmuw=;
        b=d04OnCaGmSWS4SikZ6x3aCKLzFX4MFUd3xHz1F5nYu0VqDH+5jlrxFmPp8cEVV7JhV
         JDt9LF8FiqjZA5JpP96b/WMDkPdegkeSJjju04LLQHdcSBfHfE5vi4b4efo6efGLFktt
         djrRK52v8ciZfnyz8aLZuvXw+9Z6gZizuBo/wx2m4u6QTF22GirNw4TVJZ+qIsa5q6FT
         D6ZYL8r9XUo+wUsXrAB4VSzeubIxorWPKawatbROnkNGxA3DJEp3fxZEI+sdenLTLJIq
         izI74opgznIL5C153k2m2VlI/F3Ite+dgJgDCVOHTdJO2Z+uySR6CBd7f9nQAm62ZQGr
         ks4A==
X-Gm-Message-State: AOJu0Yzi1mrV6+l7VVRkgAnci1P2PlmdrK9oJ+W3R+45xgmm0eHMWZQt
	7CyjTehD8XQS489+iX4nQT8IYvjuAN08YvpOxgWmQqXdas/U4fLM4vLQj+88I1MKjjelnGKHaa+
	IQ6uA08mxq2AlS0WsuXV66gMTQQl7kzWDg6rIpza5fCRRHyt83MKZZdTAUYbs7H6h1rUgvN2Buy
	7bMUEkIikDHi8RUITlU5RyMBkMwRjw3RC6AC2agyxsHz/qS59rrxE2oQ4WrI7FfnDqCID2Qoxsm
	34NROfHuMIWuMb6
X-Gm-Gg: ATEYQzyIZ9LboO7JTP1TV7O443oaQznDfo3yDyTiQpZ3LEm7t3Jqj0OFZQP9uSKLpy9
	eGKdl0RBrhPEkL7qBZ01a/0UqkNeQqVoPbpqM+nMNzfTmQ2tRERY8/UkEirbfFtcdeOGZpzNrmO
	Cgf7QV9BKVsT6tzD+ULKG00QnHu9mOa4MEQ/Dc/Ij2OhknMobk1oYTNOL1HGrKR2fEIiI/+SlXF
	zPl/9LijndNUYy+SEraXxHCqN5xSthazzl86wyrr+oL/hpO8RVrP1QQ+K6rWRHU7wXYQCwHehp3
	hsLfhw2aFSyOjqQNvTirxH9rtLeDWk1iMzXXKVdMTM37Ig/FmQ2LJpxkcDpLjzNM4/iIMwKg28G
	441+gFBU8/4u49hZHtn/RDf/6NJBuvxgsEx1sKIS9hx9slS9R3aXu8XJa39QbwPh+oYEwt+wmMx
	R2iFzsCDjsLeHaOq1yzwbxSv0/hBM6naZBRhqMAxhrJGlEALVQoGRjKoM3py8=
X-Received: by 2002:a53:e952:0:b0:64c:a59d:b0d1 with SMTP id 956f58d0204a3-64eaa7c2ademr1868609d50.39.1773997818979;
        Fri, 20 Mar 2026 02:10:18 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-102.dlp.protect.broadcom.com. [144.49.247.102])
        by smtp-relay.gmail.com with ESMTPS id 956f58d0204a3-64eabd81147sm181429d50.4.2026.03.20.02.10.17
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 20 Mar 2026 02:10:18 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-yx1-f71.google.com with SMTP id 956f58d0204a3-64adee81de7so970068d50.3
        for <linux-scsi@vger.kernel.org>; Fri, 20 Mar 2026 02:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1773997817; x=1774602617; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t4P1QvTCJ8BdYWXWowJhKAlk/qQowHX9TMHnRrSNmuw=;
        b=Gnzv+QJqYpcw90n/zMgrRpf7TIHU7CO2RifGJtiS/nn0t4pmdUFKp/W0f2t7bmck4S
         QpS20OgC1elekoWMsi2dqgH1sAHeIyFnMYZXJ9FPsTP1Q/GPSvY2KICDpGRzo/ci6WFL
         4St7jzmXwLmzvuS6S1d4FIZvyY/jCT5jGMvn4=
X-Received: by 2002:a05:690c:c4f1:b0:799:1913:116d with SMTP id 00721157ae682-79a90c4d758mr21641117b3.55.1773997817143;
        Fri, 20 Mar 2026 02:10:17 -0700 (PDT)
X-Received: by 2002:a05:690c:c4f1:b0:799:1913:116d with SMTP id 00721157ae682-79a90c4d758mr21640897b3.55.1773997816663;
        Fri, 20 Mar 2026 02:10:16 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-79a9057b738sm11680357b3.36.2026.03.20.02.10.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 02:10:16 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 3/3] mpi3mr: Add retry mechanism for IOC shutdown with timeout reset
Date: Fri, 20 Mar 2026 14:33:26 +0530
Message-ID: <20260320090326.47544-4-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260320090326.47544-1-ranjan.kumar@broadcom.com>
References: <20260320090326.47544-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Enhance the IOC shutdown process to handle transient failures during
controller cleanup. Add retry logic with configurable maximum retry
count (MPI3MR_MAX_SHUTDOWN_RETRY_COUNT) and proper timeout management
that resets on each retry attempt. This ensures shutdown can recover
from temporary issues without failing completely.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h    |  1 +
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 32 ++++++++++++++++++++++++++------
 2 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 631a48f7425d..c25525fe0671 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -159,6 +159,7 @@ extern atomic64_t event_counter;
 /* Controller Reset related definitions */
 #define MPI3MR_HOSTDIAG_UNLOCK_RETRY_COUNT	5
 #define MPI3MR_MAX_RESET_RETRY_COUNT		3
+#define MPI3MR_MAX_SHUTDOWN_RETRY_COUNT		2
 
 /* ResponseCode definitions */
 #define MPI3MR_RI_MASK_RESPCODE		(0x000000FF)
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index da0d475db01e..7983c3c01c65 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -5061,9 +5061,9 @@ void mpi3mr_free_mem(struct mpi3mr_ioc *mrioc)
  */
 static void mpi3mr_issue_ioc_shutdown(struct mpi3mr_ioc *mrioc)
 {
-	u32 ioc_config, ioc_status;
-	u8 retval = 1;
-	u32 timeout = MPI3MR_DEFAULT_SHUTDOWN_TIME * 10;
+	u32 ioc_config, ioc_status, shutdown_action;
+	u8 retval = 1, retry = 0;
+	u32 timeout = MPI3MR_DEFAULT_SHUTDOWN_TIME * 10, timeout_remaining = 0;
 
 	ioc_info(mrioc, "Issuing shutdown Notification\n");
 	if (mrioc->unrecoverable) {
@@ -5078,14 +5078,16 @@ static void mpi3mr_issue_ioc_shutdown(struct mpi3mr_ioc *mrioc)
 		return;
 	}
 
+	shutdown_action = MPI3_SYSIF_IOC_CONFIG_SHUTDOWN_NORMAL |
+	    MPI3_SYSIF_IOC_CONFIG_DEVICE_SHUTDOWN_SEND_REQ;
 	ioc_config = readl(&mrioc->sysif_regs->ioc_configuration);
-	ioc_config |= MPI3_SYSIF_IOC_CONFIG_SHUTDOWN_NORMAL;
-	ioc_config |= MPI3_SYSIF_IOC_CONFIG_DEVICE_SHUTDOWN_SEND_REQ;
+	ioc_config |= shutdown_action;
 
 	writel(ioc_config, &mrioc->sysif_regs->ioc_configuration);
 
 	if (mrioc->facts.shutdown_timeout)
 		timeout = mrioc->facts.shutdown_timeout * 10;
+	timeout_remaining = timeout;
 
 	do {
 		ioc_status = readl(&mrioc->sysif_regs->ioc_status);
@@ -5094,8 +5096,26 @@ static void mpi3mr_issue_ioc_shutdown(struct mpi3mr_ioc *mrioc)
 			retval = 0;
 			break;
 		}
+		if (mrioc->unrecoverable)
+			break;
+		if (ioc_status & MPI3_SYSIF_IOC_STATUS_FAULT) {
+			mpi3mr_print_fault_info(mrioc);
+			if (retry >= MPI3MR_MAX_SHUTDOWN_RETRY_COUNT)
+				break;
+			if (mpi3mr_issue_reset(mrioc,
+			    MPI3_SYSIF_HOST_DIAG_RESET_ACTION_SOFT_RESET,
+			    MPI3MR_RESET_FROM_CTLR_CLEANUP))
+				break;
+			ioc_config =
+			    readl(&mrioc->sysif_regs->ioc_configuration);
+			ioc_config |= shutdown_action;
+			writel(ioc_config,
+			    &mrioc->sysif_regs->ioc_configuration);
+			timeout_remaining = timeout;
+			retry++;
+		}
 		msleep(100);
-	} while (--timeout);
+	} while (--timeout_remaining);
 
 	ioc_status = readl(&mrioc->sysif_regs->ioc_status);
 	ioc_config = readl(&mrioc->sysif_regs->ioc_configuration);
-- 
2.47.3

