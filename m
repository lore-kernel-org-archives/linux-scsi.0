Received: from mail-qk2-f7.google.com (mail-qk2-f7.google.com [74.125.230.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E663346B4
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 04:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.199
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789100316; cv=pass; b=t+D35yXt/fCiifliVkNqPumaiqkv7ddsNOumZYzmk32uQK0MHsasXl0o9Z9Wy+09n3XbanAV2h9anZoARNWwsUefSl6nqij0MGgv6IAKdnDQWCdqLAqTcYcLzM+Qq6I6xj/JIKCpF+Z1DSHBBj7BRb1nuUiclR9ctcC4B7rw7u4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789100316; c=relaxed/simple;
	bh=k4AQtAE1VCDJVH21dryR7SNObVYxM9grIxmGKkNRrkA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=U781ErtnSBg/5Mbt8OhAMxmqi6N3SrSJDwdb5kwHiqlZbrHRahvj2gPKhtZKTjhW+A1Jbj2DeRohMM1TRAcTpy2hwIka7rnGOZr3IgBJQDmjs0WVDbIKxLQI5Q1fzEwtl8zWLP9hN3kFHTO5/q8AHdLIKc2yKwCKB81KFQv/bbM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fGcGu5QQ; arc=pass smtp.client-ip=74.125.230.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fGcGu5QQ"
Received: by mail-qk2-f7.google.com with SMTP id d75a77b69052e-52f64eb5a48so2254311cf.1
        for <linux-scsi@vger.kernel.org>; Thu, 10 Sep 2026 21:18:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789100314; cv=none;
        d=google.com; s=arc-20260327;
        b=XpK2HZ4d2lno50UmdqciepCwuFANg2+pWUDnIY3avwi++YNoDAkzdZ7x14K6Nhf0Rd
         uWiB2oa48q0G3WVvICbtDTKoetJRRlVaXFABKKaypft+FOWq4bqcfjPQXaNXrgrKOGD9
         TttfTcFS14uB0LEM8aux2N6pTJJPVH1uvtjBLFK9j4mDiaKt/7FUZvJHlrPpIsElJh/q
         gHUz/lJYeRl77VTB9tX28mnSMpE2PARGucorO73ZLPQcqMbWCnQ18/ZQstExA538ofqI
         5Kkpt25X/42FxWxzVxNR8oJvnd3PyEABwYZmTpJZ6v9wMBykriKptORWZD/QYVE5hKhU
         WELw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=k4AQtAE1VCDJVH21dryR7SNObVYxM9grIxmGKkNRrkA=;
        fh=7I+XJWPHCRSuhD4z/r3jXa4YmPs94wkMoTzlRZIiWSc=;
        b=swllDFnIica4EPxm1fwEfbWYNDQAPxbJRkUdeLa6AxseP62pqNArTEOLJTFXurhy2U
         TIqQfhVwdMS3eUaxDsm9NIXqkee3TxFEhiJYFumukg/IrubSB88hbhr8oxyIBuXhpS/q
         pBxaTKSGSpHPydidYHKGr8PUV7pd7QLhMZqh2YSztvo9XgZyg1RSADC+DZE+5BJvPNo8
         VGhMAe4J3R3GTh3K+Ea2p3NYgORMddui8ve9c5Qxtku61fRBss+nqn2+7oG2q561hqIA
         6VncnSi1CNb/kR4Rg4e+yHeM1mbmtw/P+j0c1yt+jbaHSx3tRVXQoimW4lLhjehehf66
         WMWA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789100314; x=1789705114; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=k4AQtAE1VCDJVH21dryR7SNObVYxM9grIxmGKkNRrkA=;
        b=fGcGu5QQ0sqehpM1wKiTrj+67j4dn8teUBfcBIsYOiLFABTiVKlr5yaLQPHPFfkl4r
         2MGx2aOD8axMixtIAvLTti1GBHeszctU/og5I9F79qdZ+MEv7Bvj62568yRMBxp3jVCd
         LjsbZZFtqab2W+jPYpY3t521cv4JJ7sShgP1rxXWcFdiAknY/uiO0CXu8NlJCmAFOcgO
         NvlA0cUsSE4QTnZvkR/waoxk1XAAJUWFGGefR5m6kc964LXZW+roxUqhvnYaiEGxZKOs
         fkNVJ9Ccf24cwTglCrxuYnF0gBOg8OejhMM6HWgotOFyiic//Do8f2+wRWZzV1xmuIhM
         J+/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789100314; x=1789705114;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=k4AQtAE1VCDJVH21dryR7SNObVYxM9grIxmGKkNRrkA=;
        b=HIImABeEojxM1RiRQYs/1RsBlxstYPDBz/9oG68hh+g/j6o4M4dAlvuteTNdBQ2oGP
         D+8YIwvWQzB46QIwI7ZyQWO7KfN5TcxVkvi3P9D/9SKA6NMy1k/dJv8ZXpgsXbtC6VFk
         qyfVAwfHPZTcGws92bAhuqQituI5zGey9W9HrggSLjLN0YyxMZWgsivQDvtZW11kSbBo
         o3dFaNAzAtx6khT1LqMGtNwiLpeVHcx/sfqy1Z8pDOsHa+bIeAwTOx8okIYcNuIJbR/r
         vSYmT8rOUc3ngRca290vDm3YxclIuCvybPpNo2CCSfJhhCNjqCqOba8KpiuNvLPDjwlQ
         TnGQ==
X-Gm-Message-State: AFuF++lf6jxrM+YeVFcrZvc+6BB+PAzPszOMW8ODxrP0xNR/VkvP9QTY
	QXS9ddqBlD+3//ZCh72xDVo/nvj9PsANtQangFBF6Kg8sEbsM869XOCNVfXfP+FVed3JbgtIVaj
	HryvqGMPxgfiJMP01F2d1h8YtGE8d3RmuloT5afgcEQ==
X-Gm-Gg: AYBFou37fnAmzIGduttUXLVG6UA+MVOnX6PPx4LpMUcSaqr5w4JeEMf6RK8tgIbB8Ed
	skfuF9sqz23KIafu90IL4xISNJ8SHGOhJjjOCv7aLOYqLFy1ywJCPVVaNN92XbFp9ZR/KWCMd7m
	dYMAK1wlbgDemGm09t96g7RhR3703W8y6Cawx3tu4boczditWBqM8cXSVp9rYb2dy+P6VRBndra
	pboBj1n+jUEo6INw4rGU3/gdSQG20vU1hjFdE551n1mDoJFJojZuNOn4NmF/33gTxlfrGyBiOPi
	0D+hBlB4iVALxAe40mBlulw2e6/KIR0zs/q4ehY5Ku/cFEazYCH87Bj69FaMPWfwzMQo3XhSE9X
	+eYhIe1bA3nEDLnl8ofWV+Vtme4UrHUBZ0W7W6j6v
X-Received: by 2002:ac8:7d01:0:b0:530:b2e4:4e2e with SMTP id
 d75a77b69052e-530c878bbbamr39923931cf.59.1789100313913; Thu, 10 Sep 2026
 21:18:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Date: Thu, 10 Sep 2026 21:18:21 -0700
X-Gm-Features: AcwNN1U0kdrI-g5mMO2gKFI8O5GY7q9aTyO1RTeRrQHMMDCINsh8OXmgQqo9zPI
Message-ID: <CADkSEUjRczET4zoHo944F-Tj=bK5w_SbSzwPoSfKh5EOniEhRQ@mail.gmail.com>
Subject: Is anyone using ACARD/ARTOP SCSI cards?
To: linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi, everyone,

drivers/scsi/atp870u.c is almost impossible to understand, and thus
unmaintainable, because it uses magic numbers for all access to
hardware registers. I would guess that this was done intentionally in
a misguided attempt at IP protection. Is anyone using ACARD/ARTOP SCSI
cards? If not, the driver should probably just be removed. What do the
maintainers think?

Ethan
