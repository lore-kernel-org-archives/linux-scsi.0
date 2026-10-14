Received: from mta0.migadu.com (out-210.mta0.migadu.com [91.218.175.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E133841C2F2
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 12:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.210
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791980317; cv=none; b=NKPHyzmBP0MdKSC4ty7yUBk8wR7wqdb6waIy3UgqQ9rZ3V30keE/GI4fY7ZRs7myDoL7NqOGPx36JfLDIw6R1GC+safdMA5IDP4QVooN0gQU0ixewF0nCwpQXfX2cLOMXlCf/xm0ZfAaxTovjfIc/O/3kLleqT+Nkwl0JbFtNFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791980317; c=relaxed/simple;
	bh=epxOBuojfAEGBJOX5236uAg0yXfK5UUnnWkEkz0tIRM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IW7/2BzCkQYhnFRbTkrrBUOHObPhnuiocUIYJrVXObZjbAqlsVMt+EiqI3/KFNRflkHXR125ZnsJdibvD4pLl5JYxnmpnHOKFtZc4Ex3qAn16bynRwK0hZISH8v/czld9E9b9mXWiszaDG2+02u2uWfp9NtTKK7I3udU+X/DGAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vLAoH4+n; arc=none smtp.client-ip=91.218.175.210
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vLAoH4+n"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=epxOBuojfAEGBJOX5236uAg0yXfK5UUnnWkEkz0tIRM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791980311; v=1; x=1792585111;
 b=vLAoH4+nc84ay/n2UPu8MNMP/A7wX1/R6ddCSgohs3z+JBmHaJbGbtK/GHDVmh93DxZZ1pTu
 ysAtIUKIzoeOtHuO0d774zbM2RWbYEOh3gPBiX5+FSyqXxTOoT8XSKPiXk/2Q7vhImAjPT4e1RZ
 FXo1lbojVTzGU+bdzJ2edGog=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id 2f5f8524ab26ce5d;
	Wed, 14 Oct 2026 12:18:31 +0000
X-Mizu-Trace-ID: 2f5f8524ab26ce5d
X-Migadu-Flow: FLOW_OUT
Message-ID: <a114aeca-8e9f-4353-9dd3-9ce077f6fba4@linux.dev>
Date: Wed, 14 Oct 2026 13:18:31 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] scsi: libsas: Fix SMP IO deadlock during HA resume
To: yangxingui <yangxingui@huawei.com>, yanaijie@huawei.com,
 jejb@linux.ibm.com, mkp@kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linuxarm@huawei.com, liuyonglong@huawei.com, kangfenglong@huawei.com
References: <20260928040234.992912-1-yangxingui@huawei.com>
 <820657c2-1cbd-47d8-92f2-477531692135@linux.dev>
 <ba5d9188-937c-237c-e104-9b66e7c3be3e@huawei.com>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <ba5d9188-937c-237c-e104-9b66e7c3be3e@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/8/26 04:11, yangxingui wrote:
>>> Fixes: 3dbbbf656b850 ("scsi: libsas: Fix HA resume deadlock and 
>>> hisi_sas disk-wake race")
>>> Signed-off-by: Xingui Yang <yangxingui@huawei.com>
>>
>> Question: do you have a (non-hisi_sas) SAS HBA card whose driver uses 
>> libsas? pm8001 would be such an example. It would be nice to verify 
>> that all these and other non-rpm libsas changes does cause regression 
>> there.
> 
> We don't have a pm8001 card at hand. From analysis the patch is a
> no-op for the LLDDs without runtime PM support: pm8001 and isci

It would be good if you could get another card whose driver uses libsas 
to verify these and any changes.

Anyway, the patch looks ok, so:

Reviewed-by: John Garry <john.garry@linux.dev>
