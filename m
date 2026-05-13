Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87EA342144
	for <linux-scsi@vger.kernel.org>; Wed, 13 May 2026 17:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778694587; cv=none; b=rMqVdkk/E9czFzX176r5lSUpWhIKuUrl9y5PbSyiZ7KSuEEmI8s540ozTDfxTsUR7riuhxKNwRSn+UVLCDDwO7UnCYROfaOjk9zoWySwln0UUkcYcEyXJK6MWwXjlTJKFs1/LgE/wD6Jqgmlk1jSsh68A8JOw8u5O5MERcQwiS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778694587; c=relaxed/simple;
	bh=zK+UVbu4JGt/J8NZ8OaXyaJRmmVI5d6dH/UzN/4Huk4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IxGNaPeolRZUROzVwSDZnJZ2Zfg84r6qW64gqtWCyGpz7bv1y6/bjXPRZpGYYUaJsQaHv5W5eA+gk57jx7Qnruby89OtqrthcLmBWrfe35r/93T0Gdrso0tYfcwX3MeaUZzsMqSvAsmp0Yb6GTZRTJiewNmZvhc4zPJlFUPIpyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=CNmmXxML; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="CNmmXxML"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4gG1F61z5LzlgqsP;
	Wed, 13 May 2026 17:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1778694582; x=1781286583; bh=h0oHH9rc0D7vb5A8Ea4IeMLz
	6HQR3+qCRPCSn2Lufw4=; b=CNmmXxMLCFSlJs5sQ+VNVPS/5D66R+cZgAIY5+ng
	lHhXBqTJo5QNpN5WYbYIdwArqGsftmPdqoZs4vq26KdW7fPBknJ5AVVU7M8nmMOk
	hbuSlt9NYuI69Qqb/1SKw/A2JQNw7RN98IP+RPT+14heuqNGazPxjRNXkBf+0ulS
	9HpTF96rF9ZK20ZLXbpAV0HvthCrp+hpjzaeVENnudy7ienjgX+FXPEbWCBgczR+
	j+C4v2x1ULZh0tJuRznh5ATFsfIQvbJ35WpRjZ2NhJJz60c0nNG6xtq2Btwyjnfb
	Dy+vKrB8hO8/tfkEenRebft4S+lb43eOz89oqQJSli/sCw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 9yfjGFAhTMvL; Wed, 13 May 2026 17:49:42 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4gG1F06tj0zlfwHM;
	Wed, 13 May 2026 17:49:40 +0000 (UTC)
Message-ID: <8b3090fc-0342-4c29-9345-da29ed651fab@acm.org>
Date: Wed, 13 May 2026 10:49:40 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: core: Convert inquiry information
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Brian Bunker <brian@purestorage.com>,
 Damien Le Moal <dlemoal@kernel.org>, Hannes Reinecke <hare@suse.de>,
 Guenter Roeck <linux@roeck-us.net>
References: <20260512194634.58145-1-bvanassche@acm.org>
 <20260512194634.58145-3-bvanassche@acm.org>
 <b9b20ed6506ccd0d525abbd9da1f54c65ba76a8f.camel@HansenPartnership.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <b9b20ed6506ccd0d525abbd9da1f54c65ba76a8f.camel@HansenPartnership.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 5/13/26 5:49 AM, James Bottomley wrote:
> On Tue, 2026-05-12 at 12:46 -0700, Bart Van Assche wrote:
>> @@ -905,9 +905,9 @@ static int scsi_add_lun(struct scsi_device *sdev,
>> unsigned char *inq_result,
>>  =C2=A0	if (sdev->inquiry =3D=3D NULL)
>>  =C2=A0		return SCSI_SCAN_NO_RESPONSE;
>>  =20
>> -	sdev->vendor =3D (char *) (sdev->inquiry + 8);
>> -	sdev->model =3D (char *) (sdev->inquiry + 16);
>> -	sdev->rev =3D (char *) (sdev->inquiry + 32);
>> +	strscpy(sdev->vendor, sdev->inquiry + 8);
>> +	strscpy(sdev->model, sdev->inquiry + 16);
>> +	strscpy(sdev->rev, sdev->inquiry + 32);
>>  =20
>>  =C2=A0	sdev->is_ata =3D strncmp(sdev->vendor, "ATA=C2=A0=C2=A0=C2=A0=C2=
=A0 ", 8) =3D=3D 0;
>>  =C2=A0	if (sdev->is_ata) {
>=20
> If you've gone to all the trouble to lift the lengths out as #defines,
> shouldn't we do the same with the offsets?

Hi James,

I will introduce symbolic names for the offsets in the next version of
this patch series.

Thanks,

Bart.
