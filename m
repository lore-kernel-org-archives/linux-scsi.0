Received: from fgw22-4.mail.saunalahti.fi (fgw22-4.mail.saunalahti.fi [62.142.5.109])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F418B203D4C
	for <linux-scsi@vger.kernel.org>; Mon, 16 Dec 2024 18:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.109
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734372530; cv=none; b=r1v0Ss5eh2BJmoHODMUHoRxUF9HkB5/8P9g2/47XLIFIjb3CVoZaorCfkZgaztiWAchE8AhFan39xpMs9U32IdCY5IJlGli/RP6A5hLghbNYF8wNuQYxa8v2/bAIC8OSMrAaAKBj/7ICahTOwIkaiKdP0IR0tGWKszRPuK9OTKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734372530; c=relaxed/simple;
	bh=ymUQw7TcAcLYagTrl0M58TxhLCi5oUlpFIoqUijHyhQ=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=izCs13/eZXCUtBqN569yrSU/ZPynIuE0MQ/KkeTaKBkUDQkb6+beqE/prFqnDX6o89CD1ztNsYKptVqwUMOBo3kBPHDtjnOif7W7gnnBCyh7HgL8Nk8Ua5hCw8Je/hGIIZhmLVqyaQCGg0q8I7v/9fArvZy58/YSa4tNIxPhxgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=OkiF/ewT; arc=none smtp.client-ip=62.142.5.109
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="OkiF/ewT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=to:references:message-id:content-transfer-encoding:cc:date:in-reply-to:from:
	 subject:mime-version:content-type:from:to:cc:reply-to:subject:date:in-reply-to:
	 references:list-archive:list-subscribe:list-unsubscribe:content-type:
	 content-transfer-encoding:message-id;
	bh=gMaeYAlGvPFkwn95e686zQ2JBQMyimcVkSkxhn8q0eo=;
	b=OkiF/ewTVj9tNEqrKsc2wsUpWOwOSsxC/5rBoeqMHJHsr9AmfA9LCGsXYC26H2dCWHdHZ332WmmKf
	 VZzL1GxurALTlNypenfx2kXJe6sM3cSajCJpHrnLoSaZwbfewyvgS4Geq4KF+7DI2aPqS+ODfB2FYf
	 927emNRHeCnYEKt6WGCMkyuYpIZJLHp1GVeWI5yPO4yQ7HmaBcDfnWRCqPRrCBjLRoxRwIjhx6ob4D
	 LoEf7noSYozPuVcNBNXBOMcr5O24Fc04pPK2aTGbIuo1gmlNBe8GSxyCf2g92N4ajXTLOOVJI5yD1N
	 ab/7YGjnF/7HEX9frmBP7tu2GBypQkA==
Received: from smtpclient.apple (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw20.mail.saunalahti.fi (Halon) with ESMTPSA
	id c864c142-bbd8-11ef-9c2f-005056bd6ce9;
	Mon, 16 Dec 2024 20:08:42 +0200 (EET)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.300.87.4.3\))
Subject: Re: [PATCH] scsi: st: Regression fix: Don't set pos_unknown just
 after device recognition
From: =?utf-8?B?IkthaSBNw6RraXNhcmEgKEtvbHVtYnVzKSI=?= <kai.makisara@kolumbus.fi>
In-Reply-To: <89a972a4-64e3-4fdb-b2ce-994469546bee@acm.org>
Date: Mon, 16 Dec 2024 20:08:31 +0200
Cc: linux-scsi@vger.kernel.org,
 jmeneghi@redhat.com,
 martin.petersen@oracle.com,
 "James.Bottomley@hansenpartnership.com" <James.Bottomley@HansenPartnership.com>,
 loberman@redhat.com,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <AAE245CB-536B-4CF7-98DD-829026A439BA@kolumbus.fi>
References: <20241216113755.30415-1-Kai.Makisara@kolumbus.fi>
 <89a972a4-64e3-4fdb-b2ce-994469546bee@acm.org>
To: Bart Van Assche <bvanassche@acm.org>
X-Mailer: Apple Mail (2.3826.300.87.4.3)

On 16. Dec 2024, at 19.18, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> On 12/16/24 3:37 AM, Kai M=C3=A4kisara wrote:
>> diff --git a/drivers/scsi/st.h b/drivers/scsi/st.h
>> index 7a68eaba7e81..1aaaf5369a40 100644
>> --- a/drivers/scsi/st.h
>> +++ b/drivers/scsi/st.h
>> @@ -170,6 +170,7 @@ struct scsi_tape {
>>   unsigned char rew_at_close;  /* rewind necessary at close */
>>   unsigned char inited;
>>   unsigned char cleaning_req;  /* cleaning requested? */
>> + unsigned char first_tur;     /* first TEST UNIT READY */
>>   int block_size;
>>   int min_block;
>>   int max_block;
>=20
> Why 'unsigned char' instead of 'bool'?

For historical reasons I used the same type as in the other options.
(I happen to have 1.3.30 sources from 1995. The flags in st.h are
unsigned chars there. AFAIK, the type bool was introduces in C99
in 1999.)

> Should perhaps all 'unsigned char' occurrences in struct scsi_tape be
> changed into 'bool'? I'm not aware of any other Linux kernel code that
> uses the type 'unsigned char' for boolean values.

This also came into my mind, but this is a regression fix and I tried
to keep it minimal.

A patch to change the types can be done later.

Thanks,
Kai

