From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [Lsf10-pc] Current MM topics for LSF10/MM Summit 8-9 August in Boston
Date: Tue, 22 Jun 2010 12:30:27 +0900 (JST)
Message-ID: <20100622122813.B566.A69D9226@jp.fujitsu.com>
References: <20100621120526.GA31679@laptop> <20100621131608.GW5787@random.random>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50220 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758690Ab0FVDab (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Jun 2010 23:30:31 -0400
In-Reply-To: <20100621131608.GW5787@random.random>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: kosaki.motohiro@jp.fujitsu.com, Nick Piggin <npiggin@suse.de>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, lsf10-pc@lists.linuxfoundation.org, linux-scsi@vger.kernel.org

> On Mon, Jun 21, 2010 at 10:05:26PM +1000, Nick Piggin wrote:
> > Andrea Arcangeli	Transparent hugepages
> 
> Sure fine on my side. I got a proposal accepted for presentation at
> KVM Forum 2010 about it too the days after the VM summit too.
> 
> > KOSAKI Motohiro		get_user_pages vs COW problem
> 
> Just a side note, not sure exactly what is meant to be discussed about
> this bug, considering the fact this is still unsolved isn't technical
> problem as there were plenty of fixes available, and the one that seem
> to had better chance to get included was the worst one in my view, as
> it tried to fix it in a couple of gup caller (but failed, also because
> finding all put_page pin release is kind of a pain as they're spread
> all over the place and not identified as gup_put_page, and in addition
> to the instability and lack of completeness of the fix, it was also
> the most inefficient as it added unnecessary and coarse locking) plus
> all gup callers are affected, not just a few. I normally call it gup
> vs fork race. Luckily not all threaded apps uses O_DIRECT and fork and
> pretend to do the direct-io in different sub-page chunks of the same
> page from different threads (KVM would probably be affected if it
> didn't use MADV_DONTFORK on the O_DIRECT memory, as it might run fork
> to execute some network script when adding an hotplug pci net device
> for example). But surely we can discuss the fix we prefer for this
> bug, or at least we can agree it needs fixing.

If people don't want this. I'm ok to drop this. In my personal concern
most important topics are following four topics. (again it's only _my_
concern)


Rik van Riel		Memory management under virtualization (with KVM)
Andrea Arcangeli	Transparent hugepages
- mmap_sem scalability, again
- Direct reclaim, direct writeback problems



