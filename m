From: "Sami Waheed" <Sami.Waheed@pmcs.com>
Subject: Incorrect LBA Returned from scsi_get_lba() and blk_rq_pos() (Possible DIF Impact)
Date: Tue, 12 Feb 2013 09:31:17 -0800
Message-ID: <340C71CD25A7EB49BFA81AE8C83926671B2EFFD6@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:47767 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932151Ab3BLRyM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Feb 2013 12:54:12 -0500
Received: from bby1mta03.pmc-sierra.bc.ca (localhost.pmc-sierra.bc.ca [127.0.0.1])
	by localhost (Postfix) with SMTP id E3B4610700FC
	for <linux-scsi@vger.kernel.org>; Tue, 12 Feb 2013 09:31:51 -0800 (PST)
Received: from bby1exg02.pmc_nt.nt.pmc-sierra.bc.ca (bby1exg02 [216.241.231.167])
	by bby1mta03.pmc-sierra.bc.ca (Postfix) with SMTP id D37DA10700FA
	for <linux-scsi@vger.kernel.org>; Tue, 12 Feb 2013 09:31:51 -0800 (PST)
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I am testing a SCSI/SAS target with a block size of 4K.    I noticed
that scsi_get_lba which calls blk_rq_pos is returning an incorrect LBA.
The returned LBA value is 8x the actual LBA specified in the CDB:

The following "end_request:" message is printed from blk-core.c:

[  812.451579] sd 6:0:0:0: [sdb]  
[  812.451582] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[  812.451585] sd 6:0:0:0: [sdb]  
[  812.451587] Sense Key : Aborted Command [current] 
[  812.451591] sd 6:0:0:0: [sdb]  
[  812.451593] Add. Sense: No additional sense information
[  812.451596] sd 6:0:0:0: [sdb] CDB: 
[  812.451597] Write(10): 2a 20 00 00 03 e8 00 00 01 00
[  812.451606] end_request: I/O error, dev sdb, sector 8000

Above CDB has LBA=0x3e8 which is 1000d.  Printed sector size above is
8000d


I, also, noticed that several drivers use the scsi_get_lba inline in
scsi_cmnd.h to set/check ref tag for DIF.  On a 4K device, this is
resulting in an incorrect ref tag.

Tested with kernel 3.7.5.

Regards,
--sami
