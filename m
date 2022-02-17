Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 674AFC4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 13:31:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240958AbiBQNbk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 08:31:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240961AbiBQNax (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 08:30:53 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F21092AF3D4
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:30:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645104633; x=1676640633;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=A2J9ZprGUDie40Y5laTVxgl2YHMqC17R0/oKPszFsYI=;
  b=BGf6X+sv2tbqp75EWuYmenjvKKvnrW9WmuYvMZ2SK+1hCv9aVck1B05B
   ZYXJ1TH81AbCcKIbzRAROJ3VWmcI8ns/9/MJFaO+wlv+JAv1o/5HLe2kv
   xlJ9yD7u97+f6BPXr/uZHUr2B1cHMFZ0zlBksYi6eE2V8F/pLQMRA6Npt
   2zjnwvd83zrFfI51bYQE8rebqZuILPf8Ni1wZwzam3sgQrhMd2pKdwN5O
   jnOf5ATqN4XjqygveUO0g5PukMZIdgoFoTRpnHYIG2o4dXWuwV2Etk22r
   Eyhxidy2BlHaa85DOAe4212TCuNypBJx1KpyS1InTY/5FpapdjuG5Ri2k
   w==;
X-IronPort-AV: E=Sophos;i="5.88,375,1635177600"; 
   d="scan'208";a="297303227"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 17 Feb 2022 21:30:32 +0800
IronPort-SDR: mXy9w11N+BtB/B71sUD7PrWQAObUUIvP0Pbk+bkaSFB+L/FsMXEOQqrqFNa838Fz8e/+aU7AsY
 biuhvt2FZmGhsuAIPS1eGwMHh/PCZ1WzCNaDG8OCpvFTKj3ApATbAtKESvK3AnzdrCcxj1nLq1
 hwxPiRTC+74XLVdx6us0M6YEOwoPcjcHtwoZYPwySU6P7B0ORUbBAeJLSZqZEUZGbfGrp+JgBm
 yqdgj658FT96i+gVMua5SEemcDvuIPfeEnLMBfqjhTQOgbo3QKr9jCMWSna2ANk7o5/S4DZiA+
 U5Kwa1FGSatdO+dlU0C+5hrZ
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:02:11 -0800
IronPort-SDR: YvXsWhs+uogkJJswhBissEvrGr2JPhmXVM6PJ/HQ956feP0qCsU08VE1HoD84ENfmyXWwzsRXW
 VENokRNl6+si/R7ywWB+8mMcHfTepnYBIKHETlapeOouxYz0mqvS34Weg4vOBGl7h9RxN+fCyD
 SSmQcY/JwFgMt2od6HyhHyFbITeb0Usu8c2Vp+rynQ6oIjm+7sgQZYrWdoniQ7D1CW4wPBK2gc
 mmLiJ1HIQ5EtQbQiEifAsY+u3LQmQSUoRnYYKX6EIfo8GyDAukZLL54xGsIA3BBYhlNVwsK3RR
 tmI=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:30:33 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JzwgX2g5Yz1SVp2
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:30:32 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645104631; x=1647696632; bh=A2J9ZprGUDie40Y5la
        TVxgl2YHMqC17R0/oKPszFsYI=; b=GWpNDtWn5Y27Prraz2woBHqj9qXNqQlvMb
        2b9raK1n7Fg6aOiNZ04obdnJcgyzSrz92HNGr9p9ULm4eoOcMnhW2GpbSZhmegKV
        LyC72hEegjI1FF1M/R+28jWGnLpAx0Ub2SAOX0SMiHOgMhglKy8uLGCY+Qsw99Cc
        MY59DjrkFZsUiPbNjzQiaQuSigwSzZV7Icsa73JTgqMSiG4qfVZIdY1YCr6EMDXS
        YKwx5bwJbSPSTWVCWDXDnQB73BX2FCVWlboW1Ugi1Oahyrtud7WFs1H0wWeAYJAL
        6IFAwWqATDqFXjQ1GA4U5wqeamqsiugYWAJ36dTuo9BmjJBq+aNA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 8qwZa_we13wQ for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 05:30:31 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JzwgV67qXz1Rwrw;
        Thu, 17 Feb 2022 05:30:30 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v4 23/31] scsi: pm8001: fix memory leak in pm8001_chip_fw_flash_update_req()
Date:   Thu, 17 Feb 2022 22:29:48 +0900
Message-Id: <20220217132956.484818-24-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In pm8001_chip_fw_flash_update_build(), if
pm8001_chip_fw_flash_update_build() fails, the struct fw_control_ex
allocated must be freed.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm800=
1_hwi.c
index 431fc9160637..41077c84eec9 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -4873,8 +4873,10 @@ pm8001_chip_fw_flash_update_req(struct pm8001_hba_=
info *pm8001_ha,
 	ccb->ccb_tag =3D tag;
 	rc =3D pm8001_chip_fw_flash_update_build(pm8001_ha, &flash_update_info,
 		tag);
-	if (rc)
+	if (rc) {
+		kfree(fw_control_context);
 		pm8001_tag_free(pm8001_ha, tag);
+	}
=20
 	return rc;
 }
--=20
2.34.1

