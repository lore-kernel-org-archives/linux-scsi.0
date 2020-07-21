Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 497FEC433E2
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 09:26:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1F042072E
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 09:26:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="P7uI+ml5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbgGUJ0a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 05:26:30 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:34461 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbgGUJ0a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 05:26:30 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200721092627epoutp01bb8be0ec5198aa95628ea78c8b768634~julmfRWsi1874918749epoutp01C
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:26:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200721092627epoutp01bb8be0ec5198aa95628ea78c8b768634~julmfRWsi1874918749epoutp01C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1595323587;
        bh=+lVBmDIESFw7AnD/P+WW2GXJkfUXldUMsAcynf5cgKo=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=P7uI+ml5AfUy7zV+fH5v+JivMNPAzCxHf/XgjF2BS0eBtlUJIZUjgNIMdh7R1dXet
         LWp61Ota3Q5RXkBMta3nmSn1pgrBy+bYEIC/g0ZacNWgFMsgtHyXeDAZsJBklQvBXV
         N7E6E4PYhQWJU5YO7NR3a6JxlJoA9kQBYIAj39rA=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20200721092626epcas2p2a173343502055725d60ac117c4f7b689~jull72F_L0485104851epcas2p2X;
        Tue, 21 Jul 2020 09:26:26 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.191]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4B9tWh2YCvzMqYkb; Tue, 21 Jul
        2020 09:26:24 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        05.C0.27013.0C4B61F5; Tue, 21 Jul 2020 18:26:24 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20200721092623epcas2p154fd67707660fa808b4596ee3f6faf6c~juljZRe5S0211502115epcas2p1O;
        Tue, 21 Jul 2020 09:26:23 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200721092623epsmtrp2b96dccba095439a8d64a8efdd7c4aea0~juljYfhLz2068820688epsmtrp2p;
        Tue, 21 Jul 2020 09:26:23 +0000 (GMT)
