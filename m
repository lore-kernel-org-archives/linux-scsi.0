From: Laurence Oberman <loberman@redhat.com>
Subject: Patch: lpfc: Modify Emulex lpfc LPFC_DEFAULT_SG_SEG_CNT to 128 for
 default larger sg_io capability
Date: Wed, 8 Feb 2017 15:07:12 -0500 (EST)
Message-ID: <30301867.28563578.1486584432250.JavaMail.zimbra@redhat.com>
References: <356097050.28561599.1486583932322.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx5-phx2.redhat.com ([209.132.183.37]:52468 "EHLO
        mx5-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750962AbdBHUHb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2017 15:07:31 -0500
Received: from zmail22.collab.prod.int.phx2.redhat.com (zmail22.collab.prod.int.phx2.redhat.com [10.5.83.26])
        by mx5-phx2.redhat.com (8.14.4/8.14.4) with ESMTP id v18K7C8e058944
        for <linux-scsi@vger.kernel.org>; Wed, 8 Feb 2017 15:07:12 -0500
In-Reply-To: <356097050.28561599.1486583932322.JavaMail.zimbra@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI List <linux-scsi@vger.kernel.org>

We have been seeing issues with qemu_kvm virtual guests where if they issue 
I/O to direct attached SCSI passthrough LUNS with large I/O sizes such as 512K
the sg_io will fail with -EINVAL.

Simple reproducer is here.

strace -e ioctl sg_dd if=/dev/zero of=/dev/sdae bpt=0x400 count=0x400 blk_sgio=1
Assume default 'bs' (block size) of 512 bytes
ioctl(4, SG_IO, {'S', SG_DXFER_FROM_DEV, cmd[6]=[12, 00, 00, 00, 24, 00], mx_sb_len=64, iovec_count=0, dxfer_len=36, timeout=60000, flags=0, data[36]=["\0\0\5\2\37\270\0\2LIO-ORG block-15        "...], status=00, masked_status=00, sb[0]=[], host_status=0, driver_status=0, resid=0, duration=0, info=0}) = 0
ioctl(4, SG_IO, {'S', SG_DXFER_TO_DEV, cmd[10]=[2a, 00, 00, 00, 00, 00, 00, 04, 00, 00], mx_sb_len=64, iovec_count=0, dxfer_len=524288, timeout=60000, flags=0, data[524288]=["\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...]}) = -1 EINVAL (Invalid argument)
writing (SG_IO) on sg device, error: Invalid argument
sg_write failed, seek=0
Some error occurred,  remaining block count=1024
1024+0 records in
0+0 records out

Qlogic defaults to 128 so has not been seeing this but lpfc does not.
Would like to avoid having to set this in the module parameters to 128.

Tested-by:     Laurence Oberman <loberman@redhat.com>
Signed-off-by: Laurence Oberman <loberman@redhat.com>

>From 23996dcbdd9b505d18d59ecde961c87f76fc9c2e Mon Sep 17 00:00:00 2001
From: Laurence Oberman <loberman@redhat.com>
Date: Wed, 8 Feb 2017 14:49:05 -0500
Subject: [PATCH] Modified LPFC_DEFAULT_SG_SEG_CNT to 128 to match Qlogic. This
 will allow larger sg_io passthrough for qemu_kvm guests that expect the
 larger setting for I/O large rthen 512k.

---
 drivers/scsi/lpfc/lpfc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 8a20b4e..8f86d41 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -42,7 +42,7 @@
 #define LPFC_MAX_NS_RETRY	3	/* Number of retry attempts to contact
 					   the NameServer  before giving up. */
 #define LPFC_CMD_PER_LUN	3	/* max outstanding cmds per lun */
-#define LPFC_DEFAULT_SG_SEG_CNT 64	/* sg element count per scsi cmnd */
+#define LPFC_DEFAULT_SG_SEG_CNT 128	/* sg element count per scsi cmnd */
 #define LPFC_DEFAULT_MENLO_SG_SEG_CNT 128	/* sg element count per scsi
 		cmnd for menlo needs nearly twice as for firmware
 		downloads using bsg */
-- 
1.8.3.1



 
