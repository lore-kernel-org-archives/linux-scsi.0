From: Christoph Hellwig <hch@infradead.org>
Subject: Re: osst changes required to move forward to block request
Date: Tue, 7 Feb 2006 09:12:55 +0000
Message-ID: <20060207091254.GA11691@infradead.org>
References: <20060206131944.GA1769@lst.de> <1139274141l.7464l.1l@athena.riede.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:43157 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932174AbWBGJM5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Feb 2006 04:12:57 -0500
Content-Disposition: inline
In-Reply-To: <1139274141l.7464l.1l@athena.riede.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Willem Riede <osst@riede.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Mon, Feb 06, 2006 at 08:02:21PM -0500, Willem Riede wrote:
> On 02/06/2006 08:19:44 AM, Christoph Hellwig wrote:
> >Hi Willem,
> >
> >do you still maintain the osst driver?  We're moving forward to
> >completly get rid of the scsi_request structure in the scsi midlayer,
> >and osst is the only upper level driver still using it.  I've tried to
> >convert it similar to st, but gave up.  The biggest problem for me is
> >the scsi_request reuse over the driver where a pointer to a pointer to
> >a scsi_request is passed along all the callchain, and I have a really
> >hard time to find out whether the functions actually looks it, or only
> 
> "looks it"?? don't understand :-(

sorry, should have read "looks at it"  as in examines fields in the request
or looks at the result of performing the scsi command.

> But I will certainly help retire scsi_request. And anything else that is  
> needed to keep up with proper kernel style. Let me know what those are, if 
> you  would? I'll start looking at how st has changed, and will be back with 
> any  questions I may have.

right now the above is the most urgent bit.  What would be nice but not
required is a conversion to the sense handling helpers, similar to what
st got (aka using the *normalize_sense functions and then dealing with the
parsed sense buffer instead of the raw sense data)
