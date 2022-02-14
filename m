Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F235C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 02:19:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239279AbiBNCTq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Feb 2022 21:19:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239227AbiBNCTm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Feb 2022 21:19:42 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2926054FBD
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:19:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644805174; x=1676341174;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=5t74Tf5rpwUVmPI1L41m0OpXRpn+VClcyjp+ij7cEw8=;
  b=UOEIfPLUvHjL5r03OWBMtY2dz/lxM8vdrAU8QyWKk+Qn4ZHtq34QLfWh
   YRJHOFP+cELSfekaAPusGoDJ3+eNU5ERgZdwd6KQR8mE68h+sxp6f0vDa
   idN2nlssngVJEfEMowgRXJeBzkQiciG5iGL+mgm9zgvFlFqVLnJzQTqfR
   wV1RIJr4X4xiLA8fqomJY9P1zCnu3/5e6ROL0m54OaANvF5fYdllXJ76c
   6cndZfBe0PMVRcFZJINxsaOPhyGkAVpCESJvO0U220qlmOYX5WkN2ukwR
   FmnJEclLtL+w7o+LeN8epJOeHVGtiLX+t5QpdQhquxvj9RejE5NJR+7l/
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,366,1635177600"; 
   d="scan'208";a="192819752"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Feb 2022 10:19:34 +0800
IronPort-SDR: dbWIuRT4W159ElVQj0+R9c6+K8WnWsrbgesLez3e9F3Q+yPlysvqgPQHSwcD+vRE5CDtIALOO+
 Ww1835xNXeGXevr/EE+hWsDfN8jFC+NO6+b+pjpWUTkZmHN/kuBJAVr5XR9w6nScefN8Qpzm16
 gShqwgQff0WoTu/AhqG3HFGg5jkzmbnJy/zFOxpPsEDqOpdW2gsDTpR+Mx66VDKyJgSfqoCSEW
 BVXO97f1GHAHs2Jq1/XN7LH7wvtSm5Tdm2XVikZB90WqJzZRnX+0fZjwJHRRJ8rqe1Po/8InDD
 MtuXvYW/UvJQ6fQQzu72wA9E
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 17:52:27 -0800
IronPort-SDR: eBd+8ATK5Z4OxSBBzwYT6rSqHHKC3ct6RY5VjzNIIIHMCgiSQPE6lHOZ+xqHZpgfLv8csh/dbP
 +bZV1G/loVpQ8w/TM8XIu8cwRx6fh5QZXgoB8AaZJioVJbsZxGiN2voswOgoml5MPfSiDezyAd
 8KhyWjOI297CTKifv4T4jKHQ8eJC4uLPvxrDVIVK5T1493FEEKQga/1xNZR6V64DWsg0d1A6d4
 ZN4PQdHgXwNJP55Ev4wowYXrpwegQRVQy9jqzVLPh/xapW/vj7/2qi20uEx9d6ExPaW6ogu7AF
 +/s=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 18:19:36 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jxnwl5R5Yz1SVp1
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:19:35 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644805175; x=1647397176; bh=5t74Tf5rpwUVmPI1L4
        1m0OpXRpn+VClcyjp+ij7cEw8=; b=FtmM8gpBYxitzBlskD/5r4XdF+GzdLvF31
        1esgkcjbBz4h71fy3eHkREcjoLPqoWu87cUI0INAChl+4mwLxF0uoUDqH6R6v0MP
        74xM7/C992a+D+017Ud4zuu96RIBQ/8IZVt8Mk/9pPqE07ytHVAA6/8flV5DbjiR
        NFD2+zw+p+PF5jOZrajgcb77yXNdJQAV8NvZcaOojRLF1uwrcvDYHAjk8BMYuQTq
        qSgNW09/qFO4PPzITCl3pUZTaX+eQX99x0Nv8DgaAkawxFzsd+K750z89b7u0cQ5
        /FylRjte/u6eeG/9GKl1I5OpSU3NqrwaGL7YMvQjkk8tfsErxMpg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id j2ctVKfZz-yN for <linux-scsi@vger.kernel.org>;
        Sun, 13 Feb 2022 18:19:35 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jxnwk2Xtbz1Rwrw;
        Sun, 13 Feb 2022 18:19:34 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v3 04/31] scsi: pm8001: Fix command initialization in pm80XX_send_read_log()
Date:   Mon, 14 Feb 2022 11:17:20 +0900
Message-Id: <20220214021747.4976-5-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
References: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
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
index a9decac0b5cc..dff859bc5501 100644
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
index 26b64524e327..aa0c4566db4f 100644
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

