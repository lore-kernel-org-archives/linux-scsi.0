Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA0E2F361B
	for <linux-scsi@vger.kernel.org>; Mon,  3 Aug 2026 17:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785777327; cv=none; b=l2P/qx5b1DFZCPgRBbgw2ssKAiYGhw4nCrNtNwA5BPgOlO20okoHe04D0R0w7Ib+O3l6EZkJS1yaj6jwgjOrTMhUIpqNMgec9JyztRWWr7UWI050RufkGEg2V0U3Kbnxa3ZSvU7awHHph/aBzpCIvfOxJdK52KSUcds2r4sWOcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785777327; c=relaxed/simple;
	bh=oVwCaCS85tzn+hIYzp5dWroFZj5TtohhO7SZMKZoIy0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JnQUnvFuLWeufu40Y7i4Xn60HYA2CpoK1NChQVrC6Z/CIPT7q/3vQgcSQFr+VZUnRalnBFqv0NGOFW3X0FpX4I7ggRMLbc+avwyiQPAWu1k3Hy0EtSjYUYX4kbqZdj6g3clWkot4FLJ+Cvyf95siYtYsHtIhC31YdzdpJTOPM0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=KK0AfReN; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="KK0AfReN"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hDNbd6B32zlfvq4;
	Mon,  3 Aug 2026 17:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1785777323; x=1788369324; bh=4HixOPdquqI7vVekdD1ehvOi
	rOFX/emhJUanq8YWxj4=; b=KK0AfReNozIb/hZEjdSP2z5EzQjA1biEc0nHUETp
	Ed7WGIAJQ2+4pbYchOgwh+0E3UrExDEWMHabiHxGKVY4CkbptSfJL+7442c/72VK
	xaXJcUdTlfeWxU0uGwtgULIYQYfu7C/ihKzfskXkgq+6E1LyDvNxquwzHIZlVQOM
	aMr8Ojsxqt9uH3IFYr+AZ8slQkYOYjGRFPhciM2ZLDKom7sp2a7bId+HUbM8+HPQ
	na5L4jOzY91vL0XCqLTBw7Np0Is/D0dxIsZkPF53xOby8dggscyLyrM7lHvagc4j
	sCAMShi1wGxdhMymzeKxpFtC0PeGKOl14KxT9U5qkvQLyg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id cvFiy4LUq-S4; Mon,  3 Aug 2026 17:15:23 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hDNbZ3589zlfvpM;
	Mon,  3 Aug 2026 17:15:22 +0000 (UTC)
Message-ID: <95d6fa9b-bddc-46c9-92d1-830347a432ac@acm.org>
Date: Mon, 3 Aug 2026 10:15:21 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/6] scsi: core: Pass the SCSI host pointer directly
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>, linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <68f3346cab2be570839350831f82b6c9233832ed.1785534721.git.bvanassche@acm.org>
 <0f417deef926f1574c555ec44fb2036e997a727c.1785534721.git.bvanassche@acm.org>
 <98049e01-09ac-43cb-aa5e-593bd5fb25c0@oracle.com>
 <58b7c76f-6893-44e1-bf0c-e9cbf080a073@acm.org>
 <69d7dd4a-2c0d-4e1b-984c-732af4e7efb9@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <69d7dd4a-2c0d-4e1b-984c-732af4e7efb9@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/3/26 9:30 AM, John Garry wrote:
> ok, I get it, but it's better to mention the reason briefly, like 
> "context analysis requires checking on passed argument when using 
> preferred annotation form"

I will do this :-)

Bart.
