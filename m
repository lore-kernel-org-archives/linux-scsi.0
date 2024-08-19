Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7CB215E96
	for <linux-scsi@vger.kernel.org>; Mon, 19 Aug 2024 23:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724108726; cv=none; b=KLW6jQIzWk4P4jB+TeW2g6CFqQ9PiPGJlwmtVzraW2B/+z5FMWjjoJup6f1S95uCcZES3VSLRSDqi8LO5u3xnoXa6IeEdSzAkV8FpthOOQXhB3VCjPuPAvGIYvFJyPQTPWcRMs6bBnDq3Q75qWzGSSeiyQVhH0Y/7zcTzfwr+l4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724108726; c=relaxed/simple;
	bh=K2IQPV/ueTPiMl9ZdmUFwr2Rm3VC+33d/s5U5YRx8ZU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ciG6nCX+bBiZeaO1L6I5EDOMeHw16Dj8QsMKkyBRmAspHG9Penr5iszmDkIQ4yxGAm2Q7DiLWlDBq+oOVP0QLBgW3NQT0r+rHqxMeCN6sklSGmqgqut0CSwxNpEMvxCXiyPx7jG4Ai89K3dHyLOpx9RZzp1gNW+CVdI0Ry2Tobs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pc17x3nG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pc17x3nG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88295C32782;
	Mon, 19 Aug 2024 23:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724108725;
	bh=K2IQPV/ueTPiMl9ZdmUFwr2Rm3VC+33d/s5U5YRx8ZU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pc17x3nGIxjMDyt87qEyGBmRjgGK4jwFiw8Bzey5Kgb5FBVFg4WQmrWHE4hQDgQ2U
	 YTSCJwq0fQh+TkwxyjOZnAFVvTwtQbQ+XhYHF8Y0gylLGzrPL0l2JbwtkF0QjQSXun
	 6HWfwHchOrNX8J5dcfWVwNVucyQvhGiwA+oTbTojCpvzloeVoJOsFsJRSvuma/XYHt
	 gJGM2yTo2BSpTT/aJ0d4Evg4OPVFz+X4+x2gRSDM8W6K9adHyIfVlqSV6Zg3pjupqc
	 z7X8+eI5CqC5p3MtnTLBPT1hH+BHaphy2ygBNlFTyuvmAqNA/WyMzjgcgvW40Lpinu
	 00i73pAbIBtFg==
Message-ID: <61ee112d-5df1-4dc0-8929-e6b7f53d7f9b@kernel.org>
Date: Tue, 20 Aug 2024 08:05:23 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/18] scsi: mptfusion: Simplify the alloc*_workqueue()
 invocations
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
References: <20240816215605.36240-1-bvanassche@acm.org>
 <20240816215605.36240-3-bvanassche@acm.org>
 <c1d0468d-eaf0-46c2-ba62-846ffdae6993@kernel.org>
 <01880e15-56d6-432b-8441-974ef56935fe@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <01880e15-56d6-432b-8441-974ef56935fe@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/20/24 02:08, Bart Van Assche wrote:
> On 8/18/24 4:51 PM, Damien Le Moal wrote:
>> On 8/17/24 06:55, Bart Van Assche wrote:
>>> Let alloc*_workqueue() format the workqueue names instead of calling
>>> snprintf() explicitly.
>>>
>>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>>
>> In patch 1, you have all the changes for removing the use of
>> create_singlethread_workqueue() in a single patch, touching different drivers.
>> But the series has 17 more patches to further cleanup the workqueue API use in
>> various drivers. So why not have the changes in patch 1 split into these
>> different driver patches with a title like "Cleanup and simplify workqueue API
>> use" ? That would make reviewing easier I think and avoid having the patch 2-17
>> changing again code that was changed in patch 1...
> 
> Hi Damien,
> 
> Thanks for having taken a look at this patch series. Would splitting
> patch 01/18 really help? Splitting that patch would make the description
> of the split patches longer than the actual code changes. That might
> annoy other reviewers. Additionally, isn't typical that Coccinelle
> patches are applied tree-wide instead of one driver at a time? A few
> examples:
> * 795f90c6f13c ("sysctl: treewide: constify argument
>                   ctl_table_root::permissions(table)").
> * e8058a49e67f ("netlink: introduce type-checking attribute iteration").

I know about script-based patches. But in this case, the script generated patch
changes lines of code that following patches change again (not all of them
though). So I thought splitting patch 1 may be a good idea as that would as well
isolate driver changes in their own patches, which definitely should facilitate
reviewing by the driver maintainers.

But no strong feelings about all this. If you do not want to do that, fine.

> 
> Thanks,
> 
> Bart.
> 

-- 
Damien Le Moal
Western Digital Research

