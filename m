Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E6F136E37;
	Mon,  9 Sep 2024 16:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725900733; cv=none; b=cGN2NLu/ItaLR+vPeeKVJFC7DjHsiEKHdDbxb76JYnQaMRmzzW07IluwJgByeNDkUfckzY2RoNc9Ws08PTQ0uwXliclqzcAMxUCjJDEfs6RoO+/abJO9pDnUIdJvhBtP8K642lWULVpVG/G0F1qg+OQ+lAcy8jUofp0AuR0SdvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725900733; c=relaxed/simple;
	bh=twImTYifiOWU6J6qkPtgprLRCj3s9lXxqb+u+SA5QWw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bWDhEXXyx5KHxQS2jCd/joUukVExiIBhB5I5vrbbfHyF6TT7BuoTH2NmNYQHK5kP7Xd/GJzM6zxEDSgiX98ONP7Nr3Qs+Kb6Mh5wTHn1g2WRlARgdmUJEcXLZi7e56tRntbbxTaRlqwiocMePgvuM6jLDdJaW54Is3DkPVPMC5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=uhQdZ1fg; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="uhQdZ1fg"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X2Xtg2vKZz6ClY8p;
	Mon,  9 Sep 2024 16:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1725900729; x=1728492730; bh=twImTYifiOWU6J6qkPtgprLR
	Cj3s9lXxqb+u+SA5QWw=; b=uhQdZ1fgD4AGgldTzjznraRBq+8bALTTd68791eT
	PUg2uDX3I8yPSvp/jrsif9/rA9jFeQXbAEFDLE/WfHwkSq8WUsNAzYUS9tqsJnGV
	t11Cuy289KSzOrjX5vfJWBQlNcIwGQYVzeN78H6+6zCm9DFryieAobKwOMByplw3
	JDjw1whKjj0DmbN5Fw/2KmeoGQQayE1t9VUNsb+Smxe3lE7i+D23RAT8hlPkHAiq
	5sipOBJjus7QgP+euNg83xyPD8D19zoaB3l64GPPNbHIQ20XUjFJlnxE581XAuKp
	HCBJKNIsJtyIaHRM3BX05CPhZYH8e1XcQnwcZsjoQK8LMg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id jnAtApQPnDD6; Mon,  9 Sep 2024 16:52:09 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X2Xtc4bb6z6ClbFf;
	Mon,  9 Sep 2024 16:52:08 +0000 (UTC)
Message-ID: <de761b4d-bf11-48a4-be2b-6312d5f383c6@acm.org>
Date: Mon, 9 Sep 2024 09:52:06 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: Use pre-calculated offsets in ufshcd_init_lrb
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240909095646.3756308-1-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240909095646.3756308-1-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/9/24 2:56 AM, Avri Altman wrote:
> Replace manual offset calculations for response_upiu and prd_table in
> ufshcd_init_lrb() with pre-calculated offsets already stored in the
> utp_transfer_req_desc structure. The pre-calculated offsets are set
> differently in ufshcd_host_memory_configure() based on the
> UFSHCD_QUIRK_PRDT_BYTE_GRAN quirk, ensuring correct alignment and
> access.

Please add Fixes: and Cc: stable tags.

Thanks,

Bart.

