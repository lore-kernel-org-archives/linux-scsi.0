Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13082380FD7
	for <linux-scsi@vger.kernel.org>; Thu, 10 Sep 2026 03:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789012238; cv=none; b=pkjW36cS6EXUjHnYkSn9byDaqy0XslY552rV3q16A4LUVV+g0BghI/bvKDvM/xiF1qZ0NRrc3vVJfN1eM7ghAo3y+f69ve0yHqfcWzL6WRipCIClrltvETwaJlaogCUMB0tP8WZJN0xixvDwW93u8mFOwmB5l2WKezZYlrrCGrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789012238; c=relaxed/simple;
	bh=TlRKJBE0mE+z/2yokx6TTuOLVB2K2uralfXmad2W38w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ShS30a3wgXAdlwK2mwxc4n9sXYzdLFZrN7SiR3+TyuqKitsiNPYtI8376rT2jOIljah64d7b94UMnMEd8bmAd0yIzZ1ey6E1cOq6GUavkBRCj+KOBEZQap/6V5SdMIJvcMU2L6dggrBhE10GjozxnoWLeEPsIyPNTBLhSHDKqRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=tXQXC8jk; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="tXQXC8jk"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hgNxS3T4tzlfvqP;
	Thu, 10 Sep 2026 03:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1789012232; x=1791604233; bh=TlRKJBE0mE+z/2yokx6TTuOL
	VB2K2uralfXmad2W38w=; b=tXQXC8jkEYRtKG2qrGa+oMRxF1zvwurc5eVQqCLG
	g70fagX8xqqLg7/2ve0F2ayK+hsgGXVDP43koee2RV5HQdGAW259sGZA67OeIBmX
	h1ICrOf9nDj2iHFjOcaenSFxr6tVMJrY+INPnfXh5qS1vfGAXYy8IOl3vPDuE60h
	l2HlDUNyTdCiV1qnnNPftJ7XcDR5a6r0/zQJoTFsnMuDo0dNvfFw9xVqLCtXsUrS
	cSbgjwGhHRa9NzvZBsKctqZGY5RMRa2/IQGGNbEVu5JBhxEQYAr4TcKnFCsFUQNU
	vBAwOgYyTPMgXURCTirkAsaSxaGDgXau2GMph7AqxkyBuw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id MEoNJ-vZACL4; Thu, 10 Sep 2026 03:50:32 +0000 (UTC)
Received: from [192.168.51.14] (c-24-6-239-25.hsd1.ca.comcast.net [24.6.239.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hgNxL35XszlfvpW;
	Thu, 10 Sep 2026 03:50:28 +0000 (UTC)
Message-ID: <f43d9c65-20dc-4b5b-bc63-e48b48782446@acm.org>
Date: Wed, 9 Sep 2026 20:50:27 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] scsi: core: Eliminate
 scsi_log_{reserve,release}_buffer()
To: Hannes Reinecke <hare@suse.de>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
References: <cover.1788198780.git.bvanassche@acm.org>
 <c575754856db35fe70aa7a09f1c75b7efdf118fd.1788198780.git.bvanassche@acm.org>
 <f53edf7b-fc80-4815-a884-f03a25ab0527@suse.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <f53edf7b-fc80-4815-a884-f03a25ab0527@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable


On 9/7/26 7:44 AM, Hannes Reinecke wrote:
> On 8/31/26 7:58 PM, Bart Van Assche wrote:
>> -static size_t sdev_format_header(char *logbuf, size_t logbuf_len,
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 const char *name, int tag)
>> +static void __printf(5, 0)
>> +sdev_tag_prefix_vprintk(const char *level, const struct scsi_device=20
>> *sdev,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 co=
nst char *name, int tag, const char *fmt,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 va=
_list *args)
>> =C2=A0 {
>> -=C2=A0=C2=A0=C2=A0 size_t off =3D 0;
>> +=C2=A0=C2=A0=C2=A0 const struct device *dev;
>> +=C2=A0=C2=A0=C2=A0 struct va_format vaf =3D {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .fmt =3D fmt,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .va =3D args,
>> +=C2=A0=C2=A0=C2=A0 };
>> -=C2=A0=C2=A0=C2=A0 if (name)
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 off +=3D scnprintf(logbuf =
+ off, logbuf_len - off,
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 "[%s] ", name);
>> +=C2=A0=C2=A0=C2=A0 if (!sdev)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return;
>> -=C2=A0=C2=A0=C2=A0 if (WARN_ON(off >=3D logbuf_len))
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return off;
>> +=C2=A0=C2=A0=C2=A0 dev =3D &sdev->sdev_gendev;
>> +=C2=A0=C2=A0=C2=A0 if (name) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (tag >=3D 0)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 de=
v_printk(level, dev, "[%s] tag#%d %pV", name, tag,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &vaf);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 else
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 de=
v_printk(level, dev, "[%s] %pV", name, &vaf);
>> +=C2=A0=C2=A0=C2=A0 } else {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (tag >=3D 0)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 de=
v_printk(level, dev, "tag#%d %pV", tag, &vaf);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 else
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 de=
v_printk(level, dev, "%pV", &vaf);
>> +=C2=A0=C2=A0=C2=A0 }
>> +}
> But that would completely revert the idea of this patch; 'dev_printk'=20
> will always insert a newline after the string argument, and the whole=20
> point of this patch was that do _not_ want to have a newline here as we
> want to print out several things before terminating the log message.

No direct nor any indirect callers of this function use KERN_CONT, isn't
it? Please let me know if I overlooked something.

Bart.
