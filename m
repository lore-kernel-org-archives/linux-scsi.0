From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 00/10] scsi: avoid linebreaks in syslog output
Date: Fri, 12 Oct 2012 10:33:40 +0200
Message-ID: <1350030830-25614-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34550 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933255Ab2JLIdx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Oct 2012 04:33:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

This patchset updates the SCSI midlayer to use dev_printk() instead
of the simple printk(). The main objective here is to avoid line-breaks
in syslog output; with the current state it's nearly impossible to match
the output to the occurring device; under high load even the CDB will
be split off into individual bytes, spread randomly across the lines.
Which makes debugging via scsi_logging_level _really_ hard.
In addition we'll be getting the syslog messages nicely prefixed with
the device, which will make userspace logging daemons happy.

Before:
[  297.300605] sd 2:0:3:2: Send: 
[  297.300607] 0xffff8802348b0980 
[  297.300610] sd 2:0:3:2: CDB: 
[  297.300615] Test Unit Ready: 00 00 00 00 00 00
[  297.300747] sd 2:0:3:2: Done: 
[  297.300750] 0xffff8802348b0980 SUCCESS
[  297.300753] sd 2:0:3:2:  
[  297.300755] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
[  297.300758] sd 2:0:3:2: CDB: 
[  297.300764] Test Unit Ready: 00 00 00 00 00 00
[  297.300766] sd 2:0:3:2:  
[  297.300769] Sense Key : Unit Attention [current] 
[  297.300771] Info fld=0x0
[  297.300772] sd 2:0:3:2:  
[  297.300776] Add. Sense: Capacity data has changed

After:
[  636.683556] sd 2:0:3:2: Send: 0xffff88043145eec0
[  636.727856] sd 2:0:3:2: CDB: Test Unit Ready: 00 00 00 00 00 00
[  636.785330] sd 2:0:3:2: Done: 0xffff88043145eec0 SUCCESS
[  636.838228] sd 2:0:3:2: Result: hostbyte=DID_OK driverbyte=DRIVER_OK
[  636.899099] sd 2:0:3:2: CDB: Test Unit Ready: 00 00 00 00 00 00
[  636.955905] sd 2:0:3:2: Sense Key : Unit Attention [current] 
[  637.069179] sd 2:0:3:2: Add. Sense: Capacity data has changed


Hannes Reinecke (10):
  sg: Use dev_printk
  sr: Use dev_printk()
  scsi: Avoid linebreaks in syslog output
  scsi: Use sdev_printk() for logging
  scsi: use buffer for print_opcode_name()
  scsi: use single printk call in scsi_print_command()
  scsi: use buffer for scsi_show_result()
  scsi: open-code scsi_decode_sense_buffer()
  scsi: decode descriptor sense
  scsi: use local buffer for decoding sense data

 drivers/scsi/constants.c  |  406 +++++++++++++++++++++++++--------------------
 drivers/scsi/scsi.c       |   54 ++++---
 drivers/scsi/scsi_error.c |  190 ++++++++++++++-------
 drivers/scsi/scsi_lib.c   |   13 +-
 drivers/scsi/scsi_scan.c  |   68 ++++----
 drivers/scsi/sd.c         |   16 +-
 drivers/scsi/sg.c         |  187 ++++++++++++---------
 drivers/scsi/sr.c         |   47 +++---
 drivers/scsi/sr.h         |    4 +
 include/scsi/scsi_dbg.h   |    6 +-
 include/scsi/scsi_eh.h    |    8 +-
 11 files changed, 588 insertions(+), 411 deletions(-)

-- 
1.7.4.2

