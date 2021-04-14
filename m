Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BE1CC433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Apr 2021 22:39:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5756B611CC
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Apr 2021 22:39:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236520AbhDNWkA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Apr 2021 18:40:00 -0400
Received: from angie.orcam.me.uk ([157.25.102.26]:38968 "EHLO
        angie.orcam.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234976AbhDNWjw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Apr 2021 18:39:52 -0400
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 059899200B3; Thu, 15 Apr 2021 00:39:29 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 01F2A92009D;
        Thu, 15 Apr 2021 00:39:28 +0200 (CEST)
Date:   Thu, 15 Apr 2021 00:39:28 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Nix <nix@esperi.org.uk>, Khalid Aziz <khalid@gonehiking.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
cc:     Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] scsi: Set allocation length to 255 for ATA Information
 VPD page
In-Reply-To: <alpine.DEB.2.21.2104141244520.44318@angie.orcam.me.uk>
Message-ID: <alpine.DEB.2.21.2104141306130.44318@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2104141244520.44318@angie.orcam.me.uk>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Set the allocation length to 255 for the ATA Information VPD page 
requested in the WRITE SAME handler, so as not to limit information 
examined by `scsi_get_vpd_page' in the supported vital product data 
pages unnecessarily.

Originally it was thought that Areca hardware may have issues with a 
valid allocation length supplied for a VPD inquiry, however older SCSI 
standard revisions[1] consider 255 the maximum length allowed and what 
has later become the high order byte is considered reserved and must be 
zero with the INQUIRY command.  Therefore it was unnecessary to reduce 
the amount of data requested from 512 as far down as to 64, arbitrarily 
chosen, and 255 would as well do.

With commit b3ae8780b429 ("[SCSI] Add EVPD page 0x83 and 0x80 to sysfs") 
we have since got the SCSI_VPD_PG_LEN macro, so use that instead.

References:

[1] "Information technology - Small Computer System Interface - 2",
    WORKING DRAFT, X3T9.2, Project 375D, Revision 10L, 7-SEP-93, Section
    8.2.5 "INQUIRY command", pp.104-108

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Fixes: af73623f5f10 ("[SCSI] sd: Reduce buffer size for vpd request")
---
Nix,

 I can see you're still around.  Would you therefore please be so kind 
as to verify this change with your Areca hardware if you still have it?

 It looks to me like you were thinking in the right direction with: 
<https://lore.kernel.org/linux-scsi/87vc3nuipg.fsf@spindle.srvr.nix/>. 
Sadly nobody seemed to have paid attention to your observation and neither 
were different buffer sizes considered (or at least it wasn't mentioned in 
the discussion).

  Maciej
---
 drivers/scsi/sd.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

linux-scsi-write-same-vpd-buffer.diff
Index: linux-macro-ide/drivers/scsi/sd.c
===================================================================
--- linux-macro-ide.orig/drivers/scsi/sd.c
+++ linux-macro-ide/drivers/scsi/sd.c
@@ -3076,16 +3076,13 @@ static void sd_read_write_same(struct sc
 	}
 
 	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, INQUIRY) < 0) {
-		/* too large values might cause issues with arcmsr */
-		int vpd_buf_len = 64;
-
 		sdev->no_report_opcodes = 1;
 
 		/* Disable WRITE SAME if REPORT SUPPORTED OPERATION
 		 * CODES is unsupported and the device has an ATA
 		 * Information VPD page (SAT).
 		 */
-		if (!scsi_get_vpd_page(sdev, 0x89, buffer, vpd_buf_len))
+		if (!scsi_get_vpd_page(sdev, 0x89, buffer, SCSI_VPD_PG_LEN))
 			sdev->no_write_same = 1;
 	}
 
