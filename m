Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E8938F255
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 09:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789376595; cv=none; b=jJQGa2pA3vvEnhSTBoL+MR9EIfkINbjeJf55pbQfzqDnlvUL/G8VuY7+RxUjzzHcXb2mqC0Uw2N7gGfIiWLi9LBk2IQik5Idnu1zPW75/v+ihwt3v40rAKL8kKtAiTaSIsfH8mLpmIA2Xj6u9r4Ik6LGOmL9jwRbke1ZUJfR00s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789376595; c=relaxed/simple;
	bh=l1MuEpVsXtSUZCcaDkapUPmhTkASatKaPe1Kp6YGGGw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=By88N0KCEx4+kxSWnUigswCoxld5Ci0SJvMeVZvQHqN5QjjYKLfYxqLbYxl8V/fTTGztrn7UdNyPWEVjRlkumiRUkpZlwUuPKdAh4eAcEgyebKOeFMzAgI7TM5RyLhTWqAdckKkArIUK2sBQzgC5kJznZ7wq5xoEnv7AZZsnrRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GoVjOFzQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GoVjOFzQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0C81F000FF;
	Mon, 14 Sep 2026 09:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789376594;
	bh=8tS05I3d6qg/Es0DuTLlH9AWKu05T0fx3vxHd0AoZbo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GoVjOFzQlt0c2svnwMJUFliwdwUDXAeNlhlQC+3V7D092ThUDmbJA17klqrGR5CNZ
	 Ftv4gkO73BZ+9UBGTGPIcGEPp3eAkxu1D1mFQwHCtNlyaPO/4vQWqa0nsTnjlLmXxN
	 S2uQO77Od5IgZO/9hkNK7Hvvl+W16y6l0olRwYw65fotBaHcI9jH7rgQx3JjwLDOty
	 cxS+ielC7FA4uA5zLvEBcEcE05ypg2p6NNgdRFPnfco9F5IJaoEP6YzIhg6qc/RKmy
	 ohqdIYFDVw/wGhz+vo+7KJNHaIYYj6JfvSXlPNJKNvtSDhtlbLNDCHj75Iz1iWMRcO
	 KBCAV+tE6mCxA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] scsi: ufs: Serve the device init reads from one
 aggregated read
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hyeoncheol Jeong" <hyenc.jeong@samsung.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260914084258epcms2p22f5bea4edaa975dcdcb7d6c838ffd440@epcms2p2>
References: <20260914083838epcms2p1336cbd08ce6ed192eeed9adbad365a93@epcms2p1>
 <CGME20260914083838epcms2p1336cbd08ce6ed192eeed9adbad365a93@epcms2p2>
 <20260914084258epcms2p22f5bea4edaa975dcdcb7d6c838ffd440@epcms2p2>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 09:03:13 +0000
Message-Id: <20260914090313.DD0C81F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Potential unaligned memory access when parsing malicious or buggy =
UFS 5.0 aggregated read packets.
--

commit 6958e42c99c17e67c3aba30be65b988c84328c42
Author: Hyeoncheol Jeong <hyenc.jeong@samsung.com>

scsi: ufs: Serve the device init reads from one aggregated read

The commit caches a UFS 5.0 AGGREGATED READ payload into a buffer during
initialization and serves individual attribute, flag, and string descriptor
requests from the cached packet.

> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index e0254ddb31729..05a2f4532be5d 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c

[ ... ]

> @@ -3816,6 +3816,313 @@ int ufshcd_query_descriptor_retry(struct ufs_hba =
*hba,
>  	return err;
>  }
> =20
[ ... ]
> +/**
> + * ufshcd_agg_group - find a group in the cached aggregated data packet
> + * @hba: per-adapter instance
> + * @type: group type to find
> + * @group_len: set to the group payload length on a hit
> + *
> + * Return: the group payload, or NULL if @type is not present.
> + */
> +static const u8 *ufshcd_agg_group(const struct ufs_hba *hba, u8 type,
> +				  u16 *group_len)
> +{
> +	const u8 *packet =3D hba->agg_packet;
> +	u16 hdr_off =3D 0;
> +
> +	while (packet && hdr_off + QUERY_AGG_GROUP_HDR_SIZE <=3D hba->agg_packe=
t_len) {
> +		const struct utp_agg_group_header *hdr =3D
> +			(const void *)(packet + hdr_off);
> +		u16 next_off =3D be16_to_cpu(hdr->next_group_offset);

[Severity: High]
Can this cause an unaligned memory access crash on strict-alignment
architectures?

Since struct utp_agg_group_header lacks the __packed attribute, the compiler
expects instances of this struct to be 2-byte aligned.

If a UFS device returns an odd value for next_group_offset in the payload,
hdr_off will be odd on the next iteration. Casting packet + hdr_off to
struct utp_agg_group_header * and dereferencing hdr->next_group_offset
would cause the compiler to emit an aligned 16-bit load instruction.

If the pointer is unaligned, this can lead to a hardware alignment exception
when dereferenced. Should this code validate the alignment, use
get_unaligned_be16(), or define struct utp_agg_group_header as __packed?

> +		u16 payload_off =3D hdr_off + QUERY_AGG_GROUP_HDR_SIZE;
> +
> +		if (next_off && (next_off < payload_off ||
> +				 next_off + QUERY_AGG_GROUP_HDR_SIZE > hba->agg_packet_len))
> +			return NULL;
> +
> +		if (hdr->group_type =3D=3D type) {
> +			*group_len =3D (next_off ? next_off : hba->agg_packet_len) -
> +				     payload_off;
> +			return packet + payload_off;
> +		}
> +
> +		if (!next_off)
> +			break;
> +
> +		hdr_off =3D next_off;
> +	}
> +
> +	return NULL;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914083838epcms=
2p1336cbd08ce6ed192eeed9adbad365a93@epcms2p1?part=3D2
