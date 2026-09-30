Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA17E4EC677
	for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2026 15:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790781005; cv=none; b=IYTBr+sf5sIeu+iKuIZg74tacMNYWarOsbWBb3LR0CiFwCgJL554iRLC8ONSq4zMJa3aQbX6Oi/3qyUDtR2DD6LurUyaowFadMZtbjm+E3+cpKNTYfvNyYzdZAAA+Akn1feHvCX2rB2l/5qkYygfzCafjBFOx/PLlWZKY6ui8o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790781005; c=relaxed/simple;
	bh=+efNUnGsIlWRPN03rgNs2xA/cB+V+VUxN2e4xdVeUR0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KIjbaU+d9jGfgbzTGW6yqqZZG3TfgbseaWDY3HOcxs1nT+YBPZMdlzFuknCK3RJY9j4/ER5iK04DUZih+0hCqhKyK/oa+eedfbpOCHsw6+egCBeM9oeiW44ZOx6u18iWwu9y8mPvabDwNOThQ1UBA4uxrgVC5at1K2bg5DJozBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hVGcfg37; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=g65290LZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hVGcfg37";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="g65290LZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790780992;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+efNUnGsIlWRPN03rgNs2xA/cB+V+VUxN2e4xdVeUR0=;
	b=hVGcfg37zVmjtpbD2xUr2J14yj6uY7wXf2fH4UrIzNrdPWuusFyDVqtw5kjvlzFFHwH5Wz
	A6KNadm0X89Z+gAZzsAWGeVek9V4fKMwpeZR+cpJsrpWL8iD+f9BLwwc0bjrjyWTl2HBd5
	EP3h7rRfatB0b1sDT4meKxyIJOKDmH8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-131-ujU2P7JTO5qy3bQIdutWhg-1; Wed, 30 Sep 2026 11:09:51 -0400
X-MC-Unique: ujU2P7JTO5qy3bQIdutWhg-1
X-Mimecast-MFC-AGG-ID: ujU2P7JTO5qy3bQIdutWhg_1790780990
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4a0053eb950so26161405e9.1
        for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2026 08:09:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790780990; x=1791385790; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=+efNUnGsIlWRPN03rgNs2xA/cB+V+VUxN2e4xdVeUR0=;
        b=g65290LZeHEeV0W64/zRC4zLJZhYpJsycJRIid7ZihFX9ZIb3TuX8ja6h0UijXZd5X
         VxGhFtumKm/Utmb8qnZLuCRsQV6pwYpETQS210rUFjIvXmjBGfb7PcXhRMxEqiOrWg1p
         MIl9UrB+lbMzRjpwEYl0WzOclgAkgAK3sw7THJFj/GCK3kf9TmeAjYVpgKJ8T+81Ua7V
         SE3mfG2661M7X6H/5/cYdV5/DG1JoBLV7zbGzQWOZJf7RaeUvO5NjHdGU8Kky0WiLcD6
         /7hWTup5OWvZ7Xe7TSSV2HWrVOjwzoGoW8JB13zbiQgaNFd56UkiBk7n9vqQy/g1sEpl
         ZmKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790780990; x=1791385790;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+efNUnGsIlWRPN03rgNs2xA/cB+V+VUxN2e4xdVeUR0=;
        b=I26+3C/zxg9DlPYfqQyg+Q28c0nfnar4HzC0RioVOgK7rhSpqQ88sTehI2vGQb2OmJ
         c7QN44y6qzpRYnATGMMvnhY+wVi5vQjLXV362jNV12c615kwI6uQJJFJKIdE+3upRmBE
         1NIJRU0rI8SFE4C0GYQRnjxNwdfrg4qit0VciUm+giFQErpJRjkWKJp8YV50f1Jv/1vk
         UT99zcOpLHt2H2fEJWKUab1vqPmbmbAfgy626wD/6lgPdejpNiVHyxiNcNF6BY3knxOD
         i2eHZUf8NvnvWLduB2Eb0huUKCGTQWtv8bSnwz37HvCwseqB3whhaaNbQhnnz7YLVU8F
         9DkA==
