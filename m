Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D508C25B6B
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Oct 2023 23:31:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231402AbjJWXbB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Oct 2023 19:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjJWXa6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2023 19:30:58 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA75FD78;
        Mon, 23 Oct 2023 16:30:56 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5F13C433C8;
        Mon, 23 Oct 2023 23:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698103856;
        bh=fsoWNVP/auPcxnZ1xaN3g9sSZXX/IFF40k1GgQDPFJE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Y/gZN5P4Z4zWog7hzhZSNAi1WnI+MR1XtdkkNrzmpizSbIRIR5Lki5cUB2tsnwkdI
         VWI3qcYYhSLUtzI1ubNSp0Q39KGFu68xGJt6O9J/DI7OG/oCAV6M+PlQxmYpQdQQOO
         +tErsnlPtenULWMjsecXF5Jx18f16VooYSohJxvrDMMcyPPDN+0JJr7D49+n15pA+R
         /8Etji/efFQ3wXFUSyKMKI3koDJWhW3Xu2DrZXau+1HpnMjqrZKfIjH5iml6XBziXI
         IzRp6TXyxg67jAxduZBPyj+bcYRZz5UhywBlypwux3+G9qVQ9N6hgeB+AqMMkXJKEe
         YKwBJjZYyU+fg==
Message-ID: <b3a3d7da-a268-446b-9d34-d055fc4d61d4@kernel.org>
Date:   Tue, 24 Oct 2023 08:30:55 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 03/19] block: Preserve the order of requeued zoned
 writes
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>
References: <20231023215638.3405959-1-bvanassche@acm.org>
 <20231023215638.3405959-4-bvanassche@acm.org>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20231023215638.3405959-4-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/24/23 06:53, Bart Van Assche wrote:
> blk_mq_requeue_work() inserts requeued requests in front of other
> requests. This is fine for all request types except for sequential zoned
> writes. Hence this patch.
> 
> Note: moving this functionality into the mq-deadline I/O scheduler is
> not an option because we want to be able to use zoned storage without
> I/O scheduler.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

