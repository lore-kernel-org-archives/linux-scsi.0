Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699978F4A;
	Thu, 11 Sep 2025 17:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757612245; cv=none; b=G00w2HhTW5IdfzwZvPkaqBsW0H2wzgCfDqCe4woaazZvcK3anFnumzY9cG6IIoAwkGCOOoqqTvh32b92ctYc6b5zO7kgE00Zz+sWrQVaBB+Q/vGVp0QC9ISGz+MsIhfrAHcld82MNfuWfOqX+GulhwEc/9gcErbMSsE9fP1pmYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757612245; c=relaxed/simple;
	bh=iCKOQgzTM+f6v185z6tPloY/PSMpZ/tPiCdc71DfVWA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HzgfDWwZbvMca9y2USap+YfZ7Cz6ujuvDEteXbfEc7koEpus9kBWfZxU2GMYK2tVxgWb8ESuWnQiAAUprrNBz4BdztVsg83th8LqYVMUwz5osB20qYtQbbC3au7uHXv2bYL+Tk5P0zTldVnNdVCfpGsWqb41yrWArEtM/xp2nuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=X1/l1YkV; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="X1/l1YkV"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cN4WJ4zvjzlgqV0;
	Thu, 11 Sep 2025 17:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1757612234; x=1760204235; bh=fqboVfhzysRBmiVevqdbN2cF
	2Ov3HPp4z2+i2opY8dE=; b=X1/l1YkVA/M6GzTQY0eqZsBxEVmQuDKpqDTdvgHp
	Cc1QLJomcKVRqegrA8j5oOjMfMvs0q06LftkpgXuOSYRdlAyuxM7+vOwXv5htlQH
	AaH1psfnXYqgeIKYrhmRaYz+9tdjMcYsFhT2bUmbqm7CekdJ6PA/JxUrjhYu6f4G
	ryV+BxrsHSiR1ks6Wwlt+nfsjBSpHR9Q8U++oikEZx2JjVd4CeGU8xnaDdmcWNar
	LaggvY0ghzGD3UXsEUUdKlGOdqzcrGsGd7d2aF0VJJeD2xaH/7Qcvwz3xleJzZEt
	IyWqaAvV3L6KUS+uTeYDriqbzXu/5nrhD01V2TLPVi1+Qg==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ZxFS2dDb8wVJ; Thu, 11 Sep 2025 17:37:14 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cN4WB1DWNzlgqV1;
	Thu, 11 Sep 2025 17:37:09 +0000 (UTC)
Message-ID: <0c056e23-59c7-4125-8cd6-1e22ceaadea4@acm.org>
Date: Thu, 11 Sep 2025 10:37:08 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] scsi: core: Improve IOPS in case of host-wide tags
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
 Ming Lei <ming.lei@redhat.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250910213254.1215318-1-bvanassche@acm.org>
 <20250910213254.1215318-4-bvanassche@acm.org>
 <a28d07ef-34a9-41ed-bd4b-ddcbf3de13f4@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <a28d07ef-34a9-41ed-bd4b-ddcbf3de13f4@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/11/25 1:15 AM, John Garry wrote:
> this can race with a call to scsi_change_queue_depth() (which may free 
> sdev->budget_map.map), right?
> 
> scsi_change_queue_depth() does not seem to do any queue freezing.

Hi John,

Are there any SCSI devices left about which we care and for which queue
depth tracking is important?

scsi_change_queue_depth() can be called from interrupt context as
follows:

LLD completion interrupt
   scsi_done()
     scsi_done_internal()
       blk_mq_complete_request()
         scsi_complete()
           scsi_decide_disposition()
             scsi_handle_queue_ramp_up()
               scsi_change_queue_depth()

Freezing a request queue requires thread context. Hence, the queue ramp
up queue depth increase would have to happen asynchronously, e.g. via
queue_work().

Here is another call chain:

scsi_error_handler()
   scsi_unjam_host()
     scsi_eh_ready_devs()
       scsi_eh_host_reset()
         scsi_eh_test_devices()
           scsi_eh_tur()
             scsi_send_eh_cmnd()
               scsi_eh_completed_normally()
                 scsi_handle_queue_full()
                   scsi_track_queue_full()
                     scsi_change_queue_depth()

Freezing the request queue probably would result in a deadlock for this 
call chain. So also for this call chain, changing the queue depth would
have to happen asynchronously.

Does anyone see any other options than either making 
scsi_change_queue_depth() a no-op or making all queue depth changes
asynchronously, except the call from scsi_alloc_sdev()?

Thanks,

Bart.
