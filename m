Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6494349A5
	for <linux-scsi@vger.kernel.org>; Sat, 26 Sep 2026 12:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790425829; cv=none; b=udRO139U3txqVg1LPGaU7543TUSHuLGGe6YGWRAKHflxkmEnYAayrxL5t2DNphnrbP4bMefnzVEF0AOwf3DHx4xrWc7TstUBXgsdUQjyLQLHlRDvCOLjAIf9mcHoDWBzi2pOE1h51JwIGOSi/wocaLUKudJSEEoO7s72kDvpiY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790425829; c=relaxed/simple;
	bh=nDDoUFNE3rEnZSOWzrXQ3jUzHk5zP2QnL6HLx7mf1ik=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IhV+D+HyCxcAhDY21p/KEeZKjSBDm0g5L5c6wB/eylGJqF70Ye7RcVQTM/Y17UHLBd8jFtPm/6ZGthJAqWXKT0EsH1nq0wDYA73EyUjFSEMCgbEV029QsIrS3mUdQd2uI0jDL/L8gbgbZuDyKagiktCdRvZVF889pxfudcFqnJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fVOnCNOo; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=c4ocDLNa; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fVOnCNOo";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="c4ocDLNa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790425825;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nDDoUFNE3rEnZSOWzrXQ3jUzHk5zP2QnL6HLx7mf1ik=;
	b=fVOnCNOoZX7f1k7VD72bxU1jifGyp2FxjicArgQ06+WkWxKJLGvNdWLsNMLAH7tLqDQFQe
	8UIm++ztqeKiwWhwOG/zVi3AHmY/dikCNlV8Kt8bh2AyXdNKePKvLYV7sGh6ZBQwpM7OqU
	Mtt6ZK4OMlTkCvzaCapdCKVLIptCwxc=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-580-6iauyQXVN3-mh7bj1LY4UQ-1; Sat, 26 Sep 2026 08:30:19 -0400
X-MC-Unique: 6iauyQXVN3-mh7bj1LY4UQ-1
X-Mimecast-MFC-AGG-ID: 6iauyQXVN3-mh7bj1LY4UQ_1790425818
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-91064f6e75bso48296966d6.3
        for <linux-scsi@vger.kernel.org>; Sat, 26 Sep 2026 05:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790425818; x=1791030618; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=nDDoUFNE3rEnZSOWzrXQ3jUzHk5zP2QnL6HLx7mf1ik=;
        b=c4ocDLNaBVQdRN0cGnBieQBGeT6LFsAzlIlK6HjBtw3nkp1NhNsiDgJfCUUUWjILQM
         K59AMCf5KWa4UZylQnUztvsDYDT6eVOFV6qJTsME4qmDkwUUfRK4njXog5UuL/3MAnPK
         jSLna5Msm0Ear87W2fqP2ToGIOUKv+HzSAoXo8+7s7w7hILC1mhAg6P1OLLHFWlDYCsS
         wojNaegH2gSVErN5hM9DCP96MFH272vGk3/CF5WePoyrsXgOlPsOk6YEjufJH0cSAs+D
         AkzUEG3XzUS/gRgJNXhdKRyZti3wME1KgMxXjFmIzDIwel1klaCvhQUYArZFd6RrtNEO
         G1xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790425818; x=1791030618;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nDDoUFNE3rEnZSOWzrXQ3jUzHk5zP2QnL6HLx7mf1ik=;
        b=VCNwKw+8323tZ5rIyzxujI/gxeS4xJIZ5ln2MTXVXB91BUjr34lHEe+MHK6eQ4ozjc
         UZXJ6qNXnJGBPRr3mc7ghTF9vNzK/q0VdUQ+cytsWbDREuoQZ8Yko8Ba4EEfU4i2UlFE
         A1DmNFhM74xUbeRBYu0zPP5E+qNw39E6C8SuYPXd3jv6GO70+TPXYoPck2PmrKH7xtHD
         G8eH3F78MXbpgS0R0Nc6sjjrrMDUktfTyFNvNFDc8eQTaGt+pHrBqXBsnhL4nEFGTFHm
         5kCJgHhpWzJpN8sxPJHKn5wMavGnIMoTr+dkkYbbObPuJGrtBZDBBpMlWO6CmBFXmoVK
         Chqg==
