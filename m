Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E092BEC57;
	Thu, 19 Mar 2026 17:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773940475; cv=none; b=WJnmRVb3Vwqz71aAolGsQTKf0t2LRBAaeCrZd8wycK6JaVcsdPwJe46hnbtCnZ0+xS9JU3Xd8W11YACaVj3xmpWgHIxODdLK9TV8JrMcAz7ihSIjeH/vbm0+KuxoSkR1YALolzVKsz6hWp7SFwvJQ9TdBu0ZFvvwVCdk9oEIBnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773940475; c=relaxed/simple;
	bh=iXoToCFnmo02oQkUHujesWeGeHlqhi1QJtkcTwV4ejA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mYSH1hXC46pYq2P64TTlMHUScYhRXYyRMf6OnzfNTAuU241gHuaSWD3b1hApaT6RZCTmkCTB9A7iZQA0Ope6E3T4tpefS5Sk6YK5eclIldmVQrm6aOGdBZxwGMVoDa+L2bUE9288myZ4/EOhgRSDJz8Pdl5V5Dcb51EmXfrOFio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=4JdTh93F; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="4JdTh93F"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fcC3l4TR5z1XM5kY;
	Thu, 19 Mar 2026 17:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1773940463; x=1776532464; bh=iXoToCFnmo02oQkUHujesWeG
	eHlqhi1QJtkcTwV4ejA=; b=4JdTh93Fzmo/FRvQ1NM/zBZn1hTZBw0B1Cp3GzdS
	VNyqTvMaG+Uq5xxrt0U76kRg3/FlKL4yIucf/4G0bWlyz4dOcD4R/FC3bV4QSoUV
	9Zb0GqvQzPtRIcO+83vMBGpI89wINaBsYJZBS9mJzcoTLByyjdn7nKvCBq9WwW6y
	UXXJYYDVkFr43QUR2cGgynD8UXgLsSkd0IxwaQCbqSbnVhQ7GiyDV1lbHo8qEZet
	XDU9XeI88vp0++UCwSIZbQdHTwJHjF/3fCJ4ArIGy9InYazES+iQbqCGC5JaYHEF
	SI5DR2FDD6Eo6kTbn0T9p1V2qK5cmNJBUzrG41ndd8ltug==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id sPkxWBeDxjBQ; Thu, 19 Mar 2026 17:14:23 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fcC3Y0Vmvz1XM5kW;
	Thu, 19 Mar 2026 17:14:16 +0000 (UTC)
Message-ID: <b73a2a08-7464-4f54-a485-a7d361eab668@acm.org>
Date: Thu, 19 Mar 2026 10:14:15 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: ufs: core: Handle MCQ IAG events
To: vamshi gajjela <vamshigajjela@google.com>, martin.petersen@oracle.com,
 James.Bottomley@HansenPartnership.com, avri.altman@wdc.com,
 alim.akhtar@samsung.com
Cc: peter.wang@mediatek.com, quic_nguyenb@quicinc.com,
 adrian.hunter@intel.com, beanhuo@micron.com, arthur.simchaev@sandisk.com,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260310190308.2474956-1-vamshigajjela@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260310190308.2474956-1-vamshigajjela@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/10/26 12:03 PM, vamshi gajjela wrote:
> Add support for handling aggregation-based interrupts when operating
> in MCQ mode.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
