Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59317E9
	for <linux-scsi@vger.kernel.org>; Fri, 25 Apr 2025 19:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745610490; cv=none; b=fd5bv+6UAuVI6FKcuqSYOMjDjJqRS8u/kM+C3F+AsUKUvrBDQCzFHQe7S5FhypPYOEf9XmJjZ5dxjm+ozyZnV93/fnWqx+mQcwWhrlD38kOcvK4SChW/vD+vxbXV/so+hzaYPA/Exs6D8tZZR7u8D8YU7fbmFYgn0OJ+MkDWUbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745610490; c=relaxed/simple;
	bh=kaVIw/22O1GCmj11mvIUi7tcAyAUdCPPBa6yErxA9LE=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=KvJlSVoaKiA9IoyUvxIREU9dHhbJ3gXU4Jimn3uC2TilGtWQg062zYZfdR0UePn59Qu0242sD3VLKTAoBISar6XztAs1M4nqjTECdZpAbnkJQPEKfot5nzidaWKiGrx+MaCoiH5jGDXyaw8iPvwtHtBQViqtQ2oQ4xcK7rT9P4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=zaNIB0em; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="zaNIB0em"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-39c13fa05ebso1743145f8f.0
        for <linux-scsi@vger.kernel.org>; Fri, 25 Apr 2025 12:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1745610487; x=1746215287; darn=vger.kernel.org;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9MsSm/oC6fggdpvVcy29aPeLr5GjoL3t6EBPNylpw94=;
        b=zaNIB0emmBAYTHZYlCUPNyR/HctjwWcAWNDcqoZipMMNwfBSvSOGhr8U/oJ0u08o09
         3qX7zeGM4xJXIViu1Vq/5SCvAMq9taIimuX3DvT7O9wi/gsPjkCZhYm/M5DS8+3BVwZg
         aoZQWyXBRzZfSrthEElwS6edWu1CIZNcJrZZVVj8FAzy2OTo7NW9o9DRXkkhxaV/9NCX
         FICO7HWBxUvl65Sx2OSGhIiHEpxmX5JgiTy0VYdn4z+NJ+fr9TtIB9dYK7w8dPAB5AHa
         e2yx74oWq/XXSgVzp9ISibSHBp+8ix7ch2Rui684zGgf7J5BErSsMG5F7c/QvVn3exXH
         0beg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745610487; x=1746215287;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9MsSm/oC6fggdpvVcy29aPeLr5GjoL3t6EBPNylpw94=;
        b=FC3DgQJFV+Ave77vf91rxlbZPyD24DoDPF/hD+0Bcvwmbs217H72MrbGcq+MRc+vIn
         xjItEcLkdgMrdpX3YomJuM5ZFn7qNclmbVX5jK08RIwa/0689cYacX5rZo5JjQUSqMHP
         Ip3QORhjudP9BYldPAx3khuxW2FDtb9LeE2jc5qtBPdEFOB6PRD/5yHruJOXpVQczHu9
         Boh+LMW6ynPeFQ1jdx+nNzBZs4UrO3onL5CrzrB+E1pb9aaR77knccAfLq1NXkJggjgG
         WKR5h1l3uPexHhqnPHIEN8/bmWjqQAwxWSp1WB4QZ28zpCnpiDFp7vjuRoNc89NM3AjD
         9N2A==
X-Forwarded-Encrypted: i=1; AJvYcCUMfJdJinOSnykDuf/+SoXpvY+0x/PW6ENhhiTXzZ3M188WjTgFG50KukmMFa2o7vIyGS8xogXcPqrN@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0NHuHn9CHn8uzPIUf9Zf6sbHfRDawSy3Z4Y4gluzKM4SKwlMD
	FYLi7Nc/S4wCmIsawzx+XScommWaLMRo55OeM3uGDQurLv3UDmrWzlGonywYuDU=
