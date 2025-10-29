Received: from mail-io1-f99.google.com (mail-io1-f99.google.com [209.85.166.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD6B351FAE
	for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2025 18:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761761838; cv=none; b=C7fX7xaR9FF91zuBQaa/knoCZYWGGOSS5cLz2X4v1RqTEyS5dp78F6IKVQOc+sgzeaL3Lk0ZCshXCbEJBYSIL0Yj4FzeYN7Hg4RYu8w7wzk2hB99pJigXIwZR3emB15EZ1rSWPgVdGwqNWJbODP1VFq9yfKuOsqWPI454tiD5g4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761761838; c=relaxed/simple;
	bh=woa8THisd2lsVwQV5ar5gy6507KowPdSt2e3KlddjdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wj6pP8GKNPs5wIXoD/KiygDNO/wIu2srbNFCPWbWvwYrGJ9QVk93Nht3Vmw30X4lzbBX22rb7HINFtwHZVqUhosSnVaWkfkapwqn/dfmh9t7Qk3bbEA05Ji6DfuhA8sCqFYU4ZTB/ZXUSMhQ5y2XLZv8om0ZQS5MZzuPVHm8AYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=cvVNtAnQ; arc=none smtp.client-ip=209.85.166.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="cvVNtAnQ"
Received: by mail-io1-f99.google.com with SMTP id ca18e2360f4ac-9435969137aso13864939f.1
        for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2025 11:17:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761761836; x=1762366636;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NghNMDq0ILDJ8uBRxw6+DAIxIxEorbb+IJgEMV7HWgE=;
        b=RQ2eaMv/asfWBtvyBcCF9ubpkOA4wzG9z3fT3JpEm7ABhGG0sXOxKnB4H96qzEH3Ta
         Go+9B7DP+57X2IxN0jtyW26t69hyoF6vrkTJIDVW2uCIqrgXAt+K7pexgYBAisNWX5HW
         55bJvOtjYpIuU8Ttv3x1G8Zp3yOmI3roI2aHWg7Aa3QNEtdC7Z5zSc6lpSYCS3QGHpAg
         uM4PkGLwqRDKTMAhnukcwiHuN6U9i395poRyLlVFrsTE7ifGBZ17RlBkMOjtl/Pg+FMM
         WPHgyRY0Or3yqBkVLvvojHj1AHcbpVxtRI215wxVoheILCModqZXKmE78cfi/Nj2wBXj
         MjOA==
X-Gm-Message-State: AOJu0Yxjkdr8h7ITSnToxo7lzgEq9wZsjx0XnbvOsIF7CmYvyvMWsQWP
	3NZCVAbo4ney+EU7vM70a8UyNVZYr62a/ueDet3Z1YVTWtlf/B8I5nn8rYBKke0wqkVYIEwKoBm
	aqOmbjpmqaYr9sHjrscnE3AQ0RnDZ5bOKLJYKWJcuXAVmWoZh20rswwt+bzd86ums0a6hgkNayL
	dBS3Sr0i5NxUGbRrZhPtJlNR6ySJheRrbeApbti2fn52gFP0E/DANx7LX/SGW8sfv+5NJaMxFzZ
	3xlhJdieTtJnDjS
X-Gm-Gg: ASbGncsQKh/j6YfHOhvayo3HPwV3KKiXdwZFo461a2ORFgJWg4jTIzSTu2pu4XFhkR/
	f8woHbyVS6tD/FYG6nwvWjUoGNqNqlVazAf7ZgCw/VWFB5HXkPthSsMVawObzhhyNcbAtTeSahZ
	7FMoF9tGM+8mlnneVe3/L71kTUBL3WP0OrsBp5ZQx+dkIe54ybCxaM+aD0m3+XlHbneL9dfjKat
	KNWZ6bhGLHBEFKWDSvyrshGg3JMA46I8FTs05698Epuq4cHLd63pmkREKVWWpeCXFAK6UawHXFG
	ldwfW7FRpRvu59cjOdVjrpDljzm1kNwaRevYc3l2RfBjUJOQhx+E4bdI3RvJmpwHRVykN0sPmr5
	MEPnnRMEIltMP1bQyOoXKBQS9eEl5Fq2DTaP84RqAJKsA73VOr2HbozicOQJ9fE8bDGytqirBmO
	zZS9WaDR1YMWTc/XfgoGf+SwH512Icsr0Psbf6
X-Google-Smtp-Source: AGHT+IEyIAuxqhIJ0cR4zGnUS4KmUvll76j/QxpYHID6NjM88072VnSgtJcJo2m47vhTTfHYCw3D9ZbhLNrG
X-Received: by 2002:a05:6e02:18c8:b0:430:b5d2:1a97 with SMTP id e9e14a558f8ab-4330154fb6bmr5653675ab.27.1761761835658;
        Wed, 29 Oct 2025 11:17:15 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-101.dlp.protect.broadcom.com. [144.49.247.101])
        by smtp-relay.gmail.com with ESMTPS id e9e14a558f8ab-431f688c3a8sm13222195ab.20.2025.10.29.11.17.15
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Oct 2025 11:17:15 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2697410e7f9so2252975ad.2
        for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2025 11:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1761761834; x=1762366634; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NghNMDq0ILDJ8uBRxw6+DAIxIxEorbb+IJgEMV7HWgE=;
        b=cvVNtAnQzOM8MflptlY0CMIJyXDsjV0Jiw8yB7hF+d0UUSp7hY56gdD/VMdBOyOYV6
         6YO3Nn2eS4RLYIZt2Z3BeERawiVXPy+HT+fzBWrSrrsl4TBqGM8bjGSCJ9NYlWIyWriv
         zLsHFigF78+qpm3B9uCPN4aCkKCtu2tqUR69E=
X-Received: by 2002:a17:902:ec89:b0:269:63ea:6d4e with SMTP id d9443c01a7336-294ee41d8b6mr2627185ad.37.1761761833527;
        Wed, 29 Oct 2025 11:17:13 -0700 (PDT)
X-Received: by 2002:a17:902:ec89:b0:269:63ea:6d4e with SMTP id d9443c01a7336-294ee41d8b6mr2626805ad.37.1761761832999;
        Wed, 29 Oct 2025 11:17:12 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498cf341bsm157284565ad.14.2025.10.29.11.17.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 11:17:12 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 5/5] mpt3sas: Add configurable command retry limit for slow-to-respond devices
