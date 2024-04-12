Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AACB148853
	for <linux-scsi@vger.kernel.org>; Fri, 12 Apr 2024 16:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712939495; cv=none; b=Z3eE1MOEH5XExla6nHb+/pGO2VBUV+GDBzKziZQ8W5NHPCaZCXT2/iY17/1T/mS3xf1QrR2X+Xu0wVzRiM6D0q/wot8Sn8mrJSQ07pNNTcLJxKIg7I2oCCzvirW7kie/jA10+0Oj3/CYlcERT7hEvo5RYJHLfxAvuD7XmxKzTp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712939495; c=relaxed/simple;
	bh=e/m7JjEKrmVIrjO7amYknJUn+bRcFsc7noe6YXh+rqM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SbbDNARk9l3UqCbn6x4RivyyR63P/TzmQ9zLnc9/N7oaVs5lROw28+HpCycieNW5yPvkPeb5W5mERW/cPkrU+T0a43mFeUFxQXV/INHEpHhqdXQBuw/3bNpZzSLJwansXEhCZ4V+oiytU0YdQ/fc9+NbWGIB92A7coqSiAq69ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=03NEJuqA; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="03NEJuqA"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4VGMWz5ByPzlgVnF;
	Fri, 12 Apr 2024 16:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1712939484; x=1715531485; bh=ZJaEwUwcDroPYO87IjNJTHN6
	NtuBBBBUVU+Zk5tTgBw=; b=03NEJuqAi2dMB3SGUKheAeRAe75WbwETrA3pQFfP
	UlOAJJm2lIzkiLW+fodgIKCAIYz6rtch2gp+sbbTLPNWpVCp5AkrRiNykhE4IY76
	4MVhMW8+L0orsWYsEXmfVVRRnLhxeVf2ZZypzsiOYU05Wf5VOSUAmG9SeHY8qJGy
	Tg4dh+rn2QS11hdY6XS9wqMw4SLgMKZM8Ftzqekh23M2W5dljRZtM6Tt4hJ5kvTb
	/maTIra+SVf2iTaHw6usWidPIzEFEdXQwS/frgfN5Ayvs72R4ot1Susou9uOWJBL
	NfK9tfUD3IEb+IzCPvUbIB9sOa77Q7Eu1TNrLq4mBhZ9Uw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id aaZZCa2FkkWk; Fri, 12 Apr 2024 16:31:24 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4VGMWv2Jx3zlgTsK;
	Fri, 12 Apr 2024 16:31:22 +0000 (UTC)
Message-ID: <2c2910a4-b7b4-43fe-bfe9-46bf76cb8e3f@acm.org>
Date: Fri, 12 Apr 2024 09:31:21 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] scsi: ufs: Make ufshcd_poll() complain about
 unsupported arguments
To: Avri Altman <Avri.Altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>,
 Stanley Jhu <chu.stanley@gmail.com>, Can Guo <quic_cang@quicinc.com>,
 Peter Wang <peter.wang@mediatek.com>,
 "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, Bean Huo <beanhuo@micron.com>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
References: <20240412000246.1167600-1-bvanassche@acm.org>
 <20240412000246.1167600-3-bvanassche@acm.org>
 <DM6PR04MB65752B7F3564227D7E750A90FC042@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB65752B7F3564227D7E750A90FC042@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/12/24 01:55, Avri Altman wrote:
>> The ufshcd_poll() implementation does not support queue_num ==
>> UFSHCD_POLL_FROM_INTERRUPT_CONTEXT in MCQ mode. Hence complain
>> if queue_num == UFSHCD_POLL_FROM_INTERRUPT_CONTEXT in MCQ mode.
> 
> Fixes tag - is it ed975065c31c ?

Isn't the Fixes tag for patches that fix a shortcoming? This patch does
not change the behavior of the UFS driver so I don't see it as a fix.

Thanks,

Bart.
