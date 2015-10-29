From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 106841] New: do not output error for simple subenclosure
 (handle Short Enclosure Status diagnostic page)
Date: Thu, 29 Oct 2015 04:26:17 +0000
Message-ID: <bug-106841-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:60421 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226AbbJ2E0V (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Oct 2015 00:26:21 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id B4628209EC
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2015 04:26:19 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 0D293209E7
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2015 04:26:18 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=106841

            Bug ID: 106841
           Summary: do not output error for simple subenclosure (handle
                    Short Enclosure Status diagnostic page)
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 4.2.4
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: tom.ty89@gmail.com
        Regression: No

So I have the following error with a WD My Passport:

[tom@localhost ~]$ journalctl -b -p 3 | grep scsi
Oct 29 11:18:31 localhost kernel: scsi 7:0:0:1: Failed to get diagnostic page
0x8000002
Oct 29 11:18:31 localhost kernel: scsi 7:0:0:1: Failed to bind enclosure -19

Some info of the drive:
[tom@localhost ~]$ sudo sg_ses /dev/sg4
  WD        SES Device        1065
Supported diagnostic pages:
  Supported Diagnostic Pages [sdp] [0x0]
  Short Enclosure Status (SES) [ses] [0x8]
  <unknown> [0x80]
  <unknown> [0x83]
  <unknown> [0x84]
  <unknown> [0x85]
[tom@localhost ~]$ sudo sg_senddiag -P 8 /dev/sg4
Short enclosure status (SES) diagnostic page [0x8] response in hex:
 00     08 00 00 00

According to SES-3 (ses3r10.pdf) Table 10, if diagnostic page 08h is supported,
all others pages from 01h to 0fh are prohibited.

However, the kernel (driver/scsi/ses.c) doesn't seem to be aware of this.

FWIW, my drive have a correct SES page (byte 0 should the page code 08h, byte
2-3 should be 0000h, byte 1 is vendor-specific status).

-- 
You are receiving this mail because:
You are the assignee for the bug.
