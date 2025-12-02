Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17510156678;
	Tue,  2 Dec 2025 01:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764639245; cv=none; b=QWD+PSxqhbVihHigDF29JfzOaFhkv0wD5q3ab2TzLNg8SLv4C3rZ3Ks8BR0pWLhptVVNF1eWqYtPB1sHltTorwiMCzsF0MG3NJF0iBTQsNNKbul0s5JfKwXa2paGKhN9FcjNxhqUDyQFLLO1x8yGdbp4F9+gIa9Y9Ig3j6OYW2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764639245; c=relaxed/simple;
	bh=OrVMD/BngWGi0WhA+suouSOxL4C/gwU0fVv7jC/po8U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=urM7e/EHMz381Q6Xs6JDC36UXzuf3s0aBjfvp3CcV95Fq6xLVvo8BLv4wBR+3KqDMaN2dQ8EebjcDRP4cmyW/QwwZwQEraXjfKvm1zKIqUHw9PYdMkvML0L+ecsdigyWR3w8Aih1bPhMvOVsWXXeWWfEy9qvj0y3B/Ck/GTOtKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=mv9SkwiE; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="mv9SkwiE"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dL3G3417vzlfgPr;
	Tue,  2 Dec 2025 01:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1764639242; x=1767231243; bh=KIpbx5R9seDQY+SG16E6sJVy
	GyZqe7tYqr3Lz7alEwY=; b=mv9SkwiE3yTvyrH4KlDV7zibCMkopJdphbTM2Xjp
	iLmj5B/oQwkg5aMBGKCSifGq4AwwV4Z3Gn+1IoDvvVSJXnYl+znlBGA3U1xCUH/Y
	f8sCsth9TeRg4y1WEXdkQER8RF2JYOb/JFro6S16y+B+R/fCplmT4hNYOabDTbrY
	H95Qck4+ANWjV7UO0ZH9ZNYrDUKuvaf44rHuxxjFnlNJXUopp+0npQcoyp8NTL15
	A7QED7k+8kqf8qSsTDXrxVDYQ3fQYwGCe21+7P+HJ+8YraCosp5vWNKZvaqd8FbC
	jeYzVqTAdiVHeBEoeitZXWsIL/bFDBalVw4nQHZLHKS7rQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 4JPY0cxbmsQ9; Tue,  2 Dec 2025 01:34:02 +0000 (UTC)
Received: from [100.68.218.127] (syn-076-081-111-208.biz.spectrum.com [76.81.111.208])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dL3G007LCzlfvpH;
	Tue,  2 Dec 2025 01:33:59 +0000 (UTC)
Message-ID: <3064625c-9ce6-4d40-9a2b-91f58af364f0@acm.org>
Date: Mon, 1 Dec 2025 15:33:58 -1000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] scsi: core: Fix error handler encryption support
To: Po-Wen Kao <powenkao@google.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>, Eric Biggers <ebiggers@kernel.org>
References: <20251202011529.73738-1-powenkao@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20251202011529.73738-1-powenkao@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/1/25 5:15 PM, Po-Wen Kao wrote:

(+Eric Biggers)

> Some low-level drivers (LLD) access block layer crypto fields, such as
> rq->crypt_keyslot and rq->crypt_ctx within `struct request`, to
> configure hardware for inline encryption.
> However, SCSI Error Handling (EH) commands (e.g., TEST UNIT READY,
> START STOP UNIT) should not involve any encryption setup.
> 
> To prevent drivers from erroneously applying crypto settings during EH,
> this patch saves the original values of rq->crypt_keyslot and
> rq->crypt_ctx before an EH command is prepared via scsi_eh_prep_cmnd().
> These fields in the `struct request` are then set to NULL.
> The original values are restored in scsi_eh_restore_cmnd() after the EH
> command completes.
> 
> This ensures that the block layer crypto context does not leak into
> EH command execution.
Since I suggested this approach I think it is appropriate to add the
following:

Suggested-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
