Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91FDD2EF289
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jun 2025 17:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750267329; cv=none; b=uM2V+1kW6+ms2UnabcNM6Utn/kTYGf8AADvStx55O8OtP75iL9+RIBvH58gYv5JT0DmlRDguePct687sRB+vCthvld0x48XV50NWHPlcYXsxbg90VanEHBCD4yPOOV1WesP4ZLGXZ4HCqVnIIGy4iTnJNPx7iebOBWJMCz5QJfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750267329; c=relaxed/simple;
	bh=JQXct5x6xClvcXeIW3n4Ed4wK4FBsJctQGZPbEpfj+c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g5NB8bVCG28Qm5rluPQcueIiFs4yrb8NADBfZD7wnVPUPGpHDvYtzcUjUVC0H4inmE9u9SmIidVN1ps0HbpcgOhKU5eQIrQo2uWHe/DytmfXBzG14qAbb1m0ev3HntRmH3bDSojaNrH3hV7xOA+UekX5VOPP6g1CFXtGGJiyQ1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dqLWs+Io; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dqLWs+Io"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750267326;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iPzAnQ1fZXolnZ1+sIetH1vtwxZcsqJF5DWYrNvf4/M=;
	b=dqLWs+Iopamo/bEQqXw8a4Guqq/ozXoMxhpLF/4fZjGuIv0hlOXoUdeN+upyRLYpEJ87QZ
	izm84cTbWNK7tHYO3U4TxOiaRnFwonanni7IrZhaArJuEzaEBZbHPOyc6AB6y2Z0EWbzC1
	Yj9mH/F4gnC8gWtMpMFF6ToLIu1JT5Y=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-253-zpcEMTcpMraorc_HVKzFoQ-1; Wed,
 18 Jun 2025 13:22:01 -0400
X-MC-Unique: zpcEMTcpMraorc_HVKzFoQ-1
X-Mimecast-MFC-AGG-ID: zpcEMTcpMraorc_HVKzFoQ_1750267319
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 350691800294;
	Wed, 18 Jun 2025 17:21:59 +0000 (UTC)
Received: from [10.22.64.21] (unknown [10.22.64.21])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7618E1956094;
	Wed, 18 Jun 2025 17:21:56 +0000 (UTC)
Message-ID: <89a9481a-f788-4e7e-b0ad-b23bb0f24fc9@redhat.com>
Date: Wed, 18 Jun 2025 13:21:55 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 4/4] scsi: fnic: Set appropriate logging level for log
 message
To: Karan Tilak Kumar <kartilak@cisco.com>, sebaddel@cisco.com
Cc: arulponn@cisco.com, djhawar@cisco.com, gcboffa@cisco.com,
 mkai2@cisco.com, satishkh@cisco.com, aeasi@cisco.com, jejb@linux.ibm.com,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, revers@redhat.com, dan.carpenter@linaro.org
References: <20250618003431.6314-1-kartilak@cisco.com>
 <20250618003431.6314-4-kartilak@cisco.com>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20250618003431.6314-4-kartilak@cisco.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Reviewed-by: John Meneghini <jmeneghi@redhat.com>


On 6/17/25 8:34 PM, Karan Tilak Kumar wrote:
> Replace KERN_INFO with KERN_DEBUG for a log message.
> 
> Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
> Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
> Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
> Reviewed-by: Arun Easi <aeasi@cisco.com>
> Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
> ---
> Changes between v5 and v6:
>      - Incorporate review comments from John:
> 	- Rebase patches on 6.17/scsi-queue
> 
> Changes between v4 and v5:
>      - Incorporate review comments from John:
> 	- Refactor patches
> ---
>   drivers/scsi/fnic/fnic_scsi.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
> index 7133b254cbe4..75b29a018d1f 100644
> --- a/drivers/scsi/fnic/fnic_scsi.c
> +++ b/drivers/scsi/fnic/fnic_scsi.c
> @@ -1046,7 +1046,7 @@ static void fnic_fcpio_icmnd_cmpl_handler(struct fnic *fnic, unsigned int cq_ind
>   		if (icmnd_cmpl->scsi_status == SAM_STAT_TASK_SET_FULL)
>   			atomic64_inc(&fnic_stats->misc_stats.queue_fulls);
>   
> -		FNIC_SCSI_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
> +		FNIC_SCSI_DBG(KERN_DEBUG, fnic->host, fnic->fnic_num,
>   				"xfer_len: %llu", xfer_len);
>   		break;
>   

