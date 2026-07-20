Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0773112C0
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jul 2026 03:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784519534; cv=none; b=oKyY9CIkYuvz5x1aZR+EQNwkZzUopI6c50IlgwCtI/9Zx84EpnBjFYkyw/75Z0BxliKpmtKUT1SXx/c99EG2hoWfUJLQu1D7ZZfUBqeov3/l3vtIhQbFOqMc0xJUlAgkq5k7JDNYzJ/TCALP1V5XSAUw7MyxlacuNf/hSeDHay0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784519534; c=relaxed/simple;
	bh=FuVeu22pRbwe6jM2V3LMn6QpJctNMFfcZ7SJMUd1yU0=;
	h=From:To:Cc:In-Reply-To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:References; b=QqTfO0zX01nIR2+qrxWUFMVLgddDSRJuyUCU65GXlMxISRIc/il8jyL9IxAe/ce1blnxKXsUeCjqLAcUddtGuv1z0aaulDA11aPiCSHNLfUMl202T6YbhoDlpj/0x8+xRaqWCQOdHmVAsS7byYGTGaRLUfTtpVTZ6iJijSNu8xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=Lsx3Z5Sj; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Lsx3Z5Sj"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260720035203epoutp027a80671ff083da84bf86f0cca80ab6cb~D4w0r0SKR3041530415epoutp02v
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jul 2026 03:52:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260720035203epoutp027a80671ff083da84bf86f0cca80ab6cb~D4w0r0SKR3041530415epoutp02v
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1784519523;
	bh=et5SdOXDUnMYjg+Lx57vE0z4FwEXeYJAsyYDkrg7X5w=;
	h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
	b=Lsx3Z5SjEduUs2FtZqc7mlg9FHSZJ28DQXJPANUkVUFXVfF40lpmI+/1VR/ZyaPFG
	 ky/9lCO5YwFerHL3j44BWj6SmhJiCHQnUAZOT6qcqpeZnPJWcCsnmXoVO4ZMnponAe
	 6fXtAlSKF2UQe1o2VzSC2HXtxXouXHEV+SGnyNYs=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20260720035202epcas5p4258d8417c1f59d57d06cb14578e1e375~D4w0NjJeT0525805258epcas5p4H;
	Mon, 20 Jul 2026 03:52:02 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.93]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4h3RR56Jc8z2SSKY; Mon, 20 Jul
	2026 03:52:01 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20260720035201epcas5p15760eb7af6def206435ae2856f8a46f6~D4wzITdhb1282812828epcas5p1Q;
	Mon, 20 Jul 2026 03:52:01 +0000 (GMT)
Received: from INBRO002756 (unknown [107.122.3.168]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20260720035200epsmtip1a2b3413f20114ea59a8ae48ff74f33df~D4wyRMNqI0511005110epsmtip1C;
	Mon, 20 Jul 2026 03:52:00 +0000 (GMT)
From: "Alim Akhtar" <alim.akhtar@samsung.com>
To: "'Randy Dunlap'" <rdunlap@infradead.org>, <linux-scsi@vger.kernel.org>
Cc: "'James E.J. Bottomley'" <James.Bottomley@HansenPartnership.com>,
	"'Martin K. Petersen'" <martin.petersen@oracle.com>, "'Avri	Altman'"
	<avri.altman@wdc.com>, "'Bart Van Assche'" <bvanassche@acm.org>
In-Reply-To: <20260720013759.2979593-1-rdunlap@infradead.org>
Subject: RE: [PATCH] scsi: ufs: ufshcd.h: fix all kernel-doc warnings
Date: Mon, 20 Jul 2026 09:21:59 +0530
Message-ID: <1cab01dd17fb$1ecb8f30$5c62ad90$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKkWcTv7Mn9zspz9Dcs5tCOghaHNADXc561tOCGuxA=
Content-Language: en-us
X-CMS-MailID: 20260720035201epcas5p15760eb7af6def206435ae2856f8a46f6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-543,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260720013809epcas5p2435800e514012c9cac5a62231fd8ec48
References: <CGME20260720013809epcas5p2435800e514012c9cac5a62231fd8ec48@epcas5p2.samsung.com>
	<20260720013759.2979593-1-rdunlap@infradead.org>



> -----Original Message-----
> From: Randy Dunlap <rdunlap@infradead.org>
> Sent: Monday, July 20, 2026 7:08 AM
> To: linux-scsi@vger.kernel.org
> Cc: Randy Dunlap <rdunlap@infradead.org>; James E.J. Bottomley
> <James.Bottomley@HansenPartnership.com>; Martin K. Petersen
> <martin.petersen@oracle.com>; Alim Akhtar <alim.akhtar@samsung.com>; Avri
> Altman <avri.altman@wdc.com>; Bart Van Assche <bvanassche@acm.org>
> Subject: [PATCH] scsi: ufs: ufshcd.h: fix all kernel-doc warnings
> 
> - use the correct name for a struct in kernel-doc
> - add kernel-doc for missing struct members or correct the name
> 
> Warning: ./include/ufs/ufshcd.h:201 Excess struct member 'task_tag'
>  description in 'ufshcd_lrb'
> Warning: ./include/ufs/ufshcd.h:220 expecting prototype for struct
> ufs_query_resp. Prototype was for struct ufs_query_res instead
> Warning: ./include/ufs/ufshcd.h:577 struct member 'suspend_on_no_request'
>  not described in 'ufs_clk_scaling'
> Warning: ./include/ufs/ufshcd.h:1269 struct member 'nortt' not described
in
> 'ufs_hba'
> Warning: ./include/ufs/ufshcd.h:1269 struct member 'trigger_eh_attr' not
> described in 'ufs_hba'
> Warning: ./include/ufs/ufshcd.h:1269 struct member 'timeout_attr' not
> described in 'ufs_hba'
> Warning: ./include/ufs/ufshcd.h:1269 struct member 'lsdb_sup' not
described in
> 'ufs_hba'
> Warning: ./include/ufs/ufshcd.h:1269 struct member 'vcc_off_delay_us' not
> described in 'ufs_hba'
> Warning: ./include/ufs/ufshcd.h:1269 Excess struct member 'desc_size'
>  description in 'ufs_hba'
> Warning: ./include/ufs/ufshcd.h:1269 Excess struct member 'res'
>  description in 'ufs_hba'
> Warning: ./include/ufs/ufshcd.h:1309 struct member 'sq_tail_slot' not
described
> in 'ufs_hw_queue'
> Warning: ./include/ufs/ufshcd.h:1309 Excess struct member 'sq_tp_slot'
>  description in 'ufs_hw_queue'
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> ---
> Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: Alim Akhtar <alim.akhtar@samsung.com>
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Bart Van Assche <bvanassche@acm.org>
> 
Thanks!

Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>

