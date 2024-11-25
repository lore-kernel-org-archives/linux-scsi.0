Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1094E1CD2C;
	Mon, 25 Nov 2024 21:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732570144; cv=none; b=i15ag16LIbH9BMZn14wdGLKb1/OaginNn0Vk50pmqyC5afCIAmesmbxRJVIsnSjBVxS87nD69/R95B5995VfHLnf1FP4dS+0MFglXAyOtpvK7tE9zcqO6XdyBuF8JM3bOcl/9gMZqEAqrdtjZMtG0DJ6oLYqCktEtsqf6wc2DaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732570144; c=relaxed/simple;
	bh=0mb0wTiNbxoPB2+Cw64h5PVHiG5BntmliQCvQIxOPu8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HG3Ay2b7w3a9aGH61UVAxoYwhwb3C3teICJGSJ16KShb6/YPLNq4OaDCxwoP+QDP7Lje3nQiZFp56mIjVEW1ZjSoxgLEDRdafn0opmrSHhi5PxTBQmddhXkhv72LvLGUKiWqKAOi7dC8BINeIxh5OdLxfsdNbCP3xyP2w4xEGbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=M2fUBHXR; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="M2fUBHXR"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XxzNZ2rMvzlgVnN;
	Mon, 25 Nov 2024 21:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1732570140; x=1735162141; bh=0mb0wTiNbxoPB2+Cw64h5PVH
	iG5BntmliQCvQIxOPu8=; b=M2fUBHXRt9g0gco1na88eSDYzs4gl0FJ0ciyZbiG
	QApBNPAclqnne8R3R63Vy06RRe38BO9h4rT/LyJ4R3SSCux8mNMTcJIyLijoTFKi
	Zey2vhiNLL8gjtqx+tCvePMyPWJYKRjiJKoVf+qcR+BWEuhyqTWAVfEj+2lPNB5G
	vaOFiIG0w0fJeS59yLwW+AtXVrIrzspdR6q/aMq3ehDOTkuaViBgVXXbQoCs1oNf
	FGH8ub0yt7Et308tdPrnnWTO30Ijs1jyZUYDKbNGtpK0nin/hfsTpOYLZ1OXko9D
	YDXFbZsvvQfjHmwOh9ynS7EzmBYIPCw9F3pR107IoYVjWw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ChA_ftdnRWeO; Mon, 25 Nov 2024 21:29:00 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XxzNV4DcHzlgVXv;
	Mon, 25 Nov 2024 21:28:57 +0000 (UTC)
Message-ID: <f2299dbb-9296-4f07-9034-4db9a5c07a97@acm.org>
Date: Mon, 25 Nov 2024 13:28:55 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/4] scsi: ufs: core: Introduce
 ufshcd_has_pending_tasks
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 Bean Huo <beanhuo@micron.com>
References: <20241124070808.194860-1-avri.altman@wdc.com>
 <20241124070808.194860-2-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241124070808.194860-2-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/23/24 11:08 PM, Avri Altman wrote:
> Prepare to removed hba->clk_gating.active_reqs check from
> ufshcd_is_ufs_dev_busy.

Patch descriptions should use the imperative mood. If this series
is reposted, please change "removed" into "remove". Since otherwise
this patch looks good to me:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