X-Gm-Message-State: AFuF++lpQATKNJkE7o/6BqDzI/fENqGDydde6d1S8SayCTxi7ei49lLP
	0IeEkx+eUQuJxbWcG6HP5I6aGz+3JQuYcRJauDft5/i2lof/fQRizeRjp3WW7kmmxCctxnb1Aww
	lfVataHLZgwz4oFeORG2TPOuV0NWuRez99OUmAmNwDpWQCbsbDjSKIiz6hYjdMmRZlc9QjXs=
X-Gm-Gg: AYBFou1Q+NrirIe4NfaASAcO7xLBSSwtENSlPXSNCRjzh7BwOSP2hmbQhfgv453uh9R
	M0uD2Pes6RV2qW5BK3x7F5qLKY4f4Q0m9rom5vauSFTr2/GL5uaBqPEkRZIfBW08rdmNoXcUgq5
	9qwqLSe1QIGCqjxC+wb6LBf8Nhgy1QXw1YU9jEIYkUNUn+0n8dmQLhfCKlojyBbSRqqfwJGfSSQ
	lq3f0D6EZMpoSl1S0+4KizLj3fBAnCQF2gxqofyhuNkD87QQCXmkOr7szMUj+cgLn7DAfeKcTfF
	nUgRVlCLblj+krRFIs2mHgr4qZ0rZ4RQd/1yegRGOYOMSYyKSlseX8+mdWgl5kvrqB3skrbN5F5
	pLBjK8nR6cLazCKC/MUCh/MHZdXUfmqGhV3SY
X-Received: by 2002:a05:600c:c162:b0:49f:ff32:8044 with SMTP id 5b1f17b1804b1-4a01addecdfmr30491975e9.7.1790780989930;
        Wed, 30 Sep 2026 08:09:49 -0700 (PDT)
X-Received: by 2002:a05:600c:c162:b0:49f:ff32:8044 with SMTP id 5b1f17b1804b1-4a01addecdfmr30491365e9.7.1790780989406;
        Wed, 30 Sep 2026 08:09:49 -0700 (PDT)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c65:2440:d8c:aa2b:ddff:fe88:da74])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a01e42ad94sm6707595e9.1.2026.09.30.08.09.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 08:09:47 -0700 (PDT)
Message-ID: <40901345e474c45f531a9bc48ff9658d7bfe02aa.camel@redhat.com>
Subject: Re:
From: Laurence Oberman <loberman@redhat.com>
To: "Pluess, Tobias" <tpluess@ieee.org>
Cc: linux-scsi@vger.kernel.org, sathya.prakash@broadcom.com, 
	sreekanth.reddy@broadcom.com, suganath-prabu.subramani@broadcom.com
Date: Wed, 30 Sep 2026 11:09:40 -0400
In-Reply-To: <CAB4Wsm-HLX2haXvsq5CwnfpyxnzkCEnz__jGFh4_zr7RL78UZg@mail.gmail.com>
References: 
	<CAB4Wsm8AM3h19yLR26XQOtKX78ynQu-pC2H-gECvNtvJi58gwQ@mail.gmail.com>
	 <7132c7c54ac5f6716f3e82d3666dbef015eae419.camel@redhat.com>
	 <CAB4Wsm-HLX2haXvsq5CwnfpyxnzkCEnz__jGFh4_zr7RL78UZg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2026-09-30 at 10:09 +0200, Pluess, Tobias wrote:
