Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2978F274658
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 00:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792024326; cv=none; b=Ah4Gy1YL5RnmlOTNQ1YfbAx5so5AkS05jDv7LLwJgdtCM5YVcN34YaLpECKnSKh03e3r3Nqjc2IeolrFqZk0FNhQnAhR0NFogl/jF6EtA7lUz9NtQgcW2bvB47ejuQP85UhbMPJO1xhjUZAE7F5m+PGhBg9lYiHQG5Hn0zyC/Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792024326; c=relaxed/simple;
	bh=M0N0K+x5+yG951A2mhSo7l9NGrdUB15xMzakqzUlmP4=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=psHcSv+TH9QY/VtDnJutW3S/TiZXqjstz6JEzPmJ8f6Z9jSdD+QmwvhcvQDuuydzVIHBcnYzJIUP/atGXWVGeLcX24PvAyE91316tPm4VRv4BqNUWojp0Mfpw5IOmFKlRXT89y2FDVFD2Ka9PggOst7DymhUZSKbzmVH1dQggdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sz0envr/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sz0envr/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C191F000C4;
	Thu, 15 Oct 2026 00:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792024324;
	bh=wRo6ybQZdty3rgFKDDQUAp8Qq7SLZtMXUUkfJUQJzJc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Sz0envr/K34PWeyHiIOin3oVnFRYpvCCVMKuUlGdF1U5aXTV469JnFQpF0ZnT0dhy
	 MXb22NkYyEouWikVzg9nIHfwMD+9Y9rFtHFm+E7E5b7Thy5Q9K1aXJ0MDOJIffHL/y
	 sXuLqhmLTnJkY2zhR1XQLbwrDAmGVwT+6hmqHTMnWlbpU1V1tIY2mv9h01w2rjl5qB
	 5YvbNmkzWbhf4jkEq8rXEqX2sQWNIBGfz0h6sQnSYjOd0v7Bj9SMPH2S2ZFS5KCIPL
	 EHZCtCZcEatlOcAfR4WwsV+1sXPIYwvnEDU18k7MW1PbJml+nJ97fJ74sl7Mkcuv3g
	 gu+ulUVC6+RNg==
Message-ID: <sashiko-outbox-172056@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 5/5] scsi: ufs: core: Clear stale UIC result byte
 before peer DME retries
Reply-To: sashiko-reviews@lists.linux.dev
To: "Stanley Jhu" <stanleyjhu@google.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261015001855.3450573-6-stanleyjhu@google.com>
References: <20261015001855.3450573-1-stanleyjhu@google.com>
 <20261015001855.3450573-6-stanleyjhu@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 00:32:04 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] ufs: race in ufshcd_dispatch_uic_cmd() between retry and late inte=
rrupt
--

commit 2dc892f166dff54aa2e190ad9b52806532df339b
Author: Stanley Jhu <stanleyjhu@google.com>

scsi: ufs: core: Clear stale UIC result byte before peer DME retries

This commit clears the stale UIC result byte and restores argument3 when an
attempt fails before peer DME retries. This prevents a transient failure fr=
om
becoming a hard failure after retries due to uncleared error codes.

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index bcc2512bf34b8..7532fd916bfd9 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -4400,9 +4400,12 @@ int ufshcd_dme_set_attr(struct ufs_hba *hba, u32 a=
ttr_sel,
>  	do {
>  		/* for peer attributes we retry upon failure */
>  		ret =3D ufshcd_send_uic_cmd(hba, &uic_cmd);
> -		if (ret)
> +		if (ret) {
>  			dev_dbg(hba->dev, "%s: attr-id 0x%x val 0x%x error code %d\n",
>  				set, UIC_GET_ATTR_ID(attr_sel), mib_val, ret);
> +			uic_cmd.argument2 &=3D ~MASK_UIC_COMMAND_RESULT;
> +			uic_cmd.argument3 =3D mib_val;
> +		}
>  	} while (ret && peer && --retries);

[Severity: High]
Can a retried UIC command be prematurely completed by a late interrupt from=
 a
previous timed-out command?

If a call to ufshcd_send_uic_cmd() times out, the retry loop immediately
invokes it again. In ufshcd_dispatch_uic_cmd(), the new command is assigned
to hba->active_uic_cmd without holding the host_lock:

drivers/ufs/core/ufshcd.c:ufshcd_dispatch_uic_cmd() {
    ...
    hba->active_uic_cmd =3D uic_cmd;
    ...
}

If a late interrupt from the previously timed-out command fires right after
this assignment, the ISR will read the new command under host_lock and
complete it prematurely:

drivers/ufs/core/ufshcd.c:ufshcd_uic_cmd_compl() {
    ...
    guard(spinlock_irqsave)(&hba->host->host_lock);
    cmd =3D hba->active_uic_cmd;
    if (!cmd) {
    ...
}

This could lead to invalid configuration and potential controller
desynchronization, since the new command is completed using the old command=
's
result.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015001855.3450=
573-1-stanleyjhu@google.com?part=3D5
