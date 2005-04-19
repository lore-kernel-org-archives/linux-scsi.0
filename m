From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Can a non-sg scsi write command be more than PAGE_SIZE length?
Date: Tue, 19 Apr 2005 10:29:26 +0100
Message-ID: <20050419092926.GA9785@infradead.org>
References: <20050419084730.GA96767@dspnet.fr.eu.org> <20050419085008.GA9194@infradead.org> <20050419092431.GA98975@dspnet.fr.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:33256 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261419AbVDSJ31 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Apr 2005 05:29:27 -0400
Content-Disposition: inline
In-Reply-To: <20050419092431.GA98975@dspnet.fr.eu.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olivier Galibert <galibert@pobox.com>, "Hack inc." <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Tue, Apr 19, 2005 at 11:24:31AM +0200, Olivier Galibert wrote:
> > Yes, it's allowed.
> 
> Thanks.  Pages in that case are continuous then, right?

Good question actually.  I know XFS does passed vmalloc'ed memory down
the block I/O path, but that's as a scatter/gather request.  All non-s/g
request should be contingous I think.

We really need to write down the rules about what memory can be passed
down the block I/O path - XFS for example sends kmalloced memory down
which all the iSCSI implementations don't like at all.
