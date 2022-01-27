Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D225C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Jan 2022 14:29:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242364AbiA0O3d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Jan 2022 09:29:33 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:35208 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242360AbiA0O3d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jan 2022 09:29:33 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 25A6B218DF;
        Thu, 27 Jan 2022 14:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1643293772; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R/bN2GCU3ZyyCgiuSENo5vh/blIbOiycuvB4oGUsTU4=;
        b=gMD+AzbZ7nn3Rct1Ux68LsYASEh0dVXapVIbmPENgwP6WDJA1bPkunBkG4/CpWwW9OJVgU
        55MVgPa8LelpupN6ckFzkQVEh5xxfWmwtWk4VJ9XJJpZ9K6m4Fa0qpWY40fB0mEbrRcj/R
        xLEODp9NKgdJNyRgmCpYAM/aeQYjZjM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1643293772;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R/bN2GCU3ZyyCgiuSENo5vh/blIbOiycuvB4oGUsTU4=;
        b=nFjdykKL7KC0dQgcCkCeWpoxSYqF3+9Qs/Miwo8m5Qoa4saGstJnJel89F7Tc2r2JZU6A/
        i2nJAsYXXlIKGdDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1A83913BF9;
        Thu, 27 Jan 2022 14:29:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id PhAoBkys8mESQgAAMHmgww
        (envelope-from <hare@suse.de>); Thu, 27 Jan 2022 14:29:32 +0000
Message-ID: <097238da-9d58-6153-e926-b3dcb1f21958@suse.de>
Date:   Thu, 27 Jan 2022 15:29:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] scsi: make "access_state" sysfs attribute always visible
Content-Language: en-US
To:     mwilck@suse.com, "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     linux-scsi@vger.kernel.org
References: <20220127141351.30706-1-mwilck@suse.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220127141351.30706-1-mwilck@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/27/22 15:13, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> If a SCSI device handler module is loaded after some SCSI devices
> have already been probed (e.g. via request_module() by dm-multipath),
> the "access_state" and "preferred_path" sysfs attributes remain invisible for
> these devices, although the handler is attached and live. The reason is
> that the visibility is only checked when the sysfs attribute group is
> first created. This results in an inconsistent user experience depending
> on the load order of SCSI low-level drivers vs. device handler modules.
> 
> This patch changes user space API: attempting to read the "access_state"
> or "preferred_path" attributes will now result in -EINVAL rather than
> -ENODEV for devices that have no device handler, and tests for the existence
> of these attributes will have a different result.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/scsi_sysfs.c | 8 --------
>   1 file changed, 8 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index f1e0c131b77c..226a50944c00 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -1228,14 +1228,6 @@ static umode_t scsi_sdev_attr_is_visible(struct kobject *kobj,
>   	    !sdev->host->hostt->change_queue_depth)
>   		return 0;
>   
> -#ifdef CONFIG_SCSI_DH
> -	if (attr == &dev_attr_access_state.attr &&
> -	    !sdev->handler)
> -		return 0;
> -	if (attr == &dev_attr_preferred_path.attr &&
> -	    !sdev->handler)
> -		return 0;
> -#endif
>   	return attr->mode;
>   }
>   
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
