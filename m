Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A446C433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Feb 2022 03:19:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237791AbiBTDTl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Feb 2022 22:19:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243426AbiBTDTa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2022 22:19:30 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A4F340DF
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:19:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645327141; x=1676863141;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2A6Xvm2+8LayS7L2VYBx1aN5agZihl1mgosK4OO3c78=;
  b=jolg8J7DIkDJEtEOn/jI5lmMZn3KHuLrVfgxWrDy1IVlYQ9+1qgdHSZX
   w57jkaA4HZsKsGalHVcaLYewkcveLERhC1qvy5J70KpfxFtzlnmB3jBsC
   cALCNR/p600BUFfkpFiY3C3n6lIyvT7N7kultWRrj3vRbPztK1xbtyfbU
   nX0Awft+e6z4gFVaMPa4xboZuvpo6BMGjH+sCrDHY8yAkf4knpg53XA4Q
   VUTjuUgugjhrWbEszixR6vIUvHF9abqeuk2pKR6tESb8q01PUR5zm8uDT
   XtxDEDuX9QLX8EsWvvWqGluhguYjVeWCEkTn+l4W4kTDLy3e50CXndgN8
   g==;
X-IronPort-AV: E=Sophos;i="5.88,382,1635177600"; 
   d="scan'208";a="193405832"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 20 Feb 2022 11:19:00 +0800
IronPort-SDR: q+SWtaZ7DAAK0ygggBy4w/IqEzScujbwT2QRkinp1YZVp4y9iTV7TOIcTsJkYTFcYib+jOj/2b
 rS0DjxDWWuBuN50p8DXYWYi36MQy7lNU7l08+sZvUFrPMuIB4Fd+KqdENT/jFGHpAUXNxqktqN
 nZ+QLR0kTJfstQkESh8+bUTQBPHtyY7vNwhFEBK/oeOPhmlLEsfXNYm2sgDZ7uEnv7OIORMHaD
 l4zmeXuk9vlwpmrggOGIsEZIzSGI/pTA9JeM1G6M7EZ/9wgE4zhhAWAIw5z9xj//Xwl1H/ZeL8
 96EUl8FhYel2eM+/kQ2GcdUD
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 18:50:36 -0800
IronPort-SDR: UUR6c5dcVfMsIxwMqaFSq7rCfAyR32g/xoA/QOc6bXQjjEbZvx4e8BaQI2d9vUf2nqTVVAZlU2
 vd8/rhmVTcU5YC+YffuJd3E+SgWrPjXkytoFiwHj9cyH4tvjVs8dw/DjEmQR1fw7NCY7HJD/pw
 WteOXr30kRcD/yEvadYv0Vk2rRTKdhL6wNNbsZr8Rhoh4MT3p/3/o21QjWwYOCTO41g+RlwEKn
 w0pF5oHisgkvafH/6IqC2qkS0RaclO1brlU6oEXp9anQBXJ/H8vma2vynPIzzOEWXQKhB8yOb+
 Lds=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 19:19:01 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K1VyY0kS9z1Rvlx
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:19:01 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645327140; x=1647919141; bh=2A6Xvm2+8LayS7L2VY
        Bx1aN5agZihl1mgosK4OO3c78=; b=PA/masRTjpexVx74NyHFhMEM8kiuf+Ty3M
        47Cw3IkBk43RFuTrAu/jKS2O2Cd+hWF6UwLfhT6nHcHRlkVgKASnEXyJYpse5z3x
        AzbnbMObriOtrKpcbCKhaoXvhUON81o2+GBXd+nMhkMt7nJ4r9FUvVMRTyH+M2Bg
        v7dDf6wiUO65h/bpDev29tc+AAeaIfo+7yBzPQMyKwAHPM649bMh1CP2pyZA8I6V
        Ihjgw+frywsKq9HTa8JCvMnHJAcj0t72hVkxNJejKSwKxXTs2YxHJXRk8bxE9g1c
        5ilO51Z92fI2GrdZowjdR0KFPojKAqjxbb7VYfkmM85A8wqTB4lA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id AKfEIDtuwtgg for <linux-scsi@vger.kernel.org>;
        Sat, 19 Feb 2022 19:19:00 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K1VyW4grwz1Rwrw;
        Sat, 19 Feb 2022 19:18:59 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v6 31/31] scsi: pm8001: Fix pm8001_info() message format
Date:   Sun, 20 Feb 2022 12:18:10 +0900
Message-Id: <20220220031810.738362-32-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
References: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make the driver messages more readable by adding a space after the
message prefix ":" and removing the extra space between function name
and line number.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/scsi/pm8001/pm8001_sas.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm800=
1_sas.h
index 6bbf118f61e7..d522bd0bb46b 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -71,7 +71,7 @@
 #define PM8001_IOERR_LOGGING	0x200 /* development io err message logging=
 */
=20
 #define pm8001_info(HBA, fmt, ...)					\
-	pr_info("%s:: %s  %d:" fmt,					\
+	pr_info("%s:: %s %d: " fmt,					\
 		(HBA)->name, __func__, __LINE__, ##__VA_ARGS__)
=20
 #define pm8001_dbg(HBA, level, fmt, ...)				\
--=20
2.34.1

