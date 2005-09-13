From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/8] aacraid: add name to driver template
Date: Tue, 13 Sep 2005 11:05:18 +0100
Message-ID: <20050913100518.GB30375@infradead.org>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F01919CB4@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:16311 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750753AbVIMKFT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Sep 2005 06:05:19 -0400
Content-Disposition: inline
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189F01919CB4@otce2k03.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>, Christoph Hellwig <hch@infradead.org>, Mark Haverkamp <markh@osdl.org>

On Mon, Sep 12, 2005 at 10:05:55AM -0400, Salyzyn, Mark wrote:
> Mark Salyzyn writes:
> >Christoph Hellwig writes:
> >>> +	aac_driver_template.name = aac_drivers[index].name;
> >>this is broken. it overwrites the name every time a host is allocated.
> >Especially it does this on a live template.  Just implemented ->info
> >
> >->info() is not enough, there are places in the scsi subsystem which do
> >not implement the info override over top the template name.
> >
> >I had discussed the possibility of submitting a patch to the scsi
> subsystem to fix that brokenness, I am generally concerned with legacy
> issues.
> 
> Looks like few remain. Could not figure a way to alter scsi_module.c
> that made sense, doable but expensive, but hosts.c could be fixed up
> with:

Ok.  Long-term I'll probably just kill ->name.  Note that all these
are error messages that don't happen unless someone broke the actual
driver, so adding the branding string there doesn't seem to be very
interesting..

