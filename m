Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 923DAC4338F
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Aug 2021 04:19:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7591961184
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Aug 2021 04:19:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbhHGET1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 7 Aug 2021 00:19:27 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:14369 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbhHGETW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Aug 2021 00:19:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628309944; x=1659845944;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0zuuTEioe7MID7y1H1YGfUq9+95S+EpDoqEJVj9gR/A=;
  b=AQ1/IL/IecP0Zvt0FSJzrwN3aRohBahb3jaXPD9Z1OspRmRoC5IFlGNP
   Mdb/txxnl4ugEXdPGhbeMkCgYZq1+qrj1UiHOJFr592s/dV/1XYmwU/Fw
   zFNOs04JT/xMaRtKQib81bc+L+L/Ek3P3j6L/+e0xmcC04gGM4GhceJRu
   WiI8m6i+jdSKGBfbAi5kUc7fPSaPWJ4YA49wbiytJJ5Po15fAdVd/T92r
   /VYgIyMnOuMBIRB1NUD/FFlmtQFFFOk1DNv8F5n2liE6Gdwh/fC6X/Nn6
   xwui8Cu0uGlis1kh5gcvM/BecdqHFxtDwrHXSRXpPWOSc5MDZ0JuZZjay
   A==;
X-IronPort-AV: E=Sophos;i="5.84,301,1620662400"; 
   d="scan'208";a="181363645"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Aug 2021 12:19:04 +0800
IronPort-SDR: XG/aW7NvharnXSRz1gWIHYbJzdp+4lb4KlT3Q/rFyVZPvuRbEa7jJ1iNItFBlshHVCAH6JlgNm
 r5DLKIG0sRqVn+AHTQXZF2z1nB66VzU9kfKXTblmBPB69LixIBXfizyJuiCKPX1iFahP2kuKm4
 2kmg86zLeru3gjJfcabOZA+VMP72+dZtqOk4/VVmNp9cl9XnbIFBaQXwfvAa4xtfU8HgqjV8zt
 a8q2/hi8KM1sZ0HJi1HjBYRr/14mN+vr/FK8NbDNNjUT30henmF921FZ6EbbFv0cUFnRIax/4q
 eE2IzM3hq8iMM29PnMWsyene
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 20:56:32 -0700
IronPort-SDR: 1gsNKyc7+j49zZFioxzfQ9UuVYk8uMuKHRL3AF2XqdlmaLQ+Eh94+vKOaHS7UQDlstTC+ga9sz
 nvaVpcCUZjGkhJ0uDkYa+thtH3Mra6tz5ZsD3lUGPMIm3M5E8eRJnZTmK0HdNvS6uc9MrwgZhR
 v/xz5XJZlAyVhNDMzQfukMDcvVHcYWMRu5X0HrqRuZhapAICThdYoeEmPkn4xUP+MsIo7ly55O
 ukjY5P2SxUt/xfajWgFlzvxPR1udTeN2fxcWsSRjslRKJJNwGLxfVyUK77qps2UDsYCrE6samj
 cbI=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 06 Aug 2021 21:19:04 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH v4 02/10] libata: fix ata_host_start()
Date:   Sat,  7 Aug 2021 13:18:51 +0900
Message-Id: <20210807041859.579409-3-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210807041859.579409-1-damien.lemoal@wdc.com>
References: <20210807041859.579409-1-damien.lemoal@wdc.com>
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
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/ata/libata-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index b17e161c07e2..01cbf45f9d02 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5579,7 +5579,7 @@ int ata_host_start(struct ata_host *host)
 			have_stop = 1;
 	}
 
-	if (host->ops->host_stop)
+	if (host->ops && host->ops->host_stop)
 		have_stop = 1;
 
 	if (have_stop) {
-- 
2.31.1

