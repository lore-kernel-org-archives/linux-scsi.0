Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6125CC636D4
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Feb 2023 00:50:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbjBNAuY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Feb 2023 19:50:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjBNAuY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Feb 2023 19:50:24 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 584C9C163
        for <linux-scsi@vger.kernel.org>; Mon, 13 Feb 2023 16:50:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1676335823; x=1707871823;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=62XAAHgE+0de0iLq6Fe+HsQd1woqOeb3cq2wjCuAshA=;
  b=mxmEUsHqhMeqg8dbWFLSSAejyiptChmw9cq4YG/7TCnEzT4heJ6hx/Dg
   fcCjz9hAuOsGIbW9zQcRbrx12feKHz3u0ZZsHhOZuPzD1Hmzio4bWie8n
   NQ4G2yMRBaSdcCkrspAzDJEHEDYiBG45A4tGslkd/FOpyR+Go7Wsv7tlY
   mXyW09Kf7or+n6rjxAaZixK1qDRMnM+gkClcfHKPHC9Asciii+zzPqZ0A
   ke7EdQuMRD9HcX5QXCXOYn3Iz+zkBlrA+N4X2fwppg/D2dSCCXCc7LZiG
   zcupxfR8evigwmEDUtY2j/szHBUmR6RFnLu08cVP7WkupfMd41bW16Yqp
   w==;
X-IronPort-AV: E=Sophos;i="5.97,294,1669046400"; 
   d="scan'208";a="228193154"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Feb 2023 08:50:21 +0800
IronPort-SDR: jNIUoMVX967woL6TeN/PyTPYk42kDizlKzqDTxo9DCyKwZKgw0FzWplAAOCZFeafFqt/egtUCZ
 DR9IboyaseeXeG8m+r7B4ifuQ8RujSCFTucwtTcmdWsZerfx6dAmK4ZDdu9igxEikpWXksHBno
 84wmcU5iq40g8Lev6/WxLPGOjWZk4WlOGd44pLDHCZcrP5YgicKL1JMycOhq0doI53ZRyWdHni
 l7wbMvz5EN2drTG8iQvGNJ5tDFuXKMv4fyrenTnhK/CVb4UxddHLfGOvgU5fFe/CfuVcmVVGGs
 H0g=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Feb 2023 16:07:30 -0800
IronPort-SDR: CVB+Wcu867IL9pH+jAPWDhVkzpALBwcsLcTZdvXcsqV/UJ1xcGdwbPxnKXqWvwue1JnG9cgaDK
 bMAQw3zqHcdacjJS9Ur9nUM1IrrB81A8iW4jM4ZRScnoCtkA0cT57/k54A2MHycpTk8W2N8xsh
 1+VPs4DYzazHEKacg8HYWM1bLpZZdBmLXwRx+x8KI1QFAnU+tQIxVIW9b3SBX2agqHYahOv0dK
 QljbSUtsf6HHVLq4c30n3qJBDsGGSzkaeSGSG/pke9h0fnixZmPeFb1/Uec8oyG96HwcitL4DF
 6tI=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 13 Feb 2023 16:50:20 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     linux-scsi@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com
Cc:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v5 0/4] scsi: mpi3mr: fix issues found by KASAN
Date:   Tue, 14 Feb 2023 09:50:15 +0900
Message-Id: <20230214005019.1897251-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

While I downloaded new firmware to eHBA-9600 on KASAN enabled kernel, I observed
three BUGs. The first two patches resolve one of the BUGs and related issues
found during the review. The last two patches resolve the two left BUGs
respectively.

Changes from v4:
* Squashed 1st and 2nd patch and reflected more fixes Sathya identified
* 3rd patch: replaced kfree with bitmap_free and added a missing bitmap_free

Changes from v3:
* Moved 1st patch to 3rd to resolve a compiler warning

Changes from v2:
* Added 1st and 2nd patches to address issues found during review
* 3rd patch: changed fix approach per comment on the list
* Added Acked-by and Reviewed-by tags

Changes from v1:
* 2nd patch: Modified to use bitmap helper functions and number of bits
* 1st/3rd patches: Reflected a comment on the list and added Reviewed-by tags

Shin'ichiro Kawasaki (4):
  scsi: mpi3mr: fix issues in mpi3mr_get_all_tgt_info
  scsi: mpi3mr: remove unnecessary memcpy to alltgt_info->dmi
  scsi: mpi3mr: use number of bits to manage bitmap sizes
  scsi: mpi3mr: fix missing mrioc->evtack_cmds initialization

 drivers/scsi/mpi3mr/mpi3mr.h     | 10 +----
 drivers/scsi/mpi3mr/mpi3mr_app.c | 28 +++++-------
 drivers/scsi/mpi3mr/mpi3mr_fw.c  | 75 +++++++++++++-------------------
 drivers/scsi/mpi3mr/mpi3mr_os.c  |  4 ++
 4 files changed, 47 insertions(+), 70 deletions(-)

-- 
2.38.1

