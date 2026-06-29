Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 796F5273D9F
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2026 05:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782709397; cv=none; b=rqgfnUlXOgmgyC5NePUMUpGJjETaXZss/uEDmWb/If7tMo26XTAP3NJAr7ebstXR0WwdzudPLyTvhFcsmkjLMbxVONikcBGWUtN/P4tUgrQbfmBrxqDjFvFJVLDEDVWva/UNXfllnohvYic0IMpQrDCC7uzyLUEx+tBYX1+ufME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782709397; c=relaxed/simple;
	bh=90MwQ3mBO1cgWw4OHV4Im/jluGbP6MdaVU8Av/m96A0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ouBJWVtceWb4uEXkoq39VnROn0ZV+UtGCSO70460Yo1Fzycfv3LoA723MiB+cVOpjfBzaJ+ipdMmjDf7t/bDEkWS19373/D2AHlfu7JDGguKO6V+RlLWpM6Hv5EuwAnQiN3MuTrwOr4JFAvx6Yv2FwRE7GdvSg1YGo9IMzlct6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C4461F000E9;
	Mon, 29 Jun 2026 05:03:15 +0000 (UTC)
Message-ID: <0f973be4-aa0d-435c-82f1-edd3925cc926@kernel.org>
Date: Mon, 29 Jun 2026 14:03:03 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/4] scsi: sd: unify sd_probe() error cleanup through
 out_put
To: Yang Xiuwei <yangxiuwei@kylinos.cn>
Cc: James.Bottomley@HansenPartnership.com, hare@suse.de,
 linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
 p.raghav@samsung.com, sw.prabhu6@gmail.com, tom.leiming@gmail.com
References: <20260623100159.4018066-1-yangxiuwei@kylinos.cn>
 <20260623100159.4018066-3-yangxiuwei@kylinos.cn>
 <00c16485-fc4b-43bd-a420-89b3b5eebaeb@kernel.org>
 <20260629011653.2238665-1-yangxiuwei@kylinos.cn>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20260629011653.2238665-1-yangxiuwei@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/29/26 10:16 AM, Yang Xiuwei wrote:
> ---
> 
> Hi Damien,
> 
> On Sat, Jun 27, 2026 at 06:54:44AM +0900, Damien Le Moal wrote:
>> device_unregister() is called here and in the next error path too. So what about
>> a "goto out_unregister;" to avoid repeating this pattern ?
> 
> I tried that too, but out_unregister cannot fall through to out_free_index:
> scsi_disk_release() already calls ida_free(). So it needs a second
> goto out_put after unregister, which is why v1 kept the explicit paths.

Simple solution is best :) If changing the labels makes things more
complicated, then please feel free to ignore my comment.


-- 
Damien Le Moal
Western Digital Research
