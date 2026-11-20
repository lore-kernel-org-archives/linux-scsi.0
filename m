Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795142842;
	b=1L2IOvl+hw6C9+b1jim1xw5/PsEgLEzxma7jU54m4YO9Ll4DYJsgk2hIjoMu8nfVlk74
	 x2j0yTRhwtjctXyABiISUeA+I1DvdnFmG/kKexet260/IKyxWIq4uOuyWcQdt1nxq6rXQ
	 PTLEm1RO1bMb84HAVVtuB3L9Nfg/5DvaMu/A4oN5cHYbXUWbDGbJoJOxccxLy8kqKyH5O
	 y5tVVJ+rc+ktsv3PG/APqrEnEVRVGSxcJkawsTj3o8T9S0BciMliq0aryGXHrtDheXBFX
	 0RGbBI7snw74FSp31nH1Gu/qQvnWsdmWv3QpbjvFCuoKBnCd2jL5EiXOJsBNuYhOlzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795142842;
	h=Received:DKIM-Signature:To:Cc:Subject:From:In-Reply-To:Message-ID:
	 References:Date:MIME-Version:Content-Type;
	bh=x5gEXo3frQiA5JlBAE+K635fwDbjDjwDOWUnBPVJr9U=;
	b=I0SKr6AZXWyUYGk+kiC6TjaAP8HXHTc3oiAcJmogf/n2c6sMDPwyILhesV37a39OSQQU
	 qGRybTwlbQqg3ZGR52PsE7Of6mARya8g/WDxRhWOfsARGCPynKXJGbgAvoEo/vT/ol00T
	 Ga9YifABORZCsepBDZk7j9DwNr5/hjaj6K6/YeDCqq3Awfri98/K9yvBtDQCqrTgl7ZRx
	 HZ6iE8sdfNt09Lqcz8RA//ApbABbRcrXxxj7PK09BCvJT3RSni1uanri4pDGslwm41P1E
	 bveEmLoPiReSBuoLszIv6eo9YOCgXSJ6dkGhOTBmFgtFMTYr6bcFzBhLGLhAO3I1HTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RQkAlkre;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF06606A320
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 02:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RQkAlkre
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A54001F000CA;
	Fri, 20 Nov 2026 02:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795142842;
	bh=x5gEXo3frQiA5JlBAE+K635fwDbjDjwDOWUnBPVJr9U=;
	h=To:Cc:Subject:From:In-Reply-To:References:Date;
	b=RQkAlkreQg4rMoUVA6B1f8qAWUcmwZkQg8WUJtvibSMP0pH4oSc92MIjDtDOf8sJl
	 FKqwC3TPl1ucCbXeDNKH8AKRIeGzi9OYGEpvqARScRMnOfpVfIuDjRhqdIg7++vkxN
	 ZDo5hQ2eLfegwl5r1qDWlchS6Tp1IIRmHIP0tTEKlrdmAk6kj9mQyR8LsI6TMQckQ8
	 w6WgQr5k/rl+xtvLsAjs59MDupjuXk0O2N1VFpsgheRM3rWeN3yikaE8bgtjVhfbSa
	 y9Dt0qWHKPPmN5doahgLn5VZmHh6wmm3dREP35FFSxYCJ/Bty9P07fDMW5CKBFBnDc
	 2fZ/QI8qRsXjw==
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
  linux-scsi@vger.kernel.org,  kernel test robot <lkp@intel.com>,  Peter
 Wang <peter.wang@mediatek.com>,  Chaotian Jing
 <chaotian.jing@mediatek.com>,  "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,  "Martin K. Petersen"
 <mkp@kernel.org>,  Matthias Brugger <matthias.bgg@gmail.com>,
  AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: Re: [PATCH] ufs: mediatek: Use ARRAY_SIZE() instead of open-coding it
From: "Martin K. Petersen" <mkp@kernel.org>
In-Reply-To: <547675c30e66d7664c0adec81f025986ab6ddfce.1795135740.git.bvanassche@acm.org>
Message-ID: <yq1wlq8p6c0.fsf@mail.kernel.org>
References: <547675c30e66d7664c0adec81f025986ab6ddfce.1795135740.git.bvanassche@acm.org>
Date: Thu, 19 Nov 2026 21:47:20 -0500
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


Bart,

> The kernel test robot reported the following Coccinelle warning:
>
> drivers/ufs/host/ufs-mediatek.c:1351:32-33: WARNING: Use ARRAY_SIZE

Applied to 7.5/scsi-staging, thanks!

-- 
Martin K. Petersen
