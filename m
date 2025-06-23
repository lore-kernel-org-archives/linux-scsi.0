Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5150B29AB1B
	for <linux-scsi@vger.kernel.org>; Mon, 23 Jun 2025 15:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750694324; cv=none; b=u3YcTLzgTR3yiyN4UVKuAhxfKT7m6MFdZNfYD0Mi9njY7rHHpD3MOENb7EXb+FLj+5oPt4mmnybJJAduktFYM9BDxoJFTITmAK5mMyQEBfMPSmlwHZaW014uFDyy0mIo0MIEmUkqfQaLK598UUnvkdf6g9kEQnGQicmGaPJb3Eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750694324; c=relaxed/simple;
	bh=z8xS+SakFVtaTBebQ0qFvFJNZ7vIUfLEo/crMh1HBo8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WxgcgkIYxAqBz5Sqq0gaDkJw34XImQOU14gauy970/ZOqciMPjP3l3spwdFrjG5PRZHR8I2asEek+sG+psVUaeYYNv1bdSZ81oyQ8lf7h0IsBIl264NVEft/P/HkRKGtI0RPzQi6TRjELog9Y6zETC76tD2A8AMVzrva6zp7MfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R8k4giNt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R8k4giNt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750694321;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xp/NPSwxRgyAEB8pg2EyAuhmZM7GDC/qlCOMFtZyHbs=;
	b=R8k4giNtmqD1E8CfRj/Sd8TzlWHxIYFM696n6OLi46rIxlU6DmpkrgHwBmP6tEt8t6PWzo
	jF3yYW4XwuDhEiyA9kjmLxmSIA5lxcU8ijn9xnJ4bzRw5/noYW5XzdAQtThrrWkVd0+wZj
	NkIIJily+BJ3RdJIS6Gddl7F/qzODJk=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-675-K14lKX8XPae7pqhR70rUJg-1; Mon,
 23 Jun 2025 11:58:37 -0400
X-MC-Unique: K14lKX8XPae7pqhR70rUJg-1
X-Mimecast-MFC-AGG-ID: K14lKX8XPae7pqhR70rUJg_1750694315
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AF6741809C84;
	Mon, 23 Jun 2025 15:58:34 +0000 (UTC)
Received: from [10.22.90.20] (unknown [10.22.90.20])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2EC6919560AF;
	Mon, 23 Jun 2025 15:58:32 +0000 (UTC)
Message-ID: <0d5fa679-2b19-4288-97c6-e50c199dfa2a@redhat.com>
Date: Mon, 23 Jun 2025 11:58:30 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/6] nvme-fc: nvme_fc_fpin_rcv() callback
To: Bryan Gurney <bgurney@redhat.com>, linux-nvme@lists.infradead.org,
 kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, axboe@kernel.dk
Cc: james.smart@broadcom.com, dick.kennedy@broadcom.com, njavali@marvell.com,
 linux-scsi@vger.kernel.org, hare@suse.de
References: <20250620175710.34711-1-bgurney@redhat.com>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20250620175710.34711-1-bgurney@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Reviewed-by: John Meneghini <jmeneghi@redhat.com>

