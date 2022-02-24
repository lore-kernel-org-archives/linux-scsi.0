Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D0E5C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Feb 2022 23:31:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233982AbiBXXbd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Feb 2022 18:31:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233258AbiBXXbc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2022 18:31:32 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81D66186B82
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 15:31:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645745461; x=1677281461;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=zdVLbzhYla2YZaTACujeWEbgVYGpiiXXLA0O0Pmn0YY=;
  b=gQkuQrCKb4/9iKIaWjamb25MPiKzx2NvZcMhdsG0KFtt0ZLS4zVrV+eV
   nrMNKP2FxL+DY9VkZGSCfDI4119lUA7d1148yv4gCZYxWuDx03QzRbpXL
   MH7uhI0hlKDPeDu4vUNLEubbS3GNbZh4JrFQKLlN9UZCQ+Vt/UDcl02tT
   Z1R09iWB0fyKpxZR3TCaI18fiwOS/x1e0CuBdVB7+su3JNMulLyIcCirS
   +rUJxd81UyTr19eVlCcf5G47cR1lr7IFjiWK4d9RYCQr+0VsLzTHjrmZn
   H/nD5rZW6FYLXpXR06gkNh0yifkZEOfv/nyJGwzBgLGllWgAy7A2Duvpg
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,134,1643644800"; 
   d="scan'208";a="192821970"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 25 Feb 2022 07:31:00 +0800
IronPort-SDR: zwYaq4yHahh8RhZE0uqojBBIPfxlPNw2ugZP0xI9eRfg282LtbBd9h3bpbfZaOFFig+jVHDjA6
 AZNYH4rNeEUiKQZdvAMjajY2xSF2bnhCvXfEwxU/yJIV7di2F0BFns+qzxffrVHt8wj/AwVPF+
 zTMzdAhoWpLE2WgsIFVLv6TZj6pI3g6LgCQ9Lkx9zwZd9UarnzdZube7b3NaQVL9o0f4IbfVat
 nF67NYoXCqKpxw+leDKyKPP14OzuMzTLX9R3YmE1pv0MFzk3mys/hW8e2g0tXLVV05eJeERdOf
 PJwX4FwuX9ZK8dwTp+43PFVq
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 15:02:30 -0800
IronPort-SDR: aDVklyWh+BSemyOSO4/jvCJEHTKUs1AQ5MQfgi7wiS3bQJq3bzjuJ+i82bbYf4ssyMZkMcf/v7
 3aj9QkRoKwbRNkGPuu/2Fd28RS47puQCTkSzaWeMzgIWbNQawkEBGK54SoA7qPJYC8Jaqge6PT
 8H496AodaaYNp76xjIuhJ6R5a1Rfuw02iaqXxTQF0l7OGHafWNjQB5DYEYbqyBMq/zQFD//uMs
 RPN+u0vrp3zSH6pILebWzkUKH8rShJYCI6uIZmSyX5tA/zD5jsTRuysxgQCeuo4Jq94K89UZpb
 FIk=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 15:31:01 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K4Tg84Swjz1SVp0
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2022 15:31:00 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645745460; x=1648337461; bh=zdVLbzhYla2YZaTACu
        jeWEbgVYGpiiXXLA0O0Pmn0YY=; b=m1fgOPbmSxNtS6ipCY6Wax/FbMLCuFCIic
        YBnSr6XC2y7r5gK5iOuJsFCtTziAIZSUdorFXcMInAaODnZqdlpSf3sFI0yvhRzO
        Zv67RSYVyxvTbJierN0aVEA7ec214x+vhgPxUcB44r86EsDc4KG6EVJ36DlZFwfu
        UAjCG08zlj/8VXF97rr/7dLFvXFRKQTS1dN1s0H/eLRtAdTw8LoxH+M+/jnkjd51
        bzLSYIxD2rBOL02h7BuJ7McgC8H6g26g7rY+dSowgTlZ1DCS2KDMXwyQnR8Avl1j
        sjLUM/WGYexkBDwjO2rcwIBIruqVTFMRcdYK2QOA1eup+Dtr1zyA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id X4KEhPwX3qkq for <linux-scsi@vger.kernel.org>;
        Thu, 24 Feb 2022 15:31:00 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K4Tg718nNz1Rwrw;
        Thu, 24 Feb 2022 15:30:59 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH v2 1/5] scsi: mpt3sas: fix _ctl_set_task_mid() TaskMID check
Date:   Fri, 25 Feb 2022 08:30:52 +0900
Message-Id: <20220224233056.398054-2-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220224233056.398054-1-damien.lemoal@opensource.wdc.com>
References: <20220224233056.398054-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The TaskMID field of struct Mpi2SCSITaskManagementRequest_t is a 16-bits
little endian value. Fix the search loop in _ctl_set_task_mid() to add
a cpu_to_le16() conversion before checking the value of TaskMID to avoid
sparse warnings. While at it, simplify the search loop code to remove an
unnecessarily complicated if condition.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mp=
t3sas_ctl.c
index d92ca140d298..84c87c2c3e7e 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -578,7 +578,7 @@ static int
 _ctl_set_task_mid(struct MPT3SAS_ADAPTER *ioc, struct mpt3_ioctl_command=
 *karg,
 	Mpi2SCSITaskManagementRequest_t *tm_request)
 {
-	u8 found =3D 0;
+	bool found =3D false;
 	u16 smid;
 	u16 handle;
 	struct scsi_cmnd *scmd;
@@ -600,6 +600,7 @@ _ctl_set_task_mid(struct MPT3SAS_ADAPTER *ioc, struct=
 mpt3_ioctl_command *karg,
 	handle =3D le16_to_cpu(tm_request->DevHandle);
 	for (smid =3D ioc->scsiio_depth; smid && !found; smid--) {
 		struct scsiio_tracker *st;
+		__le16 task_mid;
=20
 		scmd =3D mpt3sas_scsih_scsi_lookup_get(ioc, smid);
 		if (!scmd)
@@ -618,10 +619,10 @@ _ctl_set_task_mid(struct MPT3SAS_ADAPTER *ioc, stru=
ct mpt3_ioctl_command *karg,
 		 * first outstanding smid will be picked up.  Otherwise,
 		 * targeted smid will be the one.
 		 */
-		if (!tm_request->TaskMID || tm_request->TaskMID =3D=3D st->smid) {
-			tm_request->TaskMID =3D cpu_to_le16(st->smid);
-			found =3D 1;
-		}
+		task_mid =3D cpu_to_le16(st->smid);
+		if (!tm_request->TaskMID)
+			tm_request->TaskMID =3D task_mid;
+		found =3D tm_request->TaskMID =3D=3D task_mid;
 	}
=20
 	if (!found) {
--=20
2.35.1

