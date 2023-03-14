Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06793C61DA4
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Mar 2023 00:52:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbjCNAwp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Mar 2023 20:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbjCNAwo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Mar 2023 20:52:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A6D136C2
        for <linux-scsi@vger.kernel.org>; Mon, 13 Mar 2023 17:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678755125;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=wU6C1kTdlo/msCLzsd7D9dBPtH6geyYmQsAT7wO3k7E=;
        b=Qoj8iTHAJeEDL4GB5g5fjdGGYeVKAi+tRnLLjykFRfdPIb+idnrSIyxIQxMirza1azRW+I
        J3IhMpof3TGMTnxf5widCuAXhmOLRzWLg6gJr5Z/AKi4XZrYlM2Gn4oUCDEGdN1zc24eLu
        uKivnuInDCHH28F306Dk2Msuqx/36X0=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-10-XQheO2KbON-tXKGLrr_fZg-1; Mon, 13 Mar 2023 20:52:04 -0400
X-MC-Unique: XQheO2KbON-tXKGLrr_fZg-1
Received: by mail-qk1-f198.google.com with SMTP id d4-20020a05620a166400b00742859d0d4fso7563013qko.15
        for <linux-scsi@vger.kernel.org>; Mon, 13 Mar 2023 17:52:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678755123;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wU6C1kTdlo/msCLzsd7D9dBPtH6geyYmQsAT7wO3k7E=;
        b=nQZNRfzNBVn5ryES2ZT4093uGGRFsO9BUsvNozjMrSAotPzfu3tkFQpLvZ5jSZDItc
         GX/jYOLsUF3qmDftgDHQV3FU+S1xF4jeJ+fPkMnXmel3B0aobKXygLWyyWRumHJ3QELS
         fReaHu6cMbSyjecbrWl2A1Sk1H0AnbGUaI8d3EeMhGEmE00M6mVsny+QzdG8O0pJBzw/
         73Olv2NUqse8nKN8Grm+eDST08GKtMt7Mo8wc4ksoYHL0EyHS0ueHLkj866hCnSDmQEl
         dHGRKlYCOANTlCqNCiedjL1lDFXLd46LZKuttRw9+OoV3oVXWcXlb/SGyWnpgjF4dNyT
         DDww==
X-Gm-Message-State: AO0yUKVVTUJyHcRka5Ud6SGkp/biWRXLNNbq6RcVXFZjlFTbzv4eLZam
        vEDVbIdx0D3BDeuPaRKyAaOOFNiILlzSf0kvMywvgUAb2zH8zz32NIAkvXG27X+wRlfrhNtfTLK
        Jgsz32rOj13Gwx/BVGS3VCA==
X-Received: by 2002:a05:622a:1c6:b0:3bf:d9d2:2d2c with SMTP id t6-20020a05622a01c600b003bfd9d22d2cmr29417191qtw.53.1678755123449;
        Mon, 13 Mar 2023 17:52:03 -0700 (PDT)
X-Google-Smtp-Source: AK7set/ozd7azivE/r/qnhMQCbLcegLfllz4fDRiotnm8AMyDXscbNGUliFwubGahh0fisCqegbzDg==
X-Received: by 2002:a05:622a:1c6:b0:3bf:d9d2:2d2c with SMTP id t6-20020a05622a01c600b003bfd9d22d2cmr29417169qtw.53.1678755123231;
        Mon, 13 Mar 2023 17:52:03 -0700 (PDT)
Received: from dell-per740-01.7a2m.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id do54-20020a05620a2b3600b0073b929d0371sm780531qkb.4.2023.03.13.17.52.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 17:52:02 -0700 (PDT)
From:   Tom Rix <trix@redhat.com>
To:     ketan.mukadam@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] scsi: be2iscsi: set some be_main.c variables storage-class-specifier to static
Date:   Mon, 13 Mar 2023 20:51:57 -0400
Message-Id: <20230314005157.536918-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

