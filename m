From: Andrew Vasquez <praka@users.sourceforge.net>
Subject: Re: [PATCH] 2.6.3 qla2xxx driver -- use readX_relaxed
Date: Thu, 4 Mar 2004 21:51:17 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040305055117.GA9315@praka.local.home>
References: <B179AE41C1147041AA1121F44614F0B060EE25@AVEXCH02.qlogic.org> <20040303101014.GA586666@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-02-qfe0.socal.rr.com ([66.75.162.134]:6791 "EHLO
	ms-smtp-02-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S262203AbUCEGML (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Mar 2004 01:12:11 -0500
Content-Disposition: inline
In-Reply-To: <20040303101014.GA586666@sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jeremy Higdon <jeremy@sgi.com>

On Wed, 03 Mar 2004, Jeremy Higdon wrote:
> On Mon, Mar 01, 2004 at 04:45:49PM -0800, Andrew Vasquez wrote:
> > Interesting...but this implementation seems to be applying a different
> > set of semantic rules to the term 'relaxed' in comparison to the
> > 'relaxed ordering' rules defined by PCI-X and PCI-Express, no?
> 
> 
> I'm going to retract my previous agreement to this :-).  I took a good
> look at the PCI Express specification today, and it appears to me as
> though this implementation should be applicable to PCI Express.
> 

The intent of my original statement wasn't to imply that the
readX_relaxed() routines wouldn't be applicable to PCI-[X|Express],
but instead to note my own concerns with the differing semantics of
readX_relaxed() and 'relaxed ordering' of PCI-[X|Express], which you
mention below.

> When set, it indicates that the posted write or the read completion
> (reply from the device to the PIO read) may pass other posted writes,
> read completions, or messages.
> 

I've read through the original readX_relaxed() thread posted on LK and
no-one else seemed to express similiar concerns.  My own personal
slant leans towards the readX_nosyncdma() name, but again I seem to
always be in the minority...

Finally, in looking through other locations where we could apply this
technique (though i must admit your patch covers almost all fast-path
uses), the old calls to qla2x00_debounce_register(ISP_REQ_Q_OUT())
in qla2x00_req_pkt() and qla2x00_ms_req_pkt() should be replaced with
the standard RD_REG_WORD().  Through not in the fast, the
RD_REG_WORD() could then be extended to the *_relaxed() calls.

Thanks again for the patches.

Regards,
Andrew Vasquez
