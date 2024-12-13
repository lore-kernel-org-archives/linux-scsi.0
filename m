Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com [209.85.222.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF561DF721
	for <linux-scsi@vger.kernel.org>; Fri, 13 Dec 2024 12:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734092956; cv=none; b=oRZ3o2/Q6vmqjrqAP9R3xL871e7wtr/Zu8zecaGjm3RTEhFU1HW8TBURPdGyEOXqLZ7/yujS36IYxEzMWVDd2AKOBVBvz92tIMqi+P+jPkNRxYLb8JFarMzm4DdOXakaDl8q6sPKTdHeYZwAN6avt4pnO2d1fAAxP+GwKbGonM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734092956; c=relaxed/simple;
	bh=93KVkxX3HqqmyrQ/h4LhI1Yswq7WZECZktzyWt2bZz4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KfFUXKX26337Qj6wzb/+4YGsZZMSz1Xmhlv7ewsiFf9dCo4KVFtXghqwOM1DVYHc0EvH0FIZVXaRqi4Fzy4Vl56hpYodfyuPabgNavcW2+QCiwrydgrbbxIseQwCkk3pwdfJorKQ+UziGyJmazu/cP3U23LpQR/fCAbbOyiELhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ApTCdx4y; arc=none smtp.client-ip=209.85.222.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ApTCdx4y"
Received: by mail-ua1-f48.google.com with SMTP id a1e0cc1a2514c-85ba8b1c7b9so875887241.1
        for <linux-scsi@vger.kernel.org>; Fri, 13 Dec 2024 04:29:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1734092953; x=1734697753; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FtUtQH27YInSkS7QubBxHe0++ef4URa+tbTRrDJRxjQ=;
        b=ApTCdx4yqf7ajKoTqT1ybcA3/ECB1uL8BHxcYukX2IQRPw8hibHTFftbBIblBjKfHk
         7716vDyMG5rC/Wl/1MoEEx+ohNAZiU08VU1YvRMeBBOw0aiX5US83Nbu6j1E3tTqBj6b
         p7bxx6K9whYBzEQzXOMttnWkt7H+0m9AguCl7uTDxl76IbCW0EfyluDQtRqDqcuGFwUt
         fyrvVmrOSDUYjYb0pzhk2BkywMwU4iu5Pd/mf8cNAVPQ2FzSa9SNUFT6ETJ1vpNeLoZ+
         M7AzG6kOWXGJ/jGfV4/OV0xbIYSo15OXOxckKA7WTAabJz0eLLMvE41Gc3b9K8JX38Ad
         kWSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734092953; x=1734697753;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FtUtQH27YInSkS7QubBxHe0++ef4URa+tbTRrDJRxjQ=;
        b=unzErg9VH33I+bm2JhJyWcElrFkg+ISa2PtMGbMku8bmvZ/SRg8NlNVUO4lTqmSdu8
         wg/Miar9741J6JV7DDYQRb3IHqcahOITma0arCsbUMKOM9d64zQGjV9b1H0ZiEBsf5XP
         Y2Mmfe5YQKuzFelMDEkHlPTaalK7lvqC5KWUmCXZfWGyLlMYq5tCC+DUOkNisegurLWO
         Sj2DXDTMZWL3L9R+TUMd3pR//fT3YU+j5Hv2z+3VlaHfsrYf5zmU48MiBEiPQkas+tEI
         3Y1jkf7WXJlrq6OeRBqti2g1e99dgHSNaRSg2Y16Pyfnk0m9a8veZA9VOgaTN602Kx7y
         LGNg==
X-Forwarded-Encrypted: i=1; AJvYcCURhiuDuTe64y0Vwt4Xn+0/xeLlG366wVDYFnJ8UF029NubTJFB/I2ZZRkTYEfFDmKuvjZcZJ1cOK5I@vger.kernel.org
X-Gm-Message-State: AOJu0Ywfn2cp33AEhTYYVtZvEf8CnJKxCku1MmxVTdrt97bgk6QCULTb
	YJ8IjU70raeVfGJHKTzldQQ5VTewypnYh245CtRRbdg71xFZ0EPk21cMlKAmI9+sDPSM5wsGaBq
	lEEj+H675R0TqFAa6xAnb6sP7mAZwo+1ir2BJng==
X-Gm-Gg: ASbGnct9GeqECEIMXlWvSwnVWm3IpYATCbCZNpxhPcdNYC/U9VoqeHdfW8tlh9Ull9x
	F17bO2hLX0TVOrqZJilb0kZzHDvCW+BQfwiFNYy4hnQAbxON/PouzDTPOM0Ov6o+tQw0DaA==
X-Google-Smtp-Source: AGHT+IG1eUwqPBtXeSmNUetsnaD01mL9MHBqUyLkem51OibyPkckl12MvzfT6CQybG/qaUW/KE7JovIxwZSB3Z1xuaQ=
X-Received: by 2002:a05:6102:54a3:b0:4af:dcf3:b384 with SMTP id
 ada2fe7eead31-4b257b57f38mr4991199137.11.1734092952957; Fri, 13 Dec 2024
 04:29:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241211-ufs-qcom-suspend-fix-v1-0-83ebbde76b1c@linaro.org>
In-Reply-To: <20241211-ufs-qcom-suspend-fix-v1-0-83ebbde76b1c@linaro.org>
From: Amit Pundir <amit.pundir@linaro.org>
Date: Fri, 13 Dec 2024 17:58:37 +0530
Message-ID: <CAMi1Hd3_aDCwkg6g5Mb7Oc3sKQPmCcwoSz1vigHUbkDS2Y8a3A@mail.gmail.com>
Subject: Re: [PATCH 0/3] scsi: ufs: qcom: Suspend fixes
To: manivannan.sadhasivam@linaro.org
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
	Bart Van Assche <bvanassche@acm.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Abel Vesa <abel.vesa@linaro.org>, 
	Bjorn Andersson <andersson@kernel.org>, Neil Armstrong <neil.armstrong@linaro.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	Nitin Rawat <quic_nitirawa@quicinc.com>, stable@vger.kernel.org, 
	Ram Kumar Dwivedi <quic_rdwivedi@quicinc.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 11 Dec 2024 at 23:10, Manivannan Sadhasivam via B4 Relay
<devnull+manivannan.sadhasivam.linaro.org@kernel.org> wrote:
>
> Hi,
>
> This series fixes the several suspend issues on Qcom platforms. Patch 1 fixes
> the resume failure with spm_lvl=5 suspend on most of the Qcom platforms. For
> this patch, I couldn't figure out the exact commit that caused the issue. So I
> used the commit that introduced reinit support as a placeholder.
>
> Patch 3 fixes the suspend issue on SM8550 and SM8650 platforms where UFS
> PHY retention is not supported. Hence the default spm_lvl=3 suspend fails. So
> this patch configures spm_lvl=5 as the default suspend level to force UFSHC/
> device powerdown during suspend. This supersedes the previous series [1] that
> tried to fix the issue in clock drivers.
>
> This series is tested on Qcom SM8550 MTP and Qcom RB5 boards.

Thank you Mani. This patch-series fixes a UFS breakage on SM8550-HDK
running AOSP.

Tested-by: Amit Pundir <amit.pundir@linaro.org> # on SM8550-HDK

>
> [1] https://lore.kernel.org/linux-arm-msm/20241107-ufs-clk-fix-v1-0-6032ff22a052@linaro.org
>
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> ---
> Manivannan Sadhasivam (3):
>       scsi: ufs: qcom: Power off the PHY if it was already powered on in ufs_qcom_power_up_sequence()
>       scsi: ufs: qcom: Allow passing platform specific OF data
>       scsi: ufs: qcom: Power down the controller/device during system suspend for SM8550/SM8650 SoCs
>
>  drivers/ufs/core/ufshcd-priv.h |  6 ------
>  drivers/ufs/core/ufshcd.c      |  1 -
>  drivers/ufs/host/ufs-qcom.c    | 31 +++++++++++++++++++------------
>  drivers/ufs/host/ufs-qcom.h    |  5 +++++
>  include/ufs/ufshcd.h           |  2 --
>  5 files changed, 24 insertions(+), 21 deletions(-)
> ---
> base-commit: 40384c840ea1944d7c5a392e8975ed088ecf0b37
> change-id: 20241211-ufs-qcom-suspend-fix-5618e9c56d93
>
> Best regards,
> --
> Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
>
>
