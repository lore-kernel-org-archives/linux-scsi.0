Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA8D40584E
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jul 2026 11:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784548189; cv=none; b=qcbaPDjNdqDvTkKMmK2N9BOcPj11MQ6cVvIqUkN0dAFenFxuMKHzUQh2ZUn1+nH57mqLVC9W3rBcSttLMG+KVIRi8h8vlZk5jwP4OMS8MF1s3jX4xiw1ayTURCpVWchXkdXUsHjizDK4MHiqLay2SSyMTLk5DCaxWdjklxJcYFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784548189; c=relaxed/simple;
	bh=mWjoEED7hRlxkGUG7pJFGe3tyHHnmect48ByXM8C4ME=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TNqnmyyM3sCMqz9lDh+TpvQoiQJKKSPrnn1zP0XdXWRlFS8/ijPPJZ7mabL1GU2ev9sM4MnNBLHhwET9X+HErxS8ENznEHz++Nu22By6w6dv9J5UJCmscSgnTqKOJtamBSZDJqirulkEW/wKTYc09LCSTxEylQ8+HkWRZ10VPic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cejN8X2Z; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cejN8X2Z"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c15c42a45adso572654566b.0
        for <linux-scsi@vger.kernel.org>; Mon, 20 Jul 2026 04:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1784548186; x=1785152986; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=mWjoEED7hRlxkGUG7pJFGe3tyHHnmect48ByXM8C4ME=;
        b=cejN8X2ZixGDW8gc+mzPQekiPtNxWhhJ5TqRtNiKppTjojx1SSs7BvchNMhUpMTVXw
         eynZpgUsWf+gMbgdoultkmcoGsr+3J2JVOEIh5rcBdz5SWInbs/dxbhIAi98HMcUL+bZ
         VYaD3oBFlUgE4UFvc7rMRvPvx09n5OzwwOcZDlFLagCc6gfl4hD52+HB3eLxTnR67VlN
         pjyLhmu0CpJkwdBVuovH1wcsqO8ZgewQpV+oYQLdkWdOKaxozxd7ZVeuw++U+re1EvfI
         dPTYb5/VaN3djqGQRdGmTLLC16cNKoi3EzVL7WViY8xJcymZhLNNzEf9wBdW3WYrOFuT
         DORg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784548186; x=1785152986;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mWjoEED7hRlxkGUG7pJFGe3tyHHnmect48ByXM8C4ME=;
        b=CSyyyDQ+klmvr3O9k8t7h7S/hemVsd7VXbPAUwUVgUddeMRBq5QTGW5/jtD7wdKmra
         PFem9q/AwUNHcWRE1KjyPZPq4+jaHcEX4mfOhWMcsuSGoTILxkR5l6Sm/2XAWz9G2mmp
         nhe2GNJRevgPajPz5LkqU7aD8pSNyR6L6S8LmwZWuUKEBpkogfRbkoIlGMVlKDqGowpi
         KHTHsEneBjz/+5RdbmSqnV4wm7mE1sFW/ik0Oe9PtPgnWcjC6CM9UhG3+Keg/OW0J/0H
         nBGGa6x8CXOXRCs1g6yVRGbpnfPlOEn4+Y17jxUE7GN8yrE/VL50cj7hezvOwO28jJzW
         0I9A==
X-Gm-Message-State: AOJu0YzfXFugEVGSwxgVcY8HrX2JiVqYyd/wirL/wjXAGJh/p8gWy8KW
	pMi3MCZtFxvgrr6Df+FjaZuI/dW0RWLMi5LTc7nZNQB66GAmjGxvccTFNobu1t3kdZI=
X-Gm-Gg: AfdE7ckoqmDAWuCmAKu2cwDhfCESqwUXtGPFI+A668FNl0+7sAZrDFRhIo//5ePp2Id
	OIbIu0xFfk9EBHpaNScJlhP+YrSqf1B0zJCyqUv6tAME7bq8aSWZnaOA18yugZKCODBUvcc50Ql
	ZmRX2A4v+3VV8hr0z57PK24zh5DorOv3zIF7vrLh3WrKoHHSkl+V7tNL7up90mOZYeiNw/RxSps
	LOuRdSNfOnx3A14Tpg64xk1HF2V/F/lRTiA3rAEBSobRfvAgpeac+rXKbfxvZCLHk/ZQ1XwZW6V
	4o3M4pLVP6Rcjwl2CXcLspS1Bq/TT4ASVQDFcUSI5IDpbMt2CtrxchpBN+vCiQmJ3G4/qp1D9WK
	lRrdEcqd1vZXlMUD3tQvR8+geAJQRadqZVXv/i9Z1dlQGlvuYcopcQ0yjPPwJM+fDR3zF67ZG19
	G8Y1zR8HJnZIiaNroe
