From: Andre Hedrick <andre@linux-ide.org>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Fri, 12 Dec 2003 18:46:55 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.10.10312121838040.3805-100000@master.linux-ide.org>
References: <20031212124854.GH27116@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from astound-64-85-224-253.ca.astound.net ([64.85.224.253]:32012
	"EHLO master.linux-ide.org") by vger.kernel.org with ESMTP
	id S263792AbTLMCxE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Dec 2003 21:53:04 -0500
In-Reply-To: <20031212124854.GH27116@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: "N.C.Krishna Murthy" <krmurthy@cisco.com>, Christoph Hellwig <hch@infradead.org>, SCSI -DEVEL <linux-scsi@vger.kernel.org>, davmyers@cisco.com


Matthew,

This happens with any host.  It is a result of scsi_merge failing to
perforn a bounds check as it is attempting to create contigious
scatterlist nents.

Instead of creating a new nent base on page boundaries, because
scatterlists are bound to struct page, it does sane and normal sg list
merging.

There are cases were the length of the nent exceeds the lenght of the page
because of merging.  I know the problem and working on a fix for SATA II
rules, but something is fundementally broken in design.  Trying to tie
scatterlist nents to struct page is wrong unless one breaks on page
lengths.

I know the above is worded goofy, and I will try to explain it again after
a little more thought.

Cheers,

Andre Hedrick
LAD Storage Consulting Group

On Fri, 12 Dec 2003, Matthew Wilcox wrote:

> On Thu, Dec 11, 2003 at 09:17:46PM +0530, N.C.Krishna Murthy wrote:
> > Hi,
> > 	One of your comments was
> > "having multiple kmap() in the same process at the same time can deadlock(),
> > you redesign iscsi_xmit_task/iscsi_xmit_data/iscsi_recv_data not to do that.
> > for the tx path use ->sendpage to avoid a data copy and kmapping altogether".
> > 
> > I did try using sendpage in iscsi_xmit_data. 
> > Whenever the scatterlist->length was 4096 sendpage did succeed.
> > When it was 8192 I did see a panic 
> 
> could you post the code for that?
> 
> -- 
> "Next the statesmen will invent cheap lies, putting the blame upon 
> the nation that is attacked, and every man will be glad of those
> conscience-soothing falsities, and will diligently study them, and refuse
> to examine any refutations of them; and thus he will by and by convince 
> himself that the war is just, and will thank God for the better sleep 
> he enjoys after this process of grotesque self-deception." -- Mark Twain
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

