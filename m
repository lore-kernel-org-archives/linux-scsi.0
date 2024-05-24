Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B79C18E;
	Fri, 24 May 2024 00:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716509323; cv=none; b=WVhauX5EEPoQiC4rNof+BKss+Vz8czb5nyJfq6zGhfa+NJNdmV/0OjphTxZ8o/FzmY3KraZGrsFWfQhb7frmwh71FvkEQ1OySAIOD5vUUlMCC8Cl2GY/VhweJqwSvvd3EbWbyHjudPh2QrMb5cEJR3CPFdc8t07GqSn69do19vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716509323; c=relaxed/simple;
	bh=elye7Mqyzlzrwtk6rVKfxywi06mObxlfiV8YLIMW/Nk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sg1Ef/2+3R35pNQ/akEn74tFiLFQvvKZ+uZQJD/1NqyCULEp3MbQ7s7ssFza/8NDHHIXYRU+WoA86tCcsy7kGD+nixSBFQQKnXa7iDHjl4DQS6CwCPjGEGxfRlRv0VxSzXDnrGhiwlBUqHLG9ZebS/LPU5j/XtLLe45kTiS32a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=MK7XtREY; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="MK7XtREY"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Vllkc2tT9z6Cnk97;
	Fri, 24 May 2024 00:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1716509316; x=1719101317; bh=xAsi/F2lKW2JGFc+IyQvDa4s
	f6l5yJjKpz0kswxD7TA=; b=MK7XtREYbGWcKDT4/oYg2yQK4lBJWAG3WT7OPxRG
	7d5rFBkC61Y20toXxime6gUogwXKf0nlhPE2eF9xs3USRTWEDwCVu+hztB/mCgTr
	4o0UaesUZfvBXsGZ/EI1VWRKsfvNvIZdzK0ju4+Odb3uTap7z0Lsq3GwUU48LESv
	RmJ9zLSGfWYSm+MmLk0wkON+dH1pbv9cvJwJmTPNxouQg7Vo0r3PA+Vke6V5y1f+
	43/yGIEZnq6a1k0712cHgyLsayQ71oMK5gISNBhlQj312j42QQvcix68alAc3nFG
	md4eMH6xaTmqEVn0mKrIpLyFOMuO/+5JgdURvBGoJUU0zA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id d6a8P5AhrePd; Fri, 24 May 2024 00:08:36 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4VllkV1HgDz6Cnk95;
	Fri, 24 May 2024 00:08:33 +0000 (UTC)
Message-ID: <fb116abc-1ee6-42d0-879f-e11cdeab3cc5@acm.org>
Date: Thu, 23 May 2024 17:08:32 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ufs:mcq:Fixing Error Output for ufshcd_try_to_abort_task
 in ufshcd_mcq_abort
To: Chanwoo Lee <cw9316.lee@samsung.com>
Cc: James.Bottomley@HansenPartnership.com, alim.akhtar@samsung.com,
 avri.altman@wdc.com, linux-kernel@vger.kernel.org,
 linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
 powen.kao@mediatek.com, quic_cang@quicinc.com, quic_nguyenb@quicinc.com,
 stanley.chu@mediatek.com, yang.lee@linux.alibaba.com
References: <20240523002257.1068373-1-cw9316.lee@samsung.com>
 <CGME20240523235615epcas1p282b2405bed41b94ef8a40633066f1d4c@epcas1p2.samsung.com>
 <20240523235613.1103161-1-cw9316.lee@samsung.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240523235613.1103161-1-cw9316.lee@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/23/24 16:56, Chanwoo Lee wrote:
> I thought this patch would be appropriate to "fix" the following log.
>    * dev_err(hba->dev, "%s: device abort failed %d\n", __func__, err);
> If "Fixing" is not appropriate, could you suggest another word?

That's something I had not noticed. This is indeed a bug fix. Please add
a "Fixes:" tag as is expected for bug fixes.

BTW, I think that ufshcd_mcq_abort() can be improved significantly. How
about reworking that function as follows before the bug reported in this
patch is fixed?
- Remove the local variable 'err' (and reintroduce that variable in your
   patch).
- Change all 'goto out' statements into 'return FAILED'.
- Add 'return SUCCESS' at the end.

I expect that this change will make that function easier to read and to
maintain.

Thanks,

Bart.

