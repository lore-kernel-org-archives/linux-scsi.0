Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CEF928E7
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jul 2025 06:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752732106; cv=none; b=bVW2jH4E/EcPVl28iMrFb/+Tk/EwHOKlI38rMvZQhFMF1K6F6nLRH4IVGaWOLXlWlEoXko6ptmgxQdHey6FiQNLtyorIW5v67JsDjtid9qsS68LYppW+OqHLfzEwD/QV84AmkwNVLrRzgFRwPEChtYqG0E3xjSogyfozuAxEx9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752732106; c=relaxed/simple;
	bh=5hEeTxJsJU/ZHd6Pf/I1t+fGsjEXaB++r8ME9XKCfv4=;
	h=From:To:In-Reply-To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:References; b=cwpRrVwfitOzUpgWrdjvb4VxPnsd19BatM4IbkIGvVqvQ7vCsYO7hoqizPabqAw6wrT2sfFkpr89UC1J3+aFNOIKL65/jcJaZ4ENoDb5EjqKwRKQK4lCt72EqwP6Vp1zUhzdTRspwDiM2a+1dnVe4uCB/Np6YegozVRFDWn1Wzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=IwccAlwE; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="IwccAlwE"
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250717060141epoutp02ad6d1e93e136a17c6d33b93f35e0cd8d~S9I9F_csM2722327223epoutp028
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jul 2025 06:01:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250717060141epoutp02ad6d1e93e136a17c6d33b93f35e0cd8d~S9I9F_csM2722327223epoutp028
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1752732101;
	bh=0tldANiOdNWoBj7tvWvQgDRv741iNeSyOMv6GnIgouU=;
	h=From:To:In-Reply-To:Subject:Date:References:From;
	b=IwccAlwEUR4H1TS9CiMsYK6kdOKvhXj0JSe8qwv7oF2Kt4pd1QptFR/OHhLp0prxC
	 0GQyCkhUXMnrUAJLQSAbFXZTfH+RZbvZTeoz+fABd+4mRo/UI0FfI7UkHR+roNaSVr
	 MJ/eDayw06bSoY7Gylui6IYCovHwz4F/Twl1vV1Q=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas1p2.samsung.com (KnoxPortal) with ESMTPS id
	20250717060140epcas1p255132d25b67f32047c010419c0563874~S9I8vNenz2275022750epcas1p2o;
	Thu, 17 Jul 2025 06:01:40 +0000 (GMT)
