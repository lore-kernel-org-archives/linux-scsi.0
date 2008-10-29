From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 14/17] scsi: fix bad use of udelay in atp870u.c
Date: Wed, 29 Oct 2008 15:02:43 -0700
Message-ID: <20081029150243.27e9a4a2.akpm@linux-foundation.org>
References: <200810292124.m9TLOk2b021279@imap1.linux-foundation.org>
	<1225316535.3257.16.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46584 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753541AbYJ2WDR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2008 18:03:17 -0400
In-Reply-To: <1225316535.3257.16.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, tbm@cyrius.com

On Wed, 29 Oct 2008 16:42:15 -0500
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Wed, 2008-10-29 at 14:24 -0700, akpm@linux-foundation.org wrote:
> > -       udelay(0x800);
> > +       mdelay(2);
> > +       udelay(48);
> 
> OK, this fix is obviously wrong ... the code holds off interrupts for
> two ticks that's clearly completely bogus.  In this case silencing the
> warning is hiding the bogosity ... now if only someone could actually
> fix it ...
> 

That'll take some heavy lifting.  There's an mdelay(128) a few lines up!

I'd suggest that you merge this to fix the ARM build then hurriedly
find something else to look at :(

