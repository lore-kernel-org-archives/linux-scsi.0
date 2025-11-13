Received: from mail-oo1-f100.google.com (mail-oo1-f100.google.com [209.85.161.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA57C2F7AA7
	for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2025 15:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763048605; cv=none; b=RKVYNhct6HYDgv+E6C8TdxeTyLvUzMx+msVm1lenOYGoGMbquyHXB9cMgHnxFG65iUljNl+hzUJZIAP+pJvAcuV9Xggon7hpLbUFb0toY0o5EcJOhLD31S39K9Jz5JJqYYO6wr6/z3WOh7eTx3XheDWR/SXfbyKl4UjR67wj2kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763048605; c=relaxed/simple;
	bh=yaG/650r+t85NUeckWNyBuV9qG1H2TDCY5RtmhPLtyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FQ1uAJrL+nnmIV5M5t0SwWU1U+CSKS36g98CAIIWY9h6B4YVrLwxg8rPb0oROsbRPgFlieMK6U+c2H0XHgnqblJaT1KBaR2uBS3CHNrIgPIDySu7ZiZ1gwKemcW4LLdwheMnOLsMZ96gcvZFV0yzBF6jE1MVZCsfKOgaZ8VOXXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=LIYxLqJl; arc=none smtp.client-ip=209.85.161.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="LIYxLqJl"
Received: by mail-oo1-f100.google.com with SMTP id 006d021491bc7-657230e45e8so461987eaf.1
        for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2025 07:43:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763048603; x=1763653403;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J+joVmw9sAQigsa4Ytd3NW1uhck7qtpSs5vmBA24ygQ=;
        b=UeWw9lJh/Fvhew0ASxcxmLvP67Gy2gffx7BqbzAWJt5/v7wGWhoOEyqblj8ekb2WIz
         U42Gpw+0sRb8Ehub+bBsq0EZgIEZg0xISej+LcLrYGsHYX4FS67ZkDCQduC0MGfnvBSt
         MmT/C69IAJDmGxUXaqfprT6gb/tPNpe0nLbC5pVA+AeOpgNNocCkc+UmM5rJjZbcu9GO
         8p5XkQKNixvFvJjyte51OYEqFp7YaqybQAsVNjoJJFUCJdUacur1hYMwOqdRBOO5O40z
         5XTH0XOoyt+ertiLVy7SKiqFtbrBz+HDy02Q62FFJP3z+vOxBPdgx896cWbofXjJt97o
         uoBg==
X-Gm-Message-State: AOJu0YwHRpKI+k+brzJkgmMxrwybD/eDX+nfyj4/An40Pw3hhbA0IxvL
	KT7TjlKBJoSKgoQNkmf85k5f4j7uWWnilLbQBBWQq1TbaovtgqW8NKYzq639lVMCa8vZLxpmr2I
	WgxXa46FBGrt4vkyuAKjGEuyv4myW1a8CQDFH+Ef3T2dJaFqWrd7A7NbFVd1kDsXhFLB8JgXXa/
	CiNKzULXxeuL/UEfyhWXFot5gGJMXTHCref7yHetJmJHTo+cNwiJ/upFa3aNP09J1atxnpC0Avt
	JznIWo6Xz8+pcws
X-Gm-Gg: ASbGncvD5ltGZ+kbsy8RlgEiHsE3dzB/aU2/7Kcq4B4aFVxRMLMDb4psCPjoa8kauXy
	lkyRLH2xk1GzR9d7MP5pZGGJQQ1/pzJJoTQCIeSF5qv0cSzrSU3P2evxGU4RuaoDHNN/6nlcPQJ
	b4gr8xc7tZbqxJcup4jJD02nRgSprxkjD94LdLJflDhUvy/89SCzkNB6K0Fq6SvcLA1+KcpvloZ
	jDHrLItIHQS7iRsM9aT+Mapzoi4Lmzg+PptWGo+ua/m2JN+0nt3fcRYULiu+gTEwPknm4gm4DRh
	vL1vosXHYRjD/kxirf9gr9WBTHwNWUqHoC0UfU9JTkMar5Q68wwgSnwSOeDceLlVjBmnyyDiVtf
	UP+Or5bE8r+BIAJEP62jRqPuhwy/LhqbmJ92aiQKbK5U8BA3RXR3uh7iaaI7OyW/YDy4QZ91cS5
	SwKvU4gjZM3CupnOlXMWRkUpXQNWy6QEWqjg==
X-Google-Smtp-Source: AGHT+IFzRENjWDZyT55fRQjDYInhBzQSFmvWuwEDidx52yegjNEeTFi5QttHWqCc69+pMKcaK8MOTY6AERYs
X-Received: by 2002:a05:6871:2995:b0:3cd:aa60:c2ed with SMTP id 586e51a60fabf-3e8671b917fmr28831fac.2.1763048602694;
        Thu, 13 Nov 2025 07:43:22 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-14.dlp.protect.broadcom.com. [144.49.247.14])
        by smtp-relay.gmail.com with ESMTPS id 586e51a60fabf-3e85200cecesm194090fac.7.2025.11.13.07.43.22
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Nov 2025 07:43:22 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-297f48e81b8so18502635ad.0
        for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2025 07:43:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1763048601; x=1763653401; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J+joVmw9sAQigsa4Ytd3NW1uhck7qtpSs5vmBA24ygQ=;
        b=LIYxLqJlOEMKOEbMRJMYSrq49QLyOQNGiReIrSdr7tdOJOIrXwj6sOW5FWE4B+eZUy
         zsAUOLtwCMNqV9+1WuYQmX2iaQ7nIvwip/2fuWJ04DV92zwQaIkkKO8eUv6uOIHWaNEh
         px6DDmPX7zvSrPKrYARFw0W4Aiyb2TwtC7HAw=
X-Received: by 2002:a17:903:b4e:b0:24b:1585:6350 with SMTP id d9443c01a7336-29867eedaa0mr768935ad.11.1763048600950;
        Thu, 13 Nov 2025 07:43:20 -0800 (PST)
X-Received: by 2002:a17:903:b4e:b0:24b:1585:6350 with SMTP id d9443c01a7336-29867eedaa0mr768625ad.11.1763048600359;
        Thu, 13 Nov 2025 07:43:20 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2cca66sm29100085ad.99.2025.11.13.07.43.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 07:43:19 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v2 5/6] mpt3sas: Add configurable command retry limit for slow-to-respond devices
