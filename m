Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83CB323814D
	for <linux-scsi@vger.kernel.org>; Mon, 15 Sep 2025 17:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757957953; cv=none; b=oNfB8952quHTxsuGoXD/vL+N8OFvOevOlf9BiYgBboRvnWCjmEaljC9ailTVsqIAou+SfE6EHv/XOxwhRVkNnSlVs/lzajyroyX/EGzWUcAzyuxKr30mm9YVkSm54/EkO+2ihuzhEWEcMuEmbNVrzBZkmS1SvKryVaD4dToOr2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757957953; c=relaxed/simple;
	bh=3ZcaB5ssU6xS+IiZflZU3VwIk82Veut60m/x83AQ4aQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PyQz6tJBV7R/IIEtsMxBUYljIF19yozoyaUyQMWpwTvia+CgoGNlqF4EPiDSpZzHakrNonzG12exfLMhFRXgxYmR1YOvGwVmC7CJr+4ImzneyIv1pC3vR8lN6gDwL5EnqNMadM1HWrFc9zMpOM+RNTb82JMLJSuDAmmM/yUXkPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LynvkKwO; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LynvkKwO"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-770db3810a7so21794376d6.0
        for <linux-scsi@vger.kernel.org>; Mon, 15 Sep 2025 10:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757957950; x=1758562750; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C0vLwmgdgYkpz4Dt7c/m7kEGntyH1DlQnOQGojIwkeY=;
        b=LynvkKwOu0RDuwJgFK3DIedJADAJDq4sRlIfs79RtCB2JpSONidf4PQjpsI+EkHoUF
         8eEiS4mHk/LEhJXHuFr3ou8sBTPBNjqAgqKdyd0CVyv+b/rO0Ywu+o3wdIp8k8GqN3iV
         2bDd14P4fUbS9fQYG1zSyfTNdaq7VKsPV8NeXevniOWSeblS5Rhg3ifDRSRQHafoWjzm
         gpIsdYqtBXifroYxd/Nuz14dABKSLC91BQLGEaZP8YrsGMIE4Q6PM3Dgjif2YY+uV/Sk
         0oW+2n2D+7Txo69WdYQA7Q87IhceoD+KdNsF+f4NuaOoU9erUaeG3jEOvfXdxLZYBqqm
         +WGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757957950; x=1758562750;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C0vLwmgdgYkpz4Dt7c/m7kEGntyH1DlQnOQGojIwkeY=;
        b=gHR021cEW1L28SXEwXUrGhze+/uwrokDcVw2PF+BM7x7XXsapZokzRx9f+xSjvDJvu
         A0Iibbjm0acWlWZHsrz/cwxTCBl1b0+R70Fbz0cwzjZJB8vPfBrY2BwqaE8UI9lqN0nE
         k9l7r/t09EKO2NpYgPDR3Jg6KefPqzDGVuCFbDvmSR9EZwxviFAA1ZQnfe6vJua2wpYQ
         d5FiFKp/fZ6VDBVo8bs0Xdyzmp04J5bWfuTHpKZbJgIfsc8Zna6jhLj+TZ43x7K2qqir
         R2pGANrDDWsIigx5COAS2m4t4IqDOCqDNl7r/oSpAvUf3bRLCOjsfIgyNI4HJ9icOmy7
         z3fw==
X-Gm-Message-State: AOJu0Yzy0ICX+Zb0Yl16KKjT2r+SCHU9wKEisgDFspduHa0r8LkYt0rc
	R+Br2GLNTVo2L2I9htJTdZgM04zkoZZ8+7Tedi14HJiT8aDp8QpwOqaWtuOIFQ==
X-Gm-Gg: ASbGnctB02bKZPtKN3gS8vPxgWc9dzo0QvxOBkGbGC0HVf5n/r0WgjyXpM0gWNVVgaf
	ZW2fiSWYR/UanF/9fwLRHBwycoJEzwFMocDzszkQ8xRycz3q7uUEgsgo6m30qMTYfcAdtbg6dZ7
	FqOw2u0bohydQK0ytWjFWSbuWjzcIzZ2jCZxi5H67d/9ohcA/YRoPePq6U2jKY1oHno9HmaV7XJ
	DFn34rhZx8oGK8YkHFNLhqd9bPXNeDo+QxfoCh72RDVFUKuwHbzygqoX/mlEqFF5bdgt3FMqZgN
	QqR8Zw4RYRFhKZwKQlt8853YyuIVLEHevYsLtPBBQli8QmKzQcBnQlhjjbMutQy8hUOzeIs7mUo
	k4VByZMN1RqyDy1luZuYKlcHxOFoyJl82p5SLrasm0KC4t8wYZqErOdM/d3wLb8hsXLttcf8TL+
	MOPLjiVBY=
