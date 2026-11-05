Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793901658;
	b=HZdyU689ih+x8tjxfAs98/y1r6nh2Rqr6FzouyrivImrkYA5r2dC9NDtFAozJDzmG0Aw
	 GRTlDDK/sh2K36Brkh82y5HbJEZdlm2C7nE3vOPwBcQ8tELreCn/HwgIzu5FOnZm3aYq3
	 5Vl01rHsONY51pEKsPnW7z3cGGx7/Voj1zX3Fg0dJqm502WlTm69+JyMQZYqIoEyRn86M
	 m0DPAwkFLraSe95Fm+05Aj8J7g7kffK1yzeePX/p0JuaOEMORI93heXK3LL64FNAptrXI
	 ewOwH0WUxb5t1AjKYOeGtUWrBXDqL9c4qfXhtiL6Akja9vSz6QtsoASVee4oHtVV1zw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793901658;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=g6a/eCAlhdtD/I49/xiv15gnKI+R1B4m1qDsdvESCg8=;
	b=Gvl5H2pz+n/ttbxlHDTeWKluaHQ5EBbw80rsOJfo1RuDcdtLyAw91nmWOJIt02QYtGhA
	 qU9SMYjlGcIEtoNH15wzF1GhKYTBFklHcUtRb5P5sZUdoKxgiqPp9knbIxrQPTTf7glRt
	 I+DYvVKqE0pMOD8yWVrr7V3UPMzIQ1yl2Amc0Wf8bhCU+v6KfSTiPv6GNRaMwd1U4l68D
	 we+G2La7A01/rhBO5XKrhfph95rcR4OVIAO0KH420MSU0wGv5yrebLjIFKTHQL1GtuiSW
	 Smw2vEALOvBnEmHMzqYn4Crfl/3Udt4Eff/m8G7gI5kskBOKBxhTfqA1GPOCVMJDzWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VVeNF2eW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423D1606A31B
	for <linux-scsi@vger.kernel.org>; Thu,  5 Nov 2026 18:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VVeNF2eW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 038731F000C1;
	Thu,  5 Nov 2026 18:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793901658;
	bh=g6a/eCAlhdtD/I49/xiv15gnKI+R1B4m1qDsdvESCg8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VVeNF2eWArDBaKSY2ERSKabZTrlf0q/GFKJDA4zaL7CNCFFnsQTn9DuZBmDFZ5M7E
	 7AIb0I2uW/6OzigQ+4rvqvZB+n5F2TNLjZvXG2WnOAZ5dTLFHdDuNspGQzefUwpE4S
	 Z2dQv3eaIBp948keJbV6QmZdPW2kOHHZupv8ULlAjyjVgWejo/pbS13FJrIyaIqTEX
	 u2OdL1tLAak3z0wk50MwxBPjBhZRvZHTF3RFfDXOhMLN66VHaYkZS6ZFltaUWihmhz
	 KTYTOwRrVGWDhLt5EO2BHpIp+yoLQE8DPhXOYupflx22ifunuFyORYRws4VMfoeSsy
	 ZrrRff03ph7uQ==
Message-ID: <sashiko-outbox-199681@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v18 05/13] scsi: ibmvfc: fix resource leaks on partial
 queue allocation failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261105-ibmvfc-fpin-support-v18-5-d683b74736a3@linux.ibm.com>
References: <20261105-ibmvfc-fpin-support-v18-0-d683b74736a3@linux.ibm.com>
 <20261105-ibmvfc-fpin-support-v18-5-d683b74736a3@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 18:00:57 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: ibmvfc: stale evt_pool state in ibmvfc_free_queue() on parti=
al alloc
--

commit 226240ace51c2767f2bb52b147409116cfbb8d78
Author: Dave Marquardt <davemarq@linux.ibm.com>

scsi: ibmvfc: fix resource leaks on partial queue allocation failure

