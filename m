Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A9A5C4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 22:17:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5270460EB1
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 22:17:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232224AbhGVVhJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Jul 2021 17:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232360AbhGVVhH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jul 2021 17:37:07 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 015E0C061575
        for <linux-scsi@vger.kernel.org>; Thu, 22 Jul 2021 15:17:41 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id my10so8085932pjb.1
        for <linux-scsi@vger.kernel.org>; Thu, 22 Jul 2021 15:17:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3+Jvc6e7UyBtZFvasOd7rc7EfG0SG3w2P23Afyr5MIY=;
        b=dgnUcCnw12OkbOydLCkpuDG3ZVwCTUBx5p9PlnXWLZKZOARFs4dOQZZAe1MH1xFAm9
         4SGGwoavcxvBUpZ/SgclMHik2iDTk3757XrbBEQOo9kJi3qXl24vubadCmyFA2cb0ILd
         HV4tuJwkjfthBPqn4iGjgqICuRTy62yO9PaQDh72hf68GGD29XzdzOfBtuat5T9U4aTs
         Hz+FhocCg263two1GoT27UhjOD4uLWMoncWbBXBbgcLlGHuCcAALj2iXReLuLh1I5BMI
         ec0+UnJIRMqKzIHAgqb3FNBO3Sp8RKlTVdlAzeEfpH6ehDxlXB5+PvZ2UaWeUVN9trAw
         cEOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3+Jvc6e7UyBtZFvasOd7rc7EfG0SG3w2P23Afyr5MIY=;
        b=uQ8hCsSAr/EQhHrp2hgCzjYgRKPxfeyc3s9DG1tukxyX22dWMRm+zy8L2HJVNNOULu
         MHLEHAiYZancwRJnel5OBEVSg6CEAtKdUJukI+NjsdvUKG3wVBc5TY/C8IItW1yeE2z3
         ewOvY7FXa6LrpZ/QLK+oJTWZY6UdJk/2K/ZuvnH8IXd6VQsla9TIKLMue8TWFcWtgjPR
         iBGv2TvrZJoxXXtIxMo20DSMqz0vW/bhZIXZJ37osJ2lWgqt7W48TewjvusZbwOHF36p
         anuPWo4Gf6R5eZk+Nqcl+K2XXGt13jbHcjMr+ITIWUwau8mqUtVtuRzIGk4h8fuWHeYe
         tctw==
X-Gm-Message-State: AOAM531GFg0FMDIOvXLMKoJWm/50raclgq5IGGsGoLJ/I72p3BnGtc5Z
        lStqixPEsGw4jbCQxKL00gcqLLRb5TA=
X-Google-Smtp-Source: ABdhPJx1rtWVhesQwE9yOAraomQlOQYgdMDZyU3wYDw5vm4TkurXZV25kC+ZMFOWWtoCLB2voXOe6Q==
X-Received: by 2002:a63:ef02:: with SMTP id u2mr2096258pgh.298.1626992260493;
        Thu, 22 Jul 2021 15:17:40 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a18sm31374460pfi.6.2021.07.22.15.17.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 15:17:40 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 4/6] lpfc: Add 256Gb link speed support
Date:   Thu, 22 Jul 2021 15:17:19 -0700
Message-Id: <20210722221721.74388-5-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210722221721.74388-1-jsmart2021@gmail.com>
References: <20210722221721.74388-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update routines to support 256Gb link speed for LPe37000/LPe38000
adapters. 256Gb speeds can be seen on trunk links.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_attr.c    | 3 +++
 drivers/scsi/lpfc/lpfc_ct.c      | 5 +++++
 drivers/scsi/lpfc/lpfc_els.c     | 8 ++++++++
 drivers/scsi/lpfc/lpfc_hbadisc.c | 1 +
 drivers/scsi/lpfc/lpfc_init.c    | 5 +++++
 drivers/scsi/lpfc/lpfc_scsi.h    | 4 ++++
 6 files changed, 26 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index a5154856bc0f..869c2b6f1515 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -6745,6 +6745,9 @@ lpfc_get_host_speed(struct Scsi_Host *shost)
 		case LPFC_LINK_SPEED_128GHZ:
 			fc_host_speed(shost) = FC_PORTSPEED_128GBIT;
 			break;
+		case LPFC_LINK_SPEED_256GHZ:
+			fc_host_speed(shost) = FC_PORTSPEED_256GBIT;
+			break;
 		default:
 			fc_host_speed(shost) = FC_PORTSPEED_UNKNOWN;
 			break;
diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 1acb8820a08e..a1c85fa135a9 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -2846,6 +2846,8 @@ lpfc_fdmi_port_attr_support_speed(struct lpfc_vport *vport,
 
 	ae->un.AttrInt = 0;
 	if (!(phba->hba_flag & HBA_FCOE_MODE)) {
+		if (phba->lmt & LMT_256Gb)
+			ae->un.AttrInt |= HBA_PORTSPEED_256GFC;
 		if (phba->lmt & LMT_128Gb)
 			ae->un.AttrInt |= HBA_PORTSPEED_128GFC;
 		if (phba->lmt & LMT_64Gb)
@@ -2927,6 +2929,9 @@ lpfc_fdmi_port_attr_speed(struct lpfc_vport *vport,
 		case LPFC_LINK_SPEED_128GHZ:
 			ae->un.AttrInt = HBA_PORTSPEED_128GFC;
 			break;
+		case LPFC_LINK_SPEED_256GHZ:
+			ae->un.AttrInt = HBA_PORTSPEED_256GFC;
+			break;
 		default:
 			ae->un.AttrInt = HBA_PORTSPEED_UNKNOWN;
 			break;
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 342c7e28ee95..08ae2b12b92c 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -6105,6 +6105,12 @@ lpfc_rdp_res_speed(struct fc_rdp_port_speed_desc *desc, struct lpfc_hba *phba)
 	case LPFC_LINK_SPEED_64GHZ:
 		rdp_speed = RDP_PS_64GB;
 		break;
+	case LPFC_LINK_SPEED_128GHZ:
+		rdp_speed = RDP_PS_128GB;
+		break;
+	case LPFC_LINK_SPEED_256GHZ:
+		rdp_speed = RDP_PS_256GB;
+		break;
 	default:
 		rdp_speed = RDP_PS_UNKNOWN;
 		break;
@@ -6112,6 +6118,8 @@ lpfc_rdp_res_speed(struct fc_rdp_port_speed_desc *desc, struct lpfc_hba *phba)
 
 	desc->info.port_speed.speed = cpu_to_be16(rdp_speed);
 
+	if (phba->lmt & LMT_256Gb)
+		rdp_cap |= RDP_PS_256GB;
 	if (phba->lmt & LMT_128Gb)
 		rdp_cap |= RDP_PS_128GB;
 	if (phba->lmt & LMT_64Gb)
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 32fb3be42b26..6da2daf7d9e3 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -3331,6 +3331,7 @@ lpfc_mbx_process_link_up(struct lpfc_hba *phba, struct lpfc_mbx_read_top *la)
 		case LPFC_LINK_SPEED_32GHZ:
 		case LPFC_LINK_SPEED_64GHZ:
 		case LPFC_LINK_SPEED_128GHZ:
+		case LPFC_LINK_SPEED_256GHZ:
 			break;
 		default:
 			phba->fc_linkspeed = LPFC_LINK_SPEED_UNKNOWN;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index ead8e91e8625..2c0aaa0a301d 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -4679,6 +4679,8 @@ static void lpfc_host_supported_speeds_set(struct Scsi_Host *shost)
 	if (phba->hba_flag & HBA_FCOE_MODE)
 		return;
 
+	if (phba->lmt & LMT_256Gb)
+		fc_host_supported_speeds(shost) |= FC_PORTSPEED_256GBIT;
 	if (phba->lmt & LMT_128Gb)
 		fc_host_supported_speeds(shost) |= FC_PORTSPEED_128GBIT;
 	if (phba->lmt & LMT_64Gb)
@@ -5087,6 +5089,9 @@ lpfc_sli4_port_speed_parse(struct lpfc_hba *phba, uint32_t evt_code,
 		case LPFC_FC_LA_SPEED_128G:
 			port_speed = 128000;
 			break;
+		case LPFC_FC_LA_SPEED_256G:
+			port_speed = 256000;
+			break;
 		default:
 			port_speed = 0;
 		}
diff --git a/drivers/scsi/lpfc/lpfc_scsi.h b/drivers/scsi/lpfc/lpfc_scsi.h
index f76667b7da7b..46989532c23d 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.h
+++ b/drivers/scsi/lpfc/lpfc_scsi.h
@@ -142,6 +142,10 @@ struct lpfc_scsicmd_bkt {
 #define FC_PORTSPEED_128GBIT	0x2000
 #endif
 
+#ifndef FC_PORTSPEED_256GBIT
+#define FC_PORTSPEED_256GBIT	0x4000
+#endif
+
 #define TXRDY_PAYLOAD_LEN	12
 
 /* For sysfs/debugfs tmp string max len */
-- 
2.26.2

