Return-Path: <SRS0=aJuI=CT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B71BC433E2
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 07:40:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09917207EA
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 07:40:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="diwK5Lc2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729942AbgIJHkC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Sep 2020 03:40:02 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:55883 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728297AbgIJHj5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Sep 2020 03:39:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1599723616; x=1631259616;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=/Enw0bxROuh57kxKsP52N1Tlxw3lASJQr7vvPQRxKmk=;
  b=diwK5Lc2Xet+Py5Juq2tJasMJD2kxcskOGAgfgqbH7X+3/WyJ6JNBx7+
   WGxiIyn7e99GXKJAAX2k9kE27sHsK/rJFiCxyTwOv5BF14WaDz1ytRq2O
   DVTaUjLHFdVp86hBgfXVbAJEZo00DZnfMWu1hiJ5CUBMCODcSrxy35ZKn
   fgujFZNh9AcMPORmAuSiw74O5VJKMFBkQA/MHyG/s7baqGVNIvq70PS6l
   XYQuX29DaME9/eQkkdVxrelKyJHeWibNdicvq+F/LD8oaugd2b2Q43qNQ
   xH72yjRIByixloNb/MSdYXLtDK3nY2zDNoYLUNNJARHQf3JkFe00fjV9x
   Q==;
IronPort-SDR: Kogpo1reQJRcNRFRYqni7WVOnfJPJVAw/elIWZiswgPUkFXgpcnbVc1IXZgVPtuEfiRvsY6TKw
 zSK16p4Aa/EdzSuW0aT0Mhw27/nIav02uI5+xRZfZlJ54h1jGF770zdUYeBys40jDibW9ozkZF
 i0gZY49leT4n54Iq9nV9F6zjeQIZa1OKg7vM8xUKXt4qExLDxdPTvfDS09LDGSDZHKSRminPjw
 tt6oLLlb2FynXeicK/OHdEQLDTQU3MAiQeWVGImC0/mbmibBcmb96aIR0u7T/CB438a2yRdGnx
 6hs=
X-IronPort-AV: E=Sophos;i="5.76,412,1592841600"; 
   d="scan'208";a="250308642"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 10 Sep 2020 15:40:16 +0800
IronPort-SDR: wtuEb7iZwUijJkL9P1wEe5LAgPKF8gazmlBU3z9fszu2xFlNqv3dzrIN7FzkA+vQQuzGh2QhMi
 IBw7sSAdhUVA==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 00:26:20 -0700
IronPort-SDR: KETUFnc3Orys9axTOdvst/YHyj9mT8xQuQPMJWaQwJqZ0yJXKTUJH03l4fBSSRe9yvIgtzYnhA
 rFloBbfxqo6w==
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 10 Sep 2020 00:39:56 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 1/3] scsi: Cleanup scsi_noretry_cmd()
Date:   Thu, 10 Sep 2020 16:39:50 +0900
Message-Id: <20200910073952.212130-2-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200910073952.212130-1-damien.lemoal@wdc.com>
References: <20200910073952.212130-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

No need for else after return.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/scsi_error.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 927b1e641842..5f3726abed78 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1755,8 +1755,8 @@ int scsi_noretry_cmd(struct scsi_cmnd *scmd)
 	if (scmd->request->cmd_flags & REQ_FAILFAST_DEV ||
 	    blk_rq_is_passthrough(scmd->request))
 		return 1;
-	else
-		return 0;
+
+	return 0;
 }
 
 /**
-- 
2.26.2

