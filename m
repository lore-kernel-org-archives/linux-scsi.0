Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C060547F76D
	for <linux-scsi@vger.kernel.org>; Fri,  4 Sep 2026 10:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788518743; cv=none; b=Re31vW8T8eS9gnd1eSpXwswayfbhD6ZlbRM+D4bJFK2CcKtqyBp3asxwrzfVEupExCKOehKYTVP96iuWtWNFvRxrjswcTsIy2QPScUmpAagLOdTu/sJCO3zIz0aCFjKAaAXrcAh1YmNKcHr8QzlA7wkhT3e2Zhw6EK288Yer8fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788518743; c=relaxed/simple;
	bh=jEf1ZbVyuLx6xB4AQkVW0+fkW4EE8HbhofCfHRXscDM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q8CqYVj3KdrZtWh06vJXm9fqhud6YQKmtQa7K71g9SARr+p12270CnKVpWVLpHB267aY+TaOHbLHeboXVBv3qUU31H1YL9dmxZoeZ0qVMgBDovFt0Z63RXaCtwiGOAKlviQzbxb6ocwTduSZfVB0cDI/QXgZOLakDGhsl1GuF9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P9Zdt1dQ; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P9Zdt1dQ"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-cc1d57602e8so866849a12.3
        for <linux-scsi@vger.kernel.org>; Fri, 04 Sep 2026 03:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788518741; x=1789123541; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Sa11veKQeR2jL6eGP/Q2IWwnSfActcWrUSQM+GRtqgM=;
        b=P9Zdt1dQLhucRjA1BpbT6ZlR3ecC38lK8k4i0+f+Pat+WADCAFl5gIvJiueI6tPDzI
         8w0zszx5rvgJwYFBH0tD9DYbCf9Jt8wdMge0TmK981A5Ekxn/rNE3/4vB5ukeK28TEMJ
         VhE7YVauBhJByxI0l+4mE0AdbHPa92XStkt0+w65z+KNGyyAXQsESKtBCjXCzTGopM3Z
         Xv6DcX6oCHEG4KOSwu2FHhVPoOPtBju6nBQb3PNjw1gIuXmaUao8NIumzytzQ00/EXY0
         teveatR9A3dVjAyfJE+VzPwyg5nkPzutLASKRcbgtvAWWNWq7g+Y2LjyQbegrLS3nbgE
         q8ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788518741; x=1789123541;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Sa11veKQeR2jL6eGP/Q2IWwnSfActcWrUSQM+GRtqgM=;
        b=sgXCIks6yvX2/Vu5C0dS5xDlCsD9X9qwY7yRynPquzlKx5f1YyJalXEFao0ArwucNS
         pvg37Wpunq6H891PxY2v/KIWNbD9KtOSvQ33tMA4s06sKRoAux/QHB8KcHHMYw3qRfde
         gYbyMCOYf5YVS0qtkfQyEP7hZb03vWynJAC+0rKCDAKfB/oYbTPsvT16WE0jOFW1fDN+
         fQv+v7GWrxempE4ssJU7Vf8m93gv5kjBOVgSKD7JlLvNlZZnic3rpDPnUYrEArHykjar
         KXq0jNadRJ58/OCt4DTQv0sBHu85jIQIVFSMtGkzQ7iH5FK9YnegoS5T3eIDD+DO3Eeu
         23Ag==
X-Forwarded-Encrypted: i=1; AKwUvBxA8pbV6dlDTAulB77HH4xgtG5XBzdZe9xTj/ZJ03GcI8AsmBcuzcOpuBdgID5aqcyTeM/v/BpBMn8j@vger.kernel.org
X-Gm-Message-State: AFuF++khJ91MsFplWzmf5Z9x+xmmWKUD12VyG0zWLu6HlwpUwnuWSLEz
	RJ/3Vhllg3l8elCPqc+i0w+J7Vi+gPr6TGnbabUEcCVwWJERaNea0Ai1
X-Gm-Gg: AYBFou3dYBIUA5WN8/Dz6Ck6WYokULCmn8EMLPypyx1zn5bv5UAYykGc38/StVnqz5b
	/xrVt02n8dCJpm+7S0RD3bF/3Kt8EHbHhbvo+TzSei9D9jAzEejBaEMYAVaAnF60uJgyil0Cr0D
	ExDr9q4X2k4B/axMKWvxvvA/LrxbEcASPdKjcBqFzZltHLsqIAj7jCwQ8MVx76kx4H3MhwgO8Rb
	jMiLYjEQIse0HtmMXxs0lMVciXszYpF10qPN82niVMSVrvp8GcydSLtjUdDyBnC6omRsa2k2z8t
	XrBZPinBzHHG3fVggkrehGSHFIVL7pblBrlLHjLaACXyTipMBu9/zwGAHpP0T50qYWd9XTEhSB5
	JTchKc0Kvcx7g9rB1cmd4cx2eKQbKLeweQss19xIGpnnZhNdQ30iKs6q5ROBVIruqqHFU7pOIcO
	ICvPuihIOQe2GAt+3non3Jb5xb0ogznjGCPCue/0kL09xQSL6UT2+WDYkI/iTmSNky3emwWDZdh
	t4xGGMEX6pEp4Q=
