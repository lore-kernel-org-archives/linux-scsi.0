Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2483BB48;
	Fri, 13 Jun 2025 16:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749831620; cv=none; b=XDqyRKpLmV+qaRI8MllMhcXR2F7dxA8FiTIGFiG97D8SdeaJTHp53cCNZ45Bpc/mJKwJVxRxQ7C8lDqCyrC0wuNjAOpCcKlWY6RB551NPNN9q1R5gNAG/Z14y9cfCCRbEc7i4M6ocQbpv8A/khraSIxfQafgCwTnGWixRbgECdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749831620; c=relaxed/simple;
	bh=CNErbTXB19qmacs6+xkbQ/5C0W3lKEIyxjPb4zKkg1E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MQ6ie2yG3z2Tu45ttahImr4MffXAsw5SwfV6fIejOsiu9zgss9/0/VwngPt9BjXmUll7mlpd7aNmlvJfFXwcDW27dLNBDxINK2zmf09oBDpn9eHpqWP2UyvLCbHa5I7r2W18B7vefHWXnF7eL2u6E6yR2NbfA+TEREEtUNmVKkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=gbmiJziu; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="gbmiJziu"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bJl3v13Y4zm0yst;
	Fri, 13 Jun 2025 16:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1749831609; x=1752423610; bh=CNErbTXB19qmacs6+xkbQ/5C
	0W3lKEIyxjPb4zKkg1E=; b=gbmiJziue20r5dFW8Xxl9VhoPK4ydfn7ypM2sCED
	GHNb7a658Z3BHUECI/vxwRFgDDvl7uu98cvOmkFJHovv5KkJHW0QmYkAk7mkGBLs
	yGUGeRhYmoe4+V85a5HK1bPXRrWmvxJmbOhMXsLbllgjFIbgYbXJzJtyuUYLnA4k
	PdZDKN2eGFl6CkFbWQ20qyV0XNgIHmox1qcjyCDvhxIyWf5bWnXXOnoHpsSsi25I
	RFPmrLJ1HehlOnLlcPWbr3j4eIUMSLx8AiobfzExDPvmGCGToX+Y5scDlB4rUeTy
	LQXODrojt06aBK1n2EKgApLO/oO8iTSNpshfqsv9rJvLEA==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id XbKdJ0pP__oj; Fri, 13 Jun 2025 16:20:09 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bJl3m2Cr8zm1HbX;
	Fri, 13 Jun 2025 16:20:02 +0000 (UTC)
Message-ID: <07975e85-2424-4ae9-8f31-d689c09d21dc@acm.org>
Date: Fri, 13 Jun 2025 09:20:01 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: Do clk scaling conditionally in reset
 and restore
To: Anvith Dosapati <anvithdosapati@google.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>
Cc: Manivannan Sadhasivam <mani@kernel.org>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org, manugautam@google.com, vamshigajjela@google.com
References: <20250613103140.1121621-1-anvithdosapati@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250613103140.1121621-1-anvithdosapati@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/13/25 3:31 AM, Anvith Dosapati wrote:
> In ufshcd_host_reset_and_restore, scale up clocks only when clock
> scaling is supported. Without this change cpu latency is voted for 0
> (ufshcd_pm_qos_update) during resume unconditionally.
Since this patch is a bug fix, please add "Cc: stable@vger.kernel.org"
and "Fixes:" tags. See also Documentation/process/stable-kernel-rules.rst
in the kernel tree.

Thanks,

Bart.
