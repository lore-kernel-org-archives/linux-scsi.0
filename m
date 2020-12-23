Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03256C43381
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Dec 2020 21:39:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C01F2224BE
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Dec 2020 21:39:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725895AbgLWVjT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Dec 2020 16:39:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbgLWVjT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Dec 2020 16:39:19 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB9A7C061794;
        Wed, 23 Dec 2020 13:38:38 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id g20so1055370ejb.1;
        Wed, 23 Dec 2020 13:38:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=8VdsyZ8WvqoPBszTJ/HR859gq7oHB0bgWRAKdYZ//jM=;
        b=cCyknsDLYzH6ROOxv4AzgykGAnsJYOtpUsnIkuQLbsspXrkorztxIIDQKHRPGEBQE9
         Z9RDnI0LsYBiXH8gQqLWeQLsAYOwKiWBZcLDhNoKcpD1fdiuvJxi84nhB6ekwiU6leCo
         beMQEpklXqOHP+33VzSVeVgNHd7zeQP+z/mQT1zczv6+yxUlEl199A4PEvjszxD1vJPk
         i0vjAk49knQ/apqhUsvGdWa86CmrAwULMzm7pEZA9o/465X1pB5C4HjGiTq6VLRhRiNm
         Ff8f1pXylGCG4TLkkwtC9uK6Vr0v1H1QYLDWywVjbLaBWONRvfTV/ajnWuJIlzkIdRMq
         joSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8VdsyZ8WvqoPBszTJ/HR859gq7oHB0bgWRAKdYZ//jM=;
        b=mVgDTIJG8IsO6NvJF4IWSYt+BJXM7ihRRUJZUk57m8ar4OGTSOcVBKSTrJ+4uwpf7e
         53sNGdEJHSLJgeB/PrGXRpHwH/UTMIoK8HJD63VGOJF57wh/GD7F70OVAhOPlKoQOCJE
         Mglj0X/5lnb8sU5kyoPyP2oyyBI5DrSVmLudPZial1r9ySxwvAsRKGtQHygH/tVwFiKU
         t1wo5u4THULOm0+LsubDhakG1MFmleI/T5KC1Jh82LVQi5l+U50lfahoiyqLc+q8nlwi
         1+oUUKLeLRk06SKgIsvcF3J6h2BRqVawbrWpdiXUE58zHiETchYs/Fy9k1yuJGHFswUb
         6Ttg==
X-Gm-Message-State: AOAM533COrt2+yD77568Mx6kIrki8jqseW6QM9pyWEejZU43dqB3KTXY
        E6xHdQEEITDmQ4wE8fRwoDP+32m7h6LQDg==
X-Google-Smtp-Source: ABdhPJybsgvByfUNN0RVcS8scgqPpTu6nnMlJdtU/MOOrKZXJphy4O6x7xRtUS+pEVcdIgneZ5H3ow==
X-Received: by 2002:a17:906:3999:: with SMTP id h25mr26096077eje.146.1608759517429;
        Wed, 23 Dec 2020 13:38:37 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.gmail.com with ESMTPSA id p12sm11896994ejc.116.2020.12.23.13.38.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Dec 2020 13:38:36 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        rjw@rjwysocki.net
Subject: [PATCH v1 0/2] two changes of UFS sysfs
Date:   Wed, 23 Dec 2020 22:38:24 +0100
Message-Id: <20201223213826.20252-1-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>


Bean Huo (2):
  scsi: ufs: Replace sprintf and snprintf with sysfs_emit
  scsi: ufs: Add handling of the return value of pm_runtime_get_sync()

 drivers/scsi/ufs/ufs-sysfs.c | 68 +++++++++++++++++++++++++-----------
 1 file changed, 47 insertions(+), 21 deletions(-)

-- 
2.17.1

