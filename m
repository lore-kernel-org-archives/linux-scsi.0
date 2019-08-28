Return-Path: <SRS0=d3SH=WY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02FE7C3A5A1
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Aug 2019 05:35:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8A672173E
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Aug 2019 05:35:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="nxOru4V4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbfH1FfO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Aug 2019 01:35:14 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:11474 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbfH1FfN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Aug 2019 01:35:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1566970514; x=1598506514;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=NnI74Meq0Fb0jyqNzArGqONqEpDb4K3q2DHTXlkbLFY=;
  b=nxOru4V41pGg1jtux/s5mDD524GAWUopujXTYZMMjOAd3bhIM1ZlU4lN
   +ZjjQzGcq7BxsaHHj1xhhdUVnBuI2opK239LpDCHvz+7PvIATWG/WykgM
   o5/RihkC+Bzc9srp/Max/A7nAKgSQB3QBajASLhc+JDk9EgJobjGLO1lu
   5gv41Y/mgSi/n4dwkyVj//1aCieI5P7kCl24ggXa7ablteC6FZu2uY79j
   K+jO6HUs4/ugzTdAyqLgFU+fLIFcjazLSFAa670H3gorpM0qD4irnjBv/
   sJ6TjQOisJs1w2rYfGUdFby57lA4NlmzNWz3rENz7W5olxG7y4ifZSaSQ
   A==;
IronPort-SDR: tuL/ZYKgYX4uR/F5njWHCJMFzbgY9YgaHxbaD6AB4SIaUolxOE/e78ERK442TW1jzaBl+o+vMx
 5WIzIP/Lw4R4wi0WyEJSSGyUzxpbT3bfmoBcDaapH0IlG1OrrJ1yZh3UO0frNyfTUC84G+wwcv
 7EDWd0Y/4OG6n+ugiqCuIYyHcaDblfWPVI0TCXqkkh+8miPG93fW+PTOosPD/1heCLIQuD8eLu
 tFQcl0lmr78O4U8QARzgqiCUOuE8vOZaukGFmy7wyOtLnEVnIa8QPPfdTh0RhGKJFtLXs9Br3U
 ZtA=
X-IronPort-AV: E=Sophos;i="5.64,440,1559491200"; 
   d="scan'208";a="117743410"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Aug 2019 13:35:14 +0800
IronPort-SDR: iGQl0xxGjzTfm7Wo2FhMvawkYi1F68/7+zh20VKNFGDM+yXd3LVviKMPJjAWGCD0QnAmwrnLst
 las9rJfIojfRJgX6NdqZNLGbLqj5881f6CDmr0B8IZvRYP1vwWQzlXdHbURQmD19h6zHF0P5Yu
 WbH5uCEvdN3uJd4DjdRHRYuhhrdIP8QKqlS9iFlxryJvjCn0bZuOjuxZ1jHpj/dgFeETgBEt0I
 Iy63DWROz2hwoKKszoewHd2d+0YV3oQF07zgPMsZD1CoByrFD2BHx4p2GPsGqJDoEAGUermzN8
 QkbRUmMFHqy2PYZrdQnfqzPX
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 22:32:23 -0700
IronPort-SDR: kecAJQnDrDZYW74+y80S5GeMTVIs/1Rt6Qllm5RF8a3vB1mNaiilGZupsra7VcUg2I/B9sFGd0
 o3RwTZUjqHrC6VriSglAJ77TwgAL8aF4WW7oxPGfJ7Jq+IoRxUkYtiPC6Ru4gGwVznvsdPaH6N
 QlnMmtADoshNeV4RBXl9dlePIO/2yVI7CyERQkjn7Y2OUoAqr9irhHCj1wetHp8Tx6wL/0Xo93
 IEWjx+WdkGnQJ/xgrRz6H8KnwRti8BRLas9MGE0rgtqBqdRT3YORJ2JqdsJ39+BKAjKOyoEx/8
 g/A=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Aug 2019 22:35:12 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi: sd: Improve unaligned completion resid message
Date:   Wed, 28 Aug 2019 14:35:11 +0900
Message-Id: <20190828053511.14818-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For commands completing with a resid not aligned on the device logical
sector size, also print the command CDB in addition to the current
message to help debug hardware generating such incorrect command
completion information.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 149d406aacc9..91af598f2f53 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1978,6 +1978,7 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 			sd_printk(KERN_INFO, sdkp,
 				"Unaligned partial completion (resid=%u, sector_sz=%u)\n",
 				resid, sector_size);
+			scsi_print_command(SCpnt);
 			resid = min(scsi_bufflen(SCpnt),
 				    round_up(resid, sector_size));
 			scsi_set_resid(SCpnt, resid);
-- 
2.21.0

