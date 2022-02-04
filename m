Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23B20C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Feb 2022 07:26:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351611AbiBDH0H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Feb 2022 02:26:07 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:36914 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351411AbiBDH0G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Feb 2022 02:26:06 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 0B38D1F382;
        Fri,  4 Feb 2022 07:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1643959565; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pxHVxGwSHF3eTu4WZjnj6WdF01ak/EYjf5cBfYz/fgM=;
        b=iSoZ3VeiUfTrHgF/STlabSNtSWN6lk+8gGU03p4agTKvpwG3QRrP+o/2kMpvWIyCoQbapt
        2nSq4axuABjNUPMfym1KjpDtH8xXTD8Jq89R6uDLrYT0QGFVKds62plfvMPoxo6+u7fgwz
        qAT9u1yNenT/WZ9p7SVlq80bJs+wAd4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1643959565;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pxHVxGwSHF3eTu4WZjnj6WdF01ak/EYjf5cBfYz/fgM=;
        b=RoL2Z6/g5CnW/9xbUzbgQyOnp1Y0HVw8tLis7i40Rj93GYlFKEkZnMx39h5GAVJnYQKI5b
        nCXzLEmp/030X8CA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D7AA81331A;
        Fri,  4 Feb 2022 07:26:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Bo2AMwzV/GESRgAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 04 Feb 2022 07:26:04 +0000
Message-ID: <1b7799b3-2a4b-b536-866f-65633bbf6a1f@suse.de>
Date:   Fri, 4 Feb 2022 08:26:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 2/3] block: return -ENODEV for BLK_STS_OFFLINE
Content-Language: en-US
To:     Song Liu <song@kernel.org>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     kernel-team@fb.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        axboe@kernel.dk
References: <20220203192827.1370270-1-song@kernel.org>
 <20220203192827.1370270-3-song@kernel.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220203192827.1370270-3-song@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/3/22 20:28, Song Liu wrote:
> Change the user visible return value for BLK_STS_OFFLINE to -ENODEV, which
> is more descriptive than existing -EIO.
> 
> Signed-off-by: Song Liu <song@kernel.org>
> ---
>   block/blk-core.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
