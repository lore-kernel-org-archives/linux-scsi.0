Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7010A362120
	for <linux-scsi@vger.kernel.org>; Tue,  5 May 2026 08:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777969465; cv=none; b=qgreEYVKdDvBPQHpNUZLsPOCh8R9NE450NwTgSMoScZkvS4KJlrtz1kRp8t1NM3XdQvhqpJogt6pVH3quq8EzekfNOkCJmH6eO2RP7C9Z4ktX/Acgj5F2vpa+E41CxMlmZE+jgYQbNfDgzJQH5h9W+VXDI18YrXxwBHoqCQpLRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777969465; c=relaxed/simple;
	bh=H5yKjWEmfViJ8gWD95N7HrCAww1+G7z9zfnb1f7+QGw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=vDWlKUEaOPvHhNmI47OXmJcpxk8b3E7rG0mR8n0pqLp/qESPAGfRSUk0RafIYIqvGC4p5dZHHUmS6MhsjJ1rXREqNEBfsqP1VEySqA7sf+JCKFTjPYS/0SqI4O4xQmRzTgYzfTaiYd1mpZmBmjSc03hrl50kSsZuGlLa63Utx4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=SnIccEj1; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="SnIccEj1"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4g8s4S09RRzlfvqD;
	Tue,  5 May 2026 08:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1777969462; x=1780561463; bh=nzsGdkADv5guWR9G6UZ48SuC
	nt97Y/aOkU711jsPXyg=; b=SnIccEj1yIbtoCp3iixMsHeU7q0qZ+yyS/mEXMH/
	ED9j2+i8rlzYb3lRiAi+QLkzX4a4MxLm/i18Rkb68D2LuyOz+xjmhdVdaC/Ez3iJ
	XkAK6hyy6a2eEDPxp2/iMoi6Ikrc3x00SJ02fSWj7BIItBeRE6PN+PuvSCAiK6jH
	LS2I0XupKKOKnMSE3M+ne6C9k+Pki5GerViIZcmGtUGNF0r3TaLOGlI8VGosKnQB
	0gAtfMpOMkkfTPgWQ59gqOpMOZGLenSEjTWbh9SrEGQbteR2XNKPsG3mqr+AqC/D
	HuUkWl9juifac9BoMKJVQ/7fJ+SiztMXa0ERkYncvoYBJQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id X26DTrDxfkP0; Tue,  5 May 2026 08:24:22 +0000 (UTC)
Received: from [10.211.9.52] (unknown [213.147.98.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4g8s4N2sNfzlfvpM;
	Tue,  5 May 2026 08:24:19 +0000 (UTC)
Message-ID: <1c517f94-d03b-44d1-8f3f-327be5362199@acm.org>
Date: Tue, 5 May 2026 10:24:17 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/6] scsi: Protect INQUIRY sysfs attributes with mutex
To: Brian Bunker <brian@purestorage.com>
Cc: hare@suse.de, linux-scsi@vger.kernel.org, krishna.kant@purestorage.com
References: <b584f42f-534e-4204-9fa6-92ff93ab62ad@acm.org>
 <20260504183651.81037-1-brian@purestorage.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260504183651.81037-1-brian@purestorage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 5/4/26 8:36 PM, Brian Bunker wrote:
> This changes the sysfs ABI for /sys/.../vendor, /sys/.../model and
> /sys/.../rev.

Not necessarily. If the format specifiers %-8s / %-16s / %-4s are used 
for reporting these member variables via sysfs, the sysfs output should
remain the same.

Thanks,

Bart.
