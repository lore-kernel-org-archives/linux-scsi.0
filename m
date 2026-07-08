Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12AB143803E
	for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2026 16:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783529410; cv=none; b=ZcUCfFx8ZkKfcV3Iu8zajDPg2P2N1P9wXje0dR4HRYKJ595NngnyJJvAXnlsvXOWY81AN15/pG6WKFxSGVftvZH0N+QV8Ey0yKcDkr7yWK2ltNB8ODnIRjbyAE0Fddzg7j22KtP1+1lKcvrFXZpoGsEHPaSpBMsigLeEAd0HImU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783529410; c=relaxed/simple;
	bh=XbHwPXYNVvkP+QCkHDk9DeAKKpxWOytoPU2U2ndXHCY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sx6pbYFCRP5Ae1oqIGDjk0azKAjA/J04cJRwtnI3VFQJgLNfKCixUoFsHHqInpmSlzRGld6C/NulJ+Lm1iTlCK9TsX+vHgRRPSinx27rU2QpUs1fDdWTlGgd4XavUplTgMiaB7xWPCGUKB9HyL650LrpxF5mKGmbSfZ9PxxZAm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YO/no66r; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=p/2BSrhY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YO/no66r";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="p/2BSrhY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783529405;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XbHwPXYNVvkP+QCkHDk9DeAKKpxWOytoPU2U2ndXHCY=;
	b=YO/no66rz2tLVFci5aqKxoxXoDprTQUAMHiDHsr2K2Q5WO+pdor9N2eY02p316575d/6rF
	SY20beN6WEKfJ/XV/29KvlHuCUnJzVLVM4+ns4Ug787XpS7w48N2AmWC7Y0brVRTMudJYK
	8y3pVOl4w4zPzZ9dUGIbRnMPvPIg4Yg=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-624-uoqLBOzeNh22tYSWYt_GGg-1; Wed, 08 Jul 2026 12:50:04 -0400
X-MC-Unique: uoqLBOzeNh22tYSWYt_GGg-1
X-Mimecast-MFC-AGG-ID: uoqLBOzeNh22tYSWYt_GGg_1783529404
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-8f18c4d1f82so22432596d6.2
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2026 09:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1783529404; x=1784134204; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=XbHwPXYNVvkP+QCkHDk9DeAKKpxWOytoPU2U2ndXHCY=;
        b=p/2BSrhYORYgDL2ltHnaxNb11Jaaj7KaTRIjGaYo9+mgHAMf8dgxvm4LUJ8RBLCXDu
         0pO/8Gej623pA+7sHk8XXr09cN7e5C0YxP49NggQ2+NJtFay8uTlCQRgYPAhj7xz1AP0
         HbH/V6BcHNfJ2c4exMIo2S+IUyDowcmRR9xUamuJ+91ETvK15aT9F4e2HVBTUuB15OA+
         5lygrCmJdX5buwiJNME16FN1FO0Gt5NGJMqeySG9liafuHvl3t1KDc6tJHkQDr5WCubh
         86LhOo+pOXZ7PbrKWpqX2NIaNIrfzqB6blqyWR6OuKCSZNnRfmv40nBlcZIE+Cgoqka2
         RrSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783529404; x=1784134204;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XbHwPXYNVvkP+QCkHDk9DeAKKpxWOytoPU2U2ndXHCY=;
        b=BrNDaSy95ZtwmckhgouyiNqtu6QUAjQglrNWEU628zVTf81YYLF6q0EkAgPirATx0m
         oDvmt9/8KhoiLzQ3IFBPZwG37oEEH8dYHK4bkaSx166HpilUKnvgAdOsQhjJ5TxuIkTt
         K0nLMA+pBOG+BrYOFZWIV1OKlCzlKt/VGEcEb0QBU7SJ9lQaaZUMMkPgzktwm63Bcnc7
         FWpC+SbGPw/NAvgjjCfkOhX9nmsXJsP3bEhoqVLWZistjWQEaHTElaNPGhQLgPC2lPmr
         cGkMjtVmY+s4IfBSZQvcpXnRvm4t5IEFrGQ3LPAPhvqsA4H+nrAR4Ah0F9QKEQWeculO
         JR8g==
X-Forwarded-Encrypted: i=1; AHgh+Rq3Nt6yAiH7cDVlUhOFRi9RQq7GVIE8dIHf0yLYXx4V5FX3uAlvi/5kacwYCHC59TEKNv88FO4/ny7P@vger.kernel.org
X-Gm-Message-State: AOJu0Yxyj8OLz7n3qytqGcFDagAaoFAsIJmf9sQyERYn8t/5UdGKevCh
	VivYGpdGQwL14UcFXlbcVVRDPQ+i6hy+CZyPfVjhpvwgmkuphqPDhgp1oh0XGxzeyP4aIOhAoXf
	cRWsKJsGPugoKhClnN1NmSffMCJ8XFzwrINzjoekyUWi76VusJqaHdwKkPpqKROk=
