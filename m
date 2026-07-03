Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D8936EAA6
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2026 11:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783078421; cv=none; b=KZYaCnZPQtAsW4KHUON+8P4sCPWF6ruVYBVfit1PXTyR9oIwrhUv0L/JaxWuSzPz0CCz+m3Ew8dF2DPPG0f3fscMkaxNJeD0sALU/OQnD7EKpj782NYsK2ZV1xW1eTt1nMuCnBtPqcWzjTdkmTGI9KtwNMDujA8l9/hk9h44j2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783078421; c=relaxed/simple;
	bh=8jvAHzgY/Dx8G/TtkKLOrDwyRa3iweqMypFGpULd5i0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=sQc89Juxu7zkxKvvdKL7NwKUeAG1F0FgFgBFVvFFj5s9JjPkmfgbzmtdaz66x3RIw6JA8NOTevU+mXZVOUzQAH1pjz7zP+XLfKydLpI7RmnbsaO4uv4XfuhyZqilSIKkwb1LIlAPkNTK+Ah09btQ78Ed1LM5qzF/WjidUA3b2us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=obdZ7N6h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="obdZ7N6h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 014FA1F000E9;
	Fri,  3 Jul 2026 11:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783078420;
	bh=cs6LQ7pwXJ+wZGZdDuhFWbv3xnoUWkcSz4TIqhkolDQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=obdZ7N6hyIj62KeYrVBQ4vGsJ8EQedwqObP4hzUYmdiIz7xTnduEixGFQSbeuyq3/
	 NKI85SfgqubTS4wM8nOdjZWJnjLR3BmcIgN6oGoeAFc9eGVisS8VLRp7erS6030Xj9
	 0voWWD6/Ex2ghFUKZAIv9BuXCwPOEWV0ZuscImcvkoKpdMs9Vc7VWSJWLu864dRQTo
	 KUQVuMVFHwT6owgX+pPws/Gi6DOVRqjgDO4k7BXoT0QWDF4yI/mQfZNUz2TfkoXVCT
	 UE7XRYABw3AaQxh6/TBkq17REBZFtL2dc22VOiF6Q8UFmLt9jD4HxjNohXhXZLV4Xd
	 h/NnVaNJ+/uEQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 09/10] nvme-multipath: add
 nvme_mpath_head_queue_if_no_path()
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260703103204.3724406-10-john.g.garry@oracle.com>
References: <20260703103204.3724406-1-john.g.garry@oracle.com>
 <20260703103204.3724406-10-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 11:33:39 +0000
Message-Id: <20260703113340.014FA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] The newly added wrapper nvme_mpath_head_queue_if_no_path() calls an=
 undefined function mpath_head_queue_if_no_path(). The required header <lin=
ux/multipath.h> and the underlying libmultipath implementation are missing =
from the kernel tree and this patch series. Compiling the kernel with CONFI=
G_NVME_MULTIPATH=3Dy will result in a build failure.
--

commit cff4d8c98386c9683c8dc00a277d4f52cdd8c6a0
Author: John Garry <john.g.garry@oracle.com>

nvme-multipath: add nvme_mpath_head_queue_if_no_path()

This commit adds a wrapper function to check if the multipath head should
queue when there are no paths. It provides both an active implementation
and a stub for when CONFIG_NVME_MULTIPATH is disabled.

> diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
> index 9fd958a426f1f..354f77dea4870 100644
> --- a/drivers/nvme/host/nvme.h
> +++ b/drivers/nvme/host/nvme.h
> @@ -1095,6 +1095,11 @@ static inline void nvme_mpath_synchronize(struct n=
vme_ns_head *head)
>  	mpath_synchronize(&head->mpath_head);
>  }
> =20
> +static inline bool nvme_mpath_head_queue_if_no_path(struct nvme_ns_head =
*head)
> +{
> +	return mpath_head_queue_if_no_path(&head->mpath_head);

[Severity: Low]
Does this cause a build failure when CONFIG_NVME_MULTIPATH=3Dy?

It appears that mpath_head_queue_if_no_path() is currently undefined. I
couldn't find a declaration or the underlying implementation for it in the
kernel tree. Compiling with this configuration might result in an undefined
reference or missing header error.

> +}
> +
>  static inline void nvme_trace_bio_complete(struct request *req)

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703103204.3724=
406-1-john.g.garry@oracle.com?part=3D9
