Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729AD35E944;
	Fri, 17 Jul 2026 21:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784323067; cv=none; b=YAK9bL4WDA9qBPf8yG+aKz0k7wwMQ9oAMRpZF/e+IcWYLJDLNaP+3rEZ1N8BV9oYfur7g2+HoEFJzrHKFLgRxwdivFVOsWGYjlAxv48fzTkbbGP9egp6wT2Xwj7wJZVBmWEbk+yjJy40w5ssboIGfOLk0ZTERYWtIHLJbrWmcOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784323067; c=relaxed/simple;
	bh=dTSVQD+7tUB/G/Cudzre6neP5V5pOYq7OkaeF11dlVo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=qz10gmjvr/qWF3V/NTErV+5rKpqIl6bnjZaoRI9vj1GtP0kC9GVnv//5V7IfxaBx+b4HqlIqB22hd09YlNfFnS0+7PLWVjUoDdQoCfs9uSmkUcCh38TAq44UNqNmc0mNhMBURFrs8/3Ub3UcdyYt/1rxBraV7tBehOk6EOUDtmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=4zC1tRbW; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="4zC1tRbW"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4h22n04g6Qz1XM0p3;
	Fri, 17 Jul 2026 21:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1784323055; x=1786915056; bh=dTSVQD+7tUB/G/Cudzre6neP
	5V5pOYq7OkaeF11dlVo=; b=4zC1tRbWAakR6bcajns2sAkaHm1pH1XvcWRygQTS
	AEZwC3WScPnUcxlj0a+/NE2IAOeDLw2Sfm1dnwaaZA+/PRvS/TyVxzUWdZv+y2cu
	Okze/sc2oYimtOWzM0XemkyrIf6cL3D8Zjg6Ho/++6SPVhuj++yahORKkQE4Yrqy
	Q/jMt6ctt2LLQG+feqkkfwx2lDCyz7/LYMhGHfJ5rks8bKLtohMai+icOTq9tvza
	PlWgxfiDElbbsKA33Aew3XeYk/wNdbcQg+8oSYoa4xKIcWSUofUpYwFxMbLFVx9p
	SGGa9MdXdJ8ykWnLWdgAI2GgJ22eWIPqQNJ7BefZXcglOw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id hIgXnfgwNQ-k; Fri, 17 Jul 2026 21:17:35 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4h22mr2PrZz1XM0ny;
	Fri, 17 Jul 2026 21:17:31 +0000 (UTC)
Message-ID: <f6e3699a-690e-4ddf-849f-3aac4cf3a3b3@acm.org>
Date: Fri, 17 Jul 2026 14:17:31 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: ufs: core: cancel RTC work in active-active
 suspend
To: Guangshuo Li <lgs201920130244@gmail.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman
 <avri.altman@sandisk.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Peter Wang <peter.wang@mediatek.com>, Bean Huo <beanhuo@micron.com>,
 Can Guo <can.guo@oss.qualcomm.com>, Adrian Hunter <adrian.hunter@intel.com>,
 Wang Shuaiwei <wangshuaiwei1@xiaomi.com>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260714172726.1736967-1-lgs201920130244@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260714172726.1736967-1-lgs201920130244@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/14/26 10:27 AM, Guangshuo Li wrote:
> Cancel the RTC work before entering the vendor suspend callback in the
> active-active path. Since this path now cancels the work, move the RTC
> work scheduling outside the device and link state restoration block in
> the resume path. This restarts RTC updates after an active-active
> suspend and resume cycle.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
