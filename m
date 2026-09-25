Received: from mail-yx2-f42.google.com (mail-yx2-f42.google.com [74.125.224.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F45E31F98D
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 19:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790362827; cv=pass; b=upmqOvZvDUImVtqYkwL52KR1ljt24+anrnXqGMh1Szz9H18P9JTZM59Tm4OPuun+cfAAl02a0n1BnxGTu6LRCB6AxUFN3qer9K7Cq6NbX3/Yd/kkUFCdu0aLqzTnMYj8vz/RVhB5uywew0A29mI/m+FZhrX/je3C6mFKO0A8BKk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790362827; c=relaxed/simple;
	bh=IBS//BdClcbt4jjfSzDHkVQw0yjeipX8TTaDpnjc8l0=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=T1072mfSYA53FkeaSO6ZbG+C4wzh9qYxYkqccOBOACs47iTFQ5Wo2+2mkeCn1khIvQnjjyqgHYmYTLCO5Zild6QeIMEdR9jvvgcSWSf/EC3K+NNG1xBT3poMM77T2Kyan/K3/FwC9fBw5qv79C4ITpXw4I3pC5lV0RuqdBwHk/A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ieee.org; spf=pass smtp.mailfrom=ieee.org; dkim=pass (1024-bit key) header.d=ieee.org header.i=@ieee.org header.b=TaaxFaTQ; arc=pass smtp.client-ip=74.125.224.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ieee.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ieee.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ieee.org header.i=@ieee.org header.b="TaaxFaTQ"
Received: by mail-yx2-f42.google.com with SMTP id 956f58d0204a3-672ce86b21aso1511962d50.3
        for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 12:00:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790362824; cv=none;
        d=google.com; s=arc-20260327;
        b=A3b1gj4GiZ7v/3a9xetMRtkItZaaQKsycB6xucS2IzwmV4W9WHN+klIrqi+NqbBq9O
         1hzCCTqJQXc6ewTpfJZ2+GFMRX7ssHD28+Dtww9RkNaEWXOje/8AxoY7AW8LlBAfVIVJ
         gSY0owC0xZYIoTYMH3tuBF6s8FtOn4s90J06cOJOzcOfGRnJXkFamIb2qIBHikD476uU
         jg9FNLbQdfOtzXqQ+pD1JewE790e/BAEkGjxNuIBWTpzIuY+fIQcSQrm86ezgQYjtrYl
         m+6QsgtqOmG382PBOhez8IKjCxKty+5HqVSkKWQUcC+R+KMi7ramSqCP7YcLruWrtLCe
         gc/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=XNEuaj3C2zPyx4uLD/ycI3R+udOOhjmo0BFRM3k7mn0=;
        fh=+01239l+IJZgpVKKeQa7ZplxXT4xsrN+ZDxGe+Bec8E=;
        b=epm2lPJqugFhSg3XLhxl4UxNsjTvXHGcOkv/tfMTsE19mgRxXs4S9sEE47dYKTi670
         c9ehN5zt64+DcBdq5yl+JRuyPHR1hFtetlo9AFUW5tjNaDxzLUeWrN5uYJptHn4f/zNT
         dCq8UUBOXRVRdgU0/kifOO3YL3baWhEaFm9cBzkkRMML1oiGfe/kkEGzoaUlG/fILfvo
         2emAiCP+r2RER4cVsvHQIBIbWwOJl5ipFH/XlToj0puSCMkF0va+ssFTDY81E7kOJ3Th
         caouL+y4453Gh5ufj218K/k2kT9B/ckk6FMUdxNOanxy8ipUWz1udpt3vn8n6LHOYAqY
         ITlw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google; t=1790362824; x=1790967624; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XNEuaj3C2zPyx4uLD/ycI3R+udOOhjmo0BFRM3k7mn0=;
        b=TaaxFaTQz1kF5uG2jqXhatuZMloPwy1NklwLO3XEMBIRNv5eI6hsrtg/tNJoD2h9l1
         bz1wbJoLHSkzDBfR8yKC5NkgNDqdRf4Gv7pBE9Rk5swoJ6mzqSFkvz5NK+d+rKD2bcCV
         g3hx1igajAVIJF0oyYHn0LarVBls2mxDTPhxQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790362824; x=1790967624;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=XNEuaj3C2zPyx4uLD/ycI3R+udOOhjmo0BFRM3k7mn0=;
        b=PcbpoNjWhYB2N7+aya9oAfJ1JYys7TDe+yp20AeCT3wyhE8c+lfAn4Qma1/emUz4pe
         7luNy9cV7yTcUazYka6wbSRZgK2/Nw7CtBgQqpOaxqt2sDJ7nnTFOK5HAim9hjJhS8kV
         mwwyigoPZRAgu1TR6hbBXWyIe17cq5Hn7fk9kD8F6IgtwOUEXOw+1AIXHV3GuqtTVrDy
         GUIuyNjniXQtDFOOp8NwOkzVEFlltGZBFIO7ZqXhLdxfGhpPUVrC95AAirCBg42zM7DZ
         kTSJOaqz5vAPIS9qeMd8qLAvUzfaNjIra9WX38DPHnbTUuxXE8Q7UnEetlJCjMZdhxty
         ybnQ==
X-Gm-Message-State: AFuF++nAw6RfrKUdvgUlPTbiMg9RAZ8rkIxtgQ600WD8kZ1zCET9U6Dy
	kpyJiCpMRHGDE/nEDHLCCozUySZfiQQo9oVHcAPzPJUTU5lNO4odKfKtiL3wZIQJxlohtUValVu
	GmK8wrjsk06dplBWii4NPnqFG4w40YHuV7hmslSnzIuxX4a5GN6o+W7yPD4w=
X-Gm-Gg: AYBFou1cRnlzaz7QtJTiDNGBsBAIUIHkLIbeMyHknPq0ZrxxtyzxfxbyoEsf/FYKPBE
	dvRX5iOhDJ6QhQn4csqTvFiK7+44/NmlEbRdXCDgwrfda+MF4fuS8GS0PkiF9g2G51UqRtWyco0
	XU+//wm0wNzjrTvu8PEjarc5+PXet0z1pPftaQMHNDZLB/klOyJoFlS8rufQUraGr/x1MNRxpZL
	iFEbFmtWT93wbsR2m2468vKwnwWvkdSir3WeFX6NsZYQxvW5t9pkDlZE6dUCHmJlazQBdMoziyG
	cP4phgmcwtNl4ZMa2szAfx0c67rnAnCNz9fRZMBonSaECZZTFKXHAJVGinDiiRoaraOgY8bSijj
	n1DQzGM90+R7HqlAXwyR2SuyDn79SIMjddzekFgRWr0hq8JMo/azXxmxcJqyEeOOC8iGNJtfB/U
	V7T1OMwnUm4w+xb8x3pc9jObx2KXvIHA==
X-Received: by 2002:a05:690e:d0a:b0:674:9cc:4127 with SMTP id
 956f58d0204a3-67411464979mr803543d50.140.1790362824087; Fri, 25 Sep 2026
 12:00:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "Pluess, Tobias" <tpluess@ieee.org>
Date: Fri, 25 Sep 2026 21:00:12 +0200
X-Gm-Features: AclHuK8dbhumSL3Zpeq8yQjRveVvf292Gh3anihlZ17P8f90AM2x-jEInxBllx8
Message-ID: <CAB4Wsm8AM3h19yLR26XQOtKX78ynQu-pC2H-gECvNtvJi58gwQ@mail.gmail.com>
Subject: 
To: linux-scsi@vger.kernel.org
Cc: sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com, 
	suganath-prabu.subramani@broadcom.com
Content-Type: text/plain; charset="UTF-8"

Hi,

I am seeing a problem with the mpt3sas driver when using an
LSI/Broadcom SAS9207-8e connected to an external tape drive (HP
Ultrium 6650).
This setup worked without issues with older kernels. I cannot 100%
sure identify at which date the problem started to occur, but I would
say it started to occur around April or May this year.

What happens:
a) the external tape drive is connected to the HBA using a SAS 8088 cable.
b) the tape drive is switched on and is detected normally and works as
expected, backups can be made.
c) after the backup finishes, the tape is ejected and the drive is
idle, it is switched off.

