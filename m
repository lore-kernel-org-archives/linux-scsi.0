Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7AB72AEF5
	for <linux-scsi@vger.kernel.org>; Thu,  6 Aug 2026 06:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785996055; cv=none; b=D2/zPAuWitjTpvbmr+CcHCZCNbrdNUb067bwtLS34LyhqEto6XLHetT9DaHLCvNKDbrqyK0Lpk7W70pP21CvUq4P2yJ4XG7jjtLoyh+W8Jo9BDTvX/nmq6X45F1+H0ITKD0YInV//rhKrc7orSGL6/j0RM+LZvbc8ySz7oQpBd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785996055; c=relaxed/simple;
	bh=ZmAn4xYqmNrLccJTQHqX+hPnUdFDOeAMeWIBAZV4sIM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=NgEewIOzXS5hWKvIQb5KkqHCf+d4CraDBu1ZmJVbtHe3y0EI8JJVAUQufqOtKncWEckR/AjR1oVZK5uhtZfAAY0O/OTYg4/7SRoPk12/XpA1YJfQ81jJCkZQTiaj5urYHrp0JGL2RyTxb9Lhz9CCk/U1B5ZvEGWL1xxBddZr30w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JdjiahcR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JdjiahcR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 419661F000E9;
	Thu,  6 Aug 2026 06:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785996053;
	bh=lq7LpVyhC9G0fgq+QMdhatomUhgzmmK6zyRYeCesCHs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JdjiahcRPz4J+DjACbDMIKaWuqeVT49s2otCG/wxKytno/aPpO6JLHO2J+saR2t4u
	 898wdt2w+W+f4VkrsV7lTZ4vWmIcmP1PMPmqfROVeqEA18haWHyqsVpSBYLl7baa7z
	 FTWJOrhp7UqxdmU2kkoKk9UuJ5nrne7S0UbFYqjD5mXNWnmIGORDJ8Ek7oypr98Dwv
	 qfVWt43XTrcj5vkW3eI5itNC0Bf6SQUtEpBJybFLDouJS1L+8yb5zDGdvl8dFTJGUK
	 nvei64xvPHVP1lNIWNBuLXzgrmDgvo6goE7L3n9SqTUPxCZA8SSfy7toF2uX2xootw
	 iqLLgK7CV5iEg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: target: iscsi: Reject Extended CDB AHS when CDB
 size exceeds AHS length
Reply-To: sashiko-reviews@lists.linux.dev
To: ghuicao@163.com
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260806054820.75950-1-ghuicao@163.com>
References: <20260806054820.75950-1-ghuicao@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 06 Aug 2026 06:00:52 +0000
Message-Id: <20260806060053.419661F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The patch addresses the heap out-of-bounds read for Extended CDB A=
HS commands (`hdr->hlength > 0`), but fails to implement a similar bounds c=
heck when the command has no AHS (`hdr->hlength =3D=3D 0`), leaving the exa=
ct same vulnerability open for standard iSCSI commands.
--

--- Patch [1]: [PATCH] scsi: target: iscsi: Reject Extended CDB AHS when CD=
B size exceeds AHS length ---
commit 5a3d59b1c504777c7edf6a6c77fbad41b0da5d11
Author: Cao Guanghui <caoguanghui@kylinos.cn>

scsi: target: iscsi: Reject Extended CDB AHS when CDB size exceeds AHS leng=
th

This commit adds a check to reject iSCSI commands when the SCSI opcode-decl=
ared
size exceeds the AHS-provided length. This prevents an out-of-bounds read
during Extended CDB AHS parsing in target_cmd_init_cdb().

> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/i=
scsi_target.c
> index 62ada3a52210e..e3e9254df9602 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -1124,6 +1124,19 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn=
, struct iscsit_cmd *cmd,
> =20
>  		cdb_length =3D ahslength - 1 + ISCSI_CDB_SIZE;
> =20
> +		/*
> +		 * The CDB buffer is later re-parsed by scsi_command_size() based
> +		 * on its opcode, which may claim a length larger than the AHS
> +		 * provided. Reject such a mismatch before allocating to avoid
> +		 * an out-of-bounds read of the CDB buffer in target_cmd_init_cdb().
> +		 */
> +		if (scsi_command_size(hdr->cdb) > cdb_length) {
> +			pr_err("Extended CDB AHS: SCSI command size %u exceeds AHS-provided C=
DB length %u, protocol error.\n",
> +			       scsi_command_size(hdr->cdb), cdb_length);
> +			return iscsit_add_reject_cmd(cmd,
> +				ISCSI_REASON_PROTOCOL_ERROR, buf);
> +		}
> +

[Severity: High]
This is a pre-existing issue, but does the same out-of-bounds read occur wh=
en
an initiator sends a command without an AHS (hdr->hlength =3D=3D 0)?

If an initiator sends an iSCSI command PDU without an AHS and sets the CDB =
to a
VARIABLE_LENGTH_CMD (cdb[0] =3D 0x7F) with an additional length of 252
(cdb[7] =3D 252), the newly added bounds check is bypassed because it is in=
side
the if (hdr->hlength) block.

In this case, iscsit_setup_scsi_cmd() will pass the raw 16-byte hdr->cdb
pointer directly to target_cmd_init_cdb(). The target_cmd_init_cdb() functi=
on
will then call scsi_command_size(cdb) (which evaluates to 260) and read 244
bytes past the end of the cdb array (and 228 bytes past the end of the buf
allocation).

Could a similar bounds check be added for the standard path without AHS,
verifying that scsi_command_size(hdr->cdb) <=3D ISCSI_CDB_SIZE?

>  		cdb =3D kmalloc(cdb_length, GFP_KERNEL);
>  		if (cdb =3D=3D NULL)
>  			return iscsit_add_reject_cmd(cmd,

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260806054820.7595=
0-1-ghuicao@163.com?part=3D1
