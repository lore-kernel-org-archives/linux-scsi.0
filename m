Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C30443A9B;
	Thu, 16 Jul 2026 17:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784224612; cv=none; b=jVopbTjSrknM0IQN8DFcajMyNoFyschfo0yJ2e1ZqMNUEYy+WY0PaBl75r6odXLTbc1QX/QgiUYjC/sr5noo5aHhP2rahfrYVYYrjr9fpEObJIqa38d+leshMr8Wbku20udrIbn2yzq5wuCjIEqbr13XEZIcR6pFLaA2fswfhrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784224612; c=relaxed/simple;
	bh=JWbMCSevP2D2kV3/dLtjs6E2ZnqUQeLceGDEDf93VGM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LvDMs7M7ksTfurRQQJaTtMxSiXsz6mcqFEjY1w9tiw+CTYmNV3VuP2Lf1yIE+Dk7a0US1ubrsSFsPKMjcxtwqShmVnrSMt3TVkvprBIInqWcyqJIoRcLUI3w60o8npGUyMO7sG3YIRhhlQAg07zYVYzoyVd283hc69rfuz6rp3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=MIqyIzL6; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="MIqyIzL6"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4h1LMj706Kzlh30R;
	Thu, 16 Jul 2026 17:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1784224604; x=1786816605; bh=ubP+5bSnHp9Mp2Et+zJ1X9zO
	dTHOUvZuGx8kKq2921Q=; b=MIqyIzL6N8SdQFsT/3Wa4QDRbUqV9d1Ezi9K0Q+8
	ISsPrDio1YKNYHoxZMSwy4FhXhrf3H1OjyiqzQVb0KlfVPlZFCI35yfj2IX36mAp
	DLaj47pJIzFOQxnkazSYcuxAWO+dv2gjLfg6nUDi8x9QvQ7Rzmb2YqwyQVW+pQc+
	HCJJ3zGl3KtnpInu7S86Wh5seG2QagMBJMF1O/BZkqK2iXY+IMff7OXyULMl7bvB
	MxdPcDEiXt5oagYpMhHRq1AUzHDY7cRj1fUx2mlCGPW6AST45onFcCFr8oyKX407
	bMgzMQCV00JpM0vOR3J1A2EoRboO3G1wx2jsbyYK1irPRQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Lp1rh465vYCK; Thu, 16 Jul 2026 17:56:44 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4h1LMY1RGzzlh30C;
	Thu, 16 Jul 2026 17:56:40 +0000 (UTC)
Message-ID: <dbbe9662-9ec1-47b3-952c-282203a45cc2@acm.org>
Date: Thu, 16 Jul 2026 10:56:40 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] scsi: ufs: debugfs: Reserve space for a string
 terminator
To: liqiang <liqiang01@kylinos.cn>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, alim.akhtar@samsung.com,
 avri.altman@wdc.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, peter.wang@mediatek.com, beanhuo@micron.com,
 can.guo@oss.qualcomm.com, adrian.hunter@intel.com, tomas.winkler@intel.com
References: <cover.1784182493.git.liqiang01@kylinos.cn>
 <123b934b63a0bb3f7aa016f640b992406acd4047.1784182493.git.liqiang01@kylinos.cn>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <123b934b63a0bb3f7aa016f640b992406acd4047.1784182493.git.liqiang01@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/15/26 11:19 PM, liqiang wrote:
> From: Li Qiang <liqiang01@kylinos.cn>
> 
> ufs_saved_err_write() copies user input into a zero-initialized stack
> buffer and passes it to kstrtoint(). A write that fills the entire
> buffer overwrites its only terminator.
> 
> Reject an input whose length leaves no room for the trailing NUL.
> 
> Fixes: 7340faae9474 ("scsi: ufs: core: Add debugfs attributes for triggering the UFS EH")
> Signed-off-by: Li Qiang <liqiang01@kylinos.cn>
> ---
>   drivers/ufs/core/ufs-debugfs.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/core/ufs-debugfs.c b/drivers/ufs/core/ufs-debugfs.c
> index e3dd81d6fe82..be527209540d 100644
> --- a/drivers/ufs/core/ufs-debugfs.c
> +++ b/drivers/ufs/core/ufs-debugfs.c
> @@ -165,7 +165,7 @@ static ssize_t ufs_saved_err_write(struct file *file, const char __user *buf,
>   	char val_str[16] = { };
>   	int val, ret;
>   
> -	if (count > sizeof(val_str))
> +	if (count >= sizeof(val_str))
>   		return -EINVAL;
>   	if (copy_from_user(val_str, buf, count))
>   		return -EFAULT;

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
