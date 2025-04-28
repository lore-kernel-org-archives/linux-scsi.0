Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF91264FAF
	for <linux-scsi@vger.kernel.org>; Mon, 28 Apr 2025 11:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745839570; cv=none; b=bVzrC2hR7Fnl7WwcRubXC7jyXJ3U2U6vRKJgXFKpwK/LU3pq5XEkftCVGopa9FG5+byvVaYcsn+pcdxfkSfALbZnIXU+E2jtSV21Sl6PY5ijfc0h3ZWSzlaQzxONXX10qI6Iw+Hp6uwD/lqwaxIjenmKPVCugbtSygLXky8iRX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745839570; c=relaxed/simple;
	bh=YuK7JoVFw4BkBRnm2Ypzhevv3vdRGeuSRVhD+23HyZI=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:
	 References:In-Reply-To; b=lJxYFJvIHpnkRhnoA2Al4yLAGS/cHVuZNw7zif935KFrf4cXvUH2n4youJ1dRmL4qwICt/lCd36kC2ynRfyTFGEOkkc9oAfD3elTwtMWZwiund2rPm+7eLBe5BZzMsOz0YXy/bbZGa1bWAHRA+yOP0hye52IoPaJooWIGaqJy8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=1frXG2yA; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="1frXG2yA"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-ac289147833so822344066b.2
        for <linux-scsi@vger.kernel.org>; Mon, 28 Apr 2025 04:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1745839566; x=1746444366; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YuK7JoVFw4BkBRnm2Ypzhevv3vdRGeuSRVhD+23HyZI=;
        b=1frXG2yA/J31+DxBgvJYyVLUi97KnZtGX9Zk/M3Bl2snVVNXDWQXuc6XG3V6WeUx7B
         f1U5aDtJKWtiiQRdD4VvYbkD3B+SAt+npqBST1wiL0SNUEVcS1HY7NLDVR6Jzut24wxb
         gCPESrGCf4WX1/zJLBf38tSIbZbM/8gN1khX0H0GqndfcvVvFqRO+iBKbo3UZit/FLJp
         R+eFXaVLc4tapFpZXpJaAvS9edbIrVM0L3MCmRjZokCgHuQuvKwZU1jXQemUZ/g3SLNt
         ylJFpLFLYCDqev6z9amfbQw+GN96I9FGfWSNRZtrGzH1wyv11oJVrqBJVrTF4F3WIdqk
         YfEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745839566; x=1746444366;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=YuK7JoVFw4BkBRnm2Ypzhevv3vdRGeuSRVhD+23HyZI=;
        b=b+9nYl7/yVUZUyTQpCibyyGrzgCrAPi4JAKjBy+qCaLGa6fo4vOp6Ex/Zm9283tmlG
         yvrI7/FU2P2S7u2pLmni2NtA0HcL37euyShXRUfI1M84ZG0uaQmSBJsim9FAz2tGS+ce
         GiOIs6ciNDAMfu/jy6hFUw+VSyMOBuaLuTJvmh88+jYaDKMc9FeKCYAKUyy5w17P33fC
         2WXwgUMqQ4hJ/zY3PruSKOyY2tK7Ew/2XfNXEMb/WmPjejKW3Kfeb3ONA8G7G+Aw7egb
         lnhprLt0WtAHKOJCNTbEFqcwYW198wyJ3sQmmLX6qqpY1jJVdd7Jo09Fxlnz5umUgQVp
         eSOg==
X-Forwarded-Encrypted: i=1; AJvYcCWtp8N/nDJQyz25i/JjiqcRQFaMFyiwpIDJRu7C0vbnkSlThRfuoAZiGWN7njCsDdv8qd42Eb6tL/W3@vger.kernel.org
X-Gm-Message-State: AOJu0YzjUQVlt7XRNkrPIsUt2oHDJf50IJvHtxF4vaAbyrYPY0xzjdC2
	4lfWFIyNhqRJOTjR7El2hAaPe7CFG0EpQi3wkK6JIKkxq650nhWwJKEq+qG5yJ0=
X-Gm-Gg: ASbGncuwZstgxdgJqxvrj4L+VLedVbOu0eGXbvopKDP4AAk8Gc74S/Yv02SDdj1qIL0
	QUcX8FwhrG9XCdlpAI6+CQjK4O4l2uktWpltc656iKIHh+08K6M/LPD/y4uOvrhVNGzUsL+tXkj
	QrF9QYwt1IacgIEOLhwSCvs2/9Tn7fCa+5odJlljzYAkooQeYqMwXrCaTz3XrGPQRbC6isFZOqu
	lOkRVkruQ7eJVWRnddjGGYIQM2DUudLNKhP4Q3Cmt3+6BeyX3ToIxftbmo/gaG/tYG31r7QigLY
	btHIZXeaHsM8BfMu+gY2paF/V0jrTkPVHdrW7YBi3a9OYrOwv+fx5IWiHqQ55ptRHxv5h/VGXQs
	hv1RMU4MtWQ==
X-Google-Smtp-Source: AGHT+IGT+8m3xK7xabSZ29IvBc7+P0gS4DksBTS1Czdm2SNSBAyYHQHsIegSOcFqAFzVvUJUQUDxDA==
X-Received: by 2002:a17:907:7e84:b0:aca:d83b:611b with SMTP id a640c23a62f3a-ace84aad97bmr827114066b.43.1745839566451;
        Mon, 28 Apr 2025 04:26:06 -0700 (PDT)
