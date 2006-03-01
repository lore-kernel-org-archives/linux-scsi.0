From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH] SCSI sym53c8xx_2: bigger transfer limits
Date: Wed, 1 Mar 2006 22:34:28 +0200 (EET)
Message-ID: <Pine.LNX.4.63.0603012230370.5789@kai.makisara.local>
References: <Pine.LNX.4.63.0602282104040.6272@kai.makisara.local>
 <20060301152929.GZ4816@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep01-0.kolumbus.fi ([193.229.0.41]:61833 "EHLO
	fep01-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S1751059AbWCAUbd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Mar 2006 15:31:33 -0500
In-Reply-To: <20060301152929.GZ4816@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: matthew@wil.cx, linux-scsi@vger.kernel.org

On Wed, 1 Mar 2006, Jens Axboe wrote:

> On Tue, Feb 28 2006, Kai Makisara wrote:
> > This patch enables clustering and sets max_sectors to 0xffff to enable 
> > reading and writing of large blocks with tapes (and large transfers with 
> > sg). This change is needed after the sg and st drivers started using 
> > chained bios through scsi_request_async() in 2.6.16.
> > 
> > Signed-off-by: Kai Makisara <kai.makisara@kolumbus.fi>
> > 
> > --- linux-2.6.16-rc5/drivers/scsi/sym53c8xx_2/sym_glue.c	2006-02-04 13:25:48.000000000 +0200
> > +++ linux-2.6.16-rc5-k1/drivers/scsi/sym53c8xx_2/sym_glue.c	2006-02-18 09:45:24.000000000 +0200
> > @@ -1978,7 +1978,8 @@ static struct scsi_host_template sym2_te
> >  	.eh_bus_reset_handler	= sym53c8xx_eh_bus_reset_handler,
> >  	.eh_host_reset_handler	= sym53c8xx_eh_host_reset_handler,
> >  	.this_id		= 7,
> > -	.use_clustering		= DISABLE_CLUSTERING,
> > +	.use_clustering		= ENABLE_CLUSTERING,
> > +	.max_sectors		= 0xFFFF,
> 
> Strictly speaking, the clustering bit is unrelated.

It is related. The number of scatter/gather segments in the SCSI HBAs is 
limited. In order to fit the large requests into these limits, the 
adjacent pages (that have been split to bios) have to be recombined.

>                                                     I seem to recall
> Gerard years ago talking about some sym chips that did not like
> clustering, hence it was disabled.
> 
Facts?

-- 
Kai
