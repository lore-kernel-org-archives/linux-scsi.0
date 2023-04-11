Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B6DBC76196
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Apr 2023 07:13:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbjDKHNY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Apr 2023 03:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbjDKHNX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Apr 2023 03:13:23 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D76DDD1;
        Tue, 11 Apr 2023 00:13:22 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 95E7421A4C;
        Tue, 11 Apr 2023 07:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1681197201; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jPLIx1z2EU0oEU1Nj43y5nAv+u6B0Ix6LWD0GUUED80=;
        b=m6MPLpb+tLS7w1BuYwIE0wagxfRujBq7gTSJQ4YRj1EFiE++futJeJ8/ItBRiabQL4tYae
        5lp5q+aD90IWWvicS4s8jFtuBuc/lUFdSZpSSgHnEGPw4xrY94HfpnBBKpf6QCSjLN9uk9
        LMtg9zdWaxZuh7+YH5xBKXuwR3ay2LI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1681197201;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jPLIx1z2EU0oEU1Nj43y5nAv+u6B0Ix6LWD0GUUED80=;
        b=OYlhBE5Ok5wOXTxYnCoAVHzR/k7zbapbkmCOzFrzszoOa4ZG8dGR6/cRUe18wp7qh0+A23
        /MOGLw0trNdTYiCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3B50713519;
        Tue, 11 Apr 2023 07:13:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id vf3uDJEINWTpXAAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 11 Apr 2023 07:13:21 +0000
Message-ID: <39789d6a-389f-b2db-8274-1c692baa1117@suse.de>
Date:   Tue, 11 Apr 2023 09:13:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v6 05/18] scsi: Add support for block PR read
 keys/reservation
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Cc:     Chaitanya Kulkarni <kch@nvidia.com>
References: <20230407200551.12660-1-michael.christie@oracle.com>
 <20230407200551.12660-6-michael.christie@oracle.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230407200551.12660-6-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/7/23 22:05, Mike Christie wrote:
> This adds support in sd.c for the block PR read keys and read reservation
> callouts, so upper layers like LIO can get the PR info that's been setup
> using the existing pr callouts and return it to initiators.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/scsi_common.c | 21 +++++++++
>   drivers/scsi/sd.c          | 91 ++++++++++++++++++++++++++++++++++++++
>   include/scsi/scsi_common.h |  1 +
>   include/scsi/scsi_proto.h  |  5 +++
>   4 files changed, 118 insertions(+)
> 
Unfortunately this ties our PR abstraction to the SCSI PR model.
Let's hope that other protocols like NVMe will map onto that, too.
But in the meantime:

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

