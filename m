Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCBBB17C6B;
	Thu,  4 Apr 2024 16:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712248343; cv=none; b=ceNWgWQ1oZnIBccv3/l1E00UpWXqS0b4iovOkIo6Kibp4zv5PyZvo2WHBGSG7QZwCIMqQcHMNRhD1qZyA/zv2ha5WblQ9C7MaxciXysGjSXxWIG92P6HI+doVLKJbRjLBLxNCuDTFbh0+tuEjqgjvTCpomMYFDWJxt/7ELwkZE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712248343; c=relaxed/simple;
	bh=omsADSD+7vTDb6nfcbOkcYvRC7o4+SL5HeuxZtkQasE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kylsv/4NhFLGbzYenMj0TZvp0ZEnxyqq5+6BHfzDaWKp7ZSncmdf7T38TvHbvDVww5vnTsZo3OTBG/JTnEQpGnD+cA6333i+0gjk+BrBYIOrkrtBcUIBNsAxi2f7TbqoUU/wHAp7/0ZOohN+V2r/2YUwd/lid9IBPQvkDhbVlqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Il7OOCpQ; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Il7OOCpQ"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4V9Rwj1DLDzlgTGW;
	Thu,  4 Apr 2024 16:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:references:content-language:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1712248340; x=1714840341; bh=jIEHPy1+GaDZbSl3tHxpaKQA
	QzdIRwfb9d10+zg+Mos=; b=Il7OOCpQQqzhgZerUlqESO9Th4HkwREkAuFqmg42
	KmKHsz3Z1TiytWy/WMrnpRdbrDOs3IDlxv+oBvPyxp5NyUgshZGjti6RxpdkWV4D
	fTztFHn+uMwyXWukOd3nskqWVU5SwagMLrBmuZOtOAewxnKKyiqTnGKCXs7O7f/3
	2GzUT309IgBskbTehoYEFPebczkyGjHKh2lE5e6y/Sq+y1xOb1wgPvlM4wcd3g1o
	0OU+ZLPcyoQXY4EOY1wv+d82dK0PWyMNXEwi43jDrI5y5hzzqDzJ7hHlUwvjHnuN
	LvnrsFWD75TE1UwLKtD0bmUIfq/ldegUQHYQYqvmPlpVOg==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id oTn5h7mijZyR; Thu,  4 Apr 2024 16:32:20 +0000 (UTC)
Received: from [100.96.154.173] (unknown [104.132.1.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4V9Rwg2zFjzlgTHp;
	Thu,  4 Apr 2024 16:32:19 +0000 (UTC)
Message-ID: <d1fc0b8d-4858-4234-8b66-c8980f612ea2@acm.org>
Date: Thu, 4 Apr 2024 09:32:17 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Broken Domain Validation in 6.1.84+
Content-Language: en-US
To: John David Anglin <dave.anglin@bell.net>,
 linux-parisc <linux-parisc@vger.kernel.org>
Cc: linux-scsi@vger.kernel.org
References: <b0670b6f-b7f7-4212-9802-7773dcd7206e@bell.net>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <b0670b6f-b7f7-4212-9802-7773dcd7206e@bell.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 4/4/24 09:20, John David Anglin wrote:
> [=C2=A0=C2=A0 12.845277] scsi target2:0:0: Beginning Domain Validation
> [=C2=A0=C2=A0 12.845441] ------------[ cut here ]------------
> [=C2=A0=C2=A0 12.845485] WARNING: CPU: 2 PID: 711 at drivers/scsi/scsi_=
lib.c:214=20
> scsi_execute_cmd+0x74/0x258 [scsi_mod]

Thank you for having reported this. So that's the following warning:

	else if (WARN_ON_ONCE(args->sense &&
			      args->sense_len !=3D SCSI_SENSE_BUFFERSIZE))
		return -EINVAL;

Can you please help with verifying whether this kernel warning is only
triggered by the 6.1 stable kernel series or whether it is also
triggered by a vanilla kernel, e.g. kernel v6.8? That will tell us
whether we need to review the upstream changes or the backports on the
v6.1 branch.

Thanks,

Bart.
