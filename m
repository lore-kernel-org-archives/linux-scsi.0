Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB71B15278F
	for <linux-scsi@vger.kernel.org>; Thu, 27 Jun 2024 16:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719505230; cv=none; b=L9p1kHQZqNRhbZ/hGanrSLib+6aEWxyNOLeSU3pTVte79WfqQzoVDhU0rpNzSfkWYMuIxnjVokE2fkAlGZ2gRbSFXhnv6ZSqmmU5ql1P1yo3HYW8nzopv89NvpDMxEEFroPKngbIJcqwBK2SjQrhVFHJyJ0kP390bvx2DhykViw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719505230; c=relaxed/simple;
	bh=KX6X90NMHTC9jQPKt0zNqn71YESGkl7FfiQewvyPBb4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=i8Rxx2fMHMfkExbGF94ikxGfzrwLbcBmDK1PQzkfrFD3g6w6lFlIdqAY0WjcgpX4BA+wsjqvVdch9E50qCqnbqmAJg4fza6rrYQw59iIc5NStyjBovOHyEM4pgz1b8DpJNchy/0hPVBUUhz51Wkl325HyvEfmMa4n+lzLOrHb70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=MT8F25Xb; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="MT8F25Xb"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4W93h95wCYz6Cnv3g;
	Thu, 27 Jun 2024 16:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1719505224; x=1722097225; bh=KX6X90NMHTC9jQPKt0zNqn71
	YESGkl7FfiQewvyPBb4=; b=MT8F25XbzSwJ+hzvKhBPmoTJhw13l2y4K/YSMya0
	D+WzVC9p2WhibgSkOvEvZOaLY/1XQE3i/f3kJnn07GSqCGZhX+y56Mwq/J/2oir+
	PZ4iviKFNdpAWArl45gpo7hQwqi/KcLfD12F7LJXMZMD/YccAsVzCVCzSbDPyp29
	m8zXyR42FAs4iivKRKMQlQJRahFdta6ba6gIZNBFfIXVxiJPmOwyrjaa31h/XPBD
	zaUdcB+gcyoW+7kbiOdl81jG7ZdGH6mhaqn/4oySj71ec6vDg0I2ET6WPt3gqXT4
	Y7sgml0BjaaQNuun6RUfFF8csUGsnZxjjxi3HZbE+VSDgQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id migoWgTNk7jB; Thu, 27 Jun 2024 16:20:24 +0000 (UTC)
Received: from [100.125.79.228] (unknown [104.132.1.68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4W93h85Xvzz6Cnv3Q;
	Thu, 27 Jun 2024 16:20:24 +0000 (UTC)
Message-ID: <43071cbc-da9b-4fc6-82f0-6ab4aa41bf5b@acm.org>
Date: Thu, 27 Jun 2024 09:20:23 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/14] [PATCH] SCSI: Replace ternary operations with
 min()/max() macros
To: Prabhakar Pujeri <prabhakar.pujeri@gmail.com>, linux-scsi@vger.kernel.org
References: <20240626101342.1440049-1-prabhakar.pujeri@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240626101342.1440049-1-prabhakar.pujeri@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/26/24 3:13 AM, Prabhakar Pujeri wrote:
> The patches have been compiled and tested on an x86_64 system.
> Physical device testing was conducted for the megaraid_sas and mpi3mr
> drivers.

Compiled? Really? So why is the kernel test robot complaining?

A script that builds all SCSI drivers is available here:

https://github.com/bvanassche/build-scsi-drivers

Bart.