X-Forwarded-Encrypted: i=1; AKwUvBy8VrekWSKBn/49QipMvJo0Bs/MbO2NBFdBf4k57wdr6YFq4ro+cX02L8+KlHGivjc/m0SacdPqDkhz@vger.kernel.org
X-Gm-Message-State: AFq9FYK1B+7GS06fyGQPWPXBYLooKIJot/LcROqOcLus5A2zRXFA3G2s
	pQw38cLs6eNgFheN10+ZkrstxhToi3LqHazSiztRlEvZX7T7NPGtslGYWthko2ze9McER3flXtP
	XiEK1yVNqY6bqV4fglNvPYp9KOZfgAw/JuxxtSBNTNafxpJ6j7myoQtqx38EPmAM=
X-Gm-Gg: AYBFou3ZkzRk+SeNibWC2riJEhcnpbvluRnT+Exx26XzJ4oOu88hNT0LXO92VnUVU5W
	64O753ucfdITNdtD11ptln/NnAEW9rIqqwmF5XPccQ28FsWHMnCwS4jYYGb5jJoofvUrULMzvkt
	bXVQtKsbW8OXOwEsPWxGsH86K5CqLssogeTxKLlGGVDdIGkPzfoK0e0PkQ5EN63y3DhDVa971gg
	TXwhkQlxwRTGELALxSwbySkurza+uZ7zjGJbvPZm3vhDlLNQdL6sIfUvuT+gmZJKnwZOwKvzcrV
	Hf4qVLITf4Nw/1Q1JH3KdzgAvu+6hB7Zjk6Pz0GZDjFDzTvHdVdQY4XSGhTAheTGvnXnAdKts8m
	D5UQ0iHD6rsfKHMN/CB5yuJ7wuACXE0eU
X-Received: by 2002:a05:6214:3c8c:b0:912:517b:40fb with SMTP id 6a1803df08f44-914324c9b57mr93540896d6.45.1790425817999;
        Sat, 26 Sep 2026 05:30:17 -0700 (PDT)
X-Received: by 2002:a05:6214:3c8c:b0:912:517b:40fb with SMTP id 6a1803df08f44-914324c9b57mr93540036d6.45.1790425817380;
        Sat, 26 Sep 2026 05:30:17 -0700 (PDT)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c65:2440:d8c:aa2b:ddff:fe88:da74])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91430e9f7b0sm38377596d6.43.2026.09.26.05.30.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 05:30:15 -0700 (PDT)
Message-ID: <7132c7c54ac5f6716f3e82d3666dbef015eae419.camel@redhat.com>
Subject: Re:
From: Laurence Oberman <loberman@redhat.com>
To: "Pluess, Tobias" <tpluess@ieee.org>, linux-scsi@vger.kernel.org
Cc: sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com, 
	suganath-prabu.subramani@broadcom.com
Date: Sat, 26 Sep 2026 08:30:15 -0400
In-Reply-To: <CAB4Wsm8AM3h19yLR26XQOtKX78ynQu-pC2H-gECvNtvJi58gwQ@mail.gmail.com>
References: 
	<CAB4Wsm8AM3h19yLR26XQOtKX78ynQu-pC2H-gECvNtvJi58gwQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2026-09-25 at 21:00 +0200, Pluess, Tobias wrote:
