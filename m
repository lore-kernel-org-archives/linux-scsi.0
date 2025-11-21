Received: from mx0.herbolt.com (mx0.herbolt.com [5.59.97.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17A02E041D
	for <linux-scsi@vger.kernel.org>; Fri, 21 Nov 2025 08:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=5.59.97.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763714077; cv=none; b=ZqguP6RBDaSmZfDupfKbcMybhFRTbNSjICf44E8w9uGJAsEm0q+1CnipLaDKdMZlOo5JQIc2TyzrJbWHGqgu6dXZ+K2SNNImMJCQ1rTatbb1ZjoIimxe2MFERGPebDbD06dnWYNE+qxJFw/VMk+NLb5QFCSkSib5WLcbauFudF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763714077; c=relaxed/simple;
	bh=ChhrlhPuBAkXwnrO86rWvbTay1oFtYhI1af43MlEVmg=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=Tyf+BgZ0pdwxrhMDb59MQjBo0kvfrD0UYB60tYGslEk1/3d5+6Ks5i3B6JAauzaxY0K9SnKav17nEOk74TUisfFdqNEgutl5yTpKcEe4aEgoJ/SGZuvVtRvbmYLJU8VlxhYgUllhrMkSWBh9bExY2pEPXQvFWeo0CCBr2OY590U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com; spf=pass smtp.mailfrom=herbolt.com; arc=none smtp.client-ip=5.59.97.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=herbolt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=herbolt.com
Received: from mx0.herbolt.com (localhost [127.0.0.1])
	by mx0.herbolt.com (Postfix) with ESMTP id C6B31180F2C0;
	Fri, 21 Nov 2025 09:34:25 +0100 (CET)
Received: from mail.herbolt.com ([172.168.31.10])
	by mx0.herbolt.com with ESMTPSA
	id bSi+LxEkIGkyWDwAKEJqOA
	(envelope-from <lukas@herbolt.com>); Fri, 21 Nov 2025 09:34:25 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 21 Nov 2025 09:34:25 +0100
From: lukas@herbolt.com
To: John Garry <john.g.garry@oracle.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
 James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/1] scsi: sd: Rounddown host->opt_sectors to logical
In-Reply-To: <4728a1b9-7282-4cd3-8a36-5d8f19bd1cc0@oracle.com>
References: <20251114102853.1476938-2-lukas@herbolt.com>
 <20251114102853.1476938-4-lukas@herbolt.com>
 <yq1ecpt9yqb.fsf@ca-mkp.ca.oracle.com>
 <4728a1b9-7282-4cd3-8a36-5d8f19bd1cc0@oracle.com>
Message-ID: <0bf87d8b077299841716ad55d7a35d77@herbolt.com>
X-Sender: lukas@herbolt.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit

On 2025-11-20 17:07, John Garry wrote:
> On 20/11/2025 03:26, Martin K. Petersen wrote:
>> 
>> Lukas,
>> 
>>> The host->opt_sectors are by default 512 bytes aligned if we have 4KN
>>> SAS disk reporting zero or smaller opt_xfer_block than the
>>> host->opt_sectors we will end up with unaligned queue_limit->io_opt.
>> 
>> I am intrigued wrt. which controller returns a host->opt_sectors that
>> would trigger this misalignment. What is the actual value reported?
>> 
>>> +	lim.io_opt = rounddown(lim.logical_block_size,
>>> +			sdp->host->opt_sectors << SECTOR_SHIFT);
>> 
>> Those parameters would need to be reversed, I think. You want to round
>> down opt_sectors and not the logical_block_size.
>> 
> 
> In blk_validate_limits(), we already round down lim.io_opt to physical 
> block size, and physical block size >= logical block size (so this 
> extra rounding down should not be required). What am I missing?


Right, I overlooked it. The problematic kernel I was running is before 
this patch
9c0ba14828d64744ccd195c610594ba254a1a9ab which is setting the lim.io_opt 
to the proper value.

Thanks for the help!
