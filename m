Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E839C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 07:37:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347724AbiBKHhY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 02:37:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347710AbiBKHhR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 02:37:17 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 147D1110E
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:37:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644565033; x=1676101033;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=P9yKSBo3OyVYkqFAXqh6trK7u1E1pTxqRHMhtoDQwHQ=;
  b=mvep1uHBaTQXRuK+efUHnw9jlycNksvWMWDRIlqt7HzgVrnXneiRCLMb
   BRG2is9q7x7N0ia0erPgdyPGcLPe9ulo1gj7/+Q4rNrUI36CJTTqV71Xk
   6TbXQCPwfIB61VqxV+OfF6xe7qYABdvpDrOIhvC3X1UwRpS9tdpPhqtSG
   2Uw6jOvGCt8QUBJ1TW8d0hRraoXyWvRA/1VQiILXkZGWMURMe/hUOpKhN
   y1eXPklggZq0oP7BYfeYw6iyHJJOlxBeISPLS33xnDJHFBJ5BwLDiMz2j
   2itZuNEUr2nXRlCzno0hI0NiA/Psy4lDTV4rMWERt5EeRI73xkEYc+XlS
   g==;
X-IronPort-AV: E=Sophos;i="5.88,359,1635177600"; 
   d="scan'208";a="192675130"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 11 Feb 2022 15:37:13 +0800
IronPort-SDR: bLwOMNIH91/unH+SK82P0Md/1ZEdLNPqhCjflFomZyt/bBYSn0DHplQ0zJMEhklI9FFiRZgNNd
 AHMmrCuHFhY5mwgKMGW3yPVXFcL2h11NQN+WYKW0GzHsi/XtRj2Iwab4ucGyJAHYO2qarA9HXn
 vb1cWZ3NtOE+Csg1ZSsWGg828DFqbf71lZY7hPFF3eLkRpC0DEmWjsklivvG7UNCMdzvULm6Kh
 MCIIgua+Jc3nn/1sQu0w5tRNHqstAltME9gLT/HtsdknAIiNqLze3NRMSzuNqf5WxJYxJ7e7KB
 FgGtxTQdyB1Fr2id6gUWrl3g
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 23:09:01 -0800
IronPort-SDR: E9hqOJpssq+2GyCdMCXB7Ca8Qhdetk2Q4oHsjMmc1TfRPeGE2FctcwXNmg5Hy0u4s6LfryBodE
 1LCPzt2VL56oPh4G52HIMq2W6px9+jZ7EHZtq8KSt9+enuZcNoYi21sWhzn2fPClSjHZJT4tlE
 1MOfIhrjIo89iSa2qd/AfNutjHhk1k5qZwrOko4TNRDXgu4MeDS+eb+bEfAScCZ/s0s66q1vbY
 4k85BbmCMUnYlvk2P/dNLkJktmOSz3Hcsd8RC9ggaPwb+jD39pyLnubwfwe3mmZaGW8SFbWqDe
 7GU=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 23:37:15 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jw56f4f6lz1SVp3
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:37:14 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644565034; x=1647157035; bh=P9yKSBo3OyVYkqFAXq
        h6trK7u1E1pTxqRHMhtoDQwHQ=; b=CdGpCgbZHSF3xhe9zIvAhnZFVHU6Ju6ZGY
        gXPJnkQ14Hl1NAoW/qknzwhsScOoGwdYo0mm9luQP0flooNuGJ14Yar6xnEOdES5
        q1zUP9PLWPCl6Z1kuWT/BHBN+RWHxffJh9K+UgvbW8gqVGpkLaYMY3Niuy4S1aVO
        n8LWc8JmOZo3ozSJd6BiMK6+5WtXao+wk5J+cqO+z94cQ3Vv1fk1xxk0QtePcgK2
        mHPbHmMwnYeV47xJ0GaEV08DSu/sqlZMPKfW4jjny6awMeTLu7a5AQt4QbvRhIXw
        jbkbsPvx3/osmshsLeCIEOmVGrl7s/Wmx0T7n3ZQB2NpeuugKGHw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id X4_236lCJ0Xn for <linux-scsi@vger.kernel.org>;
        Thu, 10 Feb 2022 23:37:14 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jw56d1n1Vz1Rwrw;
        Thu, 10 Feb 2022 23:37:13 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v2 06/24] scsi: pm8001: Fix pm8001_update_flash() local variable type
Date:   Fri, 11 Feb 2022 16:36:46 +0900
Message-Id: <20220211073704.963993-7-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220211073704.963993-1-damien.lemoal@opensource.wdc.com>
References: <20220211073704.963993-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Change the type of partitionSizeTmp from u32 to __be32 to suppress the
sparse warning:

warning: cast to restricted __be32

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm8001_ctl.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm800=
1_ctl.c
index 41a63c9b719b..03aff0ba3657 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -721,7 +721,8 @@ static int pm8001_update_flash(struct pm8001_hba_info=
 *pm8001_ha)
 	DECLARE_COMPLETION_ONSTACK(completion);
 	u8		*ioctlbuffer;
 	struct fw_control_info	*fwControl;
-	u32		partitionSize, partitionSizeTmp;
+	__be32		partitionSizeTmp;
+	u32		partitionSize;
 	u32		loopNumber, loopcount;
 	struct pm8001_fw_image_header *image_hdr;
 	u32		sizeRead =3D 0;
@@ -740,7 +741,7 @@ static int pm8001_update_flash(struct pm8001_hba_info=
 *pm8001_ha)
 	image_hdr =3D (struct pm8001_fw_image_header *)pm8001_ha->fw_image->dat=
a;
 	while (sizeRead < pm8001_ha->fw_image->size) {
 		partitionSizeTmp =3D
-			*(u32 *)((u8 *)&image_hdr->image_length + sizeRead);
+			*(__be32 *)((u8 *)&image_hdr->image_length + sizeRead);
 		partitionSize =3D be32_to_cpu(partitionSizeTmp);
 		loopcount =3D DIV_ROUND_UP(partitionSize + HEADER_LEN,
 					IOCTL_BUF_SIZE);
--=20
2.34.1

