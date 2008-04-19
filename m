From: Matthew Wilcox <matthew@wil.cx>
Subject: esp_scsi incorrect unsigned test
Date: Sat, 19 Apr 2008 08:05:56 -0600
Message-ID: <20080419140555.GJ20637@parisc-linux.org>
References: <4808C90A.5040600@tiscali.nl> <Pine.LNX.4.64.0804182101200.14832@ask.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:51970 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600AbYDSOGM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Apr 2008 10:06:12 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804182101200.14832@ask.diku.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Julia Lawall <julia@diku.dk>, David Miller <davem@davemloft.net>, linux-scsi@vger.kernel.org
Cc: Roel Kluin <12o3l@tiscali.nl>, kernel-janitors@vger.kernel.org, kernelnewbies-bounce@nl.linux.org

On Fri, Apr 18, 2008 at 09:08:55PM +0200, Julia Lawall wrote:
> I found 63 occurrences of this problem with the following semantic match
> (http://www.emn.fr/x-info/coccinelle/):
> 
> @@ unsigned int i; @@
> 
> * i < 0
> 
> I looked through all of the results by hand, and they all seem to be 
> problems.  In many cases, it seems like the variable should not be 
> unsigned as it is used to hold the return value of a function that might 
> return a negative error code, but I haven't looked into this in detail.
> 
> In the output below, the lines that begin with a single start contain a 
> test of whether an unsigned variable or structure field is less than 0.
> The output is actually generated with diff, but I converted the -s to *s 
> to avoid confusion.

> diff -u -p a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
> *** a/drivers/scsi/esp_scsi.c 2008-03-12 14:13:14.000000000 +0100
> @@ -380,7 +380,7 @@ static void esp_advance_dma(struct esp *
>  
>  	p->cur_residue -= len;
>  	p->tot_residue -= len;
> *	if (p->cur_residue < 0 || p->tot_residue < 0) {
>  		printk(KERN_ERR PFX "esp%d: Data transfer overflow.\n",
>  		       esp->host->unique_id);
>  		printk(KERN_ERR PFX "esp%d: cur_residue[%d] tot_residue[%d] "

This is clearly buggy.  A residue is, though, inherently unsigned, so I
don't think we should change the type of the variable.  Rather, we
should test it before subtraction.  Dave, what do you think?

----

Fix ESP data transfer overflow checks

The current code attempts to detect data transfer overflow by checking
whether an unsigned variable is negative.  Instead, we should
compare the two variables before subtracting them.

Reported-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index bfdee59..b5e8a94 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -378,9 +378,7 @@ static void esp_advance_dma(struct esp *esp, struct esp_cmd_entry *ent,
 		return;
 	}
 
-	p->cur_residue -= len;
-	p->tot_residue -= len;
-	if (p->cur_residue < 0 || p->tot_residue < 0) {
+	if (unlikely(p->cur_residue < len || p->tot_residue < len)) {
 		printk(KERN_ERR PFX "esp%d: Data transfer overflow.\n",
 		       esp->host->unique_id);
 		printk(KERN_ERR PFX "esp%d: cur_residue[%d] tot_residue[%d] "
@@ -389,7 +387,11 @@ static void esp_advance_dma(struct esp *esp, struct esp_cmd_entry *ent,
 		       p->cur_residue, p->tot_residue, len);
 		p->cur_residue = 0;
 		p->tot_residue = 0;
+	} else {
+		p->cur_residue -= len;
+		p->tot_residue -= len;
 	}
+
 	if (!p->cur_residue && p->tot_residue) {
 		p->cur_sg++;
 		p->cur_residue = sg_dma_len(p->cur_sg);

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
