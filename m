Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91AD2D3EC5
	for <linux-scsi@vger.kernel.org>; Thu, 18 Sep 2025 19:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758223963; cv=none; b=aqeW2vfrczet8IVlCO67EqyhfHgugZAlgDZo3WuexH0vIONDUcQEcJGyDcOgWOXtejpl7lRKqB76zR0rqGpPEO2BQtPx2hG2byj+0m7xsn7YvsXUa1u/lJne6M68VyW9938IvqQnMtaYgGTLvm68zYfOHbQ3T7HalwLjlnrBQ3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758223963; c=relaxed/simple;
	bh=B+iOGzdWX3z/rYlrk5yA0SAeuhbPHc3L1cNeSiXPCmY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tY1s28H8aMM2sMmB9dHdJhMQ10tKNpgYyDvxw6g5mmf6bUwdaBTcAfdvUEGn1qb+TBXb7stugCFnCBfT0DsXbwi/w0vk6RIl+jAS/q6FFUzct5hee6iTLmncmBbktlR6t+XGePwgNUPE6cdO+9CL2doGgUpIvGhkOWy6SJE7m/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=O4SG3OTz; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="O4SG3OTz"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cSQlD6N7hzlgqym;
	Thu, 18 Sep 2025 19:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1758223958; x=1760815959; bh=B+iOGzdWX3z/rYlrk5yA0SAe
	uhbPHc3L1cNeSiXPCmY=; b=O4SG3OTzWfS4geXjtxMgQoP/tyiiFw8bt2ARrEFF
	jGAqnp+2dgojuesk4ibF62hFo60uXEs+YvWlQloGfbUKiK591c5pJT7TAwscdqt9
	7taNP5YWFadb6Ck7vA4nvT5ypJhFBaekmcD57x0JD3+Yk0hFp245vttjSi3q4T0Y
	6WOO54WPGdMRwgklgpKIETeGfu2yjhpC76HY5Yr20/eqO0nnecvi12atM64hOGJ+
	A0H7EDKmeUzfNtMu/zwfsR4RF+Bq/XdRIHRRNHnN06HN0YomxswCblC4tSJzchC2
	Pg8iZpzIsFwFRcTfW1jdsMjRHCJcq9YiWcnKhsBkCqQTeg==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id TNb82r7mKlWP; Thu, 18 Sep 2025 19:32:38 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cSQkx1bJ8zlgqyN;
	Thu, 18 Sep 2025 19:32:24 +0000 (UTC)
Message-ID: <7a51c923-d311-46c4-b9db-5df807a091f2@acm.org>
Date: Thu, 18 Sep 2025 12:32:23 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 10/10] ufs: host: mediatek: Support new feature for
 MT6991
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com,
 yi-fan.peng@mediatek.com, qilin.tan@mediatek.com, lin.gui@mediatek.com,
 tun-yu.yu@mediatek.com, eddie.huang@mediatek.com, naomi.chu@mediatek.com,
 ed.tsai@mediatek.com
References: <20250918104000.208856-1-peter.wang@mediatek.com>
 <20250918104000.208856-11-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250918104000.208856-11-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/18/25 3:36 AM, peter.wang@mediatek.com wrote:
> Enable random performance improvement features to boost
> overall system responsiveness.

I think that you meant "random I/O performance improvement" instead
of "random performance improvement".

Thanks,

Bart.
