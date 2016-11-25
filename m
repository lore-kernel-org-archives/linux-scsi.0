From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 188681] New: Function csio_hw_flash_erase_sectors() does not
 return correct error codes on failures
Date: Fri, 25 Nov 2016 10:48:22 +0000
Message-ID: <bug-188681-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:58026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751164AbcKYKsf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Nov 2016 05:48:35 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id A365920456
        for <linux-scsi@vger.kernel.org>; Fri, 25 Nov 2016 10:48:29 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
        by mail.kernel.org (Postfix) with ESMTP id BCEBF20453
        for <linux-scsi@vger.kernel.org>; Fri, 25 Nov 2016 10:48:22 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=188681

            Bug ID: 188681
           Summary: Function csio_hw_flash_erase_sectors() does not return
                    correct error codes on failures
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: linux-4.9-rc6
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: bianpan2010@ruc.edu.cn
        Regression: No

>From the usages of function csio_hw_flash_erase_sectors() defined in
drivers/scsi/csiostor/csio_hw.c, we can infer that it should return a non-zero
error code when something goes wrong. However, it will return 0 even the calls
to csio_hw_sf1_write() or csio_hw_flash_wait_op() fails. Maybe it is better to
use "return ret;" instead of "return 0;" at line 616. Codes related to this bug
are summarised as follows.

csio_hw_flash_erase_sectors @@ drivers/scsi/csiostor/csio_hw.c
 589 static int
 590 csio_hw_flash_erase_sectors(struct csio_hw *hw, int32_t start, int32_t
end)
 591 {
 592     int ret = 0;
 593 
 594     while (start <= end) {
 595 
 596         ret = csio_hw_sf1_write(hw, 1, 0, 1, SF_WR_ENABLE);
 597         if (ret != 0)
 598             goto out;
 599 
 600         ret = csio_hw_sf1_write(hw, 4, 0, 1,
 601                     SF_ERASE_SECTOR | (start << 8));
 602         if (ret != 0)
 603             goto out;
 604 
 605         ret = csio_hw_flash_wait_op(hw, 14, 500);
 606         if (ret != 0)
 607             goto out;
 608 
 609         start++;
 610     }
 611 out:
 612     if (ret)
 613         csio_err(hw, "erase of flash sector %d failed, error %d\n",
 614              start, ret);
 615     csio_wr_reg32(hw, 0, SF_OP_A);    /* unlock SF */
 616     return 0;          // return ret?
 617 }

csio_hw_fw_dload @@ drivers/scsi/csiostor/csio_hw.c
 667 static int
 668 csio_hw_fw_dload(struct csio_hw *hw, uint8_t *fw_data, uint32_t size)
 669 {
         ...
 719     ret = csio_hw_flash_erase_sectors(hw, FLASH_FW_START_SEC,
 720                       FLASH_FW_START_SEC + i - 1);
 721     if (ret) {           // check the return value of
csio_hw_flash_erase_sectors()
 722         csio_err(hw, "Flash Erase failed\n");
 723         goto out;
 724     }
         ...
 755 out:
 756     if (ret)
 757         csio_err(hw, "firmware download failed, error %d\n", ret);
 758     return ret;
 759 }

Thanks very much!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
