From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 1/3] sd: Make discard granularity match logical block
 size when LBPRZ=1
Date: Tue, 24 Nov 2015 13:52:58 +0100
Message-ID: <1448369578.2877.32.camel@suse.de>
References: <1447451209-30772-1-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53774 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753406AbbKXMw7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Nov 2015 07:52:59 -0500
In-Reply-To: <1447451209-30772-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

On Fri, 2015-11-13 at 16:46 -0500, Martin K. Petersen wrote:
> A device may report an OPTIMAL UNMAP GRANULARITY and UNMAP
> GRANULARITY
> ALIGNMENT in the Block Limits VPD. These parameters describe the
> device's internal provisioning allocation units. By default the block
> layer will round and align any discard requests based on these
> limits.
>=20
> If a device reports LBPRZ=3D1 to guarantee zeroes after discard,
> however,
> it is imperative that the block layer does not leave out any parts of
> the requested block range. Otherwise the device can not do the
> required
> zeroing of any partial allocation units and this can lead to data
> corruption.
>=20
> Since the dm thinp personality relies on the block layer's current
> behavior and is unable to deal with partial discard blocks we work
> around the problem by setting the granularity to match the logical
> block
> size when LBPRZ is enabled.
>=20
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
> =C2=A0drivers/scsi/sd.c | 23 ++++++++++++++++++-----
> =C2=A01 file changed, 18 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 3f370228bf31..c322969026bc 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -636,11 +636,24 @@ static void sd_config_discard(struct scsi_disk
> *sdkp, unsigned int mode)
> =C2=A0	unsigned int max_blocks =3D 0;
> =C2=A0
> =C2=A0	q->limits.discard_zeroes_data =3D 0;
> -	q->limits.discard_alignment =3D sdkp->unmap_alignment *
> -		logical_block_size;
> -	q->limits.discard_granularity =3D
> -		max(sdkp->physical_block_size,
> -		=C2=A0=C2=A0=C2=A0=C2=A0sdkp->unmap_granularity * logical_block_si=
ze);
> +
> +	/*
> +	=C2=A0* When LBPRZ is reported, discard alignment and granularity
> +	=C2=A0* must be fixed to the logical block size. Otherwise the
> block
> +	=C2=A0* layer will drop misaligned portions of the request which
> can
> +	=C2=A0* lead to data corruption. If LBPRZ is not set, we honor
> the
> +	=C2=A0* device preference.
> +	=C2=A0*/
> +	if (sdkp->lbprz) {
> +		q->limits.discard_alignment =3D 0;
> +		q->limits.discard_granularity =3D 1;
> +	} else {
> +		q->limits.discard_alignment =3D sdkp->unmap_alignment
> *
> +			logical_block_size;
> +		q->limits.discard_granularity =3D
> +			max(sdkp->physical_block_size,
> +			=C2=A0=C2=A0=C2=A0=C2=A0sdkp->unmap_granularity *
> logical_block_size);
> +	}
> =C2=A0
> =C2=A0	sdkp->provisioning_mode =3D mode;
> =C2=A0

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
