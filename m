Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C11372060
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2026 01:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782179463; cv=none; b=jJ45q65Y1+HM5UpPzBK3sv8kde+PIbfskgjiOFf5oQk6ugyCt7+kdOccReuQvf53QJfc0SQ++erVhqdF4oqXahAxLGBlJc1OrjGD4AVmtwFHCvu6tBGh5kix1Sg7uYdxHTGc91JR2zW2VzGjJxoR/JSqbyCqOtwSQ49/avm1jg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782179463; c=relaxed/simple;
	bh=eeI00JFKukCXAocn7lSnjsolPoC3V0Ykl3JlFDjF8zM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=eUBojKmn3S2ZOt9n/k/Ls7WRwqLUpYf7jpYAwk3Y/2JUqgUD5TJL6UBLr7Fd+Sf6jyT2UOQSAsDQrHG0HK7bnrW9B8w9CHlCTuJuFyhbdwqCLabE8jlXcv7XGqCCThGC6oiL4rnPtmbV+lumm7najUe8oheDv3qEv+8MVr+FeNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ocaR12Ge; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ocaR12Ge"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B36E1F00A3A;
	Tue, 23 Jun 2026 01:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782179462;
	bh=Thih9Gi+hkM7C6VSRFfZHMDAVqaOO5CmwbikPDXu9Ew=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ocaR12GeZCTFV5WDOZD/MfY3cn+oYftzkSbchz8+l/8cUmlrzfJtwg52diZUay9Hi
	 7/5wosmRLrID8vdZBU4TonsIpi9dG1vbwXlntNNsI9q22rUVE5OKVcA0FfWvAoBhHM
	 DfpsIhFDFid6VTNifQ2JQYVKZXV6tR5MQeWhAkOGJsIsPEM8iUD6BPE2fcJVBN3nju
	 4SnOg6ehx3kF3LMwQKdCf4zNKVOU6vmskpIyeMqSqHdF1in7VWgmaO4auboQ0zCxTy
	 QxApPFd8COp94j8SWskzBI345DjKw1UnsNo7W5cWhP2IDZ4T1FNSzNDIKDzIS+KZn4
	 0tx1viZ3+cRrg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 04/29] ibmvfc: initialize NVMe channel configuration
 during driver probe
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260623013035.3436640-5-tyreld@linux.ibm.com>
References: <20260623013035.3436640-1-tyreld@linux.ibm.com>
 <20260623013035.3436640-5-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 01:51:02 +0000
Message-Id: <20260623015102.8B36E1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] The user-configured module parameter for the number of NVMe hard=
ware submission queues (`nvme_host_queues`) is ignored during NVMe queue in=
itialization, preventing users from capping the maximum number of NVMe host=
 queues.
- [Medium] Bitfield truncation of unsigned integer module parameters can si=
lently disable NVMe or create an inconsistent state.
--

commit 8b0247aa812866f78c7701f707162de73d472772
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

ibmvfc: initialize NVMe channel configuration during driver probe

Initialize the host's NVMe channel-group state during probe. This prepares =
the
driver with a NVMe/FC channel group that can will be used by later patches =
for
NVMe queue allocation, discovery buffers, target management, and IO
submission.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> @@ -6337,7 +6337,8 @@ static int ibmvfc_probe(struct vio_dev *vdev, const=
 struct vio_device_id *id)
>  	struct device *dev =3D &vdev->dev;
>  	int rc =3D -ENOMEM;
>  	unsigned int online_cpus =3D num_online_cpus();
> -	unsigned int max_scsi_queues =3D min((unsigned int)IBMVFC_MAX_SCSI_QUEU=
ES, online_cpus);
> +	unsigned int max_scsi_queues =3D min_t(unsigned int, IBMVFC_MAX_SCSI_QU=
EUES, online_cpus);
> +	unsigned int max_nvme_queues =3D min_t(unsigned int, IBMVFC_MAX_NVME_QU=
EUES, online_cpus);
> =20
>  	ENTER;
>  	shost =3D scsi_host_alloc(&driver_template, sizeof(*vhost));

[ ... ]

> @@ -6371,6 +6373,10 @@ static int ibmvfc_probe(struct vio_dev *vdev, cons=
t struct vio_device_id *id)
>  	vhost->scsi_scrqs.protocol =3D IBMVFC_PROTO_SCSI;
>  	vhost->using_channels =3D 0;
>  	vhost->do_enquiry =3D 1;
> +	vhost->nvme_enabled =3D mq_enabled ? nvme_enabled : 0;

[Severity: Medium]
Could this result in unintended bitfield truncation if an even value is pas=
sed
via the module parameter?

Since vhost->nvme_enabled is a 1-bit bitfield, assigning an even value
directly will truncate it to 0, unintentionally disabling NVMe.

Additionally, since the ternary operator checks the un-normalized mq_enabled
integer directly, couldn't this create an inconsistent state where the tern=
ary
evaluates to true, but the underlying vhost->mq_enabled field was truncated
to 0?

> +	vhost->nvme_scrqs.desired_queues =3D min(max_nvme_queues, nr_nvme_chann=
els);
> +	vhost->nvme_scrqs.max_queues =3D max_nvme_queues;

[Severity: Medium]
Should the maximum queue calculations be constrained by the nr_nvme_hw_queu=
es
module parameter?

The NVMe queue initialization currently ignores the user-configured
nr_nvme_hw_queues limit, unconditionally defaulting to the max_nvme_queues
limit based on IBMVFC_MAX_NVME_QUEUES and online CPUs.

> +	vhost->nvme_scrqs.protocol =3D IBMVFC_PROTO_NVME;
>  	vhost->scan_timeout =3D 0;
> =20
>  	strcpy(vhost->partition_name, "UNKNOWN");

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623013035.3436=
640-1-tyreld@linux.ibm.com?part=3D4
