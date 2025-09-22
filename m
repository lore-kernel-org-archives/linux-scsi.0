Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7101311C11;
	Mon, 22 Sep 2025 16:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758559443; cv=none; b=drTu5hcuUxa4hxyqk3IRXieK6ZTj/p3pFJggsVlaj1ihKVouI2GzhIzYeyM5jWfDtaVYpgFIWaZAVrtP3Ruyw6RWx0xVMBfVXq9FAuOQneLA+lifpHld/fbJQ9W/zJ6pJzPjKO9PZUXHwCe6IhHJQUfLJXctuwhaNepzQogEHjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758559443; c=relaxed/simple;
	bh=mUfwNM6g4YV0Z5vAjP0ysuxfwxgwzn54RM9+pAqhegY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g+zWIOBZCjoRBA/w7HzPAp/uUQNznt3R+M6Ey+lnIDz2YoS4DNNQy3gN/l4Q+PcG1qlFowQmSRe6wOwSop0SGfh63WrXYyp+KrVnirxUp9JaejAtrKYp8DkEs90DK/Vn2AgS03Iq1OJIMT541LsrO+CycMpLec9HfpTlBjMGd5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=gKSawaeq; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="gKSawaeq"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cVppm4mZ0zlgqVr;
	Mon, 22 Sep 2025 16:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1758559438; x=1761151439; bh=oe2OnzjUQKN9qlZsYfhbfVwU
	ufVgPGcRyjShPZiPU84=; b=gKSawaeqZR592zvnmQh9IYnbAy7SnV1CsU7BUSjv
	4gpDhjsC9ynaYhO646ZXziPioYr/qkdR8/pDzQNhbI6JHovb6M1vumlozfzjKwCC
	GQnFt57JBXCe8rDkQgj9ZzR6KSMCnABA38z2gD4RaEj++4sttEcfuVRqB7a+cMX6
	zdTfH5SW4DoedkvCQWTvM0uBd4HZFVUX+cO0SBkqh8AoY6Y6LsuChT8OIp4wW/mb
	NtHesnUTHawWNwyAVgN4sFQ3NMsmJG/0CMAoev1DszBu52Xzw/Q5uhtAkGTgqoZf
	fUTKBuW7SVWaFcKnWN1L4k2Zvyj+0b5azrSmQG4mW2bHkw==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id rAM09P9LffWX; Mon, 22 Sep 2025 16:43:58 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cVppZ5jGnzlgqTs;
	Mon, 22 Sep 2025 16:43:49 +0000 (UTC)
Message-ID: <e359973d-aaf5-49e6-b1c2-89b580b7dfa8@acm.org>
Date: Mon, 22 Sep 2025 09:43:48 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: dc395x: correctly discard the return value in
 certain reads
To: Xinhui Yang <cyan@cyano.uk>, linux-scsi@vger.kernel.org
Cc: stable@vger.kernel.org, Mingcong Bai <jeffbai@aosc.io>,
 Kexy Biscuit <kexybiscuit@aosc.io>, Oliver Neukum <oliver@neukum.org>,
 Ali Akcaagac <aliakc@web.de>, Jamie Lenehan <lenehan@twibble.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 open list <linux-kernel@vger.kernel.org>
References: <20250922152609.827311-1-cyan@cyano.uk>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250922152609.827311-1-cyan@cyano.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/22/25 8:26 AM, Xinhui Yang wrote:
> -#define DC395x_LOCK_IO(dev,flags)		spin_lock_irqsave(((struct Scsi_Host *)dev)->host_lock, flags)
> -#define DC395x_UNLOCK_IO(dev,flags)		spin_unlock_irqrestore(((struct Scsi_Host *)dev)->host_lock, flags)
> +#define DC395x_LOCK_IO(dev, flags)		spin_lock_irqsave(((struct Scsi_Host *)dev)->host_lock, flags)
> +#define DC395x_UNLOCK_IO(dev, flags)		spin_unlock_irqrestore(((struct Scsi_Host *)dev)->host_lock, flags)

Are these whitespace-only changes? Such changes shouldn't be included in
a Cc: stable patch.

Thanks,

Bart.
