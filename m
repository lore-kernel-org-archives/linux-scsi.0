From: Krzysztof Helt <krzysztof.h1@poczta.fm>
Subject: Re: [PATCH] sym8xx_2: kill compilation warning
Date: Tue, 8 Jan 2008 07:40:34 +0100
Message-ID: <20080108074034.604f84ee.krzysztof.h1@poczta.fm>
References: <20080107225619.59621db7.krzysztof.h1@poczta.fm>
	<1199745575.3126.50.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:22094 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755907AbYAHGhY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jan 2008 01:37:24 -0500
In-Reply-To: <1199745575.3126.50.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, matthew@wil.cx

On Mon, 07 Jan 2008 16:39:35 -0600
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> 
> On Mon, 2008-01-07 at 22:56 +0100, Krzysztof Helt wrote:
> > From: Krzysztof Helt <krzysztof.h1@wp.pl>
> > 
> > This patch fixes call to wait_for_completion_timeout()
> > with NULL argument.
> 
> That doesn't seem to be at all what your patch is doing.  I can't see
> any case in the old code where wait_for_completion_timeout() could be
> called with a NULL that you fix.  What it seems you are doing is
> altering the code to eliminate the finished_reset variable.
> 

I am sorry for the mess. I put the wrong description of the patch.
Here is the correct one:
---

The purpose of the patch is to kill the compilation warning with gcc-4.1.1 on sparc64:

sym_glue.c: In function sym_eh_handler:
sym_glue.c:612: warning: io_reset may be used uninitialized in this function

This patch also eliminates the finished_reset variable.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>

---

diff -urp linux-ref/drivers/scsi/sym53c8xx_2/sym_glue.c linux-new/drivers/scsi/sym53c8xx_2/sym_glue.c
--- linux-ref/drivers/scsi/sym53c8xx_2/sym_glue.c	2007-10-28 11:11:02.000000000 +0100
+++ linux-new/drivers/scsi/sym53c8xx_2/sym_glue.c	2007-10-28 14:25:08.000000000 +0100
@@ -609,8 +609,7 @@ static int sym_eh_handler(int op, char *
 	 */
 #define WAIT_FOR_PCI_RECOVERY	35
 	if (pci_channel_offline(pdev)) {
-		struct completion *io_reset;
-		int finished_reset = 0;
+		struct completion *io_reset = NULL;
 		init_completion(&eh_done);
 		spin_lock_irq(shost->host_lock);
 		/* Make sure we didn't race */
@@ -618,15 +617,12 @@ static int sym_eh_handler(int op, char *
 			if (!sym_data->io_reset)
 				sym_data->io_reset = &eh_done;
 			io_reset = sym_data->io_reset;
-		} else {
-			finished_reset = 1;
 		}
 		spin_unlock_irq(shost->host_lock);
-		if (!finished_reset)
-			finished_reset = wait_for_completion_timeout(io_reset,
-						WAIT_FOR_PCI_RECOVERY*HZ);
-		if (!finished_reset)
-			return SCSI_FAILED;
+		if (io_reset &&
+		    !wait_for_completion_timeout(io_reset,
+						 WAIT_FOR_PCI_RECOVERY * HZ))
+				return SCSI_FAILED;
 	}
 
 	spin_lock_irq(shost->host_lock);




----------------------------------------------------------------------
Nadchodzi wojna miedzygalaktyczna! 
Sprawdz! >>> http://link.interia.pl/f1cc2

