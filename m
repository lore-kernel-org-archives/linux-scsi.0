Received: from mta1.migadu.com (out-104.mta1.migadu.com [95.215.58.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51823DDDCD
	for <linux-scsi@vger.kernel.org>; Fri,  4 Sep 2026 08:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.104
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788510995; cv=none; b=LTfsyHKDeYrrnsF8Iem6jopRs7zTULteXYiAQidbuM2y5prgafai8Y3Qu2mqUY/s06GLh9dkDN5BdUItCherxIFtktcqa7PuaFc/CU+QehpHe60kjKwAc+E8KGmQsL/T6+jcqf5aaBJpwzaBTfyuGp6PHu/0/Oj9CEpYBAO/5Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788510995; c=relaxed/simple;
	bh=IVLbRLCx4Q0XPXap6OtIn7AxAj+LX76/Uy2RZT40m4c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kPbgibzZmWh//crV1I64SDZe4Sj9Mgf05sT2Q99RPYOGSCnqZvobUK0fRXdkAIaOrtAlpvlJOA9ZFtKPowCGHgUzpiwzyTNTqwSewmUpNIHetBayr92zcUYBqGMsqdVkeem3FYQHZSyz/i2MPpAwKbq4tuBpOOdvx1far8NpzNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FDmP4pud; arc=none smtp.client-ip=95.215.58.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FDmP4pud"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=IVLbRLCx4Q0XPXap6OtIn7AxAj+LX76/Uy2RZT40m4c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788510991; v=1; x=1789115791;
 b=FDmP4pudRjPcpTUgiuMgt+1U5QBWkrZ36/0fPuA6EmlfpgjNpyO+SjTsm3ZgxMyQQZNvyTBE
 jQkk5ckUWD6EKNuFUzFF8aPrao0KjSr90bm271eG+5pWG5uwipJI24Bl2mQar0bYL4YQ6WX41wB
 kWmXS8YsUjooxMOFJicGPMsQ=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id dd65a384587b5704;
	Fri, 04 Sep 2026 08:36:31 +0000
X-Mizu-Trace-ID: dd65a384587b5704
X-Migadu-Flow: FLOW_OUT
Message-ID: <8711ac85-f3da-464d-b46e-24425e41ab72@linux.dev>
Date: Fri, 4 Sep 2026 09:36:30 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 01/27] libmultipath: Add initial framework
To: sashiko-reviews@lists.linux.dev, John Garry <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <20260901104526.3850621-1-john.g.garry@oracle.com>
 <20260901104526.3850621-2-john.g.garry@oracle.com>
 <20260901110300.DC23F1F000E9@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <20260901110300.DC23F1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/1/26 12:03, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] Missing synchronize_srcu() before cleanup_srcu_struct() in mpath_head_uninit() leads to SRCU leaks and use-after-free.
> --
> 
> commit 6f039c958c0ecba8ea01ef606d22d9dd4d06104b
> Author: John Garry <john.garry@linux.dev>
> 
> libmultipath: Add initial framework
>      
> This commit adds an initial framework for libmultipath, a library for
> multipath-capable block drivers. It introduces basic support to add and
> remove the mpath_head structure, which manages available paths and path
> selection.
> 
>> diff --git a/lib/multipath.c b/lib/multipath.c
>> new file mode 100644
>> index 0000000000000..f7b26c66eac7c
>> --- /dev/null
>> +++ b/lib/multipath.c
>> @@ -0,0 +1,67 @@
> [ ... ]
>> +void mpath_head_uninit(struct mpath_head *mpath_head)
>> +{
>> +	refcount_t *refcount = &mpath_head->refcount;
>> +
>> +	if (!refcount_dec_and_test(refcount))
>> +		wait_var_event(refcount, !refcount_read(refcount));
>> +	cleanup_srcu_struct(&mpath_head->srcu);
> 
> [Severity: High]
> Is it possible we need a synchronize_srcu() call before cleanup_srcu_struct()
> in mpath_head_uninit()?

synchronize_srcu() is called per-path as that path is removed - see 
sd_mpath_remove(). When all paths are gone, then mpath_head_uninit() 
would be called.

> 
> Active SRCU readers could trigger a WARN_ON(srcu_readers_active(ssp)) in
> cleanup_srcu_struct(), resulting in an SRCU leak. More critically, when the
> memory containing mpath_head is subsequently freed by the caller, any
> still-executing SRCU readers will experience a use-after-free crash when they
> call srcu_read_unlock() or access mpath_head fields.
> 
> During device removal, mpath_head_uninit() waits for mpath_head->refcount to
> reach 0. However, SRCU read-side critical sections do not increment this base
> refcount to maintain lockless fast-paths. Furthermore, del_gendisk() for
> bio-based queues does not automatically freeze the queue or wait for
> q_usage_counter to drain active submit_bio calls. Thus, cleanup_srcu_struct()
> might be called while readers are still executing.
> 
>> +}
>> +EXPORT_SYMBOL_GPL(mpath_head_uninit);
> 

