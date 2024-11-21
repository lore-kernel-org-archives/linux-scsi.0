Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9051BF58;
	Thu, 21 Nov 2024 20:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732220651; cv=none; b=HIpTKLNFrqjKm1nyoZP8Xym6uUVcS0P4GvFlw+fX9jrgpmPD8bOkZ/ISwWvYleP0v60iPytGQoRENFG7PiYnOeV//+yykPk5iQGFsJ3XiUyvwhycAiTG8fj28MxK+yo3fDdUR7UtHexj6sbY4OWFMQa3ZD4WWT5cJZGXwobc/VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732220651; c=relaxed/simple;
	bh=xi/tuuYf9OctfWbVmpD8lnsh2h4jN8j/5RGrSnm2nkU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QHG1EK8j7TjlF4gOcsZa+Qm2UgNmuBiIGQ4apruVRB999CtSJ0TwUZldQegvDzouCS/kCvT2oCEqhui9HuWc248GW/go7RQFK4ldIqkIdgnJn8i1DoD1sj4Zs7gSXjOaTJiMHWVL8jU2Xgzg4j25nbh9nMEj4zt6Wca9YDT/jd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=zRjWZoYo; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="zRjWZoYo"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XvV7Y1RLsz6CmQtD;
	Thu, 21 Nov 2024 20:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1732220645; x=1734812646; bh=1II20KjSCTW3+CfSjWTXJ0ox
	zZQHlqaaITwj6CmNeg4=; b=zRjWZoYoFRFG1Chj9BcEuy1X0K19qpC4kN00bXNH
	v/s3VfAnwthpiF7f6Q5BAPVgaFc9mW40aJUPF5kGn32K9KeI0aRM7XM4rDlgWUTR
	hzxZuUvWqo58Y6oh2UR+VBhvsJdrLhKEO/JBpMnxoI9xJXB6glpk57MEfShTty0a
	J4nDMUuFcViHKWtrh9Yb9u5RkH3+dO9G/AVGZQSoMG6U5Qj2zvP6ptmJ8UFRT0sh
	iYNGVwW9ZLkPCkHCxxNupmmJZxRwE92pkJUCZVgLTyoempl4vk7US6MlvdSRex9T
	CDbzzKY6yf5ThBEmC/saPfWUyiUGQaiaWFBQ7V4d0AgM3A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id YOYPm1PlPNZI; Thu, 21 Nov 2024 20:24:05 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XvV7R5vP8z6CmR09;
	Thu, 21 Nov 2024 20:24:03 +0000 (UTC)
Message-ID: <3fe2a0cf-e652-4e4e-b74f-659eb5ab89e3@acm.org>
Date: Thu, 21 Nov 2024 12:24:02 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: sg: fix slab-use-after-free Read in sg_release
To: Suraj Sonawane <surajsonawane0215@gmail.com>, dgilbert@interlog.com
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+7efb5850a17ba6ce098b@syzkaller.appspotmail.com
References: <20241120125944.88095-1-surajsonawane0215@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241120125944.88095-1-surajsonawane0215@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/20/24 4:59 AM, Suraj Sonawane wrote:
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index f86be197f..457d54171 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -393,7 +393,6 @@ sg_release(struct inode *inode, struct file *filp)
>   
>   	mutex_lock(&sdp->open_rel_lock);
>   	scsi_autopm_put_device(sdp->device);
> -	kref_put(&sfp->f_ref, sg_remove_sfp);
>   	sdp->open_cnt--;
>   
>   	/* possibly many open()s waiting on exlude clearing, start many;
> @@ -405,6 +404,7 @@ sg_release(struct inode *inode, struct file *filp)
>   		wake_up_interruptible(&sdp->open_wait);
>   	}
>   	mutex_unlock(&sdp->open_rel_lock);
> +	kref_put(&sfp->f_ref, sg_remove_sfp);
>   	return 0;
>   }

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
