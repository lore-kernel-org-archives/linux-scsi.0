Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63F43D9526
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jul 2026 08:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784105922; cv=none; b=WZxGjtSrX3EKt5oeaRYNdny01HL/HCn5glOFkitDWog0Asm4ORSjyOVf1XCIoCDmCMW9+D6mqezHfbJkoYm/CwRGwNI+3VMdNgJCB8/8YX8ngxUDLTghG+oF8JssMffyE1/BNiH1X9LeJJgkaIDQ5NHQPvxZ13cJx/eW2eo2LOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784105922; c=relaxed/simple;
	bh=T1+W2WNw+3qv0DU1s/Xee7+cNyJHpqkcumiHQ9YbWF0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ScuhYHtwGhRjbjDq1kE6znAjOdHBPP56iGri8Oitq9w5qhXNeEwoUw5D9isFi5GuRa+lTDgSVfhTTwlbYlx7l/A4BZn5jWxn1n7LXI7IY/IPyw5ex1Ji+vFPf9QptNqI3RTaBPpET4XhNNEe2HyWmmdq3CFTZfV2cyocglz4fLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nUKj9TgK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nUKj9TgK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2ADF1F00A3D;
	Wed, 15 Jul 2026 08:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784105918;
	bh=bVBbKkf5mygc9Wt38+HlHI6hPyB1rUFWa9DtkH0ZnPQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nUKj9TgKgYhDKxqECzMKeCU4NMrZ379eaDS5t6abBAmDdBOQgKRnWAUgyIJO7qluR
	 M6n0y3A+HpVeUJICKrghy4mpRJAROC4J9lDmPxebtRc51i93Ysbz/Rh+ASuYcAfAYl
	 vrDK3cRxvGPhl5QqW7S/ca2znDIKnoPur5Qcy5vPxV5zwx2hzdUpgXSZ2I7mPh822P
	 FABhEG7cnKX0sFwGl6PLojfnHYoVSgovbGSbgNx2RmnVxfknrh6n0Y9V366x0O0lw0
	 EJX4XL8ZFnmnuffHzM0po6rOpz2gU3RhksTuSjFplVQs3GFHKBYicf0ZOFUQqCJ31Z
	 gQJFClUpqtfAQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/2] scsi: 3w-sas: bound firmware error strings
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pengpeng Hou" <pengpeng@iscas.ac.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260715084652.47248-3-pengpeng@iscas.ac.cn>
References: <20260715084652.47248-1-pengpeng@iscas.ac.cn>
 <20260715084652.47248-3-pengpeng@iscas.ac.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 15 Jul 2026 08:58:37 +0000
Message-Id: <20260715085837.F2ADF1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The driver extracts `request_id` from hardware-controlled data and=
 uses it to directly index multiple fixed-size arrays without any bounds ch=
ecking, leading to potential out-of-bounds memory reads and writes.
--

--- Patch [2]: [PATCH v2 2/2] scsi: 3w-sas: bound firmware error strings ---
commit a511ca86b3f57014015bb5a807df12ea03ffd7bc
Author: Pengpeng Hou <pengpeng@iscas.ac.cn>

scsi: 3w-sas: bound firmware error strings

This patch prevents out-of-bounds reads when parsing firmware error strings=
 by
properly terminating the description field. It introduces the helper functi=
on
twl_error_string() to safely calculate lengths without scanning past the
98-byte field.

> diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
> index 52dc1aa639f7e..5fc46a90e0262 100644
> --- a/drivers/scsi/3w-sas.c
> +++ b/drivers/scsi/3w-sas.c

[ ... ]

> @@ -861,13 +878,13 @@ static int twl_fill_sense(TW_Device_Extension *tw_d=
ev, int i, int request_id, in
>  	TW_Command_Apache_Header *header;
>  	TW_Command_Full *full_command_packet;
>  	unsigned short error;
> -	char *error_str;
> +	const char *error_str;
> =20
>  	header =3D tw_dev->sense_buffer_virt[i];
>  	full_command_packet =3D tw_dev->command_packet_virt[request_id];

[Severity: High]
This is a pre-existing issue, but I noticed request_id is used here as an
unvalidated index. Is it possible for a compromised or malfunctioning device
to supply an out-of-bounds request_id?

Looking at twl_interrupt(), request_id is extracted directly from the hardw=
are
without bounds checking:

    request_id =3D le16_to_cpu(
            tw_dev->sense_buffer_virt[i]->header_desc.request_id);
    if (tw_dev->srb[request_id] !=3D NULL)
        error =3D twl_fill_sense(tw_dev, i, request_id, 1, 1);

Or alternatively from the MMIO response:

    request_id =3D TW_RESID_OUT(response);
    full_command_packet =3D tw_dev->command_packet_virt[request_id];

    if (tw_dev->state[request_id] !=3D TW_S_POSTED) {

If a device returns a request_id greater than or equal to TW_Q_LENGTH (256),
wouldn't this result in out-of-bounds memory accesses against arrays like
tw_dev->srb, tw_dev->command_packet_virt, and tw_dev->state?

>  	/* Get embedded firmware error string */
> -	error_str =3D &(header->err_specific_desc[strlen(header->err_specific_d=
esc) + 1]);
> +	error_str =3D twl_error_string(header);
> =20
>  	/* Don't print error for Logical unit not supported during rollcall */
>  	error =3D le16_to_cpu(header->status_block.error);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260715084652.4724=
8-1-pengpeng@iscas.ac.cn?part=3D2
