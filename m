Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91CF3C43332
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 09:49:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 786DD64F00
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 09:49:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233181AbhCLJsg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Mar 2021 04:48:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233065AbhCLJsF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Mar 2021 04:48:05 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B6A0C061574
        for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2021 01:47:54 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id e18so1402442wrt.6
        for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2021 01:47:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8It0TlKiH23HHYeagj0RrwZW3jVqJUmFhLQQRIEz+M0=;
        b=I2w2lAc9bV5OeVHfiVDOYDJeo247UNTvywDVv3GJIUIDJMDZczSbdNk4298es766WF
         lBhQBQFDOahEKvmm3ts4zwwEfyhVQx4xObNrJg/FBlVmcsqWMBy78hUI9xXMQNgdhzEM
         nCzFKMSZQCHefkEtviqW1JBDMOxlmF8rUhq2oAw0yWEPgVPTN2N/ygV2sLPGgsXEtHR8
         Qjcwl4zibINwl4GLyI7p0o9/7cVrhHYuD5fiNxHOXqDFHQ9GZgw4I/y9WhwKa40+8gUu
         Axf0pWLp9927KbAM9plRNAzFz3hef3waPSm6T0qjdoG1lhl6xc031nSHtC/0FrIeQPYg
         kzLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8It0TlKiH23HHYeagj0RrwZW3jVqJUmFhLQQRIEz+M0=;
        b=nuXqIE/98osr+YSmR02B8qJu0nA+MyvHp+2q1KfCYXOvkKB3LGa/kQXMmaKhVOhVTy
         vJPzrjAYF/XxdaeyJsDyNfrR2Anqn0zaUlKb5dmt44Xi2balwRVB7Xh5PUKl9pBaMPCx
         R9xx3jVZ4K29W7rgzBO/XOvgl++UdyNO5ooINf6W3Ih2B/1bSRgYH3py35J+M4m3RjWE
         1Fqgb8EI9RC4H5B4cNlQgNFL9qL7aOcwqxUC7LdhMNl79JuNAM8WFJWzgfNGMT3tEeuh
         CtD5DUFO0V4zAmZaSF63KU38rq7MkQrN0U+lO9I9B2xve/YlEI/Ce484QLO9PrIZwtV8
         rZzQ==
X-Gm-Message-State: AOAM533ApLCx/krmpHFAa6PsMmhe51Rv9QEgbmmj+Hy/jKcYAv20+E3t
        +AfSEiiz5iBcRrnxGGKN1gcwXg==
X-Google-Smtp-Source: ABdhPJyuE4tGtkv7eTzySF5dng9LAuNEfBhJ2l0qTSlu/wKRagVAvV+ieqATeszOy8PLnYyEXoPFaA==
X-Received: by 2002:a05:6000:192:: with SMTP id p18mr12928007wrx.403.1615542472867;
        Fri, 12 Mar 2021 01:47:52 -0800 (PST)
Received: from dell.default ([91.110.221.204])
        by smtp.gmail.com with ESMTPSA id f7sm1539536wmq.11.2021.03.12.01.47.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 01:47:52 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 04/30] scsi: lpfc: lpfc_attr: Fix a bunch of misnamed functions
Date:   Fri, 12 Mar 2021 09:47:12 +0000
Message-Id: <20210312094738.2207817-5-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210312094738.2207817-1-lee.jones@linaro.org>
References: <20210312094738.2207817-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/lpfc/lpfc_attr.c:880: warning: expecting prototype for lpfc_state_show(). Prototype was for lpfc_link_state_show() instead
 drivers/scsi/lpfc/lpfc_attr.c:3834: warning: expecting prototype for lpfc_tgt_queue_depth_store(). Prototype was for lpfc_tgt_queue_depth_set() instead
 drivers/scsi/lpfc/lpfc_attr.c:4027: warning: expecting prototype for lpfc_topology_set(). Prototype was for lpfc_topology_store() instead
 drivers/scsi/lpfc/lpfc_attr.c:4481: warning: expecting prototype for lpfc_link_speed_set(). Prototype was for lpfc_link_speed_store() instead
 drivers/scsi/lpfc/lpfc_attr.c:4879: warning: expecting prototype for lpfc_request_firmware_store(). Prototype was for lpfc_request_firmware_upgrade_store() instead
 drivers/scsi/lpfc/lpfc_attr.c:5235: warning: expecting prototype for lpfc_state_show(). Prototype was for lpfc_fcp_cpu_map_show() instead

Cc: James Smart <james.smart@broadcom.com>
Cc: Dick Kennedy <dick.kennedy@broadcom.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/lpfc/lpfc_attr.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 98594d6bc26b9..8b4c42016865f 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -864,7 +864,7 @@ lpfc_option_rom_version_show(struct device *dev, struct device_attribute *attr,
 }
 
 /**
- * lpfc_state_show - Return the link state of the port
+ * lpfc_link_state_show - Return the link state of the port
  * @dev: class converted to a Scsi_host structure.
  * @attr: device attribute, not used.
  * @buf: on return contains text describing the state of the link.
@@ -3819,7 +3819,7 @@ lpfc_vport_param_init(tgt_queue_depth, LPFC_MAX_TGT_QDEPTH,
 		      LPFC_MIN_TGT_QDEPTH, LPFC_MAX_TGT_QDEPTH);
 
 /**
- * lpfc_tgt_queue_depth_store: Sets an attribute value.
+ * lpfc_tgt_queue_depth_set: Sets an attribute value.
  * @vport: lpfc vport structure pointer.
  * @val: integer attribute value.
  *
@@ -4004,7 +4004,7 @@ LPFC_ATTR(topology, 0, 0, 6,
 	"Select Fibre Channel topology");
 
 /**
- * lpfc_topology_set - Set the adapters topology field
+ * lpfc_topology_store - Set the adapters topology field
  * @dev: class device that is converted into a scsi_host.
  * @attr:device attribute, not used.
  * @buf: buffer for passing information.
@@ -4457,7 +4457,7 @@ static struct bin_attribute sysfs_drvr_stat_data_attr = {
 # Value range is [0,16]. Default value is 0.
 */
 /**
- * lpfc_link_speed_set - Set the adapters link speed
+ * lpfc_link_speed_store - Set the adapters link speed
  * @dev: Pointer to class device.
  * @attr: Unused.
  * @buf: Data buffer.
@@ -4858,7 +4858,7 @@ lpfc_param_show(sriov_nr_virtfn)
 static DEVICE_ATTR_RW(lpfc_sriov_nr_virtfn);
 
 /**
- * lpfc_request_firmware_store - Request for Linux generic firmware upgrade
+ * lpfc_request_firmware_upgrade_store - Request for Linux generic firmware upgrade
  *
  * @dev: class device that is converted into a Scsi_host.
  * @attr: device attribute, not used.
@@ -5222,7 +5222,7 @@ lpfc_cq_max_proc_limit_init(struct lpfc_hba *phba, int val)
 static DEVICE_ATTR_RW(lpfc_cq_max_proc_limit);
 
 /**
- * lpfc_state_show - Display current driver CPU affinity
+ * lpfc_fcp_cpu_map_show - Display current driver CPU affinity
  * @dev: class converted to a Scsi_host structure.
  * @attr: device attribute, not used.
  * @buf: on return contains text describing the state of the link.
-- 
2.27.0

