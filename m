Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42E418634
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 18:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706726256; cv=none; b=iNhudm3lcsGBbjzRRHUbp4OKJu3eGtTYc2kInJw/QplwHd+LwFFZyojUnrZGgXdvhAHMJfc0K7PE9zUZg+q1wnJkKFUsfqmHq7GAK2GT0Oq9IEDZKgpnTNi/S5izjlF5lbeAyk4gBLhODkdXSsU0izLjK3N4WK1jwYmn/diSNO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706726256; c=relaxed/simple;
	bh=RtO0dtK3FXHwhCbu3Br75jy1EqjUvmIg9lschtZjRcY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=V/TiOlLTzjggoncnA+IyJ9vHZdf2cnnf49tko4oeamQ7C4evu6CEQPXX9VQ2zlNBvzJlYN6//ETt7lQxX98pIuFhsfuAh9mvHmoJ8/JNmbJUj6w2l8CyhQ31xHBUlMNtR8mW+lMT82fqt2eQuZuKplfMZA8aMjz31R3JEdU2Xys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j5x3P9Ft; arc=none smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j5x3P9Ft"
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-59a47232667so16304eaf.0
        for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 10:37:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706726253; x=1707331053; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c0tC+gvEyKiYRPyqNL/myXxd3Dt1Jq9ItId7EVdQTQE=;
        b=j5x3P9FtQLDboZNeKOF4SCE2DvrBBU7pVyeeNPiIKPyMcFTf2KgGW+CRQANSpxQf/Z
         VxykO3hCO3rRgdsZGjX9grYrAgS6kqIBWelSgep4xGb1wxws0GnQH6rF2M3+yMExlrIt
         b/AP5fxJD69S9j5fg4XbZe/kzLA8OileqIApuAIV2xM9GfyyYIZTy7XUmArQlgyWuWik
         wrNuIjG7chihqfvIR8AcYDBTgzHexk8kHYsJ6yyWZL6QzhG850prvaUSpYbHFBhNTO8z
         Djre+UR475rnU45dDCvsmmavhklBXnAomAStZNXgyS5mG162wsElvkGfxhpFeNrA2MtX
         DkZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706726253; x=1707331053;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c0tC+gvEyKiYRPyqNL/myXxd3Dt1Jq9ItId7EVdQTQE=;
        b=GYNGB+9v5DvCd0b6GwfqNuWx64GLF+TFuzc6t0pHByqfnKsPAyZX6hrI/rwY6UNfsg
         eyD5ocF3bN8InpMVicF5lqh0I3TJV0nYv3uoOSF5aScls1F1vCi79W8YzhIf7Cr175XU
         udzTJOrEOS93Q0nqxyXhuyLbsXObg6OxeJVR+BeKJI3/WsRLAz/9Xrt+hLyZw+Ds8JmI
         9UJoxeo5BAUPRTYpZ+J4Cvgik8XtHUYb51PO1UBe/6RS4tzh1GCzKfscJzZ/EHqj4Lxd
         tsT6wvZoLuTfTBzWuW1tDHOThFKvYI1U6A/7tPf03a5rTupG8lbYfDW3bYjq1IRzTu2C
         g1Nw==
X-Gm-Message-State: AOJu0Yz3eaHCwIqM8dc2pmFR6VI1mToIMDEb8JUv9pWNx7PE0T3zmZF4
	gMaOHPJXOGlBrohhR0MLcli+SKn5hMcYhzX7V9uokeqWFEHlQIEiEOqEznms
X-Google-Smtp-Source: AGHT+IGf+UXNZ/F6l3so6Cd0Chs3o5QSVKQ0QFtzSefRpbSQBLK7moAKZMUVcknaGMDI9ZdG9KVzDg==
X-Received: by 2002:a4a:a787:0:b0:59c:7c63:928f with SMTP id l7-20020a4aa787000000b0059c7c63928fmr610824oom.0.1706726253482;
        Wed, 31 Jan 2024 10:37:33 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id oq7-20020a056214460700b00684225ef3a0sm5111229qvb.93.2024.01.31.10.37.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jan 2024 10:37:33 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	himanshu.madhani@oracle.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH v2 10/17] lpfc: Move handling of reset congestion statistics events
Date: Wed, 31 Jan 2024 10:51:05 -0800
Message-Id: <20240131185112.149731-11-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240131185112.149731-1-justintee8345@gmail.com>
References: <20240131185112.149731-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The ACQE notification event to reset congestion statistics should be moved
into the specific lpfc_sli4_async_sli_evt routine instead of being
processed from the generic lpfc_sli4_async_event_proc routine.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_hw4.h  | 2 +-
 drivers/scsi/lpfc/lpfc_init.c | 9 ++++++---
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 5d4f9f27084d..f6b1168304f3 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -4069,7 +4069,6 @@ struct lpfc_mcqe {
 #define LPFC_TRAILER_CODE_GRP5	0x5
 #define LPFC_TRAILER_CODE_FC	0x10
 #define LPFC_TRAILER_CODE_SLI	0x11
-#define LPFC_TRAILER_CODE_CMSTAT        0x13
 };
 
 struct lpfc_acqe_link {
@@ -4339,6 +4338,7 @@ struct lpfc_acqe_sli {
 #define LPFC_SLI_EVENT_TYPE_EEPROM_FAILURE	0x10
 #define LPFC_SLI_EVENT_TYPE_CGN_SIGNAL		0x11
 #define LPFC_SLI_EVENT_TYPE_RD_SIGNAL           0x12
+#define LPFC_SLI_EVENT_TYPE_RESET_CM_STATS      0x13
 };
 
 /*
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 70bcee64bc8c..8e84ba0f7721 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -94,6 +94,7 @@ static void lpfc_sli4_oas_verify(struct lpfc_hba *phba);
 static uint16_t lpfc_find_cpu_handle(struct lpfc_hba *, uint16_t, int);
 static void lpfc_setup_bg(struct lpfc_hba *, struct Scsi_Host *);
 static int lpfc_sli4_cgn_parm_chg_evt(struct lpfc_hba *);
+static void lpfc_sli4_async_cmstat_evt(struct lpfc_hba *phba);
 static void lpfc_sli4_prep_dev_for_reset(struct lpfc_hba *phba);
 
 static struct scsi_transport_template *lpfc_transport_template = NULL;
@@ -6636,6 +6637,11 @@ lpfc_sli4_async_sli_evt(struct lpfc_hba *phba, struct lpfc_acqe_sli *acqe_sli)
 				acqe_sli->event_data1, acqe_sli->event_data2,
 				acqe_sli->event_data3);
 		break;
+	case LPFC_SLI_EVENT_TYPE_RESET_CM_STATS:
+		lpfc_printf_log(phba, KERN_INFO, LOG_CGN_MGMT,
+				"2905 Reset CM statistics\n");
+		lpfc_sli4_async_cmstat_evt(phba);
+		break;
 	default:
 		lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
 				"3193 Unrecognized SLI event, type: 0x%x",
@@ -7346,9 +7352,6 @@ void lpfc_sli4_async_event_proc(struct lpfc_hba *phba)
 		case LPFC_TRAILER_CODE_SLI:
 			lpfc_sli4_async_sli_evt(phba, &cq_event->cqe.acqe_sli);
 			break;
-		case LPFC_TRAILER_CODE_CMSTAT:
-			lpfc_sli4_async_cmstat_evt(phba);
-			break;
 		default:
 			lpfc_printf_log(phba, KERN_ERR,
 					LOG_TRACE_EVENT,
-- 
2.38.0

