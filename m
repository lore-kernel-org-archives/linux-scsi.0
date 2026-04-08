Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8252C3D8916
	for <linux-scsi@vger.kernel.org>; Wed,  8 Apr 2026 18:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671569; cv=none; b=ItYAO/X85yjhYwaalaryjqfPmUpkjUViN6j5x4c8Hyu/rSbxlGqWaPds601PGFmEQbvG+e/Fg7mzzzlLTFWxWtid5Ny8LRzq8tHaUf4LfX7rcHiQzugGKYDSEhtfNs+KskDIh7h8F3tvzW3gjjXTKux5vLYFPb9iELeB5AYbKQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671569; c=relaxed/simple;
	bh=RXQNw5Y8OwY4npADqwxMqxkPkSXSX91b0ZjH4yw4r/U=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AF3/8nS/4JqdQzeHQYII9fH4FvG3kUQWe5k0RCtTNq5TWohhN0E1dcLXwWxgcBQqZYMsr8Vx8KZ4M+up02aBHxtZZm67da57Ak0igRAVChy/apWOD2AAfdSR83C0UIrYXYQb6bG569PjXfU3x5qIfazLPvgR8u/ADsKFLB7qBEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ervxnadA; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Qx/t7Qg3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ervxnadA";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qx/t7Qg3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775671566;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Yp3qpXCVrq/PH/jAwKXNkKIDqgP+CrVei//cW2ICbL8=;
	b=ervxnadAvNwi5cuboLZfnaFTkKKdB4yid2W9qILpDBko9qmqb7sQvKFhx/Lt1accdTSwkx
	E8wrVcRTaMx2mZJAn19lg7oC9PlvJCgk/D2z23sfKADrxtWa+iQfhVVeqDZPVE4k2SXZFQ
	VGs3puigQQ0DYdT/BGmHFIJftsa8HGY=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-659-ekYhb38pPTqCo0fIHirpVA-1; Wed, 08 Apr 2026 14:06:04 -0400
X-MC-Unique: ekYhb38pPTqCo0fIHirpVA-1
X-Mimecast-MFC-AGG-ID: ekYhb38pPTqCo0fIHirpVA_1775671564
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-50d8ed08aa4so2303881cf.3
        for <linux-scsi@vger.kernel.org>; Wed, 08 Apr 2026 11:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1775671564; x=1776276364; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Yp3qpXCVrq/PH/jAwKXNkKIDqgP+CrVei//cW2ICbL8=;
        b=Qx/t7Qg3OV6Ckar8WrYZH5mB9EXHV/B631/Gxng14w30FRCt4ofGmW4LuUIEvqu1dG
         Sxrlb82GUPFlUs/uEBJxb8oX8va1X/HrkSa9r9x9/zvS4LNYLdBRvd8UKf9xsVILt6EM
         0ijVHYLVFKkXM9tbMRclrnGLQRp6stopF1+aMh9KCVltF0Kv8KPRRBpqb8Vp41YKdrzJ
         ijTdlSNm68sEBPI7X7Y33CzskjZKejJV7dv2j4eDq/QQltO5RTgbzOP22pI1Vayhuzsg
         Yi457Z6zdH+qMP01jsxgrWnickr9yIT+0iFe3X94D4Xoa6cU+Hzm16gxPOoPqC4y4j5V
         Q82Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775671564; x=1776276364;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Yp3qpXCVrq/PH/jAwKXNkKIDqgP+CrVei//cW2ICbL8=;
        b=ARmNfmo77XsmkEceqg6Qq7CYuPVjWZzLBf9UCqaZKWHH88BJk0VAINwOh5iHfubBIf
         3Y/qrA6Ql8nvtF3BLpIcZNFrQSLUdP1DTHT1AeohXk0n7xpW50BUQN3pED9P7aT+C6V+
         xOyGXZiV4TYcVkwIBvp9vZhtw1nI2PYV3IPOQCLP/2gFZMgQI3JM5g7iX+2enpKgcc3A
         QVp6FmCXI8gdW2eOZ+xwQnUtk207yRbh7yEZzC562sM2D/GcmOkXUGqwCwC3EnBrKSap
         RE3QklE+ZmeCzW/yHGW5b/vFUPhPSwv7r2zjMR/rBppF+ttG/MClbny2F/BYw+093w7p
         3AmQ==
X-Forwarded-Encrypted: i=1; AJvYcCXF9Z92yJdrGpu5NVnt0YnJJKWe4aqBTG+S+RpOKY/2smgZTXeralo5qV5i+9kiJ6D6btGst/J5mT/G@vger.kernel.org
X-Gm-Message-State: AOJu0Ywyp6DwiFXy23iDdMMM0ZJtBdatv9bMkRYr741y7/ips2NVuSFu
	iGCvYC3Xx1dE9m+h3+jEyVuibPAdRv9BVkjlG0wTEpLk4nvddyW05MJxB4hTSo3oVs890y/wF9F
	/wMxYSg0sVLQNNg8nCl26x3wE4rGGo5m+14GDFGirh5KpK7LFbp7TGqbnsfOtnPw=
