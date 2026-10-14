Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8A9376490;
	Wed, 14 Oct 2026 13:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791984677; cv=none; b=GCjJ4kkKQN/2BdwVkv1hpLnKRuAOeqHGz2ikFF/rh+5MjLUoLH5blVcFJS0k1MhBn5upahEI2wm5eSwRkIorV1EdLE+xDVKdM8k/UgW7cxMQjw4kpxl/Cg6XevKkgfV8hPGl+7dwajEJveYZ0AEA64W5EWJPFGbUTb3yX9IzDN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791984677; c=relaxed/simple;
	bh=HJZ5MJgxunIkRLWvc+jLcJkipmTsNFq8aI446pdfw+4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ozPNp4Mjcrui4mIAn7HxZEoy+x5d3jc+8B5bck12M6N5qHK1zu6thvqxs781wlsvEaWEo0DljryIgnQnJmpgL6YPqT4eQ0UV9PewVEi71H3lc+yvxRu+Lhp9grBTimBg/bJk17eviaVBtgVmslIbw1tMUDZR87KiFYkVd1uNIkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=3ZWGrcJI; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="3ZWGrcJI"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4j4XCV3nv2z1XM4Tn;
	Wed, 14 Oct 2026 13:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1791984657; x=1794576658; bh=cULsbpL4/ypKr+b68EUXjCd8
	bXVDfuRvjPXfSXjEzpw=; b=3ZWGrcJInZgri4227+zHAIEdnus5zn0z6LYL4scC
	gfLrwOfWV8HJGLAOnu3jOl2Sw111b0dGAi0MZePronT8fIuHPrIvVx1MpOdyzFmT
	KX8GARuMLp/edex9APL7R24aairirPi9QBkKilarynx34y4iC4Nl1++fELWKivo4
	mjgw4HFN0vwJRYjj0V+ZM0B5dbrLATb9h3bmVIV6Zt+EH13X6+q5OQyVgMLCUBYn
	1ce90hdU+hvyCLaxtQ3He94XRk4oVHdndO+sr+Kg5rg+8IgFKCe71ur/CxBLYGOo
	1PWmkJqhos0dQqvjzqxSb8L1B+CdgVLH+2Bfh5C8quC8vQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id IJ_-2R3aBdpI; Wed, 14 Oct 2026 13:30:57 +0000 (UTC)
Received: from [192.168.51.14] (c-24-6-239-25.hsd1.ca.comcast.net [24.6.239.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4j4XCN3s84z1XM4Tl;
	Wed, 14 Oct 2026 13:30:56 +0000 (UTC)
Message-ID: <e3706904-3b53-41bf-b8c0-48ac4d2e2cf5@acm.org>
Date: Wed, 14 Oct 2026 06:30:55 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] scsi: ufs: bsg: Clear the UIC result byte before
 sending UIC commands
To: Stanley Jhu <stanleyjhu@google.com>, "Martin K. Petersen"
 <mkp@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: powenkao@google.com, Alim Akhtar <alim.akhtar@samsung.com>,
 Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261013102913.948718-1-stanleyjhu@google.com>
 <20261013102913.948718-3-stanleyjhu@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261013102913.948718-3-stanleyjhu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/13/26 3:29 AM, Stanley Jhu wrote:
> ufs_bsg_request() passes the user-supplied UIC argument2 unchanged,
> including the result byte (bits 7:0) that only the host controller
> writes. A non-zero value triggers the WARN_ON_ONCE() in
> ufshcd_dispatch_uic_cmd() and corrupts the reported result. Found by
> syzkaller.
> 
> Clear the result byte before sending the command.
> 
> Fixes: e77044c5a842 ("scsi: ufs-bsg: Add support for uic commands in ufs_bsg_request()")
> Fixes: 9fb4c793223b ("scsi: ufs: core: Complain if UIC argument 2 is invalid")
> Cc: stable@vger.kernel.org
> Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
> ---
>   drivers/ufs/core/ufs_bsg.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
> index dab1f05aff38..331ead0403a1 100644
> --- a/drivers/ufs/core/ufs_bsg.c
> +++ b/drivers/ufs/core/ufs_bsg.c
> @@ -179,6 +179,7 @@ static int ufs_bsg_request(struct bsg_job *job)
>   		break;
>   	case UPIU_TRANSACTION_UIC_CMD:
>   		memcpy(&uc, &bsg_request->upiu_req.uc, UIC_CMD_SIZE);
> +		uc.argument2 &= ~MASK_UIC_COMMAND_RESULT;
>   		ret = ufshcd_send_bsg_uic_cmd(hba, &uc);
>   		if (ret)
>   			dev_err(hba->dev, "send uic cmd: error code %d\n", ret);

Shouldn't invalid inputs be rejected rather than trying to correct these?

Thanks,

Bart.
