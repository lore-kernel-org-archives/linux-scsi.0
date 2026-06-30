Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B15C4331ECF;
	Tue, 30 Jun 2026 22:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782860347; cv=none; b=avapqDruAqAn2gXhRG+zzbyxetIrW6KYAMYq3uTrJ2xmqMbXVg3+jLIqXVMWmedjttscVetSDT4RmH5QWT0C7aa8HhMHszJgQ0JJlImdfBsjlXeXqf24t10H+7ovKViIONn3yuSzpcCpYuL7A5pvKXZHnEElv+913mwhtnXrIzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782860347; c=relaxed/simple;
	bh=RamHX0E8wtNsTHcEO/bUX4s5m2cuQqWXNUOO5Jx+0m4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gv4LV8+CxYhTHANL8IivxEfTtVblAQzLOvrogpBHg1TCzXoEC8gHswiyiYPlTyi/s2QHUZGlvUzgkd0MaH0r0cRDFLzGnvxGmbaEuEx3mOepkZ85JAyd2usBes+XzMP3a5dEnVIEj3GNS1atPP+tbRQn7qqPMWekrMpoSh7x6IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WtpuTHuH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WtpuTHuH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 715A51F000E9;
	Tue, 30 Jun 2026 22:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782860346;
	bh=T6wnLUkshLOnOFu8Td4Y9f1tyliE5SHa8xUgdAu8ppc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WtpuTHuHk3NR89ILhf3Q/PnSdaILQHb9cQ4OlgJgMVfGLzfS+Vt/rvGDDuzbHCZ9b
	 H8c+TpyRGS0SG/6jA1US07kywtIJAhflV+J+8yRR5NR5gWqQwD6Z/cdcK1zwHa0xAw
	 pbXPbqC3zoYr+oWrZH/oqrnSkluZxFQvxW9zyIgy9PUNcfP4YfnDGT/zsIIxoP7i7b
	 RjMONGPNtk/4RZ64nqlDv3PkFl30mdTFRfmSgt6ShP9YUgctNSxQbYe3W4WjVvfzd+
	 CQdyg03rbziNAomSfMYR6NXVdFUqXvehpSxpirf0D7pARPHeyD3nou6+TK29ODaLME
	 esU763llW75xQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 2/2] scsi: mpt3sas: add hwmon support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Louis Sautier" <sautier.louis@gmail.com>
Cc: linux-hwmon@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260630224922.2543096-3-sautier.louis@gmail.com>
References: <20260630224922.2543096-1-sautier.louis@gmail.com>
 <20260630224922.2543096-3-sautier.louis@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 30 Jun 2026 22:59:03 +0000
Message-Id: <20260630225904.715A51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Expose the IOC and board temperature sensors of LSI / Broadcom SAS
> HBAs through hwmon. Readings come from MPI IO Unit Page 7 via the
> accessor added in the preceding patch.
>=20
> The same fields are exposed by Broadcom's userspace tooling
> through the /dev/mpt[23]ctl ioctl path (typically root-only):
> IOCTemperature and BoardTemperature in lsiutil; ROC and Controller
> in storcli. With this driver, sensors(1) shows them unprivileged:
>=20
>   $ sensors mpt3sas-pci-0200
>   mpt3sas-pci-0200
>   Adapter: PCI adapter
>   IOC:          +42.0=C2=B0C
>=20
> Each channel is gated independently by its *TemperatureUnits field
> through is_visible(); cards that populate only one sensor expose
> only one input file, and cards that populate neither do not register
> an hwmon device.
>=20
> The hwmon code is gated directly on CONFIG_HWMON. IS_REACHABLE() is
> used rather than IS_ENABLED() so that SCSI_MPT3SAS=3Dy with HWMON=3Dm
> still builds; in that configuration, the sensors are not exposed
> (same pattern as i915 and xe).
>=20
> Assisted-by: Claude:claude-opus-4-7
> Signed-off-by: Louis Sautier <sautier.louis@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260630224922.2543=
096-1-sautier.louis@gmail.com?part=3D2