X-Gm-Gg: AeBDiesXgzS9NzPRQPHcJRb7Ruv4u2I8ys1cYqdC6ro1K1MFTNj790NbG6sfdAAMzAC
	XuXwB/UgIs3+QYKkfu/PSP4iC46B6Djo2alljmAbWlHcfW3QSeuoWrBQe3CSSxN9Cv7g4T1bi4l
	+UEymE5mmsy0vi7UB0boLfQz9iWNVEWwKZUhAINqyWxfNuKQTJXGrHYTVvgpFZwEGed6ZVchxCE
	5gvz3MsJk2wJmsSm8uJLensNfWK/uRl0kycYQpxOdEONND144XNgnzN9MWu2kC3mxaEqWDRqd8K
	d+U/QWgfwrrZ5KLo3IT+DUi6lzaFYvdUSizroFeTuEKYAnt0ZQuH+1OW8phl1mgBwlqxaoBZHDH
	eZv+JyAtiEGwsz2L/y7Tpq0Q7iKfzFbD7cDvnSfyUO1kXnUe4o4NITrBmhLw=
X-Received: by 2002:a05:622a:203:b0:509:1ffc:c538 with SMTP id d75a77b69052e-50dc219b2d4mr6056811cf.19.1775671563631;
        Wed, 08 Apr 2026 11:06:03 -0700 (PDT)
X-Received: by 2002:a05:622a:203:b0:509:1ffc:c538 with SMTP id d75a77b69052e-50dc219b2d4mr6055861cf.19.1775671562963;
        Wed, 08 Apr 2026 11:06:02 -0700 (PDT)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c64:4e7f:603b:aa2b:ddff:fe88:da74])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50d4b93dd10sm166685151cf.7.2026.04.08.11.06.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2026 11:06:00 -0700 (PDT)
Message-ID: <238f847ffecf093f0476bc04fbd19d626c574d85.camel@redhat.com>
Subject: Re: [EXTERNAL] [PATCH] scsi: storvsc: Handle PERSISTENT_RESERVE_IN
 truncation for Hyper-V vFC
From: Laurence Oberman <loberman@redhat.com>
To: Long Li <longli@microsoft.com>, Li Tian <litian@redhat.com>, 
 "linux-scsi@vger.kernel.org"
	 <linux-scsi@vger.kernel.org>
Cc: KY Srinivasan <kys@microsoft.com>, Haiyang Zhang
 <haiyangz@microsoft.com>,  Wei Liu <wei.liu@kernel.org>, Dexuan Cui
 <DECUI@microsoft.com>, "James E.J. Bottomley"	
 <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"	
 <martin.petersen@oracle.com>, "linux-hyperv@vger.kernel.org"	
 <linux-hyperv@vger.kernel.org>, "linux-kernel@vger.kernel.org"	
 <linux-kernel@vger.kernel.org>
Date: Wed, 08 Apr 2026 14:06:00 -0400
In-Reply-To: <SA1PR21MB6683ABEAC8B490387658B7C7CE5AA@SA1PR21MB6683.namprd21.prod.outlook.com>
References: <20260406015344.12566-1-litian@redhat.com>
	 <SA1PR21MB6683ABEAC8B490387658B7C7CE5AA@SA1PR21MB6683.namprd21.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2026-04-07 at 22:30 +0000, Long Li wrote:
