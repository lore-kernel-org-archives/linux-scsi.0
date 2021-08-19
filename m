Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01DE0C4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 10:39:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD38D61029
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 10:39:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238267AbhHSKjt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 06:39:49 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:45698 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237791AbhHSKjo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 06:39:44 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 72A801FD85;
        Thu, 19 Aug 2021 10:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629369547; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5ofGiVaNnttYux8b0FkyZ0X4YRwjuvt4dHhHBdMIcY8=;
        b=vA6m8MkdwiE4qFJxQCUaBLrwOF+FcqjWHQzuBPMAur1zrnm34Gg4e3rmVUmPlY9EZY+Z9N
        D8w2SKoKcmNmyOkjBhVQXV65iL1xyoO7zNdKyX0VZCOkwgdJsGT6LpIQekTDiaOHjrnGWs
        p/36deJfrYQXsqQcrBaJUpSxEMlP94s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629369547;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5ofGiVaNnttYux8b0FkyZ0X4YRwjuvt4dHhHBdMIcY8=;
        b=uzGXDGm8vGHE/GhSxa7aJ2JH3xv1QkYF/WA4hpsPFu5BidRKzpnlZsPjGQY5RSle2Zkvw9
        raE0UATznG3BL9Dg==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 3D0F8139BA;
        Thu, 19 Aug 2021 10:39:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id izLgDcs0HmHOQgAAGKfGzw
        (envelope-from <hare@suse.de>); Thu, 19 Aug 2021 10:39:07 +0000
Subject: Re: [PATCH v2 2/2] scsi: qla1280: Fix DEBUG_QLA1280 compilation
 issues
To:     John Garry <john.garry@huawei.com>, mdr@sgi.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        bvanassche@acm.org
References: <1629365549-190391-1-git-send-email-john.garry@huawei.com>
 <1629365549-190391-3-git-send-email-john.garry@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <a79cb21c-0c7a-b3d1-3728-fb5454908dfc@suse.de>
Date:   Thu, 19 Aug 2021 12:39:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <1629365549-190391-3-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/19/21 11:32 AM, John Garry wrote:
> The driver does not compile under DEBUG_QLA1280 flag:
> - Debug statements expect an integer for printing a SCSI lun value, but
>    its size is 64b. So change SCSI_LUN_32() to cast to an int, as would be
>    expected from a "_32" function.
> - lower_32_bits() expects %x, as opposed to %lx, so fix that.
> 
> Also delete ql1280_dump_device(), which looks to have never been
> referenced.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>   drivers/scsi/qla1280.c | 27 ++-------------------------
>   1 file changed, 2 insertions(+), 25 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
