Return-Path: <SRS0=JunS=BC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B715C433E3
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 14:01:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73020207BB
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 14:01:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fCUdGbqd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729388AbgGWOB6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jul 2020 10:01:58 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25627 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728002AbgGWOB6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jul 2020 10:01:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595512917;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=FNrI3J22ipRhrW25TFVKILW4WyC6tvsphPA0SNAITiY=;
        b=fCUdGbqdMELt11S6ZNezOB8epB5kWmuw96xhiOXdjYILe6JnIgpN7119UqV5Os1UCjsWNv
        veKxIPgqDmDUvcBVD//8/xLd3DTEMJLW7w4Dr+jgneOBhTIrAafmWjbeCfUgpuOymCSm3G
        e3n3B6HFXEpFQVVdGxV7NUEoc+z480s=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-458-CBy3nl1cP1GAwPiBJIfuRA-1; Thu, 23 Jul 2020 10:01:54 -0400
X-MC-Unique: CBy3nl1cP1GAwPiBJIfuRA-1
Received: by mail-qv1-f70.google.com with SMTP id y7so923778qvj.11
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 07:01:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FNrI3J22ipRhrW25TFVKILW4WyC6tvsphPA0SNAITiY=;
        b=lJhawoL2ahQDd3M2GmRX1F/2u1kQtox1Apb3PS88rW0xg7xpci9fFG8lz5YU5LM68a
         YhtjdBv8ospbDLb/MBDCZculmRpnumEKbgZ3QI6suh+TN3b6uJ5kGcyPdAtN0/VbCWiK
         IQRnM3/pRxMC27ApoFbW4csamIdFCgy0d+rdUE+HxocFjUUQ7SPuVdStR8GJWuoSYJRj
         yD6g9BOwJ/qucklTV+mhe8Na8pknup3gPYq2sDREGvrZXi0qaEgnLQ/39TOzaHDlb5ve
         K5sXipCpJBK/s47pjGNlyWbGMD7wD8lx+tUShtxuBEEQWHx2U/n6HeeMMddI+dFVDGBx
         QqXw==
X-Gm-Message-State: AOAM5327R5O154ED6idnC859r8BnPZ6u/bbwGkQMqOwaTDK271K0UhuD
        F2alEE6WiJd9D+KAB5dZAice8DqlXCtJTNLmPKOLTppvjk+IvoO0t5+rMF/4LiZM+aBjQ39b6Ra
        OJ2knHxe1XBD5FBVKFrxkuA==
X-Received: by 2002:a0c:8583:: with SMTP id o3mr5013026qva.108.1595512914215;
        Thu, 23 Jul 2020 07:01:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy4KIDq8nFjc8M+Ayc6oKKZhshXVGfh68xoXhfmaMHK6Mfi6bMcdpiPnoy+C+NIwEpmBPfoig==
X-Received: by 2002:a0c:8583:: with SMTP id o3mr5013000qva.108.1595512913943;
        Thu, 23 Jul 2020 07:01:53 -0700 (PDT)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id z60sm2534085qtc.30.2020.07.23.07.01.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 07:01:53 -0700 (PDT)
From:   trix@redhat.com
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] scsi: lpfc: add depends CPU_FREQ to SCSI_LPFC configury
Date:   Thu, 23 Jul 2020 07:01:36 -0700
Message-Id: <20200723140136.18367-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Tom Rix <trix@redhat.com>

A compile error

drivers/scsi/lpfc/lpfc_sli.c:7329:26: error: implicit
  declaration of function ‘get_cpu_idle_time’; did you
  mean ‘set_cpu_active’? [-Werror=implicit-function-declaration]
   idle_stat->prev_idle = get_cpu_idle_time(i, &wall, 1);

lpfc_init_idle_stat_hb depends on CPU_FREQ

So add depends CPU_FREQ to the configury.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/scsi/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 571473a58f98..004dcda07d49 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1157,6 +1157,7 @@ config SCSI_LPFC
 	depends on SCSI_FC_ATTRS
 	depends on NVME_TARGET_FC || NVME_TARGET_FC=n
 	depends on NVME_FC || NVME_FC=n
+	depends on CPU_FREQ
 	select CRC_T10DIF
 	help
           This lpfc driver supports the Emulex LightPulse
-- 
2.18.1

