Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 671CB1FDE01;
	Thu, 14 Aug 2025 08:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755160369; cv=none; b=hkxMLBuFnROrYB8ZB/sVr3kAvKuay7+mq3pE5lacf1YXFpkfi5kJlm4u2cpqBKhwKshQURwIisti/PfAOPV7S/PCjsyr3opJUMgd4wfoMuMQlvqIWjoMYgPuR5+F0n/uFnLLU+zFayOpjjg3ez2UNNw14DQWGBWpgwrwTQJ/tUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755160369; c=relaxed/simple;
	bh=CTj/OAOnuOeAXS+cQFIh25xxtnkFn0gphsAQaGSDB+Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rZxUdutexFOPbOamAeFmFTcPiVRZL8JMIpCA414YDrTgPlUk83pRLzhMBZj+Vov3oOzBHONiSAFlPGsbOHg2L89jhDZvjqTkLrGXWkIQ6QzZK6/lL2ySNv0H90XvipIMgL3hyjsQw0HLZVdMd88c2g6pYT6clgu/YO+9f2LCMUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MS/1Dz62; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MS/1Dz62"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 393C2C4CEF4;
	Thu, 14 Aug 2025 08:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755160369;
	bh=CTj/OAOnuOeAXS+cQFIh25xxtnkFn0gphsAQaGSDB+Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MS/1Dz622v5JghavFxTeTGGEG6osbf3H/w9COEZXy8kFZhfbsXL+P0SFWS4aB9c74
	 PWGbzA3fWyTszeyqjeOeLtJT+3EdWrBXFvNZuggSa9HEmaxtsmYJ5E5+h3oh1qAXTz
	 Bqal6BG9Q207evq/iNyxCVnic3Fj5QRwCzeWMY6UrmZoDRY9BZOOtn9Ec8rdgmnrcR
	 f9nuaTvINz+gNVgGR+CYnbhJylGFzaBxB0t73w71IbMA/JkfFF5LV89FqCwwEydnNT
	 sRSMjrEmcC0Y4hCv1PIaIe2j+cxuntkV5MOFQdroGzu4dpyKAiz/QZ5yO7Co0KB93y
	 bIiX1ZflleEcQ==
Message-ID: <3365d638-2abf-4369-8087-d50376c0780e@kernel.org>
Date: Thu, 14 Aug 2025 17:30:06 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v23 01/16] block: Support block devices that preserve the
 order of write requests
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20250811200851.626402-1-bvanassche@acm.org>
 <20250811200851.626402-2-bvanassche@acm.org>
 <7570f60f-932b-4b76-a87d-8f3f0760c44f@kernel.org>
 <6b56a20a-3ff6-40c3-b165-2f3e4dfda45a@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <6b56a20a-3ff6-40c3-b165-2f3e4dfda45a@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/13/25 8:57 AM, Bart Van Assche wrote:
> On 8/11/25 7:12 PM, Damien Le Moal wrote:
>> On 8/12/25 5:08 AM, Bart Van Assche wrote:
>>> Some storage controllers preserve the request order per hardware queue.
>>> Some but not all device mapper drivers preserve the bio order. Introduce
>>> the feature flag BLK_FEAT_ORDERED_HWQ to allow block drivers and stacked
>>> drivers to indicate that the order of write commands is preserved per
>>> hardware queue and hence that serialization of writes per zone is not
>>> required if all pending writes are submitted to the same hardware queue.
>>> Add a sysfs attribute for controlling write pipelining support.
>>
>> Why ? Why would you want to disable write pipelining since it give better
>> performance ?
>>
>> The commit message also does not describe BLK_FEAT_PIPELINE_ZWR, but I think
>> this enable/disable flag is not needed.
> 
> Hi Damien,
> 
> Having a control in sysfs for enabling and disabling write pipelining is
> very convenient when measuring the performance impact of write
> pipelining. Adding such a control in each block driver would be
> cumbersome because it would require to add the following sequence in
> every block driver:
> * Freeze the request queue.
> * Call queue_limits_start_update().
> * Toggle the BLK_FEAT_ORDERED_HWQ flag.
> * Call queue_limits_commit_update_frozen().
> * Unfreeze the request queue.
> 
> Do you agree that this the "pipeline_zoned_writes" sysfs attribute is
> useful? If not, I will drop the newly introduced sysfs attribute and also the
> BLK_FEAT_PIPELINE_ZWR flag.

I do not think it is useful. All one needs to do to compare with & without is
to comment out one line in the driver that sets BLK_FEAT_ORDERED_HWQ. Sure that
needs a kernel recompile, but it is for debugging/evaluation, right ?
So I would not clutter the code with that feature.

-- 
Damien Le Moal
Western Digital Research
