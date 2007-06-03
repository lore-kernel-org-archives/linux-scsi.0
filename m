From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH v2] add bidi support for block pc requests
Date: Sun, 03 Jun 2007 09:17:02 -0400
Message-ID: <1180876623.3876.50.camel@mulgrave.il.steeleye.com>
References: <464C1721.8030009@panasas.com>
	 <1179408422.3785.5.camel@mulgrave.il.steeleye.com>
	 <464C5FF5.6000705@panasas.com>
	 <20070517231127T.fujita.tomonori@lab.ntt.co.jp>
	 <464C799D.7080405@panasas.com> <46607FB0.4040103@garzik.org>
	 <4662717C.9040400@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:58571 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750759AbXFCNRH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Jun 2007 09:17:07 -0400
In-Reply-To: <4662717C.9040400@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Jeff Garzik <jeff@garzik.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, bhalevy@panasas.com, hch@infradead.org, akpm@linux-foundation.org, michaelc@cs.wisc.edu

On Sun, 2007-06-03 at 10:45 +0300, Boaz Harrosh wrote:
> Jeff Garzik wrote:
> > Boaz Harrosh wrote:
> >> FUJITA Tomonori wrote:
> >>> From: Boaz Harrosh <bharrosh@panasas.com>
> >>> Subject: Re: [PATCH v2] add bidi support for block pc requests
> >>> Date: Thu, 17 May 2007 17:00:21 +0300
> >>>
> >>>> Yes Tomo found it at ata_scsi_slave_config(). Attached below the way I
> >>>> fixed it. Now it works with 127.
> >>> I think that we can just remove blk_queue_max_phys_segments since the
> >>> ata drivers seem to set sg_tablesize to LIBATA_MAX_PRD.
> >>>
> >> Who should send a patch upstream? (I cc'ed Jeff Garzik)
> >>
> >> Boaz
> >>
> >> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> >> index dd81fa7..3660f3e 100644
> >> --- a/drivers/ata/libata-scsi.c
> >> +++ b/drivers/ata/libata-scsi.c
> >> @@ -800,8 +800,6 @@ int ata_scsi_slave_config(struct scsi_device *sdev)
> >>
> >>  	ata_scsi_sdev_config(sdev);
> >>
> >> -	blk_queue_max_phys_segments(sdev->request_queue, LIBATA_MAX_PRD);
> >> -
> >>  	sdev->manage_start_stop = 1;
> > 
> > I don't mind the patch, but could someone refresh me as to the context?
> > 
> > Is there something wrong with the above code, or is it simply redundant 
> > to the scsi_host_template settings in each LLDD?
> > 
> > 	Jeff
> > 
> > 
> > 
> 
> Hi Jeff
> What happens is that if SCSI-ml sets an higher value than LIBATA_MAX_PRD (=128)
> than every thing is OK and libata-scsi will only see its LIBATA_MAX_PRD. But what
> happens if SCSI-ml sets a lower value? It will than crash on unexpected high sg
> count. My first Patch was an "if >" but Tomo said that it is redundant since
> drivers do that already. So I guess it is your call. Can it be removed or we need
> a: if ( sdev->request_queue->max_phys_segments > LIBATA_MAX_PRD)

Ordinarily, in SCSI, phys_segments is the wrong thing for a driver to
set because what a driver wants to see is what comes out the other side
of dma_map_sg() (which is controlled by hw_segments) not what goes in.
However, I could see libata having an interest in the phys_segments if
the physical region descriptors are going to the device via PIO ... is
that what this is for?

James


