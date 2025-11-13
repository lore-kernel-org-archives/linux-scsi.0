Received: from mail-io1-f98.google.com (mail-io1-f98.google.com [209.85.166.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075F02F6582
	for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2025 15:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763048593; cv=none; b=nGsFk8HvcTR0lOs/EI6E/kA+Jd3ZIBBjZxN5QzZDCYZsqedTiOlXw1lb6sfO0M0vgRX9HlKReZkAd7SvckofapfbTvQ5Tml7yK1e+lBJqerJI3fsqs+p1GNmNkdd33emRg9EoghDmq8lpwtzkryADadKKy5jVbTWKb3pZigtPhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763048593; c=relaxed/simple;
	bh=Wt1WIFyY041Wzzkm+U6CqVWI/PM5VxpgjZiiN2HjTbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Whoph/Si92kk87kbbODFRMmbLmBwIAOHkx+4dbbRUiQq9oxpC2LfP94uNSZk+sOXe8umSbVCT2x1jtW61N/MUyZ2XlAp8LtCpQMnDZzQYWSVpGOuPEcoNLUj4bqn6MR6SG4e7Vx11q04C0OwVN+nszLg7Vj1YKNnA6V62wNJp0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=O77FiwFx; arc=none smtp.client-ip=209.85.166.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="O77FiwFx"
Received: by mail-io1-f98.google.com with SMTP id ca18e2360f4ac-94822ad1baeso83260239f.2
        for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2025 07:43:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763048591; x=1763653391;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jqAruDce0eTztYIxf42xrkl4DnHNhTaK9IL1T2igN6A=;
        b=t1NQN1MdocPMaAbnQZaSOtIjsa1o5Ucnzk9pGOHUjgJMZeBwJrSpejB73Vhri3Ns61
         yZ9CfmiJamLely+ckhT7BROdubbac9JUD1uNFRosmy1QZ5nuUx8uI03mUbqHhC6jGb4w
         ve5XRTykLv8fn1HI5MAkka1gvdNtQA439588OBlWQrSuwXh5JXyHOB5kN8oXpJvVwgpn
         yNWsmdxZP+5RSjhDa5SpS6c88BzHw6vgJNmJvpUWqfm05wGrWW4hfNYZNYpZC4TcXTnk
         Kni3NJ5RcexUvqU5q9RoPov20piBKsSIcBBg+cAg+DC7ECxhDuirzo73fRIvz+kSUp/M
         nLpQ==
X-Gm-Message-State: AOJu0Yxj4GO+GQjJF3ESPqlSQOL5zGej5HcNtIrLugq/+0y9u0ckmj0R
	TpMyiOyyrvIpWnRmf1bxXvEIroMjYkL1h4LFFHvwSItPInGfKNtcI63Bb3ZLjytYTx7B/h9R3Rx
	y888JnPwNHzgrBGDMOfG1c7rMBT2ZlBXNIGxIEn5Ivex+ie2H4HR+hDk4IIbnFeYoFk8+TSXyjy
	xAlqq5EYvRpS45kitKt+5BX1V7AyNEnAiSlOJX2XbWWpYWmLN+fL7js56QBqS1Vt8KBkCpo0ffx
	3tavGJckRY4srtD
X-Gm-Gg: ASbGncuxRpsXDm2sqAZ8/LYIsIzTx+bRFXUwWJ9yb6YHyybm0LZRRQg0HLf1Ag3vOB5
	/2dW/Iwj6pSQsgXoAQRHzD4LUpnjjzB1IGaIg4GUdE38QAxhZbPaTQXlelb3b5p+A59LY4eJL+k
	XMQkrUlwWe8xYioEuqjEm/rBi0KvV0yo4hwY36byKS5xEqx4H5E0psiW4y+QM4xAnkGNflbtjwC
	PXEaG4bK4Wo8KvDIXdbfQx09ax94nUHyUJk0Zv3gmLFZycMPoLdOZWU38jQbDjJ+fD5uOoBsJM3
	J95OVIoZgZ/2i5ih99ZIeqL9t1i/ftzeN/IFT2TF8JA5aFkk+wqwGK5R2ppO6CbV6bnKBDd5oqr
	CRYQXhnTsOdvxh0aRMXf4GDAHmzX7JXhEoEKmgpPSxNDNUp0CxtJ4uv4Gfnh3RKjhLFb6A+vdeg
	lTWLz3umBQVbpJAvg/r+4vL46DN37N86uJiQ==
X-Google-Smtp-Source: AGHT+IHUf5/1gsD2T1nMqCJcFd418GnEj0ua2lfu+7icVVqa7bk5Z4ZzRD+PCi+BbHQ/1f31bEt8ryRJH9R0
X-Received: by 2002:a05:6e02:198e:b0:433:7c86:74e7 with SMTP id e9e14a558f8ab-43473d9b01amr80988175ab.19.1763048590774;
        Thu, 13 Nov 2025 07:43:10 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-14.dlp.protect.broadcom.com. [144.49.247.14])
        by smtp-relay.gmail.com with ESMTPS id 8926c6da1cb9f-5b7bd351db8sm183021173.37.2025.11.13.07.43.10
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Nov 2025 07:43:10 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-bc316e9d60eso846465a12.1
        for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2025 07:43:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1763048589; x=1763653389; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jqAruDce0eTztYIxf42xrkl4DnHNhTaK9IL1T2igN6A=;
        b=O77FiwFxNZh03ZvMF7+uvpbMtw3/YVHbJSi2fsA9rXYeE28V2BPZok7OtKvcZsIRFt
         T/kD5ynZ43rxbU0StuhuGAftKI0O9XADLLIDd5p7CHpBWk8FGJ26QmrYiBhg1HipuY6M
         vjibCR33geWCQmSQodpk794EvZ77WKWyQaZJA=
X-Received: by 2002:a17:903:2f86:b0:295:4d97:84fc with SMTP id d9443c01a7336-2984edaa36amr90051205ad.32.1763048588946;
        Thu, 13 Nov 2025 07:43:08 -0800 (PST)
X-Received: by 2002:a17:903:2f86:b0:295:4d97:84fc with SMTP id d9443c01a7336-2984edaa36amr90050895ad.32.1763048588087;
        Thu, 13 Nov 2025 07:43:08 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2cca66sm29100085ad.99.2025.11.13.07.43.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 07:43:07 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH v2 1/6] mpt3sas: Added no_turs flag to device unblock logic
