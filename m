Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36AD0348C64
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 16:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784304148; cv=none; b=XxPDtgDb3NitlH0znFXpZnVGXeVoHTPihv//3fnzpBiSsP45GKH3VC4oD2VbNBLzd6wswfBja4l7fTP8/YNxpBozZra821GNbjx0kZpLyaU3UvRzDq28rwodxAyVFAte73qyZT5hXg99yKTPO+Q2WfaOQIQBGV0qBjjm+ifSBxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784304148; c=relaxed/simple;
	bh=HXk6i9NmvfOMQJE9GepPJR66iEziqNT1b13+Evxtgcc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=E3HzOHdlEuVO9PDmutMlzUi+er/3MMOXIB01UnOjl2kyzQDGjK8RBQIfdEIlwsWGhApbBFz0sF7rIMSii53TdGNNdQ8kDuF4cD2chNE5MBzSh+CqnjF4EbCrkEyLIXzpkcydw525XrSVocLrgCgpORodDAOnuyGXg+FpvRbgo44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IDVGevRo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IDVGevRo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A52771F000E9;
	Fri, 17 Jul 2026 16:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784304146;
	bh=83OMkZnHoiab2nUdQ8e44diWAa2cmBdp2YA6JGSaqmc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IDVGevRoxv/JgRKy+Fp4ukOIadGYdpDld5lyPQGuo9+Blbt6wilBiJHnxe9tOrvpm
	 sLLpfnrBD4uzfcp7fWu9WJ0SxBPm99WtpI6G/myg76o92BXDu7rsbGwc+9h546LCeH
	 xGWe+M0RreH5rbWcq8FalpFLjv6rWWl1cgdRhzxnd4PQrvM9eIe72a9cQTNplc8ht9
	 6xXmTSGgNf4zaiGRoI1WB8qV7di6wXMotlB6Kc3JNyedLyc29mT2+Fr2uKyUpSmpGj
	 rs3bfrYbVZcqMy2wY4LrJOV/4rIRXaLbKMLHWFhzxzlbTr5s1UNQn8MLjCpK7O1FRT
	 AqGlMiJy4GjvA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 07/56] scsi: qla2xxx: Add flash block read/write BSG
 support for 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260717152904.3155730-8-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
 <20260717152904.3155730-8-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 16:02:26 +0000
Message-Id: <20260717160226.A52771F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] Uninitialized usage of `bsg_reply->reply_payload_rcv_len` and part=
ial initialization of `bsg_reply` leads to an information leak and potentia=
l kernel warning.
- [Medium] Incorrect BSG request length validation forces user space to ove=
r-allocate the payload buffer by 8 unused bytes and rejects exactly-sized v=
alid requests.
- [Medium] Passing a 0-length payload to flash block read/write commands tr=
iggers a kernel WARN_ON_ONCE via `vzalloc(0)`.
--

--- Patch [7]: [PATCH v5 07/56] scsi: qla2xxx: Add flash block read/write B=
SG support for 29xx ---
commit a2bf87754d2c500ea1dbb98bcd9b4f70437eb23f
Author: Manish Rangankar <mrangankar@marvell.com>

scsi: qla2xxx: Add flash block read/write BSG support for 29xx

Introduce QL_VND_READ_FLASH_BLOCK and QL_VND_WRITE_FLASH_BLOCK
BSG vendor commands so that userspace tools can perform flash
block-level operations on 29xx adapters via the isp_ops interface.

> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bs=
g.c
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
[ ... ]
> @@ -1431,42 +1422,79 @@ qla2x00_optrom_setup(struct bsg_job *bsg_job, scs=
i_qla_host_t *vha,
[ ... ]
> +		if (is_update) {
> +			ha->optrom_region_size =3D start +
> +			    bsg_job->request_payload.payload_len >
> +			    ha->optrom_size ?
> +			    ha->optrom_size - start :
> +			    bsg_job->request_payload.payload_len;
> +			ha->optrom_state =3D QLA_SWRITING;
> +		} else {
> +			ha->optrom_region_size =3D start +
> +			    bsg_job->reply_payload.payload_len >
> +			    ha->optrom_size ?
> +			    ha->optrom_size - start :
> +			    bsg_job->reply_payload.payload_len;
> +			ha->optrom_state =3D QLA_SREADING;
> +		}
[ ... ]
>  	ha->optrom_buffer =3D vzalloc(ha->optrom_region_size);
>  	if (!ha->optrom_buffer) {

[Severity: Medium]
If a user space tool sends a flash block read or write command with a=20
payload length of 0, ha->optrom_region_size will become 0.

Won't calling vzalloc(0) here trigger a WARN_ON_ONCE(!size) in the kernel=20
memory allocator?=20

Should there be an explicit check to reject 0-length payloads early to=20
prevent this warning and potential system instability if panic_on_warn=20
is enabled?

[ ... ]
> @@ -1554,6 +1592,234 @@ qla2x00_update_optrom(struct bsg_job *bsg_job)
[ ... ]
> +static int qla29xx_bsg_flash_block_read(struct bsg_job *bsg_job)
> +{
[ ... ]
> +	if (bsg_job->request_len < sizeof(struct fc_bsg_request) +
> +	    2 * sizeof(uint32_t) + sizeof(struct qla_block_rw))
> +		return -EINVAL;

[Severity: Medium]
Does this length calculation double-count the first two elements of the=20
vendor command array?

Since sizeof(struct fc_bsg_request) is 20 bytes and the vendor_cmd array=20
starts at offset 12, vendor_cmd[2] is at offset 20. Adding=20
2 * sizeof(uint32_t) requires an extra 8 bytes that are already accounted=20
for in the struct size.

Will this reject perfectly sized valid requests and force userspace to=20
over-allocate the payload buffer by 8 unused bytes?

[ ... ]
> +static int qla29xx_bsg_flash_block_write(struct bsg_job *bsg_job)
> +{
[ ... ]
> +	if (bsg_job->request_len < sizeof(struct fc_bsg_request) +
> +	    2 * sizeof(uint32_t) + sizeof(struct qla_block_rw))
> +		return -EINVAL;

[Severity: Medium]
Is this subject to the same length calculation issue as the flash block=20
read path above, where it over-estimates the required request size?

[ ... ]
> +	vfree(ha->optrom_buffer);
> +	ha->optrom_buffer =3D NULL;
> +	ha->optrom_state =3D QLA_SWAITING;
> +	mutex_unlock(&ha->optrom_mutex);
> +	bsg_job->reply_len =3D sizeof(struct fc_bsg_reply);
> +	bsg_job_done(bsg_job, bsg_reply->result,
> +			bsg_reply->reply_payload_rcv_len);
> +	return 0;
> +}

[Severity: High]
Because bsg_reply->reply_payload_rcv_len is never initialized in=20
qla29xx_bsg_flash_block_write(), could this pass a stale value from a=20
previous IO back to bsg_job_done()?

If the block layer reuses the kzalloc'd job->reply buffer from initializati=
on,=20
setting bsg_job->reply_len to the full size of struct fc_bsg_reply might=20
copy this partially uninitialized buffer to userspace, leaking kernel memor=
y=20
and potentially triggering a WARN_ON in the BSG layer if the stale value=20
is too large.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717152904.3155=
730-1-njavali@marvell.com?part=3D7
