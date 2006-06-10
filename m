From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] Remove last page_address from dc395x.c
Date: Sat, 10 Jun 2006 11:21:31 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0606101044390.3998@poirot.grange>
References: <Pine.LNX.4.60.0606092216460.5256@poirot.grange>
 <1149904465.3131.19.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:16542 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1751443AbWFJJVe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Jun 2006 05:21:34 -0400
In-Reply-To: <1149904465.3131.19.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Jamie Lenehan <lenehan@twibble.org>, linux-scsi@vger.kernel.org

On Sat, 10 Jun 2006, Arjan van de Ven wrote:

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

Good question. I thought it would be better to be on the safe side.

> (and if that irq_save isn't leaking here)

AFAICS, no. Looks like use_sg is constant throughout scsi_cmnd's 
life-cycle, apart from error-handling.

Thanks
Guennadi
---
Guennadi Liakhovetski
