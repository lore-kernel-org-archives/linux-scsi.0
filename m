From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] LLDD dynamic scan aids
Date: Thu, 18 Nov 2004 14:23:59 +0000
Message-ID: <20041118142359.GA23189@infradead.org>
References: <0B1E13B586976742A7599D71A6AC733C12E730@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([81.187.226.98]:54023 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S262032AbUKROYB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Nov 2004 09:24:01 -0500
Content-Disposition: inline
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C12E730@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

> Hmmm. I found the following discussion in Aug 2003 (http://marc.theaimsgroup.com/?l=linux-scsi&m=106183721811209&w=2). The argument is about exporting scsi_scan_host_selected() and alternatively using scsi_rescan_device().
> 
> This patch does not export scsi_scan_host_selected() - it simply updates the internals of scsi_scan_host() so the rescan flag is not always hardcoded to 0

which is about the same as a call to scsi_scan_host_selected with wildcards
for channel/target/lun.

> Given that scsi_rescan_device() works on a lun level, the lldd has no notion of what luns exist on the target, nor the appropriate scan logic for luns on a target (blacklist, etc), scsi_rescan_device() isn't appropriate to use (and would be very cumbersome).

IIRC FC defines notification of target discovery/removal, so that sounds
like the right level to probe to me, as the second hunk of your patch does.

What do you need the host level probe for?

> > >  	scsi_scan_host_selected(shost, SCAN_WILD_CARD, SCAN_WILD_CARD,
> > > -				SCAN_WILD_CARD, 0);
> > > +				SCAN_WILD_CARD, shost->rescan);
> > > +	shost->rescan=1;
> > 
> > this is missing whitespaces.  Also ->rescan is not used anywhere.
> 
> ?? Must have been late (or early).  The diff itself clearly shows the use of ->rescan in the call to scsi_scan_host_selected().

Yes, you're right.

> Missing whitespace ?? The only reference I can figure out is if the tabs were removed, and if so, it was an inadvertant paste into the mail message.

before and after the "=".

