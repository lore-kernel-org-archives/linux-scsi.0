Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9987EC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Apr 2022 02:19:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244017AbiDACVa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Mar 2022 22:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238038AbiDACV3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2022 22:21:29 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A28BC4BFC9
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 19:19:40 -0700 (PDT)
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220401021935epoutp034f32467f752b38baded7c94048200bdc~hpEm23x-X2131621316epoutp03J
        for <linux-scsi@vger.kernel.org>; Fri,  1 Apr 2022 02:19:35 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220401021935epoutp034f32467f752b38baded7c94048200bdc~hpEm23x-X2131621316epoutp03J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1648779575;
        bh=lxHgydYy0dDyrYXT+K/nRAe/Mj7zmyJvhv0GeVs244w=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=DVGxnPwp39TraMYbPMIHEORkk9i/k3RACtWK4C3g44AzW7FtCJooc3DpXARZIheAY
         msMrWrFyG+781E8NvMqNdvwO1FT7b2yZN0ChA5Cw4aRw3XltqiU7C+jEuv5JTTFZ8x
         S8Rqdif58JCvuUlOcnILXiPgfEVQMZIZpji/LBz0=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20220401021934epcas2p264e93c9854b22b541074d92086409ed2~hpEmINpSR1318813188epcas2p2T;
        Fri,  1 Apr 2022 02:19:34 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.36.102]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4KV3lS6xWtz4x9QC; Fri,  1 Apr
        2022 02:19:32 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        BF.34.25540.23166426; Fri,  1 Apr 2022 11:19:30 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20220401021930epcas2p1d05ae66154a30a531008db32e3123f5c~hpEieosdF3095630956epcas2p1O;
        Fri,  1 Apr 2022 02:19:30 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220401021930epsmtrp1b0417918ef13b3d2727e3b0e0eff92a0~hpEidw8Hv2376223762epsmtrp1v;
        Fri,  1 Apr 2022 02:19:30 +0000 (GMT)
