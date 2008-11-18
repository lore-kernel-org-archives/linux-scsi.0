From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: SCSI regression in 2.6.27 and Nokia phones
Date: Tue, 18 Nov 2008 17:37:44 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0811181735340.25021-100000@netrider.rowland.org>
References: <49233DEA.8040700@emulex.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:1761 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753064AbYKRWhq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Nov 2008 17:37:46 -0500
In-Reply-To: <49233DEA.8040700@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>, "stable@kernel.org" <stable@kernel.org>

On Tue, 18 Nov 2008, James Smart wrote:

> Alan,
> 
> It was probably this change:
> http://marc.info/?l=linux-scsi&m=122118359130474&w=2
> 
> However, I would *not* back it out. It's a silent data corruption if you 
> do. Past behavior reset good_bytes to indicate all data was transfered 
> and ignored any residual - which meant if no data was transfered, we 
> misinform the callee and the callee gets stuck with whatever data is in 
> the buffer. Current behavior, the patch, uses residual, and likely falls 
> into an i/o retry path.

I agree, that was probably the cause, and I also agree that it should
not be removed.  That's part of what makes this so difficult; we don't
want to just remove the original cause, we want to fix things.

Alan Stern

