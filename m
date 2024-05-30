Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96D645BFD;
	Thu, 30 May 2024 18:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717093580; cv=none; b=EXFWV9NU6cBxR2QBjxqao1+bPH2YdLzufXzZItaSaEKgXtU6J+bx8nXarH1/qGLAl/duxpvgnby9g0ZyBfV0nyG9+xxK3OW88f3Te1EAdXv2b7I0emmPMmg+NAaWCknPonVcDOSL0n8fKHryQMxC9SlpA8M0fz2UxQnGKgf7leA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717093580; c=relaxed/simple;
	bh=P3Ke8aOEFWPMDTqx1DY91Aa402UC+rbrxthzHKlZ2+c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mGIOdHmFINyOqEsuWyDnbwSrv4VvX5ihEdK208ufBJu1ksrcUjHqLMbkRxBrXXGV5T/ZK7WFVxLOjE4HLtkM/X5qyvfX7xuXHBvZHxcIFi9q2q35QGjahMkAWlG9i+DSgVi4Dw/elZx6yz0VDJhWgecYujG/E1AW/zsRc4los1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=R5bPZYeo; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="R5bPZYeo"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4VqvpK65Clz6Cnk9F;
	Thu, 30 May 2024 18:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1717093575; x=1719685576; bh=MeD3xVJN03UWc8w++yrBQwVU
	OBogx6APe246hnDMoJs=; b=R5bPZYeojh+4pFKT6Hw+6PT4Fbk6YxVhmpDlyplG
	tbTm2G7CLIshuAkDdsWpvfeb51nPAicnOZ606/Fc9JQf713VSHThEl3EEF/Ly4jN
	6YkdZMvl3xbG2IkfjOAxXtk+mk/9s/HS0ZUwz4xsTqx1JWTFpCLhRlYTaZ6WwF3T
	iwdc270d2XHMvTD7ZhOjNehROMFZ9IKSAuxS/IYQPRJ676xkJtjZMI8SkbZPxaoP
	vE3ZyYg0GPwHO4WFTPcBRLzb0wIvj375UiwI8o+wYJFrCoGtRKOf+7z2TY2gXp+4
	fz179e4+g6JS2fvOh5RHVo35mVPoAWO70O2Cog0e2LGWEQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id gSNp3QLC1RiQ; Thu, 30 May 2024 18:26:15 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4VqvpH1nZHz6Cnk97;
	Thu, 30 May 2024 18:26:15 +0000 (UTC)
Message-ID: <2727c098-8ed8-461b-ae4e-4525b17db0b4@acm.org>
Date: Thu, 30 May 2024 11:26:14 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/3] scsi: ufs: Maximum RTT supported by the host
 driver
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240530142510.734-1-avri.altman@wdc.com>
 <20240530142510.734-3-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240530142510.734-3-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/30/24 07:25, Avri Altman wrote:
> Allow platform vendors to take precedence having their own max rtt
> support.  This makes sense because the host controller's nortt
> characteristic may vary among vendors.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