Received: from localhost (31-151-138-250.dynamic.upc.nl. [31.151.138.250])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ace6ed6b009sm609885766b.138.2025.04.28.04.26.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Apr 2025 04:26:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 28 Apr 2025 13:26:05 +0200
Message-Id: <D9I8H4AII5EG.3QKI8U79KC8SO@fairphone.com>
From: "Luca Weiss" <luca.weiss@fairphone.com>
To: "Ziqi Chen" <quic_ziqichen@quicinc.com>, <quic_cang@quicinc.com>,
 <bvanassche@acm.org>, <mani@kernel.org>, <beanhuo@micron.com>,
 <avri.altman@wdc.com>, <junwoo80.lee@samsung.com>,
 <martin.petersen@oracle.com>, <quic_nguyenb@quicinc.com>,
 <quic_nitirawa@quicinc.com>, <peter.wang@mediatek.com>,
 <quic_rampraka@quicinc.com>
Cc: <linux-arm-msm@vger.kernel.org>, <linux-scsi@vger.kernel.org>, "Neil
 Armstrong" <neil.armstrong@linaro.org>, "Matthias Brugger"
 <matthias.bgg@gmail.com>, "AngeloGioacchino Del Regno"
 <angelogioacchino.delregno@collabora.com>, "open list:ARM/Mediatek SoC
 support:Keyword:mediatek" <linux-kernel@vger.kernel.org>, "moderated
 list:ARM/Mediatek SoC support:Keyword:mediatek"
 <linux-arm-kernel@lists.infradead.org>, "moderated list:ARM/Mediatek SoC
 support:Keyword:mediatek" <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH v5 0/8] Support Multi-frequency scale for UFS
X-Mailer: aerc 0.20.1-0-g2ecb8770224a
References: <20250213080008.2984807-1-quic_ziqichen@quicinc.com>
 <D9FZ9U3AEXW4.1I12FX3YQ3JPW@fairphone.com>
 <df287609-a095-4234-b23b-d335b474a130@quicinc.com>
 <29c3852c-3218-4b42-bc41-75721a95fccc@quicinc.com>
In-Reply-To: <29c3852c-3218-4b42-bc41-75721a95fccc@quicinc.com>

Hi Ziqi,

On Mon Apr 28, 2025 at 10:06 AM CEST, Ziqi Chen wrote:
> Hi Luca,
>
> We made changes to fix this special platform issue and verified it can
> fix this issue.
> Could you help double check if attached 3 patched can fix it from you sid=
e?
> If it is OK from you side as well, we will submit the final patches to
> upstream

With these 3 patches applied the errors are gone and I don't see any
UFS-related warnings/errors in dmesg anymore.

Let me know if I should check on anything else. Thanks for the quick
fix!

Regards
Luca

>
> Thanks a lot~
>
> BRs
> Ziqi
>
> On 4/27/2025 4:14 PM, Ziqi Chen wrote:
>> Hi Luca,
>>=20
>> Thanks for your report.
>> Really,=C2=A0 6350 is a special platform that the UFS_PHY_AXI_CLK doesn'=
t
>> match to the UFS_PHY_UNIPRO_CORE_CLK. We already found out the root
>> cause and discussing the fix. We will submit change to fix this corner
>> case.
>>=20
>> BRs
>> Ziqi
>>=20
>> On 4/26/2025 3:48 AM, Luca Weiss wrote:
>>> Hi Ziqi,
>>>
>>> On Thu Feb 13, 2025 at 9:00 AM CET, Ziqi Chen wrote:
>>>> With OPP V2 enabled, devfreq can scale clocks amongst multiple frequen=
cy
>>>> plans. However, the gear speed is only toggled between min and max=20
>>>> during
>>>> clock scaling. Enable multi-level gear scaling by mapping clock=20
>>>> frequencies
>>>> to gear speeds, so that when devfreq scales clock frequencies we can p=
ut
>>>> the UFS link at the appropraite gear speeds accordingly.
>>>
>>> I believe this series is causing issues on SM6350:
>>>
>>> [=C2=A0=C2=A0=C2=A0 0.859449] ufshcd-qcom 1d84000.ufshc: ufs_qcom_freq_=
to_gear_speed:=20
>>> Unsupported clock freq : 200000000
>>> [=C2=A0=C2=A0=C2=A0 0.886668] ufshcd-qcom 1d84000.ufshc: UNIPRO clk fre=
q 200 MHz not=20
>>> supported
>>> [=C2=A0=C2=A0=C2=A0 0.903791] devfreq 1d84000.ufshc: dvfs failed with (=
-22) error
>>>
>>> That's with this patch, I actually haven't tried without on v6.15-rc3
>>> https://lore.kernel.org/all/20250314-sm6350-ufs-things-=20
>>> v1-2-3600362cc52c@fairphone.com/
>>>
>>> I believe the issue appears because core clk and unipro clk rates don't
>>> match on this platform, so this 200 MHz for GCC_UFS_PHY_AXI_CLK is not =
a
>>> valid unipro clock rate, but for GCC_UFS_PHY_UNIPRO_CORE_CLK it's
>>> specified to 150 MHz in the opp table.
>>>
>>> Regards
>>> Luca
>>>
>>>>
>>>> This series has been tested on below platforms -
>>>> sm8550 mtp + UFS3.1
>>>> SM8650 MTP + UFS3.1
>>>> SM8750 MTP + UFS4.0
>>=20

