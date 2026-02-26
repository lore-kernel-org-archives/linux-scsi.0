Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08427278753
	for <linux-scsi@vger.kernel.org>; Thu, 26 Feb 2026 02:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772072196; cv=none; b=cxABcFUnENaZSGXG4viWO2QXBFFafkLRNnm6bUee3aeOc+WbOnRbVharj6IywoAv/7jpYXm6uOND5oqZ+offJtHD1FMif5+qte8XKglWw7Qsaain2HRNvPFELKpch/bzRc3i6aWgqt1lb3l3y/oToD5ik6O3A+LR01f/4HFxNis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772072196; c=relaxed/simple;
	bh=RVmoPkXlFbz9EbpwqjvzIV3GDq3ozZDDazmcIJOSNnQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rWu3nAP2xvGjoiJMi6hC+c52QOBjAI+JnywudXUJrzLpiqIpWtDrzq1V24RIOHHXE60hPMsHQX271GdtPGZCGFB5lPmYZFeexih3Zv00MjFLjo4UwXyzkNEH1+0LV9FMv50KRpaGqWLVJIQkW45qFHglFnOIISf4Y1aAU0bOF9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gI+pPS8S; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gI+pPS8S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772072194;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hJmYuxjS0nD2lV0lsEQm+chlolOaID++/wSzcaTxkiM=;
	b=gI+pPS8SRqeg08WWx13yJ73L3LDIxGMj9rNnGfNgeHyh0Gx0iMvE7x1GJLRdkF6LiWU6/Y
	fs+EOo0uN+V0eHafSa58QHHlMySXp1thsXD/nruIIHArDWFuO9dhGjhvwvavw43sHkV8e6
	b0KDp4xSqFT987vTx0jw4B/otJl8oU4=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-684-kv6YtGLNMKaescy-QcRm1g-1; Wed,
 25 Feb 2026 21:16:30 -0500
X-MC-Unique: kv6YtGLNMKaescy-QcRm1g-1
X-Mimecast-MFC-AGG-ID: kv6YtGLNMKaescy-QcRm1g_1772072188
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EDDCC180057E;
	Thu, 26 Feb 2026 02:16:27 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DA4D13003D88;
	Thu, 26 Feb 2026 02:16:26 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 61Q2GPtm1678244
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 25 Feb 2026 21:16:25 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 61Q2GO3e1678243;
	Wed, 25 Feb 2026 21:16:24 -0500
Date: Wed, 25 Feb 2026 21:16:24 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: John Garry <john.g.garry@oracle.com>
Cc: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/13] libmultipath: Add basic gendisk support
Message-ID: <aZ-s-JNWBOA1xqVG@redhat.com>
References: <20260225153225.1031169-1-john.g.garry@oracle.com>
 <20260225153225.1031169-3-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225153225.1031169-3-john.g.garry@oracle.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Wed, Feb 25, 2026 at 03:32:14PM +0000, John Garry wrote:
> Add support to allocate and free a multipath gendisk.
> 
> NVMe has almost like-for-like equivalents here:
> - mpath_alloc_head_disk() -> nvme_mpath_alloc_disk()
> - multipath_partition_scan_work() -> nvme_partition_scan_work()
> - mpath_remove_disk() -> nvme_remove_head()
> - mpath_device_set_live() -> nvme_mpath_set_live()
> 
> struct mpath_head_template is introduced as a method for drivers to
> provide custom multipath functionality.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
> +
> +void mpath_device_set_live(struct mpath_disk *mpath_disk,
> +			struct mpath_device *mpath_device)
> +{
> +	struct mpath_head *mpath_head = mpath_disk->mpath_head;

You're dereferencing mpath_disk here, before the check if it's NULL.

-Ben

> +	int ret;
> +
> +	if (!mpath_disk)
> +		return;
> +
> +	if (!test_and_set_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags)) {
> +		dev_set_drvdata(disk_to_dev(mpath_disk->disk), mpath_disk);
> +		ret = device_add_disk(mpath_disk->parent, mpath_disk->disk,
> +				mpath_head->mpdt->device_groups);
> +		if (ret) {
> +			clear_bit(MPATH_HEAD_DISK_LIVE, &mpath_head->flags);
> +			return;
> +		}
> +		queue_work(mpath_wq, &mpath_disk->partition_scan_work);
> +	}
> +}
> +EXPORT_SYMBOL_GPL(mpath_device_set_live);
> +
>  struct mpath_head *mpath_alloc_head(void)
>  {
>  	struct mpath_head *mpath_head;
> -- 
> 2.43.5

