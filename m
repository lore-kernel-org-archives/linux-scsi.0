Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 152FDC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 08:10:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239975AbiBIIKX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 03:10:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiBIIKR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 03:10:17 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0439FC0613CA
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 00:10:21 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id A6E4F210F0;
        Wed,  9 Feb 2022 08:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644394219; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LCEvbbGr5LOMug2XBEVnU2rzVKxbRUTkyRX5tHNVOao=;
        b=NnXr3MldJcC4iWfiNZ9lXQBvf8vg+5ky1fM3LkaZrEvqQniFyeNM40VAfKZAv8aWnkH3AD
        7aVQOj0f2EExNCb8ufySfUVb5JHjtdta+nKwE31ZSx1HwZrmkfgEch01EeLParwWMY46y4
        M7fT2TcLZ+8OEewgQv85GM/T0IGZEKU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644394219;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LCEvbbGr5LOMug2XBEVnU2rzVKxbRUTkyRX5tHNVOao=;
        b=02EbcePe1B4d+0rrF50aUmk7p/rLLlWwTuHBYLWg9RQN6B1HvOR2wYjHh40UEIwrCPbAhd
        eYbcTmINGIa8wdCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6FF7E139D1;
        Wed,  9 Feb 2022 08:10:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id M9GHGut2A2LbGwAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 09 Feb 2022 08:10:19 +0000
Message-ID: <dae3f6d8-efc4-b295-351c-e9a0a8e46138@suse.de>
Date:   Wed, 9 Feb 2022 09:10:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 24/44] libfc: Stop using the SCSI pointer
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-25-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220208172514.3481-25-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/8/22 18:24, Bart Van Assche wrote:
> Move the fc_fcp_pkt pointer, the residual length and the SCSI status into
> the new data structure libfc_cmd_priv. This patch prepares for removal of
> the SCSI pointer from struct scsi_cmnd.
> 
> The libfc users have been identified as follows:
> 
> $ git grep -lw 'libfc_host_alloc' | grep -v /libfc
> drivers/scsi/bnx2fc/bnx2fc_fcoe.c
> drivers/scsi/fcoe/fcoe.c
> drivers/scsi/fnic/fnic_main.c
> drivers/scsi/qedf/qedf_main.c
> 
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Saurav Kashyap <skashyap@marvell.com>
> Cc: Javed Hasan <jhasan@marvell.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/bnx2fc/bnx2fc.h      | 10 ++++++++--
>   drivers/scsi/bnx2fc/bnx2fc_fcoe.c |  1 +
>   drivers/scsi/bnx2fc/bnx2fc_io.c   | 20 ++++++++++----------
>   drivers/scsi/fcoe/fcoe.c          |  1 +
>   drivers/scsi/fnic/fnic.h          |  1 +
>   drivers/scsi/libfc/fc_fcp.c       | 26 +++++++++++---------------
>   drivers/scsi/qedf/qedf.h          | 11 ++++++++++-
>   drivers/scsi/qedf/qedf_io.c       | 16 ++++++++--------
>   drivers/scsi/qedf/qedf_main.c     |  3 ++-
>   include/scsi/libfc.h              | 11 +++++++++++
>   10 files changed, 63 insertions(+), 37 deletions(-)
> 
> diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
> index b4cea8b06ea1..08deed26c51e 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc.h
> +++ b/drivers/scsi/bnx2fc/bnx2fc.h
> @@ -137,8 +137,6 @@
>   #define BNX2FC_FW_TIMEOUT		(3 * HZ)
>   #define PORT_MAX			2
>   
> -#define CMD_SCSI_STATUS(Cmnd)		((Cmnd)->SCp.Status)
> -
>   /* FC FCP Status */
>   #define	FC_GOOD				0
>   
> @@ -493,7 +491,15 @@ struct bnx2fc_unsol_els {
>   	struct work_struct unsol_els_work;
>   };
>   
> +struct bnx2fc_priv {
> +	struct libfc_cmd_priv libfc_data; /* must be the first member */
> +	struct bnx2fc_cmd *io_req;
> +};
>   
I am not sure this is correct.

Both, libfc and the fcoe drivers do use SCp.ptr, but from what I can see 
each in different ways.
So I'm not sure that we need to stack the private data; we never did 
that previously.
Some more careful audit is required to separate out the usage here.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
