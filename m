Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D1C33AD93
	for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 07:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768204598; cv=none; b=gbxYF+t7Upcyq//N74/wbm729y/V3rhVJzvq6YGXrZVjjxQXzT/DoS0LZX4gNW+6EHGuiGj8BLznmHtJylrxtGsx4CYGym+ekDd1qga65fd1jcbBCOPoIMM3LhV/PWTwd/A94lhSZ4gv9HgmRmHJ6XKVZ8OVpW2kBnUWjun0Cqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768204598; c=relaxed/simple;
	bh=Gf3lltzd84X9dIvu2pA3a5Jkaw8Zcskzh0E99P0ou0M=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=RApxzfrPqOjRPmDOhIsTKNxsz/Eyy/VN5gEl5P0Cbf8nnHwxuyYKZ9hTldJzF+c8/2Wnul0LuD3Ih+WcQvr0fP5Xi9Nbfxw/d3wEU4IfKbnWPZ7pL9thHQAQCfnyv7lWRRCHRlHyIax1GAR+JcM9seE5yjjyR8MOOcasSbVgw14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=Vc4pdsMm; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="Vc4pdsMm"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-650854c473fso591124a12.1
        for <linux-scsi@vger.kernel.org>; Sun, 11 Jan 2026 23:56:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1768204593; x=1768809393; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gf3lltzd84X9dIvu2pA3a5Jkaw8Zcskzh0E99P0ou0M=;
        b=Vc4pdsMmRyBsv3KmX3r5ZIySQolJAgqRaFfxfs5i+FqGpZqoIAWuL9cVnXzOk6RvYP
         qyqldHPIqJPgztVszC4cxUnKrunSQY6yPRdDNjyXsvHgZXc6px2Kf9xoqhhFynkdahY3
         s6AJuqC/TUmo/6wJBsZtvdxbsTt6PPaC4KBItv/ZB/bJa1Bg/K9hBCt++OAZZi3ANnEB
         1zL/eTE9oelWCQYNNLW9oRUvft97VDRdF0HfQQrPCJDuqg0YlCH0wO1X0vY4N5jdpZxf
         DGt8NYxDcmPeNNzyuflmO1d6dubmrRjQcIaWzQdzdp08ze7hDU6DarWRTkaqkuFo1WkE
         A47w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768204593; x=1768809393;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Gf3lltzd84X9dIvu2pA3a5Jkaw8Zcskzh0E99P0ou0M=;
        b=CFv3s8HqZdaLRJg64jWMOgUC99IFyKkOxkj6TEfV9d3rVvX0qVATxrTo/HINQU3sMI
         +73USj4LgbgDLJ7zhDw2ysNE9TkTJYV018zhsRHYQDaxHeTlKKD6QDFhZxAeYBt/lV2I
         vmBwug+AB1bpKQftwt4iX26MwhZRl022azPuDE8qezZopXqKKAoHyzpmFe6Xzbc5hvcw
         4jtl3Xj8r02xenD5BJYEvolpEEna4sM2NrNAov03NuKI85Js/Tpf7nspruByeU/YU+WX
         hNj8NSZxMp8bL9p9Ue+ehThd+VdcnVez2XqaQuUHjYF4Lsq3f2EI6w/gWW/wUDPuzor1
         RXdQ==
X-Forwarded-Encrypted: i=1; AJvYcCXDPgls887MyfATfnIYSkdd9+7UoOGRem5iYchAvF3w4jhWY+RfNAtH8he/FDhAaHXXlk1iXM5KIJ5c@vger.kernel.org
X-Gm-Message-State: AOJu0YzF/HGe4SYT8f95VcmeOHSX05zxV6Bitv3WBYVRelRxco5VokwN
	0N0WCQI36JE9/v3VMsH42MCILR1vvhQsbRa1Yxkc9DxMVHmCj8iCSk77wVcxwZc/swI=
