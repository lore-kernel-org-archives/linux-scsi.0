Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26FD1C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 13:30:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240909AbiBQNaZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 08:30:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240767AbiBQNaW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 08:30:22 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F12442AE73A
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:30:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645104607; x=1676640607;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/0x4t7rrbd5xsprpsKFXXlX196gTnxRlNAkn8TTlNpE=;
  b=ReUkLGX7d2AQVDDzKbSaks6FelWx9pgvdr4s5cbDOfYf4OGIBwtijnuQ
   T1Q+T9gbo9WRnOZY46zMCK/oeghRF7poYr9E7lEmQyWWWGSpcv1ZvDXsv
   xQLrSOqv1OE3gTPEYKKi/nx/jS5gEivZueV9LpIm5tO5F1Lf5t4y8bJBY
   biJQocLLc4a58ztaC31VspwL3AEg1ddLsSAKxdKIG3iMdTzPmkUt0ZfiN
   zgECRYP5rNTPIjSQs0+MmhNQma0Atf+1zM1D/2E7L5nmbIvo47SIQHZYW
   ZvgxnTWiqCDKPg38d2Edu9q1ZsSXma8zUpOMrK6OzpVaptampsZbkY0TS
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,375,1635177600"; 
   d="scan'208";a="297303138"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 17 Feb 2022 21:30:06 +0800
IronPort-SDR: QgLhQa+KlXdrGvldOvwHyIBx84gpF9fi+ruk//27Bx2FhzRXTrLCjnCIHDX4YgHrpAXV9S87GD
 Pjku0ob4kFTzLBIFvYvha70YWq+9Scl5Q7mHrk8xtxsMh99dgGw2JOJDizBq0NtXMH0qj76/L8
 uIy83B16zimDsMsg8AI0FY0UkjJRSdLXop+5JjZbDr/nuI9Od8+jIaYlypvygOyFXZjWxSTgx2
 nD/iYziXS5iiDcuae4AOdC3bZtwd8GJUukou38LrndhS8GQbPpMzu1is3eKLzT/sH+0cmBoShb
 hveffZ/5yqA3TtG6tThu5f1t
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:01:45 -0800
IronPort-SDR: 54S1eyyQZpFCh5akO3a3zMECRIO5mMYsiI3jgrmfbZ8rFRg+2jVQ3XHyHh/5/F0FYB0YfAfc/Z
 Lhgq0ca05WJIIYAzqI1/+2aMtliCjz/MLbvFeaOfWBnIooWdHq2cSgga3qJCiKb8JZMMoIPf7z
 TvtU96jQ8CsKoReuP1d2mvoOwnnnj8E+CFEceYRlWgMBgbQZTLmPFZvD6db1w0x1lxJlVsnSAU
 /e024urtWcfS7qps/s0T+KZQWOGCbK/bsUW4N3jAz9c2o1ujNwRTfzELVjktY0+Y+XBC/EEK9d
 i2A=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:30:07 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jzwg24NjDz1SVp1
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:30:06 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645104606; x=1647696607; bh=/0x4t7rrbd5xsprpsK
        FXXlX196gTnxRlNAkn8TTlNpE=; b=Mukz2LLlOexzQWDvdK92yk8EUB6KNsIkzH
        Pb9WESh/awSX7GJGTn/vBVEwZIxeVeSIatefWmNqIHWTPOTRagUUwRTT9kjjw+iz
        UM2Ui5QTN3t95iLN3pHjrOiQniTeDbFAnlME8L5F9XK9ld/eeDqKm+owEguO2eEH
        pyQy3GVAd0GBJ18F+RpRIYyq9soSZke9nDRVxJm7uRVR6nDL1lVrqf2IbYLuO+C3
        nxVJUTc2F+vTLyHW8gAX7pJHub1paxZzlP4EamdpTI1/fpfY9KQctyc0kpo3j4vp
        N7bXUGzbgnkTtm5di7uwO4lCPq+i8sAAmVod6S1ywv8NlXhHp2tQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 81b_HomPlzHy for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 05:30:06 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jzwg075Zwz1SHwl;
        Thu, 17 Feb 2022 05:30:04 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v4 05/31] scsi: pm8001: Fix pm80xx_pci_mem_copy() interface
Date:   Thu, 17 Feb 2022 22:29:30 +0900
Message-Id: <20220217132956.484818-6-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The declaration of the local variable destination1 in
pm80xx_pci_mem_copy() as a pointer to a u32 results in the sparse
warning:

warning: incorrect type in assignment (different base types)
    expected unsigned int [usertype]
    got restricted __le32 [usertype]

Furthermore, the destination" argument of pm80xx_pci_mem_copy() is
wrongly declared with the const attribute.

Fix both problems by changing the type of the "destination" argument
to "__le32 *" and use this argument directly inside the
pm80xx_pci_mem_copy() function, thus removing the need for the
destination1 local variable.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
index f1663a10693a..0b3386a3c508 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -67,18 +67,16 @@ int pm80xx_bar4_shift(struct pm8001_hba_info *pm8001_=
ha, u32 shift_value)
 }
=20
 static void pm80xx_pci_mem_copy(struct pm8001_hba_info  *pm8001_ha, u32 =
soffset,
-				const void *destination,
+				__le32 *destination,
 				u32 dw_count, u32 bus_base_number)
 {
 	u32 index, value, offset;
-	u32 *destination1;
-	destination1 =3D (u32 *)destination;
=20
-	for (index =3D 0; index < dw_count; index +=3D 4, destination1++) {
+	for (index =3D 0; index < dw_count; index +=3D 4, destination++) {
 		offset =3D (soffset + index);
 		if (offset < (64 * 1024)) {
 			value =3D pm8001_cr32(pm8001_ha, bus_base_number, offset);
-			*destination1 =3D  cpu_to_le32(value);
+			*destination =3D cpu_to_le32(value);
 		}
 	}
 	return;
--=20
2.34.1

