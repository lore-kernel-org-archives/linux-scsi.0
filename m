Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5062C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 03:14:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231866AbiBRDPN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 22:15:13 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:55778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231863AbiBRDPL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 22:15:11 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42CE9120F7A
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:14:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645154096; x=1676690096;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tMu46lOD+saf9CD6nTTB39TE+9yuObAVdHXvuV2n3JQ=;
  b=ispgWspZ//Zbk97JFY9vwUtvWEd345aH3b5rb+cUQlENx2Bij9/SvuPO
   W66a3Ykh/SiVJn5t1V6aa66ye3OFL703KKwtZfDTmVnQws/pSgV/h6AV8
   d/gd0ghdtQ6GbBS9nOWfELg6E376EP6Twk6IkjsFEERFyc1p6MbTmF+TP
   fXLAN05EKnVdBzL3SgOBUxixn8P3b3MIdhMCSQcCGKqwf6xfqOvrK3ZVJ
   ppikJkvzzhJgYjRsTWX8W2ad2bUZ8Magwc5fkxXW4bs/LY2ciH7kPq6qD
   p31TO4WEsFjqC9gq87w5k1l6TeKAnjuqPYRoVzqGNNrEfTnh0hQAmfnMt
   g==;
X-IronPort-AV: E=Sophos;i="5.88,377,1635177600"; 
   d="scan'208";a="194225721"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 18 Feb 2022 11:14:56 +0800
IronPort-SDR: +evSo4T/iUbWYEqisD9keRhIxupV+bmLaQ9lvU7l8v7Ap9hq/6PB5/dmMpVRevvG0ldGkQicLW
 iLzb1B6A5t4YPSTsKFyeabXWnkXvONoR7qN1SxDJ7RZ/oplaOaAf/fi81+/efdCHwmxgxhsB4l
 nPHQ1dFl26ho5lcElLO3l30hKWzVPqPXbdOSFhVK43FW9pq6cNUsIehD6TDuzt78ASnrpNnD/z
 wk1tPPfe4EhD9s3Ayde5PUcOQ1kjUNc4XF2o+4lZDzac/D6IjgJLwDvUJS1qEtQaowFj/6Ml1D
 txG7lCBHpxsBm9l1jbqpkFPa
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 18:46:34 -0800
IronPort-SDR: aVcmwAPyWMmmWPJxnWoSF4uvketdAmvOJxzInNsq78fnvBeyh4Z7VKprV9bH4HciYY5umRS+8f
 Q3UVxBcWJnmN1uZ5lii9YtALKkm8b3rSbyibwhonqWz/TZj09sYSVvl/9g1mhDS/e7URoMTFtu
 Un24eqnBWdhoLl/rPPyVBH/TmFv0hjQX9Wr+bQN52kJAvFIjDNNhWLt5sdYYBBiVEqO3Iz/N/H
 sw9oyBZUnB288FKOTU5Fk7EqLPnZ2v54HTYmtbyqn7jIYAfQGn3nNMUFyK3gc38qRpT5XIGR0k
 kXg=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 19:14:56 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K0Gyl6VM8z1SVp0
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 19:14:55 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1645154095; x=1647746096; bh=tMu46lOD+saf9CD6nT
        TB39TE+9yuObAVdHXvuV2n3JQ=; b=t0b4oxhiy0vnOQ5uqSNWre+bkCOSOxH21i
        qJrt6njRXAQH/N1NwgyGZGrTjiafq7V9HizpgEqgBkc8EoUN4BytvjMoeFz4fv6B
        p450MKEM1ZpG84UtCAxjk7sW0IMmZZosPxQeAEEZjJt9dMp6vT6QY7ewxyNG6NL3
        2e26PoIS/e3Obi+MKezYAXUw/xDrDnPslcnvmygyUWuq0cQz5Zhz/j16alUuY6PD
        XMz/ePbRQcljKycAheV7q6zmYMaX5oo44sgAu3Hs8jiBtg4tfgbEQt0yShSNIJFG
        0Cz++nN0yPI4XsxMgKNG8dvtCZT5Dm7l97LRLwJwl3y+7WTQSkiQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id RF7rx7VEBwZN for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 19:14:55 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K0Gyk2LrWz1SHwl;
        Thu, 17 Feb 2022 19:14:54 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>
Cc:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v5 05/31] scsi: pm8001: Fix pm80xx_pci_mem_copy() interface
Date:   Fri, 18 Feb 2022 12:14:19 +0900
Message-Id: <20220218031445.548767-6-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
References: <20220218031445.548767-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The declaration of the local variable destination1 in
pm80xx_pci_mem_copy() as a pointer to a u32 results in the sparse
warning:

warning: incorrect type in assignment (different base types)
    expected unsigned int [usertype]
    got restricted __le32 [usertype]

Furthermore, the destination" argument of pm80xx_pci_mem_copy() is
wrongly declared with the const attribute.

Fix both problems by changing the type of the "destination" argument
to "__le32 *" and use this argument directly inside the
pm80xx_pci_mem_copy() function, thus removing the need for the
destination1 local variable.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80x=
x_hwi.c
index f1663a10693a..0b3386a3c508 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -67,18 +67,16 @@ int pm80xx_bar4_shift(struct pm8001_hba_info *pm8001_=
ha, u32 shift_value)
 }
=20
 static void pm80xx_pci_mem_copy(struct pm8001_hba_info  *pm8001_ha, u32 =
soffset,
-				const void *destination,
+				__le32 *destination,
 				u32 dw_count, u32 bus_base_number)
 {
 	u32 index, value, offset;
-	u32 *destination1;
-	destination1 =3D (u32 *)destination;
=20
-	for (index =3D 0; index < dw_count; index +=3D 4, destination1++) {
+	for (index =3D 0; index < dw_count; index +=3D 4, destination++) {
 		offset =3D (soffset + index);
 		if (offset < (64 * 1024)) {
 			value =3D pm8001_cr32(pm8001_ha, bus_base_number, offset);
-			*destination1 =3D  cpu_to_le32(value);
+			*destination =3D cpu_to_le32(value);
 		}
 	}
 	return;
--=20
2.34.1

