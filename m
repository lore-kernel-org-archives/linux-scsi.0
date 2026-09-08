Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F19A3A7D91;
	Tue,  8 Sep 2026 07:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788853957; cv=none; b=XhZk6LrkXTCPAxPZTF/7Em4yP1Fo4CSDUvdKxbAu5tW4do0SCxZksWX83JXL7iytlOnVMdDk18gucSc6DYOjDa4Ttofgqy/Q3lOU2aSFhBpURQVt2hzFEDaZG3hr2eF2m7seSrA+sZRe7HAi+ecyFyaVjn0fT/IknT09GaXBihg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788853957; c=relaxed/simple;
	bh=xbeADuiszfBnjkXVcjDqx7PUK9vbpWolLmqB8A24Geg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=B5NSpol1wy/Ezr4hf8FdhpbmzGBjCSBbZ4sVin108Fb0wsCRiLqz49wyLfCUw7oFOZ+9ye7ZRN0FsXR9riqyAnx2bw0qvNMOBP+MjCVZGHGX61ArAZ5GfsqVvNqNt5ttujKR8cEK7I/+INpIzihz5+JjsxmDxKixk1fefIgCMS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iIDkA0gl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iIDkA0gl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C3041F00A3A;
	Tue,  8 Sep 2026 07:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788853955;
	bh=rAUYcTsGM15z+nAD0iPNsv1TuDfJKYYO5zO5IRYV/PI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iIDkA0glgAdwZ8x1YU9I1ti1FVqQjB/belxmM4m8sIkBCgfSz4zeajcbanzIbV3At
	 2S+RHs7cW6cYwgsDtJ/RHhWLJkRfxtyv8VGsFl5TmxW2b7TkjVUhj2qw5MKBk1vwPN
	 S77Wh3gvDe4ypaNHcZbWMj7bs/WJn8cfLQzPF0CPN8uQ5oqBZX9nxihSHDAGQUmC8V
	 fSyRakEnjyxIOmF4kaK1y8a6oGhDuJKjE92/iaC8x8f8WiF2U4mpqRV9QjTOKCi1mr
	 jR83hz76wAYbZiso0Bq1gYZSM3LFUEy3nL8GB9EA2g7SAII29YmfJdfGXzli25404N
	 SJ2KhlseQg6fQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 3/3] riscv: dts: spacemit: k3: Add UFS support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yixun Lan" <dlan@kernel.org>
Cc: conor+dt@kernel.org, devicetree@vger.kernel.org, robh@kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260908-08-k3-ufs-support-v4-3-22aa2bd97d3b@kernel.org>
References: <20260908-08-k3-ufs-support-v4-0-22aa2bd97d3b@kernel.org>
 <20260908-08-k3-ufs-support-v4-3-22aa2bd97d3b@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 07:52:34 +0000
Message-Id: <20260908075235.3C3041F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The platform driver is missing power management operations (.pm), =
which breaks system suspend/resume and runtime PM.
--

commit e432cf6faf83c7fe0612ce4cb8a3f5d0731598d9
Author: Yixun Lan <dlan@kernel.org>

scsi: ufs: spacemit: k3: Add UFS Host Controller driver

SpacemiT K3 SoC consist of UFS (Universal Flash Storage) Host Controller
which has features compatible with JEDEC UFS 2.2, MIPI UniPro v1.61 and
M-PHY v3.0 standard.

> diff --git a/drivers/ufs/host/ufs-spacemit.c b/drivers/ufs/host/ufs-space=
mit.c
> new file mode 100644
> index 0000000000000..9d037d90ac5e3
> --- /dev/null
> +++ b/drivers/ufs/host/ufs-spacemit.c

[ ... ]

> +static struct platform_driver ufs_spacemit_pltform =3D {
> +	.probe	=3D ufs_spacemit_probe,
> +	.remove	=3D ufs_spacemit_remove,
> +	.driver	=3D {
> +		.name	=3D "ufshcd-spacemit",
> +		.of_match_table =3D of_match_ptr(ufs_spacemit_of_match),
> +	},
> +};

[Severity: High]
Does this platform driver need power management operations assigned to .pm?

Since .pm is missing in ufs_spacemit_pltform, the platform bus PM core won't
invoke any callbacks during system suspend/resume or runtime PM transitions.
This means the host controller and attached UFS device might not be placed
into a low-power state or have their hardware queues properly flushed during
suspend, and could resume in an inconsistent state causing hardware hangs or
data corruption if parent buses were powered down.

Could .pm be set here (for example, to a dev_pm_ops struct utilizing
ufshcd_system_suspend and ufshcd_runtime_suspend) to ensure the PM core
manages the UFS controller's power state?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908-08-k3-ufs-=
support-v4-0-22aa2bd97d3b@kernel.org?part=3D3
