Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 720B2C433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Feb 2022 03:18:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243399AbiBTDTG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Feb 2022 22:19:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242894AbiBTDS7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2022 22:18:59 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEDE7340CD
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:18:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645327118; x=1676863118;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aFrF4rJ6wByeGWngQJkFybPJUoSWqcmYvM759TiDF+A=;
  b=OV+1oL78fpMUAe89hScN9Rgu+dyQjbhsOj/9ogl7mDLzKpUxCRgN+agR
   PewUXQeVIzornocxKrNlp0AAcdTAFOTcs543FUl47Y7mLmtolK5b0rXTv
   fQTY9g3kapON6butA6cPTagtVmWqAwL7QnCAsLOef84nwqJx8VQ737Eb8
   Lw+or00yOOw5bzHhANr6cnbHTTJR+OO3n3biEKWffBmPc0/MYSyAgBa2D
   XgaoUyJfCOwCxl62yISLed+5FWugHr/sru4yP6bVnd+Dcfa2EYPLDPAIA
   NQPECMpHoiQMScSorU5m/xw6xWpbqOG6UxAa3Aywa3ym8QbBLWtjj+VUm
   w==;
X-IronPort-AV: E=Sophos;i="5.88,382,1635177600"; 
   d="scan'208";a="193405782"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 20 Feb 2022 11:18:38 +0800
IronPort-SDR: j5aSI1t+5CC/QEYivafgiS0WZlqKQzV1IAOLO1ZQ1v/yq6IHAK1S9RhJEs1kPkO1lNdkE20gL7
 VAXU8KHMHbU89nSWLDbc0UpdQOolSEwe57wCV5fW+/19UHBNoueXTxqxrsjC97R4QDU1zbdm2p
 DzA30MqUIXXseBaPA3FZQ55IXu4py4FsR+ue8pWxqKiADjg6Zqny73yiTggwMhXvtfDSdRKjz0
 zJv7MwZWTkZ3T7VAQDaUnzOqLhB4GdEeUd5QZrDqedNCDe1pPyZzqi2/3G4t26T+Jx53MIE085
 9/Y2o24NolZ0Ws8+/U3a5yte
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 18:50:15 -0800
IronPort-SDR: uZ7uMddqGmyY08X9Q4EzODOPHQcsPfBxeEBMTRsjbUy3Lh4zqmqDYZ9RVySHUOZVckQFzeyIRJ
 6pPDFRsy9Rs4HseIN4VZNVY0KVAANUjh6lMwXcqZFyP5O/xPEicCtfxaKRJrSZRqodfzB9eY5B
 bMuBVO9xgZB6NXpmlhHBNv2YWN6JD/8URpdgvQqIfsk+3H5LvQOSbJ/YPr8eQcTEpyVbifzeF/
 6pbPT744XDM5M3niDZIHeRaYfz/dW9LsGOx8ZHWzUlwax+hth7ShkodffABiMTXJt4tb8N8VPA
 UvI=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 19:18:39 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K1Vy70zKRz1SVp0
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 19:18:39 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645327118; x=1647919119; bh=aFrF4rJ6wByeGWngQJ
        kFybPJUoSWqcmYvM759TiDF+A=; b=gwMUfA/DbdWs4VFVI5eJooCdgwjzxNUsaF
        N43SEryvyqvNOZl2xXkDlQPqLQSTclTUzi7QFZkmOoM1SlqONhRkUTXBpCVT+kl9
        Z9+vh3u4PEE3/TAyAi4/xRmYrBIr/w5WykkZZb1ONhHLosrOSZhyqUnGCjEWOVby
        Qw/Dui0X4vQtFAoO2l/05G6xDE6H2IPOzSJnXIg1aaG/7XWi39veFTUx+nIIeQ/W
        7Je1+tt0WaN6e3d0sL0K/PfZ1oi8E37FJi9wnpg+dZVdGEiZyU/tR4vvOLKJHJ8Z
        LTRe8CgWO+rcqiiPGztvIFS4QWTNmiMN+sCdFYrBDFBO2QzUPfow==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id OZOJM7c-wZ-b for <linux-scsi@vger.kernel.org>;
        Sat, 19 Feb 2022 19:18:38 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K1Vy53Dfrz1Rwrw;
        Sat, 19 Feb 2022 19:18:37 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v6 17/31] scsi: pm8001: Fix pm8001_tag_alloc() failures handling
Date:   Sun, 20 Feb 2022 12:17:56 +0900
Message-Id: <20220220031810.738362-18-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
References: <20220220031810.738362-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In mpi_set_phy_profile_req() and in pm8001_set_phy_profile_single(), if
pm8001_tag_alloc() fails to allocate a new tag, a warning message is
issued but the uninitialized tag variable is still used to build a
command. Avoid this by returning early in case of tag allocation
failure.

Also make sure to always return the error code returned by
pm8001_tag_alloc() when this function fails instead of an arbitrary
value.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: John Garry <john.garry@huawei.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
index 8fd38e54f07c..76260d06b6be 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1191,7 +1191,7 @@ pm80xx_set_thermal_config(struct pm8001_hba_info *p=
m8001_ha)
 	memset(&payload, 0, sizeof(struct set_ctrl_cfg_req));
 	rc =3D pm8001_tag_alloc(pm8001_ha, &tag);
 	if (rc)
-		return -1;
+		return rc;
=20
 	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
 	payload.tag =3D cpu_to_le32(tag);
@@ -1240,7 +1240,7 @@ pm80xx_set_sas_protocol_timer_config(struct pm8001_=
hba_info *pm8001_ha)
 	rc =3D pm8001_tag_alloc(pm8001_ha, &tag);
=20
 	if (rc)
-		return -1;
+		return rc;
=20
 	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
 	payload.tag =3D cpu_to_le32(tag);
@@ -1398,7 +1398,7 @@ static int pm80xx_encrypt_update(struct pm8001_hba_=
info *pm8001_ha)
 	memset(&payload, 0, sizeof(struct kek_mgmt_req));
 	rc =3D pm8001_tag_alloc(pm8001_ha, &tag);
 	if (rc)
-		return -1;
+		return rc;
=20
 	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
 	payload.tag =3D cpu_to_le32(tag);
@@ -4967,8 +4967,11 @@ static void mpi_set_phy_profile_req(struct pm8001_=
hba_info *pm8001_ha,
=20
 	memset(&payload, 0, sizeof(payload));
 	rc =3D pm8001_tag_alloc(pm8001_ha, &tag);
-	if (rc)
+	if (rc) {
 		pm8001_dbg(pm8001_ha, FAIL, "Invalid tag\n");
+		return;
+	}
+
 	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
 	payload.tag =3D cpu_to_le32(tag);
 	payload.ppc_phyid =3D
@@ -5010,8 +5013,10 @@ void pm8001_set_phy_profile_single(struct pm8001_h=
ba_info *pm8001_ha,
 	memset(&payload, 0, sizeof(payload));
=20
 	rc =3D pm8001_tag_alloc(pm8001_ha, &tag);
-	if (rc)
+	if (rc) {
 		pm8001_dbg(pm8001_ha, INIT, "Invalid tag\n");
+		return;
+	}
=20
 	circularQ =3D &pm8001_ha->inbnd_q_tbl[0];
 	opc =3D OPC_INB_SET_PHY_PROFILE;
--=20
2.34.1

