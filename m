Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137E43D6D
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jul 2024 01:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719883687; cv=none; b=NKOipiFz3zvTnDuxAwchDBRi5k0yxEbtzQcg5ZCmqKZoq0y9Iu1B9LkczHi7VklholOuXK7zHzbxkcpEnPTxKwo6p1KMW9UEtzfWwvgAwhFojCASnCwWIxBT+eQe2g1LoaOnzUyeqK1M+6ZhGZ2XcAP+602tnLqmVHjYN3qTdHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719883687; c=relaxed/simple;
	bh=Uul83qQWIhudb77YaIlYroKKhx3kzDMetQ2r5NhnPt4=;
	h=Mime-Version:Subject:From:To:CC:In-Reply-To:Message-ID:Date:
	 Content-Type:References; b=dp4fWszxTtX+AttPpalWn69WBs+yjqR3DcBRE41H8vkR7ghRwO0zg6wXC3s/UAjgIpTZ8L0ybi5kVRylHU4M6m2RGf9nCadthfKZxIpB1OE7Qa+BGXsBBQd5RJRuuy50e06EtOWEIH3cytAoDOzkcd2VTd+gAfLPEg1ycwXwWbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=DpTsDurz; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="DpTsDurz"
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240702012755epoutp016800baf25607f449634fd1d17ca37978~eQRc6-QT51307413074epoutp01s
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jul 2024 01:27:55 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240702012755epoutp016800baf25607f449634fd1d17ca37978~eQRc6-QT51307413074epoutp01s
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1719883675;
	bh=OCAfCAzDNGlZJ+vvly/Ys4KshDBlcYVN+cKDZhEsRSA=;
	h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
	b=DpTsDurzM6VXinEkD0YP49zAwjTMI791/DuAKfurO2W8xtwRuMR1+tRitXUCJsrY1
	 R1fnzQfiz7UEK4NSzRzbr88/JTLZLL9HmHkvTT+X1rTZxi204qUbFWyBZTAw2UGjba
	 s6ta2M8mw5UKFBa73WawsiGAtkfVzdZ9T45f7lSQ=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas2p4.samsung.com (KnoxPortal) with ESMTP id
	20240702012755epcas2p4fa99170c4e30c88f9c6d21ad19031226~eQRcph31z2676526765epcas2p4r;
	Tue,  2 Jul 2024 01:27:55 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.36.68]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4WClf22nPhz4x9Q6; Tue,  2 Jul
	2024 01:27:54 +0000 (GMT)
