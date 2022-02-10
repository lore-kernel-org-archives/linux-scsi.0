Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB65DC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Feb 2022 11:42:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241141AbiBJLmn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Feb 2022 06:42:43 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241127AbiBJLmf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Feb 2022 06:42:35 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E80E1026
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 03:42:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644493357; x=1676029357;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=n3PQdYPDIFO8Uwr/FMnjUNEQTlCYp4IwHIQHnJXVWd8=;
  b=pjk6I/8iAWXMIdHRTSoI1ZhA+5mcs/QnkP1cQp886zY74E5yKXzMzucA
   Ng3R2xtE/HCCKfLZc0IsesrsIllHtmFhOqD/z5p4ouVvtO4GItulYpX5c
   i8eesgdckehGhnNetCYIKdvAAEsnrreFU+iUEea8qdfwhx6G/6I+myHZK
   o2HZ2i+ksLna/DSO9WqRKuWRAOvJLVAWCIvRJMY0f19qGpDE/C13LOfty
   2zIfR+he2cd0hiMWYMV0ZjWUh0bgZUPOGWxjpRFtW2q7iaQHzMrPWxEUg
   o+Vv6xZfkBZCLArjlYph748dwDna44d+pT2XrKguLwLhjIHQB+EuwsnFv
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,358,1635177600"; 
   d="scan'208";a="193575646"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Feb 2022 19:42:37 +0800
IronPort-SDR: +kSif5Ho/Zsy6p+vuFwGlUspoGm5kOnnIrdMXF+1Nrg5yl8pAddBQPid8PgKSatF34RYkaz2Hu
 FjUNDRugapXTcclJ3gTADkICmBcvjYl3zVz2w3AamKtL5mPVAuD7UsYc0kGtblI8uIBu3yrPw6
 erV5e+/kS7U651HGTYtHrwggxnvqfMBJwGjrelRbvVBX259XnQt8xtnb2Kexi/0cl2QYCfBsey
 wyxmSKz5T2XzQK4GOMLGickoywV9feqC4rqr9Nj1+T8o4f5KvAv1uM1u2vNxx373+PIl0P9Ry9
 WJ4A9ESQxw8tm2GO6QYu+20Q
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 03:15:33 -0800
IronPort-SDR: WB6svrIKOzqh0MSYMzuM0UOz0yAelzVd//doRMKQGDZ51MRuhD05V10jojSSKrAGjQPHX6akkw
 x/elH9kV1pFNbgsyJ+jTRHuKyMcjE5sUoqtznCDUe8XuBTnCP+yhsi0sxhDLT9Ha9Dus5o8I4P
 jB+grePuU7t1PdkHgLIsdTuZCXXrowpQgUNYzNaaj/y4SJkfvU3522YsBMAQOxT5d61tykDqs6
 BPaNvx9xRx0/2v8JBY1eoglikd0FTq7Q02SOmQpgTGy1Vz8pqbUpAXYE2Kd1rZmROolJ/kLXcB
 7FY=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 03:42:37 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JvZcC6vpzz1SVp3
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 03:42:35 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644493355; x=1647085356; bh=n3PQdYPDIFO8Uwr/FM
        njUNEQTlCYp4IwHIQHnJXVWd8=; b=idYyzbuWd5J26Wgsf/UidoF3uk2l9iFBer
        HAXP5utfToZsJUvShzfFpDPpltYXnIx3DmrMzmM5w0mX24A5BaqITzUR+HCJJ0da
        uqSg+BV+wksYPMSPMvh/su3cgWIxsPJ5qSxBRue8OqzAUyZJtCcHiW5rB1KvKpmP
        Xcf47rFfApLgwKXM0Uo4l3nI+Vv9WjdmwLDQax1Yi1jQDiskab5FpV3zd3l00r+2
        PmuLLVXKcYQbAStkdH6gQEOTKUZENIa1uqZNu4eTdSb//+xv5sEsn+1Op5Sehom2
        QX4Rc/atnsmXlhayq1jYslgau10nS9YA3Cok/ALKbnyDdSuxQwsQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id HxOeoKEIahUc for <linux-scsi@vger.kernel.org>;
        Thu, 10 Feb 2022 03:42:35 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JvZcB3ZYsz1Rwrw;
        Thu, 10 Feb 2022 03:42:34 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH 10/20] scsi: pm8001: fix payload initialization in pm80xx_set_thermal_config()
Date:   Thu, 10 Feb 2022 20:42:08 +0900
Message-Id: <20220210114218.632725-11-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
References: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The fields of the set_ctrl_cfg_req structure have the __le32 type, so
use cpu_to_le32() to assign them. This removes the sparse warnings:

warning: incorrect type in assignment (different base types)
    expected restricted __le32
    got unsigned int

Fixes: 842784e0d15b ("pm80xx: Update For Thermal Page Code")
Fixes: f5860992db55 ("[SCSI] pm80xx: Added SPCv/ve specific hardware func=
tionalities and relevant changes in common files")
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
index 37ede7c79e85..9c7383fb4bdc 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1202,9 +1202,11 @@ pm80xx_set_thermal_config(struct pm8001_hba_info *=
pm8001_ha)
 	else
 		page_code =3D THERMAL_PAGE_CODE_8H;
=20
-	payload.cfg_pg[0] =3D (THERMAL_LOG_ENABLE << 9) |
-				(THERMAL_ENABLE << 8) | page_code;
-	payload.cfg_pg[1] =3D (LTEMPHIL << 24) | (RTEMPHIL << 8);
+	payload.cfg_pg[0] =3D
+		cpu_to_le32((THERMAL_LOG_ENABLE << 9) |
+			    (THERMAL_ENABLE << 8) | page_code);
+	payload.cfg_pg[1] =3D
+		cpu_to_le32((LTEMPHIL << 24) | (RTEMPHIL << 8));
=20
 	pm8001_dbg(pm8001_ha, DEV,
 		   "Setting up thermal config. cfg_pg 0 0x%x cfg_pg 1 0x%x\n",
--=20
2.34.1

