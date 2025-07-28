Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2117C225785
	for <linux-scsi@vger.kernel.org>; Mon, 28 Jul 2025 09:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753696496; cv=none; b=W7hWQqkeDCa7E8xAnbvizl/by936J1lrW7yK7Xt3aokvZLmwGMceEKW0g1nckEBXBhQohCebfv/STcDa3cIyA7sWRkNXN5pGzP2Gc6ZmtOFs40SgNwLDg9OjOpZWpJQ+OEXBvifx642acqbfUnxUD3OkuQy1U9uPnYbxb4F3YQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753696496; c=relaxed/simple;
	bh=iXFkx9kWWq8YJ1ADUO3aYC1Yfgg4gOEdSxNwTdx13D0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=kG89VFrs/Fft57nwzTcnoVvwSSC3LaOeLZ6s+wXHT6GaUekesDhIoazBLydSVJMX6l3R7QAYxdqhOYqO6ZfyLp92rmsOviCrteTQzwtyiKSmp88akX2186Yxz95QSuYgXmzEhbH1d/ud4/WzCynBG5LVfxf+9RshHrPUDY6t0Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RnV2ZV2u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RnV2ZV2u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47518C4CEE7;
	Mon, 28 Jul 2025 09:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753696495;
	bh=iXFkx9kWWq8YJ1ADUO3aYC1Yfgg4gOEdSxNwTdx13D0=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=RnV2ZV2uFataDm+EoIKLcrlLfy9APjVB0JNWr/uAWYzXc19a4ra/ZTa4/5k2Ju6B2
	 iphbnaNuzy9LXHECHeJYi2Fa/VUyTkztd8CR3nF5lMrtA+aOY74krvB7lv2aumTLRy
	 WO6ADKngwfSGOVqSx0Lkjf8YUjPr2m1GvMv6FmBS1KoPu0zjulYZHc7PIS44LckaRh
	 YC3IyjAhIir0WC+GsxqS4Jrmr2JBd9miSl1xQ/bnOXDMW0vOxNvSxVoVud6mO22FpH
	 WbTMXbAMFLu60Iw/lVtDmbLVo5TGxAfHNy3c0kbvP5IDbDt1OE3P8AIpnq51bV67/c
	 J85tPYMZLiuHw==
Message-ID: <9b997705-c758-44bc-bb7c-60039304cc03@kernel.org>
Date: Mon, 28 Jul 2025 18:52:25 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: Correct sysfs attributes access rights
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org
References: <20250728041700.76660-1-dlemoal@kernel.org>
 <d3d6659e-dfff-4f4f-ad3b-afe053fe736d@oracle.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <d3d6659e-dfff-4f4f-ad3b-afe053fe736d@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/28/25 6:40 PM, John Garry wrote:
> On 28/07/2025 05:17, Damien Le Moal wrote:
>> The scsi sysfs attributes "supported_mode" and "active_mode" do not
>> define a store method and thus cannot be modified. Correct the
>> DEVICE_ATTR() call for these two attributes to not include S_IWUSR to
>> allow write access as they are read-only.
>>
>> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> 
> Reviewed-by: John Garry <john.g.garry@oracle.com>
> 
> Note that class_attr_store() returns -EIO for no store method. Does the same
> happen after this change?

The regular Permission Denied (-EPERM) is returned.
Do you think that is a problem ?

-- 
Damien Le Moal
Western Digital Research
