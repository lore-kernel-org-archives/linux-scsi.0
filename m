Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D4350129E
	for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2026 15:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783547; cv=none; b=IgI8IKN5qF10B/9z8L6Ss66kcyQY/8mbiJcNCjUnIIb9x+B+GodKajbQweS20iWnJcIxbLw8H4KATQYMoozHLAXw+3HS6ZUsMyzp8kq7oCl4+wXkimUeojn9Cq4pmjYs79fwr7JuYux7nF3oTfcvgNHL6Jux3HpA3i3ryh+sb5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783547; c=relaxed/simple;
	bh=BKbJWQd12DwghryUK09YaBzuzNF7yqiVXQZ/8lqwb+Y=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=J8VLNKhu290dy5gPcCfqaGDwtJPu9mbnpcSuYEdOwjlgnZwcmaTaWYhVN5MOvQaSbJzmfdi5UfrgL469yOsPXTg9+pflPC9XYfREXGiJsVH0r4qSe3anHFAZIkZc377ez2khH7XvT1n863uR+ehyKPClV//qrJnOGT9CwX8yzU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i8X98GBY; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ul+spd7+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i8X98GBY";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ul+spd7+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790783541;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ONgd+iKteifBmehAVDANcjA1ry/HNokcEiZSh52shqw=;
	b=i8X98GBYJWC0TPR9Z3iGRJkEnBYQkbGBIcKJbXMmyKuZIdDLl4W5N2jeqc+SdcYg7/6Jz4
	7xKUY3z78scp+EgIW/8LAO3bZZtTpK6+22GO2nRsib2bq+NzxSFdTPrBGZgpVzSE65vHvI
	9NNd/UQzC8yTdB2OBCbxx1ZJn+Z5F+w=
