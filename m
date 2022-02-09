Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 922F7C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 07:33:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232363AbiBIHdA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 02:33:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233454AbiBIHc6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 02:32:58 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7916AC05CB85
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 23:33:02 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 399CC210DF;
        Wed,  9 Feb 2022 07:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644391981; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Dt+0IFtbXMKAcxIuJStVHv3KmN3aSZfDcNOL2tRwRpM=;
        b=qc+MEAJj89CD6f7IVRVrTnTVVWQBxQhrjXch6U1oeTqaW+tmSK1g/ZbircVxQUpsCK3Fkz
        l/nH5Gamh5dETG31vLNBU8wQlI2qG5gKSqdPi9fnVrEcuhXWCijysvTgOht0AtOh0BEn8v
        vg/QkDdbe3TtWfzUNFcutUlTwASq38c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644391981;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Dt+0IFtbXMKAcxIuJStVHv3KmN3aSZfDcNOL2tRwRpM=;
        b=aNurP57MehXOsGdgGm1PNtqKcaPpPR2oaX1xFYdRLTUz195DOgXqPBU0KaQuHgj84VulWb
        cbIEjT8pBwi5jKCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1535A13216;
        Wed,  9 Feb 2022 07:33:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id DH3UAy1uA2IiCgAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 09 Feb 2022 07:33:01 +0000
Message-ID: <9f44333c-8552-b950-c80c-b61a7db7062c@suse.de>
Date:   Wed, 9 Feb 2022 08:32:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 08/44] 53c700: Stop clearing SCSI pointer fields
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-9-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220208172514.3481-9-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/8/22 18:24, Bart Van Assche wrote:
> None of the 53c700 drivers uses the SCSI pointer. Hence remove the code
> from 53c700.c that clears two SCSI pointer fields. The 53c700 drivers are:
> 
> $ git grep -nHE 'include.*53c700'
> drivers/scsi/53c700.c:132:#include "53c700.h"
> drivers/scsi/53c700.c:153:#include "53c700_d.h"
> drivers/scsi/a4000t.c:22:#include "53c700.h"
> drivers/scsi/bvme6000_scsi.c:23:#include "53c700.h"
> drivers/scsi/lasi700.c:43:#include "53c700.h"
> drivers/scsi/mvme16x_scsi.c:23:#include "53c700.h"
> drivers/scsi/sim710.c:29:#include "53c700.h"
> drivers/scsi/sni_53c710.c:38:#include "53c700.h"
> drivers/scsi/zorro7xx.c:25:#include "53c700.h"
> 
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/53c700.c | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
> index ad4972c0fc53..e1e4f9d10887 100644
> --- a/drivers/scsi/53c700.c
> +++ b/drivers/scsi/53c700.c
> @@ -1791,8 +1791,6 @@ static int NCR_700_queuecommand_lck(struct scsi_cmnd *SCp)
>   	slot->cmnd = SCp;
>   
>   	SCp->host_scribble = (unsigned char *)slot;
> -	SCp->SCp.ptr = NULL;
> -	SCp->SCp.buffer = NULL;
>   
>   #ifdef NCR_700_DEBUG
>   	printk("53c700: scsi%d, command ", SCp->device->host->host_no);

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
