From: Christoph Hellwig <hch@lst.de>
Subject: Re: [patch 6/7] ps3: ROM Storage Driver
Date: Wed, 30 May 2007 12:01:45 +0200
Message-ID: <20070530100145.GA24586@lst.de>
References: <20070525083607.784351000@sonycom.com> <20070525083632.677742000@sonycom.com> <20070529104948.GC29351@lst.de> <Pine.LNX.4.62.0705291818560.7698@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:54777 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396AbXE3KCX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 May 2007 06:02:23 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.62.0705291818560.7698@pademelon.sonytel.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Christoph Hellwig <hch@lst.de>, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, May 29, 2007 at 06:21:36PM +0200, Geert Uytterhoeven wrote:
> On Tue, 29 May 2007, Christoph Hellwig wrote:
> > > +/*
> > > + * copy data from device into scatter/gather buffer
> > > + */
> > > +static int fill_from_dev_buffer(struct scsi_cmnd *cmd, const void *buf,
> > > +				int buflen)
> > > +{
> > > +	int k, req_len, act_len, len, active;
> > > +	void *kaddr;
> > > +	struct scatterlist *sgpnt;
> > > +
> > > +	if (!cmd->request_bufflen)
> > > +		return 0;
> > > +
> > > +	if (!cmd->request_buffer)
> > > +		return DID_ERROR << 16;
> > > +
> > > +	if (cmd->sc_data_direction != DMA_BIDIRECTIONAL &&
> > > +	    cmd->sc_data_direction != DMA_FROM_DEVICE)
> > > +		return DID_ERROR << 16;
> > > +
> > > +	if (!cmd->use_sg) {
> > > +		req_len = cmd->request_bufflen;
> > > +		act_len = min(req_len, buflen);
> > > +		memcpy(cmd->request_buffer, buf, act_len);
> > > +		cmd->resid = req_len - act_len;
> > > +		return 0;
> > > +	}
> > 
> > This is never true anymore.
> 
> Just to be sure: all four if-cases or only the last one?

That's just in reference to the last one.  The checks above could
be condensed a little more aswell, but I'll comment on further in
the second round of review, in the hope that the command submission
path is a lot more streamline by then already.

