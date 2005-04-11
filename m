From: Mark Haverkamp <markh@osdl.org>
Subject: Re: [PATCH] aacraid 2.6: Address sparse warnings
Date: Mon, 11 Apr 2005 10:04:04 -0700
Message-ID: <1113239044.11839.12.camel@markh1.pdx.osdl.net>
References: <1112884953.18191.0.camel@markh1.pdx.osdl.net>
	 <20050408071351.GA5168@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:16287 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S261860AbVDKRE3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Apr 2005 13:04:29 -0400
In-Reply-To: <20050408071351.GA5168@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>, viro@parcelfarce.linux.theplanet.co.uk

On Fri, 2005-04-08 at 08:13 +0100, Christoph Hellwig wrote:
> > +			u32 temp = le32_to_cpu(psg->sg[i-1].count) - 
> > +				(byte_count - scsicmd->request_bufflen);
> > +			psg->sg[i-1].count = cpu_to_le32(temp);
> 
> You really want {be,le}*_{add,sub} helpers.  I needed them on various
> occasions, too.  Al, what do you think about adding these helpers to a
> common header somewhere?

Do you have helper functions already that you've used elsewhere?  If so,
you could add them in somewhere and I could fix these spots later.


> 
> > +#define LE32_ALL_ONES ((__force __le32)0xffffffff)
> 
> I don't like having this in an actual driver.  It might make sense to
> either have this in a common header or actually allowing to assign all
> ones to __l32*/__be* variables.  Al?

I'll put these back to the cpu_to_le32(0xffffffff)

Mark.


-- 
Mark Haverkamp <markh@osdl.org>

