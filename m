Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4641F15ADB4
	for <linux-scsi@vger.kernel.org>; Thu, 17 Apr 2025 21:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744925648; cv=none; b=nXLSUB65ONfLk/i37FNtoK/FeeiVDp0g39A3e3snTFU6Yw3MB/2amSDVoFK4Wu3y2izvDJwOjIlCi6p9SvXzWuoJbZ16eiN6kjY321QbulSyK1kq8ELANm6xIZRmg00zRuieZj+4n4c9aXkBUO8cmxi8vsYRpa/ragifotZEVS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744925648; c=relaxed/simple;
	bh=yCg46XR5Wm1jw0b5Ne63DAmCD8xHv8YNveWPm+uWqFQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZLK8mZxj/R4syy/J0sF0tx03gItjm12H3J903WGoeDOg62OL4lB1Aq5bIBGAS35a66qgBtAHlvs/sivC8qFuqevtTiJ30GLFLf04aALYfmSsAuPhy9PFY3qUKhr/zxlcWNdmivMkB+LvAwa9PXvVdflX3lF7aNjzWLMUs3UGMOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=3svWLGWt; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="3svWLGWt"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZdrkP0lcZzm0jvc;
	Thu, 17 Apr 2025 21:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1744925643; x=1747517644; bh=yCg46XR5Wm1jw0b5Ne63DAmC
	D8xHv8YNveWPm+uWqFQ=; b=3svWLGWtoRe+M6EqkR63FV3zyndyNlHhLOCnX8Td
	2gOp3c09h0WC8Qz1R6NTbrhjEopVuy+qwFld9Rkl4oy5yMC755S/gF+3OP/NVwfl
	Z/qUpxKGOKPcig6KUp24yZ77rC3E7eta5F+yXRuRkr6I8xXwlbIzsKz0RIerleSy
	7lUkJz+wavLqXOl1os6CyIgbbcVaDVTlqb3ave8jAcABMj89236Bl7syGvgeXA1t
	G7JLk9+UxLpx5+4BUsMsI2I5VW+nMOJcQ6bgvT5jiJbHvkuaL9KXzwjZ1/5DpL9G
	16mGcP0AIvDx0/4CRcD2CiTCsBZPNLMRyFewzTTmPiYtqA==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ISbZV3UT_bvt; Thu, 17 Apr 2025 21:34:03 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZdrkG5tvyzm0jw7;
	Thu, 17 Apr 2025 21:33:58 +0000 (UTC)
Message-ID: <e739732d-bc04-4c8f-a129-b974434ce4b2@acm.org>
Date: Thu, 17 Apr 2025 14:33:57 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/24] scsi: ufs: core: Rework
 ufshcd_mcq_compl_pending_transfer()
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>
References: <20250403211937.2225615-1-bvanassche@acm.org>
 <20250403211937.2225615-13-bvanassche@acm.org>
 <0390adb9d0ebed4ba4b386453d20175b1f3a0709.camel@mediatek.com>
 <84d20bdc-fcd9-42e4-939f-a3ec0422e646@acm.org>
 <41c2d72bb792a9fab243e2586696db91205c63bb.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <41c2d72bb792a9fab243e2586696db91205c63bb.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 4/17/25 5:39 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> If blk_mq_rq_state(rq) state is MQ_RQ_COMPLETE, the code
> before modification would skip this tag.
> But the code after modification will execute the function(fn).
> This should cause issues, right?

Hi Peter,

My understanding is that the function modified by patch 12/24,
ufshcd_mcq_compl_pending_transfer(), is only called by the UFS error
handler. The UFS error handler is only activated after all pending
requests have completed (MQ_RQ_IDLE) or timed out (MQ_RQ_STARTED).
No requests should have the state MQ_RQ_COMPLETE when the error handler
is activated.

Thanks,

Bart.
