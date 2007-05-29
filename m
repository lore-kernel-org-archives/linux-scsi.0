From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [patch 6/7] ps3: ROM Storage Driver
Date: Tue, 29 May 2007 18:21:36 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0705291818560.7698@pademelon.sonytel.be>
References: <20070525083607.784351000@sonycom.com> <20070525083632.677742000@sonycom.com>
 <20070529104948.GC29351@lst.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:40364 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753863AbXE2QVj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 May 2007 12:21:39 -0400
In-Reply-To: <20070529104948.GC29351@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, 29 May 2007, Christoph Hellwig wrote:
> > +/*
> > + * copy data from device into scatter/gather buffer
> > + */
> > +static int fill_from_dev_buffer(struct scsi_cmnd *cmd, const void *buf,
> > +				int buflen)
> > +{
> > +	int k, req_len, act_len, len, active;
> > +	void *kaddr;
> > +	struct scatterlist *sgpnt;
> > +
> > +	if (!cmd->request_bufflen)
> > +		return 0;
> > +
> > +	if (!cmd->request_buffer)
> > +		return DID_ERROR << 16;
> > +
> > +	if (cmd->sc_data_direction != DMA_BIDIRECTIONAL &&
> > +	    cmd->sc_data_direction != DMA_FROM_DEVICE)
> > +		return DID_ERROR << 16;
> > +
> > +	if (!cmd->use_sg) {
> > +		req_len = cmd->request_bufflen;
> > +		act_len = min(req_len, buflen);
> > +		memcpy(cmd->request_buffer, buf, act_len);
> > +		cmd->resid = req_len - act_len;
> > +		return 0;
> > +	}
> 
> This is never true anymore.

Just to be sure: all four if-cases or only the last one?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- Sony Network and Software Technology Center Europe (NSCE)
Geert.Uytterhoeven@sonycom.com ------- The Corporate Village, Da Vincilaan 7-D1
Voice +32-2-7008453 Fax +32-2-7008622 ---------------- B-1935 Zaventem, Belgium