This commit guards dma_unmap_single() and free_page() in ibmvfc_free_queue()
under a queue->msgs.handle check and adds ibmvfc_free_event_pool() calls on
the error paths of ibmvfc_alloc_queue() after ibmvfc_init_event_pool()
succeeds.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 77c685f6f959b..e04c80050b981 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> @@ -914,9 +914,11 @@ static void ibmvfc_free_queue(struct ibmvfc_host *vh=
ost,
>  {
>  	struct device *dev =3D vhost->dev;
> =20
> -	dma_unmap_single(dev, queue->msg_token, PAGE_SIZE, DMA_BIDIRECTIONAL);
> -	free_page((unsigned long)queue->msgs.handle);
> -	queue->msgs.handle =3D NULL;
> +	if (queue->msgs.handle) {
> +		dma_unmap_single(dev, queue->msg_token, PAGE_SIZE, DMA_BIDIRECTIONAL);
> +		free_page((unsigned long)queue->msgs.handle);
> +		queue->msgs.handle =3D NULL;
> +	}
> =20
>  	ibmvfc_free_event_pool(vhost, queue);
>  }
> @@ -6303,8 +6305,10 @@ static int ibmvfc_alloc_queue(struct ibmvfc_host *=
vhost,
>  	}
> =20
>  	queue->msgs.handle =3D (void *)get_zeroed_page(GFP_KERNEL);
> -	if (!queue->msgs.handle)
> +	if (!queue->msgs.handle) {
> +		ibmvfc_free_event_pool(vhost, queue);
>  		return -ENOMEM;
> +	}
> =20
>  	queue->msg_token =3D dma_map_single(dev, queue->msgs.handle, PAGE_SIZE,
>  					  DMA_BIDIRECTIONAL);
> @@ -6312,6 +6316,7 @@ static int ibmvfc_alloc_queue(struct ibmvfc_host *v=
host,
>  	if (dma_mapping_error(dev, queue->msg_token)) {
>  		free_page((unsigned long)queue->msgs.handle);
>  		queue->msgs.handle =3D NULL;
> +		ibmvfc_free_event_pool(vhost, queue);
>  		return -ENOMEM;
>  	}

[Severity: High]
The commit message states that guarding dma_unmap_single() and free_page()
under queue->msgs.handle makes ibmvfc_free_queue() safe to call on a
partially initialized queue. However, does calling ibmvfc_free_queue() after
a partial queue allocation failure still trigger a use-after-free,
double-free, or NULL pointer dereference in ibmvfc_free_event_pool()?

In drivers/scsi/ibmvscsi/ibmvfc-core.c, ibmvfc_init_event_pool() sets
pool->size before allocating pool->events and pool->iu_storage, and does not
reset pool->size or clear pool->events on failure:

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_init_event_pool() {
	...
	pool->size =3D queue->total_depth;
	pool->events =3D kzalloc_objs(*pool->events, pool->size);
	if (!pool->events)
		return -ENOMEM;

	pool->iu_storage =3D dma_alloc_coherent(vhost->dev,
					      pool->size * sizeof(*pool->iu_storage),
					      &pool->iu_token, 0);

	if (!pool->iu_storage) {
		kfree(pool->events);
		return -ENOMEM;
	}
	...
}

Similarly, when ibmvfc_alloc_queue() fails at get_zeroed_page() or
dma_mapping_error() and calls ibmvfc_free_event_pool(), pool->events and
pool->iu_storage are freed, but pool->size, pool->events, and
pool->iu_storage are left with their old values:

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_free_event_pool() {
	...
	for (i =3D 0; i < pool->size; ++i) {
		list_del(&pool->events[i].queue_list);
		BUG_ON(atomic_read(&pool->events[i].free) !=3D 1);
		if (pool->events[i].ext_list)
			dma_pool_free(vhost->sg_pool,
				      pool->events[i].ext_list,
				      pool->events[i].ext_list_token);
	}

	kfree(pool->events);
	dma_free_coherent(vhost->dev,
			  pool->size * sizeof(*pool->iu_storage),
			  pool->iu_storage, pool->iu_token);
	LEAVE;
}

Because ibmvfc_free_queue() still calls ibmvfc_free_event_pool()
unconditionally outside the if (queue->msgs.handle) check, calling
ibmvfc_free_queue() on a queue after ibmvfc_alloc_queue() fails (for
IBMVFC_CRQ_FMT or IBMVFC_SUB_CRQ_FMT where queue->total_depth is non-zero)
will iterate over the stale pool->size and either dereference a NULL
pool->events pointer or access and free pool->events and pool->iu_storage a
second time.

Should ibmvfc_free_event_pool() also be guarded or reset pool->size,
pool->events, and pool->iu_storage so that ibmvfc_free_queue() is safe on a
partially initialized queue?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-ibmvfc-fpi=
n-support-v18-0-d683b74736a3@linux.ibm.com?part=3D5
