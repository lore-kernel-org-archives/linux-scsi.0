Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A3917D35F;
	Tue, 11 Jun 2024 13:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718114071; cv=none; b=tQ+1C3G/g9anLEUIg+nIfJxIF5yttS2d4jSyJQO7P9Xfty9TG5zyPIhiNMbFxwISU/oBlZNArd/YyxlzTD1q+Kh9nCdf9FKb7TD9ZceJ6j20cBfjaSsFlfMlw46I2nOxZrpEjP7YTaFCmtsBZgVlUVpFKbb9iWPdXHAkgs/ImrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718114071; c=relaxed/simple;
	bh=z6Xlm3Myzf0XENt1mtEjLarR3vUfPV0dcq85A+bZWyw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cIquz7TL3cGyNASRVQsxEK/defYvcfA162sD2+yDH+Kli2MSH/Unm2CsD+q9lTJa+iNstPCuVmuxI7+OUcF1g1YsRsi6cqVyXAysICDAckr63GvHps6xoo9xgTbZclufQPMymc/vLfHvO4TIIJGqOY+Uz7Ha1QDsRRxsf5P7uus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=1UEv8Cc6; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="1UEv8Cc6"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Vz9C352Vjz6CmSMs;
	Tue, 11 Jun 2024 13:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1718114058; x=1720706059; bh=z6Xlm3Myzf0XENt1mtEjLarR
	3vUfPV0dcq85A+bZWyw=; b=1UEv8Cc60gybweEB3Y0s2R2ymDfOnYql7xo5mesA
	fjWjqASreJqTfoY2zA+3eUixDtM9X6KN/0nJgM41GCBOsBoTLqecBsvzSQNfgiAD
	x1KmkAWF1qVy7ZJVqawLbI3OeOGVJrYvOlqL1Xql/3mI7Of3oShFxussQA3Wounx
	1CsUtQErv9FiogRloxZtjJY1ZSSt49v1zMldT1oksKk82HoexGFmlOzLGq2TRtt2
	XxfqUw8GotKoxMyAT2h2owlG2g6KP2D/gq9eqFxgyvULyHaKgRJalIv0MihrMygo
	opfuwiC9Kb4WMcy537yI+SEUGF83GHW6EKHgmmL/BUWFAw==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id TAXE9hSNYuj5; Tue, 11 Jun 2024 13:54:18 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Vz9Bv1SMsz6Cnv3Q;
	Tue, 11 Jun 2024 13:54:14 +0000 (UTC)
Message-ID: <8005e95f-069c-4cbd-8330-c1395a238b86@acm.org>
Date: Tue, 11 Jun 2024 06:54:12 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: quiesce request queues before check
 pending cmds
To: Ziqi Chen <quic_ziqichen@quicinc.com>, quic_cang@quicinc.com,
 mani@kernel.org, beanhuo@micron.com, avri.altman@wdc.com,
 junwoo80.lee@samsung.com, martin.petersen@oracle.com,
 quic_nguyenb@quicinc.com, quic_nitirawa@quicinc.com,
 quic_rampraka@quicinc.com
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>,
 Peter Wang <peter.wang@mediatek.com>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Maramaina Naresh <quic_mnaresh@quicinc.com>,
 Asutosh Das <quic_asutoshd@quicinc.com>,
 open list <linux-kernel@vger.kernel.org>
References: <1717754818-39863-1-git-send-email-quic_ziqichen@quicinc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1717754818-39863-1-git-send-email-quic_ziqichen@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/7/24 03:06, Ziqi Chen wrote:
> Fix this race condition by quiescing the request queues before calling
> ufshcd_pending_cmds() so that block layer won't touch the budget map
> when ufshcd_pending_cmds() is working on it. In addition, remove the
> scsi layer blocking/unblocking to reduce redundancies and latencies.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
