Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=199.89.1.14
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792441578;
	b=k3Wb8hBCEVWMocIogZUK0dEbaJ4BL7r/ORFw+fabIgJrgJpQLK1MKtJW2M10F/+TpqAr
	 f0t08mdK1uRC3HncDOoDGuuGmYIaXxlielfTdJpi2lsorfsonrI+MV62r8ZSgAbtmCOxj
	 mr1rYcG6DH798+NDoYgUGif/BAGmBJznKvJQyx3wxb0D4UDDFS+H6NJaqjl/GlCnU4ZhP
	 YaPEgpvzAfpyhuQEWcs5TptFAaWlsFjkO2lvsLsbgoCqiIxcXgvs0uYty20R6PV8eUzFS
	 uJP8JNWZj7CNFZ3t/joWoxsqxlzgIRAV7cC7WUY7H/wE55hZ0wIE/cH+7Mj7xP604+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792441578;
	h=DMARC-Filter:Received:DKIM-Signature:X-Virus-Scanned:Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=ZsOx8NaJxQJvgXBOVwcRDXVEiS2DGpA6kPmNbEP03xI=;
	b=z1cvTpbxa1ktSgbT0EHHN5xzpOhaK2n3gfQbUPiU1RB7gr6rYfnSlcx1RXYcrqN+Lcn8
	 92iWDbbN79moeqjJd8oDzDubdm85O3yOGQ/10dXzvXy07ivrazvvPhGPR7s5AAsgzGzgh
	 RWQrh2dfvJi7NpS0zKxnlbx7jjaHUK5kbOQmCVzMtmqYTYxBWI5UIeRTi7HY9DBX5Inli
	 vb7/mRuZwUJhkWcr4Fv6iniU0ydCZKohDywG0bw19KJmjHlhBG2bDs+kxN7ZJEscaiuJC
	 xfPcsYzPWWsr9RWZjahxmNZTfZtqHdhrH7f7ca00tMMgMCTrITsuzVa6Xo9vpBS+WQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=acm.org;
	spf=pass smtp.mailfrom=acm.org;
	dkim=pass header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=mhlwa691;
	arc=none smtp.remote-ip=199.89.1.14
Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16CD7606A319
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2026 20:26:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 16CD7606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=acm.org header.i=@acm.org header.a=rsa-sha256 header.s=mr01 header.b=mhlwa691
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4j7nBK3YSRz1XM4Tn;
	Mon, 19 Oct 2026 20:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1792441574; x=1795033575; bh=ZsOx8NaJxQJvgXBOVwcRDXVE
	iS2DGpA6kPmNbEP03xI=; b=mhlwa691DLULC2U32IWvQqut6vcASDdrsQGnWkMz
	JYUSJqGbkGnCJaIjJNWGKUogG4F6p+9qQ1QbUqfzYC743etwVknu5lQsTZZB6l8p
	SJc2SYGlMiOAwlHieWrboL7YHsYyNVyGztcKXqUF04rtbhUc/9jpsv4fMYBRA56f
	DZzIHq8zhvGVy6e+4VEPE255qrsZDHYP/sqw9iMl4gz7zVV8hGeade4KioTQJ5kF
	W/K1py40bP4S9FEBsL7NK5kbp56bTFrQ7eO0FZWn0ubno+q9eCp6aKWOn0fZOaiM
	mH7ylIwlEL3W6ylGyOwiZ7jGC0gya1OLid/iJEUq+UTiFA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Ecbia_sMysBp; Mon, 19 Oct 2026 20:26:14 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2ed2:d:80ed:7b96:75c0:6989] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4j7nBG4HnBz1XM4Tl;
	Mon, 19 Oct 2026 20:26:14 +0000 (UTC)
Message-ID: <58609b86-3383-4320-824e-34544322692b@acm.org>
Date: Mon, 19 Oct 2026 13:26:13 -0700
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: ufs: core: Fix stale comment in
 ufshcd_mcq_config_nr_queues()
To: Shawn Lin <shawn.lin@rock-chips.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Bean Huo <beanhuo@micron.com>
References: <1792370062-23050-1-git-send-email-shawn.lin@rock-chips.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1792370062-23050-1-git-send-email-shawn.lin@rock-chips.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/18/26 5:34 PM, Shawn Lin wrote:
> The comment refers to "hba->dev_cmd_queue", but struct ufs_hba no longer
> has such a member (it was removed when the dedicated hwq for device
> commands was dropped). Reword it to describe the actual requirement:
> the queue is a host controller capability and it serves both non-polled
> SCSI commands and UFS device management commands.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

