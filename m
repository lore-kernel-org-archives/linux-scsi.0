Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21CD72C0F7F
	for <linux-scsi@vger.kernel.org>; Mon, 17 Nov 2025 16:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763396963; cv=none; b=GTUS1NY44qQG7kI1eRq3BGXSLkNxMAlBOjwArN+o0O8zXKlCp8a3iWcr5rOyUp9zEOol9AhazIchEx4qt1U9DU8SoSUX1SveUExe8zG5qB/h9HRS9FNkYutFF3LgNEPfmYleLz13rbuRZblregxWF2/q/F3nIkRy1ZAjoIZkQ+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763396963; c=relaxed/simple;
	bh=0ldFmIKWstnu7AZp0rfUPYRi4bQv96jKwEpwa8P82nA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lmEFNvSZ0HekYE/rtulvF+IuZ4TVJREqTd36Uci/B1qqh37J5vCaD/cKX807opU0+2MEl0EVWTPmf6f10kdJ6nLx8jY7my26jmsqM/jQ+9llyJow9BoQpHOwYRVxfllmhO48E8rnxQ1KDHtyPP/uRaDfQjoyGEs1+QTbAYmn4RQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=IXwUX0Wa; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="IXwUX0Wa"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4d9Cqt3z8wzlssnN;
	Mon, 17 Nov 2025 16:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1763396953; x=1765988954; bh=RK418WxJIymfRfNAjrXlKVZG
	JgbRB6uQu4pu0A5g7RA=; b=IXwUX0WaKzCvxb6S9RGib+lsz7pRc85tChg5a0d4
	WD5Sne+K+Lr0F1hSMBoH/QV1zsNTYkRv+sS7T17OgGEqqw0CZlQc7Z9E2TJjVBDl
	0Akv3kejrwb1gkWEgX7BrF7NyYRUjnx4WJ1srPVLVDKosbi/q6lCtOw6LMu85BHp
	r/F7/gobN2nvmkw5dM7yAjN5THyuSx65nIVxL82Oj5guTfGS5EJLs0B8d3W0oHwP
	bF9SXuvSj2Gnks7dEq27wgWNFwWftFsC9yF4e0pJcqbc9yi7BW4CjiMoZbBvBen3
	cWOkagvSlk54c1pjYLL/NDWdMmDrV/trxFZ2pz+/XAFsjA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Pmu48F6hXcQO; Mon, 17 Nov 2025 16:29:13 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4d9Cqk0bGPzlgqW1;
	Mon, 17 Nov 2025 16:29:05 +0000 (UTC)
Message-ID: <91e387ed-fba0-4622-b357-53356fd7fee3@acm.org>
Date: Mon, 17 Nov 2025 08:29:03 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: Fix a regression triggered by
 scsi_host_busy()
To: John Garry <john.g.garry@oracle.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
 Sebastian Reichel <sebastian.reichel@collabora.com>,
 Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20251007214800.1678255-1-bvanassche@acm.org>
 <yq1h5vr4qov.fsf@ca-mkp.ca.oracle.com>
 <fe16b110-300c-4b13-bf2b-56e7f2c6f297@oracle.com>
 <540bad1d-ba01-4044-94e0-4f7b05934779@acm.org>
 <cee0f307-b875-4578-b7ed-43daef2b238e@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <cee0f307-b875-4578-b7ed-43daef2b238e@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/17/25 4:17 AM, John Garry wrote:
> I am auditing all the other scsi_host_busy() callsites to see if it is 
> possible to backout the change in this patch (which checks tagset ops is 
> non-NULL before calling the tagset iter function).
> 
> Can you confirm that all paths in the ufs driver are safe, as there are 
> still some references and they involve workqueues (so not so callchains 
> are not so obvious)?
> 
> So far it seems that only scsi_debug may have a hidden problem, but I am 
> not overly concerned with that.

Hi John,

The patch series "Optimize the hot path in the UFS driver" makes the
scsi_add_host() call happen before most scsi_host_busy() calls. However,
a few UIC commands are sent before scsi_add_host() is called and these
may trigger the UFS error handler. The UFS error handler may trigger a
call to ufshcd_print_host_state(). Something like this patch may be
required (I will post this as an official patch after having tested it):

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index e90120d590f2..fadceb396400 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -678,7 +678,8 @@ static void ufshcd_print_host_state(struct ufs_hba *hba)

         dev_err(hba->dev, "UFS Host state=%d\n", hba->ufshcd_state);
         dev_err(hba->dev, "%d outstanding reqs, tasks=0x%lx\n",
-               scsi_host_busy(hba->host), hba->outstanding_tasks);
+               hba->scsi_host_added ? scsi_host_busy(hba->host) : 0,
+               hba->outstanding_tasks);
         dev_err(hba->dev, "saved_err=0x%x, saved_uic_err=0x%x\n",
                 hba->saved_err, hba->saved_uic_err);
         dev_err(hba->dev, "Device power mode=%d, UIC link state=%d\n",

Bart.
