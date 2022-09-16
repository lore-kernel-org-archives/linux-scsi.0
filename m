Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C298EECAAD8
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Sep 2022 13:01:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbiIPNBW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Sep 2022 09:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbiIPNBS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Sep 2022 09:01:18 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13B87A2848
        for <linux-scsi@vger.kernel.org>; Fri, 16 Sep 2022 06:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1663333275; x=1694869275;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Pl6qOW/m+GgoJxVPO/nqFZdPddOmFt6TWIeM86YixPs=;
  b=jiXKZSlBiKXitrktGXqPbF5iZcyQVNsNZtMkw76NUqN71bDCmHabg8eC
   HUQADWxcMubP9H3V20q1+h5l0JH4wvTKBijM9mimC7FJbWLDJu3bZ+OBp
   en5iVvBc52DvXvhGXeDQewfrbLAlYDuh8ZqBBxH19ODOSAKRKWzj/Unae
   EUw2ez9b6KoVk7gH0DByZWL6ABSz9RwRt7o38Vi2/P0vwCh4pEjAzjhoj
   zDog4Opi8y+YQQewbkfTzab6w9GTNvz0PX6a/OXC5YzODwp/al0IgD5HR
   cvnl+o9X5+qdtSGNAP1jiN8bBUwSxUN+ixjhCG32pwtkOKwPbeuwrggq7
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,320,1654531200"; 
   d="scan'208";a="216702718"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 16 Sep 2022 21:01:15 +0800
IronPort-SDR: ez4/uQ470bHYqLPYQodtt7Da05Cmi5cMdnoKP8wiUXYaSsqROuiz8M75vya/FIEPXNqJsXAgjf
 ZL17xmXWTuH/JowpraL54+Vo/kICJbfSfXEmpT/n5BLh1RHTEHC/6PfgeGfUiaqNb5afqfm2XU
 GUnfHeKyMVrZIbLwoGzcNPHgoMhsIc0jCvggXvCygDGaROrQWcThtTihYyHFVwKWGxWGrCcJe/
 3gcRNd5YHGUy15pHbCvF2dBFTxhTPg9Ra42xOFTdXBwJgYKdAf3QcDZP87PRUs9OZKFaChsu7b
 +sgBXF4B5QtYuy9oz3IkSmfr
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 16 Sep 2022 05:21:28 -0700
IronPort-SDR: 35wyRRbbFjvdNFxdeOBn3L9q25EB/YI+ZOlXNilFm7fbqorOv2ld/02zFym9xWilvVbGUPwcqz
 wjxDDPvb/Ol52BC2uxd1xXaqppe3yHuuL+LW5nh8QsuwHEzISElfKUuT8wHJwkSnz4X51uCdJT
 A+TEVFVsDlbwAgETvp1Q/CJ1j9Iv76wuoUKsTx0zHMhONdBS7VZcsxaFmWg17dHjrFiJSI6y4Q
 NlQJxmmkSk1seWgKz9GrRH8one9XjgHJQzTBBmspCeXployEk2MxbfSF80kpoOOOHgkuLeGMpb
 N7k=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 16 Sep 2022 06:01:18 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4MTZ2P2lRpz1RwqL
        for <linux-scsi@vger.kernel.org>; Fri, 16 Sep 2022 06:01:17 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :x-mailer:message-id:date:subject:to:from; s=dkim; t=1663333276;
         x=1665925277; bh=Pl6qOW/m+GgoJxVPO/nqFZdPddOmFt6TWIeM86YixPs=; b=
        Sb1/1oOmGYCNRVpNEJHdd6B44l7WIs/J1f67E7LofPSKhXpGzhk1D4ikEMiMkfCb
        wV/apdNWKWXwdCW5qyD0y0E5rFiqvkJgsQMDNylaFtYhc+GGWctC330VHeAcmLeN
        esST2NnMfRFQ2ZFVMFoRcakp2KYiDmNwzqHMHD6pSqBcOEu2moRYZ2vYbmn8wpQN
        aFUDtS59lahbqyNXiERXdLtACOoA2LW4LvpqMFre6X9UbL9pEADGxdFMXp+HQLSV
        x+ugadoFkYregVg/UH3bS65FOsGPre1fTK0AHNuyG4DCg0Syce/21bY3pUI5bQ6o
        i8Xp8Hyg/ffmvZouoqNwkA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id gOC4X97i2abm for <linux-scsi@vger.kernel.org>;
        Fri, 16 Sep 2022 06:01:16 -0700 (PDT)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4MTZ2M0Xbdz1RvLy;
        Fri, 16 Sep 2022 06:01:14 -0700 (PDT)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     matoro_mailinglist_kernel@matoro.tk
Subject: [PATCH 0/2] Unbreak mpt3sas on big-endian machines
Date:   Fri, 16 Sep 2022 22:01:09 +0900
Message-Id: <20220916130111.168195-1-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Patches b4efbec4c2a ("scsi: mpt3sas: Fix writel() use") and
7ab4d2441b9 ("scsi: mpt3sas: Fix ioc->base_readl() use"), while aiming
at only fixign sparse warnings without any functional change, broke the
mpt3sas driver on big endian machines. This series reverts both patches,
until someone more knowledgeable of the Broadcom HBA controller
interface can properly fix register endianness control to avoid the
compilation warnings.

Damien Le Moal (2):
  scsi: mpt3sas: Revert "scsi: mpt3sas: Fix writel() use"
  scsi: mpt3sas: Revert "scsi: mpt3sas: Fix ioc->base_readl() use"

 drivers/scsi/mpt3sas/mpt3sas_base.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

--=20
2.37.2

