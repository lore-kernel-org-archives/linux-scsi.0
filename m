Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00E0025F7B9
	for <linux-scsi@vger.kernel.org>; Fri, 31 Jul 2026 22:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785535522; cv=none; b=JBTDvZtQl/JvQ2Xgs5FIgY+Y6AKBhe9w/lG96vpQYMk2pj21kVbGChDFu2ul2/Zkx/0TugF8YeFkIT2ngXODR7Gw+AkSLuXmc0vBCi1mUOE3eIq0GxQUw6G8ocer6ZcM88osf5Ugs2FHBIWN5JZUnEnjD74W/3nPA4wILqahRsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785535522; c=relaxed/simple;
	bh=/pTYksz1RCRNuAaH7pwsAWxFMn0WimqP1vfU9xDlihY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=P+1O/BablartlTdS6MIy98M1qF/sS1/1qzuxcE0KFX2T9kUlqnRYdkAaH7u8FDMvtAwxDYiUkuauTSNJKXc+3VKfhgSc4Ii7TGNNvBHDBsydKB+Ri9bgnUZKKDfgsh6/o3Fmv64aAwNQmGiJjL6SpFYX3Rvfg7dhGIfBvrfP3xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TcWNESqy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TcWNESqy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89C831F00AC4;
	Fri, 31 Jul 2026 22:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785535520;
	bh=CSJAcEjSyHYlQJKFrBkngQBqR98bftXkDyEc5gIf0HI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TcWNESqykCfZRfC21O867LrceD/QuuWq8hoOZ+vXqE0dV45oSazaxeno+oYthsVKC
	 1sfOy5Jv7qmmMrMfQP4yg40ZKzH1lGYJZA2X7icoMvzGZYo9v34dMcI6SVhqn1GS3H
	 ckQSg4B546CuUNplSc8U9I1yKHI2CRJB5c+iNX0cVYrUCpL/TGAHB5GDTa3Ej+zai3
	 J9h/AIz1ZdDutl8gKJ9Un7KxMO4a5mej2H9PpkiSys51nROqLXSmyqjdD4Alh7tXSC
	 o+HNCfl+ga4qmWj8CXDUyT6m4cHF+nSakp+H769Po0bqwVGOHRDk1ORqft4J/0ZlFv
	 ZkXtoQRE6if0w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 5/6] scsi: core: Protect host state changes with the
 host lock
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <970cc36fb627fae64b4957954483c74cf8e59c87.1785534721.git.bvanassche@acm.org>
References: <68f3346cab2be570839350831f82b6c9233832ed.1785534721.git.bvanassche@acm.org>
 <970cc36fb627fae64b4957954483c74cf8e59c87.1785534721.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 31 Jul 2026 22:05:20 +0000
Message-Id: <20260731220520.89C831F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] The commit message claims to use READ_ONCE() for all SCSI host stat=
e reads, but scsi_host_set_state() still performs a plain read.
--

--- Patch [5]: [PATCH v4 5/6] scsi: core: Protect host state changes with t=
he host lock ---
commit 89fe98af4d7aa30cc00f86bd2b550ec8e90c44ff
Author: Bart Van Assche <bvanassche@acm.org>

scsi: core: Protect host state changes with the host lock

This commit annotates the SCSI host state with __guarded_by(host_lock)
and protects state changes with the host lock. It also updates state
accesses to use READ_ONCE() and WRITE_ONCE() to prevent data races.

Closes: https://lore.kernel.org/all/36d59d0e.6db0.19cdbeee01b.Coremail.luck=
d0g@163.com/

>     Some but not all SCSI host state changes are protected with the SCSI
>     host lock. Annotate the SCSI host state with __guarded_by(host_lock),
>     protect all SCSI host state changes with the SCSI host lock and use
>     READ_ONCE() for all SCSI host state reads. This patch prevents that
>     KCSAN complains about data races when accessing the SCSI host state.

[Severity: Low]
This isn't a bug, but the commit message states that READ_ONCE() is used for
all SCSI host state reads. However, looking at scsi_host_set_state() in
drivers/scsi/hosts.c, the initial state read still uses a plain access:

int scsi_host_set_state(struct Scsi_Host *shost, enum scsi_host_state state)
{
	enum scsi_host_state oldstate =3D shost->shost_state;

While this is safe since the host lock is held here, should this read also =
be
updated to match the commit message, or should the commit message be
adjusted to reflect this exception?

> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 08ec144f7bf77..9ea161478a10a 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -145,7 +145,7 @@ int scsi_host_set_state(struct Scsi_Host *shost, enum=
 scsi_host_state state)
>  		}
>  		break;
>  	}
> -	shost->shost_state =3D state;
> +	WRITE_ONCE(shost->shost_state, state);
>  	return 0;

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/68f3346cab2be570839=
350831f82b6c9233832ed.1785534721.git.bvanassche@acm.org?part=3D5
