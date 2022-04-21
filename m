Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5E4AC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Apr 2022 18:30:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391179AbiDUSd0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Apr 2022 14:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242768AbiDUSdZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Apr 2022 14:33:25 -0400
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C104BB84
        for <linux-scsi@vger.kernel.org>; Thu, 21 Apr 2022 11:30:35 -0700 (PDT)
Received: by mail-pf1-f169.google.com with SMTP id bo5so5770927pfb.4
        for <linux-scsi@vger.kernel.org>; Thu, 21 Apr 2022 11:30:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G+O4H6jJ/9oIGs0tHN+uWLR/+jMszIaJWcmK49M8aP4=;
        b=Gtdmf7F+Vnj0Vy7z012vk5d3MNMQg10JdqQH9UTaT3y7UiYk1ZkGwPlhediWhfbh7x
         yYlqGESZloI/N53KHdptXPD2kAsClWM0dmjzNrtEFKBevo3J0m3R83m63Kb7tB9d3CY9
         QVjjT2w9V90+SoJCIpRdQVkGqpS7qggA15OxkZA7WfZG0/rjqwFKlFtO09D0CM9w3HbN
         QXA5qPzKw1UHyEZS0ad9YOsozqu3uYJI1r4+mhPyMbItoa9HDHBMc6+92irvUfV7RVez
         B/X2ZWfTdNL6ua87zcz3H4eeXQ/kAKFKsIfl4saACGtN6GO9Dqjg6xs9zewfvz6M3o4R
         I5TQ==
X-Gm-Message-State: AOAM533z/kzucZANZzh0rga+6ic6MP9bwLQCfl1B+XtqD4CKRBKA5MGD
        yEGXIVNRYC50Fe28I7ZuX+s=
X-Google-Smtp-Source: ABdhPJz0LvlBpeiU2jAdsg+d6wP4p0Pbgn0pECgLMmtxiBAuRFXdlwUS8fx3fnxyJjAIvv5zIJ3+bQ==
X-Received: by 2002:a05:6a00:2442:b0:4fd:8b00:d2f with SMTP id d2-20020a056a00244200b004fd8b000d2fmr933381pfj.39.1650565834353;
        Thu, 21 Apr 2022 11:30:34 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a034:31d8:ca4e:1f35])
        by smtp.gmail.com with ESMTPSA id a22-20020a62d416000000b0050bd98eaccbsm2181079pfh.213.2022.04.21.11.30.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 11:30:33 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Shaun Tancheff <shaun.tancheff@seagate.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/9] Support zoned devices with gap zones
Date:   Thu, 21 Apr 2022 11:30:14 -0700
Message-Id: <20220421183023.3462291-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

In ZBC-2 support has been improved for zones with a size that is not a power
of two by allowing host-managed devices to report gap zones. This patch adds
support for zoned devices for which data zones and gap zones alternate if the
distance between zone start LBAs is a power of two.

Please consider this patch series for kernel v5.19.

Thanks,

Bart.

Changes compared to v1:
- Made this patch series compatible with the zone querying code in BTRFS.
- Addressed Damien's off-list review comments.
- Added patch "Return early in sd_zbc_check_zoned_characteristics()" to this
  series.

Bart Van Assche (9):
  scsi: sd_zbc: Improve source code documentation
  scsi: sd_zbc: Verify that the zone size is a power of two
  scsi: sd_zbc: Use logical blocks as unit when querying zones
  scsi: sd_zbc: Introduce struct zoned_disk_info
  scsi: sd_zbc: Return early in sd_zbc_check_zoned_characteristics()
  scsi: sd_zbc: Hide gap zones
  scsi_debug: Fix a typo
  scsi_debug: Rename zone type constants
  scsi_debug: Add gap zone support

 drivers/scsi/scsi_debug.c | 149 ++++++++++++++++++------
 drivers/scsi/sd.h         |  32 ++++--
 drivers/scsi/sd_zbc.c     | 236 +++++++++++++++++++++++++++++---------
 include/scsi/scsi_proto.h |   9 +-
 4 files changed, 331 insertions(+), 95 deletions(-)

