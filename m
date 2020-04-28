Return-Path: <SRS0=LQeo=6M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59E44C83004
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 11:43:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DCCF20737
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 11:43:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgD1Lnj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Apr 2020 07:43:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:40416 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726520AbgD1Lnj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Apr 2020 07:43:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 36AAFAD68;
        Tue, 28 Apr 2020 11:43:37 +0000 (UTC)
Subject: Re: [PATCH v9 10/11] block: export bio_release_pages and
 bio_iov_iter_get_pages
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@infradead.org>,
        linux-block <linux-block@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Keith Busch <kbusch@kernel.org>,
        "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-fsdevel @ vger . kernel . org" <linux-fsdevel@vger.kernel.org>
References: <20200428104605.8143-1-johannes.thumshirn@wdc.com>
 <20200428104605.8143-11-johannes.thumshirn@wdc.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <07494c4e-8f99-2b87-9f8b-c9ccd6e1acbb@suse.de>
Date:   Tue, 28 Apr 2020 13:43:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200428104605.8143-11-johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/28/20 12:46 PM, Johannes Thumshirn wrote:
> Export bio_release_pages and bio_iov_iter_get_pages, so they can be used
> from modular code.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---
>   block/bio.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/block/bio.c b/block/bio.c
> index 3aa3c4ce2e5e..e4c46e2bd5ba 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -951,6 +951,7 @@ void bio_release_pages(struct bio *bio, bool mark_dirty)
>   		put_page(bvec->bv_page);
>   	}
>   }
> +EXPORT_SYMBOL_GPL(bio_release_pages);
>   
>   static int __bio_iov_bvec_add_pages(struct bio *bio, struct iov_iter *iter)
>   {
> @@ -1114,6 +1115,7 @@ int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
>   		bio_set_flag(bio, BIO_NO_PAGE_REF);
>   	return bio->bi_vcnt ? 0 : ret;
>   }
> +EXPORT_SYMBOL_GPL(bio_iov_iter_get_pages);
>   
>   static void submit_bio_wait_endio(struct bio *bio)
>   {
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
