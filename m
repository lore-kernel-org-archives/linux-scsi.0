Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F4D1A38C1
	for <linux-scsi@vger.kernel.org>; Wed, 28 Aug 2024 17:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724864753; cv=none; b=b8HKj7PqxFxRMRKOiHvp2JUBBdgD0FWRirtMPzDLsd8aUxdNwM6hheuLyu8KSOzCrduTfMlvZ0MrbwPjpscV/pfPILTj7cztJ3Qoe8IXFrsDjc8qhUm/YpZVTJPN3NcpceTFRXAvIIf3frY3HvTTzGBIHRufAgxh20+Ffqf8fDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724864753; c=relaxed/simple;
	bh=WsKepGWNcEVJ1xgYiSclR0z9JHDJKLRZsKxjyQUSSz0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LfmZ4v7A5P+kN6Jxet74IvgWh5VvwWIiBMA9Uj3jEK3rbdhQ4U27SHhY5+kq5KygT/FI+6OzcpaBYYJrDNG6CVtfE1HyYJVLQm+Gqm6+kWmID0wnF1TSx2DUHVqZIRid5CZKJm6KnYuN4WoLr7gzKTb9fg0DUSiW67M6jbLOBRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=rWDncRCL; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="rWDncRCL"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Wv9ly5yfHz6ClY9H;
	Wed, 28 Aug 2024 17:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1724864748; x=1727456749; bh=MoGxbjwoamB7lZlFcvJBzqg4
	/6QosSBx1G3q1JhFlwI=; b=rWDncRCL1aFbHtwnE83AfxL2j5r2IH/hqUA6pArC
	eqnOwlzDMekZdviDXYKpZWekIr7QhZC6nGBxJCX74NvONW/rRPlUWFY4nUjlVQAq
	BEc24G9Foi5oSzIxugNYjSw8hoyMws+mIw0R2XCHkNBj2A+1bo6qRE6zsmGu5lBY
	ePCC8xH+P+ZyjBt5glH2D0fENrocskFAamfwbZzFxNFr6Bawr6vuKDxKPmjrykiZ
	bBeD0sG0PZgIeExe4zXOS9mdmEkKPVIQZ1pI41j2o879F/7+u/S1UOebr2keFh/a
	tfUrBtWT5kwNZkwONd+LVMch04ibURGMi51Pe9C0RmAokA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id WubCImdKkour; Wed, 28 Aug 2024 17:05:48 +0000 (UTC)
Received: from [172.16.58.82] (modemcable170.180-37-24.static.videotron.ca [24.37.180.170])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Wv9lt11tYz6ClY9F;
	Wed, 28 Aug 2024 17:05:45 +0000 (UTC)
Message-ID: <d3065aea-1ca2-4f45-bd50-9b41a1cfd1b7@acm.org>
Date: Wed, 28 Aug 2024 13:05:43 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/9] ufs: core: Introduce ufshcd_post_device_init()
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Peter Wang <peter.wang@mediatek.com>, Avri Altman <avri.altman@wdc.com>,
 Andrew Halaney <ahalaney@redhat.com>, Bean Huo <beanhuo@micron.com>
References: <20240822213645.1125016-1-bvanassche@acm.org>
 <20240822213645.1125016-4-bvanassche@acm.org>
 <20240825051628.j2qj54cnhrshj3b4@thinkpad>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240825051628.j2qj54cnhrshj3b4@thinkpad>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/25/24 1:16 AM, Manivannan Sadhasivam wrote:
> On Thu, Aug 22, 2024 at 02:36:04PM -0700, Bart Van Assche wrote:
>> +static int ufshcd_post_device_init(struct ufs_hba *hba)
>> +{
>> +	int ret;
>> +
>> +	ufshcd_tune_unipro_params(hba);
>> +
>> +	/* UFS device is also active now */
>> +	ufshcd_set_ufs_dev_active(hba);
>> +	ufshcd_force_reset_auto_bkops(hba);
>> +
>> +	ufshcd_set_timestamp_attr(hba);
>> +	schedule_delayed_work(&hba->ufs_rtc_update_work,
>> +			      msecs_to_jiffies(UFS_RTC_UPDATE_INTERVAL_MS));
>> +
>> +	if (!hba->max_pwr_info.is_valid)
>> +		return 0;
>> +
>> +	/* Gear up to HS gear. */
> 
> Maybe this comment now belongs above ufshcd_config_pwr_mode()?

Hi Manivannan,

Thanks for the feedback. I will move that comment.

Bart.
