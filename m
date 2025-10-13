Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55FF0169AE6
	for <linux-scsi@vger.kernel.org>; Mon, 13 Oct 2025 02:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760322230; cv=none; b=MSGw/9ILkYIqihdQnBdx0l/3YTB8tFHChLfvDQdVYZbbOMQc7T0VH+FT3TMsCWkE3blvpRY2AQO2PH7HXGKdmOxr/V+b04OlfdFlpoYUHXbZT3Ke3H0A13TpMiOjC+c90V/qiAwF35lZJYXuhxR+2PPJHI/z+5f5ofNRvI65wyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760322230; c=relaxed/simple;
	bh=7SGRryzVoFkWrc2jH/YqMfJi3jFq/2W2i6KS+SN50OI=;
	h=From:To:In-Reply-To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:References; b=ZJJCac5ImYPpymu4DpauWs718NRxQLrikPyVf4Yr1GTUben/TLjXE7ngv5TEaTP2pcEw7tSXMucMGrqDkRzUXxgr5yaGbWD1O1eR/PkuYrqqdk9N5cXQmKRGH99Bnc3cjRKjBhwkQNpi54Q0TGm9CXxU17n9cATBKN1lbYMTzo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=QOaXDWF9; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="QOaXDWF9"
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20251013022340epoutp045c6d4e28f7cc87548628197cf2e8a6dc~t67uYSp321827018270epoutp04T
	for <linux-scsi@vger.kernel.org>; Mon, 13 Oct 2025 02:23:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20251013022340epoutp045c6d4e28f7cc87548628197cf2e8a6dc~t67uYSp321827018270epoutp04T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1760322220;
	bh=D2ea9j59jiOzpu+mQ18H1BohxN0QztUwdmfA4+DrN2o=;
	h=From:To:In-Reply-To:Subject:Date:References:From;
	b=QOaXDWF9rmsqJsbHPi6Ls1B/bP7EKTafUK8WJHSlHQJlIQTHoyHmLSx4eYQkX0DJh
	 fAthC+O9SUsbFYwDuGGgI8BMFz3yae73SN22siwH8fVO5/Tt4W92FHZyFOeXvTnobj
	 MuuMZOyDLjJEyu73zEVDbAK81EB3mHNcWLjkWf4w=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas1p3.samsung.com (KnoxPortal) with ESMTPS id
	20251013022339epcas1p3e829aed650d6533ee949363162b8ba88~t67t9h_tq2851228512epcas1p3r;
	Mon, 13 Oct 2025 02:23:39 +0000 (GMT)
Received: from epcas1p3.samsung.com (unknown [182.195.38.196]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4clLkM4VjPz3hhTN; Mon, 13 Oct
	2025 02:23:39 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
	20251013022339epcas1p3a753d84e924146f94a77ef5697b9a561~t67tN9Ts92852828528epcas1p3-;
	Mon, 13 Oct 2025 02:23:39 +0000 (GMT)
Received: from wkonkim01 (unknown [10.253.100.198]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20251013022339epsmtip12740888892ac5a83d06d565f0baa3e41~t67tK9WBS1631316313epsmtip1c;
	Mon, 13 Oct 2025 02:23:39 +0000 (GMT)
From: "Wonkon Kim" <wkon.kim@samsung.com>
To: "'Bart Van Assche'" <bvanassche@acm.org>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<peter.wang@mediatek.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
In-Reply-To: <4c894d68-7d0e-49a0-b582-477bcc7f351d@acm.org>
Subject: RE: [PATCH] ufs: core: Initialize a variable mode for PA_PWRMODE
Date: Mon, 13 Oct 2025 11:23:38 +0900
Message-ID: <000001dc3be8$62cf3370$286d9a50$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQFhT2clGfJ4dWcII9qWXyagEihcgwJWi3eIAdcMmwG1k7+/kA==
Content-Language: ko
X-CMS-MailID: 20251013022339epcas1p3a753d84e924146f94a77ef5697b9a561
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
cpgsPolicy: CPGSC10-711,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251002070057epcas1p49ac487359f24f6813ba8f9f44bcf0924
References: <CGME20251002070057epcas1p49ac487359f24f6813ba8f9f44bcf0924@epcas1p4.samsung.com>
	<20251002070027.228638-1-wkon.kim@samsung.com>
	<4c894d68-7d0e-49a0-b582-477bcc7f351d@acm.org>

> On 10/2/25 12:00 AM, Wonkon Kim wrote:
> >   static bool ufshcd_is_pwr_mode_restore_needed(struct ufs_hba *hba)
> >   {
> >   	struct ufs_pa_layer_attr *pwr_info = &hba->pwr_info;
> > -	u32 mode;
> > +	u32 mode = 0;
> >
> >   	ufshcd_dme_get(hba, UIC_ARG_MIB(PA_PWRMODE), &mode);
> 
> Since there is more code that passes a pointer to an uninitialized
> variable to ufshcd_dme_get(), the untested patch below may be a better
> solution:
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c index
> 127b691402f9..5226fbca29ec 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -4277,8 +4277,8 @@ int ufshcd_dme_get_attr(struct ufs_hba *hba, u32
> attr_sel,
>   			get, UIC_GET_ATTR_ID(attr_sel),
>   			UFS_UIC_COMMAND_RETRIES - retries);
> 
> -	if (mib_val && !ret)
> -		*mib_val = uic_cmd.argument3;
> +	if (mib_val)
> +		*mib_val = ret == 0 ? uic_cmd.argument3 : 0;
> 
>   	if (peer && (hba->quirks & UFSHCD_QUIRK_DME_PEER_ACCESS_AUTO_MODE)
>   	    && pwr_mode_change)
> 
> 

Sorry for late reply.
Ok, I agree with you and it would be more general.
There is a code to initialize a variable.
Do you think it also needs to fix?

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index a4438a3cb73a..d593ff7ea63d 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4990,7 +4990,7 @@ EXPORT_SYMBOL_GPL(ufshcd_hba_enable);
 
 static int ufshcd_disable_tx_lcc(struct ufs_hba *hba, bool peer)
 {
-       int tx_lanes = 0, i, err = 0;
+       int tx_lanes, i, err = 0;
 
        if (!peer)
		ufshcd_dme_get(hba, UIC_ARG_MIB(PA_CONNECTEDTXDATALANES),
			       &tx_lanes);
	else
		ufshcd_dme_peer_get(hba, UIC_ARG_MIB(PA_CONNECTEDTXDATALANES),
				    &tx_lanes);

Thanks,
Wonkon Kim.

