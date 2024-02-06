Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C43A131731
	for <linux-scsi@vger.kernel.org>; Tue,  6 Feb 2024 11:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707220633; cv=none; b=f9CAn3wOsPNETZrE1K1aKWl13k8+K2idY/EBRPI/iOCECD2oNusK5LK9jRJVgLzUMvyszVmfO6r7jiclJKUwOVI4RSHwZSd50C/l1vDNx1jjtK3+xTaSb+qqDW5bjXbD/kd3BlXMg0dn/k1MKSr6BQZVZy0Ff83auh/OPqNztRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707220633; c=relaxed/simple;
	bh=Hg3/iVoN8Xt9xwsF8tbO3GWU7Apwxbu1gLJjYlDOPqo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OMDuVquceUVzBs9uSOIcs3QljmaBevzzfztm8si17g9+LA9pqLGdQvo6q4/XAmFPhWRPKoriwgSMphpmA2K4x2nM5RkfdUQ/2YsYU4Rexu3zna22lFc0hDkhjhq2oUTadml/HSx0veUonFEPfsSuIBHQwNHHUMYheEpld0yUI6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=JftHh27A; arc=none smtp.client-ip=209.85.219.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JftHh27A"
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-dc6d8f31930so396193276.0
        for <linux-scsi@vger.kernel.org>; Tue, 06 Feb 2024 03:57:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1707220631; x=1707825431; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Le8ZKrDU25Vw3DueHEr1ODzcpo1eKUbedQGPH8uNW6A=;
        b=JftHh27A3krJQpNKRVYlORZvT4fWWS0espBOQiPurvuwJUxVX24rPZcEbAbt0WCJ6b
         2MYVUmqCOBy2UHVxnjl8+xJK4PHjLS1E76X5dA9U29Ark2rrKbsOOTQ0myvl1zInlH6H
         cHBmqGhNpU7H61I7gozId7VJat9ml85iLg3YzsJ60cmDKvh6vkLrbjRy+1JY1IVoKywh
         oe0kGBLq5VBRAAd6blz6dr6pzxRc4CTkD1XSMMJPAcyfWWaGqOPNqDzH0ISJLXAbQHZQ
         oJOiy5wTYS+O4fq/p/iCaENZDDTO0Lnybl+8OWtwU+OIkSfeLfTZL3QEbMUZjTiYNDlH
         gAdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707220631; x=1707825431;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Le8ZKrDU25Vw3DueHEr1ODzcpo1eKUbedQGPH8uNW6A=;
        b=Vx7DfgeSN4Nw1DVduJ43YHCW4yawFCRFVlkIillX3lF+XlquH251qFqORgA3KLLsWm
         FvPkF7e54JGaJRjUGNDX1/jgXYKeIOWIM0ta1Z5OpF+K/kumlKkD6ZkOiq3z/swlg8U3
         SXhTYtXySJA0F5Sh74jVWUVgYm/dMDDYFTmfA3V8oDA7JqRRG1AoQs8qEP6yoXrnCdcF
         gU2UgrwzbP8lY5luZkAUux0qGsd2fsQQ+7pLIV1e8uEyRBJorTR8IWH7dkBYd66GbWPs
         /qogqvFU0zhFGVlTFTKfP6kNfOBCtG9dDbhwidfW2Kw1HpwDRxjt3Aj+SLFiUwEzxDhQ
         ENww==
X-Gm-Message-State: AOJu0Yygz8hkqG+VCOeVrRn9tm2L3tpbQjS8veZAorjmDIIwuUZyvFA8
	Pplx4MkAqqIbUBTnoUaIR4RM9+ckpZzybVzsjqzuOjsQ0IVklYAX6ASoZ2ULXFAD9qIqJlJcIOd
	zuHcUQ8sPTYDDLHrm61BIfseDpNs9C/fN89zqZA==
X-Google-Smtp-Source: AGHT+IEs6lByJ9Q70GkeZXRjw6KUG6Nrlc41vCLLrFuvc0movqmOOqhJh7iPJ7w/9F6g9Y0yMYTiHQE0bi2Y9vOudTM=
X-Received: by 2002:a05:6902:2001:b0:dc6:c670:c957 with SMTP id
 dh1-20020a056902200100b00dc6c670c957mr920837ybb.32.1707220629612; Tue, 06 Feb
 2024 03:57:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240127232436.2632187-1-quic_gaurkash@quicinc.com>
 <20240127232436.2632187-3-quic_gaurkash@quicinc.com> <b06b3b13-3d61-4bf6-bc06-80ca1a189a4f@linaro.org>
In-Reply-To: <b06b3b13-3d61-4bf6-bc06-80ca1a189a4f@linaro.org>
From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Date: Tue, 6 Feb 2024 12:56:58 +0100
Message-ID: <CACMJSevs4m9gzMrXgvzTGguQt0XUQ-bXf7Cw6WXuM=v-CrQR2g@mail.gmail.com>
Subject: Re: [PATCH v4 02/15] qcom_scm: scm call for deriving a software secret
To: Konrad Dybcio <konrad.dybcio@linaro.org>
Cc: Gaurav Kashyap <quic_gaurkash@quicinc.com>, linux-arm-msm@vger.kernel.org, 
	linux-scsi@vger.kernel.org, andersson@kernel.org, ebiggers@google.com, 
	neil.armstrong@linaro.org, srinivas.kandagatla@linaro.org, 
	krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org, robh+dt@kernel.org, 
	linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, kernel@quicinc.com, 
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
	quic_omprsing@quicinc.com, quic_nguyenb@quicinc.com, ulf.hansson@linaro.org, 
	jejb@linux.ibm.com, martin.petersen@oracle.com, mani@kernel.org, 
	davem@davemloft.net, herbert@gondor.apana.org.au
