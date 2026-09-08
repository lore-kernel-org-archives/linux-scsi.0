Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA252D47F1
	for <linux-scsi@vger.kernel.org>; Tue,  8 Sep 2026 01:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788830445; cv=none; b=Nid1UqZaeRlNyG6ebBSs5DI+LDN4+4YeY4pmquSn6Viv0HGR4lldGfWVZ0TYJKa3qp6trjKEd7ufULPvrue5TyDnl51Qtu4cTulhHzq92JUaPiprI3oWDwRVtdtzeisKS8y4jfYg6TxVwFRX7WRoVxsyFNuH+NRybhPCincabmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788830445; c=relaxed/simple;
	bh=HYnt0lgNZgdEnl2AZEbrIVxiG7QqHlBfDK5sg9QaNWY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=SkDZ7eQhY5qwTynjiGQW++HmLegd6s/UA9Ky5hFYzWZeOfNbql7z8sTS9VYuY0ikP2tBRus8N8sbt0AWmWn8ujZUrLGj3QzWn5mhiLI0ap59b/370WkAoMt1oQRt5qbcFHwJl8WkT4fKDBPaSfFASyszU9o/UO0BGU+LFyFeE80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=XDt2o2ad; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="XDt2o2ad"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hf5jH533Nzlfvq1;
	Tue,  8 Sep 2026 01:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1788830433; x=1791422434; bh=HYnt0lgNZgdEnl2AZEbrIVxi
	G7QqHlBfDK5sg9QaNWY=; b=XDt2o2aduOBCF2mXeSYT/RAGQjg3vOtc+aVjrj/g
	9qyiOJf0BLqVxyZznOP6PSdCpp3SBtRHzUNbICmwOEh+U1rWGVsImUWsRoB6sQoM
	wcTh/W0Qp72Zbpc6R6O7wNiN2AMpMjkvH/GQhgeLUfztz2ptBtmH5X+jH3cjcFBU
	blftTbJ6+vQfiwrdPuo13C7+PAfMnrRrKhBBoysXIaJqNIhIQoOKLNAkyHLukuJH
	om75ZDM+Rry9X0lfm7rcBbdwJDPUY0gTmpWZV2gbCR/IJLokfGvl6jziO7UBk9i5
	c3q7WVro84/ZUpvwmuC2hf55oyAPRziJRaFJ6jg58I+7ww==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id yUUsy0qwIRYS; Tue,  8 Sep 2026 01:20:33 +0000 (UTC)
Received: from [192.168.51.14] (c-24-6-239-25.hsd1.ca.comcast.net [24.6.239.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hf5jD10z1zlfvpS;
	Tue,  8 Sep 2026 01:20:31 +0000 (UTC)
Message-ID: <7b329106-d5e0-472f-a9fb-72f979310c51@acm.org>
Date: Mon, 7 Sep 2026 18:20:30 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 01/40] scsi: define all additional sense codes and
 their qualifiers
To: Damien Le Moal <dlemoal@kernel.org>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 James Bottomley <James.Bottomley@hansenpartnership.com>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-2-dlemoal@kernel.org>
 <20260907031437.87FC41F00A3A@smtp.kernel.org>
 <531b5431-dc8d-4708-a67d-0bfcac96e1ea@kernel.org>
 <b7d26272-f53c-4355-a5ca-b6d9fb321599@gmail.com>
 <835e4db9-5be7-4118-94ee-afc412e82a2e@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <835e4db9-5be7-4118-94ee-afc412e82a2e@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/7/26 5:30 PM, Damien Le Moal wrote:
> Sure, easy to do. But I have not seen any compilation errors. So their is
> currently no clash, but indeed, this is at the mercy of any change in included
> files. So better safe here and I will rename. Not sure what a good prefix is
> though... Maybe SCSI_WARNING ? Or SCSI_SENSE_WARNING ? Any better suggestion?

As you know any enumeration label ends up in the global namespace so
it's considered a good practice to make the names of all enumeration
labels of the same enumeration type start with the same prefix. Would
it be acceptable to make all labels in enum scsi_sense_code start with
the SCSI_SENSE_ prefix? The labels in enum scsi_sense_key probably could
also use a prefix? Constants with names like "NOT_READY" and "COMPLETED"
might also be defined in other kernel headers. Would SSK_ (SCSI SENSE
KEY) be a good prefix?

Thanks,

Bart.
