Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58E25C4338F
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Aug 2021 10:11:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39D2C60F02
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Aug 2021 10:11:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236963AbhHDKLV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Aug 2021 06:11:21 -0400
Received: from ivanoab7.miniserver.com ([37.128.132.42]:56360 "EHLO
        www.kot-begemot.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237455AbhHDKKX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Aug 2021 06:10:23 -0400
Received: from tun252.jain.kot-begemot.co.uk ([192.168.18.6] helo=jain.kot-begemot.co.uk)
        by www.kot-begemot.co.uk with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <anton.ivanov@cambridgegreys.com>)
        id 1mBDqd-0007cx-Mc; Wed, 04 Aug 2021 10:10:03 +0000
Received: from jain.kot-begemot.co.uk ([192.168.3.3])
        by jain.kot-begemot.co.uk with esmtp (Exim 4.92)
        (envelope-from <anton.ivanov@cambridgegreys.com>)
        id 1mBDqa-00016q-Pt; Wed, 04 Aug 2021 11:10:03 +0100
Subject: Re: [PATCH 11/15] ubd: use bvec_virt
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     Richard Weinberger <richard@nod.at>,
        Geoff Levand <geoff@infradead.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Song Liu <song@kernel.org>, Mike Snitzer <snitzer@redhat.com>,
        Coly Li <colyli@suse.de>, Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-um@lists.infradead.org, ceph-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20210804095634.460779-1-hch@lst.de>
 <20210804095634.460779-12-hch@lst.de>
From:   Anton Ivanov <anton.ivanov@cambridgegreys.com>
Message-ID: <0abadeca-d0fc-26ad-088e-2b137a029957@cambridgegreys.com>
Date:   Wed, 4 Aug 2021 11:10:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210804095634.460779-12-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Clacks-Overhead: GNU Terry Pratchett
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 04/08/2021 10:56, Christoph Hellwig wrote:
> Use bvec_virt instead of open coding it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   arch/um/drivers/ubd_kern.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
> index e497185dd393..cd9dc0556e91 100644
> --- a/arch/um/drivers/ubd_kern.c
> +++ b/arch/um/drivers/ubd_kern.c
> @@ -1268,8 +1268,7 @@ static void ubd_map_req(struct ubd *dev, struct io_thread_req *io_req,
>   		rq_for_each_segment(bvec, req, iter) {
>   			BUG_ON(i >= io_req->desc_cnt);
>   
> -			io_req->io_desc[i].buffer =
> -				page_address(bvec.bv_page) + bvec.bv_offset;
> +			io_req->io_desc[i].buffer = bvec_virt(&bvec);
>   			io_req->io_desc[i].length = bvec.bv_len;
>   			i++;
>   		}
> 
Acked-By: Anton Ivanov <anton.ivanov@cambridgegreys.com>

-- 
Anton R. Ivanov
Cambridgegreys Limited. Registered in England. Company Number 10273661
https://www.cambridgegreys.com/
