Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C84369D47
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 11:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781263003; cv=none; b=FjU1kSjEIr+1sRHWP91eqf6+geJxKzWvfwcAgVh9Y+/q2/CRnHNR79vY0QwdR/A4YFfjdEkVLv7ICXpPivJxGHC/DummTT2xUx9nyUJNQn6mgegelhWZ3qVIcOsOXwMMTtJ7Jr6SJgwne8pUZhPr+j6JLfF4GqknPV+fXvRVEk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781263003; c=relaxed/simple;
	bh=ZOSI329QAw4kV9BNL6bRLXI227tLeqZ/r1VstMyQR9s=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=vAfsLZLcxINlU5goVcgINFzFgIq2pyv+UZmX6/GQfI4qiI8piEO91Vezrifz4ljq+B8Yyjzf1Z09haR7+cc68FrYBlVOanKWJQLyutvtwIGfEB+OP4DueupoXbPGqU+Fa7Kc2FTrP4UkkwPouc3HiSqgodOCwyDTgjDzG8wvlUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NROq0/S2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NROq0/S2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 074071F000E9;
	Fri, 12 Jun 2026 11:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781263002;
	bh=Dem53PfKosay/0T+7nIU7bLOyTOYeqSR5LJaJhBWwmA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NROq0/S2CY83kGPA2MSYNA6aB1mEPhaByE+pPmUvb+38uyLJ0wRtE9Zm3M4r25ZXa
	 21Zx8LC9l/5nv6aQ0d/Jw2lh1M8952lj30l05mo2oaUKE6nHTJksUrFFmYgARxRy9i
	 2qknoPsBwKHAbYGWydJk6QlTTNKFsFE2dHzeCnGvXF50K4JxYyg6CEgCQUZJyz+7xs
	 sjCu7X71la2vCwIt8kEQ4+Ph6N9GDdpsWgonsTN9qpVL6PGqc3pWG9z2ytNiqe+wZ+
	 ILaP2l1jHnWt4RILc5MKhUXzjWa5f6yoqDP4vYVmRXSDwpXSXV2URjawpm6+NKuM6A
	 4OoNv9EP73egQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 44/60] scsi: qla2xxx: Adjust feature gating in BSG
 paths for 29xx support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260612095333.1666592-45-njavali@marvell.com>
References: <20260612095333.1666592-45-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 11:16:41 +0000
Message-Id: <20260612111642.074071F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] D-port diagnostics remain broken for QLA29xx due to a missing do=
wnstream feature check.
--

commit 8ffa642602cccd0180ae4aedb7562a144e25f71e
Author: Manish Rangankar <mrangankar@marvell.com>

scsi: qla2xxx: Adjust feature gating in BSG paths for 29xx support

This commit extends qla2xxx BSG command handling to recognize QLA29xx
adapters and align feature availability with hardware capabilities.
It updates several feature checks to allow QLA29xx in paths previously
restricted to QLA27xx/28xx.

> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bs=
g.c
> index 00e980f0cd782..7f4558beee2c3 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -2741,7 +2741,7 @@ qla2x00_do_dport_diagnostics(struct bsg_job *bsg_jo=
b)
>  	struct qla_dport_diag *dd;
> =20
>  	if (!IS_QLA83XX(vha->hw) && !IS_QLA27XX(vha->hw) &&
> -	    !IS_QLA28XX(vha->hw))
> +	    !IS_QLA28XX(vha->hw) && !IS_QLA29XX(vha->hw))

[Severity: Medium]
Does this change miss an update to the underlying mailbox execution functio=
n?

While qla2x00_do_dport_diagnostics() now allows QLA29xx adapters to proceed,
the lower-level function it calls, qla26xx_dport_diagnostics() in qla_mbx.c,
still appears to have the old hardware check:

drivers/scsi/qla2xxx/qla_mbx.c:qla26xx_dport_diagnostics() {
	...
	if (!IS_QLA83XX(vha->hw) && !IS_QLA27XX(vha->hw) &&
	    !IS_QLA28XX(vha->hw))
		return QLA_FUNCTION_FAILED;
	...
}

Will this cause the diagnostic command to unconditionally fail with
EXT_STATUS_MAILBOX for QLA29xx adapters despite the wrapper permitting it?

>  		return -EPERM;
> =20
>  	dd =3D kmalloc_obj(*dd);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612095333.1666=
592-1-njavali@marvell.com?part=3D44
