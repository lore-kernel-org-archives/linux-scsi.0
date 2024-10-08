Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A4F33986
	for <linux-scsi@vger.kernel.org>; Tue,  8 Oct 2024 18:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728412195; cv=none; b=k9PMnLsFpKxrLrWBjGrDnjQ4BgFDFsRq0n9GPS17Rm3CXmpOfZ0nkpH9KMm5FW8OEHZoky0Ax14U29EmsMykXWeK9OJPqMliX8JGgUxw3/AJzxD0kMrBnBvID42m/bcqQqaDcW+ZNbIx/WWd/ayXxdQu/05jpEOU6XkWRlM3wr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728412195; c=relaxed/simple;
	bh=WTOotv7qUe5/UVZH8gRBlE055cb+pebXzkjqU1ktqBc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZQ0+D3oYZ1mupRyZWqfWBL1IqXSvtX7JlvyDgVaBi/FU8T/KXZCIJz4rX8S6TtoYkpm7MnJGSHcOWE2VBn0/TCc3/870FH5Ax5brduBE8ZFSk1gxekeRvEPembnp7nNbXwuVOTp1yf+85qg6VDQj8DAvLohjPreC+YbhwFFOjSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=IN3XuxqB; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="IN3XuxqB"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XNPh11QYyzlgTWP;
	Tue,  8 Oct 2024 18:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1728412190; x=1731004191; bh=U0zAV6Rjyn//UXVAp4//ewn3
	IWChaEMAk1sLBKWsGWs=; b=IN3XuxqB/7LLfg+XIUe3aZ9uZc+c3nRGMBgC5s8o
	52wC/mdeApH7hbMlPRyKWm2fJP7vWcTGX002KTNKQMFNZQXa0guiBUfHmAOKtzi7
	tMzG8rEWBmNV38OLAUmCPubkxUAk+htouG6fESB72l6vi6u56rXlZoioCugRpG9B
	3iipkNlTQpePU4U2fKxef/egVMiBe0gKPl/x9IL9ALRkirHrjAt7YoOW6VYGEIwg
	CccFYGaNNpx0HeWM8n3gPCNl6nfmUa0y/pihiVjb5e7Csct2Z43L0P7d2KZeQ50/
	T4nRV6I4UHtsEXsQjVAZF+/8ERKZL5CUNBYcPzokWYMZaA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id HEEzqqRMUYXE; Tue,  8 Oct 2024 18:29:50 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XNPgx2X58zlgTWK;
	Tue,  8 Oct 2024 18:29:48 +0000 (UTC)
Message-ID: <a02c83eb-d057-48cc-9735-770928a2a0a1@acm.org>
Date: Tue, 8 Oct 2024 11:29:47 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 2/2] ufs: core: requeue aborted request
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: wsd_upstream <wsd_upstream@mediatek.com>,
 "linux-mediatek@lists.infradead.org" <linux-mediatek@lists.infradead.org>
References: <20241001091917.6917-1-peter.wang@mediatek.com>
 <20241001091917.6917-3-peter.wang@mediatek.com>
 <6aba27a2-d59b-4226-806b-4442cc26c419@acm.org>
 <69a77b95da27fa53104ee74ecae4e7da2d1547cf.camel@mediatek.com>
 <e6e93ff1-cba1-45a9-b4b6-7dcbd7fca862@acm.org>
 <8c463196860b71f26bddad0e7e8be6aacd470109.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <8c463196860b71f26bddad0e7e8be6aacd470109.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 10/7/24 12:20 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> On Thu, 2024-10-03 at 13:02 -0700, Bart Van Assche wrote:
>>   =09
>> External email : Please do not click links or open attachments until
>> you have verified the sender or the content.
>>   On 10/2/24 5:42 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
>>> This patch merely aligns with the approach of SDB mode
>>> and does not involve the flow of scsi_done. Besides,
>>> I don't see any issue with concurrency between
>>> ufshcd_abort_one() calling ufshcd_try_to_abort_task()
>>> and scsi_done(). Can you point out the specific flow where
>>> the problem occurs? If there is one, shouldn't SDB mode
>>> have the same issue?
>>
>> Hi Peter,
>>
>> Correct, my comment applies to both legacy mode and MCQ mode. From
>> the
>> section in the UFS standard about ABORT TASK: "A response of FUNCTION
>> COMPLETE shall indicate that the command was aborted or was not in
>> the
>> task set." In other words, if a command completes just before
>> ufshcd_try_to_abort_task() calls ufshcd_issue_tm_cmd(), then
>> ufshcd_try_to_abort_task() will call ufshcd_clear_cmd() for a command
>> that has already completed. In legacy mode, this call will succeed.
>>
>=20
> Hi Bart,
>=20
> Yes, the legacy SDB mode is protected by the outstanding_lock.
>=20
>=20
>> Hence, both ufshcd_compl_one_cqe() and ufshcd_abort_all() will call
>> ufshcd_release(hba). This will cause hba->clk_gating.active_reqs to
>> be
>> decremented twice instead of only once. Do you agree that this can
>> happen and also that it should be prevented that this happens?
>>
>> Thanks,
>>
>> Bart.
>=20
> Sorry, I still don't understand why both ufshcd_compl_one_cqe()
> and ufshcd_abort_all() will call ufshcd_release(hba)?
> Because I have already removed the ufshcd_release_scsi_cmd from
> ufshcd_abort_one, so the command won't be released immediately
> after ufshcd_try_to_abort_task succeeds. Instead, it will wait
> until the CQ Entry comes in before releasing. And since it is
> protected by the cq_lock, it should only release once, right?

Hi Peter,

I think what you wrote applies to MCQ mode only. In my previous email
I clearly referred to "legacy mode" (SDB mode). Summarizing my previous
email, I think that in legacy mode it is possible that ufshcd_release()
is called twice while it only should be called once. Here are the
possible solutions I see:
* Add a function to the SCSI core for setting SCMD_STATE_COMPLETE. This
   may be controversial since no other SCSI LLD needs this functionality.
* Changing the error handling approach in the UFS driver to the same
   approach other SCSI LLDs use: instead of using queue_work() to
   activate the error handler, call scsi_schedule_eh(). This will cause
   the error handler to be activated later, namely after all pending
   commands have timed out instead of aborting any pending commands
   first.
* Add a variant of scsi_schedule_eh() to the SCSI core that accelerates
   error handling by calling scsi_timeout() on all pending commands.

Thanks,

Bart.

