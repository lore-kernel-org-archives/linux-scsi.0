Return-Path: <SRS0=YGqw=XV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A08EAC4360C
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Sep 2019 22:08:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 754362054F
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Sep 2019 22:08:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Gv4RwGk2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728889AbfIZWIu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Sep 2019 18:08:50 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:22768 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726229AbfIZWIu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Sep 2019 18:08:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1569535730; x=1601071730;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Hgy6DAPZl0jWum/D86Hr5Fth9vxPUwrThvnxsFiiasc=;
  b=Gv4RwGk2SHc8W1yMbMk46SSozKpO8eYiSZ9MSHy8wDsDMUhik0LA7jJ1
   8bZY8AT8NWKQj7ilPZE4SCa+66Ug89Jxge9Sd34C0Td/mDCaY+15sn6vk
   +la6buQb2COL2Z0tReTA7H3z3xEln1lqAL2uOSaYnjSoPkM+zH6+/q1aY
   mzoVKxBQoWCeHUV3nCQOfsJJ26IQBISQdMJhLAT4OYJwvN/bd/vExeDC/
   4Lx9BJHsKMyeQbpSdgE98WzhLyJQAHlMG56t4ZcrrsCpqGrjEZgrg5xMv
   +wD7+dDNktbIWx1uhx2by/OI4FDveLKyh8bqWXnQcr8bykNP9yQ3hRtfi
   w==;
IronPort-SDR: dZkOm3eoQWFJ/9gTuwRCHp4o5Dv8I6ATHsk9rkGX4PtOkuSlL2lCaBtv/e4CpSkZXwEPZDUUM3
 /jrZb8fwni4pKjJID48BgTtnazfTOuWuddf92/it0yAAYyIozV6W78IbK9wE3hSM4OQRe7S/On
 HVeuIQTxOhPa6fWKnzBI63FLl1ZAxG7jWRlg0E4R7JdU8dU9GOg4L5jUUaf+5gUY5KERa3T7IZ
 xGtm0haYwyGmsFrW6DC+E7VD7P1f31vfn2LeQdcdCahzsVdd2vjLKUyAHkRPZRO9vXWSjFd4XN
 Od0=
X-IronPort-AV: E=Sophos;i="5.64,553,1559491200"; 
   d="scan'208";a="123681607"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Sep 2019 06:08:49 +0800
IronPort-SDR: pmijeaBlyYfn0ErJ/LU8MQX69Qqm1+TIlo1PfZsqkHmRJAlQ2nuGewRDLHwLxq+L7pb4qj7SXf
 5YjeDKr6mrcm6quX/ViG0zHbbeZ5WyHeTxgNFTrr4gEkx9WYFba62dADbkYxldPVJvG1v+jNoc
 B4LvPRxfdwnjMQwGD0Edj6N82Y4hyebpBXCPduem2WBZFaoq7St29lFpQSdOs87seFiNE2oSyB
 7OuQ5x+VdCs8x57fYsOSvNAmjL3O7KG2E9Uh5kJzEgHYwtLWi3Q+ymAJA9TGgUm+F/bvaT7kRU
 85o5blztRiCFMT9qldkvUnY1
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2019 15:05:09 -0700
IronPort-SDR: 9zpNuZr0vL+FQiZahPvvSOPlN/37C3hgKudFHglsD3aYQMXbBOTAvOgQZtxQYOVkVyoGd4V+vU
 b8ppPc7GBwbaTEHjhxMZGC3GB0kPBYiIaZM2GiSMOZLYhuyq1IWQ8WUQuvryFTAgOrO59St5Kz
 df6w8FlhBblJxXY6vHra7k08n8U14WXc5r9d4SUmtiqSAdcs6stpMMtMd2eYTwolGRWWKaSL9l
 8gNAtVAHexT2wvTsuRXmFfwrp4zeerBFR3Et7DDRm2EZMGmdQrmC/R7l/U1uY0jLPhQKG3wkD4
 qwg=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 26 Sep 2019 15:08:48 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: [PATCH 2/2] usb: Clear scsi command resid when residue is 0
Date:   Fri, 27 Sep 2019 07:08:44 +0900
Message-Id: <20190926220844.26631-3-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190926220844.26631-1-damien.lemoal@wdc.com>
References: <20190926220844.26631-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A scsi command terminated with CHECK CONDITION is hijacked to execute
request sense with the original command information preserved and
restored respectively with scsi_eh_prep_cmnd() and
scsi_eh_restore_cmnd() in usb_stor_invoke_transport(). This means that
if the original command is retried, the command resid may not be 0,
indicating the residual at the time of the previous failed execution. If
the command is retried and fully succeed, the residual of 0 should thus
be set, always, to avoid reporting to the upper layer an incorrect
non-zero residual.

Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/usb/storage/transport.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/usb/storage/transport.c b/drivers/usb/storage/transport.c
index 96cb0409dd89..c69fcbe467ef 100644
--- a/drivers/usb/storage/transport.c
+++ b/drivers/usb/storage/transport.c
@@ -1287,6 +1287,15 @@ int usb_stor_Bulk_transport(struct scsi_cmnd *srb, struct us_data *us)
 			scsi_set_resid(srb, max(scsi_get_resid(srb),
 			                                       (int) residue));
 		}
+	} else if (!residue) {
+		/*
+		 * The command may have been retried after a CHECK CONDITION
+		 * failure and autosense execution, which can result in resid
+		 * to indicate the residual at the time of the failure instead
+		 * of 0. Clear the resid here to indicate that the command
+		 * fully completed.
+		 */
+		scsi_set_resid(srb, 0);
 	}
 
 	/* based on the status code, we report good or bad */
-- 
2.21.0

