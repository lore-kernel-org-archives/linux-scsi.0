Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8134A12AACB
	for <linux-scsi@vger.kernel.org>; Thu, 25 Apr 2024 11:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714045185; cv=none; b=qY1kG7SaC8WUzyOJI1uNi21PIDjKx3j8JMq+KkCxNs3ElA1nI4928N7H3luhBypWlz1Jf2Dwcd91cWh0s1lp5myhsAIoRsB0J2IsXOj0aDacLlmmRRXUwtG0Km34wULQNNjbo6em1T2ny0jpMH1cwQV99WN77i04fDSrlFeRtmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714045185; c=relaxed/simple;
	bh=lx1UMZxQ7GI3jnCiWDSMDINtorN1nVNDmR/Gckd3Kyc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qTJvg0VNzwl5yHKMiZBsh4Bswqvm6DNQ7zVCRyaL7yNJz/xbkTZAy9wJ2DVh3W7nMtF5ds4yg/zeBu93aD7/8q1DPXndk11wsMpVfMjsq+8rUElEY2LWlmwMrw+KQsnM5Ki/4pi2IMivGW2hraysuuMZTlYtklKWyd79B0zYfJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xj2INoU1; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xj2INoU1"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-41adf3580dbso5259245e9.0
        for <linux-scsi@vger.kernel.org>; Thu, 25 Apr 2024 04:39:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1714045182; x=1714649982; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lx1UMZxQ7GI3jnCiWDSMDINtorN1nVNDmR/Gckd3Kyc=;
        b=xj2INoU16bTYKQIQwjjDOjaqlOIneuCHoRH4PaCQeERXmeqTAgOqe7voW2yhrY0+aT
         WpS4sn+Vk0PgPgnCd2CFKGUPAbyYaiZovfOR21epZ4RkK4puV9HZef9FUtHe0Zyklat/
         YdQB8oOzDuf0bdSMJCUC30CDhK7k+61t4hppcXY91JiMOkoqA1RA6j07nDVnIEDAmeAx
         X7yAMN0E2IuUcA0HoWSoV6ytRt9UzPPTDYdR93DnpCp/pjsLTP07d4K5Ahrwd4LO8J8B
         TbvdB1IVx+k9/ZTP8ihisckiOjvR8F+230eCrublUr1uuXIJDk0LqpM3RjqmdJqWL1V1
         3t/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714045182; x=1714649982;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lx1UMZxQ7GI3jnCiWDSMDINtorN1nVNDmR/Gckd3Kyc=;
        b=sC3DjpsZ8FUF9B6tlSbZDkabP0i8e9MrpNDzDxpf5/DCozy1xp7dnWh0ew5TS6KGfK
         XbFkymvnQ8lGZp5c+29xZuy1WBbwcx3F0uYyvmmlMS1HE4DvtAQ5uBoUwFwpOhU0r3JC
         ftmuxIBs7/AV9JeDIMZGK063WkMQZ/7SBrwZVumjxZxMfXJw9IAAlzZv0JW+69osS4p+
         2Bjksqu6wTwxzXO4RgtQcNoY21uvH6iYrVG6a2xNRnzmw99EEpnJjaKRTryzEQrwODeJ
         +8vC+m6TyQU1bKHhgTh9c3qWciumWZq8xv0XCqxv0lcjPoFgkDUhD8jkH0VYEN1D/XYu
         CETg==
X-Gm-Message-State: AOJu0YykGa2a5f6oNfv9wJbyHm2zZ6T98J331LpG4rhQVvjz5f4tPoxT
	KXkBJaumRhABt3bLA8OwYPpYvPIuHWCOh4QIOcV5JeKkCmrm9nUGbobwlshmEkU=
X-Google-Smtp-Source: AGHT+IGq82OhzsAz74n/xOWFujdowqxi2tmMG3tUKmEgRbvC6V2sRAwNbx7JTrE2QD+khqp3ZW/xjg==
X-Received: by 2002:a05:600c:3ca6:b0:41a:4623:7ee9 with SMTP id bg38-20020a05600c3ca600b0041a46237ee9mr1851362wmb.10.1714045181717;
        Thu, 25 Apr 2024 04:39:41 -0700 (PDT)
Received: from [10.1.1.109] ([80.111.64.44])
        by smtp.gmail.com with ESMTPSA id l23-20020a05600c1d1700b00418f99170f2sm25007939wms.32.2024.04.25.04.39.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Apr 2024 04:39:41 -0700 (PDT)
Message-ID: <7b10292dcc2f538c8d5c27322206507130a6595c.camel@linaro.org>
Subject: Re: [PATCH v2 04/14] arm64: dts: exynos: gs101: enable cmu-hsi2
 clock controller
From: =?ISO-8859-1?Q?Andr=E9?= Draszik <andre.draszik@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>, mturquette@baylibre.com, 
 sboyd@kernel.org, robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org,
  vkoul@kernel.org, kishon@kernel.org, alim.akhtar@samsung.com,
 avri.altman@wdc.com,  bvanassche@acm.org, s.nawrocki@samsung.com,
 cw00.choi@samsung.com,  jejb@linux.ibm.com, martin.petersen@oracle.com, 
 James.Bottomley@HansenPartnership.com, ebiggers@kernel.org
Cc: linux-scsi@vger.kernel.org, linux-phy@lists.infradead.org, 
	devicetree@vger.kernel.org, linux-clk@vger.kernel.org, 
	linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, tudor.ambarus@linaro.org, 
	saravanak@google.com, willmcvicker@google.com
Date: Thu, 25 Apr 2024 12:39:39 +0100
In-Reply-To: <20240423205006.1785138-5-peter.griffin@linaro.org>
References: <20240423205006.1785138-1-peter.griffin@linaro.org>
	 <20240423205006.1785138-5-peter.griffin@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.3-1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2024-04-23 at 21:49 +0100, Peter Griffin wrote:
> Enable the cmu_hsi2 clock management unit. It feeds some of
> the high speed interfaces such as PCIe and UFS.
>=20
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>

I think I replied to this before, in any case:

Reviewed-by: Andr=C3=A9 Draszik <andre.draszik@linaro.org>

