Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB9817579
	for <linux-scsi@vger.kernel.org>; Wed, 31 Jul 2024 20:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722457605; cv=none; b=mzJpLUYtxLbFua4p0GXMa+y0PQ+nqHQ871yVoat6uKjBKcVJiUnCzml4tzUhWoffHDvqLNEmzpAR7Frsao5xOZI90qzeSFnUf06QIVaElozx14GWOn+ci3tB8/pQm4G6GYaCNdJc7CF6ym2ZGnWhl6viM9PSSQ0YW0DnvkHRWhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722457605; c=relaxed/simple;
	bh=H5ArDd+hq2jHQBtCRY2DdmowPeY5Q8QpQXJuMJrgP/c=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=M383CVhJEvNBOhNJcRbDT7xrkXnUhzuEvoXZMExOYsJ7W0zGQwuqAUTGU7min4k+ROpBQlSKsFWLUpG5BWnI+1bOENhJC4l50t1VvDmTNR5PeYJkOBQ+YIYU1LG+lRv/3JOxfSbPDhaDYA/QNDn4xMgerxd1qfnjd8d7F0PmALM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=b98uFmXR; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="b98uFmXR"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WZ3ST1mx2z6CmLxY;
	Wed, 31 Jul 2024 20:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type
	:content-language:subject:subject:from:from:user-agent
	:mime-version:date:date:message-id:received:received; s=mr01; t=
	1722457381; x=1725049382; bh=Uuok3gItVhet6LmTYx4sbEjwn+unjYRnwLs
	mBGqO25g=; b=b98uFmXR7DgMPdjxczABqrr80xVsZGlFqsGnuDUfrcB3XLbL1AK
	SeMGlNoHUoxjjlkwB16a7hJ+dTjCw8A5JFAfZMzioSgIZA2RkyfbPQwq0sZ0xMdd
	tPe2z0CGyvJ3oN46i2Xc+0k+2jQjCESh8eKEQyvWo8LrgF9db9dhOR0tNdd/EGJB
	33n6Z+1HEGEQM2iSWAI3mVitu1ljpr2fkqQl8//XmJzCdvga9CA5TAzQzyrHtslZ
	AtLx9W1pQ27FViF6CorDpvGOIHHh8amWSi5n+tFdSJOke9bZl3cprP6rwJ531xfk
	fPYcC/37PnbH6psSVFfKgqPLRkSaxG2TBfA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Lp-8nHiRaPfG; Wed, 31 Jul 2024 20:23:01 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WZ3SM3jNyz6CmM6f;
	Wed, 31 Jul 2024 20:22:59 +0000 (UTC)
Message-ID: <b0f92045-d10f-4038-a746-e3d87e5830e8@acm.org>
Date: Wed, 31 Jul 2024 13:22:57 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Bart Van Assche <bvanassche@acm.org>
Subject: RFC: Retrying SCSI pass-through commands
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
 Damien Le Moal <dlemoal@kernel.org>, Hannes Reinecke <hare@suse.de>,
 Mike Christie <michael.christie@oracle.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 Jaegeuk Kim <jaegeuk@kernel.org>, Christoph Hellwig <hch@lst.de>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Recently I noticed that a particular UFS-based device does not resume
correctly. The logs of the device show that sd_start_stop_device() does
not retry the START STOP UNIT command if the device reports a unit
attention. I think that's a bug in the SCSI core. The following hack
makes resume work again. I think this confirms my understanding of this
issue (sd_start_stop_device() sets RQF_PM):

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index da7dac77f8cd..e21becc5bcf9 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1816,6 +1816,8 @@ bool scsi_noretry_cmd(struct scsi_cmnd *scmd)
          * assume caller has checked sense and determined
          * the check condition was retryable.
          */
+       if (req->rq_flags & RQF_PM)
+               return false;
         if (req->cmd_flags & REQ_FAILFAST_DEV || blk_rq_is_passthrough(req))
                 return true;

My understanding is that SCSI pass-through commands submitted from
user space must not be retried. Are there any objections against
modifying the behavior of the SCSI core such that it retries
REQ_OP_DRV_* operations submitted by the SCSI core, as illustrated
by the pseudo-code below?

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index da7dac77f8cd..e21becc5bcf9 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1816,6 +1816,12 @@ bool scsi_noretry_cmd(struct scsi_cmnd *scmd)
          * assume caller has checked sense and determined
          * the check condition was retryable.
          */
-       if (req->cmd_flags & REQ_FAILFAST_DEV || blk_rq_is_passthrough(req))
-               return true;
+       if (req->cmd_flags & REQ_FAILFAST_DEV)
+               return true;
+       if (/* submitted by the SCSI core */)
+               return false;
+       if (blk_rq_is_passthrough(req))
+               return true;

Thanks,

Bart.