Here begins the interesting story. In the dmesg, I see the following errors:

[Fri Sep 25 20:02:40 2026] mpt2sas_cm6: detecting: handle(0x0009),
                           sas_address(0x50014380353cba70), phy(3)
[Fri Sep 25 20:02:40 2026] mpt2sas_cm6: REPORT_LUNS: handle(0x0009),
                           retries(0)
[Fri Sep 25 20:02:40 2026] TEST_UNIT_READY: handle(0x0009) lun(0)
[Fri Sep 25 20:02:41 2026] mpt2sas_cm6: detecting: handle(0x0009),
                           sas_address(0x50014380353cba70), phy(3)
[Fri Sep 25 20:02:41 2026] mpt2sas_cm6: REPORT_LUNS: handle(0x0009),
                           retries(0)
[Fri Sep 25 20:02:41 2026] TEST_UNIT_READY: handle(0x0009) lun(0)
[Fri Sep 25 20:02:41 2026] START_UNIT: handle(0x0009), lun(0)
[Fri Sep 25 20:02:45 2026] TEST_UNIT_READY: handle(0x0009) lun(0)
[Fri Sep 25 20:02:46 2026] mpt2sas_cm6: detecting: handle(0x0009),
                           sas_address(0x50014380353cba70), phy(3)
