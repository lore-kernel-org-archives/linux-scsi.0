Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77DF194143;
	Mon, 12 Aug 2024 21:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723497867; cv=none; b=tW58XNs14QsSuWjVWTWO2fJ6aKBanIIPd6hg2PRe7OFn7h3IPRrEq5c2vdio/CWw47/KtcL7i21y78iANAjJIq8RG2yr3r8wI95cpEQNLai2QzmUqtPfxJqeia0aexiu8IUS0h8oZ3l28wSXcanjdFAPe8dO42Mvr3CNJpZVB5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723497867; c=relaxed/simple;
	bh=iH6jnQrISF1BRHO0r67xhOolK0vIIxly8lxvTKgcTBE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aCiTjnlw/tzjW143I/F/6b6cxGqYDwwoniOPhg3xiVnH7s5l+rqc4JxTjuw9JyWH6gBGnhNk1Wa7UBbqjatSM1nT9cAV2LMJsw5JIk70uC25xJ1RjPykhevoNvhbBMhysoJKzyRzCTzwsiYa5t77GSN5tGKxLRvLzXurPnMumtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=CCVn/uzP; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="CCVn/uzP"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WjSFj2BNKzlgVnF;
	Mon, 12 Aug 2024 21:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1723497862; x=1726089863; bh=QM2YMS1R1duA7Z1hyWX9+78D
	lYoVOMw+VcSUNBHdoF4=; b=CCVn/uzPix3bzN650Hh4jpTKXLs3fDHgWAAYPsWj
	W8jgpmEHGOjYwClkwyoWJcj3vLXhhkRFYj2C1GinhmeVsnnYwUpEIPAMO7UnTsbK
	lYec3xJpX32nNUEpjvjElbds5KEH1f9PLNYbZ2xCWlDHye6xVgw73t0T0w4G+xre
	rUP/EYPeB2u9BRGIj3QUp0hUKMX/8CpN61jp7avymqN2xEoVl1ymc1IYBfgUEIFW
	wl3woHyh1JcTVrftD2vjryjV3pJ+7/sJD38mfgHqg4h0yGTInoPHHNaFfHa/gug/
	pa31V0MHkdj4ScGE6LnZrCzrOPlRGH8lcwTsSArSeHI46g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id QWMS8g5n8hIO; Mon, 12 Aug 2024 21:24:22 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WjSFf2SHnzlgTGW;
	Mon, 12 Aug 2024 21:24:22 +0000 (UTC)
Message-ID: <be2a8462-38fb-4e74-905d-12bc9f678082@acm.org>
Date: Mon, 12 Aug 2024 14:24:21 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: sd: retry command SYNC CACHE if format in
 progress
To: Yihang Li <liyihang9@huawei.com>, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linuxarm@huawei.com, prime.zeng@huawei.com
References: <20240810015912.856223-1-liyihang9@huawei.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240810015912.856223-1-liyihang9@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/9/24 6:59 PM, Yihang Li wrote:
> If formatting a suspended disk (such as formatting with different DIF
> type), the disk will be resuming first, and then the format command will
> submit to the disk through SG_IO ioctl.
> 
> When the disk is processing the format command, the system does not submit
> other commands to the disk. Therefore, the system attempts to suspend the
> disk again and sends the SYNC CACHE command. However, the SYNC CACHE
> command will fail because the disk is in the formatting process, which
> will cause the runtime_status of the disk to error and it is difficult
> for user to recover it. Error info like:
> 
> [  669.925325] sd 6:0:6:0: [sdg] Synchronizing SCSI cache
> [  670.202371] sd 6:0:6:0: [sdg] Synchronize Cache(10) failed: Result: hostbyte=0x00 driverbyte=DRIVER_OK
> [  670.216300] sd 6:0:6:0: [sdg] Sense Key : 0x2 [current]
> [  670.221860] sd 6:0:6:0: [sdg] ASC=0x4 ASCQ=0x4
> 
> To solve the issue, retry the command until format command is finished.
> 
> Signed-off-by: Yihang Li <liyihang9@huawei.com>

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

If you want this patch to land in older kernels a "Cc: stable" tag will
have to be added.

Bart.
