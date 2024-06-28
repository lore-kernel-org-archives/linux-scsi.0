Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB84B210E7
	for <linux-scsi@vger.kernel.org>; Fri, 28 Jun 2024 02:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719540819; cv=none; b=k0vog9fhjBdR1a++xfIx/M3jYJzoz03yRHkAX43YhtROwB37E44bbGIjQQd8ptnnXISp3Lhogmn6zpiZg1GM4UqnPrH+vCL6LL5FG7N45OhsYrYt3gTQkjWkVHYU5FX4kZ5Sd2w7pcLuy6cxowUJ+BPIWDGmUA5v56dS0a8cGu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719540819; c=relaxed/simple;
	bh=CO+L56pRGTgO0YMdiaujfrnWA5rZRor9naFpAJUeBeU=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=YfQN8qofub/X652PkOYIRjgewMiEquA3KWMaLdiqGkezq62vGHxCLIBiG0anWvqUEMV8MQuZugOJIBU1h+KUVKWrNXpIlzNhdg+CiRipxYi8YSfFWa6n5kp8KM+OWCvX5sy5AnSG12D65XRaa5pDCSrgsMZRSJ2BbfdiwOJcTws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=E8u7qEB5; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="E8u7qEB5"
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240628021334epoutp026e4737f3f37dba3dde1d73988d7550fa~dCUKhi8Qi2999029990epoutp02I
	for <linux-scsi@vger.kernel.org>; Fri, 28 Jun 2024 02:13:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240628021334epoutp026e4737f3f37dba3dde1d73988d7550fa~dCUKhi8Qi2999029990epoutp02I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1719540814;
	bh=smV6BDj9P/w/ltsVl0S/qKQ2NBYJmlJix6tIj2EJOPM=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=E8u7qEB58DE2CLkmvoooj4xR7fNAWpvqEzTe/vR4hMjBqz4eVozDn251tSoWBYVGa
	 +2YZgxouii9ccu3IGFBnhmULkdHI4Su22AyN4t5Xfav+wLE7ICLwD48Elj8f+MrbDa
	 D+p2nnZuFkgl4dR7ge9Cgw792YHJeDN/47hy55Pg=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas2p1.samsung.com (KnoxPortal) with ESMTP id
	20240628021334epcas2p1c653eeee349990df95c5012f29108414~dCUKHSjw-3270432704epcas2p1I;
	Fri, 28 Jun 2024 02:13:34 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.36.70]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4W9JrY0zxfz4x9Q5; Fri, 28 Jun
	2024 02:13:33 +0000 (GMT)
