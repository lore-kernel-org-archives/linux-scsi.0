Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0601C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 11:56:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352116AbiBNL4T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Feb 2022 06:56:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352095AbiBNL4N (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Feb 2022 06:56:13 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 222EDC3A
        for <linux-scsi@vger.kernel.org>; Mon, 14 Feb 2022 03:56:02 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id CCB0D210F1;
        Mon, 14 Feb 2022 11:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644839760; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zmi+5ptRw6sGgyRuSw1Ivz6fsUhPb0nBxPJa4jzbXV0=;
        b=zWj5CRYzzH6o6tuKes+8nNDfzE0eKgl17I04crPssaZUuv1zSSXRXa8RMnnQnroFbP2+FS
        vU7zg0Hqk0BuHDVcqEgTj/tDTSKFj2smV7eTT3mp98zTy8X01ypLmLeufYXv2Bdl08fCt6
        sRxeupYqdTiGe+PCQyGftqe2pz9QBEI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644839760;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zmi+5ptRw6sGgyRuSw1Ivz6fsUhPb0nBxPJa4jzbXV0=;
        b=euIwWsV3tT5WDZIK06dPUdZtlGcWjGhD53sF09xQ2CJPcKtoZFgsRK6HdFaTDl9mnMDYIu
        Fcc06A7GgvW68ZBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B2FF913AF2;
        Mon, 14 Feb 2022 11:56:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id +aJjK1BDCmKpdQAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 14 Feb 2022 11:56:00 +0000
Message-ID: <2b079541-4333-535f-3f20-abb3feca85da@suse.de>
Date:   Mon, 14 Feb 2022 12:55:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v3 28/48] scsi: libfc: Stop using the SCSI pointer
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Karan Tilak Kumar <kartilak@cisco.com>
References: <20220211223247.14369-1-bvanassche@acm.org>
 <20220211223247.14369-29-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220211223247.14369-29-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/11/22 23:32, Bart Van Assche wrote:
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
> Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/bnx2fc/bnx2fc.h      | 10 ++++++++--
>   drivers/scsi/bnx2fc/bnx2fc_fcoe.c |  1 +
>   drivers/scsi/bnx2fc/bnx2fc_io.c   | 24 ++++++++++++------------
>   drivers/scsi/fcoe/fcoe.c          |  1 +
>   drivers/scsi/fnic/fnic.h          |  1 +
>   drivers/scsi/libfc/fc_fcp.c       | 26 +++++++++++---------------
>   drivers/scsi/qedf/qedf.h          | 11 ++++++++++-
>   drivers/scsi/qedf/qedf_io.c       | 24 ++++++++++++------------
>   drivers/scsi/qedf/qedf_main.c     |  3 ++-
>   include/scsi/libfc.h              | 11 +++++++++++
>   10 files changed, 69 insertions(+), 43 deletions(-)
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
I had a closer look at the usage of SCp.ptr in the various FCoE drivers, 
and it turns out that all have their own private use of SCp.ptr.
The only 'generic' use of SCp.ptr (where it points to 'struct 
libfc_cmd_priv') is in fcoe/fcoe.c.
For the others (bnx2fc, qedf, and fnic) they point to their own, 
private, data structure, and there's no overlap with libfc itself.
So no need to have a combined structure, and each driver should use
their own data structure only.
(IE bnx2fc_priv should just have the 'bnx2fc_cmd' pointer).

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
