Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9302D47E9
	for <linux-scsi@vger.kernel.org>; Fri,  5 Sep 2025 16:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757090184; cv=none; b=VWJugjRIOatIT/ERUoZqpLqTgqb+0RrrHVuLwVRb3pNG0b1lzLG6lo8FUm/v6tFezxjyXY0hvS1zj3KG99aUwVFKFxOtkCL/PTwe5V5cl8Q9y6MVRTdzoUEFBtFil4Ic/v68BEWQGZeNubHMKm4zKxx1S6gkd3P/d9sIbJm0Sy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757090184; c=relaxed/simple;
	bh=0yImr4gpAl4BNtSewpE55R4uVTYdVqsQ5/vC9JGYebI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P39J9/4c4vjtVK4Ol+CcF8FRIZSLF4qWB0rFHspkpiE//f4Acl+8rqXe7yoeKGuiqSU/7eZgQj4RlSIXQNHpnya58gfI95SFeTi3w8qIHODBzI3zBSGPjcXT8Ty/sBR1yRhzooNZEHg/GZcEzAQ+MDMd3+A32fjxi+AyjdpT53s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=sRHe9wXE; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="sRHe9wXE"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cJMRn0kRYzm1746;
	Fri,  5 Sep 2025 16:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1757090177; x=1759682178; bh=ucxHGGrbgkFMq8k3MypfNc2x
	TWHqnl6UDAWFYiAK7zM=; b=sRHe9wXE7N8A+DpCJqawegvnDLSNrSCSn2LSc9K7
	E2t05XjtKEbxpOSeINnkwQJHS79mpokk8SKUzv4eqASdYcXmFNLHUG04yUgQRJ2l
	gvvYDTkiBlE4FkHwGy6TkCXQnkeC0cVecyRPziIv6euQwRCiNeKEYNYIjOESArC6
	4RPH6phDSLMJbp9NqSUVi4Z7tMd3Q/ja/kn4S2PctMao7xViC0SsM+peSoT9qo1D
	X5xEgHxTd0AlU+cDCD0oZ0vGXb5dOBOTOoZg3LNDZB8jT6dbWjaEqdZO0IKkrEmO
	4Pu+ZBqFPZOhUDHSolf9hq1IA77yaMaLZ+lsYXPnJKOgsA==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ZfCuONcJlXhK; Fri,  5 Sep 2025 16:36:17 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cJMRd2kPSzm1745;
	Fri,  5 Sep 2025 16:36:12 +0000 (UTC)
Message-ID: <4477b1b9-be63-4e0e-9fdd-2b9633e8acca@acm.org>
Date: Fri, 5 Sep 2025 09:36:11 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/26] scsi: core: Do not allocate a budget token for
 reserved commands
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
 Ming Lei <ming.lei@redhat.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250827000816.2370150-1-bvanassche@acm.org>
 <20250827000816.2370150-4-bvanassche@acm.org>
 <7341ada1-05c4-4a70-94e3-cd208d47231d@oracle.com>
 <719e714a-6f15-46b9-b4f1-b697ea00ef66@acm.org>
 <c9b3a67a-20f2-4d2a-9b31-6a492dd17f81@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <c9b3a67a-20f2-4d2a-9b31-6a492dd17f81@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/5/25 8:17 AM, John Garry wrote:
> On 04/09/2025 19:17, Bart Van Assche wrote:
>> On 9/4/25 2:41 AM, John Garry wrote:
>>> On 27/08/2025 01:06, Bart Van Assche wrote:
>>> My original problem in this area was that we were trying to send 
>>> reserved commands for real sdevs and those sdevs may have run out of 
>>> budget. So I was suggesting to not get budget for reserved commands. 
>>> But would it really be possible to run our of budget for the shost 
>>> psuedo sdev?
>>
>> Yes. The UFS error handler may be invoked if the SCSI budget has been 
>> exhausted and may have to allocate a reserved command to recover from
>> the encountered error. The UFS error handler may e.g. submit a START
>> STOP UNIT command if the UFS device is in the suspended state to bring
>> it back to a fully powered state. See also the ufshcd_rpm_get_sync(hba)
>> call in ufshcd_err_handling_prepare().
> 
> I assumed that the budget map depth for the psuedo sdev would be the 
> same size as the number of reserved commands, right? If that is true, if 
> we have a reserved command allocated, then we must have budget as well 
> available.

A budget map is allocated by the SCSI core to enforce the
host->cmd_per_lun limit. That limit does not apply to pseudo SCSI
devices. Hence, there is no need to allocate a budget map for pseudo
SCSI devices. The patch below shows a possible replacement for this
patch, assuming that the previous patch is modified such that no budget
map is allocated for pseudo devices:

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9c67e04265ce..91a0c7f843c1 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -396,7 +396,8 @@ void scsi_device_unbusy(struct scsi_device *sdev, 
struct scsi_cmnd *cmd)
  	if (starget->can_queue > 0)
  		atomic_dec(&starget->target_busy);

-	sbitmap_put(&sdev->budget_map, cmd->budget_token);
+	if (sdev->budget_map.map)
+		sbitmap_put(&sdev->budget_map, cmd->budget_token);
  	cmd->budget_token = -1;
  }

@@ -1360,6 +1361,14 @@ static inline int scsi_dev_queue_ready(struct 
request_queue *q,
  {
  	int token;

+	/*
+	 * Do not allocate a budget token for reserved SCSI commands. Budget
+	 * tokens are used to enforce the cmd_per_lun limit. That limit does not
+	 * apply to reserved commands.
+	 */
+	if (!sdev->budget_map.map)
+		return INT_MAX;
+
  	token = sbitmap_get(&sdev->budget_map);
  	if (token < 0)
  		return -1;
@@ -1749,7 +1758,8 @@ static void scsi_mq_put_budget(struct 
request_queue *q, int budget_token)
  {
  	struct scsi_device *sdev = q->queuedata;

-	sbitmap_put(&sdev->budget_map, budget_token);
+	if (sdev->budget_map.map)
+		sbitmap_put(&sdev->budget_map, budget_token);
  }

  /*

Thanks,

Bart.
