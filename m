Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC0541C72
	for <linux-scsi@vger.kernel.org>; Sun, 21 Apr 2024 22:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713737600; cv=none; b=WjVMU5kRkGResekKrLfLCL7CTj4HyocAPdsWwIi0JUrW67jecgvEj6z4mmqz4SVG9cGm2dTCgyIgCI0USi9adDLMLKl8Hw5Tdi1oxdJXYklsbCJ5Yy7cLbIXt97O+HS40kSz2vKix2zqpJUH8kPUqor7UzEdbSZuQjrx2/kqC9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713737600; c=relaxed/simple;
	bh=06S2EbtHUxnc0u+ydjCrvQr0ZBpiAtq57HrMibhotN4=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=blNyoAADDLhuxtlefyYJZjciQMMFAldvY+MQS/K/F48tu2iBzQF4f4V7qfU7Kkiq+UpoQrlZavtRMDN/eIBc8hRJkajBHYU5ENSu4HBpf2l9QDc2gC1KQgq3FyFD/rW1Hww7+UrH8C2oRefFuMOT2kPkuVXCJWKm6SJLbtLHW4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JW+Ejvge; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JW+Ejvge"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713737597;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zP1GYZ+tMvIonsOyzxe4apRAGWBw1vIkezAujdrMmFg=;
	b=JW+Ejvge6GfIXUW9Nhu3bmWeSXsGlZkQ9xNFbcLs4Lx25NGrn8Dq45c1aQ2tJZyYxLfw9W
	K3Je8zV0cJtyPuSxp2qEspxo1tvJlak5SpOwPNhyZ5h+YQ+uV5Rw23y7SP3OzZbAXr07+g
	IenhjE9mnBbxIAYyi1v6AHadf2AkChc=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-124-J-rbGuIBOguaLuWCUcZ_dg-1; Sun, 21 Apr 2024 18:13:15 -0400
X-MC-Unique: J-rbGuIBOguaLuWCUcZ_dg-1
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-61ac32822bcso86069977b3.1
        for <linux-scsi@vger.kernel.org>; Sun, 21 Apr 2024 15:13:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713737595; x=1714342395;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zP1GYZ+tMvIonsOyzxe4apRAGWBw1vIkezAujdrMmFg=;
        b=UfptkdyzRQTDDrIfnE6MVKwQg60frkoOZ0BhllKDiTAMXDnuKM4WIGdm+nlvq9KQbx
         c/l/4ZtyVj60Rh5wRFLNd/5zrXSR6JgzXdrfz/89zhRL95Q6VALPT7kbbqBkL9u7AAEf
         XAqWjQnOUinL3dCcqM5fYpS8fZgBLavIHCymXIefjNqxKaD2HIlJJHKyf9td0FaOK583
         /CtjbSnFPuJexO9NKk06VHiO/fGuFcUFil1ifgDDECHamEjRyYPSHEEyNRUtNXmyakoE
         iwwQZaFNbHzV7k1HpviRerxGivAVY5ysCoVviQTc3UxnftU2o2h8UWwzlW/RUVx863J/
         p9Ww==
X-Forwarded-Encrypted: i=1; AJvYcCXSKWA2lHQqUIVbIJqDkv8zxTK876FI7A89Xpnz+e1Bf4YknSNbB9iDQeU4hwsbc6ifxRvyzSjo2Saj+AUhbr42rCI1KRE+vYEFxA==
X-Gm-Message-State: AOJu0YzNbKaYCuYVBTrbehud2S8KhwC3It52SQ37MQRL4oNDACPIZpPr
	U8kBRKgiRWw8/OJQEPxh4pvW3Gl4hkFmYXLBJ93uR2tvW56nKNjY0QPu/WIsJnh62Qf3ashEZmS
	cSVYeld+bSkShKcvDKQlt7TkMxImRdI80Sdof1NNp8ghPzHqKMgEPKv8A5V4=
X-Received: by 2002:a5b:60c:0:b0:dcf:6122:ccec with SMTP id d12-20020a5b060c000000b00dcf6122ccecmr8851254ybq.36.1713737595153;
        Sun, 21 Apr 2024 15:13:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH7+UsXK9zOXgVd276Ln/OJlcad9vv3yreNnDQCUm0InJioCNE2tbIZBfNZxkyXNQrOyqoXFg==
