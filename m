From: Matthew Wilcox <willy@debian.org>
Subject: Re: Building sym 2.1.18f on linux/alpha
Date: Wed, 14 Jan 2004 05:44:49 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040114054449.GD10711@parcelfarce.linux.theplanet.co.uk>
References: <40040870.9000306@solvo.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:31687 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S266316AbUANFoy
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jan 2004 00:44:54 -0500
Content-Disposition: inline
In-Reply-To: <40040870.9000306@solvo.ru>
List-Id: linux-scsi@vger.kernel.org
To: Sergey Tikhonov <tsv@solvo.ru>
Cc: willy@debian.org, "J.E.J. Bottomley" <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@zip.com.au>

On Tue, Jan 13, 2004 at 06:02:08PM +0300, Sergey Tikhonov wrote:
> The final kernel could not pass linking stage with 2.1.18f version 
> (included into 2.6.1 kernel patch).
> The linker complains that :
> drivers/built-in.o(.init.text+0x8cec): In function 'sym2_probe':
> : undfined reference to 'local symbols in discarded section .exit.text'
> 
> I compared arch/alpha/kernel/vmlinux.lds.S with one from the i386 tree. 
> The '.exit.text' and '.exit.data'
> sections were moved out of DISCARD attributes in the i386 version. I did 
> the same with alpha version
> and it helped.

Thanks for this report; you uncovered a real bug.  Actually two real
bugs; one is that parisc is not discarding the .init.text and .exit.text
sections (so I didn't notice this bug) and the other is that sym_detach
is marked __devexit, yet called from a __devinit function.

Patch follows:

Index: drivers/scsi/sym53c8xx_2/sym_glue.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/sym53c8xx_2/sym_glue.c,v
retrieving revision 1.38
diff -u -p -r1.38 sym_glue.c
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c	17 Oct 2003 13:32:00 -0000	1.38
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c	14 Jan 2004 05:43:33 -0000
@@ -2228,7 +2228,7 @@ void sym_config_pqs(struct pci_dev *pdev
  *  Detach the host.
  *  We have to free resources and halt the NCR chip.
  */
-static int __devexit sym_detach(struct sym_hcb *np)
+static int sym_detach(struct sym_hcb *np)
 {
 	printk("%s: detaching ...\n", sym_name(np));
 

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
