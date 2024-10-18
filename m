Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E241320E33D
	for <linux-scsi@vger.kernel.org>; Fri, 18 Oct 2024 19:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729280164; cv=none; b=UStFEYnnexHpW0R4Entd668MRinWsYLkIf5o7sK6OxMkJtA9bM6MbwmunAwJjCmAmO04bsrLNlT9Rsl6DPYYDqgTLF9GTNJP0dWYQnDg516HvY42+vep7VGiB9uVION2xK/QSG5whK7mCaxdrBRwxL3GV0lgPy/iNm4n1tV5/mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729280164; c=relaxed/simple;
	bh=h8GA6nEUo0Pq30+s8jrU4QWAqyk0Hsed4NLibbQvghM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cmFvmrOX/e5eXeQv1v68So3xQw0G0UBP5BeMeD/+lLfXs/vrINVdKDJmCQkeEQJUF03TA/Yo2CBnSufPcqU/WRnl2bDx8paGuFHFxrfFJBG4Ax1NH+49Z3cIBGddAPG48oVZjlDUJrKBv1tGdPOKhlu756/FHl1FG1W8TsqGtbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=BSzrZc1j; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="BSzrZc1j"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XVZgj1gKkzlgMVp;
	Fri, 18 Oct 2024 19:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1729280156; x=1731872157; bh=0LsMh34wP2MwOvrpZb+JxJJg
	NocUaZgQJA1ub5CmkOg=; b=BSzrZc1jb10jIlWru24YeHhtrvmRAaZfZLv6IgcF
	tLhJqVv+zAym0djmvuIdfd3c0UWf0/J4wzH0ES/2b3ZBSOUpnU4ZQxSMw+uIC0/m
	bKyQOls+/U9sU02S72pwbNvZHq3oIhzUII4bdWUhtO/mxE8B/fTDJu4BNQDar2Iv
	JMg9Uw7tvmAlPP/D/9CtEDFGEe9ZyLCYsw2yWEDUuRDOPx8TiFVUWd4hw9VAsvQi
	FnO2Fdu1Di7+P98Q9tbTsj7h3mZgRCLPNZjjz92LS9m0pXG3JFLI0Cnc8VYe3tSg
	G4QTmvWrgv/BycBgbLP1su+rZA0SMegSiIGHt0zz29Gz1A==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id DR57gmsUqHZy; Fri, 18 Oct 2024 19:35:56 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XVZgV61mGzlgMVr;
	Fri, 18 Oct 2024 19:35:50 +0000 (UTC)
Message-ID: <793f958f-353e-453a-b2eb-288853a38dc2@acm.org>
Date: Fri, 18 Oct 2024 12:35:48 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] scsi: ufs: core: Fix ufshcd_exception_event_handler()
To: Avri Altman <Avri.Altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Peter Wang <peter.wang@mediatek.com>, Andrew Halaney <ahalaney@redhat.com>,
 Bean Huo <beanhuo@micron.com>, Maramaina Naresh <quic_mnaresh@quicinc.com>,
 Maya Erez <quic_merez@quicinc.com>, Asutosh Das <quic_asutoshd@quicinc.com>,
 Can Guo <quic_cang@quicinc.com>
References: <20241016211154.2425403-1-bvanassche@acm.org>
 <20241016211154.2425403-5-bvanassche@acm.org>
 <DM6PR04MB6575DD9E354A70A9EA97E439FC402@DM6PR04MB6575.namprd04.prod.outlook.com>
 <608f86d5-0f27-4c88-a2b2-6504348f2f18@acm.org>
 <DM6PR04MB6575010F498BC3F480EA198AFC402@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB6575010F498BC3F480EA198AFC402@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 10/18/24 10:25 AM, Avri Altman wrote:
> No. But the Fixes tag seems strange, isn't it?

How about replacing the entire patch with the patch below?

Thanks,

Bart.


scsi: ufs: core: Simplify ufshcd_exception_event_handler()

The ufshcd_scsi_block_requests() and ufshcd_scsi_unblock_requests()
calls were introduced in ufshcd_exception_event_handler() to prevent
that querying the exception event information would time out. Commit
10fe5888a40e ("scsi: ufs: increase the scsi query response timeout")
increased the timeout for querying exception information from 30 ms to
1.5 s and thereby eliminated the risk that a timeout would happen.
Hence, the calls to block and unblock SCSI requests are superfluous.
Remove these calls.

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 76884df580c3..2fde1b0a6086 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6195,12 +6195,11 @@ static void 
ufshcd_exception_event_handler(struct work_struct *work)
  	u32 status = 0;
  	hba = container_of(work, struct ufs_hba, eeh_work);

-	ufshcd_scsi_block_requests(hba);
  	err = ufshcd_get_ee_status(hba, &status);
  	if (err) {
  		dev_err(hba->dev, "%s: failed to get exception status %d\n",
  				__func__, err);
-		goto out;
+		return;
  	}

  	trace_ufshcd_exception_event(dev_name(hba->dev), status);
@@ -6212,8 +6211,6 @@ static void ufshcd_exception_event_handler(struct 
work_struct *work)
  		ufshcd_temp_exception_event_handler(hba, status);

  	ufs_debugfs_exception_event(hba, status);
-out:
-	ufshcd_scsi_unblock_requests(hba);
  }

  /* Complete requests that have door-bell cleared */

