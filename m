Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B4E448387
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 16:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784046312; cv=none; b=S7JxxE+IIKdvtFKOL6pZ97HUQDtLfjClV/ZtGsYJG8uTRaMlNaGod37Bhq02dOrxa/JnAFlStgiUu14d8hX4ZvSxK6xXS5ZgSEqvcHsLT0A0lH0Al66omQyK6bXYxybQ/v3GQZ9Sk28GVYos8b+GSwWXXCjSbh2Hk9WiY0y2biI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784046312; c=relaxed/simple;
	bh=ronfhR3MtoPQyrj1elbnKCtjinSDJXvrGT0mVKpm4sI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=haTnwewteViPgZQjYJ3r/iMebGh4RZ80nwfiMZpEL8Ef7YElGfMU3fdobQcXmMQstcTb7dqguN4wZE6kQ+dmYN+dX0ttSKmi85VX73KRcA2DkYFvZ5IQZQ/cUPHFWCJo4+/gDVpsxuGX1vv0x9+Jj3suDsaKLugM0r2zpbqRKnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mh12lGP8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mh12lGP8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 639D91F000E9;
	Tue, 14 Jul 2026 16:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784046311;
	bh=+CQJJOmBpoE5grZpG/JuUj8HT4iugNzpEgmhThnvoIY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Mh12lGP8139DjIIjQ4QBes7m4yljoryZO+Ih3nMxUFtk5Yqtfbnag2I6LrbEts3IA
	 QB4QO6TlZqScVENypLB4RbND9/aUNYEEByHTTufXcD3qJajW6+LEeT2xCMYPNIeOiy
	 k1cLRcr0QZJqgHi1dViBKbMV/2OFNaqZJVv8JYNP2SwTOKnzUaY4D9lweMv83CGO9g
	 AO7G4/lFM8cK3/2eAyrtuWcUD1zsmHcfmR08PCiNvKny6NZxSKhSdN5ZT1B8to0ma5
	 Nw0fKPWMVz3jI0NHyk3p++jQNcht+a6817yMWlwwp9bOouIy4ijzxj76r3zBBxYhdW
	 oX6Ys5N5VHn7g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 43/56] scsi: qla2xxx: Use 64-bit FPM word counters
 for 29xx host stats
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260714095353.289460-44-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
 <20260714095353.289460-44-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 14 Jul 2026 16:25:11 +0000
Message-Id: <20260714162511.639D91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] On big-endian platforms, substituting the software approximation=
 for QLA29XX with hardware stats introduces statistics corruption due to a =
pre-existing double byte-swap bug in the hardware stats reading path.
--

--- Patch [43]: [PATCH v4 43/56] scsi: qla2xxx: Use 64-bit FPM word counter=
s for 29xx host stats ---
commit 28f78cc5cc3d52625ba0892069cf854bf1149ff9
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Use 64-bit FPM word counters for 29xx host stats

This commit updates qla2x00_get_fc_host_stats() to use the 64-bit hardware
FPM transmit and receive word counters for QLA29XX adapters. This replaces
the previous software approximation with more accurate hardware counters.

> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_a=
ttr.c
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
[ ... ]
> @@ -2990,7 +2990,8 @@ qla2x00_get_fc_host_stats(struct Scsi_Host *shost)
>  		p->error_frames =3D
>  		    le32_to_cpu(stats->dropped_frames) +
>  		    le32_to_cpu(stats->discarded_frames);
> -		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
> +		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) ||
> +		    IS_QLA29XX(ha)) {
>  			p->rx_words =3D le64_to_cpu(stats->fpm_recv_word_cnt);
>  			p->tx_words =3D le64_to_cpu(stats->fpm_xmit_word_cnt);

[Severity: Medium]
Will this return corrupted statistics on big-endian systems?

The stats buffer is populated earlier by qla24xx_get_isp_stats(), which
converts the entire structure to native byte order by treating it as an arr=
ay
of 32-bit words:

drivers/scsi/qla2xxx/qla_mbx.c:qla24xx_get_isp_stats() {
    ...
			/* Re-endianize - firmware data is le32. */
			for ( ; dwords--; iter++)
				le32_to_cpus(iter);
    ...
}

Because the buffer is already byte-swapped in 32-bit chunks, applying
le64_to_cpu() to the 64-bit fields here will incorrectly swap the two 32-bit
halves relative to each other on big-endian architectures, producing
mangled values.

While this double byte-swap bug was already present for older adapters, this
patch introduces it for QLA29XX by replacing a safe software approximation
with these mangled hardware counters.

>  		} else {
>  			p->rx_words =3D ib >> 2;
>  			p->tx_words =3D ob >> 2;
>  		}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260714095353.2894=
60-1-njavali@marvell.com?part=3D43
