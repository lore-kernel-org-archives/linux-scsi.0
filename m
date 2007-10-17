From: Willy Tarreau <w@1wt.eu>
Subject: Re: [Bug 3680] sym53c8xx_2 SMP deadlock on driver load
Date: Wed, 17 Oct 2007 20:46:48 +0200
Message-ID: <20071017184648.GB4533@1wt.eu>
References: <20071017013045.A19ED108036@picon.linux-foundation.org> <471621D2.5080806@cybernetics.com> <20071017162747.GA32174@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 1wt.eu ([62.212.114.60]:3180 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756751AbXJQSwA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Oct 2007 14:52:00 -0400
Content-Disposition: inline
In-Reply-To: <20071017162747.GA32174@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Tony Battersby <tonyb@cybernetics.com>, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, protasnb@gmail.com, bugme-daemon@bugzilla.kernel.org

On Wed, Oct 17, 2007 at 10:27:47AM -0600, Matthew Wilcox wrote:
> On Wed, Oct 17, 2007 at 10:53:06AM -0400, Tony Battersby wrote:
> > After looking at it carefully, this is true of pci_map_mem, but not
> > pci_unmap_mem.  pci_unmap_mem can be called from both ->detect and
> > ->release.  io_request_lock is held in ->detect but not in ->release.
> > So, your patch locks up the system on module unload.
> 
> My mistake.  I should have checked the iorl was held over ->release too.
> 
> This is a pretty ugly patch, but I think the three alternatives are
> worse:
> 
>  - Drop the iorl at the beginning of ->detect and reacquire it at exit.
>    We don't know what else the iorl might be protecting.  Probably
>    nothing, but I don't want to audit it.
>  - Convert sym2 back to old error handling so the midlayer doesn't
>    acquire the iorl for us in ->detect.
>  - Acquire the iorl in ->release.  We might deadlock on something.
> 
> So, sure, apply this patch.

Matthew,

Sincere thanks for your help and review. I'll apply this patch in
2.4.36-pre2 and in next 2.4.35.X. An ugly fix is clearly better than
a massive change at this stage.

Natalie, if you want, you can close the bug right now, I've queued the
patch for both branches.

Best regards,
Willy

