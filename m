Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E86F7433D1;
	Mon,  9 Dec 2024 19:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733771617; cv=none; b=kvJHkklNe4Q398+rXA0n+jvcRgiHzSyZI4krzBypNvsjC5cKjREXyv1bg+fv4uHhgrZgaVov5HOcBpMbXz8vlyCpbdRbGwXoueyZV+keohZyd0GIMdZMQrnMu6WOeBUqeRGrdkYf7XP7JF9UiCp9RfXSWsW4AleHdFGXwA5o2go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733771617; c=relaxed/simple;
	bh=x/6mdVaQD66fUETMfDy8Ko59PDfOmbDeJAXGrA5l0eI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SC7jBifB6aTQ2X+FfAUFeRizwr9RxhYINLtjvv+dkf2WAG2VJd7nLxD59DKl9Ag3u6mveiHNpO+AHhdjiGKNJpBn4vMbFECxd0AzihwFWxADtVW4dqxqSr1tJemZaFxyf9/c17tDhox99odU1xIQCGux+CITzbpOpyImstNFsmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=rTUVP9dv; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="rTUVP9dv"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Y6Wjq2K8sz6CmM6Q;
	Mon,  9 Dec 2024 19:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1733771612; x=1736363613; bh=DrqYJLXRVPPjNX6SAaFm+a2c
	KjD9b5KZtgJ2dWi/Tg0=; b=rTUVP9dvGIKoJQ72rzoW11QtYnxJ3iJdPGmfWoq2
	eDjjGPGEgSaBZ/uEP+GiTWYnANbCP4JvRa0UxHa6XtRLSyumeAxFpOmbWNutlw1V
	hIAYkKPFpAP7bohEepBykJK5sov14eCeO83I9pCW3jfnWQQgq6PgALgi0qQPB82Q
	Ta4E8P1WAJdOuontt1QLlIxlkgYAi1wFtbHAWfqvPSc+i1UM3KySq6VUC62vWHvq
	2R2ac7jVnPyBNOvVzJ3n4RHvm6TnDFQRcIdVqVP+lVTtHWPYe5jtRreIo/tiaubl
	swOMvdot8bj+LCgfQnhsr0rCWbsdW7FcOqjgx3NTlS9CQA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id FUFZ7ZJ4S76Z; Mon,  9 Dec 2024 19:13:32 +0000 (UTC)
Received: from [192.168.3.219] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Y6Wjl5SMFz6CmQtD;
	Mon,  9 Dec 2024 19:13:31 +0000 (UTC)
Message-ID: <d5364b55-5846-4c96-8a95-2fba3667efbb@acm.org>
Date: Mon, 9 Dec 2024 11:13:30 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: ufs: core: Do not hold any lock in
 ufshcd_hba_stop
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20241128072542.219170-1-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241128072542.219170-1-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/27/24 11:25 PM, Avri Altman wrote:
> This change is motivated by Bart's suggestion in [1], which enables to
> further reduce the scsi host lock usage in the ufs driver. The reason
> why it make sense, because although the legacy interrupt is disabled by
> some but not all ufshcd_hba_stop() callers, it is safe to nest
> disable_irq() calls as it checks the irq depth.
> 
> [1] https://lore.kernel.org/linux-scsi/c58e4fce-0a74-4469-ad16-f1edbd670728@acm.org/
> 
> Suggested-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Avri Altman <avri.altman@wdc.com>

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
