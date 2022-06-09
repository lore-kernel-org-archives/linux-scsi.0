Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0985BC43334
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jun 2022 02:25:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236703AbiFICZJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jun 2022 22:25:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236634AbiFICZD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jun 2022 22:25:03 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2044F1D81B7
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jun 2022 19:25:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1654741503; x=1686277503;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=0JQQvXQ5K3VvZl36WY/dYo6dIIQ+Ya7q+dJvDPmd6Kc=;
  b=aIT1uaZNPhbiNaZAOcmVOHK/7J83+bD+UJpsrj+aWEzzQ6s22zJ+/7gI
   78yIx3eQ6aLhxkCgC6eTVWB5cvqtpW56Elln2081+zIdKiAeOZEn7ZZAy
   neRO2hUF+sf/tPUKvJOXWmyDLcO/2R05C4AoCCyuqAzUCa90CyfFYU3oo
   BC9aut49aGEef38T6ZmZ5a+IPzLC16p27sP0RL1hc2kkSvIkixCZf9AqI
   Rd1OsnXfXpihQsX0+SskEiV+9olkYBKDg6XYOOl+7h7HQp1Bd1G5s0AN0
   d6bN2HUhPSs24gGP7y9i5MWrdLj1qxwQ//zv6SRceDTr5ECzdMEYyqFMT
   g==;
X-IronPort-AV: E=Sophos;i="5.91,287,1647273600"; 
   d="scan'208";a="314703271"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 09 Jun 2022 10:25:02 +0800
IronPort-SDR: Fue2kXVPy/TnJQAGQcB1sDbj9XMGA8MbCuIXx+GXnw1nA6rdicX3vhb+T0WjuE0MqrkIHFC7dT
 hi4Roigo4gDd8HtwZJXKjsPV4/KPYJFa5Nl+rBXBO014vGPeQ5tYsZwJuW1xjbljOsZ9AQoxU4
 MsZfef3Jk+xS8MeR1Ic5w7rOmlPbRDecQlxt5LyKj/vVkC1owmu+51mLHYmVP9g6uRvfc89lSo
 cP1ciMbBd0843ImL6q6Yegk3UHztr7E/H7khFcnDUBXdJ3yg2t1hYOn86oguzHnnE+uNKlc5I2
 Butr2nMCIbZBvCE2B9Ga/uCT
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Jun 2022 18:43:51 -0700
IronPort-SDR: 1DmiNJa7aZGeKEJsjvqhBgSHvGQvlbKZKEDP/WepTWG9ARyIjFRfoAQFVbrDcCCggwSIRNo9jw
 V/rWWfB8RrRus3iZbXa0rM1l/+P5xAqV5u+y6ES46Y0dRAojRoghoVdhl6I2Bpps7kLlfmJEVb
 RLUk86ds87mDeSmHpiqbDLLP3YyI/EPmQksbsr2AUeZp4f2v5IM6Hi5bnDjHrxvw5YyQPZ/CMA
 tFHAl1z36uHw0DGfib5eohWfM89p+Nu0H0L0sjJvuXG8gk+EMNgRnvz7gFS+6HUPBgzTsbWDGC
 OHg=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Jun 2022 19:25:02 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LJSbx592Mz1Rvlc
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jun 2022 19:25:01 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1654741501; x=1657333502; bh=0JQQvXQ5K3VvZl36WY
        /dYo6dIIQ+Ya7q+dJvDPmd6Kc=; b=AopHRzSVIvnnE8MWTrnYvnJkuceJAcp1F6
        SatWID95BQAfmeRJemMF9CGispFdZ9Uey72r7dYzy0/XtYp1hWQxk/voHCkQc9T6
        syhaX6wDbN+mHMem29jFhABb+LC4SeWaZj/zeKon2D9uHI19iPf9TqbSX7tSeSt2
        7pFwMbpWZ6sTOPAa0AnmEN+Gs/RqE3gxe4YyNiNxElmBEOeqcYQrTBsf8ZKYN9em
        AsUTLpe43pIWcPTx/Bb4EIAF0IHyAihdTtRFrJKw0Bb9HmpbHLiUVTPyqzetst7J
        hKlxW7lsBgh7IuzfXux8GB3wxef+2Y594ua5IZVxqUdbZZWUBuDQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id NKYqSiJ87zXr for <linux-scsi@vger.kernel.org>;
        Wed,  8 Jun 2022 19:25:01 -0700 (PDT)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LJSbw5Sckz1Rvlx;
        Wed,  8 Jun 2022 19:25:00 -0700 (PDT)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH 3/3] scsi: libsas: introduce struct smp_rps_resp
