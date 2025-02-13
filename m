Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CE780034
	for <linux-scsi@vger.kernel.org>; Thu, 13 Feb 2025 01:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739410830; cv=none; b=Yp3f8NxW92e9+D1YmdMDGIS2pqPeHvC6Vl349LDH1xUZ0wj/QQs/buFK+K28xhRUGIEtRlLZWxkyiJao581+M9a48kQhc8UrlGL7inFz7orSNyvCpMKSY73dNDD/5D+L3ZcOfLq+ma12JRNmcf+UMrTvj/mxHCWR6a1lAzii2vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739410830; c=relaxed/simple;
	bh=bPI36BfzP0kWZuv06S7SuzAwfHPhp3MD1KHJTto7G7k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=SScnkOQ98cb/hy0tCllgCLWlzAufiuylKIAki/8sQ9rZYVc/JUPa6w/HJVYleFOzoa+QfJv50Jvs0q5bHXyvXcUGOKoTDewDL+xVeMRzJ9BCm+7hUU7XKmhXd1KlVLuLqD8OuuXO/h4w+Ma4qKb/Ki4UuzLM07d4LUwL2bDaOCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=AS5dbepp; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="AS5dbepp"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-21f818a980cso4095995ad.3
        for <linux-scsi@vger.kernel.org>; Wed, 12 Feb 2025 17:40:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1739410827; x=1740015627; darn=vger.kernel.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BkoMvZuVdu59HnviV0YgD4bHTFYdW3NaoKkTnzYmcNY=;
        b=AS5dbepp1jOAOy/sevdE9qK537A2KfprRYdwT0rOsX2IUFx6+eERqLbhnvb9OdETkF
         CDlZxM9ZsUJbDkLSe48FvtSGXEj/zS5ZVikxQUta8aaUNONZ7cNEcE0mgQ38N/oMsH8h
         vDVJigF8XIqIUd/UIWzbZTiVr2ynCfUQfOJF0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739410827; x=1740015627;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BkoMvZuVdu59HnviV0YgD4bHTFYdW3NaoKkTnzYmcNY=;
        b=opXo9xJoF0iKnVtJw+DjMfA6Q4h0iOIW/4Y7dpu0C7v/g6QPWofifNvzZVdjpxOudO
         4OLCJ7FAGRdc80dCphuyiwMz49wpT6mLrH0b0FRNcwgGgj3ycEFHmtMeE93FPGrq9I2H
         ZI3dIkR15IEwdPWQ3dpxJNk9Eevh2yH48u1tUES8Hs3vjlaFQozTamCSLFvz431lNchI
         5cx/aSU1eSljSIy/IFMWIjlgUCxi+wi611C1B7ee1Ptau2emKfhKl7wSmPSYiXSW5axI
         iI7Eh96orXyHNLEkpqW0m5NexXhgLFtaWTLkUFmHa9FAtd0ZzZuZBnEcKNFimoozP+HQ
         sgSg==
X-Gm-Message-State: AOJu0YylgL/ThhNfOGMyeFMGe0q2CtiewxTBptTELacmrI4SuoJ6UIka
	SBtpSmC/9q/MAmlPGEDJeQGubgU3QoXk9OsxYX1eD/CAheN/OAP27dsTfu2nZ+NlYcEerm4/bbJ
	MDNsSJHtB4TG26bXry6tgaLo6Sf4VNrdF0SROprS5eKY6uVJjej7Ovcrd2lrt0LGzgfdjBkb7TP
	VX4LYRQtllCU2ouIwxIeC0QaFhuMsnFFFJrzohgMgTJf+OMtCNzxcFDyqZWkbw3hMW
