From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] Remove last page_address from dc395x.c
Date: Sat, 10 Jun 2006 15:29:58 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0606101528170.3305@poirot.grange>
References: <Pine.LNX.4.60.0606092216460.5256@poirot.grange>
 <1149904465.3131.19.camel@laptopd505.fenrus.org> <20060610095038.GA20526@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:27064 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1751511AbWFJNaA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Jun 2006 09:30:00 -0400
In-Reply-To: <20060610095038.GA20526@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Arjan van de Ven <arjan@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, Jamie Lenehan <lenehan@twibble.org>, linux-scsi@vger.kernel.org

On Sat, 10 Jun 2006, Christoph Hellwig wrote:

> On Sat, Jun 10, 2006 at 03:54:25AM +0200, Arjan van de Ven wrote:
> > On Fri, 2006-06-09 at 22:25 +0200, Guennadi Liakhovetski wrote:
> > > +
> > > +		if (cmd->use_sg) {
> > > +			struct scatterlist* sg = (struct scatterlist *)cmd->request_buffer;
> > > +			size_t offset = 0, len = sizeof(struct ScsiInqData);
> > > +
> > > +			local_irq_save(flags);
> > > +			base = scsi_kmap_atomic_sg(sg, cmd->use_sg, &offset, &len);
> > > +			ptr = (struct ScsiInqData *)(base + offset);
> > > +		} else
> > > +			ptr = (struct ScsiInqData *)(cmd->request_buffer);
> > 
> > hmm I wonder if the non-use-sg case can ever happen?
> > (and if that irq_save isn't leaking here)
> 
> It can still happen in when invoked through the EH code, but I plan to fix
> that for 2.6.18.

"can happen" - you mean INQUIRY without sg (NOT irq_save leaking)?

Thanks
Guennadi
---
Guennadi Liakhovetski
