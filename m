From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Fix two potential mem leaks in MPT Fusion (mpt_attach())
Date: Wed, 1 Aug 2007 21:03:50 -0600
Message-ID: <20070802030350.GF21219@parisc-linux.org>
References: <200708020155.33690.jesper.juhl@gmail.com> <20070801172653.1fd44e99.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:56424 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783AbXHBDDw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Aug 2007 23:03:52 -0400
Content-Disposition: inline
In-Reply-To: <20070801172653.1fd44e99.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jesper Juhl <jesper.juhl@gmail.com>, Eric Moore <Eric.Moore@lsi.com>, DL-MPTFusionLinux@lsi.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, support@lsi.com, mpt_linux_developer@lsi.com, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

On Wed, Aug 01, 2007 at 05:26:53PM -0700, Andrew Morton wrote:
> Why on earth is that using GFP_ATOMIC?  This function later goes on to
> create procfs files and such things.

Seems fairly common in driver initialisation code.  I removed three
instances of this in the advansys driver.

> y'know, we could have a debug option which will spit warnings if someone
> does a !__GFP_WAIT allocation while !in_atomic() (only works if
> CONFIG_PREEMPT).  
> 
> But please, make it depend on !CONFIG_AKPM.  I shudder to think about all
> the stuff it would pick up.

Seems like you'd get a lot of false positives.  How about a call:

slab_warn_about_atomic_allocs();

right before calling the initcalls, and then

slab_stop_warning_about_atomic_allocs();

after calling them?  That should give people a lot to chew on for a few
months.  Obviously, you would need to not warn about allocations from
interrupt context, as you say above.

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