Content-Type: text/plain; charset="UTF-8"

On Thu, 1 Feb 2024 at 17:11, Konrad Dybcio <konrad.dybcio@linaro.org> wrote:
>
> On 28.01.2024 00:14, Gaurav Kashyap wrote:
> > Inline storage encryption may require deriving a software
> > secret from storage keys added to the kernel.
> >
> > For non-wrapped keys, this can be directly done in the kernel as
> > keys are in the clear.
> >
> > However, hardware wrapped keys can only be unwrapped by the wrapping
> > entity. In case of Qualcomm's wrapped key solution, this is done by
> > the Hardware Key Manager (HWKM) from Trustzone.
> > Hence, adding a new SCM call which in the end provides a hook
> > to the software secret crypto profile API provided by the block
> > layer.
> >
> > Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
> > Tested-by: Neil Armstrong <neil.armstrong@linaro.org>
> > ---
> >  drivers/firmware/qcom/qcom_scm.c       | 65 ++++++++++++++++++++++++++
> >  drivers/firmware/qcom/qcom_scm.h       |  1 +
> >  include/linux/firmware/qcom/qcom_scm.h |  2 +
> >  3 files changed, 68 insertions(+)
> >
> > diff --git a/drivers/firmware/qcom/qcom_scm.c b/drivers/firmware/qcom/qcom_scm.c
> > index 7e17fd662bda..4882f8a36453 100644
> > --- a/drivers/firmware/qcom/qcom_scm.c
> > +++ b/drivers/firmware/qcom/qcom_scm.c
> > @@ -1220,6 +1220,71 @@ int qcom_scm_ice_set_key(u32 index, const u8 *key, u32 key_size,
> >  }
> >  EXPORT_SYMBOL_GPL(qcom_scm_ice_set_key);
> >
> > +/**
> > + * qcom_scm_derive_sw_secret() - Derive software secret from wrapped key
> > + * @wkey: the hardware wrapped key inaccessible to software
> > + * @wkey_size: size of the wrapped key
> > + * @sw_secret: the secret to be derived which is exactly the secret size
> > + * @sw_secret_size: size of the sw_secret
> > + *
> > + * Derive a software secret from a hardware wrapped key for software crypto
> > + * operations.
> > + * For wrapped keys, the key needs to be unwrapped, in order to derive a
> > + * software secret, which can be done in the hardware from a secure execution
> > + * environment.
> > + *
> > + * For more information on sw secret, please refer to "Hardware-wrapped keys"
> > + * section of Documentation/block/inline-encryption.rst.
> > + *
> > + * Return: 0 on success; -errno on failure.
> > + */
> > +int qcom_scm_derive_sw_secret(const u8 *wkey, size_t wkey_size,
> > +                           u8 *sw_secret, size_t sw_secret_size)
> > +{
> > +     struct qcom_scm_desc desc = {
> > +             .svc = QCOM_SCM_SVC_ES,
> > +             .cmd =  QCOM_SCM_ES_DERIVE_SW_SECRET,
> > +             .arginfo = QCOM_SCM_ARGS(4, QCOM_SCM_RW,
> > +                                      QCOM_SCM_VAL, QCOM_SCM_RW,
> > +                                      QCOM_SCM_VAL),
> > +             .args[1] = wkey_size,
> > +             .args[3] = sw_secret_size,
> > +             .owner = ARM_SMCCC_OWNER_SIP,
> > +     };
> > +
> > +     void *secret_buf;
> > +     void *wkey_buf;
> > +     int ret;
> > +
> > +     wkey_buf = qcom_tzmem_alloc(__scm->mempool, wkey_size, GFP_KERNEL);
> > +     if (!wkey_buf)
> > +             return -ENOMEM;
> > +
> > +     secret_buf = qcom_tzmem_alloc(__scm->mempool, sw_secret_size, GFP_KERNEL);
> > +     if (!secret_buf) {
> > +             ret = -ENOMEM;
> > +             goto err_free_wrapped;
> > +     }
> > +
> > +     memcpy(wkey_buf, wkey, wkey_size);
> > +     desc.args[0] = qcom_tzmem_to_phys(wkey_buf);
> > +     desc.args[2] = qcom_tzmem_to_phys(secret_buf);
> > +
> > +     ret = qcom_scm_call(__scm->dev, &desc, NULL);
> > +     if (!ret)
> > +             memcpy(sw_secret, secret_buf, sw_secret_size);
> > +
> > +     memzero_explicit(secret_buf, sw_secret_size);
> > +     qcom_tzmem_free(secret_buf);
> > +
> > +err_free_wrapped:
> > +     memzero_explicit(wkey_buf, wkey_size);
> > +     qcom_tzmem_free(wkey_buf);
> __free(qcom_tzmem) attribute instead?
>

I second this. Please look at other implementations.

Bart

> Konrad
>
