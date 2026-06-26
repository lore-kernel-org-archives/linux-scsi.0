Received: from mail-dy1-f227.google.com (mail-dy1-f227.google.com [74.125.82.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCD6380FF8
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2026 11:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782474539; cv=none; b=EFUZS+5bgbQvgs4gRa/m+x65zwbScNpsVwp12hH4Nvp4GXxSbm7K9w5SyjXtSO6TJ5w1eTPR4QBmOI7DtaliKzciO0j+NWyVIr751PJHpUUllGkzuR48WSNrq1xMQRMoqrVDtZ0s3Q2C/qmME8K2ahSo2QTJiuImYCX5r7BohWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782474539; c=relaxed/simple;
	bh=IFsjNIGQnTnC4zZRFYGmqqRYyd6306co2TCoR/ghKsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W9fO0NsxRLHICMMbNE9/s0RcNHkMc3uK1KLr9sIx8+2a+l+u7b/8OzyWANHPUXye4BrI3MUwyNaNerpsFm4flOwb0iwY9g5VRg7ZLYkxLuJS3SGhvrKtBqGua4EKc1IurZbR6cwJrQEDNyG0ELEEZ2E0FyhGRWjzK2FADJdudrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=XoLHo005; arc=none smtp.client-ip=74.125.82.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="XoLHo005"
Received: by mail-dy1-f227.google.com with SMTP id 5a478bee46e88-30bf132969bso1351280eec.0
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2026 04:48:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782474537; x=1783079337;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oGoFjwpEcSO8ifbIh2YfJkC24mYNsF+ThQJRfQ7tsqM=;
        b=Z9/FkiwIWfDRiuoLvqWFmdZ3OZohFkB7PvTVl9DnFrNP9V4UuSKTWZv7JLWn1vrtUK
         EWWLlbxf+Y5GcLsHEGYtY5bscKh708udvW595Ss+TQRD4WcxQGqsdlq4jXy1ihkiqHlO
         JxKEHTrF5vwX5/qE73avteJ6kpku7s5L0sRgFMcgUKVHXYQUE7wDEkr/JMO06oia+4QK
         nBxMX+dHwnp399kaEhysk2gxSplBCkos0T+f4KSbYkVQdKM+2qgLvNQvt1ewDsWasfWM
         buPbXL/xzp4d7Y4SVS0c3Ykg3ZMdSPE7+rAQ9IZs6xUVu/YMLmCkBB1ncaG2J5eD60BJ
         sCnA==
X-Gm-Message-State: AOJu0YxlGXfRlJfg4EXSCxOMKOvM8OOsQVfu9BP/Joql8YHAEqg9TIj4
	bF3cCgtfzZdUm9i5uPl0tcHhjYnX0UlW5u3/8JCt/PiddIe5OO4BSnYrdgO/FvG1DsZT4u2TnFf
	ewug5S79UBAzHUOzmiITDGTOR4Rax3lTdcbxCuHJW+gibVxyamqOFf3ueetlhV8m5bh2NGEoORG
	j95lR7Kcn495wvcNGkzgZHz/hISFKEHjsExl/2bUVFjzDXpZ14OK3x9ilpjJ5oaRPFnYi0aX2FC
	QGCM862Y82PRPhm
X-Gm-Gg: AfdE7clcFXYK7wwOSE/LANzt9YQY5LKEJNaaiv+Ou8EpZnerXR5/2/HgWhIewsUkXPg
	6anjo7CRU8erJOqx7Wr3fQVkTYI5pkidiyJiJexMhN82mfcD8I1Oi0k2RzdqMcmxFVsZ9JDfpEZ
	XgXNZI1v9C8BhxknDm/jnGwZPwwZGinVhLPn02bmnMN4huu5H7ngP4O32SPlaH84FfLuzM6mZU5
	/876umONWEGfxGA9tENUouUmdK3IZpIyy2wkCh8wqeHMgIf64inJU7MojBlUW99EcJVIVykNYgf
	A9CBiAJEmWmptZ6zNu2jgFazW9ayyltxmSgy9i71sO6RlPLEVs+r5GvJnEG9GpdVPE6FWlFQk8E
	EdXOJTwC7L46Fa44+pFsEo8jfL7N8HiGfSzsLJ2Kn0Kd1bXa7ihW25KHZhjJztB4vBQlFh3NKhH
	3QVeHFthGQySgwCbwneTJlhVD/npZbmn4ytnKUG9Bq9NmObA==
X-Received: by 2002:a05:7300:324e:b0:30b:c4e3:8235 with SMTP id 5a478bee46e88-30c84d9f7afmr4640191eec.27.1782474536692;
        Fri, 26 Jun 2026 04:48:56 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-25.dlp.protect.broadcom.com. [144.49.247.25])
        by smtp-relay.gmail.com with ESMTPS id 5a478bee46e88-30c7c8208cesm445737eec.27.2026.06.26.04.48.56
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jun 2026 04:48:56 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-30ca81e05bfso188597eec.1
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2026 04:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1782474535; x=1783079335; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oGoFjwpEcSO8ifbIh2YfJkC24mYNsF+ThQJRfQ7tsqM=;
        b=XoLHo005QNu4fFXDMo7FnLzNrt09qF/6rk2OdD7xjJNvbioYukuic6yw/uD4o45Ff2
         M3T98Tz/wWyIEiXrZJHKW+9B2q/2jqABuBSXXESDlwYe1emwqR9GY93GStGTTwCdaTMX
         fWhoHsn0WI34BfHSBe9Vbk75OH5SOdsSgzPnw=
X-Received: by 2002:a05:7300:d021:b0:30c:536e:3a8a with SMTP id 5a478bee46e88-30c84b7208amr5861837eec.6.1782474534789;
        Fri, 26 Jun 2026 04:48:54 -0700 (PDT)
X-Received: by 2002:a05:7300:d021:b0:30c:536e:3a8a with SMTP id 5a478bee46e88-30c84b7208amr5861780eec.6.1782474533622;
        Fri, 26 Jun 2026 04:48:53 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7c58831asm18844838eec.13.2026.06.26.04.48.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 04:48:53 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 08/10] mpi3mr: Fix SAS port allocation and registration error handling
Date: Fri, 26 Jun 2026 17:11:07 +0530
Message-ID: <20260626114109.43685-9-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260626114109.43685-1-ranjan.kumar@broadcom.com>
References: <20260626114109.43685-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

During SAS port creation, the driver does not verify successful port
allocation before attempting registration, which can lead to a NULL
pointer dereference. Additionally, if registration fails, the allocated
port is not freed, resulting in a memory leak.

Fix this by adding a NULL check after allocation and freeing the port
when registration fails.

Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index 240f67a8e2e3..1b793d86f758 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -1428,9 +1428,15 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
 	}
 
 	port = sas_port_alloc_num(mr_sas_node->parent_dev);
+	if (!port) {
+		ioc_err(mrioc, "failure at %s:%d/%s() (sas_port_alloc)!\n",
+		    __FILE__, __LINE__, __func__);
+		goto out_fail;
+	}
 	if ((sas_port_add(port))) {
 		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
 		    __FILE__, __LINE__, __func__);
+		sas_port_free(port);
 		goto out_fail;
 	}
 
-- 
2.47.3

