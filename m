From: Jeff Garzik <jgarzik@pobox.com>
Subject: [Fwd: [patch libata-dev-2.6 5/5] libata: update ATA pass thru opcodes]
Date: Fri, 18 Feb 2005 15:21:50 -0500
Message-ID: <42164E5E.1020505@pobox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000501090906040804060108"
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:62344 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261486AbVBRUWO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Feb 2005 15:22:14 -0500
Received: from [69.134.152.124] (helo=[10.10.10.88])
	by parcelfarce.linux.theplanet.co.uk with asmtp (TLSv1:AES256-SHA:256)
	(Exim 4.33)
	id 1D2Edb-0006Kv-Nu
	for linux-scsi@vger.kernel.org; Fri, 18 Feb 2005 20:22:08 +0000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------000501090906040804060108
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

I thought the "Command sets are supposed to be qualified" paragraph was 
worth forwarding to linux-scsi.

	Jeff



--------------000501090906040804060108
Content-Type: message/rfc822;
 name="[patch libata-dev-2.6 5/5] libata: update ATA pass thru opcodes"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="[patch libata-dev-2.6 5/5] libata: update ATA pass thru opcodes"

Return-Path: <SRS0=zZFa=RA=bilbo.tuxdriver.com=linville@bounce2.pobox.com>
X-Original-To: garzik@gtf.org
Delivered-To: garzik@gtf.org
Received: from icicle.pobox.com (icicle.pobox.com [207.8.226.3])
	by havoc.gtf.org (Postfix) with ESMTP id DC5C81C0A82E
	for <garzik@gtf.org>; Fri, 18 Feb 2005 15:16:29 -0500 (EST)
Received: from icicle.pobox.com (localhost [127.0.0.1])
	by icicle.pobox.com (Postfix) with ESMTP id C94B71BFF0
	for <garzik@gtf.org>; Fri, 18 Feb 2005 15:16:30 -0500 (EST)
Delivered-To: jgarzik@pobox.com
Received: from ra.tuxdriver.com (ra.tuxdriver.com [24.172.12.4])
	by icicle.pobox.com (Postfix) with ESMTP id 934721C0AB
	for <jgarzik@pobox.com>; Fri, 18 Feb 2005 15:16:30 -0500 (EST)
Received: from bilbo.tuxdriver.com (bilbo.tuxdriver.com [24.172.12.5])
	by ra.tuxdriver.com (8.11.6/8.11.6) with ESMTP id j1IKEfc22007;
	Fri, 18 Feb 2005 15:14:41 -0500
Received: from bilbo.tuxdriver.com (localhost.localdomain [127.0.0.1])
	by bilbo.tuxdriver.com (8.13.1/8.13.1) with ESMTP id j1IKGNMe003784;
	Fri, 18 Feb 2005 15:16:23 -0500
Received: (from linville@localhost)
	by bilbo.tuxdriver.com (8.13.1/8.13.1/Submit) id j1IKGNMZ003783;
	Fri, 18 Feb 2005 15:16:23 -0500
Date: Fri, 18 Feb 2005 15:16:23 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
	jgarzik@pobox.com
Subject: [patch libata-dev-2.6 5/5] libata: update ATA pass thru opcodes
Message-ID: <20050218201623.GF3197@tuxdriver.com>
Mail-Followup-To: linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org, jgarzik@pobox.com
References: <20050218195027.GB3197@tuxdriver.com> <20050218195512.GC3197@tuxdriver.com> <20050218200337.GD3197@tuxdriver.com> <20050218200637.GE3197@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20050218200637.GE3197@tuxdriver.com>
User-Agent: Mutt/1.4.1i
X-Spam-Checker-Version: SpamAssassin 3.0.1 (2004-10-22) on havoc.gtf.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=7.0 tests=AWL,BAYES_00,SPF_HELO_PASS,
	SPF_PASS autolearn=ham version=3.0.1
X-UID: 4345
X-Keywords: 

Update ATA pass thru opcodes to match what is specified in the current
ATA pass thru spec (T10/04-262r7).

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
This part was controversial before, because these opcodes seemed to
overlap with some existing opcodes.  So I contacted the author of
the spec, Curtis Stevens: (quoted without permision)

"The command values in 04-262r7 are correct.  There was an erroneous value
published in the minutes that subsequently got published in SPC.  This has
been corrected.

Command sets are supposed to be qualified by the Inquiry Peripheral Device
Type.  I am a little concerned that some portions of linux depend on opcodes
being the same for all PDTs.  Using reusing opcodes will continue to happen
more frequently as new applications emerge and new devices are created.  The
SCSI opcoded are already overloaded to the point that Service Actions have
become necessary to extend the protocol."

Honestly, I don't know if that clears things up or not.  But, Curtis
seems pretty adamant that the values in the patch below (which match
rev 7 of the spec) are correct.  IMHO, at worst these values are no
more wrong than the ones already there.

So, apply this now, or apply it later... :-)

 include/scsi/scsi.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

--- sata-smart-2.6/include/scsi/scsi.h.orig	2005-02-01 16:22:12.390234346 -0500
+++ sata-smart-2.6/include/scsi/scsi.h	2005-02-01 16:23:02.828491161 -0500
@@ -113,9 +113,9 @@ extern const char *const scsi_device_typ
 /* values for service action in */
 #define	SAI_READ_CAPACITY_16  0x10
 
-/* Temporary values for T10/04-262 until official values are allocated */
-#define	ATA_16		      0x85	/* 16-byte pass-thru [0x85 == unused]*/
-#define	ATA_12		      0xb3	/* 12-byte pass-thru [0xb3 == obsolete set limits command] */
+/* Values for T10/04-262r7 */
+#define	ATA_16		      0x85	/* 16-byte pass-thru */
+#define	ATA_12		      0xa1	/* 12-byte pass-thru */
 
 /*
  *  SCSI Architecture Model (SAM) Status codes. Taken from SAM-3 draft
-- 
John W. Linville
linville@tuxdriver.com


--------------000501090906040804060108--
