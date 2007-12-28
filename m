From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: SCSI errors on powerpc with 2.6.24-rc6-mm1
Date: Fri, 28 Dec 2007 14:30:43 +0900
Message-ID: <20071228143043U.fujita.tomonori@lab.ntt.co.jp>
References: <47732C41.7000003@linux.vnet.ibm.com>
	<20071227134335O.fujita.tomonori@lab.ntt.co.jp>
	<47733C01.1080002@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama555.ecl.ntt.co.jp ([129.60.39.106]:41322 "EHLO
	tama555.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbXL1Fbb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Dec 2007 00:31:31 -0500
In-Reply-To: <47733C01.1080002@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: balbir@linux.vnet.ibm.com
Cc: fujita.tomonori@lab.ntt.co.jp, linuxppc-dev@ozlabs.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, 27 Dec 2007 11:15:37 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> FUJITA Tomonori wrote:
> > On Thu, 27 Dec 2007 10:08:25 +0530
> > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > 
> >> FUJITA Tomonori wrote:
> >>> On Mon, 24 Dec 2007 10:18:50 +0530
> >>> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> >>>
> >> [snip]
> >>
> >>> I might break the IOMMU code. Can you reproduce it easily? If so,
> >>> reverting my IOMMU patches (I've attached a patch to revert them) fix
> >>> the problem?
> >> [snip]
> >>
> >>
> >> Yes, this patch fixes the problem for me.
> > 
> > Thanks, so you can reproduce it easily, right?
> > 
> 
> Yes, quite easily
> 
> > The problem is that I don't want to revert these changes. I'll see
> > how these changes cause the problem shortly.
> 
> I'll try and find some bandwidth to review/test the patches and help you
> figure out the right solution.

Thanks,

Can you try this?


diff --git a/lib/iommu-helper.c b/lib/iommu-helper.c
index e7d8544..495575a 100644
--- a/lib/iommu-helper.c
+++ b/lib/iommu-helper.c
@@ -8,15 +8,20 @@
 static unsigned long find_next_zero_area(unsigned long *map,
 					 unsigned long size,
 					 unsigned long start,
-					 unsigned int nr)
+					 unsigned int nr,
+					 unsigned long align_mask)
 {
 	unsigned long index, end, i;
 again:
 	index = find_next_zero_bit(map, size, start);
+
+	/* Align allocation */
+	index = (index + align_mask) & ~align_mask;
+
 	end = index + nr;
-	if (end > size)
+	if (end >= size)
 		return -1;
-	for (i = index + 1; i < end; i++) {
+	for (i = index; i < end; i++) {
 		if (test_bit(i, map)) {
 			start = i+1;
 			goto again;
@@ -50,9 +55,8 @@ unsigned long iommu_area_alloc(unsigned long *map, unsigned long size,
 {
 	unsigned long index;
 again:
-	index = find_next_zero_area(map, size, start, nr);
+	index = find_next_zero_area(map, size, start, nr, align_mask);
 	if (index != -1) {
-		index = (index + align_mask) & ~align_mask;
 		if (is_span_boundary(index, nr, shift, boundary_size)) {
 			/* we could do more effectively */
 			start = index + 1;