X-Gm-Gg: AfdE7clz22+89ZUvbVVyYQdT6gETrZxD9xR/UB5ocrGNwA7Jlpd5ioT4KjhckhBPqxB
	teiid46RfT/DJ7UBSLys3dhEnQMpfgi7dbGMtg7rsGiXXMPkzGOlJh63GJPWXfephFxecbJ85ZJ
	iSMuNdOlPRodgSqL+lCe2qTS3n8R7Y5AcVzzOt43VZGDA+06Stib/nUNqDkTjGAENHLLf9F5LsL
	HSK+edxn7XRsCz2i9SlxJLBeVq7wHYZ5HHVBPYDfHSgnpSiOCiuE9EeTrKeF9Q6l6JgKLoCyDhq
	C+MAy4TmB4K8+9NfP4NIWs8ecJeHaLE0eVsAWUSWxOIPW0a4vvIS0K27KCKJ1KzhvOq/g6yh/XG
	310s4WKgmDNo0tJXCHFRhBmlilVuxE9k4qO5zt9/Y9Rxb3lo=
X-Received: by 2002:ad4:5ccd:0:b0:8e9:f5de:d614 with SMTP id 6a1803df08f44-8fec3a03667mr37427526d6.51.1783529402707;
        Wed, 08 Jul 2026 09:50:02 -0700 (PDT)
X-Received: by 2002:ad4:5ccd:0:b0:8e9:f5de:d614 with SMTP id 6a1803df08f44-8fec3a03667mr37427136d6.51.1783529401867;
        Wed, 08 Jul 2026 09:50:01 -0700 (PDT)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c65:2440:d8c:dbb1:97f1:a6e6:766b])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ff70196cc5sm5834976d6.27.2026.07.08.09.50.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 09:50:01 -0700 (PDT)
Message-ID: <b3baf6f6e9151078c21de67228f8f84e4ca090c7.camel@redhat.com>
Subject: Re: [PATCH 0/2] scsi: smartpqi: fix PCIe hot reset recovery
From: Laurence Oberman <loberman@redhat.com>
To: Don.Brace@microchip.com, mateusz.nowicki@posteo.net
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, 
	storagedev@microchip.com, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Date: Wed, 08 Jul 2026 12:50:00 -0400
In-Reply-To: <SJ2PR11MB8369F3008C15A2E56DB7B429E1072@SJ2PR11MB8369.namprd11.prod.outlook.com>
References: <cover.1778075755.git.mateusz.nowicki@posteo.net>
	 <SJ2PR11MB8369F3008C15A2E56DB7B429E1072@SJ2PR11MB8369.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2026-05-14 at 14:24 +0000, Don.Brace@microchip.com wrote:
> ________________________________________
> From:=C2=A0Mateusz Nowicki <mateusz.nowicki@posteo.net>
> Sent:=C2=A0Wednesday, May 6, 2026 9:01 AM
> To:=C2=A0Don Brace - C33706 <Don.Brace@microchip.com>
> Cc:=C2=A0martin.petersen@oracle.com=C2=A0<martin.petersen@oracle.com>;
> James.Bottomley@HansenPartnership.com=C2=A0<
> James.Bottomley@HansenPartnership.com>; storagedev
> <storagedev@microchip.com>;
> linux-scsi@vger.kernel.org=C2=A0<linux-scsi@vger.kernel.org>;
> linux-kernel@vger.kernel.org=C2=A0<linux-kernel@vger.kernel.org>
> Subject:=C2=A0[PATCH 0/2] scsi: smartpqi: fix PCIe hot reset recovery
> =C2=A0
> EXTERNAL EMAIL: Do not click links or open attachments unless you
> know the content is safe
>=20
> A PCIe bus reset (e.g. "echo 1 > /sys/bus/pci/devices/<bdf>/reset")
> on a
> controller without FLR support leaves the HPE SR932i-p Gen10+
> unusable
> until reboot: smartpqi registers no pci_error_handlers, so the driver
> is not notified, firmware reverts to SIS mode, and all queue mappings
> are dropped while the driver still drives PQI.
>=20
> Patch 1 adds .reset_prepare / .reset_done reusing
> pqi_ofa_ctrl_quiesce() / _unquiesce() / pqi_ctrl_init_resume().
>=20
> Patch 2 raises SIS_CTRL_READY_RESUME_TIMEOUT_SECS from 90s to 180s,
> matching the cold-boot path; without this patch 1 fails at the SIS
> ready check because firmware boot after reset takes ~125s on the
> SR932i-p Gen10+.
>=20
> Tested on HPE SR932i-p Gen10+ against Linus' master at 74fe02ce122a.
>=20
> Thanks for the patch.=20
> NAK for now.
>=20
> Before we ack, we want to run this through internal regression on the
> SR-series=20
> =E2=80=94 particularly the OFA + bus-reset interaction in patch 1 and whe=
ther
> the 180s timeout in patch 2 should apply universally or
> =C2=A0=C2=A0=C2=A0=C2=A0 be controller-gated. This may lead to changes in=
 your patches.
>=20
>=20
>=20
>=20
> Hi Don, Where are we with the testing you wanted to do.

Regards
Laurence

