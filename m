From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: sbp2: allow WRITE SAME and REPORT SUPPORTED
 OPERATION CODES
Date: Sun, 25 Nov 2012 18:45:25 +0100
Message-ID: <20121125184525.0b7967c4@stein>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:42847 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab2KYRpk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Nov 2012 12:45:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux1394-devel@lists.sourceforge.net
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>

The commits
    3c6bdaeab4fd "[SCSI] Add a report opcode helper"
    5db44863b6eb "[SCSI] sd: Implement support for WRITE SAME"
introduced in-kernel uses of the mentioned commands but cautiously
blacklisted for any IEEE 1394 (SBP-2/3) targets and some other
transports.

I looked through a range of SBP devices and found that the blacklist
flags can be removed:

The kernel never attempts these commands if the device's INQUIRY
data claim a SCSI revision of less than 0x05.  This is the case with
all SBP devices that I checked, except for two devices (both based on
the OXUF936QSE chip but having different firmwares) which claimed
a revision of 0x05 i.e. conformance with SPC-3.

I tried "sg_opcodes" from sg3_utils on these two devices and several
of the other ones and did not encounter any apparent firmware bug
with it.  (All of them returned Illegal Request/ Invalid command
operation code and carried on.)

I did not try "sg_write_same" on any of the devices; but since the
two SPC-3 devices are correctly identified as "fully provisioned",
won't issue WRITE SAME to them either.

Hence let's remove the no_report_opcodes and no_write_same blacklist
flags so that these commands can be used on respectively capable
targets.  I guess the Linux sbp-target could be such a target.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/sbp2.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index bb1b392..1162d6b 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -1546,8 +1546,6 @@ static int sbp2_scsi_slave_configure(struct scsi_device *sdev)
 	struct sbp2_logical_unit *lu = sdev->hostdata;
 
 	sdev->use_10_for_rw = 1;
-	sdev->no_report_opcodes = 1;
-	sdev->no_write_same = 1;
 
 	if (sbp2_param_exclusive_login)
 		sdev->manage_start_stop = 1;
-- 
1.7.12



-- 
Stefan Richter
-=====-===-- =-== ==--=
http://arcgraph.de/sr/
