Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E912C2FC1A
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Aug 2023 11:01:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350094AbjHQLA0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Aug 2023 07:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350109AbjHQLAV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2023 07:00:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 603272D4A;
        Thu, 17 Aug 2023 04:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F231E608D5;
        Thu, 17 Aug 2023 11:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA50C433C8;
        Thu, 17 Aug 2023 11:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692270019;
        bh=6o6ovJTGhJp9a+Kyp0jno4rIqedxLlLLMba/7wSjIyE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=QJS9Kw7ls4+8g9PTfr6mJ/n0zQbHCCpcx6bNNm1PMEnrajVfQWmrolJv/3zuYBQi+
         wEzVQ0+2wCR/HdOuAqOlBmy6AubGwug0guVW6xaFZesBz07//oBs3izMGd0bVV5lIb
         hT1tup3bhXelDzH4zpmaBhrJ7i8MZiMRzsl2V67eb9H+hjsem2AobvpTR3YtP1x9Lu
         ioo2sNrRbw1zLdKsIqYueyLKgBwQTX4aUENrI5XUJRQ11Vydnek7YdVT8Ryhj3uJuW
         RQ4kgahBUR0dIRw7VSgMDC3TfGWcHgcHiGaYP2wAqRVHn8N3cNINebso41BWWvl+F/
         fB5wkVF+h4H0A==
Message-ID: <6d823671-db2b-2280-0c93-87d03a2f471e@kernel.org>
Date:   Thu, 17 Aug 2023 20:00:17 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v9 01/17] block: Introduce more member variables related
 to zone write locking
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
References: <20230816195447.3703954-1-bvanassche@acm.org>
 <20230816195447.3703954-2-bvanassche@acm.org>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20230816195447.3703954-2-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/17/23 04:53, Bart Van Assche wrote:
> Many but not all storage controllers require serialization of zoned writes.
> Introduce two new request queue limit member variables related to write
> serialization. 'driver_preserves_write_order' allows block drivers to
> indicate that the order of write commands is preserved and hence that
> serialization of writes per zone is not required. 'use_zone_write_lock' is
> set by disk_set_zoned() if and only if the block device has zones and if
> the block driver does not preserve the order of write requests.
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

