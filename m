Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87AC72FD1AD
	for <linux-scsi@vger.kernel.org>; Wed,  5 Nov 2025 14:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762353807; cv=none; b=iZLiIpobbiKy5/cs2XtoMLAt/jkdiYUAkpC09hPIIPNgL9cy+CjIZmCFHzDjyvRxwE2PCwNCh4idbjbgtSzkqEtbR22OJrKS3abrEWy8Lm0vI5sR4WfIMnXF4PgOsgTmbw61Avz/80EPNBPxB4fuAyRIrdjh2jqOKe65qra1bGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762353807; c=relaxed/simple;
	bh=0hkb7by5IAO3oMKA9ZUfw2arhET5DGsZhlCQtZ3fVFg=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=r+aBJf4GOB9gDmbrCrE13XISNqUgXnE26lmvYLCbdG2CnKYPTOO/7r5iAP8dFjfyBcwwBBTyYKp0ATJzOA2k7o3GB94IJHSTMOn4H6CU6azj75RLtB4E2PDeaftjIVxJek4k9DTUTv1bZ27miDkDMEFGp35EWbosRghlIUOiRcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TNAFAcaa; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=EpNJfk/k; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TNAFAcaa";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="EpNJfk/k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762353804;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x+9/0hcFpRTIdvmUxht46J/fGQuPFy6A+m3zTKBeCjA=;
	b=TNAFAcaaZfBj3QX1gLgTvfLQdqb9xLaQwUt8ehQn2iwGHPIjt9Pbm8CS1HqQ0/LCS7KYxW
	HCsrk9hQ2GpCSmbz5WK14yZ1GEfHli9k3yz+5oLzGyOY9GMCS8pE5nN9N6fFck1rr4Csp4
	XQVCgJp7n8b0V2XhYvCT2JujAG8LGXU=
