Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB13133D8;
	Thu, 19 Sep 2024 16:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726762312; cv=none; b=lFyDr7d1vo0+2bZ+QpEW9jlcTYkj/80HO0LAU8mPaK2bpOn6x+ix4kYNc9QD9R+A3KqDGJzzIuaWjEGLtkJPSYD02/GhGAZpPol1o1ArFRGDhtgITf6J3BFu8OgMlQuVy7Q5zL/n7uA4XczX8q6oGIsPGYOMtE1L8nBipB8MCsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726762312; c=relaxed/simple;
	bh=RwFUT4/1bvkICJiXz/a4cp1ZOr5f/sY1Hl2xioK2hbc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m74baL1JSzKiHyIlAow0LMaA0gvoDTvLP0gTH99ZX3FzmU3B9Zx3Nb+9DCJYeqOPyIuyfsilCsgDSEeG6EgMk8t0WFKCkSbym7+SS5oyva/N4QVaWapIaTTakrqIlAX8YCRSc4/8TUCfjjB+TV9qjrU7iHYqXP+c7puQ/nfSblE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Y6bom4R3; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Y6bom4R3"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4X8gWV0YQYzlgMVg;
	Thu, 19 Sep 2024 16:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1726762307; x=1729354308; bh=5A7CoGBRIDh7hXjPzoJ27jsG
	5cpX2WYu5BLWqO1q3eM=; b=Y6bom4R3xe4k7x7SHJ6wl61NzocPuy2HtDQ+an9Q
	J2K5t8iF9yruBrnOjUhzFc2z1+isRMqd+u07Xg80OSAj2XsP1EBEHEzAaVdMlwDe
	5rO1hF41XyJUYgNgvKa4A5dJipGuyjdbkLbmslvckVvpfFTxSKEHoizNY26ASdo/
	m82i/X3+UpXs3U4lhu4duhLq8XdPFL5+gqMaXI6DhMEEyUpejlflu2SPhxhsNYe2
	fWKRT3kx5Hnlj08WShdhAzuJYa8o1xsFr6egFjz7twne5GTq1ppT59S4Pt+hV5Nm
	v70pbz/oKWdHJLdlpg+PbBsqj7cWQSBu0UybeU94VF7CMQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 1M7YI83dPMdz; Thu, 19 Sep 2024 16:11:47 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2e14:8:c63c:d019:b694:8044] (unknown [104.135.204.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4X8gWQ1bghzlgMVY;
	Thu, 19 Sep 2024 16:11:46 +0000 (UTC)
Message-ID: <8e8d2268-fde5-4f0e-949c-b2a929f41474@acm.org>
Date: Thu, 19 Sep 2024 09:11:47 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: qedf: Fix potential null pointer dereference
To: Liao Chen <liaochen4@huawei.com>, GR-QLogic-Storage-Upstream@marvell.com,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: skashyap@marvell.com, jhasan@marvell.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 njavali@marvell.com
References: <20240913033627.1465713-1-liaochen4@huawei.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240913033627.1465713-1-liaochen4@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/12/24 8:36 PM, Liao Chen wrote:
> qedf is checked to be null in this if branch, accessing its member will
> cause a null pointer dereference. Fix it by passing a direct NULL into
> the error function.
> 
> Fixes: 51071f0831ea ("scsi: qedf: Don't process stag work during unload and recovery")
> Signed-off-by: Liao Chen <liaochen4@huawei.com>
> ---
>   drivers/scsi/qedf/qedf_main.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
> index 4813087e58a1..9d4738db0e51 100644
> --- a/drivers/scsi/qedf/qedf_main.c
> +++ b/drivers/scsi/qedf/qedf_main.c
> @@ -4021,7 +4021,7 @@ void qedf_stag_change_work(struct work_struct *work)
>   	    container_of(work, struct qedf_ctx, stag_work.work);
>   
>   	if (!qedf) {
> -		QEDF_ERR(&qedf->dbg_ctx, "qedf is NULL");
> +		QEDF_ERR(NULL, "qedf is NULL");
>   		return;
>   	}

I think it would be better to remove the if-statement and the
if-statement body since qedf cannot be NULL in this function.

Thanks,

Bart.


