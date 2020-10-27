Return-Path: <SRS0=LZqT=EC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7494AC388F9
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 13:07:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 321BB20878
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 13:07:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SxIjkC10"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439261AbgJ0NHq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Oct 2020 09:07:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49227 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751834AbgJ0NHq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Oct 2020 09:07:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603804064;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pUGFV8Epd7vXcx8sg02eTabi/rVHE/rnCF+rnz+uE1E=;
        b=SxIjkC10pdkNSjzuIH5eikq/PXVUMI1i16xA2H47cEX4wCCqO4TxFZBCMSUa7lEH0JTe4C
        8DynKgUvsLO71Et0YwLse/o3yGrxIqhH4K8nU9MJ/yFVHkoYiEf3mtcqHCqm5OqW99cfJk
        1Z6u31H/YpooNQg43FHRV3krt9HaSHk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-CsZFxLlnOKOv-4qGODkByw-1; Tue, 27 Oct 2020 09:07:39 -0400
X-MC-Unique: CsZFxLlnOKOv-4qGODkByw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 940B580B714;
        Tue, 27 Oct 2020 13:07:18 +0000 (UTC)
Received: from [10.35.206.125] (unknown [10.35.206.125])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DF5D06EF67;
        Tue, 27 Oct 2020 13:07:14 +0000 (UTC)
Subject: Re: [PATCH 09/17] vhost scsi: fix cmd completion race
To:     Mike Christie <michael.christie@oracle.com>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
References: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
 <1603326903-27052-10-git-send-email-michael.christie@oracle.com>
From:   Maurizio Lombardi <mlombard@redhat.com>
Message-ID: <8662eb42-7632-a05f-cb55-5dc80b444612@redhat.com>
Date:   Tue, 27 Oct 2020 14:07:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <1603326903-27052-10-git-send-email-michael.christie@oracle.com>
Content-Type: text/plain; charset=iso-8859-2
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



Dne 22. 10. 20 v 2:34 Mike Christie napsal(a):
> We might not do the final se_cmd put from vhost_scsi_complete_cmd_work.
> When the last put happens a little later then we could race where
> vhost_scsi_complete_cmd_work does vhost_signal, the guest runs and sends
> more IO, and vhost_scsi_handle_vq runs but does not find any free cmds.
> 
> This patch has us delay completing the cmd until the last lio core ref
> is dropped. We then know that once we signal to the guest that the cmd
> is completed that if it queues a new command it will find a free cmd.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/vhost/scsi.c | 42 +++++++++++++++---------------------------
>  1 file changed, 15 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
> index f6b9010..2fa48dd 100644
> --- a/drivers/vhost/scsi.c
> +++ b/drivers/vhost/scsi.c
> @@ -322,7 +322,7 @@ static u32 vhost_scsi_tpg_get_inst_index(struct se_portal_group *se_tpg)
>  	return 1;
>  }
>  
> -static void vhost_scsi_release_cmd(struct se_cmd *se_cmd)
> +static void vhost_scsi_release_cmd_res(struct se_cmd *se_cmd)
>  {
>  	struct vhost_scsi_cmd *tv_cmd = container_of(se_cmd,
>  				struct vhost_scsi_cmd, tvc_se_cmd);
> @@ -344,6 +344,16 @@ static void vhost_scsi_release_cmd(struct se_cmd *se_cmd)
>  	vhost_scsi_put_inflight(inflight);
>  }
>  
> +static void vhost_scsi_release_cmd(struct se_cmd *se_cmd)
> +{
> +	struct vhost_scsi_cmd *cmd = container_of(se_cmd,
> +					struct vhost_scsi_cmd, tvc_se_cmd);
> +	struct vhost_scsi *vs = cmd->tvc_vhost;
> +
> +	llist_add(&cmd->tvc_completion_list, &vs->vs_completion_list);
> +	vhost_work_queue(&vs->dev, &vs->vs_completion_work);
> +}
> +
>  static u32 vhost_scsi_sess_get_index(struct se_session *se_sess)
>  {
>  	return 0;
> @@ -366,28 +376,15 @@ static int vhost_scsi_get_cmd_state(struct se_cmd *se_cmd)
>  	return 0;
>  }
>  
> -static void vhost_scsi_complete_cmd(struct vhost_scsi_cmd *cmd)
> -{
> -	struct vhost_scsi *vs = cmd->tvc_vhost;
> -
> -	llist_add(&cmd->tvc_completion_list, &vs->vs_completion_list);
> -
> -	vhost_work_queue(&vs->dev, &vs->vs_completion_work);
> -}
> -
>  static int vhost_scsi_queue_data_in(struct se_cmd *se_cmd)
>  {
> -	struct vhost_scsi_cmd *cmd = container_of(se_cmd,
> -				struct vhost_scsi_cmd, tvc_se_cmd);
> -	vhost_scsi_complete_cmd(cmd);
> +	transport_generic_free_cmd(se_cmd, 0);
>  	return 0;
>  }
>  
>  static int vhost_scsi_queue_status(struct se_cmd *se_cmd)
>  {
> -	struct vhost_scsi_cmd *cmd = container_of(se_cmd,
> -				struct vhost_scsi_cmd, tvc_se_cmd);
> -	vhost_scsi_complete_cmd(cmd);
> +	transport_generic_free_cmd(se_cmd, 0);
>  	return 0;
>  }
>  
> @@ -433,15 +430,6 @@ static void vhost_scsi_free_evt(struct vhost_scsi *vs, struct vhost_scsi_evt *ev
>  	return evt;
>  }
>  
> -static void vhost_scsi_free_cmd(struct vhost_scsi_cmd *cmd)
> -{
> -	struct se_cmd *se_cmd = &cmd->tvc_se_cmd;
> -
> -	/* TODO locking against target/backend threads? */
> -	transport_generic_free_cmd(se_cmd, 0);
> -
> -}
> -
>  static int vhost_scsi_check_stop_free(struct se_cmd *se_cmd)
>  {
>  	return target_put_sess_cmd(se_cmd);
> @@ -560,7 +548,7 @@ static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
>  		} else
>  			pr_err("Faulted on virtio_scsi_cmd_resp\n");
>  
> -		vhost_scsi_free_cmd(cmd);
> +		vhost_scsi_release_cmd_res(se_cmd);
>  	}
>  
>  	vq = -1;
> @@ -1096,7 +1084,7 @@ static u16 vhost_buf_to_lun(u8 *lun_buf)
>  						      &prot_iter, exp_data_len,
>  						      &data_iter))) {
>  				vq_err(vq, "Failed to map iov to sgl\n");
> -				vhost_scsi_release_cmd(&cmd->tvc_se_cmd);
> +				vhost_scsi_release_cmd_res(&cmd->tvc_se_cmd);
>  				goto err;
>  			}
>  		}
> 

Looks ok to me.

Reviewed-by: Maurizio Lombardi <mlombard@redhat.com>

