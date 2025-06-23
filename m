Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F157429AB01
	for <linux-scsi@vger.kernel.org>; Mon, 23 Jun 2025 15:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750694368; cv=none; b=LHW5Doia3NvNzlcnxuDg4ssWVTy1dkXns+i3AWa0hnbDMY3osoZ1e5jRP17ac+6oMGIE9rlJhS+7PRyw3WThAqNFnOyvp5PKsINOOBJHf6qOzgKtRZn5eOHTyFoDYdpThNltA2KALGVbXEoNkieBYHIuSIbRCf/fj02LrGk5UHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750694368; c=relaxed/simple;
	bh=SKSxmXWUJg3pdxwCLx7EW+tbTmovVAc71Wmi47Pbahw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CfYSd+xBidD+0mcDlygZZnlrHUhgp/a1xfhi1AuqBG6XJAjIFpN2IMbw86ahAJ3+gFi59yrXNpGBNKCQufJt6XTgE+dwPevYAatSLsjOEE4rXNWCVhig/rPtot+pI2XTl7+p58L9Cff0tspWNev+xVIecGYI4qjlOvNsO7jXdTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ERIQ+vVo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ERIQ+vVo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750694365;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C/VEpYOQlU7ibJrkmX04kqM1Ioan10IhR0BMkMXk3aI=;
	b=ERIQ+vVoATluxuLdMB3+Y0pyjOZOLdK/EYVxXL6/6z5yQNP4b+dJ4bKOFe0smulY4M3WhC
	jW8hBc/ccm8FWLDublw3tQlo9jGUB42wudbLaU/nJog3K+N22XhRW9xIXZtva0SQS3tN7s
	GR4cGQhm3nF99wQgBIV5mLNzaoDlDn8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-417-zLP3MARfNuOXSDS6v5be6w-1; Mon,
 23 Jun 2025 11:59:22 -0400
X-MC-Unique: zLP3MARfNuOXSDS6v5be6w-1
X-Mimecast-MFC-AGG-ID: zLP3MARfNuOXSDS6v5be6w_1750694361
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 700871809C97;
	Mon, 23 Jun 2025 15:59:20 +0000 (UTC)
Received: from [10.22.90.20] (unknown [10.22.90.20])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1943930001A1;
	Mon, 23 Jun 2025 15:59:16 +0000 (UTC)
Message-ID: <646e30c2-42db-4eb8-b516-f7d5ab3e3475@redhat.com>
Date: Mon, 23 Jun 2025 11:59:16 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/6] nvme-fc: marginal path handling
To: Bryan Gurney <bgurney@redhat.com>, linux-nvme@lists.infradead.org,
 kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, axboe@kernel.dk
Cc: james.smart@broadcom.com, dick.kennedy@broadcom.com, njavali@marvell.com,
 linux-scsi@vger.kernel.org, hare@suse.de
References: <20250620175632.34660-1-bgurney@redhat.com>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20250620175632.34660-1-bgurney@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Reviewed-by: John Meneghini <jmeneghi@redhat.com>

