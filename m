Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D939139CEC
	for <linux-scsi@vger.kernel.org>; Tue,  8 Oct 2024 11:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728385338; cv=none; b=LBM3SOBLY+ylyuIn3GkLf6zEnw1TBL7hq6SFHdCpmA1HCsqZi4KzKTWC0HWlwcxpeMjXqcqpsZTfJf7FVoXluCCdJrlsCaTvcQ6TFifd/ZSVunTpLxNuH6oSdESTo7mR2kiXUEbgmV19KwIEGPQURWDH3MTyyVjzNV2og57BFl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728385338; c=relaxed/simple;
	bh=9MxQ225oguJtsavv+etB/Z6eXIUd0XesGeecYxJ8FbI=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=WbCzjlkzAuYLhx2gu8cuKwAZdDh0M77Gguty/dkuEWbG9DeNZXfXyGgFjbMYUmreEs6gJ4VmLsCShGofZndnbM+1PB+hF2HQY4BD35+BJJynXgQXMiVc0deJtUOG8E2lx6BjNubudengny39RKtYNAnKSGjd4izrNbtbxjZJ90w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FeR81S44; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FeR81S44"
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728385334;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2yF7irZ6YJEKS7gOO+JHbJiJfvjGEpJhpY5c39nJXI8=;
	b=FeR81S4402La3HRpJyZgmMzp+AnjpCUpoLmeKlOxBX1ps5Hi6fnJxZxbWK+3KKDho8m0aH
	h3Lurjm88idrTt/YRj4w8F0q3/406ZJKmzbMK/J0w7FC6QFIwgyr9VvuHQZXyFZJojY29D
	Sl95MQxWb53XcVqyqGsFX4NrCaUA6OY=
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Re: [PATCH v2] scsi: fnic: Use vzalloc() instead of vmalloc() and
 memset(0)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
In-Reply-To: <596a6bd4-88b3-4836-94ec-b2930c9b0062@wdc.com>
Date: Tue, 8 Oct 2024 13:02:01 +0200
Cc: Satish Kharat <satishkh@cisco.com>,
 Sesidhar Baddela <sebaddel@cisco.com>,
 Karan Tilak Kumar <kartilak@cisco.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <2D16B4A0-DC8F-4448-93B1-508FD9F92774@linux.dev>
References: <20241008095152.1831-2-thorsten.blum@linux.dev>
 <596a6bd4-88b3-4836-94ec-b2930c9b0062@wdc.com>
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
X-Migadu-Flow: FLOW_OUT

On 8. Oct 2024, at 12:25, Johannes Thumshirn wrote:
> On 08.10.24 11:53, Thorsten Blum wrote:
>> Use vzalloc() instead of vmalloc() followed by memset(0) to simplify =
the
>> functions fnic_trace_buf_init() and fnic_fc_trace_init().
>>=20
>> Remove unnecessary unsigned long cast.
>>=20
>> Compile-tested only.
>>=20
>> Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
>> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
>> ---
>> Changes in v2:
>> - Remove unsigned long cast as suggested by Johannes Thumshirn
>> - Link to v1: =
https://lore.kernel.org/linux-kernel/20241007115840.2239-6-thorsten.blum@l=
inux.dev/
>> ---
>>  drivers/scsi/fnic/fnic_trace.c | 14 +++-----------
>>  1 file changed, 3 insertions(+), 11 deletions(-)
>>=20
>> diff --git a/drivers/scsi/fnic/fnic_trace.c =
b/drivers/scsi/fnic/fnic_trace.c
>> index aaa4ea02fb7c..c2413e0e4eaa 100644
>> --- a/drivers/scsi/fnic/fnic_trace.c
>> +++ b/drivers/scsi/fnic/fnic_trace.c
>> @@ -485,7 +485,7 @@ int fnic_trace_buf_init(void)
>>   }
>>=20
>>   fnic_trace_entries.page_offset =3D
>> - vmalloc(array_size(fnic_max_trace_entries,
>> + vzalloc(array_size(fnic_max_trace_entries,
>>     sizeof(unsigned long)));
>=20
> Sorry for not having spotted it earlier, but all those=20
> vzalloc(array_size(foo, bar)); calls can be turned into vcalloc(foo, =
bar);

No worries, but removing the unsigned long casts actually doesn't work:

drivers/scsi/fnic/fnic_trace.c:559:27: error: incompatible pointer to =
integer conversion assigning to 'unsigned long' from 'typeof =
(vzalloc_noprof(size_mul(((1UL) << 12), fnic_fc_trace_max_pages)))' (aka =
'void *') [-Wint-conversion]
  559 |         fnic_fc_ctlr_trace_buf_p =3D
      |                                  ^
  560 |                 vzalloc(array_size(PAGE_SIZE, =
fnic_fc_trace_max_pages));
      |                 =
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1 error generated.

I'll submit a v3.

Thanks,
Thorsten=
