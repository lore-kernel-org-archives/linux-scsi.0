From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] IBM Power RAID driver (ipr)
Date: Tue, 20 Jan 2004 19:28:22 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040120192822.A19908@infradead.org>
References: <40085EDA.4010802@us.ibm.com> <20040119183400.A4182@infradead.org> <400C3E70.9040702@us.ibm.com> <20040120133858.A15671@infradead.org> <400D5A28.1000301@us.ibm.com> <20040120180151.A18616@infradead.org> <400D7DE2.2080402@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:11017 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S265710AbUATT2Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jan 2004 14:28:25 -0500
Content-Disposition: inline
In-Reply-To: <400D7DE2.2080402@us.ibm.com>; from brking@us.ibm.com on Tue, Jan 20, 2004 at 01:13:38PM -0600
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Jan 20, 2004 at 01:13:38PM -0600, Brian King wrote:
> > commands as in scsi commands or as in internal commands?
> 
> Internal commands. As you look through the driver, they will look very 
> similar, as the interface to the adapter maps to scsi pretty close. I 
> could use the mid-layer for these commands, but I would need some way to 
> send them when the adapter is self blocked and would probably need to 
> call scsi_add_host before the adapter is functional so I could send the 
> adapter initialization sequence.

Okay, so maybe we'll have to keep the internals commands without midlayer
interaction for the adapter intialization.

> The reason I have a pending_q is so that when I reset the adapter 
> without the mid-layer knowing about it, I need to fail back any 
> outstanding ops so they get retried as appropriate. I suppose a way 
> around this would be a mid-layer interface that an LLD could call which 
> would cause a host reset. Then the midlayer could drive the reset and 
> take care of doing the right thing with any outstanding ops.

Does scsi_reset_provider fit your needs?

