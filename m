Return-Path: <SRS0=0D1w=7E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79346C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 22 May 2020 08:49:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46C99206C3
	for <linux-scsi@archiver.kernel.org>; Fri, 22 May 2020 08:49:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729365AbgEVIti convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 May 2020 04:49:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:58816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728152AbgEVIth (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 May 2020 04:49:37 -0400
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-scsi@vger.kernel.org
Subject: [Bug 207855] New: arcconf host reset causes kernel panic -> driver
 crash?
Date:   Fri, 22 May 2020 08:49:36 +0000
X-Bugzilla-Reason: AssignedTo
X-Bugzilla-Type: new
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: IO/Storage
X-Bugzilla-Component: SCSI
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: janpieter.sollie@edpnet.be
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: linux-scsi@vger.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-207855-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=207855

            Bug ID: 207855
           Summary: arcconf host reset causes kernel panic -> driver
                    crash?
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 5.6.13
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: janpieter.sollie@edpnet.be
        Regression: No

Created attachment 289227
  --> https://bugzilla.kernel.org/attachment.cgi?id=289227&action=edit
last dmesg captured

When performing a arcconf operation (assign hot-spare) on a adaptec 72405 SAS
controller, the program crashes with the error "segmentation fault", but
apparently, the driver is not too happy with it either: it becomes
unresponsive, and makes it impossible to access scsi devices on the SAS
controller.
Additional tricks to perform a PCI level reset ultimately lead to a kernel
panic:
linuxserver# echo 1 > /sys/bus/pci/devices/0000\:04\:00.0/reset
(wait a minute)
linuxserver# echo 1 > /sys/bus/pci/rescan
(wait a minute)
linuxserver# umount /data/* (where all SAS devices are mounted)
(hangs indefinitely) 
linuxserver# echo auto > /sys/bus/pci/devices/0000\:04\:00.0/power/control
linuxserver# echo "0000:04:00.0" > /sys/bus/pci/drivers/aacraid/unbind
--PANIC--

I haven't been able to C/P the panic output yet, working on a kexec kernel or
crash dump.
The root directory is NOT one of the SAS devices, it is on a generic SATA
controller

-- 
You are receiving this mail because:
You are the assignee for the bug.
