From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 4/6] SCSI: simplify target destruction
Date: Mon, 8 Jun 2009 16:14:45 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0906081610190.13888-100000@netrider.rowland.org>
References: <4A2CC313.1030703@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:34074 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750853AbZFHUOo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2009 16:14:44 -0400
In-Reply-To: <4A2CC313.1030703@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Kay Sievers <kay.sievers@vrfy.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 8 Jun 2009, Hannes Reinecke wrote:

> Hi Alan,
> 
> Alan Stern wrote:
> > This patch (as1249) adds an extra state, STARGET_NEW, to the SCSI
> > target state model.  A target is in this state initially and changes
> > over to STARGET_CREATED when the hostt->target_alloc() call has been
> > made.
> > 
> > This simplifies target destruction.  There's no need for a separate
> > scsi_target_destroy() function; everything can be handled within
> > scsi_target_reap().  The error paths are more robust because now it's
> > easy to verify that all the destructors are called along every
> > pathway.
> > 
> Hmm. Is there a specific reason why we have to keep the ->reap_ref
> counter around and cannot use the 'normal' driver core reference
> counting for this?

Yes, there's a very good reason.

> Duplicating refcounting doesn't seem logical to me, given that
> we already have a 'struct device' hanging about ...

We are talking about two different refcounts serving two different
purposes.  The refcount that is embedded inside struct device controls
the structure's overall lifetime; when that count goes to 0 the release
method is called and the structure is deallocated.

By contrast, starget->reap_ref is (or rather, becomes later on in the 
patch series) a count of the number of visible LUNs below the target.  
When this number drops to 0 the target is removed from visibility, 
i.e., we call device_del() for it.  But it remains allocated until the 
other refcount also becomes 0.

Alan Stern

