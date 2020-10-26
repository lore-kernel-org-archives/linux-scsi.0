Return-Path: <SRS0=a792=EB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93040C388F7
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 03:33:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 461EA21548
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 03:33:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bAuOX9vV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1420313AbgJZDdU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Oct 2020 23:33:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47998 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2411389AbgJZDdU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 25 Oct 2020 23:33:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603683199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/UA4iCjiTPMl9Eaovz1mPhI0BzNej9aUfltuhE76s2M=;
        b=bAuOX9vVGMNDAruBHNXCcPFqc8pmftx0V3NNvAzMHq0qdlPHlCSWTs01BMwCjvlNZQPnwO
        Ivv8FJ9ilA8jL+NIYYE7AnoissYcy5QnLduMMXhw27Bk9lSGprOdrUDpsubXXR5wy2XPSp
        xiCbYcCKm29zBDm9zmVjawix7lC+2xw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-dbwGOHC0Pdu-Wod8u8nhzg-1; Sun, 25 Oct 2020 23:33:17 -0400
X-MC-Unique: dbwGOHC0Pdu-Wod8u8nhzg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 422F9186840A;
        Mon, 26 Oct 2020 03:33:16 +0000 (UTC)
Received: from [10.72.13.201] (ovpn-13-201.pek2.redhat.com [10.72.13.201])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6F2C755772;
        Mon, 26 Oct 2020 03:33:03 +0000 (UTC)
Subject: Re: [PATCH 01/17] vhost scsi: add lun parser helper
To:     Mike Christie <michael.christie@oracle.com>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, pbonzini@redhat.com,
        stefanha@redhat.com, virtualization@lists.linux-foundation.org
References: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
 <1603326903-27052-2-git-send-email-michael.christie@oracle.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <eef46e20-ed8f-0fb4-be9f-a0f5bd1edfa0@redhat.com>
Date:   Mon, 26 Oct 2020 11:33:01 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1603326903-27052-2-git-send-email-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 2020/10/22 上午8:34, Mike Christie wrote:
> Move code to parse lun from req's lun_buf to helper, so tmf code
> can use it in the next patch.
>
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   drivers/vhost/scsi.c | 9 +++++++--
>   1 file changed, 7 insertions(+), 2 deletions(-)


Acked-by: Jason Wang <jasowang@redhat.com>


>
> diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
> index b22adf0..0ea78d0 100644
> --- a/drivers/vhost/scsi.c
> +++ b/drivers/vhost/scsi.c
> @@ -907,6 +907,11 @@ static void vhost_scsi_submission_work(struct work_struct *work)
>   	return ret;
>   }
>   
> +static u16 vhost_buf_to_lun(u8 *lun_buf)
> +{
> +	return ((lun_buf[2] << 8) | lun_buf[3]) & 0x3FFF;
> +}
> +
>   static void
>   vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
>   {
> @@ -1045,12 +1050,12 @@ static void vhost_scsi_submission_work(struct work_struct *work)
>   			tag = vhost64_to_cpu(vq, v_req_pi.tag);
>   			task_attr = v_req_pi.task_attr;
>   			cdb = &v_req_pi.cdb[0];
> -			lun = ((v_req_pi.lun[2] << 8) | v_req_pi.lun[3]) & 0x3FFF;
> +			lun = vhost_buf_to_lun(v_req_pi.lun);
>   		} else {
>   			tag = vhost64_to_cpu(vq, v_req.tag);
>   			task_attr = v_req.task_attr;
>   			cdb = &v_req.cdb[0];
> -			lun = ((v_req.lun[2] << 8) | v_req.lun[3]) & 0x3FFF;
> +			lun = vhost_buf_to_lun(v_req.lun);
>   		}
>   		/*
>   		 * Check that the received CDB size does not exceeded our

