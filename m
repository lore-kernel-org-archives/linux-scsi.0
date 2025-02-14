Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 736BF2046AA
	for <linux-scsi@vger.kernel.org>; Fri, 14 Feb 2025 06:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739515823; cv=none; b=C18Tsw/Gf6JMqws6MEbqG96GKNl5TAGIk41ZySBBLXFg2tqmJOAifW9/cTuIuK0LUsTEp6aVaSXZK24Bl2DqGYk+B1etwmArdZna3CCZrUU+yjWg64n4TL4VkKj8e7db+Qut5kcdHkM2VUeTMyDMP51B6gMDzaMqgBMQH3BYL9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739515823; c=relaxed/simple;
	bh=82IhPvdg6sgV4AQAagdaD2oscL5iIeWGWtD6mhOA0m0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ljwjUvNqo1+9GqP3Wy5dm5vsZTsozKDvWtxoJFfOsfkMNUVKIonF8K0Bo1sl0S7xDlVO8OQgLA1MYjzKTBgKtqwkqtbgxiFl422/b3CaXfM7nAAt6GKBSyQXvwDNFHKhWbWnsq1UbarjBRcEtgX93ztOqi2eJ5juQ8kbixoL2Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kWG7NGIc; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kWG7NGIc"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2fc291f7ddbso1057287a91.1
        for <linux-scsi@vger.kernel.org>; Thu, 13 Feb 2025 22:50:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1739515820; x=1740120620; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=u/bwpmhibqCSWXsfxMuekBQiCAQCaSoqpsC6Q1WLM/g=;
        b=kWG7NGIcPob5Ad6qh0RT+apdx+8oxTs+DrubaZT5gSIMdMnnhB+Gsq54f6k94DCqFl
         boehNSDMt0A3U+uHjXPQyzjfp9ezcexPRa1EcsEzldIqxRZzJWRCxS8Tr3h6ZCkvAh8H
         F9477cEpDDJC7lPzveHCCjv7BJZCOTKDnKOOnLpztxy1xbnIU3rNF/Gz1fuwDaJjM7/3
         NoZDr1sISYtgw+NexjScPyTgm7CO7V4pScr3hnQkbSUsgb7CpOWjlDY/BsUHtixYnK2c
         wPZ+iluTs0Xxy1wJQdcoQbcjik+Eb02xLMQkcAwKK56/I+xm3gF9faaVzSa21cfPhSbh
         Gq9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739515820; x=1740120620;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u/bwpmhibqCSWXsfxMuekBQiCAQCaSoqpsC6Q1WLM/g=;
        b=VBJ3X2Aw6eJoJjglVmoeFKfMFCjpHrlDMRpkJZW04KVBScVckxkLsoqXcI+c/sOYi9
         dylBs7rnXE2oCbcdE+u0TsNaZ0HE9t97x6afi/ewZu1FNt9ssaxH0RwP5/I8uD6AbJdS
         ayeEcS+wNxB5wi2xaX84XFJ3Nvvhymi52YNVE56Rc90o0EU6FrhTWK9WlrojU5dDBk6s
         9+K5W6SXaOmVQNQcvGxiDHnsSp3scBlmB/XXrH0vtuqx34tAiptpOTWRRp6S2XF3Todv
         gNzAvq+mYBr1oPgAeiQgbwm8NXh9Y+ovS68XRxl9yoX5njXA0BllS6B1i/pfu1/TOZvG
         jScg==
X-Forwarded-Encrypted: i=1; AJvYcCWacdk3czs1mi+qAvW0BojUluPxwdh7H0W6Le9/ldbIQpFuXye3YtmykFBtxkqgtJpZSnSauCuOHkgT@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9Lz9sUCzAalVmTWW7qABLKfG035E87qcZ3NnxufghMZFaEocE
	l46xDitr2eEfODqYYGqAqKn+pOHTBYFP4b5DmwPCLCrV5NXBptzp3EIlSIe0Sg==
X-Gm-Gg: ASbGncvHg+8b0BaYj0gtI2KKNpsslfcAHFd+YKpdk4JApA9Z7UbAaEYiW9ast87GiUh
	1nYKSYe/5ayV9q4wYrR9lIjHRh7bVdrN6j+8e/ADzJwNA1oy5UpAfFgXJN+NVPL8KwGaFISNWAV
	oHjuxruHQRRsXXYXgbFIA+wOdMl/kjaziT3GiEV992VjM6aVbH+6uzKs28EEIEVpNHPddBhwSYp
	ELGtLlekdtU7cWfgIQXg/693QJ/wPEMn35oux3W0lJaxGcKJ8cqPUV+kjMYQaxiMNRrWEPHwLPg
	Dx1W6xfpr1p18Ixlk60Tdp/sZMNW/6w=
X-Google-Smtp-Source: AGHT+IFX6zS1A/v/lAX87GhqlIvEXShQyFVA3goXMvKLoqOPdD6mgLwijiX503q7RrCZ5DU1xqruYQ==
X-Received: by 2002:a17:90b:4d08:b0:2fa:ba3:5455 with SMTP id 98e67ed59e1d1-2fc0ddd3602mr8941895a91.7.1739515820426;
        Thu, 13 Feb 2025 22:50:20 -0800 (PST)
