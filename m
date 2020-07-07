Return-Path: <SRS0=EBgm=AS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 810CDC433DF
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 14:01:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FAD52073E
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jul 2020 14:01:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pjWCUJEZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728337AbgGGOBj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jul 2020 10:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728073AbgGGOBD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jul 2020 10:01:03 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 172FBC061755
        for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2020 07:01:03 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 17so46585638wmo.1
        for <linux-scsi@vger.kernel.org>; Tue, 07 Jul 2020 07:01:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jN1nbT1sxQbFlRXUCBfggkW/hnjjJGCQVCG/NPTfu6Y=;
        b=pjWCUJEZwyPxA5RaPU66fCI6rKNgDNOxWlKt8d8YsnOGnz9+M2K1koQ7iG9eKhjaFx
         g8YYXzC7TkDHe9hJ+8+ILM1uoCB/M+MHWG34tN2gn70O8IytBqRJWMHsFxODpQitWvEe
         sT1z3OQLglHZy7jLwHM8UGQsPz8CNy8aRD+rEndm5AA2TpFh6opalazJ6fET6JTQdH6o
         +tipp3x4BsKQaEnJZRxgT8WT7DN2KIDtAgsdP5DvogsK2YWShtueljfN3tKDaAN+lpu2
         YLnIN4NNKIPdCd2/DMVhL0hcCLI01P4Qqh9eyPNxWoFhcq6sDnQe2S9JbIZ4IQOte1b9
         to+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jN1nbT1sxQbFlRXUCBfggkW/hnjjJGCQVCG/NPTfu6Y=;
        b=mcApt7Lfocpid/R8wJvCTy+Daya8/13PATonmZSoU4ncgt0j5z7IQ/oZaxf9ISk756
         tt/V56b0L5QqwaUFA3z1Fjn9M13inc7HFMXK8q6k5QeFIY+v92F6JDmTLfnOfI1dbt34
         wnfgAh+RpJpUl5J2M3b068qf1Zk32cAo3Ov12pDLsAQ0OtbbylbQf84o8KrxmXpKheHd
         X7KMPyl5Zr1Eqh4K2Y5hpD4i7P2hxbK0xHZt5rHKwYWh1xt+4586xmuLCdo5mUMEGpDR
         ZkS9S3gjb7CNUejlEnZYDsZnvd+T9f5PBfcxE85HI70PYspMkk2iOtXTlnyn/hmWolX2
         yZrw==
X-Gm-Message-State: AOAM5316cPnHPxX7l9EU+xMh7TAhaGtuJD+eVi+58Uxl6hbdMGd+doCf
        bAx+Q8yM24DubxDC7S9pVGtv5gDm8w8=
X-Google-Smtp-Source: ABdhPJzUV97sKhk0cTprn9h4VIm8fJrhl/nqYSZ5hY14wPRhadSv020fwC6sc7z+gXrJDrbeBjfV5A==
X-Received: by 2002:a1c:4303:: with SMTP id q3mr4547681wma.134.1594130461172;
        Tue, 07 Jul 2020 07:01:01 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id z25sm1102823wmk.28.2020.07.07.07.01.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 07:01:00 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Atul Mukker <Atul.Mukker@lsi.com>,
        Sreenivas Bagalkote <Sreenivas.Bagalkote@lsi.com>,
        Manoj Jose <Manoj.Jose@lsi.com>, megaraidlinux@lsi.com,
        megaraidlinux.pdl@broadcom.com
Subject: [PATCH 02/10] scsi: megaraid: megaraid_mbox: Fix some kerneldoc bitrot
Date:   Tue,  7 Jul 2020 15:00:47 +0100
Message-Id: <20200707140055.2956235-3-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200707140055.2956235-1-lee.jones@linaro.org>
References: <20200707140055.2956235-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some function parameters have changed without updating the documentation.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/megaraid/megaraid_mbox.c:3314: warning: Excess function parameter 'level' description in 'megaraid_mbox_display_scb'
 drivers/scsi/megaraid/megaraid_mbox.c:3985: warning: Function parameter or member 'dev' not described in 'megaraid_sysfs_show_app_hndl'
 drivers/scsi/megaraid/megaraid_mbox.c:3985: warning: Function parameter or member 'attr' not described in 'megaraid_sysfs_show_app_hndl'
 drivers/scsi/megaraid/megaraid_mbox.c:3985: warning: Excess function parameter 'cdev' description in 'megaraid_sysfs_show_app_hndl'

Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: Atul Mukker <Atul.Mukker@lsi.com>
Cc: Sreenivas Bagalkote <Sreenivas.Bagalkote@lsi.com>
Cc: Manoj Jose <Manoj.Jose@lsi.com>
Cc: megaraidlinux@lsi.com
Cc: megaraidlinux.pdl@broadcom.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/megaraid/megaraid_mbox.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index 8f918df631bfe..cace28dd81ad8 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -3304,7 +3304,6 @@ megaraid_mbox_fire_sync_cmd(adapter_t *adapter)
  * megaraid_mbox_display_scb - display SCB information, mostly debug purposes
  * @adapter		: controller's soft state
  * @scb			: SCB to be displayed
- * @level		: debug level for console print
  *
  * Diplay information about the given SCB iff the current debug level is
  * verbose.
@@ -3972,7 +3971,8 @@ megaraid_sysfs_get_ldmap(adapter_t *adapter)
 
 /**
  * megaraid_sysfs_show_app_hndl - display application handle for this adapter
- * @cdev	: class device object representation for the host
+ * @dev		: device object representation for the host
+ * @attr	: unused
  * @buf		: buffer to send data to
  *
  * Display the handle used by the applications while executing management
-- 
2.25.1

