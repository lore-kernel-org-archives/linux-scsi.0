Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B474B130E58
	for <linux-scsi@vger.kernel.org>; Sun,  6 Apr 2025 18:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743963832; cv=none; b=RpIF2EFz8QG6JCv4csNF+BdfPQ6kNszvDr28Y6N292Wb7/z5wl07Ci4Qjt5jubxpa8aa+K7a8XVPth33UEobEH2GY05s12HTOHBwUTKQx0z8GcUx9ImJVIZnz2kTnx49/9F7JOMQK5Xn2YRzxEm2V9MKLXmRfy2z0TuxVMNz3Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743963832; c=relaxed/simple;
	bh=IAzy0fh8K5Ij9hbamh80vAnFaq8nFygBt8h0leYVIkA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jzsFyPwaHh76ej7Kk7y8Nc3hV+wnHjjtF3U44aZ3RkPB9lexAzeV2n/7yvM9YBpMAPuWYJb3np0kUrZzFEEvCYg/TIH7kSS8KtRNuICXOhKEJ7L0mpjMpFzD9GLx9YDieH5CDQreNFgqBzGWtbQD28l8QuuKKZZSeNpVb3FRmj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cEJxc9ln; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cEJxc9ln"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-223f4c06e9fso31332865ad.1
        for <linux-scsi@vger.kernel.org>; Sun, 06 Apr 2025 11:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1743963830; x=1744568630; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+3W5JbOyIE71HVwKTUQkHyqilZi+aSbwXv3gNCNt8vU=;
        b=cEJxc9lntGpyYbhlbgqgFWq9NRq/slvr98jMZ/veQwWwnBEJA/p8UvxfGeapC/VMuq
         V+ZV9pevy47AvxA84ZiVLX5NLBS03ujz8iKysxiPcoqEk3CDvt//6wd8R2CpvY67jAam
         ZyYyfmRNvbviYDpuoBjRIaIvrUgq/jAbRPxaYxenOEMiXgxrO5VPJcCNEWsi1FofKmhd
         RHVm82lcl6vm8seK/REtKcNxW1YEp3geuWNgGF7Rzc7tjpP+rv7FocAr2fDSgjzZQuXn
         QAlGQUP51cDwIpyGhDvtrJcAF2q2sQN7y2EOOPyWOTVvUrYXweoKhDCZN6xUMYdKH7Pd
         Y2nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743963830; x=1744568630;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+3W5JbOyIE71HVwKTUQkHyqilZi+aSbwXv3gNCNt8vU=;
        b=jmWNSMoRWFV8p5rwapXsV0KIFQ5OCQ2IJS3KtwbUmSKdHb6kgoj0HbHZu9tGcpslma
         1wohTF2awdLcV/2rEPbybYFNOvvb0ZGLve5kRGIIsNzrGO5d1EC57qRSrpXpzaWXmkQ2
         fxh491k2cHlXAvywaz6i3gwb6eEQGuuCPhlrBBz7LV/jdX0GhLEzIzk4txqBIyM1mJI9
         TU2lZXpe7adQDewuQ84Qxh7nF7gBx0rnSaz8FoJTZ83glTFGjhTw+XlavBwwoSBJ3n/q
         XcolyS+VLoWNlLq3a5PS3HRbosbOZ3ah6m3+5DkTT+aUaU9HPohbt24hrPzMZ/TXt8RR
         mbBw==
X-Forwarded-Encrypted: i=1; AJvYcCU0mnqEaavZKHyo+9A2+3xFx/k/rvoCA69aMZXKW0BqJF2KW3Jer/v0Vjhw3nNpw6bkq8fZ70BRpszF@vger.kernel.org
X-Gm-Message-State: AOJu0YwJ2aQseMXIXKsntMGIp6G+lfp6ZqNseb1zr9ANbGDvM2CYYPk1
	/b4OFFrOEAeuCUmWTtCCyIvvZPicZpXq72ugrgD60uEF6z+CVpCG0guhcLaQjw==
X-Gm-Gg: ASbGnctswmeLcyfTES/dU6R8LaGy8YSnKxMlmR7SdLafHdWoXP9AxznIdUsO6IZ9sMO
	HRx8/w+7WipsnNHFKWwId1ROl/Okx2hjr8hFXzuwnUOC2XUlAW5dxhqcAv3BmWTUzePw4+wFGBZ
	Dr8eGW8kUbiwwT9Bwcya3YEMBBCebTV/u7nEYcsIUO74YjX74UkfA4gGmmqyHfm/nZWxWj5wB+h
	pjYBdttpKJtUANGurLQ/l5nEle6VKvT61Jq/JiI8jkZXpCbiKfnx+jqnIwj74FCu0aTClJTHaJj
	30bm4fxNkIhzolWt+qh3aqBz90laRZncXjxJSg6cYtS7B74yLNv8deg=
