Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837EE473C8C
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 18:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786558914; cv=none; b=hO29nBzaY3hKZKh1X+pW0d7detpRbEwXM4BJQue03URUIK/EUZPejUrl1bpld8q/yy49O9BksGeIn59U27qyrNBewKvVpp7W5E5YyzJHS5/WBvw0iItFCvqZssTT3kdbvUtpiyxhAXo6U5e46nM7DGsOD4/kSZKgZkA/TEzJ7hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786558914; c=relaxed/simple;
	bh=Ct/4sGeLY3YsK38WkWgsc8fSmlodn2eGBElumPvlNI8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=P/Mbrr75vpXqDgshmHLAA3bsYkdjgFOaJsfurcegpYnMcjlCgsXOCDhvKtx+gXfdjVVaS5GClyXCXR/q7D0/Naev0cz0kjI3SUJVX0Zz2H/LbfuDcQA7XwOE+gN01RmzTEUuSQnb49SIaf599k23x1TnU0PavxwFnyBd90UPuCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cg+qNnej; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cg+qNnej"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBBD41F000E9;
	Wed, 12 Aug 2026 18:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786558913;
	bh=t+pLMX0owe9b+/tdQ3YtmoaG8Fs8w0dxCksDXd577Ds=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cg+qNnejB4rUJU0hs2a59T2VBc2n51G2iLBWsZfM0jFe+uOttC1e3HgRv3ICel2W/
	 c0HP9wlCwFUWKnKFaFpYw0ppVfGH9x1b7ys5ToI7r/sBRcP824OkdxRxkiSkYq1FbN
	 wlchk0Ch+l9tMQS4HnF+QeEwfLt+pKbBG4A/H23KBmZPtyr9WaZ3WJ2KxhHYr7TaYA
	 0Xmh9n1Bpo0simF8BqnBpMU/7GtTulyZ5iuJpU8KBa78SgQX7qijaNKUan0nQSt4/W
	 pxYFqvcogQAmuJa3l3NKk3WV9W8aRLK7F6xtNwRgMlt8jZA3UIZaHcKhnQwwvLYyuD
	 k08Jbs9qULOWw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 06/13] nvme: sysfs: emit the marginal path state in
 show_state()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jesse Taube" <jtaubepe@redhat.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260812181300.3712426-7-jtaubepe@redhat.com>
References: <20260812181300.3712426-1-jtaubepe@redhat.com>
 <20260812181300.3712426-7-jtaubepe@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 12 Aug 2026 18:21:52 +0000
Message-Id: <20260812182152.DBBD41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Unconditional override of sysfs state attribute with 'marginal', m=
asking critical controller states.
--

--- Patch [6]: [PATCH 06/13] nvme: sysfs: emit the marginal path state in s=
how_state() ---
commit 881ed7168d40f086dcba6f49059055d962ce09aa
Author: Bryan Gurney <bgurney@redhat.com>

nvme: sysfs: emit the marginal path state in show_state()

If a controller has received a link integrity or congestion event, and
has the NVME_CTRL_MARGINAL flag set, emit "marginal" in the state
instead of "live", to identify the marginal paths.

> diff --git a/drivers/nvme/host/sysfs.c b/drivers/nvme/host/sysfs.c
> --- a/drivers/nvme/host/sysfs.c
> +++ b/drivers/nvme/host/sysfs.c
> @@ -527,7 +527,9 @@ static ssize_t nvme_sysfs_show_state(struct device *d=
ev,
>  	};
> =20
>  	if (state < ARRAY_SIZE(state_name) && state_name[state])
> -		return sysfs_emit(buf, "%s\n", state_name[state]);
> +		return sysfs_emit(buf, "%s\n",
> +			(nvme_ctrl_is_marginal(ctrl)) ? "marginal" :
> +			state_name[state]);

[Severity: High]
The commit message mentions emitting "marginal" in the state instead of
"live", but does this implementation unconditionally override all valid
states if the NVME_CTRL_MARGINAL flag is set?

If a marginal controller encounters a fatal error or is deleted, changing i=
ts
internal state to NVME_CTRL_DEAD, NVME_CTRL_RESETTING, or NVME_CTRL_DELETIN=
G,
won't this still emit "marginal" as long as the flag is set?

Could this mask critical controller states and cause userspace tools that
poll this sysfs attribute for teardown or error handling to hang while wait=
ing
for the state to change?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260812181300.3712=
426-1-jtaubepe@redhat.com?part=3D6
