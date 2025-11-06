Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 255853093C4
	for <linux-scsi@vger.kernel.org>; Thu,  6 Nov 2025 08:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762419056; cv=none; b=nSRw6nlagFupsH95vAqXn2GpJyjfpTN5mVjk/Da7qxnZ1hrs71a57Way035701PUa7nVqIvtC1+fyV1cVp5U6rgUhdAYvbxVZ11pgdsHo7IXIpSfjsTbwbUu6dBk6Jsl6VBu6hXmsw3P5xICQdWO/Tvyh908NBcbYMQPpBCUn3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762419056; c=relaxed/simple;
	bh=y/dw8Yeek5uiSFfzrYLyDpk4KHGZ2Q+0lMj56HOwE3s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XhY9gr7gtncdtK3jK0YrHmvWpRepNMf3HSQK/8SLuvYXLTdBjvNL2uGgyoLUl5FRYJcTaWtH4HPH1PRM7ojdQS4/fM5oC8NHaIty4frP/PyvgBVSQiwihjLM38D4RFlOSxuLGpC2bXxuaobx1oDoc4nwmj4N8X7UUXGgY2tfqZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zpMBkhr7; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zpMBkhr7"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-429c8632fcbso492040f8f.1
        for <linux-scsi@vger.kernel.org>; Thu, 06 Nov 2025 00:50:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1762419053; x=1763023853; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0O1+Bk0V1ecJIiIZPiuBQsoCpD34teqnebEkC3KejHk=;
        b=zpMBkhr7lpfrb0BndEugyEG98HARsRAOlnqU7cCJ8s+vPR0tkymgHv9TIx2jWP9ht+
         CHXG501wIUp3p/H+/5mDBgnSosnu/NlyX4MwkeNdLIXs7AewSDPD36a19QqB9lym0x8w
         PVHatOGR4ILuSUKJSkWmycF5fI+h3e1P1R1nEk5pb6ASahhfEWjBIWHw1kOj0h9NDn+r
         IdV2YPbWVovnaCMiXjwehpnKfH359rwrOHw0hkm5f1fYRzBQqtZpn5J90y4k46c9Dk4W
         RsZjauAXkSj2AJYIyviETBTvEILJYhQ/O7/bM170HrI/H4AfF2R1cmj8U4b0NrL9aKiP
         /Lxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762419053; x=1763023853;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0O1+Bk0V1ecJIiIZPiuBQsoCpD34teqnebEkC3KejHk=;
        b=J6YZIwzaPbAZKZoGXG4bsNhgGg5amNo/ckPiwxnbofd4UuyQoUsIBkOIfluWDwOG/p
         hEw4YvJnKMmKSLnhT7p210de61dz04zaD7ehX9ciQ+8kBfmq4/gZx9IJi/UF1eq0lMPe
         0YvhnWC3YfEz/y80ypj4RpJ8ST/NJeVOJnS8p4ymt0u1m1ICasR7RTvSAGuG1I+thtyE
         O8VgsDBwW7P0jLQTH6zBjUDrFV+en4EKP2YNa1xZFiY3WeVCziWanVCFv/UqNQo1LbBB
         G9gbQvlDlgZGVltdMTxZ7rb3LbbyfvLNkj7yi5J50UZ0JwIgaYrclyJN0Ev47xt+ZIDA
         Ptaw==
X-Forwarded-Encrypted: i=1; AJvYcCVcisDNEQel9KRCPlF0e7qod8+Q8AZ78HVBEO09UItfiYj8oOOFXNkT2o7hd4+a4PbAPfjsE1F54ETz@vger.kernel.org
X-Gm-Message-State: AOJu0Yz58ZPVZBIbiQeZqtBEthkj7p47vkQx8yDeUPpKRlPHe58WLbYg
	mqKz61Q//SIzP/aKZjt7rjsYhHsvOCGTl0pOa9Oh8rKFlBTOuQ7Vh682j+xLMd8eYnQ=
X-Gm-Gg: ASbGncsiT3PHp/Qnaj9dte94MWPBxMCaUY85sH0RVda3qJJXRlM3PaFktvRim1BZ/4E
	Bk952irJOYadmoYqtbayLLqg2Np0rb92nmeCL/hbA+z572bnHBJ8IQx2g93K6lIeg1DV3HvvrLG
	70lEnbW6U8UQqTSajZGU1re/2WnVpr7NCADr6EFovmxson/L8oukTJ9nfTDiMEJE35kAI3KYBLh
	ezrnSZR2QeVzSXjK/e8vm19FAhoSwHOOFnBYRMx6z1/PtZ9MJ5YTKiQ2Rs7iHzJHUIqB4DNfa1b
	jDjL7dTNcnI2LgiBJVvv2m/RLF2RqBAfpGuRAnKIzTR3FmlBLeDHhsVpFcYmwow7o4CnGbcUHKr
	+LipHvRKGLWbGmtCRS+vOZleL3UEmJGCeRtZnphecPW+JKYM4F7vZ26dyDJyUwjFmcAsjVG5y
X-Google-Smtp-Source: AGHT+IEpNkwrjClS3MRT6aT/Q6UAaN6LRZvZHXmcxt93frsHr0y/6tOsqdtfdy9Fugmh28HWQ5XyVg==
X-Received: by 2002:a05:6000:2a0c:b0:429:bb40:eecd with SMTP id ffacd0b85a97d-429e33120cfmr4859897f8f.52.1762419053386;
        Thu, 06 Nov 2025 00:50:53 -0800 (PST)
Received: from linaro.org ([86.121.7.169])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429eb49a079sm3648338f8f.32.2025.11.06.00.50.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 00:50:52 -0800 (PST)
Date: Thu, 6 Nov 2025 10:50:49 +0200
From: Abel Vesa <abel.vesa@linaro.org>
To: Ritesh Kumar <riteshk@qti.qualcomm.com>
Cc: robin.clark@oss.qualcomm.com, lumag@kernel.org, 
	abhinav.kumar@linux.dev, jessica.zhang@oss.qualcomm.com, sean@poorly.run, 
	marijn.suijten@somainline.org, maarten.lankhorst@linux.intel.com, mripard@kernel.org, 
	tzimmermann@suse.de, airlied@gmail.com, simona@ffwll.ch, robh@kernel.org, 
	krzk+dt@kernel.org, conor+dt@kernel.org, quic_mahap@quicinc.com, 
	andersson@kernel.org, konradybcio@kernel.org, mani@kernel.org, 
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com, vkoul@kernel.org, kishon@kernel.org, 
	cros-qcom-dts-watchers@chromium.org, Ritesh Kumar <quic_riteshk@quicinc.com>, 
	linux-phy@lists.infradead.org, linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	freedreno@lists.freedesktop.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-scsi@vger.kernel.org, quic_vproddut@quicinc.com
Subject: Re: [PATCH v3 2/2] arm64: dts: qcom: lemans: Add eDP ref clk for eDP
 PHYs
Message-ID: <x7ej2ne3lwn66xwgavdom45hj5imncczd5h5owufvvx4e3cblu@rdhb2adstev6>
References: <20251104114327.27842-1-riteshk@qti.qualcomm.com>
 <20251104114327.27842-3-riteshk@qti.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251104114327.27842-3-riteshk@qti.qualcomm.com>

On 25-11-04 17:13:27, Ritesh Kumar wrote:
> From: Ritesh Kumar <quic_riteshk@quicinc.com>
> 
> Add eDP reference clock for eDP PHYs on lemans chipset.

I'd add more information in here as to why this is needed,
specially since this is a fix.
