Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB5E13A400;
	Wed,  5 Jun 2024 19:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717614941; cv=none; b=RPITI1M29VbaGMTRdvXFof23VCWp3Kz+MnR/K5UfM3gs9bHqmBATb0glxM56sVUsmWKFx7p5GmLHsPietiNxNgwvpUWIPRIQ9ZbsjvseHZw0CM41toL7o1EEIcSiSsxP8Ug1zhC+sW9a3t7VOAiJmMeUcYOPGUZ+IO5uK3bOslY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717614941; c=relaxed/simple;
	bh=PSWN472Wnorxu4k9ywdhZ+5eQVpHQixWKDSbnDQYmvc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MfyqTDRYdK1M9xGUa/A1oNx2+kD/n5HhNleMLfbbjo8lgXpj2jViraqmJ7Nou90IXW4QuiJCuvCNWn9Cj+YYBL8DKEyORjSkl0Uh8dKqaNkvrpqlnvH4ZBcKqvS2RekPF8hmBYa6eYcf9o+GSw6u8crO0WBq0GSt54pX5hoGmPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=HqU0hIq5; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="HqU0hIq5"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4VvccW3XJkz6CmQvG;
	Wed,  5 Jun 2024 19:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1717614937; x=1720206938; bh=F7zsNdmnby97gLElUEVqV1uV
	tQADs+pescSr74QdCVQ=; b=HqU0hIq52Vp5574Xuw1Xpdbx3JvX36wx6DBqFCtH
	E/w4jP9v105RMCEhx2p9vFZ8cRxlJS3PpTQxXP632VhEGwCLqDHz5oG7i0wCcDQS
	pH/U+R1eTUFCytFXJzzQzJJ4i6WTzgqhzVmfC4F4cjg8H4TcXU7uS9NVeaVAGE3q
	Gg1mm7dtPEy6pjZSqO/Bn7Ud98b/NHF+3JUY3QwsYNxLfi7DBbPJfcjOQSJlpR3H
	3amXtDHA5CBzG2oIwvj1KJadYXzZZKtZC/XS0h5RrX6obTQnb0Yfy20kW1qVG7tL
	f1ni9oD/RDCQHI2aID/r8tIBcv0wbL/gTq2ihr0gwhQ8GA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id yXFPYd83rbJl; Wed,  5 Jun 2024 19:15:37 +0000 (UTC)
Received: from [192.168.132.235] (unknown [65.117.37.195])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4VvccS6D9yz6Cnk8s;
	Wed,  5 Jun 2024 19:15:36 +0000 (UTC)
Message-ID: <9b382d5d-b02b-4dc8-8142-d6b2a1b06ab6@acm.org>
Date: Wed, 5 Jun 2024 13:15:36 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: sd: Use READ(16) when reading block zero on
 large capacity disks
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org
Cc: stable@vger.kernel.org, Pierre Tomon <pierretom+12@ik.me>,
 Alan Stern <stern@rowland.harvard.edu>
References: <50211dcb-dc40-4bb5-8168-8f102f6bfb5c@acm.org>
 <20240605022521.3960956-1-martin.petersen@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240605022521.3960956-1-martin.petersen@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/4/24 20:25, Martin K. Petersen wrote:
> Commit 321da3dc1f3c ("scsi: sd: usb_storage: uas: Access media prior
> to querying device properties") triggered a read to LBA 0 before
> attempting to inquire about device characteristics. This was done
> because some protocol bridge devices will return generic values until
> an attached storage device's media has been accessed.
> 
> Pierre Tomon reported that this change caused problems on a large
> capacity external drive connected via a bridge device. The bridge in
> question does not appear to implement the READ(10) command.
> 
> Issue a READ(16) instead of READ(10) when a device has been identified
> as preferring 16-byte commands (use_16_for_rw heuristic).

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
