Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8FFF4E4C3B;
	Mon, 21 Sep 2026 17:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790010852; cv=none; b=eZWElkI67tFKtC5EskaqQFIrGDN5lJaLoWwaOkpv0IgT1vU6Ttpi4Ar6bZ+A2m50xBzsEyjVPbGJKYg50Y9zSfSwlXXMAQ6OHkYgaCkQ04vhBzJDeeA535o3KzktuJ1SA2EwyUm6yt2QxxHblvMuCpr41v91jl50llxZHIkgagg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790010852; c=relaxed/simple;
	bh=kqxY2zov/jVqeQ1KVFISrBCe3FoqDqXuMzz2Ve5uYVg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BoK2VGhxCNw3zfNAqGwbhNwJ4NMj5mYu+pFI8znUVcwNWox6N0zibmzR9gfun7eTqFGjwzPlnWtzm5E9q/4RRWmf0EQ2oAHi8E6avSFLI1CVZcSEd4uiORJ9IpEzjxmuGR7Aw5OND33IqnN2KL8Wh/4STkHyxVCZu0i8sktQgQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=5FJKXyK5; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="5FJKXyK5"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hpVFY4rXLzlfvpT;
	Mon, 21 Sep 2026 17:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1790010842; x=1792602843; bh=AskVSoJkNZBuJ/DQFvVg79Le
	i3Ww/xenqZy1OnJA3VI=; b=5FJKXyK5zFdcAfCURSDmtfCYPPm9BqJqdWtEznY3
	Q57cWPkS5jXGCb3oNZQ2CIE0fDN/BWI+q0eFMKja9yX4R6fMdJV5SUJAZP6LjlEA
	vXV3AJCdi/hkpbE6yRECl3wyXUXUEJthg2ZXt2dHbos10dYypVHo+PH/iG0Fou15
	heWyC/cXo/Zu7E2STILTtDl+LQzvHgDwXHjhy18gSoe5Ld67aVziGdSh+btaCaTp
	82Dg29P3scXmSIO19E33EbNXyf6FgKjk8xNQTPHsVsydsUuZVsJhsXiCGf/waxLW
	aVTgQXS2ve+JTli7SefzqK8q7rTIHjapoSbPQCeXBtwapQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id MIflE73B5RyQ; Mon, 21 Sep 2026 17:14:02 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hpVFJ6vRQzlfvpH;
	Mon, 21 Sep 2026 17:13:56 +0000 (UTC)
Message-ID: <e3538f10-fb9e-48ce-b48f-bca25c8f3d6c@acm.org>
Date: Mon, 21 Sep 2026 10:13:55 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] scsi: ufs: core: Decouple CQ sweep from request
 iterator in MCQ
To: Stanley Jhu <stanleyjhu@google.com>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <mkp@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman
 <avri.altman@sandisk.com>, Peter Wang <peter.wang@mediatek.com>,
 Bean Huo <beanhuo@micron.com>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 Can Guo <can.guo@oss.qualcomm.com>, Manivannan Sadhasivam <mani@kernel.org>,
 linux-kernel@vger.kernel.org
References: <CAE14pdek6ynze+muDZrK+yNX-3ioe3vprxOA4W22qokg352tJQ@mail.gmail.com>
 <20260918143809.3034592-1-stanleyjhu@google.com>
 <20260918143809.3034592-3-stanleyjhu@google.com>
 <1ddc5181-f547-465c-bfbe-dbf14a91493e@acm.org>
 <20260920135014.3528082-1-stanleyjhu@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260920135014.3528082-1-stanleyjhu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/20/26 6:49 AM, Stanley Jhu wrote:
> On 9/18/26 9:06 AM, Bart Van Assche wrote:
>> Forcibly completing SCSI commands from inside the UFS SCSI host reset
>> error handling callback is incompatible with the SCSI core error
>> handler. The "force_compl" behavior should be removed instead of
>> reworking it. If you take a look at the SDB (single doorbell) code you
>> will see that forcibly completing requests doesn't happen for SDB mode.
> 
> Note that ufshcd_mcq_force_compl_one() already checks
> !test_bit(SCMD_STATE_COMPLETE, &cmd->state), so it only completes non-EH
> commands (e.g. during an autonomous ufshcd_err_handler() reset);

What are "non-EH" commands? The SCSI error handler only starts its
error handling strategy after all pending commands have either timed
out or completed.

I think that you are misunderstanding the code. The purpose of the
SCMD_STATE_COMPLETE check is to prevent double completions of SCSI
commands.

> in SDB mode, ufshcd_hba_stop() (HCE = 0) clears UTRLDBR to 0, so
> ufshcd_poll() similarly treats all outstanding_reqs as completed
> right after ufshcd_hba_stop().
> 
> That said, doing this inside ufshcd_host_reset_and_restore() right after
> ufshcd_hba_stop() is indeed the wrong place: at controller stop time we
> should only release LLD resources (ufshcd_release_scsi_cmd()), and
> requeue any remaining non-EH (!SCMD_STATE_COMPLETE) commands with
> DID_REQUEUE only after host/link recovery finishes (so autonomous resets
> neither wake callers mid-reset nor leave in-flight I/O stalled for the
> 30s block layer timeout, similar to autonomous reset handling in
> hisi_sas, megaraid_sas, and smartpqi).

In SDB mode, clearing UTRLDBR will cause all pending commands to be
requeued because the OCS member is initialized to 
OCS_INVALID_COMMAND_STATUS and because ufshcd_transfer_rsp_status()
translates this status value into DID_REQUEUE << 16. I'm concerned
that this approach may cause the deadlines for SCSI commands to be
exceeded. Hence my proposal for MCQ mode not to requeue pending SCSI
commands but instead to let the SCSI error handler decide what to do
with these commands.

Thanks,

Bart.
