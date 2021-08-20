Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E654C432BE
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 07:05:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7664B61056
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 07:05:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238727AbhHTHFh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Aug 2021 03:05:37 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:20637 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238664AbhHTHFd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Aug 2021 03:05:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1629443095; x=1660979095;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=zrL1s5kuho6QHoYQ3XfWT692XbkgjvR+pif0sZOqHuM=;
  b=QygrumweuVmIyj0o7yHMX8q1DTRiOFJSLT3ltzGaiRxw32sLZzf7Q73p
   JdAO5mglfEgpxf5epkDkkL//jIVtxUwfQShf7wy/jHrtx4cSgH4hRwmX/
   uKhcnd0nY9IA2I8yrvEilnSUuSPiL3UCisbh000vxbh6gXBTM1PN7qEQ6
   JhgwoDXQRczee9ERQkTKBdyRoIRGFXp7rpG5thalDopfUUixHI28bXoYl
   C3JSMZM8LUMIlBrtmbsTWW5v0/W0W+wFlRvVGPntSt793pnpUyuVWZZPN
   Cjee6Fu0M+TsZVZjFW8t8NoNOL0svnLgZ8LVX6mlsLEpJ4qXvrjg3E9/l
   w==;
X-IronPort-AV: E=Sophos;i="5.84,336,1620662400"; 
   d="scan'208";a="182663597"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 20 Aug 2021 15:04:38 +0800
IronPort-SDR: uGbQSPanZJY9RaIJSXTWU0vYW4I0luzAI6A1i9dlRLMLWNLe+rS7ALQ5qPGLP4MBISIVj6hs7L
 XLW+bItVpmqXNaCaTVrD+YuQ8PGwcz/7oSAe8wxfu40C9C+A0NA2J8SyDHeEQBh2bgXfuz3NJH
 z1p/xmGx9k/VCQl/cZwyP3DgxtaZ70a2idMM8zrViD02+ygxlXZ91r7Ut9115hg/wgI6QQP/+p
 KhOY7GiwKqsJXThMx7MgZNFn81vIWPiKLniYKy7IFh4DvvmpCLl+51STbfKbp+Jz9ckcsvpHTt
 TvcMdt6ye6+zatRI24hJ0sED
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2021 23:39:58 -0700
IronPort-SDR: F5IPH4TP7v+DVwL7mh4fIsQCQOUWjpkpB8jrTx7ZVusOdvSQZuvjdYUs7q2w4+Qi1TYnt8VeVn
 QSXQP1W6VlcFhsdpaq6XLAIPMy9mIu6JOMjRMVr7xkJMtgY6Xl3cqwq9mtkrarKetg3x1pfwJG
 X2VBkbM1+CpaOSDBPxon+9Myoge2vOZ4u1GwDng8mPM3RMbIx9weM981IZYD8ExJX6YZR2xO70
 JTX8KbNBp1tcIyot5A3cEAGLf5z3BJWNZOrbXHVl7DYw/Lq6p9k4xfpUgmnzbGHLDFpu30kXxp
 yPw=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 20 Aug 2021 00:04:39 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v3 3/3] scsi: sd: fix sd_do_mode_sense() buffer length handling
Date:   Fri, 20 Aug 2021 16:02:55 +0900
Message-Id: <20210820070255.682775-4-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210820070255.682775-1-damien.lemoal@wdc.com>
References: <20210820070255.682775-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For devices that explicitly asked for MODE SENSE 10 use, make sure that
scsi_mode_sense() is called with a buffer of at least 8B so that mode
sense header fits.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 920df3a04a7b..34faff96e165 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2603,6 +2603,13 @@ sd_do_mode_sense(struct scsi_disk *sdkp, int dbd, int modepage,
 		 unsigned char *buffer, int len, struct scsi_mode_data *data,
 		 struct scsi_sense_hdr *sshdr)
 {
+	/*
+	 * If we must use MODE SENSE 10, make sure that the buffer length
+	 * is at least 8B so that the mode sense header fits.
+	 */
+	if (sdkp->device->use_10_for_ms && len < 8)
+		len = 8;
+
 	return scsi_mode_sense(sdkp->device, dbd, modepage, buffer, len,
 			       SD_TIMEOUT, sdkp->max_retries, data,
 			       sshdr);
-- 
2.31.1

