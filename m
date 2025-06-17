Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2EC4CA6F
	for <linux-scsi@vger.kernel.org>; Tue, 17 Jun 2025 07:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750145141; cv=none; b=r4BcD012pK3yiU9+nwt+4vAl8K04FiE1FlYK7zroY7nzPpZT6FfEMd2gmtVDUkeaRsHgbQpI7RO4BKql1YVoqZv57W/kpu+kkzNRKErvRTZzvFZ7Ncjtlpq9MPe7YVxhiL0TbRRIRVXGTOv/0W0eDYgfvdg9+QIl8axt4qsBg+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750145141; c=relaxed/simple;
	bh=Pbj3vJHvkhc3w1ktwr4/JfCbq1mnFSis2rU+He7Fek8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EO6qJZfdVL+d8MDAZCTMOoS9TDQ77bSnT/AjuR7nrdf3ltPy7/Xpe0xLjLeuRVWJx6aNPben8bJqoRGre6HecfIax43GmHZUqy239nVYITnVN5CfmXel+Pn2mNxVXFUcdP70dd9ApLRv1UOUjzxO74R9/DWfS2jxuG+iXvjxS7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G2bc68Y0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G2bc68Y0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750145138;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tRhdOYnZijUDFTbLchYF+k1cCB2nXXbuhiNRlKP9kcA=;
	b=G2bc68Y0IFAOmGZ+kpkKiE6UD8j0xjJFZxcw0wJGBrmooSmKkfdeqteWiEgCwmumV7hxcY
	GW2hmOb2ImVQxkAuf6Ehfd08XyKyR985uZkLgDZBDnqbkY4/HnJKN4YhC69/qJ5+nnP0Py
	wFkXcwtIzwrNSaxKKvlWlGYfUfgTt2A=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-259-dzcPNCogMRuMAz-WLh7S6g-1; Tue,
 17 Jun 2025 03:25:34 -0400
X-MC-Unique: dzcPNCogMRuMAz-WLh7S6g-1
X-Mimecast-MFC-AGG-ID: dzcPNCogMRuMAz-WLh7S6g_1750145133
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E3CDA195609F;
	Tue, 17 Jun 2025 07:25:32 +0000 (UTC)
Received: from fedora (unknown [10.72.116.143])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6064530002C3;
	Tue, 17 Jun 2025 07:25:26 +0000 (UTC)
Date: Tue, 17 Jun 2025 15:25:21 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, "Ewan D. Milne" <emilne@redhat.com>,
	Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH] scsi: storvsc: set max_segment_size as UINT_MAX
 explicitly
Message-ID: <aFEYYSCREiCMGBAH@fedora>
References: <20250616160509.52491-1-ming.lei@redhat.com>
 <20250617050240.GA2178@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250617050240.GA2178@lst.de>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Tue, Jun 17, 2025 at 07:02:40AM +0200, Christoph Hellwig wrote:
> Please try this proper fix instead:
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index e021f1106bea..09f5fb5b2fb1 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -473,7 +473,9 @@ struct Scsi_Host *scsi_host_alloc(const struct scsi_host_template *sht, int priv
>  	else
>  		shost->max_sectors = SCSI_DEFAULT_MAX_SECTORS;
>  
> -	if (sht->max_segment_size)
> +	if (sht->virt_boundary_mask)
> +		shost->virt_boundary_mask = sht->virt_boundary_mask;
> +	else if (sht->max_segment_size)
>  		shost->max_segment_size = sht->max_segment_size;
>  	else
>  		shost->max_segment_size = BLK_MAX_SEGMENT_SIZE;

This way works, but I prefer to set it explicitly in driver, instead of
making block layer more fragile to deal with def ->max_segment_size
if ->virt_boundary_mask is defined

- for low level driver, if ->virt_boundary_mask is defined, ->max_segment_size
should be UINT_MAX obviously since it implies single `virt segment`.
Setting UINT_MAX in driver has document benefit too.

- for logical block device(md, dm, ...), both ->virt_boundary_mask and
->max_segment_size may be set, and it is fine since logical block device
driver needn't to deal with sg


Thanks,
Ming

