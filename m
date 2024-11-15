Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309821CDA3F;
	Fri, 15 Nov 2024 18:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731693622; cv=none; b=nScBcT1nT5nXoqIC2PNcNYpiY/hO6MUKFeDi8b4iPvNv7uZHAxuhVj4wphOiGslztZ1zpdpVw1MsgFz6YIpWLc94u4Ux9/bpg+C1cVWtK4kcJQc+3j7bqUdsl2IQZ406FK9IgAO/BtH2wBGsWe88SCQ7ymt9hrTeIDPVf/xytaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731693622; c=relaxed/simple;
	bh=kz1/rdO3MbFLFPxJLFU6eWzlgrxKAo09K7jT0P0w11g=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=OI4ZU07j2EYVMSrzclZXiv5zYXT1M3Aa+ZLxPxG8PMkgb1kq9A+w6LexiI3Gr3WmazsVa1iHA+ivcEDjjm1sX//2nNmdyQhLo6pinFW5n2GUVXSqE3BmVYfyzrbZtaa5F4PXMEeF/yPyJRBT8DFOnEoEU0UYgTajOsyBGYns1zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=u3asuL4I; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="u3asuL4I"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XqlDG2dbbz6CmQyW;
	Fri, 15 Nov 2024 18:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1731693611; x=1734285612; bh=kz1/rdO3MbFLFPxJLFU6eWzl
	grxKAo09K7jT0P0w11g=; b=u3asuL4IjmGCidOmgRw8CoZ/sdtX+T472kDGpWYz
	tncvLg4rUGZ/jxDgOdy7MUJvDF1ctKUzMYZvqF4+fPZQoABQbC0Y0p0bU4I90WTw
	+iKSWU4WW44LgPGSnn5LNeSNT6ayUDFWnjWqdFKTysODqoe9H+txaj5PB0lSLT6h
	384UaQbrY6xYkDQOMu3CPeafw2gkPRyF7NGPSHZEKhxVOL9Q/a1pGjUOpwaz4F7r
	AMA2KmMZFvxqG4HdlKd32lz5nkP8yb8RCVmfpfgaedszfHDZmHAlsZsWPl9ttxod
	MfNh9wluK9smCXLc/SvuY5QZKXIJpPFVjErUYSsI5tDaVg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id h_RTI91TuQQ3; Fri, 15 Nov 2024 18:00:11 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XqlD971plz6CmQyV;
	Fri, 15 Nov 2024 18:00:09 +0000 (UTC)
Message-ID: <1e56d9f8-6e16-4f17-9fdb-5296bb308bdd@acm.org>
Date: Fri, 15 Nov 2024 10:00:06 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [scsi?] [usb?] KASAN: slab-use-after-free Read in
 sg_release
To: syzbot <syzbot+7efb5850a17ba6ce098b@syzkaller.appspotmail.com>,
 linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-usb@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <672b574b.050a0220.2edce.1523.GAE@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <672b574b.050a0220.2edce.1523.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

#syz test: https://github.com/bvanassche/linux.git scsi-for-next
