Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB323C6BA;
	Mon, 19 Aug 2024 23:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724109590; cv=none; b=u+wCX0HnmZg1WopNv307ycWZTfbuyIU06U8bOSINwE6IgG5H3nvsokczd1NvRFL6v6eN0+D39+gYoIKNU5wnwNPHw5u0yUMovJClq1oPCnVyawoAwjQg+CmdgqX9A4gowPZhrmpgjmit7zAWDy1R9iK8RjkfwfT8VFM0h9WR+Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724109590; c=relaxed/simple;
	bh=2ImzkB7O8gai6HY2zXjwaPXhKiFOYPPvSz9lLmbAVWk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RLeoDyOLp7Qcp9+xtDlW0Belh7zzl93LvUD44hGPNbxT2C1f9GWTawl/65JvrmnIrzBtYKPXth+nYKty3dMDJZe+Hgy4BapHLEwdUau9+HAcKjFXUBGnWt2k9AJ/tAp4p+MDzrBKtUHicDbyabnBfKRCZ4saAbIJEFh2kYlKM2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s2OacVrr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s2OacVrr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E27B0C32782;
	Mon, 19 Aug 2024 23:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724109590;
	bh=2ImzkB7O8gai6HY2zXjwaPXhKiFOYPPvSz9lLmbAVWk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=s2OacVrrHPSbTJIubdGK4X8810FhXeVDlUGDRt9ZtkqZP0SFZ76sNnP2KWW0y9cVw
	 sQKbbIJj+x32z7qIqIMZ7vramllJr9fEXqgp5e4AXiDPT2nP7D1nbclYzDfAwAThnY
	 m8T49rIFEziT7R/H6GZEb2UNSgfZj1b4OZXqWJlkA2/qEmtW4b8a7BHqQ+BJG0uONY
	 UHMSc+X3utxOp+rDoWNJc6e1cVhNYIvg3vuW9dgftrl9bRWpQqKAIkesJmW4S2onZ1
	 U/bHWWB68rQe6vROUYjFWQhmyKB/bJn+VXtako67gQNrW8qUgch82WETSfnXXxQzh/
	 2MJHTq166Ka6w==
Message-ID: <c8a990c3-4b47-4e22-a378-8714c697748a@kernel.org>
Date: Tue, 20 Aug 2024 08:19:47 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] scsi: sd: Ignore command SYNC CACHE error if format in
 progress
To: Bart Van Assche <bvanassche@acm.org>, Yihang Li <liyihang9@huawei.com>,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linuxarm@huawei.com, prime.zeng@huawei.com, stable@vger.kernel.org
References: <20240819090934.2130592-1-liyihang9@huawei.com>
 <bfce098e-a070-40b1-95fc-951e2b3c1c22@acm.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <bfce098e-a070-40b1-95fc-951e2b3c1c22@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/20/24 01:59, Bart Van Assche wrote:
> On 8/19/24 2:09 AM, Yihang Li wrote:
>> +			if ((sshdr.asc == 0x04 && sshdr.ascq == 0x04) ||
> 
> Shouldn't symbolic names be introduced for these numeric constants?
> Although there is more code in the SCSI core that compares ASC / ASCQ
> values with numeric constants, I think we need symbolic names for these
> constants to make code like the above easier to read. There is already
> a header file for definitions that come directly from the SCSI standard
> and that is used by both SCSI initiator and SCSI target code:
> <scsi/scsi_proto.h>.

That would be *a lot* to define... So in keeping with the current practice of
using numerical values + comment documenting what the values are, it is why I
suggested the comment change above this also as the asc/ascq names for this are
added. It would be odd to have macros for just this asc/ascq here with so many
other places using numerical values...

Note: I personally find https://www.t10.org/lists/1spc-lst.htm more than enough
to work with the scsi code. If we have to define macros for all this, that would
be a lot of lines...

> 
> Thanks,
> 
> Bart.

-- 
Damien Le Moal
Western Digital Research

