Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE20242D8D
	for <linux-scsi@vger.kernel.org>; Wed,  9 Jul 2025 22:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752098625; cv=none; b=HdSfUXlxjwzbysfGghAy0pdmOUsSiK/PEjlEm2dpdAwsh1Iwy9DJNHsr4NlZUj/eKcXwlgfsoLgW8h/ofjZpezuOE13NTsMRNg6LAHOqW6uaG5EgbCJ9NuUlEsfFVulU574JAdFZwi5l882M2JTq+SdxJ+QK2H7lM1giFroj1IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752098625; c=relaxed/simple;
	bh=W3GM3rB8WcKRUSN4uA1SPoZJSB1gORKSmW0XgdelN7g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=De4NVOvz8ddMA5T3S3qd1grTJNRcUa7C7l149NiNO0ciXMgK+O5BbKTI7cUEw+iyNOJItGSku9MrBBvs3fyDJBwa5Zd4KNLs6X7R7LN/hJura/MpiM6uljFX1iHb9EcehIhWqejpeNWRw6SK7f7pvqDcJD3szwU5buEfF+LoCRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CPcHIsuD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CPcHIsuD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752098621;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cNWVgYorlezzpiXLgcrEONisn5Nz590rYKhz7d0bXSo=;
	b=CPcHIsuDPC7CdV9+eAJjT0hHBJhYtVrzUQrLHVKBb9lREWvp/GP0vCErqVcsrdgOJkEaro
	F3ERLLaCBxnZ2eqeuZaBajkX5X/gxWjfF7DwjM3kef6mJlIoNuRdqeiy5znwg9Vq2wnvDj
	zvUlKzdOjJojEGEV0/iHU4iPAgtddqQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-523-bY1N7DJWM12Cj8q9x6okxg-1; Wed,
 09 Jul 2025 18:03:35 -0400
X-MC-Unique: bY1N7DJWM12Cj8q9x6okxg-1
X-Mimecast-MFC-AGG-ID: bY1N7DJWM12Cj8q9x6okxg_1752098614
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 27DFA19560BE;
	Wed,  9 Jul 2025 22:03:34 +0000 (UTC)
Received: from [10.17.16.239] (unknown [10.17.16.239])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 192EC1955E99;
	Wed,  9 Jul 2025 22:03:31 +0000 (UTC)
Message-ID: <66a05f2e-f3fd-4347-9c7f-f8fbb715890d@redhat.com>
Date: Wed, 9 Jul 2025 18:03:31 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 8/8] nvme-multipath: queue-depth support for marginal
 paths
To: hare@suse.de
Cc: james.smart@broadcom.com, dick.kennedy@broadcom.com, njavali@marvell.com,
 linux-scsi@vger.kernel.org, axboe@kernel.dk, sagi@grimberg.me, hch@lst.de,
 kbusch@kernel.org, linux-nvme@lists.infradead.org,
 Bryan Gurney <bgurney@redhat.com>
References: <20250709212652.49471-1-bgurney@redhat.com>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20250709212652.49471-1-bgurney@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Hannes, this patch fixes the queue-depth scheduler.  Please take a look.

On 7/9/25 5:26 PM, Bryan Gurney wrote:
> From: John Meneghini <jmeneghi@redhat.com>
> 
> Exclude marginal paths from queue-depth io policy. In the case where all
> paths are marginal and no optimized or non-optimized path is found, we
> fall back to __nvme_find_path which selects the best marginal path.
> 
> Tested-by: Bryan Gurney <bgurney@redhat.com>
> Signed-off-by: John Meneghini <jmeneghi@redhat.com>
> ---
>   drivers/nvme/host/multipath.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
> index 8d4e54bb4261..767583e8454b 100644
> --- a/drivers/nvme/host/multipath.c
> +++ b/drivers/nvme/host/multipath.c
> @@ -420,6 +420,9 @@ static struct nvme_ns *nvme_queue_depth_path(struct nvme_ns_head *head)
>   		if (nvme_path_is_disabled(ns))
>   			continue;
>   
> +		if (nvme_ctrl_is_marginal(ns->ctrl))
> +			continue;
> +
>   		depth = atomic_read(&ns->ctrl->nr_active);
>   
>   		switch (ns->ana_state) {
> @@ -443,7 +446,9 @@ static struct nvme_ns *nvme_queue_depth_path(struct nvme_ns_head *head)
>   			return best_opt;
>   	}
>   
> -	return best_opt ? best_opt : best_nonopt;
> +	best_opt = (best_opt) ? best_opt : best_nonopt;
> +
> +	return best_opt ? best_opt : __nvme_find_path(head, numa_node_id());
>   }
>   
>   static inline bool nvme_path_is_optimized(struct nvme_ns *ns)

