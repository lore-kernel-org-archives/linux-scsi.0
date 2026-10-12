Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52737418353
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 14:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791814329; cv=none; b=jrGAaBtD/eS2GbO2wfB7+2gYaZSzPpLVHiEV+uyo4tHsCg2wVc57TPwsuxTND33khc9961c7u2S42M78fo6caf2lmRCOoKAcfMeGXYJFQqJChK2VnBNSQeughRegRMhAbdupwn+QPvOganE9L1CySsKnlovNqXT13UnpNYRytTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791814329; c=relaxed/simple;
	bh=CPvo+AzxSzNGYJIk8xLfZSV+qAjB6TOvQqyVqYmY3qw=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=s8OJJRjt84R77bwdih76jIcqRTpmLk/GBLtn8ttLEls4XZV1OK0tQrVp3sCQpaek8cxrvov0QtmZYbBnApmVcXsui14/SNuU2DtcYzZGSfdDUsje8kv9iWMWgHgh5iM8+MCkeJeKczgTHGSkjmmu7LPe8mmc3HsJ4HcHJfnWy+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UpWHXGWS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UpWHXGWS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C88E21F0089B;
	Mon, 12 Oct 2026 14:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791814328;
	bh=jY4mNkf8KvWLoRDxtmbB+r+ysInmyTMxZTFuO2QiCwo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UpWHXGWSR5ZQ7Vdlfl7DYzf7jAik1g/uvAkRzvqKzKVq6fxD9JmmS2EhwUjjXwBG2
	 UZRUgH41C7uyDibbv79f/Y7nC6+7N2xwbfCIofCq++hRjN1XDhiESG25eBTRFOoKlO
	 Z9+Y/F6Yz1RKJ9oNmpG/EdpZGVRazaV2c+V1ogYDZYvGQT79dF6HCbsF673sLKrpo/
	 ohI1aqhJnuAB2pAA4ogFcVDg6+q2jah0RUeJz8GbsE5fhICohE97BTNGEeI8x31L0B
	 twtBkDGlCDhVTVwAo8ksKKT3q5nY6+Iob1x/6rDPDJeFghyERzr1XU09qO/pUQp8jv
	 QFea9EHV6waiA==
Message-ID: <sashiko-outbox-168246@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: sg: update local scatter size when clamping
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiacheng Xu" <stitch@zju.edu.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261012135955.78357-1-stitch@zju.edu.cn>
References: <20261012135955.78357-1-stitch@zju.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 14:12:07 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] scsi: sg: compiler reload of lockless global scatter_elem_sz byp=
asses clamp
--

commit c196717f4b3e3f71b450481a3b45198601caf07e
Author: Jiacheng Xu <stitch@zju.edu.cn>

scsi: sg: update local scatter size when clamping

When scatter_elem_sz is set to a value smaller than PAGE_SIZE through
its writable sysfs module parameter, sg_build_indirect() updates the
global scatter element size variables but leaves the local num
variable unchanged.

> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 3f9e08725602c..64ce489128672 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -1863,6 +1863,7 @@ sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * s=
fp, int buff_size)
>  	num =3D scatter_elem_sz;
>  	if (unlikely(num !=3D scatter_elem_sz_prev)) {
>  		if (num < PAGE_SIZE) {
> +			num =3D PAGE_SIZE;
>  			scatter_elem_sz =3D PAGE_SIZE;
>  			scatter_elem_sz_prev =3D PAGE_SIZE;
>  		} else

[Severity: Medium]
Since scatter_elem_sz is a global variable accessed locklessly in
sg_build_indirect(), is there a risk the compiler could reload its value
from memory after the initial read without READ_ONCE()?

If scatter_elem_sz is changed to 0 by a concurrent sysfs write right after
the `num < PAGE_SIZE` check, could a compiler reload in the `else` branch
assign 0 to scatter_elem_sz_prev?

drivers/scsi/sg.c:sg_build_indirect() {
...
		} else
			scatter_elem_sz_prev =3D num;
...
}

If this happens, on the next execution both variables would be 0, causing
`num !=3D scatter_elem_sz_prev` to evaluate to false.

Would this permanently bypass the clamp and pass 0 to get_order(),
reproducing the exact shift-out-of-bounds bug this patch is attempting to
fix?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012135955.7835=
7-1-stitch@zju.edu.cn?part=3D1
