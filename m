Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F186295D91
	for <linux-scsi@vger.kernel.org>; Wed, 13 Aug 2025 21:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755119051; cv=none; b=h8qxXOn6WBulynjOgSx6WWRR2cfTaLAGSAegNkRe2WF2AQdhUENIHeS3sIwKoJTHtiLgZ5ZbwsrOrKvTnqm+q0Zt0f02PiwVMbjV6ZVV6mmiQlW9fn6LgNAm8Jz8CVdN11Jhif2SWlnrS0CJq1mZYwHQc78i+SKXb+8vcENLzXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755119051; c=relaxed/simple;
	bh=pJ5SG/gVCM5zHaWFcO/fRUN+eik4jFTHbZmnyuFVjW4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hrkQO13UGBfVucYkGYi+/kTHg8LGTrFw8BFTO2csywMMb7XeX9euTTHvoeAvcUSh2p4OE/f22N50kiOT4R3SXJNeVAAXbesHHwSJML0mu5ll+ZqxayKhWKBvtslheJIAp4IcsNnJZJwEwXRnYDyBq0oOljLxFg8PO/+UUfBMsgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PmhlE8ys; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PmhlE8ys"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755119049;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Z3vCnaIRAN9mFjSHaEHuq2UqB/P8rLKZjWPINyl1gkQ=;
	b=PmhlE8yshkvWP4JDXmKCQo5oeHlrpurE4iRrAeQtk02LJl0sCPRo78OMtP2e5Eqd8yiBNt
	n55VELBxXJU0c+ZNc7/fMWmLs1NYRGetGGT9KLijeSqnGTUu1BXufZOBPWWMoaouNZAT66
	pFjL3minBbYMavB94qna3t1sAYS3v1M=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-265-RTt8HLflO8q5AZNBoQcc5g-1; Wed,
 13 Aug 2025 17:04:05 -0400
X-MC-Unique: RTt8HLflO8q5AZNBoQcc5g-1
X-Mimecast-MFC-AGG-ID: RTt8HLflO8q5AZNBoQcc5g_1755119043
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4D07719560B5;
	Wed, 13 Aug 2025 21:04:03 +0000 (UTC)
Received: from my-developer-toolbox-latest (unknown [10.2.17.22])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1CF753001452;
	Wed, 13 Aug 2025 21:03:59 +0000 (UTC)
Date: Wed, 13 Aug 2025 14:03:57 -0700
From: Chris Leech <cleech@redhat.com>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>,
	Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	James Bottomley <JBottomley@parallels.com>,
	Ravi Anand <ravi.anand@qlogic.com>, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: qla4xxx: Prevent a potential error pointer
 dereference
Message-ID: <aJz9vY0sGj2a98kE@my-developer-toolbox-latest>
References: <aJwnVKS9tHsw1tEu@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJwnVKS9tHsw1tEu@stanley.mountain>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Wed, Aug 13, 2025 at 08:49:08AM +0300, Dan Carpenter wrote:
> The qla4xxx_get_ep_fwdb() function is supposed to return NULL on error,
> but qla4xxx_ep_connect() returns error pointers.  Propagating the error
> pointers will lead to an Oops in the caller, so change the error
> pointers to NULL.

Looks right to me.

Reviewed-by: Chris Leech <cleech@redhat.com>

> Fixes: 13483730a13b ("[SCSI] qla4xxx: fix flash/ddb support")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---
>  drivers/scsi/qla4xxx/ql4_os.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
> index a39f1da4ce47..a761c0aa5127 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -6606,6 +6606,8 @@ static struct iscsi_endpoint *qla4xxx_get_ep_fwdb(struct scsi_qla_host *ha,
>  
>  	ep = qla4xxx_ep_connect(ha->host, (struct sockaddr *)dst_addr, 0);
>  	vfree(dst_addr);
> +	if (IS_ERR(ep))
> +		return NULL;
>  	return ep;
>  }
>  
> -- 
> 2.47.2
> 

