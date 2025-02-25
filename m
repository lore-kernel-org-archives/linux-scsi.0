Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CCD0DF59;
	Tue, 25 Feb 2025 20:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740516937; cv=none; b=GPXlDnCUUKmL7hf8QH8AUlI572mpB0taEq36CSTHUNco6W1BmvEsM412d5eeXHMcwGO9P93ts0zGrBrKNlueKKGFjQcC6LtQQQKsn3G8xCwiudTloHoj6JiroV45aD4jrAO75LpmEEuz50mFpdPleiVIKUaOgHPXuc2hWrIIkrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740516937; c=relaxed/simple;
	bh=lco9n0RxUuvAOMk5F/ODYsml2IC7jczYWBV1xX6v8nI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gL1J5AWuIdDTNLqNtUvA7FNxpmy/LVP4b2yZ3NtpDoww+MLnnwrfsZ6g4KeWkaz6eWNkVkEWn2hZLg59CAt6PZTBnMNB+9+fckVSshxEhWmljA02WbahI1f8SY0rwHbV13vrke1XTmw8fu9X9k+SIyMPa+SeEw7NfzzGVGyJD+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=TWB+zjWh; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="TWB+zjWh"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Z2VHN62PqzlgdL4;
	Tue, 25 Feb 2025 20:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1740516927; x=1743108928; bh=lco9n0RxUuvAOMk5F/ODYsml
	2IC7jczYWBV1xX6v8nI=; b=TWB+zjWhX+MrxF35TSdsCelXH9JRaI4IplaTbIg1
	JgAoC+/m7KmujkcDe4C/7m9TjPMvwsI1EPDNgDssGlhzN+0HiUF9DBmfYUjS+Mc7
	qYYvpeREFltqvlxz794fulJiQdlGy3hbXjSqMMHybSx+/hUT/l2l8bQSMURpNbpd
	9ARushmTP/XY86ARXC750XVYpI0xQEwePzBtqC9xiwpTTtQpQUIMSNh11A5neeqc
	bJ/xAizY/fWiooktqwAELE+qVQwIF+PkEn1fScRp20VrdqiTdTUiVJal/o6vOZPs
	4KSshjAbafG1Kz4MAtj4es9z2TEFxzZksuj9EvS6cKghUg==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 8lZd0LW-LFXu; Tue, 25 Feb 2025 20:55:27 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Z2VHL500NzlgSFk;
	Tue, 25 Feb 2025 20:55:26 +0000 (UTC)
Message-ID: <88f09f1c-c80b-4c8c-8e7d-08ab9cdb7a9c@acm.org>
Date: Tue, 25 Feb 2025 12:55:25 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: fix missing lock protection
To: Chaohai Chen <wdhh66@163.com>, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250221030755.219277-1-wdhh66@163.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250221030755.219277-1-wdhh66@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/20/25 7:07 PM, Chaohai Chen wrote:
> async_scan_lock is designed to protect the scanning_hosts list,
> but there is no protection here.
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
