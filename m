Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E01C030100B
	for <linux-scsi@vger.kernel.org>; Thu, 18 Dec 2025 17:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766079360; cv=none; b=J/v+iN+7lpV9M2gBd5KAJlZBoMlHBidaT16OxchltMojglwVBa5/bUbnXpHZv/EiibYiAw4uvbYHjJPZzwNvmpG2cCpaHeqdJkuCiLRqqvCn3DP+hbTMwbe2c3vt1TitBX8MQ3ThQX0B5Bfgkgz64+RACeNAl80emxON8084V0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766079360; c=relaxed/simple;
	bh=nzcA7c48q5XS5Roy2lXR024dj4daYm4zvfVsLU6ahz4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g62KDwj9bZ4bOJHufbeeVLkQ1DfSuPll4GIhc64Cq9DDT485lEghdm4Bl+qDkI7l/1mLFX13g53UD1Z9T1H9HJAKBtOjdggPfdUoxoBduca18R+pQFzYPgU3Ll2Ex1e6YZUQJ1D5EPfSeIwyniL44Yqs6YZLdn15XyiPOK02vD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A9AoR5Rz; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A9AoR5Rz"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-88a2f2e5445so9894456d6.1
        for <linux-scsi@vger.kernel.org>; Thu, 18 Dec 2025 09:35:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766079358; x=1766684158; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Km2T1I5YBUewLvu5wzssTsrcMP7r1tKGG8gU9jwLlQI=;
        b=A9AoR5Rz2lM8QcNHSifTM9yZxbEWZu6JOhGY571VCvQwXm0yjUfbizldzkCCTP611Y
         aH63eDBUDvvuEJyeiQeabvVFNLgeB9jDTfFtO9IawP7BsrnT2eWdW9mNLf2B8dVtUPzX
         sbSNdWrdfse1QaiVhx1p4znKipW2e9zG2WEgmftq2cKQptR6BVS6vXkm1wcnbJcKxnb9
         E6y8N8FcgcBR6p6DyTvirL0qb3LEXVSzqknW1T1ib/ImK+dDdX4PSn+eF6QTtbENdzut
         909U+YosHK+Vi+ZA3+wQhKOFVkMYXCt91Bs4oh3cz9QtH+PN18JrFsYOBqQC0f63ejYf
         1HxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766079358; x=1766684158;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Km2T1I5YBUewLvu5wzssTsrcMP7r1tKGG8gU9jwLlQI=;
        b=jL8sc2MSlM+c/kpCOIiRMQatzhNqK3BASGvpD4Vmfc9yWiQAk8mTR6HQ8rZhQzjDva
         Y9vudMVUY/6PSzYTbKictUJVzUz+cbT9pdEcja+MRPE8LyhAkb+fA0VPUutlXQlUV6Z8
         yTQMPdVYjNoxVQ+qppALsVWzfOZmAmsLmMCRouhigeO2duId5NCkCxDNtOSj5pSUSRXN
         d1INnvoRgRD7omN+eCeJkJ3QH6yKU0DTZ13Noz0udpv+L3WQcxHeCuNdWMkERDxdeBtQ
         nWIBlxt2Ux3YqHiWET49GAFiN9f0BfI63hIYkNwtyznPGDFkdlyndfRVTPCDOUydBYm4
         bWrA==
X-Forwarded-Encrypted: i=1; AJvYcCW/RCn5uy1pVc05VQOrZzEdej/bHJ1UakOIdvYfCTBNrK9igTWcP8sf4rHwM7NfdXRsgxP7MeJE69ov@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0oR9KGd9aBZVkcmDvNOc2NUpq2HNmDT7Cy4njYWZgjCUAjJu8
	9K85Xu7TpJDd6PxomdMEQorxmQziQmFy3Q6qt2ESM3B3mSho+FSnsDX+GHGyU9vEYha9iXODH2e
	hqIjNmMeCrAYqIPLEVyb66Hztdlhtjf0=
X-Gm-Gg: AY/fxX6G3g8xW2s+BCxK2dP68ByrF99fB4z0iWSULsGRRJma0H+gN4ZzYajUsjeyBWY
	dKddZMOPU3dO1PNF2EKGScVllUEfZ0VFVSsjQdEo5OjqjPdQmJVecjBK19Yw/XbRYbNL2HgG6NZ
	AldKTHgyZO+NZZ+OCVHPdHKM/w3zlFJZs3+Jwk2FAoUBU+ObC87gMjoWHwQJD0S/djYK3bLg2Oh
	VWKlhbaxsnrEyfZbe6ckU3+5w7N8D6+c0YNN3fLNmCJA/RQG7OQ3bpc9NIbkSZIrMr0y1oriqMU
	4sX0CR8=
X-Google-Smtp-Source: AGHT+IHWmp4l+iwvvk4UGfOw4WyIVuDTX+WygPNaY3MwlLjW0z28sFuGsm38Zc7fjoo+CRsLN7xb1TW05w1c4WM+paQ=
X-Received: by 2002:a05:6214:5789:b0:880:3e92:3d33 with SMTP id
 6a1803df08f44-88d8369e698mr6123316d6.34.1766079357608; Thu, 18 Dec 2025
 09:35:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <5b023828-b03d-4351-b6f0-e13d0df8c446@wdc.com>
In-Reply-To: <5b023828-b03d-4351-b6f0-e13d0df8c446@wdc.com>
From: Justin Tee <justintee8345@gmail.com>
Date: Thu, 18 Dec 2025 09:34:45 -0800
X-Gm-Features: AQt7F2oCL92KL5RlafjzhPSPhxdJJT7DMmF2OqVJY7G1K2GtyDi2MGUAHicBT6Q
Message-ID: <CABPRKS-2zsAEjhsJX8aPjzud9LeOTCsF8WN=amSKpBzxxzJ-iQ@mail.gmail.com>
Subject: Re: blktests failures with v6.18 kernel
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, 
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, 
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "nbd@other.debian.org" <nbd@other.debian.org>, 
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Shinichiro,

> List of failures
> ================
> #2: nvme/041 (fc transport)
>
>      The test case nvme/041 fails for fc transport. Refer to the report for the
>      v6.12 kernel [3]. Daniel posted the fix patch series [4].
>
>      [3] https://lore.kernel.org/linux-nvme/6crydkodszx5vq4ieox3jjpwkxtu7mhbohypy24awlo5w7f4k6@to3dcng24rd4/
>      [4] https://lore.kernel.org/linux-nvme/20250829-nvme-fc-sync-v3-0-d69c87e63aee@kernel.org/

This has been fixed in 6.19
https://lore.kernel.org/linux-nvme/20251117184343.97605-1-justintee8345@gmail.com/

commit 13989207ee29 (tag: nvme-6.19-2025-12-04) nvme-fabrics: add
ENOKEY to no retry criteria for authentication failures

Regards,
Justin
