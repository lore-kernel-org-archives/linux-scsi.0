Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62433C2FD
	for <linux-scsi@vger.kernel.org>; Tue, 24 Sep 2024 02:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727144242; cv=none; b=sg4Pco+PaOtJKsgcYU3UFbzEEawIcDB7OmmJMl1cNrhfXKud2CIyNcQzQEwen+ZThfuM7b7dx2L7+W3jPnBgGD7VicRuWZXOwd54DHI8tW33piwVKRI2afmB8Cz6erxmhnV6U0H+S9pWAtVwB23XHxzP6oIiXOjkQu1wm8KLfgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727144242; c=relaxed/simple;
	bh=/98/X/1TQko0fk2o2qTQZdODpUNx9qGthglVwr99660=;
	h=From:To:Cc:In-Reply-To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:References; b=DLOMNWXQATqwejS9dmqVRHbGSaLWouoUVpW7tlLLjkLj6seGwIVySQPkoAYpDBICQpZS6uukF/USqS2e5gjkkInIj+r7Fw1d/xraCPiu533GslZSwvDhV3cXTkVdmmg3SEkwNLSBSnz8kvS0p+llUuRQ06ViwBqbYBJHipdyOPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=DkYWqHwS; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="DkYWqHwS"
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240924021717epoutp0443518eafc1d6e4f7cef1f179289b2485~4DIhtixu61146211462epoutp04E
	for <linux-scsi@vger.kernel.org>; Tue, 24 Sep 2024 02:17:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240924021717epoutp0443518eafc1d6e4f7cef1f179289b2485~4DIhtixu61146211462epoutp04E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1727144237;
	bh=0qkUJwYUsUzYOS/o+iFENz/vUnaM4sHEQ79KnQB9MKs=;
	h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
	b=DkYWqHwSicTgPenw9k42Ybe++5SxPENvXodkL1PU26VLYyj+6NDsi4GApxcR6pWWt
	 bjNDZ6771+vItbizmRLNQWJYuATY5ydyLfdT05kjBS53S8gihEv04pDp2aefF3YoaM
	 MSGhujsrTQvNDHdaU4Ofj7lc72yJacbpvVa2+RdI=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas1p3.samsung.com (KnoxPortal) with ESMTP id
	20240924021716epcas1p35c5ef8acbf0f00700000239ece6ea1db~4DIhMfgL70485904859epcas1p3D;
	Tue, 24 Sep 2024 02:17:16 +0000 (GMT)
