From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] IBM Power RAID driver (ipr) 2.0.6
Date: 10 May 2004 15:38:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1084221540.2659.353.camel@mulgrave>
References: <4097D863.8040505@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:11439 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261580AbUEJUjF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 May 2004 16:39:05 -0400
In-Reply-To: <4097D863.8040505@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-05-04 at 12:52, Brian King wrote:
> Here is the latest version of the LLD for the IBM Power RAID family of
> adapters. This includes several IBM iSeries and pSeries SCSI adapters.
> Please apply.

OK, I put this in the tree.  However, it fails to compile on parisc:

 CC [M]  drivers/scsi/ipr.o
{standard input}: Assembler messages:
{standard input}:1788: Error: Field not properly aligned [8] (1028).
{standard input}:1788: Error: Invalid operands 
[...]

The problem is your use of list_head pointers in packed structures.  You
can't simply pass a pointer to a misaligned structure to a common kernel
function and expect it to work: the packed attribute is lost doing this
and what you end up with is a misaligned pointer reference.

The attached actually allows me to compile, but all it's doing is hiding
the problem.

James

===== drivers/scsi/ipr.h 1.1 vs edited =====
--- 1.1/drivers/scsi/ipr.h	Mon May 10 11:26:37 2004
+++ edited/drivers/scsi/ipr.h	Mon May 10 14:53:55 2004
@@ -666,7 +666,7 @@
 
 	/* Driver added data */
 	u32 hostrcb_dma;
-	struct list_head queue;
+	struct list_head queue __attribute__((aligned(sizeof(unsigned long))));
 }__attribute__((packed, aligned (4)));
 
 #define IPR_HOSTRCB_SZ offsetof(struct ipr_hostrcb, hostrcb_dma)

