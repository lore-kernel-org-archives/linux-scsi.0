Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B634344E03B
	for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2026 20:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774988597; cv=none; b=hgcvbdefHy/6bAqhS8/rBytrH/lM+EakMG9B5e+NnJSimu1pfW2uM9OjwnODGhXUDNCX7aqxOJ/HjwvIOkFepRm5ZQt4/0Srr0/nDkVliySg2CMZ/1kRS9eDJrnopn2QfpbuxS93tgvD5u1iheDONAxOpSpuvVe6rtZikscxIS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774988597; c=relaxed/simple;
	bh=/28BIdgxCr7PYrApWvquFkyx7DeE10zTDosm36FdhjY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YJkunzA3G2tawy84US3wbpv+HpHF0aEZp/OlUr+foqqjiiFAPIe3/1+ouG8xBZNN901i9tQwHnJhByLu2AtwZ1GEKYQ5JwaKwY4bffZQQo6+bl/3SvmZ0yDmI5K1DoJIAvYWKrXE18UXknIhW/mzubDwE7XBEHb/ArCxWeqWJJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QLY0jbHA; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QLY0jbHA"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-89fc4147f2eso62872246d6.3
        for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2026 13:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774988594; x=1775593394; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IZnTQ35XhabclR3qxit8OoOAE+RR7rH3Q46FWVoGZdg=;
        b=QLY0jbHAqxrWIrVYwQ8hMqlLj//3l/c8giQri1fW/QsR6tNnWyvKI7bQ8Ip3K+lK+Q
         uLoMrlSRRMvdz5TJiFa2UTxyPVS6QRlEgLUipJFdJPQuagAcq9ch5ohqu5uTLczEfZoP
         b6Cu1+QyOq71G96nphUqpwmc9KWHqZ2p4Jm/qm3sJNEwXvTwUXyhjB1yPGQM+OPDO5LP
         b1tDCva6el4cJEWT45mTPnL8kroyjGcXC2mGBvcyiUG79Cw3cS6GNsTQpoRkwK6qCR4M
         XZh5G7ajkinzyrYNwsA6+elwBqJBevy1g6WvK26Kz5bC7wGp+nhU8NqDundLrlh3qb7i
         Qrgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774988594; x=1775593394;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IZnTQ35XhabclR3qxit8OoOAE+RR7rH3Q46FWVoGZdg=;
        b=N2KJD0OgZdx/qvSKZzdo6ZFoQutU2VQjaecRMI1MjoB24bPiLmClNE2dpV/oZPVREL
         qFh5p8LGy3iyVmdAZBQRJ16SSRbBxESN2C+Ves2lDjvAYiKTjZqxP9TwcSHGeo259baw
         XdXxGBYvi3joy8Y8WlUQzmwAk/omnN+n2simUGBSTXfemXgzbk5AcFs/gfDuK4htPmSE
         DAOSwLq3fDHly+zUJ5Rgv6FlH5ev7wzK8MCHpR9vMUE/wHOkg0wKKzIqay83SrbXJROY
         CqnFYFgGkSQidRBGr6IYlS1W1clX9jP5YKANAHJUWTUONld2LyMnSNf8oXoN5S5MiPls
         86Jw==
X-Gm-Message-State: AOJu0Yw0v8kSTuHwPnZcX5Lclt1hJ91g/eGRaGrz4TK1a4IH7CIzrpN+
	JUiAAxx+UTC7x39BMiE4TGWuaryHuNfiooJTs19rG/jDwjvqivj2NglleIyfzA==
