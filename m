Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2665CC433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Nov 2022 01:44:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232471AbiKKBo4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Nov 2022 20:44:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232574AbiKKBow (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Nov 2022 20:44:52 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95837E47
        for <linux-scsi@vger.kernel.org>; Thu, 10 Nov 2022 17:44:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1668131091; x=1699667091;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ObxZLEA/XpVnrM88UQwlximxW83zvCEYsD2pZyChGys=;
  b=ryCdguD6imF7X6p7d3EkraL286UwlwsB4tHR0ar8q5rWZNCrwqxJrK6V
   LzXPYd7E2UTFR1hchF+cE+mBOJFkr4iGUa8fmFb1wdzfrHBydKwBjM1Om
   clbPK31ETv1oNgdJI5LPjslhDU3DzrS1biPLm6Y/agb8GaVUV1T9p41HQ
   48Qy2Sk+xPlhrAwPGwmzA0qGQm3NtrCULXCp05URJVYQwRg3kvdfp7nAL
   E+UPCES3diBdwioPQlFsOiYEO0N8faQg9TDihvDIV0DBGuefhqsaMNr8j
   agzUlOFxCvCzfwJPFpufccH0mQkBRnM0EgKqEXQu2K6qFnI3EcNejOwfX
   w==;
X-IronPort-AV: E=Sophos;i="5.96,155,1665417600"; 
   d="scan'208";a="216341264"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 11 Nov 2022 09:44:50 +0800
IronPort-SDR: 0+XqfnS3pcFcStXYHHZS6s5eRuxElOBsaMrgxwE8qhdzs3tLdwGmi291FHBA+7Gqm25fB+AOiL
 RBdgiTYQj0RlRpU4XwZL/Mi6NvCbfS6lCtWb5SuZxkVp6HKAzgytDYlT1SO9IploPpnbsuknfr
 erCBcsRXYDJFOo/i5UWq+/KGuFcIn8mvcKr32LXb1IUA3v5TBpslOIUGTB/8AL4RNPIdT26mDN
 vBZHL0gqYCrCv+JpnKk7c/u0RQgcQTDG55t9Tec1kcgT6iHA2oqVCF3dPFnzLj8zYKouMTegzu
 AhM=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Nov 2022 16:58:08 -0800
IronPort-SDR: Gx4ISufoegW1eBwnBpco3MEmYTG6xFwpTm+m42u2y9xF1fgPgBsZQICZ5SNGAQLG+pkHm0e0xW
 UXvor+wTLREg0Qdlh5B4XF4VFIZdBsmcVcuPUsA9F/D+KYjx9IOfhh9CUo00/vAOlQzlP+K5Xw
 GkSMVfKCs+k3KmLlJAWA36ZatNx6Zt5/MxAPY0UxDlTRJ7DPJPegMHCZO74xwSS3jabQn/5sP1
 sCxYsRYY2XaGl9/vCXBPFECh39fRlFYPqAJWZspN/wLXcXw4+V0madKCMOf395LEy9a4erCb3V
 7hY=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 10 Nov 2022 17:44:50 -0800
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
Subject: [PATCH v2] scsi: mpi3mr: suppress command reply debug prints
Date:   Fri, 11 Nov 2022 10:44:49 +0900
Message-Id: <20221111014449.1649968-1-shinichiro.kawasaki@wdc.com>
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
when the module parameter logging_level has value MPI3_DEBUG_SCSI_ERROR=
64, in same manner as mpt3sas driver.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
Changes from v1:
* Changed logging_level flag from MPI3_DEBUG_REPLY to MPI3_DEBUG_SCSI_ERROR

 drivers/scsi/mpi3mr/mpi3mr_os.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index f77ee4051b00..3306de7170f6 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -3265,7 +3265,8 @@ void mpi3mr_process_op_reply_desc(struct mpi3mr_ioc *mrioc,
 	}
 
 	if (scmd->result != (DID_OK << 16) && (scmd->cmnd[0] != ATA_12) &&
-	    (scmd->cmnd[0] != ATA_16)) {
+	    (scmd->cmnd[0] != ATA_16) &&
+	    mrioc->logging_level & MPI3_DEBUG_SCSI_ERROR) {
 		ioc_info(mrioc, "%s :scmd->result 0x%x\n", __func__,
 		    scmd->result);
 		scsi_print_command(scmd);
-- 
2.37.1

