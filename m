Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 211292E92B3
	for <linux-scsi@vger.kernel.org>; Mon, 30 Mar 2026 02:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774836791; cv=none; b=qy1EP1A6tfu2YbdAxHClKd8A5ZPSfARAWvZ1o3qiJB579aYCduRpnsL+/nwb3lo73f/UruYSsruXWXhDxPiSYC2d0SmHJRnDmIq3qjw/2VskQRATo6TOLiPxImHtYUU+w5DP3dUskzBdQ/4A9MjqxKA71Y0zMgOC1pGm0h6Crow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774836791; c=relaxed/simple;
	bh=vrzSyHaslq3MSiXPuC7FSAAC4qvh97I27PRanA5teso=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dWy7f7iuygiLcSa9BYt9zwIgkKOv7eviHxsVH+J1NNwO+k2pZx8JPLLCMXanJSVZICuofdpBQmOeVVFK9F8376QVTosCUnmuj/B0I6B6w9DQGfdyeDkg7YoO71cKu1Laa1tkuH0oyilWs3OBI+iwvuCjS9BImEm4nIbp9lVIdkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OhZQ9ACq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OhZQ9ACq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774836786;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GYl0Gfx1l/S4PpzJS9mjyQT83t+lS+RXkxvjtJf7FQE=;
	b=OhZQ9ACqliH7wvA2TLQCcgJRQ0MfKA2SnpyMFuJJasZwishAoT8P2gqYRwM5YnHoTs5Ufb
	pZGPF9vXphcyWFb8H+VdnzarfThC+oC5pyRDU/TgAjFXQy7aCnfSXrQRqb+v+OVLaHuPDe
	0VqfhXj9ZDHPSEaNLA5Kq4nwznK5EUM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-194-y-rX6CFkOo-dZBIN4EfKeg-1; Sun,
 29 Mar 2026 22:13:03 -0400
X-MC-Unique: y-rX6CFkOo-dZBIN4EfKeg-1
X-Mimecast-MFC-AGG-ID: y-rX6CFkOo-dZBIN4EfKeg_1774836782
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 72F57195608D;
	Mon, 30 Mar 2026 02:13:01 +0000 (UTC)
Received: from fedora (unknown [10.72.116.5])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ED88019560AB;
	Mon, 30 Mar 2026 02:12:56 +0000 (UTC)
Date: Mon, 30 Mar 2026 10:12:51 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Yang Xiuwei <yangxiuwei@kylinos.cn>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
	John Garry <john.g.garry@oracle.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3] scsi: sd: fix missing put_disk() when
 device_add(&disk_dev) fails
Message-ID: <acncI-IZhtdDsmJg@fedora>
References: <20260330014952.152776-1-yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330014952.152776-1-yangxiuwei@kylinos.cn>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Mon, Mar 30, 2026 at 09:49:52AM +0800, Yang Xiuwei wrote:
> If device_add(&sdkp->disk_dev) fails, put_device() runs
> scsi_disk_release(), which frees the scsi_disk but leaves the gendisk
> referenced. The device_add_disk() error path in sd_probe() calls
> put_disk(gd); call put_disk(gd) here to mirror that cleanup.
> 
> Fixes: 265dfe8ebbab ("scsi: sd: Free scsi_disk device via put_device()")
> Cc: stable@vger.kernel.org
> Reviewed-by: John Garry <john.g.garry@oracle.com>
> Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
> ---
> v2: Add Fixes: and Cc: stable; add a short note on how the issue was found.
> v3: Commit message and subject refined per review; add Reviewed-by from John Garry.
> 
>  drivers/scsi/sd.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 628a1d0a74ba..aba22060fcd5 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -4018,6 +4018,7 @@ static int sd_probe(struct scsi_device *sdp)
>  	error = device_add(&sdkp->disk_dev);
>  	if (error) {
>  		put_device(&sdkp->disk_dev);
> +		put_disk(gd);
>  		goto out;
>  	}

Another fix is to clear `sdkp` and `goto out_put`:

- clearing `sdkp` because the device is released already, and this way is `memory safe`
- `goto out_put` can release disk centrally



Thanks,
Ming

