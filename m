Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA25F19D092;
	Mon,  2 Feb 2026 01:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769995305; cv=none; b=i32xnYWddGfXEQKDcPNSEyhZM2kHpU0aGo/qYqhL+InzZFnlnM0hj+C0V41LusmBY+c2ScybRfI7/tch/nOm+v7fGyhAqJzru0x/lq6vyQNFyfp2BMMy8fzurQ+7GeWn7FAtJBFdbsWiJU0BgIsInE06SPzWmD0x5mzl400h7o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769995305; c=relaxed/simple;
	bh=mCK4jAurctXneO9NLzv7RMZBD5H3BIpLk3Fp60fsWxU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aZ8JkZbVTvDe0DO2rUakiAWDU2+0A0T10u//dWnmCoFtFjYZQZxowkbOpXuXlJ4PiZGpbs47jJWpvWqtWbIQYJL+ROvgwikX59zqNcVXV/9zCkzHUKbekEj3EImsZrski7NcPi5nHoQUYSu4AgfVlXnA0wDrg5nM6awwHoei6PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=klpxed5X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="klpxed5X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02974C4CEF7;
	Mon,  2 Feb 2026 01:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769995305;
	bh=mCK4jAurctXneO9NLzv7RMZBD5H3BIpLk3Fp60fsWxU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=klpxed5Xdavgeds3eRzynfyHMTTTXl5f1xLv1v8zb9GyelRdFc08i/w9pCcdIjx2z
	 7catgkmMruYIG/r891AILjUrqgNDpRQzC65jF1eKMKeBP/LxrMzjI53yYc0i3SwQ3/
	 YK6OwpL9k54Aew/q1gmw0pH0BCxWOeGiu3UrE7bFpe5jkieVOT/VxsF0t9jvvnVGGF
	 ECrcix4VvT2lX/Ou3F9AHoROCAepiFYXI+6tM4iAokFwf8fcO8IlJj1Ri6bzgFY7Cg
	 N80FqHo4A94W2DwmOGIkoraFVD4YnoM4QsxQ8q81VsN/7GcjAe0hfx05apbtNlsorQ
	 mLVn+HWFzASgA==
Message-ID: <b4f3b1d7-45f7-49c4-ad16-e085d71e2d9b@kernel.org>
Date: Mon, 2 Feb 2026 10:21:43 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: libsas: Fix dev_list race conditions with proper
 locking
To: Chaohai Chen <wdhh6@aliyun.com>
Cc: john.g.garry@oracle.com, yanaijie@huawei.com,
 James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
 johannes.thumshirn@wdc.com, mingo@kernel.org, cassel@kernel.org,
 tglx@kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260129093859.1418749-1-wdhh6@aliyun.com>
 <aa5ca682-ea38-49f6-81a1-6b154f00239d@kernel.org>
 <aX3lV4erBYL068PT@LAPTOP-RK2E6KJ3.localdomain>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <aX3lV4erBYL068PT@LAPTOP-RK2E6KJ3.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/31/26 20:19, Chaohai Chen wrote:
>>> +	 * We need to unlock before calling sas_unregister_dev() as it
>>> +	 * may sleep, but we hold a reference to prevent device removal.
>>
>> And why is that necessary ?
>>
> Because when unlocked, it is possible that the device has already been 
> released by another thread. If there is no reference count, it will lead
> to used after free.

Please clearly explain the problem path. Your statements about "another thread"
is too vague.

>>> +	 */
>>> +	spin_lock_irq(&port->dev_list_lock);
>>>  	list_for_each_entry_safe_reverse(dev, n, &port->dev_list, dev_list_node) {
>>>  		if (gone)
>>>  			set_bit(SAS_DEV_GONE, &dev->state);
>>> +		kref_get(&dev->kref);
>>> +		spin_unlock_irq(&port->dev_list_lock);
>>> +
>>>  		sas_unregister_dev(port, dev);
>>> +		sas_put_device(dev);
>>> +
>>> +		spin_lock_irq(&port->dev_list_lock);
>>>  	}
>>> +	spin_unlock_irq(&port->dev_list_lock);

-- 
Damien Le Moal
Western Digital Research
