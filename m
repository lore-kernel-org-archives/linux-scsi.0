Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE7336BCED
	for <linux-scsi@vger.kernel.org>; Wed, 26 Aug 2026 10:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787739785; cv=none; b=giC6ddpvHXwdGAS3E6fb5NWtlKXymGFU6glDkycnBpS90xpUVN0HCs7CHtxE/K2WPwlXGgHbUQeqKSlDvcc6DV+MS3FeKLPk50jUP/41oFXRIzLb9j1oK6jM3Ixu27gWlgewNE462FurMBVFZ8Sn3QytZ7hF80VIPJQxm88H/kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787739785; c=relaxed/simple;
	bh=o14ad/pdKpkdxDMMHB2jYbVaFW+QlueZXkE3uu1iwQA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=I+BoSNWWhHHhqvgP0D3BBIvAE2KGZpaZEjWLh5J7VlAff+wzMkdEjrGiol++/tbYT+ZWmhoi4f8rOYPeZJhmlnh7DInaNajh/11vnvJjEGTpafSfNdvjhFCAGKgjXAwp9R7eeG14FghV0z3zAVFUcCSAPuBpvE3iFnnPFvKXNl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WbpsQ1R6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WbpsQ1R6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A1B1F00A3F;
	Wed, 26 Aug 2026 10:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787739784;
	bh=xWesl3YOYGAUF3cQjjX/5X1IDOsKpqiGfPyzcn9BCME=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WbpsQ1R6euqw25MFWDWASS1tRDcWqRu+hKuM2+5Ays6A2o0Q0NRs0K5EJBX4zJspO
	 hZAog2mKeS1hUj5jqOl6F1Lw/tjc21BH0M6Yf5+SwHjWIs1U1IzPEBY0YSOlLP2yc1
	 Wy7dmgEWIHmmngNTZntm6vKqjcLzkzARuB4KGuFrCQ9t8pPni99lne7JDfiNBDoWFK
	 337S3MWtQ/2sR53ekWlrvCUyANoKo8YfOJeuNszQLYl3wVR+PgB7TqmDsl3+2cPcHT
	 CZ1g1tRYo1Qb/3w2PBzymOTivPj1mEoJPZSpSuL4YfHZ5wykESJGk0BWV7sjRXvZqT
	 hdPe/ahfdpqNg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] scsi: target: iscsi: Reject CDB size exceeding
 available buffer in iscsit_setup_scsi_cmd
Reply-To: sashiko-reviews@lists.linux.dev
To: ghuicao@163.com
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260826100526.106011-1-ghuicao@163.com>
References: <20260826100526.106011-1-ghuicao@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 26 Aug 2026 10:23:03 +0000
Message-Id: <20260826102304.15A1B1F00A3F@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] FORTIFY_SOURCE kernel panic due to out-of-bounds memcpy from fixed=
-size AHS ecdb array.
--

commit c7194730eff1d4be537c227966c11dc80b91b92b
Author: Cao Guanghui <caoguanghui@kylinos.cn>

scsi: target: iscsi: Reject CDB size exceeding available buffer in iscsit_s=
etup_scsi_cmd

This commit fixes a heap out-of-bounds read in iscsit_setup_scsi_cmd()
caused by an initiator claiming a larger SCSI command size than the availab=
le
CDB space. It adds bounds checks to reject the command if the opcode-declar=
ed
CDB size exceeds either the basic header limit or the AHS-provided length.

Fixes: 8f1f7d297bce ("scsi: target: iscsi: Add support for extended CDB AHS=
")

> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/i=
scsi_target.c
> index 62ada3a52210e..56f8fd461192d 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c

[ ... ]

> @@ -1124,6 +1139,20 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn=
, struct iscsit_cmd *cmd,
> =20
>  		cdb_length =3D ahslength - 1 + ISCSI_CDB_SIZE;
> =20
> +		/*
> +		 * The CDB buffer is later re-parsed by scsi_command_size()
> +		 * based on its opcode, which may claim a length larger than
> +		 * the AHS provided. Reject such a mismatch before allocating
> +		 * to avoid an out-of-bounds read of the CDB buffer in
> +		 * target_cmd_init_cdb().
> +		 */
> +		if (scsi_command_size(hdr->cdb) > cdb_length) {
> +			pr_err("Extended CDB AHS: SCSI command size %u exceeds AHS-provided C=
DB length %u, protocol error.\n",
> +			       scsi_command_size(hdr->cdb), cdb_length);
> +			return iscsit_add_reject_cmd(cmd,
> +				ISCSI_REASON_PROTOCOL_ERROR, buf);
> +		}
> +
>  		cdb =3D kmalloc(cdb_length, GFP_KERNEL);
>  		if (cdb =3D=3D NULL)
>  			return iscsit_add_reject_cmd(cmd,
>  				ISCSI_REASON_BOOKMARK_NO_RESOURCES, buf);
>  		memcpy(cdb, hdr->cdb, ISCSI_CDB_SIZE);
>  		memcpy(cdb + ISCSI_CDB_SIZE, ecdb_ahdr->ecdb, cdb_length - ISCSI_CDB_S=
IZE);
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^=
^^^^^^^^^^^^^^^^

[Severity: High]
This is a pre-existing issue, but does this memcpy() risk triggering a
FORTIFY_SOURCE kernel panic?

If a remote attacker sends an iSCSI SCSI CMD PDU with an Extended CDB AHS
where ahslength is large (e.g., 1017), the target accepts it because it is
bounded by the total AHS buffer length.

However, when copying the AHS payload to the newly allocated CDB buffer,
memcpy() reads cdb_length - ISCSI_CDB_SIZE (up to 1016) bytes from
ecdb_ahdr->ecdb.

Since ecdb_ahdr->ecdb is declared as a fixed-size array of 244 bytes
(SCSI_MAX_VARLEN_CDB_SIZE - ISCSI_CDB_SIZE) in include/scsi/iscsi_proto.h:

struct iscsi_ecdb_ahdr {
	...
	/* 4-byte aligned extended CDB spillover */
	uint8_t ecdb[SCSI_MAX_VARLEN_CDB_SIZE - ISCSI_CDB_SIZE];
};

reading more than 244 bytes with CONFIG_FORTIFY_SOURCE=3Dy will detect an
out-of-bounds read and panic the kernel, causing a system-wide Denial of
Service.

Should we restrict ahslength (or cdb_length) to not exceed the maximum allo=
wed
Extended CDB length of 244 bytes?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260826100526.1060=
11-1-ghuicao@163.com?part=3D1
