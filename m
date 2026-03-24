Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5866F370D7D
	for <linux-scsi@vger.kernel.org>; Tue, 24 Mar 2026 16:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774369462; cv=none; b=P2ckfhq9VvWBABMjamMWqBT8CfMQ9PjeOKz9EWd6NXf7oFLcOEBEa0PnXx42h/cPgu73CWOajXK86dCw94gVTZsL1qpvzHvEqH0LvBrJt9Bs3lG77taPyuscI97WpyDpm95atUjKM+TJCEhz2CofxzgPhIC1kN3sQ6FIl9FCXcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774369462; c=relaxed/simple;
	bh=5hqfrwBm85798QS+Jlyzrk8R2d9MOeYITHCu+d6Wi8M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M9s9sFRCJffD/bGabEjkF8uvQ28ROXbBfJdEjKocGA0scnoGXMT+PQOCdSmJiAmC/IrjS3CjrR5iPj4wkmvcEjspvAPCut/XOLS4nnPC/fzB0nhmMsP72KByvj9PXHhEsH7HaMVkwSPU3aHYdEt1GyosEdSshVJ8GSZwdSuHBNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=dT0BuAQB; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="dT0BuAQB"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fgFjV60KQzlh2g7;
	Tue, 24 Mar 2026 16:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1774369452; x=1776961453; bh=pNC367QBUdUhhCAG9jmQmXfB
	lM3/u5YXS+I7Dq2mqiM=; b=dT0BuAQBvx4DZI+5ccbfjGabNvyO/FvChq7lNpRY
	FwM3Du2lDHBEHDVdTszBNzk/g8DxJ2hVutyuxn4WePzVkTyknr6o2Mv7LTIQpvlF
	ejNIvnwd7Dx8VjMjV/qaW4dZ3Km/TOVx6Z13XjjcIMDJP7YMQP3tNDEutKcRaiHb
	pK3kRWEL81Cjq22DP5X/d9idOP+u5rZo2SLV153c0eK8mXDNFSTWj/P60lzzzWum
	jA6kmRsZpKVqoxFSWd09LrU0cTOYlwoM0NE9qg/EjDAD61O6udBkrQpldlQt/N0Y
	Ri47s+WYczZd4S9GDXtaRB8JzmfRsOAxAfd+9QGdf48m9Q==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 7mZHDgCl2bOa; Tue, 24 Mar 2026 16:24:12 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fgFjR0CzKzlh2g5;
	Tue, 24 Mar 2026 16:24:10 +0000 (UTC)
Message-ID: <d2d4b9c4-6c47-4450-925f-d2cbbede63f3@acm.org>
Date: Tue, 24 Mar 2026 09:24:10 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi_debug: Support configuring the maximum segment size
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Doug Gilbert <dgilbert@interlog.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20260323203117.1248925-1-bvanassche@acm.org>
 <1d4c332e-6151-47a2-8f9c-160f03416e64@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1d4c332e-6151-47a2-8f9c-160f03416e64@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/24/26 2:11 AM, John Garry wrote:
> Did you consider sanitizing this value? Maybe we should ensure that it 
> is a power-of-2 or UINT_MAX or BLK_MAX_SEGMENT_SIZE

That's a good question.

max_segment_size does not have to be a power of two. From
drivers/ata/sata_inic162x.c:255:

	.max_segment_size	= 65536 - 512,

I think the only invalid value is zero. blk_validate_limits() considers
zero as the default and changes it into something else (UINT_MAX or
BLK_MAX_SEGMENT_SIZE).

> BTW, I don't think that we still need to set a value in 
> sdebug_driver_template.max_segment_size now.

If nobody objects I will integrate the change below into this patch:

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 641cc0e01dfc..0d3e0ba537c4 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -9542,7 +9542,6 @@ static const struct scsi_host_template 
sdebug_driver_template = {
         .sg_tablesize =         SG_MAX_SEGMENTS,
         .cmd_per_lun =          DEF_CMD_PER_LUN,
         .max_sectors =          -1U,
-       .max_segment_size =     -1U,
         .module =               THIS_MODULE,
         .skip_settle_delay =    1,
         .track_queue_depth =    1,

Thanks,

Bart.