X-Received: by 2002:a5b:60c:0:b0:dcf:6122:ccec with SMTP id d12-20020a5b060c000000b00dcf6122ccecmr8851238ybq.36.1713737594740;
        Sun, 21 Apr 2024 15:13:14 -0700 (PDT)
Received: from syn-2600-6c64-4e7f-603b-9b92-b2ac-3267-27e9.biz6.spectrum.com ([2600:6c64:4e7f:603b:9b92:b2ac:3267:27e9])
        by smtp.gmail.com with ESMTPSA id t4-20020a0c8d84000000b0069be29e160fsm2597767qvb.141.2024.04.21.15.13.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Apr 2024 15:13:13 -0700 (PDT)
Message-ID: <51960080a06b9e02ca8d539fe0e696a5e520f3b7.camel@redhat.com>
Subject: Re: [PATCH] V2 scsi_mod: Add a new parameter to scsi_mod to control
From: Laurence Oberman <loberman@redhat.com>
To: michael.christie@oracle.com, martin.petersen@oracle.com, 
	linux-scsi@vger.kernel.org, emilne@redhat.com, jpittman@redhat.com, 
	jmeneghi@redhat.com, Bart.VanAssche@wdc.com
Date: Sun, 21 Apr 2024 18:13:12 -0400
In-Reply-To: <47e8a845f19f8723ae5a913dcb20c85a2355f5b6.camel@redhat.com>
References: <20240418181038.198242-1-loberman@redhat.com>
	 <d82ee3b2-ded7-4020-a286-e9aff060572e@oracle.com>
	 <47e8a845f19f8723ae5a913dcb20c85a2355f5b6.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-9.el9) 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 2024-04-19 at 15:36 -0400, Laurence Oberman wrote:
> On Fri, 2024-04-19 at 14:28 -0500, michael.christie@oracle.com wrote:
> > On 4/18/24 1:10 PM, Laurence Oberman wrote:
> > > Resend of this patch as V2 against Martin's tree.
> > > Changes: Removed initialization of global variable
> > > storage_quiet_discovery
> > > 
> > > This new parameter storage_quiet_discovery defaults to 0 and
> > > behavior is
> > > unchanged. If its set to 1 on the kernel line then sd_printk and
> > > sdev_printk are disabled for printing. The default logging can be
> > > re-enabled any time after boot using /etc/sysctl.conf by setting
> > > dev.scsi.storage_quiet_discovery = 0.
> > > systctl -w dev.scsi.storage_quiet_discovery=0 will also change it
> > > immediately back to logging. i
> > > Users can leave it set to 1 on the kernel line and 0 in the conf
> > > file
> > > so it changes back to default after rc.sysinit.
> > > This solves the tough problem of systems with 1000's of
> > > storage LUNS consuming a system and preventing it from booting
> > > due
> > > to
> > > NMI's and timeouts due to udev triggers.
> > > 
> > 
> > I didn't see v1 so maybe this was already asked. Why can you use
> > the
> > existing SCSI_LOG infrastructure for this?
> > 
> > For example, are the printks that are causing you problems specific
> > calls that are not already covered by SCSI_LOG, like the
> > sdev_printk
> > in
> > scsi_probe_lun? Do we just want to have those covered by a new
> > SCSI_LOG
> > value like SCSI_LOG_DISCOVERY?
> > 
> > 
> > 
> 
> Mike and Bart, Thank you
> 
> I think I looked at this some years back and customers wanted an off
> during boot but then on workflow.
> I sent the patch a few years back but the problem has not gone away
> so
> I resent.
> 
> Back Monday after review of your suggestions.
> 
> Regards
> Laurence

Hello folks

OK I remember why I did it this way. (Back in 2021)
There are too many places sdev_printk is called, not as bad for
sd_printk but still a lot of changes so doing it in the macro was the
most sensible. It also masks all the ALUA messages.

Adding another KERN_xxx and LOGLEVEL_xxx won't fly and Enterprise
customers want the normal log behavior after boot.
So I think other than adding a single extra module parameter this
solution is the cleanest and makes sense. 
Using rate_limiting is not what customers want after boot to ensure
device logging is back as normal. It's only the boot challenges that
cause problems.
This change other than adding the single extra option defaults to ZERO
changed behavior so I am asking for this please to be considered.
It is way too common now for Enterprise customers to have these multi-
thousand lun paths and devices. 

Sincerely
Laurence






