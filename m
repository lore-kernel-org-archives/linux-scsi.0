From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH] fusion: streamline ->queuecommand
Date: 05 Oct 2004 18:11:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1097017890.1765.216.camel@mulgrave>
References: <0E3FA95632D6D047BA649F95DAB60E570526235F@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:12424 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266555AbUJEXMH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Oct 2004 19:12:07 -0400
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E570526235F@exa-atlanta>
List-Id: linux-scsi@vger.kernel.org
To: Eric Dean Moore <Emoore@lsil.com>
Cc: "Stephens, Larry" <larry.stephens@lsil.com>, "Shirron, Stephen" <Stephen.Shirron@lsil.com>, "Gibbons, Terry" <Terry.Gibbons@lsil.com>, Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>, Christoph Hellwig <hch@lst.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-10-05 at 17:38, Moore, Eric Dean wrote:
> Can we assume that all linux distributions provide at least 57 bytes of
> inquiry data
> during the scsi bus scan?   I don't know if Suse has solved this, but they
> were
> in 2.4 kernel only sending 36 bytes of inquiry data.

2.6 always does a two phase inquiry, the minimum first and then the full
inquiry string.  We pick the negotiation flags you're looking for out of
the inquiry data and save them away in the scsi_device structure, so you
don't even have to parse the saved inquiry data.

> > > (6) DV algorithm works, and well tested, and accepted by 
> > our OEMS. Nothing
> > > is broke. Why break it?    
> > 
> > Because sharing code and thus increasing its usage is good.
> 
> That is not a risk that LSI Logic is willing to take;   
> currently there is not a 2.7 kernel testbed for this. 
> Having someone outside LSI blindly posting a patch removing our
> DV and not having throughly tested could have grave results. 
> The DV currently in place has been thru many test cycles in our own
> test labs, and these drivers are well accepted by our customer base.
> Other LSI employees copied on this email can comment futher on that.

I'm not forcing people to use it ... yet.

However, the attitude that "my driver works and I've tested it, so I'm
not going to change it" is in a large measure what got the SCSI subsytem
into its pariah status in 2.4: too many in-driver work arounds and no
thought to fixing the problems in the generic code.

If the benefits of sharing common code in an open source model aren't
apparent then consider this: the last three critical Adaptec bugs were
all in the domain validation code; and they thought their driver was
"thoroughly tested" too.

James