X-AuditID: b6c32a45-1c7ff70000002678-39-668357995cd1
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
	epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
	CF.F6.09848.99753866; Tue,  2 Jul 2024 10:27:53 +0900 (KST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Subject: RE: [PATCH v3 1/7] scsi: ufs: Declare functions once
Reply-To: keosung.park@samsung.com
Sender: Keoseong Park <keosung.park@samsung.com>
From: Keoseong Park <keosung.park@samsung.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, Keoseong Park
	<keosung.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20240701180419.1028844-2-bvanassche@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20240702012753epcms2p13d6ac449718b8df290867135dd2d937c@epcms2p1>
Date: Tue, 02 Jul 2024 10:27:53 +0900
X-CMS-MailID: 20240702012753epcms2p13d6ac449718b8df290867135dd2d937c
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpik+LIzCtJLcpLzFFi42LZdljTQndmeHOawcVNUhbTPvxktnh5SNPi
	0e1njBYb+zksjp98x2jRfX0Hm8Xy4/+YHNg9Ll/x9pg26RSbx8ent1g8+rasYvT4vEkugDUq
	2yYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6AYlhbLE
	nFKgUEBicbGSvp1NUX5pSapCRn5xia1SakFKToF5gV5xYm5xaV66Xl5qiZWhgYGRKVBhQnZG
	+8eZrAWruSsmtRxkbWA8y9nFyMkhIWAiMXHdbJYuRi4OIYEdjBIdV94wdjFycPAKCEr83SEM
	UiMsYCsxceFDFhBbSEBJomvhVmaIuIHEuul7wGw2AT2JKb/vMILYIgJxEq2zXjGCzGQWWM0o
	8fjYTzaIZbwSM9qfskDY0hLbl28F28UpYCUx70cIRFhD4seyXmYIW1Ti5uq37DD2+2PzGSFs
	EYnWe2ehagQlHvzcDRWXkDj3YSHU+HqJ1ven2EFukBCYwCjReOwP1CB9iWsdG8GKeAV8JTZs
	28EEYrMIqErM+jeBBeQeCQEXiYMdziBhZgF5ie1v5zCDhJkFNCXW79KHqFCWOHKLBaKCT6Lj
	8F92mAcbNv7Gyt4x7wkThK0m8WjBFtYJjMqzEOE8C8muWQi7FjAyr2IUSy0ozk1PLTYqMIRH
	bXJ+7iZGcGLUct3BOPntB71DjEwcjIcYJTiYlUR4A3/VpwnxpiRWVqUW5ccXleakFh9iNAV6
	ciKzlGhyPjA155XEG5pYGpiYmRmaG5kamCuJ895rnZsiJJCeWJKanZpakFoE08fEwSnVwBQQ
	vH2r70Px48/7+8I28pT9/XFrarINs/WWg7v2/PuyfUNjHN+x6MqyQ1w2Oo6Tm03YPQUFXz/+
	ULXuo9iBaOsthxIkhZmyF38MeDX9uuqxnLO166bFJi39oh92KoS/3SXT86vjxD9SM9h2XzyW
	Wv7P71CPPhvPy53ztlz+zb1SeJnhyvnSyjc/fmGVLe18dTy37lYpx4T6+8G7/EM9xJKd+rfF
	Na1be9mqNfrYJ+dN560yXlsfmfb3cdDs3Kaid/WJX+d+rxCv33n1/8/V1es6N6XI+CUHye8/
	q34vyYv77V+X/fJRcpds67VY5/UVxW5fVlzHtvO7PnMw47cTbrM4bn/If/qt9d35g/pG8T5K
	LMUZiYZazEXFiQC+/CK5FQQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240701180442epcas2p351e08f49cdbfbfb15c9288add2a167f1
References: <20240701180419.1028844-2-bvanassche@acm.org>
	<20240701180419.1028844-1-bvanassche@acm.org>
	<CGME20240701180442epcas2p351e08f49cdbfbfb15c9288add2a167f1@epcms2p1>

> Several functions are declared in include/ufs/ufshcd.h and also in
> drivers/ufs/core/ufshcd-priv.h. Remove the duplicate declarations.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Keoseong Park <keosung.park@samsung.com>

Best Regards,
Keoseong

> ---
>  drivers/ufs/core/ufshcd-priv.h | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
> index f42d99ce5bf1..668748477e6e 100644
> --- a/drivers/ufs/core/ufshcd-priv.h
> +++ b/drivers/ufs/core/ufshcd-priv.h
> @@ -66,14 +66,8 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, int task_tag,
>  int ufshcd_mcq_init(struct ufs_hba *hba);
>  int ufshcd_mcq_decide_queue_depth(struct ufs_hba *hba);
>  int ufshcd_mcq_memory_alloc(struct ufs_hba *hba);
> -void ufshcd_mcq_make_queues_operational(struct ufs_hba *hba);
> -void ufshcd_mcq_config_mac(struct ufs_hba *hba, u32 max_active_cmds);
> -u32 ufshcd_mcq_read_cqis(struct ufs_hba *hba, int i);
> -void ufshcd_mcq_write_cqis(struct ufs_hba *hba, u32 val, int i);
>  struct ufs_hw_queue *ufshcd_mcq_req_to_hwq(struct ufs_hba *hba,
>  					   struct request *req);
> -unsigned long ufshcd_mcq_poll_cqe_lock(struct ufs_hba *hba,
> -				       struct ufs_hw_queue *hwq);
>  void ufshcd_mcq_compl_all_cqes_lock(struct ufs_hba *hba,
>  				    struct ufs_hw_queue *hwq);
>  bool ufshcd_cmd_inflight(struct scsi_cmnd *cmd);