X-Google-Smtp-Source: AGHT+IFdT0XFI03UAIeiotZXeIYigu0aV7BLlfFTU0OW0vocyL0gj4gwxcJDUVb4tfjT4ZP6NIWT6w==
X-Received: by 2002:a17:903:41c7:b0:223:607c:1d99 with SMTP id d9443c01a7336-22a89992b46mr153666815ad.0.1743963829885;
        Sun, 06 Apr 2025 11:23:49 -0700 (PDT)
Received: from thinkpad ([120.60.71.192])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2297866e161sm65969765ad.171.2025.04.06.11.23.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Apr 2025 11:23:49 -0700 (PDT)
Date: Sun, 6 Apr 2025 23:53:41 +0530
From: 
	"manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>
To: "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Cc: Bart Van Assche <bvanassche@acm.org>, 
	Arthur Simchaev <Arthur.Simchaev@sandisk.com>, "quic_cang@quicinc.com" <quic_cang@quicinc.com>, 
	"quic_nitirawa@quicinc.com" <quic_nitirawa@quicinc.com>, "avri.altman@wdc.com" <avri.altman@wdc.com>, 
	"peter.wang@mediatek.com" <peter.wang@mediatek.com>, "minwoo.im@samsung.com" <minwoo.im@samsung.com>, 
	"adrian.hunter@intel.com" <adrian.hunter@intel.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, 
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, Bean Huo <beanhuo@micron.com>, 
	Keoseong Park <keosung.park@samsung.com>, Ziqi Chen <quic_ziqichen@quicinc.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, Gwendal Grignou <gwendal@chromium.org>, 
	Eric Biggers <ebiggers@google.com>, open list <linux-kernel@vger.kernel.org>, 
	"moderated list:ARM/Mediatek SoC support:Keyword:mediatek" <linux-arm-kernel@lists.infradead.org>, 
	"moderated list:ARM/Mediatek SoC support:Keyword:mediatek" <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH v4 1/1] scsi: ufs: core: add device level exception
 support
Message-ID: <ouxmroni4miwrzd24gvcvo3v5hqthodhhx3ohk4i37qryn4k2w@47s2a6nvxby6>
References: <4370b3a3b5a5675bb3e75aaa48a273674c159339.1742526978.git.quic_nguyenb@quicinc.com>
 <SA2PR16MB4251229744D717821D3D8353F4A72@SA2PR16MB4251.namprd16.prod.outlook.com>
 <c5ab13ec-f650-ea10-5cb8-d6a2ddf1e825@quicinc.com>
 <0a68d437-5d6a-42aa-ae4e-6f5d89cfcaf3@acm.org>
 <ad246ef4-7429-63bb-0279-90738736f6e3@quicinc.com>
 <3d7b543c-1165-42e0-8471-25b04c7572ac@acm.org>
 <4cb20c80-9bb0-e147-e3c0-467f4c8828ba@quicinc.com>
 <989e695e-e6a4-4427-9041-e39ecf5b5674@acm.org>
 <yzy7oad77h744vf2bdylkm4fronemjwvrmlstnj6x5lzjxg672@zya6toqv4aeg>
 <1b87152e-ff0f-9c45-020d-4927ff3dbef8@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1b87152e-ff0f-9c45-020d-4927ff3dbef8@quicinc.com>

On Wed, Apr 02, 2025 at 12:00:26PM -0700, Bao D. Nguyen wrote:
> On 4/2/2025 12:49 AM, manivannan.sadhasivam@linaro.org wrote:
> > Yeah, we should be cautious in changing the uAPI header as it can break the
> > userspace applications. Annotating the members that need packed attribute seems
> > like the way forward to me.
> 
> Yes, I realized potential issue when Bart raised a concern.
> 
> > 
> > Though, I'd like to understand which architecture has the alignment constraint
> > in this structure. Only if an architecture requires 8 byte alignment for __be32
> > would be a problem. That too only for osf7 and reserved. But I'm not aware of
> > such architectures in use.
> When using "__u64 value;" in place of osf3-6, I saw the compiler padded 4
> bytes, so __packed was needed for me to get correct __u64 value. I thought
> even the existing structure utp_upiu_query_v4_0 may need __packed on some
> fields where the driver reads the returned data in order to be safe across
> all architectures. However, without evidence of an actual failure, I didn't
> touch the existing structure. Only raised potential issue for discussion.
> 

If you change members to be 64bit, then for sure compiler will add padding to
avoid holes. But I don't see any issue with the unchanged utp_upiu_query_v4_0
structure.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
