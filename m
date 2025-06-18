Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19ED22FEE03
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jun 2025 17:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750267288; cv=none; b=Hr3isusNZFqapOvB/Irf0vKmL2IPIQ+QORCXhQRVshopcx7x/4zqa8OMT4dtnhkWtFC9hf6cfUWTaICoQsvHFJHpFHF81C7ag9Mnxy4t6lXy+l38BQDrha/2Fyz7tiqukErvifpM2LHMtx4kKf4H/Lf//6H9T0xfhp+48xjn+kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750267288; c=relaxed/simple;
	bh=OddQ3mc3GKLzvGmWgpK8T6AGc4plYh2LG3rxCQeyyQU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X60mpfwJCFHm4y21q/RFr33Pmb/y+z75HybWK2bAkhGIhwVMHZv0Wg/e0T9+v9VZuG916rCvxB7x1RwPqif4skhVapHP90s1txKXizH2nrMnREJXMF1dIwBzfiY7dXlTn/+r5Cf0spFy2j6kS38Om3/6rllx2Ndd0JUEaxpWDxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PZZ4V9A3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PZZ4V9A3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750267286;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YG8r/IIYIdyHl5tXRTBVltid870q8yTl316BdHq9fAQ=;
	b=PZZ4V9A3iK3kKSMlevxKwZkMFO4JxYZosmNnefHc0G1nIJARyA5XkDfIFb2wANjPRe1/DA
	OV8+1FroTxYTDUHBQk8kHbCbFrBBInwPBxOWKAE/uhmt2ykJzPc2T57INz/plE32x3jUwj
	wY5GvPysPT5mGP2TOOC1Ynx5iGdn+kE=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-372-3QsPROwCOJqz8eLqL7gKUA-1; Wed,
 18 Jun 2025 13:21:22 -0400
X-MC-Unique: 3QsPROwCOJqz8eLqL7gKUA-1
X-Mimecast-MFC-AGG-ID: 3QsPROwCOJqz8eLqL7gKUA_1750267278
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2626019560B2;
	Wed, 18 Jun 2025 17:21:18 +0000 (UTC)
Received: from [10.22.64.21] (unknown [10.22.64.21])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0CF38195E346;
	Wed, 18 Jun 2025 17:21:14 +0000 (UTC)
Message-ID: <2dfb3baf-00c9-456a-9411-330b2fd7cba4@redhat.com>
Date: Wed, 18 Jun 2025 13:21:13 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/4] scsi: fnic: Turn off FDMI ACTIVE flags on link
 down
To: Karan Tilak Kumar <kartilak@cisco.com>, sebaddel@cisco.com
Cc: arulponn@cisco.com, djhawar@cisco.com, gcboffa@cisco.com,
 mkai2@cisco.com, satishkh@cisco.com, aeasi@cisco.com, jejb@linux.ibm.com,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, revers@redhat.com, dan.carpenter@linaro.org,
 stable@vger.kernel.org
References: <20250618003431.6314-1-kartilak@cisco.com>
 <20250618003431.6314-2-kartilak@cisco.com>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20250618003431.6314-2-kartilak@cisco.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Reviewed-by: John Meneghini <jmeneghi@redhat.com>

On 6/17/25 8:34 PM, Karan Tilak Kumar wrote:
> When the link goes down and comes up, FDMI requests are not sent out
> anymore.
> Fix bug by turning off FNIC_FDMI_ACTIVE when the link goes down.
> 
> Fixes: 09c1e6ab4ab2 ("scsi: fnic: Add and integrate support for FDMI")
> Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
> Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
> Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
> Reviewed-by: Arun Easi <aeasi@cisco.com>
> Tested-by: Karan Tilak Kumar <kartilak@cisco.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
> ---
> Changes between v5 and v6:
>      - Incorporate review comments from John:
> 	- Rebase patches on 6.17/scsi-queue
> 
> Changes between v4 and v5:
>      - Incorporate review comments from John:
> 	- Refactor patches
> 	- Increment driver version number
> 
> Changes between v3 and v4:
>      - Incorporate review comments from Dan:
> 	- Remove comments from Cc tag
> 
> Changes between v2 and v3:
>      - Incorporate review comments from Dan:
> 	- Add Cc to stable
> 
> Changes between v1 and v2:
>      - Incorporate review comments from Dan:
> 	- Add Fixes tag
> ---
>   drivers/scsi/fnic/fdls_disc.c | 9 ++++++---
>   drivers/scsi/fnic/fnic.h      | 2 +-
>   2 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
> index 36b498ad55b4..fa9cf0b37d72 100644
> --- a/drivers/scsi/fnic/fdls_disc.c
> +++ b/drivers/scsi/fnic/fdls_disc.c
> @@ -5029,9 +5029,12 @@ void fnic_fdls_link_down(struct fnic_iport_s *iport)
>   		fdls_delete_tport(iport, tport);
>   	}
>   
> -	if ((fnic_fdmi_support == 1) && (iport->fabric.fdmi_pending > 0)) {
> -		timer_delete_sync(&iport->fabric.fdmi_timer);
> -		iport->fabric.fdmi_pending = 0;
> +	if (fnic_fdmi_support == 1) {
> +		if (iport->fabric.fdmi_pending > 0) {
> +			timer_delete_sync(&iport->fabric.fdmi_timer);
> +			iport->fabric.fdmi_pending = 0;
> +		}
> +		iport->flags &= ~FNIC_FDMI_ACTIVE;
>   	}
>   
>   	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
> diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
> index 86e293ce530d..c2fdc6553e62 100644
> --- a/drivers/scsi/fnic/fnic.h
> +++ b/drivers/scsi/fnic/fnic.h
> @@ -30,7 +30,7 @@
>   
>   #define DRV_NAME		"fnic"
>   #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
> -#define DRV_VERSION		"1.8.0.1"
> +#define DRV_VERSION		"1.8.0.2"
>   #define PFX			DRV_NAME ": "
>   #define DFX                     DRV_NAME "%d: "
>   

