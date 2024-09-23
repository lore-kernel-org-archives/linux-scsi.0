Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E003D556
	for <linux-scsi@vger.kernel.org>; Mon, 23 Sep 2024 07:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727078097; cv=none; b=BKby8Ll14bhXnC+qYnAWJrerVqrrSsd3b20tkJDbrVCc7dhXx4Fi3rcEd/tpwylYRW5DS4ftzEnZvuorSnVrvkmp9JvQwsncY7qH+QbFFZTi8oNEfx+FI8Ya/ARROyowwxmPwoHRn2QBIZqVA3H6rTuNydVuiFrhQEUSQpPobWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727078097; c=relaxed/simple;
	bh=TDt0rR4qJ0fXQ3LnBs1POsNdJokGS44w8/R7zwfdZzo=;
	h=From:To:Cc:In-Reply-To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:References; b=oO2DD0MTNpotR8IOrIx96YxSwLvw4q8dVj1MizxjZef3jY8hP8c7nWXqqbMx5Hr/J6h1A2vqWI2/Lsnt+KiNfxBkfe24z+ujQUczHpAbbnpSNDS0QBdHlpcQcxnJugTuze6qvQsNyujNU/VvYqFn63ZN5KweBTfWdMpempsgCDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=XY1xghjT; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="XY1xghjT"
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240923075446epoutp0407e2b39238e4932963537b97d28618fd~30F6bBy0k2898728987epoutp04V
	for <linux-scsi@vger.kernel.org>; Mon, 23 Sep 2024 07:54:46 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240923075446epoutp0407e2b39238e4932963537b97d28618fd~30F6bBy0k2898728987epoutp04V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1727078086;
	bh=aahNRjEo37R2qjI0x09uFKV+251h2kC1QauutDaOJzQ=;
	h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
	b=XY1xghjTu2uGZGc6EU/+09HoT8rV4rQ1WiGLpqfFx7GwMEjHUfDOFO5zqp7ZypzKC
	 BynM9J3u/yYbe6SiFXUq8MTiQE2gdZsxhT5kspj+dqekawTVQ4kQuMSoUiUFdqnRrK
	 3i4MpkLOf+AQb9LJedv5h+kjod6VrEo4y49e60mU=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas1p2.samsung.com (KnoxPortal) with ESMTP id
	20240923075446epcas1p238c62eb8045cfca8d94ce9f5182c225e~30F5w5yMZ0976209762epcas1p2U;
	Mon, 23 Sep 2024 07:54:46 +0000 (GMT)
