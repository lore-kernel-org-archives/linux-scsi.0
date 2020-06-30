Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 908D3C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 21:50:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6860E2074D
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 21:50:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LzKSRe7I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729921AbgF3VuZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 17:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729914AbgF3VuY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2020 17:50:24 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7386C03E979
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2020 14:50:24 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id j4so19187446wrp.10
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2020 14:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CaTeCvtdkXaOja3UOTzDHPbVHibgT37GnBkcn4sO3NU=;
        b=LzKSRe7I1yTvzoZaZtCvwJdhgSTCapH1WRl7InIqKn5ypMhoGGjTubyASOdU9k43Jt
         M9OgnK4xSALLIFm4XyXG5Zh0phpzfeYiEYq2KA7N6sRT6abXQ8+6LfcI9nT/I/oheoUz
         geniVm/MArou19h4IcmnTJV1TKWOh3cpaFIJcX3jaC49EsGArnMadyKCPFitDFY5cPTu
         wJSOkI1pZYnrDs4DawDfrx5MfwzR5Vu5X4FPYIZjjMXFoqG8MkiHmB6/y4f2vt2bL8yQ
         eBZUM1zHjEwg9aTlJENxfbhzNzWQsiv1jDrmVPFRWmTCDgVini/I89LmxE+fYL8Txk5N
         5e6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CaTeCvtdkXaOja3UOTzDHPbVHibgT37GnBkcn4sO3NU=;
        b=TnMqiKCOAR4MTR9INZKhEBbXN49SiYW1w5osDg2+htq/wjaYfJuwBBfB3n93b2m6Lc
         2zzXoxy2/UYw5WGgyW1ynGtpjXwGJnEr4DqFwTdvc6rrLMfbpj1/QUsHltv40+43arTM
         1ZWVIZKe3o8punai63gg0h1hLWtwOzcDkA6PuFmIX0tch5/JefSQwldtLyvyYm8f5tpN
         q2NMafkEN+1Yc9rS35tCCQ30++1LUyXOrKv1YhRfReTGtmyInByg86IY0+QuZ/tPYgyH
         IwX+0gOhKj1NXHUItxypdSTr+QKiKfK8sk9eDoTvdJcr4A/CjqBq6YAzZp2QDhy3Sx3J
         eV/w==
X-Gm-Message-State: AOAM531ixAkM29POQolK/7hvQdu4IUoHLsBt9I/ZW6twebXqyXBgTL3H
        rX2erg6RTqRgu4qNCddCkoTcJ7SQ
X-Google-Smtp-Source: ABdhPJxxigAzEQiUI+b0OE+TgNXYFkp88BrwA1EzG36x5NJ1Egu59dO9Fq/YJL9/kkW6m9IcQhQKvw==
X-Received: by 2002:adf:aa94:: with SMTP id h20mr22262696wrc.327.1593553822885;
        Tue, 30 Jun 2020 14:50:22 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f14sm5518551wro.90.2020.06.30.14.50.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 14:50:22 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 07/14] lpfc: Fix shost refcount mismatch when deleting vport
Date:   Tue, 30 Jun 2020 14:49:54 -0700
Message-Id: <20200630215001.70793-8-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200630215001.70793-1-jsmart2021@gmail.com>
References: <20200630215001.70793-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When vports are deleted, it is observed that there is memory/kthread
leakage as the vport isn't fully being released.

There is a shost reference taken in scsi_add_host_dma that is not
released during scsi_remove_host. It was noticed that other drivers
resolve this by doing a scsi_host_put after calling scsi_remove_host.

The vport_delete routine is taking two references one that corresponds to
an access to the scsi_host in the vport_delete routine and another that is
released after the adapter mailbox command completes that destroys the VPI
that corresponds to the vport.

Remove one of the references taken such that the second reference that is
put will complete the missing scsi_add_host_dma reference and the shost
will be terminated.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_vport.c | 26 ++++++++------------------
 1 file changed, 8 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
index b76646357980..d0296f7cf45f 100644
--- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -642,27 +642,16 @@ lpfc_vport_delete(struct fc_vport *fc_vport)
 		    vport->port_state < LPFC_VPORT_READY)
 			return -EAGAIN;
 	}
+
 	/*
-	 * This is a bit of a mess.  We want to ensure the shost doesn't get
-	 * torn down until we're done with the embedded lpfc_vport structure.
-	 *
-	 * Beyond holding a reference for this function, we also need a
-	 * reference for outstanding I/O requests we schedule during delete
-	 * processing.  But once we scsi_remove_host() we can no longer obtain
-	 * a reference through scsi_host_get().
-	 *
-	 * So we take two references here.  We release one reference at the
-	 * bottom of the function -- after delinking the vport.  And we
-	 * release the other at the completion of the unreg_vpi that get's
-	 * initiated after we've disposed of all other resources associated
-	 * with the port.
+	 * Take early refcount for outstanding I/O requests we schedule during
+	 * delete processing for unreg_vpi.  Always keep this before
+	 * scsi_remove_host() as we can no longer obtain a reference through
+	 * scsi_host_get() after scsi_host_remove as shost is set to SHOST_DEL.
 	 */
 	if (!scsi_host_get(shost))
 		return VPORT_INVAL;
-	if (!scsi_host_get(shost)) {
-		scsi_host_put(shost);
-		return VPORT_INVAL;
-	}
+
 	lpfc_free_sysfs_attr(vport);
 
 	lpfc_debugfs_terminate(vport);
@@ -809,8 +798,9 @@ lpfc_vport_delete(struct fc_vport *fc_vport)
 		if (!(vport->vpi_state & LPFC_VPI_REGISTERED) ||
 				lpfc_mbx_unreg_vpi(vport))
 			scsi_host_put(shost);
-	} else
+	} else {
 		scsi_host_put(shost);
+	}
 
 	lpfc_free_vpi(phba, vport->vpi);
 	vport->work_port_events = 0;
-- 
2.25.0

