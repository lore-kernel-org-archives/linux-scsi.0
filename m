Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2533D2222D9;
	Mon,  7 Sep 2026 03:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788750340; cv=none; b=rW5xU6N6wnxgdLfLLzJr+J8Bn4ObRbO8Ualn4e9Gnk1xy28tqmc2vRmOoKYrFies9O25x5L9FVJ2wUQhrJ5YoMYfxvy/KiLe/+jdSu/zD1sHlqD8fJ7Y+YJSxeDIP4s3G5sn0pyYXXOWHsRCVESUMsVgy5TZHgcps8FJJuU9GV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788750340; c=relaxed/simple;
	bh=4a5metdf2CBbfBsvai18ymMQPxf9kMA0loR0jK28f40=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=USH7NlxokVM3WIAMV4nkdzzObVuljM+YifS3mizrPxN2Kb5xAaG5+5arYsYPwSyPwnVVqPx4y65FbknY5NWOPtOshQhet+x5GlE8CSPHarVYs4dHb1H2YEhb7pnofsCgxoiETU96jxQG40SRCPFlhgcMJ+P/LUeGaqsvHG+jJsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a6NwvTCq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a6NwvTCq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27F5D1F00A3D;
	Mon,  7 Sep 2026 03:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788750338;
	bh=myD7kMtlV9gMrefHKOP3Eh7/cEmVpJfz2OqwBKMN6eI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=a6NwvTCquMujmCrPr6gLtvMiYjE6zI0sAn0J9MaMRPmiDBVb/ivYfpSgZ64Xmtgur
	 TqMia7NF62MONx52u4QrPQ4Uua4oXuqH/K6CkRXWZB6EcpPJrUhiqNNnwMgQkIqfd2
	 WmmaURWOc/3CctqlRYItAi7ifHXndjHhrnXIOrP0brj493eFkEDLJDXj12x1+xcPf0
	 cMdqcPp2rGKVzJjyg/BP9TIkBBLOvtbnfwsjTyiVGE7OpJcJCzBrfUM/lbWTmZKzyE
	 HSam/82xlfcZtqW2pywQogBww2FstorMJfaVwcZpHt2DVK6HEkrA3f5tRG8NDgUnR9
	 s+GwqzD+gPxUg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 30/40] scsi: ibmvscsi_tgt: use 16-bits defined sense
 codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: cassel@kernel.org, linux-scsi@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, linux-ide@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-s390@vger.kernel.org, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, dlemoal@kernel.org
In-Reply-To: <20260907024343.1046387-31-dlemoal@kernel.org>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-31-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 03:05:37 +0000
Message-Id: <20260907030538.27F5D1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] When `srp_transfer_data()` fails during an RDMA read data tran=
sfer to the initiator, the target populates the sense buffer but fails to u=
pdate the command status to `SAM_STAT_CHECK_CONDITION`. This causes the tar=
get to send a `SAM_STAT_GOOD` response to the initiator, masking the transf=
er failure and causing the initiator to process stale/corrupted data from i=
ts unmodified read buffers.
--

commit 6317be85b00b8041ec78e59ae2da48d7e5d24fde
Author: Damien Le Moal <dlemoal@kernel.org>

scsi: ibmvscsi_tgt: use 16-bits defined sense codes

Refactor the IBM virtual SCSI target driver to use scsi_set_sense_buffer()
and replace all hard-coded additional sense codes and additional sense
code qualifiers with the enum values defined in include/scsi/scsi_sense.h.
This helps with code clarity as the sense codes being processed are easier
to test and self-documented.

> diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmv=
scsi_tgt/ibmvscsi_tgt.c
> index 61f6828007654..e2af90b6da39b 100644
> --- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
> +++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
> @@ -3757,9 +3757,8 @@ static int ibmvscsis_queue_data_in(struct se_cmd *s=
e_cmd)
>  		dev_err(&vscsi->dev, "srp_transfer_data failed: %d\n", rc);
>  		se_cmd->scsi_sense_length =3D 18;
>  		memset(se_cmd->sense_buffer, 0, se_cmd->scsi_sense_length);
> -		/* Logical Unit Communication Time-out asc/ascq =3D 0x0801 */
> -		scsi_build_sense_buffer(0, se_cmd->sense_buffer, MEDIUM_ERROR,
> -					0x08, 0x01);
> +		scsi_set_sense_buffer(0, se_cmd->sense_buffer, MEDIUM_ERROR,
> +				      LU_COMMUNICATION_TIMEOUT);

[Severity: Critical]
This is a pre-existing issue, but when srp_transfer_data() fails during an
RDMA read data transfer, the code populates the sense buffer but fails to
update the command status to SAM_STAT_CHECK_CONDITION.

Without setting se_cmd->scsi_status =3D SAM_STAT_CHECK_CONDITION here, the =
target
core seems to believe the command succeeded.

Later in srp_build_response():

drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c:srp_build_response() {
    ...
    if (cmd->type =3D=3D SCSI_CDB) {
        rsp->status =3D ibmvscsis_fast_fail(vscsi, cmd);
        if (rsp->status) {
            ...
            if (se_cmd->scsi_sense_length && se_cmd->sense_buffer) {
                rsp->sense_data_len =3D cpu_to_be32(se_cmd->scsi_sense_leng=
th);
    ...
}

Because se_cmd->scsi_status is 0 (SAM_STAT_GOOD), rsp->status remains 0. The
check if (rsp->status) evaluates to false, causing the sense data to be
completely bypassed and ignored.

Could this cause the target to send a SAM_STAT_GOOD response to the initiat=
or,
masking the transfer failure and causing the initiator to process stale or
corrupted data from its unmodified read buffers?

>  	}
> =20
>  	srp_build_response(vscsi, cmd, &len);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907024343.1046=
387-1-dlemoal@kernel.org?part=3D30
