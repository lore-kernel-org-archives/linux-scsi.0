Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5BF61C861D
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 00:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784768068; cv=none; b=EUR0WR3wSsQ3TiMvFTTuzBulC9sul6URrzq0v64zLrRJoqqkTWbnqTJfuMY7O9cllIyuXjaBfNUrPqXrkryGo7Psf40j/mcYlasPvMP3YvwvGn1A8I/0gSR2iEFI4by2UVQoccMVyESvXowvyVEuF9rdMkOZSVfQXSGuE704YSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784768068; c=relaxed/simple;
	bh=4Ui0cDRUO5GdHG3uNKMqe5/QeRCQDT/kCCN41ISreEI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=I52DORT3NS8SlPfHbndsWYm0Er8Zn7NDD6+3grR5HGLj0AnKP1fA34mF5gACfWfTaVsPlx8v9/zvxVc4y4nxcAnv3U0zSsssubAMNHJjAjMCX2fdig0/jSdvaiZK5yN9eSOldiZAyf9HwTmP3A+spgFIdtofSqT8q9ZMzK5XYZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KOSIvgO/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KOSIvgO/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C161F000E9;
	Thu, 23 Jul 2026 00:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784768066;
	bh=ADJ6Nq66HhwYVXvoXhL5W28PmAtFhGw+UQQIFFd8VP0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KOSIvgO/uPDbxg1FLCcCDzf1faHw2Yx/2eCckSmAGDuiTVow5zjzOCuleFVpZQooO
	 leV8ecIRFDbL81tLFyk/WJFH+4ZVl1baRJJ8i+z8tFSYaMxn34g+9YW5qODKIP+1Fh
	 +Dmzm72kAcTigFkK6oJZdvXFtZ1xjdCcZScB1k6msdAcF+z4o/ozoUpRjbWDlIlkE0
	 xOHoJD2z+cnwq6UIXsS5k93bhENVW3qbFtU0r5GhPIwftODB8uVhGZI0Hbpybrrv+a
	 A0S09enWlr8BUpIyYos7v93i8jkVHo6qZh879rxm6agdVnAOKnBhzoduXG4NEcWsIl
	 4o2Vb1jfbUY8g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 23/33] ibmvfc: implement NVMe/FC stubs for
 local/remote port registration
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723000149.969416-24-tyreld@linux.ibm.com>
References: <20260723000149.969416-1-tyreld@linux.ibm.com>
 <20260723000149.969416-24-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 00:54:26 +0000
Message-Id: <20260723005426.76C161F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] Overwriting the NVMe-FC transport's pre-allocated `private` poin=
ter in port registration functions causes API misuse and out-of-bounds memo=
ry corruption.
- [Medium] The NVMe-FC transport stubs (`ibmvfc_nvme_ls_req` and `ibmvfc_nv=
me_fcp_io`) return 0 (success) but drop requests without invoking the manda=
tory asynchronous `done` callbacks, causing uninterruptible hangs.
--

--- Patch [23]: [PATCH v2 23/33] ibmvfc: implement NVMe/FC stubs for local/=
remote port registration ---
commit a018152524c65e5db110e234e12e5b6d56bbe966
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

ibmvfc: implement NVMe/FC stubs for local/remote port registration

Implement the initial NVMe/FC local-port and remote-port registration
functions that notify the NVMe-FC midlayr of port discovery and loss.

Register the local port with the NVMe-FC transport, register discovered
remote ports against that local port, and add matching unregister paths
that wait for the NVMe-FC core to complete asynchronous deletion before
dropping driver references. Also store driver-private host and target
pointers in the registered NVMe-FC port objects.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c b/drivers/scsi/ibmvscsi/=
ibmvfc-nvme.c
> index 2ee1c64665d9c..d679d1ca366a8 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
> @@ -14,10 +14,18 @@
> =20
>  static void ibmvfc_nvme_localport_delete(struct nvme_fc_local_port *lpor=
t)
>  {
> +	struct ibmvfc_host *vhost =3D lport->private;
> +
> +	vhost->nvme_local_port =3D NULL;
> +	complete(&vhost->nvme_delete_done);
>  }
> =20
>  static void ibmvfc_nvme_remoteport_delete(struct nvme_fc_remote_port *rp=
ort)
>  {
> +	struct ibmvfc_target *tgt =3D rport->private;
> +
> +	tgt->nvme_remote_port =3D NULL;
> +	complete(&tgt->nvme_delete_done);
>  }

