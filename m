Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 562EBC352A1
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Dec 2022 02:37:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbiLGChE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Dec 2022 21:37:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiLGChD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Dec 2022 21:37:03 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CD3B5474B
        for <linux-scsi@vger.kernel.org>; Tue,  6 Dec 2022 18:37:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1670380621; x=1701916621;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Y7bchj9g5xFoVwiNYVsQQ6NH7WUkPDsp00JpHbpe/Y8=;
  b=iW929EY+eTGEgQk3c6XkQBiCNvKC2oeg3KiEAAIxOW2UtA+++rrHu6Av
   gIl2oLxbz2nnheYK+UX750n05aNxh1IU38u8a77dCzXUjTxLcDJ/qe/bz
   OJGE2cXYi5HMea8gzx08U53pepNA/oI7b1EMqtnsxFzg4nzkxeq3kaMnW
   W3DFKSiMmmvg1Iuj4rXUndpqxX9XoKadAP8Una+6IgVMtE1CUqDNbbTKw
   JFAh3PTJBcJE4KoGztRce4VSOlFUxCH0a5A//jRWJe7gl945VTJ4hBL5+
   ltAdEAPrshEdpkMAlOceuSDRfRWsNdFum+ev8TPkiHPgSqJtDQwFn9o+4
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,223,1665417600"; 
   d="scan'208";a="218056344"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 07 Dec 2022 10:37:01 +0800
IronPort-SDR: 4l7h47pBWDxTYaBuoA/v0J+mwjcf3I+qmNR9L6wW9eOAR/4/M1ujihnCff2kLGUHcgWM/+XdfD
 ulE89LNsnUhVio/JJnBv9C9SlsdK8cKV15d0v2CMF0L0yxmw7ZDW6dW8gtLz409BFIIPi+akv1
 quFqrhyAJcYz2PNjhlvaHr9KBt/2Ym2x6bKs+bYq6LROOeNMjyGrdYsqIj+GKnH6Qv8t7wTBt0
 sbMz8FucFGLtPv2rIOXHRjUJ7HB3EzItf40/MaSjiIjr3nQLzChAutC5E1RjUbEqYeIUYK9+YU
 OdI=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Dec 2022 17:49:47 -0800
IronPort-SDR: T2YXDWyl5zmwYbCcU0hOkpIgkffJccfeZqQu3aJW1eLv6flvpVr7IP7dhUEtCqMHqr7GRSBDUW
 v0Wd4F+7YI/rDnQ+xnp8iGXqd66g64JCEwEZBhxfy45FosOvr5LPucE6AkQbToqaCKW/QJ24ds
 kA56UDCuyaJP8cVCt9lmdOLOGx9esVnGcccvnQIRYuDmddmkFixeD76ZuhHvUAGjWiwkqaC0Oh
 L3rj0950phvNo9mteY16Td1V1wARJQtGQ0BcI+O8d3Efk2McO76NcCX7cgP0sfnEpbFDbrowdB
 Xvg=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 06 Dec 2022 18:37:01 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     linux-scsi@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com
Cc:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH] scsi: mpi3mr: refer CONFIG_SCSI_MPI3MR in makefile
Date:   Wed,  7 Dec 2022 11:36:59 +0900
Message-Id: <20221207023659.2411785-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When kconfig item CONFIG_SCSI_MPI3MR was introduced for mpi3mr driver,
makefile of the driver was not modified to refer the kconfig item. Then
mpi3mr.ko is built regardless of the kconfig item value y or m. Also
"make localmodconfig" can not find the kconfig item in the makefile,
then it does not generate CONFIG_SCSI_MPI3MR=m even when mpi3mr.ko is
loaded on the system. Refer the kconfig item to avoid the issues.

Fixes: c4f7ac64616e ("scsi: mpi3mr: Add mpi30 Rev-R headers and Kconfig")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 drivers/scsi/mpi3mr/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/Makefile b/drivers/scsi/mpi3mr/Makefile
index ef86ca46646b..3bf8cf34e1c3 100644
--- a/drivers/scsi/mpi3mr/Makefile
+++ b/drivers/scsi/mpi3mr/Makefile
@@ -1,5 +1,5 @@
 # mpi3mr makefile
-obj-m += mpi3mr.o
+obj-$(CONFIG_SCSI_MPI3MR) += mpi3mr.o
 mpi3mr-y +=  mpi3mr_os.o     \
 		mpi3mr_fw.o \
 		mpi3mr_app.o \
-- 
2.37.1

