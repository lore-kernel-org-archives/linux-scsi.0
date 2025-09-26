Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C44307AD5
	for <linux-scsi@vger.kernel.org>; Fri, 26 Sep 2025 20:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758919473; cv=none; b=Rz1ajDjqH9qHuGe+vzU/C9eczXoWoASDTgoaLuCIbDUHluJdlF1WmRg6iIPZYQAk5taNiv5NVJEb6s8rU6uizKRihtxXzpdIU58vBobNcTG7sozblIc8qUw5jsCkt5JavK+C/Xf9IG0EecbgRf7oTaCMTwcu0xCdPmblEzKcn5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758919473; c=relaxed/simple;
	bh=L1vsF/TS6k1q2MLmfNzIW2FdoigZjl50RsjAhlA/TOc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CS8dti2b7JHatV3nx082TS730PKyIL01RH9Dx8j/+C6xz3nOKrRaP2i/47rzQvJyo12LWwKoYwjE/CfdgsjfqQa+rDlnzhiBHLVYPEyA6u2FWMG72GvJT4/Iz7QF7N2MmLOMavzRFQCJbDqs992QtxCL+VtaflHs+wUOGCUO9sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=T4mO3sQd; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="T4mO3sQd"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cYMyQ3FHrzm0yT2;
	Fri, 26 Sep 2025 20:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1758919469; x=1761511470; bh=AZGGStz3qHPT+43gYJw6JtyI
	+iydaG/zPpWMG+X8iS4=; b=T4mO3sQd1O92Dn4X/7djhx47M4bAQ5GiXPT0eujo
	VS/wSCio1U5x4+uxGZpStq3IrHxfPtr/hV7Otwh4UyffFnj6hz7dgZff1MWMsfjT
	z+KzefIm+oG9PCeZnSw8vH1LCxblir4SLCp+pdni31MRtoCVppIouVZb4BLEeT/q
	VQlbgSdIvWTrZSMMyc5wdjEEhmBBz1hDjUmSmAxzlbywVzVjcaK+tzJ2vf4tTlA7
	Bj2J2yJeCsXb5UnQiPBSyg3+u60WPBuR/Bjkg2fdGaHRsMfePwY9SDXryVkiE/pM
	h7Qnsery4UARzzALSonGAktVldq28uWT7SRVROLk69gEgQ==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ZvgpvVZfCWn6; Fri, 26 Sep 2025 20:44:29 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cYMyL5n9Jzm0yQV;
	Fri, 26 Sep 2025 20:44:26 +0000 (UTC)
Message-ID: <550f7c16-036c-409d-9f5e-0fb2a5b3baa9@acm.org>
Date: Fri, 26 Sep 2025 13:44:25 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/28] scsi_debug: Abort SCSI commands via
 .queue_reserved_command()
To: John Garry <john.g.garry@oracle.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20250924203142.4073403-1-bvanassche@acm.org>
 <20250924203142.4073403-8-bvanassche@acm.org>
 <aea7f72a-7d65-4ab6-98c3-34abf112f6e1@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <aea7f72a-7d65-4ab6-98c3-34abf112f6e1@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 9/26/25 12:32 AM, John Garry wrote:
> On 24/09/2025 21:30, Bart Van Assche wrote:
>> Add a .queue_reserved_command() implementation and call it from the co=
de
>> path that aborts SCSI commands. This ensures that the code for
>> allocating a pseudo SCSI device and also the code for processing
>> reserved commands gets triggered while running blktests.
>>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>=20
> At least Suggested-by would be good, if you don't mind

If nobody objects I will add the following text:

----------------------------------------------------------------------
Most of the code in this patch is a modified version of code from John
Garry. See also
https://lore.kernel.org/linux-scsi/75018e17-4dea-4e1b-8c92-7a224a1e13b9@o=
racle.com/

Suggested-by: John Garry <john.g.garry@oracle.com>
----------------------------------------------------------------------

>> =C2=A0 enum sdeb_defer_type {SDEB_DEFER_NONE =3D 0, SDEB_DEFER_HRT =3D=
 1,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 SDEB_DEFER_WQ =3D 2, SDEB_DEFER_POLL =3D 3};
>> @@ -466,6 +483,8 @@ struct sdebug_defer {
>> =C2=A0 struct sdebug_scsi_cmd {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spinlock_t=C2=A0=C2=A0 lock;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct sdebug_defer sd_dp;
>> +
>> +=C2=A0=C2=A0=C2=A0 struct scsi_debug_internal_cmd internal_cmd;
>=20
> you could prob make this a union with sd_dp - I mean, could they ever=20
> both be simultaneously used?

Introducing a union for sd_dp and internal_cmd only would suggest to
readers of the scsi_debug code that 'lock' protects both 'sd_dp' and
'internal_cmd', which is not the case. I propose to include the
following change in this patch:

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 0d4bdd38597a..12b885a2f719 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -483,8 +483,6 @@ struct sdebug_defer {
  struct sdebug_scsi_cmd {
  	spinlock_t   lock;
  	struct sdebug_defer sd_dp;
-
-	struct scsi_debug_internal_cmd internal_cmd;
  };

  static atomic_t sdebug_cmnd_count;   /* number of incoming commands */
@@ -9518,7 +9516,8 @@ static const struct scsi_host_template=20
sdebug_driver_template =3D {
  	.module =3D		THIS_MODULE,
  	.skip_settle_delay =3D	1,
  	.track_queue_depth =3D	1,
-	.cmd_size =3D sizeof(struct sdebug_scsi_cmd),
+	.cmd_size =3D sizeof(union { struct sdebug_scsi_cmd c;
+				   struct scsi_debug_internal_cmd ic; }),
  	.init_cmd_priv =3D sdebug_init_cmd_priv,
  	.target_alloc =3D		sdebug_target_alloc,
  	.target_destroy =3D	sdebug_target_destroy,

>> +static int scsi_debug_setup_abort_cmd(struct scsi_cmnd *cmd,
>=20
> nobody checks the return value

Agreed. I will change the return type from 'int' into 'void'.

>> +=C2=A0=C2=A0=C2=A0 abort_cmd =3D scsi_get_internal_cmd(shost->pseudo_=
sdev, DMA_TO_DEVICE,
>=20
> DMA_NONE?

DMA_TO_DEVICE is converted into REQ_OP_DRV_OUT by=20
scsi_get_internal_cmd(). Isn't that more appropriate for an operation
that has side effects (aborting a SCSI command) rather than
REQ_OP_DRV_IN?

>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BLK_MQ_REQ_RESE=
RVED);
>> +=C2=A0=C2=A0=C2=A0 if (WARN_ON_ONCE(!abort_cmd))
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return false;
>=20
> I don't really think that this deserves a WARN_ON_ONCE

OK, I will remove the WARN_ON_ONCE().

>> +=C2=A0=C2=A0=C2=A0 scp->result =3D (res ? DID_OK : DID_ERROR) << 16;
>=20
> personally I think that if-else is nicer, but that's just me
>=20
> And please consider using set_host_byte()

I will use set_host_byte().

Thanks,

Bart.
