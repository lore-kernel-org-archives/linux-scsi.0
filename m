From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] tmscsim: remove internal waiting queue (draft)
Date: Fri, 10 Sep 2004 14:29:53 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040910142953.A24592@infradead.org>
References: <Pine.LNX.4.60.0409040041030.5266@poirot.grange> <20040904141104.A15311@infradead.org> <Pine.LNX.4.60.0409062353100.7448@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:16137 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S267408AbUIJNaB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Sep 2004 09:30:01 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0409062353100.7448@poirot.grange>; from g.liakhovetski@gmx.de on Tue, Sep 07, 2004 at 12:12:11AM +0200
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, Kurt Garloff <garloff@suse.de>, linux-scsi@vger.kernel.org

On Tue, Sep 07, 2004 at 12:12:11AM +0200, Guennadi Liakhovetski wrote:
> Moving further in the order of patch submission:-)
> 
> On Sat, 4 Sep 2004, Christoph Hellwig wrote:
> 
> > On Sat, Sep 04, 2004 at 12:48:01AM +0200, Guennadi Liakhovetski wrote:
> >> Hello
> >>
> >> The attached patch __attempts__ to remove the internal "waiting" (issue)
> >> queue, in favour of using the scsi mid-layer command queuing.
> >>
> >> I may very well imaging, that it is not perfeect, __please__, comment.
> >>
> >> I did test it (what a surprise for such a trivial patch:-)), it worked, I
> >> even managed to hit that /* Arbitration lost but Reselection won */ case
> >> several times under load, although, I still don't undresrtand how this
> >> happens and what this means. An explanation would be appreciated.
> >
> > This one is definitly too complicated for just a quick look :)
> > You'd make the review easier by splitting it up a little or at least
> > remove the gratious reformating from this patch.
> 
> In the attached patch I removed all the reformatting. Applies on the top 
> of the latest version of the bug #2139 fix (using the global black-list).

Looks good to me.  The only nitpick is that you opencode a freelist insert
in ->queuecommand instead of using dc390_Free_insert.

