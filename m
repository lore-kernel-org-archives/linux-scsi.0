Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B240353A88;
	Tue,  1 Sep 2026 14:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788271295; cv=none; b=DpSbLyI0i5Jb5ORL3Zz+RyU2Bo7rvCJ+Gj6tu+iQHzjFwOtDKd4B/ug28GspuGiX4U7P0IRn/OhgUUzpD24Tgaeo/dkntOqcHvA0p42qoNT2hkaJLTHXEMm6QASVrJz92463DsRd+mhuwiM8/XVcA08Otp0KJ1yvSZvx0vYUIQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788271295; c=relaxed/simple;
	bh=i0auOqviT7OdfQYFxKaGhvnbI3u48O1A/LNjWrh7uTA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=quN/Hxg/cWpcsgeWUOWK1tUt0640eMPIz6Ha0vqOGy6n8ipGoLAa2I/bE+ueBIHBQGbI7HajfRiZyHGJZfD+lxT4ndoCoWPBulWBb8E0aRZbE9w8vc0SLh1yHFdeZ/C5cVF/c+mF8ByRalz7TwZR6TVKO+tCDSsmv337vF0u/+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mzcQJWVk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mzcQJWVk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 233E01F000E9;
	Tue,  1 Sep 2026 14:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788271293;
	bh=82Y0DK4uWf3NpKC3fa3COeqgaTO2DjUIts3rlyJPJm0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mzcQJWVkxU+PXzv+ZtVeMmMdyZGweBL1BLmGKXl6+dqqSWRPFnQr+3Exr81nThINA
	 zNcfVHa/tD7uQYMe+01vEhvIBg+kXY6ZkwjNJQ8tbguSekArPbfRcV+bC/x5qouhPN
	 fOziTB2CQoWjNEkOBaq/fPYRc/Un767CKF5KI1Il2YklHz1qckNEgih+/MRgpCYjQQ
	 yrs+jr5c7MID8cWcami2udW3SJ1xZV0XGhY9huub0gObe9HkE/q7r4fkjkC5uKTXsB
	 3RXdVkwEkPFfFX2QbrVl5VVnXtVqLUkLH4AQcfpyTn/Q41Btf4gymoHmXF3NbgIyVU
	 RsoDR9GrrqxeQ==
Message-ID: <650ac172-312f-43a3-ab5f-82318796472d@kernel.org>
Date: Tue, 1 Sep 2026 16:01:20 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 03/11] soc: qcom: crypto_virt: add support for create,
 prepare and import keys
To: Linlin Zhang <linlin.zhang@oss.qualcomm.com>, ebiggers@kernel.org,
 axboe@kernel.dk, mst@redhat.com, jasowangio@gmail.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org,
 linux-block@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-scsi@vger.kernel.org, virtualization@lists.linux.dev,
 devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc: neeraj.soni@oss.qualcomm.com, gaurav.kashyap@oss.qualcomm.com,
 mani@kernel.org, andersson@kernel.org, konradybcio@kernel.org,
 bvanassche@acm.org, alim.akhtar@samsung.com, avri.altman@sandisk.com,
 stefanha@redhat.com, pbonzini@redhat.com, eperezma@redhat.com,
 xuanzhuo@linux.alibaba.com, linux-kernel@vger.kernel.org
References: <20260827160806.1295313-1-linlin.zhang@oss.qualcomm.com>
 <20260827160806.1295313-4-linlin.zhang@oss.qualcomm.com>
 <4594e3db-a8e3-4f8d-95c2-a4edcbc8ca7c@kernel.org>
 <40156974-6637-49b7-8629-11e7d0d4e55d@oss.qualcomm.com>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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
In-Reply-To: <40156974-6637-49b7-8629-11e7d0d4e55d@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 01/09/2026 12:31, Linlin Zhang wrote:
> 
> 
> On 8/31/2026 2:58 PM, Krzysztof Kozlowski wrote:
>> On 27/08/2026 18:07, Linlin Zhang wrote:
>>> +static void crypto_virt_remove(struct platform_device *pdev)
>>> +{
>>> +	virtblk_set_crypto_ops(NULL);
>>> +}
>>> +
>>> +static const struct of_device_id crypto_virt_of_match[] = {
>>> +	{ .compatible = "qcom,crypto-virt" },
>>
>> Undocumented ABI, also not really allowed. We don't take bindings for
>> drivers.
>>
> 
> The dt-binding document is included in another patch in this series.

And what does the submitting patches document ask you?


> The concern about introducing a DT binding for a software-only driver.
> The underlying problem I am trying to solve is how to communicate the
> wrapped-key size to the guest.

I am not asking about your problem. Can you please stop answering to
actual problems with irrelevant other aspects?

You cannot have DT for a driver.

That's it, please read DTS101 slides.


> 
> Because the guest has no access to the ICE hardware, it cannot get
> the key size by reading the ICE hardware directly. In the other hand,
> the wrapped key size may vary across ICE versions, it's infeasible
> to have a fixed wrapped key size in the code. Additionally, wrapped
> key size is vendor-specific, it's nor proper to pass it via virtio.
> 
> As an experiment, I used a DT property to set this wrapped key and
> wanted to get feedback on whether this is a reasonable approach.
> 
> Is there a preferred mechanism for handling this kind of vendor-specific
> configuration, or are there similar examples elsewhere in the kernel
> that I should follow?

Not DT. Use whatever other mechanism kernel provides.


> 
>>> +	{ }
>>> +};
>>> +MODULE_DEVICE_TABLE(of, crypto_virt_of_match);
>>> +
>>> +static struct platform_driver crypto_virt_driver = {
>>> +	.probe = crypto_virt_probe,
>>> +	.remove = crypto_virt_remove,
>>> +	.driver = {
>>> +		.name = "crypto_virt",
>>> +		.of_match_table = crypto_virt_of_match,
>>> +	},
>>> +};
>>> +
>>> +static int __init crypto_virt_init(void)
>>> +{
>>> +	return platform_driver_register(&crypto_virt_driver);
>>> +}
>>>  module_init(crypto_virt_init);
>>>  
>>>  #if IS_MODULE(CONFIG_QCOM_CRYPTO_VIRT)
>>>  static void __exit crypto_virt_exit(void)
>>>  {
>>> -	virtblk_set_crypto_ops(NULL);
>>> +	platform_driver_unregister(&crypto_virt_driver);
>>
>> You just added this line, so previous code was simply wrong?
> No. In previous patch, virtblk_set_crypto_ops is called in
> crypto_virt_init and crypto_virt_exit. This patch moves the caller
> to the driver probe and remove APIs.

Heh?

Let's look at your previous patch:

+#if IS_MODULE(CONFIG_QCOM_CRYPTO_VIRT)
+static void __exit crypto_virt_exit(void)
+{
+	virtblk_set_crypto_ops(NULL);
+}
+module_exit(crypto_virt_exit);
+#endif

And you claim that you did not add this line?

Do you understand how diff format works?

Best regards,
Krzysztof
