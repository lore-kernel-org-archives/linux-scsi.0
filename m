Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9CD6FB9;
	Thu, 21 Mar 2024 02:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710987263; cv=none; b=Ef3MR8T4qlpWux7PwKug0vMP1w6ak0Id/7/g4lCM3oVuSC+DU8HjSUmlRsAXbGWfUWazj0QdHzROVzGHh34jKbvfXEpnI62N6WEWxI9jsbgIXaTobXiKC9ULP+F9EGQlm9+iDM11mgPGpNcT1BoUJzsD0Mn3ZJn1TCy6YndiOnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710987263; c=relaxed/simple;
	bh=jfvCeLIg+canj1YOabyHCZY32Y5la91we5Z1XUDvdkc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ddb7ibvh1IDQDwFt6FXBZwTyM+r3274mOAiJPcWw1YzwdiQbRZTFO8Od5S7rMO5/oTK0w0Dk7ogqOXZoPcIycb7KQ9h1EhPb4hQFbBqHBVPLUKHsIGvnCKZgXr4XrxYCwsc/NetmKfKRZV6vKEozrDQoGjBL+qTcmhaAvZ1Hrjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=elhsWbcB; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="elhsWbcB"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4V0TY902pTz6Cnk8y;
	Thu, 21 Mar 2024 02:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:references:content-language:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1710987258; x=1713579259; bh=bYq+oUDZUpDI/pMzlQv8q7N+
	w8/crdOYLwn0HTneqtY=; b=elhsWbcBTPwtjGsPM4L4hGm3L4I4yocByWau3xoq
	z23GYI0sR2owMGt6ydD330kIdaPCT5LlAapQrWWMQKTGp0UAx29SNghjRkU+pRWW
	0ZRwPL/NGof/zUL31XnSB6eJZEM/szbz8tPUUPcNPuZIvdurZkPZ4Cfxkb7zyf2J
	32trLH2A5XSuDB9V2Ria8o184JyqV5du0TH3pzZ+yuHpdHyUtAf/r/ftoIjHUJ9o
	rnv44qvJyjjhjcfErw9P8fJMhxCBDgwvFzpdxNy4IknUAXtAF1cC7vgB8aSNOSs+
	R27xMjqikQsF/i7LI0gjznh4bFZng+3wdiBddj2o870IdQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id gOfMeMs7eDlS; Thu, 21 Mar 2024 02:14:18 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4V0TY60Thsz6Cnk90;
	Thu, 21 Mar 2024 02:14:17 +0000 (UTC)
Message-ID: <2489eb85-747d-441b-b19b-4e4c5ef1c478@acm.org>
Date: Wed, 20 Mar 2024 19:14:16 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: WARNING: CPU: 45 PID: 84967 at ../block/mq-deadline.c:659
 dd_exit_sched+0xce/0xe0
Content-Language: en-US
To: Xose Vazquez Perez <xose.vazquez@gmail.com>,
 Martin Wilck <mwilck@suse.com>, Hannes Reinecke <hare@suse.com>,
 Jens Axboe <axboe@kernel.dk>, BLOCK ML <linux-block@vger.kernel.org>,
 SCSI ML <linux-scsi@vger.kernel.org>
References: <cc8d00fa-9ffb-441e-9483-7ef4a581e9d2@gmail.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <cc8d00fa-9ffb-441e-9483-7ef4a581e9d2@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 3/8/24 07:24, Xose Vazquez Perez wrote:
> This warning arose in the middle of a lpfc bug.
> The block/mq-deadline.c file of this SUSE kernel is synchronized with
> the latest version, and perhaps the bug is relevant for upstream.
>=20
>  =C2=A0statistics for priority 1: i 219 m 0 d 219 c 218
>  =C2=A0WARNING: CPU: 45 PID: 84967 at ../block/mq-deadline.c:659=20
> dd_exit_sched+0xce/0xe0

I think this indicates a bug in the block layer core - a bug that has
been fixed in the latest kernels by the blk-flush.c rewrite. I fixed
this bug for the Android 6.1 kernel. Please let me know if it would help
if I make my fix available for inclusion in the stable trees.

Bart.

