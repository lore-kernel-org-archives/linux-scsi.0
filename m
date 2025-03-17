Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C25F1FE45F
	for <linux-scsi@vger.kernel.org>; Mon, 17 Mar 2025 22:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742251805; cv=none; b=Wx9BIF3bE7nfE7HFnIi13vdKs91jcH1lDXmd/M7tgauTOympNZQO8p0mAhOmT5KxYyh6P4S1SXhkFj1jamxuLohNXlvdk0CukZamxawevw7yuAd64+S9bh/THlEakR5cMlo8HY9LOA5fO5lLNjXswrt1lHP8chqsZCeIt5/UXu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742251805; c=relaxed/simple;
	bh=idCASc8F1qjkEE6GRF2fybfjFik8BtI/lgF/xJUD9BQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CNiBB18QrKjVwCN8Tcc/hgDMvZi3327TMZXyrd+uJFApFAi/USe+C2QiIEGG83oS4xe5zr7QPCbMbW2rxbE4Xak+v0J/vQ77chbQOqllPHkJWSO6Q/Uu0FodgHSSE0zXLJ/HsUxOq1M90gnp9B1fITCGyPlGvGFXzvG04FqlK2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=HeP5HYqx; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="HeP5HYqx"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4ZGqtL2q5GzltP0r;
	Mon, 17 Mar 2025 22:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1742251800; x=1744843801; bh=TKPg+cRk8W9+jNdrfgKEmz0q
	siR8F490DSGY4AB/Agc=; b=HeP5HYqxOrpyKIsgqcoSs1H2Sw50KmbcMC+/zUc/
	T9sp658S1xWizPuxkAXawD2UkTWvmMyOgCVqO3bZEtw44r5OI6dxiDzfJXH/8CVX
	7Ao+lJTLZ44l6FUbGUapYSQdo7cn3zMPH4jsO99vB8QbeZajkYBVUZSN7pSE2D3I
	8io4Us5LujJg+Pu8XTGUMQYcxgKbCp9W95uH2HNZUeMwt9nLC/iL24PhqGzOKG1q
	eGw0UPjeP2FhlnMrRCK/YbHyfQx02UnL32sfWdPeZtM3N0SKtrt7C8NErKlyU0HC
	NflSfBW7bBiYu2z+/8PQlZ64hHTDsbtteMK6FpbwVTxuLw==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id RWyKz0MEhZiG; Mon, 17 Mar 2025 22:50:00 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4ZGqt81qskzlryq8;
	Mon, 17 Mar 2025 22:49:50 +0000 (UTC)
Message-ID: <993ecbf6-3ef2-43a9-9586-59bd4db0553b@acm.org>
Date: Mon, 17 Mar 2025 15:49:49 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: ufs: core: Fix a race condition related to
 device commands
To: Avri Altman <Avri.Altman@sandisk.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Avri Altman <avri.altman@wdc.com>, Peter Wang <peter.wang@mediatek.com>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Eric Biggers <ebiggers@google.com>, Minwoo Im <minwoo.im@samsung.com>,
 Can Guo <quic_cang@quicinc.com>, Santosh Y <santoshsy@gmail.com>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20250314225206.1487838-1-bvanassche@acm.org>
 <PH7PR16MB61963DEE199FA75742C2A47DE5DD2@PH7PR16MB6196.namprd16.prod.outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <PH7PR16MB61963DEE199FA75742C2A47DE5DD2@PH7PR16MB6196.namprd16.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/15/25 1:46 AM, Avri Altman wrote:
> Shouldn't you now call for reinit_completion now?
> before wait_for_dev? Or at ufshcd_dev_cmd_completion ?

complete() increments the counter in struct completion and
wait_for_complete() decrements it, isn't it? From
kernel/sched/completion.c:

void complete(struct completion *x)
{
	complete_with_flags(x, 0);
}
EXPORT_SYMBOL(complete);

static void complete_with_flags(struct completion *x, int wake_flags)
{
	unsigned long flags;

	raw_spin_lock_irqsave(&x->wait.lock, flags);

	if (x->done != UINT_MAX)
		x->done++;
	swake_up_locked(&x->wait, wake_flags);
	raw_spin_unlock_irqrestore(&x->wait.lock, flags);
}

As one can see complete() increments x->done if it is less than
UINT_MAX, which should be the case in the UFS driver.


 From the same file:

void __sched wait_for_completion(struct completion *x)
{
	wait_for_common(x, MAX_SCHEDULE_TIMEOUT, TASK_UNINTERRUPTIBLE);
}
EXPORT_SYMBOL(wait_for_completion);

static long __sched
wait_for_common(struct completion *x, long timeout, int state)
{
	return __wait_for_common(x, schedule_timeout, timeout, state);
}

static inline long __sched
__wait_for_common(struct completion *x,
		  long (*action)(long), long timeout, int state)
{
	might_sleep();

	complete_acquire(x);

	raw_spin_lock_irq(&x->wait.lock);
	timeout = do_wait_for_common(x, action, timeout, state);
	raw_spin_unlock_irq(&x->wait.lock);

	complete_release(x);

	return timeout;
}

static inline long __sched
do_wait_for_common(struct completion *x,
		   long (*action)(long), long timeout, int state)
{
	if (!x->done) {
		DECLARE_SWAITQUEUE(wait);

		do {
			if (signal_pending_state(state, current)) {
				timeout = -ERESTARTSYS;
				break;
			}
			__prepare_to_swait(&x->wait, &wait);
			__set_current_state(state);
			raw_spin_unlock_irq(&x->wait.lock);
			timeout = action(timeout);
			raw_spin_lock_irq(&x->wait.lock);
		} while (!x->done && timeout);
		__finish_swait(&x->wait, &wait);
		if (!x->done)
			return timeout;
	}
	if (x->done != UINT_MAX)
		x->done--;
	return timeout ?: 1;
}

If I read the above code correctly, it waits until x->done != 0 or the
timeout has been reached. x->done is decremented if a strictly positive
value is returned. do_wait_for_common() ignores pending signals because
state == TASK_UNINTERRUPTIBLE.

Bart.
