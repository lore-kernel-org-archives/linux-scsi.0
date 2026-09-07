Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A7310F1;
	Mon,  7 Sep 2026 02:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788749994; cv=none; b=jhlOziCCaJZYcCv8sbI+gvN2WPWTqb4gX4BjaC7SWhV12pW6kTDml3TcuRVjRN3B0Ww/AXt4SbBpT7S0BFV/WYzx5mXE/evqFXfbmrXvIkuR+gbURk/uZJOVEg1LGKKoZJhZOy3hI4eZtsi3jw+K0igBHH2Dxavn6OiCEnTx4v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788749994; c=relaxed/simple;
	bh=SZHZ4IRZYtQi0Hlm6UtVCAao8SSCNMQ1J4zhkE5Fbyc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=HtPM+IA00FfY3Me1cuFbole4WSGxpwRtzspyjJr2zGenlCaHDAEmVDpxUMlEZng8mN4mAPrkPMa0SdE300XRtdh5Iu88JjCNXk0N4/4km8E6OfUQCLh4V3Gh4DbRbs8qH98M5SwXHlne+hHo6XfN08EMLfeO3qTU3uQ0tGvtkFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OVZV0F7F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OVZV0F7F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EC941F00A3A;
	Mon,  7 Sep 2026 02:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788749993;
	bh=8cqWnnT7z3XujXymweS1VF3AYvAQS08EaGF3RZfTQ/0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OVZV0F7Fom+ogr4l5qkodvou1O7GtKQ1fvpt7ml4a845faDV1pfdqFHesIJ27v7LW
	 Dh/3lsdTpke3fLqy2F7sQQ7ZwCnflWuoMSaTkMUXfWjwQXlQ8SdJ7DmbWLtLd1NDcn
	 eJPCsfaxw8KY4G9pJBF3JJ3MxnFEdfbgb9orzH+yQ/a6v8UXXiNHVynJIYc8wucqCO
	 sw4edeWji8ghKvLBo1shriaxnYCK0NU/3oTEj56IWmT2UuihUWb8VtromrhMRNz/KX
	 PQDaiQG2IHB5EUCeggNZdygCiaZnmTtKSRt5UxegWCT+KekmS3hStArqAuJc3Gx8tI
	 EGrtpxER/Ncww==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 22/40] scsi: myrX: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-s390@vger.kernel.org, "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-ide@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, dlemoal@kernel.org, cassel@kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260907024343.1046387-23-dlemoal@kernel.org>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-23-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 02:59:52 +0000
Message-Id: <20260907025952.9EC941F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The REQUEST_SENSE command handler in myrb_ldev_queuecommand comple=
tes the command locally but fails to call scsi_done(scmd), leading to a com=
mand timeout.
--

commit 8ca552cf50170727d9d9b758f842364f75a74d16
Author: Damien Le Moal <dlemoal@kernel.org>

scsi: myrX: use 16-bits defined sense codes

This patch refactors the Mylex RAID controller driver to use
scsi_set_sense() and 16-bit sense codes from include/scsi/scsi_sense.h
instead of hard-coded values.

> diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
> index 3678b66310ed0..e7d796add9864 100644
> --- a/drivers/scsi/myrb.c
> +++ b/drivers/scsi/myrb.c
[ ... ]
> @@ -1493,8 +1495,8 @@ static enum scsi_qc_status myrb_ldev_queuecommand(s=
truct Scsi_Host *shost,
>  		return 0;

[Severity: High]
This is a pre-existing issue, but I noticed a potential problem in how
the REQUEST_SENSE command is handled in myrb_ldev_queuecommand() in
drivers/scsi/myrb.c.

When handling REQUEST_SENSE, the driver executes the command locally:

	case REQUEST_SENSE:
		myrb_request_sense(cb, scmd);
		scmd->result =3D (DID_OK << 16);
		return 0;

However, it returns 0 without calling scsi_done(scmd).

Because the SCSI midlayer expects local command completions to invoke
scsi_done(), will this omission cause the command to stall until a timeout
occurs?

If an application issues a REQUEST_SENSE command via the SG_IO interface
to a logical drive, could this trigger the SCSI error handler and lead to
resets that disrupt system I/O?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907024343.1046=
387-1-dlemoal@kernel.org?part=3D22
