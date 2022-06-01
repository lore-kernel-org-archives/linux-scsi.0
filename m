Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2F89C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jun 2022 06:25:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349869AbiFAGZv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jun 2022 02:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349858AbiFAGZu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jun 2022 02:25:50 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 514A380231
        for <linux-scsi@vger.kernel.org>; Tue, 31 May 2022 23:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1654064749; x=1685600749;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bNP+pJ4hBgXTU9O/4GfwwC5cUlUs+psqppR9OjQNCrk=;
  b=alZsWny/q7ivjomTASUVz7zxCtKHFv3CxSbJ46OiujTT/OxK3NF84Ubx
   h6To/Y5L5LuBVKpYx1IUJD77FQFBIZkvRfoNeLVraaC+HLr8FYoXzsRHb
   sUN//xVas0XWHuNe4aaRKB+2qk3Lz/NYmitEyY/dPCSFXn62tXAzH1q9d
   wFLNPEtLG5kGzd2m1TxFHtPHnjonWzdOzTFks1GAsDw1SVlejEFM0HP1h
   LZeFsczYWSSdVeHnVRL5skx8UmJPckk5zrC4zZLwoiJsrg+e/gxdAlA43
   vcZzHSMCWvv8uOenYEBvaKdvEKsbMSPP/r0/6HzAYWjhb3/CrFQ48uaBL
   w==;
X-IronPort-AV: E=Sophos;i="5.91,266,1647273600"; 
   d="scan'208";a="200715425"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 01 Jun 2022 14:25:47 +0800
IronPort-SDR: e0wrfbQ3qDTamBlkUOiHW/JpnGRyXKozFUIr7Bzm9UJ7PU8Zc2i9t/RtDvRZnqapElFqc6XHJX
 ypVmmzrA5ruSs4rkIkrvwpohs4VTpg92ElcjVum81IetGVvarLSfdd8Wy6kEycmCGOFjfnGylV
 VHnzLcXyuoRxCQvq0/Hd75BORlqX23lfjC6Q61poGxhXQqT4i4UTLrBRRbIO5VRN9sXnJOIPsP
 gqoaONflosUQLDzayBTJ31QjxEq/UDB7ShODdFTeU4tYkWPXl5MZ2aCPypKX+aCPDgKKiHh8Gw
 HkfhULfcBCkvaFJHN8w6qnZK
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 31 May 2022 22:45:01 -0700
IronPort-SDR: zH1LVs5kk+wTFZkoi9VnG0I8MqKqpmbu+8/yntMzgsjnaxF4MCMsxdDdNvIKSqvjKqEibM8YcG
 1MoC4xrjy3kw059OuWhaK/MhVPxWhOvgycVFj/arwL7ION7NmdDp7q7hcNuP4RiI7EO2B/92If
 2URh1s3whe3b5rKVCTgjPwFMEkoVr72JBbfrYLLtHdTc5AlnGfemEobk53r96VGjFKvOPBdpUa
 ztKlb+qMf/s1kG2zIXKbSc5kJBAjsvU9Bea+GIUkPdVcbUTRChTJd0mMzV0Otimm/1IMpRZjl/
 qyA=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 31 May 2022 23:25:48 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LCfKR5nrQz1SVp0
        for <linux-scsi@vger.kernel.org>; Tue, 31 May 2022 23:25:47 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1654064747; x=1656656748; bh=bNP+pJ4hBgXTU9O/4G
        fwwC5cUlUs+psqppR9OjQNCrk=; b=NT9GQ/3EyTLh9jaPIh55p5qTS8peWkLb8b
        fb6WmDoXllJGLYBkwjGCOMMkqtX87CY7BjWBcqI1s0LbrDPsJq1NkNHeBth/g6F2
        zclgD9d9+K90Q/1whWBhegVWnIqaguGfN9pW+yE2MuD53AedMvAczkJlb37WyP+Q
        S0nGZ4bBldwWFRhtRqd+n6RRNsc+PuQ0oJTJUtzYrLOLG0NbAnRX4E9prPrLDCEe
        gfhMtZqoPH6BfTDJcgNQP+ILJHUXpxWRAJlCTBF5M9xPrp4IhLhvhKk1tv5pjQph
        Um3GOzzLsb0jlN1S0Hzpk7bRpwved+2KTPJl02OV/FSPYDyc0EGg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id QjUiL1acr9sK for <linux-scsi@vger.kernel.org>;
        Tue, 31 May 2022 23:25:47 -0700 (PDT)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LCfKQ5zm6z1Rvlx;
        Tue, 31 May 2022 23:25:46 -0700 (PDT)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>
Subject: [PATCH v3 1/2] scsi: sd: Fix potential NULL pointer dereference
Date:   Wed,  1 Jun 2022 15:25:43 +0900
Message-Id: <20220601062544.905141-2-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220601062544.905141-1-damien.lemoal@opensource.wdc.com>
References: <20220601062544.905141-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If sd_probe() sees an early error before sdkp->device is initialized,
sd_zbc_release_disk() is called. This causes a NULL pointer dereference
when sd_is_zoned() is called inside that function. Avoid this by
removing the call to sd_zbc_release_disk() in sd_probe() error path.

This chnage is safe and does not result in zone information memory
leakage because the zone information for a zoned disk is allocated only
when sd_revalidate_disk() is called, at which point sdkp->disk_dev is
fully set, resulting in sd_disk_release() being called when needed to
cleanup a disk zone information using sd_zbc_release_disk().

Reported-by: Dongliang Mu <mudongliangabcd@gmail.com>
Suggested-by: Christoph Hellwig <hch@lst.de>
Fixes: 89d947561077 ("sd: Implement support for ZBC device")
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/sd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 749316462075..dabdc0eeb3dc 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3542,7 +3542,6 @@ static int sd_probe(struct device *dev)
  out_put:
 	put_disk(gd);
  out_free:
-	sd_zbc_release_disk(sdkp);
 	kfree(sdkp);
  out:
 	scsi_autopm_put_device(sdp);
--=20
2.36.1

