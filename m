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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B0C1C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 23:47:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F57864E44
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 23:47:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhBKXrs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 18:47:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbhBKXq4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2021 18:46:56 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FBB1C06121E
        for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2021 15:45:04 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id 189so4714917pfy.6
        for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2021 15:45:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oQB1dAaUqsMnmq94iSdRzzEk5JowgE6V55+PiCf8re8=;
        b=s8ShMmJfppC11a9vzQvFakMZdEIT8zVLNchxdXGkCZJ3CZXJJ/O1VCQacKnfi5E2xt
         OcCALFWVMiQzkJnQngkIxDk75QPPAhFogVu9dP6iNCCg1au3/SDyPkoB5s6u8FdwiF78
         byWKGwKjKWIq9iPQQ/PXSSsxhKp+0TFUibXpoajjKx4dO18gJJrt2t8QljHSybifSUfg
         zsMyxOKaT5ZDYIOAXKcMzy0bCl9GOi8oVe9st4ybnyFq39VgFLUo1YDBRZPD1QAJDR2f
         5ORvxXpgijoJxuzvtv52h9Yxuy0IXYvPlxeXJcqR/QOeSF/LjoECzQ9wf1Kb3Dw+Snz8
         gVEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oQB1dAaUqsMnmq94iSdRzzEk5JowgE6V55+PiCf8re8=;
        b=lET336JJ19t8askgwR2FeIJG1ThRtcUZ7UEK/G+3Y+Bn1AlDH4OBdWTdindKnmLSA8
         QwkQGM1NHgZaIlVG0V5c3TM7yNXfHxzpi+sEzlGt6HqLUxK8j6GEtP9WeGNOPYSXWH46
         bdQHLhuZLrP3OeaHcVZ47JOrNv2RcCpiRM9jIj+Ch/ypKpAUD1ET71YafEV6GOEC56AZ
         sqlGHlTMiEoyFrk7b8xjZM2//fM6iSpNVgHJe+DoKG8bOzM1Fd5cZc2w+5ypIomz1DPs
         hekElCLePUkXnuPIUat7JJVuS4TPsW4O+pGqWKgMWOmwQhzNwCLP84fADoiL04IYg8Ii
         eszg==
X-Gm-Message-State: AOAM531wUw51pixVbklmxQSQ/QjjZBQD/uwX2IK2LapWc0bTuMYj1rlI
        73kORZH4STUN4uT/oSvsC16j7D/9tXk=
X-Google-Smtp-Source: ABdhPJzT9yLYd3cq8uj1d+K0UQNpad4xS5PqgLYGqMmB52e2SdmOQDbjc+VtlJLVgH40Ldfr6xy1eA==
X-Received: by 2002:a05:6a00:2305:b029:1b4:8368:13fd with SMTP id h5-20020a056a002305b02901b4836813fdmr445183pfh.0.1613087103902;
        Thu, 11 Feb 2021 15:45:03 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i67sm6808035pfe.19.2021.02.11.15.45.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 15:45:03 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 19/22] lpfc: Reduce LOG_TRACE_EVENT logging for vports
Date:   Thu, 11 Feb 2021 15:44:40 -0800
Message-Id: <20210211234443.3107-20-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210211234443.3107-1-jsmart2021@gmail.com>
References: <20210211234443.3107-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Lots of discovery messages are flooding the console log when testing
NPIV.

Informational message for vports should have LOG_VPORT associated with
it as opposed to LOG_TRACE_EVENT.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_vport.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
index ccf7b6cd0bd8..2fb6904f3209 100644
--- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -190,7 +190,7 @@ lpfc_valid_wwn_format(struct lpfc_hba *phba, struct lpfc_name *wwn,
 	      ((wwn->u.wwn[0] & 0xf) != 0 || (wwn->u.wwn[1] & 0xf) != 0)))
 		return 1;
 
-	lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
+	lpfc_printf_log(phba, KERN_ERR, LOG_VPORT,
 			"1822 Invalid %s: %02x:%02x:%02x:%02x:"
 			"%02x:%02x:%02x:%02x\n",
 			name_type,
@@ -531,7 +531,7 @@ disable_vport(struct fc_vport *fc_vport)
 	}
 
 	lpfc_vport_set_state(vport, FC_VPORT_DISABLED);
-	lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
+	lpfc_printf_vlog(vport, KERN_ERR, LOG_VPORT,
 			 "1826 Vport Disabled.\n");
 	return VPORT_OK;
 }
@@ -579,7 +579,7 @@ enable_vport(struct fc_vport *fc_vport)
 	}
 
 out:
-	lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
+	lpfc_printf_vlog(vport, KERN_ERR, LOG_VPORT,
 			 "1827 Vport Enabled.\n");
 	return VPORT_OK;
 }
@@ -725,7 +725,7 @@ lpfc_vport_delete(struct fc_vport *fc_vport)
 	spin_lock_irq(&phba->port_list_lock);
 	list_del_init(&vport->listentry);
 	spin_unlock_irq(&phba->port_list_lock);
-	lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
+	lpfc_printf_vlog(vport, KERN_ERR, LOG_VPORT,
 			 "1828 Vport Deleted.\n");
 	scsi_host_put(shost);
 	return VPORT_OK;
-- 
2.26.2

