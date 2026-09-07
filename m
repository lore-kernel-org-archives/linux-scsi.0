Received: from mta0.migadu.com (out-148.mta0.migadu.com [91.218.175.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D2F4854E8
	for <linux-scsi@vger.kernel.org>; Mon,  7 Sep 2026 12:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788782487; cv=none; b=rdZCs7cTKXlI8nf5AMyoB9wwBE4oWDzwe5S0bL9SM6YJG6vdea5z5PscK8OpSnEbmwtMgXg/3PBdlKB6y1gF81JsmNBGoFgvGPFlvZqXJ8PWM+tNOGDsGZblQ91iDMd2fQC2sVD8vU3lcHO0GKu5C/2+z7DxqBF0BqzoaITvpfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788782487; c=relaxed/simple;
	bh=z/3vkkTkRnSgafbvWpZAGvt7Eu3p3LEtwTCDELgtGhs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EETnzD62RTVdJeSX6emhi8duTDTCmcdTKqMY4/eGCbPOCUfT01S58Ir8civW2BZTW53PChiBVkceH8gTEkgfbD9h8DAy/orHGkYwm/ekEJdtXMc1JbVyh4kTre0fT7r4MSZJyy+VZvOUD4DnJ22NmgOS6HgpHFAxEw4CNnn5iFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rZ3HCza/; arc=none smtp.client-ip=91.218.175.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rZ3HCza/"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=z/3vkkTkRnSgafbvWpZAGvt7Eu3p3LEtwTCDELgtGhs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788782483; v=1; x=1789387283;
 b=rZ3HCza/mKmuiRbf20nx47wx7z58tLHgxHpgujtBpo/jsXpTtSV54PCcj1gRetbEeNDpYYoC
 4ShHJBFk8vGaqUg6dOh1xQej484CHqY9siNH7k+SiNv7fx2kspOiiN1vdYOkfY2QOT8Btxyrboj
 RDHNN+z1b9rY19mTHr9HB3sE=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 77084fcb1395786a;
	Mon, 07 Sep 2026 12:01:22 +0000
X-Mizu-Trace-ID: 77084fcb1395786a
X-Migadu-Flow: FLOW_OUT
Message-ID: <fff22b8c-c795-45d4-a33b-2cd464d72316@linux.dev>
Date: Mon, 7 Sep 2026 13:01:16 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 06/27] libmultipath: Add delayed removal support
To: sashiko-reviews@lists.linux.dev, John Garry <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <20260907105021.1763236-1-john.g.garry@oracle.com>
 <20260907105021.1763236-7-john.g.garry@oracle.com>
 <20260907112327.7635E1F00A3A@smtp.kernel.org>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <20260907112327.7635E1F00A3A@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/7/26 12:23, sashiko-bot@kernel.org wrote:
>> +			const char *buf, size_t count)
>> +{
>> +	unsigned int sec;
>> +	ssize_t ret;
>> +
>> +	ret = kstrtouint(buf, 0, &sec);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	mutex_lock(&mpath_head->lock);
>> +	mpath_head->delayed_removal_secs = sec;
>> +	if (sec)
>> +		set_bit(MPATH_HEAD_QUEUE_IF_NO_PATH, &mpath_head->flags);
>> +	else
>> +		clear_bit(MPATH_HEAD_QUEUE_IF_NO_PATH, &mpath_head->flags);
>> +	mutex_unlock(&mpath_head->lock);
>> +
>> +	/*
>> +	 * Ensure that update to MPATH_HEAD_QUEUE_IF_NO_PATH is seen
>> +	 * by its reader.
>> +	 */
>> +	mpath_synchronize(mpath_head);
>> +
>> +	return count;
> [Severity: High]
> Does disabling delayed removal here leave pending I/Os stranded in the requeue
> list and fail to cancel the teardown timer?
> 
> If all paths go offline while delayed_removal_secs is non-zero, new I/Os
> are queued in requeue_list. If an administrator subsequently writes 0 to
> this sysfs attribute to disable delayed removal,
> mpath_delayed_removal_secs_store() in lib/multipath.c clears the
> MPATH_HEAD_QUEUE_IF_NO_PATH flag but does not call
> mpath_schedule_requeue_work() to flush existing stranded I/Os.
> 
> Additionally, it doesn't appear to cancel the pending remove_work timer,
> which might cause the device teardown to be arbitrarily delayed by the old
> timeout value rather than executing immediately upon user reconfiguration.
> Could these unhandled I/Os hang indefinitely?

Same response as v7:
https://lore.kernel.org/linux-scsi/a547bec0-3600-43f9-bb7b-0a644601a367@linux.dev/
