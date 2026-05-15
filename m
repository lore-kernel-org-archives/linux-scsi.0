Received: from lamorak.hansenpartnership.com (lamorak.hansenpartnership.com [198.37.111.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732422DB7B9;
	Fri, 15 May 2026 14:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.37.111.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778856542; cv=none; b=Ym8ooTJ6d1AYvR7NEMrUPq4YpPXPY6kxbvT9vL133u5z4q0Tyi4Dmpi6NfW1OKxmqzTdNPiZ5W5vjo/B+FPbivMfekkBQ37FptH2CoMnGPQkYMe73f8889/zoyJ/4SBVUmRj8EAcSn+Yi1oMyoUGcwkOb1mko1xbUG6g4R/5TwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778856542; c=relaxed/simple;
	bh=jVzMCTviHxDVtDICC8Ut2bndwm5jMSDVya94DaGzzYg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ljs8hBltv+1zHkxceMiCFc8XZMMXz7g9rhid7m+gOt+wCi8UU4alSLhkJqr0pFwN19Kz2by3PTfJh6t5g4o9kKzixurPH+7A+hoEZmA6MVyRYLBHhcPqiNi2wyl3G65NQsOsQikqjl27/KrOHveHIdDeIumiwNdNsfkv4ps6Hbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=YDA8Lg5V; arc=none smtp.client-ip=198.37.111.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="YDA8Lg5V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1778856537;
	bh=jVzMCTviHxDVtDICC8Ut2bndwm5jMSDVya94DaGzzYg=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=YDA8Lg5V+8rlJ4fMmMAdt6JXRzuh5E4bUVuz8idFRpp+kUbF4YYWtMJ1L/goVsjt8
	 RwRuAJ952wmvbx/d0mKqUtud9B5AdKCuygo8SzkpipdwfBbXUl4RM+YGlUWF73tf1V
	 CNUUT3ePo8qg+HlM7Oqrz90DSduYGHIYvLq7GEA4=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:d341:a71:90ff:fec2:f05b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by lamorak.hansenpartnership.com (Postfix) with ESMTPSA id 7F19E1C01B7;
	Fri, 15 May 2026 10:48:57 -0400 (EDT)
Message-ID: <8c46c1982a49cacfac7a984cc09daf41266c82bd.camel@HansenPartnership.com>
Subject: Re: [PATCH 1/2] scsi: pm8001: Redefine sas_identify_frame structure
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Ronja Meyer <rnj@google.com>, Jack Wang <jinpu.wang@cloud.ionos.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, Tom Peng
 <tom_peng@usish.com>, Kevin Ao <aoqingyun@usish.com>, Lindar Liu
 <lindar_liu@usish.com>, James Bottomley <James.Bottomley@suse.de>
Cc: jack wang <jack_wang@usish.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Fri, 15 May 2026 10:48:56 -0400
In-Reply-To: <20260515-fortify_pm80-v1-1-2863187f6d4b@google.com>
References: <20260515-fortify_pm80-v1-0-2863187f6d4b@google.com>
	 <20260515-fortify_pm80-v1-1-2863187f6d4b@google.com>
Autocrypt: addr=James.Bottomley@HansenPartnership.com;
 prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.3 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2026-05-15 at 12:15 +0000, Ronja Meyer wrote:
> The sas_identify structure defined by pm8001 doesn't have a CRC
> field.
> Add a new sas_identify_frame_local structure without the CRC field.
> The equivalent change was already made to the pm80xx driver in:
> commit 5990fd57ebea ("scsi: pm80xx: redefine sas_identify_frame
> structure")
>=20
> Sending to stable, as this change is required for the fortify-panic
> fix
> later in this chain to apply cleanly.
>=20
> Cc: stable@vger.kernel.org
> Fixes: dbf9bfe61571 ("[SCSI] pm8001: add SAS/SATA HBA driver")
> Signed-off-by: Ronja Meyer <rnj@google.com>
> ---
> =C2=A0drivers/scsi/pm8001/pm8001_hwi.h | 101
> ++++++++++++++++++++++++++++++++++++++-
> =C2=A01 file changed, 99 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.h
> b/drivers/scsi/pm8001/pm8001_hwi.h
> index f1ce8df082b0..14b162f93eb8 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.h
> +++ b/drivers/scsi/pm8001/pm8001_hwi.h
> @@ -133,6 +133,103 @@
> =C2=A0
> =C2=A0/* for new SPC controllers MEMBASE III is shared between BIOS and
> DATA */
> =C2=A0#define GSM_SM_BASE			0x4F0000
> +
> +#ifdef __LITTLE_ENDIAN_BITFIELD
> +struct sas_identify_frame_local {
> +	/* Byte 0 */
> +	u8=C2=A0 frame_type:4;
> +	u8=C2=A0 dev_type:3;
> +	u8=C2=A0 _un0:1;
> +
> +	/* Byte 1 */
> +	u8=C2=A0 _un1;
> +
> +	/* Byte 2 */
> +	union {
> +		struct {
> +			u8=C2=A0 _un20:1;
> +			u8=C2=A0 smp_iport:1;
> +			u8=C2=A0 stp_iport:1;
> +			u8=C2=A0 ssp_iport:1;
> +			u8=C2=A0 _un247:4;
> +		};
> +		u8 initiator_bits;
> +	};
> +
> +	/* Byte 3 */
> +	union {
> +		struct {
> +			u8=C2=A0 _un30:1;
> +			u8 smp_tport:1;
> +			u8 stp_tport:1;
> +			u8 ssp_tport:1;
> +			u8 _un347:4;
> +		};
> +		u8 target_bits;
> +	};
> +
> +	/* Byte 4 - 11 */
> +	u8 _un4_11[8];
> +
> +	/* Byte 12 - 19 */
> +	u8 sas_addr[SAS_ADDR_SIZE];
> +
> +	/* Byte 20 */
> +	u8 phy_id;
> +
> +	u8 _un21_27[7];
> +
> +} __packed;
> +
> +#elif defined(__BIG_ENDIAN_BITFIELD)
> +struct sas_identify_frame_local {
> +	/* Byte 0 */
> +	u8=C2=A0 _un0:1;
> +	u8=C2=A0 dev_type:3;
> +	u8=C2=A0 frame_type:4;
> +
> +	/* Byte 1 */
> +	u8=C2=A0 _un1;
> +
> +	/* Byte 2 */
> +	union {
> +		struct {
> +			u8=C2=A0 _un247:4;
> +			u8=C2=A0 ssp_iport:1;
> +			u8=C2=A0 stp_iport:1;
> +			u8=C2=A0 smp_iport:1;
> +			u8=C2=A0 _un20:1;
> +		};
> +		u8 initiator_bits;
> +	};
> +
> +	/* Byte 3 */
> +	union {
> +		struct {
> +			u8 _un347:4;
> +			u8 ssp_tport:1;
> +			u8 stp_tport:1;
> +			u8 smp_tport:1;
> +			u8 _un30:1;
> +		};
> +		u8 target_bits;
> +	};
> +
> +	/* Byte 4 - 11 */
> +	u8 _un4_11[8];
> +
> +	/* Byte 12 - 19 */
> +	u8 sas_addr[SAS_ADDR_SIZE];
> +
> +	/* Byte 20 */
> +	u8 phy_id;
> +
> +	u8 _un21_27[7];
> +} __packed;
> +#else
> +#error "Bitfield order not defined!"
> +#endif

This is basically a duplicate of what's in pm80xx_hwi.h, which looks a
bit ungainly ... couldn't they be unified?  Additionally, it does seem
we could add a #define to the definition in scsi/sas.h to omit the crc
field and allow you to use its definition for both drivers rather than
having to duplicate it like this.

Regards,

James

