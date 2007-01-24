From: Mark Haverkamp <markh@linux-foundation.org>
Subject: Re: [Patch 2/4] aacraid: expanded expose physical device code
Date: Wed, 24 Jan 2007 08:31:22 -0800
Message-ID: <1169656282.26207.11.camel@markh3.pdx.osdl.net>
References: <1169593190.10440.23.camel@markh3.pdx.osdl.net>
	 <20070124054902.GA14694@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42950 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723AbXAXQbe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Jan 2007 11:31:34 -0500
In-Reply-To: <20070124054902.GA14694@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

On Wed, 2007-01-24 at 05:49 +0000, Christoph Hellwig wrote:
> > +		if ((scsicmd->cmnd[0] == INQUIRY) && (expose_physicals <= 0)) {
> > +			u8 b;
> > +			u8 b1;
> > +			/* We can't expose disk devices because we can't
> > +			 * tell whether they are the raw container drives
> > +			 * or stand alone drives.  If they have the removable
> > +			 * bit set then we should expose them though.
> > +			 */
> > +			b = (*(u8*)scsicmd->request_buffer)&0x1f;
> > +			b1 = ((u8*)scsicmd->request_buffer)[1];
> > +			if (b == TYPE_TAPE || b == TYPE_WORM ||
> > +			    b == TYPE_ROM || b==TYPE_MOD ||
> > +			    b == TYPE_MEDIUM_CHANGER ||
> > +			    (b == TYPE_DISK && (b1 & 0x80))) {
> > +				scsicmd->result = DID_OK << 16 |
> > +					COMMAND_COMPLETE << 8;
> 
> This can't work at all.  request_buffer is always a scatterlist these days.
> Besides this implementation bug it's also not the wrong way to do it either.
> Please just return -ENXIO in ->slave_configure if sdev->type is not to
> your liking instead of failing the INQUIRY command.

Christoph,

I talked to Mark Salyzyn about this.  He wants to drop this patch for
the time being and re-think it.

James,

The other patches still apply with this one removed (One applies with
fuzz).  Is that OK or should I re-diff and resend them.

Mark.

-- 
Mark Haverkamp <markh@linux-foundation.org>

