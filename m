Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 344D3C00140
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Aug 2022 18:28:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbiHJS2G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Aug 2022 14:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiHJS2F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Aug 2022 14:28:05 -0400
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEEEA85FB8
        for <linux-scsi@vger.kernel.org>; Wed, 10 Aug 2022 11:28:04 -0700 (PDT)
Received: by mail-pj1-f43.google.com with SMTP id a8so15563010pjg.5
        for <linux-scsi@vger.kernel.org>; Wed, 10 Aug 2022 11:28:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=JwhABp/4Llr/mdGclRAh+V8MPlFZEKQS69B2JKR5Z9k=;
        b=xz0OOGuDDRlJvzATxV3aBffG2AUUWa9a0xBELWu9RbelU+zZpHQKHvxcSUli2aNCrs
         Zov4ZgLZXvlLZ9RVRTcNzChGu3JfGu6vK2tFjmqQhfwoWtBinjmIUAo8Xqoy8udeXrma
         C74LFGaw8vGBSx1ke/h51epq/QkjOzkKtcER/DvHypYM68PTvSxX2eesZ620FXma47qC
         qcIXJONxMCw0j/UzXi1oMTdw2Ei6XQ2IXWzf0HEqi9qnIC1bbAtDVlK0Onhkyx0gRv3e
         l7zn/bTUCT86VM/lZvgcktf9IUJDmcmneNsIKWtO8H3n1BIs1hbMs4T+AXTxKSYSrg2H
         KJhQ==
X-Gm-Message-State: ACgBeo2b2vxZeks7XrQhPjuw7YanywIslJObAPGuPXZxmhU5C3UrLKG9
        bZgNw5JcpwBVC4adxotMToE=
X-Google-Smtp-Source: AA6agR5yShEp51f9/ilUSapVL7Rx+zLXfK0YhlpAcuin9V+E6XssbP5RwitZbEqr8LvuA4R/XimdxQ==
X-Received: by 2002:a17:902:ecc2:b0:16f:3846:b279 with SMTP id a2-20020a170902ecc200b0016f3846b279mr28614183plh.127.1660156084293;
        Wed, 10 Aug 2022 11:28:04 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:85c9:163f:8564:e41f])
        by smtp.gmail.com with ESMTPSA id p3-20020a170902780300b0016d10267927sm13080315pll.203.2022.08.10.11.28.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 11:28:03 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Doug Gilbert <dgilbert@interlog.com>
Cc:     Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>
Subject: [sg3_utils 0/3] Prepare for removing /proc/scsi from the Linux kernel
Date:   Wed, 10 Aug 2022 11:27:36 -0700
Message-Id: <20220810182739.756352-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Doug,

The sg3_utils package is the only /proc/scsi user I know of. Although support
for systems without /proc/scsi was added to rescan_scsi_bus.sh more than ten
years ago, a few references to /proc/scsi remain. Convert these references into
the recommended interfaces.

Please consider these patches for inclusion in the sg3_utils package.

Thanks,

Bart.

Bart Van Assche (3):
  Change /proc/scsi/sg/allow_dio into
    /sys/module/sg/parameters/allow_dio
  Replace the references to /proc/scsi/sg/debug
  Refer to sg_map instead of /proc/scsi/scsi

 ChangeLog             |  2 +-
 doc/sg_dd.8           |  9 ++++-----
 doc/sg_map.8          |  2 +-
 doc/sg_read.8         |  4 ++--
 doc/sgp_dd.8          |  6 +++---
 examples/sgq_dd.c     |  6 +++---
 src/sg_dd.c           |  6 +++---
 src/sg_read.c         |  6 +++---
 src/sgm_dd.c          |  6 +++---
 src/sgp_dd.c          |  6 +++---
 testing/sg_mrq_dd.cpp | 18 +++++++++---------
 testing/sg_tst_bidi.c |  2 +-
 testing/sgh_dd.cpp    | 18 +++++++++---------
 testing/uapi_sg.h     |  4 ++--
 14 files changed, 47 insertions(+), 48 deletions(-)