smatch reports several warnings
drivers/scsi/be2iscsi/be_main.c:148:1: warning:
  symbol 'dev_attr_beiscsi_log_enable' was not declared. Should it be static?
drivers/scsi/be2iscsi/be_main.c:158:1: warning:
  symbol 'dev_attr_beiscsi_drvr_ver' was not declared. Should it be static?
drivers/scsi/be2iscsi/be_main.c:159:1: warning:
  symbol 'dev_attr_beiscsi_adapter_family' was not declared. Should it be static?
drivers/scsi/be2iscsi/be_main.c:160:1: warning:
  symbol 'dev_attr_beiscsi_fw_ver' was not declared. Should it be static?
drivers/scsi/be2iscsi/be_main.c:161:1: warning:
  symbol 'dev_attr_beiscsi_phys_port' was not declared. Should it be static?
drivers/scsi/be2iscsi/be_main.c:162:1: warning:
  symbol 'dev_attr_beiscsi_active_session_count' was not declared. Should it be static?
drivers/scsi/be2iscsi/be_main.c:164:1: warning:
  symbol 'dev_attr_beiscsi_free_session_count' was not declared. Should it be static ?

These variables are only used in be_main.c, so should be static.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/scsi/be2iscsi/be_main.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 50a577ac3bb4..e3a07084c7e7 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -139,7 +139,7 @@ beiscsi_disp_param(_name)\
 beiscsi_change_param(_name, _minval, _maxval, _defval)\
 beiscsi_store_param(_name)\
 beiscsi_init_param(_name, _minval, _maxval, _defval)\
-DEVICE_ATTR(beiscsi_##_name, S_IRUGO | S_IWUSR,\
+static DEVICE_ATTR(beiscsi_##_name, S_IRUGO | S_IWUSR,\
 	      beiscsi_##_name##_disp, beiscsi_##_name##_store)
 
 /*
@@ -155,14 +155,14 @@ BEISCSI_RW_ATTR(log_enable, 0x00,
 		"\t\t\t\tConfiguration Path	: 0x20\n"
 		"\t\t\t\tiSCSI Protocol		: 0x40\n");
 
-DEVICE_ATTR(beiscsi_drvr_ver, S_IRUGO, beiscsi_drvr_ver_disp, NULL);
-DEVICE_ATTR(beiscsi_adapter_family, S_IRUGO, beiscsi_adap_family_disp, NULL);
-DEVICE_ATTR(beiscsi_fw_ver, S_IRUGO, beiscsi_fw_ver_disp, NULL);
-DEVICE_ATTR(beiscsi_phys_port, S_IRUGO, beiscsi_phys_port_disp, NULL);
-DEVICE_ATTR(beiscsi_active_session_count, S_IRUGO,
-	     beiscsi_active_session_disp, NULL);
-DEVICE_ATTR(beiscsi_free_session_count, S_IRUGO,
-	     beiscsi_free_session_disp, NULL);
+static DEVICE_ATTR(beiscsi_drvr_ver, S_IRUGO, beiscsi_drvr_ver_disp, NULL);
+static DEVICE_ATTR(beiscsi_adapter_family, S_IRUGO, beiscsi_adap_family_disp, NULL);
+static DEVICE_ATTR(beiscsi_fw_ver, S_IRUGO, beiscsi_fw_ver_disp, NULL);
+static DEVICE_ATTR(beiscsi_phys_port, S_IRUGO, beiscsi_phys_port_disp, NULL);
+static DEVICE_ATTR(beiscsi_active_session_count, S_IRUGO,
+		   beiscsi_active_session_disp, NULL);
+static DEVICE_ATTR(beiscsi_free_session_count, S_IRUGO,
+		   beiscsi_free_session_disp, NULL);
 
 static struct attribute *beiscsi_attrs[] = {
 	&dev_attr_beiscsi_log_enable.attr,
-- 
2.27.0

