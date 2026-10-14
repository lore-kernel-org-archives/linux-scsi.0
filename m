Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65957560AC6
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 16:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791996050; cv=none; b=i/+Rkzwa+PbzltWGstnDqadqiI59pxubEBICaFhO5w9dzKQib2vewyFNg7Ml5kiwo0yhiuN9d6QLBo3Q6GLv/sMQ6LFb5rqLvcL4TqaraqbsfLh7l98K40yr2KhBylPBDdKVlV+iwR1FSPxP7+hYxQHktU9rUG2AyeLeBgoRAgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791996050; c=relaxed/simple;
	bh=T07CgMPutxoc8bKKUxwhQdLT6UcGbP9Ghuy2b7CMGeE=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=C6E14Cv5fnS+Pg0vKzqayo5eoOLiGGzKHb0qfv4vpH8IDfXCkNApQyUPoEiGCyIw7YdA/LTj16SUI8ZsltDive3TeuzC2kwCldEfQUjIaIAtW7G9bXhoWnJ1Kc8/QD024W1dTyearaHu9MLaZ7MbkLQ+x2jfCrGXaZFwPqug3q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kQ2l6fuM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kQ2l6fuM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C30F41F000C4;
	Wed, 14 Oct 2026 16:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791996048;
	bh=jHwNS/e44ED+3uXuaPvLRY98lCk+apPC+Wbhd24zax0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kQ2l6fuMCppU9RSU6Dt/vKTZ//J3RM+cbtkI3zKkDX0FEHiVpNZ/gC7O3F4XFBcLP
	 n3C9dD94ndwzo/zTpFOnrzOHO2O09mgn92VyZRxilCl8s2t7bb0RAk5hfhxeeq0ZWQ
	 02skHyUma3Qvol9NeKSZiekP/GsTSJHUSsXqx4/cPopkM3vFnsnmpcOL2sXKiu2xwk
	 NhK59q+Bx+OaZ6JhsB5aXCvTZNUIwd4xJUcHEXkC/sUyalI0/P8ttJ0eFweUjjC08t
	 s+YHgEHnwG07P3N3DjvPs7UmNzgTGjdLOEiwcsngMP/FWXNWyOC4LtP3YpSCMG/JtI
	 HTTtezel5skoA==
Message-ID: <sashiko-outbox-171549@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 5/5] scsi: mvumi: validate the response frame tag
 before using it
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261014162413.3649841-6-yhlee@isslab.korea.ac.kr>
References: <20261014162413.3649841-1-yhlee@isslab.korea.ac.kr>
 <20261014162413.3649841-6-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 16:40:47 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] scsi: mvumi: incomplete TOCTOU fix missing request_id re-validat=
ion
--

commit 603dc78073e88003a67484fc0cd705e2144c5c40
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: mvumi: validate the response frame tag before using it

This commit fixes out-of-bounds array accesses and NULL pointer
dereferences in mvumi_handle_clob() caused by a double-fetch/TOCTOU
vulnerability. It re-validates the response frame tag and command pointer
from the copied local buffer.

> diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
> index 2871b4c96f1c8..85624efcc1725 100644
> --- a/drivers/scsi/mvumi.c
> +++ b/drivers/scsi/mvumi.c

[ ... ]

> @@ -1878,6 +1880,7 @@ static void mvumi_handle_clob(struct mvumi_hba *mhb=
a)
>  	struct mvumi_rsp_frame *ob_frame;
>  	struct mvumi_cmd *cmd;
>  	struct mvumi_ob_data *pool;
> +	unsigned short tag;
> =20
>  	while (!list_empty(&mhba->free_ob_list)) {
>  		pool =3D list_first_entry(&mhba->free_ob_list,
> @@ -1886,11 +1889,26 @@ static void mvumi_handle_clob(struct mvumi_hba *m=
hba)
>  		list_add_tail(&pool->list, &mhba->ob_data_list);
> =20
>  		ob_frame =3D (struct mvumi_rsp_frame *) &pool->data[0];
> -		cmd =3D mhba->tag_cmd[ob_frame->tag];
> +		/*
> +		 * The tag was checked against the frame in the outbound list.
> +		 * This is the copy, so check the value that is used.
> +		 */
> +		tag =3D ob_frame->tag;
> +		if (tag >=3D mhba->tag_pool.size) {
> +			dev_err(&mhba->pdev->dev,
> +				"ob frame tag[0x%x] out of range\n", tag);
> +			continue;
> +		}
> +		cmd =3D mhba->tag_cmd[tag];
> +		if (!cmd) {
> +			dev_err(&mhba->pdev->dev,
> +				"ob frame tag[0x%x] with no command\n", tag);
> +			continue;
> +		}

[Severity: Medium]
Is a re-validation of the request_id also needed here?

The patch aims to prevent a double-fetch vulnerability by re-checking the
tag and command after copying the frame to the local ob_data buffer.
However, the request_id does not appear to be re-verified against
cmd->request_id.

If the firmware modifies the tag in the outbound list after the initial
check in mvumi_receive_ob_list_entry() but before the copy:

1. The initial validation passes with a valid tag and matching request_id.
2. The firmware changes the tag to point to a different, valid command.
3. The memcpy() grabs the modified tag into the local ob_data buffer.
4. mvumi_handle_clob() validates that the modified tag is in bounds and
   that the associated command exists.

Without verifying that ob_frame->request_id matches cmd->request_id on
this copied frame, does this regression allow the driver to blindly complete
the swapped command with the payload from this response, potentially causing
data corruption or logical errors?

> =20
>  		atomic_dec(&mhba->fw_outstanding);
> -		mhba->tag_cmd[ob_frame->tag] =3D NULL;
> -		tag_release_one(mhba, &mhba->tag_pool, ob_frame->tag);
> +		mhba->tag_cmd[tag] =3D NULL;
> +		tag_release_one(mhba, &mhba->tag_pool, tag);
>  		if (cmd->scmd)
>  			mvumi_complete_cmd(mhba, cmd, ob_frame);
>  		else

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014162413.3649=
841-1-yhlee@isslab.korea.ac.kr?part=3D5