Received: from mail-yx1-f71.google.com (mail-yx1-f71.google.com
 [74.125.224.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-102-o2uY3NLPOjKae35ffvCGVA-1; Wed, 05 Nov 2025 09:43:23 -0500
X-MC-Unique: o2uY3NLPOjKae35ffvCGVA-1
X-Mimecast-MFC-AGG-ID: o2uY3NLPOjKae35ffvCGVA_1762353803
Received: by mail-yx1-f71.google.com with SMTP id 956f58d0204a3-63dcbe3d18dso9692415d50.3
        for <linux-scsi@vger.kernel.org>; Wed, 05 Nov 2025 06:43:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762353803; x=1762958603; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x+9/0hcFpRTIdvmUxht46J/fGQuPFy6A+m3zTKBeCjA=;
        b=EpNJfk/khxjxLgkQUXA5r8eaT0w1/IDZh1umcUPysOrcx9Eb0Or26FaaTXexWL5pKx
         zTmPiylzEvG0BQVXEt6B3w316Mn/Dkaj3MBlnNH7md6FzAXlgQQlpQzS9KRXFtggE0oc
         jZ9dxRlXgQ8cny0Hp7KwHi36Jfu4X0OeLA1zAN2lFJrsZ1MoObrIeN3CSST47Q7RN1Pz
         J4PUKBU9s8fl4MMnDIAAF3jJ7uKJxYl0M/Q+iGpSwsLOXZ0ht14kFI/PBfRhfsgI9n3T
         XlFmmx2hMgHlf0vDiBIqxosrvMEsC//+ULzdxPGUOnGGT/s6Ri2OxyQBN46LTHZabIrd
         JkdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762353803; x=1762958603;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=x+9/0hcFpRTIdvmUxht46J/fGQuPFy6A+m3zTKBeCjA=;
        b=MFa9HVD4d/kNvqm5tCFJx0+bFcl8XHdeLtmxFR7VR/2uZ1SRtWGMJXH03M4GfSv/Kt
         g83AQL5ISXXVqCgXqjRaHWdezdXltNgZ0Ys+820oDYl5UvUm8wNw1/Z8af0hfNtUtI2M
         NNS3ktqBXPAxHF22jj6BZ524aJNY5B2gkTKmSaAzxJMOUfnfoCOir90m5hNLzN+btL3O
         1pH5lrrXr6tdP+LgaVYH51FtIFoGwqj5B7JXEMOLFp6UQ5V7ey78K+s8a8LxTgAtcA0l
         rpEbkuzPn6FPlO5cKnUPUH3uUBJ5s6Nxbs/zWHDKENTtXMraE4pl46oe6o0RmvBKFsi9
         93hQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQWYLtCPoYH8Gl9zBMQsLIHe5JuOeILFAouzQnjbWVi5XPHcu9h9u3JNPibw0HQq7yCjry5gLPIdq/@vger.kernel.org
X-Gm-Message-State: AOJu0YzVCRgJXdPf8O8WJUZ2xrXVdbkgtIW5Z8b6hG1587nhdSk3tjag
	ka43ODTcpjSzl6gaFiCVXI6exvWmhtDUdRlryMEM8gc4Ia6LMfGNvmzBMaNsna2KqDDNViQuKT5
	KaOVyudkIUoCi5/aT4Mz8rpfnX1zJtUurzBvInFID+Yy/9aU3dLIR0U8M3c7YTmk=
X-Gm-Gg: ASbGnctF8JUiLw6BPwQyvqzVNi+yQm10smL0Vn8b0jFMPdU90iieNj3wxKwu2kb1W0Z
	PQHe0OB57/bD9m6smu57Xn5PUJAZyoeV18eNhL6ZZ2zKGlspY7q2nLY349in2eKGZGNKMqEv0BB
	cjekigql16cC0sluo2fv926cInxQepPDGhNvgMG9v29IFRY/AW72fZ6SIBrJ7IxHWifySeJlw2j
	8ydlCzPN5Bq1qDN3RdW0GM/UMf4fphG3jBoHPXhoRZ9PBf04cDSUXXsycwhmTT0zKDp7JLCBCyo
	dOwPHqFnQctqJPw+/1yskmxHUrOjZjBwGiPYiqhbzEHIvRqnNupkOlPTfLaCxCniP9C3BDzrIgh
	xLNjI6l09N0bKpMC4mlsDbhcIMeqFffvZDjT418aeBUlyw0jJ
X-Received: by 2002:a05:690e:428c:20b0:63f:c816:1172 with SMTP id 956f58d0204a3-63fd34bda23mr2652572d50.14.1762353802848;
        Wed, 05 Nov 2025 06:43:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFgguWaVcPmRVRYYxf3mqZkOXMxH3SZ9TJ5rZ8YDa+eviQ0NZPcI0mQ68g1JQO4So21KnaJiA==
X-Received: by 2002:a05:690e:428c:20b0:63f:c816:1172 with SMTP id 956f58d0204a3-63fd34bda23mr2652556d50.14.1762353802477;
        Wed, 05 Nov 2025 06:43:22 -0800 (PST)
Received: from ?IPv6:2600:6c64:4e7f:603b:fc4d:8b7c:e90c:601a? ([2600:6c64:4e7f:603b:fc4d:8b7c:e90c:601a])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-63fc95a3c2bsm1814781d50.13.2025.11.05.06.43.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 06:43:21 -0800 (PST)
Message-ID: <8fc9581aadc868f0caa54484980a40e6f53ea0c0.camel@redhat.com>
Subject: Re: [PATCH 1/2] st: separate st-unique ioctl handling from scsi
 common ioctl  handling
From: Laurence Oberman <loberman@redhat.com>
To: David Jeffery <djeffery@redhat.com>, Kai =?ISO-8859-1?Q?M=E4kisara?=
	 <Kai.Makisara@kolumbus.fi>, linux-scsi@vger.kernel.org
Date: Wed, 05 Nov 2025 09:43:20 -0500
In-Reply-To: <20251104154709.6436-1-djeffery@redhat.com>
References: <20251104154709.6436-1-djeffery@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 (3.54.3-2.fc41) 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2025-11-04 at 10:46 -0500, David Jeffery wrote:
> The st ioctl function currently interleaves code for handling various
> st
> specific ioctls with parts of code needed for handling ioctls common
> to
> all scsi devices. Separate out st's code for the common ioctls into a
> more
> manageable, separate function.
>=20
> Signed-off-by: David Jeffery <djeffery@redhat.com>
> Tested-by:=C2=A0=C2=A0=C2=A0=C2=A0 Laurence Oberman <loberman@redhat.com>
> ---
>=20
> =C2=A0drivers/scsi/st.c | 85 ++++++++++++++++++++++++++++++++++----------=
-
> --
> =C2=A01 file changed, 62 insertions(+), 23 deletions(-)
>=20
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index 74a6830b7ed8..87f0e303fdd6 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -3526,8 +3526,60 @@ static int partition_tape(struct scsi_tape
> *STp, int size)
> =C2=A0out:
> =C2=A0	return result;
> =C2=A0}
> -=0C
> =C2=A0
> +/*
> + * Handles any extra state needed for ioctls which are not st-
> specific.
> + * Called with the scsi_tape lock held, released before return
> + */
> +static long st_common_ioctl(struct scsi_tape *STp, struct st_modedef
> *STm,
> +			=C2=A0=C2=A0=C2=A0 struct file *file, unsigned int cmd_in,
> +			=C2=A0=C2=A0=C2=A0 unsigned long arg)
> +{
> +	int i, retval =3D 0;
> +
> +	if (!STm->defined) {
> +		retval =3D -ENXIO;
> +		goto out;
> +	}
> +
> +	if ((i =3D flush_buffer(STp, 0)) < 0) {
> +		retval =3D i;
> +		goto out;
> +	} else { /* flush_buffer succeeds */
> +		if (STp->can_partitions) {
> +			i =3D switch_partition(STp);
> +			if (i < 0) {
> +				retval =3D i;
> +				goto out;
> +			}
> +		}
> +	}
> +	mutex_unlock(&STp->lock);
> +
> +	switch (cmd_in) {
> +	case SG_IO:
> +	case SCSI_IOCTL_SEND_COMMAND:
> +	case CDROM_SEND_PACKET:
> +		if (!capable(CAP_SYS_RAWIO))
> +			return -EPERM;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	retval =3D scsi_ioctl(STp->device, file->f_mode & FMODE_WRITE,
> +			=C2=A0=C2=A0=C2=A0 cmd_in, (void __user *)arg);
> +	if (!retval && cmd_in =3D=3D SCSI_IOCTL_STOP_UNIT) {
> +		/* unload */
> +		STp->rew_at_close =3D 0;
> +		STp->ready =3D ST_NO_TAPE;
> +	}
> +
> +	return retval;
> +out:
> +	mutex_unlock(&STp->lock);
> +	return retval;
> +}
> =C2=A0
> =C2=A0/* The ioctl command */
> =C2=A0static long st_ioctl(struct file *file, unsigned int cmd_in,
> unsigned long arg)
> @@ -3565,6 +3617,15 @@ static long st_ioctl(struct file *file,
> unsigned int cmd_in, unsigned long arg)
> =C2=A0	if (retval)
> =C2=A0		goto out;
> =C2=A0
> +	switch(cmd_in) {
> +	case MTIOCPOS:
> +	case MTIOCGET:
> +	case MTIOCTOP:
> +		break;
> +	default:
> +		return st_common_ioctl(STp, STm, file, cmd_in, arg);
> +	}
> +
> =C2=A0	cmd_type =3D _IOC_TYPE(cmd_in);
> =C2=A0	cmd_nr =3D _IOC_NR(cmd_in);
> =C2=A0
> @@ -3876,29 +3937,7 @@ static long st_ioctl(struct file *file,
> unsigned int cmd_in, unsigned long arg)
> =C2=A0		}
> =C2=A0		mt_pos.mt_blkno =3D blk;
> =C2=A0		retval =3D put_user_mtpos(p, &mt_pos);
> -		goto out;
> -	}
> -	mutex_unlock(&STp->lock);
> -
> -	switch (cmd_in) {
> -	case SG_IO:
> -	case SCSI_IOCTL_SEND_COMMAND:
> -	case CDROM_SEND_PACKET:
> -		if (!capable(CAP_SYS_RAWIO))
> -			return -EPERM;
> -		break;
> -	default:
> -		break;
> =C2=A0	}
> -
> -	retval =3D scsi_ioctl(STp->device, file->f_mode & FMODE_WRITE,
> cmd_in, p);
> -	if (!retval && cmd_in =3D=3D SCSI_IOCTL_STOP_UNIT) {
> -		/* unload */
> -		STp->rew_at_close =3D 0;
> -		STp->ready =3D ST_NO_TAPE;
> -	}
> -	return retval;
> -
> =C2=A0 out:
> =C2=A0	mutex_unlock(&STp->lock);
> =C2=A0	return retval;


For the series:
Reviewed by: Laurence Oberman <loberman@redhat.com>

Many hours of testing done here folks, this looks to be solid and fixes
all our prior issues.

