Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F3792931F4
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 00:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784767371; cv=none; b=GikdhXJPqGoJq8w4TnpbKdsvIPsU0/uu0fmZ3kYC9QnqO+HnDFEYaKEim07RkFR5usrFhV52+p1SkNDaAGQueO4gL2aGuejYc5sY0Roo1yyuQlZxQe+/4nKlowB7o4UHSyv/4We0qN3OydY1LUtnMKUoah/BZcxN2ZPrSNPyYpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784767371; c=relaxed/simple;
	bh=hxW5lPxYX3wbGes8rOwjdCCZLgr+uhQp6Ce89XzASu4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BBoZukXeGgT3F1uqO/oGUk+PZEl7itDp4WKHFPFatyIum5yIxAD0NAFSoYDopZ7MfhdT7zVe6naetf6+s/cWNa7QcEkvsgJY8gCwtFV9hETTMirvB+JOz5tk0rSo0h/sRUvIgH9mZS49fxyPlNnkcCWREl/X2w9w2vyhTgHEmz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bzw11oeM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bzw11oeM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3DDF1F000E9;
	Thu, 23 Jul 2026 00:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784767368;
	bh=lXzYGKkXF+orYZlXEJUu4hbFJDke7JR78Iwp130zvtA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bzw11oeMb0xiWmvNzP7UyaA2y60X5o2s3VrMvmZDSirqL9MJyzONhiJHspeq8ftEY
	 PxvtEqth7oMeB/e8tJqabDgeIko4OZFeHcK4sRJsnBloYuVL1X0FFzy9VpqrcdFprI
	 19XI+nDBC2wyO2yH2T1OglOZ5NL2FxZW5h4JHN8cRt99gc9q9m/LKHsxd7LAfY9KQa
	 jfKqf10kcBG2e+1ap80OJxVJULl6LukYcKC1Le+9gnjpVdFEPzBqm3nP/5/RDYe47q
	 VNHfrK7QCb8+1K22bFSG2hDv0AIqWOk5tKOWfvCFUHJ/wQ/w3SATOP+Z+PnckFXhHw
	 Ya96NO1QSFAtQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 26/33] ibmvfc: extend ibmvfc_debug visibility to
 ibmvfc-nvme.h
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723000149.969416-27-tyreld@linux.ibm.com>
References: <20260723000149.969416-1-tyreld@linux.ibm.com>
 <20260723000149.969416-27-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 00:42:47 +0000
Message-Id: <20260723004247.D3DDF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] The exported variable `ibmvfc_debug` is completely unused by the NV=
Me support code.
--

--- Patch [26]: [PATCH v2 26/33] ibmvfc: extend ibmvfc_debug visibility to =
ibmvfc-nvme.h ---
commit 35cd49c4c7f0c39e5adc622d14fb39bef0080a91
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

ibmvfc: extend ibmvfc_debug visibility to ibmvfc-nvme.h

This commit makes the ibmvfc_debug control variable global and declares it
in ibmvfc-nvme.h. The stated intent is to allow NVMe protocol-specific code
in ibmvfc-nvme.c to use the shared ibmvfc_dbg logging macro.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-nvme.h b/drivers/scsi/ibmvscsi/=
ibmvfc-nvme.h
> index 0465e87198817..3aa2857887950 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-nvme.h
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-nvme.h
> @@ -22,6 +22,8 @@
>  #define IBMVFC_MAX_NVME_QUEUES	16
>  #define IBMVFC_NVME_CHANNELS	8
> =20
> +extern unsigned int ibmvfc_debug;

[Severity: Low]
Is this variable actually utilized by the NVMe support code?

The commit message indicates this export is so ibmvfc-nvme.c can use the
ibmvfc_dbg macro. However, looking at drivers/scsi/ibmvscsi/ibmvfc-nvme.c,
it appears to use ibmvfc_log instead and contains no references to
ibmvfc_dbg, DBG_CMD, or ibmvfc_debug.

Are there follow-up patches that add these debug calls, or is this export
unnecessary?

> +
>  struct ibmvfc_host;
>  struct ibmvfc_target;
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723000149.9694=
16-1-tyreld@linux.ibm.com?part=3D26
