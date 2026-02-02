Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DBC929BD89;
	Mon,  2 Feb 2026 07:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770018325; cv=none; b=dvnr0DnEO+b8eo7/vqfcDzV3kdSJM2RUgIKGsjs5tOOcFZ9dZJCdWiOl126yQYZrUDaiWWi1n4KPMUje2tpHwpQGhGAtmx1iuGu8L4hQe8yyswCUUZ+8fbZM20T0xvgzRnBXu/8DaKDU3lmohoi/Ns8h8gKi0wVANbVVd44aYco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770018325; c=relaxed/simple;
	bh=iYf1bf2NlQA4+CEabOZKDmLqt0oydgjjfjWLiXC30uc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SvYAGiYvCMNx+iv1TpG0STdz+1vLuFcJQp2OiXK3A/BcNMlV2C3yAE6aptQaQMo2HSzRxN1Njrj+znfPFVS87NZq39bICpiBtNU6JGhCQbsld//GmL8fLAz41o2dd20Uw1nIxRPc6JD3NIK9LMVtQ2c+bqDVgSY5/1wU2DWTOow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aDj4kqUw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aDj4kqUw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8579C19421;
	Mon,  2 Feb 2026 07:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770018325;
	bh=iYf1bf2NlQA4+CEabOZKDmLqt0oydgjjfjWLiXC30uc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=aDj4kqUwbfXLopWwHfgcSIcJIh19/nlyRQgfjAJKgKPbQ1r5PpM/OVht4uHJ+tdX7
	 GMrofUWKVTQrA1ZMtlC6uGkn/+wIFwM6h8O4QlXj3SjfmBUUbh0cEqojyKWOAFlHuL
	 LpnNeksCvTbNcH6jWVtySVh/x7nDYEJ45V2ditO4932R8DQl6aR0I1UTzRXyyfem/I
	 rXKOWohZZHk0TQyg4n+Ke4S1sZC1aQVjBfY1yXVEypDy7a6s7zFWJ70iRboovCrbun
	 96VD4MPzzQbJunsfmaHHSiRVebURmjc90PxPCEZf15GnTRpdPs3/gbTMx48aWOjRjq
	 jXpUiklYAxTSA==
Message-ID: <6abc7127-0591-4965-97d6-f034851309db@kernel.org>
Date: Mon, 2 Feb 2026 16:45:22 +0900
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
 <b4f3b1d7-45f7-49c4-ad16-e085d71e2d9b@kernel.org>
 <aYBT9ASycq4hA5U7@VM-209-93-tencentos>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <aYBT9ASycq4hA5U7@VM-209-93-tencentos>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/2/26 16:36, Chaohai Chen wrote:
> On Mon, Feb 02, 2026 at 10:21:43AM +0900, Damien Le Moal wrote:
>> On 1/31/26 20:19, Chaohai Chen wrote:
>>>>> +	 * We need to unlock before calling sas_unregister_dev() as it
>>>>> +	 * may sleep, but we hold a reference to prevent device removal.
>>>>
>>>> And why is that necessary ?
>>>>
>>> Because when unlocked, it is possible that the device has already been 
>>> released by another thread. If there is no reference count, it will lead
>>> to used after free.
>>
>> Please clearly explain the problem path. Your statements about "another thread"
>> is too vague.
>>
> 1.
> CPU 1: disco_q                          CPU 2: event_q
> ==============================          ==============================
> sas_discover_domain()                   sas_phye_loss_of_signal()
> 
> sas_ex_level_discovery()                sas_deform_port(phy, true)
> 
> list_for_each_entry(dev,                sas_unregister_domain_devices()
>   &port->dev_list, ...)
> 
> NOP                                     list_for_each_entry_safe_reverse(
>                                         dev, n, &port->dev_list, ...)
> 
> NOP                                     sas_unregister_dev(port, dev)
> 
> NOP                                     kfree(dev)
> 
> if (dev_is_expander(dev->dev_type))(UAF)
> ...
> > 2.
> CPU 1: disco_q                          CPU 2: event_q
> ==============================          ==============================
> sas_resume_devices()                    sas_porte_link_reset_err()
> 
> sas_resume_port()                       sas_deform_port(phy, true)
> 
> list_for_each_entry_safe(dev,           sas_unregister_domain_devices()
>   &port->dev_list, ...)
> 
> NOP                                     free dev
> 
> visit dev->ex_dev(UAF)

OK. Then add this to the commit message to make everything clear. Also, the
examples above are only for device removal, and given that
list_for_each_entry_safe() is safe against removals, that is likely the only
change needed (in case 1, disco_q side), together with a device get/put inside
the loop. Not sure that the spinlock to protect the list is actually needed.


-- 
Damien Le Moal
Western Digital Research
