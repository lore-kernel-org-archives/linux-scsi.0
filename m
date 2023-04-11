Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F403C76196
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Apr 2023 07:30:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbjDKHao (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Apr 2023 03:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbjDKHaP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Apr 2023 03:30:15 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B932010D9;
        Tue, 11 Apr 2023 00:30:07 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 7932A1FE07;
        Tue, 11 Apr 2023 07:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1681198206; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sao6iSzYyV4pF7pf2Hp9JojA2SzyYnX9w/dSvM41I9M=;
        b=Hr31JrdpfEHoynPIksW7e/3+RvCa7x4/jnq5kI+8BDP0ZTV/EiePkvRzDRPODAs4ZDMCJA
        lSD7NlO3KdvkSFcRqKKvvokyrNwUT/q+cebaFLfnp9bhBy9yF+8Ct1QKHFi3MhNftf1IBb
        EF55X5l8cGT9jeQ1aw8ZClVQslIlnGU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1681198206;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sao6iSzYyV4pF7pf2Hp9JojA2SzyYnX9w/dSvM41I9M=;
        b=J4pk274J0eqX22FppfnsjPugB3NPoEnj3goKQ4QJFWmJtbzaIltKS080HraNH73Joe/k9A
        NHVj2b9bvHruNcAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1E49813638;
        Tue, 11 Apr 2023 07:30:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id jYpZBn4MNWTcZQAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 11 Apr 2023 07:30:06 +0000
Message-ID: <25a93d03-556f-e71c-f8d7-a4db686f43af@suse.de>
Date:   Tue, 11 Apr 2023 09:30:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v6 13/18] nvme: Add pr_ops read_reservation support
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Cc:     Chaitanya Kulkarni <kch@nvidia.com>
References: <20230407200551.12660-1-michael.christie@oracle.com>
 <20230407200551.12660-14-michael.christie@oracle.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230407200551.12660-14-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/7/23 22:05, Mike Christie wrote:
> This patch adds support for the pr_ops read_reservation callout by
> calling the NVMe Reservation Report helper. It then parses that info to
> detect if there is a reservation and if there is then convert the
> returned info to a pr_ops pr_held_reservation struct.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
> ---
>   drivers/nvme/host/pr.c | 83 ++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 83 insertions(+)
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

