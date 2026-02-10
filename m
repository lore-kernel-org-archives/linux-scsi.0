Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E37E329E6D
	for <linux-scsi@vger.kernel.org>; Tue, 10 Feb 2026 13:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770731075; cv=pass; b=NONnRxuaxvr1dN2WBWD+6Jicet4CI3QILOXzx/DjdL2BiVM9+J0Zv8YbvXoSNNT6DfQNl/RZTwjEJP2g6fnl+J8T65JBUBBa0oIHoxahZaUwcky6EHPLBy8sXqKkkIU1GEO9r15NOGMCUqKpGPy44v/aRaENllYnp4+8rKNlK1w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770731075; c=relaxed/simple;
	bh=My7H0zv9om6eGFOqwrY8WEQgO1PL3LXVOyrjI3ZQRjo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aJieMoKRvvpcmII4GUeFAyqQRL2+1JjV2gzJpS+68+ycBfdjefapkicplTM8aGj2ECAnAAVJiEOOFLlv4HWAf/CiDJ+94Iz5DpYfNhrKn8y0dAuQc2Xkvu64w+3CAbQWZm5iWzso0RrLy/US6b5SMwNb1XK7f1PucT3xPnfyboU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Vw8WzPB0; arc=pass smtp.client-ip=74.125.224.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Vw8WzPB0"
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-649dbff9727so3538996d50.3
        for <linux-scsi@vger.kernel.org>; Tue, 10 Feb 2026 05:44:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770731072; cv=none;
        d=google.com; s=arc-20240605;
        b=PPYgip3AycH8B1o5LnOHofg2gj3vvZj80ufe8M1wWkVxXgYQRmeXgmHOdpzwe8S5xs
         nGMqcDVofyc0z0cK1GWPSo31N4HZTnhaX1/VP29ogmsIXXcG4jCzvjDf5omWv69Ipn99
         xQkdEcfU3k/a7dpaIluvdonM1X16wEDqdGVv3qkpEaIMOh5iXEs23s7R3dRRmsZT/sVA
         bbFDQekmxD5mwn0v/wVuN0BlWj4paUDxcCLi9FN93MI0yHpp3b2iEn4H38UORiu4GM38
         TQ7nMdp6giho60oWUZgYmQPSgGujaZLrXZMod/fyKdLGDJEFc5gTwhkskueaYBgEPOkp
         SxbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=cO0B8QPhPo0Y3GlbKCDusifXNzaiAeSd4InIZCnguwY=;
        fh=xMPmsZEkI1ZXMIXrwtb8ISVIZGFF7C8j62WyZ907A+0=;
        b=NIs4b+GQrkwlT7WCUwO2rZOJ5ubhsRzyVOgy2ybsjb9LxL298MIwtwfz+I0R3kZPM4
         dX1SVR29tQbrYTHl1tvi9iYV2CXY2d4yshGZbP7YXdOKINY2k9no7KnDXCbkLHesKuAp
         xnEf0Nsw3p/I3KHwSpMTbctDqZHRzPyRj4o5iRvyOq//VRYOCWj8j5SHeH2OXBUQnsiS
         H+t23xXbOTHHecc9canum7cBU/1zuZGrXskAyu5Dp8OhpuxXdpMQhGOvDG49Z0gsZLtW
         +H/JS17aU5AJw1DHaodQBFY8i6EmQ7KaFvC9uBvMGJyWpUKnnv3RAqUDLXF6MHhgyIcE
         biLA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770731072; x=1771335872; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cO0B8QPhPo0Y3GlbKCDusifXNzaiAeSd4InIZCnguwY=;
        b=Vw8WzPB0oLcYWhtQSx/BjgeR0IIJffAqCy/AtF/PqSjkoeWAJ3MPMv1QGab0EKCEJp
         hYOrRYbpzrt0KLCPL8dv2ImW+w3GICWzj0n+MLSB8F4DaPx0w3X9pqcj/75b/SrDmK+0
         dS6JJILoKeKUQwgO44dPaUMEmOtfdsgxTXuM9w/SFYfhDEhVXbdIppsVZ474fE4EH5z8
         W5tQMD6yyOGACdGI2sBNuBPlvNFy1h5C8ojSZJ9FMMJx7l2OTuwjy/VDX4yB7L05G2NR
         AU1NqixA2Lis3AnkTkzixffUUqPnjIMvk9NfWEWDvDQciQRcfQzdH3t2uFPeYph0ihxZ
         tAwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770731072; x=1771335872;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cO0B8QPhPo0Y3GlbKCDusifXNzaiAeSd4InIZCnguwY=;
        b=D/QEFkg2CJZr8d1KoaBYnQkoDPjqo+BPL/hxoZ8p5qWC8rIvtox6kLIAzEle2lw8xM
         k7N6umkInDocaOopEEuxNHVs2XD4AyhlsaekscfcjRUX/RHRfyZPGD+g7ofTcPnAlgje
         XwI3wViJzxRKUsXR5E4rB4g54sfoKr8mANbneZ2/rWY1ulpqsDZjY/jyQ/YoJT5WTAT8
         uThmsKH7G0g1QvevjFUrPwkiua3JLDVipzqmSoB3F0OILxGMw+4u2n5WmhdPayHW9hPj
         kOs4WPvhkNmCmu2PfQOA1Jp4TJXlmsKb2q7Dk6DW4K/m4pzEU1GRzjDU4mQeOoKN7+pU
         6UKA==
