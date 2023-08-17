Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE86DC27C7A
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Aug 2023 11:03:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350117AbjHQLDH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Aug 2023 07:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350232AbjHQLDD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2023 07:03:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C859335B5;
        Thu, 17 Aug 2023 04:02:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0290641F6;
        Thu, 17 Aug 2023 11:02:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DFC0C433C8;
        Thu, 17 Aug 2023 11:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692270138;
        bh=BQoFD8Awp3Ww55V0WQCSVKjlFLOO5YEgzVQJ759o3vs=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=cA2UmGi7QytOIu1eASPAtu3IyDRrBNDtPMoJN6CKx/O8TbpDBwAJXwBuHpQaAyGQy
         hcFKxTF8MXxBWWhXB4VGw4l6mHfBIEr0b7TC4zhZ0cBm6Q7vIGvSmIaa0FV7+sDkK9
         iVhFhO/ld56EpuP0VAhmqSoLUFFUBARtaXW+4RX5qurezwGLsBNy0IUs/K5HDpWEJ0
         YNFAyZAG3huuCyDznRJtRXNzbvU+qD5lku2hS9mHAjxei9PJqbNjjYifeh1RQbLRhh
         8tB6JOkwdGH5vXrVhIWHCfWSxEGqgR7ZiqI+ElGOv/IQUaPGTjTm7fCPARCLA9EBNO
         1Anr7h2dtSAig==
Message-ID: <ce13331c-3cc6-32bb-b154-70621be52b21@kernel.org>
Date:   Thu, 17 Aug 2023 20:02:16 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v9 03/17] block/mq-deadline: Only use zone locking if
 necessary
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
References: <20230816195447.3703954-1-bvanassche@acm.org>
 <20230816195447.3703954-4-bvanassche@acm.org>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20230816195447.3703954-4-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/17/23 04:53, Bart Van Assche wrote:
> Measurements have shown that limiting the queue depth to one per zone for
> zoned writes has a significant negative performance impact on zoned UFS
> devices. Hence this patch that disables zone locking by the mq-deadline
> scheduler if the storage controller preserves the command order. This
> patch is based on the following assumptions:
> - It happens infrequently that zoned write requests are reordered by the
>   block layer.
> - The I/O priority of all write requests is the same per zone.
> - Either no I/O scheduler is used or an I/O scheduler is used that
>   serializes write requests per zone.
> 
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

