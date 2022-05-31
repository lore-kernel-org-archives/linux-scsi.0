Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0988C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 31 May 2022 00:28:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237851AbiEaA2S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 May 2022 20:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbiEaA2R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 May 2022 20:28:17 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B15563BC7
        for <linux-scsi@vger.kernel.org>; Mon, 30 May 2022 17:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1653956897; x=1685492897;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=yy0O9zQ6xdp3IDS+OOzjixei9uOyVNqeEdMWW/7VXBo=;
  b=iR4RY+8qg6MymAxa9sdBP3/5xFSkwJpXvyJUeDtocLfSndnbASysoJmG
   euhy/GFI1vgZMIwbLs3R0gei6LP497kiJ/iUtSpXQzoL9GEoF1V5vr03U
   sgrKiKkgtR74TqRWVuM1CvIdDzqzqory5M6vPKWYLE0lnQlR7GA03O1/o
   ejUTera2TF7RQ9ST2weLG0L/KFgs3Dk6eP+7ac25J6VyOF2o9OPgjW5uT
   ZUH/jsADHvzMZ/59VlRtLSGLyabB3gRLVY2IIL1iDQsEb6HGd1LOssy5Y
   yBLPB+XeUB8U+fRNUGsaJ54gQS8QTdDoFso/znzhxaAvsVX/vw7itFaLt
   w==;
X-IronPort-AV: E=Sophos;i="5.91,263,1647273600"; 
   d="scan'208";a="202641866"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 31 May 2022 08:28:16 +0800
IronPort-SDR: jLNJ/kDS8x5UzmFV3JTEoRyjT1ChjEq61V/tzQqyYiAIrroaeQaBmZyFxGNvM6/JWbzVwBJD2u
 M1Fd5g2jjcFDQiL5fWDCObqR8ZbAJKfvPMcxWWG80CtaKu+ONiUOCyfhIpZGTRl1O1myBO8w50
 4GE6AKLN1kMGBFJcIdJGDrDPDNFX1NGVQI4/jhdbvC70Sk548mO4UWrVTV7C5zUdxWmu1eR1qa
 DGIUBsFm4Q+bITg9syot149FnQg5DVVYgnc5fp/CqPhMrYWrhlkkub3AsN6e5oWZRA0PuKCGTN
 7yo/c0+AbKnPMzEPZhEnWTKO
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 30 May 2022 16:47:39 -0700
IronPort-SDR: bwnQ+m+GRgS0lyxWdMvWrONNIVS4BSAuaGNoSXuxrpxb6TsHE7Tk1C97L911iLk9YkiD8GOnvF
 4uJT02J5/Q/QZcxozVUx7khRlI0W7Wdm3SnnaZFVyN/gBgd3mf0fG7PZAgAQnjvRMKPQ4uJNaN
 0uWTSKCW4pfzlFlLbI78bd5XDxZoAi1fkB8RzTYnrbjc30cVuZjwqlESq49/iYb9LcKUeD3RDN
 BulWACPrWEvOgfaohHk9Icw5t1AzEFvMpgFG4mt2js4gpGxHXEBVSwvs5OYlGdyT6d77u2VO00
 vzg=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 30 May 2022 17:28:15 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LBtRM0xCQz1SHwl
        for <linux-scsi@vger.kernel.org>; Mon, 30 May 2022 17:28:15 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :x-mailer:message-id:date:subject:to:from; s=dkim; t=1653956894;
         x=1656548895; bh=yy0O9zQ6xdp3IDS+OOzjixei9uOyVNqeEdMWW/7VXBo=; b=
        tflSi/yNUVMse2s1PslJJPRIO6kcfKDburEs3L7rzcyAeGbvE7636yQhMQibECiz
        v/L00f9c0dd+cg4Wp0KM4Ke6oo8zVIdeDGzzUEQKHObvM6CkI9DgbzpQ2PIOsN3F
        bOjENTWN0dy9ddhYeHZLhguQ94AH0hKbaS9aQioj+hs3Xk93vtzrDDRuXgj0Vr0v
        b40KGjzcIpikTLyvVKZ61VXzK9Lv9kVGertUoXiuvvtOoNQk0QlIOdR9Ab5j3B3n
        Uwt9X7aRe98u88YmcCL2369C/9Qk+uch/kL3rOnDgJVombqJ2/nwM43+kDPs9XjW
        ZR8cw5XOlpIF20Q+eQeylg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 4MiF2m_w1OEC for <linux-scsi@vger.kernel.org>;
        Mon, 30 May 2022 17:28:14 -0700 (PDT)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LBtRK5Kg7z1Rvlc;
        Mon, 30 May 2022 17:28:13 -0700 (PDT)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>
Subject: [PATCH v2 0/2] sd_zbc fixes
Date:   Tue, 31 May 2022 09:28:10 +0900
Message-Id: <20220531002812.527368-1-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A couple of patches to fix 2 issues with the zbc code:
* A potential NULL pointer dereference in sd_is_zoned(), if that
  function is called when sdkp->device is not yet set (e.g. if an error
  happen early in sd_probe()).
* Make sure that sdkp zone information memory is never leaked.

Changes from v1:
* Added reviewed-by and tested-by tags in patch 1
* Changed patch 2 to rename sd_zbc_clear_zone_info() to
  sd_zbc_free_zone_info() and remove sd_zbc_release_disk().

Damien Le Moal (2):
  scsi: sd: Fix potential NULL pointer dereference
  scsi: sd_zbc: prevent zone information memory leak

 drivers/scsi/sd.c     |  4 ++--
 drivers/scsi/sd.h     |  7 ++++---
 drivers/scsi/sd_zbc.c | 26 +++++++++++++-------------
 3 files changed, 19 insertions(+), 18 deletions(-)

--=20
2.36.1

