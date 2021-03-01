Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FB20C43381
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 17:27:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0F496507D
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 17:27:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234343AbhCAR0s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 12:26:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238003AbhCARV2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 12:21:28 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43D1AC0611C0
        for <linux-scsi@vger.kernel.org>; Mon,  1 Mar 2021 09:18:41 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id c16so847716ply.0
        for <linux-scsi@vger.kernel.org>; Mon, 01 Mar 2021 09:18:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oQB1dAaUqsMnmq94iSdRzzEk5JowgE6V55+PiCf8re8=;
        b=CmitidJHDo7Wz4HkHHZimZ/uF0lbf0mURrBBjK0QwWMZRBwMUBEYFemxGTYknY8JoQ
         ifiHdnDDD3jIP4xlN8s9vFlWE+yYcZ1TPdm0XbdPnG7ft5pK/QfApGUJkhGTmhF8FOZx
         corSfNgS3ngI+PVO4Po7xuIfYRiGKZoLlEI0sUL7/6hICCRBS5UAvebXTYEAT/MQo95/
         zu6zotYOi83hysq5SrMQ5pRsKHaNwQ3oqqwyO9rOif4rIvRQckIB9L+BVQZUWsEdl07/
         CUpopU5YbvimzMeT/71lT7FQ7zh/al4rY+K4pdrr2SOrmXxEc1V9kdMdO4kUdmrVAomV
         9x2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oQB1dAaUqsMnmq94iSdRzzEk5JowgE6V55+PiCf8re8=;
        b=Pt4kTQ7ut0tf+EJPCFaPcfX8ehjWNBSKV+a8MfdLjoaSAhCqEvweHOh5Lt+WzMsiRE
         h0Rq+dC6k9r9fbPmDi3FMoIoMMWc56gqoMv2ybyE/u/PyyavLg5uMy0P8MxaDwGjJ2ir
         MCw9gWotNGX13tjaiA/nxtEVC9uWIwRT7dxa+FsbOK3T30IN6YLGQ9woq3D9Tdan8w/J
         4q/TIjnviawXNf0Od0DAuWJYuQUgEfTERmJrk4SnDyBK7CSYNbk7jTQ1t1S9eTN1XiMZ
         Y4dvJZxVaB3ALfTD9mj7wxKTxu6rZ/wFcWx9E7WP9XvD03SDewKeZVAjx9jv772F4xcm
         ztPQ==
X-Gm-Message-State: AOAM533Qy44ZfwuupPhTwkr1vjfDWFjmsS6NIdkGKKx4fbF7nOsdekFY
        tpimLFzCCu91XhZDpaMw8VA2kQ4j0Uw=
X-Google-Smtp-Source: ABdhPJwev+0OfdNnW4Pq+y3STWAUOWXgyU7IIE5qfLSPJ9UaGdgbGqhw8Dfw8Y1Xm3xbaiNZT0IwBQ==
X-Received: by 2002:a17:902:f242:b029:e4:6dfc:8c1f with SMTP id j2-20020a170902f242b02900e46dfc8c1fmr16314457plc.0.1614619120617;
        Mon, 01 Mar 2021 09:18:40 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t19sm10133602pgj.8.2021.03.01.09.18.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 09:18:40 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH v2 19/22] lpfc: Reduce LOG_TRACE_EVENT logging for vports
Date:   Mon,  1 Mar 2021 09:18:18 -0800
Message-Id: <20210301171821.3427-20-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210301171821.3427-1-jsmart2021@gmail.com>
References: <20210301171821.3427-1-jsmart2021@gmail.com>
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

