Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06DBF19066E;
	Mon, 25 Nov 2024 21:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732570553; cv=none; b=jb5U8SJKbh+y48OiZnD1kuG1P7fYkicHE3P7l1VTP7q/VdQr4B3mY9ejK1w0WvxLm6l0HxFWfiMqz5IVKhjJ9OlxKvQDcUrFXtVfTaNb+s9QKxe9IGtyP/l9yOLtStw5+VnVU0VBY7Gpyl7vpyYSoPPA1cjkcCKkJUEMwKA7mvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732570553; c=relaxed/simple;
	bh=+tpMmL9/XD1fkXGSv4k2+BJ7zMnhSXY5CaysoEvs6D0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N5H7vpCc+mywP+tWF1Ko3uP+IyeQCLX1QI1KAsoMALidbJiKRihBe4f8Vq9kk4WdZV8DOQThXC9CMUStyeajYgsdRAGgbPsUy2Y9iBqbj858XF/1KrtRXoUfH3mfORnrtkMTor/5qZL0S0YcB1Shw1acQ2ucD1JAU/ScaM6AxaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=4NZk8leh; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="4NZk8leh"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XxzXR3WKRzlgMVj;
	Mon, 25 Nov 2024 21:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1732570549; x=1735162550; bh=IrHa5ZNEao7sHyok6XycjVxW
	xoDIc4VvGpQ4W2EzdGo=; b=4NZk8lehkVLMpfP5MasbBuRVEePjM1zP1aOX16nF
	Ys7wbkWaDkvnH0sphysNmLEZPvTnFu1Fnm7fqaJTADcz8tsBQyuTqxNrqRK5okPF
	XBNQy9iJ3/XDGJeMxoJPvFu+iXxEYeQoGoj0LKPO70qDc4XPGH4X69m1u/lzaf4g
	4rjp46hy1NSiAJp+T6DW/eQKutZiYrBIK3fTXs1EpjBoYhwTIBKZlR7vVnz1WYQK
	pcxPiubP86bj0NQ6JFAHpiEHIBziSZeYlkJoG0aX9SoFonqLrrdF202T7DwOAWMr
	2aaHQhLKrP317RigVDpxEOuvuxmPwf5SZf3bs38611IRwg==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id zBVirz8dkYpD; Mon, 25 Nov 2024 21:35:49 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XxzXM5DBZzlgTWQ;
	Mon, 25 Nov 2024 21:35:47 +0000 (UTC)
Message-ID: <ee1eaed1-3ce5-4037-a385-18febab695a0@acm.org>
Date: Mon, 25 Nov 2024 13:35:45 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/4] scsi: ufs: core: Introduce a new clock_gating lock
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 Bean Huo <beanhuo@micron.com>
References: <20241124070808.194860-1-avri.altman@wdc.com>
 <20241124070808.194860-4-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241124070808.194860-4-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/23/24 11:08 PM, Avri Altman wrote:
> Introduce a new clock gating lock to serialize access to some of the
> clock gating members instead of the host_lock.
> 
> While at it, simplify the code with the guard() macro and co for
> automatic cleanup of the new lock. There are some explicit
> spin_lock_irqsave/spin_unlock_irqrestore snaking instances I left behind
> because I couldn't make heads or tails of it.
> 
> Additionally, move the trace_ufshcd_clk_gating() call from inside the
> region protected by the lock as it doesn't needs protection.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

