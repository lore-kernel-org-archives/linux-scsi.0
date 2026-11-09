Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794194315;
	b=vHsDv712hC4ABav7obcbnOElWAbZsRGga8EPEdhUPcG4ZqySHtUR7P0tnjKa25BB1vCP
	 WjMkLKE9Dolld+2miIlc/v4gVhzq7gkJS3+ea8KX6m/FW134cdyz50OGOSq+/fX+ViFee
	 lhnRQ/ux8OcJrQEya+uvVyS5619nzvocB7+g2t5h3/vtCG3fCzDAErj/ifQpNv/gTnhTY
	 3jrCtfY/ztlygeR4AaZRzaLgI8wf33CODIKwHc4uDX79ElZAkgVPVgD3W9AYXDRwADGQP
	 SjP4Ww5qyqCwUu1A/rfls8wRnvKYOg+atFU7YIKnujMM/MM0CNLHHzDZYzasd/hLqQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794194315;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=s0Hi6a4UzQOVDUCrl2d7KaSZKBXxqT7Il00z8aUrfhY=;
	b=Jey9JXF1GstRmkjSyqebPPrR26UBr7gnIA7JPpBkD5BvIWV4XWZz3/JJepOX/jocPx2/
	 lUolTWzWH9CCvVfgVTzd2FHy7V5WS5cSPg+lNzSVOpwyhA+W77lEKLEHqhUoLRqWAhILj
	 Fitt3dMLzd4T5GTmS7loGJVDfvWf2Jr564p1IjQlJl/ZMfu+u4w82QCmgE/0gB8BIHgUZ
	 CbACsfWvocxljJkJ2TqgmnmhrgSeu3l/yqXGJtdXcdmagL2D/nFmDzgNcD5b+ANKUeWnX
	 q+Qn/0w5kuRCJMKI8Nvm5kgB4OvPdT7SZipjU762xb9QfRpTWxe/2TgBX/+XntNPrdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MhuE+yBj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7F3606A31C;
	Mon,  9 Nov 2026 03:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MhuE+yBj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 035FF1F0089F;
	Mon,  9 Nov 2026 03:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794194315;
	bh=s0Hi6a4UzQOVDUCrl2d7KaSZKBXxqT7Il00z8aUrfhY=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=MhuE+yBjnbqQXlDe/1usvgThyy9whC6+OWlEkMGl0lpUn0xVxFT5IP9e0A8vslzCy
	 P02e7hfJ0x/wMDhu/5tJ3mlxmpRvTLXufcNEUD8SmtzBc2KL34O91PNUjXtAmIIYwX
	 /RTKyjQnKaM862pHqlwEAsAnptwqhKkvA6HzTALSKqxIK2aT4meq/gteR9nNNfqSCD
	 7LBbCYQR52mO7QkfbaARtOwAFPVXfi/dM+19WlO2YkCT4JlBM6Rf3Gm8FWSmon0F21
	 CpQTlFzbf3+gFT27bWdDJbXJYATZWvMbBvo8HqVkO4UHRQwireG3pMmnP6odL9DqG1
	 ejfF+SX3YiWJQ==
To: <shao.mingyin@zte.com.cn>
Cc: <mkp@kernel.org>,  <james.bottomley@hansenpartnership.com>,
  <linux-scsi@vger.kernel.org>,  <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: scsi_devinfo: return an error when the proc write
 fails
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <20261031222133489hI-BEIDpFMxrtlntnLiFb@zte.com.cn>
Message-ID: <yq1ld72wv42.fsf@mail.kernel.org>
References: <20261031222133489hI-BEIDpFMxrtlntnLiFb@zte.com.cn>
Date: Sun, 08 Nov 2026 22:18:34 -0500
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain


> proc_scsi_devinfo_write() calls scsi_dev_info_list_add_str() but
> ignores its return value, so a write to /proc/scsi/device_info always
> reports success, even when the string is malformed and no entry was
> added. Users and scripts then believe that the quirk is in effect.

Applied to 7.5/scsi-staging, thanks!

-- 
Martin K. Petersen