X-AuditID: b6c32a45-1c7ff70000002678-43-667e1c4cdc93
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
	epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
	66.2B.09848.C4C1E766; Fri, 28 Jun 2024 11:13:32 +0900 (KST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: RE: [PATCH v2 1/7] scsi: ufs: Declare ufshcd_mcq_poll_cqe_lock()
 once
Reply-To: keosung.park@samsung.com
Sender: Keoseong Park <keosung.park@samsung.com>
From: Keoseong Park <keosung.park@samsung.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Avri Altman
	<avri.altman@wdc.com>, "James E.J. Bottomley"
	<James.Bottomley@HansenPartnership.com>, Keoseong Park
	<keosung.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20240627195918.2709502-2-bvanassche@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20240628021332epcms2p33801c04cb32d44c5fe3d396a6a45b256@epcms2p3>
Date: Fri, 28 Jun 2024 11:13:32 +0900
X-CMS-MailID: 20240628021332epcms2p33801c04cb32d44c5fe3d396a6a45b256
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphk+LIzCtJLcpLzFFi42LZdljTTNdHpi7NYMV7S4uXP6+yWUz78JPZ
	4uUhTYtHt58xWmzs57A4fvIdo0X39R1sFsuP/2Ny4PC4fMXbY9qkU2weH5/eYvHo27KK0ePz
	JjmP9gPdTAFsUdk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4B
	um6ZOUDXKCmUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslVILUnIKzAv0ihNzi0vz0vXyUkus
	DA0MjEyBChOyM9bc+sVesI2rYvGynUwNjJc5uhg5OSQETCQO3lnM3MXIxSEksINR4uPdBSxd
	jBwcvAKCEn93CIPUCAsESJx//5EFxBYSUJLoWriVGSJuILFu+h4wm01AT2LK7zuMILaIQJxE
	66xXjCAzmQUuMEqsvXGWFWIZr8SM9qcsELa0xPblWxlBdnEKWEn82WwDEdaQ+LGslxnCFpW4
	ufotO4z9/th8RghbRKL13lmoGkGJBz93Q8UlJM59WAg1vl6i9f0pdpAbJAQmMEo0HvsDNUhf
	4lrHRqgffSW2/o8HCbMIqEoc23GUCaLERWLKj7Vgc5gF5CW2v53DDFLOLKApsX6XPogpIaAs
	ceQWVAWfRMfhv+wwDzZs/I2VvWPeE6jpahKPFmxhncCoPAsRzrOQ7JqFsGsBI/MqRrHUguLc
	9NRiowJDeNQm5+duYgQnSy3XHYyT337QO8TIxMF4iFGCg1lJhDe0pCpNiDclsbIqtSg/vqg0
	J7X4EKMp0JcTmaVEk/OB6TqvJN7QxNLAxMzM0NzI1MBcSZz3XuvcFCGB9MSS1OzU1ILUIpg+
	Jg5OqQam0xt95HU+Ksw7Iidu9pm9durkr77+NRtE38hsnff6bv+lS+yay2a63Q8Xa6y4/qzP
	y+D0t79Bk0t+nLr3c1pe3btv/Z6Hjv1of1n4dlPXOdbszqLpL/bv3+ru4rYunGv2hJfbZ/B+
	OvJOegHv6eP2+hOWzdfZl/X9Mgtf6g+bC0c19x8NLmp9/+s1556HGod01hp5+k28d9srSc9s
	uZPZpBpRjmSFE8Vn998xXpRWvoGPWapEnG/rIzbTdfMuXNL9z8lf+2uelv4lk28TLGes3+2T
	fz5idc02+T6dN+HKURfPhNYdOz1Rf3/uj5bD/N5RO3maxPnnbWq5U2tZ9qLi27ndGhXBJyOZ
	mgImv+J1+6LEUpyRaKjFXFScCAAlSL6zHwQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240627200032epcas2p32fbc04e654e3bdde7298e90eb7350635
References: <20240627195918.2709502-2-bvanassche@acm.org>
	<20240627195918.2709502-1-bvanassche@acm.org>
	<CGME20240627200032epcas2p32fbc04e654e3bdde7298e90eb7350635@epcms2p3>

> ufshcd_mcq_poll_cqe_lock() is declared in include/ufs/ufshcd.h and also in
> drivers/ufs/core/ufshcd-priv.h. Remove the declaration from the latter file.

Hi Bart,

The functions below seem to be the same case.
 - ufshcd_mcq_write_cqis()
 - ufshcd_mcq_read_cqis()
 - ufshcd_mcq_config_mac()
 - ufshcd_mcq_make_queues_operational()

How about including these cases in the patch as well?

Best Regards,
Keoseong

> 
> Reviewed-by: Avri Altman <avri.altman@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/ufs/core/ufshcd-priv.h | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
> index f42d99ce5bf1..0bce72848402 100644
> --- a/drivers/ufs/core/ufshcd-priv.h
> +++ b/drivers/ufs/core/ufshcd-priv.h
> @@ -72,8 +72,6 @@ u32 ufshcd_mcq_read_cqis(struct ufs_hba *hba, int i);
>  void ufshcd_mcq_write_cqis(struct ufs_hba *hba, u32 val, int i);
>  struct ufs_hw_queue *ufshcd_mcq_req_to_hwq(struct ufs_hba *hba,
>  					   struct request *req);
> -unsigned long ufshcd_mcq_poll_cqe_lock(struct ufs_hba *hba,
> -				       struct ufs_hw_queue *hwq);
>  void ufshcd_mcq_compl_all_cqes_lock(struct ufs_hba *hba,
>  				    struct ufs_hw_queue *hwq);
>  bool ufshcd_cmd_inflight(struct scsi_cmnd *cmd);
