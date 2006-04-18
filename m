From: Konstantin Khorenko <khorenko@sw.ru>
Subject: Re: Compaq Fiber Channel Array RM4000 / 2.6.16 kernel patch VER6
Date: Tue, 18 Apr 2006 15:10:06 +0400
Message-ID: <4444C90E.6020804@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.233.200]:50180 "EHLO relay.sw.ru")
	by vger.kernel.org with ESMTP id S932146AbWDRLKQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Apr 2006 07:10:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, Ingo Flaschberger <if@xip.at>, Vasily Averin <vvs@sw.ru>

Hello James,

excuse me, but i have a question concerning following changes, made for support 
of Compaq Fiber Channel Array RM4000.

This patch changes logic for ALL devices which have scsi_level detected as 
SCSI_UNKNOWN,
all such devices now won't store LUN values in scsi commands and ALL of them 
would report their luns.
Do you know if there are such devices (with scsi_level detected as 
SCSI_UNKNOWN) other then Compaq Fiber Channel Array RM4000?
Wouldn't these changes brake their support?

http://www.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=4d7db04a7a69099accd84984a78c64d2178252f1
http://marc.theaimsgroup.com/?l=linux-scsi&m=114391012120176&w=2

Hunks from the patch i'm talking about:

linux-2.6.16/drivers/scsi/scsi.c:
  	 * If SCSI-2 or lower, store the LUN value in cmnd.
  	 */
-	if (cmd->device->scsi_level <= SCSI_2) {
+	if (cmd->device->scsi_level <= SCSI_2 &&
+			cmd->device->scsi_level != SCSI_UNKNOWN) {
  		cmd->cmnd[1] = (cmd->cmnd[1] & 0x1f) |
  			       (cmd->device->lun << 5 & 0xe0);
  	}

linux-2.6.16/drivers/scsi/scsi_scan.c:
  	 * Also allow SCSI-2 and SCSI-UNKNOWN if BLIST_REPORTLUN is set and host
  	 * adapter does support more than 8 LUNs.
  	 */
-	if ((bflags & BLIST_NOREPORTLUN) ||
-	     starget->scsi_level < SCSI_2 ||
-	    (starget->scsi_level < SCSI_3 &&
-	     (!(bflags & BLIST_REPORTLUN) || shost->max_lun <= 8)) )
+	if (bflags & BLIST_NOREPORTLUN)
+		return 1;
+	if (starget->scsi_level < SCSI_2 &&
+			starget->scsi_level != SCSI_UNKNOWN)
+		return 1;
+	if (starget->scsi_level < SCSI_3 &&
+			(!(bflags & BLIST_REPORTLUN) || shost->max_lun <= 8))
  		return 1;

Thank you.
-- 
Konstantin Khorenko,
SWsoft, Inc.

