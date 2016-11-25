From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 188861] New: Function csio_config_device_caps() does not set
 error codes on failures
Date: Fri, 25 Nov 2016 11:04:27 +0000
Message-ID: <bug-188861-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:60640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751411AbcKYLEk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Nov 2016 06:04:40 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id 3451220453
        for <linux-scsi@vger.kernel.org>; Fri, 25 Nov 2016 11:04:34 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
        by mail.kernel.org (Postfix) with ESMTP id F3F8F20396
        for <linux-scsi@vger.kernel.org>; Fri, 25 Nov 2016 11:04:27 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=188861

            Bug ID: 188861
           Summary: Function csio_config_device_caps() does not set error
                    codes on failures
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

The function csio_config_device_caps() defined in file
drivers/scsi/csiostor/csio_hw.c returns the value of variable rv at the end. By
reviewing the source code of the caller of csio_config_device_caps(), we can
infer that variable rv should takes a non-zero value on failures. However,
after the check of variable rv at line 1376, its value must be 0. As a result,
0 will be returned even if the subsequent calls to csio_mb_issue() (at line
1389) or csio_mb_fw_retval() (at line 1394) fails. I guess letting rv receives
the return value of csio_hw_validate_caps() at line 1375 may be a typo. Does
the author means "retval" instead of "rv"? Codes related to this bug are
summarised as follows.

csio_config_device_caps @@ drivers/scsi/csiostor/csio_hw.c
1347 static int
1348 csio_config_device_caps(struct csio_hw *hw)
1349 {
1350     struct csio_mb  *mbp;
1351     enum fw_retval retval;
1352     int rv = -EINVAL;
1353 
1354     mbp = mempool_alloc(hw->mb_mempool, GFP_ATOMIC);
1355     if (!mbp) {
1356         CSIO_INC_STATS(hw, n_err_nomem);
1357         return -ENOMEM;
1358     }
         ...
1374     /* Validate device capabilities */
1375     rv = csio_hw_validate_caps(hw, mbp); // use "retval" instead of "rv"?
1376     if (rv != 0)
1377         goto out;
1378 
1379     /* Don't config device capabilities if already configured */
1380     if (hw->fw_state == CSIO_DEV_STATE_INIT) {
1381         rv = 0;
1382         goto out;
1383     }
1384 
1385     /* Write back desired device capabilities */
1386     csio_mb_caps_config(hw, mbp, CSIO_MB_DEFAULT_TMO, true, true,
1387                 false, true, NULL);
1388 
1389     if (csio_mb_issue(hw, mbp)) {
1390         csio_err(hw, "Issue of FW_CAPS_CONFIG_CMD(w) failed!\n");
             // on this error, the return value is 0
1391         goto out;
1392     }
1393 
1394     retval = csio_mb_fw_retval(mbp);
1395     if (retval != FW_SUCCESS) {
1396         csio_err(hw, "FW_CAPS_CONFIG_CMD(w) returned %d!\n", retval);
             // on this error, the return value is 0
1397         goto out;
1398     }
1399 
1400     rv = 0;
1401 out:
1402     mempool_free(mbp, hw->mb_mempool);
1403     return rv;
1404 }

Thanks very much!

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
