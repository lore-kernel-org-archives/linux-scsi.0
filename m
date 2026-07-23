Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B09F3DB31E
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 07:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784790717; cv=none; b=nb/MxGp+K50coz5/5+VhSJ90QcnR6ZVaGJ2TA8MEkHFpw2OKAWOW8WYDLZWJ59Q8uUqqaw1x34WuNjOsWOwNeHh9UjeJxEvKRr8Dz4sMA4XQMm5ZSCno1Niwmy6g/2ucupHDsAnmoQO3rrdM4hlTJC0V7DN5u/wGO4F3FaDN4gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784790717; c=relaxed/simple;
	bh=65VKIp1lFJOypKMXJSSskKqMz6SAX3FzPmohMA5N4mQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=a3mWbeIVrmN0RT2ISVO+cXzBQ+OB1KWf9bPO1t4yTWxThQ7MdFs+RxBenjeUtiY/SssEs1ftEBBWquX+rsQTIntqxuhWQxwi3kXh0Pb99Xf+eg8ZbjuPSMYLzUKrvaSyXsw+ecP8aylueK1H2bLP4bRQ5lMxpS1g953GeNuyGBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HOi05P0t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HOi05P0t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6843E1F000E9;
	Thu, 23 Jul 2026 07:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784790712;
	bh=9hD7aFIAqEp9C81mc/V3E4AfGMutqvc7ZfX9k98TH1E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HOi05P0tpY3pFxbPciBGyr0gnXuo64sUULAxlmQaFh53+5YoMQ4dWuI8uveXKpoOs
	 HdnwW5T+HrG9Q5Jjfe1TScO3ahwXVo8bi78jq+qM2+bBdIl8tIY6tzJFLkt+eVa4QP
	 Urok5UCvlggOBMKCaeUfYLjAWcJXUhfCXMfy21FIxtvCg4YJLYMPssBF1JXbBFlviX
	 5E7N2sqvmYgzMixKZAwDn6Vl5OC3e/VbZMB63v5iCgRjvfRpgLdifQVMuCxsUkkBlS
	 JqDvkWYN3yAqvSfwtoqZ9kl0hEdQOo6cfEbgOH6Ec96pJzWhiEZFI+D+GaSlUnR3B4
	 FXLkoAY91WgDA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 07/56] scsi: qla2xxx: Add flash block read/write BSG
 support for 29xx
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723050413.3897522-8-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
 <20260723050413.3897522-8-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 07:11:51 +0000
Message-Id: <20260723071152.6843E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Medium] The BSG request length check double-counts the union size, incor=
rectly forcing an 8-byte extraneous padding and rejecting perfectly sized u=
serspace requests with -EINVAL.

Pre-existing issues:
- [High] Unconditional read of vendor_cmd[0] without request_len validation=
 leads to a heap out-of-bounds read if the userspace request is undersized.
--

--- Patch [7]: [PATCH v6 07/56] scsi: qla2xxx: Add flash block read/write B=
SG support for 29xx ---
commit 57ce5ec988753c7bc4221ec14672382fc6af4d41
Author: Manish Rangankar <mrangankar@marvell.com>

scsi: qla2xxx: Add flash block read/write BSG support for 29xx

Introduce QL_VND_READ_FLASH_BLOCK and QL_VND_WRITE_FLASH_BLOCK BSG vendor
commands so that userspace tools can perform flash block-level operations
on 29xx adapters via the isp_ops interface.

> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bs=
g.c
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c

[ ... ]

> @@ -1554,6 +1592,182 @@ qla2x00_update_optrom(struct bsg_job *bsg_job)
>  	return rval;
>  }
> =20
> +/**
> + * qla29xx_bsg_flash_block_read - Read flash block for QLA29XX.
> + * @bsg_job: BSG job structure.
> + *
> + * Returns 0 on success, error code on failure.
> + */
> +static int qla29xx_bsg_flash_block_read(struct bsg_job *bsg_job)
> +{
> +	struct fc_bsg_request *bsg_req =3D bsg_job->request;
> +	struct fc_bsg_reply *bsg_reply =3D bsg_job->reply;
> +	struct Scsi_Host *host =3D fc_bsg_to_shost(bsg_job);
> +	scsi_qla_host_t *vha =3D shost_priv(host);
> +	struct qla_hw_data *ha =3D vha->hw;
> +	struct qla_block_rw *brcmd;
> +	void *buf;
> +	uint16_t opts =3D 0;
> +	int rval =3D 0;
> +
> +	if (bsg_job->request_len < sizeof(struct fc_bsg_request) +
> +	    2 * sizeof(uint32_t) + sizeof(struct qla_block_rw))
> +		return -EINVAL;

[Severity: Medium]
Does this length check double-count the first two 32-bit words of the vendor
command?

Since sizeof(struct fc_bsg_request) already includes the 16-byte union space
for rqst_data, the first 8 bytes of vendor_cmd are effectively counted twic=
e.

By adding 2 * sizeof(uint32_t), does this incorrectly force an 8-byte paddi=
ng,
causing valid 84-byte requests from userspace tools to be rejected with
-EINVAL unless they are padded to 92 bytes?

[ ... ]

> +static int qla29xx_bsg_flash_block_write(struct bsg_job *bsg_job)
> +{
> +	struct fc_bsg_request *bsg_req =3D bsg_job->request;
> +	struct fc_bsg_reply *bsg_reply =3D bsg_job->reply;
> +	struct Scsi_Host *host =3D fc_bsg_to_shost(bsg_job);
> +	scsi_qla_host_t *vha =3D shost_priv(host);
> +	struct qla_hw_data *ha =3D vha->hw;
> +	struct qla_block_rw *bwcmd;
> +	uint16_t opts =3D 0;
> +	int rval =3D 0;
> +
> +	if (bsg_job->request_len < sizeof(struct fc_bsg_request) +
> +	    2 * sizeof(uint32_t) + sizeof(struct qla_block_rw))
> +		return -EINVAL;

[Severity: Medium]
Similarly, does this length check also mistakenly double-count the first two
32-bit words, incorrectly rejecting valid unpadded write requests?

[ ... ]

> @@ -3007,6 +3221,12 @@ qla2x00_process_vendor_specific(struct scsi_qla_ho=
st *vha, struct bsg_job *bsg_j
>  	case QL_VND_MBX_PASSTHRU:
>  		return qla2x00_mailbox_passthru(bsg_job);
> =20
> +	case QL_VND_READ_FLASH_BLOCK:
> +		return qla29xx_bsg_flash_block_read(bsg_job);
> +
> +	case QL_VND_WRITE_FLASH_BLOCK:
> +		return qla29xx_bsg_flash_block_write(bsg_job);

[Severity: High]
This is a pre-existing issue, but since we are adding new vendor commands
here, is it possible to trigger an out-of-bounds read if the userspace
request is undersized?

Looking at qla2x00_process_vendor_specific() and qla24xx_bsg_request(), the
code unconditionally accesses bsg_request->rqst_data.h_vendor.vendor_cmd[0]
without verifying that bsg_job->request_len is at least 16 bytes.

If a process with CAP_SYS_RAWIO submits a FC_BSG_HST_VENDOR request with
request_len set to 12, the block layer allocates exactly 12 bytes. Reading
vendor_cmd[0] at offset 12 could lead to a heap out-of-bounds read.

Would it make sense to add a request_len bounds check before inspecting
vendor_cmd[0] to prevent this?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723050413.3897=
522-1-njavali@marvell.com?part=3D7
