From: Anton Blanchard <anton@samba.org>
Subject: Re: [PATCH] Convert sym2 to be hotplug-capable
Date: Sun, 20 Jul 2003 04:28:30 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030719182830.GD25703@krispykreme>
References: <20030716210059.GR23808@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dp.samba.org ([66.70.73.150]:48331 "EHLO lists.samba.org")
	by vger.kernel.org with ESMTP id S268256AbTGTU3P (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Jul 2003 16:29:15 -0400
Content-Disposition: inline
In-Reply-To: <20030716210059.GR23808@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: linux-scsi@vger.kernel.org

 
Hi,

> This patch is on top of the patch I posted yesterday.  It..
>  - Stops using Scsi_Cmnd etc typedefs
>  - Removes the unused Scsi_Host_Template argument from sym53c8xx_pci_init
>  - Converts sym53c8xx_2 to be a hotplug-capable driver

Nice work. 

> NOTE: This does not even attempt to preserve existing controller ordering.
> But given how much I've seen symbios controllers move around under
> the current setup (what?  you plugged in an 875 that happens to have
> NVRAM on it?  Oh well then, let's just renumber all your other cards!),
> I really don't care.

Its worse than that, the driver probes each sym2 type one at a time. Even
if the 875 has no NVRAM it will be probed before all 1010 devices for
example. Confused the hell out of me for a while.

I agree we should just move to hotplug ordering, that at least makes
sense.

The last things on my sym2 hitlist are using pci_name() everywhere and
removing the redundant memory allocator. (Actually you fixed the main
reason I wanted to kill sym_calloc etc, the driver had a 32 controller
limit on ppc64 due to a fixed sized array.)

Anton
