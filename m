Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F5D44F54B
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 08:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792054555; cv=none; b=feKcVB3Wx/cmrL3E5IKfQlhCY3oBSCAegjmToftlFyO89nS6HzP2JZ5+Iq4l4q9l3bqpAMGjD+BvIk9/1r7nh9jpVpOXkeZPvx0uY7XTq3276pbemid71UH4OoXmJOR7oHGWdzCOFLOeRJCt9jbgFZnuW8ZJSkDAspRnAq41PFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792054555; c=relaxed/simple;
	bh=3rnD5YXymhokr5rpzqkeAaG+xaQfFb6tCKs5uDomhhI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=ERNIf4NPiubp4TfbhQCssT921jvJf0cxO9+IFfhRW9NZanLaT4/6uJSkPeVVaEkdoRUGt93mVvASfj6uTccIdKGnXeXhMzE9VXsHb5Fp2gcKVK8HoSgVJncRCBnYs2ii0VoN3p2pKwPfItlnKtmGwdPPTz65Z1APkQyhhnE1vKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J7resfde; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J7resfde"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CB0D1F000C4;
	Thu, 15 Oct 2026 08:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792054554;
	bh=3wGPosTRVpu39627VWEvvyZk1fOTVrun8JSP156m/zQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=J7resfde2nGuvIRcYX9K+GWluEHF3Lb87aJPjmZSTGL1eKFqz3vdwURNTVToHb+xe
	 hwY25TztwyOrWEYhuE/RSauVKOZwdZkbUY7iUvyifG/aKssfvnT+PRIADe1BB5Wrhs
	 t+pO/pX0j/w1VwcjRGZJSuZLDl7e61DJStFRk2/4ymLHjhaBFrqFdtbOmsqQMfcPwV
	 yzjUAr5Z2JzB2HDlKoxEuLI7Ad2noYfNgcXWmR/YN0H2O2NdN0GbKgEtJIZ4Yafzlq
	 wG4snX9fBiad+9WIwdQxP/s4tFvNM7GF0uPtZ10IvUd5aUoEhM8xMpolCxrLMFNtW6
	 mNdee3tBh574g==
Message-ID: <sashiko-outbox-172524@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 5/5] scsi: aic94xx: check that an ESCB lookup
 returned an ESCB
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261015081935.4168771-6-yhlee@isslab.korea.ac.kr>
References: <20261015081935.4168771-1-yhlee@isslab.korea.ac.kr>
 <20261015081935.4168771-6-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 08:55:53 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: aic94xx: UAF race condition due to lockless escb access
--

commit 61c788d589a8ac9597298b6297ce45bf72a70621
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: aic94xx: check that an ESCB lookup returned an ESCB

This commit adds checks to verify that an ESCB lookup actually returns an
Empty SCB by inspecting the opcode.

> diff --git a/drivers/scsi/aic94xx/aic94xx_task.c b/drivers/scsi/aic94xx/a=
ic94xx_task.c
> --- a/drivers/scsi/aic94xx/aic94xx_task.c
> +++ b/drivers/scsi/aic94xx/aic94xx_task.c
> @@ -170,6 +170,14 @@ static void asd_get_response_tasklet(struct asd_ascb=
 *ascb,
>  		return;
>  	}
> =20
> +	if (escb->scb->header.opcode !=3D EMPTY_SCB) {

[Severity: High]
Does checking the escb->scb->header.opcode outside of the tc_index_lock
introduce a race condition?

If the hardware returns a bogus index corresponding to a live task, could
that task concurrently time out and be freed while we are evaluating the
opcode? This appears to introduce a use-after-free read when dereferencing
escb->scb since the tc_index_lock was already dropped earlier in
asd_get_response_tasklet().

> +		ASD_DPRINTK("index_escb %d is not an ESCB, opcode is 0x%x!\n",
> +			    le16_to_cpu(resp_sb->index_escb),
> +			    escb->scb->header.opcode);
> +		ts->stat =3D SAS_INTERRUPTED;
> +		return;
> +	}
> +

[ ... ]

> diff --git a/drivers/scsi/aic94xx/aic94xx_tmf.c b/drivers/scsi/aic94xx/ai=
c94xx_tmf.c
> --- a/drivers/scsi/aic94xx/aic94xx_tmf.c
> +++ b/drivers/scsi/aic94xx/aic94xx_tmf.c
> @@ -282,6 +282,13 @@ static int asd_get_tmf_resp_tasklet(struct asd_ascb =
*ascb,
>  		return res;
>  	}
> =20
> +	if (escb->scb->header.opcode !=3D EMPTY_SCB) {

[Severity: High]
Can this lockless access to escb->scb in asd_get_tmf_resp_tasklet() also
risk a use-after-free if the escb is concurrently freed?

> +		ASD_DPRINTK("index_escb %d is not an ESCB, opcode is 0x%x!\n",
> +			    le16_to_cpu(resp_sb->index_escb),
> +			    escb->scb->header.opcode);
> +		return res;
> +	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015081935.4168=
771-1-yhlee@isslab.korea.ac.kr?part=3D5
