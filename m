Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DA50C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 09:47:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D08D964E00
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 09:47:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbhBKJrV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 04:47:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35854 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229939AbhBKJhh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 Feb 2021 04:37:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613036162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=yrH14ThSpslMqaxU9hfy00CpYCwozqauB+Xha4aC2vk=;
        b=FoRymX0tRzyHXp2+bOKNFF7/SiRusHkQtAf+I+nLtImZHBUwzNNv4SmDuMeJnIJ2EYa7Ud
        en4iFjCJ02B4hjy+8aJhPQVv09LkzjIQF6uer+xWVKK4vy1/CAlgqwkVfTgoz1CcWlAUfx
        6TGyIRrzz05XRJdlsnIzGBWSwzyKip4=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-168-JKIb-o8XNuCDqwxBLKRv5A-1; Thu, 11 Feb 2021 04:36:00 -0500
X-MC-Unique: JKIb-o8XNuCDqwxBLKRv5A-1
Received: by mail-pj1-f71.google.com with SMTP id gx14so3418713pjb.6
        for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2021 01:36:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=yrH14ThSpslMqaxU9hfy00CpYCwozqauB+Xha4aC2vk=;
        b=d0coDsb+nvzicu8D8ncCRgYw+GC/rWOVXNc92i4hyj8uEMz67RHoY08txkzNaxtO7v
         RvF4zwYOQ/SVGZht52PQPYUkgiSllJL/WXDUVbTx68p1GnBboEnlXTErHLi8eimEkv2C
         0jEjE0okd1N70yH/UNjLZHcSeJ2IuxJKJxz0WLHTUKvYSj1dGo5nIFR0tBDgiwOg6QrO
         fU3vPfCeEwXLFYBok3I18pEwA1BB768fGmzyl17s/S2JeRWwvTs9zrRbJ+NfVJnPPkvg
         utnsW68S1JB2T9Sizzs12KkGJYbTgM0zQDDGq6Ki+LHYzh/jz7L3rbdOVQRF1y926rYx
         OFuA==
X-Gm-Message-State: AOAM5321ATpp9jyy3w9KWwsdWObXZsv5+k6Ln73MKQvH4TtKlQuP4pht
        x3nkRz4rSKVNGAyo/S3RcdbWjGNcgW7gT6LBt5WHCQ9z5VmmLm0tuzGzc0p7k5dTD4Yx7gslvQm
        cFrwlgAhLh2xR5OwuoAvZLA==
X-Received: by 2002:a17:90b:4a8c:: with SMTP id lp12mr3150910pjb.214.1613036159714;
        Thu, 11 Feb 2021 01:35:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzX5s6369kWgAFyoKTN1EnUhX28RncCcpO0G+q/leGwlQX5B7qbMMkpk7dNzP4jkl0D3uCh/A==
X-Received: by 2002:a17:90b:4a8c:: with SMTP id lp12mr3150881pjb.214.1613036159432;
        Thu, 11 Feb 2021 01:35:59 -0800 (PST)
Received: from machine1 ([171.50.216.159])
        by smtp.gmail.com with ESMTPSA id p12sm4469782pju.35.2021.02.11.01.35.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 01:35:58 -0800 (PST)
Date:   Thu, 11 Feb 2021 15:05:52 +0530
From:   "Milan P. Gandhi" <mgandhi@redhat.com>
To:     kernel-janitors@vger.kernel.org
Cc:     GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org,
        njavali@marvell.com, jejb@linux.ibm.com, martin.petersen@oracle.com
Subject: [PATCH] scsi: qla2xxx: Removed extra space in variable declaration.
Message-ID: <20210211093552.GA5375@machine1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.11.3 (2019-02-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Milan P. Gandhi <mgandhi@redhat.com>
---
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index ab45ac1e5a72..7f2db8badb6d 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -226,7 +226,7 @@ qla2x00_sysfs_write_nvram(struct file *filp, struct kobject *kobj,
 	struct scsi_qla_host *vha = shost_priv(dev_to_shost(container_of(kobj,
 	    struct device, kobj)));
 	struct qla_hw_data *ha = vha->hw;
-	uint16_t	cnt;
+	uint16_t cnt;
 
 	if (!capable(CAP_SYS_ADMIN) || off != 0 || count != ha->nvram_size ||
 	    !ha->isp_ops->write_nvram)