Received: from epsmges1p4.samsung.com (unknown [182.195.38.240]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4XBwJ53S4hz4x9Py; Mon, 23 Sep
	2024 07:54:45 +0000 (GMT)
Received: from epcas1p3.samsung.com ( [182.195.41.47]) by
	epsmges1p4.samsung.com (Symantec Messaging Gateway) with SMTP id
	B9.31.10258.5CE11F66; Mon, 23 Sep 2024 16:54:45 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
	20240923075444epcas1p3fd61fad32b6c61a2c42e3a21de498cc7~30F4q-UCu2483924839epcas1p37;
	Mon, 23 Sep 2024 07:54:44 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240923075444epsmtrp127dbce40e46dbf5e1d8c0db52966a26b~30F4p8ARU1242412424epsmtrp1G;
	Mon, 23 Sep 2024 07:54:44 +0000 (GMT)
X-AuditID: b6c32a38-995ff70000002812-97-66f11ec53fd0
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	74.67.19367.4CE11F66; Mon, 23 Sep 2024 16:54:44 +0900 (KST)
Received: from sh8267baek02 (unknown [10.253.99.49]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20240923075444epsmtip1e51e5aa52957b1e2b00cf43c4243ddf4~30F4bW0D-3202932029epsmtip1q;
	Mon, 23 Sep 2024 07:54:44 +0000 (GMT)
From: "Seunghwan Baek" <sh8267.baek@samsung.com>
To: <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
	<martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>,
	<bvanassche@acm.org>, <avri.altman@wdc.com>, <alim.akhtar@samsung.com>
Cc: <grant.jung@samsung.com>, <jt77.jang@samsung.com>,
	<junwoo80.lee@samsung.com>, <dh0421.hwang@samsung.com>,
	<jangsub.yi@samsung.com>, <sh043.lee@samsung.com>, <cw9316.lee@samsung.com>,
	<wkon.kim@samsung.com>, <stable@vger.kernel.org>
In-Reply-To: <20240829093913.6282-2-sh8267.baek@samsung.com>
Subject: RE: [PATCH v1 1/1] ufs: core: set SDEV_OFFLINE when ufs shutdown.
Date: Mon, 23 Sep 2024 16:54:44 +0900
Message-ID: <015101db0d8d$daacd030$90067090$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQITd6wvsWq6bg+5ypABxh1kBxxfMwHy7pIVAtyJc3ixza3SMA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNJsWRmVeSWpSXmKPExsWy7bCmvu5RuY9pBusPiVs8mLeNzeLlz6ts
	FtM+/GS2mHGqjdVi37WT7Ba//q5nt9jYz2HRsXUyk8WO52fYLXb9bWayuLxrDptF9/UdbBbL
	j/9jsmj6s4/FYsHGR4wWmy99Y3EQ8Lh8xdtj2qRTbB4fn95i8ejbsorR4/MmOY/2A91MAWxR
	2TYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QGcrKZQl
	5pQChQISi4uV9O1sivJLS1IVMvKLS2yVUgtScgrMCvSKE3OLS/PS9fJSS6wMDQyMTIEKE7Iz
	3k7bxVrwWL7ixdw+1gbGtRJdjJwcEgImEjPW/mbpYuTiEBLYwShxZcMUKOcTo8S6t4cY4ZwF
	izYxwbQc/3KHFSKxk1Hix/wVTBDOS0aJxodHWUCq2AQMJJp/HGQHSYgIXGaUuDH/KdgsZpBZ
	W/4cA6viFLCRuP15PthcYQEviR/bToDZLAKqEivWbwKr4RWwlDhy4x6ULShxcuYTMJtZQFti
	2cLXzBA3KUj8fLqMFcQWEXCS6P3ZywxRIyIxu7ONGWSxhMANDond3XugGlwkzkzbyQhhC0u8
	Or6FHcKWknjZ3wZlF0ss3DiJBaK5hVHi+vI/UA32Es2tzWxdjBxAGzQl1u/Sh1jGJ/Huaw8r
	SFhCgFeio00IolpV4tSGrVCd0hLXmxtYIWwPiY3r9jNPYFScheS1WUhem4XkhVkIyxYwsqxi
	FEstKM5NTy02LDCBR3hyfu4mRnCq1rLYwTj37Qe9Q4xMHIyHGCU4mJVEeNc9eZsmxJuSWFmV
	WpQfX1Sak1p8iNEUGNgTmaVEk/OB2SKvJN7QxNLAxMzIxMLY0thMSZz3zJWyVCGB9MSS1OzU
	1ILUIpg+Jg5OqQYmPefT254uU4h0nr+7pjqtvHG7e8HGOZz5Jcz3wxl0KwO2hSp7tC+0nSt7
	Zp+Ikst3z3M912fGnbjDf9Vx3Xzl5cYFTpUTOMKm77S12fH9Z0bpMY4m9dPzFMPcpotsrT8n
	05B68K3nnqgOl3uTIxJ5E67kRn3OPuvOOduK6+nM2O7mqYK++87py9ad4nTer3jyxFZm9t6F
	CtWVbNb365Rea3wqlbHIuKlZZXw6rT78m5qcyHbpJrm3aw/9POLexLtCU086gD358bunZZ4O
	yU4XVLUXfWE62Dzd0EO6MjQru7osTmFSxpFdex6v2Hj36q3/jz78OnahLX/7+RluU11mzmqZ
	ahLkv+Xa+WkPOtqVWIozEg21mIuKEwGC6437XgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsWy7bCSnO4RuY9pBjsnmlk8mLeNzeLlz6ts
	FtM+/GS2mHGqjdVi37WT7Ba//q5nt9jYz2HRsXUyk8WO52fYLXb9bWayuLxrDptF9/UdbBbL
	j/9jsmj6s4/FYsHGR4wWmy99Y3EQ8Lh8xdtj2qRTbB4fn95i8ejbsorR4/MmOY/2A91MAWxR
	XDYpqTmZZalF+nYJXBlLG5awFVyRrTjZMoWtgXGNWBcjJ4eEgInE8S93WLsYuTiEBLYzSvz+
	e4QZIiEt8fjAS8YuRg4gW1ji8OFiiJrnjBKzvm1lA6lhEzCQaP5xkB0kISJwm1Hiw/RdYA6z
	wB9GiTnnJrNBtOxllNhwq5sVpIVTwEbi9uf5TCC2sICXxI9tJ8BsFgFViRXrN7GA2LwClhJH
	btyDsgUlTs58AmYzC2hL9D5sZYSxly18DXWqgsTPp8vA5osIOEn0/uxlhqgRkZjd2cY8gVF4
	FpJRs5CMmoVk1CwkLQsYWVYxiqYWFOem5yYXGOoVJ+YWl+al6yXn525iBMeqVtAOxmXr/+od
	YmTiYDzEKMHBrCTCu+7J2zQh3pTEyqrUovz4otKc1OJDjNIcLErivMo5nSlCAumJJanZqakF
	qUUwWSYOTqkGJi6e6YtWtc6Q/h2+ISeyUnidqe2u0O2W61gkrz0JT1ti783xPHW+WqdXQJCf
	c9L3P0Yi7QIGM2eam3w87rIpQv9e6OOfzQovrqf6XLU/8rP/2KMb63MSTlWaK4efjF57yicr
	8GSbz9F7zLqLWR5wfJrUtWDzoQvzWBMfLfZnby626X0eZPVnoYvOphc/N3JXL2i2fdkqnq/d
	N4EtroTpgrj92XN7JQqOup4TKj41aVmV0cx8uYMyCTw+Pl06dXsWxWonb+krXLR//6IPAXeX
	bDy89PqLsEmlOwMmpOcz3z/e6j31XVGHs0fbVcGVt6oYZzX9rAkTKnz85//pnY/tS1dtmyXz
	3f6C3ItXf83UeJVYijMSDbWYi4oTAcV5hihEAwAA
X-CMS-MailID: 20240923075444epcas1p3fd61fad32b6c61a2c42e3a21de498cc7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240829093921epcas1p35d28696b0f79e2ae39d8e3690f088e64
References: <20240829093913.6282-1-sh8267.baek@samsung.com>
	<CGME20240829093921epcas1p35d28696b0f79e2ae39d8e3690f088e64@epcas1p3.samsung.com>
	<20240829093913.6282-2-sh8267.baek@samsung.com>

> There is a history of dead lock as reboot is performed at the beginning o=
f
> booting. SDEV_QUIESCE was set for all lu's scsi_devices by ufs shutdown,
> and at that time the audio driver was waiting on blk_mq_submit_bio holdin=
g
> a mutex_lock while reading the fw binary. After that, a deadlock issue
> occurred while audio driver shutdown was waiting for mutex_unlock of
> blk_mq_submit_bio. To solve this, set SDEV_OFFLINE for all lus except wlu=
n,
> so that any i/o that comes down after a ufs shutdown will return an error=
.
>=20
> =5B   31.907781=5DI=5B0:      swapper/0:    0=5D        1        13070500=
7       1651079834
> 11289729804                0 D(   2) 3 ffffff882e208000 *             ini=
t
> =5Bdevice_shutdown=5D
> =5B   31.907793=5DI=5B0:      swapper/0:    0=5D Mutex: 0xffffff8849a2b8b=
0:
> owner=5B0xffffff882e28cb00 kworker/6:0 :49=5D
> =5B   31.907806=5DI=5B0:      swapper/0:    0=5D Call trace:
> =5B   31.907810=5DI=5B0:      swapper/0:    0=5D  __switch_to+0x174/0x338
> =5B   31.907819=5DI=5B0:      swapper/0:    0=5D  __schedule+0x5ec/0x9cc
> =5B   31.907826=5DI=5B0:      swapper/0:    0=5D  schedule+0x7c/0xe8
> =5B   31.907834=5DI=5B0:      swapper/0:    0=5D  schedule_preempt_disabl=
ed+0x24/0x40
> =5B   31.907842=5DI=5B0:      swapper/0:    0=5D  __mutex_lock+0x408/0xda=
c
> =5B   31.907849=5DI=5B0:      swapper/0:    0=5D  __mutex_lock_slowpath+0=
x14/0x24
> =5B   31.907858=5DI=5B0:      swapper/0:    0=5D  mutex_lock+0x40/0xec
> =5B   31.907866=5DI=5B0:      swapper/0:    0=5D  device_shutdown+0x108/0=
x280
> =5B   31.907875=5DI=5B0:      swapper/0:    0=5D  kernel_restart+0x4c/0x1=
1c
> =5B   31.907883=5DI=5B0:      swapper/0:    0=5D  __arm64_sys_reboot+0x15=
c/0x280
> =5B   31.907890=5DI=5B0:      swapper/0:    0=5D  invoke_syscall+0x70/0x1=
58
> =5B   31.907899=5DI=5B0:      swapper/0:    0=5D  el0_svc_common+0xb4/0xf=
4
> =5B   31.907909=5DI=5B0:      swapper/0:    0=5D  do_el0_svc+0x2c/0xb0
> =5B   31.907918=5DI=5B0:      swapper/0:    0=5D  el0_svc+0x34/0xe0
> =5B   31.907928=5DI=5B0:      swapper/0:    0=5D  el0t_64_sync_handler+0x=
68/0xb4
> =5B   31.907937=5DI=5B0:      swapper/0:    0=5D  el0t_64_sync+0x1a0/0x1a=
4
>=20
> =5B   31.908774=5DI=5B0:      swapper/0:    0=5D       49                =
0         11960702
> 11236868007                0 D(   2) 6 ffffff882e28cb00 *      kworker/6:=
0
> =5B__bio_queue_enter=5D
> =5B   31.908783=5DI=5B0:      swapper/0:    0=5D Call trace:
> =5B   31.908788=5DI=5B0:      swapper/0:    0=5D  __switch_to+0x174/0x338
> =5B   31.908796=5DI=5B0:      swapper/0:    0=5D  __schedule+0x5ec/0x9cc
> =5B   31.908803=5DI=5B0:      swapper/0:    0=5D  schedule+0x7c/0xe8
> =5B   31.908811=5DI=5B0:      swapper/0:    0=5D  __bio_queue_enter+0xb8/=
0x178
> =5B   31.908818=5DI=5B0:      swapper/0:    0=5D  blk_mq_submit_bio+0x194=
/0x67c
> =5B   31.908827=5DI=5B0:      swapper/0:    0=5D  __submit_bio+0xb8/0x19c
>=20
> Fixes: b294ff3e3449 (=22scsi: ufs: core: Enable power management for wlun=
=22)
> Cc: stable=40vger.kernel.org
> Signed-off-by: Seunghwan Baek <sh8267.baek=40samsung.com>
> ---
>  drivers/ufs/core/ufshcd.c =7C 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index a6f818cdef0e..4ac1492787c2 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> =40=40 -10215,7 +10215,9 =40=40 static void ufshcd_wl_shutdown(struct dev=
ice *dev)
>  	shost_for_each_device(sdev, hba->host) =7B
>  		if (sdev =3D=3D hba->ufs_device_wlun)
>  			continue;
> -		scsi_device_quiesce(sdev);
> +		mutex_lock(&sdev->state_mutex);
> +		scsi_device_set_state(sdev, SDEV_OFFLINE);
> +		mutex_unlock(&sdev->state_mutex);
>  	=7D
>  	__ufshcd_wl_suspend(hba, UFS_SHUTDOWN_PM);
>=20
> --
> 2.17.1
>=20

Dear all.

Could you please review this patch? It's been almost a month.
If you have any opinions about this patch, share and comment it.

Thanks.
BRs.

