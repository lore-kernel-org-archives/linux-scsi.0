Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73101C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 07:37:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347731AbiBKHha (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 02:37:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347723AbiBKHhW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 02:37:22 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845BE110E
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:37:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644565040; x=1676101040;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=8dQ5lKPkh6OkNBD1ShdPkO1NXPCql9jZdUSOljzBMdI=;
  b=X3lb76Xu+jFTDZ1HN9xokFO7GR0NqEsjRYOen+i5TiiL4Wne/shirc49
   BapKEKvz/c39BfRPDYq/tV3/2dgd3vSKW4KqqxsIByHloD0ZpQcGxwD5T
   DRsiX78ORKvcXY5sm6L+YFr8UPhZl+1qQwa6hAzmb3qQ+du4G1QEZtcqn
   fzItgF/8/NPyXZn0w3N00U3TkFBRb5zf9w0geUIQ+QTOYx/NzB1eav2v+
   W5dpszW92phzZYQWbJX9evto3UT8YdBQpFCPMt523ikqhgpsgdalm5cY9
   WkXw1WOTnLMaRwt3nYlyOzdXXhA7YhqRz1W7S6Z5yVZPljAQREAOEKf7t
   A==;
X-IronPort-AV: E=Sophos;i="5.88,359,1635177600"; 
   d="scan'208";a="192675147"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 11 Feb 2022 15:37:20 +0800
IronPort-SDR: cFJ1ezAxuEzuEy1K3f6TXMxZ7Bz8mganKDw540UHb3sJrQvAs8l6ViImn60MGmPHh1P+0oBvql
 /WOIdgVpitdZAI/Am6464bKoG3YMBcfVVXJZJBibqQR1qlr6dOI6uyRSb6wi1GFeuSVXDbNTsP
 LUBMRBMYrylH9yMnBptRbNydVY5C6X3nKDa/UjA5y7LIWjKRtBtZpKzA5MRROhgj5KUNlZQw5n
 cPlL0ftPR3OvVBIUKoYSWyGV8Cgtl8+1T4eyI3IIsXvoshuQCDjOShSyuyWxPiC+1REn6cS8hK
 1wg5+jP5uY9lrgDMH+XUdHNA
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 23:09:08 -0800
IronPort-SDR: C2ybNMsnFTimV6SKA4EskNV/BjCvllB8Nqu8XdZS8jVILBUMw6ZJLVRafe/SCot+NPipV4fgmX
 UpvZjN6ibxScJ1EhrfnXUMdv9drFgX5N+fcT0TYAwTJ48QDk9XjsM6Clftp6zlsDUOokVXV9vq
 XoNWiZZiyBrqhYo4rpmlmnIljJ5HtvBY7CHQb3gkWN4H8uXJoTEyA4Fgzmy2/lOeoLpkWkQV/C
 AgNi+S3NM+yCdEEl3QvBxEGE7fWlsHzd66mjpMfrIPeKGwxw5zP6fZUPPzBqEPvvxi7xPJSGW6
 FQw=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 23:37:23 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jw56p0hcVz1SVp3
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:37:22 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644565041; x=1647157042; bh=8dQ5lKPkh6OkNBD1Sh
        dPkO1NXPCql9jZdUSOljzBMdI=; b=QsE4o5r5Hyim3a6Cn0v7XxiChnPzA3wmB7
        Xb1plnZUMWrMkTUYTyImMPBQ+jc8MOJ+7jTnsPH6+lQz1lsFTzGJ1I4eqYkw5dH2
        r5kGbhPXDGFjrsmdf6H2i0REK6wcBv0pPgnmdxPMhu9zOVF8G3yIRgcuawO4NTFr
        nbfSq550VykVKfVId7M7VOC/SPBT8DjqaAh8v+5ncAl9vkdk+bdRkzTSzJSRgmCF
        a33Qf+pqQ41eDAnh8G7nB3348zelW+YXgnIy7KEAxTBv7ph2rpaCMKAd1xpW0dx8
        nABrK088todaBtF0hWVLsgVhpCzgE9lpN8murfZpLFk9lbkBqPig==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id aBdELKqIK8UW for <linux-scsi@vger.kernel.org>;
        Thu, 10 Feb 2022 23:37:21 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jw56m54ggz1SHwl;
        Thu, 10 Feb 2022 23:37:20 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v2 12/24] scsi: pm8001: fix payload initialization in pm80xx_encrypt_update()
Date:   Fri, 11 Feb 2022 16:36:52 +0900
Message-Id: <20220211073704.963993-13-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220211073704.963993-1-damien.lemoal@opensource.wdc.com>
References: <20220211073704.963993-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

All fields of the kek_mgmt_req structure have the type __le32. So make
sure to use cpu_to_le32() to initialize them. This suppresses the sparse
warning:

warning: incorrect type in assignment (different base types)
   expected restricted __le32 [addressable] [assigned] [usertype] new_cur=
idx_ksop
   got int

Fixes: 5860992db55c ("[SCSI] pm80xx: Added SPCv/ve specific hardware func=
tionalities and relevant changes in common files")
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
index ea1f250e4b42..41a74943888b 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1405,12 +1405,13 @@ static int pm80xx_encrypt_update(struct pm8001_hb=
a_info *pm8001_ha)
 	/* Currently only one key is used. New KEK index is 1.
 	 * Current KEK index is 1. Store KEK to NVRAM is 1.
 	 */
-	payload.new_curidx_ksop =3D ((1 << 24) | (1 << 16) | (1 << 8) |
-					KEK_MGMT_SUBOP_KEYCARDUPDATE);
+	payload.new_curidx_ksop =3D
+		cpu_to_le32(((1 << 24) | (1 << 16) | (1 << 8) |
+			     KEK_MGMT_SUBOP_KEYCARDUPDATE));
=20
 	pm8001_dbg(pm8001_ha, DEV,
 		   "Saving Encryption info to flash. payload 0x%x\n",
-		   payload.new_curidx_ksop);
+		   le32_to_cpu(payload.new_curidx_ksop));
=20
 	rc =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
 			sizeof(payload), 0);
--=20
2.34.1

