Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95232C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Apr 2022 20:18:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351606AbiDOUUd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Apr 2022 16:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244545AbiDOUUb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Apr 2022 16:20:31 -0400
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D44DE0BE
        for <linux-scsi@vger.kernel.org>; Fri, 15 Apr 2022 13:18:01 -0700 (PDT)
Received: by mail-pg1-f182.google.com with SMTP id q19so8432054pgm.6
        for <linux-scsi@vger.kernel.org>; Fri, 15 Apr 2022 13:18:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NVETNu0tXbhWTo24Q4mydqzYBbQNI2EFycBcH67wHBY=;
        b=lb8j2bmJ5LWf8MnMh+RpUcDL7MLNAmGKBapPb+05P0s8q/osY5myw9IXuDSM6+uERH
         c+Im6JST2InxOCcgfE7Jpw/dAjkBo1BTZHtFx0+NuXnwp2A1WUzWKwjbHrG3hHLKh6z/
         Gm+ZJiYxSnW3adVUnDoWBO40WOdjXU1j29IT0ivS8H3lNVbWHw094vSvCt/CrlGluGyx
         6u4MZLg33or0U09AkCrWEkdHs9KG+2MHRoJDRx0Zq4zGtHjH5/1feVkg5TPnop3FvM4g
         ElkQK6Vit/QpbDLpgnp8a/1facuivudes0ZRIf/ZlmyEW27l3fUDMPUcUawKVVWhzw4l
         xIvg==
X-Gm-Message-State: AOAM53182DbK0/vN9cWj61BiLnEf/HMksqv1YPl3zdjNQmnvfZNPD7aY
        5IHTUNv4ACXOJ+hskP6lSSQ=
X-Google-Smtp-Source: ABdhPJyGDk/Mx12E02UYW3/E60oX83isekIFPNalxP2IlV3tkXE3Zzalffsw1m2PhX5NPO2nfocDYg==
X-Received: by 2002:a63:5f05:0:b0:39d:b7da:1c58 with SMTP id t5-20020a635f05000000b0039db7da1c58mr558157pgb.22.1650053880921;
        Fri, 15 Apr 2022 13:18:00 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a014:c21c:c3f8:d62])
        by smtp.gmail.com with ESMTPSA id q9-20020a056a00088900b004fe1a045e97sm3641141pfj.118.2022.04.15.13.17.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 13:18:00 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Shaun Tancheff <shaun.tancheff@seagate.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/8] Support zoned devices with gap zones
Date:   Fri, 15 Apr 2022 13:17:44 -0700
Message-Id: <20220415201752.2793700-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
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

Bart Van Assche (8):
  scsi: sd_zbc: Improve source code documentation
  scsi: sd_zbc: Rename a local variable
  scsi: sd_zbc: Verify that the zone size is a power of two
  scsi: sd_zbc: Introduce struct zoned_disk_info
  scsi: sd_zbc: Hide gap zones
  scsi_debug: Fix a typo
  scsi_debug: Rename zone type constants
  scsi_debug: Add gap zone support

 drivers/scsi/scsi_debug.c | 147 +++++++++++++++++++++-------
 drivers/scsi/sd.h         |  28 ++++--
 drivers/scsi/sd_zbc.c     | 199 ++++++++++++++++++++++++++++++--------
 include/scsi/scsi_proto.h |   8 +-
 4 files changed, 301 insertions(+), 81 deletions(-)

