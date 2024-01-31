Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EAF515D4
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jan 2024 00:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706660521; cv=none; b=Kjt1TE252BKuM/U/ConSNlfxLf0P2rJjL58oSLpxS8j6IP3o3jtMZGdwi/DJPy4BmKCe+4NBk9rNqxJMN3s6oe+KVThKnIkmAvoLnVBO1z/Cwg0AXGsOBLdvtO8JydvHF8myOtElevQKaasJuH738vz1yAu+7OF4jpUP3jBPQNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706660521; c=relaxed/simple;
	bh=RtO0dtK3FXHwhCbu3Br75jy1EqjUvmIg9lschtZjRcY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BHfa7BZ/kamuOyH5oXrJjJv+as11gGpt0nXX9GCDi4BFL29VWyfh0A1m2DjYQo+CHmdgOmQxHmLCLx0jCO9wouH7wod2vXT722b2kalnf7Pdqxg6TazmcQJSm73hqAK5TfdDyP9HcaKOr0eIG/OAqT3gqtvrKB4wo7cQ4n6eeFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FoYpYUlj; arc=none smtp.client-ip=209.85.128.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FoYpYUlj"
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-60403e59090so1453967b3.0
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2024 16:21:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706660518; x=1707265318; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c0tC+gvEyKiYRPyqNL/myXxd3Dt1Jq9ItId7EVdQTQE=;
        b=FoYpYUljjrOpvo3zW1eQyn/MkgXBgphYc8IiYRczwIEt9w6dRthfnFyfp4bFVgOM09
         xZRjozkKUftAT4IzFyZD9kYxjC4dipzWQsaRtSaiIV/LELNvdWpSMRx7uJY5fxYxdeAa
         R7YNc2XzF/N9mu65tRbp1+eNbVELqdH7yWG0bmHwhYyyfD8gEmxgwc4WgLG66J3N61eg
         oVJ33DG/s2p95Po7Dl9cj6mozqtF38+PoD136w97hMb6ygOcoEiPGPHth992fdRP+CdY
         PPWFZn7/v3laCeukIBHaZMQDEtI8BNAAbeQasUvgQXl59ZIK+w7YCtx8nUiW3ZDrE+5l
         4EMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706660518; x=1707265318;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c0tC+gvEyKiYRPyqNL/myXxd3Dt1Jq9ItId7EVdQTQE=;
        b=l9rP3vX44bIQkwvFDE9RaS8jECOHlq2/VuWOCtpyaGuWz4PCIsGCfMZJGW672x80BG
         r4BdaEYoyZhUL+7CQAc8pTrjzJF1AuzJH7bkuLaPdhz11vAtk2C1At2o+uGd6t4N7dEb
         WNIHsQry7k5IX+Jujn86D+Nq8FWX28DT6Dzq6IIO8Qz8Kf7TrsF2kN+9eojE46ggITUa
         DX2dU3bGuB5CiY4zHjMFGKH4QUuV+rZqCht6LNfx9dWgDas7ono8ALTE7YryXpYXluHD
         nNSEGPv+c7+D5zFEVc5mhvIsMqp9kirAIy5+cB3VZ9kMUzECh3fsN5j4g7GXLwsljQDW
         LL7w==
X-Gm-Message-State: AOJu0YwiSpcR7fpPRARc/pG6FrOlFtP3X+FEQliwM7mDQbrrb3tSeXbc
	dZ1Se6QNd18d19FuD/0MoJAXS5hXiBOOmim/1AmrMa7ZlTSS9mMWx9c449ql
X-Google-Smtp-Source: AGHT+IH9LhqJ88IB0M6tuy9G8QTLBV2GnyoJj5BDhAbBOZD4ZdFx3mggEMqGaPnhdKfrs3IEs2UBiw==
X-Received: by 2002:a05:6902:b20:b0:dbe:ac10:9410 with SMTP id ch32-20020a0569020b2000b00dbeac109410mr180970ybb.0.1706660518227;
        Tue, 30 Jan 2024 16:21:58 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id qn19-20020a056214571300b0068c4ecc8886sm2600931qvb.127.2024.01.30.16.21.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jan 2024 16:21:57 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 10/17] lpfc: Move handling of reset congestion statistics events
Date: Tue, 30 Jan 2024 16:35:42 -0800
Message-Id: <20240131003549.147784-11-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240131003549.147784-1-justintee8345@gmail.com>
References: <20240131003549.147784-1-justintee8345@gmail.com>
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

