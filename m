Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C623C191F91
	for <linux-scsi@vger.kernel.org>; Fri, 18 Jul 2025 06:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752821976; cv=none; b=OrbKKT9Z18wmh4swWGJMvcpgDFU+4L5Zh2QOuQEhU/xb9UvaIxOXpH7pFAVh4bXy47pfuXOWx9PLReMagnSb9EKGMOpreZstLcoKohKr1ldl9KU6QfhKk+Iefc8Kj8ZiGQC2J8109cFbPKeA+GOMfVREKFze0ys8G4dkMt63Nrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752821976; c=relaxed/simple;
	bh=VVv8bUjuizjQTqKtBbVLo6PX03c9jmHMKzceqBx6Aho=;
	h=From:To:In-Reply-To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:References; b=Yqs5ZC2KK78z70tHzyHXID69cdvi0h/zanzeF3wJwaxQ/jCCgJPr+aS27CnzabB9eWso0bUZNg7BpR5le8/C7zBZ405PifHIMcyKYX3zxSAmdL3jjeVjd/q3yJsAQ7mff230ovK6j5Mr42IF1i+N/y5yggRxwKX3hev9gYPaomA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Lv81SI4J; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Lv81SI4J"
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250718065931epoutp014edbc1efa82754399a5a95627fe9475d~TRkvfPC_f0664806648epoutp01d
	for <linux-scsi@vger.kernel.org>; Fri, 18 Jul 2025 06:59:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250718065931epoutp014edbc1efa82754399a5a95627fe9475d~TRkvfPC_f0664806648epoutp01d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1752821971;
	bh=jOmwYmthexibsqK4/+J+LRPyQZze0KHjrKlRRRPSnpE=;
	h=From:To:In-Reply-To:Subject:Date:References:From;
	b=Lv81SI4JjewOI8y3lWBTmk07DQSSExcnM3VUahynMP0lt+QRJbJMepXJIAC6kipfJ
	 1mqiuCRlQSVFXsXVCNVDerGPV3IH5Q67rUiGrGb8qRflIdsGLySmInpKoKpXo843vL
	 vaZm/WGqm6v1zWGtE3jrZtWA3wVgC5+evjpcd0OQ=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas1p1.samsung.com (KnoxPortal) with ESMTPS id
	20250718065930epcas1p166233541bcf7bc05c1290a64f4e6c3df~TRku2_gaa2589125891epcas1p1Q;
	Fri, 18 Jul 2025 06:59:30 +0000 (GMT)
