From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Fix race with shared tag queue maps
Date: Thu, 13 Sep 2007 08:42:29 -0700 (PDT)
Message-ID: <alpine.LFD.0.999.0709130840450.16478@woody.linux-foundation.org>
References: <20070913122652.GK25592@kernel.dk>
 <alpine.LFD.0.999.0709130813220.16478@woody.linux-foundation.org>
 <20070913152222.GS25592@kernel.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34860 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756751AbXIMPnY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Sep 2007 11:43:24 -0400
In-Reply-To: <20070913152222.GS25592@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, orgis@agnld.uni-potsdam.de, arekm@maven.pl, ed.lin@promise.com, Andrew Morton <akpm@linux-foundation.org>, James.Bottomley@SteelEye.com



On Thu, 13 Sep 2007, Jens Axboe wrote:
> 
> My bad, I think I added the smp_mb__before_clear_bit() when it was
> __test_and_set_bit() like in the first hunk.

Ahh, that wouldn't work at all. The "__test_and_set_bit()" thing isn't 
atomic at all, and no amount of memory barriers around it would help 
(you'd need to use real locking, but at that point the memory barriers are 
pointless anyway).

> +	/*
> +	 * Ensure ordering between ->tag_index[tag] clear and tag clear
> +	 */
> +	smp_mb__after_clear_bit();

You still left this one. But never mind - I already edited your original 
patch and it's in my tree with both of those things removed.

		Linus
