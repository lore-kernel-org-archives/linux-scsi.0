Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BECEE522A
	for <linux-scsi@vger.kernel.org>; Wed,  5 Feb 2025 14:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765708; cv=none; b=Vywl6pe6VnMNhDg9DFK27FWn2tjD1IQQEb76cQOlyj1L5OH7jS7xFXjBfbLHz27WsRAozRb4phUU7XVoGi9UhtU6Y1iBQ6rJvOYTk+DU0wTSkVBXmLHx3V1Qs+vs/1yT2f6rRestfFjERfr/cmfAu5ZDnX0DNzQKRd41G1F4BPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765708; c=relaxed/simple;
	bh=Pj2ARB5IEhM6ZKcnaj1grIDX3nSvfPjwFQ8DWbEC28g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OVCgV8IjvbNVqh7kCsZBb61Xfe6Xz0Or4x+AQ4+p1ZUMIgZGNDizcQmkGANzuBNgudaPjBJu1Q6YGhgrdq71rBnGYRzVbKhB34rSsIMl8+UFQI+JytOkQrGs9xEnPJ5h2lJxMVg/HsTOM+UwayxFFbN7n/AsbceY+cgl5QILRjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=S4At3ZnI; arc=none smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="S4At3ZnI"
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-6f006748fd1so53246687b3.3
        for <linux-scsi@vger.kernel.org>; Wed, 05 Feb 2025 06:28:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1738765704; x=1739370504; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RxjPZioicVlmOp6G07at5GPXCO7hO5KTGz1etg8yNsM=;
        b=S4At3ZnIZR+dEc3s5ijOO0BfldraAPhRmJFBt2LTPJpxFaUHQEGL00pAdR/iqT3Ak8
         Df6kEK2/1ZLCGeFhOJdpBWUc4XnQQSvhpWZtO7hzbDCeyW8YcW9TlNumtPVvE1v9Z5a4
         oj3jYPcacnDS4UKHAv6pWAtd6bLCE9aiVVka5rypy2IHz9ks4CPUOXjvWDGGetqRIyCB
         jDe2Ic+L8/M53i4a5YbbJx9ARBSprjU4s8Bt3ogm0Y1kjK/rRkoEKdPcwabBcTykao9Z
         1Jt39FPTAO1gxC8cIOJNujbvTp6H0HECpj+eZYihPwKetXXig7uBk+gwRj9KNUsIgWgx
         5Euw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738765705; x=1739370505;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RxjPZioicVlmOp6G07at5GPXCO7hO5KTGz1etg8yNsM=;
        b=jcpenu6NEn9KhnpALMcGVRioFURVtaP1lyCX32V7uirSdRqbPEDYnFPpzDhuyirjRU
         zggen9/6i9EByF0f/DLymWgv75nFbPJxUqDDDuSwhnQbb91zVdofMcCX62CvzgIQiWV5
         6GxiqMh4MoJ+C6itvBzXRYcEcX2ik1bh0q9fhvBBH3mv7rfY7uPaj6bDGuRCiwwZMWxT
         96eY2q5L7Hi6jvRRZ7TDMCbYjp7xYpJyuDBmP9pWKdFFVpBqR6IiVkc6Pjn0/WlZlXcZ
         oI0jDH2Jovw+I2x9WrFmQr16FDg6Upsp6OGKhx4G+ldceivy2Km/ThUBBZIZRUmMX8+O
         B6Uw==
X-Forwarded-Encrypted: i=1; AJvYcCVVHUHNBBlRxq+NmbCY8YDlU5+nvzdQViENXcgRHcwpoerWoJfcLPtg+mlOmyaxWl5P8LM0LlH20X1i@vger.kernel.org
X-Gm-Message-State: AOJu0YzFs26gfDWcgDeD2MK//MkI4zuo9La4bROLEfo57PDA2q6tEYD1
	5QWbu+V7LECZITfnPWMsFq6PIs+IEeMgpfeEFLRCfjhd9+ezYQU0XxmfUBO/NG/y00T7Btf3bXw
	jWR5jnUXCwdKIOLaUTncZAyY2tP4oBdEBlAsjOA==
