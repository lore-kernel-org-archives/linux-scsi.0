Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459072494F0
	for <linux-scsi@vger.kernel.org>; Mon,  3 Aug 2026 04:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785730646; cv=none; b=hgtwD3UBmfOOzgqtOJczqP2KlMsloynKTHccCenxwJ15YGQ5xUYVjXnhT8kbbtFgavL0cJyfrCKFII3VYzNeww8XyR2GE9al8/Bj7knb6FjqIXoDxl6XYbhSynyCokP+AGbMM62pVjOQyuZOkvWUXXi3zm9djwPxXO6XrYVBEnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785730646; c=relaxed/simple;
	bh=k3dHSOoaFFASz/ex9ZO2H0w4jTLqLDVj7cxZL5Fffuk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=V6J71ryDnhryv4RzNC71NJ6yna+R6ndmIe2FkFZq1a9gzJ3zSICbSLpIYwBVgCwWU7UaJTtVwBifzZa2UuW3P17+JwanR16JA1IYOl8c1pH6MoREvV40alCrgKxstllX8aRagT6RaJpTcbt/nRInf9yyGOfQFIhCbDpGiHa0xhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WqUvsk5L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WqUvsk5L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A81B71F000E9;
	Mon,  3 Aug 2026 04:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785730644;
	bh=lo6wFVqh+bCgH75Rq4QrOrEKKNAdzwI2nAh4Abt5fng=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=WqUvsk5Lwu/WzVOAI7OlAwdHoTK68DGuvFzhYTWAKZHBksqc6LL7m/8JUgG/ka72/
	 S4WdK7JFc/Bs5NLIYbmHyk1OfDQRtoFVN8SLmwY3VihykYUHRxKBrmCBeC2afC4RmD
	 zdcEHi+fjheizCKhWKxguDrb9SqVwsUk4p2mHn4xTgOWw4gJinf6zJ/jWZyvWQK6uA
	 1nreLPE4QCTlNQ2oebl6LlUDtdPYZ65ZhgT9xSK13YEDv1kQp5V1eQRa0zXGIgcOq/
	 KMga8NS10/PqsrpvDwhLeCkNr3d1d94IpuWvINu5jAcGtHrKKEBwLkJ2OkIuZh4sDO
	 Fl8+LgGxPujSQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/2] scsi: libsas: Add PHYE_NOTIFY_ENABLE_SPINUP phy
 event for ASC/ASCQ=0x04/0x11
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xingui Yang" <yangxingui@huawei.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260803020536.546544-2-yangxingui@huawei.com>
References: <20260803020536.546544-1-yangxingui@huawei.com>
 <20260803020536.546544-2-yangxingui@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 03 Aug 2026 04:17:24 +0000
Message-Id: <20260803041724.A81B71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] This problem wasn't introduced by this patch, but it is a crit=
ical vulnerability. In `sas_ssp_task_response()`, the `min_t` macro incorre=
ctly casts `be32_to_cpu(iu->sense_data_len)` to a signed `int`. If a malici=
ous or malfunctioning SAS device sends a very large `sense_data_len` (e.g.,=
 0xFFFFFFFF), the cast to `int` results in a negative value (e.g., -1). `mi=
n_t` evaluates to this negative number, which is stored in `tstat->buf_vali=
d_size`. When passed to `memcpy()`, the negative size is implicitly cast to=
 `size_t`, becoming `SIZE_MAX`. This causes a massive heap buffer overflow =
when copying from `iu->sense_data`.
--

--- Patch [1]: [PATCH v3 1/2] scsi: libsas: Add PHYE_NOTIFY_ENABLE_SPINUP p=
hy event for ASC/ASCQ=3D0x04/0x11 ---
commit 04d93ab7400ada2fff2a532b87fdf708e22b793a
Author: Xingui Yang <yangxingui@huawei.com>

scsi: libsas: Add PHYE_NOTIFY_ENABLE_SPINUP phy event for ASC/ASCQ=3D0x04/0=
x11

This patch adds a new PHY event to handle ASC/ASCQ 0x04/0x11 for SAS devices
requiring a NOTIFY(ENABLE SPINUP) primitive. It introduces sense detection =
in
the common task response path and an optional LLDD callback.

> diff --git a/drivers/scsi/libsas/sas_task.c b/drivers/scsi/libsas/sas_tas=
k.c
> index e9d291007817b..d1eb6ce90626e 100644
> --- a/drivers/scsi/libsas/sas_task.c
> +++ b/drivers/scsi/libsas/sas_task.c
> @@ -29,6 +29,8 @@ void sas_ssp_task_response(struct device *dev, struct s=
as_task *task,
>  			      be32_to_cpu(iu->sense_data_len));
>  		memcpy(tstat->buf, iu->sense_data, tstat->buf_valid_size);

[Severity: Critical]
This is a pre-existing issue, but does this min_t() cast to signed int expo=
se
the kernel to a heap buffer overflow?

If a malicious or malfunctioning SAS device returns an SSP response IU with=
 a
very large sense_data_len (e.g., 0xFFFFFFFF), casting it to 'int' results i=
n a
negative value.

This negative value would be stored in tstat->buf_valid_size, and when pass=
ed
to memcpy(), it is implicitly cast to size_t, becoming SIZE_MAX.

> =20
> +		sas_ssp_task_spinup_notify(task, iu);
> +
>  		if (iu->status !=3D SAM_STAT_CHECK_CONDITION)
>  			dev_warn(dev, "dev %016llx sent sense data, but stat(0x%x) is not CHE=
CK CONDITION\n",
>  				 SAS_ADDR(task->dev->sas_addr), iu->status);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260803020536.5465=
44-1-yangxingui@huawei.com?part=3D1
