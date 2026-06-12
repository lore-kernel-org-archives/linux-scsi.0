Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54208248B
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 10:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781259363; cv=none; b=oDMtKBk7omBvbw1y/p3JiD2STUlHNqlzoKS+n+AhQfWky13PBL+9gxVgylXxRTsia+FcaYZna0M0PZJt4wyrHEYuZA/cPJZNSzNCqlEqN6lA8hJxZT6o1cpgI4K2+mF4AWQd9NkP/J1nl1EnQ0C9VNukFBx5uhmweY7QftOXg/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781259363; c=relaxed/simple;
	bh=xCQSrK0JWCAdlBNLWv18jJgA7JN9GlAiuOL8CpUk6XI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=f+fi2RZoTdKzh+7Cf6RoxI8U8vtZYv9dMawPgU3IO1Ur4JgW8xMArPbkj1V6i87wKtM/txUSf7fBPH0ixWhnFvsXilfJMZqe2dTsg1itiDUCbeW49KWxEFys3ek8ScC8wLb/0KBFa5qAHcdyP9Ai6SWUT4ajfDt/AKKbGsKvgQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NidBRXe7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NidBRXe7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 214AA1F000E9;
	Fri, 12 Jun 2026 10:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781259362;
	bh=BHF2zuSdr+KWX/xmh1zDhUZrZD+maNPcjk1URjHZQmo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NidBRXe7J9GWLS7h+PJoapLloFEMGngOByQRzaxH/ZBS48CWAQt01GkW0TYU/W9YA
	 /7a4gD2kUtL8V8uQiXFNhNABczOt8qXNl2FsuErpdkblDP/vDkcTNU9Uu5QpIvdGYs
	 OTHpcegwdwuj79zP/oq2oUD3sSicl/MCFVRxohQaCCybJW8k7kw0hjs3j24+Gojq0F
	 8JCpoMPZD9FND9GRe3iCW1cmiUgALhgEiXzTtkMCr0WvY8VssqoS+S/4mTrW2pq6iH
	 TO6YyUM96HYpOdJu7wtcCVnnaZOsKKkojpxYBF/2WWsb2DI1RKcw30VfhgER/j5mWZ
	 kSboPn9Nq46wA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 02/60] scsi: qla2xxx: Add flash read/write interface
 for 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260612095333.1666592-3-njavali@marvell.com>
References: <20260612095333.1666592-3-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 12 Jun 2026 10:16:01 +0000
Message-Id: <20260612101602.214AA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] FLT version check is bypassed due to incorrect logical operator an=
d signature constant.
- [High] Flash layout parsing iterates over regions using a fixed struct si=
ze instead of the firmware-provided `region_size`.
- [High] Unprotected concurrent modification of `ha->flt_data` during ISP a=
bort can cause out-of-bounds reads in sysfs/BSG handlers.
--

commit 406f516c2c12956321654662c33a7512be63f8be
Author: Manish Rangankar <mrangankar@marvell.com>

scsi: qla2xxx: Add flash read/write interface for 29xx

The 29xx series uses a different flash access mechanism than
earlier adapters. Add the mailbox wrappers and qla_sup helpers
needed for flash read and write operations, including the
necessary hooks in isp_ops so that the existing flash
infrastructure can drive the new hardware.

> diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_su=
p.c
> index b6c36a8a2d60b..eb10904f14caa 100644
> --- a/drivers/scsi/qla2xxx/qla_sup.c
> +++ b/drivers/scsi/qla2xxx/qla_sup.c
> @@ -10,6 +10,651 @@
>  #include <linux/vmalloc.h>
>  #include <linux/uaccess.h>
> =20
> +/**
> + * qla29xx_get_flt_layout - Retrieve the flash layout table (FLT) for QL=
A29xx.
[ ... ]
> +static void
> +qla29xx_get_flt_layout(scsi_qla_host_t *vha)
> +{
> +	struct qla_hw_data *ha =3D vha->hw;
> +	struct qla_flash_layout *flt_layout =3D ha->flt_data;
> +	struct qla_flt_region_header *flt_header =3D &flt_layout->flt_header;
> +	struct qla_flt_region_data *region =3D &flt_layout->region[0];
> +	uint32_t flt_options =3D 0;
> +	uint32_t flt_size;
> +	uint32_t cnt, chksum;
> +	uint16_t reg_cnt, i;
> +	__le32 *wptr;
> +	void *buf =3D NULL;
> +
> +	flt_size =3D sizeof(struct qla_flt_region_header);
> +	wptr =3D (__force __le32 *)ha->flt_data;
> +
> +	buf =3D qla29xx_read_optrom_data(vha, FLT_REG_MINI_FLT, flt_options,
> +				       ha->flt_data, 0, flt_size);

[Severity: High]
Is ha->flt_data safe from concurrent modification here?

This function can be reached asynchronously via the DPC thread during an
ISP abort (qla2x00_do_dpc -> qla2x00_abort_isp -> qla2x00_setup_chip ->
qla2xxx_get_flash_info), and it unconditionally overwrites ha->flt_data
without acquiring ha->optrom_mutex.

Concurrently, a sysfs or BSG read request might execute
qla29xx_get_flash_region(), holding only ha->optrom_mutex. If this
overwrite happens at the same time, the reading thread could see a torn
or garbage region_count value (up to 65535). Since the flt_data array is
sized for 255 regions, the subsequent loop could read far past the
allocated buffer bounds.

> +	if (!buf) {
> +		ql_log(ql_log_warn, vha, 0x007b,
> +		    "Failed to read FLT information.\n");
> +		goto exit_flt;
> +	}
> +
> +	ql_dbg(ql_dbg_init + ql_dbg_buffer, vha, 0x0111,
> +	       "Contents of Flash Layout (0x%x):\n", flt_size);
> +	ql_dump_buffer(ql_dbg_init + ql_dbg_buffer, vha, 0x0112,
> +		       ha->flt_data, flt_size);
> +
> +	/* check flt version checksum and other info */
> +	if ((le32_to_cpu(*wptr) =3D=3D 0xffff) &&
> +	    flt_header->version !=3D cpu_to_le32(FLT_HDR_VERSION)) {

[Severity: High]
Will this correctly catch corrupted or invalid FLT headers?

It looks like the logical && is used instead of ||, and the 32-bit
pointer is checked against 0xffff (which resolves to 0x0000ffff)
instead of 0xffffffff for an empty flash block.

Because both conditions must be true for the error to trigger, corrupted
or uninitialized flash data with an incorrect version but a first DWORD
other than 0x0000ffff might silently bypass this validation check. This
would allow the driver to parse garbage data as valid flash layout
regions.

> +		ql_log(ql_log_warn, vha, 0x007c,
[ ... ]
> +	ql_dbg(ql_dbg_init, vha, 0x007f,
> +		"FLT detected: version=3D0x%08x length=3D0x%08x signature=3D0x%08x reg=
ion_count=3D0x%04x region_len=3D0x%04x segment_len=3D0x%08x checksum=3D0x%0=
8x.\n",
> +		le32_to_cpu(flt_header->version),
> +		le32_to_cpu(flt_header->length),
> +		le32_to_cpu(flt_header->signature),
> +		le16_to_cpu(flt_header->region_count),
> +		le16_to_cpu(flt_header->region_size),
> +		le32_to_cpu(flt_header->segment_size),
> +		le32_to_cpu(flt_header->checksum));
> +
> +	for (i =3D 0; reg_cnt; i++, reg_cnt--) {
> +		region =3D &flt_layout->region[i];

[Severity: High]
Could this array indexing result in misaligned memory reads?

The total flash layout size is calculated dynamically using
le16_to_cpu(flt_header->region_size). However, standard C array indexing
(&flt_layout->region[i]) strides by the compile-time size of
struct qla_flt_region_data.

If the firmware provides a region_size that differs from
sizeof(struct qla_flt_region_data) due to padding or future extensions,
the pointer arithmetic will be misaligned, causing the driver to read
garbage memory for subsequent regions.

> +		ql_dbg(ql_dbg_init, vha, 0x0080,
[ ... ]
> +static int
> +qla29xx_get_flash_region(struct scsi_qla_host *vha, uint32_t code,
> +			 struct qla_flt_region_data *region)
> +{
> +	struct qla_hw_data *ha =3D vha->hw;
> +	struct qla_flash_layout *flt =3D ha->flt_data;
> +	struct qla_flt_region_header *flt_hdr =3D &flt->flt_header;
> +	struct qla_flt_region_data *flt_reg =3D &flt->region[0];
> +	uint16_t cnt;
> +	int rval =3D QLA_FUNCTION_FAILED;
> +
> +	if (!ha->flt_data || !ha->flags.valid_flt)
> +		return QLA_FUNCTION_FAILED;
> +
> +	cnt =3D le16_to_cpu(flt_hdr->region_count);
> +	for (; cnt; cnt--, flt_reg++) {

[Severity: High]
Does this loop also suffer from the same fixed-size stride issue as above?

Using flt_reg++ advances the pointer by sizeof(struct qla_flt_region_data)
rather than the dynamic region_size provided by the firmware. If those
sizes differ, this will misalign and read garbage memory.

> +		if (le16_to_cpu(flt_reg->region_code) =3D=3D code) {
> +			memcpy((uint8_t *)region, flt_reg,
> +			    sizeof(struct qla_flt_region_data));
> +			rval =3D QLA_SUCCESS;
> +			break;
> +		}
> +	}
> +
> +	return rval;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260612095333.1666=
592-1-njavali@marvell.com?part=3D2