Received: from mail-yx1-f70.google.com (mail-yx1-f70.google.com
 [74.125.224.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-672-_2pikEhIOTecEfe6S3DTBw-1; Wed, 30 Sep 2026 11:52:20 -0400
X-MC-Unique: _2pikEhIOTecEfe6S3DTBw-1
X-Mimecast-MFC-AGG-ID: _2pikEhIOTecEfe6S3DTBw_1790783538
Received: by mail-yx1-f70.google.com with SMTP id 956f58d0204a3-66c767e23f6so5712179d50.0
        for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2026 08:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790783538; x=1791388338; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=ONgd+iKteifBmehAVDANcjA1ry/HNokcEiZSh52shqw=;
        b=Ul+spd7+hqrOnQ5axGUMtJe6X1+HVCG4CmX5DcuDis9CzNGo1xMsmqhZuuOB2XUvK7
         y4tyzDYXtiS3LILy/A6e6xlLmNdY3gl4++LTVWQynbGafKoXo4qXd4DGVVvXFYIJR/Cy
         BxdTsxDzxhNzgN+oTLR43ApufVstNDxaAxxMX5xTHdQaBRbCQfMBhSVIFsaplboF+RIU
         t5jDXJnRleng4ybZudHOcRhc7rdn1cCoSWBkg7ZpmKhZMDy4zn/qt4AP87aBIPCJ2Ae4
         KJeoBCwkoJH14UA+RGX2etlrvTU0zu3t58spEFKGPt4d9cTQ7/+hi0YioBrLPzBH2+wm
         7olA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790783538; x=1791388338;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ONgd+iKteifBmehAVDANcjA1ry/HNokcEiZSh52shqw=;
        b=q6Xh6Deh/A1rhwbK9gqc56MqLrGU+kofDFGETvpF2wD+PUwkYhth6pcL7y3/pOxt/o
         KuLl38ZCrN6SInHy9R0daSEpREdX9AmFFWvGYdJn5wf+Eh3yZcZeSzTOAMSEGuYwnDyt
         JfE2hjcGP520h1MEkJAq/3/f/DwY1WYrwQhz72BHFWcU55fDP0wdMu87Dw/m0ubbPey9
         +NCr2iZrSSHDGXaUp1yt9oFxHtSaVzuehtq2s/SZKo0HQyJV7A9tyYuWw+ELihN9L8yz
         sEINxYL/Bfngoxo13naLzrmUmJwVV0R7c94fVmQAW8Z4P8kY/do/g+2W2rBble7kPcdp
         hqJA==
X-Gm-Message-State: AFq9FYKJdObP/GiG4HiIQ1o+QaUEDTq3fR/W9USE5gA2MHRB3I6GiwLe
	mAfVB4F4J11EE8F9UIH3CnyOgcM63yIwGDNj6A4SU7ALlh9rAq9ZppNNMHMUk3IlSOC3LXlliLK
	I4Q+slekJBSiC6iut44iI8AEBIwOOhYanIH2U9+/oSr0DDKHP+UDhxdJZqjW+kgE=
X-Gm-Gg: AYBFou1JFQOwlXJs9JSj6rRo9KCVxboLPyRZ922NyWdPc1CTBnfuJV2rnwUqrlMICDQ
	YIzjnFo8WFWlfRSBypxtk2LshoBJ1l2r59Wlnzy56n8DBqlzl5Ma7TNfH4mnfleDKH7WjVrUkWV
	7crVQOddqtRq51obk35rqxr00mk/HP1t65xyMQSKQE1I5EEWLSSCs+gLA5Ufbdz7VSssxGFLF+I
	bl7bIHepwwJBgR3DUFhLbgZB4DsNw0BfKtPVNWp8CnvvMhJoG7rKe50c3wDUyXjXe1hEZ7K7rcG
	xeOLcnCMwGTKCccq7R2dQrh5txcwMmMKMVlgC9/1WJ5QYwJjpaLqbT6YD8qHLOIns+HSUR8sAXv
	e7YCPqAJW+e/T8+69GNmqrT84Ue39UJou3qAB
X-Received: by 2002:a05:690e:812:20b0:675:4713:1f9b with SMTP id 956f58d0204a3-67683479223mr809706d50.39.1790783538303;
        Wed, 30 Sep 2026 08:52:18 -0700 (PDT)
X-Received: by 2002:a05:690e:812:20b0:675:4713:1f9b with SMTP id 956f58d0204a3-67683479223mr809692d50.39.1790783537698;
        Wed, 30 Sep 2026 08:52:17 -0700 (PDT)
Received: from loberman-thinkpadp16gen3.rmtusma.csb ([2600:6c65:2440:d8c:aa2b:ddff:fe88:da74])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-917a89aca2asm2593336d6.15.2026.09.30.08.52.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 08:52:15 -0700 (PDT)
Message-ID: <210356974e568b5453c540a955c16045aa79f106.camel@redhat.com>
Subject: Re:
From: Laurence Oberman <loberman@redhat.com>
To: "Pluess, Tobias" <tpluess@ieee.org>
Cc: linux-scsi@vger.kernel.org, sathya.prakash@broadcom.com, 
	sreekanth.reddy@broadcom.com, suganath-prabu.subramani@broadcom.com
Date: Wed, 30 Sep 2026 11:52:14 -0400
In-Reply-To: <40901345e474c45f531a9bc48ff9658d7bfe02aa.camel@redhat.com>
References: 
	<CAB4Wsm8AM3h19yLR26XQOtKX78ynQu-pC2H-gECvNtvJi58gwQ@mail.gmail.com>
		 <7132c7c54ac5f6716f3e82d3666dbef015eae419.camel@redhat.com>
		 <CAB4Wsm-HLX2haXvsq5CwnfpyxnzkCEnz__jGFh4_zr7RL78UZg@mail.gmail.com>
	 <40901345e474c45f531a9bc48ff9658d7bfe02aa.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2026-09-30 at 11:09 -0400, Laurence Oberman wrote:
> On Wed, 2026-09-30 at 10:09 +0200, Pluess, Tobias wrote:
> > Hello Laurence,
> > sorry for my late reply.
> > Thanks for looking into this. I will setup my system accordingly to
> > be
> > able to boot older versions. It will take a few days until I have
> > time
> > but I will report ASAP my findings.
> >=20
> > From inspecting my kernel update logs,
> >=20
> > zgrep -E "status installed .*kernel-" /var/log/dpkg.log.*
> >=20
> > I see that around that time when the error started occuring was
> > when
> > updating from 6.14 to 6.17 and later. So I would guess the
> > corresponding changes must have happened around that point. I'm not
> > 100% sure, but I will try booting the older kernels and will report
> > my
> > findings.
> >=20
> > Thanks!
> > greetings Tobias
> >=20
> > On Sat, Sep 26, 2026 at 2:30=E2=80=AFPM Laurence Oberman
> > <loberman@redhat.com> wrote:
> > >=20
> > > On Fri, 2026-09-25 at 21:00 +0200, Pluess, Tobias wrote:
> > > > Hi,
> > > >=20
> > > > I am seeing a problem with the mpt3sas driver when using an
> > > > LSI/Broadcom SAS9207-8e connected to an external tape drive (HP
> > > > Ultrium 6650).
> > > > This setup worked without issues with older kernels. I cannot
> > > > 100%
> > > > sure identify at which date the problem started to occur, but I
> > > > would
> > > > say it started to occur around April or May this year.
> > > >=20
> > > > What happens:
> > > > a) the external tape drive is connected to the HBA using a SAS
> > > > 8088
> > > > cable.
> > > > b) the tape drive is switched on and is detected normally and
> > > > works
> > > > as
> > > > expected, backups can be made.
> > > > c) after the backup finishes, the tape is ejected and the drive
> > > > is
> > > > idle, it is switched off.
> > > >=20
> > > > Here begins the interesting story. In the dmesg, I see the
> > > > following
> > > > errors:
> > > >=20
> > > > [Fri Sep 25 20:02:40 2026] mpt2sas_cm6: detecting:
> > > > handle(0x0009),
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 sas_address(0x50014380353cba70),
> > > > phy(3)
> > > > [Fri Sep 25 20:02:40 2026] mpt2sas_cm6: REPORT_LUNS:
> > > > handle(0x0009),
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 retries(0)
> > > > [Fri Sep 25 20:02:40 2026] TEST_UNIT_READY: handle(0x0009)
> > > > lun(0)
> > > > [Fri Sep 25 20:02:41 2026] mpt2sas_cm6: detecting:
> > > > handle(0x0009),
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 sas_address(0x50014380353cba70),
> > > > phy(3)
> > > > [Fri Sep 25 20:02:41 2026] mpt2sas_cm6: REPORT_LUNS:
> > > > handle(0x0009),
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 retries(0)
> > > > [Fri Sep 25 20:02:41 2026] TEST_UNIT_READY: handle(0x0009)
> > > > lun(0)
> > > > [Fri Sep 25 20:02:41 2026] START_UNIT: handle(0x0009), lun(0)
> > > > [Fri Sep 25 20:02:45 2026] TEST_UNIT_READY: handle(0x0009)
> > > > lun(0)
> > > > [Fri Sep 25 20:02:46 2026] mpt2sas_cm6: detecting:
> > > > handle(0x0009),
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 sas_address(0x50014380353cba70),
> > > > phy(3)
> > > > [Fri Sep 25 20:02:46 2026] mpt2sas_cm6: REPORT_LUNS:
> > > > handle(0x0009),
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 retries(0)
> > > > [Fri Sep 25 20:02:46 2026] TEST_UNIT_READY: handle(0x0009)
> > > > lun(0)
> > > > [Fri Sep 25 20:02:46 2026] START_UNIT: handle(0x0009), lun(0)
> > > > [Fri Sep 25 20:02:49 2026] TEST_UNIT_READY: handle(0x0009)
> > > > lun(0)
> > > > [Fri Sep 25 20:02:52 2026] mpt2sas_cm6: log_info(0x31130000):
> > > > originator(PL), code(0x13), sub_code(0x0000)
> > > > [Fri Sep 25 20:02:53 2026] mpt2sas_cm6: handle(0x0009),
> > > > ioc_status(0x0022) failure at
> > > > drivers/scsi/mpt3sas/mpt3sas_transport.c:228/_transport_set_ide
> > > > nt
> > > > ify(
> > > > )!
> > > > [Fri Sep 25 20:02:53 2026] mpt2sas_cm6: failure at
> > > > drivers/scsi/mpt3sas/mpt3sas_scsih.c:8407/_scsih_add_device()!
> > > > [Fri Sep 25 20:02:54 2026] mpt2sas_cm6: handle(0x0009),
> > > > ioc_status(0x0022) failure at
> > > > drivers/scsi/mpt3sas/mpt3sas_transport.c:228/_transport_set_ide
> > > > nt
> > > > ify(
> > > > )!
> > > > [Fri Sep 25 20:02:54 2026] mpt2sas_cm6: failure at
> > > > drivers/scsi/mpt3sas/mpt3sas_scsih.c:8407/_scsih_add_device()!
> > > > [Fri Sep 25 20:02:55 2026] mpt2sas_cm6: handle(0x0009),
> > > > ioc_status(0x0022) failure at
> > > > drivers/scsi/mpt3sas/mpt3sas_transport.c:228/_transport_set_ide
> > > > nt
> > > > ify(
> > > > )!
> > > >=20
> > > > Here, the last 2 lines are printed to dmesg approximately every
> > > > second, ad infinitum until the system is rebooted; the error
> > > > never
> > > > stops. I am certain this did not occur with older versions of
> > > > mpt3sas,
> > > > but as I said, I cannot pinpoint exactly when the change
> > > > happened.
> > > >=20
> > > > Powering up the tape drive again fixes the error, but as soon
> > > > as
> > > > the
> > > > tape drive is switched off again, the error reappears.
> > > >=20
> > > > However, the error doesn't occur every time the drive is
> > > > switched
> > > > off.
> > > > Sometimes the mpt3sas driver seems to be happy and no errors
> > > > are
> > > > reported. I think it has to do with some kind of timing, i.e.
> > > > in
> > > > which
> > > > internal state the mpt3sas driver is when the external drive is
> > > > disconnected.
> > > >=20
> > > > Hardware:
> > > > * Serial Attached SCSI controller: Broadcom / LSI SAS2308 PCI-
> > > > Express
> > > > Fusion-MPT SAS-2 (rev 05)
> > > > * external tape drive HP Ultrium 6650
> > > > * Linux pve0 7.0.14-12-pve #1 SMP PREEMPT_DYNAMIC PMX 7.0.14-12
> > > > (2026-08-11T11:05Z) x86_64 GNU/Linux
> > > > * mpt3sas
> > > >=20
> > > >=20
> > > > I wonder why this problem occurs and how it could be prevented.
> > > > I
> > > > have
> > > > to say, my hot swap HDDs are connected to
> > > >=20
> > > > Serial Attached SCSI controller: Broadcom / LSI SAS3416 Fusion-
> > > > MPT
> > > > Tri-Mode I/O Controller Chip (IOC) (rev 01)
> > > >=20
> > > > and here, I never have the issue, it only appears with the
> > > > 9207-
> > > > 8e.
> > > >=20
> > > > I made my own "fix" to stop the driver from filling up my dmesg
> > > > with
> > > > errors; using a little bash script with these commands
> > > >=20
> > > > echo "0000:51:00.0" > /sys/bus/pci/drivers/mpt3sas/unbind
> > > > echo "0000:51:00.0" > /sys/bus/pci/drivers/mpt3sas/bind
> > > >=20
> > > > resets the driver and it then stops printing errors. However I
> > > > think
> > > > this is not a true solution to the problem, it just fixes the
> > > > symptom.
> > > >=20
> > > >=20
> > > > Any ideas how to proceed?
> > > > Unfortunately I don't quickly have another system handy where I
> > > > could
> > > > test older versions of the driver.
> > > >=20
> > > > Thanks,
> > > > Greetings
> > > > Tobias
> > > >=20
> > >=20
> > > Hello
> > > Any chance you can boot an earlier set of kernels to try narrow
> > > down
> > > when this started. I don't have the older hardware to reproduce
> > > in
> > > our
> > > lab here. I will do some code inspection in the meantime to try
> > > figure
> > > out what triggers this and come up with some ideas.
> > >=20
> > > Would be good to know which version older kernel was not seeing
> > > this.
> > > Thanks
> > > Laurence
> > >=20
> Hi Tobias,
> Thanks, that version range helps. From code inspection, one possibly
> relevant change between 6.14 and 6.17 is:
> 37c4e72b0651 scsi: Fix sas_user_scan() to handle wildcard and multi-
> channel scans
> That changed SAS wildcard scan behavior so a scan may now cover more
> channels than before. It may only be exposing an existing mpt3sas
> stale-handle issue, but it could explain why the problem became
> visible
> now.
>=20
> Could you please test these if possible:
> v6.14
> v6.15
> v6.16
> v6.17
>=20
> The key thing is to find the first version where powering off the
> tape
> drive starts the repeated _transport_set_identify() /
> _scsih_add_device() messages.
>=20
> Also, while the messages are repeating, could you check whether
> anything is repeatedly rescanning SCSI hosts?
> grep -R "host.*/scan|/scan" /etc /usr/lib/systemd /lib/systemd
> /etc/udev /lib/udev 2>/dev/null
>=20
> If you are able to build/test a kernel with 37c4e72b0651 reverted,
> that
> would also be very useful.
>=20
> My current theory is that after the tape drive is powered off, the
> SAS2308/mpt3sas path may still have a stale device handle, and a
> wildcard scan keeps trying to add it again. The add then fails
> because
> the firmware no longer returns valid identify data for that handle.
>=20
> Thanks,
> Laurence