X-Received: by 2002:a17:90b:2681:b0:38f:5801:dc0e with SMTP id 98e67ed59e1d1-39b261d52a4mr7706671a91.15.1788518740880;
        Fri, 04 Sep 2026 03:45:40 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339aa36b37sm5674895eec.14.2026.09.04.03.45.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 03:45:39 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: linux-kernel@vger.kernel.org,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: message: fusion: fix typos in comments
Date: Fri,  4 Sep 2026 16:15:31 +0530
Message-ID: <20260904104534.20126-1-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix typos in comments, reported by scripts/checkpatch.pl using the
misspelling list in scripts/spelling.txt.  Only touches comments, no code
changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 drivers/message/fusion/lsi/mpi_log_sas.h | 2 +-
 drivers/message/fusion/lsi/mpi_raid.h    | 2 +-
 drivers/message/fusion/mptbase.c         | 2 +-
 drivers/message/fusion/mptbase.h         | 2 +-
 drivers/message/fusion/mptctl.c          | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/message/fusion/lsi/mpi_log_sas.h b/drivers/message/fusion/lsi/mpi_log_sas.h
index 27fe17a75eaa..a0465f2db050 100644
--- a/drivers/message/fusion/lsi/mpi_log_sas.h
+++ b/drivers/message/fusion/lsi/mpi_log_sas.h
@@ -191,7 +191,7 @@
 #define PL_LOGINFO_CODE_ENCL_MGMT_SMP_READ_ERROR             (0x00200010) /* Error occurred on SMP Read */
 #define PL_LOGINFO_CODE_ENCL_MGMT_SMP_WRITE_ERROR            (0x00200020) /* Error occurred on SMP Write */
 #define PL_LOGINFO_CODE_ENCL_MGMT_NOT_SUPPORTED_ON_ENCL      (0x00200040) /* Encl Mgmt services not available for this WWID */
-#define PL_LOGINFO_CODE_ENCL_MGMT_ADDR_MODE_NOT_SUPPORTED    (0x00200050) /* Address Mode not suppored */
+#define PL_LOGINFO_CODE_ENCL_MGMT_ADDR_MODE_NOT_SUPPORTED    (0x00200050) /* Address Mode not supported */
 #define PL_LOGINFO_CODE_ENCL_MGMT_BAD_SLOT_NUM               (0x00200060) /* Invalid Slot Number in SEP Msg */
 #define PL_LOGINFO_CODE_ENCL_MGMT_SGPIO_NOT_PRESENT          (0x00200070) /* SGPIO not present/enabled */
 #define PL_LOGINFO_CODE_ENCL_MGMT_GPIO_NOT_CONFIGURED        (0x00200080) /* GPIO not configured */
diff --git a/drivers/message/fusion/lsi/mpi_raid.h b/drivers/message/fusion/lsi/mpi_raid.h
index 36688a921ef2..5fa3f4000800 100644
--- a/drivers/message/fusion/lsi/mpi_raid.h
+++ b/drivers/message/fusion/lsi/mpi_raid.h
@@ -218,7 +218,7 @@ typedef struct _MSG_SCSI_IO_RAID_PT_REPLY
 
 
 /****************************************************************************/
-/* Mailbox reqeust structure */
+/* Mailbox request structure */
 /****************************************************************************/
 
 typedef struct _MSG_MAILBOX_REQUEST
diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 3a431ffd3e2e..7672ab523ede 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -4453,7 +4453,7 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
 				    "Request/Reply/Chain and Sense Buffers\n",
 				    ioc->name));
 			} else {
-				/*Reseting DMA mask to 64 bit*/
+				/*Resetting DMA mask to 64 bit*/
 				dma_set_mask(&ioc->pcidev->dev,
 					     DMA_BIT_MASK(64));
 				dma_set_coherent_mask(&ioc->pcidev->dev,
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index b406fd676da0..6f3091dff920 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -62,7 +62,7 @@
 #include "lsi/mpi_raid.h"	/* Integrated Mirroring support */
 
 #include "lsi/mpi_fc.h"		/* Fibre Channel (lowlevel) support */
-#include "lsi/mpi_targ.h"	/* SCSI/FCP Target protcol support */
+#include "lsi/mpi_targ.h"	/* SCSI/FCP Target protocol support */
 #include "lsi/mpi_tool.h"	/* Tools support */
 #include "lsi/mpi_sas.h"	/* SAS support */
 
diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index 77fa55df70d0..fc0c4670b203 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -213,7 +213,7 @@ mptctl_reply(MPT_ADAPTER *ioc, MPT_FRAME_HDR *req, MPT_FRAME_HDR *reply)
 
 	/*
 	 * Handling continuation of the same reply. Processing the first
-	 * reply, and eating the other replys that come later.
+	 * reply, and eating the other replies that come later.
 	 */
 	if (ioc->ioctl_cmds.msg_context != req->u.hdr.MsgContext)
 		goto out_continuation;
-- 
2.48.1