> Hello Laurence,
> sorry for my late reply.
> Thanks for looking into this. I will setup my system accordingly to
> be
> able to boot older versions. It will take a few days until I have
> time
> but I will report ASAP my findings.
>=20
> From inspecting my kernel update logs,
>=20
> zgrep -E "status installed .*kernel-" /var/log/dpkg.log.*
>=20
> I see that around that time when the error started occuring was when
> updating from 6.14 to 6.17 and later. So I would guess the
> corresponding changes must have happened around that point. I'm not
> 100% sure, but I will try booting the older kernels and will report
> my
> findings.
>=20
> Thanks!
> greetings Tobias
>=20
> On Sat, Sep 26, 2026 at 2:30=E2=80=AFPM Laurence Oberman
> <loberman@redhat.com> wrote:
> >=20
> > On Fri, 2026-09-25 at 21:00 +0200, Pluess, Tobias wrote:
> > > Hi,
> > >=20
> > > I am seeing a problem with the mpt3sas driver when using an
> > > LSI/Broadcom SAS9207-8e connected to an external tape drive (HP
> > > Ultrium 6650).
> > > This setup worked without issues with older kernels. I cannot
> > > 100%
> > > sure identify at which date the problem started to occur, but I
> > > would
> > > say it started to occur around April or May this year.
> > >=20
> > > What happens:
> > > a) the external tape drive is connected to the HBA using a SAS
> > > 8088
> > > cable.
> > > b) the tape drive is switched on and is detected normally and
> > > works
> > > as
> > > expected, backups can be made.
> > > c) after the backup finishes, the tape is ejected and the drive
> > > is
> > > idle, it is switched off.
> > >=20
> > > Here begins the interesting story. In the dmesg, I see the
> > > following
> > > errors:
> > >=20
> > > [Fri Sep 25 20:02:40 2026] mpt2sas_cm6: detecting:
> > > handle(0x0009),
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 sas_address(0x50014380353cba70),
> > > phy(3)
> > > [Fri Sep 25 20:02:40 2026] mpt2sas_cm6: REPORT_LUNS:
> > > handle(0x0009),
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 retries(0)
> > > [Fri Sep 25 20:02:40 2026] TEST_UNIT_READY: handle(0x0009) lun(0)
> > > [Fri Sep 25 20:02:41 2026] mpt2sas_cm6: detecting:
> > > handle(0x0009),
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 sas_address(0x50014380353cba70),
> > > phy(3)
> > > [Fri Sep 25 20:02:41 2026] mpt2sas_cm6: REPORT_LUNS:
> > > handle(0x0009),
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 retries(0)
> > > [Fri Sep 25 20:02:41 2026] TEST_UNIT_READY: handle(0x0009) lun(0)
> > > [Fri Sep 25 20:02:41 2026] START_UNIT: handle(0x0009), lun(0)
> > > [Fri Sep 25 20:02:45 2026] TEST_UNIT_READY: handle(0x0009) lun(0)
> > > [Fri Sep 25 20:02:46 2026] mpt2sas_cm6: detecting:
> > > handle(0x0009),
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 sas_address(0x50014380353cba70),
> > > phy(3)
> > > [Fri Sep 25 20:02:46 2026] mpt2sas_cm6: REPORT_LUNS:
> > > handle(0x0009),
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 retries(0)
> > > [Fri Sep 25 20:02:46 2026] TEST_UNIT_READY: handle(0x0009) lun(0)
> > > [Fri Sep 25 20:02:46 2026] START_UNIT: handle(0x0009), lun(0)
> > > [Fri Sep 25 20:02:49 2026] TEST_UNIT_READY: handle(0x0009) lun(0)
> > > [Fri Sep 25 20:02:52 2026] mpt2sas_cm6: log_info(0x31130000):
> > > originator(PL), code(0x13), sub_code(0x0000)
> > > [Fri Sep 25 20:02:53 2026] mpt2sas_cm6: handle(0x0009),
> > > ioc_status(0x0022) failure at
> > > drivers/scsi/mpt3sas/mpt3sas_transport.c:228/_transport_set_ident
> > > ify(
> > > )!
> > > [Fri Sep 25 20:02:53 2026] mpt2sas_cm6: failure at
> > > drivers/scsi/mpt3sas/mpt3sas_scsih.c:8407/_scsih_add_device()!
> > > [Fri Sep 25 20:02:54 2026] mpt2sas_cm6: handle(0x0009),
> > > ioc_status(0x0022) failure at
> > > drivers/scsi/mpt3sas/mpt3sas_transport.c:228/_transport_set_ident
> > > ify(
> > > )!
> > > [Fri Sep 25 20:02:54 2026] mpt2sas_cm6: failure at
> > > drivers/scsi/mpt3sas/mpt3sas_scsih.c:8407/_scsih_add_device()!
> > > [Fri Sep 25 20:02:55 2026] mpt2sas_cm6: handle(0x0009),
> > > ioc_status(0x0022) failure at
> > > drivers/scsi/mpt3sas/mpt3sas_transport.c:228/_transport_set_ident
> > > ify(
> > > )!
> > >=20
> > > Here, the last 2 lines are printed to dmesg approximately every
> > > second, ad infinitum until the system is rebooted; the error
> > > never
> > > stops. I am certain this did not occur with older versions of
> > > mpt3sas,
> > > but as I said, I cannot pinpoint exactly when the change
> > > happened.
> > >=20
> > > Powering up the tape drive again fixes the error, but as soon as
> > > the
> > > tape drive is switched off again, the error reappears.
> > >=20
> > > However, the error doesn't occur every time the drive is switched
> > > off.
> > > Sometimes the mpt3sas driver seems to be happy and no errors are
> > > reported. I think it has to do with some kind of timing, i.e. in
> > > which
> > > internal state the mpt3sas driver is when the external drive is
> > > disconnected.
> > >=20
> > > Hardware:
> > > * Serial Attached SCSI controller: Broadcom / LSI SAS2308 PCI-
> > > Express
> > > Fusion-MPT SAS-2 (rev 05)
> > > * external tape drive HP Ultrium 6650
> > > * Linux pve0 7.0.14-12-pve #1 SMP PREEMPT_DYNAMIC PMX 7.0.14-12
> > > (2026-08-11T11:05Z) x86_64 GNU/Linux
> > > * mpt3sas
> > >=20
> > >=20
> > > I wonder why this problem occurs and how it could be prevented. I
> > > have
> > > to say, my hot swap HDDs are connected to
> > >=20
> > > Serial Attached SCSI controller: Broadcom / LSI SAS3416 Fusion-
> > > MPT
> > > Tri-Mode I/O Controller Chip (IOC) (rev 01)
> > >=20
> > > and here, I never have the issue, it only appears with the 9207-
> > > 8e.
> > >=20
> > > I made my own "fix" to stop the driver from filling up my dmesg
> > > with
> > > errors; using a little bash script with these commands
> > >=20
> > > echo "0000:51:00.0" > /sys/bus/pci/drivers/mpt3sas/unbind
> > > echo "0000:51:00.0" > /sys/bus/pci/drivers/mpt3sas/bind
> > >=20
> > > resets the driver and it then stops printing errors. However I
> > > think
> > > this is not a true solution to the problem, it just fixes the
> > > symptom.
> > >=20
> > >=20
> > > Any ideas how to proceed?
> > > Unfortunately I don't quickly have another system handy where I
> > > could
> > > test older versions of the driver.
> > >=20
> > > Thanks,
> > > Greetings
> > > Tobias
> > >=20
> >=20
> > Hello
> > Any chance you can boot an earlier set of kernels to try narrow
> > down
> > when this started. I don't have the older hardware to reproduce in
> > our
> > lab here. I will do some code inspection in the meantime to try
> > figure
> > out what triggers this and come up with some ideas.
> >=20
> > Would be good to know which version older kernel was not seeing
> > this.
> > Thanks
> > Laurence
> >=20
Hi Tobias,
Thanks, that version range helps. From code inspection, one possibly
relevant change between 6.14 and 6.17 is:
37c4e72b0651 scsi: Fix sas_user_scan() to handle wildcard and multi-
channel scans
That changed SAS wildcard scan behavior so a scan may now cover more
channels than before. It may only be exposing an existing mpt3sas
stale-handle issue, but it could explain why the problem became visible
now.

Could you please test these if possible:
v6.14
v6.15
v6.16
v6.17

The key thing is to find the first version where powering off the tape
drive starts the repeated _transport_set_identify() /
_scsih_add_device() messages.

Also, while the messages are repeating, could you check whether
anything is repeatedly rescanning SCSI hosts?
grep -R "host.*/scan|/scan" /etc /usr/lib/systemd /lib/systemd
/etc/udev /lib/udev 2>/dev/null

If you are able to build/test a kernel with 37c4e72b0651 reverted, that
would also be very useful.

My current theory is that after the tape drive is powered off, the
SAS2308/mpt3sas path may still have a stale device handle, and a
wildcard scan keeps trying to add it again. The add then fails because
the firmware no longer returns valid identify data for that handle.

Thanks,
Laurence

