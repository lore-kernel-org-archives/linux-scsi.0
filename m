From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 106861] New: DPOFUA should not be related to WCE / Caching mode
 page
Date: Thu, 29 Oct 2015 08:14:51 +0000
Message-ID: <bug-106861-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:41819 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbbJ2IOz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Oct 2015 04:14:55 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D31E5209BD
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2015 08:14:53 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 597E72096A
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2015 08:14:52 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=106861

            Bug ID: 106861
           Summary: DPOFUA should not be related to WCE / Caching mode
                    page
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

The sd driver checks whether the device supports DPO/FUA and reports it to the
FUA readonly attribute. However, they are somehow "depended" on the Caching
mode page and WCE (sd.c).

The fact is, the DPOFUA bit just isn't part of the Caching mode page. Instead
it is reported in DEVICE-SPECIFIC PARAMETER of mode parameter header.

Moreover, I don't see what impact does WCE have on DPO/FUA as per SBC or SAT.
As long as it is implemented correctly, DPO/FUA should be completely fine on
drives without write cache as well.

So IMHO how the kernel handles the checking and reporting simply has logical
mistake.

-- 
You are receiving this mail because:
You are the assignee for the bug.
