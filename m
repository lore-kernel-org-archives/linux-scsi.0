Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A61CC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 07:48:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347817AbiBKHsS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 02:48:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347800AbiBKHsS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 02:48:18 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF843B35
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:48:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644565696; x=1676101696;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=ZEH58Mx+JDtaj1pUPUFdEIk3VShBFqVuE+ZOslCsQAA=;
  b=pldyjPGp6rvUXwK3Ev8uLtJHI1Z+FEpi+4JOUEs2fyAZgvGjGDGawmnw
   6byWiWvji+keoumjsIEBQe5KazdtEsqxtmyhdtMOnCXbe7t2cTfp9WMRG
   /NbIf+63oGPFqdxLUgwzToy3TauoAW9rPn+GLEM66Dv96kdDjkFzKLqL0
   o2YB3My9Rj1ku3dfxRsoAEeRdPCOFrLFlXaovvnRf5KU8sMGHuaMs+z3g
   /9WzFtGZpB2FAu+whymoiTjXjrOC/sI7W5Xdt75KvygnwtNxREPOBqn56
   HJXnoM0i9iVuQAPDHdbl8tiWFbx74ZRE02Oktpv9ptqdQxSVTrRVWgum7
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,359,1635177600"; 
   d="scan'208";a="192675711"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 11 Feb 2022 15:48:16 +0800
IronPort-SDR: Qu0CimtmBFqdlWK0XNYM1uqFiDN/l8IGA41Jhqs6hwfd2lIjFD2dV1LNKmrEaW5yO+05FD183/
 A6b2syxQroGwspVBQoExG+O9k22LBN8gMeNYykH4Z06v/IgMSRW9zfK93PqGcGh69w+ZCn1Oir
 sZUC71Jw95PLiDmajD9oN14KXz3ILRK0jjWVFwGlSAHddCg46N+qI7RRz/ONzV5lwni38IRhhs
 tCY9fgZo58YeTs+mL2CyerFcwVwO1rCgZkzfoMwhfWjQ6iaMCpGiGD6YXywp0UcHG4e5A3XRcY
 o1qeGBaLfbnhF6p634Nk1Zyz
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 23:20:04 -0800
IronPort-SDR: cCggl333x3uCHvRvEyF22ZPdCJA1VlF6BTLJcXMBNAVEWeRTC7HHLWdwuTByZyfz9A4YGdf4hA
 KBPWXDrcVl9VCsBKLCDSdwhTbeMx9yqOgXlQXqDDFk7t8p6MJ7DVFMBqElsJR/IeYwCbrNBkxl
 rEd7UtM16uLtW1Yu6S7q/Jx7QBFezogPwWBnYGls87JIA3ferO47cbObvTbQ2v6cCJ5WbeLCzV
 tPVItR/FbwM7psWiqY2o/7vkye5bE+4Pn8Ya+iC8zgdoDNoLDgXoUXdVRtotI8K3tJOU1SXBl1
 cb4=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2022 23:48:18 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jw56z0fBxz1SVp6
        for <linux-scsi@vger.kernel.org>; Thu, 10 Feb 2022 23:37:31 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644565050; x=1647157051; bh=ZEH58Mx+JDtaj1pUPU
        FdEIk3VShBFqVuE+ZOslCsQAA=; b=rmtH8Jz0PyugAOT253/GXNlaVeUe5HSDKC
        TI47GluksvmxbxI9/JieOwf7T36d6Vsphsj2XVKzhvr6n1iJDW8u54yeJmldC+A8
        cV4jAPcWK0+185r/kWCpU2COTEMNQ2YFw1djzWtWFYYp5DfutXlGpWtXHZI/1QtD
        ulA9cqYA9y6w338B3epwhXerLejLho9XrGD174DZL7ArhqLve6BtxsmOPO8QBjOi
        kUFzCQFqQ+c1Y2klb4oCa7oc8QztCO4qS8hHPXoqz8fRCQW4FRgwGMT16uQrbIpo
        ysKBSt/FmBmlHifs9z8g/ceqSladAoRA/UXWKQnjyhuWmkTMxZIw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ryb2cqPVLFoT for <linux-scsi@vger.kernel.org>;
        Thu, 10 Feb 2022 23:37:30 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jw56x47LTz1Rwrw;
        Thu, 10 Feb 2022 23:37:29 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v2 19/24] scsi: pm8001: cleanup pm8001_queue_command()