Date: Thu, 13 Nov 2025 21:07:09 +0530
Message-ID: <20251113153712.31850-6-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251113153712.31850-1-ranjan.kumar@broadcom.com>
References: <20251113153712.31850-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Adds a new module parameter "command_retry_count" to control
the number of retries during device discovery and readiness checks,
improving reliability for slow or transient SAS/PCIe devices.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 84 ++++++++++++++++++++++++++--
 1 file changed, 78 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index eb04ca5e0043..ac69a5abe2e2 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -195,6 +195,11 @@ module_param(host_tagset_enable, int, 0444);
 MODULE_PARM_DESC(host_tagset_enable,
 	"Shared host tagset enable/disable Default: enable(1)");
 
+static int command_retry_count = 144;
+module_param(command_retry_count, int, 0444);
+MODULE_PARM_DESC(command_retry_count, "Device discovery TUR command retry\n"
+	"count: (default=144)");
+
 /* raid transport support */
 static struct raid_template *mpt3sas_raid_template;
 static struct raid_template *mpt2sas_raid_template;
@@ -3927,11 +3932,24 @@ _scsih_ublock_io_all_device(struct MPT3SAS_ADAPTER *ioc, u8 no_turs)
 {
 	struct MPT3SAS_DEVICE *sas_device_priv_data;
 	struct scsi_device *sdev;
+	struct MPT3SAS_TARGET *sas_target;
+	enum device_responsive_state rc;
+	struct _sas_device *sas_device = NULL;
+	struct _pcie_device *pcie_device = NULL;
+	int count = 0;
+	u8 tr_method = 0;
+	u8 tr_timeout = 30;
+
 
 	shost_for_each_device(sdev, ioc->shost) {
 		sas_device_priv_data = sdev->hostdata;
 		if (!sas_device_priv_data)
 			continue;
+
+		sas_target = sas_device_priv_data->sas_target;
+		if (!sas_target || sas_target->deleted)
+			continue;
+
 		if (!sas_device_priv_data->block)
 			continue;
 
@@ -3942,10 +3960,62 @@ _scsih_ublock_io_all_device(struct MPT3SAS_ADAPTER *ioc, u8 no_turs)
 			continue;
 		}
 
-		dewtprintk(ioc, sdev_printk(KERN_INFO, sdev,
-			"device_running, handle(0x%04x)\n",
-		    sas_device_priv_data->sas_target->handle));
+		do {
+			pcie_device = mpt3sas_get_pdev_by_handle(ioc, sas_target->handle);
+			if (pcie_device && (!ioc->tm_custom_handling) &&
+				(!(mpt3sas_scsih_is_pcie_scsi_device(pcie_device->device_info)))) {
+				tr_timeout = pcie_device->reset_timeout;
+				tr_method = MPI26_SCSITASKMGMT_MSGFLAGS_PROTOCOL_LVL_RST_PCIE;
+			}
+			rc = _scsih_wait_for_device_to_become_ready(ioc,
+			    sas_target->handle, 0, (sas_target->flags &
+			    MPT_TARGET_FLAGS_RAID_COMPONENT), sdev->lun, tr_timeout, tr_method);
+			if (rc == DEVICE_RETRY || rc == DEVICE_START_UNIT ||
+			    rc == DEVICE_STOP_UNIT || rc == DEVICE_RETRY_UA)
+				ssleep(1);
+			if (pcie_device)
+				pcie_device_put(pcie_device);
+		} while ((rc == DEVICE_RETRY || rc == DEVICE_START_UNIT ||
+		    rc == DEVICE_STOP_UNIT || rc == DEVICE_RETRY_UA)
+			&& count++ < command_retry_count);
+		sas_device_priv_data->block = 0;
+		if (rc != DEVICE_READY)
+			sas_device_priv_data->deleted = 1;
+
 		_scsih_internal_device_unblock(sdev, sas_device_priv_data);
+
+		if (rc != DEVICE_READY) {
+			sdev_printk(KERN_WARNING, sdev, "%s: device_offlined,\n"
+			    "handle(0x%04x)\n",
+			    __func__, sas_device_priv_data->sas_target->handle);
+			scsi_device_set_state(sdev, SDEV_OFFLINE);
+			sas_device = mpt3sas_get_sdev_by_addr(ioc,
+					sas_device_priv_data->sas_target->sas_address,
+					sas_device_priv_data->sas_target->port);
+			if (sas_device) {
+				_scsih_display_enclosure_chassis_info(NULL, sas_device, sdev, NULL);
+				sas_device_put(sas_device);
+			} else {
+				pcie_device = mpt3sas_get_pdev_by_wwid(ioc,
+						    sas_device_priv_data->sas_target->sas_address);
+				if (pcie_device) {
+					if (pcie_device->enclosure_handle != 0)
+						sdev_printk(KERN_INFO, sdev, "enclosure logical id\n"
+						    "(0x%016llx), slot(%d)\n", (unsigned long long)
+							pcie_device->enclosure_logical_id,
+							pcie_device->slot);
+					if (pcie_device->connector_name[0] != '\0')
+						sdev_printk(KERN_INFO, sdev, "enclosure level(0x%04x),\n"
+							" connector name( %s)\n",
+							pcie_device->enclosure_level,
+							pcie_device->connector_name);
+					pcie_device_put(pcie_device);
+				}
+			}
+		} else
+			sdev_printk(KERN_WARNING, sdev, "device_unblocked,\n"
+			    "handle(0x%04x)\n",
+			    sas_device_priv_data->sas_target->handle);
 	}
 }
 
