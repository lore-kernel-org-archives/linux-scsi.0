Received: from mta1.migadu.com (out-48.mta1.migadu.com [95.215.58.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08EEE39EF1C
	for <linux-scsi@vger.kernel.org>; Wed,  2 Sep 2026 08:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788337323; cv=none; b=TeMfaaCYKx4G495eSkBainT7ob4gpd5PnUqDQfmNh4qfeHjOqA5uRXjR83yrN2eZBM+8bgYjztG6Dhu1DQ3s92TRDOJXrMIYlWO+wSAD0kjK5mu8Oc7Q0Lx/A7tOWVLL4qtXEWDFnyOUqo5r/uhvVe+bF8fO+m4uPq3NWrKhUEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788337323; c=relaxed/simple;
	bh=gm/xQDsQxKOZBBK9seZtbMMtrzHqjNEJgInmHyK6/F0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lm40mSGSPflbwTehKPghR968Xy+5wkPbJRxtzbG/G1b2mr0sdZn6u5g+RQRJLNufwxGJOTE3YFzzYvH/2AapeBUJyOQFyFbb0so58Khr2lWK/enb/AnihQ33I1Q0on0or2Po9milqOWNRqVfu/BcjYmLUFwlBkd2jraSaynyVZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ncuzX+7B; arc=none smtp.client-ip=95.215.58.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ncuzX+7B"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=gm/xQDsQxKOZBBK9seZtbMMtrzHqjNEJgInmHyK6/F0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788337320; v=1; x=1788942120;
 b=ncuzX+7B+tk4pU7LHfzxBzUH0/t27ido7Dl57dA4zeygiz9M/Wrn8Dnebxvm+q3ySpx5Nyz4
 +24A3vU9azLI11NyuzfU8qp15j+9AzGhcp6uuUHsvLR/2GodQXpSnd6KFZ6Es8+ffNu70dn3yut
 dor2eZMF64amtnSxJhtAltyg=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id fa7baee0f8231f62;
	Wed, 02 Sep 2026 08:22:00 +0000
X-Mizu-Trace-ID: fa7baee0f8231f62
X-Migadu-Flow: FLOW_OUT
Message-ID: <7687de74-0543-4729-9427-e1cafd4eb105@linux.dev>
Date: Wed, 2 Sep 2026 09:21:56 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: core: Rework the DEF_SCSI_QCMD() implementation
To: Bart Van Assche <bvanassche@acm.org>, John Garry
 <john.g.garry@oracle.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
References: <7d904551041c58fd2cda31f82cf3e7b246e6550a.1788214709.git.bvanassche@acm.org>
 <b003c0c1-ba99-403d-b3c9-3670dd7d027c@oracle.com>
 <fc05556d-e81f-4039-b62a-d8327bcf6d5b@acm.org>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <fc05556d-e81f-4039-b62a-d8327bcf6d5b@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/1/26 19:17, Bart Van Assche wrote:
> On 9/1/26 1:04 AM, John Garry wrote:
>> On 31/08/2026 23:19, Bart Van Assche wrote:
>>> In DEF_SCSI_QCMD(), make the following changes:
>>>    - Assign cmd->device->host to shost because func_name##_lck()
>>>      implementations will be annotated with
>>>      __must_hold(&cmd->device->host->host_lock). This change prepares 
>>> for
>>
>> Why not annotate with __must_hold(&host->host_lock)? That is what we 
>> do in scsi_host_set_state().
> 
> Because the host pointer is not in the argument list of functions like
> blogic_qcmd_lck(). 

Yes, silly me.

> Do you perhaps want me to pass the SCSI host pointer
> as an argument to blogic_qcmd_lck()? This could be done by open-coding
> DEF_SCSI_QCMD() in the BusLogic driver.

How would that look? All users of DEF_SCSI_QCMD would need a similar 
change, right?
