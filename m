From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: sd: Refactor sd_read_capacity()
Date: Tue, 23 Dec 2008 09:59:00 -0700
Message-ID: <20081223165900.GC19967@parisc-linux.org>
References: <20081223164509.GA19967@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:35771 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbYLWQ7Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Dec 2008 11:59:16 -0500
Content-Disposition: inline
In-Reply-To: <20081223164509.GA19967@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Tue, Dec 23, 2008 at 09:45:10AM -0700, Matthew Wilcox wrote:
> The sd_read_capacity() function was about 180 lines long and
> included a backwards goto and a tricky state variable.  Splitting out
> read_capacity_10() and read_capacity_16() (about 50 lines each) reduces
> sd_read_capacity to about 100 lines and gets rid of the backwards goto
> and the state variable.  I've tried to avoid any behaviour change with
> this patch.

I should have probably said what testing I've done (with both patches
applied, not just this one).

I've tried numerous <= SCSI-2 devices -- USB keys, older SCSI drives ...
even newer SCSI drives still seem to claim SCSI-2 compliance.  Almost
all my equipment claims ANSI rev 2.

I've tried a few libata devices (which claim ANSI rev 5).  I've tried a
WD My Book (attached via firewire) which claims ANSI rev 4.  I've also
tried an HP fibre channel array which claims ANSI rev 3.

I can't claim to have exercised all the error paths here.  

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
