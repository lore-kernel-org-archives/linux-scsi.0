Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E372076A9;
	Tue, 12 Nov 2024 18:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731436380; cv=none; b=IIaVuU1gkWsiDFTzO7zlZRvTo2PAsv705ioeA7GGHu+uKmzxTmFy2Jjw6XLOPbz7AAjjTlajLOSlSHZsnKlKy9WEuzbe7RAvctWtBsDoeJEKakPP/Zu3jQ3/RzbhjBBhE4yQDq12afMmO5n1httZii0PqcFsBjAW7s0ILaXVHMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731436380; c=relaxed/simple;
	bh=kAKrmxHzaZK5HUmOM2dUG4sHB4zf20+tgEXvW32Ecto=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=n007Dse+ygwHljpo9HxEMN0LuRFn8gAaHSDcZ5fCJBlaW3myiCsicweZqYugQeUKmjT98KkVNIVRTKsDLSRGObzMcRHnZw5rq8uBrQpKjHHs2jGOOwOVUnmUrM6Ts3Q4YEG20aBieZFyZulWsE0z3rP84dwbakWscqaahCTqjn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=fcaL4P/h; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="fcaL4P/h"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Xnw5Q51x1z6ClbFS;
	Tue, 12 Nov 2024 18:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:content-language:references:from:from:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1731436375; x=1734028376; bh=kAKrmxHzaZK5HUmOM2dUG4sH
	B4zf20+tgEXvW32Ecto=; b=fcaL4P/hbqtsBFDMVLKwFrJq1nUkV64hS5DO9CD+
	eW8onjfwrB2jmUqiEUiwMRQSPJpkdI8X3oMBOF17l4oLOXHtlCm65d0VGAqRE7BC
	yjIw/TDi4uXnf8ZpNzLiEZZr15V1vboGZYSeUS1KHtUWJD0AUN0CY9EOhghafn5Z
	pn2c15dmkCnzwKWcPWZqN99WY7Ph1lw6Noc9VCtUJs7sMwdbpzWBP3jHpXWjAY3m
	+pVB79W6Pywu/MnHcwgyGjgJwXQ9hE+pQoGskuGGU0A4HSMZ9dydE8DDY8HAeXIX
	e6F5dzjHj3hW+WVIcUFlVq3onaoPulMSv6GIjKAvnqJLMQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id bznZJufjbDeT; Tue, 12 Nov 2024 18:32:55 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Xnw5L0rjHz6CmQwT;
	Tue, 12 Nov 2024 18:32:53 +0000 (UTC)
Message-ID: <733165d4-1f25-46ff-a629-6e6afe065110@acm.org>
Date: Tue, 12 Nov 2024 10:32:51 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] block: remove the write_hint field from struct
 request
From: Bart Van Assche <bvanassche@acm.org>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20241112170050.1612998-1-hch@lst.de>
 <20241112170050.1612998-2-hch@lst.de>
 <aa3b1983-d166-451f-899f-74d6f75687ed@acm.org>
Content-Language: en-US
In-Reply-To: <aa3b1983-d166-451f-899f-74d6f75687ed@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 11/12/24 10:29 AM, Bart Van Assche wrote:
> On 11/12/24 9:00 AM, Christoph Hellwig wrote:
>> -=C2=A0=C2=A0=C2=A0 /* Don't merge requests with different write hints=
. */
>> -=C2=A0=C2=A0=C2=A0 if (req->write_hint !=3D next->write_hint)
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return NULL;
>> +=C2=A0=C2=A0=C2=A0 if (req->bio && next->bio) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Don't merge requests wi=
th different write hints. */
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (req->bio->bi_write_hin=
t !=3D next->bio->bi_write_hint)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
turn NULL;
>> +=C2=A0=C2=A0=C2=A0 }
>=20
> The above two if-statements can be combined into a single if-statement.
>=20
>> @@ -1001,9 +1003,11 @@ bool blk_rq_merge_ok(struct request *rq, struct=
=20
>> bio *bio)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!bio_crypt_rq_ctx_compatible(rq, bi=
o))
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return false;
>> -=C2=A0=C2=A0=C2=A0 /* Don't merge requests with different write hints=
. */
>> -=C2=A0=C2=A0=C2=A0 if (rq->write_hint !=3D bio->bi_write_hint)
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return false;
>> +=C2=A0=C2=A0=C2=A0 if (rq->bio) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Don't merge requests wi=
th different write hints. */
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (rq->bio->bi_write_hint=
 !=3D bio->bi_write_hint)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 re=
turn false;
>> +=C2=A0=C2=A0=C2=A0 }
>=20
> Same comment here: the above two if-statements can also be combined int=
o=20
> a single if-statement.
>=20
> Otherwise this patch looks good to me.

(replying to my own email)

Since apparently the goal is to minimize diffs in the next patch,

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
