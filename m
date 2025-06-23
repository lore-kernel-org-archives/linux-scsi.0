Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B5627C854
	for <linux-scsi@vger.kernel.org>; Mon, 23 Jun 2025 15:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750692809; cv=none; b=Xap/8Jmj/yTNT5sk+6JSWEMvJy/JIA7sY35NK/mZe3YO9pie7xwEMwU5mHqmmCN+JnFQ2Fuix/f8RI3Vo/mBme8dyBvwTGyKCLMoGRAwqKuwzqKx9drjx9j9kivUbqfFPYYhKYcvEiJN+v+9BEvab6zgB83WCs+AWOVtQ46LUso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750692809; c=relaxed/simple;
	bh=O6hDUufQP/D9o6VlhX76Lect/oTqo6NVcu6GOiUEr8Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Id2a0x20JycbZY9vX4i4NvHpQLoZcej1okeoAok+5R4bRs+Tjs5kCU/VNxb+mQTJ3wwGmBReTJMrBf5o8S/SXfBS1cmj0MKi5GjJuZYElflD0T9HiW/cJ5CZIKIaW/XiouqIxVg/rjv+MMNOa+YjBExe0wLXjTPWE3EvuIMRSDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J6ynrcAF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J6ynrcAF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750692807;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JynrP5TGuxhjWxQiqEKOXeWc2e5BPWFMVYNl8GD1NSI=;
	b=J6ynrcAF6hNeYRDRVZL/yP5fFI5et5cte46yzqC446P9f1786QyRMQWAX1MGkkJ+CoZY1m
	9V6//9gjaRkisFCDH8s6rCaCP6qKeTOaH2viHQIzNHRDBZadtb/r6tIiYY5CRxUxqdwkTg
	SDwxcCLRlhChmpHBo4xsJBd1V8QUZSk=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-131-orDf3zvkOOOoPf7Oj7N2gw-1; Mon,
 23 Jun 2025 11:33:25 -0400
X-MC-Unique: orDf3zvkOOOoPf7Oj7N2gw-1
X-Mimecast-MFC-AGG-ID: orDf3zvkOOOoPf7Oj7N2gw_1750692804
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2FFDA195608E;
	Mon, 23 Jun 2025 15:33:23 +0000 (UTC)
Received: from [10.22.90.20] (unknown [10.22.90.20])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 587C2195608D;
	Mon, 23 Jun 2025 15:33:20 +0000 (UTC)
Message-ID: <84781ea1-3faa-4afe-8158-f41bdb8974e1@redhat.com>
Date: Mon, 23 Jun 2025 11:33:19 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 5/6] qla2xxx: enable FPIN notification for NVMe
To: Bryan Gurney <bgurney@redhat.com>, linux-nvme@lists.infradead.org,
 kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, axboe@kernel.dk
Cc: james.smart@broadcom.com, dick.kennedy@broadcom.com, njavali@marvell.com,
 linux-scsi@vger.kernel.org, hare@suse.de
References: <20250620175800.34769-1-bgurney@redhat.com>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20250620175800.34769-1-bgurney@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Reviewed-by: John Meneghini <jmeneghi@redhat.com>


On 6/20/25 1:58 PM, Bryan Gurney wrote:
> From: Hannes Reinecke <hare@kernel.org>
> 
> Call 'nvme_fc_fpin_rcv()' to enable FPIN notifications for NVMe.
> 
> Signed-off-by: Hannes Reinecke <hare@kernel.org>
> ---
>   drivers/scsi/qla2xxx/qla_isr.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index fe98c76e9be3..cfe7afc905b4 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -46,6 +46,9 @@ qla27xx_process_purex_fpin(struct scsi_qla_host *vha, struct purex_item *item)
>   		       pkt, pkt_size);
>   
>   	fc_host_fpin_rcv(vha->host, pkt_size, (char *)pkt, 0);
> +#if (IS_ENABLED(CONFIG_NVME_FC))
> +	nvme_fc_fpin_rcv(vha->nvme_local_port, pkt_size, (char *)pkt);
> +#endif
>   }
>   
>   const char *const port_state_str[] = {

