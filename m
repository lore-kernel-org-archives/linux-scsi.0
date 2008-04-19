From: Matthew Wilcox <matthew@wil.cx>
Subject: u14-3f incorrect unsigned test
Date: Sat, 19 Apr 2008 08:17:52 -0600
Message-ID: <20080419141752.GK20637@parisc-linux.org>
References: <4808C90A.5040600@tiscali.nl> <Pine.LNX.4.64.0804182101200.14832@ask.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:39965 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755417AbYDSORx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Apr 2008 10:17:53 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804182101200.14832@ask.diku.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Julia Lawall <julia@diku.dk>, linux-scsi@vger.kernel.org
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

> diff -u -p a/drivers/scsi/u14-34f.c b/drivers/scsi/u14-34f.c
> *** a/drivers/scsi/u14-34f.c 2008-03-12 14:13:14.000000000 +0100
> @@ -1126,7 +1126,7 @@ static void map_dma(unsigned int i, unsi
>  
>     if (scsi_bufflen(SCpnt)) {
>  	   count = scsi_dma_map(SCpnt);
> *	   BUG_ON(count < 0);
>  
>  	   scsi_for_each_sg(SCpnt, sg, count, k) {
>  		   cpp->sglist[k].address = H2DEV(sg_dma_address(sg));

----

u14-34f: Correct unsigned comparison against 0

scsi_dma_map() can return an error.  The current situation of BUG_ON for
an out of memory condition is far from ideal, but it's better than the
current situation where running out of memory will lead to the driver
trying to walk through 4 billion sg entries.

Discovered-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

diff --git a/drivers/scsi/u14-34f.c b/drivers/scsi/u14-34f.c
index 58d7eee..11df071 100644
--- a/drivers/scsi/u14-34f.c
+++ b/drivers/scsi/u14-34f.c
@@ -1110,7 +1110,7 @@ static int u14_34f_detect(struct scsi_host_template *tpnt) {
 
 static void map_dma(unsigned int i, unsigned int j) {
    unsigned int data_len = 0;
-   unsigned int k, count, pci_dir;
+   unsigned int k, pci_dir;
    struct scatterlist *sg;
    struct mscp *cpp;
    struct scsi_cmnd *SCpnt;
@@ -1125,7 +1125,7 @@ static void map_dma(unsigned int i, unsigned int j) {
    cpp->sense_len = SCSI_SENSE_BUFFERSIZE;
 
    if (scsi_bufflen(SCpnt)) {
-	   count = scsi_dma_map(SCpnt);
+	   int count = scsi_dma_map(SCpnt);
 	   BUG_ON(count < 0);
 
 	   scsi_for_each_sg(SCpnt, sg, count, k) {

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
