Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A864C6FD1D
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 02:22:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbjCVCWR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Mar 2023 22:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjCVCWQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Mar 2023 22:22:16 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F0359E50
        for <linux-scsi@vger.kernel.org>; Tue, 21 Mar 2023 19:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1679451734; x=1710987734;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=qctaoUf2mFENIx9waLsFgZsfHWDssf/cHbAGoDmaWU0=;
  b=I5+v1SoOloF6ZgghPm/Y1lsN4vxgALOUjrZ9Zrr7fhIU8luaqppQ8r1a
   BXZkX0R5v90mTvqTOMoEY0Hhg7RPN8y406yo4Ztm2IcXkSTYxRqjrag9C
   6fpu60UI5l4apkeFwLBWBuf2+94RTMySoR9Fn82sRXIhyzkhzCKsYaow/
   6Cx62T6H30L8jg6AMKV7Oat2DO1UbSeC0ynBDaGuVK+SgatlCV7bIXgbq
   XkFklWcj+89ksYNPITL+5JW3Nq3JH2WLqgkyfXTEagChcHuoQDer91l8q
   WPVQ5XuH6tgYSNPtKMRN+EeWzYJPXmvPbGzPjuLGYQ83Z+zXO1pCMIGhQ
   A==;
X-IronPort-AV: E=Sophos;i="5.98,280,1673884800"; 
   d="scan'208";a="225997480"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 22 Mar 2023 10:22:14 +0800
IronPort-SDR: yTQrOpnFuf5vfsiwDiSKhStS60UHuT2+pWLemya2nIQq/pc4BMI4XKxuSQrJ76JtqU+IPNJlpG
 byoorD8f4wDmAJlnUmo5MreuaNobiH/kFeBR1h3Agef07zuhxWisT+uNrETPshHLm0LNgAJk0Q
 mXgC7DACL1spfnSPPtn8v4X1FohQ1TxgoidYdctgZfXJQ0fkaSbSqdob5R6HzSNDNCp7/uCPof
 HOov1FQnoc+WqK03m/vWexuaaCRWpUunuqMuJafA71N8Q7gbsqnwntpcGpHtySYaa/aV5dmZAs
 iCs=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Mar 2023 18:32:52 -0700
IronPort-SDR: FOIO/FpBV9cQ5qnx31JoBzq0SIJwl2CSFV4qxl4nijawXSNvWlYOJtZsJFSFxSH+KfqYrULIrX
 a9n7Ru2X24exkegtpU+022gZqVxRQbBR4LdojJc6h7+8R+LxHvQ5qzPFcnZYdv24XzwW2s45VA
 nouU//R3maX4BQN9QyDzMJ8mlUm18UcZqmlcaLUmIR4tzeab+0YcHrXSuncP/t5A0mIfTF8et0
 Lrld9gBR/pVwCGeHNDckoU0lBG0x9pVcC8C2k6Eq04Udr9eNPQnN7ADzeMmaRA3Pzb4un+0bsA
 MYA=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Mar 2023 19:22:14 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4PhC0k237rz1RtVn
        for <linux-scsi@vger.kernel.org>; Tue, 21 Mar 2023 19:22:14 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :x-mailer:message-id:date:subject:to:from; s=dkim; t=1679451733;
         x=1682043734; bh=qctaoUf2mFENIx9waLsFgZsfHWDssf/cHbAGoDmaWU0=; b=
        OFP7zYPV2gfuzuwcKz/M5OtDQy4mPG4F3tW06FjlpqGLioxBG0eU89K911c1Y6eL
        bBKxn7333Raelp4v45ft6VcjI7kRTmUeIO0hIXb7Nhqs4pV6IVI7B466MQqMANPs
        9ZFu7lvMW5LU6RUW+QMTDKAYiNFlWhKDKRx/R7A2n3sJsUWXjZeqsn3V3HpU1gQq
        fjPh8Vh5BQl7chRxRME+IQ5B0QI+pw88pJ5cJ2i6nyFHtZuogRMqmOtdpqEkjlgb
        Sco83OmmpusOhcOSme+KrHeWfdRL9RVs06haE3/aBMLWSm92VGp7yHD6jizwnFxC
        kZmMy+mDfHUdBFJ/IoUaaw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id zt6AyDMeER6N for <linux-scsi@vger.kernel.org>;
        Tue, 21 Mar 2023 19:22:13 -0700 (PDT)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4PhC0j3RSFz1RtVm;
        Tue, 21 Mar 2023 19:22:13 -0700 (PDT)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi: Improves scsi_vpd_inquiry() checks
Date:   Wed, 22 Mar 2023 11:22:11 +0900
Message-Id: <20230322022211.116327-1-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some USB-SATA adapters have a broken behavior when a non supported VPD
page is probed: depending on the VPD page number, a 4 byte header with a
valid VPD page number but with a 0 lenghth is returned. Currently,
scsi_vpd_inquiry() only checks that the page number is valid to
determine if the page is supported, which results in VPD page users
receiving only the 4 B header for the non existent page. This error
manifests itself very often with page 0xb9 for the concurrent
Positioning Ranges detection done by sd_read_cpr(), resulting in the
error message:

sd 0:0:0:0: [sda] Invalid Concurrent Positioning Ranges VPD page

Prevent such misleading error message by adding a check in
scsi_vpd_inquiry() to verify that the page length is not 0.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/scsi.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index ab6e2d5e1430..c4bf99a842f3 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -314,11 +314,18 @@ static int scsi_vpd_inquiry(struct scsi_device *sde=
v, unsigned char *buffer,
 	if (result)
 		return -EIO;
=20
-	/* Sanity check that we got the page back that we asked for */
+	/*
+	 * Sanity check that we got the page back that we asked for and that
+	 * the page size is not 0.
+	 */
 	if (buffer[1] !=3D page)
 		return -EIO;
=20
-	return get_unaligned_be16(&buffer[2]) + 4;
+	result =3D get_unaligned_be16(&buffer[2]);
+	if (!result)
+		return -EIO;
+
+	return result + 4;
 }
=20
 static int scsi_get_vpd_size(struct scsi_device *sdev, u8 page)
--=20
2.39.2

