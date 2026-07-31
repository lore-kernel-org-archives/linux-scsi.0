Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31BB2345EA3
	for <linux-scsi@vger.kernel.org>; Fri, 31 Jul 2026 22:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785535548; cv=none; b=TW94k+1UV0kEr67aFNE2eghXvrW6vxpBEC/qB+MpQtJPn1lid34Gly3Omrts0BFadu9AqNINXqMifbNu6/zLr8JLBYRrAp4nhcGw57RVcgSHvSj4LQa/ACy9xe/5fuvCALhmFQ0oK6vWh7RXef5NypbA+UDsUrjo0tkBKcq4Aqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785535548; c=relaxed/simple;
	bh=9ljX5YLih29SJCuRUEZ8wLVEw9Ac1Qn5jRH1P+MOol8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=O3AwhD2uXh0N7Il6mJNimyDn/72XkWs/nHEHmF/EB3dqYq2+SpgL1YhglGw5IdNSLBrD6ElfY1meXjq61YmWdT8vonvJHnxj1sKZLgN1DE7R/qTDz9J9HkPu5zIjN3LqmWDSHhUK1GD+mq7waQvz49Lc1B6EC3a9k46OVmpbvU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mh3wC42P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mh3wC42P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9368C1F00ACA;
	Fri, 31 Jul 2026 22:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785535546;
	bh=gDxFGAAwoPTr/UglJFOeKnjYptQJcRKDrD2w3wSu0DY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Mh3wC42PUHVbj7EH63VC3qQzqESMbXwVqrDIJPX8B7az7wNBp/k/X5ocS3jKEoXrJ
	 sM5UOgPIagoACZV18jF0SG2oEMDcF4PG0RrCFMoFKSBQ60C1pZFI0ShRpfcm8cUlY+
	 43222NQtd+nv2cLBy+SmgHHXwCQfT0DRCAI9fpbGaI/1iQHHvwMb89n8s3/u35fCdW
	 MPeyCnN39j4bVQJhKOJa4Z4tJ3IDrg6xRJ1nGKvwai2CVl5sHteO8a/zmd/OZvmhI3
	 P8fT3mD2FzqgfdQbfQYf4VqbYK3vH2CVUNmgLdpEn98n0I2WpJzDV2uJWOCb6na1vL
	 maP4Z9ugn4ZuA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 6/6] scsi: core: Enable lock context analysis
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <377b28286cab215eea4e6f0f35ba5a9c4eff3455.1785534722.git.bvanassche@acm.org>
References: <68f3346cab2be570839350831f82b6c9233832ed.1785534721.git.bvanassche@acm.org>
 <377b28286cab215eea4e6f0f35ba5a9c4eff3455.1785534722.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 31 Jul 2026 22:05:46 +0000
Message-Id: <20260731220546.9368C1F00ACA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Makefile variables intended to enable lock context analysis are =
incorrectly named due to missing 'scsi_' prefixes, failing to enable analys=
is for most intended SCSI core files.
--

--- Patch [6]: [PATCH v4 6/6] scsi: core: Enable lock context analysis ---
commit 72acfbb8a25ff6235de3b56d2113eb7681fd8184
Author: Bart Van Assche <bvanassche@acm.org>

scsi: core: Enable lock context analysis

Enable lock context analysis for those SCSI core files that build
without triggering any compiler warnings.

> diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
> index 842c254bb2269..69ea80819f3ba 100644
> --- a/drivers/scsi/Makefile
> +++ b/drivers/scsi/Makefile
> @@ -14,6 +14,28 @@
>  # satisfy certain initialization assumptions in the SCSI layer.
>  # *!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!
> =20
> +CONTEXT_ANALYSIS_constants.o :=3D y
> +CONTEXT_ANALYSIS_scsi.o :=3D y
> +CONTEXT_ANALYSIS_scsicam.o :=3D y
> +CONTEXT_ANALYSIS_common.o :=3D y
> +CONTEXT_ANALYSIS_devinfo.o :=3D y
> +CONTEXT_ANALYSIS_dh.o :=3D y
> +CONTEXT_ANALYSIS_ioctl.o :=3D y
> +CONTEXT_ANALYSIS_lib.o :=3D y
> +CONTEXT_ANALYSIS_lib_dma.o :=3D y
> +CONTEXT_ANALYSIS_error.o :=3D y
> +CONTEXT_ANALYSIS_logging.o :=3D y
> +CONTEXT_ANALYSIS_netlink.o :=3D y
> +CONTEXT_ANALYSIS_pm.o :=3D y
> +CONTEXT_ANALYSIS_scan.o :=3D y
> +CONTEXT_ANALYSIS_sysfs.o :=3D y
> +CONTEXT_ANALYSIS_trace.o :=3D y
> +CONTEXT_ANALYSIS_sd.o :=3D y
> +CONTEXT_ANALYSIS_sd_dif.o :=3D y
> +CONTEXT_ANALYSIS_sd_zbc.o :=3D y
> +CONTEXT_ANALYSIS_sr.o :=3D y
> +CONTEXT_ANALYSIS_sr_ioctl.o :=3D y
> +CONTEXT_ANALYSIS_proc.o :=3D y

[Severity: Medium]
Do these Makefile variables need a "scsi_" prefix to match the actual
object files?

For example, drivers/scsi/scsi_ioctl.c generates scsi_ioctl.o, so Kbuild
expects CONTEXT_ANALYSIS_scsi_ioctl.o :=3D y.

Since the target stems do not match the variables (like common, devinfo, dh,
ioctl, lib, lib_dma, error, logging, netlink, pm, scan, sysfs, trace, and
proc), Kbuild will silently ignore them and lock context analysis will not
be enabled for these files.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/68f3346cab2be570839=
350831f82b6c9233832ed.1785534721.git.bvanassche@acm.org?part=3D6
