From: "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>
Subject: [PATCH] scsi: aacraid: Add a small delay after IOP reset
Date: Tue, 19 Sep 2017 12:11:55 -0300
Message-ID: <20170919151156.29412-1-gpiccoli@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57726 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751572AbdISPME (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Sep 2017 11:12:04 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v8JFBPim147291
        for <linux-scsi@vger.kernel.org>; Tue, 19 Sep 2017 11:12:03 -0400
Received: from e17.ny.us.ibm.com (e17.ny.us.ibm.com [129.33.205.207])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2d35ner1ne-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 19 Sep 2017 11:12:03 -0400
Received: from localhost
        by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <gpiccoli@linux.vnet.ibm.com>;
        Tue, 19 Sep 2017 11:12:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: aacraid@microsemi.com, linux-scsi@vger.kernel.org
Cc: gpiccoli@linux.vnet.ibm.com, RaghavaAditya.Renukunta@microsemi.com, david.carroll@microsemi.com, brking@linux.vnet.ibm.com, dougmill@linux.vnet.ibm.com, stable@vger.kernel.org

Commit 0e9973ed3382 ("scsi: aacraid: Add periodic checks to see IOP reset
status") changed the way driver checks if a reset succeeded. Now, after an
IOP reset, aacraid immediately start polling a register to verify the reset
is complete.

This behavior cause regressions on the reset path in PowerPC (at least).
Since the delay after the IOP reset was removed by the aforementioned patch,
the fact driver just starts to read a register instantly after the reset
was issued (by writing in another register) "corrupts" the reset procedure,
which ends up failing all the time.

The issue highly impacted kdump on PowerPC, since on kdump path we
proactively issue a reset in adapter (through the reset_devices kernel
parameter).

This patch (re-)adds a delay right after IOP reset is issued. Empirically
we measured that 3 seconds is enough, but for safety reasons we delay
for 5s (and since it was 30s before, 5s is still a small amount).

For reference, without this patch we observe the following messages
on kdump kernel boot process:

  [ 76.294] aacraid 0003:01:00.0: IOP reset failed
  [ 76.294] aacraid 0003:01:00.0: ARC Reset attempt failed
  [ 86.524] aacraid 0003:01:00.0: adapter kernel panic'd ff.
  [ 86.524] aacraid 0003:01:00.0: Controller reset type is 3
  [ 86.524] aacraid 0003:01:00.0: Issuing IOP reset
  [146.534] aacraid 0003:01:00.0: IOP reset failed
  [146.534] aacraid 0003:01:00.0: ARC Reset attempt failed

Fixes: 0e9973ed3382 ("scsi: aacraid: Add periodic checks to see IOP reset status")
Cc: stable@vger.kernel.org # v4.13+
Signed-off-by: Guilherme G. Piccoli <gpiccoli@linux.vnet.ibm.com>
---
 drivers/scsi/aacraid/src.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 48c2b2b34b72..0c9361c87ec8 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -740,6 +740,8 @@ static void aac_send_iop_reset(struct aac_dev *dev)
 	aac_set_intx_mode(dev);
 
 	src_writel(dev, MUnit.IDR, IOP_SRC_RESET_MASK);
+
+	msleep(5000);
 }
 
 static void aac_send_hardware_soft_reset(struct aac_dev *dev)
-- 
2.14.1
