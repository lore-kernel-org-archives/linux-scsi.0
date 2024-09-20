Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616A544C81;
	Fri, 20 Sep 2024 19:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726861136; cv=none; b=SGBpvIY8R/hTcKwLYwi1w2Soh/+oDbalfoAnz9F649D+5XL5/9l3GnntKZHtScSTS3jtE6HnvPFbMGKKJKckZkT1Dk+k7n16gOd5X7DpcMkUpvFbDG2cnCDAKi+oMC1qgCHeq6hkTG+d3Jl+xAqe+PGn0L7puyHuL+r1dgWiRq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726861136; c=relaxed/simple;
	bh=rE1ASxi+2T/GdyeBbaU50PKBL5Rqz1OVfkmDm8DtfkI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TtrJeEqCIk2mI+9hQBuQ9aZKTQ2fnPtITePBU7X16MyXy2i/RkxOi5hy62qXUpdGtw8q0fKgkcBIwtRURcofO48Xg/tc35a9nU+IxnEqkquMZzxEqqV6t5G62kMkUEDg3dpX3tx7Kc2f1y7zAqxakxG3aU+kNGLuNOIVkiR2O0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=HpMrHry3; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="HpMrHry3"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X9N3y55dMz6ClY9H;
	Fri, 20 Sep 2024 19:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1726861133; x=1729453134; bh=rE1ASxi+2T/GdyeBbaU50PKB
	L5Rqz1OVfkmDm8DtfkI=; b=HpMrHry37gur552xwHYM/V2kqpHgjufuOYqLnLcO
	RY2mKX8vvVJKgZMg+HdDXp+f3ZSc80XWP3zZ2DMURKidbM5NnAUHuU849gB9zwrJ
	JEn3Jt2DdqAPcZ1t9+NN9TcmL+zfyrcYkIRvc/HrlD2NmLFhtIKoGqelkIu8rol6
	mEuOeGJZnjmI46Z5WFdbMdNtyQzonkPbccNl3yMlPwfICnyX/v6TOrz30wtkO3g7
	fH/WVZB+dsXpJzm+jts1F0TQYnvc6uo/QlT5ONKfKTdhoXBPNE+BJXQ7zSnd7JmQ
	BttYlX4GOxBcQhJY958cMThHCNuRLzQrA4wNO2fORx9B9w==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id NjR24LrHcaeX; Fri, 20 Sep 2024 19:38:53 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X9N3w68KJz6ClY9F;
	Fri, 20 Sep 2024 19:38:52 +0000 (UTC)
Message-ID: <92cbd8d3-5d16-4c7f-9e82-d1b6139b0994@acm.org>
Date: Fri, 20 Sep 2024 12:38:52 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: Do not open code read_poll_timeout
To: Avri Altman <Avri.Altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20240919112442.48491-1-avri.altman@wdc.com>
 <ff33de4f-d111-4499-afff-231baaccf61c@acm.org>
 <DM6PR04MB657543C148391E6F60921083FC6C2@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB657543C148391E6F60921083FC6C2@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/20/24 12:00 PM, Avri Altman wrote:
> I think that the wait_for_register makes it much clearer what the function actually does,
> And for that reason, only, it worth keeping the function name.

That makes sense to me.

Thanks,

Bart.

