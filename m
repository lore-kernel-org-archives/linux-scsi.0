From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] convert 53c700 driver to use change_queue_depth API
Date: Wed, 22 Dec 2004 10:53:33 -0600
Message-ID: <1103734414.5290.8.camel@mulgrave>
References: <1102812847.5232.6.camel@mulgrave>
	 <Pine.LNX.4.60.0412201605360.15046@poirot.grange>
	 <Pine.LNX.4.60.0412201700350.16691@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:32153 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261839AbULVQxp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Dec 2004 11:53:45 -0500
In-Reply-To: <Pine.LNX.4.60.0412201700350.16691@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2004-12-20 at 17:04 +0100, Guennadi Liakhovetski wrote:
> On Mon, 20 Dec 2004, Guennadi Liakhovetski wrote:
> 
> > Shouldn't it really be something like
> > 
> >  	if(depth > NCR_700_MAX_TAGS)
> > -		return -EINVAL;
> > +		depth = NCR_700_MAX_TAGS;
> > +	if (depth < 0)
> > +		depth = 0;
> 
> Ahh, yeah, sure, because of the simple_strtoul incompatibility with glibc 
> this check is superfluous, but, the below doubt still remains

Actually, depth may never be zero.  There is a check in an updated piece
of code which I'll send out shortly that checks it is never less than
one (in the main routine).  This got folded into an update I did and
then not properly separated again.

I'll send the update under a new subject.

James


