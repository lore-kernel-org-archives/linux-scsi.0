Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6DBBC43217
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 10:27:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347029AbiBNK1u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Feb 2022 05:27:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346962AbiBNK1h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Feb 2022 05:27:37 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C2B95A16
        for <linux-scsi@vger.kernel.org>; Mon, 14 Feb 2022 01:58:15 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 6D178210EA;
        Mon, 14 Feb 2022 09:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1644832676; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=arII4N5KEf+KezYMWKQuSC7G+1zpcNu8jXkXxW/Ue1U=;
        b=BXnyLoOXVqI0ZenYJUQp+dXX6mD9gF89wT0RoKGL+UJZxWZJLhM/nMrzov3uUWPPBnZB9u
        wULUSBD7egNIci9DjFihpdkzVlxnKeuv6AZT+5buNA5QULfHp9eXfMwN5nZcpPDjcX+bSu
        PC2L9Te0tEypuf7jIvNySV771YA3iJM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1644832676;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=arII4N5KEf+KezYMWKQuSC7G+1zpcNu8jXkXxW/Ue1U=;
        b=c5rg41JPUtiF9CRjKGuo+UDdl7vGJ4dKClTLIeuCND3jx5RMwIHAkXPYShHgilg4l4HQ2S
        uv7DexB/NT2m1BCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2CAF513A3C;
        Mon, 14 Feb 2022 09:57:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id muj7CaQnCmJ9NQAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 14 Feb 2022 09:57:56 +0000
Message-ID: <260a2a5c-f325-0b7e-b911-6d47b8b0fcb9@suse.de>
Date:   Mon, 14 Feb 2022 10:57:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v3 26/48] scsi: iscsi: Stop using the SCSI pointer
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Lee Duncan <lduncan@suse.com>,
        Chris Leech <cleech@redhat.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        Karen Xie <kxie@chelsio.com>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        GR-QLogic-Storage-Upstream@marvell.com
References: <20220211223247.14369-1-bvanassche@acm.org>
 <20220211223247.14369-27-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220211223247.14369-27-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/11/22 23:32, Bart Van Assche wrote:
> Instead of storing the iSCSI task pointer and the session age in the SCSI
> pointer, use command-private variables. This patch prepares for removal of
> the SCSI pointer from struct scsi_cmnd.
> 
> The list of iSCSI drivers has been obtained as follows:
> $ git grep -lw iscsi_host_alloc
> drivers/infiniband/ulp/iser/iscsi_iser.c
> drivers/scsi/be2iscsi/be_main.c
> drivers/scsi/bnx2i/bnx2i_iscsi.c
> drivers/scsi/cxgbi/libcxgbi.c
> drivers/scsi/iscsi_tcp.c
> drivers/scsi/libiscsi.c
> drivers/scsi/qedi/qedi_main.c
> drivers/scsi/qla4xxx/ql4_os.c
> include/scsi/libiscsi.h
> 
> Note: it is not clear to me how the qla4xxx driver can work without this
> patch since it uses the scsi_cmnd::SCp.ptr member for two different
> purposes:
> - The qla4xxx driver uses this member to store a struct srb pointer.
> - libiscsi uses this member to store a struct iscsi_task pointer.
> 
> Cc: Lee Duncan <lduncan@suse.com>
> Cc: Chris Leech <cleech@redhat.com>
> Cc: Sagi Grimberg <sagi@grimberg.me>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Manish Rangankar <mrangankar@marvell.com>
> Cc: Karen Xie <kxie@chelsio.com>
> Cc: Ketan Mukadam <ketan.mukadam@broadcom.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> 
> ---
>   drivers/infiniband/ulp/iser/iscsi_iser.c |  1 +
>   drivers/scsi/be2iscsi/be_main.c          |  3 ++-
>   drivers/scsi/bnx2i/bnx2i_iscsi.c         |  1 +
>   drivers/scsi/cxgbi/cxgb3i/cxgb3i.c       |  1 +
>   drivers/scsi/cxgbi/cxgb4i/cxgb4i.c       |  1 +
>   drivers/scsi/iscsi_tcp.c                 |  1 +
>   drivers/scsi/libiscsi.c                  | 20 ++++++++++----------
>   drivers/scsi/qedi/qedi_fw.c              |  4 ++--
>   drivers/scsi/qedi/qedi_iscsi.c           |  1 +
>   drivers/scsi/qla4xxx/ql4_def.h           | 16 +++++++++++++---
>   drivers/scsi/qla4xxx/ql4_os.c            | 13 +++++++------
>   include/scsi/libiscsi.h                  | 12 ++++++++++++
>   12 files changed, 52 insertions(+), 22 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
