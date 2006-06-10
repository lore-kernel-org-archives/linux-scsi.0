From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Remove last page_address from dc395x.c
Date: Sat, 10 Jun 2006 10:50:38 +0100
Message-ID: <20060610095038.GA20526@infradead.org>
References: <Pine.LNX.4.60.0606092216460.5256@poirot.grange> <1149904465.3131.19.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:29677 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750832AbWFJJul (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Jun 2006 05:50:41 -0400
Content-Disposition: inline
In-Reply-To: <1149904465.3131.19.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, James Bottomley <James.Bottomley@steeleye.com>, Jamie Lenehan <lenehan@twibble.org>, linux-scsi@vger.kernel.org

On Sat, Jun 10, 2006 at 03:54:25AM +0200, Arjan van de Ven wrote:
> On Fri, 2006-06-09 at 22:25 +0200, Guennadi Liakhovetski wrote:
> > +
> > +		if (cmd->use_sg) {
> > +			struct scatterlist* sg = (struct scatterlist *)cmd->request_buffer;
> > +			size_t offset = 0, len = sizeof(struct ScsiInqData);
> > +
> > +			local_irq_save(flags);
> > +			base = scsi_kmap_atomic_sg(sg, cmd->use_sg, &offset, &len);
> > +			ptr = (struct ScsiInqData *)(base + offset);
> > +		} else
> > +			ptr = (struct ScsiInqData *)(cmd->request_buffer);
> 
> hmm I wonder if the non-use-sg case can ever happen?
> (and if that irq_save isn't leaking here)

It can still happen in when invoked through the EH code, but I plan to fix
that for 2.6.18.