On 6/20/25 1:57 PM, Bryan Gurney wrote:
> From: Hannes Reinecke <hare@kernel.org>
> 
> Add a callback nvme_fc_fpin_rcv() to evaluate the FPIN LI TLV
> information and set the 'marginal' path status for all affected
> rports.
> 
> Signed-off-by: Hannes Reinecke <hare@kernel.org>
> Tested-by: Bryan Gurney <bgurney@redhat.com>
> ---
>   drivers/nvme/host/fc.c         | 95 ++++++++++++++++++++++++++++++++++
>   include/linux/nvme-fc-driver.h |  3 ++
>   2 files changed, 98 insertions(+)
> 
> diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
> index 7e81c815bb83..71a77917a14f 100644
> --- a/drivers/nvme/host/fc.c
> +++ b/drivers/nvme/host/fc.c
> @@ -3724,6 +3724,101 @@ static struct nvmf_transport_ops nvme_fc_transport = {
>   	.create_ctrl	= nvme_fc_create_ctrl,
>   };
>   
> +static struct nvme_fc_rport *nvme_fc_rport_from_wwpn(struct nvme_fc_lport *lport,
> +		u64 rport_wwpn)
> +{
> +	struct nvme_fc_rport *rport;
> +
> +	list_for_each_entry(rport, &lport->endp_list, endp_list) {
> +		if (!nvme_fc_rport_get(rport))
> +			continue;
> +		if (rport->remoteport.port_name == rport_wwpn &&
> +		    rport->remoteport.port_role & FC_PORT_ROLE_NVME_TARGET)
> +			return rport;
> +		nvme_fc_rport_put(rport);
> +	}
> +	return NULL;
> +}
> +
> +static void
> +nvme_fc_fpin_li_lport_update(struct nvme_fc_lport *lport, struct fc_fn_li_desc *li)
> +{
> +	unsigned int i, pname_count = be32_to_cpu(li->pname_count);
> +	u64 attached_wwpn = be64_to_cpu(li->attached_wwpn);
> +	struct nvme_fc_rport *attached_rport;
> +
> +	for (i = 0; i < pname_count; i++) {
> +		struct nvme_fc_rport *rport;
> +		u64 wwpn = be64_to_cpu(li->pname_list[i]);
> +
> +		rport = nvme_fc_rport_from_wwpn(lport, wwpn);
> +		if (!rport)
> +			continue;
> +		if (wwpn != attached_wwpn) {
> +			struct nvme_fc_ctrl *ctrl;
> +
> +			spin_lock_irq(&rport->lock);
> +			list_for_each_entry(ctrl, &rport->ctrl_list, ctrl_list)
> +				set_bit(NVME_CTRL_MARGINAL, &ctrl->ctrl.flags);
> +			spin_unlock_irq(&rport->lock);
> +		}
> +		nvme_fc_rport_put(rport);
> +	}
> +
> +	attached_rport = nvme_fc_rport_from_wwpn(lport, attached_wwpn);
> +	if (attached_rport) {
> +		struct nvme_fc_ctrl *ctrl;
> +
> +		spin_lock_irq(&attached_rport->lock);
> +		list_for_each_entry(ctrl, &attached_rport->ctrl_list, ctrl_list)
> +			set_bit(NVME_CTRL_MARGINAL, &ctrl->ctrl.flags);
> +		spin_unlock_irq(&attached_rport->lock);
> +		nvme_fc_rport_put(attached_rport);
> +	}
> +}
> +
> +/**
> + * fc_host_fpin_rcv() - Process a received FPIN.
> + * @localport:		local port the FPIN was received on
> + * @fpin_len:		length of FPIN payload, in bytes
> + * @fpin_buf:		pointer to FPIN payload
> + * Notes:
> + *	This routine assumes no locks are held on entry.
> + */
> +void
> +nvme_fc_fpin_rcv(struct nvme_fc_local_port *localport,
> +		 u32 fpin_len, char *fpin_buf)
> +{
> +	struct nvme_fc_lport *lport;
> +	struct fc_els_fpin *fpin = (struct fc_els_fpin *)fpin_buf;
> +	union fc_tlv_desc *tlv;
> +	u32 bytes_remain;
> +	u32 dtag;
> +
> +	if (!localport)
> +		return;
> +	lport = localport_to_lport(localport);
> +	tlv = &fpin->fpin_desc[0];
> +	bytes_remain = fpin_len - offsetof(struct fc_els_fpin, fpin_desc);
> +	bytes_remain = min_t(u32, bytes_remain, be32_to_cpu(fpin->desc_len));
> +
> +	while (bytes_remain >= FC_TLV_DESC_HDR_SZ &&
> +	       bytes_remain >= FC_TLV_DESC_SZ_FROM_LENGTH(tlv)) {
> +		dtag = be32_to_cpu(tlv->hdr.desc_tag);
> +		switch (dtag) {
> +		case ELS_DTAG_LNK_INTEGRITY:
> +			nvme_fc_fpin_li_lport_update(lport, &tlv->li);
> +			break;
> +		default:
> +			break;
> +		}
> +
> +		bytes_remain -= FC_TLV_DESC_SZ_FROM_LENGTH(tlv);
> +		tlv = fc_tlv_next_desc(tlv);
> +	}
> +}
> +EXPORT_SYMBOL(nvme_fc_fpin_rcv);
> +
>   /* Arbitrary successive failures max. With lots of subsystems could be high */
>   #define DISCOVERY_MAX_FAIL	20
>   
> diff --git a/include/linux/nvme-fc-driver.h b/include/linux/nvme-fc-driver.h
> index 9f6acadfe0c8..bcd3b1e5a256 100644
> --- a/include/linux/nvme-fc-driver.h
> +++ b/include/linux/nvme-fc-driver.h
> @@ -536,6 +536,9 @@ void nvme_fc_rescan_remoteport(struct nvme_fc_remote_port *remoteport);
>   int nvme_fc_set_remoteport_devloss(struct nvme_fc_remote_port *remoteport,
>   			u32 dev_loss_tmo);
>   
> +void nvme_fc_fpin_rcv(struct nvme_fc_local_port *localport,
> +		      u32 fpin_len, char *fpin_buf);
> +
>   /*
>    * Routine called to pass a NVME-FC LS request, received by the lldd,
>    * to the nvme-fc transport.

