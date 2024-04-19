Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851AC13118B
	for <linux-scsi@vger.kernel.org>; Fri, 19 Apr 2024 19:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713555379; cv=none; b=Tp8Tulv2d/uzfIAK1Q7SRxtHO1DqOhTQbXtQKNyUBGBuVpomrTjraQtuzOAq01bRBFndbtu012iPSTbPYk7JTDdiy3gNgS5aArJ+yVoifXMCneOBfUyPXcMzKc3lJBAaGWYI2rpfzC11EwARROpNy7h1xczL3R42xiSP3EwsFnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713555379; c=relaxed/simple;
	bh=9RemURLgiNhMGmPJlyhUunAHZxkDRj8sIUS7tq0ct5o=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=q+4KkjsBbqn5T/HXI56Xz9x/6ugoRoh66tQRLhYyyoylZ/sQAcBGG/DrsfY1f69VsIESYJWtddWB317cEnLQPKm5Ujc6seTAHE0XuAHiXSL245h4C2oDWGz/B3uo3S+dL19nTkU+wxqAn8QE0IFXHrG5h+uwQiyh5gMVzWHzdDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e2GpLQ//; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e2GpLQ//"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713555376;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9RemURLgiNhMGmPJlyhUunAHZxkDRj8sIUS7tq0ct5o=;
	b=e2GpLQ//oYjN3If0nT/aSPLfVmIXbbqfww7TtJ3Kaey+9jqA4on9qRj7lMKV78qCnDOJSA
	HABjvBJcjUqP8+W24X7SjSi9VM3R8253vCG0icwSufbV87HZudTQ6S4LmHxtstpKmBE8qG
	8uGAbQzpb7dtVdqqw6RMg/dlgxrT0fM=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-20-hoakdeCwPqW9sOWjS-Onvw-1; Fri, 19 Apr 2024 15:36:15 -0400
X-MC-Unique: hoakdeCwPqW9sOWjS-Onvw-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-436d9e571c1so26793741cf.0
        for <linux-scsi@vger.kernel.org>; Fri, 19 Apr 2024 12:36:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713555374; x=1714160174;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9RemURLgiNhMGmPJlyhUunAHZxkDRj8sIUS7tq0ct5o=;
        b=WAm80l1R8bUMSWbkFD750T27BKzrATzlBBC6o5bKtO43AVn7M3BO7n1Ej5uoFlLkaK
         1UFvUpyPuLzwIC89SuiRamagvUjdt+I2IEqpDNSiMDInvJL4MVQdv15zaUbPh/sMoW/g
         1+OH+Q6Gq3CqVcOb1xXAZyf8ROJEG5w0pLlrh/LELOr26UHkmMEBJGa+A9oVhc5RDKHM
         JmeXyE+V5svSNGm/wJoFGpuIdjTvCbRe8gwsaK7gBN+SBesaZTcC2dhPT6GNwLLY+bgB
         Z7gmxA9iaU6RxVcyxHVzB9ZWjE/j5kOzlFHNxhoBNywmTs9qSTdim6NxKePrYoq/yyyY
         LxIQ==
X-Forwarded-Encrypted: i=1; AJvYcCXz4A5lLSsWGwJ/UuLtQsSPTX+45I6zGSeOa0Uvi5l0J+aqOAHDrky3laAvjqbeuLtoIUIoe3urex0cdc/9pbwCw1zqSwbxfUQtuA==
X-Gm-Message-State: AOJu0YxFFwrjCGtHHhcpjNh0qA6scQ33prrJcBUa7BJxIWbxIdB4lMmE
	B5MxyuPFrFMqsWaEvmagb0+celJelrKf0JtAvX4ngD4JWCwew6+MQ+2/1NIDstzNcuG3N0QKcll
	uXebfmJ4RN0dfU2HI5OlLQoYaUdhbPHaAAZ2PyMHVL0cXqf5E/bJuyQCahI0=
X-Received: by 2002:ac8:5f12:0:b0:436:5ca6:cd8f with SMTP id x18-20020ac85f12000000b004365ca6cd8fmr3663716qta.53.1713555374617;
        Fri, 19 Apr 2024 12:36:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF2pos9yNQ3U4n9xCSRw5PFhPxsiJnwvGO/DRmMXGJu1nTkJT3YURbBmT4sYXdJZB4nmw+qSw==
X-Received: by 2002:ac8:5f12:0:b0:436:5ca6:cd8f with SMTP id x18-20020ac85f12000000b004365ca6cd8fmr3663702qta.53.1713555374350;
        Fri, 19 Apr 2024 12:36:14 -0700 (PDT)
Received: from ?IPv6:2600:6c64:4e7f:603b:2613:173:a68a:fce8? ([2600:6c64:4e7f:603b:2613:173:a68a:fce8])
        by smtp.gmail.com with ESMTPSA id x14-20020ac84a0e000000b00436c05b12a6sm1824564qtq.60.2024.04.19.12.36.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Apr 2024 12:36:14 -0700 (PDT)
Message-ID: <47e8a845f19f8723ae5a913dcb20c85a2355f5b6.camel@redhat.com>
Subject: Re: [PATCH] V2 scsi_mod: Add a new parameter to scsi_mod to control
From: Laurence Oberman <loberman@redhat.com>
To: michael.christie@oracle.com, martin.petersen@oracle.com, 
	linux-scsi@vger.kernel.org, emilne@redhat.com, jpittman@redhat.com, 
	jmeneghi@redhat.com, Bart.VanAssche@wdc.com
Date: Fri, 19 Apr 2024 15:36:13 -0400
In-Reply-To: <d82ee3b2-ded7-4020-a286-e9aff060572e@oracle.com>
References: <20240418181038.198242-1-loberman@redhat.com>
	 <d82ee3b2-ded7-4020-a286-e9aff060572e@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2024-04-19 at 14:28 -0500, michael.christie@oracle.com wrote:
> On 4/18/24 1:10 PM, Laurence Oberman wrote:
> > Resend of this patch as V2 against Martin's tree.
> > Changes: Removed initialization of global variable
> > storage_quiet_discovery
> >=20
> > This new parameter storage_quiet_discovery defaults to 0 and
> > behavior is
> > unchanged. If its set to 1 on the kernel line then sd_printk and
> > sdev_printk are disabled for printing. The default logging can be
> > re-enabled any time after boot using /etc/sysctl.conf by setting
> > dev.scsi.storage_quiet_discovery =3D 0.
> > systctl -w dev.scsi.storage_quiet_discovery=3D0 will also change it
> > immediately back to logging. i
> > Users can leave it set to 1 on the kernel line and 0 in the conf
> > file
> > so it changes back to default after rc.sysinit.
> > This solves the tough problem of systems with 1000's of
> > storage LUNS consuming a system and preventing it from booting due
> > to
> > NMI's and timeouts due to udev triggers.
> >=20
>=20
> I didn't see v1 so maybe this was already asked. Why can you use the
> existing SCSI_LOG infrastructure for this?
>=20
> For example, are the printks that are causing you problems specific
> calls that are not already covered by SCSI_LOG, like the sdev_printk
> in
> scsi_probe_lun? Do we just want to have those covered by a new
> SCSI_LOG
> value like SCSI_LOG_DISCOVERY?
>=20
>=20
>=20

Mike and Bart, Thank you

I think I looked at this some years back and customers wanted an off
during boot but then on workflow.
I sent the patch a few years back but the problem has not gone away so
I resent.

Back Monday after review of your suggestions.

Regards
Laurence