Received: from epcas1p3.samsung.com (unknown [182.195.36.222]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4bjMkX2VpDz3hhTB; Thu, 17 Jul
	2025 06:01:40 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas1p4.samsung.com (KnoxPortal) with ESMTPA id
	20250717060139epcas1p423dd0889993a9df6999c1def23db0e6d~S9I72Xns_2648926489epcas1p4o;
	Thu, 17 Jul 2025 06:01:39 +0000 (GMT)
Received: from sh043lee04 (unknown [10.253.101.72]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20250717060139epsmtip1810bfff8c98b0eda4ef2777539ab1fde~S9I7ynJIr2367723677epsmtip1W;
	Thu, 17 Jul 2025 06:01:39 +0000 (GMT)
From: "Seunghui Lee" <sh043.lee@samsung.com>
To: "'Bart Van Assche'" <bvanassche@acm.org>, "'Bean Huo'"
	<huobean@gmail.com>, <alim.akhtar@samsung.com>, <avri.altman@wdc.com>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>, <sdriver.sec@samsung.com>
In-Reply-To: <4080315d-4d90-433d-85e3-db5eef48bc90@acm.org>
Subject: RE: [PATCH] ufs: core: Use link recovery when the h8 exit failure
 during runtime resume
Date: Thu, 17 Jul 2025 15:01:39 +0900
Message-ID: <000001dbf6e0$43333c20$c999b460$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQH3aHPkcZ8xP3B7R0c5EXGU8cAQqgKwpSsnAUiyhkICOzcz6QJIvQEgAeA6CDICLTGocrOalZhQ
Content-Language: ko
X-CMS-MailID: 20250717060139epcas1p423dd0889993a9df6999c1def23db0e6d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
cpgsPolicy: CPGSC10-711,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250714090630epcas1p28ab8afec11bbab4d256dfe6649d3b00b
References: <CGME20250714090630epcas1p28ab8afec11bbab4d256dfe6649d3b00b@epcas1p2.samsung.com>
	<20250714090617.9212-1-sh043.lee@samsung.com>
	<b8fa773234058e68e6006127b3cd848046b75e6f.camel@gmail.com>
	<000901dbf52f$63a69090$2af3b1b0$@samsung.com>
	<cd0959939d2fefe927b66ca12620c094c4cfb7a2.camel@gmail.com>
	<005801dbf61f$7287e7d0$5797b770$@samsung.com>
	<4080315d-4d90-433d-85e3-db5eef48bc90@acm.org>

> Subject: Re: =5BPATCH=5D ufs: core: Use link recovery when the h8 exit fa=
ilure
> during runtime resume
>=20
>=20
> On 7/16/25 12:01 AM, Seunghui Lee wrote:
> > This issue arises from the race condition between the runtime pm
> > worker and the error handler worker.
>=20
> How could there be a race condition between the runtime PM code and UFS
> error handling? Runtime PM is disabled while UFS error handling is in
> progress by surrounding error handling with ufshcd_rpm_get_sync(hba) and
> ufshcd_rpm_put(hba).
>=20
> > I believe it would be safer to handle recovery within the runtime pm
> > worker itself.
> I do not agree. If runtime PM and the UFS error handler really happen in
> parallel, the proper way to fix this is by serializing both activities
> instead of introducing concurrent error handling.
>=20
> Thanks,
>=20
> Bart.


Even though adding ufshcd_rpm_get_sync(hba),ufshcd_rpm_put(hba) in ufshcd_e=
rr_handler,
the failure of ufshcd_wl_runtime_resume causes parent devices's runtime sus=
pend.

Here is the fault scenario more details.

1> runtime PM worker
2> err handler worker

1> sd 0:0:0:0: rpm_resume: rpmflags(0x2)
1> scsi target0:0:0: rpm_resume: rpmflags(0x0)
1> scsi host0: rpm_resume: rpmflags(0x0)
1> ufshcd-qcom 1d84000.ufshc: rpm_resume: rpmflags(0x0)
   -> enable irq, setup clocks on
1> ufshcd-qcom 1d84000.ufshc: rpm_resume: end. retval(0)
1> scsi host0: rpm_resume: end. retval(0)
1> scsi target0:0:0: rpm_resume: end. retval(0)
1> ufs_device_wlun 0:0:0:49488: rpm_resume: rpmflags(0x4)
1> __ufshcd_wl_resume: hibern8 exit failed -110
   -> set link broken, schedule error handler

	2> ufshcd_err_handler started; HBA state eh_fatal; powered 1; shutting dow=
n 0; saved_err =3D 0; saved_uic_err =3D 0; force_reset =3D 0; link is broke=
n
	   ufshcd_err_handling_prepare()
	   ufshcd_rpm_get_sync()	// hba->ufs_device_wlun->sdev_gendev
	   -> sdev_gendev is suspended

1> ufs_device_wlun 0:0:0:49488: ufshcd_wl_runtime_resume failed: -110
   -> sync wl_runtime_resume here, but set dev->power.runtime_error.
1> ufs_device_wlun 0:0:0:49488: rpm_resume: end. retval(-110)	// hba->ufs_d=
evice_wlun->sdev_gendev
1> sd 0:0:0:0: rpm_resume: end. retval(-110)
   -> Due to the child device PM operation error, PM operation invokes runt=
ime suspend.

1> scsi target0:0:0: rpm_suspend: rpmflags(0xa)
1> scsi target0:0:0: rpm_suspend: end. retval(0)
1> scsi host0: rpm_suspend: rpmflags(0xa)
1> scsi host0: rpm_suspend: end. retval(0)
1> ufshcd-qcom 1d84000.ufshc: rpm_suspend: rpmflags(0xa)
1> ufshcd-qcom 1d84000.ufshc: rpm_suspend: end. retval(0)	// hba->dev
   -> disable irq, setup clocks off

	2> ufshcd_err_handling_prepare()
	   ufshcd_enable_irq(), ufshcd_setup_clocks( , on)
	2> ufshcd_reset_and_restore()
	2> ufshcd_recover_pm_error()
	   pm_runtime_set_active(&hba->ufs_device_wlun->sdev_gendev)
	   -> ret error due to scsi target0:0:0 is suspended.
	   pm_runtime_set_active(hba->dev)
	   -> rev error due to dev->power.runtime_error.
	   -> Due to the upper errors, host can't invoke pm_request_resume any mor=
e.

