Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8DBB31F990
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 23:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785453761; cv=none; b=LlsrGEJRaXuPa37iaQEB3sJwHzuqaT/wIp4Pak4+bx7LwjRHvnRSkGwXTFIyTjHF8LzL45UWHqvkNj+b3gDMg6f4lS3dI93bc8oxOdlZ7aZKwqJ+VeZyB/j2XnezbfsZCyb5934lF7qvjH3rB7IophwLmAATmUcz2ImdxL6JrKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785453761; c=relaxed/simple;
	bh=3YFieFzMq+4FH/SFYgVLeaE1Ic6ZZYnoqmTuRuinc7o=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bBF9LeQ+0+5UStiWUPXMq+ZSEEizQ7SJUw5jxR22ief2Aa2OVDv9bqivbMZ124WVruJJLvgwLGhjUP/p4y0VaDVtnQBDpAawyiukM7D6Zo3tP76ukVPJazuFb0ggLOw4zG5qcjvFYQ3YeIn2NC5XcK+9AyyQwFDJ1YWm1o0Kxic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BnRv83xy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BnRv83xy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 502CD1F000E9;
	Thu, 30 Jul 2026 23:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785453760;
	bh=0YHkVJ44LL2MbV1vHCB5l7+mX8IIoSWAdw50i8yDuu0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BnRv83xyEki3rKjuPyoPbi2PeuL7J/EmEw1MhevA4mTgkHIJqo/gYoWahcskhnFx2
	 2476sjPMc2CKeB8Tif49nzz9Tva2aOAka9OkBXToziC9taJ3Tf2y4PduQIdaNw39/W
	 ER2mroS6y8IUSbiPXYhr+gpzRcGPgS5TbxYrMRy1XF8SoxdIuTtqV79zJrZquSXzTk
	 +seGS9y90ekgYdb4uZ0U1blvUJo7RWre6iw4TXlAPh97IJHo6oVFkppl2Z7/4+DcQn
	 Z1zinEg6TrHS+LJ33kjjh4yElyryB79YdW97SaC9RhDk0++3JogKCoi3fmlgoxjiJu
	 x+fyz/0u5jwIw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 55/57] scsi: core: Pass the SCSI host pointer
 directly
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <c267516c9a512b98b39d817f25f74a44b55a8d51.1785451174.git.bvanassche@acm.org>
References: <cover.1785451174.git.bvanassche@acm.org>
 <c267516c9a512b98b39d817f25f74a44b55a8d51.1785451174.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 23:22:39 +0000
Message-Id: <20260730232240.502CD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] The kernel-doc block for `scsi_report_lun_scan()` was not updated t=
o document the newly added `shost` parameter.
--

--- Patch [55]: [PATCH v3 55/57] scsi: core: Pass the SCSI host pointer dir=
ectly ---
commit 843d3f98c1bc1414a3f6276906221ddaef557d90
Author: Bart Van Assche <bvanassche@acm.org>

scsi: core: Pass the SCSI host pointer directly

In several SCSI scanning functions, the SCSI host pointer is derived from
the SCSI target pointer. This patch updates these functions to pass the
SCSI host pointer directly, preparing for lock context analysis. No
functionality is changed.

> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index e27da038603a2..a8994c07d4154 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c

[ ... ]

> @@ -1438,8 +1440,9 @@ static void scsi_sequential_lun_scan(struct scsi_ta=
rget *starget,
>   *     0: scan completed (or no memory, so further scanning is futile)
>   *     1: could not scan with REPORT LUN
>   **/
> -static int scsi_report_lun_scan(struct scsi_target *starget, blist_flags=
_t bflags,
> -				enum scsi_scan_mode rescan)
> +static int scsi_report_lun_scan(struct Scsi_Host *shost,
> +			struct scsi_target *starget, blist_flags_t bflags,
> +			enum scsi_scan_mode rescan)

[Severity: Low]
Should the kernel-doc block for scsi_report_lun_scan() be updated to include
the new @shost parameter?

It looks like the parameter was added to the function signature, but unlike
scsi_probe_and_add_lun() and scsi_sequential_lun_scan(), the documentation
wasn't updated here.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785451174.gi=
t.bvanassche@acm.org?part=3D55
