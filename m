Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97732C2D0E4
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Nov 2020 06:42:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53CCF223FB
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Nov 2020 06:42:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgKOGmI convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Nov 2020 01:42:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:46152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726625AbgKOGmH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 15 Nov 2020 01:42:07 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 210203] New: linux boot sometimes hang around
 scsi_try_target_reset for a system with SSD/SATA 1.92T *10
Date:   Sun, 15 Nov 2020 06:42:06 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: wangyugui@e16-tech.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-210203-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=210203

            Bug ID: 210203
           Summary: linux boot sometimes hang around scsi_try_target_reset
                    for a system with SSD/SATA 1.92T *10
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 5.4.76 and other 5.4.x
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: wangyugui@e16-tech.com
        Regression: No

Created attachment 293673
  --> https://bugzilla.kernel.org/attachment.cgi?id=293673&action=edit
sysrq-l-t-1.log

linux boot sometimes hang around scsi_try_target_reset for a system with
SSD/SATA 1.92T *10

console output:
        A start job is running for dev-disk-by\x2dlabel-OS_T604.device
                *** always waiting here

Failed to login, so only gathered SysRq info(saved in sysrq-l-t-1.log,
sysrq-l-t-2.log).
- sysrq l command
- sysrq t command

From SysRq info, it seem a problem around scsi_try_target_reset();

[  744.388123] scsi_eh_9       S    0   604      2 0x80004000
[  744.388124] Call Trace:
[  744.388125]  __schedule+0x285/0x6e0
[  744.388126]  ? scsi_try_target_reset+0x90/0x90
[  744.388127]  schedule+0x2f/0xa0
[  744.388128]  scsi_error_handler+0x1c4/0x500
[  744.388129]  ? scsi_eh_get_sense+0x220/0x220
[  744.388130]  kthread+0x112/0x130
[  744.388131]  ? kthread_park+0x80/0x80
[  744.388132]  ret_from_fork+0x1f/0x40


Frequency: about 10%
   only happened in a server with btrfs RAID0 & 10 SSD.
   yet not happened in another two server with the same kernel

OS: centos 7.8/7.9
kernel version:
        5.4.76, 5.4.74, 5.4.73, and others 5.4.x

# lsscsi
[14:0:0:0]   disk    ATA      MK1920GFDKU      HPG0  /dev/sda
[14:0:1:0]   disk    ATA      MK1920GFDKU      HPG0  /dev/sdb
[14:0:2:0]   disk    ATA      MK1920GFDKU      HPG0  /dev/sdc
[14:0:3:0]   disk    ATA      MK1920GFDKU      HPG0  /dev/sdd
[14:0:4:0]   disk    ATA      MK1920GFDKU      HPG0  /dev/sde
[14:0:6:0]   disk    ATA      SAMSUNG MZ7KM1T9 003Q  /dev/sdf
[14:0:7:0]   disk    ATA      SAMSUNG MZ7KM1T9 003Q  /dev/sdg
[14:0:8:0]   disk    ATA      SAMSUNG MZ7KM1T9 003Q  /dev/sdh
[14:0:9:0]   disk    ATA      SAMSUNG MZ7KM1T9 003Q  /dev/sdi
[14:0:10:0]  disk    ATA      SAMSUNG MZ7KM1T9 003Q  /dev/sdj

-- 
You are receiving this mail because:
You are the assignee for the bug.
