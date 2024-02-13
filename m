Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com [209.85.219.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE2B2C683
	for <linux-scsi@vger.kernel.org>; Tue, 13 Feb 2024 10:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707819289; cv=none; b=CFGi/L7R8z0Wv8q4imDEFubz2MHcb+fAqAjK/FBvZq7fp0QLm3KUc4wibUGJ5MGhcnOCLwGT+rSC5CbeepuxwiJ48nepnYO1ecZui2oxx5Jb3Y/nTw2ZP/6kP6Avqh5UyVOX78EinDUqvhqQjlajvbBCKaayyc9OnkSHwlqkN9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707819289; c=relaxed/simple;
	bh=qdwBhSjUwQlPmDF34us+O31ur8u9qEpELpEa5WnbVSc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uv7BC0rQTbnEICacjoD8+50VCbGf4QTrhsYyv12NKOQUPMoWqKoCwsZ9JHsCGvupS+yJRkAcxXCnefAHHx2/NK8VswoVK9I5+BJIW39NNStx4iCjElWi8RZAkvsVsDtUNjquOgEyYL7rRPZ5y+DuGKBGDUZYzrq6LT5Q6zDIlqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dcVdIZWH; arc=none smtp.client-ip=209.85.219.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dcVdIZWH"
Received: by mail-yb1-f182.google.com with SMTP id 3f1490d57ef6-dcbf82cdf05so1076573276.2
        for <linux-scsi@vger.kernel.org>; Tue, 13 Feb 2024 02:14:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1707819287; x=1708424087; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uAkusKZXu4VxkCaxFs2ANE2O6DTRMuupESPk1UtuR8I=;
        b=dcVdIZWHNjh2cBUAqKtpcZxko4CQ+60s+eaEd9GMHyolKoUkSKw1s1m1SMCFQULvsf
         6brq/PQr2gxb7Qha4MMFPtVqD0vRVUtF5y03qrllgiBav9b/ueksOfbEjhf5zNiYB9DG
         yuN09+ZrSOEYji66D1xnFFGPGMnMr44pkCt2MV/Uf7FgGTdrPXtSkdavEU+sZcX3TEim
         I+RKshzL/sBLAUk+JJjnRK8EEm4eCcpTgsuuZQTUjegviflsAy5xABGQ1fi+RkB7AsNL
         f+S9GRnmkMBorgkKi8meVU1Owsn6dSdI9xzEFyYGUJvR3oubgmtWMVS/+08uh8chNCCs
         TGSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707819287; x=1708424087;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uAkusKZXu4VxkCaxFs2ANE2O6DTRMuupESPk1UtuR8I=;
        b=QNEi/zsImE1EhLKveUfFrehckj+yzO6x6nBsMsC72935pSfG0OTkqz+T5zkdsUe7hf
         bjuiO6T/1rL7vDyGiwaNSzoddEjXAaN1MUN+osanLEfKn4Y6zpN6ZrF3lj7ZHvHYHqPa
         7JukP0ml4n6z5VDnuGTI3rRbCHijeGoHPnWRpHcyc7zFhqgcxAJ6qJQCX/iaokBBFrK6
         ifQyV6G3N0/mppZRu8FmkE9sP+UtY2PhXijvca73ljw9104mQWO1VGGWqi1T24MLGJE2
         atUn3fKu5t8eviVaAKF0JDWfEssPTTBlcMuxBDX8w4g5oxyqok8sTAe2Q+azqglNb+bM
         pN1Q==
X-Gm-Message-State: AOJu0YyXCb1WtyO1q928XQ7ZbARDXOO3G3+1W1TtBxZX0yw3kgsit8qL
	QMOE0QGkKNb52zVh6oU5OWPEGj+rrWq+mYtd3mUjpQHCpOv/Ug54KABmB9QmYF5K1Hsst9FnntO
	QBt3Dw5LWSCtdM4B/5DVeV+qoOfwMF3RhId0k7w==
X-Google-Smtp-Source: AGHT+IEVm1Knjlt3O7qiDjxwD0iN4GvXtg7Ltb1tOjcwmWakmQZAsoE0ftYUaSsSBXyfT4khwq+X23qqApBdH/Do5JI=
X-Received: by 2002:a05:6902:1b89:b0:dcc:f6e2:44d0 with SMTP id
 ei9-20020a0569021b8900b00dccf6e244d0mr593209ybb.37.1707819287099; Tue, 13 Feb
 2024 02:14:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240209-msm8996-fix-ufs-v1-0-107b52e57420@linaro.org>
 <20240209-msm8996-fix-ufs-v1-1-107b52e57420@linaro.org> <6dd8b54e-8334-4bc7-a6c5-7a81c04ed8bb@linaro.org>
In-Reply-To: <6dd8b54e-8334-4bc7-a6c5-7a81c04ed8bb@linaro.org>
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Date: Tue, 13 Feb 2024 12:14:36 +0200
Message-ID: <CAA8EJprOh0PB1n3c9NS276ck8YrbSTj8wd6J8QqvoozpaB4H9A@mail.gmail.com>
Subject: Re: [PATCH 1/8] dt-bindings: ufs: qcom,ufs: add second RX lane on
 MSM8996 platform
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konrad.dybcio@linaro.org>, 
	"James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Nitin Rawat <quic_nitirawa@quicinc.com>, Can Guo <quic_cang@quicinc.com>, 
	Naveen Kumar Goud Arepalli <quic_narepall@quicinc.com>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, Conor Dooley <conor+dt@kernel.org>, 
	Andy Gross <andy.gross@linaro.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Andy Gross <agross@kernel.org>, 
	linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org, 
	devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 11 Feb 2024 at 16:02, Krzysztof Kozlowski
<krzysztof.kozlowski@linaro.org> wrote:
>
> On 09/02/2024 22:50, Dmitry Baryshkov wrote:
> > Describe the second RX lane used by the UFS controller on MSM8996
> > platform.
> >
> > Fixes: 462c5c0aa798 ("dt-bindings: ufs: qcom,ufs: convert to dtschema")
>
> Your commit msg does not explain why this is a fix.

.. and it is probably unnecessary, as msm8996 has 'lanes-per-direcion
= <1>;' I'll drop this for v2.

>
> > Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> > ---
> >  Documentation/devicetree/bindings/ufs/qcom,ufs.yaml | 11 ++++++-----
> >  1 file changed, 6 insertions(+), 5 deletions(-)
> >
> > diff --git a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
> > index 10c146424baa..f1de3244b473 100644
> > --- a/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
> > +++ b/Documentation/devicetree/bindings/ufs/qcom,ufs.yaml
> > @@ -43,11 +43,11 @@ properties:
> >
> >    clocks:
> >      minItems: 8
> > -    maxItems: 11
> > +    maxItems: 12
> >
> >    clock-names:
> >      minItems: 8
> > -    maxItems: 11
> > +    maxItems: 12
>
>
> Best regards,
> Krzysztof
>


-- 
With best wishes
Dmitry
