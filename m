Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6ECC374C4
	for <linux-scsi@vger.kernel.org>; Thu,  4 Sep 2025 19:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757015099; cv=none; b=fxQaMKU4xaTBS0rSnVph6INcykMJT1MXJHqe7ZU1FjsN7uuBD4fkx6B2CCEQ04giDM9hix4ubrCWJQaJtwfOTRqW3O9Zh13qH1mhhxrRkd41REPeWTGL+3qwOj2mJ8iZzRiQckQIdpMAbJIngL2kqNo4p7rsETAHjhUmnguNnro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757015099; c=relaxed/simple;
	bh=49TFE0iT64CyAdPn7ffX+feQU4VVPpP0/AtFV3H7zAg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rrgsoKzwXpwJ4yREcSDqNHfSQ9SdmjmVO1i4Is+HyuLVnbEvfgBFaGen4+eSxtzw47JjAzmXqIaM6IIXTnsgJiTwnOP5/hLHlETi9QY21q4+7eQVaGHc4jhwyDtk5ZnLsJtROzSwznaCXyNximXgoFbTJZpz8ySo5S84WsPnOk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=O+D46jex; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="O+D46jex"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cHqgs042Mzm0yTF;
	Thu,  4 Sep 2025 19:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1757015094; x=1759607095; bh=K/SF9TeGxIuagtxv6avc4DZe
	I1f748Rv7SNATi8Xwjg=; b=O+D46jexARCxsq9+t73qrfrbc3XUtkd40x8AOUSF
	QA8bpsLkXRZCQrpF6uGWpimXYfh5pvXeiHFNhOoSE88nWLI2fICaMwEghO9ZwfNH
	8ip7gPe3Vf0oePJ00uootwBixEQWcc5xWMiJj3OuMEQ6WLhhbmK4h/I1ak63qz0Y
	aSzqZvm+2HL+Nmwh+ZvluaFu/VR1IwMgL1pO6PAQ+qWQihsTlBdM7vVp7Ir2eB9o
	meUWzzZga6mLU6xCiQm3MDvLj9LDFNWh5/VfCs4B/BJLzsuvd0DYAnOm/EA2VxWz
	f+p2dfBVSfHQd+ovMHrRd8YQEgLtJRdpDZs7Lbb33dZuow==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id z4qIU52gx4qp; Thu,  4 Sep 2025 19:44:54 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cHqgl1XD5zm0ySJ;
	Thu,  4 Sep 2025 19:44:49 +0000 (UTC)
Message-ID: <521755f9-246c-4bcf-84a4-2541c830cad3@acm.org>
Date: Thu, 4 Sep 2025 12:44:49 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/26] scsi_debug: Set .alloc_pseudo_sdev
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250827000816.2370150-1-bvanassche@acm.org>
 <20250827000816.2370150-7-bvanassche@acm.org>
 <85ebf74e-47d6-4208-9d41-61ac818d2115@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <85ebf74e-47d6-4208-9d41-61ac818d2115@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 9/4/25 3:02 AM, John Garry wrote:
> On 27/08/2025 01:06, Bart Van Assche wrote:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .cmd_size =3D sizeof(struct sdebug_scsi=
_cmd),
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .init_cmd_priv =3D sdebug_init_cmd_priv=
,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 .target_alloc =3D=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 sdebug_target_alloc,
>>
>=20
>=20
> for scsi_debug, maybe we can add reserved command handling as part of=20
> the driver abort handling, e.g. eh_abort_handler -> scsi_debug_abort=20
> should send a reserved command to "abort" a scmd, and the reserved=20
> command handler does the same as scsi_debug_abort currently does.

Another possibility for getting rid of .alloc_pseudo_sdev is to allocate
a pseudo SCSI device if either .nr_reserved_cmds or=20
.queue_reserved_command has been set in the SCSI host template. A dummy
.queue_reserved_command method could be defined as follows in the SCSI
debug driver:

+/*
+ * The only purpose of this function is to make the SCSI core allocate a
+ * pseudo SCSI device.
+ */
+static int scsi_debug_queue_reserved_command(struct Scsi_Host *shost,
+					     struct scsi_cmnd *scp)
+{
+	WARN_ON_ONCE(true);
+	scp->result =3D DID_ERROR << 16;
+	scsi_done(scp);
+	return 0;
+}

Thanks,

Bart.
