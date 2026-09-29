Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 264213A2559
	for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 17:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790702244; cv=none; b=N/kRKc1yQ9QHpksjBjyXBHGTyXXDmqWvlLwhPL9oDaKL2oGWG+ArRFBL52PcowbliFNuqv9St1+7f+J6JLezdz1MhHBTLiHN4vlLY3D8eC8IPBbyqzWWwiKkfPaodpsvgq4hln/PAnYWk+QPb0TM92yvzJlUcHSacxVGsVVI668=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790702244; c=relaxed/simple;
	bh=jQU5fG+a47SUrbSo+LWO+RzXKwRcL7AN/eeckxJKxy0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=M8Q+ZyXofEKEnytrjWIkYpBtb50IMQ937SXYKLgJoB8fLqc4dI91WwJzDP14ZMxJJ5i+KJJrOy1A88BN+gGSjhmmnlFVp8zkOozageMjkc0ZH0MWCGMqYGWDVhMyT0F8gfgE5nrjiPPuBYSNxGKtU49ZWxXpb8TKt9xPS7rE+tM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NVEXwhJ3; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=LIeHXVPm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NVEXwhJ3";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="LIeHXVPm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790702242;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jQU5fG+a47SUrbSo+LWO+RzXKwRcL7AN/eeckxJKxy0=;
	b=NVEXwhJ3ao93ZUPb5UtDe8XF6MOI0ao1yQIEf0rReHLSrJE0ZsytPOcQNGcHSyTVYjm41+
	JY3bfxGCyLZCsvmqfjygwCjCUwUfllqIBHWTA68/RBCrHKNqB4xRwV65VDKdwLur0blcdQ
	5OB4yxVMnFgDMRsB8MLiglB8lKS+o14=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-673-bOLW1URhPdiprEglSAUVvw-1; Tue, 29 Sep 2026 13:17:21 -0400
X-MC-Unique: bOLW1URhPdiprEglSAUVvw-1
X-Mimecast-MFC-AGG-ID: bOLW1URhPdiprEglSAUVvw_1790702240
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-530d43c9a55so112125671cf.2
        for <linux-scsi@vger.kernel.org>; Tue, 29 Sep 2026 10:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790702240; x=1791307040; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=jQU5fG+a47SUrbSo+LWO+RzXKwRcL7AN/eeckxJKxy0=;
        b=LIeHXVPm4uQytLvDtXeB3laY4s4B5wX1WJJXrz9g/c116Z/DsRPrRdCrt2zb6RjTza
         5sYzhiKr/BHJGx7kxDR1nkxq+TlTUwiVv1DJtNGv5nQrRghMqebcdzeEBAcxF18T9a3c
         9WuYjOUoiwXkuPATu3UHhOooolmOCNQ1IO1V55+0zKoKwhXonkM/Yqvd02/KWX61Be02
         pQXch/2yHgSPqeVXOh2750T6QiY/GAfHtLXLm4Fr2Oq8gvR0RCf3WWs29MVocGYuPkPw
         Pd74RIADfykckVKRAJR9NXGeALUklIastZBH9UifIjXpL/oAssLLxMwV3qLna5qCUoMh
         n2Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790702240; x=1791307040;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jQU5fG+a47SUrbSo+LWO+RzXKwRcL7AN/eeckxJKxy0=;
        b=FmUJrXUsRTAkdxBWahLZNre0A6+0Y7RfcORa5rDu/0cmZsG7ipvJf15Pb1OZxQE0Dx
         t0Qvd0azlCOSF641/5Ejuwao6gGAcVYPiKqRrCp7KP5ZSFwlkYyzoDGiK/zC2kb5177V
         U8bqPOlRUokOmpTjQP9HPiN7tMZzyc0eX3M/NxrgmqcTydj0LMFRBe4wHKgnk6bU5YSf
         tVnLwmheZcbq9ukcLbTibYJTxp/9AJd6ET9aHheFMg0GfcdFfZA3qXi7DGTqbwfIHVNB
         cC+Y+Us60lrH7d4gsFEbeK+F3RLQoSMQX69ozNnY5MOO5Ecls4lwJ6MtzVBPbXpUgN71
         PmOQ==
X-Gm-Message-State: AFuF++kaPJkTXMOfFxPiJjvRGRSK8D5GiBVxNehWE4RAE6rCwJye2KuA
	ZW2KohvGEMb/Xg9chi6UrFUskDLQ+xt+URh7PbLyIxaLEKzk9LefIKs69IJCThpV1jMSIw+/Qcc
	Ehn9p4t32udF+k276Ne2ggclkxZJ22EjcuSLVijZI9lYZkeo/QqZMLVMxLxQ3l52SYToeONs=