X-Gm-Gg: ASbGncts9UQXaf1gNqprSVxU90pAGVNGBU4MyfC8GPJZXy/kBLKst0DsaH2kw3gj9TF
	E9yWRHtJNKNhdoRbOnp/VWiEnKkuJiWsrqu/JWPYhsWg8uSn0Uhf00v0frmawgJWvYSfa4ec=
X-Google-Smtp-Source: AGHT+IGvT6fRYRimcPuK0ghQ6l2fJhpuTegAxts5NZNBuejmaYfUhD9DQAS2Jt8OFDlInZpH8BiB7Vh4LYu4UkMfUBU=
X-Received: by 2002:a05:690c:6104:b0:6f6:b646:4f34 with SMTP id
 00721157ae682-6f989f62f57mr25937957b3.30.1738765704529; Wed, 05 Feb 2025
 06:28:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250113-sm8750_ufs_master-v1-0-b3774120eb8c@quicinc.com>
 <20250113-sm8750_ufs_master-v1-2-b3774120eb8c@quicinc.com>
 <vry7yib4jtvyc5baruetqb2msy4j4ityv2s6z5smrz6rqjfb5l@xoharscfhz5n>
 <a4162070-f5cd-464a-b814-42c923e63784@quicinc.com> <CAA8EJpq45o6M24ZXWYrx4WCakW3EiD6hunjhQ1NK+Lduwu7CXg@mail.gmail.com>
 <28687463-b2ba-4f6b-8d7e-7ffd006dec0c@quicinc.com>
In-Reply-To: <28687463-b2ba-4f6b-8d7e-7ffd006dec0c@quicinc.com>
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Date: Wed, 5 Feb 2025 16:28:13 +0200
X-Gm-Features: AWEUYZmSCuup3kmhgdPqrRz6rFJy3-Xi4fY5gUF7dMnMWz6ztP1YLRGejqe2GqI
Message-ID: <CAA8EJppC3aQ7BGj0ccuVNfNCbrimHs1v6=-aueL4b-Y3RAYb3g@mail.gmail.com>
Subject: Re: [PATCH 2/5] phy: qcom-qmp-ufs: Add PHY Configuration support for SM8750
To: Nitin Rawat <quic_nitirawa@quicinc.com>
Cc: Melody Olvera <quic_molvera@quicinc.com>, Vinod Koul <vkoul@kernel.org>, 
	Kishon Vijay Abraham I <kishon@kernel.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
	Bjorn Andersson <andersson@kernel.org>, Andy Gross <agross@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, 
	Satya Durga Srinivasu Prabhala <quic_satyap@quicinc.com>, Trilok Soni <quic_tsoni@quicinc.com>, 
	linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-scsi@vger.kernel.org, Manish Pandey <quic_mapa@quicinc.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 5 Feb 2025 at 15:57, Nitin Rawat <quic_nitirawa@quicinc.com> wrote:
