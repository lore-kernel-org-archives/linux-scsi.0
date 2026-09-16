Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF4541754
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 00:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789517901; cv=none; b=RJBW7rWLH6XjY5HgF1OPkd+tbUrC+O7a8tivrPc1rxlmuZ+wk6fojOSremHRUkzbO45sLf7OPz+3cr7HQDrt5A9Dnnqvbx0pmw0pWXgxwuwlVcWch+8ycdjeuAFvfm+4nGrZB6IrTREyQcf8K8/a8o6CdgDgQM5Rl75gxG4Fm+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789517901; c=relaxed/simple;
	bh=8vQzFvnX0cAfYMYiCQNp3gr8WoPqrba5EFcW7X06e7o=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ErHlGDquAeJhaF+D012w0sEnSRoGofhw3Q8AnDUmpatr4ybn7bxiYR+3RKM/Ff70W1wZI9kDM6CoAvKyLtezprcrzvo7PaN59Gowels1svYzv5erboNrWZM5S4CHt7+KbzcIEJfc87IjFSSDgwR5thWGg9qciA6fnujTDVNlAJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fK1hleD/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fK1hleD/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69D4C1F000FF;
	Wed, 16 Sep 2026 00:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789517899;
	bh=eV6w3kixz1xfXyBLdJzZk+IYT4JFDNncIVCJ0BQTuOA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fK1hleD/LYIXo5Ug3RjIWRMTJrel9CIO2O0lWLv/ZhAOJrcT/gFRsR8WUxSXY/OuZ
	 go6gEdkhMfv/8s7n2cYnZ8IlaT4egy41/d6qG2Fiz5LENIcYTwY8Tkervl+6ojrZlX
	 sDes07vTLdaeGL/qWJrnY1JBi5mgMfKx4d/OMgNTgwROH6ECM/q/Ix812R6pe1iScS
	 ZVQqKPE5Ez9a20oEKUUzpSqQXNs0NRwxYyZS2XYTAHBmZsd6Kc0czrG9l43oLqY95B
	 h9Eoov2nNYs2H7gQuB8/W60st7UIegLo6zT4iA8M97gHHPQAfBPsdreBDsEkp3kh+M
	 btxyia80aRgzw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] ibmvscsi: implement vio driver shutdown call back to
 quiesce ibmvscsi
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260916000626.1981569-1-tyreld@linux.ibm.com>
References: <20260916000626.1981569-1-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 16 Sep 2026 00:18:18 +0000
Message-Id: <20260916001819.69D4C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] scsi: ibmvscsi: Use-After-Free in queuecommand due to prematur=
e resource free
- [High] scsi: ibmvscsi: deadlock during device removal due to blocked host
--

commit 83656c60ea18229cd02899fae2cde7d1ac88c182
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

ibmvscsi: implement vio driver shutdown call back to quiesce ibmvscsi

This patch implements a driver shutdown callback to quiesce the ibmvscsi
driver and avoids tearing down the full host. It moves quiesce steps into
a new helper function, which is also used by the device remove path.

> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibm=
vscsi.c
> index 609bda730b3a8..77f4eac828788 100644
> --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
> @@ -2341,26 +2341,39 @@ static int ibmvscsi_probe(struct vio_dev *vdev, c=
onst struct vio_device_id *id)
>  	return -1;
>  }
> =20
> -static void ibmvscsi_remove(struct vio_dev *vdev)
> +static void ibmvscsi_quiesce(struct ibmvscsi_host_data *hostdata, int sc=
si_error_code)
>  {
> -	struct ibmvscsi_host_data *hostdata =3D dev_get_drvdata(&vdev->dev);
> -
> -	srp_remove_host(hostdata->host);
> -	scsi_remove_host(hostdata->host);
> -
> -	purge_requests(hostdata, DID_ERROR);
> -	release_event_pool(&hostdata->pool, hostdata);
> +	scsi_block_requests(hostdata->host);
> +	kthread_stop(hostdata->work_thread);
> =20
>  	ibmvscsi_release_crq_queue(&hostdata->queue, hostdata,
>  					max_events);
> =20
> -	kthread_stop(hostdata->work_thread);
> +	purge_requests(hostdata, scsi_error_code);
> +
> +	release_event_pool(&hostdata->pool, hostdata);

[Severity: Critical]
Will this lead to a use-after-free when handling concurrent SCSI commands?

If a concurrent scsi_queue_rq() thread passes the budget check before
host_self_blocked is set by scsi_block_requests(), it will block on
host_lock.

Once purge_requests() drops the host_lock, the preempted thread will
acquire it and enter ibmvscsi_queuecommand_lck(). Because the event pool
memory is freed by release_event_pool() right after purge_requests(),
get_event_struct() would directly access the freed pool->events array when
the preempted thread finally runs.

>  	unmap_persist_bufs(hostdata);
> +}
> +
> +static void ibmvscsi_shutdown(struct vio_dev *vdev)
> +{
> +	struct ibmvscsi_host_data *hostdata =3D dev_get_drvdata(&vdev->dev);
> +
> +	ibmvscsi_quiesce(hostdata, DID_REQUEUE);
> +}

[Severity: Critical]
Is it safe to omit scsi_remove_host() during shutdown?

During shutdown, the host is never removed here, leaving the SCSI midlayer
completely active. Could this cause crashes if I/O timeouts or commands
trigger after the driver resources have been quiesced and freed?

> +
> +static void ibmvscsi_remove(struct vio_dev *vdev)
> +{
> +	struct ibmvscsi_host_data *hostdata =3D dev_get_drvdata(&vdev->dev);
> +
> +	ibmvscsi_quiesce(hostdata, DID_ERROR);
> =20
>  	spin_lock(&ibmvscsi_driver_lock);
>  	list_del(&hostdata->host_list);
>  	spin_unlock(&ibmvscsi_driver_lock);
> =20
> +	srp_remove_host(hostdata->host);
> +	scsi_remove_host(hostdata->host);

[Severity: High]
Does this sequence cause a deadlock during device unbind or module unload?

Since ibmvscsi_quiesce() calls scsi_block_requests(), the host is put into a
blocked state before the child devices are removed.

When scsi_remove_host() synchronously unregisters child devices,
unregistering a SCSI disk calls sd_sync_cache() to flush the write cache.
This submits a bio and waits for completion via blk_execute_rq().

Because the host is blocked, the block layer budget check fails and returns
BLK_STS_RESOURCE, causing the block layer to continuously requeue the flush
request. Will the cache flush request wait indefinitely and deadlock the
rmmod or unbind process?

>  	scsi_host_put(hostdata->host);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260916000626.1981=
569-1-tyreld@linux.ibm.com?part=3D1
