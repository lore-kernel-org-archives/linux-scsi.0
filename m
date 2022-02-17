Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C874DC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 13:31:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240995AbiBQNbY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 08:31:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240907AbiBQNbA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 08:31:00 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58C1A2AE2BE
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:30:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645104646; x=1676640646;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Fo+u3tJIh0jVn7uMv+unetkdnajPsN0MoK2SbdL/JbE=;
  b=U9OUOLBzFjI2vwL4PmznrDzbPaxaFtOXpNExcW+CpNKXsEoLUnmSIgBZ
   TvOkgDYZ4oXzGz2lK+ZUVODA6lXlg29iXkATO37Wp7j99Guz29PeUQXMi
   pa9O0SgnYP8GC/uL38kJyf1T/9t3jr5b8j2s/cnhcM3krbhJ2onHr6dDL
   528ni47NBmCjOAk0g7iDEYyUJv5WLEGgwHxf0BBQW1Atz10ylsnwkDtz4
   L3CrzRzLdbAXCOzl7Aag6jdD8ongeY+rrxqd1OvoUIKCGzcpCl/2jUbWM
   TScoqRN+LVdVyhxVnNd6rvwGhLV+HR45kk6PS+QN+1ru0NP4njFDVy4sR
   w==;
X-IronPort-AV: E=Sophos;i="5.88,375,1635177600"; 
   d="scan'208";a="297303253"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 17 Feb 2022 21:30:45 +0800
IronPort-SDR: QjAyuL8dfKAS8R4M6JlPio9+ukvZimzEdXjyYy4VHCqQ4sm5r39Bn8WNsb3A+WLYj6of7vqnj/
 itIivWCEy80N26qi1yAdleyTg97KTDlci6oYq5XgmsEm2BgpYw8IT8M3M+DGc3xQrOfaT0Lud1
 NiJ2fJ9SSGe6ze+cq/fFLGw2JrUnT2gPVcN6JSUSPt07ZusOcu+6thXcCe6QTwDo4wFHxMO33B
 M8WxoKgL8M/jWctb7u4t+SWgAedJ1RMfYkuZXkQDRK47VMR3CqxWiNM2Fn8sfqBYWCP7ICS3Xp
 f6DyKBOU9zukjWSaLZsT3ls5
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:02:24 -0800
IronPort-SDR: OP/deS2KYuujFVXVFcNzyIvfR45ogYYOnmweE8sGvC79PIxhIQ0rYDoZaF29W88xi6bepQRa2S
 Ze944riK67u+FhTW6YWvn5r0EnRWXT2/unfwQ8wBbzZOzwIDGGWIuc6vzC59igoVfhw9z9Yzbg
 ae+f30RjS1E9Yq5eIhsK74kQI2vWFenTHV4h2Qe8VVrxT9G2ZafcsTtaNKB1S1SqbF8e/nNxKd
 v7cvZin5L1uEf0/E1t1gfmjRWHncWEgLTicCvPscykD4hyPsOGbMbdHeYkLxqp+iOEA3spnFB9
 d1c=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 05:30:46 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jzwgn4hgsz1SVp1
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 05:30:45 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645104645; x=1647696646; bh=Fo+u3tJIh0jVn7uMv+
        unetkdnajPsN0MoK2SbdL/JbE=; b=kTkQ8+FzywHs5lVIoiiYejOuJh403YFfyr
        r4p1jDpqk3s2woM+kFtgZuLZx+VF+sbnQ8jEHR9EQ5Rp2Ly0LkyrZ/nkfe79M1K+
        P5JCmJa+E4xAXOW4iIFGieWYEXX9f4Qc2aJ/ls5wMfpgf3UzK6opw5yOrIG808Ae
        Ltd9fDFMoVeiHO/1XfC3ZVMHBaM7KbHHyW3OuFT5/EXeiPHxwRhoddDzjEvE/R4N
        lGb/okgN3kDJmt4MKkn1twsw/B4Vet7PvNxgbJ11c0ipHKNIhxR6LYOnJG2YFfyq
        TW7YIdnToWnkGabx9BPDomrbUpw11CRwhKqtsGayh/XSILDOaOMg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 81AO1T90xNaF for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 05:30:45 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jzwgl459Kz1Rwrw;
        Thu, 17 Feb 2022 05:30:43 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v4 30/31] scsi: pm8001: improve pm80XX_send_abort_all()