X-Forwarded-Encrypted: i=1; AJvYcCVThXWmjJq3iipc2rrkdFUlDamp7wOxolmckz8jiUKP16tdBcxl+nsdChxLapyEsEE9kFTT9jcKlLg9@vger.kernel.org
X-Gm-Message-State: AOJu0YycSNMNTQK2ljqbn+vZPFVMmdllNRcwP6VIsknNr+Jq/N3K2K56
	Tn3zfw2p96pWE6fL5d7bH8BuLceN5yYjBM+EF1ObqyXyGlRBQsYxWhssujZAByBFS6SCLeWAQ53
	CvQlfCDPBZ90nOBrKza09gaSw0KbawPPyLTYlcBvHnA==
X-Gm-Gg: AZuq6aIigREjaTTT0hZ+WvTScFPOSxSrGl1NhIjhU7QMyb1Iw5S9Ps/TVy4jadPjwtp
	2r2xAwaaZ9QtbVsdHRWbGmnlz1H6BiY+DKkzjArXcKzCr7+Hg0NXa2VqMctoThyIEXxKj167dwg
	lO3TxJzvEB4fe8EEbKxmDhaqrJoIgkQkkNBsQ0T3mBhSZRtVMgBBRPRZgH2EsfH22W0O1+1KSkJ
	bz3vNIqJTlnUBv9sojhHOd8Eo5vLSjQIj7PKZAsdX7Jf/jRhnVbs0lKMehZ0PMEJIIKZ+alLgln
	57AYYnGY
X-Received: by 2002:a05:690e:b4e:b0:64a:f188:976f with SMTP id
 956f58d0204a3-64af1889b6fmr1730648d50.45.1770731072184; Tue, 10 Feb 2026
 05:44:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260210-qcom-ice-fix-v2-0-9c1ab5d6502c@oss.qualcomm.com>
In-Reply-To: <20260210-qcom-ice-fix-v2-0-9c1ab5d6502c@oss.qualcomm.com>
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Tue, 10 Feb 2026 14:43:53 +0100
X-Gm-Features: AZwV_QhTZ9KRaRA5GTHx4N22K6Lp6hSICHstQ6937DBI5S-nFi13iuFlfu6mtC8
Message-ID: <CAPDyKFocm3yRTG0TJJRxfDvJMjvvvri5fzi_HoNY4YSd-41oKA@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] soc: qcom: ice: Remove platform_driver support and
 expose as a pure library
To: manivannan.sadhasivam@oss.qualcomm.com
Cc: Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Abel Vesa <abel.vesa@linaro.org>, Adrian Hunter <adrian.hunter@intel.com>, 
	Manivannan Sadhasivam <mani@kernel.org>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, linux-arm-msm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, 
	linux-scsi@vger.kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, 
	stable@vger.kernel.org, Abel Vesa <abel.vesa@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 10 Feb 2026 at 07:56, Manivannan Sadhasivam via B4 Relay
<devnull+manivannan.sadhasivam.oss.qualcomm.com@kernel.org> wrote:
>
> Hi,
>
> This series removes the platform_driver support from Qcom ICE driver and
> exposes it as a pure library to the clients to avoid race conditions with ICE
> SCM call availability.
>
> Merge Strategy
> ==============
>
> ICE patches (1,2) through Qcom tree and MMC/UFS patches (3,4) through respective
> subsystem trees as there is no dependency.

Just wanted to double check that this is really correct....

The propagated error codes (or NULL) are changed in patch1/patch2, so
is it really okay to pick the mmc/ufs patches (patch3 and patch4)
independently?

Kind regards
Uffe

>
> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> ---
> Changes in v2:
>
> * Added MODULE_* macros back
> * Removed spurious platform_device_put()
> * Added patches to remove NULL return
>
> ---
> Manivannan Sadhasivam (4):
>       soc: qcom: ice: Remove platform_driver support and expose as a pure library
>       soc: qcom: ice: Return proper error codes from devm_of_qcom_ice_get() instead of NULL
>       mmc: sdhci-msm: Remove NULL check from devm_of_qcom_ice_get()
>       scsi: ufs: ufs-qcom: Remove NULL check from devm_of_qcom_ice_get()
>
>  drivers/mmc/host/sdhci-msm.c |  10 ++--
>  drivers/soc/qcom/ice.c       | 127 ++++++++++++++++---------------------------
>  drivers/ufs/host/ufs-qcom.c  |  10 ++--
>  3 files changed, 58 insertions(+), 89 deletions(-)
> ---
> base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
> change-id: 20260210-qcom-ice-fix-d2a3a045b32d
>
> Best regards,
> --
> Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
>
>