Received: from epsmges1p4.samsung.com (unknown [182.195.36.225]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4XCNmD22YXz4x9Pv; Tue, 24 Sep
	2024 02:17:16 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
	epsmges1p4.samsung.com (Symantec Messaging Gateway) with SMTP id
	D6.1E.10258.C2122F66; Tue, 24 Sep 2024 11:17:16 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20240924021715epcas1p1a9fdb7ead8080969f615ba755534fe21~4DIgTep1Q1634116341epcas1p1x;
	Tue, 24 Sep 2024 02:17:15 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240924021715epsmtrp1e1b22bf58674c4e45857ed62aef0884a~4DIgSf6ML1087310873epsmtrp1r;
	Tue, 24 Sep 2024 02:17:15 +0000 (GMT)
X-AuditID: b6c32a38-995ff70000002812-80-66f2212c80d2
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	1C.13.07567.B2122F66; Tue, 24 Sep 2024 11:17:15 +0900 (KST)
Received: from sh8267baek02 (unknown [10.253.99.49]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20240924021715epsmtip229b2252294dc4a3f9965fb57c2a6076b~4DIgEW9z02569525695epsmtip28;
	Tue, 24 Sep 2024 02:17:15 +0000 (GMT)
From: "Seunghwan Baek" <sh8267.baek@samsung.com>
To: "'Bart Van Assche'" <bvanassche@acm.org>,
	<linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
	<martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>,
	<avri.altman@wdc.com>, <alim.akhtar@samsung.com>
Cc: <grant.jung@samsung.com>, <jt77.jang@samsung.com>,
	<junwoo80.lee@samsung.com>, <dh0421.hwang@samsung.com>,
	<jangsub.yi@samsung.com>, <sh043.lee@samsung.com>, <cw9316.lee@samsung.com>,
	<wkon.kim@samsung.com>, <stable@vger.kernel.org>
In-Reply-To: <fa8a4c1a-e583-496b-a0a2-bd86f86af508@acm.org>
Subject: RE: [PATCH v1 1/1] ufs: core: set SDEV_OFFLINE when ufs shutdown.
Date: Tue, 24 Sep 2024 11:17:15 +0900
Message-ID: <003201db0e27$df93f250$9ebbd6f0$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQITd6wvsWq6bg+5ypABxh1kBxxfMwHy7pIVAtyJc3gCDAIdK7G+gjWA
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFJsWRmVeSWpSXmKPExsWy7bCmnq6O4qc0gw03eCwezNvGZvHy51U2
	i2kffjJbzDjVxmqx79pJdotff9ezW2zs57Do2DqZyWLH8zPsFrv+NjNZXN41h82i+/oONovl
	x/8xWTT92cdisWDjI0aLzZe+sTgIeFy+4u0xbdIpNo+PT2+xePRtWcXo8XmTnEf7gW6mALao
	bJuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoLOVFMoS
	c0qBQgGJxcVK+nY2RfmlJakKGfnFJbZKqQUpOQVmBXrFibnFpXnpenmpJVaGBgZGpkCFCdkZ
	8+8+Zy3YJ1mx5v9dlgbG5SJdjJwcEgImEm2HpzF3MXJxCAnsYJR4/fsGO4TziVHi/LN/jBDO
	N0aJQ9c6WWFaDi6bAZXYyyjROOUZG4TzklFiydVbbCBVbAIGEs0/DoLNEgFJ7NhynQXEYQYZ
	vOXPMRaQKk4Ba4mF2+4xgdjCAl4SP7adALNZBFQl3t/5wQxi8wpYShx6tRHKFpQ4OfMJWC+z
	gLbEsoWvmSFuUpD4+XQZ2H0iAm4Sb2dNZYaoEZGY3dkG9p6EwAMOidWX5gE1cwA5LhJ/XqhC
	9ApLvDq+hR3ClpJ42d8GZRdLLNw4iQWit4VR4vryP4wQCXuJ5tZmNpA5zAKaEut36UPs4pN4
	97WHFWI8r0RHmxBEtarEqQ1boTqlJa43N0CD0UNi47r9zBMYFWch+WwWks9mIflgFsKyBYws
	qxjFUguKc9NTiw0LTODxnZyfu4kRnKi1LHYwzn37Qe8QIxMH4yFGCQ5mJRHeSTc/pgnxpiRW
	VqUW5ccXleakFh9iNAWG9URmKdHkfGCuyCuJNzSxNDAxMzKxMLY0NlMS5z1zpSxVSCA9sSQ1
	OzW1ILUIpo+Jg1OqgamKwUVc6cfjaZESH3WufbDzqd1cOeXH28WFvW23ZLcdusN0K2Gpm9Hm
	/omRgTviF/eumXWuVZXBScirlu3MycvqWZuSrz6Y35sf1nPrlLdDVvrdjf5qQpf1jyjN0J50
	hGHWa27jFSYXw5afbZjyo+pCTcju/V1zUlXv3Xlx8RTrMq3f/SZrTHYfvK94/6LC6/0X1Xe4
	V8j87u2bYjN76Y5sxuVvJprarbnvI7ziR8P1RL9/xvc/Lf13g5+9YsGNRXHPftofMJn8OK37
	s3zfhA8lvtq+/y5oZ2/kepZ1IvnU273z5FuXunMqtia0vFuzTOjqOoNfj72nNLv7SoY0LQpw
	vS02ud+fr4slc+H+hlXTlViKMxINtZiLihMBisOeSF0EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsWy7bCSvK624qc0g20LlC0ezNvGZvHy51U2
	i2kffjJbzDjVxmqx79pJdotff9ezW2zs57Do2DqZyWLH8zPsFrv+NjNZXN41h82i+/oONovl
	x/8xWTT92cdisWDjI0aLzZe+sTgIeFy+4u0xbdIpNo+PT2+xePRtWcXo8XmTnEf7gW6mALYo
	LpuU1JzMstQifbsEroyla/rYC5olKw4tX8XUwPhOuIuRk0NCwETi4LIZjF2MXBxCArsZJfav
	3MIOkZCWeHzgJVCCA8gWljh8uBii5jmjxIa+72A1bAIGEs0/DrKDJEQE3jNKHP+zDsxhFvjD
	KDHn3GQ2iJY3jBKPpuxgAWnhFLCWWLjtHhOILSzgJfFj2wkwm0VAVeL9nR/MIDavgKXEoVcb
	oWxBiZMzn4D1MgtoS/Q+bGWEsZctfM0McaqCxM+ny1hBbBEBN4m3s6YyQ9SISMzubGOewCg8
	C8moWUhGzUIyahaSlgWMLKsYJVMLinPTc5MNCwzzUsv1ihNzi0vz0vWS83M3MYJjVktjB+O9
	+f/0DjEycTAeYpTgYFYS4Z1082OaEG9KYmVValF+fFFpTmrxIUZpDhYlcV7DGbNThATSE0tS
	s1NTC1KLYLJMHJxSDUx33He9mSZ3ui/a4eait+dtDCdf97XQOPjn3tUfPBcP/ynVyOTdN73v
	xYvPD/vyso7KJfeXBtVuU76+6eXauw3vpzz0zIvwEZ/XJs/flfM4tlwwyIJ/X+GWTS83GzGs
	THfzOf3CLt784qEai0tHOeKzzsjvF5qzo+a95O3P9/Udd6nptD442iGumq9TW5q5InqD1krR
	P4JrLNfbru9wLXOZ3vW1NbRN5XHJmT3P5IWbF26Yqh5s6nZUmdue4egkN78J+/N2d6zor/JI
	OlZts/1/+ob7JZflQvcoTI/X22cWenHd/Tqd4xvY2s2fXovy/PX3dN1Pte7dl+7bKua0yGwI
	yXn45uiniR2W7knqPXlKLMUZiYZazEXFiQBl8ulbSAMAAA==
X-CMS-MailID: 20240924021715epcas1p1a9fdb7ead8080969f615ba755534fe21
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240829093921epcas1p35d28696b0f79e2ae39d8e3690f088e64
References: <20240829093913.6282-1-sh8267.baek@samsung.com>
	<CGME20240829093921epcas1p35d28696b0f79e2ae39d8e3690f088e64@epcas1p3.samsung.com>
	<20240829093913.6282-2-sh8267.baek@samsung.com>
	<fa8a4c1a-e583-496b-a0a2-bd86f86af508@acm.org>

> On 8/29/24 2:39 AM, Seunghwan Baek wrote:
> > diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> > index a6f818cdef0e..4ac1492787c2 100644
> > --- a/drivers/ufs/core/ufshcd.c
> > +++ b/drivers/ufs/core/ufshcd.c
> > =40=40 -10215,7 +10215,9 =40=40 static void ufshcd_wl_shutdown(struct d=
evice
> *dev)
> >   	shost_for_each_device(sdev, hba->host) =7B
> >   		if (sdev =3D=3D hba->ufs_device_wlun)
> >   			continue;
> > -		scsi_device_quiesce(sdev);
> > +		mutex_lock(&sdev->state_mutex);
> > +		scsi_device_set_state(sdev, SDEV_OFFLINE);
> > +		mutex_unlock(&sdev->state_mutex);
> >   	=7D
> >   	__ufshcd_wl_suspend(hba, UFS_SHUTDOWN_PM);
>=20
> Why to keep one scsi_device_quiesce() call and convert the other call?
> Please consider something like this change:
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c index
> e808350c6774..914770dff18f 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> =40=40 -10134,11 +10134,10 =40=40 static void ufshcd_wl_shutdown(struct d=
evice
> *dev)
>=20
>   	/* Turn on everything while shutting down */
>   	ufshcd_rpm_get_sync(hba);
> -	scsi_device_quiesce(sdev);
>   	shost_for_each_device(sdev, hba->host) =7B
> -		if (sdev =3D=3D hba->ufs_device_wlun)
> -			continue;
> -		scsi_device_quiesce(sdev);
> +		mutex_lock(&sdev->state_mutex);
> +		scsi_device_set_state(sdev, SDEV_OFFLINE);
> +		mutex_unlock(&sdev->state_mutex);
>   	=7D
>   	__ufshcd_wl_suspend(hba, UFS_SHUTDOWN_PM);
>=20
> Thanks,
>=20
> Bart.

That's because SSU (Start Stop Unit) command must be sent during shutdown p=
rocess.
If SDEV_OFFLINE is set for wlun, SSU command cannot be sent because it is r=
ejected
by the scsi layer. Therefore, we consider to set SDEV_QUIESCE for wlun, and=
 set
SDEV_OFFLINE for other lus.

static int ufshcd_execute_start_stop(struct scsi_device *sdev,
				     enum ufs_dev_pwr_mode pwr_mode,
				     struct scsi_sense_hdr *sshdr)
=7B
	const unsigned char cdb=5B6=5D =3D =7B START_STOP, 0, 0, 0, pwr_mode << 4,=
 0 =7D;
	const struct scsi_exec_args args =3D =7B
		.sshdr =3D sshdr,
		.req_flags =3D BLK_MQ_REQ_PM,            <<< set REQ_PM flag
		.scmd_flags =3D SCMD_FAIL_IF_RECOVERING,
	=7D;

	return scsi_execute_cmd(sdev, cdb, REQ_OP_DRV_IN, /*buffer=3D*/NULL,
			/*bufflen=3D*/0, /*timeout=3D*/10 * HZ, /*retries=3D*/0,
			&args);
=7D

static blk_status_t
scsi_device_state_check(struct scsi_device *sdev, struct request *req)
=7B
	case SDEV_OFFLINE:
	case SDEV_TRANSPORT_OFFLINE:             <<< Refuse all commands
		/*
		 * If the device is offline we refuse to process any
		 * commands.  The device must be brought online
		 * before trying any recovery commands.
		 */
		if (=21sdev->offline_already) =7B
			sdev->offline_already =3D true;
			sdev_printk(KERN_ERR, sdev,
				    =22rejecting I/O to offline device=5Cn=22);
		=7D
		return BLK_STS_IOERR;
	case SDEV_QUIESCE:                       <<< Refuse all commands except RE=
Q_PM flag
		/*
		 * If the device is blocked we only accept power management
		 * commands.
		 */
		if (req && WARN_ON_ONCE(=21(req->rq_flags & RQF_PM)))
			return BLK_STS_RESOURCE;
		return BLK_STS_OK;

