Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19759C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 07:38:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347726AbiBKHiA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 02:38:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347770AbiBKHhh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 02:37:37 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C50910E1
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:37:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644565053; x=1676101053;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=AitAV1CBe7kiP6NC834qdZNZdn/41OHpdV7ouBe4kno=;
  b=mDQarEUKPjFIC0wH/166j7C019gMLKHUlsTHELUL/cxEPdK0n9gU30Xw
   hXG2N49NXdqURc1dHtX2yceLaRttU84gA5Cvv9cnmVWPPA+Y+DqiwWYeB
   G7EqMuO/AVhEHwYUbkCq2nRthlIgaN+uZei79RW2cTrdd3U7BchvEYT28
   kPHk1tI8fozPMosSm7QsXmqWT2aukyQn02OVl0SD44r5pEpeIF28pI48x
   JyYM/ujt8hKpdofRmYG66M9YQJxO3ozGg29jFJ5Tdrf7aIM9J4JPVLeP4
   jII9I62vZ7LbDLwcI/TjvANI6CS9ha4gjCn9sHe8R3NpBSZJP5w1UhSvW
   g==;
X-IronPort-AV: E=Sophos;i="5.88,359,1635177600"; 
   d="scan'208";a="192675160"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 11 Feb 2022 15:37:33 +0800
IronPort-SDR: gsVY77IdQCXEJyEG8ye5QEywD/Glnpae4d5YSNznsWC6Y/fn/NYiQQCtPUpwPxFmDT+UO5v5xU
 OfgRxiBNhyTA4eF/VzxtyqOtajDcEsK7P8xZ4uF/aLtcNDBNZMuwIPRU827FZb/ViZlkkcsgdk
 /N5gIdbZqgGPsQvVeJTo63k9y7KOKR2KwB/yXz2ZjyxvfN6z3GM54gdCEiRdmxa4EpSl+P+eK4
 5XM86Ga/tAf4Y/lZmMTOGNt4ZiCxQGleJMj9lgYp1THxiyr/MlGq24NZy6e2SETWJA4pSqMXbR
 6NL3UbL9uKyscHoakMnzYV48
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 23:09:21 -0800
IronPort-SDR: 7HNOpVQd0WgDLzlBXFDOVfur/qJdw3No3CHs0NdkAfXE0vzNntbpBen0yZCl3GZsNF0DjiP24P
 6YAfHgh36RzJmAxWjuvvCcLLj6twNBFflGr9A684oan+LWnMQ0s6WD/H/PJofYvv+h9FR7oo9c
 GI20PwgFSPKAZ9jfmPUXxB2ohyEVC/q6lhZsw4bV4uUbfQEJ7PDt7NlB0AI8if+0ptBP3y3hOf
 igfHOYcUaUt1cSJz7DOJSOZF1Cc4MZwmVf4xjFIbG7ScvdRDsW9Ml1B8UJiTHqM7cCS4U9kq2k
 qVQ=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 23:37:36 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jw57303Vhz1SVp2
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:37:35 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644565054; x=1647157055; bh=AitAV1CBe7kiP6NC83
        4qdZNZdn/41OHpdV7ouBe4kno=; b=gbfwGjTlPQzlR3xxXQjA1HVidEYzg1Ywec
        KLeHVfQqjjvinYRIePro8otazEbz1rf5tGFZisy5Etg4ELsYlisM35TEQhk70Rso
        jjJ6g8agXv0UkboAUTls80K+v4Dnu6Yl582Yn++1K80PJhDatgHo6Ho3BhGbQPXs
        S1PIFn/UfJZKVh38Iz7izEmczb1OyPGy2EUGRB92Up2IikKbBXmeJboHKAEAhfDa
        bAs5eGz3f6qUdwIZgv7/SO5BJtUaTve/U0zJIhuUkcYyXCDlN8aqn3/Zk3ta+OEd
        8RqeJhH3LjP3/lwsnEJbxUMT1TwRlcALN5MynHi317MGDECQkwJw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id XoTs5Zeswc9k for <linux-scsi@vger.kernel.org>;
        Thu, 10 Feb 2022 23:37:34 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jw5713YHfz1SHwl;
        Thu, 10 Feb 2022 23:37:33 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v2 22/24] scsi: pm8001: Fix pm8001_tag_alloc() failures handling
Date:   Fri, 11 Feb 2022 16:37:02 +0900
Message-Id: <20220211073704.963993-23-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220211073704.963993-1-damien.lemoal@opensource.wdc.com>
References: <20220211073704.963993-1-damien.lemoal@opensource.wdc.com>
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

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
index 0cf515844493..ce33d0e71076 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4972,8 +4972,11 @@ static void mpi_set_phy_profile_req(struct pm8001_=
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
@@ -5015,8 +5018,10 @@ void pm8001_set_phy_profile_single(struct pm8001_h=
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

