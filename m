From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] aacraid 2.6: Address sparse warnings
Date: Fri, 8 Apr 2005 08:13:51 +0100
Message-ID: <20050408071351.GA5168@infradead.org>
References: <1112884953.18191.0.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:7349 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262717AbVDHHNx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Apr 2005 03:13:53 -0400
Content-Disposition: inline
In-Reply-To: <1112884953.18191.0.camel@markh1.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>, viro@parcelfarce.linux.theplanet.co.uk

> +			u32 temp = le32_to_cpu(psg->sg[i-1].count) - 
> +				(byte_count - scsicmd->request_bufflen);
> +			psg->sg[i-1].count = cpu_to_le32(temp);

You really want {be,le}*_{add,sub} helpers.  I needed them on various
occasions, too.  Al, what do you think about adding these helpers to a
common header somewhere?

> +#define LE32_ALL_ONES ((__force __le32)0xffffffff)

I don't like having this in an actual driver.  It might make sense to
either have this in a common header or actually allowing to assign all
ones to __l32*/__be* variables.  Al?

