Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB1916D9BB
	for <linux-scsi@vger.kernel.org>; Mon,  1 Jul 2024 16:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719852044; cv=none; b=jQ0gzpUW6o29xUudEh0/5FulcxsO/xgEOvtQkDzqU2g3bhwH7aOsWf9O51htOsub6ZJ2eAi1PhUSiOEEqi9LZgrK/ybDaIZT6boBKfbYw/n2zC23PMovWn2UFJxBYo0SkF1ZKT6lw2aKIhq+V00ng1JA1k4zclcCHeJxtMJnQkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719852044; c=relaxed/simple;
	bh=Zkn/XxBcUnmdd5okNx5anp0D9ApBYFHa1YYGaY2wIGo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=KZ5UQhdFE5mzoLe1TENmvcuMgUFl4CD/eOMsVfJlODSUpCKMXj4T3O5fw52D/CEP/gj6fFm93fv49QzmKxXHX96UcUymJ4bVd4BaZ/7i6BdLyuANEK1GsMUyGcngtlKj/UuZVTmEOi1FciZJJal6n1VLkI2qqW1hlbD3orZgFsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=1spOv5oG; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="1spOv5oG"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WCWxk3TYczlnNFG;
	Mon,  1 Jul 2024 16:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1719852041; x=1722444042; bh=Zkn/XxBcUnmdd5okNx5anp0D
	9ApBYFHa1YYGaY2wIGo=; b=1spOv5oG1BzpLPjrtjhVHXhFdG2nR4UnlP8YZWjz
	8OqxAvf45DQ+f8AZ8/fjzjCvwv4fWlNp6wwiTdn1bDF07+tfXKcAj31YJv9c3msb
	Kr2Gnk3nREauEyUdlz6RcNO2ALROK32fEOiXFe7tOPoKpeEJ6tfSgAxK64Jzbhk6
	5eYJu5nroOt4RnJa736cTHmWfFPQD06MQWcrU6OCuTi/9i3LNk0fZi1ElTU/PTdM
	Q9fy/YJ2Xu8RsV9XmvCrD+LvqN0+l1k3FiQ2fywJFpDfioAaxrxpIqzJ1c4ppRDF
	esdF9R6/mtpkXbv+ec7glVkR0OYr9UTTNVS1MpPUaQWEiw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id DhNSKBaIh9q5; Mon,  1 Jul 2024 16:40:41 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WCWxh74dxzllCSJ;
	Mon,  1 Jul 2024 16:40:40 +0000 (UTC)
Message-ID: <d75d9642-0e68-4001-bbc0-f5da2593fd55@acm.org>
Date: Mon, 1 Jul 2024 09:40:40 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: sd: Do not repeat the starting disk message
To: Damien Le Moal <dlemoal@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org
References: <20240701092451.122800-1-dlemoal@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240701092451.122800-1-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/1/24 2:24 AM, Damien Le Moal wrote:
> The scsi disk message "Starting disk" to signal resuming of a suspended
> disk is printed in both sd_resume() and sd_resume_common(), which result

result -> results ?

> in this message being printed twice when resuming from e.g. autosuspend:

Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
