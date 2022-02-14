Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA960C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 09:50:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242108AbiBNJuR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Feb 2022 04:50:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245478AbiBNJts (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Feb 2022 04:49:48 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A95EA190
        for <linux-scsi@vger.kernel.org>; Mon, 14 Feb 2022 01:41:05 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 9B2AF1F38B;
        Mon, 14 Feb 2022 09:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644831655; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6O6PaWjf9dmfO8Ni2qf9BYWS2Vpsvl9388AqKizrErk=;
        b=iP6dCBPmijtKknEBZeb1yeoqejvP7KbgZh5nRaK3FisYv8q3KuCezvhlBkwlPG8+GePjV7
        dAmQQwJ3P8BO00xMJ994XYBij8Z1rgojMz8nBts3I/k+KyZRhB8MkQMoeV8rTp6TVfqDBr
        vcChh4vG60U7Y2BHHLOYUYHQojSzTEY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644831655;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6O6PaWjf9dmfO8Ni2qf9BYWS2Vpsvl9388AqKizrErk=;
        b=IcOfTVpCi4+cMiCmPGXac/CJRNAtDHpfnwnUmCfJCaIvL1kx+pff/JRRzudfJ25962vlmD
        631N6RXqN/pdSRDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7DC8013A3C;
        Mon, 14 Feb 2022 09:40:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id NLARHKcjCmJTKwAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 14 Feb 2022 09:40:55 +0000
Message-ID: <42240db7-d2fc-8aa6-3c96-7c0eca1dc52b@suse.de>
Date:   Mon, 14 Feb 2022 10:40:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v3 01/48] scsi: ips: Remove an unreachable statement
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        John Garry <john.garry@huawei.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220211223247.14369-1-bvanassche@acm.org>
 <20220211223247.14369-2-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220211223247.14369-2-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/11/22 23:32, Bart Van Assche wrote:
> Whether or not CONFIG_BUG is enabled, BUG() never returns. Hence, code past
> a BUG() statement is unreachable. Remove one such unreachable statement.
> 
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Cc: John Garry <john.garry@huawei.com>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/ips.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
> index 498bf04499ce..0db35e97ce8f 100644
> --- a/drivers/scsi/ips.c
> +++ b/drivers/scsi/ips.c
> @@ -655,7 +655,6 @@ ips_release(struct Scsi_Host *sh)
>   		printk(KERN_WARNING
>   		       "(%s) release, invalid Scsi_Host pointer.\n", ips_name);
>   		BUG();
> -		return (FALSE);
>   	}
>   
>   	ha = IPS_HA(sh);
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
