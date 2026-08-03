Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D285E6BB5B
	for <linux-scsi@vger.kernel.org>; Mon,  3 Aug 2026 17:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785777094; cv=none; b=nUylP6URB/hO/1Tu6e+/ZCWmujdZl1mKGA3bam2SWA5QSkGRNd4N8FIKSa1nbBmNIwOZfqaR/LyulXT6K0Ry08lJPOqjl4nAiVFCZOBIke+G+CGWYNT6QtB59pL9EibQjFwfMb1zcRrKVuaijiiLn0AWFWeU1A+Pg/4HvjoSgpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785777094; c=relaxed/simple;
	bh=7aHX2CiYE+Qub4v7iv+SjfTPS+yF2Kq1TCW802xorfQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qoeOqtrXfrOByQ02gHwQzJ9LVpJztuejp/mfgowbHVL8+e3YtgFYpLYxr8PRqvLJZynSeQxURGto1H23sl8DAJFi4fyKP7zdcdAmAsCY9elfeEisZXcm/0C/FDJTtsTRx4kEUa1UttX8AC5p5bHV/yAM8ZAKyKJ+4NufHA4FHxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=YEBnFVFY; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="YEBnFVFY"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hDNW82HC4z1XM5kY;
	Mon,  3 Aug 2026 17:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1785777083; x=1788369084; bh=34aTnhOe02Wog1buMviQoCLF
	qBEHuQ4K1H2UeMFbl+0=; b=YEBnFVFYGPqU4n//UZQiQx69FLegILgCk+jm8Uqk
	qvTniqtxmNjnJMF/mgL48Zd18QxODVp2W/v3hzrBPEIePNyPGqTO6hPbpLITupB3
	0AAnAiKr7sw6TcB036IKcjxicURk1NNhdSeET/03uwMs95E2FiyCZGS098tMwRzb
	GDmPhwR19lrRQER/C9UYxKRGli9iW35GRBAZiaBKnSosNQystinFMLHWPdrHK5xj
	b4TYiWOQ1X1ZQcMNkLJQ17HZq301s8pXv3khROLnkDB/5iF15DVsMAxOUdw6csrq
	N0rlcoFF7miCfs2DKSWvrFNmA/8ou2TX6UOMlO+LFeOyuQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id wYrEZKFIWD5U; Mon,  3 Aug 2026 17:11:23 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hDNVt5stqz1XM4Sx;
	Mon,  3 Aug 2026 17:11:18 +0000 (UTC)
Message-ID: <a1de6868-f0b0-460c-ab0d-ee759e7886e8@acm.org>
Date: Mon, 3 Aug 2026 10:11:17 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/6] scsi: core: Protect host state changes with the
 host lock
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>, linux-scsi@vger.kernel.org,
 Jianzhou Zhao <luckd0g@163.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>,
 Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
 Chandrakanth patil <chandrakanth.patil@broadcom.com>,
 Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
 Ranjan Kumar <ranjan.kumar@broadcom.com>, Nilesh Javali
 <njavali@marvell.com>, Manish Rangankar <mrangankar@marvell.com>,
 GR-QLogic-Storage-Upstream@marvell.com
References: <68f3346cab2be570839350831f82b6c9233832ed.1785534721.git.bvanassche@acm.org>
 <970cc36fb627fae64b4957954483c74cf8e59c87.1785534721.git.bvanassche@acm.org>
 <7ea61c74-ed48-44cf-bfab-3f3a49b3d455@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <7ea61c74-ed48-44cf-bfab-3f3a49b3d455@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 8/3/26 10:01 AM, John Garry wrote:
> On 31/07/2026 22:52, Bart Van Assche wrote:
>> @@ -411,8 +413,8 @@ struct Scsi_Host *scsi_host_alloc(const struct=20
>> scsi_host_template *sht, int priv
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return NULL;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 shost->host_lock =3D &shost->default_lo=
ck;
>> -=C2=A0=C2=A0=C2=A0 spin_lock_init(shost->host_lock);
>> -=C2=A0=C2=A0=C2=A0 shost->shost_state =3D SHOST_CREATED;
>> +=C2=A0=C2=A0=C2=A0 scoped_guard(spinlock_init, shost->host_lock)
>=20
> Please forgive my ignorance, but what does spinlock_init do here in=20
> relation to setting shost->shost_state?
>=20
> Elsewhere we have scoped_guard(spinlock_irq, shost->host_lock) for=20
> protecting setting shost->shost_state and this makes sense to me.=20
> However I am curious what scoped_guard(spinlock_init, ...) does.

Support for scoped_guard(*_init, ...) and guard(*_init)(...) was
introduced in January of this year. My understanding of commit
d084a73714f8 ("compiler-context-analysis: Introduce scoped init guards")
is as follows:
* The referenced synchronization object is initialized. In this case
   that means calling spinlock_init(shost->host_lock).
* Compiler warnings triggered by __guarded_by() are suppressed for the
   referenced synchronization object. In this case, the compiler is told
   not to assume that shost->host_lock is acquired at the start of the
   guarded code block and released at the end of the guarded code block.

Marco, please correct me if I got this wrong.

Thanks,

Bart.

