Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E85D8C433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Feb 2022 03:18:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240224AbiBTDSx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Feb 2022 22:18:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238602AbiBTDSt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2022 22:18:49 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D031340D1
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:18:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645327108; x=1676863108;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PplX+kDNXdsQ5HZh8arIKafLu+DD+Al5/ujtqhFFtf0=;
  b=EFWkJZg3yNzIazN/4WfIymbLk/hY/JvOw2EVx9Nzqp4QKuh90+bVu8cV
   qv8S1q4d0BokZSf+OTx0DW7XbC6Yh6mElN4MyS4ZoFqZxWHXdQxFcbe3K
   LOaJ75KZWBVZnbWdayrmNvx0Q0rMcsG5ljdNNGytLP0JeBKEK4tNsXqH+
   wTqDw50dwjE9V1xl95CPPszlR5GFLsPj0kswfwihn/zElMJbskNUWnegq
   vvmY2kpy+urjGUkeGJgGRj8ttyQlSezMzZl4l9Esn/o8yBP6+5GV7D4/D
   NSRIdwvkHZNelp+fhZkeMI+BOanXiWiRiic46+zdEADKqGZgtvQ2vrYbu
   A==;
X-IronPort-AV: E=Sophos;i="5.88,382,1635177600"; 
   d="scan'208";a="193405755"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 20 Feb 2022 11:18:26 +0800
IronPort-SDR: b8B9RfjeM0Kf32q/p5PYVGFSQT2O1DoZpC75yy/Pf5Gqrdnm3AFXrJJXpiZpml6TtaYFLvazqd
 1b/NtMlW+W9eD3YloCcsoVgIHIwluPQrFrz/OwwIStc4vM41KkRuKrHvf6blY9wyVxj2WECAHx
 usJfrKsrX4thXtZqpRI2IYXL4tdDVRK6myEqUnKcpctuv7JCgvzDv5ryAaRcS/f+3Zc/NmMq62
 jkHHb+1Ol6OQrXE5LdOBZIlsQqZ2rjIvZti6OaGUba/GKJHSITTkuKKUyQsVUFcocjwrJRbSB7
 so3pDJXIxPecLbJrxE2RVUWp
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 18:50:03 -0800
IronPort-SDR: 4S4ecbexQ093WcSHwciCYT193rvgMDH1HZdCOEvVl2nCgPHJT5wWhfRNiJM66X4YJOaCRl5geB
 9pqIfro5Oq6SxrN/RcpU19mBh7jAFFS0WFDzG5tGW/h9At6piawQe3zTebHplv8yPcJSjgHxXP
 EPtDIUY9Yn/34LkMn891JKiKI3cq2SjkIkJnHoBUAF0GtkX8NKdUQVBq2P0v1oDaZe/+bRbFFi
 FnFeqwO0gEj3GhaQZFfj/GtEiZk50Da5roTAMT+O6TQBLJvxCScaai3oNWK4T7+xXEavQkXSio
 SvI=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 19:18:28 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K1Vxv3nQpz1SVnx
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:18:27 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645327107; x=1647919108; bh=PplX+kDNXdsQ5HZh8a
        rIKafLu+DD+Al5/ujtqhFFtf0=; b=HjWEMRDvwO9t5iWQMzC3b0H3GtBS3yFGKI
        od5j67W/Mbg3V4bKEUrUW+ZQwZzP6gTDRxqpRheQB8X6taKhPSoJaRfcoIaeHsVl
        0ZamE2SZeLlEL1mDOqUHwLVWscSG4C7KMT0oRVVJ3z9ogIO4psvsDJvb31FmxxGz
        ed5X3dx599+n59ckASk1b+ceHBieeGaid8JtOuLOSKBjdcd4eDyMndluAjvgfEkz
        fdp9dvT3BDw5w4dTJMsTJKW3samdRFaDRXWpBUIN2arVRcabluZZEsJUsTWdply/
        pja3txF75d4/54OlN/APkR65JgkbGwo3PbNIa6yuAXqagdTDE+BA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id yoriKdONc5WM for <linux-scsi@vger.kernel.org>;
        Sat, 19 Feb 2022 19:18:27 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K1Vxt0Ks6z1Rwrw;
        Sat, 19 Feb 2022 19:18:25 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v6 09/31] scsi: pm8001: Fix payload initialization in pm80xx_encrypt_update()
Date:   Sun, 20 Feb 2022 12:17:48 +0900
Message-Id: <20220220031810.738362-10-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
References: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
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
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
index e6fb89138030..b06d5ded45ca 100644
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

