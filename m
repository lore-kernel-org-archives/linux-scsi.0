From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH RESEND number 2] libata: eliminate the home grown dma
 padding in favour of that provided by the block layer
Date: Mon, 04 Feb 2008 00:14:39 +0900
Message-ID: <47A5DA5F.3070209@gmail.com>
References: <1199138168.3110.12.camel@localhost.localdomain>	 <1200698057.3111.68.camel@localhost.localdomain>	 <1201894847.3134.59.camel@localhost.localdomain>	 <47A37AF3.3030503@garzik.org>	 <1201900175.3134.67.camel@localhost.localdomain> <47A52F23.70506@gmail.com>	 <1202013174.3187.69.camel@localhost.localdomain>	 <47A56F2B.4040904@gmail.com> <1202049511.3318.13.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.188]:2547 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbYBCPOs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Feb 2008 10:14:48 -0500
Received: by rv-out-0910.google.com with SMTP id k20so1241191rvb.1
        for <linux-scsi@vger.kernel.org>; Sun, 03 Feb 2008 07:14:47 -0800 (PST)
In-Reply-To: <1202049511.3318.13.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, Jens Axboe <Jens.Axboe@oracle.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

James Bottomley wrote:
> I'm reluctant to add another parameter to the request, but this one you
> can calculate:  you just do it wherever you work out the size of the
> request.  If data_len is the true data length and total_data_len is the
> data length plus the drain length, the calculation fragment is
> 
> if (blk_pc_request(req))
> 	data_len = req->data_len;
> else
> 	data_len = req->nr_sectors << 9;
> total_data_len = data_len + req->q->dma_drain_size;
> 
> If the request has already been mapped by scsi, then data_len is
> actually scsi_cmnd->sdb.length

We either need to add a field or a helper and rq->data_len should
probably record the size with drain buffer attached and either add
raw_data_len or blk_rq_raw_data_len().  That size is the length of data
in sg and should be programmed into the controller etc... For ATAPI the
raw size is only used to program the chunk size for odd devices.

>> What's needed is updating libata accordingly and testing it.
> 
> Actually, I sent the patch to do this a few days ago:
> 
> http://marc.info/?l=linux-ide&m=120189565418258
> 
> But I've attached it again.

Thanks a lot.

>> I'm currently away from all my toys.  I'll implement the ATA part,
>> test it and submit the patch on Monday.
> 
> Great, will look forward to the results.  Like I said, I think the turn
> on draining in slave configure should be narrowed from all ATAPI devices
> to all AHCI ATAPI devices if there's no evidence that any other
> implementation that uses DMA to transfer PIO isn't similarly broken (I
> know the aic94xx works fine, for instance ...

What do you mean by aic94xx working fine?  Does the controller
automatically throw away extra data FISes?

Off to bed now.  See you tomorrow.

-- 
tejun