In my lab:

I have a sas3008 card connected direct to an Ultrium5

kernel running is 7.3.0-rc2+

[Wed Sep 30 11:46:27 2026] st 1:0:0:0: device_block, handle(0x0009)
[Wed Sep 30 11:46:28 2026] st 1:0:0:0: device_unblock and setting to
running, handle(0x0009)
[Wed Sep 30 11:46:28 2026] mpt3sas_cm0: mpt3sas_transport_port_remove:
removed: sas_addr(0x500110a001059994)
[Wed Sep 30 11:46:28 2026] mpt3sas_cm0: removing handle(0x0009),
sas_addr(0x500110a001059994)
[Wed Sep 30 11:46:28 2026] mpt3sas_cm0: enclosure logical
id(0x500605b0099087a0), slot(4)

Your log clearly shows the handle is stale and never properly removed
om poweroff


[Fri Sep 25 20:02:40 2026] mpt2sas_cm6: detecting: handle(0x0009),
                           sas_address(0x50014380353cba70), phy(3)
[Fri Sep 25 20:02:40 2026] mpt2sas_cm6: REPORT_LUNS: handle(0x0009),
                           retries(0)
[Fri Sep 25 20:02:40 2026] TEST_UNIT_READY: handle(0x0009) lun(0)
[Fri Sep 25 20:02:41 2026] mpt2sas_cm6: detecting: handle(0x0009),
                           sas_address(0x50014380353cba70), phy(3)

