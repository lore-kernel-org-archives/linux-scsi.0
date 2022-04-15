Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EA65C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Apr 2022 20:18:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351651AbiDOUUk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Apr 2022 16:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351690AbiDOUUi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Apr 2022 16:20:38 -0400
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E67E2DE911
        for <linux-scsi@vger.kernel.org>; Fri, 15 Apr 2022 13:18:06 -0700 (PDT)
Received: by mail-pj1-f43.google.com with SMTP id bx5so8347630pjb.3
        for <linux-scsi@vger.kernel.org>; Fri, 15 Apr 2022 13:18:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pn/IYKkpeewf8nSwoMk19/ZmYTfn293dC4VAidTdxVg=;
        b=ChAug0VLwpCjN0amSsb9yzDqB2kBZqHQ8o2a3jXZyrfHQ8qosKihQu4yo9FpLAL61f
         U39Wf4TjyrdWBdNGkIEjHx7lr65Nq8Gboc2wUCyzNQbumb3xZ4qn1Ageli76LYDk7uWd
         HgOldUsgt1k2W+Rt5LIcRKo84GqiSr3M/s50NsG3ddMfNsH/8B9g7iyjg67kkOx9uG3C
         6O8ce4tkQk2WtNsQDEN6AKr09EuGKZp4niUa5QfIFjqCDLgepiWZ73Qd05YzuGQfwhrK
         OVe7PztpRCnLojpsPOfIarj5dPrWdhboXt7DMjkuohSdBXwMfXiv4mnpoxkz6OY8M1xA
         kvIg==
X-Gm-Message-State: AOAM531AfFo8WMjBSUClgtdXH+X1vVWLThRKCV60R9IJ6o0HYmpha/kQ
        PzPkb7XARxIdPyru4lx9Haw=
X-Google-Smtp-Source: ABdhPJypqbhJNguIX4fMkXlh/7FhYf1VWxGoZHTPH+zb4F4MULa+gNOwyFfg0PDL+JgN1zLOe8InmA==
X-Received: by 2002:a17:90a:b890:b0:1cb:7ef2:8577 with SMTP id o16-20020a17090ab89000b001cb7ef28577mr563553pjr.45.1650053886347;
        Fri, 15 Apr 2022 13:18:06 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a014:c21c:c3f8:d62])
        by smtp.gmail.com with ESMTPSA id q9-20020a056a00088900b004fe1a045e97sm3641141pfj.118.2022.04.15.13.18.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 13:18:05 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Shaun Tancheff <shaun.tancheff@seagate.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 3/8] scsi: sd_zbc: Verify that the zone size is a power of two
Date:   Fri, 15 Apr 2022 13:17:47 -0700
Message-Id: <20220415201752.2793700-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220415201752.2793700-1-bvanassche@acm.org>
References: <20220415201752.2793700-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following check in sd_zbc_cmnd_checks() can only work correctly if
the zone size is a power of two:

	if (sector & (sd_zbc_zone_sectors(sdkp) - 1))
		/* Unaligned request */
		return BLK_STS_IOERR;

Hence this patch that verifies that the zone size is a power of two.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd_zbc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index d0275855b16c..c1f295859b27 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -666,6 +666,13 @@ static int sd_zbc_check_capacity(struct scsi_disk *sdkp, unsigned char *buf,
 
 	*zblocks = zone_blocks;
 
+	if (!is_power_of_2(*zblocks)) {
+		sd_printk(KERN_ERR, sdkp,
+			  "Zone size %llu is not a power of two.\n",
+			  zone_blocks);
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
