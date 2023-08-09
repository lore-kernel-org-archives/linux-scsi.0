Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FF02C001DE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Aug 2023 19:11:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232755AbjHITLs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Aug 2023 15:11:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232549AbjHITLp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Aug 2023 15:11:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4282910E7
        for <linux-scsi@vger.kernel.org>; Wed,  9 Aug 2023 12:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691608268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=idN6k6wnvIRmPVarrYDUY5WM1/+zqey5Stp1+3/1nn8=;
        b=XWDcY21VyZJGGoLxFXrxvagO+5wGL7ptTZ4K9ltum8x8vWgA40WSC859d3Gi74eeq+7AE6
        dRUm2Ne0ZGRNAqe+xsN9MsUK0iMS7n+RVb7T5fmivx9MMJ/LtXDOojrUDj6wTgiyzuzl4o
        srEHQhz+p3wwV8EYZErK4Z32adU4EU8=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-567-UiGGQpg5Ole-8NhyEb3LSg-1; Wed, 09 Aug 2023 15:11:07 -0400
X-MC-Unique: UiGGQpg5Ole-8NhyEb3LSg-1
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-583fe0f84a5so2894547b3.3
        for <linux-scsi@vger.kernel.org>; Wed, 09 Aug 2023 12:11:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691608266; x=1692213066;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=idN6k6wnvIRmPVarrYDUY5WM1/+zqey5Stp1+3/1nn8=;
        b=g1VJQDo/CNj3ql6Qze7Uwfq6XksSvlS5DytKUrTdEFM5ElJD3CmnlATIs2TEjiWYAh
         aHvvZHRbN7DiZxcRsuF6A03JCyuJbgzXEUTzrdSqKKeJuAkYCrWYZ7uGHIgRIlNgUg1m
         rIlGjPNPBoql51UvUpwL5DJt7FgktpRw7AOiHG5n3Ld+rgRyGPnaNxKT89YKMrTgKius
         Nz/l6fjiosZ7JK1tq8OmccG4tpwu9UdMUw/1akFRa9LYJgIL1VcXfRdhogWM5EFxmH5Q
         Dwwj2r6683j1Dh39wltkyT1cJRmSCwk+p7OJzHXC/S+uBGZNzJNgT5ecS6qKISc8LUMW
         ZAfw==
X-Gm-Message-State: AOJu0Yy0BFyTTUuDh3BvOY430bjy6+f5FXKn6IiQfPOtRS1Gz7TMS1os
        gxq3gJiPQlvBZbKATDIBiIfkHcRj6wRT/1j68NpiPCozQrx6JYnnQYA0Nr8xvR/zU7zUsmSQRCO
        6kZo4GDy9rskHAqPb3JdCNSK5ACBnnQ==
X-Received: by 2002:a81:5213:0:b0:577:18a9:fde9 with SMTP id g19-20020a815213000000b0057718a9fde9mr203976ywb.43.1691608265902;
        Wed, 09 Aug 2023 12:11:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF4bakAFmnDHXZCtm+vYnH/44zCXQwIHL3mdbk7E48nsMmoY5a7btEW/R6hRCA2pgPLsg/bFg==
X-Received: by 2002:a81:5213:0:b0:577:18a9:fde9 with SMTP id g19-20020a815213000000b0057718a9fde9mr203963ywb.43.1691608265662;
        Wed, 09 Aug 2023 12:11:05 -0700 (PDT)
Received: from brian-x1.. (c-73-214-169-22.hsd1.pa.comcast.net. [73.214.169.22])
        by smtp.gmail.com with ESMTPSA id s84-20020a817757000000b005774338d039sm4172969ywc.96.2023.08.09.12.11.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 12:11:04 -0700 (PDT)
From:   Brian Masney <bmasney@redhat.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hugo@hugovil.com
Subject: [PATCH v2 0/2] scsi: ufs: convert probe to use dev_err_probe()
Date:   Wed,  9 Aug 2023 15:10:52 -0400
Message-ID: <20230809191054.2197963-1-bmasney@redhat.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following two log messages are shown on bootup due to an
-EPROBE_DEFER when booting on a Qualcomm sa8775p development board:

    ufshcd-qcom 1d84000.ufs: ufshcd_variant_hba_init: variant qcom init
        failed err -517
    ufshcd-qcom 1d84000.ufs: Initialization failed

This patch series converts the relevant two probe functions over to use
dev_err_probe() so that these messages are not shown on bootup.

Changes since v1
https://lore.kernel.org/lkml/20230808142650.1713432-1-bmasney@redhat.com/
- Dropped code cleanup

Brian Masney (2):
  scsi: ufs: core: convert to dev_err_probe() in hba_init
  scsi: ufs: host: convert to dev_err_probe() in pltfrm_init

 drivers/ufs/core/ufshcd.c        | 5 +++--
 drivers/ufs/host/ufshcd-pltfrm.c | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

-- 
2.41.0

