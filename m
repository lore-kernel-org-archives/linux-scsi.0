Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hDM9XGU4"
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09CF171E
	for <linux-scsi@vger.kernel.org>; Thu,  7 Dec 2023 14:28:27 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1d03f90b0cbso2425625ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 07 Dec 2023 14:28:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701988107; x=1702592907; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bCv3btQ+5E50niLLuMglxaWaz3TzsPB68L9v16fFWxM=;
        b=hDM9XGU41uMwGW2oOTJxCOZeTPKtmfmIC+5XAcvGtvJN/62ih/AB7f9e7NeYQkFjgU
         aeVon3MIkbElLloYkqjx4db5MgqgdPILEUIzoPSNgXdPoaKTnQ4PmIVD7UhLQmYpe+vx
         KVKHEh1d9gPLmiPwGNzskm1rIaoT4fVVdnJZahEo/6yOuAuU5JucvVqLKB15cIF1Vlq0
         0CMEqbaKQsGEpcnCjitriDiGXppZVw5/XAkFOTtOTjHghA8eXAP2y+700zDEc4G7bwxm
         6ZJUL7gQYVlcZy8gQLEHSEbI/li7OJvhk5ugMpPtWmD0W9mWs/+j7Mvo8foNnxjd/QFk
         +RQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701988107; x=1702592907;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bCv3btQ+5E50niLLuMglxaWaz3TzsPB68L9v16fFWxM=;
        b=pdC2ogZ4IV7EAC9dahpCIYe6fUY1ZV5Bc32OZ+GZYJev0YAwFlm5FNi9xnqWLRUfwA
         YWT1Mmcw4kyd3kTBLjWI9x6fD+ixRIwiY6Kz+XzH4HuR0vzJTkUDveidy3O1r9PTV4Vs
         wtJPuTdQ1hAmzTHI59eNKD/BhSeHSUifxCYDwBVMjgGZyfm9IJr8HyCRI8Z3O0igRNE6
         59Kq0Zm4X1621+3FVGSy8j7aoMKnbhIojQPfIIELCvlAPncAKTFOY2MGkClFMTEAzmvJ
         /xyejn1lEMXz4jD6FPKr0aN6OTwe3z+KbluN7S9GlvHI80j9JPunoryCVBjVsfUKzduG
         dfxw==
X-Gm-Message-State: AOJu0YytMmB06FJnGc+V5pgxb3z3C/5rL34SHlHQBYRWhuPcghwPLM5x
	f5GhmocQY6X5rf8t/bMH1UOLxEvmM1patA==
X-Google-Smtp-Source: AGHT+IGWlyuZvMxHZD9xa9/Xs2yWfU70MqATPEQ+7DRy9t2DUn2UaGkZoKq2myFWasM4G8gKAM/iIA==
X-Received: by 2002:a17:902:ec89:b0:1d0:80db:a841 with SMTP id x9-20020a170902ec8900b001d080dba841mr6626483plg.3.1701988107162;
        Thu, 07 Dec 2023 14:28:27 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j18-20020a170902c3d200b001cc3a6813f8sm312417plj.154.2023.12.07.14.28.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Dec 2023 14:28:26 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 1/4] lpfc: Change VMID driver load time parameters to read only
Date: Thu,  7 Dec 2023 14:40:36 -0800
Message-Id: <20231207224039.35466-2-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20231207224039.35466-1-justintee8345@gmail.com>
References: <20231207224039.35466-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

VMID driver support is a load time configuration setting.  Thus, change
sysfs attributes to read only.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_attr.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 48c727a51193..d3a5d6ecdf7d 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -5954,7 +5954,7 @@ LPFC_ATTR_R(enable_mi, 1, 0, 1, "Enable MI");
  *       4 - 255  = vmid support enabled for 4-255 VMs
  *       Value range is [4,255].
  */
-LPFC_ATTR_RW(max_vmid, LPFC_MIN_VMID, LPFC_MIN_VMID, LPFC_MAX_VMID,
+LPFC_ATTR_R(max_vmid, LPFC_MIN_VMID, LPFC_MIN_VMID, LPFC_MAX_VMID,
 	     "Maximum number of VMs supported");
 
 /*
@@ -5962,7 +5962,7 @@ LPFC_ATTR_RW(max_vmid, LPFC_MIN_VMID, LPFC_MIN_VMID, LPFC_MAX_VMID,
  *       0  = Timeout is disabled
  * Value range is [0,24].
  */
-LPFC_ATTR_RW(vmid_inactivity_timeout, 4, 0, 24,
+LPFC_ATTR_R(vmid_inactivity_timeout, 4, 0, 24,
 	     "Inactivity timeout in hours");
 
 /*
@@ -5971,7 +5971,7 @@ LPFC_ATTR_RW(vmid_inactivity_timeout, 4, 0, 24,
  *       1  = Support is enabled
  * Value range is [0,1].
  */
-LPFC_ATTR_RW(vmid_app_header, LPFC_VMID_APP_HEADER_DISABLE,
+LPFC_ATTR_R(vmid_app_header, LPFC_VMID_APP_HEADER_DISABLE,
 	     LPFC_VMID_APP_HEADER_DISABLE, LPFC_VMID_APP_HEADER_ENABLE,
 	     "Enable App Header VMID support");
 
@@ -5982,7 +5982,7 @@ LPFC_ATTR_RW(vmid_app_header, LPFC_VMID_APP_HEADER_DISABLE,
  *       2  = Allow all targets
  * Value range is [0,2].
  */
-LPFC_ATTR_RW(vmid_priority_tagging, LPFC_VMID_PRIO_TAG_DISABLE,
+LPFC_ATTR_R(vmid_priority_tagging, LPFC_VMID_PRIO_TAG_DISABLE,
 	     LPFC_VMID_PRIO_TAG_DISABLE,
 	     LPFC_VMID_PRIO_TAG_ALL_TARGETS,
 	     "Enable Priority Tagging VMID support");
-- 
2.38.0

