From: Matthew Wilcox <willy@debian.org>
Subject: Re: [PATCH] Convert sym2 to be hotplug-capable
Date: Sun, 20 Jul 2003 22:55:22 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030720215522.GH1485@parcelfarce.linux.theplanet.co.uk>
References: <20030716210059.GR23808@parcelfarce.linux.theplanet.co.uk> <20030719182830.GD25703@krispykreme>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:5774 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S268577AbTGTVkV
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Jul 2003 17:40:21 -0400
Content-Disposition: inline
In-Reply-To: <20030719182830.GD25703@krispykreme>
List-Id: linux-scsi@vger.kernel.org
To: Anton Blanchard <anton@samba.org>
Cc: Matthew Wilcox <willy@debian.org>, linux-scsi@vger.kernel.org

On Sun, Jul 20, 2003 at 04:28:30AM +1000, Anton Blanchard wrote:
> > NOTE: This does not even attempt to preserve existing controller ordering.
> > But given how much I've seen symbios controllers move around under
> > the current setup (what?  you plugged in an 875 that happens to have
> > NVRAM on it?  Oh well then, let's just renumber all your other cards!),
> > I really don't care.
> 
> Its worse than that, the driver probes each sym2 type one at a time. Even
> if the 875 has no NVRAM it will be probed before all 1010 devices for
> example. Confused the hell out of me for a while.

That's right, but we have the following even more confusing situation on
at least one of our boxes:

1010 with NVRAM indicating it should go first
2 halves of 896 which come second & third
other half of 1010 which comes fourth.
(these cards are both built-in to the box)

Then you add an 875 with NVRAM and you get

875
896
896
1010
1010

So all your discs get renumbered because you have some discs on the 896.
Even though there's no discs plugged into the 875.  Gaagh.

> I agree we should just move to hotplug ordering, that at least makes
> sense.

Yay.

> The last things on my sym2 hitlist are using pci_name() everywhere and
> removing the redundant memory allocator. (Actually you fixed the main
> reason I wanted to kill sym_calloc etc, the driver had a 32 controller
> limit on ppc64 due to a fixed sized array.)

I wasn't sure how redundant the sym_calloc was ... apparently power-of-2
allocations improve perf on these cards (according to the comments),
whereas kmalloc deliberately doesn't align stuff on power-of-2 to get
better cache line usage.

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
