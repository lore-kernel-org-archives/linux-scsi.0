Return-Path: <SRS0=EUsX=4Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70E8AC3F2D0
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Feb 2020 08:28:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DD9E246A2
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Feb 2020 08:28:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbgB1I2B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Feb 2020 03:28:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:49580 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726151AbgB1I2A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Feb 2020 03:28:00 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6D4DAAC65;
        Fri, 28 Feb 2020 08:27:58 +0000 (UTC)
Subject: Re: [PATCH v7 10/38] sg: improve naming
To:     Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
References: <20200227165902.11861-1-dgilbert@interlog.com>
 <20200227165902.11861-11-dgilbert@interlog.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <11e41b41-8569-173a-3ce0-a6013e57f7da@suse.de>
Date:   Fri, 28 Feb 2020 09:27:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200227165902.11861-11-dgilbert@interlog.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/27/20 5:58 PM, Douglas Gilbert wrote:
> Remove use of typedef sg_io_hdr_t and replace with struct
> sg_io_hdr. Change some names on driver wide structure fields
> and comment them. Rename sg_alloc() to sg_add_device_helper()
> to reflect its current role.
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> ---
>   drivers/scsi/sg.c | 240 ++++++++++++++++++++++++----------------------
>   1 file changed, 127 insertions(+), 113 deletions(-)
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 246c630d3523..eb3b333ea30b 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -92,7 +92,7 @@ static int sg_allow_dio = SG_ALLOW_DIO_DEF;
>   static int scatter_elem_sz = SG_SCATTER_SZ;
>   static int scatter_elem_sz_prev = SG_SCATTER_SZ;
>   
> -#define SG_SECTOR_SZ 512
> +#define SG_DEF_SECTOR_SZ 512
>   
>   static int sg_add_device(struct device *, struct class_interface *);
>   static void sg_remove_device(struct device *, struct class_interface *);
> @@ -105,12 +105,13 @@ static struct class_interface sg_interface = {
>   	.remove_dev     = sg_remove_device,
>   };
>   
> -struct sg_scatter_hold { /* holding area for scsi scatter gather info */
> -	u16 k_use_sg; /* Count of kernel scatter-gather pieces */
> +struct sg_scatter_hold {     /* holding area for scsi scatter gather info */
> +	struct page **pages;	/* num_sgat element array of struct page* */
> +	int buflen;		/* capacity in bytes (dlen<=buflen) */
> +	int dlen;		/* current valid data length of this req */
> +	u16 page_order;		/* byte_len = (page_size*(2**page_order)) */
> +	u16 num_sgat;		/* actual number of scatter-gather segments */
>   	unsigned int sglist_len; /* size of malloc'd scatter-gather list ++ */
> -	unsigned int bufflen;	/* Size of (aggregate) data buffer */
> -	struct page **pages;
> -	int page_order;
>   	char dio_in_use;	/* 0->indirect IO (or mmap), 1->dio */
>   	u8 cmd_opcode;		/* first byte of command */
>   };
While you're at it, it might be worthwhile to exchange the order of the 
last two fields.
Having a 'char' before the 'u8' guarantees either a misaligned structure 
or implicit padding by the compiler, neither of which is a good thing.

> @@ -122,20 +123,20 @@ struct sg_request {	/* SG_MAX_QUEUE requests outstanding per file */
>   	struct list_head entry;	/* list entry */
>   	struct sg_fd *parentfp;	/* NULL -> not in use */
>   	struct sg_scatter_hold data;	/* hold buffer, perhaps scatter list */
> -	sg_io_hdr_t header;	/* scsi command+info, see <scsi/sg.h> */
> +	struct sg_io_hdr header;  /* scsi command+info, see <scsi/sg.h> */
>   	u8 sense_b[SCSI_SENSE_BUFFERSIZE];
>   	char res_used;		/* 1 -> using reserve buffer, 0 -> not ... */
>   	char orphan;		/* 1 -> drop on sight, 0 -> normal */
>   	char sg_io_owned;	/* 1 -> packet belongs to SG_IO */
>   	/* done protected by rq_list_lock */
>   	char done;		/* 0->before bh, 1->before read, 2->read */

And here a bitfield might be a good idea, as otherwise you might run 
into alignment / padding issues again ...

Cheers,

Hannes

-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
