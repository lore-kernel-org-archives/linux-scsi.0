Return-Path: <SRS0=JddF=7F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BAF6C433DF
	for <linux-scsi@archiver.kernel.org>; Sat, 23 May 2020 19:05:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 131442070A
	for <linux-scsi@archiver.kernel.org>; Sat, 23 May 2020 19:05:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P78HqkSQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728018AbgEWTFc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 23 May 2020 15:05:32 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:42792 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726790AbgEWTFc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 23 May 2020 15:05:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590260731;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Nf7zHjEemPEQTkQ9G+ErBRBTFKvl0CzvhJ6SPwvk8Z4=;
        b=P78HqkSQGIk4hrgjRSsQ3tau3IZ50wZnndjZdMj/Hh40Y0yS3q90nOU/a2EeTaLn4+pkAY
        8O9N28eOsntzM5qihzKQ578mwN16zBovrcYo7FLhaEBNRxqI1XuHniE6vMfrsW8co4LpzT
        ZR6L9B1nWTV+Cgnkk2eB/rM4rmtSyPw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-365-EgWFgU5NOzSMlwjpEV0D3g-1; Sat, 23 May 2020 15:05:27 -0400
X-MC-Unique: EgWFgU5NOzSMlwjpEV0D3g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 37CB1800D24;
        Sat, 23 May 2020 19:05:26 +0000 (UTC)
Received: from [10.10.112.111] (ovpn-112-111.rdu2.redhat.com [10.10.112.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D3C045D9D5;
        Sat, 23 May 2020 19:05:19 +0000 (UTC)
Subject: Re: [PATCH 1/1] vhost: scsi: notify TCM about the maximum sg entries
 supported per command.
To:     Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>,
        martin.petersen@oracle.com, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
        stefanha@redhat.com, shirley.ma@oracle.com
References: <1590166317-953-1-git-send-email-sudhakar.panneerselvam@oracle.com>
From:   Mike Christie <mchristi@redhat.com>
Message-ID: <a0cd35c6-71b0-1b9f-ef29-d937b6484290@redhat.com>
Date:   Sat, 23 May 2020 14:05:19 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <1590166317-953-1-git-send-email-sudhakar.panneerselvam@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/22/20 11:51 AM, Sudhakar Panneerselvam wrote:
> vhost-scsi pre-allocates the maximum sg entries per command and if a
> command requires more than VHOST_SCSI_PREALLOC_SGLS entries, then that
> command is failed by it. This patch lets vhost communicate the max sg limit
> when it registers vhost_scsi_ops with TCM. With this change, TCM would
> report the max sg entries through "Block Limits" VPD page which will be
> typically queried by the SCSI initiator during device discovery. By knowing
> this limit, the initiator could ensure the maximum transfer length is less
> than or equal to what is reported by vhost-scsi.
> 
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
> ---
>  drivers/vhost/scsi.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
> index c39952243fd3..8b104f76f324 100644
> --- a/drivers/vhost/scsi.c
> +++ b/drivers/vhost/scsi.c
> @@ -2280,6 +2280,7 @@ static void vhost_scsi_drop_tport(struct se_wwn *wwn)
>  static const struct target_core_fabric_ops vhost_scsi_ops = {
>  	.module				= THIS_MODULE,
>  	.fabric_name			= "vhost",
> +	.max_data_sg_nents		= VHOST_SCSI_PREALLOC_SGLS,
>  	.tpg_get_wwn			= vhost_scsi_get_fabric_wwn,
>  	.tpg_get_tag			= vhost_scsi_get_tpgt,
>  	.tpg_check_demo_mode		= vhost_scsi_check_true,
> 

Looks ok to me.

Reviewed-by: Mike Christie <mchristi@redhat.com>

