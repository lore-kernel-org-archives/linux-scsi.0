Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A5003C6A29;
	Mon, 20 Jul 2026 07:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784533231; cv=none; b=nFe6zt9VM/Pk9AuJb0wA4zriOHEpIgzj5w83Zu9R8gsoq1d4ehMt9yBUlDn4ngVh/MXSW1Bur1v5Nf5LQi6Ne6KK4tpalZRcWXsPA/eSijpCYcgbNbV/Ib7Drn/lDmMx4cvSBWxT13QvMGW4iRZgHYr7fKrVCPxe0db3Y9ztczA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784533231; c=relaxed/simple;
	bh=/TgedkZrQdA0C8VNe2Le2k0Ie5TJCjqKy5AsKkK9bIk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Ae+hL4aRovRp9seLQJmh947Se3Ks7LLZ5ERLEhFLJve0pvVH6wT1+8jZp5x2FqgKm0U8Knzh9BsLfM5jypg36vq1IOgvMxKSt2BHyMsx9FPhRbT39PxSpyFtZocY/cSbzbX72bAQnXHmXN5GStrhL004ahRk88pwaSxsMgiMWso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n4IDqwlS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n4IDqwlS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 649FD1F000E9;
	Mon, 20 Jul 2026 07:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784533228;
	bh=iiRDLIaUDvPyOUfNQ5QPT0jzupS3tjgYKE+sN4pSdR8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=n4IDqwlSP7HkDmWCVgp27niQOCk47vTCNPI/POdf2WPhk1eJuCBWOnVADjFpOdyn9
	 cYm2DzUBCd6nGbFp1LdH876Wp7QGiqCFQ0C73irLQhScXzqzF2lXtUIRmElkk3AdiQ
	 hci8q6sE5C+gqkvEA2TtL2kqv+dlwdlaMtBaR37qwdtBSa16LvXJG5LHDBA45D9aIo
	 VOMlV9GbbiaNdZT2jya1QXP6w7ehYc8h3HeEKWNmZAefOiUopM+lrjCqeW7Rtp0zyK
	 /TphPqiuYKbubi3lO+QrXGRidBLbWG7rckz6+lS+Dsu/7rjoVhZF+gysPgC4olissI
	 ab7XwUCZNszUA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/1] fix memory leak during adapter release by
 destroying gid_pn_req
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nihar Panda" <niharp@linux.ibm.com>
Cc: "Heiko Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>
In-Reply-To: <20260720072736.3381816-2-niharp@linux.ibm.com>
References: <20260720072736.3381816-1-niharp@linux.ibm.com>
 <20260720072736.3381816-2-niharp@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 20 Jul 2026 07:40:26 +0000
Message-Id: <20260720074027.649FD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The error path in `zfcp_adapter_enqueue()` calls `zfcp_erp_thread_=
kill()` which unconditionally passes `adapter->erp_thread` to `kthread_stop=
()`. If adapter initialization fails before the thread is created (e.g., du=
ring `zfcp_allocate_low_mem_buffers()`), this results in a kernel panic bec=
ause `kthread_stop()` does not handle NULL pointers.
--

--- Patch [1]: [PATCH 1/1] fix memory leak during adapter release by destro=
ying gid_pn_req ---
commit 5b4668bd066d14a43f77f6f0301f8c98cbb5069c
Author: Benjamin Block <bblock@linux.ibm.com>

fix memory leak during adapter release by destroying gid_pn_req

When releasing an adapter we don't free the mempool gid_pn_req that is
allocated during the enqueue. This fixes the memory leak by destroying the
mempool during the adapter's release.

> diff --git a/drivers/s390/scsi/zfcp_aux.c b/drivers/s390/scsi/zfcp_aux.c
> index 8ff7db7921b5a..fea573e00f9df 100644
> --- a/drivers/s390/scsi/zfcp_aux.c
> +++ b/drivers/s390/scsi/zfcp_aux.c
> @@ -253,6 +253,7 @@ static int zfcp_allocate_low_mem_buffers(struct zfcp_=
adapter *adapter)
>  static void zfcp_free_low_mem_buffers(struct zfcp_adapter *adapter)
>  {
>  	mempool_destroy(adapter->pool.erp_req);
> +	mempool_destroy(adapter->pool.gid_pn_req);

[Severity: High]
This is a pre-existing issue, but if memory allocation fails during adapter
setup, could this lead to a kernel panic?

In zfcp_adapter_enqueue(), if zfcp_allocate_low_mem_buffers() returns -ENOM=
EM,
the code jumps to the failed label and unconditionally calls
zfcp_erp_thread_kill():

drivers/s390/scsi/zfcp_aux.c:zfcp_adapter_enqueue() {
    ...
failed:
    /* TODO: make this more fine-granular */
    cancel_delayed_work_sync(&adapter->scan_work);
    cancel_work_sync(&adapter->stat_work);
    cancel_work_sync(&adapter->ns_up_work);
    cancel_work_sync(&adapter->version_change_lost_work);
    zfcp_destroy_adapter_work_queue(adapter);

    zfcp_fc_wka_ports_force_offline(adapter->gs);
    zfcp_scsi_adapter_unregister(adapter);

    zfcp_erp_thread_kill(adapter);
    ...
}

However, if the thread was never created, adapter->erp_thread is NULL.
zfcp_erp_thread_kill() unconditionally passes it to kthread_stop():

drivers/s390/scsi/zfcp_erp.c:zfcp_erp_thread_kill() {
    kthread_stop(adapter->erp_thread);
    adapter->erp_thread =3D NULL;
}

Since kthread_stop() does not handle NULL pointers, will this result in a
NULL pointer dereference?

>  	mempool_destroy(adapter->pool.scsi_req);
>  	mempool_destroy(adapter->pool.scsi_abort);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260720072736.3381=
816-2-niharp@linux.ibm.com?part=3D1