[Fri Sep 25 20:02:46 2026] mpt2sas_cm6: REPORT_LUNS: handle(0x0009),
                           retries(0)
[Fri Sep 25 20:02:46 2026] TEST_UNIT_READY: handle(0x0009) lun(0)
[Fri Sep 25 20:02:46 2026] START_UNIT: handle(0x0009), lun(0)
[Fri Sep 25 20:02:49 2026] TEST_UNIT_READY: handle(0x0009) lun(0)
[Fri Sep 25 20:02:52 2026] mpt2sas_cm6: log_info(0x31130000):
originator(PL), code(0x13), sub_code(0x0000)
[Fri Sep 25 20:02:53 2026] mpt2sas_cm6: handle(0x0009),
ioc_status(0x0022) failure at
drivers/scsi/mpt3sas/mpt3sas_transport.c:228/_transport_set_identify()!
[Fri Sep 25 20:02:53 2026] mpt2sas_cm6: failure at
drivers/scsi/mpt3sas/mpt3sas_scsih.c:8407/_scsih_add_device()!
[Fri Sep 25 20:02:54 2026] mpt2sas_cm6: handle(0x0009),
ioc_status(0x0022) failure at
drivers/scsi/mpt3sas/mpt3sas_transport.c:228/_transport_set_identify()!
[Fri Sep 25 20:02:54 2026] mpt2sas_cm6: failure at
drivers/scsi/mpt3sas/mpt3sas_scsih.c:8407/_scsih_add_device()!
[Fri Sep 25 20:02:55 2026] mpt2sas_cm6: handle(0x0009),
ioc_status(0x0022) failure at
drivers/scsi/mpt3sas/mpt3sas_transport.c:228/_transport_set_identify()!

Here, the last 2 lines are printed to dmesg approximately every
second, ad infinitum until the system is rebooted; the error never
stops. I am certain this did not occur with older versions of mpt3sas,
but as I said, I cannot pinpoint exactly when the change happened.

Powering up the tape drive again fixes the error, but as soon as the
tape drive is switched off again, the error reappears.

However, the error doesn't occur every time the drive is switched off.
Sometimes the mpt3sas driver seems to be happy and no errors are
reported. I think it has to do with some kind of timing, i.e. in which
internal state the mpt3sas driver is when the external drive is
disconnected.

Hardware:
* Serial Attached SCSI controller: Broadcom / LSI SAS2308 PCI-Express
Fusion-MPT SAS-2 (rev 05)
* external tape drive HP Ultrium 6650
* Linux pve0 7.0.14-12-pve #1 SMP PREEMPT_DYNAMIC PMX 7.0.14-12
(2026-08-11T11:05Z) x86_64 GNU/Linux
* mpt3sas


I wonder why this problem occurs and how it could be prevented. I have
to say, my hot swap HDDs are connected to

Serial Attached SCSI controller: Broadcom / LSI SAS3416 Fusion-MPT
Tri-Mode I/O Controller Chip (IOC) (rev 01)

and here, I never have the issue, it only appears with the 9207-8e.

I made my own "fix" to stop the driver from filling up my dmesg with
errors; using a little bash script with these commands

echo "0000:51:00.0" > /sys/bus/pci/drivers/mpt3sas/unbind
echo "0000:51:00.0" > /sys/bus/pci/drivers/mpt3sas/bind

resets the driver and it then stops printing errors. However I think
this is not a true solution to the problem, it just fixes the symptom.


Any ideas how to proceed?
Unfortunately I don't quickly have another system handy where I could
test older versions of the driver.

Thanks,
Greetings
Tobias
