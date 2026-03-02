Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8669C23C4F2
	for <linux-scsi@vger.kernel.org>; Mon,  2 Mar 2026 04:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772424527; cv=none; b=tffZiMlCcsoKMGcI2ejFxygKzlks1QvbJbAiLoq7nvBiqweasOzP1v6PfkaCOyK/0d0z8YAzbHfwfVWLCLTfzCXkIwzssKgmofvGlHSN9oEBs6zVNj0zArvSN9n0j3+lTzo3On9M8SAD3zkZI5UQ2Cb+BqwDvmKOUNZ1dcsKmX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772424527; c=relaxed/simple;
	bh=ddnR7K08vPwBrR16+xYPOB55dXcC1YG6QcLfS0NeXUU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fkGgNllf+MJZ6X3659XDfO/qVrjV13jgLzi1g/Hs2VpkzK1Ym5FjDpH+in1V94SovIXauD6KGbmRXr2xJBP6/n9XqZkW4LU/8KlDP68bilvlpkTqzONV9MYcT09raGsOcHEQOJZAEyTU/eshK73ze8Gd/FJIymRQucYnAEH2/Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NuU1rBQS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NuU1rBQS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772424524;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NKGcz8tlyCPU7NrDjoUUnPCQmL3iAFi9IJXAqCR6JYs=;
	b=NuU1rBQSWaNDhWlbi59vy8kGBYlFWPMwJXf+QhCQFzgHzP/tJgnUU8ls4YLKq1lSIJEtD4
	fCdsEo8Yx5cMrf5CXdQ0rCe9ifYzlKOHXmzAJjj949gMZA6ojxEIm+e861kUc93wJzqpMK
	vBFSvbChB4ikVmaLZjVo5tbjbqGb7tk=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-464-Q2mNSiM0N7OQD_xm4M8l5A-1; Sun,
 01 Mar 2026 23:08:39 -0500
X-MC-Unique: Q2mNSiM0N7OQD_xm4M8l5A-1
X-Mimecast-MFC-AGG-ID: Q2mNSiM0N7OQD_xm4M8l5A_1772424517
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0330E1956089;
	Mon,  2 Mar 2026 04:08:37 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E984F19560A3;
	Mon,  2 Mar 2026 04:08:35 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 62248YjS1832189
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 1 Mar 2026 23:08:34 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 62248Ype1832188;
	Sun, 1 Mar 2026 23:08:34 -0500
Date: Sun, 1 Mar 2026 23:08:34 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: John Garry <john.g.garry@oracle.com>
Cc: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        hare@suse.com, jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com,
        snitzer@kernel.org, dm-devel@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/24] scsi-multipath: add
 scsi_mpath_{start,end}_request()
Message-ID: <aaUNQgJu8sEx-lsv@redhat.com>
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
 <20260225153627.1032500-11-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225153627.1032500-11-john.g.garry@oracle.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Wed, Feb 25, 2026 at 03:36:13PM +0000, John Garry wrote:
> Add scsi_mpath_{start,end}_request() to handle updating private multipath
> request data, like nvme_mpath_{start,end}_request().
> 
> Since we may need to update mpath_disk data, add a callbacks in
> scsi_driver to actually do this work for the scsi driver.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>  drivers/scsi/scsi_lib.c       |  4 ++++
>  include/scsi/scsi_driver.h    |  2 ++
>  include/scsi/scsi_multipath.h | 24 ++++++++++++++++++++++++
>  3 files changed, 30 insertions(+)
> 
>  	#ifdef CONFIG_SCSI_MULTIPATH
> +	void (*mpath_start_cmd)(struct scsi_cmnd *);
> +	void (*mpath_end_cmd)(struct scsi_cmnd *);
>  	struct mpath_disk *(*to_mpath_disk)(struct request *);
>  	#endif
>  };
> diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
> index 07db217edb085..6cb3107260952 100644
> --- a/include/scsi/scsi_multipath.h
> +++ b/include/scsi/scsi_multipath.h
> @@ -56,6 +56,23 @@ void scsi_mpath_add_sysfs_link(struct scsi_device *sdev);
>  void scsi_mpath_remove_sysfs_link(struct scsi_device *sdev);
>  int scsi_mpath_get_head(struct scsi_mpath_head *);
>  void scsi_mpath_put_head(struct scsi_mpath_head *);
> +
> +static inline void scsi_mpath_start_request(struct request *req)
> +{
> +	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
> +
> +	if (is_mpath_request(req))
> +		scsi_cmd_to_driver(cmd)->mpath_start_cmd(cmd);
> +}
> +
> +static inline void scsi_mpath_end_request(struct request *req)
> +{
> +	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
> +
> +	if (is_mpath_request(req))
> +		scsi_cmd_to_driver(cmd)->mpath_start_cmd(cmd);

Copy-paste error. It should be:

		scsi_cmd_to_driver(cmd)->mpath_end_cmd(cmd);

-Ben

