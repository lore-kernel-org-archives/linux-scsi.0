Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F0429A9
	for <linux-scsi@vger.kernel.org>; Mon, 11 Mar 2024 17:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710177293; cv=none; b=ZzbWDnuLJvGE466Vkl765Y3F5DwhwPlhEXvCkS3aGl1YaBx0p1Dj+v+Z6KtPlHyIn67fUm7B+cKdpMv5ZJOoDzeJHF9V2Skb2is/idtDW/qaPy5jITay726gPgtCYuZnrxOB9vzQayJUbSVlBb2xaO60VgFDIolgGv774n834tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710177293; c=relaxed/simple;
	bh=mRhQLV1lLNDsg6AtX/v5SmyDho1CMffkpKKQJqDTKTA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZOZAYSDH5+nQcgcW1ExBNUJKp8vMRmLWn2UYUWSo/4dod5HGrTx60Z7VV4mw9F1PHvdKYsT4psQA55vB8F8pnV0WlYeIpvU6xGMmeLKGC+zOplgE3ucIvrPTCbO185JON7esXi/nBKk7OBD2WNCm4igg8Mws3I5LlZdZuTTdWxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=RHtNzR8k; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="RHtNzR8k"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Ttk0j0dw7zlgVnY;
	Mon, 11 Mar 2024 17:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:references:content-language:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1710177282; x=1712769283; bh=mRhQLV1lLNDsg6AtX/v5SmyD
	ho1CMffkpKKQJqDTKTA=; b=RHtNzR8k41dBxi/d1oUaAq1x0/uyAtxExY8pVbmg
	MMhypcpQXPIvuiO6JGApO1ra8DaVzG0NHGep+xtCGTk7o91YoPZW4sqhNW+0jxSQ
	R2hS7V5mBiWgGWjDtFrusWXHLxERBr6/OLuLKHfM9BBDmkNm5WK2WMEzCz+FOJss
	3KudabHWZEPmqtt9BG1YyhSGlJlXaxBL98iAXOdv+h0i+kAJvHCWWXTu0PT2Ohka
	nyxTdtja47TrnzHKdiDq/1kNMP9P2dMZloJMlU4KthdJLWMLufvlbx6gRhDTZBD3
	vsSSDmufJlhIYyLtgYRtUqofI67PALqPrJY0VDgc5dWrzg==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id iXxnbA52TPT9; Mon, 11 Mar 2024 17:14:42 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Ttk0c2y7mzlgVnW;
	Mon, 11 Mar 2024 17:14:39 +0000 (UTC)
Message-ID: <5fd6552e-3127-4388-a45f-c2214a601d00@acm.org>
Date: Mon, 11 Mar 2024 10:14:37 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 03/11] scsi: sd: Translate data lifetime information
Content-Language: en-US
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>,
 Kanchan Joshi <joshi.k@samsung.com>, Christoph Hellwig <hch@lst.de>,
 Damien Le Moal <dlemoal@kernel.org>,
 "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20240222214508.1630719-1-bvanassche@acm.org>
 <20240222214508.1630719-4-bvanassche@acm.org>
 <abef4b9f-a53d-45ba-a97c-ec2ff5885240@oracle.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <abef4b9f-a53d-45ba-a97c-ec2ff5885240@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 3/11/24 03:46, John Garry wrote:
> On 22/02/2024 21:44, Bart Van Assche wrote:
>> +=C2=A0=C2=A0=C2=A0 sdkp->permanent_stream_count =3D desc - start;
>> +=C2=A0=C2=A0=C2=A0 if (sdkp->permanent_stream_count < 2) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sd_printk(KERN_INFO, sdkp,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 "Unexpected: RSCS has been set and the permanent stream=20
>> count is %u\n",
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 sdkp->permanent_stream_count);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return;
>> +=C2=A0=C2=A0=C2=A0 }
>> +
>> +=C2=A0=C2=A0=C2=A0 sd_printk(KERN_INFO, sdkp, "permanent stream count=
 =3D %d\n",
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sdkp->permanen=
t_stream_count);
>=20
> I have been testing a recent linux-next (which includes this change),=20
> and I now see this following kernel log just for writing to the bdev=20
> file, like:
>=20
> # mnt/test-pwritev2 -d -l 512 -p 512 /dev/sda
> wrote 512 bytes at pos 512 write_size=3D512
> # [=C2=A0=C2=A0 22.339526] sd 0:0:0:0: [sda] permanent stream count =3D=
 5
>=20
> Is that log really required, especially at info level?
>=20
> That is a scsi_debug disk - I assume that the relevant io hint feature=20
> is now default enabled there.

Hi John,

How about removing the sd_printk() call mentioned above and adding a
sysfs attribute instead that reports the number of permanent streams?

Thanks,

Bart.

