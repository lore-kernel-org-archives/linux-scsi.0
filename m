Received: from mail-ej1-f67.google.com (mail-ej1-f67.google.com [209.85.218.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A632C11CD
	for <linux-scsi@vger.kernel.org>; Wed, 25 Feb 2026 07:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772005114; cv=none; b=Y3cTh4ZCFqQQMfZBV6HN1J4uC7Iz98mwY6Yr8p4uOuc3U+S4IpTtOwc6y+zZqdgYEO5HbzwcTWMzxyqC/zW07XoopRjIvC0KX21FAy2UB38/o4UiLtyhUhytJQTox2cTLTq4uRuN39dXY5GgYlSgvwMCf7LPWQsuNrhxxSVc1Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772005114; c=relaxed/simple;
	bh=RBbXuWLXblfk6OwSd9oD/neH6OS15UC/fy5GctQv3UE=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=kxPe6FtUthfLk1s908oMPgjvFDhXUGRUBsOdhQWNEHQ/nP/eRRlfRlZDEWCjf9GqY16PvLsJm5dIpJb5enWGBLPUg0NcgPyi0CJZRwsRRHBy6LXVcDQEhETtgqvxZbEWCoRb/wmHEBroxWqoDGtXfH1G6CAKhmQ89aicpKRy3c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=YFt0B7kz; arc=none smtp.client-ip=209.85.218.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="YFt0B7kz"
Received: by mail-ej1-f67.google.com with SMTP id a640c23a62f3a-b8860d6251bso841627566b.3
        for <linux-scsi@vger.kernel.org>; Tue, 24 Feb 2026 23:38:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1772005112; x=1772609912; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RBbXuWLXblfk6OwSd9oD/neH6OS15UC/fy5GctQv3UE=;
        b=YFt0B7kzDND5OVl2+MnPcsAB9HGkjCkn/jj4r7YU5tBnp4y36qwriwD2e5CJdI0c/6
         1sDt5AbR0J+c+HHL9iWMYCeX6umOneiuoC0ZlYQAXmOO0/iqYeTbkdfSkC17K8fzxtGq
         /zfB36IRQ6XEmyLqYLfAAdNlx+L+e8uYv0oyjuPlGY/5/FYMEHHOWNr1TkEwHRZnV0mo
         ML2hpvsd4YdzGSK6FtoOvy6TxNtdTaUvf7+r47vbkl/ciYb3wl0Cwq3OMvKh1e47NzxR
         zRI2ex3XM0JpGH0xJGYSrUPPiCbNLbZBcn1JLffUfpiP5p0Y+wK+WTCgrntBVYa06+eI
         xiAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772005112; x=1772609912;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RBbXuWLXblfk6OwSd9oD/neH6OS15UC/fy5GctQv3UE=;
        b=BqlIQ8MBqzIAkw4wPtVAHiq6/l5Alb/NUQvZ+7WgtlzAsTrn1Z7PVYWHrA7wLd8SB2
         C2caN7vRipAyM3bsrlNLC/xxFsHEAtp895kMoGBpayNili2v/jkOnz9W784KlEOgubk8
         uUcQGtb/L9tAp7Gomo/04V7B72xUkOZ+HvMN/a6NQNx2Ouw9Hjb5iUv9SOusSf/wxjLD
         T4LFkKM6D6+qooZcGGro8lB7XE+ilgkCh4C19RGx+JeTKMlXBw/6hXsY7LyL5bL97bss
         h07nqZez9HYl3Ey4RxMWvVMfMuQeE9SBwUPD7fbvUKg3sAIxWE5HZSMq7eczyilmZ3tP
         rgLA==
X-Forwarded-Encrypted: i=1; AJvYcCWKRvU61+q3+wU2WzKqO5VEiLY8dSQjsYny1cg3L9LzmNYNNJ1A5WJsE8vPmBmp5it6nl7YtV2cUnJ8@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9FBH4z91i62HtpBWcgJn8EFVSRZ5BbpB7SPOGB07sanUE9/jA
	oqzCaUqkFD8V59eYnNEzlLYRMhPcDBek+Xbd15u2FYrAOX5w8BWqU+00pemw091jtnY=
X-Gm-Gg: ATEYQzwgVncgKGMIPUYQUPKE9gwDyuJ0ttqTU4A2QjV+VfnYi7aPyKgtRjMjToKDNPS
	xupO58v0j9eGlBIgoAJkDCO/wO3rGN64rKpLvqpauR1uYdxUJlKneGKK4hq/VJZ4lYuBllud+3g
	QRvj0rVmlL0jgw2WQ+iGOoz2OQaxqXKJDW7ucsrS2cyKEYrcYQWTJ/NDdk7IqozKbj+Kw1LdWSY
	PXZte/q0r5S7fNW3Y5jwQo097tlBQmnyJNpBtxB/JkhkEST7OTXyHwF0cmQahH2F2s3FISC910X
	2ESaieEQZLtJD2rC1vjtKhJ0LCWu39cWzZPdbK155EZFUy5hfwhaSOg44YGMGpHVwV9sh3Ht8+U
	t3SBsB65gmCwQW0yfkXBPtL4s6/vo6gQU6n8+7/dGL5ujXIRbhJ6jYWMA8w4JwI9Ppsv/gQOBG9
	ZKCQZ2jyWrX8xrXoFRwkjXxVVDG/s80P2azkxptKiY5f2HUiaImJB7R8aieoOvnramQWV2
X-Received: by 2002:a17:906:eec7:b0:b87:c92:25bf with SMTP id a640c23a62f3a-b9081b23d71mr868904066b.33.1772005111791;
        Tue, 24 Feb 2026 23:38:31 -0800 (PST)
Received: from localhost (144-178-202-138.static.ef-service.nl. [144.178.202.138])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b9084cd4adbsm494528566b.29.2026.02.24.23.38.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Feb 2026 23:38:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 25 Feb 2026 08:38:30 +0100
Message-Id: <DGNVDXQTH812.3MCVKWNCKR8B6@fairphone.com>
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>, "David S. Miller"
 <davem@davemloft.net>, "Rob Herring" <robh@kernel.org>, "Krzysztof
 Kozlowski" <krzk+dt@kernel.org>, "Conor Dooley" <conor+dt@kernel.org>,
 "Bjorn Andersson" <andersson@kernel.org>, "Alim Akhtar"
 <alim.akhtar@samsung.com>, "Avri Altman" <avri.altman@wdc.com>, "Bart Van
 Assche" <bvanassche@acm.org>, "Vinod Koul" <vkoul@kernel.org>, "Neil
 Armstrong" <neil.armstrong@linaro.org>, "Konrad Dybcio"
 <konradybcio@kernel.org>, <~postmarketos/upstreaming@lists.sr.ht>,
 <phone-devel@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
 <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
 <linux-phy@lists.infradead.org>, "Krzysztof Kozlowski"
 <krzysztof.kozlowski@oss.qualcomm.com>
Subject: Re: [PATCH v2 2/6] scsi: ufs: qcom,sc7180-ufshc: dt-bindings:
 Document the Milos UFS Controller
From: "Luca Weiss" <luca.weiss@fairphone.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>, "Luca Weiss"
 <luca.weiss@fairphone.com>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260112-milos-ufs-v2-0-d3ce4f61f030@fairphone.com>
 <20260112-milos-ufs-v2-2-d3ce4f61f030@fairphone.com>
 <DGDW69W84LJ1.2GHM2WU31VANR@fairphone.com>
 <yq14in67xwd.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq14in67xwd.fsf@ca-mkp.ca.oracle.com>

On Tue Feb 24, 2026 at 8:19 PM CET, Martin K. Petersen wrote:
>
> Luca,
>
>> I've added you to this email now since you seem to pick up most patches
>> for these files. Could you take this one please to unblock Milos UFS
>> dts?
>
> Applied #2, #5, and #6 to 7.1/scsi-staging, thanks!

Hi Martin,

Thanks for picking up the bindings!

I'm surprised you picked up the dts as well (and modified the subject
line), these patches should go via Bjorn's qcom tree.

* scsi: qcom: milos: arm64: dts: Add UFS nodes
* scsi: qcom: milos-fairphone-fp6: arm64: dts: Enable UFS

I also see these in your staging branch as well:

* scsi: qcom: hamoa: arm64: dts: Add UFS nodes for x1e80100 SoC
* scsi: qcom: hamoa-iot-evk: arm64: dts: Enable UFS

Regards
Luca
