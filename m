Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35D22C77B74
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Apr 2023 07:31:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbjDKHbm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Apr 2023 03:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbjDKHbU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Apr 2023 03:31:20 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE6B130D3;
        Tue, 11 Apr 2023 00:31:19 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 593CE1FE00;
        Tue, 11 Apr 2023 07:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1681198278; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zrKJwUKKQqPwV2GMYE3vvKipc0Y4/zBPoyFnBRMPE5Y=;
        b=Q7qTB94wj3Gg/3rFS/TyqOMweHV6DVNY8f9a/7PDxK74NEJADGNmvOG3RLGuKJW7mhCP4Y
        A4szjiTISxfspLyeqN9VAYRSn0ky2pDJIssd5vF9K8TOg9FtGJFQK/r81vIlPBqNs+J/qh
        jV7EEWs6zdGRtusRQYNwY160B7FVLvE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1681198278;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zrKJwUKKQqPwV2GMYE3vvKipc0Y4/zBPoyFnBRMPE5Y=;
        b=JyQyzgRWSbw63ZHATm4TNpQfkxooqhNaR5VOVlFibWtHFYugP8dOZ85ZUQhu15it8YKX4r
        vb/3/FkJKatR9/AA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F3B2E13638;
        Tue, 11 Apr 2023 07:31:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 71B0OsUMNWRiZgAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 11 Apr 2023 07:31:17 +0000
Message-ID: <a78916e3-16f1-3928-8245-bb54532bcb58@suse.de>
Date:   Tue, 11 Apr 2023 09:31:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v6 15/18] scsi: target: Allow backends to hook into PR
 handling
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
References: <20230407200551.12660-1-michael.christie@oracle.com>
 <20230407200551.12660-16-michael.christie@oracle.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230407200551.12660-16-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/7/23 22:05, Mike Christie wrote:
> For the cases where you want to export a device to a VM via a single
> I_T nexus and want to passthrough the PR handling to the physical/real
> device you have to use pscsi or tcmu. Both are good for specific uses
> however for the case where you want good performance, and are not using
> SCSI devices directly (using DM/MD RAID or multipath devices) then we are
> out of luck.
> 
> The following patches allow iblock to mimimally hook into the LIO PR code
> and then pass the PR handling to the physical device. Note that like with
> the tcmu an pscsi cases it's only supported when you export the device via
> one I_T nexus.
> 
> This patch adds the initial LIO callouts. The next patch will modify
> iblock.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/target/target_core_pr.c      | 62 +++++++++++++++++++++++++++-
>   include/target/target_core_backend.h |  4 ++
>   2 files changed, 65 insertions(+), 1 deletion(-)
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

