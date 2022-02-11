Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC152C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 07:37:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347716AbiBKHhV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 02:37:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347706AbiBKHhM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 02:37:12 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FA2A10E1
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:37:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644565030; x=1676101030;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=ezAlBnqNea2WEn5Uj/GbU8n5xAcCJpcaHqkuq8Sgjec=;
  b=hf1r0BdfqAKuOJq7JCAjtNzF5BLA1AtIYU8I39jDH/0nkp3VkLeADxse
   1EYGo2GCBOoAc4za0NjC2S+5qMSSxlCwhYnpRTu1nsnQXgpbark3teGJm
   sW0d8fJ1GsJLCiSdftCEz1fMObGJ4M3ngpjEAcSwdZtZb0i7pFHp8QvwJ
   tiCNAva4LNhsrqjAb+jVL7Qw/yJlZqMFtuHpllpzHmvY3C+vQUADE5e5P
   m04mpLkH5yowChYs80J4A17FlOG3Av87QYHjwfelQR5BOYNyIG3C3/X5E
   9A6JyblDnsLv5sLHV/X9AiE1XnP2+GpT/xt/v9eJ+iLS/ewbBZ6df+vZm
   g==;
X-IronPort-AV: E=Sophos;i="5.88,359,1635177600"; 
   d="scan'208";a="192675121"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 11 Feb 2022 15:37:10 +0800
IronPort-SDR: D0R3uMwZKHXrt87CzCE6/e8auuN74dYSRrB4AAYoYFkJ64H3CxOL/ZSlfw/aPg3ckGXOZGp6pt
 dYc8JGbgaxbczggiYOcNj8yRvLhfcfWEHz6DDGee4uv7ETtontcyupHqDRr5yojIbOxy/lyTyg
 vSR0ZFYbXFR+H7lE+Wywr+CpHlA2khTThsEVhfzjCLyenaEO2VPwSbvi8fqRQlRYfMtssRUAFj
 rTNUPQbYU5XpTgXnDwqsZzpxjS5IuO1dl2CYLrNAd4WYzmPXYRCMQXA/t4A+LTptZfUXr/8xnc
 /M10VEfJZPdG12bTay34ZqTu
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 23:08:58 -0800
IronPort-SDR: jV6ZXYJUK7cGXv3ON7wUrqcEIOPxDVxiwH4DTZOEBqx8jXGkQg3wbaJaTGBtmJJaq197la0W03
 tjwyPl4kB/OX/Ru2IURxcYlJQXGxa55kZfWejHD0ejyvu+rsMK6t0k0Nj9wa8Iaa9UbrI9YmcH
 wbQHJrTwMsO8ACsmIB4qACRgCB1d8aZlVn4Lj1sMuWKqoyo7u4Gzn5ppm3MWH8iwon1aPUS8z4
 LXuWlZYe1o7n+swpyMfKN4uoksofTVFVbum/41wOPd6eMpq9oieERMdcbU+rKjKUKepyd236lk
 9L4=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 23:37:13 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jw56c0ZzBz1SVny
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:37:12 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644565031; x=1647157032; bh=ezAlBnqNea2WEn5Uj/
        GbU8n5xAcCJpcaHqkuq8Sgjec=; b=PLTETIK0XOIAM16rrs+LeIHQcenpFq0rbN
        UWnBKmFd56bCaAJ0DHRFKwlxnU73jIJe1RIQS8l3xHLozDV5FFzpx4cIeTbR7Ui/
        3xL9RQdOpdos6cbJ8tM0Vpwb4hpbsy23Yju0J5LlkkNEBs7xmnze5ISpwNCCU1Ns
        6/2PZadVF5ZVZ3ypHB1oMaxU6VwMJ7PA08d/KkLUiYSNl+J8Ii6/vr1WFBGuQV1t
        xG3BJSZXJc0RZu0XyL3iDu9CFssbj7AfLrQ5sqIlVvKbYv7QVnOoOuqH3KhqD33h
        4a5J4dKrjOo23JIjANCtKJIpCA53bDXZH5RODCUmXL7q/Qn4EP6A==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id HgqXKda3EjJx for <linux-scsi@vger.kernel.org>;
        Thu, 10 Feb 2022 23:37:11 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jw56Z5LWBz1Rwrw;
        Thu, 10 Feb 2022 23:37:10 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v2 04/24] scsi: pm8001: fix __iomem pointer use in pm8001_phy_control()
Date:   Fri, 11 Feb 2022 16:36:44 +0900
Message-Id: <20220211073704.963993-5-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220211073704.963993-1-damien.lemoal@opensource.wdc.com>
References: <20220211073704.963993-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Avoid the sparse warning "warning: cast removes address space '__iomem'
of expression" by declaring the qp pointer as "u32 __iomem *".
Accordingly, change the accesses to the qp array to use readl().

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm8001_sas.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm800=
1_sas.c
index 32edda3e55c6..60a56a18e60a 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -234,14 +234,13 @@ int pm8001_phy_control(struct asd_sas_phy *sas_phy,=
 enum phy_func func,
 		}
 		{
 			struct sas_phy *phy =3D sas_phy->phy;
-			uint32_t *qp =3D (uint32_t *)(((char *)
-				pm8001_ha->io_mem[2].memvirtaddr)
-				+ 0x1034 + (0x4000 * (phy_id & 3)));
-
-			phy->invalid_dword_count =3D qp[0];
-			phy->running_disparity_error_count =3D qp[1];
-			phy->loss_of_dword_sync_count =3D qp[3];
-			phy->phy_reset_problem_count =3D qp[4];
+			u32 __iomem *qp =3D pm8001_ha->io_mem[2].memvirtaddr
+				+ 0x1034 + (0x4000 * (phy_id & 3));
+
+			phy->invalid_dword_count =3D readl(qp);
+			phy->running_disparity_error_count =3D readl(&qp[1]);
+			phy->loss_of_dword_sync_count =3D readl(&qp[3]);
+			phy->phy_reset_problem_count =3D readl(&qp[4]);
 		}
 		if (pm8001_ha->chip_id =3D=3D chip_8001)
 			pm8001_bar4_shift(pm8001_ha, 0);
--=20
2.34.1

