Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4F7BC6FA83
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Sep 2022 23:08:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbiIYXIY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Sep 2022 19:08:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbiIYXIX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Sep 2022 19:08:23 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C05F72982E
        for <linux-scsi@vger.kernel.org>; Sun, 25 Sep 2022 16:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1664147302; x=1695683302;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=zGCSgfOMqVnazTIwSJyzepZefBWFgHkJ3WSZBt3xuTg=;
  b=CklCbCfQeBIyoYU05NPtJtD0K93/A7QikRKphczAlx1R9q2OeH3F2WDX
   HOllmM2DjawAY0iFs4hVDCYDBzibkwvuIkIqdPsPmsVbdJqiP1xDffpVE
   hXGL0TWMuRljIjXsJujojcGZMHChpFXkL6UZmosNeBwaJT7zmQtFVlj05
   CR9Qo/Ujqwt4u8qehYhCJjvulK7OPfMAyw1DBtzyIzeM3MB/nHrjT3yhp
   mOZxZtWfHw4UI8P0G9lls5kci6NDiKLTqqpU5hxabDQc8COQV39rvzEib
   PlSQ5sGoxt1NyVQtbmw+ajQFY5UYj2+jX0qb0TYVF3uUbWAYl7B3uHqMr
   A==;
X-IronPort-AV: E=Sophos;i="5.93,345,1654531200"; 
   d="scan'208";a="217414820"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 26 Sep 2022 07:08:21 +0800
IronPort-SDR: r1Bal3GEId0Rc0v7D1fi+7obvQn6Ic2CoAFIFZqTCPgNrCDRmD3ryzsZzGI1ciyqYvNEz9gaVn
 QiVKFuzU3rGD2u06JVeZujprt+luZ9ObsbYBAUC/qT4g/REeENGdo4XXbLR1RE8epu4Ig9CYgM
 dbj8FStHZS8VmwZBVJBQt9Z+EWPSeYTsQzn92NSdnxII5XBSbqpZtYvoXw2AUJ7c7NVlX/BWRO
 G+924Izvvkrtotl0xBZRhBLSihdFLfsurIxUw3dZ1a0BXxa3gJ5tntluNseplfFqcvkN06bj4e
 btqcFODgBrVigrKyXYr/WhAq
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Sep 2022 15:22:49 -0700
IronPort-SDR: XO7qHqc/9fj59xMLtRoiZyjHPtPw21YxC2Brmfq6jvl6J1jR2LsGcp4iXlB3fVkODiCwbrt/Mi
 lsojANeqWXgNwfquW2qL+xjvpeS464402eJx1vecFYQnyP69GzmYqWPfCBpBTjOnBuXDbHRcG6
 ExDmrIJKTCXx6RgkJl668quFNNozZfb5SKI0u4wi4pVPV/WaW85QYX3AhO0cYagFUS+Sqazpcm
 jrDMj1ZMM3YvVuanLAZdaEMlpvrb9gv45PKjv10kdaYdowk+WmvVn67b3YLxTJ5oBe4j9DmkKR
 Fvw=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Sep 2022 16:08:22 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4MbM4h5K87z1RwqL
        for <linux-scsi@vger.kernel.org>; Sun, 25 Sep 2022 16:08:20 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :x-mailer:message-id:date:subject:to:from; s=dkim; t=1664147300;
         x=1666739301; bh=zGCSgfOMqVnazTIwSJyzepZefBWFgHkJ3WSZBt3xuTg=; b=
        EdcYkwNpsxYWT2785OxI9ESxEzthUunhrbN/wKSYWHbd/s/rVbJkcKSR34x8DZTj
        XvqH7NtY90SBZA8e395RjaOG2LuPwSeo59U55nHz1JXo27P9Hzt0yzH9Nz3PJ2SR
        U1mabNu7cJCNeoBxdrMMCIKs3WbGL6a7iZdO5Le8rMcw5mcHRVGpSjoifER/eYbT
        JTcXFlESm0lKMCf5AakXEJSSNWVdPu4RlryqjRYlJSbEN+A1R1bn8sr6SQWlQnlg
        MYl2viQgpuHRTOlMMpLEpClSHDvy0ewR/JNim4fi70iRpG6DWZCdD+5RER9tikuW
        +AYksIPQTAnRNnDsEwsoEw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id lmq6zxET5heS for <linux-scsi@vger.kernel.org>;
        Sun, 25 Sep 2022 16:08:20 -0700 (PDT)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4MbM4g4G6lz1RvLy;
        Sun, 25 Sep 2022 16:08:19 -0700 (PDT)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v2 0/2] Fixes for ATA device queue depth control
Date:   Mon, 26 Sep 2022 08:08:15 +0900
Message-Id: <20220925230817.91542-1-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A couple of patches to fix maximum queue depth initialization and
control for ATA devices used through libsas.

Changes from v1:
* Addressed Sergey comments: fixed typos in patch 2 commit message and
  removed a temporary pr_info() debug call.

Damien Le Moal (2):
  ata: libata-scsi: Fix initialization of device queue depth
  ata: libata-sata: Fix device queue depth control

 drivers/ata/libata-sata.c           | 24 ++++++++++++------------
 drivers/ata/libata-scsi.c           | 10 ++++------
 drivers/scsi/libsas/sas_scsi_host.c |  3 ++-
 include/linux/libata.h              |  4 ++--
 4 files changed, 20 insertions(+), 21 deletions(-)

--=20
2.37.3