Date:   Thu,  9 Jun 2022 11:24:56 +0900
Message-Id: <20220609022456.409087-4-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220609022456.409087-1-damien.lemoal@opensource.wdc.com>
References: <20220609022456.409087-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Similarly to sas report general and discovery responses, define the
structure struct smp_rps_resp to handle SATA PHY report responses
using a structure with a size that is exactly equal to the sas defined
response size.

With this change, struct smp_resp becomes unused and is removed.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/aic94xx/aic94xx_dev.c | 2 +-
 drivers/scsi/libsas/sas_expander.c | 4 ++--
 drivers/scsi/libsas/sas_internal.h | 2 +-
 include/scsi/libsas.h              | 2 +-
 include/scsi/sas.h                 | 8 ++------
 5 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_dev.c b/drivers/scsi/aic94xx/ai=
c94xx_dev.c
index 73506a459bf8..91d196f26b76 100644
--- a/drivers/scsi/aic94xx/aic94xx_dev.c
+++ b/drivers/scsi/aic94xx/aic94xx_dev.c
@@ -159,7 +159,7 @@ static int asd_init_target_ddb(struct domain_device *=
dev)
 		flags |=3D OPEN_REQUIRED;
 		if ((dev->dev_type =3D=3D SAS_SATA_DEV) ||
 		    (dev->tproto & SAS_PROTOCOL_STP)) {
-			struct smp_resp *rps_resp =3D &dev->sata_dev.rps_resp;
+			struct smp_rps_resp *rps_resp =3D &dev->sata_dev.rps_resp;
 			if (rps_resp->frame_type =3D=3D SMP_RESPONSE &&
 			    rps_resp->function =3D=3D SMP_REPORT_PHY_SATA &&
 			    rps_resp->result =3D=3D SMP_RESP_FUNC_ACC) {
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas=
_expander.c
index 78a38980636e..fa2209080cc2 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -676,10 +676,10 @@ int sas_smp_get_phy_events(struct sas_phy *phy)
 #ifdef CONFIG_SCSI_SAS_ATA
=20
 #define RPS_REQ_SIZE  16
-#define RPS_RESP_SIZE 60
+#define RPS_RESP_SIZE sizeof(struct smp_rps_resp)
=20
 int sas_get_report_phy_sata(struct domain_device *dev, int phy_id,
-			    struct smp_resp *rps_resp)
+			    struct smp_rps_resp *rps_resp)
 {
 	int res;
 	u8 *rps_req =3D alloc_smp_req(RPS_REQ_SIZE);
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas=
_internal.h
index 13d0ffaada93..8d0ad3abc7b5 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -83,7 +83,7 @@ struct domain_device *sas_find_dev_by_rphy(struct sas_r=
phy *rphy);
 struct domain_device *sas_ex_to_ata(struct domain_device *ex_dev, int ph=
y_id);
 int sas_ex_phy_discover(struct domain_device *dev, int single);
 int sas_get_report_phy_sata(struct domain_device *dev, int phy_id,
-			    struct smp_resp *rps_resp);
+			    struct smp_rps_resp *rps_resp);
 int sas_try_ata_reset(struct asd_sas_phy *phy);
 void sas_hae_reset(struct work_struct *work);
=20
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index ff04eb6d250b..2dbead74a2af 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -145,7 +145,7 @@ struct sata_device {
=20
 	struct ata_port *ap;
 	struct ata_host *ata_host;
-	struct smp_resp rps_resp ____cacheline_aligned; /* report_phy_sata_resp=
 */
+	struct smp_rps_resp rps_resp ____cacheline_aligned; /* report_phy_sata_=
resp */
 	u8     fis[ATA_RESP_FIS_SIZE];
 };
=20
diff --git a/include/scsi/sas.h b/include/scsi/sas.h
index a8f9743ed6fc..71b749bed3b0 100644
--- a/include/scsi/sas.h
+++ b/include/scsi/sas.h
@@ -712,16 +712,12 @@ struct smp_disc_resp {
 	struct discover_resp disc;
 } __attribute__ ((packed));
=20
-struct smp_resp {
+struct smp_rps_resp {
 	u8    frame_type;
 	u8    function;
 	u8    result;
 	u8    reserved;
-	union {
-		struct report_general_resp  rg;
-		struct discover_resp        disc;
-		struct report_phy_sata_resp rps;
-	};
+	struct report_phy_sata_resp rps;
 } __attribute__ ((packed));
=20
 #endif /* _SAS_H_ */
--=20
2.36.1