X-Received: by 2002:a17:907:e1d0:20b0:c12:cb91:58aa with SMTP id a640c23a62f3a-c16b4137321mr383177466b.24.1784548185469;
        Mon, 20 Jul 2026 04:49:45 -0700 (PDT)
Received: from draszik.lan ([109.255.181.4])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1705a08490sm455141166b.21.2026.07.20.04.49.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 04:49:44 -0700 (PDT)
Message-ID: <0b03502eaa261f786a2995397790c4da81422992.camel@linaro.org>
Subject: Re: [PATCH] ufs: core: Revert "Delegate the interrupt service
 routine to a threaded IRQ handler"
From: =?ISO-8859-1?Q?Andr=E9?= Draszik <andre.draszik@linaro.org>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	 <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Neil Armstrong <neil.armstrong@linaro.org>, 
 =?UTF-8?Q?=E5=AD=99=E9=AD=81?= "(Kui Sun)"
	 <kui.sun@unisoc.com>, Gregory CLEMENT <gregory.clement@bootlin.com>, 
 Sebastian Andrzej Siewior
	 <bigeasy@linutronix.de>
Date: Mon, 20 Jul 2026 12:49:53 +0100
In-Reply-To: <b70eb60a01f971bed68c42c5b555929db5f835df.1784135511.git.bvanassche@acm.org>
References: 
	<b70eb60a01f971bed68c42c5b555929db5f835df.1784135511.git.bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-8+build1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2026-07-15 at 10:12 -0700, Bart Van Assche wrote:
> There have been multiple reports of performance regressions caused by
> commit 3c7ac40d7322. Hence this revert.
>=20
> This patch reverts most of the following commits:
> * 3c7ac40d7322 ("scsi: ufs: core: Delegate the interrupt service routine =
to
> =C2=A0 a threaded IRQ handler")
> * 6475cfb81fc4 ("scsi: ufs: core: Avoid IRQ thread wakeup during active U=
IC
> =C2=A0 command")
>=20
> This patch preserves the following commits:
> * 034d319c8899 ("scsi: ufs: core: Fix interrupt handling for MCQ Mode")
> * eabcac808ca3 ("scsi: ufs: core: Fix IRQ lock inversion for the SCSI hos=
t
> =C2=A0 lock")
>=20
> Neil, please check whether this patch series fixes the stalls that you
> reported: [f2fs-dev] [PATCH 0/4] Reduce the time spent in interrupt conte=
xt
> (
> https://sourceforge.net/p/linux-f2fs/mailman/linux-f2fs-devel/thread/4b33=
7c7f-2fbd-47b6-9c8c-587e7b5513f1%40kernel.org/#msg59345049).
>=20
> Cc: Neil Armstrong <neil.armstrong@linaro.org>
> Cc: =E5=AD=99=E9=AD=81 (Kui Sun) <kui.sun@unisoc.com>
> Cc: Andr=C3=A9 Draszik <andre.draszik@linaro.org>
> Cc: Gregory CLEMENT <gregory.clement@bootlin.com>
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Fixes: 3c7ac40d7322 ("scsi: ufs: core: Delegate the interrupt service rou=
tine to a threaded IRQ handler")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> =C2=A0drivers/ufs/core/ufshcd.c | 39 +++---------------------------------=
---
> =C2=A01 file changed, 3 insertions(+), 36 deletions(-)

This fixes the performance problems observed previously:

Tested-by: Andr=C3=A9 Draszik <andre.draszik@linaro.org> # on Pixel 6
Reviewed-by: Andr=C3=A9 Draszik <andre.draszik@linaro.org>


Cheers,
Andre'
