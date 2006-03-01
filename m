From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH] SCSI sym53c8xx_2: bigger transfer limits
Date: Thu, 2 Mar 2006 00:24:27 +0200 (EET)
Message-ID: <Pine.LNX.4.63.0603020011500.5789@kai.makisara.local>
References: <Pine.LNX.4.63.0602282104040.6272@kai.makisara.local>
 <20060301152929.GZ4816@suse.de> <Pine.LNX.4.63.0603012230370.5789@kai.makisara.local>
 <20060301204345.GP4816@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep30-0.kolumbus.fi ([193.229.0.32]:56004 "EHLO
	fep30-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S1751285AbWCAWV2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Mar 2006 17:21:28 -0500
In-Reply-To: <20060301204345.GP4816@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: matthew@wil.cx, linux-scsi@vger.kernel.org

On Wed, 1 Mar 2006, Jens Axboe wrote:

> On Wed, Mar 01 2006, Kai Makisara wrote:
> > On Wed, 1 Mar 2006, Jens Axboe wrote:
> > 
> > > On Tue, Feb 28 2006, Kai Makisara wrote:
> > > > This patch enables clustering and sets max_sectors to 0xffff to enable 
> > > > reading and writing of large blocks with tapes (and large transfers with 
> > > > sg). This change is needed after the sg and st drivers started using 
> > > > chained bios through scsi_request_async() in 2.6.16.
> > > > 
> > > > Signed-off-by: Kai Makisara <kai.makisara@kolumbus.fi>
> > > > 
> > > > --- linux-2.6.16-rc5/drivers/scsi/sym53c8xx_2/sym_glue.c	2006-02-04 13:25:48.000000000 +0200
> > > > +++ linux-2.6.16-rc5-k1/drivers/scsi/sym53c8xx_2/sym_glue.c	2006-02-18 09:45:24.000000000 +0200
> > > > @@ -1978,7 +1978,8 @@ static struct scsi_host_template sym2_te
> > > >  	.eh_bus_reset_handler	= sym53c8xx_eh_bus_reset_handler,
> > > >  	.eh_host_reset_handler	= sym53c8xx_eh_host_reset_handler,
> > > >  	.this_id		= 7,
> > > > -	.use_clustering		= DISABLE_CLUSTERING,
> > > > +	.use_clustering		= ENABLE_CLUSTERING,
> > > > +	.max_sectors		= 0xFFFF,
> > > 
> > > Strictly speaking, the clustering bit is unrelated.
> > 
> > It is related. The number of scatter/gather segments in the SCSI HBAs is 
> > limited. In order to fit the large requests into these limits, the 
> > adjacent pages (that have been split to bios) have to be recombined.
> 
> As James also described, you cannot rely on clustering at all to get you
> bigger requests. I'm thinking you are perhaps misunderstanding what that
> option does - it only potentially limits the number of sg segments in a
> request, if the pages happen to be physically contig. So it'll only help
> you to a certain degree, IFF the pages are indeed adjacent in memory.
> It's an extra optimization that isn't deterministic at all.
> 
The computer is deterministic. In this case we know what pages are 
physically contiguous because they have been allocated in kernel space 
with alloc_pages(). The st driver has made sure that the buffer can be 
described with the scatter/gather list supported by the SCSI HBA.

In general, you should not rely on coalescing. Here I agree with you. If 
you know what the buffer structure is, then you may be able to rely on 
coalescing.

> And it definitely is unrelated to how many sectors you can support. As
> such, these two unrelated patches should submitted seperately. The
> clustering bit is potentially more dangerous, as the hardware can have
> all sorts of 'issues' related to the size and alignment of sg segments.
> 
They are related if in the sense that both are needed in order to support 
large requests. However, I don't mind if someone splits those changes into 
two patches if both go in. Otherwise I don't recommend sym53c8xx_2 and/or 
sym53c8xx chips for any serious work any more.

> > >                                                     I seem to recall
> > > Gerard years ago talking about some sym chips that did not like
> > > clustering, hence it was disabled.
> > > 
> > Facts?
> 
> I'm just reporting what Gerald (who definitely knows this hardware very
> well) told me, when I submitted a patch to him enabling clustering a
> long time ago. This might have been about 5 years ago, I seem to recall
> it happening when I used a un ultra10 workstation which had a sym scsi
> board.
> 
A bit vague but I guess this is all we know. Unless Matthew knows more?

-- 
Kai