X-Gm-Gg: AY/fxX61YoRSzvBeWglakvcDXXwqLYuniZUwxzsI1gYeHamdfS82fLO3Bj3/rugJ2zc
	Iit0STPhVfZMmoF5AlodQ0YaXC1WhT6WcsOTnXJ4ZnKiU01QW+K6/ohkf7K9/7vCfzoJSW2dj3T
	REsgaSb4LrEhogqvsYmX/PAbI3AoU+ZaRnT2D/MquqeUMtloQHPxsB4EexZxVrwwvVtZZvYiHjq
	oR/fwmRPFkcOcAZBS+B4TqXVcLr5JcAw0H/mHZj/Q2T3cFOM9w5q2ZzR6Xn/xMjS5iRBaTuD8WO
	aRUygM/CNU4R8JgxLT7jcbqgJLY5pqIhCxjUG0G/mtFwUZjH1s9+ilYEtUk4MeJD+knQ6aIDrXE
	xeU1vlqCM7IWXTueStBAia6ZiyYCxx0wvVGL4/s1RRx4Az/8zljmIm5qBKfDf5gAdTguG0c2cvq
	up5+YAnFLwOGlhcapt7HZv5XqB9HnZShYXJgsZsOcMEogElRdLAE4vqN1q
X-Google-Smtp-Source: AGHT+IF4Co8aoQPdp/p5ff/3fLI8tNtSvixQwidRJsMSeJbryeMgmiZxjL+AqiLpgmcJiIOYnaXZoQ==
X-Received: by 2002:a05:6402:34d1:b0:636:2699:3812 with SMTP id 4fb4d7f45d1cf-650977df5e8mr17217698a12.0.1768204592725;
        Sun, 11 Jan 2026 23:56:32 -0800 (PST)
Received: from localhost (144-178-202-138.static.ef-service.nl. [144.178.202.138])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6507b9d4c0asm17138294a12.9.2026.01.11.23.56.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Jan 2026 23:56:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 12 Jan 2026 08:56:31 +0100
Message-Id: <DFMG7RK9BACS.1LM96XH56V2VL@fairphone.com>
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>, "David S. Miller"
 <davem@davemloft.net>, "Rob Herring" <robh@kernel.org>, "Krzysztof
 Kozlowski" <krzk+dt@kernel.org>, "Conor Dooley" <conor+dt@kernel.org>,
 "Bjorn Andersson" <andersson@kernel.org>, "Alim Akhtar"
 <alim.akhtar@samsung.com>, "Avri Altman" <avri.altman@wdc.com>, "Bart Van
 Assche" <bvanassche@acm.org>, "Vinod Koul" <vkoul@kernel.org>, "Neil
 Armstrong" <neil.armstrong@linaro.org>, "Konrad Dybcio"
 <konradybcio@kernel.org>, <phone-devel@vger.kernel.org>,
 <linux-arm-msm@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
 <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-scsi@vger.kernel.org>, <linux-phy@lists.infradead.org>
Subject: Re: [PATCH 5/6] arm64: dts: qcom: milos: Add UFS nodes
From: "Luca Weiss" <luca.weiss@fairphone.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>, "Luca Weiss"
 <luca.weiss@fairphone.com>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260107-milos-ufs-v1-0-6982ab20d0ac@fairphone.com>
 <20260107-milos-ufs-v1-5-6982ab20d0ac@fairphone.com>
 <yq1a4yj5ysp.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq1a4yj5ysp.fsf@ca-mkp.ca.oracle.com>

Hi Martin,

On Mon Jan 12, 2026 at 3:52 AM CET, Martin K. Petersen wrote:
>
> Hi Luca!
>
>> Add the nodes for the UFS PHY and UFS host controller, along with the
>> ICE used for UFS.
>
> arch/arm64/boot/dts/qcom/milos.dtsi isn't present in v6.19-rc1 so I am
> unable to apply this.

This patch is based on linux-next where milos.dtsi exists, but any arm64
qcom dts is for Bjorn to pick up, so please ignore this patch.

Regards
Luca
