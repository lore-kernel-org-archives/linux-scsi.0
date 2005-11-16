From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Subject: U320 SCSI negotiation problem in Linux 2.6.13 and later implementations
 on LSI Logic / Symbios Logic 53c1030 PCI-X Fusion-MPT Dual Ultra320 SCSI
 (rev 08)
Date: Wed, 16 Nov 2005 15:57:12 -0500
Message-ID: <437B9D28.8000306@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ccerelbas01.cce.hp.com ([161.114.21.104]:7911 "EHLO
	ccerelbas01.cce.hp.com") by vger.kernel.org with ESMTP
	id S1030476AbVKPUuO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Nov 2005 15:50:14 -0500
Received: from mailrelay01.cce.cpqcorp.net (mailrelay01.cce.cpqcorp.net [16.47.68.171])
	by ccerelbas01.cce.hp.com (Postfix) with ESMTP id 59AAF20001BF
	for <linux-scsi@vger.kernel.org>; Wed, 16 Nov 2005 14:50:14 -0600 (CST)
Received: from kitche.zk3.dec.com (kitche1.zk3.dec.com [16.140.160.161])
	by mailrelay01.cce.cpqcorp.net (Postfix) with ESMTP id 074293EA2
	for <linux-scsi@vger.kernel.org>; Wed, 16 Nov 2005 14:50:13 -0600 (CST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Whilst running a 2.6.14.2 kernel, I started running into severe 
performance issues with the following configuration:

- 4-way IA64 box (HP rx4640)
- 4x53c1030
- 8 dual-bus MSA 30 disk enclosures + six 72GB (U320 wide-capable) 
drives per bus (total of 48 disks)
- [[BTW: req_depth is being calculated as 255 per adapter in this 
configuration...]]

What I found was that a small number of drives (8 or 9 out of the 48) 
would come up at asynchronous narrow (8-bit) and very slow rates, while 
the rest came up correctly. After trying various kernel revisions - I 
had been using 2.6.9 prior to jumping to 2.6.14.2 - I narrowed it down 
to having occurred between 2.6.12.6 and 2.6.13 (it works correctly in 
2.6.12.6, but fails in 2.6.13 and afterwards).

With some more debugging, I found that what was happening was that 
during the negotiations, mpt_config would fail due to mpt_get_msg_frame 
returning -EAGAIN (frames were exhausted). I changed the code in 
mpt_config to do the following on an -EAGAIN: sleep for a short period 
of time, and then retry the mpt_get_msg_frame call; and this appears to 
have solved the problem - all the negotiations complete successfully, 
and I have full U320/wide disks across the board.

I'm not at all sure why the problem appears in 2.6.13 (and later) - I'm 
*assuming* that it has to do with either better parallel capabilities 
present in the base OS and/or better coding within the Fusion driver(s) 
producing more parallel activities (which exhaust the number of frames 
available).

I'm not quite sure how to proceed from here: I have sent a similar 
message to mpt_linux_developer@lsil.com (as the source code indicated 
that as one option).

Alan D. Brunelle
Hewlett-Packard Company
Open Source and Linux Organization
Performance and Scalability Group

