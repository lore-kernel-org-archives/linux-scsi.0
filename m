Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56A51B87F0
	for <linux-scsi@vger.kernel.org>; Mon, 30 Jun 2025 20:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751314796; cv=none; b=si0W5alf0hLpQ1YJG22/IQTK50L/Vi6zpkqmeq8Sqd6Gq3JnoRtUWXy6JmaDnThkq6LsU5WnIi3mIPZqX+gJuGCTTN3yHd6tYON7Mff6xJo/QWdOLoAQVLKd6SIH4XwCv6oCmBOTX4RRmRJfRDBb+ym9AIVzXGPP9tYwyAws/Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751314796; c=relaxed/simple;
	bh=FNGJZXHQCV8s30CPikdIYTYRY5EgyxI268VxE/XRVyQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qs6QaG/NAVm4PXHRkyL++9Yt5Bd0YKbYUwAzrj87mdusf2AJoTtAZbCJvCvCw5wYPBpR3Ua642i+jdpAfKt8Al8DOpTVpLRsYppdO5zvp9+7yh5V+2E/0BWwF3nlM37FMqUkTe+DzuRyP2GIdsGMKEXqG7Clni5GzHDTSXjzfaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=0z0bXkCg; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="0z0bXkCg"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bWHZX26f1zm1HbW;
	Mon, 30 Jun 2025 20:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1751314786; x=1753906787; bh=FNGJZXHQCV8s30CPikdIYTYR
	Y5EgyxI268VxE/XRVyQ=; b=0z0bXkCgTyFTFHL/FKq5saceZmRYr2FJ0AFdDdDs
	RLqZHBYy9PdlEiljOQo76HjKdPTYGu+yloaYqUwNu1uM7+1T9gbV1SgjFmXeXo2s
	XWmhTE770p/ZiuxYcrETYBzBIh4GqdTp26WN/X0UTOIjp9VfAECW2S99xefT34Sx
	CI2byA5zz1cDKIjyqvySnoLuWM/cnCBYNBVBNNi20AD2Y00ufSfnD72TjmbByVRe
	AowujD6v6rHqPEEasSy0hQs8TXNHXUNWrjDLLXNHWHBU7UKQ2P+io/eoJTz5Sj2Q
	t08DrRasJxf4Mx1b8Q65r5KY6qepCj2XF6t/bvwSyrjSTg==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id zu98DAb2UNou; Mon, 30 Jun 2025 20:19:46 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bWHZM4Jn3zm1HcD;
	Mon, 30 Jun 2025 20:19:38 +0000 (UTC)
Message-ID: <cd2e929a-1328-4618-89dd-01f9992ca779@acm.org>
Date: Mon, 30 Jun 2025 13:19:37 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: Make ufshcd_clock_scaling_prepare() compatible
 with MCQ
To: linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 Can Guo <quic_cang@quicinc.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Peter Wang <peter.wang@mediatek.com>, Avri Altman <avri.altman@sandisk.com>,
 Manivannan Sadhasivam <mani@kernel.org>,
 "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 Stanley Jhu <chu.stanley@gmail.com>, Asutosh Das <quic_asutoshd@quicinc.com>
References: <20250624201252.396941-1-bvanassche@acm.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250624201252.396941-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/24/25 1:12 PM, Bart Van Assche wrote:
> ufshcd_clock_scaling_prepare() only supports the lecagy doorbell mode and
> may wait up to 20 ms longer than necessary. Hence this patch that reworks
> ufshcd_clock_scaling_prepare(). Compile-tested only.
(replying to my own e-mail)

Can someone from Qualcomm please help with reviewing and/or testing this
patch? I'd like to get rid of the ufshcd_wait_for_doorbell_clr()
function before anyone adds more callers to that function.
ufshcd_wait_for_doorbell_clr() supports the legacy doorbell mode but not
MCQ.

Thanks

Bart.