X-Gm-Gg: ATEYQzxu+5fdbxHHHtw405PPPvojujK1IPPFd2XCPRv9Iqg4PxAEBAeghnst5n6z0Ik
	KheoMLL+nU2PU3MkUbluNDIKw4galIuZHCuW7NvaRHqNRP6lgtN/inn77j733cRPFlkpwnIzpiR
	NwBTcutbU85jXxzssUMW8wPlUXXfaQahBE/3ZeRsAxi5mblEdUu/UfcmtqZm3wbAaDu4KrTftoJ
	5vj/UCk9GKQyoA6oGwf2uUjesYF/x0XHqvIJMwMCBoa9eXxLVxRreW3OiOcZfg1jnf+pCB8TuvE
	smddwhUP6v8/8qahAaXm9fXkci4QpcrrYqt9wkZ/fMyBpteWp2K+P4fldJA6NexLecOymO0zRD+
	rtt/FXrGPgfSH8WRHJoIhko4Oi7x9Bcpm8Mnqwo4z8VkcN4TKATDAqEkRz8XsDMZOBlNFYCfA66
	LhxqXlKg+D70rASSYClJKwm5k4Kv4w3D5b7RK9+bZbfls4jzEM1Pk7wmZ1MXj2B/O8xX76fJ220
	h4OSn0w6wgWKbyoqdcRS2+xnHXn26RWC4a+rcQUPIY=
X-Received: by 2002:a05:6214:328f:b0:89c:e5f0:8f2f with SMTP id 6a1803df08f44-8a436a1cef9mr15490786d6.6.1774988594486;
        Tue, 31 Mar 2026 13:23:14 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89ecf865ccesm96685616d6.39.2026.03.31.13.23.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 31 Mar 2026 13:23:14 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 08/10] lpfc: Introduce 128G link speed selection and support
Date: Tue, 31 Mar 2026 13:59:26 -0700
Message-Id: <20260331205928.119833-9-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260331205928.119833-1-justintee8345@gmail.com>
References: <20260331205928.119833-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