Received: from thinkpad ([2409:40f4:304f:ad8a:8cb7:72db:3a5e:1287])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2fc13ac2984sm2376439a91.20.2025.02.13.22.50.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2025 22:50:19 -0800 (PST)
Date: Fri, 14 Feb 2025 12:20:09 +0530
From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Nitin Rawat <quic_nitirawa@quicinc.com>,
	Melody Olvera <quic_molvera@quicinc.com>,
	Vinod Koul <vkoul@kernel.org>,
	Kishon Vijay Abraham I <kishon@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Andy Gross <agross@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Satya Durga Srinivasu Prabhala <quic_satyap@quicinc.com>,
	Trilok Soni <quic_tsoni@quicinc.com>, linux-arm-msm@vger.kernel.org,
	linux-phy@lists.infradead.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
	Manish Pandey <quic_mapa@quicinc.com>
Subject: Re: [PATCH 4/5] arm64: dts: qcom: sm8750: Add UFS nodes for SM8750
 SoC
Message-ID: <20250214065009.w4rmrbbejnywh6nt@thinkpad>
References: <20250113-sm8750_ufs_master-v1-0-b3774120eb8c@quicinc.com>
 <20250113-sm8750_ufs_master-v1-4-b3774120eb8c@quicinc.com>
 <vifyx2lcaq3lhani5ovmxxqsknhkx24ggbu7sxnulrxv4gxzsk@bvmk3znm2ivl>
 <be8a4f65-3b36-4740-a4f7-312126cfd547@quicinc.com>
 <ferdaevlfrpf2ewzcct7mqyxltvmt6aaar4fujxfehrmizm3qw@aaroprnpwlxq>
 <354f8710-a5ec-47b5-bcfa-bff75ac3ca71@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <354f8710-a5ec-47b5-bcfa-bff75ac3ca71@oss.qualcomm.com>

On Mon, Feb 10, 2025 at 08:20:27PM +0100, Konrad Dybcio wrote:
> On 8.02.2025 11:06 PM, Dmitry Baryshkov wrote:
> > On Sun, Feb 09, 2025 at 12:47:56AM +0530, Nitin Rawat wrote:
> >>
> >>
> >> On 1/14/2025 4:22 PM, Dmitry Baryshkov wrote:
> >>> On Mon, Jan 13, 2025 at 01:46:27PM -0800, Melody Olvera wrote:
> >>>> From: Nitin Rawat <quic_nitirawa@quicinc.com>
> >>>>
> >>>> Add UFS host controller and PHY nodes for SM8750 SoC.
> >>>>
> >>>> Co-developed-by: Manish Pandey <quic_mapa@quicinc.com>
> >>>> Signed-off-by: Manish Pandey <quic_mapa@quicinc.com>
> >>>> Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
> >>>> Signed-off-by: Melody Olvera <quic_molvera@quicinc.com>
> >>>> ---
> 
> [...]
> 
> >>> Use OPP table instead
> >>
> >> Currently, OPP is not enabled in the device tree for any previous targets. I
> > 
> > Excuse me? ufs_opp_table is present on SM8250, SM8550 and SDM845 (and
> > QCS615). So this is not correct
> > 
> >> plan to enable OPP in a separate patch at a later stage. This is because
> >> there is an ongoing patch in the upstream that aims to enable multiple-level
> >> clock scaling using OPP, which may introduce changes to the device tree
> >> entries. To avoid extra efforts, I intend to enable OPP once that patch is
> >> merged.
> > 
> > Whatever changes are introduced, old DT must still continue to work.
> > There is no reason to use legacy freq-table-hz if you can use OPP table.
> > 
> >> Please let me know if you have any concerns.
> 
> Go ahead with the OPP table. freq-table-hz is ancient and doesn't describe
> e.g. the required RPMh levels for core clock frequencies.
> 
> You should then drop required-opps from the UFS node.
> 
> >>>> +
> >>>> +			resets = <&gcc GCC_UFS_PHY_BCR>;
> >>>> +			reset-names = "rst";
> >>>> +
> >>>> +
> >>>> +			interconnects = <&aggre1_noc MASTER_UFS_MEM QCOM_ICC_TAG_ALWAYS
> >>>> +					 &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
> >>>> +					<&gem_noc MASTER_APPSS_PROC QCOM_ICC_TAG_ALWAYS
> >>>> +					 &config_noc SLAVE_UFS_MEM_CFG QCOM_ICC_TAG_ALWAYS>;
> >>>
> >>> Shouldn't cpu-ufs be ACTIVE_ONLY?
> >>
> >> As per ufs driver implementation, Icc voting from ufs driver is removed as
> >> part of low power mode (suspend or clock gating) and voted again in
> >> resume/ungating path. Hence TAG_ALWAYS will have no power concern.
> >> All previous targets have the same configuration.
> > 
> > arch/arm64/boot/dts/qcom/qcs615.dtsi:                                    &config_noc SLAVE_UFS_MEM_CFG QCOM_ICC_TAG_ACTIVE_ONLY>;
> > 
> > It might be a mistake for that target though. Your explanation sounds
> > fine to me.
> 
> Let's use QCOM_ICC_TAG_ACTIVE_ONLY for the CPU path to clear up confusion.
> 
> Toggling it from the driver makes sense for UFS-idling-while-CPUs-are-online
> cases and accidentally also does what RPMh does internally in the other case.
> 

Shouldn't it be applied to config path of all peripherals then? If
QCOM_ICC_TAG_ACTIVE_ONLY translates to 'resource getting voted only if the CPUSS
is active', then the same constraint should apply to all peripherals, isn't it?

I'm not sure who is accessing the config path other than the CPUs.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
