Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2CDD4A99C6;
	Fri, 11 Sep 2026 17:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789148566; cv=none; b=FnJLUXDOMA/JYLJ+QVp9ShZX3+CDA672bIZ27Bbi+M6tBEVpGrhBYq/LGzCO8gHhyV+aY6O6SoOMTj5ugNNoCStKYT6/VD5YsnmymPdRcB4ChzB5WH7GftmrW5m7ih8sRJccxvYTfMRZf2AVJQhnKn7A8LMnwSC0NQrgkMNEYaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789148566; c=relaxed/simple;
	bh=gRPmfQnW76c+8ECYLyGlaPU72sJ4pKh8ygMwuo1xnOM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=pqzNguASUyEGcy1jM1d/F2UJXrxGmSJE/mYVUtkVshF8pTs98fcjgDF4L2KdWslaRhqY8ziE28sxITXojbaz22MEbpfN0ttz/sujZSDUtS1PdhGKDFpgh+p9cBARMsuth8iQ3+QdR2z3a2IoPrS0jH3VStF0ZzRg2jg/9e1Wvcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=OOJAPWm1; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="OOJAPWm1"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hhMM76qQczlfwHS;
	Fri, 11 Sep 2026 17:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1789148561; x=1791740562; bh=gRPmfQnW76c+8ECYLyGlaPU7
	2sJ4pKh8ygMwuo1xnOM=; b=OOJAPWm1mO9tseLX31qlp2ykgNoBQGt6NbICddoi
	pzgS6NrTZdlDNbXvX+ImRkJjYp3XbFqDCNW3EV0/+yBomuLNWezxXvOU1o9AqzeO
	vSkgo5BWdVAHvlQKKCCOXqS/Hk5yR6rj1IwtU33nz52n12mJMANKIqdEUJelhbAA
	RL8f5l0nUSOZ0YZIl1ap9bLjKSNa2cMyYF8vpC9dkGql9VQ+CHRvxWR5CEv2I7sf
	cSbjNymcxxurca3qBMQeosSMxS54HdGm1uvLOCttCXOafYwJTfQyblrsryIOs04M
	0qZfG1ViDuwbyAxZ1SBIaoWi1AcrGMQpiZfDet11Vw90dw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id XJT4RtjXPrIC; Fri, 11 Sep 2026 17:42:41 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hhMM34kdczlfvqM;
	Fri, 11 Sep 2026 17:42:39 +0000 (UTC)
Message-ID: <fcabab93-13bf-47da-91ac-5e7fcaec6362@acm.org>
Date: Fri, 11 Sep 2026 10:42:38 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [scsi?] INFO: task hung in scsi_scan_host_selected
To: syzbot <syzbot+1f678bd2872aefb11d8a@syzkaller.appspotmail.com>,
 James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org,
 linux-scsi@vger.kernel.org, mkp@kernel.org, syzkaller-bugs@googlegroups.com
References: <6a998e96.9266084e.bf0d7.026d.GAE@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <6a998e96.9266084e.bf0d7.026d.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

#syz test https://github.com/bvanassche/linux/ scsi-scan-syzbot