X-Gm-Gg: AYBFou2Mk4jeArNnDLEkJQ5+4DcNu1MvZAaRlxWYpoJB+cGV/4wthkFg2RVRLJraom+
	S6HTkhk47YCrGR5/8IXz+/YxWytGlIRb1CShf6FpDSreRx19oO1bas5JDqY8ZBAny1SpJH89E7B
	tl8bZt4dIZ19Ms/zhI/nt49wvvQvlLecAB9jDinxalK9V7qSzUjxijZF+UqwmXeNycqEcYrmDoW
	ln+6Jw17twSDv4mh7cfDUk+hXAvN6POJRfStLcT71AaKQW7lpR/MoS48EcM12hZRa0T//Uh1b36
	P5Pzq2U8r4/Z3OCJvYsaP81W+hzlXfrj1mDZKAIo/78HzDbVXTmRHGJxhf/Ly+S6iL/qV8RqUAa
	464S3R+qR620+bniV/SNJfANGv+ApT4WUFDRF
X-Received: by 2002:a05:622a:156:b0:532:c476:55ea with SMTP id d75a77b69052e-5330b5f24c6mr274007101cf.24.1790702240232;
        Tue, 29 Sep 2026 10:17:20 -0700 (PDT)
X-Received: by 2002:a05:622a:156:b0:532:c476:55ea with SMTP id d75a77b69052e-5330b5f24c6mr274006651cf.24.1790702239574;
        Tue, 29 Sep 2026 10:17:19 -0700 (PDT)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c65:2440:d8c:aa2b:ddff:fe88:da74])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53369bd31besm84051cf.23.2026.09.29.10.17.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 10:17:16 -0700 (PDT)
Message-ID: <e666eb713f5a264b294753056c04de64bc3060b0.camel@redhat.com>
Subject: Re: [PATCH v2 1/2] scsi: st: Restore changed drive settings after
 reset also for MTLOAD and MTRETEN
From: Laurence Oberman <loberman@redhat.com>
To: "\"Kai" =?ISO-8859-1?Q?M=E4kisara?= "(Kolumbus)\""
	 <kai.makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <mkp@kernel.org>, 
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, John
 Meneghini <jmeneghi@redhat.com>, emilne@redhat.com, 	bgurney@redhat.com
Date: Tue, 29 Sep 2026 13:17:15 -0400
In-Reply-To: <2ABF6AD2-97F0-4373-A47D-1444B27A9593@kolumbus.fi>
References: <20260928132539.56876-1-loberman@redhat.com>
	 <20260928132539.56876-2-loberman@redhat.com>
	 <2ABF6AD2-97F0-4373-A47D-1444B27A9593@kolumbus.fi>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2026-09-29 at 17:15 +0300, Kai M=C3=A4kisara (Kolumbus) wrote:
>=20
>=20
> > On 28. Sep 2026, at 16.25, Laurence Oberman <loberman@redhat.com>
> > wrote:
> >=20
> > A device reset returns the drive's density and block size to their
> > defaults.=C2=A0 Commit 7081dc75df79 ("scsi: st: Restore some drive
> > settings
> > after reset") re-applies values changed by the user when the
> > position is
> > recovered with MTREW, MTSEEK or MTEOM.=C2=A0 MTLOAD and MTRETEN are als=
o
> > allowed to clear the reset condition and also leave the same medium
> > at
> > BOT, but they restore nothing.
> >=20
> > Because check_tape() reads the drive's block size with MODE SENSE
> > on
> > every open, the driver silently switches to the drive default after
> > the
> > reset.=C2=A0 An application that set fixed-block mode with MTSETBLK and
> > recovers with MTLOAD or MTRETEN keeps writing, but variable-length
> > blocks, without any error.
>=20
> Reset also returns the drive buffering mode (STp->drv_buffer) to the
> default.
> This should also be restored. It might be possible to use the same
> logic than
> with density and block size. check_tape() reads the possibly damaged
> drv_buffer
> value. So the old value should be saved before check_tape() and
> restored if
> the value after check_tape() differs from the saved value (and the
> saved
> value !=3D 1). (I may have overlooked somthing.)
>=20
> Another thing is the auto_lock mode. It should be enough to set
> STp->door_locked =3D ST_UNLOCKED when reset is recognized. The door
> wiil
> then be locked at first read or write.
>=20
> Otherwise I did not find any issues.
>=20
> Thanks, Kai
>=20
>=20
Thanks Kai. Both are new patches in v3: 3/4 records the buffering mode
set with MTSETDRVBUFFER and restores it in both restore paths (it is
already lost when the device is reopened after the reset, so it is
saved when set rather than before check_tape()), and 4/4 sets
door_locked =3D ST_UNLOCKED when the reset is recognized. Both reproduced
and verified on an IBM LTO-5.