128G link speed selection and support is added for various mailbox
commands, defines, and ACQE handling.  The default behavior to
autonegotiate supported link speed remains the same.

Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc.h         |  5 +++--
 drivers/scsi/lpfc/lpfc_attr.c    | 21 ++++++++++++---------
 drivers/scsi/lpfc/lpfc_els.c     | 18 ++++++++++++++----
 drivers/scsi/lpfc/lpfc_hbadisc.c |  4 ++--
 drivers/scsi/lpfc/lpfc_init.c    | 12 ++++++++++--
 drivers/scsi/lpfc/lpfc_mbox.c    |  4 ++++
 6 files changed, 45 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 022c8b1bcc24..b67ea1730dcf 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -810,9 +810,10 @@ struct unsol_rcv_ct_ctx {
 #define LPFC_USER_LINK_SPEED_16G	16	/* 16 Gigabaud */
 #define LPFC_USER_LINK_SPEED_32G	32	/* 32 Gigabaud */
 #define LPFC_USER_LINK_SPEED_64G	64	/* 64 Gigabaud */
-#define LPFC_USER_LINK_SPEED_MAX	LPFC_USER_LINK_SPEED_64G
+#define LPFC_USER_LINK_SPEED_128G	128	/* 128 Gigabaud */
+#define LPFC_USER_LINK_SPEED_MAX	LPFC_USER_LINK_SPEED_128G
 
-#define LPFC_LINK_SPEED_STRING "0, 1, 2, 4, 8, 10, 16, 32, 64"
+#define LPFC_LINK_SPEED_STRING "0, 1, 2, 4, 8, 10, 16, 32, 64, 128"
 
 enum nemb_type {
 	nemb_mse = 1,
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 9f7df51f893d..c91fa44b12d4 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -4415,7 +4415,7 @@ static DEVICE_ATTR_RO(lpfc_static_vport);
 /*
 # lpfc_link_speed: Link speed selection for initializing the Fibre Channel
 # connection.
-# Value range is [0,16]. Default value is 0.
+# Value range is [0,128]. Default value is 0.
 */
 /**
  * lpfc_link_speed_store - Set the adapters link speed
@@ -4468,14 +4468,15 @@ lpfc_link_speed_store(struct device *dev, struct device_attribute *attr,
 		"3055 lpfc_link_speed changed from %d to %d %s\n",
 		phba->cfg_link_speed, val, nolip ? "(nolip)" : "(lip)");
 
-	if (((val == LPFC_USER_LINK_SPEED_1G) && !(phba->lmt & LMT_1Gb)) ||
-	    ((val == LPFC_USER_LINK_SPEED_2G) && !(phba->lmt & LMT_2Gb)) ||
-	    ((val == LPFC_USER_LINK_SPEED_4G) && !(phba->lmt & LMT_4Gb)) ||
-	    ((val == LPFC_USER_LINK_SPEED_8G) && !(phba->lmt & LMT_8Gb)) ||
-	    ((val == LPFC_USER_LINK_SPEED_10G) && !(phba->lmt & LMT_10Gb)) ||
-	    ((val == LPFC_USER_LINK_SPEED_16G) && !(phba->lmt & LMT_16Gb)) ||
-	    ((val == LPFC_USER_LINK_SPEED_32G) && !(phba->lmt & LMT_32Gb)) ||
-	    ((val == LPFC_USER_LINK_SPEED_64G) && !(phba->lmt & LMT_64Gb))) {
+	if ((val == LPFC_USER_LINK_SPEED_1G && !(phba->lmt & LMT_1Gb)) ||
+	    (val == LPFC_USER_LINK_SPEED_2G && !(phba->lmt & LMT_2Gb)) ||
+	    (val == LPFC_USER_LINK_SPEED_4G && !(phba->lmt & LMT_4Gb)) ||
+	    (val == LPFC_USER_LINK_SPEED_8G && !(phba->lmt & LMT_8Gb)) ||
+	    (val == LPFC_USER_LINK_SPEED_10G && !(phba->lmt & LMT_10Gb)) ||
+	    (val == LPFC_USER_LINK_SPEED_16G && !(phba->lmt & LMT_16Gb)) ||
+	    (val == LPFC_USER_LINK_SPEED_32G && !(phba->lmt & LMT_32Gb)) ||
+	    (val == LPFC_USER_LINK_SPEED_64G && !(phba->lmt & LMT_64Gb)) ||
+	    (val == LPFC_USER_LINK_SPEED_128G && !(phba->lmt & LMT_128Gb))) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"2879 lpfc_link_speed attribute cannot be set "
 				"to %d. Speed is not supported by this port.\n",
@@ -4500,6 +4501,7 @@ lpfc_link_speed_store(struct device *dev, struct device_attribute *attr,
 	case LPFC_USER_LINK_SPEED_16G:
 	case LPFC_USER_LINK_SPEED_32G:
 	case LPFC_USER_LINK_SPEED_64G:
+	case LPFC_USER_LINK_SPEED_128G:
 		prev_val = phba->cfg_link_speed;
 		phba->cfg_link_speed = val;
 		if (nolip)
@@ -4564,6 +4566,7 @@ lpfc_link_speed_init(struct lpfc_hba *phba, int val)
 	case LPFC_USER_LINK_SPEED_16G:
 	case LPFC_USER_LINK_SPEED_32G:
 	case LPFC_USER_LINK_SPEED_64G:
+	case LPFC_USER_LINK_SPEED_128G:
 		phba->cfg_link_speed = val;
 		return 0;
 	default:
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index d70a4039a345..4e3fe89283e4 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -4329,18 +4329,28 @@ lpfc_format_edc_cgn_desc(struct lpfc_hba *phba, struct fc_tlv_desc *tlv)
 static bool
 lpfc_link_is_lds_capable(struct lpfc_hba *phba)
 {
-	if (!(phba->lmt & LMT_64Gb))
+	if (!(phba->lmt & (LMT_64Gb | LMT_128Gb)))
 		return false;
 	if (phba->sli_rev != LPFC_SLI_REV4)
 		return false;
 
 	if (phba->sli4_hba.conf_trunk) {
-		if (phba->trunk_link.phy_lnk_speed == LPFC_USER_LINK_SPEED_64G)
+		switch (phba->trunk_link.phy_lnk_speed) {
+		case LPFC_USER_LINK_SPEED_128G:
+		case LPFC_USER_LINK_SPEED_64G:
 			return true;
-	} else if (phba->fc_linkspeed == LPFC_LINK_SPEED_64GHZ) {
+		default:
+			return false;
+		}
+	}
+
+	switch (phba->fc_linkspeed) {
+	case LPFC_LINK_SPEED_128GHZ:
+	case LPFC_LINK_SPEED_64GHZ:
 		return true;
+	default:
+		return false;
 	}
-	return false;
 }
 
  /**
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 73e78e633d41..34f8d58192ce 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -3817,7 +3817,7 @@ lpfc_mbx_cmpl_read_topology(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 		if (phba->cmf_active_mode != LPFC_CFG_OFF)
 			lpfc_cmf_signal_init(phba);
 
-		if (phba->lmt & LMT_64Gb)
+		if (phba->lmt & (LMT_64Gb | LMT_128Gb))
 			lpfc_read_lds_params(phba);
 
 	} else if (attn_type == LPFC_ATT_LINK_DOWN ||
@@ -4410,7 +4410,7 @@ lpfc_mbx_cmpl_ns_reg_login(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 					LOG_INIT | LOG_ELS | LOG_DISCOVERY,
 					"4220 Issue EDC status x%x Data x%x\n",
 					rc, phba->cgn_init_reg_signal);
-		} else if (phba->lmt & LMT_64Gb) {
+		} else if (phba->lmt & (LMT_64Gb | LMT_128Gb)) {
 			/* may send link fault capability descriptor */
 			lpfc_issue_els_edc(vport, 0);
 		} else {
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index fd6b48e46a69..70cdb039ef4e 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -789,7 +789,9 @@ lpfc_hba_init_link_fc_topology(struct lpfc_hba *phba, uint32_t fc_topology,
 	    ((phba->cfg_link_speed == LPFC_USER_LINK_SPEED_32G) &&
 	     !(phba->lmt & LMT_32Gb)) ||
 	    ((phba->cfg_link_speed == LPFC_USER_LINK_SPEED_64G) &&
-	     !(phba->lmt & LMT_64Gb))) {
+	     !(phba->lmt & LMT_64Gb)) ||
+	    ((phba->cfg_link_speed == LPFC_USER_LINK_SPEED_128G) &&
+	     !(phba->lmt & LMT_128Gb))) {
 		/* Reset link speed to auto */
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
 				"1302 Invalid speed for this board:%d "
@@ -2535,7 +2537,9 @@ lpfc_get_hba_model_desc(struct lpfc_hba *phba, uint8_t *mdp, uint8_t *descp)
 		return;
 	}
 
-	if (phba->lmt & LMT_64Gb)
+	if (phba->lmt & LMT_128Gb)
+		max_speed = 128;
+	else if (phba->lmt & LMT_64Gb)
 		max_speed = 64;
 	else if (phba->lmt & LMT_32Gb)
 		max_speed = 32;
@@ -10144,6 +10148,10 @@ lpfc_sli4_read_config(struct lpfc_hba *phba)
 				phba->cfg_link_speed =
 					LPFC_USER_LINK_SPEED_64G;
 				break;
+			case LINK_SPEED_128G:
+				phba->cfg_link_speed =
+					LPFC_USER_LINK_SPEED_128G;
+				break;
 			case 0xffff:
 				phba->cfg_link_speed =
 					LPFC_USER_LINK_SPEED_AUTO;
diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index 572db7348806..4c058904758d 100644
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -625,6 +625,10 @@ lpfc_init_link(struct lpfc_hba * phba,
 			mb->un.varInitLnk.link_flags |= FLAGS_LINK_SPEED;
 			mb->un.varInitLnk.link_speed = LINK_SPEED_64G;
 			break;
+		case LPFC_USER_LINK_SPEED_128G:
+			mb->un.varInitLnk.link_flags |= FLAGS_LINK_SPEED;
+			mb->un.varInitLnk.link_speed = LINK_SPEED_128G;
+			break;
 		case LPFC_USER_LINK_SPEED_AUTO:
 		default:
 			mb->un.varInitLnk.link_speed = LINK_SPEED_AUTO;
-- 
2.38.0