>
>
>
> On 2/5/2025 5:14 PM, Dmitry Baryshkov wrote:
> > On Wed, 5 Feb 2025 at 13:34, Nitin Rawat <quic_nitirawa@quicinc.com> wrote:
> >>
> >>
> >>
> >> On 1/14/2025 4:19 PM, Dmitry Baryshkov wrote:
> >>> On Mon, Jan 13, 2025 at 01:46:25PM -0800, Melody Olvera wrote:
> >>>> From: Nitin Rawat <quic_nitirawa@quicinc.com>
> >>>>
> >>>> Add SM8750 specific register layout and table configs. The serdes
> >>>> TX RX register offset has changed for SM8750 and hence keep UFS
> >>>> specific serdes offsets in a dedicated header file.
> >>>>
> >>>> Co-developed-by: Manish Pandey <quic_mapa@quicinc.com>
> >>>> Signed-off-by: Manish Pandey <quic_mapa@quicinc.com>
> >>>> Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
> >>>> Signed-off-by: Melody Olvera <quic_molvera@quicinc.com>
> >>>> ---
> >>>>    drivers/phy/qualcomm/phy-qcom-qmp-qserdes-com-v6.h |  12 ++
> >>>>    .../qualcomm/phy-qcom-qmp-qserdes-txrx-ufs-v7.h    |  68 ++++++++
> >>>>    drivers/phy/qualcomm/phy-qcom-qmp-ufs.c            | 174 ++++++++++++++++++++-
> >>>>    3 files changed, 253 insertions(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-qserdes-com-v6.h b/drivers/phy/qualcomm/phy-qcom-qmp-qserdes-com-v6.h
> >>>> index 328c6c0b0b09ae4ff5bf14e846772e6d0f31ce5a..aa2278f9377408b3c602f6fa0de5021804f21f52 100644
> >>>> --- a/drivers/phy/qualcomm/phy-qcom-qmp-qserdes-com-v6.h
> >>>> +++ b/drivers/phy/qualcomm/phy-qcom-qmp-qserdes-com-v6.h
> >>>> @@ -86,4 +86,16 @@
> >>>>    #define QSERDES_V6_COM_CMN_STATUS                          0x1d0
> >>>>    #define QSERDES_V6_COM_C_READY_STATUS                              0x1f8
> >>>>
> >>>> +#define QSERDES_V6_COM_ADAPTIVE_ANALOG_CONFIG                       0x268
> >>>> +#define QSERDES_V6_COM_CP_CTRL_ADAPTIVE_MODE0                       0x26c
> >>>> +#define QSERDES_V6_COM_PLL_RCCTRL_ADAPTIVE_MODE0            0x270
> >>>> +#define QSERDES_V6_COM_PLL_CCTRL_ADAPTIVE_MODE0                     0x274
> >>>> +#define QSERDES_V6_COM_BIN_VCOCAL_CMP_CODE1_MODE0           0x58
> >>>> +
> >>>> +#define QSERDES_V6_COM_BIN_VCOCAL_CMP_CODE2_MODE0           0x5c
> >>>> +#define QSERDES_V6_COM_CP_CTRL_ADAPTIVE_MODE1                       0x278
> >>>> +#define QSERDES_V6_COM_PLL_RCCTRL_ADAPTIVE_MODE1            0x27c
> >>>> +#define QSERDES_V6_COM_PLL_CCTRL_ADAPTIVE_MODE1                     0x280
> >>>> +#define QSERDES_V6_COM_BIN_VCOCAL_CMP_CODE1_MODE1           0x50
> >>>> +#define QSERDES_V6_COM_BIN_VCOCAL_CMP_CODE2_MODE1           0x54
> >>>>    #endif
> >>>> diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-qserdes-txrx-ufs-v7.h b/drivers/phy/qualcomm/phy-qcom-qmp-qserdes-txrx-ufs-v7.h
> >>>> new file mode 100644
> >>>> index 0000000000000000000000000000000000000000..73b3857e0277ce6cdbe658066772172a94f25d6e
> >>>> --- /dev/null
> >>>> +++ b/drivers/phy/qualcomm/phy-qcom-qmp-qserdes-txrx-ufs-v7.h
> >>>> @@ -0,0 +1,68 @@
> >>>> +/* SPDX-License-Identifier: GPL-2.0 */
> >>>> +/*
> >>>> + * Copyright (c) 2024, Linaro Limited
> >>>> + */
> >>>> +
> >>>> +#ifndef QCOM_PHY_QMP_QSERDES_TXRX_UFS_V7_H_
> >>>> +#define QCOM_PHY_QMP_QSERDES_TXRX_UFS_V7_H_
> >>>> +
> >>>> +#define QSERDES_UFS_V7_TX_RES_CODE_LANE_TX                          0x28
> >>>> +#define QSERDES_UFS_V7_TX_RES_CODE_LANE_RX                          0x2c
> >>>> +#define QSERDES_UFS_V7_TX_RES_CODE_LANE_OFFSET_TX                   0x30
> >>>> +#define QSERDES_UFS_V7_TX_RES_CODE_LANE_OFFSET_RX                   0x34
> >>>> +#define QSERDES_UFS_V7_TX_LANE_MODE_1                                       0x7c
> >>>> +#define QSERDES_UFS_V7_TX_FR_DCC_CTRL                                       0x108
> >>>> +
> >>>> +#define QSERDES_UFS_V7_RX_UCDR_SO_SATURATION                                0x28
> >>>> +#define QSERDES_UFS_V7_RX_UCDR_PI_CTRL1                                     0x58
> >>>> +#define QSERDES_UFS_V7_RX_TERM_BW_CTRL0                                     0xC4
> >>>> +#define QSERDES_UFS_V7_RX_MODE_RATE_0_1_B0                          0x218
> >>>> +#define QSERDES_UFS_V7_RX_MODE_RATE_0_1_B1                          0x21C
> >>>> +#define QSERDES_UFS_V7_RX_MODE_RATE_0_1_B2                          0x220
> >>>> +#define QSERDES_UFS_V7_RX_MODE_RATE_0_1_B3                          0x224
> >>>> +#define QSERDES_UFS_V7_RX_MODE_RATE_0_1_B4                          0x228
> >>>> +#define QSERDES_UFS_V7_RX_MODE_RATE_0_1_B6                          0x230
> >>>> +#define QSERDES_UFS_V7_RX_MODE_RATE_0_1_B7                          0x234
> >>>> +#define QSERDES_UFS_V7_RX_MODE_RATE2_B3                                     0x248
> >>>> +#define QSERDES_UFS_V7_RX_MODE_RATE2_B6                                     0x254
> >>>> +#define QSERDES_UFS_V7_RX_MODE_RATE2_B7                                     0x258
> >>>> +#define QSERDES_UFS_V7_RX_MODE_RATE3_B0                                     0x260
> >>>> +#define QSERDES_UFS_V7_RX_MODE_RATE3_B1                                     0x264
> >>>> +#define QSERDES_UFS_V7_RX_MODE_RATE3_B2                                     0x268
> >>>> +#define QSERDES_UFS_V7_RX_MODE_RATE3_B3                                     0x26C
> >>>> +#define QSERDES_UFS_V7_RX_MODE_RATE3_B4                                     0x270
> >>>> +#define QSERDES_UFS_V7_RX_MODE_RATE3_B5                                     0x274
> >>>> +#define QSERDES_UFS_V7_RX_MODE_RATE3_B7                                     0x27C
> >>>> +#define QSERDES_UFS_V7_RX_MODE_RATE3_B8                                     0x280
> >>>> +#define QSERDES_UFS_V7_RX_MODE_RATE4_SA_B0                          0x284
> >>>> +#define QSERDES_UFS_V7_RX_MODE_RATE4_SA_B1                          0x288
> >>>> +#define QSERDES_UFS_V7_RX_MODE_RATE4_SA_B2                          0x28C
> >>>> +#define QSERDES_UFS_V7_RX_MODE_RATE4_SA_B3                          0x290
> >>>> +#define QSERDES_UFS_V7_RX_MODE_RATE4_SA_B4                          0x294
> >>>> +#define QSERDES_UFS_V7_RX_MODE_RATE4_SA_B5                          0x298
> >>>> +#define QSERDES_UFS_V7_RX_MODE_RATE4_SA_B6                          0x29C
> >>>> +#define QSERDES_UFS_V7_RX_MODE_RATE4_SA_B7                          0x2A0
> >>>> +#define QSERDES_UFS_V7_RX_MODE_RATE4_SB_B0                          0x2A8
> >>>> +#define QSERDES_UFS_V7_RX_MODE_RATE4_SB_B1                          0x2AC
> >>>> +#define QSERDES_UFS_V7_RX_MODE_RATE4_SB_B2                          0x2B0
> >>>> +#define QSERDES_UFS_V7_RX_MODE_RATE4_SB_B3                          0x2B4
> >>>> +#define QSERDES_UFS_V7_RX_MODE_RATE4_SB_B4                          0x2B8
> >>>> +#define QSERDES_UFS_V7_RX_MODE_RATE4_SB_B5                          0x2BC
> >>>> +#define QSERDES_UFS_V7_RX_MODE_RATE4_SB_B6                          0x2C0
> >>>> +#define QSERDES_UFS_V7_RX_MODE_RATE4_SB_B7                          0x2C4
> >>>> +#define QSERDES_UFS_V7_RX_DLL0_FTUNE_CTRL                           0x348
> >>>> +#define QSERDES_UFS_V7_RX_SIGDET_CAL_TRIM                           0x380
> >>>> +#define QSERDES_UFS_V7_RX_INTERFACE_MODE                            0x1F0
> >>>> +#define QSERDES_UFS_V7_RX_UCDR_FO_GAIN_RATE2                                0xD4
> >>>> +#define QSERDES_UFS_V7_RX_UCDR_FO_GAIN_RATE4                                0xDC
> >>>> +#define QSERDES_UFS_V7_RX_UCDR_SO_GAIN_RATE4                                0xF0
> >>>> +#define QSERDES_UFS_V7_RX_UCDR_PI_CONTROLS                          0xF4
> >>>> +#define QSERDES_UFS_V7_RX_UCDR_FASTLOCK_COUNT_HIGH_RATE4            0x54
> >>>> +#define QSERDES_UFS_V7_RX_UCDR_FASTLOCK_FO_GAIN_RATE4                       0x10
> >>>> +#define QSERDES_UFS_V7_RX_UCDR_FASTLOCK_SO_GAIN_RATE4                       0x24
> >>>> +#define QSERDES_UFS_V7_RX_EQ_OFFSET_ADAPTOR_CNTRL1                  0x1CC
> >>>> +#define QSERDES_UFS_V7_RX_OFFSET_ADAPTOR_CNTRL3                             0x1D4
> >>>> +#define QSERDES_UFS_V7_RX_EQU_ADAPTOR_CNTRL4                                0x1B4
> >>>> +#define QSERDES_UFS_V7_RX_VGA_CAL_MAN_VAL                           0x178
> >>>
> >>> - Lowercase hex
> >>> - Sort RX by the register offset
> >>
> >> Sure Will take care in next patchset.
> >
> > Just to note, please sort QSERDES_V6_COM regs too.
> >
> >>
> >>>
> >>>
> >>>> +
> >>>> +#endif
> >>>> diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
> >>>> index d964bdfe870029226482f264c78a27d0ec43bf2b..a1695b368fe7622bf8663343d0241b4d0d40ab59 100644
> >>>> --- a/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
> >>>> +++ b/drivers/phy/qualcomm/phy-qcom-qmp-ufs.c
> >>>> @@ -31,6 +31,7 @@
> >>>>    #include "phy-qcom-qmp-pcs-ufs-v6.h"
> >>>>
> >>>>    #include "phy-qcom-qmp-qserdes-txrx-ufs-v6.h"
> >>>> +#include "phy-qcom-qmp-qserdes-txrx-ufs-v7.h"
> >>>>
> >>>>    /* QPHY_PCS_READY_STATUS bit */
> >>>>    #define PCS_READY                          BIT(0)
> >>>> @@ -949,6 +950,132 @@ static const struct qmp_phy_init_tbl sm8650_ufsphy_g5_pcs[] = {
> >>>>       QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_RX_HSG5_SYNC_WAIT_TIME, 0x9e),
> >>>>    };
> >>>>
> >>>> +static const struct qmp_phy_init_tbl sm8750_ufsphy_serdes[] = {
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_V6_COM_SYSCLK_EN_SEL, 0xD9),
> >>>
> >>> Lowercase hex
> >>
> >> Sure Will take care in next patchset.
> >>>
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_V6_COM_CMN_CONFIG_1, 0x16),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_V6_COM_HSCLK_SEL_1, 0x11),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_V6_COM_HSCLK_HS_SWITCH_SEL_1, 0x00),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_V6_COM_LOCK_CMP_EN, 0x01),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_V6_COM_LOCK_CMP_CFG, 0x60),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_V6_COM_PLL_IVCO, 0x1F),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_V6_COM_PLL_IVCO_MODE1, 0x1F),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_V6_COM_CMN_IETRIM, 0x07),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_V6_COM_CMN_IPTRIM, 0x20),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_V6_COM_VCO_TUNE_MAP, 0x04),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_V6_COM_VCO_TUNE_CTRL, 0x40),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_V6_COM_ADAPTIVE_ANALOG_CONFIG, 0x06),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_V6_COM_DEC_START_MODE0, 0x41),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_V6_COM_CP_CTRL_MODE0, 0x06),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_V6_COM_PLL_RCTRL_MODE0, 0x18),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_V6_COM_PLL_CCTRL_MODE0, 0x14),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_V6_COM_CP_CTRL_ADAPTIVE_MODE0, 0x06),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_V6_COM_PLL_RCCTRL_ADAPTIVE_MODE0, 0x18),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_V6_COM_PLL_CCTRL_ADAPTIVE_MODE0, 0x14),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_V6_COM_LOCK_CMP1_MODE0, 0x7F),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_V6_COM_LOCK_CMP2_MODE0, 0x06),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_V6_COM_BIN_VCOCAL_CMP_CODE1_MODE0, 0x92),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_V6_COM_BIN_VCOCAL_CMP_CODE2_MODE0, 0x1E),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_V6_COM_DEC_START_MODE1, 0x4C),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_V6_COM_CP_CTRL_MODE1, 0x06),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_V6_COM_PLL_RCTRL_MODE1, 0x18),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_V6_COM_PLL_CCTRL_MODE1, 0x14),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_V6_COM_CP_CTRL_ADAPTIVE_MODE1, 0x06),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_V6_COM_PLL_RCCTRL_ADAPTIVE_MODE1, 0x18),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_V6_COM_PLL_CCTRL_ADAPTIVE_MODE1, 0x14),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_V6_COM_LOCK_CMP1_MODE1, 0x99),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_V6_COM_LOCK_CMP2_MODE1, 0x07),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_V6_COM_BIN_VCOCAL_CMP_CODE1_MODE1, 0xBE),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_V6_COM_BIN_VCOCAL_CMP_CODE2_MODE1, 0x23),
> >>>> +};
> >>>> +
> >>>> +static const struct qmp_phy_init_tbl sm8750_ufsphy_tx[] = {
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_TX_LANE_MODE_1, 0x00),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_TX_RES_CODE_LANE_OFFSET_TX, 0x07),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_TX_RES_CODE_LANE_OFFSET_RX, 0x17),
> >>>> +};
> >>>> +
> >>>> +static const struct qmp_phy_init_tbl sm8750_ufsphy_rx[] = {
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_UCDR_FO_GAIN_RATE2, 0x0C),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_UCDR_FO_GAIN_RATE4, 0x0C),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_UCDR_SO_GAIN_RATE4, 0x04),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_EQ_OFFSET_ADAPTOR_CNTRL1, 0x14),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_UCDR_PI_CONTROLS, 0x07),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_OFFSET_ADAPTOR_CNTRL3, 0x0E),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_UCDR_FASTLOCK_COUNT_HIGH_RATE4, 0x02),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_UCDR_FASTLOCK_FO_GAIN_RATE4, 0x1C),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_UCDR_FASTLOCK_SO_GAIN_RATE4, 0x06),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_VGA_CAL_MAN_VAL, 0x8E),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_EQU_ADAPTOR_CNTRL4, 0x0F),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE_0_1_B0, 0xCE),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE_0_1_B1, 0xCE),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE_0_1_B2, 0x18),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE_0_1_B3, 0x1A),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE_0_1_B4, 0x0F),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE_0_1_B6, 0x60),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE_0_1_B7, 0x62),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE2_B3, 0x9A),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE2_B6, 0xE2),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE2_B7, 0x06),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE3_B0, 0x1B),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE3_B1, 0x1B),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE3_B2, 0x98),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE3_B3, 0x9B),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE3_B4, 0x2A),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE3_B5, 0x12),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE3_B7, 0x06),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE3_B8, 0x01),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE4_SA_B0, 0x93),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE4_SA_B1, 0x93),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE4_SA_B2, 0x60),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE4_SA_B3, 0x99),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE4_SA_B4, 0x5F),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE4_SA_B5, 0x92),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE4_SA_B6, 0xE3),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE4_SA_B7, 0x06),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE4_SB_B0, 0x9B),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE4_SB_B1, 0x9B),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE4_SB_B2, 0x60),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE4_SB_B3, 0x99),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE4_SB_B4, 0x5F),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE4_SB_B5, 0x92),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE4_SB_B6, 0xFB),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_MODE_RATE4_SB_B7, 0x06),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_UCDR_SO_SATURATION, 0x1F),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_UCDR_PI_CTRL1, 0x94),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_TERM_BW_CTRL0, 0xFA),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_DLL0_FTUNE_CTRL, 0x30),
> >>>> +    QMP_PHY_INIT_CFG(QSERDES_UFS_V7_RX_SIGDET_CAL_TRIM, 0x77),
> >>>> +};
> >>>> +
> >>>> +static const struct qmp_phy_init_tbl sm8750_ufsphy_pcs[] = {
> >>>> +    QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_MULTI_LANE_CTRL1, 0x02),
> >>>> +    QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_TX_MID_TERM_CTRL1, 0x43),
> >>>> +    QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_PCS_CTRL1, 0x40),
> >>>
> >>> Why does SM8650 have 0xc1 here?
> >>
> >> SM8750 phy is different from SM8650 and hence it is using different phy
> >> calibration setting. This value is as per Hardware programming guide.'
> >
> > Ack.
> >
> >>
> >>>
> >>>> +    QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_TX_LARGE_AMP_DRV_LVL, 0x0F),
> >>>> +    QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_RX_SIGDET_CTRL2, 0x68),
> >>>> +    QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_TX_POST_EMP_LVL_S4, 0x0E),
> >>>> +    QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_TX_POST_EMP_LVL_S5, 0x12),
> >>>> +    QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_TX_POST_EMP_LVL_S6, 0x15),
> >>>> +    QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_TX_POST_EMP_LVL_S7, 0x19),
> >>>> +};
> >>>> +
> >>>> +static const struct qmp_phy_init_tbl sm8750_ufsphy_g4_pcs[] = {
> >>>
> >>> Missing QPHY_V6_PCS_UFS_PLL_CNTL, then it becomes sm8650_ufsphy_g4_pcs
> >>
> >> The value of QPHY_V6_PCS_UFS_PLL_CNTL is 0x33 for SM8750 as it is
> >> operating on 80bit mode. Similiar change needs to be done for SM8650.
> >
> > Ack, please check if that allows the driver to use the same set of
> > tables for SM8650 and SM8750.
> >
> >>>
> >>>> +    QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_TX_HSGEAR_CAPABILITY, 0x04),
> >>>> +    QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_RX_HSGEAR_CAPABILITY, 0x04),
> >>>> +};
> >>>> +
> >>>> +static const struct qmp_phy_init_tbl sm8750_ufsphy_g5_pcs[] = {
> >>>
> >>> sm8650_ufsphy_g5_pcs?
> >> Agree with you. Good Finding. I will replace sm8750_ufsphy_g5_pcs with
> >> sm8650_ufsphy_g5_pcs.
> >>
> >>
> >>>
> >>>> +    QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_PLL_CNTL, 0x33),
> >>>> +    QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_TX_HSGEAR_CAPABILITY, 0x05),
> >>>> +    QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_RX_HSGEAR_CAPABILITY, 0x05),
> >>>> +    QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_RX_HS_G5_SYNC_LENGTH_CAPABILITY, 0x4d),
> >>>> +    QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_RX_HSG5_SYNC_WAIT_TIME, 0x9e),
> >>>> +};
> >>>> +
> >>>> +static const struct qmp_phy_init_tbl sm8750_ufsphy_hs_b_pcs[] = {
> >>>> +    QMP_PHY_INIT_CFG(QPHY_V6_PCS_UFS_PCS_CTRL1, 0x41),
> >>>> +};
> >>>> +
> >>>>    struct qmp_ufs_offsets {
> >>>>       u16 serdes;
> >>>>       u16 pcs;
> >>>> @@ -1523,6 +1650,45 @@ static const struct qmp_phy_cfg sm8650_ufsphy_cfg = {
> >>>>       .regs                   = ufsphy_v6_regs_layout,
> >>>>    };
> >>>>
> >>>> +static const struct qmp_phy_cfg sm8750_ufsphy_cfg = {
> >>>> +    .lanes                  = 2,
> >>>> +
> >>>> +    .offsets                = &qmp_ufs_offsets_v6,
> >>>> +    .max_supported_gear     = UFS_HS_G5,
> >>>> +
> >>>> +    .tbls = {
> >>>> +            .serdes         = sm8750_ufsphy_serdes,
> >>>> +            .serdes_num     = ARRAY_SIZE(sm8750_ufsphy_serdes),
> >>>> +            .tx             = sm8750_ufsphy_tx,
> >>>> +            .tx_num         = ARRAY_SIZE(sm8750_ufsphy_tx),
> >>>> +            .rx             = sm8750_ufsphy_rx,
> >>>> +            .rx_num         = ARRAY_SIZE(sm8750_ufsphy_rx),
> >>>> +            .pcs            = sm8750_ufsphy_pcs,
> >>>> +            .pcs_num        = ARRAY_SIZE(sm8750_ufsphy_pcs),
> >>>> +    },
> >>>> +
> >>>> +    .tbls_hs_b = {
> >>>> +            .pcs            = sm8750_ufsphy_hs_b_pcs,
> >>>> +            .pcs_num        = ARRAY_SIZE(sm8750_ufsphy_hs_b_pcs),
> >>>> +    },
> >>>> +
> >>>> +    .tbls_hs_overlay[0] = {
> >>>> +            .pcs            = sm8750_ufsphy_g4_pcs,
> >>>> +            .pcs_num        = ARRAY_SIZE(sm8750_ufsphy_g4_pcs),
> >>>> +            .max_gear       = UFS_HS_G4,
> >>>> +    },
> >>>> +    .tbls_hs_overlay[1] = {
> >>>> +            .pcs            = sm8750_ufsphy_g5_pcs,
> >>>> +            .pcs_num        = ARRAY_SIZE(sm8750_ufsphy_g5_pcs),
> >>>> +            .max_gear       = UFS_HS_G5,
> >>>> +    },
> >>>> +
> >>>> +    .vreg_list              = qmp_phy_vreg_l,
> >>>> +    .num_vregs              = ARRAY_SIZE(qmp_phy_vreg_l),
> >>>> +    .regs                   = ufsphy_v6_regs_layout,
> >>>> +
> >>>> +};
> >>>> +
> >>>>    static void qmp_ufs_serdes_init(struct qmp_ufs *qmp, const struct qmp_phy_cfg_tbls *tbls)
> >>>>    {
> >>>>       void __iomem *serdes = qmp->serdes;
> >>>> @@ -1593,8 +1759,10 @@ static void qmp_ufs_init_registers(struct qmp_ufs *qmp, const struct qmp_phy_cfg
> >>>>               qmp_ufs_pcs_init(qmp, &cfg->tbls_hs_overlay[i]);
> >>>>       }
> >>>>
> >>>> -    if (qmp->mode == PHY_MODE_UFS_HS_B)
> >>>> +    if (qmp->mode == PHY_MODE_UFS_HS_B) {
> >>>>               qmp_ufs_serdes_init(qmp, &cfg->tbls_hs_b);
> >>>> +            qmp_ufs_pcs_init(qmp, &cfg->tbls_hs_b);
> >>>
> >>> Extract the serdes+lanes+pcs helper, use it in this function.
> >>
> >> Lane init is already a different helper and is already being called from
> >> function (qmp_ufs_init_register). Here we just adding few extra PCS
> >> registers needed to support Rate B.
> >
> > Please extract the helper that calls qmp_ufs_serdes_init() +
> > qmp_ufs_lanes_init() + qmp_ufs_pcs_init() over a particular table.
>
> Hi Dmitry,
>
> Do you mean to move qmp_ufs_serdes_init , qmp_ufs_lanes_init and
> qmp_ufs_pcs_init into a different wrapper function and call this wrapper
> from qmp_ufs_init_registers for each table.

Yes.

>
> But for tbls_hs_b, we just need qmp_ufs_serdes_init and
> qmp_ufs_pcs_init. qmp_ufs_lanes_init is not required for tbls_hs_b.
> So wrapper API won't be of much help.

It still is, it removes a need to care about the particular table.
Historically tbls_hs_b had only qserdes. Now you've added pcs. I don't
think we should wait for somebody to add tx/rx on top of that.

>
> Regards,
> Nitin
>
>
> >
> >>
> >>>
> >>>> +    }
> >>>>    }
> >>>>
> >>>>    static int qmp_ufs_com_init(struct qmp_ufs *qmp)
> >>>> @@ -2061,7 +2229,11 @@ static const struct of_device_id qmp_ufs_of_match_table[] = {
> >>>>       }, {
> >>>>               .compatible = "qcom,sm8650-qmp-ufs-phy",
> >>>>               .data = &sm8650_ufsphy_cfg,
> >>>> +    }, {
> >>>> +            .compatible = "qcom,sm8750-qmp-ufs-phy",
> >>>> +            .data = &sm8750_ufsphy_cfg,
> >>>>       },
> >>>> +
> >>>>       { },
> >>>>    };
> >>>>    MODULE_DEVICE_TABLE(of, qmp_ufs_of_match_table);
> >>>>
> >>>> --
> >>>> 2.46.1
> >>>>
> >>>
> >> Thanks,
> >> Nitin
> >>
> >
> >
>


-- 
With best wishes
Dmitry
