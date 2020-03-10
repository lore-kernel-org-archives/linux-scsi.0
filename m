Return-Path: <SRS0=Pfrg=43=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F3C6C10DCE
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 23:09:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20C3A2071B
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 23:09:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KfAbE8M9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727642AbgCJXJB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Mar 2020 19:09:01 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:54956 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726325AbgCJXJB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Mar 2020 19:09:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583881740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wkPE+IhNE5fdZSVJ5cOurXqU2RwW85UEqdhYtpKuSmI=;
        b=KfAbE8M9nVSOtyM5f/LW/80dV7Ch67+MJycCckHWNDfrQ+nVpiOFjF8Bt3vfe/zslOdtyx
        0psCWV6IqGPPrQ9CUCrs3DMCaRiAfISyhurtTAyhOIGd7kjjbPDQKCL/Q44ABIkcLrreo/
        p567zBz74ycWzuM9HTM/LxImuDZd0MA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-ai_V4I1sODC8ESQzccoL5A-1; Tue, 10 Mar 2020 19:08:58 -0400
X-MC-Unique: ai_V4I1sODC8ESQzccoL5A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E5DFA184C810;
        Tue, 10 Mar 2020 23:08:50 +0000 (UTC)
Received: from ming.t460p (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B50BB10013A1;
        Tue, 10 Mar 2020 23:08:40 +0000 (UTC)
Date:   Wed, 11 Mar 2020 07:08:35 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com,
        hare@suse.de, bvanassche@acm.org, hch@infradead.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        esc.storagedev@microsemi.com, chenxiang66@hisilicon.com,
        Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH RFC v2 01/24] scsi: add 'nr_reserved_cmds' field to the
 SCSI host template
Message-ID: <20200310230835.GA16056@ming.t460p>
References: <1583857550-12049-1-git-send-email-john.garry@huawei.com>
 <1583857550-12049-2-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1583857550-12049-2-git-send-email-john.garry@huawei.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Mar 11, 2020 at 12:25:27AM +0800, John Garry wrote:
> From: Hannes Reinecke <hare@suse.com>
> 
> Add a new field 'nr_reserved_cmds' to the SCSI host template to
> instruct the block layer to set aside a tag space for reserved
> commands.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/scsi_lib.c  | 1 +
>  include/scsi/scsi_host.h | 6 ++++++
>  2 files changed, 7 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 610ee41fa54c..2967325df7a0 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1896,6 +1896,7 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
>  		shost->tag_set.ops = &scsi_mq_ops_no_commit;
>  	shost->tag_set.nr_hw_queues = shost->nr_hw_queues ? : 1;
>  	shost->tag_set.queue_depth = shost->can_queue;
> +	shost->tag_set.reserved_tags = shost->nr_reserved_cmds;

You reserve tags for special usage, meantime the whole queue depth
isn't increased, that means the tags for IO request is decreased given
reserved tags can't be used for IO, so IO performance may be effected.

If not the case, please explain a bit in commit log.

Thanks,
Ming

