Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67E174C14
	for <linux-scsi@vger.kernel.org>; Wed, 19 Jun 2024 07:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718781149; cv=none; b=i1rGltawvINbJeWrdByDDSB3we41JttWenvUXSPMETET2wBJEb33kXjwo3su+tE2dRad/4xU2brazJaI8f9EXqlypf/y90fVl1W03w4yTQ+lUBbbHWVTTuMvpTxB4n8UMWNYzIKyAXB2gb3+b007F2GG0U7ACIcgXj/Imp/y0gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718781149; c=relaxed/simple;
	bh=8W4LbrWm1kYw0GsZppHHivzVKYF4UoUJF3V4pnFaxRU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kB3whk3q3J9ppPO5trEoCTVq2Kag75nRP27ncU9i1VNs2yFSWlDryYQgZLTJ5f/6J5s6fWPZIkgEVo7ZPoxFNDyhNHw6o/gNiXepY0V22985PiFGWs5KVlPPo71mECZEwaXDcckFdO8+bYDn+oRFj9VhVWfwOaAqNpeqPrANQpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=A2n5ZnzA; arc=none smtp.client-ip=209.85.208.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="A2n5ZnzA"
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2ebf961e504so67887011fa.2
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jun 2024 00:12:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718781145; x=1719385945; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rNkt80zZ5bRZ67g3R3x+4enPR3S8kwJm33iEuDlFGnk=;
        b=A2n5ZnzARZlvW3uQmbTxuwOUg9R0C0RirylD22Hs3E3xYZ4u3ikwbQFexZBwqfHpHH
         X4QLBA4kDok5/hzmmA9joMgQMp1VMkF6QwHMIJtWdrjy38JQvFC+PDwdeUMV6mcCacKz
         LEa156GkvRRtnUA+eVurd/wgiSY2M627TZinJxIovYj/d1rU67pkarHEC1nUJYQ8IndW
         SuNmkaM/JX/1Or1FihQ5XQ+H+8Z8w3d4NFsnoHbkn3Uf4mzg9Q1zmIrP1jwI3+mJ1wPP
         hbOdKgDzRH9KmNg7PBTs5MpL1HvAfoJFggZmaXMOAlm87FMIMqCJb5KbTT2qZGBuMamx
         h3Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718781145; x=1719385945;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rNkt80zZ5bRZ67g3R3x+4enPR3S8kwJm33iEuDlFGnk=;
        b=CT3VgR+HhHzeMOUUiF2ftDj+o9o9ASbZW5FI6pupDP2wQw/WYsDFWH0Yt3IvVakv83
         FrktOGTOVz9DO/NkE7fTgi0nrsB8e3I7jZTjyQnuvOXTo7tWL/kaIm5wFiP//Lks4qKL
         8lj2WarJJ+Su/txeexh34pNV27rhoBk3VRQek0zzWeRcmjWLMUGbYl9wcqZuTWeE5Ugk
         lUCm0AqTVIsMkY6N096iNhHaFQWj+xYNsZkpz0YWIHAwrtWp7htW+lZoQ0G9DaXVbL6Y
         Uhihnvt+NTsN60kRJctUroHl7q8K4MJ/MrU+2GnY1W2qMa+JTSvDhW8TWoofjfEzmiKj
         7OPQ==
X-Forwarded-Encrypted: i=1; AJvYcCUNcRldqp/ooka9n6RYamoLVbved/wtG6pWxGiG3rXlAFsXPQ54qCD8Vr7O3pEKv/S44bu6ujPsJ4SiLuPQGeD07oofWumv2MwHTQ==
X-Gm-Message-State: AOJu0Yy3Wk1dORNYkXwBxYcmLlWKg7ZJG0pj51XezDXo/705EvqjV0ow
	0DvFTjFwBI2piJWgo4yLIPrHBXlQAgKUW9iMs5ITWwkAlxTGpvd+OSa1pQEVDwM=
