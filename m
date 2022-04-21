Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50DEAC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Apr 2022 18:30:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391374AbiDUSdi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Apr 2022 14:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242768AbiDUSd3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Apr 2022 14:33:29 -0400
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C14CC4BB82
        for <linux-scsi@vger.kernel.org>; Thu, 21 Apr 2022 11:30:38 -0700 (PDT)
Received: by mail-pj1-f41.google.com with SMTP id iq10so1949418pjb.0
        for <linux-scsi@vger.kernel.org>; Thu, 21 Apr 2022 11:30:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GOwCxOmcpg8qevQ4HBSE2TMzu2pCuWaDfQK1i23f80Y=;
        b=gsCx5wlR4PFH0ePcE3a2mMBFFQzzyUWPUjd4juYxEVXtGliNzdihxwOkU6x6bRzNNL
         9CmQw6LKGo016qCKe6aaS42/16cKtAthYNpjI+JDl6yqniBzMiB7JTrqPRaAYdBDuDL9
         CL2p1u6dgkJXQYBTHjmdlU//8lGV+S0W23RRW9Q2x5EHVP4aZTd3bpHZFtT67YHQy8/R
         G8lE7DY3K7j8nnB5xb8Y5cV6kpSrrnk8jlBm7+Ngg3sY7uIlV2cLrljayIcGUwC+EirF
         8hE4VBtGYCSpwqbnt1gjQKQdicAEjCuLMA87oAbt36SbbKKBvYL/enMrOj+9iiFzf7ZQ
         zibg==
X-Gm-Message-State: AOAM531LqF9jma8DIsDqf4+bHFT+ol6V9bf4+XRx+HFu8wlRA86uo6EP
        VIFyjRt+Dc9F1o6RHNSzwuM=
X-Google-Smtp-Source: ABdhPJzqNZi3FYSHARX8xoNQcMLnycPjGgw8WzifO+KoLGNun5vait0saKoEoR+Itp5yzGcQBr5A0g==
X-Received: by 2002:a17:90a:70cf:b0:1cb:a31e:a2c1 with SMTP id a15-20020a17090a70cf00b001cba31ea2c1mr11935978pjm.94.1650565838065;
        Thu, 21 Apr 2022 11:30:38 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a034:31d8:ca4e:1f35])
        by smtp.gmail.com with ESMTPSA id a22-20020a62d416000000b0050bd98eaccbsm2181079pfh.213.2022.04.21.11.30.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 11:30:37 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Shaun Tancheff <shaun.tancheff@seagate.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 2/9] scsi: sd_zbc: Verify that the zone size is a power of two
Date:   Thu, 21 Apr 2022 11:30:16 -0700
Message-Id: <20220421183023.3462291-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
In-Reply-To: <20220421183023.3462291-1-bvanassche@acm.org>
References: <20220421183023.3462291-1-bvanassche@acm.org>
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

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd_zbc.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 2ae44bc52a5f..9ef5ad345185 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -664,6 +664,13 @@ static int sd_zbc_check_capacity(struct scsi_disk *sdkp, unsigned char *buf,
 		return -EFBIG;
 	}
 
+	if (!is_power_of_2(zone_blocks)) {
+		sd_printk(KERN_ERR, sdkp,
+			  "Zone size %llu is not a power of two.\n",
+			  zone_blocks);
+		return -EINVAL;
+	}
+
 	*zblocks = zone_blocks;
 
 	return 0;
