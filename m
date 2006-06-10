From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] Remove last page_address from dc395x.c
Date: Sat, 10 Jun 2006 22:56:06 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0606102248150.16586@poirot.grange>
References: <Pine.LNX.4.60.0606092216460.5256@poirot.grange>
 <1149904465.3131.19.camel@laptopd505.fenrus.org> <20060610095038.GA20526@infradead.org>
 <Pine.LNX.4.60.0606101528170.3305@poirot.grange> <20060610134042.GA7764@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.21]:39342 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1750750AbWFJU4J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Jun 2006 16:56:09 -0400
In-Reply-To: <20060610134042.GA7764@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Arjan van de Ven <arjan@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, Jamie Lenehan <lenehan@twibble.org>, linux-scsi@vger.kernel.org

On Sat, 10 Jun 2006, Christoph Hellwig wrote:

> On Sat, Jun 10, 2006 at 03:29:58PM +0200, Guennadi Liakhovetski wrote:
> > > > hmm I wonder if the non-use-sg case can ever happen?
> > > > (and if that irq_save isn't leaking here)
> > > 
> > > It can still happen in when invoked through the EH code, but I plan to fix
> > > that for 2.6.18.
> > 
> > "can happen" - you mean INQUIRY without sg (NOT irq_save leaking)?
> 
> Oh, that's a path only reached for INQUIRY commands.  No, there is no
> chance to get non-sg commands for 2.6.17+

Is the plan to completely remove non-sg commands from scsi? Then, I guess, 
at some point use_sg + void *request_buffer will be replaced with a 
sg_count + struct scatterlist *request_gs. Would it be better to keep the 
use_sg == 0 test in until then? Or shall I resubmit the patch without that 
check or with a BUG_ON(!use_sg)?

Thanks
Guennadi
---
Guennadi Liakhovetski