Date:   Fri, 11 Feb 2022 16:36:59 +0900
Message-Id: <20220211073704.963993-20-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220211073704.963993-1-damien.lemoal@opensource.wdc.com>
References: <20220211073704.963993-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Avoid repeatedly declaring "struct task_status_struct *ts" to handle
error cases by declaring this variable for the entire function scope.
This allows simplifying the error cases, and together with the addition
of blank lines make the code more readable.

Reviewed-by: John Garry <john.garry@huawei.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm8001_sas.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm800=
1_sas.c
index e72006a23c1c..7b749da82a61 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -381,54 +381,53 @@ static int pm8001_task_exec(struct sas_task *task,
 	struct pm8001_device *pm8001_dev;
 	struct pm8001_port *port =3D NULL;
 	struct sas_task *t =3D task;
+	struct task_status_struct *ts =3D &t->task_status;
 	struct pm8001_ccb_info *ccb;
 	u32 tag =3D 0xdeadbeef, rc =3D 0, n_elem =3D 0;
 	unsigned long flags =3D 0;
 	enum sas_protocol task_proto =3D t->task_proto;
=20
 	if (!dev->port) {
-		struct task_status_struct *tsm =3D &t->task_status;
-		tsm->resp =3D SAS_TASK_UNDELIVERED;
-		tsm->stat =3D SAS_PHY_DOWN;
+		ts->resp =3D SAS_TASK_UNDELIVERED;
+		ts->stat =3D SAS_PHY_DOWN;
 		if (dev->dev_type !=3D SAS_SATA_DEV)
 			t->task_done(t);
 		return 0;
 	}
+
 	pm8001_ha =3D pm8001_find_ha_by_dev(task->dev);
 	if (pm8001_ha->controller_fatal_error) {
-		struct task_status_struct *ts =3D &t->task_status;
-
 		ts->resp =3D SAS_TASK_UNDELIVERED;
 		t->task_done(t);
 		return 0;
 	}
+
 	pm8001_dbg(pm8001_ha, IO, "pm8001_task_exec device\n");
+
 	spin_lock_irqsave(&pm8001_ha->lock, flags);
+
 	do {
 		dev =3D t->dev;
 		pm8001_dev =3D dev->lldd_dev;
 		port =3D &pm8001_ha->port[sas_find_local_port_id(dev)];
+
 		if (DEV_IS_GONE(pm8001_dev) || !port->port_attached) {
+			ts->resp =3D SAS_TASK_UNDELIVERED;
+			ts->stat =3D SAS_PHY_DOWN;
 			if (sas_protocol_ata(task_proto)) {
-				struct task_status_struct *ts =3D &t->task_status;
-				ts->resp =3D SAS_TASK_UNDELIVERED;
-				ts->stat =3D SAS_PHY_DOWN;
-
 				spin_unlock_irqrestore(&pm8001_ha->lock, flags);
 				t->task_done(t);
 				spin_lock_irqsave(&pm8001_ha->lock, flags);
-				continue;
 			} else {
-				struct task_status_struct *ts =3D &t->task_status;
-				ts->resp =3D SAS_TASK_UNDELIVERED;
-				ts->stat =3D SAS_PHY_DOWN;
 				t->task_done(t);
-				continue;
 			}
+			continue;
 		}
+
 		rc =3D pm8001_tag_alloc(pm8001_ha, &tag);
 		if (rc)
 			goto err_out;
+
 		ccb =3D &pm8001_ha->ccb_info[tag];
=20
 		if (!sas_protocol_ata(task_proto)) {
--=20
2.34.1

