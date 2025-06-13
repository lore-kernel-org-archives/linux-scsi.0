Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F093231832
	for <linux-scsi@vger.kernel.org>; Fri, 13 Jun 2025 20:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749846538; cv=none; b=m+Slw8MKXuwHaDpA3cVTPEwjuYsUj3Zkxv3r4Hx7V2DaOOVxwTm2IFzpeFWG4MF0qo4Q6VY3umFb0jxr+OkjbLy6jf3dgyEA9KrnA7Te356u4f1MF8nZ59rhQnMVUaYAfFjuW6N5xzmdCV+sTtOIu200OvyMqhnp6Kyo3/2/wKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749846538; c=relaxed/simple;
	bh=0C7rucsi2wDNfOlT2f1f4Cf3XdF6x8PbTkvIGXjNy40=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=egAXCGrHyLiexWhW++RUE1muFh7al3XRI90Rst0Z5qi6+Qy7NJH+kJEVIKPLALVPE1eqIoX9Ae0JyCcvxYFfJVcNRTyDdF1rXE0b68gUWw9BwVmbEcjbr4qh55tTyxEBl20RnTDXCffcGTT0mPXtfd9DqMjyG+37vE6wHSZsYWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CrMrnXi1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CrMrnXi1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749846536;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TizfHzI50YnSZlKybyqCNDP5fZpWaKGNKEQ9XDSpq2w=;
	b=CrMrnXi1EjKGjp+VHTZWeyNdUfPIViSyzcYFIg0AuXgntfjUyDo6s/woT4XUIiLJhZeyBS
	uLJDOa/AbActbeN5uL9BdOGylZRVbCTjEoKV8JaRJruMZn6w+qt0Wu1vyMn+KR7oNalC1S
	bS41lAq7YhbCm2TiA++cMYqq3F/yaaw=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-66-UJ1Xa6KVNceOYHD-Rug-1g-1; Fri,
 13 Jun 2025 16:28:52 -0400
X-MC-Unique: UJ1Xa6KVNceOYHD-Rug-1g-1
X-Mimecast-MFC-AGG-ID: UJ1Xa6KVNceOYHD-Rug-1g_1749846531
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AA42E1956046;
	Fri, 13 Jun 2025 20:28:50 +0000 (UTC)
Received: from [10.22.89.154] (unknown [10.22.89.154])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 770F41956050;
	Fri, 13 Jun 2025 20:28:47 +0000 (UTC)
Message-ID: <7a33bd90-7f1b-49ad-b24c-1808073f7f5e@redhat.com>
Date: Fri, 13 Jun 2025 16:28:46 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/5] scsi: fnic: Turn off FDMI ACTIVE flags on link
 down
To: Karan Tilak Kumar <kartilak@cisco.com>, sebaddel@cisco.com
Cc: arulponn@cisco.com, djhawar@cisco.com, gcboffa@cisco.com,
 mkai2@cisco.com, satishkh@cisco.com, aeasi@cisco.com, jejb@linux.ibm.com,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, revers@redhat.com, dan.carpenter@linaro.org,
 stable@vger.kernel.org
References: <20250612221805.4066-1-kartilak@cisco.com>
 <20250612221805.4066-4-kartilak@cisco.com>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20250612221805.4066-4-kartilak@cisco.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Hi Karan.

You've got two patches in this series with the same Fixes: tag.

[PATCH v4 2/5] scsi: fnic: Fix crash in fnic_wq_cmpl_handler when FDMI times out
Fixes: 09c1e6ab4ab2 ("scsi: fnic: Add and integrate support for FDMI")

[PATCH v4 4/5] scsi: fnic: Turn off FDMI ACTIVE flags on link down
Fixes: 09c1e6ab4ab2 ("scsi: fnic: Add and integrate support for FDMI")

both of these patches modify the same file:

   drivers/scsi/fnic/fdls_disc.c

So I recommend you squash patch 4/5 and patch 2/5 into one.

Thanks,

/John

On 6/12/25 6:18 PM, Karan Tilak Kumar wrote:
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
>   1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
> index 9e9939d41fa8..14691db4d5f9 100644
> --- a/drivers/scsi/fnic/fdls_disc.c
> +++ b/drivers/scsi/fnic/fdls_disc.c
> @@ -5078,9 +5078,12 @@ void fnic_fdls_link_down(struct fnic_iport_s *iport)
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