On 6/20/25 1:56 PM, Bryan Gurney wrote:
> From: Hannes Reinecke <hare@kernel.org>
> 
> FPIN LI (link integrity) messages are received when the attached
> fabric detects hardware errors. In response to these messages I/O
> should be directed away from the affected ports, and only used
> if the 'optimized' paths are unavailable.
> To handle this a new controller flag 'NVME_CTRL_MARGINAL' is added
> which will cause the multipath scheduler to skip these paths when
> checking for 'optimized' paths. They are, however, still eligible
> for non-optimized path selected. The flag is cleared upon reset as then the
> faulty hardware might be replaced.
> 
> Signed-off-by: Hannes Reinecke <hare@kernel.org>
> Tested-by: Bryan Gurney <bgurney@redhat.com>
> ---
>   drivers/nvme/host/core.c      |  1 +
>   drivers/nvme/host/fc.c        |  4 ++++
>   drivers/nvme/host/multipath.c | 17 +++++++++++------
>   drivers/nvme/host/nvme.h      |  6 ++++++
>   4 files changed, 22 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> index 3da5ac71a9b0..ac03ef7baab9 100644
> --- a/drivers/nvme/host/core.c
> +++ b/drivers/nvme/host/core.c
> @@ -5040,6 +5040,7 @@ int nvme_init_ctrl(struct nvme_ctrl *ctrl, struct device *dev,
>   	WRITE_ONCE(ctrl->state, NVME_CTRL_NEW);
>   	ctrl->passthru_err_log_enabled = false;
>   	clear_bit(NVME_CTRL_FAILFAST_EXPIRED, &ctrl->flags);
> +	clear_bit(NVME_CTRL_MARGINAL, &ctrl->flags);
>   	spin_lock_init(&ctrl->lock);
>   	mutex_init(&ctrl->namespaces_lock);
>   
> diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
> index 014b387f1e8b..7e81c815bb83 100644
> --- a/drivers/nvme/host/fc.c
> +++ b/drivers/nvme/host/fc.c
> @@ -786,6 +786,10 @@ nvme_fc_ctrl_connectivity_loss(struct nvme_fc_ctrl *ctrl)
>   		"Reconnect", ctrl->cnum);
>   
>   	set_bit(ASSOC_FAILED, &ctrl->flags);
> +
> +	/* clear 'marginal' flag as controller will be reset */
> +	clear_bit(NVME_CTRL_MARGINAL, &ctrl->flags);
> +
>   	nvme_reset_ctrl(&ctrl->ctrl);
>   }
>   
> diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
> index 1062467595f3..003954985675 100644
> --- a/drivers/nvme/host/multipath.c
> +++ b/drivers/nvme/host/multipath.c
> @@ -324,11 +324,14 @@ static struct nvme_ns *__nvme_find_path(struct nvme_ns_head *head, int node)
>   
>   		switch (ns->ana_state) {
>   		case NVME_ANA_OPTIMIZED:
> -			if (distance < found_distance) {
> -				found_distance = distance;
> -				found = ns;
> +			if (!nvme_ctrl_is_marginal(ns->ctrl)) {
> +				if (distance < found_distance) {
> +					found_distance = distance;
> +					found = ns;
> +				}
> +				break;
>   			}
> -			break;
> +			fallthrough;
>   		case NVME_ANA_NONOPTIMIZED:
>   			if (distance < fallback_distance) {
>   				fallback_distance = distance;
> @@ -381,7 +384,8 @@ static struct nvme_ns *nvme_round_robin_path(struct nvme_ns_head *head)
>   
>   		if (ns->ana_state == NVME_ANA_OPTIMIZED) {
>   			found = ns;
> -			goto out;
> +			if (!nvme_ctrl_is_marginal(ns->ctrl))
> +				goto out;
>   		}
>   		if (ns->ana_state == NVME_ANA_NONOPTIMIZED)
>   			found = ns;
> @@ -445,7 +449,8 @@ static struct nvme_ns *nvme_queue_depth_path(struct nvme_ns_head *head)
>   static inline bool nvme_path_is_optimized(struct nvme_ns *ns)
>   {
>   	return nvme_ctrl_state(ns->ctrl) == NVME_CTRL_LIVE &&
> -		ns->ana_state == NVME_ANA_OPTIMIZED;
> +		ns->ana_state == NVME_ANA_OPTIMIZED &&
> +		!nvme_ctrl_is_marginal(ns->ctrl);
>   }
>   
>   static struct nvme_ns *nvme_numa_path(struct nvme_ns_head *head)
> diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
> index 7df2ea21851f..71a5c5f87db6 100644
> --- a/drivers/nvme/host/nvme.h
> +++ b/drivers/nvme/host/nvme.h
> @@ -275,6 +275,7 @@ enum nvme_ctrl_flags {
>   	NVME_CTRL_SKIP_ID_CNS_CS	= 4,
>   	NVME_CTRL_DIRTY_CAPABILITY	= 5,
>   	NVME_CTRL_FROZEN		= 6,
> +	NVME_CTRL_MARGINAL		= 7,
>   };
>   
>   struct nvme_ctrl {
> @@ -417,6 +418,11 @@ static inline enum nvme_ctrl_state nvme_ctrl_state(struct nvme_ctrl *ctrl)
>   	return READ_ONCE(ctrl->state);
>   }
>   
> +static inline bool nvme_ctrl_is_marginal(struct nvme_ctrl *ctrl)
> +{
> +	return test_bit(NVME_CTRL_MARGINAL, &ctrl->flags);
> +}
> +
>   enum nvme_iopolicy {
>   	NVME_IOPOLICY_NUMA,
>   	NVME_IOPOLICY_RR,

