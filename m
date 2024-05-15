Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96913446AC
	for <linux-scsi@vger.kernel.org>; Wed, 15 May 2024 19:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715800679; cv=none; b=Sj0Je7vhp6/NKhdC/9xZ4NdYxe6ganGL21VIDDCUe7jgqxn/JCWeldgDcG6Fpapb0b91Qzczhle2jb1+AxVq7fsasyyovBQHDYQBaVncIJXY5eBs4j3I0ocpfSdBUcBCuCm1nVKXoVnrsl4DB6WgNtap2daKq2dMCTZQ5I8e2Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715800679; c=relaxed/simple;
	bh=CPp/HTGSY2HiQLDatrLtpTGFshesDpce0Bi4vdjYKoA=;
	h=MIME-Version:In-Reply-To:References:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pxU6jEgpOodslRYg1yPbp23unu0PT0JSUUZQuxnh5SYskLa1IS8YUFsDw4kvxX+P9Gs4wlUZR7o/vNauci7oy3t32i97Ztmvt8dbsHm3hd5Qm5gEBbCV3OFeNdHc4+YM0YJXPMCRE13pxgRvFmHX7CNX5ZlHApcVjcczlrbEaMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=Ugk4nfFu; arc=none smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Ugk4nfFu"
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-61e04fcf813so83289947b3.3
        for <linux-scsi@vger.kernel.org>; Wed, 15 May 2024 12:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1715800678; x=1716405478; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CPp/HTGSY2HiQLDatrLtpTGFshesDpce0Bi4vdjYKoA=;
        b=Ugk4nfFudEGnmxbeMe3fqOScBd2csDTdrrIrc553IfAIMJtcBbrY9xyd11GfZa7zpq
         9g8MesNTlkcq5BNdZyJdbG2ltgjJ6HeQHjF1PMlhJQW/o8QhHDmrJmwal5UtP/BQ5K9a
         d/YRZnPsUJnZAGkfgFNMAcmo85SqcBJbmRw6U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715800678; x=1716405478;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CPp/HTGSY2HiQLDatrLtpTGFshesDpce0Bi4vdjYKoA=;
        b=kuWsPkCZz6IvUE3JiChHpUzWgKD3Y18TN7FPaTnMeKDngJUUDnpXeZjdXHEhxGesTK
         pPzq/Ohii83+i4jhLjtoKLczg9yjLqnubmyIdG+uREXD+aKX4Y2lvqpLdP0RQBwJwvm9
         vmZxx6WzVyv+bVglK7oO5yUpduHRjaiQ3QnW4zzNTfp8wwfV+c/l5iFoYcFoP74KngUh
         Pu9uGbO2RYjEinnX06xtv3OJR3VGHkmfK0fou36BB/+IskePhF2tmc9lx7MceNJUS6pQ
         tQ9x36hN8281vJ2wPaJOKqAtjyIL4iAj2fDiPg3Wamsz9NZOVJiPttUDpit/Jcj7YhnI
         seHQ==
X-Forwarded-Encrypted: i=1; AJvYcCVjQ+34IzK4G5+PsptaquzUYoOYR0PJSTA0QJRbXFbWMORSjDDuQXG7M24ExSKNd4GX+YZhs75g4CO2tXi/C7kjxkUdFL1/JExWPA==
X-Gm-Message-State: AOJu0YykZ7/QEpbZ/2vFFZZlS8Kq36NZc9kpdq11dEheUjUyENsNV27+
	g7F6N84bXmE3gUBLmFvOiqJxHNxtXCPo8i1WtxqQKmyXSXqWIg5kHadsxs0/++5PofhGhYtNKU7
	GnC+IEGOTg08oi2UZ8PHtnIVv9J/nE+2NL7GP
X-Google-Smtp-Source: AGHT+IFwkFXVASVtHHXe54Bdbs+H/MUnSJ+K2O/gJn4A57/o9XwLM5LjW5jlvs0cYMn5hlnXOzinjk+dbmRrXQRVB6Q=
X-Received: by 2002:a25:900b:0:b0:dce:fd56:b213 with SMTP id
 3f1490d57ef6-dee4f324ab4mr16873966276.7.1715800677723; Wed, 15 May 2024
 12:17:57 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 15 May 2024 12:17:57 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240514-ufs-nodename-fix-v1-2-4c55483ac401@linaro.org>
References: <20240514-ufs-nodename-fix-v1-0-4c55483ac401@linaro.org> <20240514-ufs-nodename-fix-v1-2-4c55483ac401@linaro.org>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Wed, 15 May 2024 12:17:57 -0700
Message-ID: <CAE-0n50nygK8+0yVUx6MQPwG7+07J+MuGcN1vx77RPZOipffPw@mail.gmail.com>
Subject: Re: [PATCH 2/2] arm64: dts: qcom: Use 'ufshc' as the node name for
 UFS controller nodes
To: Alim Akhtar <alim.akhtar@samsung.com>, Andy Gross <agross@kernel.org>, 
	Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
	Bjorn Andersson <andersson@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Konrad Dybcio <konrad.dybcio@linaro.org>, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, 
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, Rob Herring <robh@kernel.org>, 
	cros-qcom-dts-watchers@chromium.org
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Quoting Manivannan Sadhasivam (2024-05-14 06:08:41)
> Devicetree binding has documented the node name for UFS controllers as
> 'ufshc'. So let's use it instead of 'ufs' which is for the UFS devices.
>
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---

Reviewed-by: Stephen Boyd <swboyd@chromium.org>
