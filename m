Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6FF53C2BA4
	for <linux-scsi@vger.kernel.org>; Sun, 20 Sep 2026 14:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789916385; cv=none; b=sLiPnMnGurITcArCR/RvqM7+i4zx+4R9RMGQZciF1qaeBJvjnYS9mEkPiBtQSEvJAHclV7jM060L5FCXfjqlOZSQJPTyZpHsE+uezaFSxjgf6zv9l6GAvx2QTxR7QgNCVgsU4nQ5zaRysJEBtriFopB1tathb8oGooZXbY4O1WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789916385; c=relaxed/simple;
	bh=kvjFSsXqEPoxuvUrozkU9FZTKpXOeyfW2hHRPvWXwHU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hZBSpEIBjNVE/9BbfiBaSM0jhhDZbNF60jBIBXRaWiiGyJd9qmxDpsyaNKfvZLZ+eWvQiLnPl1ML8Gs1cakzXxyo8QGqebfhE0LqQ+KsnmFdhMlGoX0+Gkp9Fa4IvbJt9xXeXsZaNIeYz09/1POj1oj9gVbejhN5A/eDYIDlxmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bA/dFciw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bA/dFciw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D4431F000FF;
	Sun, 20 Sep 2026 14:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789916383;
	bh=I9LAZkeYUfGw3bWyEfKWRYujFOuvKLKPL5FpeTQe7Kw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bA/dFciw8XKxh64ogPTW2fOsBgA0Cu/8tMoUOKh65rXehrpjJyG7tu6IBwnrvZMUX
	 +b4lUaZTQ00l3eP6l9reuUQFRbaOulbaXuNYZQ/KEQZb9gA4JlRGhJErGzoetROKzc
	 0eNsMXmTrnt1fa56x07UBiea1jc6wNB728g6JzK8R/FIZ4QUuoryjdhavGW6YJgRpI
	 vCsELyI0nMR5K+uXlVaTjlLZzVBH1UvOLAfLzxSEmMe4DomiD7bZQkA8qqgFmiUcOO
	 rL6W1K6QqPW/M0wZy7FMFDyTXv3VGtiIUjIRwMwm/9zeJKy4LlDvVtMEy8NY/Is9U+
	 9y0oSn58er8WA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: ufs: rpmb: register and unregister the ufs_rpmb
 bus
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dmitry Baryshkov" <dmitry.baryshkov@oss.qualcomm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260920-fix-ufs-rpmb-v1-1-560b842c589d@oss.qualcomm.com>
References: <20260920-fix-ufs-rpmb-v1-1-560b842c589d@oss.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 20 Sep 2026 14:59:42 +0000
Message-Id: <20260920145943.6D4431F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] scsi: ufs: multiple module_init definitions cause linker error in u=
fshcd-core
--

commit c4238766f6e56be8464c4760e2cccf9cdc5bd928
Author: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

scsi: ufs: rpmb: register and unregister the ufs_rpmb bus

This patch adds module_init() and module_exit() functions to handle
ufs_rpmb bus registration and unregistration, fixing an issue where
attempting to register RPMB devices fails because the bus is unregistered.

> diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
> index 50ef63afd5283..8ae917adbc98b 100644
> --- a/drivers/ufs/core/ufs-rpmb.c
> +++ b/drivers/ufs/core/ufs-rpmb.c
[ ... ]
> @@ -275,5 +275,18 @@ void ufs_rpmb_remove(struct ufs_hba *hba)
>  	dev_info(hba->dev, "All UFS RPMB devices unregistered\n");
>  }
> =20
> +static int __init ufs_rpmb_init(void)
> +{
> +	return bus_register(&ufs_rpmb_bus_type);
> +}
> +
> +static void __exit ufs_rpmb_exit(void)
> +{
> +	bus_unregister(&ufs_rpmb_bus_type);
> +}
> +
> +module_init(ufs_rpmb_init);
> +module_exit(ufs_rpmb_exit);

[Severity: Low]
Does this cause a build failure when built as a loadable module?

The ufs-rpmb.c file is compiled and linked directly into the composite
ufshcd-core module when CONFIG_SCSI_UFSHCD=3Dm and CONFIG_RPMB are enabled:

drivers/ufs/core/Makefile:
    ufshcd-core-$(CONFIG_RPMB) +=3D ufs-rpmb.o

However, drivers/ufs/core/ufshcd.c already contains the module_init hook
for the ufshcd-core module with module_init(ufshcd_core_init).

Because module_init() expands to a global alias for init_module, combining
multiple object files with their own module_init() declarations into a sing=
le
loadable kernel module produces a fatal linker error due to multiple
definitions.

Could the bus registration be handled by calling ufs_rpmb_init() directly
from ufshcd_core_init() instead?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260920-fix-tcpm-v=
bus-bis-v1-0-bc9a7c72e5d0@oss.qualcomm.com?part=3D1
