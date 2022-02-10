Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98FA2C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Feb 2022 11:42:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241117AbiBJLmd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Feb 2022 06:42:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241114AbiBJLm3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Feb 2022 06:42:29 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 656D2FF0
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 03:42:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644493352; x=1676029352;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=3YhGeYPBwZrSeSc35Br5ADny29zolAB/42QRCJwcMUA=;
  b=hzFwpbbN+H6F7fApZqLOMXJJWoPpGrH/qYIWgCMuYvIhgJcApGzYIJG2
   y8lwFAoGaNBGTvlfle0sKuEq7GUekLKpKibpXdcLoHN6yIaSWZz1xtXd1
   faHZLAgfIfY3ay3P46wBdkEsYxJ9L5iZtpzI9lYyH9Di1fvpxnW0kjx46
   YUtfbAf+MDv1w206h33DzGYI/84KFkmtgAqPqIPR0FBftrr6wW94Mfd4f
   aUVbcr/2Q340K/x3j2aQYtnwg/QjXPfeQrDyn9S/3MUdvNNB0+sBBDSgA
   8N5aQHdKgoqJSULMqe3vPHRg4dH781Ar+JWAD902y+Tef2jSeDPIl/N06
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,358,1635177600"; 
   d="scan'208";a="193575631"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Feb 2022 19:42:31 +0800
IronPort-SDR: aXcpXocqnetwDUB2C/kkbh6lDwTxDe7ZesJIjrWlqOzWVlmQauNMOC1mYmle0P5d2BmIdJMeYH
 4qfzgmZIDIKSbXB3bWhXJNdpsQ7RDg7nY0UP3koAfYK9t6P7HTy43DvVvGhZrxH7le6OEY3xlL
 wQl9UWhGIrPZZGN5SOltT1ShJNA2b8LOgBV4QiaYIP1m3rY0YI7Mv7zrL67Gl+PgB/EPQmHRyw
 q1/D51YJtbHd5c8aho+FunjjrfLCZWq+QObD6lvw78/lWqvwejw7kwV34JPc0vPbmzSynV+FyZ
 r8B4AEe2MADBT9uC3mw9r+4U
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 03:15:28 -0800
IronPort-SDR: JRN9T9gBsV3pxS/pWJA9H+0avVTMjSpMtFdNBa/2CraV7/LszVswMpAMB7tgBhx2w5N7kWx2eZ
 5jrVbnO1THOothT318WvSQTFFGFud8yopT5CPC2SuZIm0ggcj2XyTD0F6WDbTfEET2pwJw7sRI
 aTzDbtceUJOwAnNTmNxwKihQBVadJpZCUerimIms158NsroufzDUaZ7aSPgGZKAIDbWC61mPDv
 bupmPBn34cEQMsR3yQj5uPnoYc6dQ63f/XllpYsLL+FYmD+hVho4MBSzi9PH1MFs1sMsl4qgik
 08o=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 03:42:32 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JvZc702vbz1SVp0
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 03:42:30 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644493350; x=1647085351; bh=3YhGeYPBwZrSeSc35B
        r5ADny29zolAB/42QRCJwcMUA=; b=UoC0T62ughfYf1K35aY0bJnZv1cZ66vYfx
        rrsQC4lSu7Nti+5r9wY7rRijIPMBp1KLzo7CcCHb1avxkxCR9fNKu1zh12+pvqfE
        HD1TzHFI5H1DIJCSd3s01cMEewBE2ODR59XxXujosQi3D97Z9KJN2FhkPFrKL2l6
        E/szKC7x61Lf0Se0ZaAjUJzPk0fYKGdcvjandLB8PzPZTPw/POS2dco3vj4s5zDD
        GpVXa8mgpmAyU+FnEQW2AOpOC0XYgWqlzFb9wTx6kIl2cjsG3BerSyTeagf7ZA2r
        v+oyFvGc3MmZzaKZwtJyBNcI65y3xkrjs/JdBuXmTMwZS2vt3BGw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 5OG7nTIe9ch1 for <linux-scsi@vger.kernel.org>;
        Thu, 10 Feb 2022 03:42:30 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JvZc5400Lz1Rwrw;
        Thu, 10 Feb 2022 03:42:29 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH 06/20] scsi: pm8001: Fix pm8001_update_flash() local variable type
Date:   Thu, 10 Feb 2022 20:42:04 +0900
Message-Id: <20220210114218.632725-7-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
References: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Chnage the type of partitionSizeTmp from u32 to __be32 to suppress the
sparse warning:

warning: cast to restricted __be32

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm8001_ctl.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm800=
1_ctl.c
index 41a63c9b719b..03aff0ba3657 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -721,7 +721,8 @@ static int pm8001_update_flash(struct pm8001_hba_info=
 *pm8001_ha)
 	DECLARE_COMPLETION_ONSTACK(completion);
 	u8		*ioctlbuffer;
 	struct fw_control_info	*fwControl;
-	u32		partitionSize, partitionSizeTmp;
+	__be32		partitionSizeTmp;
+	u32		partitionSize;
 	u32		loopNumber, loopcount;
 	struct pm8001_fw_image_header *image_hdr;
 	u32		sizeRead =3D 0;
@@ -740,7 +741,7 @@ static int pm8001_update_flash(struct pm8001_hba_info=
 *pm8001_ha)
 	image_hdr =3D (struct pm8001_fw_image_header *)pm8001_ha->fw_image->dat=
a;
 	while (sizeRead < pm8001_ha->fw_image->size) {
 		partitionSizeTmp =3D
-			*(u32 *)((u8 *)&image_hdr->image_length + sizeRead);
+			*(__be32 *)((u8 *)&image_hdr->image_length + sizeRead);
 		partitionSize =3D be32_to_cpu(partitionSizeTmp);
 		loopcount =3D DIV_ROUND_UP(partitionSize + HEADER_LEN,
 					IOCTL_BUF_SIZE);
--=20
2.34.1

