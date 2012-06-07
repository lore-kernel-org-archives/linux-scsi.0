From: Norman Diamond <n0diamond@yahoo.co.jp>
Subject: How to detect if a libata ioctl SG_IO had an error?
Date: Thu, 7 Jun 2012 15:46:57 +0900 (JST)
Message-ID: <542808.89361.qm@web100008.mail.kks.yahoo.co.jp>
Reply-To: n0diamond@yahoo.co.jp
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web100008.mail.kks.yahoo.co.jp ([114.111.98.182]:28176 "HELO
	web100008.mail.kks.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752676Ab2FGGq7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Jun 2012 02:46:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

My application wants to detect if an error occured, but in struct sg_io_hdr sg_io, sg_io.driver_status != DRIVER_OK does not say if an error occured, and (sg_io.info & SG_INFO_OK_MASK) != SG_INFO_OK does not say if an error occured.

In http://tldp.org/HOWTO/SCSI-Generic-HOWTO/x322.html:
"A copy of these defines can be found in sg_err.h (see the utilities section): 
SG_ERR_DRIVER_OK [0x00] Typically no suggestion"

Where's sg_err.h?  scsi.h defines DRIVER_OK but no one defines SG_ERR_DRIVER_OK.  Anyway, the real problem is that other values besides DRIVER_OK also mean driver ok.

In http://tldp.org/HOWTO/SCSI-Generic-HOWTO/x364.html:
"SG_INFO_CHECK [0x1] something abnormal happened."

Sense data is abnormal but not an error, so I don't know if an error occured.

In scsi.h:
443 #define DRIVER_OK       0x00    /* Driver status                           */
444 
445 /*
446  *  These indicate the error that occurred, and what is available.
447  */
448 
449 #define DRIVER_BUSY         0x01
450 #define DRIVER_SOFT         0x02
451 #define DRIVER_MEDIA        0x03
452 #define DRIVER_ERROR        0x04
453 
454 #define DRIVER_INVALID      0x05
455 #define DRIVER_TIMEOUT      0x06
456 #define DRIVER_HARD         0x07
457 #define DRIVER_SENSE        0x08

Is DRIVER_SENSE a bitwise value that can be or'ed with other values?

In libata-scsi.c
523         if (driver_byte(cmd_result) == DRIVER_SENSE) {/* sense data available */
524                 u8 *desc = sensebuf + 8;
525                 cmd_result &= ~(0xFF<<24); /* DRIVER_SENSE is not an error */

Line 523 does not test driver_byte(cmd_result) & DRIVER_SENSE.  It looks like DRIVER_SENSE is a value all by itself, not bitwise.

In sc.c:
463         if ((CHECK_CONDITION & hp->masked_status) ||
464             (DRIVER_SENSE & hp->driver_status))

Line 464 does not test DRIVER_SENSE == hp->driver_status.  It looks like DRIVER_SENSE is bitwise, not a value all by itself.

I sense inconsistency.

In sc.c:
546         if (hp->masked_status || hp->host_status || hp->driver_status)
547                 hp->info |= SG_INFO_CHECK;

So even though DRIVER_SENSE is not an error, the SG_INFO_CHECK bit gets set.  (The info field is undoubtedly bitwise.)

How can I really test if an error occured?

A bit more here.

In scsi.h:
217 /*
218  *  SCSI Architecture Model (SAM) Status codes. Taken from SAM-3 draft
219  *  T10/1561-D Revision 4 Draft dated 7th November 2002.
220  */
221 #define SAM_STAT_GOOD            0x00
222 #define SAM_STAT_CHECK_CONDITION 0x02
223 #define SAM_STAT_CONDITION_MET   0x04
224 #define SAM_STAT_BUSY            0x08
225 #define SAM_STAT_INTERMEDIATE    0x10
226 #define SAM_STAT_INTERMEDIATE_CONDITION_MET 0x14
227 #define SAM_STAT_RESERVATION_CONFLICT 0x18
228 #define SAM_STAT_COMMAND_TERMINATED 0x22        /* obsolete in SAM-3 */
229 #define SAM_STAT_TASK_SET_FULL   0x28
230 #define SAM_STAT_ACA_ACTIVE      0x30
231 #define SAM_STAT_TASK_ABORTED    0x40

Is SAM_STAT_CHECK_CONDITION a bitwise value?  It looks like the answer is mostly no.  Some of them could be, but not consistently.  Did the T10 committee say if these are bitwise?

In scsi.h:
256 /*
257  *  Status codes. These are deprecated as they are shifted 1 bit right
258  *  from those found in the SCSI standards. This causes confusion for
259  *  applications that are ported to several OSes. Prefer SAM Status codes
260  *  above.
261  */
262 
263 #define GOOD                 0x00
264 #define CHECK_CONDITION      0x01

In sg.c:
533                 if ((CHECK_CONDITION & hp->masked_status) ||
534                     (DRIVER_SENSE & hp->driver_status)) {

Why doesn't sg use SAM Status codes?

Meanwhile, is CHECK_CONDITION a bitwise value?  It looks like the answer is mostly no, for the same reason as SAM_STAT_CHECK_CONDITION.  These bitwise tests look like bugs.

