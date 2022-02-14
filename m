Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE186C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 02:19:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239277AbiBNCTp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Feb 2022 21:19:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234357AbiBNCTm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Feb 2022 21:19:42 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E340A54FA0
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:19:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644805173; x=1676341173;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=MDPQos9blKV8Oo0LcYELhApb03Psw+soVXabs2uNE4Y=;
  b=pEPMHq4OK+ZipcB5ksJsf9YegJudkTeZzmGZRMuefiFGh+9eyC0EYssM
   1x2RDRb6P1kwWTCvBSX3o9GDS9iZiLVX7iYWJ3/9TyaQlF9cVhgUUpKGa
   mtMg8qH/iMqNZ+m8eAP0wFn838h/piUyVOm6K3cay01j8X8/6Xz2JV66n
   oEa+EHgX1Vi42DXCRk1zyTpAg9QE5ZQfpQ3bbp+pMYUH5MU6/HACRlBXA
   zGT/6YAQqJg2kvb5Ix8Mm1l1gmi166sllgxObH4fwaOyf9xozwEEBa0xm
   1Ov80OMmUT2QdX6Uf6NP/gvb0kuqnKIYx8YNStxDbq5ie0oH1iz8z/yaM
   g==;
X-IronPort-AV: E=Sophos;i="5.88,366,1635177600"; 
   d="scan'208";a="192819751"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Feb 2022 10:19:33 +0800
IronPort-SDR: J1s3Ogd1MnbSpUggb5gewkMSgRa0fjBSwAsZX0oxe9S+5pvWGzJfvDE5IT2aVknsIvys4kHehh
 69m8aGddkeYEbmJBqvHa6JU7MfuAkgQQo9oiP76tYnYVWdQz54HgSE/HCLFZPjD+jwprysYMDo
 A3p6q+fELB1rt/hgXcKjFD83N3e/OCyo8li1wJB7zXfXCgJIdQFi+woSkH41ojXchPsNyXNkbH
 toGmjZMLxJEW1hEwDjWpRYWPT9rUDtav0yW6xR644DOmsmSwVfVAy89qkl94xAsyXpWmipBcK5
 1axb6GZeTo9TxTgHGMYiOcY0
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 17:52:26 -0800
IronPort-SDR: n9lUkqKu+LRmdzgaKT8Oj8VdbHfIgh6aa+mFJkrq+BQytJfgEJrjJFuOrLWJ1Wduvaeij88mIG
 9ldUVi3D/9OQtCLC/zfFXyxNI4yFeYuu8RFzQIHzfGHKT1XeOAIwleFFSrciOqtOoDu/B0/Ewu
 P5mptvZkgxkCgbvo6m1QM+EldooShCzr9D5RBvPaZa7y92fk5ksgFy6/riHtU/s1a+6ZRRfMSK
 56JmQnNkrXqJyU5iLOOkxmpq/VC8EUJnnjXipoWxwuiZhSBUtknGlNAZ9gWEnGBPKRTNH7WFbY
 Iqo=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 18:19:35 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jxnwk3Rmdz1SVp0
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:19:34 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644805174; x=1647397175; bh=MDPQos9blKV8Oo0LcY
        ELhApb03Psw+soVXabs2uNE4Y=; b=CcInFUB+txcTRSTpk/8t4HWZmqb0EM105Q
        cPyuU9oVYAGbLseSWDYCyQkwAZkbjKGeMkVOyV4QPbwPun3XB2oYXaX8KFUaE6SS
        KCnKhTA4p0KHhUdXbGUqxz+NpftIL1KPoKq43ICfapFMGOjClYggDKZjLkdVZ2Ed
        2rC0y7zhqfl4Fys/18vUxS7MCA/6Q19YwCVm1+jZ8kmdCaFpbH2cTQzUi1qNIirZ
        3XbF06ESS3FHqVvE/JRae2hVYLnZaBSEZzczFg5kxkT+tfNKx5iDvpc6mpsDRq9N
        w3wzbD47CO7SqfuFQSWP2Y5DleSAbRLPFiD6pDhrqPphKL/BtBWg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id M26dlUNN--Ie for <linux-scsi@vger.kernel.org>;
        Sun, 13 Feb 2022 18:19:34 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jxnwj15Sqz1SHwl;
        Sun, 13 Feb 2022 18:19:33 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v3 03/31] scsi: pm8001: Fix pm8001_update_flash() local variable type
Date:   Mon, 14 Feb 2022 11:17:19 +0900
Message-Id: <20220214021747.4976-4-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
References: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Change the type of partitionSizeTmp from u32 to __be32 to suppress the
sparse warning:

warning: cast to restricted __be32

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm8001_ctl.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm800=
1_ctl.c
index 66307783c73c..73f036bed128 100644
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
@@ -742,7 +743,7 @@ static int pm8001_update_flash(struct pm8001_hba_info=
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