Date:   Thu, 17 Feb 2022 22:29:55 +0900
Message-Id: <20220217132956.484818-31-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Both pm8001_send_abort_all() and pm80xx_send_abort_all() are called only
for a non null device with the NCQ_READ_LOG_FLAG set, so remove the
device check on entry of these functions. Furthermore, setting the
NCQ_ABORT_ALL_FLAG device id flag and clearing the NCQ_READ_LOG_FLAG is
always done before calling these functions. Move these operations inside
the functions.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 14 ++++----------
 drivers/scsi/pm8001/pm80xx_hwi.c | 16 ++++------------
 2 files changed, 8 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm800=
1_hwi.c
index c2dbadb5d91e..edf83b8a6bd0 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1748,15 +1748,13 @@ static void pm8001_send_abort_all(struct pm8001_h=
ba_info *pm8001_ha,
 		struct pm8001_device *pm8001_ha_dev)
 {
 	struct pm8001_ccb_info *ccb;
-	struct sas_task *task =3D NULL;
+	struct sas_task *task;
 	struct task_abort_req task_abort;
 	u32 opc =3D OPC_INB_SATA_ABORT;
 	int ret;
=20
-	if (!pm8001_ha_dev) {
-		pm8001_dbg(pm8001_ha, FAIL, "dev is null\n");
-		return;
-	}
+	pm8001_ha_dev->id |=3D NCQ_ABORT_ALL_FLAG;
+	pm8001_ha_dev->id &=3D ~NCQ_READ_LOG_FLAG;
=20
 	task =3D sas_alloc_slow_task(GFP_ATOMIC);
 	if (!task) {
@@ -2358,11 +2356,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001=
_ha, void *piomb)
 			ts->stat =3D SAS_SAM_STAT_GOOD;
 			/* check if response is for SEND READ LOG */
 			if (pm8001_dev &&
-				(pm8001_dev->id & NCQ_READ_LOG_FLAG)) {
-				/* set new bit for abort_all */
-				pm8001_dev->id |=3D NCQ_ABORT_ALL_FLAG;
-				/* clear bit for read log */
-				pm8001_dev->id =3D pm8001_dev->id & 0x7FFFFFFF;
+			    (pm8001_dev->id & NCQ_READ_LOG_FLAG)) {
 				pm8001_send_abort_all(pm8001_ha, pm8001_dev);
 				/* Free the tag */
 				pm8001_tag_free(pm8001_ha, tag);
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
index b5e1aaa0fd58..9bb31f66db85 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1761,23 +1761,19 @@ static void pm80xx_send_abort_all(struct pm8001_h=
ba_info *pm8001_ha,
 		struct pm8001_device *pm8001_ha_dev)
 {
 	struct pm8001_ccb_info *ccb;
-	struct sas_task *task =3D NULL;
+	struct sas_task *task;
 	struct task_abort_req task_abort;
 	u32 opc =3D OPC_INB_SATA_ABORT;
 	int ret;
=20
-	if (!pm8001_ha_dev) {
-		pm8001_dbg(pm8001_ha, FAIL, "dev is null\n");
-		return;
-	}
+	pm8001_ha_dev->id |=3D NCQ_ABORT_ALL_FLAG;
+	pm8001_ha_dev->id &=3D ~NCQ_READ_LOG_FLAG;
=20
 	task =3D sas_alloc_slow_task(GFP_ATOMIC);
-
 	if (!task) {
 		pm8001_dbg(pm8001_ha, FAIL, "cannot allocate task\n");
 		return;
 	}
-
 	task->task_done =3D pm8001_task_done;
=20
 	ccb =3D pm8001_ccb_alloc(pm8001_ha, pm8001_ha_dev, task);
@@ -2446,11 +2442,7 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001=
_ha,
 			ts->stat =3D SAS_SAM_STAT_GOOD;
 			/* check if response is for SEND READ LOG */
 			if (pm8001_dev &&
-				(pm8001_dev->id & NCQ_READ_LOG_FLAG)) {
-				/* set new bit for abort_all */
-				pm8001_dev->id |=3D NCQ_ABORT_ALL_FLAG;
-				/* clear bit for read log */
-				pm8001_dev->id =3D pm8001_dev->id & 0x7FFFFFFF;
+			    (pm8001_dev->id & NCQ_READ_LOG_FLAG)) {
 				pm80xx_send_abort_all(pm8001_ha, pm8001_dev);
 				/* Free the tag */
 				pm8001_tag_free(pm8001_ha, tag);
--=20
2.34.1

