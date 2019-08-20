Return-Path: <SRS0=HqgQ=WQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F2A3C3A589
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Aug 2019 09:05:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5D0E22DBF
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Aug 2019 09:05:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="EP9KgOdD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729341AbfHTJFA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Aug 2019 05:05:00 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:16080 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728698AbfHTJFA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Aug 2019 05:05:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1566291904; x=1597827904;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MnC9I/+eq+q2Ei5v2mBRNNadmxEq1GlCxXcT3BpX/mk=;
  b=EP9KgOdDLnzAW16bHgJGfp0zIIsqAKy9iZiql7Bm29bWzigvFl0FLh+a
   Y8x5LPuLd+VG7loJItYklhNGia1kC7Lgc759o+aN1WGGe+mDKv3eBpnkI
   pwThyzQjdzNw/0x2fbQgrL/mAx+BQGvpVRhrF8OX04fLXbvqP3JW0rz3B
   2iXTnf1XPjwqtkzS6CoIc1HRkibDtgIlPEaksO+9j+jFh9h3BpdgdLQua
   y8whPkJ3wMGBlVxR6bxsPx1sIKOEW4ziyOVo6mMY7hob+w7aGv6CoWd/j
   NyJCtnU+zS60qtBpRWB6OElIHsgQEKJSuYAqMkz0KYBsN955xN6N1e3Qv
   Q==;
IronPort-SDR: ByVHicBDJWbirCzrZ7Ef0+lruTDPMrYseR8FA+3LSrBQ7j0LBYR3BnM5xgTLeF1U4BSPARAVF7
 QjfIguPG9XhzEHoEFcK0u4nl+wQA+T1kZpWsx3SOOjBJJ36I54LJmaYU3iJTUMBpYT77mACsc5
 RTvYJo3et6In3d2nxFKyx+xgiFXbH69SkHNi8XRYHp49vy5kiBGvgitMzomNaEmM0oEkPLt+bL
 0A/5DTKpsX11SQTx+XCozt38pv0rqnJsvThRCFYhM9x8vDK3zHd21kT/40YKY4+++x/NLtkEYm
 kvM=
X-IronPort-AV: E=Sophos;i="5.64,408,1559491200"; 
   d="scan'208";a="216621449"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 20 Aug 2019 17:05:03 +0800
IronPort-SDR: 7GAmPa1U8WzWjP77iMJfEQ3vogNrg8p6Xg6V6Tc19jM43InSVJShbM4+WbOaUXaGo0mRMkxNr+
 dbiW9mUqTT0FL/IoeMexztIjdm6t4ue1wENUIGesiB6JHHFLGnuUW4TmDgeb01QjqSXo4kLMaZ
 SojxFgREid36g9wOsZfNsPZxQ9PC660h0JvQPrqTWHxbWIR1J++XPVO1ekAkgwRvK5UwayfQL6
 wxOYAXBxAWeEqVMc80j8ntrxAFVxbjU+Y3lPOO20bbdyIPwsUL3AphoaPfOHZW39cy2DiKUaWR
 WgSRh9ulpg5ReDa3Kc6HRRFQ
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2019 02:02:22 -0700
IronPort-SDR: sRH6lXI2d7s0zVPGznpsL3FE6x+nFHv05UYQvz2F7SfTGmMt5uQP1gEefGy0sW2jonkZTQGB+/
 M+y9MN5lDrM2+oU4y/hxI0auzrNMkNRzrXrnKsAX4r6bvKFozK2Os/NXKcKGZkrXwK6gtEIsh6
 Z0O81WzIk0seDSDRbL6doWvRgcZdDsLjMcS6MzfUFf7a2VQtdlSw4ngR0NwZrDuVyUw/9J8R4N
 7QOXkqCbSOYuW7FUtgWs+LtHUQM+MzYJdYrRZRAdnAv3YD2eswmTmJw95IqH/LJu0W/86am3Oz
 glw=
Received: from naota.dhcp.fujisawa.hgst.com (HELO naota.fujisawa.hgst.com) ([10.149.53.115])
  by uls-op-cesaip01.wdc.com with ESMTP; 20 Aug 2019 02:04:59 -0700
From:   Naohiro Aota <naohiro.aota@wdc.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <mchristi@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Naohiro Aota <naohiro.aota@wdc.com>
Subject: [PATCH v2 2/2] scsi: target/tcm_loop: update upper limit of LUN
Date:   Tue, 20 Aug 2019 18:04:29 +0900
Message-Id: <20190820090429.1961085-2-naohiro.aota@wdc.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190820090429.1961085-1-naohiro.aota@wdc.com>
References: <20190820090429.1961085-1-naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

targetcli-fb (or its library: rtslib-fb) allows us to create LUN up to
65535. On the other hand, the kernel driver is limiting max_lun to 0.

This limitation causes actual problem when you delete a loopback device
(using /sys/class/scsi_device/${lun}/device/delete) and rescan it (using
/sys/class/scsi_host/host${h}/scan). You can delete the device, but
cannot rescan it because its LUN is larger than max_lun and so the scan
request results in -EINVAL error in scsi_scan_host_selected().

This commit fix the upper limit to a max possible value: U64_MAX.

Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
---
 drivers/target/loopback/tcm_loop.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 0942f3bd7eec..50e93b487375 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -336,10 +336,10 @@ static int tcm_loop_driver_probe(struct device *dev)
 	 */
 	*((struct tcm_loop_hba **)sh->hostdata) = tl_hba;
 	/*
-	 * Setup single ID, Channel and LUN for now..
+	 * Setup single ID, and Channel for now..
 	 */
 	sh->max_id = 2;
-	sh->max_lun = 0;
+	sh->max_lun = U64_MAX;
 	sh->max_channel = 0;
 	sh->max_cmd_len = SCSI_MAX_VARLEN_CDB_SIZE;
 
-- 
2.23.0

