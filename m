Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004813F6C32
	for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 14:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791901004; cv=none; b=T2RbJXh5q0yCO7nXAbkSvhTG0wAbSNHIQtZuFBt1244MI9xYAXTnTNsuR1UV/+2z7GFI99kqbjKpUSD1fvD4imGYf8sFiQvTak83qsy4UM5as0zvPSPmtng0vMtoNjoAuqP7XIxWXR0776M5Vaj0cwf5wfrk6jmMIFSbRqFW1ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791901004; c=relaxed/simple;
	bh=BEY6K1ws1Ck/yhpM2aWAvXubUxHV/n1obIE+Xyn6/x8=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=tfyUVMRBy3PrcpyTMBGCj/pJNCIWo6nWwvY8GJx3RCiEfYbKEi1UAxLeSR1Du90eFn0UhN0tzoW1OURWW302mk4Ng99GQnuaUlnMj/MBgATNIsZN9lrBVkE17M1m7413wjjzF7iy4H8mv3ej4lDqtGQQMQTdrx0ZtF2W45X1fUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ipG4cCII; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ipG4cCII"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B28D1F000FF;
	Tue, 13 Oct 2026 14:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791901002;
	bh=ioSq5wwOeRGE/O4t3WRuOGuvjbrh/0kmNzHeX80oOVg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ipG4cCIImktZxZF+M/hhux70F5wsx8xffwGCKRsaVW7I8yFT1e6KeSjJ99o7vwE0S
	 Ogfum6fMbXlIUmsEHPkSxPq5TheJ7yUNnAA0gUQEKyRR0UDuOmTMz9pmmADeR2B9SE
	 KcQNuKyW/q7wkLqd3nu5nJYKQqEQxcaiS4S+a4Gqmra+zELVfQv53b8HDUV08tH90E
	 GvvYxk8H7MCrLXVlgu3M+tDXIFpKAmhV04ZgfR7vX3U7IvkJKEH7Kd+vBg7rdfwm7v
	 evEe+pOOiFw413gjjlWvZR+6YsIVzTgqvRcWzp17x5LWVBSSKN9WHAhOzbJ8YJyszi
	 1ER/Dj1KU4vsQ==
Message-ID: <sashiko-outbox-169893@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] scsi: aacraid: bound the HBA sense response copy to
 the source buffer
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261013140214.3156938-3-yhlee@isslab.korea.ac.kr>
References: <20261013140214.3156938-1-yhlee@isslab.korea.ac.kr>
 <20261013140214.3156938-3-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 14:16:42 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] scsi: aacraid: truncation of HBA sense data
--

commit fad62a85b43941f12e2686c1d61c5fdd7b5b7c46
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: aacraid: bound the HBA sense response copy to the source buffer

This commit restricts the amount of sense data copied from the native HBA
response into the command's sense buffer. It caps the copy at the size of
the sense_response_buf array to prevent a potential out-of-bounds read.

> diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
> index 89d8e33517584..23512648e389e 100644
> --- a/drivers/scsi/aacraid/aachba.c
> +++ b/drivers/scsi/aacraid/aachba.c
[ ... ]
> @@ -3579,7 +3579,7 @@ static void hba_resp_task_complete(struct aac_dev *=
dev,
>  		int len;
> =20
>  		len =3D min_t(u8, err->sense_response_data_len,
> -			SCSI_SENSE_BUFFERSIZE);
> +			sizeof(err->sense_response_buf));

[Severity: Medium]
In hba_resp_task_complete(), does this change actually truncate valid
extended sense data returned by the firmware?

Looking at struct aac_native_hba, the err object is backed by a 512-byte
buffer:

union {
	struct aac_hba_resp err;
	u8 resp_bytes[FW_ERROR_BUFFER_SIZE];
} resp;

Because of this union, the original copy of up to SCSI_SENSE_BUFFERSIZE (96
bytes) appears to have been memory-safe. Capping the length to the size of
sense_response_buf limits the copy to 32 bytes. This would discard diagnost=
ic
information whenever the HBA firmware returns a CHECK CONDITION status with
more than 32 bytes of sense data.

>  		if (len)
>  			memcpy(scsicmd->sense_buffer,
>  				err->sense_response_buf, len);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261013140214.3156=
938-1-yhlee@isslab.korea.ac.kr?part=3D2
