From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 85101] hpsa + P410 does not show connected HP SAS port
 expanders
Date: Thu, 25 Sep 2014 22:22:04 +0000
Message-ID: <bug-85101-11613-r7FDruKxyT@https.bugzilla.kernel.org/>
References: <bug-85101-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:45179 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678AbaIYWWH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Sep 2014 18:22:07 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 49FB5202E5
	for <linux-scsi@vger.kernel.org>; Thu, 25 Sep 2014 22:22:06 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id AEA54202B8
	for <linux-scsi@vger.kernel.org>; Thu, 25 Sep 2014 22:22:04 +0000 (UTC)
In-Reply-To: <bug-85101-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=85101

--- Comment #6 from linux-ide@crashplan.pro ---
The HP Smart Array P410 still has its issues: sometimes the diagnostics LED
turns amber, other times it works ok.

As a fall back a Marvell controller detects the HP SAS expander card fine:
# lsscsi -g | grep HP
[6:0:0:0]    enclosu HP       HP SAS EXP Card  2.08  -          /dev/sg1

I am not able to figure out a correct sg_write_buffer command. Run from the
directory where the unpacked binary image is stored:
# sg_write_buffer --bpw=4096 -v --in=PUF21000.bin /dev/sg1
tried to read 8388608 bytes from PUF21000.bin, got 1509632 bytes
will write 1509632 bytes
sending write buffer, mode=0x0, mspec=0, id=0,  offset=0, len=4096
    Write buffer cmd: 3b 00 00 00 00 00 00 10 00 00
write buffer:  Fixed format, current;  Sense key: Illegal Request
 Additional sense: Invalid field in cdb
Write buffer failed: Illegal request sense key, apart from Invalid opcode

Any suggestions for the correct sg_write_buffer statement for writing to an HP
SAS expander card?

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
