From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 63141] New: Linux Kernel will shows "Got wrong page" in kernel
 log when Linux kernel tries to send SCSI ModeSense command with Page code
 0x08 (Caching Mode Page)
Date: Wed, 16 Oct 2013 09:39:01 +0000
Message-ID: <bug-63141-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:56688 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754110Ab3JPJjO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Oct 2013 05:39:14 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id C5C3B20131
	for <linux-scsi@vger.kernel.org>; Wed, 16 Oct 2013 09:39:09 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id ABAAA20461
	for <linux-scsi@vger.kernel.org>; Wed, 16 Oct 2013 09:39:07 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=63141

            Bug ID: 63141
           Summary: Linux Kernel will shows "Got wrong page" in kernel log
                    when Linux kernel tries to send SCSI ModeSense command
                    with Page code 0x08 (Caching Mode Page)
           Product: IO/Storage
           Version: 2.5
    Kernel Version: 3.6.11
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: low
          Priority: P1
         Component: SCSI
          Assignee: linux-scsi@vger.kernel.org
          Reporter: leochen64@gmail.com
        Regression: No

Created attachment 111291
  --> https://bugzilla.kernel.org/attachment.cgi?id=111291&action=edit
SourceCodeComparsionBetween2.6.xAnd3.9.1

Reporter: Leo Chen (Li-Chung Chen)
Report Date: 10/16/13

Issue Descrition: In Linux kernel 3.6.11, sd.c file, host calls
sd_read_cache_type() function to read physical disk or volume cache type. This
function works properly on most physical disks but will fail to read the cache
type on LSI raid volume. The error message in Linux Kernel is "Got wrong page".

However, the Linux kernel works properly in kernel 2.6.x.

Suggestion: If we restore below codes from 2.6.x to 3.6.11 in
sd.c,sd_read_cache_type()function, then the kernel won't report "got wrong
page" in the log. 

/* Take headers and block descriptors into account */
len += data.header_length + data.block_descriptor_length;

I also referenced the SPC-4(SCSI Primary Commands - 4) specification from T10
to check if it's LSI firmware problem to response the wrong parameter length to
the host. According to the description in SPC below, it looks like LSI logical
volume doesn't voilate the specification to response the MODE DATA LENGTH value
to host.

[SPC-4 Description about the Mode Parameter]
When using the MODE SENSE command, the MODE DATA LENGTH field indicates the
length in bytes of the following
data that is available to be transferred. The mode data length does not include
the number of bytes in the MODE
DATA LENGTH field. 
[SPC-4 Description about the Mode Parameter]

Therefore, I'd like to suggest the Linux Kernel to add the code above to make
the kernel handle the cache reading properly.

-- 
You are receiving this mail because:
You are the assignee for the bug.
