From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] scsi_status() macro
Date: Fri, 16 May 2003 15:32:13 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EC477DD.7080409@torque.net>
References: <3EC427D5.3060309@torque.net> <1053047480.3998.120.camel@mulgrave>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010502050509080901010407"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:8718 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S264121AbTEPFSx
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 May 2003 01:18:53 -0400
In-Reply-To: <1053047480.3998.120.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------010502050509080901010407
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

James Bottomley wrote:
> If you're doing this:
> 
> On Thu, 2003-05-15 at 18:50, Douglas Gilbert wrote:
> 
>>+#define scsi_status(result) ((result) & 0x7e)
> 
> 
> because bit0 is reserved in SCSI-2, then it should be 0x3e because bits
> 6 and 7 are also reserved.  Of course, this would clash with the SCSI-3
> definition of TASK ABORTED, sigh.
> 
> Perhaps it's better just not to bother with the mask?

James,
The macro still gets rid of the upper bytes in
scsi_cmnd::result so in needs to be at least
a mask of 0xff.

With a mask of 0x7e it is correct for SCSI-3,
bit 6 is reserved ** in SCSI-2  and "vendor unique"
in SCSI-1 and SCSI_1_CCS. I dug up a SCSI 1 draft and
the Status byte table is attached. So as far as I
can see our only exposure is to SCSI 1 and CCS
devices.

A possible source of confusion with this proposed
patch is that 'scsi_status' is probably one of the
most common variable names in the SCSI subsystem.
As a macro it shouldn't clash but it may confuse.
Alternate patch using get_scsi_status() attached.


** SCSI-2 defines reserved as "set aside for future
standardization" but SPC-3 (spc3r12) nails it down:
"A reserved bit, byte, word or field shall be set to
zero, ...".

Doug Gilbert


--------------010502050509080901010407
Content-Type: text/plain;
 name="scsi1_stat.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi1_stat.txt"

14. Status 

A status byte shall be sent from the target to the initiator during the STATUS 
phase at the termination of each command as specified in Tables 14-1 and 14-2 
unless the command is cleared by an ABORT message, by a BUS DEVICE RESET 
message, or by a "hard" RESET condition.

                                  Table 14-1
                                 Status Byte 

==============================================================================
  Bit|   7    |   6    |   5    |   4    |   3    |   2    |   1    |   0    |
Byte |        |        |        |        |        |        |        |        |
==============================================================================
 0   |Reserved|  Vendor Unique  |        Status Byte Code           |   V    |
==============================================================================


--------------010502050509080901010407
Content-Type: text/plain;
 name="scsi_h2569bk8cc2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi_h2569bk8cc2.diff"

--- linux/drivers/scsi/scsi.h	2003-05-14 18:09:21.000000000 +1000
+++ linux/drivers/scsi/scsi.h2569bk8cc	2003-05-16 14:50:11.046698960 +1000
@@ -90,12 +90,19 @@
  *
  *  These are set by:
  *
- *      status byte = set from target device
+ *      status byte = set from target device (SCSI status value)
  *      msg_byte    = return status from host adapter itself.
  *      host_byte   = set by low-level driver to indicate status.
  *      driver_byte = set by mid-level.
+ *
+ *  Notes about following macros:
+ *	get_scsi_status() returns a standard SCSI status value that
+ *	may be compared with the SAM_STAT_... series of defines.
+ *	status_byte() returns a shifted SCSI status value that matches
+ *	CHECK_CONDITION and friends. status_byte() is deprecated.
  */
-#define status_byte(result) (((result) >> 1) & 0x1f)
+#define get_scsi_status(result) ((result) & 0x7e)
+#define status_byte(result) (((result) >> 1) & 0x1f)	/* deprecated */
 #define msg_byte(result)    (((result) >> 8) & 0xff)
 #define host_byte(result)   (((result) >> 16) & 0xff)
 #define driver_byte(result) (((result) >> 24) & 0xff)

--------------010502050509080901010407--

