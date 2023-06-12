Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A27BDC88CB2
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jun 2023 15:42:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239591AbjFLPmN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jun 2023 11:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237377AbjFLPmJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jun 2023 11:42:09 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4336C10FF;
        Mon, 12 Jun 2023 08:42:05 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 963AB2006B;
        Mon, 12 Jun 2023 15:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1686584523; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wOSH8BCHrUPjsulF5jcPfLP76wATTCuHnxRP96DrRWE=;
        b=asVxbyGaXYuaPPr7Qj8BOrxzNAu7CIEARL504d6JyBpoZFK+UGSqv5p6bz0SgERAJIwg0K
        nAwFB/dkY6DbNFSdGa++ENn4sW8PU7Sa2OdPwsoYHKMpljlzwLJ+g9sjbCiSTZj+SHJg/m
        w2dFvrkZ2WzQA8Y5kNyDzSyGRDlMyWU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1686584523;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wOSH8BCHrUPjsulF5jcPfLP76wATTCuHnxRP96DrRWE=;
        b=W81iqUzMN8jLgI4tgQEx7gUnFDVpLlErn2k3bpotpibAEsTJ7nRxAH31iK22aWvywO1TKt
        LRgSxfmsLfkALTBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 67380138EC;
        Mon, 12 Jun 2023 15:42:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id R2w+GMs8h2QcQQAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 12 Jun 2023 15:42:03 +0000
Message-ID: <79df8907-8834-05e5-0878-5c8072b1db19@suse.de>
Date:   Mon, 12 Jun 2023 17:42:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v4 4/6] scsi: don't wait for quiesce in scsi_stop_queue()
Content-Language: en-US
To:     mwilck@suse.com, "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
References: <20230612145638.16999-1-mwilck@suse.com>
 <20230612145638.16999-5-mwilck@suse.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230612145638.16999-5-mwilck@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/12/23 16:56, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> scsi_stop_queue() has just two callers, one with and one without
> "nowait". As blk_mq_quiesce_queue() comes down to
> blk_mq_quiesce_queue_nowait() followed by blk_mq_wait_quiesce_done(),
> we might as well open-code this in scsi_device_block().
> 
> Also, add a comment explaining why blk_mq_quiesce_queue_nowait() must
> be called with the state_mutex held, see
> https://lore.kernel.org/linux-scsi/3b8b13bf-a458-827a-b916-07d7eee8ae00@acm.org/.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>   drivers/scsi/scsi_lib.c | 32 ++++++++++++++++----------------
>   1 file changed, 16 insertions(+), 16 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

