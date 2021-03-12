Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38332C4160E
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 09:49:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C49464FDC
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 09:49:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233206AbhCLJsm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Mar 2021 04:48:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233092AbhCLJsI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Mar 2021 04:48:08 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5538BC061762
        for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2021 01:47:56 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id z2so1404545wrl.5
        for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2021 01:47:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ernCjPMMVGuobH5cM6P0HSGWW9MWpSeDQW02LfHawZ0=;
        b=rV7xkOsGBPIFRjGq0Dz5wZSBevytx0B/6CObs78N1+1GuTNBCsrtzBaxhQmLZcYKvb
         +60VvIE0Tn4ZoDu+XhaL5v/ElwGTjd5q7niHw61TPEG1J27StkOX0hJfNVB2o+pReHvq
         iokyGUoCAoyynwsJHuaW9+CJwEFoe0QUoRNtmOlVe6b2DPM9ZrdTa7BPIORlK8q6UkqH
         8FW9VlKXtNAgsKx5MmBzrKIXkmHT7VlY8ZpQLhG0lQ3i9XoavQ/XBFW8FQSnbIAV1Hgv
         ISyzRlJQZ33rqPLawhW9lIMILijpZMwXoF2tvWZVFiix0uXvOg+PHOtU30/DkCRvdJuI
         gLpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ernCjPMMVGuobH5cM6P0HSGWW9MWpSeDQW02LfHawZ0=;
        b=Yv71aWssKfKe0xcNRGYmTr9ERlYB19RRAERYU/pUvLKjHg2NUkhnpeSfHOz8ks57ej
         pLuCIvAacYyLyz0xHo73C/KgfeI4cPqSdv9pOjaqNv4yHqPvN2t6kFHxb9xoivFDLkmR
         SAfwEoTqpHaddIglp0sjo3fW+nUA92EbKkXcHpeGyMyQDXci4Aq4L/dy0JkAtuWN03pD
         K3zK21gNZ/RHfvNw7IZdnIOoQBe02dTGEwoO05c4dB6IFQ/Ade9veOQVvXq414LsR6Ix
         7SbxLfQKauD4126EqDaDpQrZz5Yazcs9ygkOsM7Xmfx/g8i/7hVNdREQ5F25CFHhQs29
         6+ew==
X-Gm-Message-State: AOAM533V+AQj3A4oTVY498eo2+/wpWmAsJIlOz+deAXHBj6mwrezU23j
        vyR4/mw4ORiPfgWpN06KOaFQGw==
X-Google-Smtp-Source: ABdhPJzVJfO3OjMFAJiQoXF9fqGRD7xpsM2ycwsfdQX3fW3ocsinr2i1s/BTouIeJhIBvj5gIACKKQ==
X-Received: by 2002:a5d:5047:: with SMTP id h7mr13568391wrt.111.1615542475019;
        Fri, 12 Mar 2021 01:47:55 -0800 (PST)
Received: from dell.default ([91.110.221.204])
        by smtp.gmail.com with ESMTPSA id f7sm1539536wmq.11.2021.03.12.01.47.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 01:47:54 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        MPT-FusionLinux.pdl@avagotech.com,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH 06/30] scsi: mpt3sas: mpt3sas_transport: Fix a couple of misdocumented functions/params
Date:   Fri, 12 Mar 2021 09:47:14 +0000
Message-Id: <20210312094738.2207817-7-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210312094738.2207817-1-lee.jones@linaro.org>
References: <20210312094738.2207817-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/mpt3sas/mpt3sas_transport.c:71: warning: Function parameter or member 'phy' not described in '_transport_get_port_id_by_sas_phy'
 drivers/scsi/mpt3sas/mpt3sas_transport.c:354: warning: Function parameter or member 'port_id' not described in '_transport_expander_report_manufacture'
 drivers/scsi/mpt3sas/mpt3sas_transport.c:354: warning: expecting prototype for transport_expander_report_manufacture(). Prototype was for _transport_expander_report_manufacture() instead
 drivers/scsi/mpt3sas/mpt3sas_transport.c:684: warning: Function parameter or member 'hba_port' not described in 'mpt3sas_transport_port_add'
 drivers/scsi/mpt3sas/mpt3sas_transport.c:684: warning: Excess function parameter 'port' description in 'mpt3sas_transport_port_add'

Cc: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: MPT-FusionLinux.pdl@avagotech.com
Cc: MPT-FusionLinux.pdl@broadcom.com
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/mpt3sas/mpt3sas_transport.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index 6f47082247551..0681daee6c149 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -62,7 +62,7 @@
 
 /**
  * _transport_get_port_id_by_sas_phy - get zone's port id that Phy belong to
- * @phy - sas_phy object
+ * @phy: sas_phy object
  *
  * Return Port number
  */
@@ -339,10 +339,11 @@ struct rep_manu_reply {
 };
 
 /**
- * transport_expander_report_manufacture - obtain SMP report_manufacture
+ * _transport_expander_report_manufacture - obtain SMP report_manufacture
  * @ioc: per adapter object
  * @sas_address: expander sas address
  * @edev: the sas_expander_device object
+ * @port_id: Port ID number
  *
  * Fills in the sas_expander_device object when SMP port is created.
  *
@@ -671,7 +672,7 @@ _transport_sanity_check(struct MPT3SAS_ADAPTER *ioc, struct _sas_node *sas_node,
  * @ioc: per adapter object
  * @handle: handle of attached device
  * @sas_address: sas address of parent expander or sas host
- * @port: hba port entry
+ * @hba_port: hba port entry
  * Context: This function will acquire ioc->sas_node_lock.
  *
  * Adding new port object to the sas_node->sas_port_list.
-- 
2.27.0