Date: Wed, 29 Oct 2025 23:40:49 +0530
Message-ID: <20251029181058.39157-6-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251029181058.39157-1-ranjan.kumar@broadcom.com>
References: <20251029181058.39157-1-ranjan.kumar@broadcom.com>
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
index e93610df0a32..74beab7f398e 100644
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
@@ -3921,11 +3926,24 @@ _scsih_ublock_io_all_device(struct MPT3SAS_ADAPTER *ioc, u8 no_turs)
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
 
@@ -3936,10 +3954,62 @@ _scsih_ublock_io_all_device(struct MPT3SAS_ADAPTER *ioc, u8 no_turs)
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
 
@@ -3964,6 +4034,7 @@ _scsih_ublock_io_device_wait(struct MPT3SAS_ADAPTER *ioc, u64 sas_address,
 	struct _pcie_device *pcie_device;
 	u8 tr_timeout = 30;
 	u8 tr_method = 0;
+	int count = 0;
 
 	/* moving devices from SDEV_OFFLINE to SDEV_BLOCK */
 	shost_for_each_device(sdev, ioc->shost) {
@@ -4030,7 +4101,8 @@ _scsih_ublock_io_device_wait(struct MPT3SAS_ADAPTER *ioc, u64 sas_address,
 			if (pcie_device)
 				pcie_device_put(pcie_device);
 		} while ((rc == DEVICE_RETRY || rc == DEVICE_START_UNIT ||
-		    rc == DEVICE_STOP_UNIT || rc == DEVICE_RETRY_UA));
+		    rc == DEVICE_STOP_UNIT || rc == DEVICE_RETRY_UA)
+			&& count++ <= command_retry_count);
 
 		sas_device_priv_data->block = 0;
 		if (rc != DEVICE_READY)
@@ -7766,7 +7838,7 @@ _scsih_report_luns(struct MPT3SAS_ADAPTER *ioc, u16 handle, void *data,
 	kfree(transfer_packet);
 
 	if ((rc == DEVICE_RETRY || rc == DEVICE_START_UNIT ||
-	    rc == DEVICE_RETRY_UA))
+	    rc == DEVICE_RETRY_UA) && retry_count >= command_retry_count)
 		rc = DEVICE_ERROR;
 
 	return rc;
@@ -8022,7 +8094,7 @@ _scsih_wait_for_device_to_become_ready(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 	}
 
 	if ((rc == DEVICE_RETRY || rc == DEVICE_START_UNIT ||
-	    rc == DEVICE_RETRY_UA))
+	    rc == DEVICE_RETRY_UA) && retry_count >= command_retry_count)
 		rc = DEVICE_ERROR;
 	return rc;
 }
-- 
2.47.3

