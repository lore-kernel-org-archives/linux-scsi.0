Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C277A3988FE;
	Wed,  4 Mar 2026 09:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772617939; cv=none; b=UNTtQYjQ+jQc0bahhY6uGsMS2+Ckd9WazCXrUL4OjSmUVi3SBUm2U/Jx+nb+SjRv5EpaiqA90MjKhVqZIUnMd9QFbtM74xjEsCONk+FaRvdsUmQm+khRvV8zVQ69ul1A8/WKF3yDvJxF+c/f9MLShzRA7e6o2vgfCRPvYidm8mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772617939; c=relaxed/simple;
	bh=3uY/ZReqQuF/VaLAKNwfGyuwdnkEsCVU52pytEoQ8CY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N0EL23KN2oP499qsE5IhTIp5ngfBQ42BNTXNpq825vAc8qZKRyalz3w0AmXbkki36h0nXeh0Fvb/f5IwPMFUpkUsyPv2+eG4xqAjNV58arOT7IWFkHQkmRa+ODRW127i2t4GOq6q4xxXrP8pfmStY4utZ77NoWHcgXo9gNf1VaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aviDvS8+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aviDvS8+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3803FC19423;
	Wed,  4 Mar 2026 09:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772617939;
	bh=3uY/ZReqQuF/VaLAKNwfGyuwdnkEsCVU52pytEoQ8CY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=aviDvS8+cAwFW35VY4fUmcMNDkisZaDchfVzfAwWW/UcC7NRJ1GRP8PGeJn4Cnem8
	 SelB+ms63SLP9JrQNhe7zOltYCtDk7qsdycfPCQsoSvzMwqHRAMbSrktk0DEql4o83
	 CEx426o0bPhq1ayjaoazqcz6polxkg4DTdLLYvhs7KJK4WjaEGRVm42sr0zG1V58/G
	 i53KVeGa5NZW6VI1lTIZ/uPdJicpZNingWDIKx8ng8pq+p+z/Sg6iZAyGmXA6vocUR
	 EVFpEaNp8eBdIImKXx2lZHqTnqPuHPMUk2Ni+YkrFWtWNGPaQFZfHhBn5yO6IjA5Z6
	 7goQ4ZCVUpDUw==
Message-ID: <391b74b8-eb4b-4510-9cc8-3483f6605748@kernel.org>
Date: Wed, 4 Mar 2026 18:52:16 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: core: Fix async_scan race condition with
 READ_ONCE/WRITE_ONCE
To: Chaohai Chen <wdhh6@aliyun.com>, John Garry <john.g.garry@oracle.com>
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
 bvanassche@acm.org, hch@infradead.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260304075712.3039960-1-wdhh6@aliyun.com>
 <2885ac50-2326-4548-b92c-c5ae566a8013@oracle.com>
 <aaf+ucySU/sSN8WZ@VM-209-93-tencentos>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <aaf+ucySU/sSN8WZ@VM-209-93-tencentos>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/4/26 18:43, Chaohai Chen wrote:
> On Wed, Mar 04, 2026 at 09:20:25AM +0000, John Garry wrote:
>> On 04/03/2026 07:57, Chaohai Chen wrote:
>>> Previously, host_lock was used to prevent bit-set conflicts in async_scan,
>>> but this approach introduced naked reads in some code paths.
>>>
>>> Convert async_scan from a bitfield to a bool type to eliminate bit-level
>>> conflicts entirely. Use READ_ONCE() and WRITE_ONCE() to ensure proper
>>> memory ordering on Alpha and satisfy KCSAN requirements.
>>
>> Is the shost->scan_mutex always held when shost->async_scan is read/written?
>>
> Yes. In theory, there is no need for READ-ONCE/WRITE-ONCE. Plus, this belongs 
> to defensive programming. And it indicates that this is a shared variable, 
> which means that this variable will be accessed by multiple threads and 
> concurrency issues need to be handled carefully.

If the scan_mutex is always held when scan_mutex is used, there will not be
multiple threads, unless there are accessed also from IRQ context, which would
be odd. So I am not sure what concurrency issue you are referring to here.


-- 
Damien Le Moal
Western Digital Research
