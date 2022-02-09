Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4476C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 07:35:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237049AbiBIHfI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 02:35:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236104AbiBIHfH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 02:35:07 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EBAAC0612C3
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 23:35:11 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 3F9B9210DF;
        Wed,  9 Feb 2022 07:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644392110; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g6nOsH78SiUG9jaRhCHDR2GrpIVVBY/3SQq+m5uPNA4=;
        b=Cegg5tLkYWV4/DsezZS0JmgCG7k1CiUsm6jZRC2NNxOvuTxaazsdWVZDrAdTIEWIAwpLk+
        +9pAma8KU/dQvWwXZX3TAH0cnsfsLbT1xyrCThXg4CHHrWZ7ZE1WQrH2/Z3mQvT5zxMlLy
        UNjPKxhtpWw+I0IfwixVm/wo7x00e5Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644392110;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g6nOsH78SiUG9jaRhCHDR2GrpIVVBY/3SQq+m5uPNA4=;
        b=nwrf4aev/m+XRItAwH+7lxzti6Rdycn/ytsk8GPAQynC4dWW3n5BCsRNW8Y5mYMQ0C+3C7
        ZeJ1qJSbMbKL0GBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id ECBAD13216;
        Wed,  9 Feb 2022 07:35:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id bk55L61uA2IQCwAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 09 Feb 2022 07:35:09 +0000
Message-ID: <090717c5-207d-62fb-1c76-c558c1f995da@suse.de>
Date:   Wed, 9 Feb 2022 08:35:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 11/44] aha1542: Remove a set-but-not-used array
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-12-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220208172514.3481-12-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/8/22 18:24, Bart Van Assche wrote:
> This patch fixes the following W=1 warning:
> 
> drivers/scsi/aha1542.c:209:12: warning: variable ‘inquiry_result’ set but not used [-Wunused-but-set-variable]
>    209 |         u8 inquiry_result[4];
> 
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/aha1542.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
> index f0e8ae9f5e40..cf7bba2ca68d 100644
> --- a/drivers/scsi/aha1542.c
> +++ b/drivers/scsi/aha1542.c
> @@ -206,7 +206,6 @@ static int makecode(unsigned hosterr, unsigned scsierr)
>   
>   static int aha1542_test_port(struct Scsi_Host *sh)
>   {
> -	u8 inquiry_result[4];
>   	int i;
>   
>   	/* Quick and dirty test for presence of the card. */
> @@ -240,7 +239,7 @@ static int aha1542_test_port(struct Scsi_Host *sh)
>   	for (i = 0; i < 4; i++) {
>   		if (!wait_mask(STATUS(sh->io_port), DF, DF, 0, 0))
>   			return 0;
> -		inquiry_result[i] = inb(DATA(sh->io_port));
> +		(void)inb(DATA(sh->io_port));
>   	}
>   
>   	/* Reading port should reset DF */

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
