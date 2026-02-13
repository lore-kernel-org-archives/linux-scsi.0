Received: from mail-ej1-f68.google.com (mail-ej1-f68.google.com [209.85.218.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A517E35FF72
	for <linux-scsi@vger.kernel.org>; Fri, 13 Feb 2026 14:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770991737; cv=none; b=Yc4bBu3TtausJ0tkL3G7SBBvpVKnuh9+O4eENvaZ3KgHi082UiF5v3qpJ5f0qHPs5RLoyc0AI9Fzwgb77Y4HzKZnvXMc6ddRCu1SqwkJ3b4geMpFsWrYWr3Y1xlyueWxV9yR6r4y7PiXxtAcK5b2QZRAnDH/gVu1R+NaCJGRm5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770991737; c=relaxed/simple;
	bh=kSxpGwm9UDimkXPadlMLx9J4LPHuy90pfvo/9O4YcSg=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=LbFTfwfPhU55UCIbT936vVN58ykTct2U1KKH509RItZMpF2itpXhRisj6cLL0hkPQRZCug5jO8s83Efzssk027QLTnVBz8OEtoKl6v1Lhh7+KDBfwYeGzFvwxVf1fwv9IzcRDISVx7KbNWXtiYrpuwQ7jwrTkw5W9sBPSCXYBZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=cn7gYATX; arc=none smtp.client-ip=209.85.218.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="cn7gYATX"
Received: by mail-ej1-f68.google.com with SMTP id a640c23a62f3a-b8842e5a2a1so114838966b.2
        for <linux-scsi@vger.kernel.org>; Fri, 13 Feb 2026 06:08:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1770991734; x=1771596534; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MDWCaCmjcMdTeU70IpQ6l5t9XJKDcXByz0w6wvm7lMw=;
        b=cn7gYATXW2pTKK268nnPC96kyjE6vk5jUTQgnqIFRP5kqqObCjRljl4R95gTd96L6M
         DPnWW4erxOVa2X7ux+83MCOsBwa9Cj9NnNVtUhwZQ7DwTV31Cd/5+/N3NIN7i9zduFrp
         Qf+aU2Nql3i9pxJVZtggqel1lfwaTkPMcTA1LUiiQ+X83z8V7BIVnB8ZYbCA1OmZAQPt
         HWDslNDDUC8StTtd2ISTAIHcqNokBLZ+F7yqQE+wk062LMISnYQT+jTokXXdQfnWTmgS
         sV5womhihB1B0+Zk7Ydflgt+9DeFMPXE/E1vIOoOnKNnaZzFS55Utd6Zvf58SfeUbk6O
         PffA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770991734; x=1771596534;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MDWCaCmjcMdTeU70IpQ6l5t9XJKDcXByz0w6wvm7lMw=;
        b=k0jo7umRnrHJ88qbpsoQGSVKqKC1GTzNcP5Zw7vmwbxbsaafMC5G3HyBWB1y8VBiBf
         QSr2JD7fiXBfrEczShNoC/hGrdEaktTkK4KHgMHifSpIis/EocRQ1/pfxvDzDhI/Q2Pv
         IzWaSZWiypnTkgV3B0GBq3dfwgmKDx8CwQ+abviR2bdL3ffznDACuHd7jmFQqP/M77eR
         Xf5CVdmZLifYAnezyx1meS0gpvFv3CD9kSWJLVwQxZFX4e3JNO9uXkDtTDDowR7R/llA
         nzwm7AvDrQQsogs/PDyB1qf1va0TR1p8SBr5X/tL4RH2XN2bcRWb3RPFuJcsf7CUnmzX
         tvSA==
X-Forwarded-Encrypted: i=1; AJvYcCXG1ubNRTHWl9mutg4EclBYuvrtnmRPEzF7YWofx1avjJrYqp8BbKbXvxv0LgH7dWnYv8Nm/B91RefN@vger.kernel.org
X-Gm-Message-State: AOJu0Yxq32FZ1QYICQUQ8vliYHKiPxofNCLZLg5w2fLavXsVmamFq23K
	LbwUhVQrAbv8LDoTFXBip/Pu2HIHJKPvpYGApeqAWj9JVSZGigRVixMWvNG1STHuDgw=
X-Gm-Gg: AZuq6aKbn60tIEW3EOQpXwagok9cWQVxphHmIJgfH4R70CWIbYZQhavnk8t4x/ciAek
	91VLPz7ZYwVncK3l7L7K4U+f5h3YgxCj7Cj0Zw5bBSsNPHo5apGLAVvruS6BYJIfzawBVwCZh3u
	46dFjNeX9KzSAJAVh+JMtzzy7OCiZwMpew3ts1xSO/eml1H91ia1gCMwaanb2HV47xXU61dkAfp
	k6uZOTnpfUCjwL2lPFBbMIhXXtfK9wxuG12FwxrKmLHprBezVipxoqRyMpKlb+6C2FH7TGC9Wt7
	rFyO6XNJzpBnCXFWfj0uYi4cUo5r9n87CD4RHlKb2ZM4zfvIYXqAF8DXX64VqeiAz/FFAgF3YGN
	wrMU+OKAsRusndQciHdZyXkArcINx89jMq0Bp3fUCTZEWbm0hFhZa4b8qsP0isL80MBDr4P1l5J
	A2gU/x9AvTTJM7G9vbxPL35GMrFGzMu0JaAbsPdaXhEKl0oSY/KSs1Qzy9gFJaBgmN2nxG
X-Received: by 2002:a17:907:961a:b0:b6d:67b0:ca0b with SMTP id a640c23a62f3a-b8fb46764admr98204666b.61.1770991733815;
        Fri, 13 Feb 2026 06:08:53 -0800 (PST)
Received: from localhost (144-178-202-138.static.ef-service.nl. [144.178.202.138])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8f6e9cd6d4sm263856066b.23.2026.02.13.06.08.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Feb 2026 06:08:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 13 Feb 2026 15:08:51 +0100
Message-Id: <DGDW69W84LJ1.2GHM2WU31VANR@fairphone.com>
Cc: <~postmarketos/upstreaming@lists.sr.ht>, <phone-devel@vger.kernel.org>,
 <linux-arm-msm@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
 <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-scsi@vger.kernel.org>, <linux-phy@lists.infradead.org>, "Krzysztof
 Kozlowski" <krzysztof.kozlowski@oss.qualcomm.com>
Subject: Re: [PATCH v2 2/6] scsi: ufs: qcom,sc7180-ufshc: dt-bindings:
 Document the Milos UFS Controller
From: "Luca Weiss" <luca.weiss@fairphone.com>
To: "Luca Weiss" <luca.weiss@fairphone.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, "Herbert Xu" <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, "Rob Herring" <robh@kernel.org>,
 "Krzysztof Kozlowski" <krzk+dt@kernel.org>, "Conor Dooley"
 <conor+dt@kernel.org>, "Bjorn Andersson" <andersson@kernel.org>, "Alim
 Akhtar" <alim.akhtar@samsung.com>, "Avri Altman" <avri.altman@wdc.com>,
 "Bart Van Assche" <bvanassche@acm.org>, "Vinod Koul" <vkoul@kernel.org>,
 "Neil Armstrong" <neil.armstrong@linaro.org>, "Konrad Dybcio"
 <konradybcio@kernel.org>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260112-milos-ufs-v2-0-d3ce4f61f030@fairphone.com>
 <20260112-milos-ufs-v2-2-d3ce4f61f030@fairphone.com>
In-Reply-To: <20260112-milos-ufs-v2-2-d3ce4f61f030@fairphone.com>

Hi Martin,

On Mon Jan 12, 2026 at 2:53 PM CET, Luca Weiss wrote:
> Document the UFS Controller on the Milos SoC.
>
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>

I've added you to this email now since you seem to pick up most patches
for these files. Could you take this one please to unblock Milos UFS
dts?

And maybe you could add yourself to MAINTAINERS so b4 picks up your
email for patches to these files?

Regards
Luca

> ---
>  Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml=
 b/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
> index d94ef4e6b85a..c85f126e52a0 100644
> --- a/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
> +++ b/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
> @@ -15,6 +15,7 @@ select:
>      compatible:
>        contains:
>          enum:
> +          - qcom,milos-ufshc
>            - qcom,msm8998-ufshc
>            - qcom,qcs8300-ufshc
>            - qcom,sa8775p-ufshc
> @@ -33,6 +34,7 @@ properties:
>    compatible:
>      items:
>        - enum:
> +          - qcom,milos-ufshc
>            - qcom,msm8998-ufshc
>            - qcom,qcs8300-ufshc
>            - qcom,sa8775p-ufshc