> Hi,
>=20
> I am seeing a problem with the mpt3sas driver when using an
> LSI/Broadcom SAS9207-8e connected to an external tape drive (HP
> Ultrium 6650).
> This setup worked without issues with older kernels. I cannot 100%
> sure identify at which date the problem started to occur, but I would
> say it started to occur around April or May this year.
>=20
> What happens:
> a) the external tape drive is connected to the HBA using a SAS 8088
> cable.
> b) the tape drive is switched on and is detected normally and works
> as
> expected, backups can be made.
> c) after the backup finishes, the tape is ejected and the drive is
> idle, it is switched off.
>=20
> Here begins the interesting story. In the dmesg, I see the following
> errors:
>=20
> [Fri Sep 25 20:02:40 2026] mpt2sas_cm6: detecting: handle(0x0009),
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 sas_address(0x50014380353cba70), phy(3)
> [Fri Sep 25 20:02:40 2026] mpt2sas_cm6: REPORT_LUNS: handle(0x0009),
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 retries(0)
> [Fri Sep 25 20:02:40 2026] TEST_UNIT_READY: handle(0x0009) lun(0)
> [Fri Sep 25 20:02:41 2026] mpt2sas_cm6: detecting: handle(0x0009),
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 sas_address(0x50014380353cba70), phy(3)
> [Fri Sep 25 20:02:41 2026] mpt2sas_cm6: REPORT_LUNS: handle(0x0009),
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 retries(0)
> [Fri Sep 25 20:02:41 2026] TEST_UNIT_READY: handle(0x0009) lun(0)
> [Fri Sep 25 20:02:41 2026] START_UNIT: handle(0x0009), lun(0)
> [Fri Sep 25 20:02:45 2026] TEST_UNIT_READY: handle(0x0009) lun(0)
> [Fri Sep 25 20:02:46 2026] mpt2sas_cm6: detecting: handle(0x0009),
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 sas_address(0x50014380353cba70), phy(3)
> [Fri Sep 25 20:02:46 2026] mpt2sas_cm6: REPORT_LUNS: handle(0x0009),
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 retries(0)
> [Fri Sep 25 20:02:46 2026] TEST_UNIT_READY: handle(0x0009) lun(0)
> [Fri Sep 25 20:02:46 2026] START_UNIT: handle(0x0009), lun(0)
> [Fri Sep 25 20:02:49 2026] TEST_UNIT_READY: handle(0x0009) lun(0)
> [Fri Sep 25 20:02:52 2026] mpt2sas_cm6: log_info(0x31130000):
> originator(PL), code(0x13), sub_code(0x0000)
> [Fri Sep 25 20:02:53 2026] mpt2sas_cm6: handle(0x0009),
> ioc_status(0x0022) failure at
> drivers/scsi/mpt3sas/mpt3sas_transport.c:228/_transport_set_identify(
> )!
> [Fri Sep 25 20:02:53 2026] mpt2sas_cm6: failure at
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:8407/_scsih_add_device()!
> [Fri Sep 25 20:02:54 2026] mpt2sas_cm6: handle(0x0009),
> ioc_status(0x0022) failure at
> drivers/scsi/mpt3sas/mpt3sas_transport.c:228/_transport_set_identify(
> )!
> [Fri Sep 25 20:02:54 2026] mpt2sas_cm6: failure at
> drivers/scsi/mpt3sas/mpt3sas_scsih.c:8407/_scsih_add_device()!
> [Fri Sep 25 20:02:55 2026] mpt2sas_cm6: handle(0x0009),
> ioc_status(0x0022) failure at
> drivers/scsi/mpt3sas/mpt3sas_transport.c:228/_transport_set_identify(
> )!
>=20
> Here, the last 2 lines are printed to dmesg approximately every
> second, ad infinitum until the system is rebooted; the error never
> stops. I am certain this did not occur with older versions of
> mpt3sas,
> but as I said, I cannot pinpoint exactly when the change happened.
>=20
> Powering up the tape drive again fixes the error, but as soon as the
> tape drive is switched off again, the error reappears.
>=20
> However, the error doesn't occur every time the drive is switched
> off.
> Sometimes the mpt3sas driver seems to be happy and no errors are
> reported. I think it has to do with some kind of timing, i.e. in
> which
> internal state the mpt3sas driver is when the external drive is
> disconnected.
>=20
> Hardware:
> * Serial Attached SCSI controller: Broadcom / LSI SAS2308 PCI-Express
> Fusion-MPT SAS-2 (rev 05)
> * external tape drive HP Ultrium 6650
> * Linux pve0 7.0.14-12-pve #1 SMP PREEMPT_DYNAMIC PMX 7.0.14-12
> (2026-08-11T11:05Z) x86_64 GNU/Linux
> * mpt3sas
>=20
>=20
> I wonder why this problem occurs and how it could be prevented. I
> have
> to say, my hot swap HDDs are connected to
>=20
> Serial Attached SCSI controller: Broadcom / LSI SAS3416 Fusion-MPT
> Tri-Mode I/O Controller Chip (IOC) (rev 01)
>=20
> and here, I never have the issue, it only appears with the 9207-8e.
>=20
> I made my own "fix" to stop the driver from filling up my dmesg with
> errors; using a little bash script with these commands
>=20
> echo "0000:51:00.0" > /sys/bus/pci/drivers/mpt3sas/unbind
> echo "0000:51:00.0" > /sys/bus/pci/drivers/mpt3sas/bind
>=20
> resets the driver and it then stops printing errors. However I think
> this is not a true solution to the problem, it just fixes the
> symptom.
>=20
>=20
> Any ideas how to proceed?
> Unfortunately I don't quickly have another system handy where I could
> test older versions of the driver.
>=20
> Thanks,
> Greetings
> Tobias
>=20

Hello
Any chance you can boot an earlier set of kernels to try narrow down
when this started. I don't have the older hardware to reproduce in our
lab here. I will do some code inspection in the meantime to try figure
out what triggers this and come up with some ideas.

Would be good to know which version older kernel was not seeing this.
Thanks
Laurence

