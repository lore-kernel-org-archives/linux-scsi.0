From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH -mm 11/11] aacraid: use pci_set_dma_max_seg_size
Date: Wed, 24 Oct 2007 20:35:15 +0900
Message-ID: <20071024203515E.fujita.tomonori@lab.ntt.co.jp>
References: <67bb10d9f4e9473ddc84d9839114602c1966f19f.tomof@acm.org>
	<20071024173019I.tomof@acm.org>
	<471F2D12.50006@garzik.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:35110 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755334AbXJXLfl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Oct 2007 07:35:41 -0400
In-Reply-To: <471F2D12.50006@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jeff@garzik.org
Cc: tomof@acm.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, aacraid@adaptec.com, fujita.tomonori@lab.ntt.co.jp

On Wed, 24 Oct 2007 07:31:30 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> FUJITA Tomonori wrote:
> > This sets the segment size limit properly via pci_set_dma_max_seg_size
> > and remove blk_queue_max_segment_size because scsi-ml calls it.
> > 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > ---
> >  drivers/scsi/aacraid/linit.c |    9 ++++++---
> >  1 files changed, 6 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
> > index 038980b..04d6a65 100644
> > --- a/drivers/scsi/aacraid/linit.c
> > +++ b/drivers/scsi/aacraid/linit.c
> > @@ -435,9 +435,6 @@ static int aac_slave_configure(struct scsi_device *sdev)
> >  		else if (depth < 2)
> >  			depth = 2;
> >  		scsi_adjust_queue_depth(sdev, MSG_ORDERED_TAG, depth);
> > -		if (!(((struct aac_dev *)host->hostdata)->adapter_info.options &
> > -				AAC_OPT_NEW_COMM))
> > -			blk_queue_max_segment_size(sdev->request_queue, 65536);
> >  	} else
> >  		scsi_adjust_queue_depth(sdev, 0, 1);
> >  
> > @@ -1045,6 +1042,12 @@ static int __devinit aac_probe_one(struct pci_dev *pdev,
> >  	if (error < 0)
> >  		goto out_deinit;
> >  
> > +	if (!(aac->adapter_info.options & AAC_OPT_NEW_COMM)) {
> > +		error = pci_set_dma_max_seg_size(pdev, 65536);
> > +		if (error)
> > +			goto out_deinit;
> > +	}
> 
> 
> is this needed, given that the default is already 65536?

Yeah, but I thought that it would be better to set it explicitly
because 'aac->adapter_info.options & AAC_OPT_NEW_COMM' HBAs looks to
be able to handle larger segments.
