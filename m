Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 262A5287245
	for <linux-scsi@vger.kernel.org>; Tue, 15 Jul 2025 17:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752601775; cv=none; b=WBz0pnQ3/4irMhJtwu3uJG4ixUi8EXyARHPvi4fcc3JSUs21Lzjqh5DVzQyGeT9TkMnebgAw4mFZMHsJA2VzpKjOcQzpEFMXP41WA+/hJxAHfIv2+i2I+qmtmdhW7IyI9l+F43EroH62zxWKqkhYFlGGQc7+hzQUkUPPh+kBYqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752601775; c=relaxed/simple;
	bh=1KjMYagADHM/6HPP3ad2dwRKcUpER75SXgfcksOR7mo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hnzb2AG8mVDJZnVMHMHYQi/eao7ua0ZHAEiK4wWnXQYWSJ7RFOu6ql6My8bde/jvuLi3yIfNDuuqSuY06EZrrOdU+11oBDlegataYY/x6wKADiR9PKLRUPNz8uOea5WU9mY+JIlgWgaMYs4xFa69kiDStRiiiWgrW2svms/I1po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Bwwbl8UB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bwwbl8UB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752601773;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DvYoJszPqTOnmrYYbLqgBmKS/MWvoTMwhb6CXYFaSX4=;
	b=Bwwbl8UBodYAgM2sfRFhJZ/Ry0GX6fkzbJgpp+bTWqcQKw1Iw5Y1Hvqr0tFNHNXgsOZWm3
	RA5B/Av7AXPOqM1PQQU7zIaxLVOW6zFkYERtvQ4tjJ10sKmHCo5FS86tq6UBkBuN4MS1Rj
	iudDHzWKiR5O0dejZhFiEZWUfMZyC58=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-685-7vslXh-ZMr2oPZN6Xcz82A-1; Tue,
 15 Jul 2025 13:49:27 -0400
X-MC-Unique: 7vslXh-ZMr2oPZN6Xcz82A-1
X-Mimecast-MFC-AGG-ID: 7vslXh-ZMr2oPZN6Xcz82A_1752601766
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3897F19560B7;
	Tue, 15 Jul 2025 17:49:26 +0000 (UTC)
Received: from my-developer-toolbox-latest (unknown [10.2.16.31])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8929A195609E;
	Tue, 15 Jul 2025 17:49:24 +0000 (UTC)
Date: Tue, 15 Jul 2025 10:49:21 -0700
From: Chris Leech <cleech@redhat.com>
To: Showrya M N <showrya@chelsio.com>
Cc: lduncan@suse.com, michael.christie@oracle.com,
	martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
	bharat@chelsio.com
Subject: Re: [PATCH for-rc] scsi: libiscsi: initialize iscsi_conn->dd_data
 only if memory is allocated
Message-ID: <aHaUoRFbpnjkQFYD@my-developer-toolbox-latest>
References: <20250627112329.19763-1-showrya@chelsio.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250627112329.19763-1-showrya@chelsio.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Fri, Jun 27, 2025 at 04:53:29PM +0530, Showrya M N wrote:
> In case of an ib_fast_reg_mr allocation failure during iSER setup,
> the machine hits a panic because iscsi_conn->dd_data is initialized
> unconditionally, even when no memory is allocated (dd_size == 0).
> This leads invalid pointer dereference during connection teardown.
> 
> Fix by setting iscsi_conn->dd_data only if memory is actually allocated.

iser is allocating the iser_conn along with the endpoint, and
dynamically updating iscsi_conn->dd_data to track that allocation.
That's different from all the other libiscsi drivers which allocate a
fixed sized driver area with every iscsi_conn.

I don't see any problem with conditionally setting iscsi_conn->dd_data,
and it makes sense to not have an invalid pointer for a 0 size request.

iscsi_iser_conn_stop already has the checks for a NULL dd_data for this
case of a bind failure, so that looks OK.

Signed-off-by: Chris Leech <cleech@redhat.com>

> Panic trace:
> ------------
>  iser: iser_create_fastreg_desc: Failed to allocate ib_fast_reg_mr err=-12
>  iser: iser_alloc_rx_descriptors: failed allocating rx descriptors / data buffers
>  BUG: unable to handle page fault for address: fffffffffffffff8
>  RIP: 0010:swake_up_locked.part.5+0xa/0x40
>  Call Trace:
>   complete+0x31/0x40
>   iscsi_iser_conn_stop+0x88/0xb0 [ib_iser]
>   iscsi_stop_conn+0x66/0xc0 [scsi_transport_iscsi]
>   iscsi_if_stop_conn+0x14a/0x150 [scsi_transport_iscsi]
>   iscsi_if_rx+0x1135/0x1834 [scsi_transport_iscsi]
>   ? netlink_lookup+0x12f/0x1b0
>   ? netlink_deliver_tap+0x2c/0x200
>   netlink_unicast+0x1ab/0x280
>   netlink_sendmsg+0x257/0x4f0
>   ? _copy_from_user+0x29/0x60
>   sock_sendmsg+0x5f/0x70
> 
> Signed-off-by: Showrya M N <showrya@chelsio.com>
> Signed-off-by: Potnuri Bharat Teja <bharat@chelsio.com>
> ---
>  drivers/scsi/libiscsi.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 392d57e054db..c9f410c50978 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -3185,7 +3185,8 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_session, int dd_size,
>  		return NULL;
>  	conn = cls_conn->dd_data;
>  
> -	conn->dd_data = cls_conn->dd_data + sizeof(*conn);
> +	if (dd_size)
> +		conn->dd_data = cls_conn->dd_data + sizeof(*conn);
>  	conn->session = session;
>  	conn->cls_conn = cls_conn;
>  	conn->c_stage = ISCSI_CONN_INITIAL_STAGE;
> -- 
> 2.39.3
> 

