From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/4] Add udelay to A100U2W SCSI driver
Date: Tue, 15 Jul 2008 10:12:13 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0807151011350.24544@devserv.devel.redhat.com>
References: <Pine.LNX.4.64.0807151008370.24544@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60692 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752981AbYGOOMQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jul 2008 10:12:16 -0400
In-Reply-To: <Pine.LNX.4.64.0807151008370.24544@devserv.devel.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

udelay is required on Sun Ultra 5.
I don't know any reason or explanation for this, it was found purely
experimentally.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
  drivers/scsi/a100u2w.c |    1 +
  1 file changed, 1 insertion(+)

Index: linux-2.6.26-rc8/drivers/scsi/a100u2w.c
===================================================================
--- linux-2.6.26-rc8.orig/drivers/scsi/a100u2w.c	2008-07-01 18:48:09.000000000 +0200
+++ linux-2.6.26-rc8/drivers/scsi/a100u2w.c	2008-07-01 18:48:11.000000000 +0200
@@ -401,6 +401,7 @@ static u8 orc_load_firmware(struct orc_h

  	/* Copy the code from the BIOS to the SRAM */

+	udelay(500);	/* Required on Sun Ultra 5 ... 350 -> failures */
  	bios_addr = (u16) le32_to_cpu(data32);	/* FW code locate at BIOS address + ? */
  	for (i = 0, data32_ptr = (u8 *) & data32;	/* Download the code    */
  	     i < 0x1000;	/* Firmware code size = 4K      */
