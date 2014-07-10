From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 79901] New: Extremely slow boot on Promise VTrak E610f due to
 sd_mod RSOC usage
Date: Thu, 10 Jul 2014 13:23:57 +0000
Message-ID: <bug-79901-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:43418 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbaGJNYC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jul 2014 09:24:02 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 0A25920340
	for <linux-scsi@vger.kernel.org>; Thu, 10 Jul 2014 13:24:00 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 4328F202F0
	for <linux-scsi@vger.kernel.org>; Thu, 10 Jul 2014 13:23:58 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=79901

            Bug ID: 79901
           Summary: Extremely slow boot on Promise VTrak E610f due to
                    sd_mod RSOC usage
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 3.14.7
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: rraptorr@nails.eu.org
        Regression: No

Recently I've started upgrading all of my machines to kernel 3.14 (from Debian
wheezy backports to be precise). Mostly there were not problems, but I've
stumbled upon weird behavior on Fibre Channel servers (QLogic cards inside HP
blades) using Promise VTrak E610f arrays.

As soon as SCSI subsystem tries to detect partitions a lot of SCSI errors are
reported. The system stalls (but initramfs is responsive) for about 20-30
minutes (depending on number of arrays and LUNs). After that time, disk
detection finishes and system continues booting as usual. Everything works
perfectly afterwards.

I've spent some time fiddling with qla2xxx driver versions, SCSI scanning
options and anything else I could think of. Finally, I was able to find
culprit. The problem lies in sd_mod usage of scsi_report_opcode(). This
function is used to determine if the disk supports WRITE SAME command. It does
so by issuing REPORT SUPPORTED OPERATION CODES command. Unfortunately, it seems
Promise VTrak E610f really, really does not like RSOC. As soon as RSOC is
issued the array stalls for a while, then kernel tries to abort the command and
finally it must reset the port. Fortunately the array starts working again
after the reset. I've also verified this behavior with sg_opcodes utility.

Commit that introduced RSOC usage in sd_mod:
http://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/?id=98dcc2946adbe4349ef1ef9b99873b912831edd4
Removing it fixes the issue.

I'm not sure what is the correct way to fix this as I'm not very familiar with
SCSI spec. If RSOC support cannot be reliably determined then probably some
kind of blacklist should be introduced.

As a workaround, I've modified qla2xxx driver to set 'no_write_same' flag.
While not directly related it forces sd_mod not to issue RSOC and it is easier
for me to ship Debian package with modified single driver (I'd prefer not to
manage my own kernel packages).

-- 
You are receiving this mail because:
You are the assignee for the bug.
