Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28BAE10785;
	Mon,  4 May 2026 02:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777861856; cv=none; b=mOBklqMgk2YEznfEjeA0n6I3zyXqE2g0PyMjEnPcSZ5r5CWw5/UuUnicOwkZjfft1iZg9yzNUQ32r+TE+6BoxDpSwKCeshJk7S1ZE9SN7MJWjEEyGZi+9H8hBOcVRSjKpfOpR1D23j+Qs8TNNBv1dZgGxTZGdb6TJg8FBeGZdcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777861856; c=relaxed/simple;
	bh=nQ59hFSTNLKwIsGnos/FQe+GP54UIHtD2n43AqR22+w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b38X6aGgxy076h/gBxnTksfMxQevTeetVQAbRRhs1qkth9PdKeFID3fnX/d5S7+evtyFa0GxaXotv05woENdw8PjOGrlaaEeyQJm4S0DhBQWLFU0dEYjPEVCvCuLuWR5tLIZHLQfUBszoK1LA+O11Qjq4caQxlZMmua+B+E49jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Xje3m3Pk; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Xje3m3Pk"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4g85Gw1LgjzlfwHS;
	Mon,  4 May 2026 02:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1777861844; x=1780453845; bh=VigNCXKT0O25ajfnUdQKCKlM
	C5Qwj9i3pq5HA09F+bU=; b=Xje3m3PkwjybofyEmE7eyo4vCBTdHKYpF9q/r2xf
	Nvj4jrLSEmkNUwIbCPJ0XXCMP56dk7eXmYiIP3vd+4X4/fvoNFJlH5+q84Y3szYM
	fOngvkydNhMN+jAYsgpuYcrE+JziauXrVPpn/KmV5ieHy7w/G9jA4fp6ixfcxkIM
	se2+91Sqie3YjDppXewMQCBHhnjbkZLVk+VLuX5Wg/kVjNZkgW2KB1cPhRW2DgVr
	+gC6C3N3Z786s/kIF+i8UiBoPpR4rabmAdXwHkBDz0BWTAHWyi8yuKBIHJ5h7lpk
	prZ3F568c8CzUmJ3f0bfTFf+FR6Aczqp50fweKY/18Rosg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id hpxg11yaNnif; Mon,  4 May 2026 02:30:44 +0000 (UTC)
Received: from [10.211.8.56] (unknown [213.147.98.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4g85Gn2L8Dzlfl6R;
	Mon,  4 May 2026 02:30:40 +0000 (UTC)
Message-ID: <0f7918bf-adfd-4529-91da-460b914aa022@acm.org>
Date: Mon, 4 May 2026 04:30:38 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] scsi: ufs: core: call hibern8 notify when hibern8 cmd
 failed
To: Hongjie Fang <hongjiefang@asrmicro.com>, alim.akhtar@samsung.com,
 avri.altman@wdc.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260502143012.2859480-1-hongjiefang@asrmicro.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260502143012.2859480-1-hongjiefang@asrmicro.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/2/26 4:30 PM, Hongjie Fang wrote:
> The vendor hibern8 notify callback always can be executed in the
> PRE_CHANGE phase of hibern8 enter/exit. But it cannot be executed
> in the POST_CHANGE phase if the hibern8 cmd fails.
> 
> When the hibern8 cmd fails, the vendor hibern8 notify callback
> should still have the opportunity to execute.
> 
> Add a third enum ROLLBACK_CHANGE for the ufshcd_vops_hibern8_notify(),
> pass the ROLLBACK_CHANGE when the hibern8 command returns a failure and
> use the POST_CHANGE otherwise.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
