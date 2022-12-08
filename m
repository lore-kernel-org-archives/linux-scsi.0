Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9EDEC6371D
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Dec 2022 11:03:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbiLHLDa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Dec 2022 06:03:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbiLHLCN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Dec 2022 06:02:13 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A67ADF01;
        Thu,  8 Dec 2022 03:01:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1670497264; x=1702033264;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=y/WCKpHJCy1/94Jl00aMjpl6YjzcQPt+Nc3cOlCy9Q0=;
  b=XDJ4iCPUApD6i5d/09C+gHc+y34amma9/T3T+aLTsN2kAiU9dcWifDTU
   8tZilZplwvb06QY825sbaqLL1YYyggQ6mUCrsgApNkf1KglXuWdExAZXB
   iBQqrDOZUU6fdBG7lc+WjdnfOPClmPFq0Bszly2A2NWHNgNqSIJSFnwgF
   NxpqevQmN8pT9x6VXOR6mnG91fpR/hIdwVcpC1OIy5UASjmNsrYtzDZvx
   bF+dsmaowAhwqBDYbmcDUukC3LAWy7pw2ykeyWsTSfxZXuyqVfvF2q+oE
   gJ8JjpqXJpO+ThqnrBeCoeO6aRVKu18MfyT3sMkEnC8cRFu6hdI8fw+42
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,227,1665417600"; 
   d="scan'208";a="223333388"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Dec 2022 19:01:03 +0800
IronPort-SDR: KtQLNNHyjyeU8Nikk81VTxAwj6iL4DnVw+x4bn/5aK1XUpAL08GfUmzvBA5NMHL17FmNoQ8RTC
 yCfu2NJA7pCEYYeUOqd8PezjoxFrXodrk6Y9ctJlyTYbFKxBtmEK7SFgOlZMXbI7Su/GvpzkWY
 sKTCdcJh81YUrPXmTnbuhCMglZHlbAdr88yXSQI1BSkP7Ce/3MTk/iFnQu+/RmjhRKpUSOc3Lt
 t+jP8/jUUXAbDjprOxaQ3mpE/HamJvDIek6R+rwbfL/nux7kwpOLgat4PjX/UVK/dJo7XM6Yh7
 9yo=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Dec 2022 02:13:49 -0800
IronPort-SDR: n7DP5eOX9kGRysOgLgAi1oIsdQVJo4HAwc775L4L8cHU09TXsmFAN6ibxdiq5t7HwEyHRWJGaa
 RoO/bWfz238EdtakNsRvEANGFLQw/QAyrVIodDPQli/y4icTsP4rHCMFqI26kiFf/UHe/zj8rq
 YINyOsArb8ZXKKR8GdXpyw8+qjNFVXzC1t2d+mv+0fh7wTpeqHzlpbxHgyYdPSUVP5ibihVkhj
 NfUkJXh1r2UeihO09Dk0hxawX/30/4PIJj+EUDCT+aB5T1v2y0X/MFUkybJ95RbEH85melfQEs
 Fro=
WDCIronportException: Internal
Received: from dellx5.wdc.com (HELO x1-carbon.cphwdc) ([10.200.210.81])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Dec 2022 03:01:03 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: [PATCH 09/25] ata: libata-scsi: improve ata_scsiop_maint_in()
Date:   Thu,  8 Dec 2022 11:59:25 +0100
Message-Id: <20221208105947.2399894-10-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221208105947.2399894-1-niklas.cassel@wdc.com>
References: <20221208105947.2399894-1-niklas.cassel@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

Allow translation of REPORT_SUPPORTED_OPERATION_CODES commands using
the command format 0x3, that is, checking support for commands that are
identified using an opcode and a service action.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/ata/libata-scsi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index ca3b92a1a6a5..78729fd9fbfd 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3268,11 +3268,12 @@ static unsigned int ata_scsiop_maint_in(struct ata_scsi_args *args, u8 *rbuf)
 	u8 supported = 0;
 	unsigned int err = 0;
 
-	if (cdb[2] != 1) {
+	if (cdb[2] != 1 && cdb[2] != 3) {
 		ata_dev_warn(dev, "invalid command format %d\n", cdb[2]);
 		err = 2;
 		goto out;
 	}
+
 	switch (cdb[3]) {
 	case INQUIRY:
 	case MODE_SENSE:
-- 
2.38.1

