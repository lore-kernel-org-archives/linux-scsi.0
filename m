Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A23158845;
	Thu, 21 Nov 2024 21:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732223658; cv=none; b=XtssdK8gNYG8t+mkCg3xD3wfccbpSmp5aw8OmipDaDz7IwQppVTCKll1uFMNOydoZWkiZSnIDfMS3KABDB/rYCUGrzuNoruCqABeu/zWWyEVhpdW0xXFXwqGfhLTb5g12Gd7lUpiB55wzuQuw/r0Vz6MNRJgzc/mzRboiOR3mTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732223658; c=relaxed/simple;
	bh=ygAci0n8cn6dU9C1b/PayexPxmT0FSo+5Nqzjoxka3w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mXXVmArXVIWBasLY33LhLO2JGxjac07UuUaQppHeSAkXFdbg8IRoZldFI4J0jhyrz+1EAystCeEp3yoRyxM/VY4LIxzSVl0IUC/tExP1aSmwmnxJOeQOf79PFxgA5M5dd1EakTZzmMS4rTYWWugAEjmRaWTSrNiOcc2aU67b7dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Fl8a9beG; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Fl8a9beG"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XvWFM6GkSz6CmQtQ;
	Thu, 21 Nov 2024 21:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1732223652; x=1734815653; bh=4/SUVmnIuBg+PBG2Y69yzh4A
	n8y1tc792Qoi7ufSsRU=; b=Fl8a9beGXvdFtOYcAGGHWPko7A8ycHQTYS9+qiwc
	TR+USgwtJIsj+8522mEsVV89elJDQxujqKBl0e+v9+XrptBCC1wrnO1jWxA+bzns
	wih7V7CJ1j6vEl8VHyBO3pg4tPfHgonRhEcvCJAmXDYn07wnLz6cMx47c6875Q1a
	ccYX8bYKIJLPOMFPuyE6spbiSEqxEl84gYG1qVgD8fIaPmqX79iQ0I5OTBw7do+7
	T6rABHcQolkRAkvcZNlnwlnFAsIRZwTrUeOKZW18umK1O8b/mj1JXKMfR5d6n/R7
	uacweTBz+Fua/PSJM+1/IZv9MJO6howHRV6wyxZmOugO0A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id aHfrl3cUDq0e; Thu, 21 Nov 2024 21:14:12 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XvWFJ0BMtz6CmQwP;
	Thu, 21 Nov 2024 21:14:11 +0000 (UTC)
Message-ID: <55ab06af-ff92-4454-b9d2-d481d8e9db43@acm.org>
Date: Thu, 21 Nov 2024 13:14:10 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] scsi: ufs: core: Introduce a new clock_gating lock
To: Avri Altman <Avri.Altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Bean Huo <beanhuo@micron.com>
References: <20241118144117.88483-1-avri.altman@wdc.com>
 <20241118144117.88483-3-avri.altman@wdc.com>
 <2955aa00-824d-4803-96f6-35575ae9560e@acm.org>
 <DM6PR04MB65754AAF1FD62DC4ECF32A69FC222@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB65754AAF1FD62DC4ECF32A69FC222@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/21/24 1:06 PM, Avri Altman wrote:
>> On 11/18/24 6:41 AM, Avri Altman wrote:
>>> +     spin_lock_irqsave(hba->host->host_lock, flags);
>>> +     if (ufshcd_has_pending_tasks(hba) ||
>>> +         hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL) {
>>> +             spin_unlock_irqrestore(hba->host->host_lock, flags);
>>> +             return;
>>> +     }
>>> +     spin_unlock_irqrestore(hba->host->host_lock, flags);
>>
>> Why explicit lock/unlock calls instead of using scoped_guard()?
> Should I apply those to host_lock as well?

Yes, please use scoped_guard() and guard() in new code. I expect that
using scoped_guard() here will lead to code that is easier to read.

>>> + * @clk_gating_workq: workqueue for clock gating work.
>>> + * @lock: serialize access to some struct ufs_clk_gating members
>>
>> Please document that @lock is the outer lock relative to the host lock.
> Not sure what you mean?
> host_lock is nested in one place only, should this goes to the @lock documentation?

Whenever locks are nested, the nesting order must be consistent
everywhere. Otherwise there is a risk of triggering an ABBA deadlock.
So I think it is a good practice to document in which order locks should
be nested.

Thanks,

Bart.

