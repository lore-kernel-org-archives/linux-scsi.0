Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32F3CC00A8F
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Oct 2023 00:11:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbjJXALt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Oct 2023 20:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231697AbjJXALq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2023 20:11:46 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7179E10EA;
        Mon, 23 Oct 2023 17:11:37 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3508C433C9;
        Tue, 24 Oct 2023 00:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698106296;
        bh=zvwxOiofUnYEQUVM/sjBEz7BUQLR9RWz7keuXQ8Z69Y=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=IXgM+my2ElaKqHt+Hshf1daUpdqxEY2l8X799/DUGER425662bLaMjuQKSpD+rAFR
         hxTDSUm6Gaucg0qPgLS6GzIaVQp6m38cQf56oXJoiF/bx6/JJycW6gjQTcYt7fYdHs
         zk4t6GsjYL2EFYcOr0KuXu4SWU6nsBqosUD+T8K3fIVyUOH7r58dsFunS+L1YykEH6
         iOPfETiWb52lpsp8P/0RdVxdsEJGgiaVQtufFPc+rep/JMkrwsgbbiKVlcSM3bPEGZ
         T7M3XJ/di7qzVBQC1mIBss57gnBwh/3DRRao/BqlncP+hMBVD1QY04DohxHfO8xJXU
         Ovr+AUxQiFABQ==
Message-ID: <a649fef4-804d-412b-9bcf-940781f9d90a@kernel.org>
Date:   Tue, 24 Oct 2023 09:11:34 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 08/19] scsi: sd: Sort commands by LBA before
 resubmitting
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20231023215638.3405959-1-bvanassche@acm.org>
 <20231023215638.3405959-9-bvanassche@acm.org>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20231023215638.3405959-9-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/24/23 06:53, Bart Van Assche wrote:
> Sort SCSI commands by LBA before the SCSI error handler resubmits
> these commands. This is necessary when resubmitting zoned writes
> (REQ_OP_WRITE) if multiple writes have been queued for a single zone.
> 
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Looks OK.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

