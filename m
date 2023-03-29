Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A86B1C74A5B
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Mar 2023 13:26:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbjC2N0H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Mar 2023 09:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbjC2N0B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Mar 2023 09:26:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A2CD8
        for <linux-scsi@vger.kernel.org>; Wed, 29 Mar 2023 06:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680096291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=rtS7QVAtuYQjDEY7nXHnoqbfop6chvBfZPGcSLcnwDU=;
        b=R7G5+qa2bAPZzw5b+Fb/3gBgSFVZQ1nWAdHUXQR9Di0sjpvOTL9HLnhyMRLogWQmCC6HKN
        j9FJSey9TgocpvbXH2ty11PbEofqDlQEjsSCe9lM85MBoDsX3XjV7o+g7e4Ko76s3JILFD
        TCFlgU+la7kMRjIKhaz/DmASQ7s8P1k=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-650-CkKAlFiNN76-dNEHmk0CXA-1; Wed, 29 Mar 2023 09:24:50 -0400
X-MC-Unique: CkKAlFiNN76-dNEHmk0CXA-1
Received: by mail-qv1-f70.google.com with SMTP id px9-20020a056214050900b005d510cdfc41so6629500qvb.7
        for <linux-scsi@vger.kernel.org>; Wed, 29 Mar 2023 06:24:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680096290;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rtS7QVAtuYQjDEY7nXHnoqbfop6chvBfZPGcSLcnwDU=;
        b=H3ZxXNnAfRK9BP2tP4J3Ic6YUuntTIw7MrQtt02GCzhTPet0l2kncAcCse4o3gPCBU
         vEJhBl6GIdcwinipeQER15Qc1udAZqBAYIlTCSLZMKUv9XJs09noNB4PhgkvhzwJ+jLL
         f9mQRxse6hwsulqUIRzHycgmRFVjzzhPFvYiv+KgasJ5Q7eJpnaJzBEhQYebGeRSaUcH
         dpGn4eJNx2XSTfw4kM/DCtAU5HUbypVsoxU3C+Ng0UXGUnqcVL5GtTrlc5812ZoCy2VE
         NvKz/+3WYXVQ452z1hk3okFN4Q00WjhWMrG0ZjiEH45LPzG2ge0cTkZ93suWjbhIbRp0
         j2gA==
X-Gm-Message-State: AO0yUKUAjH9t5xRrjdvzrF27WXfauschj6DrLsG0cJt8KD+IwNk+nJB3
        MVg/vQoCRbzGAWyRTVCu2bNR/LbTqiaUIIytO1ac+Ny5BZ9gf6GwiyXDTDOH677SICJhr9FMfo7
        IYiQ7DI26KmzwVd6SfJi3qA==
X-Received: by 2002:a05:622a:1903:b0:3e3:982b:f535 with SMTP id w3-20020a05622a190300b003e3982bf535mr35038323qtc.33.1680096290100;
        Wed, 29 Mar 2023 06:24:50 -0700 (PDT)
X-Google-Smtp-Source: AK7set/pxHT+zYmnDLN7+oI3EGOeAUDzDtVHPAhTMokbOjOy3WQMS3mqH9rtro9CtstXRdGMpp050g==
X-Received: by 2002:a05:622a:1903:b0:3e3:982b:f535 with SMTP id w3-20020a05622a190300b003e3982bf535mr35038289qtc.33.1680096289729;
        Wed, 29 Mar 2023 06:24:49 -0700 (PDT)
Received: from dell-per740-01.7a2m.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id l6-20020ac848c6000000b003bfb0ea8094sm9803279qtr.83.2023.03.29.06.24.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 06:24:49 -0700 (PDT)
From:   Tom Rix <trix@redhat.com>
To:     martin.petersen@oracle.com, nathan@kernel.org,
        ndesaulniers@google.com
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] scsi: target: core: remove unused prod_len variable
Date:   Wed, 29 Mar 2023 09:24:21 -0400
Message-Id: <20230329132421.1809362-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

clang with W=1 reports
drivers/target/target_core_spc.c:229:6: error: variable
  'prod_len' set but not used [-Werror,-Wunused-but-set-variable]
        u32 prod_len;
            ^
This variable is not used so remove it.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/target/target_core_spc.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 5bae45c3fb65..89c0d56294cc 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -226,7 +226,6 @@ spc_emulate_evpd_83(struct se_cmd *cmd, unsigned char *buf)
 	struct t10_alua_lu_gp_member *lu_gp_mem;
 	struct t10_alua_tg_pt_gp *tg_pt_gp;
 	unsigned char *prod = &dev->t10_wwn.model[0];
-	u32 prod_len;
 	u32 off = 0;
 	u16 len = 0, id_len;
 
@@ -267,10 +266,6 @@ spc_emulate_evpd_83(struct se_cmd *cmd, unsigned char *buf)
 	 * T10 Vendor Identifier Page, see spc4r17 section 7.7.3.4
 	 */
 	id_len = 8; /* For Vendor field */
-	prod_len = 4; /* For VPD Header */
-	prod_len += 8; /* For Vendor field */
-	prod_len += strlen(prod);
-	prod_len++; /* For : */
 
 	if (dev->dev_flags & DF_EMULATED_VPD_UNIT_SERIAL)
 		id_len += sprintf(&buf[off+12], "%s:%s", prod,
-- 
2.27.0

