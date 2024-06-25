Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EBAE14A627;
	Tue, 25 Jun 2024 16:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719332019; cv=none; b=uNTwCDJJbsrVF5icbuPs7vJehm10sM8ozaTtf9u6ynZ5DT8N0TEU0bVIKiNMSx1NzGOPYkLS1T12yPp6YifOoBnm4OBuyc1v9h6CVvlDrP4Fpn7Hkan8fKyNlFVmWsEinDyO5xkYqd1c4BR114K0nDl4audZJSfG1rHVBkDWtEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719332019; c=relaxed/simple;
	bh=msYZhZCxWZBxDmvizCkJHvdjfdVF2a0TW+w8bbNgRJc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L/90TP/W9y78CV22X7zQ2242WaKcOy2pjeZ4AiDtd2UvDo/mg0G3zjVBbXJutpOLfVvYAGvArZdq8/QbWyjqLtkAj0rr99TvzS+g5MftU81SBZpIsRxKQpjCkyMAUb2jHizVuuS3VsY+QjkVN2NtAgE8AP1sR1mgj5OrGjzzRX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=wRSj1gHh; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="wRSj1gHh"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4W7qdF1TcYz6Cnk9F;
	Tue, 25 Jun 2024 16:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1719332009; x=1721924010; bh=msYZhZCxWZBxDmvizCkJHvdj
	fdVF2a0TW+w8bbNgRJc=; b=wRSj1gHh+zHK3ryUK5RrBNkuEQOK9GR4zWSFP+YO
	d8CdsOS82ib7JS+e816UQqzvYLZCUjCbn8royEG93wtBpdMdCFueIN2lxnh/scmI
	Yk6U96wqxAFO0qXeD0XNFJLhoWJIsw0d1mhhEmM88QO00BFIRhC7JNui70TPUt2d
	OfWmQcj3PHJtj4XMPc+QwK3zWZNvNNJBH12sJ+l2lhc9YU4viW/fmbPdMvBpiKDX
	pXk1m0s36VHWX/LDkqzlYxJ1kgrIE5X8YLg80R5uHkdTuUdvfeIZ1A3IwK9XFn2T
	O64WIxuzm5nqfAks7wvwIEmmf4/eEoYWSmZggP6iWLkSmw==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id I4FFymU7LBn7; Tue, 25 Jun 2024 16:13:29 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4W7qd24L9qz6Cnk97;
	Tue, 25 Jun 2024 16:13:26 +0000 (UTC)
Message-ID: <3c7e776e-df2e-4718-995f-5e5dfa3cc916@acm.org>
Date: Tue, 25 Jun 2024 09:13:23 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: core: quiesce request queues before check
 pending cmds
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "quic_rampraka@quicinc.com" <quic_rampraka@quicinc.com>,
 "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
 "quic_ziqichen@quicinc.com" <quic_ziqichen@quicinc.com>,
 "quic_nitirawa@quicinc.com" <quic_nitirawa@quicinc.com>,
 "beanhuo@micron.com" <beanhuo@micron.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "junwoo80.lee@samsung.com" <junwoo80.lee@samsung.com>,
 "mani@kernel.org" <mani@kernel.org>,
 "quic_cang@quicinc.com" <quic_cang@quicinc.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
 "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
 "quic_asutoshd@quicinc.com" <quic_asutoshd@quicinc.com>,
 "quic_mnaresh@quicinc.com" <quic_mnaresh@quicinc.com>,
 "manivannan.sadhasivam@linaro.org" <manivannan.sadhasivam@linaro.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1717754818-39863-1-git-send-email-quic_ziqichen@quicinc.com>
 <d3fc4d2b-81b0-4ab2-9606-5f4a5fb8b867@acm.org>
 <efc80348-46c0-4307-a363-a242a7b44d94@quicinc.com>
 <b1173b6f-445c-4d6d-9c78-b0351da2893a@acm.org>
 <ee45ce9429b1f69147c1a01e07b050275b4009bf.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ee45ce9429b1f69147c1a01e07b050275b4009bf.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 6/24/24 8:38 PM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> But ufshcd_scsi_block_requests usage is correct in SDR mode.

ufshcd_scsi_block_requests() uses scsi_block_requests(). It is almost
never correct to use scsi_block_requests() in a blk-mq driver because
scsi_block_requests() does not wait for ongoing request submission
calls to complete. scsi_block_requests() is a legacy from the time when
all request dispatching and queueing was protected by the SCSI host
lock, a change that was made in 2010 or about 14 years ago. See also
https://lore.kernel.org/linux-scsi/20101105002409.GA21714@havoc.gtf.org/

> So, I think ufshcd_wait_for_doorbell_clr should be revise.
> Check tr_doorbell in SDR mode. (before 8d077ede48c1 do)
> Check each HWQ's are all empty in MCQ mode. (need think how to do)
> Make sure all requests is complete, and finish this function' job
> correctly.
> Or there still have a gap in ufshcd_wait_for_doorbell_clr.

ufshcd_wait_for_doorbell_clr() should be removed and=20
ufshcd_clock_scaling_prepare() should use blk_mq_freeze_*().
See also my patch "ufs: Simplify the clock scaling mechanism
implementation" from 5 years ago=20
(https://lore.kernel.org/linux-scsi/20191112173743.141503-5-bvanassche@ac=
m.org/).

Best regards,

Bart.
