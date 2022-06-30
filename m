Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEF24C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jun 2022 21:37:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233794AbiF3Vho (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jun 2022 17:37:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbiF3Vhm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jun 2022 17:37:42 -0400
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A3DE52389
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jun 2022 14:37:42 -0700 (PDT)
Received: by mail-pl1-f177.google.com with SMTP id b2so532782plx.7
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jun 2022 14:37:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qlCJPipl4Qw+tkOgFUnuzrBHCkIsfmcMMLjK7Dc2Zq4=;
        b=kKD7tO7Aqcf2iDnxbJg3y1NfOa/NSm1H99M67DKJCRJhe2fp1HVCttwVf3rT5UmAqp
         8BT2gGYaIY8owmxPgVWFj51q+BKOFkSZGD/DWyYLTnmzC9TPC7UBSE9TFm2Z9KGRmZaP
         u2IcfXhYwno5pifPSnugY89o12OrqPxeBImcg6UYcqOZtoW08AHet+jIN0uDYgipJFWq
         cdowYl0LOLt25j9xUQwPTJ66aSh1WQWKlFQvMc+SXmxx4DnPwQ65bJ0TVYM8Ral4vq0l
         w2JgBNkZNesQzm1lhgJ///LugPsOgTy1no9hUjFuSiMwWIz7wEEVKZWQxZppRIUCrRbi
         zimA==
X-Gm-Message-State: AJIora8tDCf0BiWlmNhP1xR3HVlD958cWvqbKt1JjpEC5SxUYcxZ/2W6
        pL5k2A/l4GIuE/ENfeZErpE=
X-Google-Smtp-Source: AGRyM1tkGExVhME6ZmG5ukQQzKZdwWTzvYbuDtbq8vt3COkrpKG0O734WNt5UChOxmlc6Y6RcQ55YQ==
X-Received: by 2002:a17:90b:4f91:b0:1cd:3a73:3a5d with SMTP id qe17-20020a17090b4f9100b001cd3a733a5dmr12331264pjb.98.1656625061727;
        Thu, 30 Jun 2022 14:37:41 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id mt18-20020a17090b231200b001e0899052f1sm2484701pjb.3.2022.06.30.14.37.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 14:37:41 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/3] Call blk_mq_free_tag_set() earlier
Date:   Thu, 30 Jun 2022 14:37:30 -0700
Message-Id: <20220630213733.17689-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This patch series fixes a recently reported use-after-free in the SRP driver.
Please consider this patch series for kernel v5.20.

Changes compared to v1:
- Expanded this series from one to three patches.
- Fixed the description of patch 3/3.

Bart Van Assche (3):
  scsi: Simplify scsi_forget_host()
  scsi: Make scsi_forget_host() wait for request queue removal
  scsi: core: Call blk_mq_free_tag_set() earlier

 drivers/scsi/hosts.c     | 10 +++++-----
 drivers/scsi/scsi_lib.c  |  3 +++
 drivers/scsi/scsi_scan.c | 34 +++++++++++++++++++++++++++++-----
 3 files changed, 37 insertions(+), 10 deletions(-)

