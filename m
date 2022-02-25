Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C26C2C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Feb 2022 08:45:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237934AbiBYIqC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Feb 2022 03:46:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbiBYIqC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Feb 2022 03:46:02 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FCD72255A5
        for <linux-scsi@vger.kernel.org>; Fri, 25 Feb 2022 00:45:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645778730; x=1677314730;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Uyb5EWqt7IFi+TMN7J3O1uqmh9gnJtKxly3LECFx76g=;
  b=FIZVP7PRkk5g+ZSzEyGd4ZhTt09S9WrqlgImnv5GEE79rAL5QdD89CG0
   uVZupn/2WdPNbOWPKcygVQ5aB/G0ei0XW0OnqM6xp21IIKg33StU2c9wL
   OZBfasfGTxbWuz+J5Dam8ZG6dg9ezYr+sIqKN15GZ7posedxyWvpWpxUN
   ifrOWXYuGwpC038KoxSSzarjiuatyVBGdFXFqUkwwt50csJG7bllREmvM
   PG2iRC0aBfxPLfxmbXYOij4yokiX6gLrx2qRfyyBC38pDf/K1Mvco0kDY
   vXkeN5JItH7lcfPqTi8evdBOkDrM55ggkj8iUvz888/KSdmBwbDW7OMBb
   g==;
X-IronPort-AV: E=Sophos;i="5.90,136,1643644800"; 
   d="scan'208";a="305831610"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 25 Feb 2022 16:45:29 +0800
IronPort-SDR: RTZd2n3V7uf+yMvJLDU35NfGOCeJDhAX40i1c9G/zMtDxWk8qtWdszQFF3Pa+FpNsZUKszS8BR
 Ahr9ohG9UTj21VSfbTQqKcSV9lO5SihMaXNI0+gFAGENR54occUkoxwRUmP46IPP6lkdiusTgl
 XDWb2/G8b+M0go/faSyffikBV+TlfwM/9iFQLGPvCmtvqJ0uZ1MVN25xeOauVKt+DKI0DCOkpv
 /h48q/dhtRnbPxhnwja/tCQsTc/aidpTt+dDw7kT2SypBwVS5ujGKEtl+S3itQ3r102g7oR91S
 bos97M0lC1vJEISZzmGvlMqF
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 00:18:04 -0800
IronPort-SDR: sdS6NvoFsauMmyHoIzBdF07W+6Mvs/Bkik/Tt7ummD7p2E6ZeB+R43Wvkd/KRJxlwSSHiFbZEy
 jMxLr+SKHyAlaqVF4MDNULE2ZcYR0v6MTFCexOHVrom/qsuyI6RyEJllcWru0yO7q3klW6a/ou
 oXwe8TRxm7DhzVlY9fpjINLcMdfx4vonOBLOodxAe1MD5FsRq8qSWqTs0JY3uhLfYUyNOWLn2u
 TWD9TF3X0HewVdOY5cRWtOkPZLCvbjNwe/PGP0UHiF/5RO33w8uZpqyntMS6K9evqLXdoIPNgt
 +5M=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 00:45:30 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K4jyx4jhcz1SHwl
        for <linux-scsi@vger.kernel.org>; Fri, 25 Feb 2022 00:45:29 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :x-mailer:message-id:date:subject:to:from; s=dkim; t=1645778729;
         x=1648370730; bh=Uyb5EWqt7IFi+TMN7J3O1uqmh9gnJtKxly3LECFx76g=; b=
        lozC0o3nfWTwkLbPnh13rJ5lTlYUfY0axnuhJUAUhZJ2JjkUp6WvNcenzHBhDFAE
        XLqnMqFjYJ/ZMeHQhtV9/zQwKIP1+b3lkpa5/XvowKfwY0A2Q4litnzbhst8NdSp
        WAYOGJKaCc9K3XUugPcokuXM1LSy40ShaJmNxvdKRAIjAIOdOJDJQnYZrdRHaymD
        2Ws7Gu0eQlzHqre0p+VZqqTHHII19aQUUNdW91oxm+xD6hlaki34sYl1T+hGvGDs
        xRg3rbvfb9hK0kBk5aClL8sZm/06RUJ2Umu4CWlK9SxwQFyMz9p3Jg/6BEhnmXuq
        l/dMBarLlcfcxAyx6fQBKw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ZmAwzvzDS9MU for <linux-scsi@vger.kernel.org>;
        Fri, 25 Feb 2022 00:45:29 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K4jyw4HTrz1Rvlx;
        Fri, 25 Feb 2022 00:45:28 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH 0/2] Fix sparse warnings in scsi_debug
Date:   Fri, 25 Feb 2022 17:45:25 +0900
Message-Id: <20220225084527.523038-1-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A couple of patches to suppress sparse warnings in scsi_debug. No
functional changes.

Damien Le Moal (2):
  scsi: scsi_debug: silence sparse unexpected unlock warnings
  scsi: scsi_debug: fix sparse lock warnings in sdebug_blk_mq_poll()

 drivers/scsi/scsi_debug.c | 87 ++++++++++++++++++++++++---------------
 1 file changed, 53 insertions(+), 34 deletions(-)

--=20
2.35.1