Date: Thu, 13 Nov 2025 21:07:05 +0530
Message-ID: <20251113153712.31850-2-ranjan.kumar@broadcom.com>
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

Add a "no_turs" flag to _scsih_ublock_io_all_device() to
optionally skip TEST UNIT READY (TUR) checks while
unblocking devices. This is used after broadcast events
where sending TURs is not required.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202510310216.gerpzbxP-lkp@intel.com/
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 7092d0debef3..013b10348ec4 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3825,11 +3825,12 @@ _scsih_internal_device_unblock(struct scsi_device *sdev,
 /**
  * _scsih_ublock_io_all_device - unblock every device
  * @ioc: per adapter object
+ * @no_turs: flag to disable TEST UNIT READY checks during device unblocking
  *
  * change the device state from block to running
  */
 static void
-_scsih_ublock_io_all_device(struct MPT3SAS_ADAPTER *ioc)
+_scsih_ublock_io_all_device(struct MPT3SAS_ADAPTER *ioc, u8 no_turs)
 {
 	struct MPT3SAS_DEVICE *sas_device_priv_data;
 	struct scsi_device *sdev;
@@ -3841,6 +3842,13 @@ _scsih_ublock_io_all_device(struct MPT3SAS_ADAPTER *ioc)
 		if (!sas_device_priv_data->block)
 			continue;
 
+		if (no_turs) {
+			sdev_printk(KERN_WARNING, sdev, "device_unblocked handle(0x%04x)\n",
+				sas_device_priv_data->sas_target->handle);
+			_scsih_internal_device_unblock(sdev, sas_device_priv_data);
+			continue;
+		}
+
 		dewtprintk(ioc, sdev_printk(KERN_INFO, sdev,
 			"device_running, handle(0x%04x)\n",
 		    sas_device_priv_data->sas_target->handle));
@@ -8810,7 +8818,7 @@ _scsih_sas_broadcast_primitive_event(struct MPT3SAS_ADAPTER *ioc,
 
 	ioc->broadcast_aen_busy = 0;
 	if (!ioc->shost_recovery)
-		_scsih_ublock_io_all_device(ioc);
+		_scsih_ublock_io_all_device(ioc, 1);
 	mutex_unlock(&ioc->tm_cmds.mutex);
 }
 
@@ -10344,7 +10352,7 @@ _scsih_remove_unresponding_devices(struct MPT3SAS_ADAPTER *ioc)
 	ioc_info(ioc, "removing unresponding devices: complete\n");
 
 	/* unblock devices */
-	_scsih_ublock_io_all_device(ioc);
+	_scsih_ublock_io_all_device(ioc, 0);
 }
 
 static void
-- 
2.47.3