X-AuditID: b6c32a47-831ff700000063c4-d0-624661324c6b
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        F6.4F.03370.23166426; Fri,  1 Apr 2022 11:19:30 +0900 (KST)
Received: from KORCO082417 (unknown [10.229.8.121]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20220401021930epsmtip22da449431383c00b8176935b19c0995a~hpEiQ48ZX0895208952epsmtip2x;
        Fri,  1 Apr 2022 02:19:30 +0000 (GMT)
From:   "Chanho Park" <chanho61.park@samsung.com>
To:     "'Bart Van Assche'" <bvanassche@acm.org>,
        "'Martin K . Petersen'" <martin.petersen@oracle.com>
Cc:     "'Jaegeuk Kim'" <jaegeuk@kernel.org>,
        "'Adrian Hunter'" <adrian.hunter@intel.com>,
        <linux-scsi@vger.kernel.org>,
        "'James E.J. Bottomley'" <jejb@linux.ibm.com>,
        "'Krzysztof Kozlowski'" <krzk@kernel.org>,
        "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'Bean Huo'" <beanhuo@micron.com>,
        "'Inki Dae'" <inki.dae@samsung.com>,
        "'Avri Altman'" <avri.altman@wdc.com>,
        "'Daejun Park'" <daejun7.park@samsung.com>
In-Reply-To: <20220331223424.1054715-20-bvanassche@acm.org>
Subject: RE: [PATCH 19/29] scsi: ufs: Remove the TRUE and FALSE definitions
Date:   Fri, 1 Apr 2022 11:19:30 +0900
Message-ID: <00d101d8456e$eb350830$c19f1890$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQEkvIO8WDCMeleYLL46gzQacByZhQGxE6ZpAfC7lyCuJFIFQA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMJsWRmVeSWpSXmKPExsWy7bCmha5RoluSwZXJBhYnn6xhs3gwbxub
        xcufV9ksDj7sZLGY9uEns8WqB+EWk+5PYLF4sn4Ws8WiG9uYLM6f38Bu0X19B5vF8uP/mBx4
        PC5f8fZYvOclk8emVZ1sHhMWHWD0+L6+g83j49NbLB59W1YxenzeJOfRfqCbKYAzKtsmIzUx
        JbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB+hiJYWyxJxSoFBA
        YnGxkr6dTVF+aUmqQkZ+cYmtUmpBSk6BeYFecWJucWleul5eaomVoYGBkSlQYUJ2xo3jd5gL
        1mlULJhwjrmB8ZViFyMnh4SAicSPG/eZuhi5OIQEdjBK3Nv1kRnC+cQo0X11GhuE85lR4vay
        F6wwLX1Lt0IldjFKTFzXBeW8YJS4uO0CM0gVm4C+xMuObUAdHBwiAikS+x9IgtQwC8xllri7
        aCUTSA2ngLXE2+P3WUBsYQFvia3TesDiLAIqEg9bOhlBbF4BS4n+e/+hbEGJkzOfgNUzC8hL
        bH87hxniIgWJn0+XgV0nIuAkcaLrPBNEjYjE7M42sH8kBK5wSEy+sJ4JosFF4s7mfnYIW1ji
        1fEtULaUxMv+Nii7WGLprE9MEM0NjBKXt/1ig0gYS8x61s4I8hmzgKbE+l36IKaEgLLEkVtQ
        t/FJdBz+yw4R5pXoaBOCaFSXOLB9OguELSvRPecz6wRGpVlIPpuF5LNZSD6YhbBrASPLKkax
        1ILi3PTUYqMCY3hsJ+fnbmIEp2Yt9x2MM95+0DvEyMTBeIhRgoNZSYT3aqxrkhBvSmJlVWpR
        fnxRaU5q8SFGU2BYT2SWEk3OB2aHvJJ4QxNLAxMzM0NzI1MDcyVxXq+UDYlCAumJJanZqakF
        qUUwfUwcnFINTHF+sq13O8VmOjo3XJM0/FkmsZlTTurg3s2HFuzPPdVTucn6ucP3nzW952Vm
        SDIfexa4ayrTwm4ZhQrOVS6PJ7add1SccfTOXJ8Vl0/8YFxtPiWVsS1OMdXu5TatFSvXfP4W
        yukqs7FX+khpYn7XnZOplywkXSoWBx15I8aTcFH3atpTjunNP8TNDshG/7sXz95328Sk8ufZ
        ZzY79h7z1Tqw+FAN2zaLzGjzy6HPL/HnScun3m1f9W2b4++qCral/xT6c++mTbSZHD1Jbde1
        1yqzTa7f0e/uPerH02+bralbPFPou+n+eaqHHl0UYzp21fjjPH5txZ8N15x2c3s+fxH25Nnx
        3/Pm3+UW1jVZckiJpTgj0VCLuag4EQBg6N7AVgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsWy7bCSvK5RoluSwbpXghYnn6xhs3gwbxub
        xcufV9ksDj7sZLGY9uEns8WqB+EWk+5PYLF4sn4Ws8WiG9uYLM6f38Bu0X19B5vF8uP/mBx4
        PC5f8fZYvOclk8emVZ1sHhMWHWD0+L6+g83j49NbLB59W1YxenzeJOfRfqCbKYAzissmJTUn
        syy1SN8ugSvjxvE7zAXrNCoWTDjH3MD4SrGLkZNDQsBEom/pVrYuRi4OIYEdjBJPvi1mgUjI
        Sjx7t4MdwhaWuN9yhBWi6BmjxKEJTxhBEmwC+hIvO7axgtgiAikSMxZ8ZAcpYhZYyizRen4G
        C0THLkaJTbMgqjgFrCXeHr8PtkJYwFti67QeJhCbRUBF4mFLJ9hUXgFLif57/6FsQYmTM58A
        1XMATdWTaNsIFmYWkJfY/nYOM8R1ChI/ny6DOsJJ4kTXeSaIGhGJ2Z1tzBMYhWchmTQLYdIs
        JJNmIelYwMiyilEytaA4Nz232LDAKC+1XK84Mbe4NC9dLzk/dxMjOEq1tHYw7ln1Qe8QIxMH
        4yFGCQ5mJRHeq7GuSUK8KYmVValF+fFFpTmpxYcYpTlYlMR5L3SdjBcSSE8sSc1OTS1ILYLJ
        MnFwSjUwLWVJ/a3vP93rtn3ej1c13InLp9wV16j8Xn7toQd/jiD79yN1gutuXmI3Mpny6pyT
        8rY4Ln/Zm67T1/bv45Ndw9MzedLPvbGLVRl6XH7Pqzn+7cLx/Y/ebGb4J1jStt7puLRKndfi
        e+/iJnU+KBL4478s30smg4VJq9w3Ni6r7GLzC8lP309JCL59E9Vw+krCIkuu/I6IaG2X/4KN
        Wg2HJq67MfVdP2tK/i+hUs6M/sWZr3mnsKwW1BG8f8tmU96O3T3Zs15xiVbmbEj+JhunamG8
        t0JU7Mr6A+k2J888etP2ZuGKZ7Kmohs3zZD5mN9lGLnnx+uHP2V2HVwTU23ZKtVqPPfpbVXp
        1ecfxK81V2Ipzkg01GIuKk4EAOlQnEhBAwAA
X-CMS-MailID: 20220401021930epcas2p1d05ae66154a30a531008db32e3123f5c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220331223751epcas2p1348fddbccaa989efb1cb98e3d870bc4a
References: <20220331223424.1054715-1-bvanassche@acm.org>
        <CGME20220331223751epcas2p1348fddbccaa989efb1cb98e3d870bc4a@epcas2p1.samsung.com>
        <20220331223424.1054715-20-bvanassche@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> In the Linux kernel coding style document
> (Documentation/process/coding-style.rst) it is recommended to use the type
> 'bool' and also the values 'true' and 'false'. Hence this patch that
> removes the definitions and uses of TRUE and FALSE from the UFS driver.

The third parameter of ufshcd_dme_set is "int" type.
I think the coding-style doc recommends to use "bool" as comparison purpose
not int type conversion.
However, regarding C99 and C11, they might be converted to 0 and 1
respectively.

Reviewed-by: Chanho Park <chanho61.park@samsung.com>

The usage of 'TRUE' and 'FALSE' seems to be written as following the
description of below JEDEC doc.
> A Flag is a single Boolean value that represents a TRUE or FALSE, '0' or
'1', ON or OFF type of value.

Best Regards,
Chanho Park

> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/ufs/ufs-exynos.c |  4 ++--  drivers/scsi/ufs/ufs-exynos.h |
> 8 ++++----
>  drivers/scsi/ufs/ufshcd.c     |  8 ++++----
>  drivers/scsi/ufs/unipro.h     | 14 --------------
>  4 files changed, 10 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
> index 474a4a064a68..0b99c74955ef 100644
> --- a/drivers/scsi/ufs/ufs-exynos.c
> +++ b/drivers/scsi/ufs/ufs-exynos.c
> @@ -704,7 +704,7 @@ static void exynos_ufs_establish_connt(struct
> exynos_ufs *ufs)
> 
>  	/* local unipro attributes */
>  	ufshcd_dme_set(hba, UIC_ARG_MIB(N_DEVICEID), DEV_ID);
> -	ufshcd_dme_set(hba, UIC_ARG_MIB(N_DEVICEID_VALID), TRUE);
> +	ufshcd_dme_set(hba, UIC_ARG_MIB(N_DEVICEID_VALID), true);
>  	ufshcd_dme_set(hba, UIC_ARG_MIB(T_PEERDEVICEID), PEER_DEV_ID);
>  	ufshcd_dme_set(hba, UIC_ARG_MIB(T_PEERCPORTID), PEER_CPORT_ID);
>  	ufshcd_dme_set(hba, UIC_ARG_MIB(T_CPORTFLAGS), CPORT_DEF_FLAGS); @@
> -1028,7 +1028,7 @@ static int exynos_ufs_post_link(struct ufs_hba *hba)
> 
>  	if (ufs->opts & EXYNOS_UFS_OPT_SKIP_CONNECTION_ESTAB)
>  		ufshcd_dme_set(hba,
> -			UIC_ARG_MIB(T_DBG_SKIP_INIT_HIBERN8_EXIT), TRUE);
> +			UIC_ARG_MIB(T_DBG_SKIP_INIT_HIBERN8_EXIT), true);
> 
>  	if (attr->pa_granularity) {
>  		exynos_ufs_enable_dbg_mode(hba);
> diff --git a/drivers/scsi/ufs/ufs-exynos.h b/drivers/scsi/ufs/ufs-exynos.h
> index 1c33e5466082..0b0a3d530ca6 100644
> --- a/drivers/scsi/ufs/ufs-exynos.h
> +++ b/drivers/scsi/ufs/ufs-exynos.h
> @@ -248,22 +248,22 @@ long exynos_ufs_calc_time_cntr(struct exynos_ufs *,
> long);
> 
>  static inline void exynos_ufs_enable_ov_tm(struct ufs_hba *hba)  {
> -	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_OV_TM), TRUE);
> +	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_OV_TM), true);
>  }
> 
>  static inline void exynos_ufs_disable_ov_tm(struct ufs_hba *hba)  {
> -	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_OV_TM), FALSE);
> +	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_OV_TM), false);
>  }
> 
>  static inline void exynos_ufs_enable_dbg_mode(struct ufs_hba *hba)  {
> -	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_MODE), TRUE);
> +	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_MODE), true);
>  }
> 
>  static inline void exynos_ufs_disable_dbg_mode(struct ufs_hba *hba)  {
> -	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_MODE), FALSE);
> +	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_DBG_MODE), false);
>  }
> 
>  #endif /* _UFS_EXYNOS_H_ */
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
> c36658d97774..c81b5f3f0b9a 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -4325,18 +4325,18 @@ static int ufshcd_change_power_mode(struct ufs_hba
> *hba,
>  			pwr_mode->lane_rx);
>  	if (pwr_mode->pwr_rx == FASTAUTO_MODE ||
>  			pwr_mode->pwr_rx == FAST_MODE)
> -		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_RXTERMINATION), TRUE);
> +		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_RXTERMINATION), true);
>  	else
> -		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_RXTERMINATION), FALSE);
> +		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_RXTERMINATION), false);
> 
>  	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TXGEAR), pwr_mode->gear_tx);
>  	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_ACTIVETXDATALANES),
>  			pwr_mode->lane_tx);
>  	if (pwr_mode->pwr_tx == FASTAUTO_MODE ||
>  			pwr_mode->pwr_tx == FAST_MODE)
> -		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TXTERMINATION), TRUE);
> +		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TXTERMINATION), true);
>  	else
> -		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TXTERMINATION), FALSE);
> +		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TXTERMINATION), false);
> 
>  	if (pwr_mode->pwr_rx == FASTAUTO_MODE ||
>  	    pwr_mode->pwr_tx == FASTAUTO_MODE || diff --git
> a/drivers/scsi/ufs/unipro.h b/drivers/scsi/ufs/unipro.h index
> bdd0fa6a3c74..91152d8386e6 100644
> --- a/drivers/scsi/ufs/unipro.h
> +++ b/drivers/scsi/ufs/unipro.h
> @@ -298,20 +298,6 @@ enum ufs_unipro_ver {
>  #define T_TC0TXMAXSDUSIZE	0x4060
>  #define T_TC1TXMAXSDUSIZE	0x4061
> 
> -#ifdef FALSE
> -#undef FALSE
> -#endif
> -
> -#ifdef TRUE
> -#undef TRUE
> -#endif
> -
> -/* Boolean attribute values */
> -enum {
> -	FALSE = 0,
> -	TRUE,
> -};
> -
>  /* CPort setting */
>  #define E2EFC_ON	(1 << 0)
>  #define E2EFC_OFF	(0 << 0)

