Return-Path: <SRS0=/6u/=WU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A501DC3A59E
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Aug 2019 12:34:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 759382082F
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Aug 2019 12:34:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727928AbfHXMe6 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Aug 2019 08:34:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:57222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727590AbfHXMe6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 24 Aug 2019 08:34:58 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 204685] New: Sometimes Lenovo Yoga C630 WOS boot is delayed due
 to UFS initialization error
Date:   Sat, 24 Aug 2019 12:34:56 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: AssignedTo scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Product: SCSI Drivers
X-Bugzilla-Component: Other
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: russianneuromancer@ya.ru
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: scsi_drivers-other@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-204685-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=204685

            Bug ID: 204685
           Summary: Sometimes Lenovo Yoga C630 WOS boot is delayed due to
                    UFS initialization error
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 5.2
          Hardware: ARM
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: scsi_drivers-other@kernel-bugs.osdl.org
          Reporter: russianneuromancer@ya.ru
        Regression: No

Created attachment 284585
  --> https://bugzilla.kernel.org/attachment.cgi?id=284585&action=edit
Linux 5.2.0 dmesg from Lenovo Yoga C630 WOS

I noticed that sometimes Linux boot is delayed on Lenovo Yoga C630 WOS by
following error:

[   33.772190] ufshcd-qcom 1d84000.ufshc: ufshcd_abort: Device abort task at
tag 7
[   33.774946] sd 0:0:0:5: [sdf] tag#7 CDB: Read(10) 28 00 00 00 00 00 00 00 01
00
[   33.777732] host_regs: 00000000: 1587031f 00000000 00000210 00000000
[   33.780508] host_regs: 00000010: 01000000 00010217 00000c96 00000000
[   33.783281] host_regs: 00000020: 00000000 00030e75 00000000 00000000
[   33.786061] host_regs: 00000030: 0000010f 00000001 80000010 00000000
[   33.788842] host_regs: 00000040: 00000000 00000000 00000000 00000000
[   33.791616] host_regs: 00000050: 661cd000 00000002 ab000080 00000000
[   33.794403] host_regs: 00000060: 00000001 ff1fffff 00000000 00000000
[   33.797195] host_regs: 00000070: 661cc000 00000002 00000000 00000000
[   33.799987] host_regs: 00000080: 00000001 00000000 00000000 00000000
[   33.802763] host_regs: 00000090: 00000002 15710000 00000000 00000003
[   33.805525] ufshcd-qcom 1d84000.ufshc: hba->ufs_version = 0x210,
hba->capabilities = 0x1587031f
[   33.808338] ufshcd-qcom 1d84000.ufshc: hba->outstanding_reqs = 0xab000080,
hba->outstanding_tasks = 0x0
[   33.811144] ufshcd-qcom 1d84000.ufshc: last_hibern8_exit_tstamp at 0 us,
hibern8_exit_cnt = 0
[   33.813951] ufshcd-qcom 1d84000.ufshc: No record of pa_err uic errors
[   33.816735] ufshcd-qcom 1d84000.ufshc: No record of dl_err uic errors
[   33.819496] ufshcd-qcom 1d84000.ufshc: No record of nl_err uic errors
[   33.822236] ufshcd-qcom 1d84000.ufshc: No record of tl_err uic errors
[   33.824947] ufshcd-qcom 1d84000.ufshc: No record of dme_err uic errors
[   33.827660] ufshcd-qcom 1d84000.ufshc: clk: core_clk, rate: 200000000
[   33.830371] ufshcd-qcom 1d84000.ufshc: clk: core_clk_unipro, rate: 150000000
[   33.833118] HCI Vendor Specific Registers 00000000: 000000c8 00000000
00000000 00000000
[   33.835858] HCI Vendor Specific Registers 00000010: 00000000 00000000
00000001 5c5c052c
[   33.838566] HCI Vendor Specific Registers 00000020: 3f0113ff 30010001
00000000 00000000
[   33.841258] HCI Vendor Specific Registers 00000030: 00000000 00000000
02500000 00000000

After boot is completion UFS storage is accessible, as you can see in attached
Linux 5.2 boot log.
Original bugreport: https://github.com/aarch64-laptops/build/issues/15
If needed there is also Linux 5.3rc1 boot logs attached to this message:
https://github.com/aarch64-laptops/build/issues/13#issuecomment-518707493

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