X-Gm-Gg: ASbGncvRJchONxDaC9zAv6UWq4V1I5eJ5aJek92OPa1pBbY3dUofr8xSwIOIHW3Ny6G
	iI4yHLd08yO0hlSeZXr5bNL0fYBEvsZ/ZDbPsjTIFCG7V+IkE0eEav9fNziOUiKZHEUE4I8BobO
	RVPJeL6G2S4dBKvQ9UQtTLXcLkpDWvmlCZ2mFKT8VKGv9nsKiv4KQaPdZUkb5Yeixh74rMA7Q6f
	Sm5j37aLNkQKdlF+GHrq2myhz94KOeddElsJJLxLo7jJJj81+hGRku45+hDRpIfmyB62IUamqmr
	kHS7olmxsiwjImNDZa1M/LQHw2uTI5A3wyaf0tQoo70SZEITvJLRhvlj4yaePMisPOJEF9TTI34
	A3UuHuihJseIpPkNna5lYYKGpT3RCqXH4nskPbDuIwQPVe6193B00SFJMYafA2ss=
X-Google-Smtp-Source: AGHT+IHfsn5wCKhwTa0J8zfuwB8lcJPWgRUEQdZlhyrj1mUqnBM8NKHg90Ct03YfbCjHwLs/15BqRw==
X-Received: by 2002:adf:e5c3:0:b0:39a:c467:a095 with SMTP id ffacd0b85a97d-3a07aa7545emr335807f8f.24.1745610486979;
        Fri, 25 Apr 2025 12:48:06 -0700 (PDT)
Received: from localhost (2a02-8388-6584-6400-d322-7350-96d2-429d.cable.dynamic.v6.surfer.at. [2a02:8388:6584:6400:d322:7350:96d2:429d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4409d2d8154sm66076505e9.30.2025.04.25.12.48.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Apr 2025 12:48:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 25 Apr 2025 21:48:04 +0200
Message-Id: <D9FZ9U3AEXW4.1I12FX3YQ3JPW@fairphone.com>
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
From: "Luca Weiss" <luca.weiss@fairphone.com>
X-Mailer: aerc 0.20.1-0-g2ecb8770224a
References: <20250213080008.2984807-1-quic_ziqichen@quicinc.com>
In-Reply-To: <20250213080008.2984807-1-quic_ziqichen@quicinc.com>

Hi Ziqi,

On Thu Feb 13, 2025 at 9:00 AM CET, Ziqi Chen wrote:
> With OPP V2 enabled, devfreq can scale clocks amongst multiple frequency
> plans. However, the gear speed is only toggled between min and max during
> clock scaling. Enable multi-level gear scaling by mapping clock frequenci=
es
> to gear speeds, so that when devfreq scales clock frequencies we can put
> the UFS link at the appropraite gear speeds accordingly.

I believe this series is causing issues on SM6350:

[    0.859449] ufshcd-qcom 1d84000.ufshc: ufs_qcom_freq_to_gear_speed: Unsu=
pported clock freq : 200000000
[    0.886668] ufshcd-qcom 1d84000.ufshc: UNIPRO clk freq 200 MHz not suppo=
rted
[    0.903791] devfreq 1d84000.ufshc: dvfs failed with (-22) error

That's with this patch, I actually haven't tried without on v6.15-rc3
https://lore.kernel.org/all/20250314-sm6350-ufs-things-v1-2-3600362cc52c@fa=
irphone.com/

I believe the issue appears because core clk and unipro clk rates don't
match on this platform, so this 200 MHz for GCC_UFS_PHY_AXI_CLK is not a
valid unipro clock rate, but for GCC_UFS_PHY_UNIPRO_CORE_CLK it's
specified to 150 MHz in the opp table.

Regards
Luca

>
> This series has been tested on below platforms -
> sm8550 mtp + UFS3.1
> SM8650 MTP + UFS3.1
> SM8750 MTP + UFS4.0
