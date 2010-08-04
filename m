From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: 2.6.35 Regression: Ages spent discarding blocks that weren't
 used!
Date: Wed, 04 Aug 2010 10:59:42 +0200
Message-ID: <4C592BFE.7070701@s5r6.in-berlin.de>
References: <4C58C528.4000606@tuxonice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C58C528.4000606@tuxonice.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Nigel Cunningham <nigel@tuxonice.net>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

(adding Cc: linux-scsi)

Nigel Cunningham wrote:
> I've just given hibernation a go under 2.6.35, and at first I thought
> there was some sort of hang in freezing processes. The computer sat
> there for aaaaaages, apparently doing nothing. Switched from TuxOnIce to
> swsusp to see if it was specific to my code but no - the problem was
> there too. I used the nifty new kdb support to get a backtrace, which was:
> 
> get_swap_page_of_type
> discard_swap_cluster
> blk_dev_issue_discard
> wait_for_completion
> 
> Adding a printk in discard swap cluster gives the following:
> 
> [   46.758330] Discarding 256 pages from bdev 800003 beginning at page 640377.
> [   47.003363] Discarding 256 pages from bdev 800003 beginning at page 640633.
> [   47.246514] Discarding 256 pages from bdev 800003 beginning at page 640889.
> 
> ...
> 
> [  221.877465] Discarding 256 pages from bdev 800003 beginning at page 826745.
> [  222.121284] Discarding 256 pages from bdev 800003 beginning at page 827001.
> [  222.365908] Discarding 256 pages from bdev 800003 beginning at page 827257.
> [  222.610311] Discarding 256 pages from bdev 800003 beginning at page 827513.
> 
> So allocating 4GB of swap on my SSD now takes 176 seconds instead of
> virtually no time at all. (This code is completely unchanged from 2.6.34).
> 
> I have a couple of questions:
> 
> 1) As far as I can see, there haven't been any changes in mm/swapfile.c
> that would cause this slowdown, so something in the block layer has
> (from my point of view) regressed. Is this a known issue?

Perhaps ATA TRIM is enabled for this SSD in 2.6.35 but not in 2.6.34?
Or the discard code has been changed to issue many moderately sized ATA
TRIMs instead of a single huge one, and the former was much more optimal
for your particular SSD?

> 2) Why are we calling discard_swap_cluster anyway? The swap was unused
> and we're allocating it. I could understand calling it when freeing
> swap, but when allocating?

At the moment when the administrator creates swap space, the kernel can
assume that he has no use anymore for the data that may have existed
previously at this space.  Hence instruct the SSD's flash translation
layer to return all these blocks to the list of unused logical blocks
which do not have to be read and backed up whenever another logical
block within the same erase block is written to.

However, I am surprised that this is done every time (?) when preparing
for hibernation.
-- 
Stefan Richter
-=====-==-=- =--- --=--
http://arcgraph.de/sr/
