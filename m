Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16292263F2C;
	Mon, 24 Feb 2025 18:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740420733; cv=none; b=Sfh47/ozA7bj2rxNVnrda98GzfhrubsElMES5hdYSxDQob/wE1WjfjUz5549L3XO0HtDTNsSLRY7df8+wUiWbJotI9w68YqixdryLZ/cL5I8mH59VzHHLtHBRg98/wvqF7pch/JE8S+FZk8vEoqqsaj0B3Ge/p8JeikDY3GLWTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740420733; c=relaxed/simple;
	bh=g8/KDpgvxe1c7z2kKKWcFmyVaQCFiSYt5VoEmADrJJM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MZTBWyV16ZunJRC76QN84+cpwqUUaqBNzZtiWlcRsYY8Cy190QeU3SB5jkmPrwKnFeN1OqJnwpdB5k6XlmLhYJ/iOhNqnZbPnFiC0Ygwo/ofbEKeuzea4H9YtAovgXghvf7x3VEWbixdAhFXg+aYuHrxblnWBnEXKxmP8AntYVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=0WpoIo37; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="0WpoIo37"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4Z1pjK1LVvzm0yQH;
	Mon, 24 Feb 2025 18:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1740420722; x=1743012723; bh=02iQ2St+XAcnKASiGHZa/LWP
	G7gPbiyGfTrSwpW4hCY=; b=0WpoIo37rLvZE4R0nHmTmhSA1NaoKDLuVf1GcV7o
	xm3tMdd+/Q9Us2R+HgYP/5NSBYL0QZ3jzspvwFN0kZszUDhXVgcBNtxhn/XDjDOb
	H+qVeS7mfi2gAe7GN687iElF6PfOM3eIn6pPjWsBoz9tiiykVyOmgRA+NQvBPb8i
	GNTVWmoy7Rz0JPmUY9S7sTWuB08SEcX6gTv/gvdjTVUSVBC8hvWypxB07Kzs9Y+W
	3qE0ii8/SDmlE8i1E+eyrq/Qi/eEj8OuImtpWZDb5pfyXRnR/20FrdQ0ghwDGo5B
	Pw+YY1qdEYTHmMWclEXRpjZytc7+Z1n5O6HdG+1kz7XR+Q==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id LkPBP-YrE8zg; Mon, 24 Feb 2025 18:12:02 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4Z1pjD4JM3zm0djZ;
	Mon, 24 Feb 2025 18:11:59 +0000 (UTC)
Message-ID: <ad1ba59a-3a67-4b3c-a05d-c4e56405cc19@acm.org>
Date: Mon, 24 Feb 2025 10:11:58 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND PATCH v3] scsi: Bypass certain SCSI commands on disks
 with "use_192_bytes_for_3f" attribute
To: WangYuli <wangyuli@uniontech.com>, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 stern@rowland.harvard.edu, zhanjun@uniontech.com, niecheng1@uniontech.com,
 guanwentao@uniontech.com, chenlinxuan@uniontech.com,
 Xinwei Zhou <zhouxinwei@uniontech.com>, Xu Rao <raoxu@uniontech.com>,
 Yujing Ming <mingyujing@uniontech.com>
References: <ADB8844D07D40320+20250224034832.40529-1-wangyuli@uniontech.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ADB8844D07D40320+20250224034832.40529-1-wangyuli@uniontech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/23/25 7:48 PM, WangYuli wrote:
> However, "lshw" disregards the "use_192_bytes_for_3f" attribute and
> transmits data with a length of 0xff bytes via ioctl, which can cause
> some hard drives to hang and become unusable.

lshw is a user space utility. use_192_bytes_for_3f is not exposed to
user space as far as I know. So how can the above statement be correct?

> @@ -1613,6 +1614,17 @@ static int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
> +	/*
> +	 * Before we queue this command, check attribute use_192_bytes_for_3f.
> +	 * Because transmits data with a length of 0xff bytes via ioctl may
> +	 * cause some hard drives to hang and become unusable.
> +	 */
> +	if (cmd->cmnd[0] == MODE_SENSE && sdev->use_192_bytes_for_3f &&
> +		cmd->cmnd[2] == 0x3f && cmd->cmnd[4] != 192) {
> +		cmd->result = DID_ABORT << 16;
> +		goto done;
> +	}

 From include/scsi/scsi_device.h:

unsigned use_192_bytes_for_3f:1; /* ask for 192 bytes from page 0x3f */

The above code uses use_192_bytes_for_3f for another purpose. Please 
respect the purpose of the use_192_bytes_for_3f bitfield.

Thanks,

Bart.

