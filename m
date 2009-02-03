From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: slab error in verify_redzone_free() badness...
Date: Mon, 2 Feb 2009 20:05:16 -0800
Message-ID: <20090203040516.GA11835@plap4-2.local>
References: <20090129225532.GA37589@plap4-2.local> <20090202151852.de39952b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:45835 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbZBCEFS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Feb 2009 23:05:18 -0500
Content-Disposition: inline
In-Reply-To: <20090202151852.de39952b.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "matthew@wil.cx" <matthew@wil.cx>, "gregkh@suse.de" <gregkh@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Seokmann Ju <seokmann.ju@qlogic.com>

On Mon, 02 Feb 2009, Andrew Morton wrote:

> I'd be suspecting a bug in the caller.
> 
> Try setting CONFIG_DEBUG_PAGEALLOC, and use slab.c (not slub).  slab
> will perform page unmapping for those 2k-sized slabs.  I don't know
> whether slub does that.
> 
> All being well, you'll get a nice oops at the site of the improper
> reference.

Thanks for the tip...  Yeah, we're triaging this further, as it seems
to be pointing to something in the recent 'refactoring/multi-q' code
in qla2xxx...

--
av
