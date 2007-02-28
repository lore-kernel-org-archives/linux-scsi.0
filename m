From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 0/4] SCSI: Printing cleanups
Date: Tue, 27 Feb 2007 22:39:05 -0500
Message-ID: <yq17iu36jdy.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:43183 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbXB1Dk4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Feb 2007 22:40:56 -0500
Received: from rgmgw2.us.oracle.com (rgmgw2.us.oracle.com [138.1.186.111])
	by rgminet01.oracle.com (Switch-3.2.4/Switch-3.1.6) with ESMTP id l1S3esKP032172
	for <linux-scsi@vger.kernel.org>; Tue, 27 Feb 2007 20:40:55 -0700
Received: from rcsmt251.oracle.com (rcsmt251.oracle.com [148.87.90.196])
	by rgmgw2.us.oracle.com (Switch-3.2.4/Switch-3.1.7) with ESMTP id l1S3McM2018324
	for <linux-scsi@vger.kernel.org>; Tue, 27 Feb 2007 20:40:54 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


This patch series is the first batch of cleanups in an attempt to make
the SCSI printing more consistent and suitable for human consumption.

Previously a typical error looked like this:

    sd 0:0:0:0: SCSI error: return code = 0x08000002
    sda: Current: sense key: Aborted Command
        Additional sense: Logical block reference tag check failed

You had to have the magic return value decoder ring handy to figure
out what had really happened.  And you had to do the mapping between
sd 0:0:0:0 and sda yourself.


The following patches clean up various bits so that the same
information can be presented in a more readable form:

    sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
    sd 0:0:0:0: [sda] Sense Key : Aborted Command [current] 
    sd 0:0:0:0: [sda] Add. Sense: Logical block reference tag check failed

All printk's from sd.c now have the same prefix.  If logging is turned
on, for instance, we also get:

    sd 0:0:0:0: [sda] Send: 0x0fb89180 
    sd 0:0:0:0: [sda] CDB: Read(16): 88 20 00 00 00 00 00 00 00 20 00 00 00 08 00 00
    sd 0:0:0:0: [sda] Done: 0x0fb89180 SUCCESS

The patches need to be applied in order.

-- 
Martin K. Petersen	Oracle Linux Engineering

