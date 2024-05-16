Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB57F14D451;
	Thu, 16 May 2024 16:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715875508; cv=none; b=LKIqBENruUtDYRkI1hdBf/vur84+ZzDIEngHux0pS9aOtXtGILEVfLRK6yonKDL+hPfUsKr6cp/XmW5g+sX7WqpfMeFPqawowEF/tFm+FOcQSqp5r5bCIzEd0jsX7sHP3KpES7nV6mfetm84upWOEq7GT7yaMlpJmROnDlFZ3cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715875508; c=relaxed/simple;
	bh=dkUWRF5CQj+qay0J1rvifZC7vv/X/i2/qQvVURLE4Zw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ko2rO4ikRga426D8moC47pViy6eOIasV05J7HAjk38OCUyoGlo1luvP3dsVCjqhGzeH0lO9MUqIvo+zcHtVaR4nBU0e8TH1T1/toGX03d1Kdm5vxwXbo/mlQSdFI2TDcvWGtNO5n6EwCXHIMNFa0GzBP0U/7+Eb/Ild0ZkoFCAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=CFreOHEb; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="CFreOHEb"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4VgFKr0xS2z6Cnk8t;
	Thu, 16 May 2024 16:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1715875501; x=1718467502; bh=Ho8ISs0QS8pcWo56eqDyveg7
	mCHU412H1CXWK7Dg6NQ=; b=CFreOHEbNlRZPZRCjRpsQ5wGjtUYNdUlBHUbEbrD
	NAxRXZV0mLg1hlK0nfNSc7yEpEtiH0SjFWU2O9rc0UuKtbh0vLF7VV+TXkZE6c83
	frjpuVQ45PTIvKw1YqBKPgBbj8W/kfwapMijNKU1YiXwH0Tx23WrP6xFh1A2sc1C
	oU9/O5XJNi/xBMMgrhU7yWufX+GXODDjZMqO743REA+Bfy7KDP2UfZlhgDafQDF5
	wxX2vGNOI8EHSdTnask+kvIAz6g9SXUqAd9XEgXbt5yUMIQA3p0yfeMHV8oMPWOf
	f0fPOzZiQnRWbbQ1GVFeKde5c5K3CrfKNvB9MXM7eJdy9Q==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id rbHg1KpeB0mj; Thu, 16 May 2024 16:05:01 +0000 (UTC)
Received: from [10.21.145.186] (unknown [65.132.165.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4VgFKl3htpz6Cnk8s;
	Thu, 16 May 2024 16:04:59 +0000 (UTC)
Message-ID: <1e3308ad-7bf7-4fb4-82fa-a2f63d464ef7@acm.org>
Date: Thu, 16 May 2024 10:04:56 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/3] scsi: ufs: Allow RTT negotiation
To: Avri Altman <Avri.Altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20240516055124.24490-1-avri.altman@wdc.com>
 <20240516055124.24490-2-avri.altman@wdc.com>
 <91e9322b-9304-4cb7-a1be-1f43208800e8@acm.org>
 <DM6PR04MB6575208AAB1E40C6EE91A815FCED2@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB6575208AAB1E40C6EE91A815FCED2@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/16/24 09:21, Avri Altman wrote:
>> On 5/15/24 23:51, Avri Altman wrote:
>>>    void ufshcd_fixup_dev_quirks(struct ufs_hba *hba,
>>>                             const struct ufs_dev_quirk *fixups)
>>>    {
>>> @@ -8278,6 +8312,8 @@ static int ufs_get_device_desc(struct ufs_hba *hba)
>>>        if (hba->ext_iid_sup)
>>>                ufshcd_ext_iid_probe(hba, desc_buf);
>>>
>>> +     ufshcd_rtt_set(hba, desc_buf);
>>> +
>>
>> Why does this call occur in ufs_get_device_desc()? ufshcd_rtt_set() sets
>> a device parameter. Shouldn't this call be moved one level up into
>> ufshcd_device_params_init()?
> Because otherwise bDeviceRTTCap is not available.
> Please note several device configuration calls in  ufs_get_device_desc - all requires some device descriptor fields.

Please make sure that the functionality of ufs_get_device_desc() and the 
name of that function remain in sync.

I think that bDeviceRTTCap is available in ufshcd_device_params_init()
after ufs_get_device_desc() has returned?

Thanks,

Bart.
