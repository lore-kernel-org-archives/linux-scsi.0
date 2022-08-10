Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD9F3C00140
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Aug 2022 18:28:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbiHJS2R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Aug 2022 14:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230430AbiHJS2L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Aug 2022 14:28:11 -0400
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9264086C16
        for <linux-scsi@vger.kernel.org>; Wed, 10 Aug 2022 11:28:09 -0700 (PDT)
Received: by mail-pg1-f173.google.com with SMTP id 12so15074281pga.1
        for <linux-scsi@vger.kernel.org>; Wed, 10 Aug 2022 11:28:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=l//4b3stp0WdmU9qPa2Gbkr8thaoo+qqRe/qNuhI6ZI=;
        b=qPlick+veY2ucNJDoJRBtNVC69Q5itpVmKz9OARO86vyF6wRbT+WAzOXhqEghX0IAZ
         WESacZ6Pg/w2WTeKW/cPZt9P3tz2bbcU2KzaJxdKWD57wjjaraJIH/tLGQMtJPZ7XcRq
         b2WXToiHkiiXWKi47AM0VNms4j6frPo3oCtF4vtJ15miWu3TtbMR2aO7ApkKBR8/gZ2c
         7cEG3704nEOcXuB5ucxyhRPvkc8Zrva88Jo0SIO4bKpREwpipXU02LFWAzvyCgcBmw5R
         Y7hYqPjInl1xZvG+svrALcJQnikhYq01CJ87dXi23CArCxac72/Snj/GEG8yAcA7ZuT3
         M3eg==
X-Gm-Message-State: ACgBeo2tSbY99GmmVPhOQ4d6jzPK4/FpvwNlSctWlovg3DlF1v+XPMo9
        gPFEoRZMPrdSMTC3OWh4Jow=
X-Google-Smtp-Source: AA6agR5XU+QydzhvIZYaISxNTrGOclLL/BWLNnwi6U6BnpeU411gVEAcQBRI5s88TURtbQRT2v9B0g==
X-Received: by 2002:a05:6a00:2403:b0:52b:cd68:27f0 with SMTP id z3-20020a056a00240300b0052bcd6827f0mr28775019pfh.11.1660156088960;
        Wed, 10 Aug 2022 11:28:08 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:85c9:163f:8564:e41f])
        by smtp.gmail.com with ESMTPSA id p3-20020a170902780300b0016d10267927sm13080315pll.203.2022.08.10.11.28.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 11:28:08 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Doug Gilbert <dgilbert@interlog.com>
Cc:     Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>
Subject: [sg3_utils 3/3] Refer to sg_map instead of /proc/scsi/scsi
Date:   Wed, 10 Aug 2022 11:27:39 -0700
Message-Id: <20220810182739.756352-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
In-Reply-To: <20220810182739.756352-1-bvanassche@acm.org>
References: <20220810182739.756352-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for the removal of /proc/scsi from the Linux kernel by removing the
references to /proc/scsi.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 doc/sg_dd.8  | 3 +--
 doc/sg_map.8 | 2 +-
 doc/sgp_dd.8 | 2 +-
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/doc/sg_dd.8 b/doc/sg_dd.8
index 3268de32e738..fa182022fd49 100644
--- a/doc/sg_dd.8
+++ b/doc/sg_dd.8
@@ -484,8 +484,7 @@ A raw device must be bound to a block device prior to using sg_dd.
 See
 .B raw(8)
 for more information about binding raw devices. To be safe, the sg device
-mapping to SCSI block devices should be checked with 'cat /proc/scsi/scsi',
-or sg_map before use.
+mapping to SCSI block devices should be checked with sg_map before use.
 .PP
 Disk partition information can often be found with
 .B fdisk(8)
diff --git a/doc/sg_map.8 b/doc/sg_map.8
index 5cbb4c2a82f0..abe0935d3ae4 100644
--- a/doc/sg_map.8
+++ b/doc/sg_map.8
@@ -73,7 +73,7 @@ called devfsd whose default configuration adds back the
 Linux device names in their traditional positions.
 .PP
 Quite often the mapping information can be derived by
-observing the output of the command: "cat /proc/scsi/scsi".
+observing the output of the command: "sg_map".
 However if devices have been added since boot this can
 be deceptive.
 .PP
diff --git a/doc/sgp_dd.8 b/doc/sgp_dd.8
index 99afcf30f085..6e40295e4443 100644
--- a/doc/sgp_dd.8
+++ b/doc/sgp_dd.8
@@ -246,7 +246,7 @@ A raw device must be bound to a block device prior to using sgp_dd.
 See
 .B raw(8)
 for more information about binding raw devices. To be safe, the sg device
-mapping to SCSI block devices should be checked with 'cat /proc/scsi/scsi'
+mapping to SCSI block devices should be checked with 'sg_map'
 before use.
 .PP
 Raw device partition information can often be found with
