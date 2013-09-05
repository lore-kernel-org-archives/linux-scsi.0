From: Bradley Grove <bgrove@attotech.com>
Subject: [PATCH V2 0/7] SCSI: esas2r: Static check fixes
Date: Thu, 5 Sep 2013 13:07:53 -0400
Message-ID: <1378400880-14640-1-git-send-email-bgrove@attotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sw.attotech.com ([208.69.85.34]:35683 "EHLO
	NOTESERV1.attotech.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753121Ab3IERIS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Sep 2013 13:08:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jbottomley@parallels.com
Cc: jseba@attotech.com, davej@redhat.com, Bradley Grove <bgrove@attotech.com>

This series of patches fixes errors detected by smatch and coccinelle.

V2 adds an additional fix, removing a null check on a stack allocated
array.  The test was needed in older versions of the driver when the
buffer was allocated on the heap.   

Bradley Grove (7):
  SCSI: esas2r: smatch - Use biwise rather than logical AND for checking
    if any bit set
  SCSI: esas2r: smatch - Fix dereference that occurs prior to check
  SCSI: esas2r: smatch - Fix dereference that occurs prior to check
  SCSI: esas2r: smatch - Fix overrun due to sprintf appending NULL
  SCSI: esas2r: smatch - Remove test for impossible condition (uint8 >
    255)
  SCSI: esas2r: coccinelle - Replace memcpy with struct assignment
  SCSI: esas2r: Remove null test for stack allocated fw_coredump_buffer

 drivers/scsi/esas2r/esas2r_flash.c | 11 ++++++++---
 drivers/scsi/esas2r/esas2r_init.c  |  8 ++++----
 drivers/scsi/esas2r/esas2r_ioctl.c |  2 +-
 drivers/scsi/esas2r/esas2r_vda.c   |  7 +++++--
 4 files changed, 18 insertions(+), 10 deletions(-)

-- 
1.8.1.4

