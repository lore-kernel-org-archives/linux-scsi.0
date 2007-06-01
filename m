From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH v2] add bidi support for block pc requests
Date: Fri, 01 Jun 2007 16:21:04 -0400
Message-ID: <46607FB0.4040103@garzik.org>
References: <464C1721.8030009@panasas.com>	<1179408422.3785.5.camel@mulgrave.il.steeleye.com>	<464C5FF5.6000705@panasas.com> <20070517231127T.fujita.tomonori@lab.ntt.co.jp> <464C799D.7080405@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:55470 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764515AbXFAUVO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Jun 2007 16:21:14 -0400
In-Reply-To: <464C799D.7080405@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James.Bottomley@SteelEye.com, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, bhalevy@panasas.com, hch@infradead.org, akpm@linux-foundation.org, michaelc@cs.wisc.edu

Boaz Harrosh wrote:
> FUJITA Tomonori wrote:
>> From: Boaz Harrosh <bharrosh@panasas.com>
>> Subject: Re: [PATCH v2] add bidi support for block pc requests
>> Date: Thu, 17 May 2007 17:00:21 +0300
>>
>>> Yes Tomo found it at ata_scsi_slave_config(). Attached below the way I
>>> fixed it. Now it works with 127.
>> I think that we can just remove blk_queue_max_phys_segments since the
>> ata drivers seem to set sg_tablesize to LIBATA_MAX_PRD.
>>
> 
> Who should send a patch upstream? (I cc'ed Jeff Garzik)
> 
> Boaz
> 
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index dd81fa7..3660f3e 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -800,8 +800,6 @@ int ata_scsi_slave_config(struct scsi_device *sdev)
> 
>  	ata_scsi_sdev_config(sdev);
> 
> -	blk_queue_max_phys_segments(sdev->request_queue, LIBATA_MAX_PRD);
> -
>  	sdev->manage_start_stop = 1;

I don't mind the patch, but could someone refresh me as to the context?

Is there something wrong with the above code, or is it simply redundant 
to the scsi_host_template settings in each LLDD?

	Jeff



