Return-Path: <SRS0=95cY=AR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0158AC433E3
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 12:33:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFCAD20715
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 12:33:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="D7GyKAKx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729125AbgGFMdv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jul 2020 08:33:51 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:37664 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728414AbgGFMdv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jul 2020 08:33:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594038831; x=1625574831;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=WNLX/+Oz5Vex8A8CocMW9LO62aSK0QWDznL8cr1hlJc=;
  b=D7GyKAKxzD9iypuxug4FttdCUbY1yzejYm3o+wToAExYQjVvYlz0/ybE
   ZSl2HmEvHlXdIZLW41B84rzaL943MqSZJtwMXtFTtPCojfctZ4BzSk0Ty
   gPgEOiAdvUiNm/NN+rUodbY8yQ696dWSqdfC3ZU49lbnogSCGI66R7FXp
   oZVjjzgclCjWFo1pt3S20720D9MdA+7mDx96Ox1r1Kmjy3pbIpsJuond5
   +4PEcX3EkY/aZbZhja0YsYuIBGydjtKi6AQzOP3SfT+WS9DIbVite8Uhq
   uhgHGJODGurT6J7LaTaKLGcouzSDtjQRT7MMszrq735aoTezwg+uMC334
   w==;
IronPort-SDR: ahhg4Hqgzze2sRgeLyrKUrMVQooAMpmAM75JBhaKpEuCoprJDU3apyrhWLjuQbYsXnRFt4Dcr6
 JVCBNEBNnLuFqBjQXCdmOfUykHwCUUGMk0yJRnMDDEtlOw0ZS1w9hty/su85lj7Ts0r380XrEr
 s2L/mr857Qh3fU1zNI6zibpPMDOJYjH78BFm+IbcCUYwS73jn0LJ6kTIokA5T7JuBzTGcfJ4db
 PS8Cll+11oVIAaa46y2pnU8Sgqlah4aXPjKAH3UBHxKeQTk7ARZWFcvh9u4PhGD38ufQHBxV0s
 UpA=
X-IronPort-AV: E=Sophos;i="5.75,318,1589212800"; 
   d="scan'208";a="146052063"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 06 Jul 2020 20:33:51 +0800
IronPort-SDR: TiSuk9vbvg314nyRsh08VIcz6lEbVQsQrQgFS8Xh7q0ZnwApMNgBArzbvkh8n+i+lAJM3eM0Ns
 nHaHVBmjDQn+vgHn3nR+5FeAclR41/lWw=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2020 05:21:59 -0700
IronPort-SDR: pUWuducwwkMp3sIIWMs+hUV8Blk3bgBGhwbcrd6MWpAzWY1ulmA63zGOwf4SfTkVir3qn7kdBM
 06l7bTxKkwnw==
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 06 Jul 2020 05:33:50 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 04/10] scsi: megaraid: Remove set but unused variable
Date:   Mon,  6 Jul 2020 21:33:49 +0900
Message-Id: <20200706123349.451915-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In mega_build_cmd(), the variable epthru is set but not used. Remove it
to avoid a compiler warning.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/megaraid.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 07ce31c546ba..96ecf5929e68 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -517,7 +517,6 @@ mega_get_ldrv_num(adapter_t *adapter, struct scsi_cmnd *cmd, int channel)
 static scb_t *
 mega_build_cmd(adapter_t *adapter, struct scsi_cmnd *cmd, int *busy)
 {
-	mega_ext_passthru	*epthru;
 	mega_passthru	*pthru;
 	scb_t	*scb;
 	mbox_t	*mbox;
@@ -905,7 +904,7 @@ mega_build_cmd(adapter_t *adapter, struct scsi_cmnd *cmd, int *busy)
 
 		if( adapter->support_ext_cdb ) {
 
-			epthru = mega_prepare_extpassthru(adapter, scb, cmd,
+			mega_prepare_extpassthru(adapter, scb, cmd,
 					channel, target);
 
 			mbox->m_out.cmd = MEGA_MBOXCMD_EXTPTHRU;
-- 
2.26.2

