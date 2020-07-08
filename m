Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8B56C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:03:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8154720772
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:03:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="n292cOlk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728848AbgGHMDU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 08:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729232AbgGHMDL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 08:03:11 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B505C08C5DC
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2020 05:03:11 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id o8so2710386wmh.4
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2020 05:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XQHRlmYiMy5z0WnxtNKRalmwQyJTVSmo3hN7/2Qvzas=;
        b=n292cOlkFOyUyQ8ZkW6XuDxtzEgcsyhqPXRt7/EPXsfkxxrObnUpsWEbLWdfZ8Eq6s
         P/lp8mGBvS46SbnST3odFaAF/4nxTUozIlvQvRrCISKPcSbf3EHcfXo3R0XZPFzKWE/M
         /RrB07MQODt05nVNPEhKIQRcU0rvw4VBjKaAiUpdwmUcpfHNL/LQP4J/VFqBS8UcbWoN
         g7QKzYhENoql15R1iKSDZIGmsP/8U05P5VOFN8YtkJTIByodKGe1GMjnqEfFCJb8khIC
         c2jBNUY588S31VNGlrlv95/LdNM8UZFuWKauPiMhIy84/UTVA0T055uCUGikYhYvvilL
         4cOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XQHRlmYiMy5z0WnxtNKRalmwQyJTVSmo3hN7/2Qvzas=;
        b=auv6yTK8Dc0fGiEpKXdqjcNw5Uy/xq5pgPq9/Dmn3L9dsvkNYHb4MnVoavbGwDovAp
         aofVi4JzggCstDWIry724GvuToBztRRT84Dx+0+wISmrxaxJAMPxC5QAYougsPRfO+aO
         sRMeYZue+ilrnlpYWtr4GvZjOlfx0Vqoe0WiJJTJCtloOll8LUVPIjscJJeeOULBErn0
         mZ9WW/qqUIh4R7RsKWszmvh/Tdb/ItJAtRTJ2vObodL0Z9mvUOExmt6n5HfTcKDRLDhK
         rSAHp+B5beo1Lu9cQlkuf3r+c2L2R9cKB2OgQewhD4Ry+R+u7RzKlZzxFxmY3Ycwg8Qy
         oFmw==
X-Gm-Message-State: AOAM53129X2TqMJNWxltzbpz1dIEvDBZ4N9/3UfvdCeIW+VZlZkGQDRP
        NRQcXK7wkxb1KqDHPE2AXuPKUg==
X-Google-Smtp-Source: ABdhPJywj779mVY5kkp6U1/q3t+6iH+w1ef8s3SruZgBMfwL4j+sJHFUFND72bQd7nKC092vdnHnHA==
X-Received: by 2002:a1c:f219:: with SMTP id s25mr8709643wmc.2.1594209789802;
        Wed, 08 Jul 2020 05:03:09 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id m62sm3964997wmm.42.2020.07.08.05.03.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 05:03:08 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        QLogic-Storage-Upstream@qlogic.com
Subject: [PATCH 30/30] scsi: qla4xxx: ql4_init: Provide a missing function param description and fix formatting
Date:   Wed,  8 Jul 2020 13:02:21 +0100
Message-Id: <20200708120221.3386672-31-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200708120221.3386672-1-lee.jones@linaro.org>
References: <20200708120221.3386672-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Kerneldoc function parameter references need to be in the format '@.*: ',
else the kerneldoc checker gets confused.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/qla4xxx/ql4_init.c: In function ‘ql4xxx_set_mac_number’:
 drivers/scsi/qla4xxx/ql4_init.c:17:10: warning: variable ‘func_number’ set but not used [-Wunused-but-set-variable]
 drivers/scsi/qla4xxx/ql4_init.c: In function ‘qla4xxx_pci_config’:
 drivers/scsi/qla4xxx/ql4_init.c:664:6: warning: variable ‘status’ set but not used [-Wunused-but-set-variable]
from  drivers/scsi/qla4xxx/ql4_init.c:9:
from  drivers/scsi/qla4xxx/ql4_init.c:9:
 drivers/scsi/qla4xxx/ql4_init.c:953: warning: Function parameter or member 'is_reset' not described in 'qla4xxx_initialize_adapter'
 drivers/scsi/qla4xxx/ql4_init.c:1168: warning: Function parameter or member 'ha' not described in 'qla4xxx_process_ddb_changed'
 drivers/scsi/qla4xxx/ql4_init.c:1168: warning: Function parameter or member 'fw_ddb_index' not described in 'qla4xxx_process_ddb_changed'
 drivers/scsi/qla4xxx/ql4_init.c:1168: warning: Function parameter or member 'state' not described in 'qla4xxx_process_ddb_changed'
 drivers/scsi/qla4xxx/ql4_init.c:1168: warning: Function parameter or member 'conn_err' not described in 'qla4xxx_process_ddb_changed'

Cc: QLogic-Storage-Upstream@qlogic.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/qla4xxx/ql4_init.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 2bf5e3e639e1a..5963127f7d2ef 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -945,6 +945,7 @@ void qla4xxx_free_ddb_index(struct scsi_qla_host *ha)
 /**
  * qla4xxx_initialize_adapter - initiailizes hba
  * @ha: Pointer to host adapter structure.
+ * @is_reset: Is this init path or reset path
  *
  * This routine parforms all of the steps necessary to initialize the adapter.
  *
@@ -1156,9 +1157,9 @@ int qla4xxx_flash_ddb_change(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
 
 /**
  * qla4xxx_process_ddb_changed - process ddb state change
- * @ha - Pointer to host adapter structure.
- * @fw_ddb_index - Firmware's device database index
- * @state - Device state
+ * @ha: Pointer to host adapter structure.
+ * @fw_ddb_index: Firmware's device database index
+ * @state: Device state
  *
  * This routine processes a Decive Database Changed AEN Event.
  **/
-- 
2.25.1

