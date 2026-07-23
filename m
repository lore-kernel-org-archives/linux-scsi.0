Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72EDE1D555
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 00:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784766108; cv=none; b=XWCOVswOHhOFtrH5imFvYFj43zTcKySLWjbvViiNnsHvkp7nOtWiXhNU3XF9IHIDMsIS6nMjLmwJWD7O9ce5c/6lhbFtqIOJJOlMuN1h58ti1v+X4EhjxLMY1pcyNwWAOV0MF3V8ENkSu6tifNXo9hAsSlM8MyntIZTAiJrMJKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784766108; c=relaxed/simple;
	bh=O8JavN8TPMpkJzdDPf7/kQUsUFgUo2SBNVAWgrk6cAk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=enH+I2ccK3E7hrez7K2MyOCgiZRlv5oSNQ0F8QUsrbxGUVys8ySXd44g6DLuI+7VfVwsoyvgswmhKybVoiUEDo9VRijWMNsPXolUDOVsneAoQCSXgqQzqsaUeYHqEal+MicO64niedvtCAponqzvGW+Fvq+NC4o1TPAwOhNWZ48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UsKdzlBI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UsKdzlBI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D7AD1F000E9;
	Thu, 23 Jul 2026 00:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784766107;
	bh=gNuBmOyxyJNHP9/M9cR78kncOwmCnFAQQ/dxyS/qOkQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UsKdzlBINDaI6MViXVo1l9Grkn49P/26J6/YBo1jimUwxXZsVpuPjsgaT9Cx959zF
	 Ax5dpo75ijit93rTZlYymNoK7uWttLjSII+QpY7s6SOpkSTO1L2kfWbAZ/PxzKKnJx
	 4+Ni1HglixbHGBp3taSjGsNm+NXiex7PDf6nBwTmUMi/+O8gbRq4cW/mkOXrQDXgRn
	 fwEwmL+JeOlbTr93mSFq/A4y1l03uSa10X8Kdy+4mCnAuU0wrqUsZSDgoLNtkf1/K8
	 vnA19PO/x5OwgIhWYfRF1Du1EpISPKjwFcIVnJr5D2TVKBmLEa+UYXC919wpC2kpsz
	 LMNHx5pe4HNtw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 08/33] ibmvfc: initialize NVMe channel configuration
 during driver probe
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723000149.969416-9-tyreld@linux.ibm.com>
References: <20260723000149.969416-1-tyreld@linux.ibm.com>
 <20260723000149.969416-9-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 00:21:46 +0000
Message-Id: <20260723002147.2D7AD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The `nvme_host_queues` module parameter (stored as `nr_nvme_hw_q=
ueues`) is completely ignored when computing and configuring the maximum nu=
mber of NVMe hardware queues.
--

--- Patch [8]: [PATCH v2 08/33] ibmvfc: initialize NVMe channel configurati=
on during driver probe ---
commit 99d71f6b2c78b8700e766c71f498b0d820a0931d
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

ibmvfc: initialize NVMe channel configuration during driver probe

This commit initializes the host's NVMe channel-group state during driver
probe. It sets up the NVMe channel list, desired and maximum queue counts,
and enablement state to prepare the driver for subsequent NVMe queue
allocation and IO submission.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 56f4fb200a69b..5b6570232df36 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
> @@ -6347,7 +6347,8 @@ static int ibmvfc_probe(struct vio_dev *vdev, const=
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

[Severity: Medium]
Is there a regression in configuration handling here by bypassing the
nvme_host_queues module parameter?

Unlike the SCSI equivalent which caps queues with min(max_scsi_queues,
nr_scsi_hw_queues), max_nvme_queues is computed here without incorporating
nr_nvme_hw_queues at all.

[ ... ]

> @@ -6381,6 +6383,10 @@ static int ibmvfc_probe(struct vio_dev *vdev, cons=
t struct vio_device_id *id)
>  	vhost->scsi_scrqs.protocol =3D IBMVFC_PROTO_SCSI;
>  	vhost->using_channels =3D 0;
>  	vhost->do_enquiry =3D 1;
> +	vhost->nvme_enabled =3D mq_enabled ? nvme_enabled : 0;
> +	vhost->nvme_scrqs.desired_queues =3D min(max_nvme_queues, nr_nvme_chann=
els);
> +	vhost->nvme_scrqs.max_queues =3D max_nvme_queues;

[Severity: Medium]
Does this assignment cause a regression for deployments trying to tune NVMe
queue counts?

Since max_nvme_queues does not incorporate nr_nvme_hw_queues, it seems the
administrator's module parameter configuration is completely ignored when
setting the maximum number of NVMe hardware queues.

> +	vhost->nvme_scrqs.protocol =3D IBMVFC_PROTO_NVME;
>  	vhost->scan_timeout =3D 0;
> =20
>  	strcpy(vhost->partition_name, "UNKNOWN");

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723000149.9694=
16-1-tyreld@linux.ibm.com?part=3D8
