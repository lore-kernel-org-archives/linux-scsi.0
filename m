From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [RFC PATCH 2.6.9-rc2] add ability to set device queue depth to mptfusion
Date: Tue, 28 Sep 2004 12:43:24 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040928114324.GT16153@parcelfarce.linux.theplanet.co.uk>
References: <20040928075846.GA190230@sgi.com> <20040928114814.A794@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:45259 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S267651AbUI1Ln3
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2004 07:43:29 -0400
Content-Disposition: inline
In-Reply-To: <20040928114814.A794@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeremy Higdon <jeremy@sgi.com>, Emoore@lsil.com, linux-scsi@vger.kernel.org

On Tue, Sep 28, 2004 at 11:48:14AM +0100, Christoph Hellwig wrote:
> > +			else if (((pTarget->inq_data[0] & 0x1f) == 0x00)
> > +			  && (pTarget->minSyncFactor <= MPT_ULTRA160 ))
> 
> 
> 			else if (!(pTarget->inq_data[0] & 0x1f) &&
> 				 (pTarget->minSyncFactor <= MPT_ULTRA160)

I'm not sure about converting
	if ((pTarget->inq_data[0] & 0x1f) == 0x00)
to
	if (!(pTarget->inq_data[0] & 0x1f))

It really depends on the semantics -- in this case I think it's "this 5
bit field has the value 0", rather than "this field is not set".  It's the
same reason I hate people using if (!strcmp()) -- it's not that strcmp()
failed, it's that it returned 0.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
