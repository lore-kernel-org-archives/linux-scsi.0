From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: + aacraid-fix-unchecked-down_interruptible.patch added to -mm
 tree
Date: Thu, 10 Apr 2008 14:29:29 -0700
Message-ID: <20080410142929.3be73136.akpm@linux-foundation.org>
References: <200804102037.m3AKb2g4016314@imap1.linux-foundation.org>
	<1207860882.4915.35.camel@localhost.localdomain>
	<18656C81-9F7B-47D8-B02C-9E7667349500@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50986 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757283AbYDJV3s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Apr 2008 17:29:48 -0400
In-Reply-To: <18656C81-9F7B-47D8-B02C-9E7667349500@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
Cc: James.Bottomley@HansenPartnership.com, alan@lxorguk.ukuu.org.uk, linux-scsi@vger.kernel.org

On Thu, 10 Apr 2008 17:19:23 -0400
Mark Salyzyn <Mark_Salyzyn@adaptec.com> wrote:

> Until the epiphany that solves this problem or someone straightens me  
> out on the proper usage, I suggest a STRONG comment be added: /*  
> BADCODE DO NOT COPY */ :-)

There must be _some_ way of handling it which vaguely reflects what the
code is actually trying to do.

I assume that what you're saying is that *fibptr is about to be freed (or
reinitialised) whether or not the down_interruptible() succeeded.

If it gets freed with the lock held, CONFIG_DEBUG_LOCK_ALLOC could (should)
generate a runtime warning.

Even something like

	/*
	 * lavish comment goes here
	 */
	if (down_interruptible(&fibptr->event_wait) == 0)
		up(&fibptr->event_wait);

would fix the compile-time and runtime warnings.
