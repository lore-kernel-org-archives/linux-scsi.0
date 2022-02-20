Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 464BDC433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Feb 2022 03:18:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238040AbiBTDSr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Feb 2022 22:18:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235446AbiBTDSm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2022 22:18:42 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38F9C340D2
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:18:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645327101; x=1676863101;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tMu46lOD+saf9CD6nTTB39TE+9yuObAVdHXvuV2n3JQ=;
  b=Cb8FwbbPWDvyIrKrqWXDYb1gvt5r5wc4xz/IDJ8IpAS0DU1vZA690QQo
   ibok/0KEQASsosNmyg7sUZUIzwssur6tczFQM4zzbZqI+CqcnBy7liO0D
   LGi5NpU70HefiWxuIQU5esMEoSRyUJaVea3yyblc8rU2RSp5eTbNMZ8Yz
   SVPE4htH0ZhKYw0qlrh1N5+lcip8KvgnJP6Ai1XyMpDAVVnZO86BxFvc1
   q/DtYiIe6eOGt4lDZFbnQp5hykKyx/hPU870P6Nb+mVcdocdX9ePRCj8N
   HvT2chET+vMt3TkmF509tO9r38X7xfVLA7VFRyBYSqFOHQTm+Y+LIQTzb
   w==;
X-IronPort-AV: E=Sophos;i="5.88,382,1635177600"; 
   d="scan'208";a="193405737"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 20 Feb 2022 11:18:21 +0800
IronPort-SDR: G+snjoB20wn8Qg9wOj+MRNF9wdmHKnX/GYEvzDxlqD/ABRddmYlpBvQ0mn+EkhXupchqolr69f
 GD6pqRkbHKgi7iAT8IItOSwOnlDwAUxhvszCBOj6VW4hn9+EmQMh0rxmePG/SiOgKpaKJFIar+
 7aFnHhRndA/jsHO6gS2nujiDZ5YUAiUMC9r/T714PdWcdt4Gx5G/BcfiOWdHd0vHwQTHQpRONs
 3fiqPO4AEJfWYJdpBeE3yzhjDDcPXgbLaFOtBE6PbA/uIVcuxVUKV+Jp0529Z69W6V24xuFt5p
 lZEu1AvH/dMmuo2UJmYmtB3g
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 18:49:57 -0800
IronPort-SDR: DTsP8+t4xBhUS/UCQWfD4+F8M1HpZVOwbKWHxaalvqjgBX1mvVa81rD5b6IPtNj4MO9Cc5iX9a
 kh+KJhdXkpJLsweK7wpLyHebdMHLf0snLAG++qMqo1uNPKfuroCKey8NoIibejQR9+fMxYuagr
 BWnBJBBZCtMn0mdPcOSsQY3KdW1Q8WZZV3yZhy08rcqQoj7RncKq4NQtQmhMDxxtvphHZGzwxH
 O0UkerKJ+VmXNSDEwJhb+dzJA60MPlsQqTUsGoCquqaLh4WAFdg28tyGzl3hUInoEOw9CSOnFY
 vpE=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 19:18:22 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K1Vxn60dVz1SVp0
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:18:21 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645327101; x=1647919102; bh=tMu46lOD+saf9CD6nT
        TB39TE+9yuObAVdHXvuV2n3JQ=; b=s7VdFW9LCNBmFYr8YBXmpPSibGZIChJlNI
        8W8jFZbVaezwTpOa4d2iULfXvXTSw+nEAJTDYsqN7hK6b2/nrmMUbyRV6d5fTjQY
        yLCq9ifhsitvm5ZqhStyxqHPqJN3/U/v9QlyiyQ66ljQJLfIO8+aYd8T6Q09pz5d
        RxBLgShXM9EaYFU6DkK9sYEQXkcaQpaCGPOh8ScZHjcUrdQgU8QL9oesgrvwBagT
        C2vDEU+PrJryl3rrRiGO6xHsN0tWwuSqSlDnZu5vrGVutQomTGxIoxb31AZqqK+w
        dacHoBwUwE1cjOV3toVwzPSkPM+2PGoZGOp+f0dCsRIqhuq2qCYA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id cYFjpGiMGesO for <linux-scsi@vger.kernel.org>;
        Sat, 19 Feb 2022 19:18:21 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K1Vxm2RKNz1Rwrw;
        Sat, 19 Feb 2022 19:18:20 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v6 05/31] scsi: pm8001: Fix pm80xx_pci_mem_copy() interface
Date:   Sun, 20 Feb 2022 12:17:44 +0900
Message-Id: <20220220031810.738362-6-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
References: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
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
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
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

