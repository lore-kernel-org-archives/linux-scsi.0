Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E3E0351C18
	for <linux-scsi@vger.kernel.org>; Wed,  4 Mar 2026 06:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772604839; cv=none; b=mA3OB9aPxGRnF8n9Gdd05U35hC0Ve4SJ01szbMTUu9pJndAGtPf0g1T8vn9Qsj0wMgeYqzhG94UJ35sspsNetJI6JLhDNksuwvQBKyy4nergrGApd9vAMiFr2uGrjuToWd2hIU3PAl3pvozsVtlPJPbeHcK9nYIHn10+thWQ5q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772604839; c=relaxed/simple;
	bh=gqXRrFTZaqcVbrfVc+/wuwQR8f0xb49c1Wd6BXvdxFE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TbEbENaK9ATq2GQEhJ141SzEk7ixysNGT/vQWK1rpBUWaRGaqybms7lxc2QNOYpmAvIZO4J0n/qn8jV+GbFS+3GIBmOtlzLq8V9Sh+Jvz3EqaxHnJqWkQfFn1BzabCk7AiaOQVgUlWgebY78aCbshx6OIgIadUj2bmjG2jT3NJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HkFYOMZE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HkFYOMZE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772604837;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hifhB8EKHJQ7PQPYx3jR5aKs6hdV4ehfn0Z4JLP6Nxg=;
	b=HkFYOMZEgI5NR5c9K7j7g9MQnmwmpwNPt1Ns4Q9BdtFNMDIq8j6cLScdq1jYRM9gRt/m4b
	u8RwjjaSBJR8z6AskcgaVdZ5LgwL7Gk7nSOD9ivWA//wrvvA3rB4vJ0RQl/Q6zNEXMTRli
	P2ZhY0ul5bGl7gipTpFmMng5dCoUn5k=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-447-QBsmGE1QP9ycB549mn9zFQ-1; Wed,
 04 Mar 2026 01:13:54 -0500
X-MC-Unique: QBsmGE1QP9ycB549mn9zFQ-1
X-Mimecast-MFC-AGG-ID: QBsmGE1QP9ycB549mn9zFQ_1772604832
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D94C7195609F;
	Wed,  4 Mar 2026 06:13:50 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0873D18002A6;
	Wed,  4 Mar 2026 06:13:49 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 6246Dm4e1917917
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 4 Mar 2026 01:13:48 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 6246Dmhf1917916;
	Wed, 4 Mar 2026 01:13:48 -0500
Date: Wed, 4 Mar 2026 01:13:48 -0500
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
Message-ID: <aafNnO6o2yoeLjPs@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

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
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 7ed0defc8161e..61179caa7b2c8 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -654,6 +654,8 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
>  	 */
>  	destroy_rcu_head(&cmd->rcu);
>  
> +	scsi_mpath_end_request(req);
> +
>  	/*
>  	 * In the MQ case the command gets freed by __blk_mq_end_request,
>  	 * so we have to do all cleanup that depends on it earlier.

This looks wrong. We start accounting in scsi_queue_rq(), and we need to
end it whenever we complete or requeue the request, otherwise the
accounting will get off. But not all requests go through
scsi_end_request(). scsi_mpath_failover_req(), for instance, calls
blk_mq_end_request() directly, and other functions, like
scsi_queue_insert() call blk_mq_requeue_request(). I'm pretty sure that
this should go in scsi_complete(), as well in the error path of
scsi_queue_rq().

-Ben

