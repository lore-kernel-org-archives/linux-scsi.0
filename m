Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8399DC4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 13:30:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240908AbiBQNaY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 08:30:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240620AbiBQNaT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 08:30:19 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8381F2AE709
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:30:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645104605; x=1676640605;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nIVG0sFjkIorcrheJ1UfoRawD5kq2+itLtArlFm6OoA=;
  b=Y1YWM5Dr07H+gQvI3+3ndPH/j0TeiwCZ/F7ixLGkqQciIT1hkQF6rNZS
   avUhGv12FbGKSf+B24We3i8HoVEqHak9oBzEUC9EQptGrbBndhsDenh3v
   uBXo14I8URQ9N0ee7Y+vtUxi2NNC+Nq52jbmy/PChVSOF9ArqL7Y/CiQy
   Pkp0OXxOGQGOWeg1+TkgI4D5l3LMMGFCZRZHJnxC51bjU0p4FqdaWZ+PP
   r3I1hoGEV1efyI0rEIRmy5b5AWsf9oWXsTN9Fc/Vl+RpFNvpmY9T6azsK
   d8QBpbSZidR4TqUMZrmCpJrv+oXjUqN3pW68bgFMufxeolOcoCdRQFNnJ
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,375,1635177600"; 
   d="scan'208";a="297303136"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 17 Feb 2022 21:30:05 +0800
IronPort-SDR: nZvcAY/RBg/Yn3rvX5y0BtHy5FBU0jutn4I8k3+/d4m6IqNxAc4Wd7PCRZpsDaZIPskyDZRPyM
 DGPOl2W3De4BVug7h5mvHlJ48LBKqbDmapoMZGj8ETaWVzrEl1t6Q3BsHTt6TEgAtfqTl7hxYb
 t0pV5hmiE1mIipN0HcoirpYcQ0yvRge9/HNo6E8DRsxTM7Y6xizLNEwhMgcMUS2HOsq/ko3MgB
 PxtA39thlDvZsmRBhT/Wep5ah4iE6ybkU+rYorbhteY8NxFs9GipjWGa+TX9siTIyHjORFV5TM
 5b6SAOT15AMKdNn/wrFGxk69
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:01:44 -0800
IronPort-SDR: iLA12uWmOmv4f+gA8HCDUTJiwvD+QGag2Mpy0o/WdKoP0RMDI9EBH7QCS/pmDzbr6lyJ5tTmXT
 4Zz8/Pc3K5IBhm43ljIwUjXIwc9Rj9pxXYtKVfa9L68AxL2vmK2p4GsZ3OIW1X57UspoP0sIF+
 xwiIbr0qAOi9WXRoOfT405Rk9k1Y4/749iCaz0CthxgOmrEa6Bdi3SmXHEsQW9forRBR2wQbPt
 qU7e3OMpP+MjFKggd5mWjdHHW9EgTiDudQ3qbhGKcaCzrNZa+MqlhoZ+f3utHN65iviiQi7MvK
 Rp4=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:30:05 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jzwg10TxLz1SVnx
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:30:05 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645104604; x=1647696605; bh=nIVG0sFjkIorcrheJ1
        UfoRawD5kq2+itLtArlFm6OoA=; b=LFab5CraCQAfiK7/zLyx87YzEvEwGi6Sgj
        pM9ubCu7ypHmiaYOgpKb1veyEqvXzkcG0MTI74s0isfPfijI/Or96IUg0LasnSwH
        44Zu7lAjyBHjKps4ozEcaq/rdb4IpSSrLlCTJ4xzTeVg9B5qUMqhG4MBmPz4OVrL
        cssBFzqT3tA73jv65mqBBRuOx+zqLFw439VZstwPP1FQ99U0+p0HZ8pHUqHo7u5e
        2Bb1gsxhT8RiZfjVnURi/1bNpSIKqpMDcLc7ClO06EumRo99TdeGhqqPD/eEiE6f
        HewndbI+wRgyZOoQyqsFqK3i3OKZSXO7hKWy8ieZDabqPJ0xTt0w==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id kLpB2OhirWdx for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 05:30:04 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jzwfz45X4z1Rwrw;
        Thu, 17 Feb 2022 05:30:03 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v4 04/31] scsi: pm8001: Fix command initialization in pm80XX_send_read_log()
Date:   Thu, 17 Feb 2022 22:29:29 +0900
Message-Id: <20220217132956.484818-5-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Since the sata_cmd struct is zeroed out before its fields are
initialized, there is no need for using "|=3D" to initialize the
ncqtag_atap_dir_m field. Using a standard assignment removes the sparse
warning:

warning: invalid assignment: |=3D

Also, since the ncqtag_atap_dir_m field has type __le32, use
cpu_to_le32() to generate the assigned value.

Fixes: c6b9ef5779c3 ("[SCSI] pm80xx: NCQ error handling changes")
Reviewed-by: John Garry <john.garry@huawei.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 2 +-
 drivers/scsi/pm8001/pm80xx_hwi.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm800=
1_hwi.c
index 4683fee87b84..817bba65feb3 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1864,7 +1864,7 @@ static void pm8001_send_read_log(struct pm8001_hba_=
info *pm8001_ha,
=20
 	sata_cmd.tag =3D cpu_to_le32(ccb_tag);
 	sata_cmd.device_id =3D cpu_to_le32(pm8001_ha_dev->device_id);
-	sata_cmd.ncqtag_atap_dir_m |=3D ((0x1 << 7) | (0x5 << 9));
+	sata_cmd.ncqtag_atap_dir_m =3D cpu_to_le32((0x1 << 7) | (0x5 << 9));
 	memcpy(&sata_cmd.sata_fis, &fis, sizeof(struct host_to_dev_fis));
=20
 	res =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &sata_cmd,
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
index b83500ef3d86..f1663a10693a 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1882,7 +1882,7 @@ static void pm80xx_send_read_log(struct pm8001_hba_=
info *pm8001_ha,
=20
 	sata_cmd.tag =3D cpu_to_le32(ccb_tag);
 	sata_cmd.device_id =3D cpu_to_le32(pm8001_ha_dev->device_id);
-	sata_cmd.ncqtag_atap_dir_m_dad |=3D ((0x1 << 7) | (0x5 << 9));
+	sata_cmd.ncqtag_atap_dir_m_dad =3D cpu_to_le32(((0x1 << 7) | (0x5 << 9)=
));
 	memcpy(&sata_cmd.sata_fis, &fis, sizeof(struct host_to_dev_fis));
=20
 	res =3D pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &sata_cmd,
--=20
2.34.1

