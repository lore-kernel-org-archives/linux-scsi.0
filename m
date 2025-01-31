Received: from fgw20-4.mail.saunalahti.fi (fgw20-4.mail.saunalahti.fi [62.142.5.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38511CA81
	for <linux-scsi@vger.kernel.org>; Fri, 31 Jan 2025 10:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.107
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738320597; cv=none; b=qDfw5lRVyTnB0KZzosWoroIQPlECBimlI6sghxfYP+S5pJtOjoRnnXGp7uUd2hUD/aFMQcDPE4LTfm/8NE9eaIDWLh8zjj/EtpGb1LdGMeyHcEtoBQxbkkX1raBJ8++dfhozFAajKNfgKn6VoKXLn4dQnWV5vsQ69khsaye5BlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738320597; c=relaxed/simple;
	bh=qVhDY/7Am+FurwTxHbXQQpKpPvZi6Hf4vO4oi4LjOD0=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=TW52dfptzurJLJe0d8yekdBszHcr4rsP/kbNpwvyKtK9fkjtcKtEEdRATeqgy32cHwRadFqDDs4JpBn4ZaKVpYperEY9Ex5jCyHzZNoYy8nI3hK06Xq8EHeuBdqJOX18xBV0sfvJ3WaWHCBErbpROIaReHJ7scTUvbBW/qMpbO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=jtWRIPfi; arc=none smtp.client-ip=62.142.5.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="jtWRIPfi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=to:references:message-id:content-transfer-encoding:cc:date:in-reply-to:from:
	 subject:mime-version:content-type:from:to:cc:reply-to:subject:date:in-reply-to:
	 references:list-archive:list-subscribe:list-unsubscribe:content-type:
	 content-transfer-encoding:message-id;
	bh=6IFhTH+3oylG59tbNEAQvvWpGGIePrviZiMXXXhnzAo=;
	b=jtWRIPfiTQ+Ebo30BGFjotWKBqOBJQS8OT8xY/bu2gnk+TU+bxKaYaGAHb68Df+Z0RwmZUHu/G2G1
	 TuIIQ6OfZ6w1eLFZh5PNAZzf9lMF5qP1xcIW6KcpwS4IHladAASZeZo9w2meHPW6pmtDWq7QZe9sNY
	 7ApfuyhkUppMXGmcWyVZcO4HewpxwI6BnTxW494z7Fq+aYo6nNfmwp2aKh3Xn/SqwpFQgv5pvDEyGt
	 5K1tyR1kYs9o7htcL1UEJ5FAu/UjOWgQMjskYpWM0fTplKmxyoH8h30yD35PWCY8KwbDJXIgoEWF86
	 9WE56FghCq9Aa0KfbmQHG51PasiJUDg==
Received: from smtpclient.apple (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw22.mail.saunalahti.fi (Halon) with ESMTPSA
	id 14cb3d8a-dfc1-11ef-8364-005056bdf889;
	Fri, 31 Jan 2025 12:49:44 +0200 (EET)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.400.131.1.6\))
Subject: Re: [PATCH v3 4/4] scsi: st: Add sysfs file reset_blocked
From: =?utf-8?B?IkthaSBNw6RraXNhcmEgKEtvbHVtYnVzKSI=?= <kai.makisara@kolumbus.fi>
In-Reply-To: <84a38d69-7ee7-4faa-82c6-38db2408f823@redhat.com>
Date: Fri, 31 Jan 2025 12:49:34 +0200
Cc: linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com,
 loberman@redhat.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <E86C013A-4C12-43E2-829D-7023F377A6B6@kolumbus.fi>
References: <20250120194925.44432-1-Kai.Makisara@kolumbus.fi>
 <20250120194925.44432-5-Kai.Makisara@kolumbus.fi>
 <84a38d69-7ee7-4faa-82c6-38db2408f823@redhat.com>
To: John Meneghini <jmeneghi@redhat.com>
X-Mailer: Apple Mail (2.3826.400.131.1.6)



> On 30. Jan 2025, at 20.27, John Meneghini <jmeneghi@redhat.com> wrote:
>=20
> One suggestion here.
>=20
> On 1/20/25 2:49 PM, Kai M=C3=A4kisara wrote:
>> If the value read from the file is 1, reads and writes from/to the

...
>> --- a/Documentation/scsi/st.rst
>> +++ b/Documentation/scsi/st.rst
>> @@ -157,6 +157,11 @@ enabled driver and mode options. The value in =
the file is a bit mask where the
>>  bit definitions are the same as those used with MTSETDRVBUFFER in =
setting the
>>  options.
>>  +Each directory contains the entry 'reset_blocked'. If this value is =
one,
>=20
> I suggest calling this 'position_lost' or 'position_unknown' rather =
than 'reset_blocked'.
>=20
>> +reading and writing to the device is blocked after device reset. =
Most
>>  +/**
...
>> + * reset_blocked_show - Value 1 indicates that reads, writes, etc. =
are blocked
>=20
>      position_lost_show

Yes. The function name should be changed when the file name is changed.

>=20
>> + * because a device reset has occurred and no operation positioning =
the tape
>> + * has been issued.
>> + * @dev: struct device
>> + * @attr: attribute structure
>> + * @buf: buffer to return formatted data in
>> + */
>> +static ssize_t reset_blocked_show(struct device *dev,
>> + struct device_attribute *attr, char *buf)
>> +{
>> + struct st_modedef *STm =3D dev_get_drvdata(dev);
>> + struct scsi_tape *STp =3D STm->tape;
>> +
>> + return sprintf(buf, "%d", STp->pos_unknown);
>                                   ^^^^^^^^^^^^^^
>=20
> I'd like the name of this function/sysfs variable to more closely =
match the code
> that drives this state.

I am not too fond of the name "reset_blocked", but I had to choose =
something :-)
This name is based on the phenomenon causing the situation (device =
reset) and
what it causes (blocks many st operations).

I think "reset" should be part of the name. Device reset may mean that =
the tape
position is changed (rewind), but it can also mean more: the device =
settings are
reset to the saved values. Patch 1/4 restores the values set using st, =
but it does
not restore the values set by other means (e.g., encryption). The user =
should
remember to re-set also these before continuing.

Combining the above and your suggestion, what about =
"position_lost_in_reset"
or "pos_lost_in_reset"? (Whatever the name is, the user should check =
what
has really happened. The name should point to the correct direction,
but it should be short enough.)

Thanks!

