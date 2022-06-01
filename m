Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DCD5C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jun 2022 06:25:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346306AbiFAGZt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jun 2022 02:25:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239265AbiFAGZt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jun 2022 02:25:49 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 760176A066
        for <linux-scsi@vger.kernel.org>; Tue, 31 May 2022 23:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1654064748; x=1685600748;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=SfB5Tcn6+9gEXCeTR3+x8+Yymdzz0bxr2x7XmDdK6DQ=;
  b=pi99bDcjs/DPsh2DvgfVRWIcs0FtTLwL8rQ8zjTWjc1cw4nxh7RMC6CP
   4T4sCh6UmLNyagy0+rSIV3KActJ8RlTd/M4cToHnLQ0oHOWwc46KE21IY
   fAEpTNoB+9bI8cGP9g7S5Y638tkJtQQRaGQkclcxuVYO7r3bf5fvEPyYu
   ApxCX/0b2vVeIjQUDk2BMEvDSCR9yZdJqCfq1y1QDHLu02UpaXJLGgh6m
   5ApdYO6e66b8DSAGsG0GAE4O7jcdlf6ztbEMLOAdK8kn+hv+Qv33Zc0rP
   sA0zZrohU9w+YvKghL2dZmnppXqjPQ6i1ZpYj6Jdw/k6hz17KvNK2pYdO
   Q==;
X-IronPort-AV: E=Sophos;i="5.91,266,1647273600"; 
   d="scan'208";a="200715422"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 01 Jun 2022 14:25:47 +0800
IronPort-SDR: C1iiA4qOgKNkbRjmP6HzJ8gscMkLolS6pH4crBKpcNcA7XsnQYJNkjbWmw368IDc8DHVqcZw9Q
 aJjiVSbzdJBQ1kx4pyv/1aoOJ8H/m1jZ+Oh1JcpjT03PUJ9fOHSln4zme57+M3T78H25WCzwCr
 1eiU3Cb3d8gwsLT1E54nXRa1lCMGnOX1FyASML9fpj7sh/M9jiHw+d47OzfsOBnw8QfC59qTAM
 H6TYOTyb69/15nCUMSBURyLPuVLVGJcwJRrh6SbhkSlAwpu/tZYO4cNrc1BfrrDclHVnkaAKzM
 HEmRDiFl43S6VYQF8tqgRZpl
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 31 May 2022 22:45:00 -0700
IronPort-SDR: JLAXi1sTyJuPM/Jgz30S+imWOVp1PscZOc4td30Fa5ye/RPgZvXCRodxl+Va8K6PlP8/oybL7p
 gsJydh1kXRpHejhOzwqC/AZGqxuo/hXj9xxmYJJFGoDUuDb78jRp87WqBLhUAE1nq9MMx5EgkO
 Z2puAVjuZzivEpVxzrL9gpTiMYcaRJiL4ruGcp74sgBvBVHW8pYtt5NH7WSXTQlF8gR/dQASJc
 lzge0btLfLZfV//eKRRd9p2EaUjIG1i6IakaqcA/7hKbLW3Zm5yP/vvFTT017tOfXxQLKECCoF
 s7g=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 31 May 2022 23:25:47 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LCfKQ6dTrz1SHwl
        for <linux-scsi@vger.kernel.org>; Tue, 31 May 2022 23:25:46 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :x-mailer:message-id:date:subject:to:from; s=dkim; t=1654064746;
         x=1656656747; bh=SfB5Tcn6+9gEXCeTR3+x8+Yymdzz0bxr2x7XmDdK6DQ=; b=
        Nkov0ci3SWNQey3G8P5M1o3ARI5D27u7dobj3nONKzCJdsRL3IDjSf3VbqVNv5pN
        AFpbbfu0QVTiGUdZXugZA1WeoxwIh7GWwCS4Rsmdops4C3M/vLkCTM1WYWC2Pcg+
        0CYJrds5MGgRUHyrsaYq1yt5+HoKLaLlmp7L/Zejcd/DvLetarpCa/Xbq9c/aVUE
        yQqGYzR5cXEb/kMa4ZywW89eAht1RokN/Om93uw8oQLDoEcvkYtFiLdRpXYw0YNE
        5AkS4bIfvnip8ISL8pN0biGLUUsLs+hAS61gS6bVqwwR760/odkiM7n+WhfV8GSa
        ONCtpVb2SbkZ+61VIYHAwQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id F9hBwq7AXkd8 for <linux-scsi@vger.kernel.org>;
        Tue, 31 May 2022 23:25:46 -0700 (PDT)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LCfKQ05Tyz1Rvlc;
        Tue, 31 May 2022 23:25:45 -0700 (PDT)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>
Subject: [PATCH v3 0/2] sd_zbc fixes
Date:   Wed,  1 Jun 2022 15:25:42 +0900
Message-Id: <20220601062544.905141-1-damien.lemoal@opensource.wdc.com>
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

Changes from v2:
* Simplified patch 1 fix as suggested by Christoph.

Changes from v1:
* Added reviewed-by and tested-by tags in patch 1
* Changed patch 2 to rename sd_zbc_clear_zone_info() to
  sd_zbc_free_zone_info() and remove sd_zbc_release_disk().

Damien Le Moal (2):
  scsi: sd: Fix potential NULL pointer dereference
  scsi: sd_zbc: prevent zone information memory leak

 drivers/scsi/sd.c     |  3 +--
 drivers/scsi/sd.h     |  4 ++--
 drivers/scsi/sd_zbc.c | 26 +++++++++++++-------------
 3 files changed, 16 insertions(+), 17 deletions(-)

--=20
2.36.1

