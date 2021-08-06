Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D60CC4320E
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 07:43:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4939061050
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 07:43:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238601AbhHFHnS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 03:43:18 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:24064 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236860AbhHFHnN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 03:43:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628235777; x=1659771777;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cNgb2TROU2WsZ1zU8ihpVY71OcdgiBcGbW7LESxTUo0=;
  b=cCFUR+zNI50BCRwv8Fc1Ed5932PCzQegMa/5T0Ldg1OZlHXZ0e3StRDA
   8Wspy3tBkurlyFCueU8QayzSKpRThC0LX1018k0ea8AJMigT1VaB3/XAP
   0+iCrZQUYp9GygTAzJx/uhw8PMl4ZjwlXRp+9HPtEeXShNsH5T3+xvjIk
   A4htuM6WTpC4O5P56G3caTuOiYst9FdQ6TBqUKj4CJDyl/gx5BEjT8qW5
   Z4b5PM3R7AHHfNSJbrAWa7/dxP7VN1AfiT7VUMXcLe966ZXFkq6GbJ+ha
   FQzBBlnw1aY3hNPpbYBS5kUxdIt6dTg2styr1AUJ+mYMCmkOSSCerFW9b
   w==;
X-IronPort-AV: E=Sophos;i="5.84,300,1620662400"; 
   d="scan'208";a="181296847"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 06 Aug 2021 15:42:57 +0800
IronPort-SDR: lDVC/xls6cqjf7GOzaxjdZIeoG017ZDyNvZM2IlttAkZJ9tSQ07E3TZGPFdwfFcz4i403+4DDs
 VN5ZLMWW+GnI6rZOHNY65G43a81LOlTIuCYJa9OZr1m9nyfhdawGJzR1yuOQH21xZyp/kHUg6y
 GXmmTNQWSon9FqGCdq0x3AvE2evlwk56eCebPLkRL/En0z/7QM5KbvWLh5lduLvXex8cqCqLtm
 9OD8bewGe/0V7DRSYZM0zacpM8sZG1e2wHIVCuj77+YXLYlRpkCSgK36PNpGADEsPwzimYWswV
 woS1bNvAdGhP3wHasdsBzwWU
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 00:20:25 -0700
IronPort-SDR: z/Nhu9Qg97cElW4dG7C3BRIhv/bpEniPzQevntb6xReHLZ1SST8yEdbUtBbtVCHs3pxjO66jmJ
 yambJo4aPmCyK0QF7rlkWTvpgU/RkguNsjzBL6Bb9ZxmNZq3Mh8uD+UKThziZNCLZKPyA+nSz+
 HzPPUqKwcfQUepj92ymcN7Uu3/UDf3IyjtFccEsu+1ocu2Ijvdkt+EH5GZAE2hh4lAuFGk17vq
 /bK3wmcd/UtouN6TB/U91GTc4+aEHRrFyS5QDYTcvhAg8bEDnWKkFHvKONZvSWW56Nwv5aWS6z
 ML8=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 06 Aug 2021 00:42:56 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH v2 2/9] libata: fix ata_host_start()
Date:   Fri,  6 Aug 2021 16:42:45 +0900
Message-Id: <20210806074252.398482-3-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210806074252.398482-1-damien.lemoal@wdc.com>
References: <20210806074252.398482-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The loop on entry of ata_host_start() may not initialize host->ops to a
non NULL value. The test on the host_stop field of host->ops must then
be preceded by a check that host->ops is not NULL.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/ata/libata-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index ea8b91297f12..fe49197caf99 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5573,7 +5573,7 @@ int ata_host_start(struct ata_host *host)
 			have_stop = 1;
 	}
 
-	if (host->ops->host_stop)
+	if (host->ops && host->ops->host_stop)
 		have_stop = 1;
 
 	if (have_stop) {
-- 
2.31.1

