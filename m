Return-Path: <SRS0=9vL1=57=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABA01C2BB85
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 08:08:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A6692078A
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 08:08:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance-com.20150623.gappssmtp.com header.i=@bytedance-com.20150623.gappssmtp.com header.b="Mwr3Hvke"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2635623AbgDOIId (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Apr 2020 04:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2635622AbgDOII3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Apr 2020 04:08:29 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 346CCC061A0F
        for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2020 01:08:29 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id p8so1153189pgi.5
        for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2020 01:08:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=+bfCUElRvrAPmVBMOIFVDlt70V4vk+GeakY9Soaqik4=;
        b=Mwr3Hvke6qkKUwkMlQdwOAG6l4hEG8IUaQT8lKi9QtS/7ixwoIDtc2/o/EGhm8o1+G
         ffQsggJMg40osVmaehwNNr1jJH3WgruBdIOXIqOPMj/olcmiV3tqlntckVM8+IAIPjob
         tmhBqcecPBM8zZaPNGHlLhJcVbgVHRCiNzsRZs5Y0JB2tMJJlKjSidGoo5f7DHFREfX1
         8tFaLxTTXsNDhMZmCJtYbEiQyKEV7W1ShFtnVmPaKAVwtuEpso+uDwjFPgwRRfF1ldPH
         QjgAfZDiHUl38xmwIdTdQtdquGvI+KVG6GLxsMYMw6vBcvtjNco1Tyr1/XuPmA/Dknq8
         4IzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+bfCUElRvrAPmVBMOIFVDlt70V4vk+GeakY9Soaqik4=;
        b=Y6u2L1hOpCQFNDV/3J45ZQhVvMiPAUmm10rm6vJpfsUSRUyOINSz7g61fExRdpdcOf
         WVyDLHWAkv98e+owwjur/T+2sZm3I2GG4LGpaIwOC1ukAKwamw/oGaWYlXXZaTuG2pP8
         mBuKj3I/Zz2175gGRT3ruuqvuyaXKi7d/45csYSUEKG3irPxpyTqtDZjOBMhH6pjsOwV
         DQK6YUDngQ1oyJofa/rR0ovjecyFjwABd+yeZK1LTuX5Ix5/Bsi6xPY6LsKx/gP5brt4
         RSZgigewE9j3RVG8BoJVfD4wrc89QM0f8kdzLA0WTPN8KPbZfUDR5vI7cB957uvvOTZQ
         91NQ==
X-Gm-Message-State: AGi0Puaek3GkW9yGWTxzKbhhEWOtCS3U7QEWrrkduFbiy42fmXYzEBMv
        d0Sg22fddlJ1OrsZx5JNoGHLiA==
X-Google-Smtp-Source: APiQypLA+zObXCwcyxRLpX0xYKZ0QrTtTQgGwaLvCZmvVMaN7u2DLkzEEmaxprqIkFAH+QdfFH02Og==
X-Received: by 2002:a63:d10f:: with SMTP id k15mr24329834pgg.73.1586938108742;
        Wed, 15 Apr 2020 01:08:28 -0700 (PDT)
Received: from debian.bytedance.net ([61.120.150.75])
        by smtp.gmail.com with ESMTPSA id c10sm10020576pfc.23.2020.04.15.01.08.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Apr 2020 01:08:28 -0700 (PDT)
From:   Pu Hou <houpu@bytedance.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     mchristi@redhat.com, Pu Hou <houpu@bytedance.com>
Subject: [PATCH 0/2] iscsi-target: fix login error when receiving is too fast
Date:   Wed, 15 Apr 2020 04:08:17 -0400
Message-Id: <20200415080819.27327-1-houpu@bytedance.com>
X-Mailer: git-send-email 2.11.0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,
We encountered "iSCSI Login negotiation failed" several times.
After enable debug log in iscsi_target_nego.c of iSCSI target.
Error shows:
  "Got LOGIN_FLAGS_READ_ACTIVE=1, conn: xxxxxxxxxx >>>>"

Patch 1 is trying to fix this problem. Please see comment in patch 1
for details.

Pu Hou (2):
  iscsi-target: fix login error when receiving is too fast
  iscsi-target: Fix inconsistent debug message in
    __iscsi_target_sk_check_close

 drivers/target/iscsi/iscsi_target_nego.c | 31 ++++++++++++++++++++++++++-----
 include/target/iscsi/iscsi_target_core.h |  1 +
 2 files changed, 27 insertions(+), 5 deletions(-)

-- 
2.11.0