X-Google-Smtp-Source: AGHT+IGldqIFYgyHuslG1CMTYyN0h1G1iCdYZZcpRlsRiqTgyMA+KWZnaXAKWv96mTUsoZGXaQFBlg==
X-Received: by 2002:a2e:9153:0:b0:2ec:17a9:ce95 with SMTP id 38308e7fff4ca-2ec3ce9a91cmr13378821fa.5.1718781144791;
        Wed, 19 Jun 2024 00:12:24 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:982:cbb0:cd29:2431:ff2f:880b? ([2a01:e0a:982:cbb0:cd29:2431:ff2f:880b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3607509c9absm16285621f8f.46.2024.06.19.00.12.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jun 2024 00:12:24 -0700 (PDT)
Message-ID: <22121526-c6c7-4667-af82-76725ad72888@linaro.org>
Date: Wed, 19 Jun 2024 09:12:21 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 04/15] soc: qcom: ice: add hwkm support in ice
To: "Gaurav Kashyap (QUIC)" <quic_gaurkash@quicinc.com>,
 "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "andersson@kernel.org" <andersson@kernel.org>,
 "ebiggers@google.com" <ebiggers@google.com>,
 "srinivas.kandagatla" <srinivas.kandagatla@linaro.org>,
 "krzysztof.kozlowski+dt@linaro.org" <krzysztof.kozlowski+dt@linaro.org>,
 "conor+dt@kernel.org" <conor+dt@kernel.org>,
 "robh+dt@kernel.org" <robh+dt@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
 kernel <kernel@quicinc.com>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
 "Om Prakash Singh (QUIC)" <quic_omprsing@quicinc.com>,
 "Bao D. Nguyen (QUIC)" <quic_nguyenb@quicinc.com>,
 "bartosz.golaszewski" <bartosz.golaszewski@linaro.org>,
 "konrad.dybcio@linaro.org" <konrad.dybcio@linaro.org>,
 "ulf.hansson@linaro.org" <ulf.hansson@linaro.org>,
 "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "mani@kernel.org" <mani@kernel.org>,
 "davem@davemloft.net" <davem@davemloft.net>,
 "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
 Prasad Sodagudi <psodagud@quicinc.com>, Sonal Gupta <sonalg@quicinc.com>
References: <20240617005825.1443206-1-quic_gaurkash@quicinc.com>
 <20240617005825.1443206-5-quic_gaurkash@quicinc.com>
 <ad7f22f5-21e4-4411-88f3-7daa448d2c83@linaro.org>
 <51a930fdf83146cb8a3e420a11f1252b@quicinc.com>
Content-Language: en-GB
From: Neil Armstrong <neil.armstrong@linaro.org>
In-Reply-To: <51a930fdf83146cb8a3e420a11f1252b@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Le 19/06/2024 à 00:08, Gaurav Kashyap (QUIC) a écrit :
> Hello Neil,
> 
> On 06/18/2024 12:14 AM PDT, Neil Armstrong wrote:
>> On 17/06/2024 02:50, Gaurav Kashyap wrote:
>>> Qualcomm's ICE (Inline Crypto Engine) contains a proprietary key
>>> management hardware called Hardware Key Manager (HWKM).
>>> This patch integrates HWKM support in ICE when it is available. HWKM
>>> primarily provides hardware wrapped key support where the ICE
>>> (storage) keys are not available in software and protected in
>>> hardware.
>>>
>>> When HWKM software support is not fully available (from Trustzone),
>>> there can be a scenario where the ICE hardware supports HWKM, but it
>>> cannot be used for wrapped keys. In this case, standard keys have to
>>> be used without using HWKM. Hence, providing a toggle controlled by a
>>> devicetree entry to use HWKM or not.
>>>
>>> Tested-by: Neil Armstrong <neil.armstrong@linaro.org>
>>> Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
>>> ---
>>>    drivers/soc/qcom/ice.c | 153
>> +++++++++++++++++++++++++++++++++++++++--
>>>    include/soc/qcom/ice.h |   1 +
>>>    2 files changed, 150 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/soc/qcom/ice.c b/drivers/soc/qcom/ice.c index
>>> 6f941d32fffb..d5e74cf2946b 100644
>>> --- a/drivers/soc/qcom/ice.c
>>> +++ b/drivers/soc/qcom/ice.c
>>> @@ -26,6 +26,40 @@
>>
>> <snip>
>>
>>> +
>>>    static struct qcom_ice *qcom_ice_create(struct device *dev,
>>>                                        void __iomem *base)
>>>    {
>>> @@ -239,6 +382,8 @@ static struct qcom_ice *qcom_ice_create(struct
>> device *dev,
>>>                engine->core_clk = devm_clk_get_enabled(dev, NULL);
>>>        if (IS_ERR(engine->core_clk))
>>>                return ERR_CAST(engine->core_clk);
>>> +     engine->use_hwkm = of_property_read_bool(dev->of_node,
>>> +                                              "qcom,ice-use-hwkm");
>>
>> Please drop this property and instead add an scm function calling:
>>
>> __qcom_scm_is_call_available(QCOM_SCM_SVC_ES,
>> QCOM_SCM_ES_DERIVE_SW_SECRET)
>>
>> like
>>
>> bool qcom_scm_derive_sw_secret_available(void)
>> {
>>          if (!__qcom_scm_is_call_available(__scm->dev, QCOM_SCM_SVC_ES,
>>                                            QCOM_SCM_ES_DERIVE_SW_SECRET))
>>                  return false;
>>
>>          return true;
>> }
>>
>> You may perhaps only call qcom_scm_derive_sw_secret_available() for
>> some ICE versions.
>>
>> Neil
> 
> The issue here is that for the same ICE version, based on the chipset,
> there might be different configurations.

So use a combination of a list of compatible strings + qcom_scm_derive_sw_secret_available()
to enable hwkm.

Neil

> 
> Is it acceptable to use the addressable size from DTSI instead?
> Meaning, if it 0x8000, it would take the legacy route, and only when it has been
> updated to 0x10000, we would use HWKM and wrapped keys.
> 
>>
>>>
>>>        if (!qcom_ice_check_supported(engine))
>>>                return ERR_PTR(-EOPNOTSUPP); diff --git
>>> a/include/soc/qcom/ice.h b/include/soc/qcom/ice.h index
>>> 9dd835dba2a7..1f52e82e3e1c 100644
>>> --- a/include/soc/qcom/ice.h
>>> +++ b/include/soc/qcom/ice.h
>>> @@ -34,5 +34,6 @@ int qcom_ice_program_key(struct qcom_ice *ice,
>>>                         const struct blk_crypto_key *bkey,
>>>                         u8 data_unit_size, int slot);
>>>    int qcom_ice_evict_key(struct qcom_ice *ice, int slot);
>>> +bool qcom_ice_hwkm_supported(struct qcom_ice *ice);
>>>    struct qcom_ice *of_qcom_ice_get(struct device *dev);
>>>    #endif /* __QCOM_ICE_H__ */
> 
> Regards,
> Gaurav

