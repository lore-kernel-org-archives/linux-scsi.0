Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5A625DD1E
	for <linux-scsi@vger.kernel.org>; Thu,  5 Mar 2026 02:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772678252; cv=none; b=tSHAPBHFfKS4pCwcJEzsqx1LRNAu3pnq3cxQaAk2JayGXMz23Udy0v8yWronnKB0KcrTOeUXnrvVx37WnCoEIVGBVm3AFqsuCmN/SQLSsll5JK/G7J5NsCSE82qyCgTxKL01hnspMlNHEio1AmsdCu1uPMAEZFkQI3ZKWVP2PLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772678252; c=relaxed/simple;
	bh=Zrg3xQuzRFUmRFcIu7kcHq6e2o8cqc90mKbBofbKzTI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b1jOJzfQv7EYlWRCtPV+PaUuD8fDfVLRvWQomkr9f5/4i5T0xFBk535NlFyfB2SJJUQZmV4SmgaVTHmAaldEbHtQR/enerzPf71X0dpXqe5SWC/gc7R4AWNlDGJ0W0tkCwP8pFhcQ5y5A1riPS05fwen0IgfGKHIa5KdqguDYdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WkVZ2TIo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WkVZ2TIo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772678249;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yBUhNsBoeECXQ2g42ZbRUoURW/9mr3wjydrCeND0ozI=;
	b=WkVZ2TIos7vMR8datonuO+xUMd5g68v0iIl7OkrywObdeGPWib0vi9+A8peTwq3UGM/E9A
	HXU/V7rrtBYvtNmG94NaXaIO7cVNlw+MMg7wvJey5u5tXR+TFA1J5fi+kQVBizczgB6adB
	IhPtQwd2/bko5uPmlVIkqBE1Oy7p8Jg=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-408-gnIwOrr_MGynkDKdRAbF8A-1; Wed,
 04 Mar 2026 21:37:26 -0500
X-MC-Unique: gnIwOrr_MGynkDKdRAbF8A-1
X-Mimecast-MFC-AGG-ID: gnIwOrr_MGynkDKdRAbF8A_1772678244
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 19BF119560A5;
	Thu,  5 Mar 2026 02:37:23 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DEF321800671;
	Thu,  5 Mar 2026 02:37:21 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 6252bKqD1952898
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 4 Mar 2026 21:37:20 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 6252bIIF1952897;
	Wed, 4 Mar 2026 21:37:18 -0500
Date: Wed, 4 Mar 2026 21:37:18 -0500
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
Message-ID: <aajsXqau3gHFIqVG@redhat.com>
References: <20260225153627.1032500-1-john.g.garry@oracle.com>
 <20260225153627.1032500-11-john.g.garry@oracle.com>
 <aafNnO6o2yoeLjPs@redhat.com>
 <93752514-3225-4cdf-b9a5-e0964d693b5b@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93752514-3225-4cdf-b9a5-e0964d693b5b@oracle.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Wed, Mar 04, 2026 at 11:11:08AM +0000, John Garry wrote:
> On 04/03/2026 06:13, Benjamin Marzinski wrote:
> > > +	scsi_mpath_end_request(req);
> > > +
> > >   	/*
> > >   	 * In the MQ case the command gets freed by __blk_mq_end_request,
> > >   	 * so we have to do all cleanup that depends on it earlier.
> > This looks wrong. We start accounting in scsi_queue_rq(), and we need to
> > end it whenever we complete or requeue the request, otherwise the
> > accounting will get off. But not all requests go through
> > scsi_end_request(). scsi_mpath_failover_req(), for instance, calls
> > blk_mq_end_request() directly, and other functions, like
> > scsi_queue_insert() call blk_mq_requeue_request(). I'm pretty sure that
> > this should go in scsi_complete(), as well in the error path of
> > scsi_queue_rq().
> 
> ok, let me check that further.
> 

I think I was a little hasty here. Looking at sd_mpath_start_command()
and sd_mpath_end_command() in patch 17, I can see that they protect
against repeat calls, so requeueing the request should be o.k. There's
still a problem when scsi_mpath_failover_req() calls blk_mq_end_request()
directly, and when scsi_queue_rq() exits with a failure where the
request won't requeued (all the returns except BLK_STS_OK,
BLK_STS_RESOURCE, and BLK_STS_DEV_RESOURCE).

-Ben

> Thanks for the notice.