Received: from epcas1p4.samsung.com (unknown [182.195.38.241]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4bk0yp3n8Yz2SSKd; Fri, 18 Jul
	2025 06:59:30 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20250718065929epcas1p1a635ab6fe47253d9a72913f0e6f4afba~TRktoV2Rv2840428404epcas1p1S;
	Fri, 18 Jul 2025 06:59:29 +0000 (GMT)
Received: from sh043lee04 (unknown [10.253.101.72]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20250718065929epsmtip23ad10baab04ca6a10d9f3291c919d230~TRktkJVme3249832498epsmtip2Y;
	Fri, 18 Jul 2025 06:59:29 +0000 (GMT)
From: "Seunghui Lee" <sh043.lee@samsung.com>
To: "'Bart Van Assche'" <bvanassche@acm.org>, <alim.akhtar@samsung.com>,
	<avri.altman@wdc.com>, <James.Bottomley@HansenPartnership.com>,
	<martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
	<sdriver.sec@samsung.com>
In-Reply-To: <2743ce40-72fa-4c87-a2cc-528b51418aec@acm.org>
Subject: RE: [PATCH v2] ufs: core: Use link recovery when the h8 exit
 failure during runtime resume
Date: Fri, 18 Jul 2025 15:59:29 +0900
Message-ID: <000401dbf7b1$81b61ef0$85225cd0$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQIyfnsb3T5DgEG2NsXoDWpt/ecQsQK7vKXIAfscmgOzZK698A==
Content-Language: ko
X-CMS-MailID: 20250718065929epcas1p1a635ab6fe47253d9a72913f0e6f4afba
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
cpgsPolicy: CPGSC10-711,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250717081220epcas1p224952b344389e4967beb893297f1ae02
References: <CGME20250717081220epcas1p224952b344389e4967beb893297f1ae02@epcas1p2.samsung.com>
	<20250717081213.6811-1-sh043.lee@samsung.com>
	<2743ce40-72fa-4c87-a2cc-528b51418aec@acm.org>

> On 7/17/25 1:12 AM, Seunghui Lee wrote:
> > If the h8 exit fails during runtime resume process, the runtime thread
> > enters runtime suspend immediately and the error handler operates at
> > the same time.
> > It becomes stuck and cannot be recovered through the error handler.
> > To fix this, use link recovery instead of the error handler.
> >
> > Fixes: 4db7a2360597 (=22scsi: ufs: Fix concurrency of error handler and
> > other error recovery paths=22)
> > Signed-off-by: Seunghui Lee <sh043.lee=40samsung.com>
> > ---
> > Changes from v1:
> >   * Add the Fixes tag as Beanhuo's requested.
> > ---
> >   drivers/ufs/core/ufshcd.c =7C 10 +++++++++-
> >   1 file changed, 9 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> > index 50adfb8b335b..dc2845c32d72 100644
> > --- a/drivers/ufs/core/ufshcd.c
> > +++ b/drivers/ufs/core/ufshcd.c
> > =40=40 -4340,7 +4340,7 =40=40 static int ufshcd_uic_pwr_ctrl(struct ufs=
_hba *hba,
> struct uic_command *cmd)
> >   	hba->uic_async_done =3D NULL;
> >   	if (reenable_intr)
> >   		ufshcd_enable_intr(hba, UIC_COMMAND_COMPL);
> > -	if (ret) =7B
> > +	if (ret && =21hba->pm_op_in_progress) =7B
> >   		ufshcd_set_link_broken(hba);
> >   		ufshcd_schedule_eh_work(hba);
> >   	=7D
> > =40=40 -4348,6 +4348,14 =40=40 static int ufshcd_uic_pwr_ctrl(struct uf=
s_hba
> *hba, struct uic_command *cmd)
> >   	spin_unlock_irqrestore(hba->host->host_lock, flags);
> >   	mutex_unlock(&hba->uic_cmd_mutex);
> >
> > +	/*
> > +	 * If the h8 exit fails during the runtime resume process,
> > +	 * it becomes stuck and cannot be recovered through the error
> handler.
> > +	 * To fix this, use link recovery instead of the error handler.
> > +	 */
> > +	if (ret && hba->pm_op_in_progress)
> > +		ret =3D ufshcd_link_recovery(hba);
> > +
> >   	return ret;
> >   =7D
>=20
> There are multiple calls to ufshcd_uic_pwr_ctrl() from outside the runtim=
e
> power management callbacks. Hence, hba->pm_op_in_progress may be changed
> from another thread while ufshcd_uic_pwr_ctrl() is in progress. Hence,
> ufshcd_uic_pwr_ctrl() calls from outside runtime power management
> callbacks should be serialized against these callbacks, e.g.
> by surrounding these calls with pm_runtime_get_sync() and pm_runtime_put(=
).
>=20
> Thanks,
>=20
> Bart.

Hi Bart,

Thank you for your opinion.
I understand what you're concerned about.

I've checked multiple calls to ufshcd_uic_pwr_ctrl().
I think that follow cases looks okay.
(using rpm get/put, init sequence, synchronize with PM operation sequence)
Do you have any better idea to cover this issue?

1. ufshcd_send_bsg_uic_cmd()
ufs_bsg_request()	// using rpm get sync, put

2. __ufshcd_wl_suspend() / __ufshcd_wl_resume()	// runtime sequence

3. ufshcd_change_pwr_mode()
ufshcd_dme_get_attr()
	ufshcd_get_max_pwr_mode() from ufshcd_device_init()	// init
	ufshcd_disable_tx_lcc() from ufshcd_link_startup()	// init
	ufshcd_is_pwr_mode_restore_needed() from ufshcd_err_handler()	// using rpm=
 get sync, put
	ufshcd_quirk_tune_host_pa_tactivate()	// init
	ufshcd_quirk_override_pa_h8time()		// init
ufshcd_config_pwr_mode()
	ufschd_scale_gear()	// synchronize with __ufshcd_wl_resume() / __ufshcd_wl=
_suspend()
	ufschd_err_handler()	// using rpm get sync, put
	ufshcd_post_device_init()	// init

