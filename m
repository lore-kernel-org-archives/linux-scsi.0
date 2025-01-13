Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 479AD240232
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jan 2025 17:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736789717; cv=none; b=mVOc2Gt2cBQtrySDeo1sd2KHSVqRbj0gauE4fidct0qYQjzrAQXl64iOlOtR4fOxBs59ybPL4eYxNTSO2Bq2cTo5GChkmDFlnUNXiIr3fWs84BVpwiQqXcxgV1RnWZIjFR8gKzlUmp58v4aq/tcjCTDRPOZffC3etv/OunreV6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736789717; c=relaxed/simple;
	bh=CI5+IGgnYmbjhmrCVmHIxZJQFJJ21P57dYKX0FUhNNI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gfNj9tPuySC3bhwKT5/MgfkqsXq4n11rCpYVYT9hFVJNSGAuQg7PVuSuaFQwlQzLXpbJAyEOQ3oxkiDUSkASMYiyNPFYpGTK4I5kwFvZ6ocFEN1c9dhTIhVaWEOoEWUXa5y7ZCmGJnDVULs9n5uZWb5gKEzjpXu2cgLxRmkHOsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AqBGk6aT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AqBGk6aT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736789715;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dzKLqtRZ5aH02FElO8h5/wetXak3uKOHfIBugzNkgHs=;
	b=AqBGk6aTY7Qx51vJuS46lrL08IaNobfgvYnttFV8tNKI2rHj6GglQZPeg4JRxA8M301a6i
	juTwwRQ8Ej3OKO8YNFArCeYea2EXOTMKv8Rh9lLVVKc8kN30ATjDXZAToxvXW9JYcitlAw
	QWKyNNQP1lzbDqIVo/zxcwyzL2ynxE0=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-508-sOL-LWoUNpeLFJLxEboi3A-1; Mon,
 13 Jan 2025 12:35:09 -0500
X-MC-Unique: sOL-LWoUNpeLFJLxEboi3A-1
X-Mimecast-MFC-AGG-ID: sOL-LWoUNpeLFJLxEboi3A
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3C7611955DDD;
	Mon, 13 Jan 2025 17:35:07 +0000 (UTC)
Received: from [10.22.80.21] (unknown [10.22.80.21])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7418019560A3;
	Mon, 13 Jan 2025 17:35:04 +0000 (UTC)
Message-ID: <d18ed046-0d16-49d6-b666-8ef8ee20f6d2@redhat.com>
Date: Mon, 13 Jan 2025 12:35:03 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 07/15] scsi: fnic: Add and integrate support for FDMI
To: Dan Carpenter <dan.carpenter@linaro.org>,
 Karan Tilak Kumar <kartilak@cisco.com>
Cc: sebaddel@cisco.com, arulponn@cisco.com, djhawar@cisco.com,
 gcboffa@cisco.com, mkai2@cisco.com, satishkh@cisco.com, aeasi@cisco.com,
 jejb@linux.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>
References: <20241212020312.4786-1-kartilak@cisco.com>
 <20241212020312.4786-8-kartilak@cisco.com>
 <4141c9ab-c640-4765-a23c-c2f64df687cb@stanley.mountain>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <4141c9ab-c640-4765-a23c-c2f64df687cb@stanley.mountain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Just a note to say that these patches are important to Red Hat and we are actively engaged in back porting and testing these patches in to RHEL-9 and RHEL-10.

I think these issues that Dan has pointed out are all issues which can be addressed in a follow up patch.

/John

On 1/7/25 07:30, Dan Carpenter wrote:
> On Wed, Dec 11, 2024 at 06:03:04PM -0800, Karan Tilak Kumar wrote:
>> @@ -612,6 +615,7 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>>   	unsigned long flags;
>>   	int hwq;
>>   	char *desc, *subsys_desc;
>> +	int len;
> 
> Do not introduce unnecessary levels of indirection.  Get rid of this len
> variable.
> 
>>   
>>   	/*
>>   	 * Allocate SCSI Host and set up association between host,
>> @@ -646,9 +650,17 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>>   	fnic_stats_debugfs_init(fnic);
>>   
>>   	/* Find model name from PCIe subsys ID */
>> -	if (fnic_get_desc_by_devid(pdev, &desc, &subsys_desc) == 0)
>> +	if (fnic_get_desc_by_devid(pdev, &desc, &subsys_desc) == 0) {
>>   		dev_info(&fnic->pdev->dev, "Model: %s\n", subsys_desc);
>> -	else {
>> +
>> +		/* Update FDMI model */
> 
> This comment adds no information.  Delete it.
> 
>> +		fnic->subsys_desc_len = strlen(subsys_desc);
> 
> Keep in mind that strlen() does not count the NUL-terminator.
> 
>> +		len = ARRAY_SIZE(fnic->subsys_desc);
> 
> Use sizeof() when you are talking about bytes or chars.  For snprintf() and
> other string functions, it's always sizeof() and never ARRAY_SIZE().
> 
>> +		if (fnic->subsys_desc_len > len)
>> +			fnic->subsys_desc_len = len;
>> +		memcpy(fnic->subsys_desc, subsys_desc, fnic->subsys_desc_len);
> 
> So this is an 0-14 character buffer.  If fnic->subsys_desc_len is set to 14,
> then the string is not NUL terminated.  This is how the buffer is used in
> fdls_fdmi_register_hba()
> 
> 	strscpy_pad(data, fnic->subsys_desc, FNIC_FDMI_MODEL_LEN);
> 	data[FNIC_FDMI_MODEL_LEN - 1] = 0;
> 
> This suggests that fnic->subsys_desc is expected to be NUL-terminated.
> However FNIC_FDMI_MODEL_LEN is 12.  So in that case the last 3 characters
> are removed.  LOL.  It's harmless but so very annoying.
> 
> Also strscpy_pad() will ensure that data[FNIC_FDMI_MODEL_LEN - 1] is set
> to zero so that line could be deleted.
> 
> regards,
> dan carpenter
> 

