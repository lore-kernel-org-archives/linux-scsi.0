Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58F0254844;
	Mon,  7 Jul 2025 17:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751909330; cv=none; b=DLw+Rn/Hni4MvFeMtS/7prZwFpPB+TZ+7+kzCPnwJkJ4zEbLWdPaUF73amrebUmXEf4EvUQJxGR6sIEcn7fKH2i6tno15rqY0TTbYfxDk3cmMjS0sAu25BjU42Vv0lgQggFRzuJaga8QRtqcN9s9ul1vjCKDNjY96Elgg5sz/c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751909330; c=relaxed/simple;
	bh=1jlknYGz0gkT7zfhsbFovYnZ0C7e5EpXOpZVZUsMyGo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MNaH5s2DfLiiP/8vU8fRXzbGedN6GIKZikGShfkXZlKBaQx+A1F3Oi1WkCqROoNSKIz77hrgtgWY2W32iJhi/R9HgAYpIs/X//vYMZP5TFdHtzoUrykwdYGPavZWUidE7yBnyb40mQGJJVoz4eNaahEKupU0C1QF+YoaEAFhCC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=AKQPgYMN; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="AKQPgYMN"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4bbWRz6JqNzlgqV0;
	Mon,  7 Jul 2025 17:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1751909326; x=1754501327; bh=md8qy8yxZTzH3LBXV0VJeHIu
	kMDhKe97sdG22mgsqyE=; b=AKQPgYMNUsjE6CMeo/Qs4KVKzve9Ey2Z4iPAt8Rl
	nGRbNvf4hljmWPHpZ2o6lmesyl6ZiRVVsNdj9X5GIRtUBRxMHKTObYN60e/mMHT1
	AjiVay6r9mrpJHujW3ox9AnIMdG8E51b2S+LAAtWvPCgfq/n6EQ5n1gjSQhI/6IV
	pVKkXQHUzjQboCotgJ4I+Yrwso0p0tsJ1x/827SDju7u16dEd7NPEbEYa1HvUPKG
	UX/mtQ4iXnVHDkPtZaBUbziUZMmSP1LgqRXNX/hvaIhQvKtdqhskq7cguYuTE13w
	8GSOiP4USvXOXCGHOwS7n2AtRkMqXiiwNz9lbklY8N6P0g==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 1GKD9fC3-i1h; Mon,  7 Jul 2025 17:28:46 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4bbWRt0sdmzlv76Z;
	Mon,  7 Jul 2025 17:28:40 +0000 (UTC)
Message-ID: <ceabaefd-6df5-4d08-9b6c-6ce75611ebef@acm.org>
Date: Mon, 7 Jul 2025 10:28:39 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2] target: generate correct string identifiers for PR OUT
 transport IDs
To: Maurizio Lombardi <mlombard@redhat.com>, martin.petersen@oracle.com
Cc: michael.christie@oracle.com, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, mlombard@bsdbackstore.eu, d.bogdanov@yadro.com
References: <20250703081224.115865-1-mlombard@redhat.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250703081224.115865-1-mlombard@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/3/25 1:12 AM, Maurizio Lombardi wrote:
> -static char *iscsi_parse_pr_out_transport_id(
> +static void sas_parse_pr_out_transport_id(char *buf, char *i_str)
> +{
> +	char hex[17] = {0};

Isn't "{}" the preferred way to zero-initialize arrays and data
structures? "{}" has the advantage over "{0}" that it doesn't trigger
any compiler warnings when initializing a data structure in which the
first member is a pointer.

Thanks,

Bart.
