Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D1101863E;
	Tue,  6 May 2025 16:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746548135; cv=none; b=A1yr8XuepL+429V5ztgjZIP3QlFXMpvcfXF4ji95A990bpxmbmG6TbbrAMMjOMY5wpM4aKzyN5+4neK4qFbHNKMmZeyt/K9xNBWGW0bGaT/EKFHN/SjR+AGswd+OXcbIEMei9qVNHoQ4LiLSoY20Hc/IAzZlIba4vZ85sGZD98Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746548135; c=relaxed/simple;
	bh=IMwNfLGm9juQH4lPnt2AR3LxjJ4sPAsvNvdRxYIrgLk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B1/njVZc2KUv7yhtTqS9JQg0U4gOMAaJAOvwFlgFkYasGlTkkKsZfiYfnqrVi+EmiJZ2opyrWUXbvIP0fgr+KAq3mY0ifY1FcYK2njgDs2BniuPYmghW7slyaya125NRMB29nxew/uxZQO5vYFmk0g9cNA6673ke1yzC+Qt3z/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=NbQlOyCH; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="NbQlOyCH"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4ZsNlw5NBWzlvBXp;
	Tue,  6 May 2025 16:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1746548120; x=1749140121; bh=oEjLAJ5MJCR9DXyM0kDJC2DJ
	T9WpoekiwyCg7+L54VM=; b=NbQlOyCH1zKMZNJ2xEg57lzteu1dW07WpzdiUOgP
	CtxlrnVRj8P3LL4VXMP9JXD5JSu/uw84jetEEm1EJFWtZPslsdNRa7TNWlUvb9Dl
	CQ9OB7m72raomLLBa37CxkTl0NttuVArdb+VBqZmdMTKMMXTyzmslD1i49ox0yTE
	0PCFtKhL2YwWvRWYiD680Gjq03CCiIlovHObuOA4PoWQSQjT0YFKqCHWRslyIw9f
	NyX9Ai7KO7MxT9H9BeQYfc3O5dnjdMoo8yxUnEmQpGYrlHkFCq2GxpvCKnfvx+Oy
	hgHNDhBsxLT1kgnpIHBhw/4wlE/HHwxjQ+6qlnHIIyT8Ow==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id LiH4KEfXhywU; Tue,  6 May 2025 16:15:20 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4ZsNlX3lBgzlvBXV;
	Tue,  6 May 2025 16:15:03 +0000 (UTC)
Message-ID: <04fc1549-0fa6-4956-b522-df5fbc26100c@acm.org>
Date: Tue, 6 May 2025 09:15:02 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] ufs: core: fix hwq_id type and value
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com,
 jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com,
 yi-fan.peng@mediatek.com, qilin.tan@mediatek.com, lin.gui@mediatek.com,
 tun-yu.yu@mediatek.com, eddie.huang@mediatek.com, naomi.chu@mediatek.com,
 ed.tsai@mediatek.com, quic_ziqichen@quicinc.com, stable@vger.kernel.org
References: <20250506124038.4071609-1-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250506124038.4071609-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/6/25 5:39 AM, peter.wang@mediatek.com wrote:
> From: Peter Wang <peter.wang@mediatek.com>
> 
> Because the member id of struct ufs_hw_queue is u32 (hwq->id) and
> the trace entry hwq_id is also u32, the type should be changed to u32.
> If mcq is not supported, SDB mode only supports one hardware queue,
> for which setting the hwq_id to 0 is more suitable.
> 
> Fixes: 4a52338bf288 ("scsi: ufs: core: Add trace event for MCQ")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Peter Wang <peter.wang@mediatek.com>
> ---
>   drivers/ufs/core/ufshcd.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 7735421e3991..14e4cfbcb9eb 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -432,7 +432,7 @@ static void ufshcd_add_command_trace(struct ufs_hba *hba, unsigned int tag,
>   	u8 opcode = 0, group_id = 0;
>   	u32 doorbell = 0;
>   	u32 intr;
> -	int hwq_id = -1;
> +	u32 hwq_id = 0;
>   	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
>   	struct scsi_cmnd *cmd = lrbp->cmd;
>   	struct request *rq = scsi_cmd_to_rq(cmd);

Is this change really necessary? I like the current behavior because it
makes it easy to figure out whether or not MCQ has been enabled. Even if
others would agree with this change, I think that the "Fixes:" and "Cc:
stable" tags are overkill because I don't see this as a bug fix but
rather as a behavior change that is not a bug fix.

Thanks,

Bart.
