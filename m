From: Grahame Bowland <grahame@ucs.uwa.edu.au>
Subject: Megaraid slowdowns on 2850
Date: Tue, 18 Jul 2006 13:45:57 +0800
Message-ID: <C0E29695.3704A%grahame@ucs.uwa.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from asclepius.uwa.edu.au ([130.95.128.56]:61130 "EHLO
	asclepius.uwa.edu.au") by vger.kernel.org with ESMTP
	id S1750714AbWGRFp6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jul 2006 01:45:58 -0400
Received: from asclepius.kas (localhost.localdomain [127.0.0.1])
	by asclepius.uwa.edu.au (Postfix) with SMTP id B06BB1836C8
	for <linux-scsi@vger.kernel.org>; Tue, 18 Jul 2006 13:45:56 +0800 (WST)
Received: from asclepius (localhost.localdomain [127.0.0.1])
	by asclepius.prekas (Postfix) with SMTP id 9EC621852A9
	for <linux-scsi@vger.kernel.org>; Tue, 18 Jul 2006 13:45:56 +0800 (WST)
Received: from [130.95.86.174] (unknown [130.95.86.174])
	by asclepius.input (Postfix) with ESMTP id 87A9B1847C7
	for <linux-scsi@vger.kernel.org>; Tue, 18 Jul 2006 13:45:56 +0800 (WST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi all

We're having an odd problem running 2.6.17.6 on two of our Dell 2850
machines. They work fine at first, but then suddenly it seems that the IO
locks up. Using hdparm to get some rough numbers, we see < 200KB/sec
throughput.

Both the machines work fine with 2.4.30 (CONFIG_MEGARAID2) and we're running
the new megaraid (CONFIG_MEGARAID_MM) on 2.6.17.6 now. I saw this in the
list archives and it seemed to help:
  echo 8 > /sys/block/sda/queue/nr_requests

Here's the dmesg lines for megaraid - we're not seeing anything logged when
the machine slows right down.
megaraid cmm: 2.20.2.6 (Release Date: Mon Mar 7 00:01:03 EST 2005)
megaraid: 2.20.4.8 (Release Date: Mon Apr 11 12:27:22 EST 2006)
megaraid: probe new device 0x1028:0x0013:0x1028:0x016d: bus 2:slot 14:func 0
megaraid: fw version:[521S] bios version:[H430]

Some graphs of what happens:
http://lethe.uwa.edu.au/lrrd/Servers/cyllene.uwa.edu.au.html
(the spike in eth0 connections and number of processes seems to be related
to a lot of pop/imap processes stuck in iowait)

It's an odd problem, is there anything we can try? Any suggestions would be
really appreciated - if any more info would help debugging this, just let me
know..

Cheers
Grahame

-- 
Grahame Bowland                       Email: grahame.bowland@uwa.edu.au
Information Technology Services       Phone: +61 8 6488 1175
The University of Western Australia     Fax: +61 8 6488 1109
                                     CRICOS: 00126G




