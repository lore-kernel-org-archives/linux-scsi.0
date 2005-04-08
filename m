From: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
Subject: Re: [PATCH] aacraid 2.6: Address sparse warnings
Date: Fri, 8 Apr 2005 17:37:24 +0100
Message-ID: <20050408163724.GG8859@parcelfarce.linux.theplanet.co.uk>
References: <1112884953.18191.0.camel@markh1.pdx.osdl.net> <20050408071351.GA5168@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:9668 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S262872AbVDHQh0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Apr 2005 12:37:26 -0400
Content-Disposition: inline
In-Reply-To: <20050408071351.GA5168@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Mark Haverkamp <markh@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

On Fri, Apr 08, 2005 at 08:13:51AM +0100, Christoph Hellwig wrote:
> > +			u32 temp = le32_to_cpu(psg->sg[i-1].count) - 
> > +				(byte_count - scsicmd->request_bufflen);
> > +			psg->sg[i-1].count = cpu_to_le32(temp);
> 
> You really want {be,le}*_{add,sub} helpers.  I needed them on various
> occasions, too.  Al, what do you think about adding these helpers to a
> common header somewhere?

*shrug*
Are you asking for suggestions regarding the suitable place for such
helpers?  include/linux/byteorder/generic.h would be the obvious
candidate...

> > +#define LE32_ALL_ONES ((__force __le32)0xffffffff)
> 
> I don't like having this in an actual driver.  It might make sense to
> either have this in a common header or actually allowing to assign all
> ones to __l32*/__be* variables.  Al?

It doesn't make sense, period.  Use cpu_to_le32(~0U) - calculations will
be done at compile time and it's self-documenting.  Definition above
is not more efficient or easier to type, so...
