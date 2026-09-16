Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781864E1C8F
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 23:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789601982; cv=none; b=HPd6gIQnPRh3xvy2SVE79ZSy5Jj0ybBQjhwzrw2JUqTYsEY19LuDVd95gjAEYZjKb4S1YuGbtrXX9HikoAzelpLJ2wQMWgyiuY+4Ewpl2GznpTTqlkWXpdUplRVe+/8r3AkF0mz+uG5Y3VEcYnQQ6bXDEe0YFiYOKwWVzP54ISw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789601982; c=relaxed/simple;
	bh=qhMWcevBHpeWXu79w+gTt9BX0+x3Fy8Gpv/hrsZ2/po=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=j3+bIweHHXSHYtpnwGnBJGXhsVB3Qin40QUEOXkQ9qINRGlaAnhwEuREJsxpUgYLFVCAYmcX0/5ygRF4xmJNAqSR3jQ3DoTtoMRggTVctC1wQLSZbPaZASUHmgLLFCp80OiIaI4S/MOQh33KQdF29do1eyebX4TcOmACAxyq+vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EVRW3LID; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EVRW3LID"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33B801F000FF;
	Wed, 16 Sep 2026 23:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789601981;
	bh=FVYkrttAxpoDV1G6lv8oC0FuWIO4sIdv23pJyUT08G0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EVRW3LIDaQLqhdrqN3r0zHA2RFqa7jY8cb+T/bTOsVSeOqmc/rPgf6glI5Wfn94AR
	 oTyLQhQfUtZ6mA1+3gPB7Z1HcgrW+/X30riX1WVPCn+IzMIeiW3NYZmTc4PsSP3htv
	 nAYKgwB5nbOkKCd3/rgf56NjSJyxjhSvbowtwKLNXh+JAyRGLooa5yrhvfNIT1l+5N
	 i1B30er/a7nRkZi/mzLd7Pr3pdNEINYnjbEhMLwuWuJQ4Dl4SGXjdwA5/HIAf0zihj
	 b6aLftxqjEMOwBmgpSsJihUPF51cWww+Ed0pvbhlqTpRhyljRbJFH1lpi8i+irUuX6
	 ywKf3tUB5vV7w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 15/20] scsi: ibmvfc: unregister NVMe local port on
 adapter removal
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260916230921.2204729-16-tyreld@linux.ibm.com>
References: <20260916230921.2204729-1-tyreld@linux.ibm.com>
 <20260916230921.2204729-16-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 16 Sep 2026 23:39:40 +0000
Message-Id: <20260916233941.33B801F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: ibmvfc: deadlock in ibmvfc_nvme_unregister() during adapter =
removal
--

commit 58109a2f9e0799681cadb400cd50fd44f1f7c337
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

scsi: ibmvfc: unregister NVMe local port on adapter removal

This commit adds a call to ibmvfc_nvme_unregister() during adapter removal
to prevent a use-after-free in the NVMe-FC transport layer. It ensures the
local port is unregistered before the host memory is freed.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> @@ -6995,6 +6995,8 @@ static void ibmvfc_remove(struct vio_dev *vdev)
>  	ibmvfc_release_sub_crqs(vhost);
>  	ibmvfc_release_crq_queue(vhost);
> =20
> +	ibmvfc_nvme_unregister(vhost);

[Severity: High]
Could this unregister call block forever if the adapter reset times out?

Earlier in ibmvfc_remove(), ibmvfc_wait_while_resetting() waits for the=20
adapter to finish resetting. If this wait times out, kthread_stop() is call=
ed
on the worker thread. The worker thread will then exit and abandon any
remaining NVMe remote ports that needed deletion.

Because these remote ports are never unregistered, the local port's active
remote port count remains greater than zero.

When ibmvfc_nvme_unregister() is called here, it invokes
nvme_fc_unregister_localport(), which defers the localport_delete callback
until all remote ports are deleted. It then unconditionally blocks:

ibmvfc_nvme_unregister() {
        ...
        rc =3D nvme_fc_unregister_localport(vhost->nvme_local_port);
        if (!rc) {
                wait_for_completion(&vhost->nvme_delete_done);
        ...
}

Since the worker thread is dead and will never delete the remaining remote
ports, will this completion never be signaled, resulting in a permanent hang
of the driver removal process?

> +
>  	ibmvfc_free_mem(vhost);
>  	spin_lock(&ibmvfc_driver_lock);
>  	list_del(&vhost->queue);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260916230921.2204=
729-1-tyreld@linux.ibm.com?part=3D15
