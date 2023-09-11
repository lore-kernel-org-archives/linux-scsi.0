Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF119EE7FF4
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Sep 2023 07:05:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234628AbjIKHFV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 03:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234622AbjIKHFU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 03:05:20 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0953130;
        Mon, 11 Sep 2023 00:05:15 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 9F6D721875;
        Mon, 11 Sep 2023 07:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1694415914; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VfqAlIoYGjDSt2kv5mGsYO4FJ8D56v97YQu1Nk2N5xw=;
        b=yhH1aENt6PrdYfScK1jzIrWW5fQ9+//W6U36ZbCZ9aNkTUplRynEvamVXkImBqiiM+KAI3
        +jYylSoMqeUEGixzUgp/8/9gWoq4oDYwslSLOc0U50MlAOn0Lp6oGt40vW6BySc3SRS/ma
        mxQ2EqUa0FuQd/lvB1/kitkfFz+ENG4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1694415914;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VfqAlIoYGjDSt2kv5mGsYO4FJ8D56v97YQu1Nk2N5xw=;
        b=lq7pPLOHMLiYot74x+hXNOTpj8GeLQCJFn9m6PNQelxtru32NzDAywtFzuX/BXjDT2j3aV
        NZfjuf8S94ybftDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6E45A13780;
        Mon, 11 Sep 2023 07:05:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id dcX9GSq8/mQKVwAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 11 Sep 2023 07:05:14 +0000
Message-ID: <b19a30c4-bac3-4606-8e73-536171a55aff@suse.de>
Date:   Mon, 11 Sep 2023 09:05:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 18/19] ata: libata-eh: Reduce "disable device" message
 verbosity
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
References: <20230911040217.253905-1-dlemoal@kernel.org>
 <20230911040217.253905-19-dlemoal@kernel.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230911040217.253905-19-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/11/23 06:02, Damien Le Moal wrote:
> There is no point in warning about a device being diabled when we expect

disabled

> it to be, that is, on suspend, shutdown or when detaching a device.
> Suppress this message for these cases by introducing the EH static
> function ata_eh_dev_disable() and by using it in ata_eh_unload() and
> ata_eh_detach_dev(). ata_dev_disable() code is modified to call this new
> function after printing the "disable device" message.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/ata/libata-eh.c | 32 +++++++++++++++++++-------------
>   1 file changed, 19 insertions(+), 13 deletions(-)
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

