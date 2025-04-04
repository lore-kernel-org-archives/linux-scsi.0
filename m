Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5977B20B7E1
	for <linux-scsi@vger.kernel.org>; Fri,  4 Apr 2025 17:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743786358; cv=none; b=enYljaFUR7wspv2I8fqbudqtuRjkeyOyx4RRwVTQinHgKbHk2ax6P1sKiFuOhT8zvMtevWK40LAdrf/pqtsj5U4AJxGf4qDfzWgPkMuHujJxG2/bAFbEhUD2hqNrV9tJeYyCSfXgzAQiqa5O59qRjz9Pq56nxa1tpguTcqljECk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743786358; c=relaxed/simple;
	bh=SPmiagxc/m2wovTqjabdDfLKdnw1vQy09cnvFXdnQSU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r8+bs/SpibLJC0e7oMiHN6oshLdbF3z9TJxUpOxEh1FnO682GIf4PnA/+eF0BeaPGpdgC6nph+XorLnXnTP52xTfd3J//Q5//R1/ym6Ic20kwfhg9vZeU4aFPhdg9yHi3wdlJxZYfONHWzmkCHbyl8Tn6lCYcPPiao7TXaE2DQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=5Anvo6cG; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="5Anvo6cG"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZTlNz1ffszm26qS;
	Fri,  4 Apr 2025 17:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1743786354; x=1746378355; bh=QRNBZ26V41d77EBz6kex7xXQ
	pgaL1fmP+fQtc8tNlNc=; b=5Anvo6cGAEjeyQxL1kKi8t1APTf5jgJoNQkI6q2/
	2RPzHUxjpVqPfR/VLKkFKGnvW7mu+fe2K+ejGfrmV9BOeUpmdp90rZSNqEvyHeCX
	t5deRAAM7KslN58d73Db55QqwKf6t4PqadqiaZNVa80qun/EtZWPOxlmEc+fEHeH
	uug8iJK7Lh6YvasIXNUhXqs872y0EEF1nH7fsr22FzFz7+H9rA+WbHPQPdBTHQT4
	XUTR450K296tsu0ucssT0VzZ1xPoBDLHCdJAPnyCyZWjAw/BzNvF97FQToeVt+Fa
	OXz+coPFROdHhLJ3w/qSXa79/LT76ySva2j3vkfv9lhBPA==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ZxNa4iEC7bzQ; Fri,  4 Apr 2025 17:05:54 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZTlNv4LHdzm0yVF;
	Fri,  4 Apr 2025 17:05:50 +0000 (UTC)
Message-ID: <3affc917-6634-47fc-a6d2-5b57a2e34bef@acm.org>
Date: Fri, 4 Apr 2025 10:05:49 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/24] Optimize the hot path in the UFS driver
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <20250403211937.2225615-1-bvanassche@acm.org>
 <bcc48e7a-8d83-46dd-ad71-d7587d2b0434@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <bcc48e7a-8d83-46dd-ad71-d7587d2b0434@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/4/25 3:15 AM, John Garry wrote:
> On 03/04/2025 22:17, Bart Van Assche wrote:
>> Hi Martin,
>>
>> This patch series increases IOPS by 1% and reduces CPU per I/O by 10% 
>> on my
>> UFS 4.0 test setup. Please consider this patch series for the next merge
>> window.
> 
> That cover letter is a bit thin for something which now implements SCSI 
> reserved command handling (in addition to any UFS optimisation).
Hi John,

Here is a more detailed version:

This patch series optimizes the hot path of the UFS driver by making
struct scsi_cmnd and struct ufshcd_lrb adjacent. Making these two data
structures adjacent is realized as follows:

@@ -9040,6 +9046,7 @@ static const struct scsi_host_template 
ufshcd_driver_template = {
  	.name			= UFSHCD,
  	.proc_name		= UFSHCD,
  	.map_queues		= ufshcd_map_queues,
+	.cmd_size		= sizeof(struct ufshcd_lrb),
  	.init_cmd_priv		= ufshcd_init_cmd_priv,
  	.queuecommand		= ufshcd_queuecommand,
  	.mq_poll		= ufshcd_poll,

The following changes had to be made prior to making these two data
structures adjacent:
* Instead of making the reserved command slot (hba->reserved_slot)
   invisible to the SCSI core, let the SCSI core allocate memory for the
   reserved slot and tell the block layer to reserve one slot. This is
   why patch 04/24 adds minimal support in the SCSI core for reserved
   command handling.
* Remove all UFS data structure members that are no longer needed
   because struct scsi_cmnd and struct ufshcd_lrb are now adjacent
* Call ufshcd_init_lrb() from inside ufshcd_queuecommand() instead of
   calling this function before I/O starts. This is necessary because
   ufshcd_memory_alloc() allocates fewer instances than the block layer
   allocates requests. See also the following code in the block layer
   core:

	if (blk_mq_init_request(set, hctx->fq->flush_rq, hctx_idx,
				hctx->numa_node))

   Although the UFS driver could be modified such that ufshcd_init_lrb()
   is called from ufshcd_init_cmd_priv(), realizing this would require
   moving the memory allocations that happen from inside
   ufshcd_memory_alloc() into ufshcd_init_cmd_priv(). That would make
   this patch series even larger.
* ufshcd_add_scsi_host() happens now before any device management
   commands are submitted. This change is necessary because this patch
   makes device management command allocation happen when the SCSI host
   is allocated.
* Start with allocating 32 command slots and increase this number later
   after it is clear whether or not the UFS device supports more than 32
   command slots. Introduce scsi_host_update_can_queue() to support this
   approach.

Bart.