>=20
>=20
> > -----Original Message-----
> > From: Li Tian <litian@redhat.com>
> > Sent: Sunday, April 5, 2026 6:54 PM
> > To: linux-scsi@vger.kernel.org
> > Cc: Li Tian <litian@redhat.com>; KY Srinivasan <kys@microsoft.com>;
> > Haiyang
> > Zhang <haiyangz@microsoft.com>; Wei Liu <wei.liu@kernel.org>;
> > Dexuan Cui
> > <DECUI@microsoft.com>; Long Li <longli@microsoft.com>; James E.J.
> > Bottomley
> > <James.Bottomley@HansenPartnership.com>; Martin K. Petersen
> > <martin.petersen@oracle.com>; linux-hyperv@vger.kernel.org; linux-
> > kernel@vger.kernel.org
> > Subject: [EXTERNAL] [PATCH] scsi: storvsc: Handle
> > PERSISTENT_RESERVE_IN
> > truncation for Hyper-V vFC
> >=20
> > The storvsc driver has become stricter in handling SRB status codes
> > returned by
> > the Hyper-V host. When using Virtual Fibre Channel (vFC)
> > passthrough, the host
> > may return SRB_STATUS_DATA_OVERRUN for PERSISTENT_RESERVE_IN
> > commands if the allocation length in the CDB does not match the
> > host's expected
> > response size.
> >=20
> > Currently, this status is treated as a fatal error, propagating
> > Host_status=3D0x07 [DID_ERROR] to the SCSI mid-layer. This causes
> > userspace
> > storage utilities (such as sg_persist) to fail with transport
> > errors, even when the
> > host has actually returned the requested reservation data in the
> > buffer.
> >=20
> > Refactor the existing command-specific workarounds into a new
> > helper function,
> > storvsc_host_mishandles_cmd(), and add PERSISTENT_RESERVE_IN to the
> > list of
> > commands where SRB status errors should be suppressed for vFC
> > devices. This
> > ensures that the SCSI mid-layer processes the returned data buffer
> > instead of
> > terminating the command.
> >=20
> > Signed-off-by: Li Tian <litian@redhat.com>
>=20
> Reviewed-by: Long Li <longli@microsoft.com>
>=20
>=20
> > ---
> > =C2=A0drivers/scsi/storvsc_drv.c | 32 +++++++++++++++++++++-----------
> > =C2=A01 file changed, 21 insertions(+), 11 deletions(-)
> >=20
> > diff --git a/drivers/scsi/storvsc_drv.c
> > b/drivers/scsi/storvsc_drv.c index
> > ae1abab97835..6977ca8a0658 100644
> > --- a/drivers/scsi/storvsc_drv.c
> > +++ b/drivers/scsi/storvsc_drv.c
> > @@ -1131,6 +1131,26 @@ static void
> > storvsc_command_completion(struct
> > storvsc_cmd_request *cmd_request,
> > =C2=A0		kfree(payload);
> > =C2=A0}
> >=20
> > +/*
> > + * The current SCSI handling on the host side does not correctly
> > handle:
> > + * INQUIRY with page code 0x80, MODE_SENSE / MODE_SENSE_10 with
> > cmd[2]
> > +=3D=3D 0x1c,
> > + * and (for FC) MAINTENANCE_IN / PERSISTENT_RESERVE_IN
> > passthrough.
> > + */
> > +static bool storvsc_host_mishandles_cmd(u8 opcode, struct
> > hv_device
> > +*device) {
> > +	switch (opcode) {
> > +	case INQUIRY:
> > +	case MODE_SENSE:
> > +	case MODE_SENSE_10:
> > +		return true;
> > +	case MAINTENANCE_IN:
> > +	case PERSISTENT_RESERVE_IN:
> > +		return hv_dev_is_fc(device);
> > +	default:
> > +		return false;
> > +	}
> > +}
> > +
> > =C2=A0static void storvsc_on_io_completion(struct storvsc_device
> > *stor_device,
> > =C2=A0				=C2=A0 struct vstor_packet
> > *vstor_packet,
> > =C2=A0				=C2=A0 struct storvsc_cmd_request
> > *request) @@ -
> > 1141,22 +1161,12 @@ static void storvsc_on_io_completion(struct
> > storvsc_device *stor_device,
> > =C2=A0	stor_pkt =3D &request->vstor_packet;
> >=20
> > =C2=A0	/*
> > -	 * The current SCSI handling on the host side does
> > -	 * not correctly handle:
> > -	 * INQUIRY command with page code parameter set to 0x80
> > -	 * MODE_SENSE and MODE_SENSE_10 command with cmd[2] =3D=3D
> > 0x1c
> > -	 * MAINTENANCE_IN is not supported by HyperV FC
> > passthrough
> > -	 *
> > =C2=A0	 * Setup srb and scsi status so this won't be fatal.
> > =C2=A0	 * We do this so we can distinguish truly fatal failues
> > =C2=A0	 * (srb status =3D=3D 0x4) and off-line the device in that
> > case.
> > =C2=A0	 */
> >=20
> > -	if ((stor_pkt->vm_srb.cdb[0] =3D=3D INQUIRY) ||
> > -	=C2=A0=C2=A0 (stor_pkt->vm_srb.cdb[0] =3D=3D MODE_SENSE) ||
> > -	=C2=A0=C2=A0 (stor_pkt->vm_srb.cdb[0] =3D=3D MODE_SENSE_10) ||
> > -	=C2=A0=C2=A0 (stor_pkt->vm_srb.cdb[0] =3D=3D MAINTENANCE_IN &&
> > -	=C2=A0=C2=A0 hv_dev_is_fc(device))) {
> > +	if (storvsc_host_mishandles_cmd(stor_pkt->vm_srb.cdb[0],
> > device)) {
> > =C2=A0		vstor_packet->vm_srb.scsi_status =3D 0;
> > =C2=A0		vstor_packet->vm_srb.srb_status =3D
> > SRB_STATUS_SUCCESS;
> > =C2=A0	}
> > --
> > 2.53.0
>=20

Looks good, rewrite of how it was done before but will achieve the same
behavior we wanted for the new addition for PR.

Reviewed-by: Laurence Oberman <loberman@redhat.com>

