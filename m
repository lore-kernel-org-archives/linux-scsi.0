Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ECFDC433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Nov 2022 03:12:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbiKIDMN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Nov 2022 22:12:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiKIDMM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2022 22:12:12 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D71C01B9CF
        for <linux-scsi@vger.kernel.org>; Tue,  8 Nov 2022 19:12:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1667963530; x=1699499530;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=zzYZwFhED9e8w/lYxA0enjt0ApQtlUXNWQQs5vJkrPM=;
  b=CoVmwn3o5q7awRDaM6d/7N8c21cGpccbJf0XECRCv+VPB5hM33QaEowo
   OasP+vhTkbKeVSGgqlI1I+dD27K+GASbwpM+Aw1ITPtjlOiRYZ8NLIYVU
   PHgaI/tHz7BKa/I8WdoMQZ+JUoAoOaAo8Gv2TfI5v/DQAufahK5S41NJS
   kwuybE1VQR4O1l7AcI10KSJhrDSPVnrqBR6M+ychEI5p6Jsu0EYqc2sxw
   gKbuz0RAL8Puj3gnUWJGC8Hie3d66zXki6lU89M8D2cjqTsGAy9WLNI97
   Aoup0RqowbSphFIV/phzc69UANHo0d9JDLUSs3BPxeGdLGJCeKiLM4Y/o
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,149,1665417600"; 
   d="scan'208";a="327921010"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2022 11:12:09 +0800
IronPort-SDR: mSptsskn9CEQxjV8AZLamVe3CeabN3gK0zH9zwbRX/vHWiNzHUAc7LZuuufaAs497eQtJzeF1i
 +Cy9Wb0S7YwCo+qp4JXctRqSAID6Alt2Vw8qyIERCrayWEqHPEpEubGpEJzvF6BfBmqj08x2zz
 uOXgid64n8xef3Z4fhppRKlUgQMG9E1HsRpzMmsrnas0KZpTWpSwXSGdFzkuqoXg4bAd4OOagH
 91lanyyGdn2lI4aaSR+sFerc8BWT5HcJM9ZTYnX+u+p4w3KUposap7FzprGEFB9vxyP1uvlslW
 FrQ=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Nov 2022 18:25:30 -0800
IronPort-SDR: WIvCVapTAldW6ZnFggXlTI28e2mYd3FLU0AAB038GjJPfqoPk5DGqmFDCJ7L+0YrfA9N51BFE5
 4qtHf5MsdbFCW5zvik8XM535SzpLSyTkHYWwmtubHszzDTszZ2XsHUG8dCncL+GWrgfhirvp1p
 3/ioJGYhp1eOfYHk+jgqXH8iPRrCiVZUbTKU1FHqD3IjEKy9ULDfsN6VuFtJZuNthIipZLQmda
 aeUkSQFxbekbnJcGdn2RidLw699Wfn6S2y7Ssw248rKXg8rx1qYmSYpIL4rrn9bwhe0CoMehg1
 aNU=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Nov 2022 19:12:08 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     mpi3mr-linuxdrv.pdl@broadcom.com,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH] scsi: mpi3mr: suppress command reply debug prints
Date:   Wed,  9 Nov 2022 12:12:07 +0900
Message-Id: <20221109031207.1605138-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

After it receives command reply, mpi3mr driver checks command result. If
the result is not zero, it prints out command information. This debug
information is confusing since they are printed even when the non-zero
result is expected. "Power-on or device reset occurred" is printed for
Test Unit Ready command at drive detection. Inquiry failure for
unsupported VPD page header is also printed. They are harmless but look
like failures.

To avoid the confusion, print the command reply debug information only
when the module parameter logging_level has value MPI3_DEBUG_REPLY=128,
in same manner as mpt3sas driver.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index f77ee4051b00..2b95d1d375f2 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -3265,7 +3265,8 @@ void mpi3mr_process_op_reply_desc(struct mpi3mr_ioc *mrioc,
 	}
 
 	if (scmd->result != (DID_OK << 16) && (scmd->cmnd[0] != ATA_12) &&
-	    (scmd->cmnd[0] != ATA_16)) {
+	    (scmd->cmnd[0] != ATA_16) &&
+	    mrioc->logging_level & MPI3_DEBUG_REPLY) {
 		ioc_info(mrioc, "%s :scmd->result 0x%x\n", __func__,
 		    scmd->result);
 		scsi_print_command(scmd);
-- 
2.37.1

