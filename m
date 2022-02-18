Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D9F0C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 03:15:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231886AbiBRDPX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 22:15:23 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:56392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231881AbiBRDPT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 22:15:19 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E6CA120F7A
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:15:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645154101; x=1676690101;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PplX+kDNXdsQ5HZh8arIKafLu+DD+Al5/ujtqhFFtf0=;
  b=ihq3jYrY/AOWAAP52BvSZvF5W1Ed40gmqI0Ie14tgQ5YdbDk7ZMvh0bI
   RZxNbZ065JQAS5F4j+Gk6CKjapCO5icwoen0rnqNswONKRqEwdsSOrDIL
   MLOHMvtMtgOVrSb+uli+OmAVwp0X4xzfq5dn9amgDhwOh2NUUIvT0KAs1
   xyJoWwHVo8gM5+Wbi8y/PLXQ8SCwDf5VHMw6urlywRcPFDVy+UAZ9UNTr
   5qWc6z5LGNK2ho8WdL9xtc3wBiEsc6OUEnd4zme15IolkMLcPXFZhMmPj
   uPuHZn9syPfhe74Q7fNMTmbHCtSr/Qfgld+QjmDrIHGB8d2r7PealhqE/
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,377,1635177600"; 
   d="scan'208";a="194225754"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 18 Feb 2022 11:15:01 +0800
IronPort-SDR: /y2mT2jbQVGq6PPEMXREL/CzdFXecCxuPySTecrvKhth5QwMhV6kH8utChbF6Iu6+Lq2tD/3kB
 G0PZ6mYIWlnSOyqCa7Rk6vxxY+JsnG8aNvs/+H+PD0tYbeT3aBlwge6x493+hrwOn/BLIE5B3l
 HLn4D9KidYjaFN04WUR8iQvr1Kv9pGZmbZtht6Q2LQKPWACGPdYUJcm7FckeHZPMUqZniw435f
 CapvL37oEooM5ApOhTig6eCQcrTF62fi6gyHpvM69SHjnUKjfUmxAY84udW22bGcBGCA5YtcIh
 4EIOfq1OWv4aNp9zugilMpZo
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 18:46:39 -0800
IronPort-SDR: yR+D3La8fum/V0O1mCOU0Aem0kdDpASUMFllyHmNfU/+DOEGjxEpfWoUP9mA6ZOCVHUw8DhXIW
 /3POTAy7JC9SWxZhT5jOFx83meywuBgovuKMSmYQurwVmd9W0xkWeyEMrmB66eMSYHRIYM8I7I
 7Xs7hBHxly+3JWc7/UcRxT9tqvv0bK6H5Z+Y91xc+HLn19RuKtOfZ/hzz2N/2V/r4AVPL/mN7D
 ILa4VYS/H2Kt/0U2HtTxJHh8d30bPVbB4GFTE0xlDeuuQh1Vqdgst9DU9C8m5mUfYEqxG4o/CT
 mXg=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 19:15:01 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K0Gys1jZhz1SVp0
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:15:01 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645154100; x=1647746101; bh=PplX+kDNXdsQ5HZh8a
        rIKafLu+DD+Al5/ujtqhFFtf0=; b=mmEz+2fj+4MA3pe99yPeOzCNRviSRFbSxt
        KuY6n1RIW/L0qFe1HB0h1sp6D2U6pELijzoOzXnAN2MTjgjLS1tiot8npFKjaBDk
        jpZMLtCBVkcFa2OmgGiQzTJMMQkDx7qlTc+2Myvj8m2Ipl+DXYJJG1Hj9iGL7TDK
        fmIHOZrpeCgwZS8a3qPq2H0G0jWm3iGvypcj0DaKNJ0fci2FOg9tHVQmUgIKWD3k
        bhTVekZcgZeRIQTsNaFavDQ3JcBaWEAX1E0WvGZB2PD5Imh4qu2atrj4cvkqkk71
        iOsv5MNUPQpL8jC8eVC79iOBW/Atd7uVN53HnCbuMstbzVYVpyFw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id L8MkZV8DzjiP for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 19:15:00 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K0Gyq5Pxcz1SHwl;
        Thu, 17 Feb 2022 19:14:59 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v5 09/31] scsi: pm8001: Fix payload initialization in pm80xx_encrypt_update()
Date:   Fri, 18 Feb 2022 12:14:23 +0900
Message-Id: <20220218031445.548767-10-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
References: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
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

