Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493E3395240;
	Mon,  6 Jul 2026 14:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783348457; cv=none; b=CgSuT91AbKK8jtNmcvhmv1FCu0zgbdQWOTGQL5QZGobaxnCQebRgWpEbO3yjZrWY7yjCE3u8B7nAlvLZhbt8QzbzMJiLY5qVIdi+ZgtH6ppCu+D90Wq0qMO+mx4aefrXvN07rZDhGqq5FZVkViZCX1zZycUIN64e3jrDvRovE5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783348457; c=relaxed/simple;
	bh=FgCPWeln/kFw6RqWaS+SBhkbZJD5o4OXKGkFlXMgb5w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KsvXqW0P9mzoTy7XY0yeoOCXBi5yhu6hBhCd6gsqLSViCoV3b7lrWYnhKEn0MKJnE6YYJ0uAwLa8DeUeRr4GszbozBqyUiiqbrRFdeivANOfZL/w9ADbtcexoiHEeXTEGCLtYiMN3QzXvQCOQbKLwuhDqFsOVnYMiVYxmBa3pVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=OMxqNgmG; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="OMxqNgmG"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4gv6Lb5J75z1XM6JQ;
	Mon,  6 Jul 2026 14:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1783348451; x=1785940452; bh=WuLwV49+spEMXEvaQgJi0tNh
	xysoBrN7TbxsHcJzTwY=; b=OMxqNgmG98PbJ8CEJC6yoRiX3vib7Qy+2WwEY1Bs
	6yL1HeHGEnME5BQBjwUk7jRvbwqVnoly5UQ1pktvYtGvvk/pvVIVLxcrSNQLM5Pj
	Oi/FleC0vtAIre+UXqjR8ao86EDBIA0U+oiL2Tgpl+b9yZuRzR4iL8KCajQcHiOm
	ZEn2ynTVlHdDEW7lPz6TAJ2csvsOmIjJGwO4JZQt0xRY+tUwchrIMOyUOYVl+GQg
	ov+KFzD8X4mc5gZjEB06YcG/mc+dVBa5kpi8FxsPhLrJbW2BsPXkavYh6NcEp0r0
	w92qtZUP5hdOYFD/F6S72kCLWXd8XQOgPX9alBS87F2KFg==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id N-qZJ22PTEzd; Mon,  6 Jul 2026 14:34:11 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4gv6LR2sC0z1XM6J4;
	Mon,  6 Jul 2026 14:34:07 +0000 (UTC)
Message-ID: <88ee8295-80cc-411c-a1c2-d6c9e7ef5d03@acm.org>
Date: Mon, 6 Jul 2026 07:34:06 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] scsi: ufs: core: Always run tx_eqtr POST_CHANGE
 notify
To: Can Guo <can.guo@oss.qualcomm.com>, beanhuo@micron.com,
 peter.wang@mediatek.com, martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@wdc.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 open list <linux-kernel@vger.kernel.org>
References: <20260620080322.3765210-1-can.guo@oss.qualcomm.com>
 <20260620080322.3765210-4-can.guo@oss.qualcomm.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260620080322.3765210-4-can.guo@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/20/26 1:03 AM, Can Guo wrote:
> ufshcd_tx_eqtr() skips POST_CHANGE notify when __ufshcd_tx_eqtr()
> fails. That can leave variant cleanup incomplete when PRE_CHANGE saved
> temporary state that POST_CHANGE is expected to restore.
> 
> Always call POST_CHANGE once PRE_CHANGE has succeeded. Keep the TX EQTR
> result as the primary return value, and only propagate POST_CHANGE
> failure when TX EQTR itself succeeded.
> 
> Log PRE_CHANGE and POST_CHANGE notify failures to make variant callback
> failures visible in TX EQTR error paths.
Reviewed-by: Bart Van Assche <bvanassche@acm.org>

