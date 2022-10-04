Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2057C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Oct 2022 05:49:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiJDFtH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Oct 2022 01:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiJDFtG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Oct 2022 01:49:06 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE9B5326D9;
        Mon,  3 Oct 2022 22:48:56 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 9D46021921;
        Tue,  4 Oct 2022 05:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1664862535; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jtUfys+stQlbxkRtiAL8mGJXFEhPSi06TVr7zfIiSr8=;
        b=nwVI+GGn/zG8eHjxwEJzPEIJM181YBhtia9stG1uvCwLddUgD5ncinL75CEHbh1E+uTwzi
        3MzqGkUMzFBSPw+AUk1uYicZMADDf0dcYK33DJ8JmE65kFIpb6zPXVewBcreaW0fSRiDrn
        CHb4Z7tP0kXqGyaMj5exa2hJoAQk/4Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1664862535;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jtUfys+stQlbxkRtiAL8mGJXFEhPSi06TVr7zfIiSr8=;
        b=nlnZAAPz3eInu65ARjvpRmK40UCPMbjwdBYTNrKSWL9iQi8joaammqS3rHGccr6NwBMI8y
        Z73ohXLZ/X2wG2Bw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 602BD13A8F;
        Tue,  4 Oct 2022 05:48:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id rdBpFkfJO2O7DAAAMHmgww
        (envelope-from <hare@suse.de>); Tue, 04 Oct 2022 05:48:55 +0000
Message-ID: <36494144-2e85-bf3d-642e-6cb263e54f70@suse.de>
Date:   Tue, 4 Oct 2022 07:48:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v2 1/6] scsi: libsas: Add sas_task_find_rq()
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, jinpu.wang@cloud.ionos.com,
        damien.lemoal@wdc.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, ipylypiv@google.com, changyuanl@google.com,
        hch@lst.de, yanaijie@huawei.com
References: <1664528184-162714-1-git-send-email-john.garry@huawei.com>
 <1664528184-162714-2-git-send-email-john.garry@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <1664528184-162714-2-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/30/22 10:56, John Garry wrote:
> blk-mq already provides a unique tag per request. Some libsas LLDDs - like
> hisi_sas - already use this tag as the unique per-IO HW tag.
> 
> Add a common function to provide the request associated with a sas_task
> for all libsas LLDDs.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>   include/scsi/libsas.h | 18 ++++++++++++++++++
>   1 file changed, 18 insertions(+)
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