@@ -3970,6 +4040,7 @@ _scsih_ublock_io_device_wait(struct MPT3SAS_ADAPTER *ioc, u64 sas_address,
 	struct _pcie_device *pcie_device;
 	u8 tr_timeout = 30;
 	u8 tr_method = 0;
+	int count = 0;
 
 	/* moving devices from SDEV_OFFLINE to SDEV_BLOCK */
 	shost_for_each_device(sdev, ioc->shost) {
@@ -4036,7 +4107,8 @@ _scsih_ublock_io_device_wait(struct MPT3SAS_ADAPTER *ioc, u64 sas_address,
 			if (pcie_device)
 				pcie_device_put(pcie_device);
 		} while ((rc == DEVICE_RETRY || rc == DEVICE_START_UNIT ||
-		    rc == DEVICE_STOP_UNIT || rc == DEVICE_RETRY_UA));
+		    rc == DEVICE_STOP_UNIT || rc == DEVICE_RETRY_UA)
+			&& count++ <= command_retry_count);
 
 		sas_device_priv_data->block = 0;
 		if (rc != DEVICE_READY)
@@ -7771,7 +7843,7 @@ _scsih_report_luns(struct MPT3SAS_ADAPTER *ioc, u16 handle, void *data,
 	kfree(transfer_packet);
 
 	if ((rc == DEVICE_RETRY || rc == DEVICE_START_UNIT ||
-	    rc == DEVICE_RETRY_UA))
+	    rc == DEVICE_RETRY_UA) && retry_count >= command_retry_count)
 		rc = DEVICE_ERROR;
 
 	return rc;
@@ -8027,7 +8099,7 @@ _scsih_wait_for_device_to_become_ready(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 	}
 
 	if ((rc == DEVICE_RETRY || rc == DEVICE_START_UNIT ||
-	    rc == DEVICE_RETRY_UA))
+	    rc == DEVICE_RETRY_UA) && retry_count >= command_retry_count)
 		rc = DEVICE_ERROR;
 	return rc;
 }
-- 
2.47.3

