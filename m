Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EF10C4338F
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Aug 2021 04:19:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1048861050
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Aug 2021 04:19:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbhHGETW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 7 Aug 2021 00:19:22 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:14369 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbhHGETU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Aug 2021 00:19:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628309943; x=1659845943;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aXW6/p3ypW87W+JiJ4JAJc8PorvCsLNnaanq9ftqUMQ=;
  b=Ym9XaYYzaUQn2jKWkD2wVX2N+4z1/L+B/sDaghIw/SIM0Npv9o3D42PV
   6xdCaJOZNZ0AiSS/pEhlEZDV63ZuJwEWmLjqr47V19srj03Dp49Ts5Ebh
   cI0qn4ICDKo6x28ofApKKr9n/ww7vdvjMfdkTydp0b2577WmX/ACXT2c3
   RWT4wy9r/0k77//aZG4bOS8CdbJFdclSAPdsz1Jr7FlNARQsR0q5NlI9V
   zIyeJ0yjbXiq/IttFD1fu5jATK+WpWNpzO9t63pKH4sqGZ13tYxZuBp7x
   c0iFFvKDSNzyxF0ALAXbwbeTmax3KcE42xCy/0IP6LOlALEhW71r7W+Xl
   Q==;
X-IronPort-AV: E=Sophos;i="5.84,301,1620662400"; 
   d="scan'208";a="181363642"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Aug 2021 12:19:02 +0800
IronPort-SDR: VB8fdssUJikSJUvsIo5HARe5t86jXzxqy1TD3GbLED95shJjRrXGT6/hBGwxeh8roSDT5ySmI5
 uvsdDxlr3KIttP04b+APQ6UWMkgzBw41+Bt77LgttL9nSY66B7p3LPqEUx6RsoTxCu5HC0xKoo
 F3MXUySSjYyNWDOZE5YRFDNRZjAbb+z4DOa6t+NyimbgAQFV1JmBh0sPir0saAhsG8ifg2iPY7
 kZhIlFadH0Q3mP9vf/kIPBlq0hGJ2bLC4OT5HAT0xWwW8lDNDerZBxry6OJPB9BlTaJycRcYM+
 lkoH//yUdYM9EwTbayqby75G
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2021 20:56:30 -0700
IronPort-SDR: 8jYq1+Tf6VUQkuovmAYZRUHc+Oooki+96ZnSfM2Phsp95TNjCSPsAfAWwsXPMluHjf29o/KI71
 m/Fs1RpzXClFleWQcjPLNxCuKUYEu6Y0s9ulHOvPiqRsRNz4rU6mdNRsRj8L3dt9ankA0QkZKQ
 btUKzK8hMcyjjle74Z/rB9fbJkZAi3oP2hil8R3PTwK5oz0AZ+nTxLTwx+0p3ZsthPXnwCClVC
 B4JuQFOnaOk1c85ANl5RJGoAL2qDsNOF3CrYzmJPjTSdRn2yVriaP81p5zNoBjawHnaHRc9c2h
 YPM=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 06 Aug 2021 21:19:02 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH v4 01/10] libata: fix ata_host_alloc_pinfo()
Date:   Sat,  7 Aug 2021 13:18:50 +0900
Message-Id: <20210807041859.579409-2-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210807041859.579409-1-damien.lemoal@wdc.com>
References: <20210807041859.579409-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Avoid static checkers warnings about a potential NULL pointer
dereference for the port info variable pi. To do so, test that at least
one port info is available on entry to ata_host_alloc_pinfo() and start
the ata port initialization for loop with pi initialized to a non-NULL
pointer. Within the for loop, get the next port info (if it is not NULL)
after initializing the ata port using the previous port info.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/ata/libata-core.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 61c762961ca8..b17e161c07e2 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5441,16 +5441,17 @@ struct ata_host *ata_host_alloc_pinfo(struct device *dev,
 	struct ata_host *host;
 	int i, j;
 
+	/* We must have at least one port info */
+	if (!ppi[0])
+		return NULL;
+
 	host = ata_host_alloc(dev, n_ports);
 	if (!host)
 		return NULL;
 
-	for (i = 0, j = 0, pi = NULL; i < host->n_ports; i++) {
+	for (i = 0, j = 0, pi = ppi[0]; i < host->n_ports; i++) {
 		struct ata_port *ap = host->ports[i];
 
-		if (ppi[j])
-			pi = ppi[j++];
-
 		ap->pio_mask = pi->pio_mask;
 		ap->mwdma_mask = pi->mwdma_mask;
 		ap->udma_mask = pi->udma_mask;
@@ -5458,8 +5459,13 @@ struct ata_host *ata_host_alloc_pinfo(struct device *dev,
 		ap->link.flags |= pi->link_flags;
 		ap->ops = pi->port_ops;
 
-		if (!host->ops && (pi->port_ops != &ata_dummy_port_ops))
+		if (!host->ops && pi->port_ops != &ata_dummy_port_ops)
 			host->ops = pi->port_ops;
+
+		if (ppi[j + 1]) {
+			j++;
+			pi = ppi[j];
+		}
 	}
 
 	return host;
-- 
2.31.1

