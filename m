Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D431DC7EE2E
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jun 2023 15:42:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238103AbjFLPmj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jun 2023 11:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233394AbjFLPmh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jun 2023 11:42:37 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E61DA10C7;
        Mon, 12 Jun 2023 08:42:36 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 91AE722724;
        Mon, 12 Jun 2023 15:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1686584555; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FmuY1UZ8N0C0yeMPPmwYkjJ0ejF0JD75EQZXYcTievU=;
        b=tWQDR1QfvZTusYfel4Cf8TbQBW3Y1xcFJbBNR7Kq2sz0CdSic2IlwAtpjimctmJQzrmQta
        cly3/kSRObOoaYSugYl9IfvkrlE+ugPUSj2AFMBTYHWQ6Gf+LlGe/yO51iE8hOnHivutsg
        UfauE1k6rzJ8w/AJvKnjCzDL8HibA5M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1686584555;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FmuY1UZ8N0C0yeMPPmwYkjJ0ejF0JD75EQZXYcTievU=;
        b=gYtRX+q3bKrvF1MQ4yBc9CM6hAPqm40Bx115Sq9wAS8CVhnNkkL0LSYBYRDE6brcaF3X99
        HnTKxvKCE5RijqCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5B3F5138EC;
        Mon, 12 Jun 2023 15:42:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id rsx4Fes8h2RmQQAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 12 Jun 2023 15:42:35 +0000
Message-ID: <26ad0240-0f41-e5b8-412d-972c2f9ac63f@suse.de>
Date:   Mon, 12 Jun 2023 17:42:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v4 5/6] scsi: don't wait for quiesce in
 scsi_device_block()
Content-Language: en-US
To:     mwilck@suse.com, "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
References: <20230612145638.16999-1-mwilck@suse.com>
 <20230612145638.16999-6-mwilck@suse.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230612145638.16999-6-mwilck@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/12/23 16:56, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> scsi_device_block() is only called from scsi_target_block(), which
> calls it repeatedly for every child device. For targets with many devices,
> waiting for every queue to quiesce may cause a substantial delay
> (we measured more than 100s delay for blocking a FC rport with 2048 LUNs).
> 
> Just call blk_mq_wait_quiesce_done() once from scsi_target_block() after
> stopping all queues.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>   drivers/scsi/scsi_lib.c | 16 +++++++++-------
>   1 file changed, 9 insertions(+), 7 deletions(-)
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