[Severity: Medium]
If a concurrent teardown unregisters the port before the private pointer
is overwritten during registration, could rport->private still point to the
8-byte inline buffer allocated by the NVMe-FC core?

If so, won't casting this 8-byte buffer to a much larger struct ibmvfc_targ=
et
and writing to tgt->nvme_remote_port cause an out-of-bounds write and memory
corruption?

> =20
>  static int ibmvfc_nvme_ls_req(struct nvme_fc_local_port *lport,

[Severity: Medium]
Do the NVMe-FC transport stubs (ibmvfc_nvme_ls_req and ibmvfc_nvme_fcp_io)
return 0 without invoking the mandatory asynchronous done callbacks?

If these functions return 0 (success) but drop requests without calling
ls_req->done or fcp_req->done, won't this leave the NVMe-FC core waiting
forever, potentially causing an uninterruptible hang?

[ ... ]

> @@ -70,28 +78,96 @@ static struct nvme_fc_port_template ibmvfc_nvme_fc_tr=
ansport =3D {
> =20
>  int ibmvfc_nvme_register_remoteport(struct ibmvfc_target *tgt)
>  {
> +	struct ibmvfc_host *vhost =3D tgt->vhost;
> +	struct nvme_fc_port_info pinfo;
> +	int rc;
> +
>  	if (!IS_ENABLED(CONFIG_NVME_FC))
>  		return 0;
> =20
> -	return 0;
> +	if (!vhost->nvme_local_port) {
> +		dev_err(vhost->dev, "Attempt to register NVMe fc remoteport without va=
lid localport\n");
> +		return -EINVAL;
> +	}
> +
> +	memset(&pinfo, 0, sizeof(struct nvme_fc_port_info));
> +	pinfo.node_name =3D tgt->ids.node_name;
> +	pinfo.port_name =3D tgt->ids.port_name;
> +	pinfo.port_id =3D tgt->ids.port_id;
> +	pinfo.port_role =3D FC_PORT_ROLE_NVME_TARGET;
> +
> +	rc =3D nvme_fc_register_remoteport(vhost->nvme_local_port, &pinfo,
> +					 &tgt->nvme_remote_port);
> +
> +	if (!rc) {
> +		ibmvfc_log(vhost, 2, "register_remoteport: traddr=3Dnn-0x%llx:pn-0x%ll=
x PortID:%x\n",
> +			   pinfo.node_name, pinfo.port_name, pinfo.port_id);
> +		tgt->nvme_remote_port->private =3D tgt;

[Severity: Medium]
Does directly overwriting the nvme_remote_port->private pointer orphan the
inline buffer allocated by the NVMe-FC core?

Since the NVMe-FC core allocates an 8-byte inline buffer for private data
based on remote_priv_sz, shouldn't the data be copied into the allocated
buffer rather than overwriting the pointer entirely?

> +	}
> +
> +	return rc;
>  }

[ ... ]

>  int ibmvfc_nvme_register(struct ibmvfc_host *vhost)
>  {
> +	struct nvme_fc_port_info pinfo;
> +	int rc;
> +
>  	if (!IS_ENABLED(CONFIG_NVME_FC))
>  		return 0;
> =20
> -	return 0;
> +	pinfo.node_name =3D fc_host_node_name(vhost->host);
> +	pinfo.port_name =3D fc_host_port_name(vhost->host);
> +	pinfo.port_id =3D fc_host_port_id(vhost->host);
> +	pinfo.port_role =3D FC_PORT_ROLE_NVME_INITIATOR;
> +	pinfo.dev_loss_tmo =3D 0;
> +
> +	rc =3D nvme_fc_register_localport(&pinfo, &ibmvfc_nvme_fc_transport,
> +					vhost->dev, &vhost->nvme_local_port);
> +
> +	if (!rc) {
> +		ibmvfc_log(vhost, 2, "register_localport: host-traddr=3Dnn-0x%llx:pn-0=
x%llx on portID:%x\n",
> +			   pinfo.node_name, pinfo.port_name, pinfo.port_id);
> +		vhost->nvme_local_port->private =3D vhost;

[Severity: Medium]
Similar to the remote port registration, does overwriting the pre-allocated
nvme_local_port->private pointer here orphan the core's inline buffer
allocation?

> +	} else
> +		dev_err(vhost->dev, "Failed to register NVMe fc localport (%d)\n", rc);
> +
> +	return rc;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723000149.9694=
16-1-tyreld@linux.ibm.com?part=3D23