X-AuditID: b6c32a48-d1fff70000006985-0e-5f16b4c09602
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        66.66.08303.FB4B61F5; Tue, 21 Jul 2020 18:26:23 +0900 (KST)
Received: from KORDO040863 (unknown [12.36.185.126]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200721092623epsmtip23e6e61cac18e485285a1e4dd4234ad18~juljIEbfc2136321363epsmtip2U;
        Tue, 21 Jul 2020 09:26:23 +0000 (GMT)
From:   =?UTF-8?B?7ISc7Zi47JiB?= <hy50.seo@samsung.com>
To:     "'Asutosh Das \(asd\)'" <asutoshd@codeaurora.org>,
        <linux-scsi@vger.kernel.org>, <alim.akhtar@samsung.com>,
        <avri.altman@wdc.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <beanhuo@micron.com>,
        <cang@codeaurora.org>, <bvanassche@acm.org>,
        <grant.jung@samsung.com>
In-Reply-To: <4a4c1753-b78d-30eb-b086-5812b67de31a@codeaurora.org>
Subject: RE: [RFC PATCH v2 1/3] scsi: ufs: modify write booster
Date:   Tue, 21 Jul 2020 18:26:23 +0900
Message-ID: <02d401d65f41$003e6390$00bb2ab0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQIfIxEdsYJ1mLdzVGY1rs4r3TVr7QIVJnx0AhyXLpAB9kJpWahOj9SQ
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMJsWRmVeSWpSXmKPExsWy7bCmue6BLWLxBvsbWS0ezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usejGNiaL7us72CyWH//H5MDlcfmKt8flvl4m
        jwmLDjB6fF/fwebx8ektFo++LasYPT5vkvNoP9DNFMARlWOTkZqYklqkkJqXnJ+SmZduq+Qd
        HO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3SjkkJZYk4pUCggsbhYSd/Opii/tCRVISO/
        uMRWKbUgJafA0LBArzgxt7g0L10vOT/XytDAwMgUqDIhJ+PsuwvsBX9MK45e38jUwLhPq4uR
        k0NCwETi5eYPbCC2kMAORonG54ldjFxA9idGiWMHGtkgnM+MEntPTGCG6dj4aRILRMcuRolz
        xzghil4ySsxdPp8VJMEmYCrRt20FK0hCRGAek8SFv6/AEpwCThLLm3vA9gkL2Ess33GCCcRm
        EVCVmPf9M5jNK2Ap0fXhFQuELShxcuYTMJtZQF5i+9s5UFcoSOw4+5oRxBYRcJP48vY+O0SN
        iMTszjZmkMUSAls4JKYcmwbUzAHkuEj8aDCA6BWWeHV8CzuELSXx+d1eNgi7XmLKvVUsEL09
        jBJ7VkAcJyFgLDHrWTsjyBxmAU2J9bv0IUYqSxy5BXUan0TH4b/sEGFeiY42IYhGJYkzc29D
        hSUkDs7OgQh7SCw6+555AqPiLCQ/zkLy4ywkv8xCWLuAkWUVo1hqQXFuemqxUYEJclRvYgSn
        Xi2PHYyz337QO8TIxMF4iFGCg1lJhHcij3C8EG9KYmVValF+fFFpTmrxIUZTYKhPZJYSTc4H
        Jv+8knhDUyMzMwNLUwtTMyMLJXHed1YX4oQE0hNLUrNTUwtSi2D6mDg4pRqYZvGGFTU/rs6r
        Ss1py15R8yGmdfKyrUk/ZnPW2cy9yTuZsy3/12mNMzv7Tm9et0P45xv1o/Y2zfZV6yWiN+na
        RTHzb/ig7pb0o8Nai80mZ6+XQGgWD7uP2Bq2GZKC2yIftpiwnX6klZ5uf2KCYVSgRuSxr1l1
        vrzzrrw4pxp4r1V9x++m+ykO82WOp/n5ir2V/izzReS6Tl/Nzq6AIx/TSuOXlcaJcXin2qQH
        9jVNV1TgWDInOiljQZ323LDGv3PVV9zboJwpbjv3w+Z2RvvAruT97Nfda89vm6x+Vv52RVp9
        a9PJ29XaojsVFjLfPPfhsri7UpRQ2LXvZwwbi/ZsmP/j7vv04m4HyxCpPCWW4oxEQy3mouJE
        AF+FYd1GBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsWy7bCSvO7+LWLxBp8Xq1o8mLeNzWJv2wl2
        i5c/r7JZHHzYyWIx7cNPZotP65exWvz6u57dYtGNbUwW3dd3sFksP/6PyYHL4/IVb4/Lfb1M
        HhMWHWD0+L6+g83j49NbLB59W1YxenzeJOfRfqCbKYAjissmJTUnsyy1SN8ugSvj7LsL7AV/
        TCuOXt/I1MC4T6uLkZNDQsBEYuOnSSxdjFwcQgI7GCUWrTrODJGQkPi/uIkJwhaWuN9yhBWi
        6DmjxNUzfawgCTYBU4m+bSvAEiICK5gkVu+fyAZR1cckMa3pB9goTgEnieXNPWwgtrCAvcTy
        HSfAxrIIqErM+/4ZzOYVsJTo+vCKBcIWlDg58wmYzSygLdH7sJURwpaX2P52DtR5ChI7zr4G
        i4sIuEl8eXufHaJGRGJ2ZxvzBEahWUhGzUIyahaSUbOQtCxgZFnFKJlaUJybnltsWGCUl1qu
        V5yYW1yal66XnJ+7iREcdVpaOxj3rPqgd4iRiYPxEKMEB7OSCO9EHuF4Id6UxMqq1KL8+KLS
        nNTiQ4zSHCxK4rxfZy2MExJITyxJzU5NLUgtgskycXBKNTA13cv97rZKv2L/88y7ivOnJ/46
        yMli7JaVZuDl8aFR65/6aiN9q4Lw/xwNZ4wvXuT3mLW0st1G2zAyIU1kt3Svo+ySP1d0r/U8
        r4iPf55ycHH1FqP7olt4Jk2v7y1c+u3rhSUXkgr6n3rabcw/9JbTN2nlj0pRnrPTkl7xbb4s
        o6B53kzETCZ+xgL59G836s+syXf9vrj9XcjbWVfuSNxlfPOX8dnapC2bmn+IXDrG1zXnu8DZ
        FSq32sqyuZ7/ncnvq7skT+rO/097T4jEuOY+Wp7ck+N/7MU32dqyd8u+iuTMOOOh0rDGZnZ1
        gZKt93Mnnbe9th6zww2029bvZLx3s+7p4Y2P15V/3aoxXdJGiaU4I9FQi7moOBEAFq54dCkD
        AAA=
X-CMS-MailID: 20200721092623epcas2p154fd67707660fa808b4596ee3f6faf6c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200720103949epcas2p4a49b245d9cebf0478d42fb6c607fc236
References: <cover.1595240433.git.hy50.seo@samsung.com>
        <CGME20200720103949epcas2p4a49b245d9cebf0478d42fb6c607fc236@epcas2p4.samsung.com>
        <a4db9e7982c4dcd00b4adbcb5d247261a7ec0c27.1595240433.git.hy50.seo@samsung.com>
        <4a4c1753-b78d-30eb-b086-5812b67de31a@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: asutoshd=codeaurora.org@mg.codeaurora.org
> [mailto:asutoshd=codeaurora.org@mg.codeaurora.org] On Behalf Of Asutosh
> Das (asd)
> Sent: Tuesday, July 21, 2020 1:47 AM
> To: SEO HOYOUNG; linux-scsi@vger.kernel.org; alim.akhtar@samsung.com;
> avri.altman@wdc.com; jejb@linux.ibm.com; martin.petersen@oracle.com;
> beanhuo@micron.com; cang@codeaurora.org; bvanassche@acm.org;
> grant.jung@samsung.com
> Subject: Re: [RFC PATCH v2 1/3] scsi: ufs: modify write booster
> 
> On 7/20/2020 3:40 AM, SEO HOYOUNG wrote:
> > Add vendor specific functions for WB
> > Use callback additional setting when use write booster.
> >
> > Signed-off-by: SEO HOYOUNG <hy50.seo@samsung.com>
> > ---
> >   drivers/scsi/ufs/ufshcd.c | 23 ++++++++++++++++-----
> >   drivers/scsi/ufs/ufshcd.h | 43 +++++++++++++++++++++++++++++++++++++++
> >   2 files changed, 61 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index efc0a6cbfe22..efa16bf4fd76 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -3306,11 +3306,11 @@ int ufshcd_read_string_desc(struct ufs_hba *hba,
> u8 desc_index,
> >    *
> >    * Return 0 in case of success, non-zero otherwise
> >    */
> > -static inline int ufshcd_read_unit_desc_param(struct ufs_hba *hba,
> > -					      int lun,
> > -					      enum unit_desc_param param_offset,
> > -					      u8 *param_read_buf,
> > -					      u32 param_size)
> > +int ufshcd_read_unit_desc_param(struct ufs_hba *hba,
> > +				int lun,
> > +				enum unit_desc_param param_offset,
> > +				u8 *param_read_buf,
> > +				u32 param_size)
> >   {
> >   	/*
> >   	 * Unit descriptors are only available for general purpose LUs (LUN
> > id @@ -3322,6 +3322,7 @@ static inline int
> ufshcd_read_unit_desc_param(struct ufs_hba *hba,
> >   	return ufshcd_read_desc_param(hba, QUERY_DESC_IDN_UNIT, lun,
> >   				      param_offset, param_read_buf, param_size);
> >   }
> > +EXPORT_SYMBOL_GPL(ufshcd_read_unit_desc_param);
> >
> >   static int ufshcd_get_ref_clk_gating_wait(struct ufs_hba *hba)
> >   {
> > @@ -5257,6 +5258,10 @@ static int ufshcd_wb_ctrl(struct ufs_hba *hba,
> > bool enable)
> >
> >   	if (!(enable ^ hba->wb_enabled))
> >   		return 0;
> > +
> > +	if (!ufshcd_wb_ctrl_vendor(hba, enable))
> > +		return 0;
> > +
> >   	if (enable)
> >   		opcode = UPIU_QUERY_OPCODE_SET_FLAG;
> >   	else
> > @@ -6610,6 +6615,8 @@ static int ufshcd_reset_and_restore(struct ufs_hba
> *hba)
> >   	int err = 0;
> >   	int retries = MAX_HOST_RESET_RETRIES;
> >
> > +	ufshcd_reset_vendor(hba);
> > +
> >   	do {
> >   		/* Reset the attached device */
> >   		ufshcd_vops_device_reset(hba);
> > @@ -6903,6 +6910,9 @@ static void ufshcd_wb_probe(struct ufs_hba *hba,
> u8 *desc_buf)
> >   	if (!(dev_info->d_ext_ufs_feature_sup & UFS_DEV_WRITE_BOOSTER_SUP))
> >   		goto wb_disabled;
> >
> > +	if (!ufshcd_wb_alloc_units_vendor(hba))
> > +		return;
> I didn't understand this check. Have you considered this -
> ufshcd_is_wb_allowed(...).
Ok. I will modify to using this function

> > +
> >   	/*
> >   	 * WB may be supported but not configured while provisioning.
> >   	 * The spec says, in dedicated wb buffer mode, @@ -8260,6 +8270,7
> > @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
> >   			/* make sure that auto bkops is disabled */
> >   			ufshcd_disable_auto_bkops(hba);
> >   		}
> > +
> Unnecessary new line, perhaps?
I will remove new line.
> >   		/*
> >   		 * If device needs to do BKOP or WB buffer flush during
> >   		 * Hibern8, keep device power mode as "active power mode"
> > @@ -8273,6 +8284,8 @@ static int ufshcd_suspend(struct ufs_hba *hba,
> enum ufs_pm_op pm_op)
> >   			ufshcd_wb_need_flush(hba));
> >   	}
> >
> > +	ufshcd_wb_toggle_flush_vendor(hba, pm_op);
> > +
> >   	if (req_dev_pwr_mode != hba->curr_dev_pwr_mode) {
> >   		if ((ufshcd_is_runtime_pm(pm_op) && !hba->auto_bkops_enabled)
> ||
> >   		    !ufshcd_is_runtime_pm(pm_op)) { diff --git
> > a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h index
> > 656c0691c858..deb9577e0eaa 100644
> > --- a/drivers/scsi/ufs/ufshcd.h
> > +++ b/drivers/scsi/ufs/ufshcd.h
> > @@ -254,6 +254,13 @@ struct ufs_pwr_mode_info {
> >   	struct ufs_pa_layer_attr info;
> >   };
> >
> > +struct ufs_wb_ops {
> > +	int (*wb_toggle_flush_vendor)(struct ufs_hba *hba, enum ufs_pm_op
> pm_op);
> > +	int (*wb_alloc_units_vendor)(struct ufs_hba *hba);
> > +	int (*wb_ctrl_vendor)(struct ufs_hba *hba, bool enable);
> > +	int (*wb_reset_vendor)(struct ufs_hba *hba, bool force); };
> > +
> >   /**
> >    * struct ufs_hba_variant_ops - variant specific callbacks
> >    * @name: variant name
> > @@ -752,6 +759,7 @@ struct ufs_hba {
> >   	struct request_queue	*bsg_queue;
> >   	bool wb_buf_flush_enabled;
> >   	bool wb_enabled;
> > +	struct ufs_wb_ops *wb_ops;
> >   	struct delayed_work rpm_dev_flush_recheck_work;
> >
> >   #ifdef CONFIG_SCSI_UFS_CRYPTO
> > @@ -1004,6 +1012,10 @@ int ufshcd_exec_raw_upiu_cmd(struct ufs_hba *hba,
> >   			     u8 *desc_buff, int *buff_len,
> >   			     enum query_opcode desc_op);
> >
> > +int ufshcd_read_unit_desc_param(struct ufs_hba *hba,
> > +				int lun, enum unit_desc_param param_offset,
> > +				u8 *param_read_buf, u32 param_size);
> > +
> >   /* Wrapper functions for safely calling variant operations */
> >   static inline const char *ufshcd_get_var_name(struct ufs_hba *hba)
> >   {
> > @@ -1181,4 +1193,35 @@ static inline u8 ufshcd_scsi_to_upiu_lun(unsigned
> int scsi_lun)
> >   int ufshcd_dump_regs(struct ufs_hba *hba, size_t offset, size_t len,
> >   		     const char *prefix);
> >
> > +static inline int ufshcd_wb_toggle_flush_vendor(struct ufs_hba *hba,
> > +enum ufs_pm_op pm_op) {
> > +	if (!hba->wb_ops || !hba->wb_ops->wb_toggle_flush_vendor)
> > +		return -1;
> > +
> > +	return hba->wb_ops->wb_toggle_flush_vendor(hba, pm_op); }
> > +
> > +static int ufshcd_wb_alloc_units_vendor(struct ufs_hba *hba) {
> > +	if (!hba->wb_ops || !hba->wb_ops->wb_alloc_units_vendor)
> > +		return -1;
> > +
> > +	return hba->wb_ops->wb_alloc_units_vendor(hba);
> > +}
> > +
> > +static int ufshcd_wb_ctrl_vendor(struct ufs_hba *hba, bool enable) {
> > +	if (!hba->wb_ops || !hba->wb_ops->wb_ctrl_vendor)
> > +		return -1;
> > +
> > +	return hba->wb_ops->wb_ctrl_vendor(hba, enable); }
> > +
> > +static int ufshcd_reset_vendor(struct ufs_hba *hba) {
> > +	if (!hba->wb_ops || !hba->wb_ops->wb_reset_vendor)
> > +		return -1;
> > +
> > +	return hba->wb_ops->wb_reset_vendor(hba, false); }
> >   #endif /* End of Header */
> >
> 
> 
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> Linux Foundation Collaborative Project