X-Google-Smtp-Source: AGHT+IFZcO7MZ8apofmhdSexAOLoHnU8g5R/k/fmjHi2CC58slZa0N6SBaPCBYqEE8VSiii/ITm6Vg==
X-Received: by 2002:a05:6214:21e9:b0:70f:a04f:232f with SMTP id 6a1803df08f44-767be6cc73bmr190972676d6.30.1757957950196;
        Mon, 15 Sep 2025 10:39:10 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-77ef70bcc4esm29710976d6.41.2025.09.15.10.39.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Sep 2025 10:39:09 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 01/14] lpfc: Remove unused member variables in struct lpfc_hba and lpfc_vport
Date: Mon, 15 Sep 2025 11:07:58 -0700
Message-Id: <20250915180811.137530-2-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20250915180811.137530-1-justintee8345@gmail.com>
References: <20250915180811.137530-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are variables defined in struct lpfc_hba and lpfc_vport that are not
used anywhere.  Delete the unused variables from struct lpfc_hba and
lpfc_vport.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc.h | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index fe4fb67eb50c..588411200b00 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -661,15 +661,12 @@ struct lpfc_vport {
 	uint32_t num_disc_nodes;	/* in addition to hba_state */
 	uint32_t gidft_inp;		/* cnt of outstanding GID_FTs */
 
-	uint32_t fc_nlp_cnt;	/* outstanding NODELIST requests */
 	uint32_t fc_rscn_id_cnt;	/* count of RSCNs payloads in list */
 	uint32_t fc_rscn_flush;		/* flag use of fc_rscn_id_list */
 	struct lpfc_dmabuf *fc_rscn_id_list[FC_MAX_HOLD_RSCN];
 	struct lpfc_name fc_nodename;	/* fc nodename */
 	struct lpfc_name fc_portname;	/* fc portname */
 
-	struct lpfc_work_evt disc_timeout_evt;
-
 	struct timer_list fc_disctmo;	/* Discovery rescue timer */
 	uint8_t fc_ns_retry;	/* retries for fabric nameserver */
 	uint32_t fc_prli_sent;	/* cntr for outstanding PRLIs */
@@ -767,7 +764,6 @@ struct lpfc_vport {
 	/* There is a single nvme instance per vport. */
 	struct nvme_fc_local_port *localport;
 	uint8_t  nvmei_support; /* driver supports NVME Initiator */
-	uint32_t last_fcp_wqidx;
 	uint32_t rcv_flogi_cnt; /* How many unsol FLOGIs ACK'd. */
 };
 
@@ -1060,8 +1056,6 @@ struct lpfc_hba {
 
 	struct lpfc_dmabuf hbqslimp;
 
-	uint16_t pci_cfg_value;
-
 	uint8_t fc_linkspeed;	/* Link speed after last READ_LA */
 
 	uint32_t fc_eventTag;	/* event tag for link attention */
@@ -1088,7 +1082,6 @@ struct lpfc_hba {
 
 	struct lpfc_stats fc_stat;
 
-	struct lpfc_nodelist fc_fcpnodev; /* nodelist entry for no device */
 	uint32_t nport_event_cnt;	/* timestamp for nlplist entry */
 
 	uint8_t  wwnn[8];
@@ -1229,9 +1222,6 @@ struct lpfc_hba {
 	uint32_t hbq_count;	        /* Count of configured HBQs */
 	struct hbq_s hbqs[LPFC_MAX_HBQS]; /* local copy of hbq indicies  */
 
-	atomic_t fcp_qidx;         /* next FCP WQ (RR Policy) */
-	atomic_t nvme_qidx;        /* next NVME WQ (RR Policy) */
-
 	phys_addr_t pci_bar0_map;     /* Physical address for PCI BAR0 */
 	phys_addr_t pci_bar1_map;     /* Physical address for PCI BAR1 */
 	phys_addr_t pci_bar2_map;     /* Physical address for PCI BAR2 */
-- 
2.38.0

