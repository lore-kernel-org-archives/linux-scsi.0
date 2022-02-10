Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2CFBC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Feb 2022 11:42:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241162AbiBJLmq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Feb 2022 06:42:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241145AbiBJLml (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Feb 2022 06:42:41 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81DAE13B
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 03:42:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644493360; x=1676029360;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=IDp1iLLUHH7ab3+nq5Z7yLB/vbG5eCYWsAByfVoKrUs=;
  b=aVrOVQ87Jy9ai+aGezkliTg1BhXLIlQYogg/163TkhEcqhP12CDdNmXP
   zyyoo3eXleVKtOjauxvi1xSS9PgnY8qgbBJZE2xUCfTymJ8hBgxXV7XRo
   5tu9bVNs9vR1DjwfvigRGlsj7NyeZcMRR8VSC6yKAGgtUBeOuFWnDxN0e
   E+Xrh1MIqHM3/RI/jji0d0ocSOIhvQIJqB2teq1LU9E5vp1ayTOA9aHWG
   TiNJMcHK++QoHV0hwon1CUre2PsjkGSjAsHv2Vg6vRI5CmYVu+GZ2DBVN
   5TkDhhJU+1Tem97duG5S4Ad/qNbuiWYDh4JtM1S9i1w7ytBv3iU9XVrEy
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,358,1635177600"; 
   d="scan'208";a="193575652"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 10 Feb 2022 19:42:40 +0800
IronPort-SDR: MHuvEKje3qxCdfhPH+qycVwKx2+N5Fd39zZrDe9bzzvin3iFG8WkSRHtb8cB5wdQWrFe7DKmR1
 q+szucwj2+I98+tuyyA+nlLvNneN2caPu7mD1MJ9SUe3ldVoBVkb1jWWP/DuVQ61LgEnRuUwlM
 u8npBPhWG+NUHmApF6i9xSLxOSpa8uo1oL+u/0MvMqjvQ2JA/yiUY5K0GpffadEhY1DYfOcczF
 pbBF0E3Cd3pFXN9Zew58/Scw0aP4yEpfGBuQlUTMYpRIDbyegEPB7LZkDLVPaGlPFXYNM+857k
 4ur4654RjEtz8FP0XTdyV28h
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 03:15:35 -0800
IronPort-SDR: piPFkLQ1lPi/iRNOi2F6ONAVxotphakxEUWrjuV47hDFN0i0b/VHFaJY5I+falKogNBTT8qBP8
 UdkV/VEM0meRQKMtNc0BhoDW27dYejebKp0s9yfM5ooWRzSJazloOc/QjZlv3UHoBcpEjaLbdF
 ZICxWGDU0168BDgA26+377LfYhau8lmEtFEU/cnUnM46I11pAYktHzu52yso62TPRHB6m5T7/3
 tHMzJYYmYXC2bI7aZkW/lBhF5wWkTkMp+C/wMRMI+t1Iinrf2mWbkc9ow3sr9kp7kBstXomzEx
 ErI=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 03:42:39 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JvZcG3bgmz1SVp1
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 03:42:38 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644493358; x=1647085359; bh=IDp1iLLUHH7ab3+nq5
        Z7yLB/vbG5eCYWsAByfVoKrUs=; b=Pz8g5JnPPe5g+WOYqyeRVxKX3S8OWq/eBj
        dR+R/KCuRxiLcMMq50VPaaREyialVKkSyslsPVhMXMEhdyAGGHKkvEcaf7Y9L3HA
        opQuYXs/l16Pubsmnzcn+fhZtTLqS/03DoEMaWCrZCRIryCGzXzxch59iDIwyWCF
        tE68EXFaKGjlmPQrmSn8wkPWznIUlWwjB7Tg+Jo02ZQMj/8DV7cjme7rba34qBGZ
        7k4u8NuTqMVlD5GN3IyA9dWoyNZZMu0/8sV1KiTcdYDnL+pnG8Rv398NZhrardxq
        W+cEsQor2gSxY1+HtCafPGoYHmx3GDE8x3a3pmQO+9Sy86BEHxTA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id NtTto2umYdBi for <linux-scsi@vger.kernel.org>;
        Thu, 10 Feb 2022 03:42:38 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JvZcF0SJ1z1Rwrw;
        Thu, 10 Feb 2022 03:42:36 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH 12/20] scsi: pm8001: fix payload initialization in pm80xx_encrypt_update()
Date:   Thu, 10 Feb 2022 20:42:10 +0900
Message-Id: <20220210114218.632725-13-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
References: <20220210114218.632725-1-damien.lemoal@opensource.wdc.com>
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
index 84322d694391..d37599a94003 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1406,12 +1406,13 @@ static int pm80xx_encrypt_update(struct pm8001_hb=
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