X-Gm-Gg: ASbGncv8FxgBzlzuw+v1HrNmSXBRJcYo3z+hnScs86JbqbkG+Go5hOrVWafNAAmLCd6
	G0VTOd6cte4FQZXW/Njoslk9qyu4UrowJVMy70klghCah6/Kz3/AVucGbXZr2pAbhhWuEEcuPFu
	HdPcOFaJMcbYWdMZ6R0prcRQiBSg1gRZqwcmYLGvcaUu9bOb1nGPhmKis5Wgqj+DDhnFPpFLWGM
	2C82lctOY8h2rOFEBy/UXdQdxzvB2tltikwewZmxUf9gw60CydPJmWi7+29gMDK92xzD/411U5e
	v270JzEeQQKUYdyXyw0CY352ftArTQ6Jdx8SeM9/5+iCxTFZDYe2gKMr4dxUsSVrruvKdLks85T
	pl4XeDSKtZsAf6/LGOl4qDG8=
X-Google-Smtp-Source: AGHT+IGHRJ402B6G0VJwmkwSoHTLEhp2Mg3kcOoUMhByikB5NaT94rNUDaOdJ+a+S08GiZMzVgE1BA==
X-Received: by 2002:a05:6a21:2e81:b0:1ee:5cf2:9c04 with SMTP id adf61e73a8af0-1ee5cf29e98mr6936031637.8.1739410827219;
        Wed, 12 Feb 2025 17:40:27 -0800 (PST)
Received: from dhcp-135-24-192-142.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73242761714sm106145b3a.133.2025.02.12.17.40.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Feb 2025 17:40:26 -0800 (PST)
From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	ranjan.kumar@broadcom.com,
	suganath-prabu.subramani@broadcom.com,
	sumit.saxena@broadcom.com,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 3/5] mpt3sas: Report driver capability as part of IOCINFO command
Date: Wed, 12 Feb 2025 17:26:54 -0800
Message-Id: <1739410016-27503-4-git-send-email-shivasharan.srikanteshwara@broadcom.com>
X-Mailer: git-send-email 2.4.3
In-Reply-To: <1739410016-27503-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1739410016-27503-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Add a new capability field to report the MCTP passthrough support to
applications.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 2 ++
 drivers/scsi/mpt3sas/mpt3sas_ctl.h | 7 ++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index 54a8a9c3ce5f..a731622f2f65 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -1254,6 +1254,8 @@ _ctl_getiocinfo(struct MPT3SAS_ADAPTER *ioc, void __user *arg)
 	}
 	karg.bios_version = le32_to_cpu(ioc->bios_pg3.BiosVersion);
 
+	karg.driver_capability |= MPT3_IOCTL_IOCINFO_DRIVER_CAP_MCTP_PASSTHRU;
+
 	if (copy_to_user(arg, &karg, sizeof(karg))) {
 		pr_err("failure at %s:%d/%s()!\n",
 		    __FILE__, __LINE__, __func__);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.h b/drivers/scsi/mpt3sas/mpt3sas_ctl.h
index 6bc1fffb7a33..483e0549c02f 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.h
@@ -160,6 +160,9 @@ struct mpt3_ioctl_pci_info {
 #define MPT3_IOCTL_INTERFACE_SAS35	(0x07)
 #define MPT2_IOCTL_VERSION_LENGTH	(32)
 
+/* Bits set for mpt3_ioctl_iocinfo.driver_cap */
+#define MPT3_IOCTL_IOCINFO_DRIVER_CAP_MCTP_PASSTHRU		0x1
+
 /**
  * struct mpt3_ioctl_iocinfo - generic controller info
  * @hdr - generic header
@@ -175,6 +178,7 @@ struct mpt3_ioctl_pci_info {
  * @driver_version - driver version - 32 ASCII characters
  * @rsvd1 - reserved
  * @scsi_id - scsi id of adapter 0
+ * @driver_capability - driver capabilities
  * @rsvd2 - reserved
  * @pci_information - pci info (2nd revision)
  */
@@ -192,7 +196,8 @@ struct mpt3_ioctl_iocinfo {
 	uint8_t driver_version[MPT2_IOCTL_VERSION_LENGTH];
 	uint8_t rsvd1;
 	uint8_t scsi_id;
-	uint16_t rsvd2;
+	uint8_t driver_capability;
+	uint8_t rsvd2;
 	struct mpt3_ioctl_pci_info pci_information;
 };
 
-- 
2.43.0

