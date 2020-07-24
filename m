Return-Path: <SRS0=9S6W=BD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 322ACC433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jul 2020 09:42:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D03152070B
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jul 2020 09:42:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="GPiiVzUd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgGXJmo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jul 2020 05:42:44 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:28805 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbgGXJmn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jul 2020 05:42:43 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200724094238epoutp03bd12734c8c3330a7589282524ca4fe6f~kpvmW1_2r0559105591epoutp03n
        for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2020 09:42:38 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200724094238epoutp03bd12734c8c3330a7589282524ca4fe6f~kpvmW1_2r0559105591epoutp03n
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1595583758;
        bh=8282XycqjlQUcBz0ZHPEfI7p7irw996L4Enh1eiHhRA=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=GPiiVzUd0+YSpTLKNGLnT45s2Ax/ksnHIA26k3WEzmQ2sg7/oVi/FhC75yf9zW7PY
         g+oXJVC8WwcaFb8JIrWS+9h3oXCy88eyx2lruBGVgbTiz1U/x7UyOiUmXl98CXZupg
         ZL5zCcxr7fcw4HJ68t69YMS22hzTlptRUiy7w5zg=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20200724094238epcas2p3b99a34268366b83cc6e7bd2571226eba~kpvly5xoR2613226132epcas2p3U;
        Fri, 24 Jul 2020 09:42:38 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.189]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4BCkkz47YWzMqYkY; Fri, 24 Jul
        2020 09:42:35 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        65.9E.27013.B0DAA1F5; Fri, 24 Jul 2020 18:42:35 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20200724094235epcas2p3a2ee8e03c8a41fb199c6b7ea0cd35073~kpviynw012612126121epcas2p3h;
        Fri, 24 Jul 2020 09:42:35 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200724094235epsmtrp2148986389851082d7e5218bacfb6c832~kpvix479i2565725657epsmtrp2k;
        Fri, 24 Jul 2020 09:42:35 +0000 (GMT)
X-AuditID: b6c32a48-d1fff70000006985-07-5f1aad0b6cca
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        98.59.08303.A0DAA1F5; Fri, 24 Jul 2020 18:42:34 +0900 (KST)
Received: from KORDO040863 (unknown [12.36.185.126]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20200724094234epsmtip1d77b3f793e109dc8148bf211cffd9742~kpvihY2tD0160201602epsmtip1Q;
        Fri, 24 Jul 2020 09:42:34 +0000 (GMT)
From:   =?UTF-8?B?7ISc7Zi47JiB?= <hy50.seo@samsung.com>
To:     "'Asutosh Das \(asd\)'" <asutoshd@codeaurora.org>,
        <linux-scsi@vger.kernel.org>, <alim.akhtar@samsung.com>,
        <avri.altman@wdc.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <beanhuo@micron.com>,
        <cang@codeaurora.org>, <bvanassche@acm.org>,
        <grant.jung@samsung.com>
In-Reply-To: <91b86407-c9ee-9d3a-c01c-654deba72e75@codeaurora.org>
Subject: RE: [RFC PATCH v2 3/3] scsi: ufs: add vendor specific write booster
 To support the fuction of writebooster by vendor. The WB behavior that the
 vendor wants is slightly different. But we have to support it
Date:   Fri, 24 Jul 2020 18:42:34 +0900
Message-ID: <05cc01d6619e$c2695ba0$473c12e0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQIfIxEdsYJ1mLdzVGY1rs4r3TVr7QGX/GqsAi1+KxwBLEWACAGagF0hAwQrPdGoOGXaQA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGJsWRmVeSWpSXmKPExsWy7bCmhS73Wql4g5tXpSwezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usejGNiaL7us72CyWH//H5MDlcfmKt8flvl4m
        jwmLDjB6fF/fwebx8ektFo++LasYPT5vkvNoP9DNFMARlWOTkZqYklqkkJqXnJ+SmZduq+Qd
        HO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3SjkkJZYk4pUCggsbhYSd/Opii/tCRVISO/
        uMRWKbUgJafA0LBArzgxt7g0L10vOT/XytDAwMgUqDIhJ6P36TvGgtdVFWvev2BqYPyU2MXI
        ySEhYCJx4Pli5i5GLg4hgR2MEqcWnWCHcD4xSvSd38UG4XxmlLiy9TcTTMujaVsYIRK7GCUO
        Pb0C1f+SUeLHqvPMIFVsAqYSfdtWsIIkRATmMUlc+PuKFSTBKeAk8bWrC2yJsMBNRonOXQ1A
        CQ4OFgFViSUr9UFqeAUsJTo2b2KFsAUlTs58wgJiMwtoSyxb+JoZ4gwFiR1nXzOC2CICYRJP
        b11lgqgRkZjd2QZ2kYTADg6Jiy8nsEI0uEh0/TkC9YOwxKvjW9ghbCmJz+/2skHY9RJT7q1i
        gWjuYZTYs+IEVIOxxKxn7YwghzILaEqs36UPYkoIKEscuQV1G59Ex+G/7BBhXomONiGIRiWJ
        M3NvQ4UlJA7OzoEIe0h0fLjPOIFRcRaSJ2cheXIWkmdmIaxdwMiyilEstaA4Nz212KjABDm2
        NzGCE7CWxw7G2W8/6B1iZOJgPMQowcGsJMKrwygeL8SbklhZlVqUH19UmpNafIjRFBjqE5ml
        RJPzgTkgryTe0NTIzMzA0tTC1MzIQkmc953VhTghgfTEktTs1NSC1CKYPiYOTqkGJmMd1zN9
        qp41G1Ljcx14lLZJLe9aa9/S4W6Vci/Ed92HqNOMJvO5J+ZwHXqYlu3AXhbY0Zd6fkvqR6MN
        i/Z1/sgov2j7VtV9tZlzuG0H86TFPXceSPButrTv2Fb/0Vz4adiym7ys2QXSJSlxW36X3Ljz
        zNX1IUMrzy62bu49l//JCHt39dyT+17NET113n67eMH1SvYdGjcrjz1wecu8/bC22dpdbw13
        LfjdvfDAyTUVN1zPPNpo0ZjNauIfY7s1ccIVn4krY2bz7jswf3mB6t+YYwY/C6U+Cuj9/PLt
        imXjbPUjC+u22jNszDv14IWxiJzNvns2B1v/Wsp2s/5tqm3hTZx/+kumnHWpnLqcEktxRqKh
        FnNRcSIAQ3REiUkEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsWy7bCSnC7XWql4gwlTzC0ezNvGZrG37QS7
        xcufV9ksDj7sZLGY9uEns8Wn9ctYLX79Xc9usejGNiaL7us72CyWH//H5MDlcfmKt8flvl4m
        jwmLDjB6fF/fwebx8ektFo++LasYPT5vkvNoP9DNFMARxWWTkpqTWZZapG+XwJVxeNMT9oJl
        5RUXfjxha2BcHNfFyMkhIWAi8WjaFsYuRi4OIYEdjBIbPl5ghEhISPxf3MQEYQtL3G85wgpR
        9JxRYvGk3WBFbAKmEn3bVoAlRARWMEms3j+RDSQhJPCJSeJBMzeIzSngJPG1q4sdpEhY4Cqj
        xPIPS4AcDg4WAVWJJSv1QWp4BSwlOjZvYoWwBSVOznzCAmIzC2hL9D5sZYSxly18zQxxkYLE
        jrOvweIiAmEST29dZYKoEZGY3dnGPIFRaBaSUbOQjJqFZNQsJC0LGFlWMUqmFhTnpucWGxYY
        5aWW6xUn5haX5qXrJefnbmIEx5yW1g7GPas+6B1iZOJgPMQowcGsJMKrwygeL8SbklhZlVqU
        H19UmpNafIhRmoNFSZz366yFcUIC6YklqdmpqQWpRTBZJg5OqQamzLSrYtaOl/IzrQ9xFU/6
        9E3n3M/SjzwPDuZP3+U0y7Aqs5LpwYJvpz1/rJfJfjFPT37XeZ1Mz7gY8au8Fa//3Ck8teed
        ruLH8CCTt9FX/aZdNT2ZxZeiYFMg9vLUyuoTob8SOhc9Loq7u+mJ7b26VTesI048TXqs9Kvk
        GL/31KszDefZFYbacih1tdY7CSi3Hevjjyg/kdxVoGDiGHvL2Du+Ovcm26yereEz42p8d+1j
        ElNynLVio/Y1MTv5Elap9/3MDcF/XlqdqPXj/sQ1JzxV+PsVMXbbg2kte3bfFbh9jzXw+4rz
        s74lzD94bzVX7eJE859uCfb9np+D2jIu/n34xe5TQY6YjWGlX6wSS3FGoqEWc1FxIgD9D7DT
        KAMAAA==
X-CMS-MailID: 20200724094235epcas2p3a2ee8e03c8a41fb199c6b7ea0cd35073
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200720103951epcas2p246072985a70a459f0acb31d339298a47
References: <cover.1595240433.git.hy50.seo@samsung.com>
        <CGME20200720103951epcas2p246072985a70a459f0acb31d339298a47@epcas2p2.samsung.com>
        <5be595eb83365ec97a8ee0ddafb748029ee8cdf9.1595240433.git.hy50.seo@samsung.com>
        <588c1a29-38b9-8c5f-d9c5-899272b9f3a3@codeaurora.org>
        <02dd01d65f43$fc837710$f58a6530$@samsung.com>
        <91b86407-c9ee-9d3a-c01c-654deba72e75@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> >> On 7/20/2020 3:40 AM, SEO HOYOUNG wrote:
> >>> Signed-off-by: SEO HOYOUNG <hy50.seo=40samsung.com>
> >>> ---
> >>>    drivers/scsi/ufs/Makefile     =7C   1 +
> >>>    drivers/scsi/ufs/ufs-exynos.c =7C   6 +
> >>>    drivers/scsi/ufs/ufs_ctmwb.c  =7C 279
> ++++++++++++++++++++++++++++++++++
> >>>    drivers/scsi/ufs/ufs_ctmwb.h  =7C  27 ++++
> >>>    4 files changed, 313 insertions(+)
> >>>    create mode 100644 drivers/scsi/ufs/ufs_ctmwb.c
> >>>    create mode 100644 drivers/scsi/ufs/ufs_ctmwb.h
> >>>
> >>> diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
> >>> index 9810963bc049..b1ba36c7d66f 100644
> >>> --- a/drivers/scsi/ufs/Makefile
> >>> +++ b/drivers/scsi/ufs/Makefile
> >>> =40=40 -5,6 +5,7 =40=40 obj-=24(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) +=3D
> >>> tc-dwc-g210-
> >> pltfrm.o ufshcd-dwc.o tc-d
> >>>    obj-=24(CONFIG_SCSI_UFS_CDNS_PLATFORM) +=3D cdns-pltfrm.o
> >>>    obj-=24(CONFIG_SCSI_UFS_QCOM) +=3D ufs-qcom.o
> >>>    obj-=24(CONFIG_SCSI_UFS_EXYNOS) +=3D ufs-exynos.o
> >>> +obj-=24(CONFIG_SCSI_UFS_VENDOR_WB) +=3D ufs_ctmwb.o
> >>>    obj-=24(CONFIG_SCSI_UFSHCD) +=3D ufshcd-core.o
> >>>    ufshcd-core-y				+=3D ufshcd.o ufs-sysfs.o
> >>>    ufshcd-core-=24(CONFIG_SCSI_UFS_BSG)	+=3D ufs_bsg.o
> >>> diff --git a/drivers/scsi/ufs/ufs-exynos.c
> >>> b/drivers/scsi/ufs/ufs-exynos.c index 32b61ba77241..f127f5f2bf36
> >>> 100644
> >>> --- a/drivers/scsi/ufs/ufs-exynos.c
> >>> +++ b/drivers/scsi/ufs/ufs-exynos.c
> >>> =40=40 -22,6 +22,9 =40=40
> >>>
> >>
> >> To me it looks like, you want to have your own flush policy &
> >> initializations etc, is that understanding correct?
> >> I don't understand why though. The current implementation is spec
> >> compliant. If there're benefits that you see in this implementation,
> >> please highlight those. It'd be interesting to see that.
> >
> > Yes. I want to own flush policy, initialization..
> > I already know current implementation is spec compliant.
> > But some vendor want to change flush policy.
> Ok. It'd be interesting to know the benefits of your flush policy over th=
e
> current one. If it's better, we can replace the current policy, perhaps?
> So please can you highlight those benefits.
At first, our vendor device did not support gear scaling. So we can't use g=
ear scaling code at mainline.
And we want to WB disable after probe. If IO state busy, then we will enabl=
e WB with IO monitoring.
I think always enable WB, then maybe occur power related problems.
So we want to modify those.
> > So we modify below code.
> > Additionally when use below code, we can use WB without UFS 3.1
> > devices
> I guess non-standard stuff should be kept out of ufshcd.c to vendor
> specific files, which I guess you're doing.
> >>
> >>
> >>>    =23include =22ufs-exynos.h=22
> >>>
> >>> +=23ifdef CONFIG_SCSI_UFS_VENDOR_WB
> >>> +=23include =22ufs_ctmwb.h=22
> >>> +=23endif
> >>>    /*
> >>>     * Exynos's Vendor specific registers for UFSHCI
> >>>     */
> >>> =40=40 -989,6 +992,9 =40=40 static int exynos_ufs_init(struct ufs_hba=
 *hba)
> >>>    		goto phy_off;
> >>>
> >>>    	ufs->hba =3D hba;
> >>> +=23ifdef CONFIG_SCSI_UFS_VENDOR_WB
> >>> +	ufs->hba->wb_ops =3D ufshcd_ctmwb_init(); =23endif
> >>>    	ufs->opts =3D ufs->drv_data->opts;
> >>>    	ufs->rx_sel_idx =3D PA_MAXDATALANES;
> >>>    	if (ufs->opts & EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX) diff --git
> >>> a/drivers/scsi/ufs/ufs_ctmwb.c b/drivers/scsi/ufs/ufs_ctmwb.c new
> >>> file mode 100644 index 000000000000..ab39f40721ae
> >>> --- /dev/null
> >>> +++ b/drivers/scsi/ufs/ufs_ctmwb.c
> >>> =40=40 -0,0 +1,279 =40=40
> >>> +=23include =22ufshcd.h=22
> >>> +=23include =22ufshci.h=22
> >>> +=23include =22ufs_ctmwb.h=22
> >>> +
> >>> +static struct ufshba_ctmwb hba_ctmwb;
> >>> +
> >>> +/* Query request retries */
> >>> +=23define QUERY_REQ_RETRIES 3
> >>> +
> >>> +static int ufshcd_query_attr_retry(struct ufs_hba *hba,
> >>> +	enum query_opcode opcode, enum attr_idn idn, u8 index, u8 selector,
> >>> +	u32 *attr_val)
> >>> +=7B
> >>> +	int ret =3D 0;
> >>> +	u32 retries;
> >>> +
> >>> +	 for (retries =3D QUERY_REQ_RETRIES; retries > 0; retries--) =7B
> >>> +		ret =3D ufshcd_query_attr(hba, opcode, idn, index,
> >>> +						selector, attr_val);
> >>> +		if (ret)
> >>> +			dev_dbg(hba->dev, =22%s: failed with error %d,
> >> retries %d=5Cn=22,
> >>> +				__func__, ret, retries);
> >>> +		else
> >>> +			break;
> >>> +	=7D
> >>> +
> >>> +	if (ret)
> >>> +		dev_err(hba->dev,
> >>> +			=22%s: query attribute, idn %d, failed with error %d
> >> after %d retires=5Cn=22,
> >>> +			__func__, idn, ret, QUERY_REQ_RETRIES);
> >>> +	return ret;
> >>> +=7D
> >>> +
> >>> +static int ufshcd_query_flag_retry(struct ufs_hba *hba,
> >>> +	enum query_opcode opcode, enum flag_idn idn, bool *flag_res) =7B
> >>> +	int ret;
> >>> +	int retries;
> >>> +
> >>> +	for (retries =3D 0; retries < QUERY_REQ_RETRIES; retries++) =7B
> >>> +		ret =3D ufshcd_query_flag(hba, opcode, idn, flag_res);
> >>> +		if (ret)
> >>> +			dev_dbg(hba->dev,
> >>> +				=22%s: failed with error %d, retries %d=5Cn=22,
> >>> +				__func__, ret, retries);
> >>> +		else
> >>> +			break;
> >>> +	=7D
> >>> +
> >>> +	if (ret)
> >>> +		dev_err(hba->dev,
> >>> +			=22%s: query attribute, opcode %d, idn %d, failed with
> >> error %d after %d retries=5Cn=22,
> >>> +			__func__, (int)opcode, (int)idn, ret, retries);
> >>> +	return ret;
> >>> +=7D
> >>> +
> >>> +static int ufshcd_reset_ctmwb(struct ufs_hba *hba, bool force) =7B
> >>> +	int err =3D 0;
> >>> +
> >>> +	if (=21hba_ctmwb.support_ctmwb)
> >>> +		return 0;
> >>> +
> >>> +	if (ufshcd_is_ctmwb_off(hba_ctmwb)) =7B
> >>> +		dev_info(hba->dev, =22%s: turbo write already disabled.
> >> ctmwb_state =3D %d=5Cn=22,
> >>> +			__func__, hba_ctmwb.ufs_ctmwb_state);
> >>> +		return 0;
> >>> +	=7D
> >>> +
> >>> +	if (ufshcd_is_ctmwb_err(hba_ctmwb))
> >>> +		dev_err(hba->dev, =22%s: previous turbo write control was
> >> failed.=5Cn=22,
> >>> +			__func__);
> >>> +
> >>> +	if (force)
> >>> +		err =3D ufshcd_query_flag_retry(hba,
> >> UPIU_QUERY_OPCODE_CLEAR_FLAG,
> >>> +				QUERY_FLAG_IDN_WB_EN, NULL);
> >>> +
> >>> +	if (err) =7B
> >>> +		ufshcd_set_ctmwb_err(hba_ctmwb);
> >>> +		dev_err(hba->dev, =22%s: disable turbo write failed. err
> >> =3D %d=5Cn=22,
> >>> +			__func__, err);
> >>> +	=7D else =7B
> >>> +		ufshcd_set_ctmwb_off(hba_ctmwb);
> >>> +		dev_info(hba->dev, =22%s: ufs turbo write disabled =5Cn=22,
> >> __func__);
> >>> +	=7D
> >>> +
> >>> +	return 0;
> >>> +=7D
> >>> +
> >>> +static int ufshcd_get_ctmwb_buf_status(struct ufs_hba *hba, u32
> >>> +*status) =7B
> >>> +	return ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
> >>> +			QUERY_ATTR_IDN_AVAIL_WB_BUFF_SIZE, 0, 0, status); =7D
> >>> +
> >>> +static int ufshcd_ctmwb_manual_flush_ctrl(struct ufs_hba *hba, int
> >>> +en) =7B
> >>> +	int err =3D 0;
> >>> +
> >>> +	dev_info(hba->dev, =22%s: %sable turbo write manual flush=5Cn=22,
> >>> +				__func__, en ? =22en=22 : =22dis=22);
> >>> +	if (en) =7B
> >>> +		err =3D ufshcd_query_flag_retry(hba,
> >> UPIU_QUERY_OPCODE_SET_FLAG,
> >>> +					QUERY_FLAG_IDN_WB_BUFF_FLUSH_EN, NULL);
> >>> +		if (err)
> >>> +			dev_err(hba->dev, =22%s: enable turbo write failed. err
> >> =3D %d=5Cn=22,
> >>> +				__func__, err);
> >>> +	=7D else =7B
> >>> +		err =3D ufshcd_query_flag_retry(hba,
> >> UPIU_QUERY_OPCODE_CLEAR_FLAG,
> >>> +					QUERY_FLAG_IDN_WB_BUFF_FLUSH_EN, NULL);
> >>> +		if (err)
> >>> +			dev_err(hba->dev, =22%s: disable turbo write failed. err
> >> =3D %d=5Cn=22,
> >>> +				__func__, err);
> >>> +	=7D
> >>> +
> >>> +	return err;
> >>> +=7D
> >>> +
> >>> +static int ufshcd_ctmwb_flush_ctrl(struct ufs_hba *hba) =7B
> >>> +	int err =3D 0;
> >>> +	u32 curr_status =3D 0;
> >>> +
> >>> +	err =3D ufshcd_get_ctmwb_buf_status(hba, &curr_status);
> >>> +
> >>> +	if (=21err && (curr_status <=3D UFS_WB_MANUAL_FLUSH_THRESHOLD)) =7B
> >>> +		dev_info(hba->dev, =22%s: enable ctmwb manual flush, buf
> >> status : %d=5Cn=22,
> >>> +				__func__, curr_status);
> >>> +		scsi_block_requests(hba->host);
> >>> +		err =3D ufshcd_ctmwb_manual_flush_ctrl(hba, 1);
> >>> +		if (=21err) =7B
> >>> +			mdelay(100);
> >>> +			err =3D ufshcd_ctmwb_manual_flush_ctrl(hba, 0);
> >>> +			if (err)
> >>> +				dev_err(hba->dev, =22%s: disable ctmwb manual
> >> flush failed. err =3D %d=5Cn=22,
> >>> +						__func__, err);
> >>> +		=7D else
> >>> +			dev_err(hba->dev, =22%s: enable ctmwb manual flush
> >> failed. err =3D %d=5Cn=22,
> >>> +					__func__, err);
> >>> +		scsi_unblock_requests(hba->host);
> >>> +	=7D
> >>> +	return err;
> >>> +=7D
> >>> +
> >>> +static int ufshcd_ctmwb_ctrl(struct ufs_hba *hba, bool enable) =7B
> >>> +	int err;
> >>> +=23if 0
> >> Did you miss removing these =23if 0?
> > I will modify this code.
> >>
> >>> +	if (=21hba->support_ctmwb)
> >>> +		return;
> >>> +
> >>> +	if (hba->pm_op_in_progress) =7B
> >>> +		dev_err(hba->dev, =22%s: ctmwb ctrl during pm operation is not
> >> allowed.=5Cn=22,
> >>> +			__func__);
> >>> +		return;
> >>> +	=7D
> >>> +
> >>> +	if (hba->ufshcd_state =21=3D UFSHCD_STATE_OPERATIONAL) =7B
> >>> +		dev_err(hba->dev, =22%s: ufs host is not available.=5Cn=22,
> >>> +			__func__);
> >>> +		return;
> >>> +	=7D
> >>> +	if (ufshcd_is_ctmwb_err(hba_ctmwb))
> >>> +		dev_err(hba->dev, =22%s: previous turbo write control was
> >> failed.=5Cn=22,
> >>> +			__func__);
> >>> +=23endif
> >>> +	if (enable) =7B
> >>> +		if (ufshcd_is_ctmwb_on(hba_ctmwb)) =7B
> >>> +			dev_err(hba->dev, =22%s: turbo write already enabled.
> >> ctmwb_state =3D %d=5Cn=22,
> >>> +				__func__, hba_ctmwb.ufs_ctmwb_state);
> >>> +			return 0;
> >>> +		=7D
> >>> +		pm_runtime_get_sync(hba->dev);
> >>> +		err =3D ufshcd_query_flag_retry(hba,
> >> UPIU_QUERY_OPCODE_SET_FLAG,
> >>> +					QUERY_FLAG_IDN_WB_EN, NULL);
> >>> +		if (err) =7B
> >>> +			ufshcd_set_ctmwb_err(hba_ctmwb);
> >>> +			dev_err(hba->dev, =22%s: enable turbo write failed. err
> >> =3D %d=5Cn=22,
> >>> +				__func__, err);
> >>> +		=7D else =7B
> >>> +			ufshcd_set_ctmwb_on(hba_ctmwb);
> >>> +			dev_info(hba->dev, =22%s: ufs turbo write enabled =5Cn=22,
> >> __func__);
> >>> +		=7D
> >>> +	=7D else =7B
> >>> +		if (ufshcd_is_ctmwb_off(hba_ctmwb)) =7B
> >>> +			dev_err(hba->dev, =22%s: turbo write already disabled.
> >> ctmwb_state =3D %d=5Cn=22,
> >>> +				__func__, hba_ctmwb.ufs_ctmwb_state);
> >>> +			return 0;
> >>> +		=7D
> >>> +		pm_runtime_get_sync(hba->dev);
> >>> +		err =3D ufshcd_query_flag_retry(hba,
> >> UPIU_QUERY_OPCODE_CLEAR_FLAG,
> >>> +					QUERY_FLAG_IDN_WB_EN, NULL);
> >>> +		if (err) =7B
> >>> +			ufshcd_set_ctmwb_err(hba_ctmwb);
> >>> +			dev_err(hba->dev, =22%s: disable turbo write failed. err
> >> =3D %d=5Cn=22,
> >>> +				__func__, err);
> >>> +		=7D else =7B
> >>> +			ufshcd_set_ctmwb_off(hba_ctmwb);
> >>> +			dev_info(hba->dev, =22%s: ufs turbo write disabled =5Cn=22,
> >> __func__);
> >> What is 'turbo write'?
> > I wrote it wrong. I will collect it.
> >
> >>> +		=7D
> >>> +	=7D
> >>> +
> >>> +	pm_runtime_put_sync(hba->dev);
> >>> +
> >>> +	return 0;
> >>> +=7D
> >>> +
> >>> +/**
> >>> + * ufshcd_get_ctmwbbuf_unit - get ctmwb buffer alloc units
> >>> + * =40sdev: pointer to SCSI device
> >>> + *
> >>> + * Read dLUNumTurboWriteBufferAllocUnits in UNIT Descriptor
> >>> + * to check if LU supports turbo write feature  */ static int
> >>> +ufshcd_get_ctmwbbuf_unit(struct ufs_hba *hba) =7B
> >>> +	struct scsi_device *sdev =3D hba->sdev_ufs_device;
> >>> +	struct ufshba_ctmwb *hba_ctmwb =3D (struct ufshba_ctmwb *)hba->wb_o=
ps;
> >>> +	int ret =3D 0;
> >>> +
> >>> +	u32 dLUNumTurboWriteBufferAllocUnits =3D 0;
> >>> +	u8 desc_buf=5B4=5D;
> >>> +
> >>> +	if (=21hba_ctmwb->support_ctmwb)
> >>> +		return 0;
> >>> +
> >>> +	ret =3D ufshcd_read_unit_desc_param(hba,
> >>> +			ufshcd_scsi_to_upiu_lun(sdev->lun),
> >>> +			UNIT_DESC_PARAM_WB_BUF_ALLOC_UNITS,
> >>> +			desc_buf,
> >>> +			sizeof(dLUNumTurboWriteBufferAllocUnits));
> >>> +
> >>> +	/* Some WLUN doesn't support unit descriptor */
> >>> +	if ((ret =3D=3D -EOPNOTSUPP) =7C=7C scsi_is_wlun(sdev->lun))=7B
> >>> +		hba_ctmwb->support_ctmwb_lu =3D false;
> >>> +		dev_info(hba->dev,=22%s: do not support WB=5Cn=22, __func__);
> >>> +		return 0;
> >>> +	=7D
> >>> +
> >>> +	dLUNumTurboWriteBufferAllocUnits =3D ((desc_buf=5B0=5D << 24)=7C
> >>> +			(desc_buf=5B1=5D << 16) =7C
> >>> +			(desc_buf=5B2=5D << 8) =7C
> >>> +			desc_buf=5B3=5D);
> >>> +
> >>> +	if (dLUNumTurboWriteBufferAllocUnits) =7B
> >>> +		hba_ctmwb->support_ctmwb_lu =3D true;
> >>> +		dev_info(hba->dev, =22%s: LU %d supports ctmwb, ctmwbbuf unit :
> >> 0x%x=5Cn=22,
> >>> +				__func__, (int)sdev->lun,
> >> dLUNumTurboWriteBufferAllocUnits);
> >>> +	=7D else
> >>> +		hba_ctmwb->support_ctmwb_lu =3D false;
> >>> +
> >>> +	return 0;
> >>> +=7D
> >>> +
> >>> +static inline int ufshcd_ctmwb_toggle_flush(struct ufs_hba *hba,
> >>> +enum ufs_pm_op pm_op) =7B
> >>> +	ufshcd_ctmwb_flush_ctrl(hba);
> >>> +
> >>> +	if (ufshcd_is_system_pm(pm_op))
> >>> +		ufshcd_reset_ctmwb(hba, true);
> >>> +
> >>> +	return 0;
> >>> +=7D
> >>> +
> >>> +static struct ufs_wb_ops exynos_ctmwb_ops =3D =7B
> >>> +	.wb_toggle_flush_vendor =3D ufshcd_ctmwb_toggle_flush,
> >>> +	.wb_alloc_units_vendor =3D ufshcd_get_ctmwbbuf_unit,
> >>> +	.wb_ctrl_vendor =3D ufshcd_ctmwb_ctrl,
> >>> +	.wb_reset_vendor =3D ufshcd_reset_ctmwb, =7D;
> >>> +
> >>> +struct ufs_wb_ops *ufshcd_ctmwb_init(void) =7B
> >>> +	hba_ctmwb.support_ctmwb =3D 1;
> >>> +
> >>> +	return &exynos_ctmwb_ops;
> >>> +=7D
> >>> +EXPORT_SYMBOL_GPL(ufshcd_ctmwb_init);
> >>> +
> >>> diff --git a/drivers/scsi/ufs/ufs_ctmwb.h
> >>> b/drivers/scsi/ufs/ufs_ctmwb.h new file mode 100644 index
> >>> 000000000000..073e21a4900b
> >>> --- /dev/null
> >>> +++ b/drivers/scsi/ufs/ufs_ctmwb.h
> >>> =40=40 -0,0 +1,27 =40=40
> >>> +=23ifndef _UFS_CTMWB_H_
> >>> +=23define _UFS_CTMWB_H_
> >>> +
> >>> +enum ufs_ctmwb_state =7B
> >>> +       UFS_WB_OFF_STATE	=3D 0,    /* turbo write disabled state */
> >>> +       UFS_WB_ON_STATE	=3D 1,            /* turbo write enabled stat=
e */
> >>> +       UFS_WB_ERR_STATE	=3D 2,            /* turbo write error state=
 */
> >>> +=7D;
> >>> +
> >>> +=23define ufshcd_is_ctmwb_off(hba) ((hba).ufs_ctmwb_state =3D=3D
> >>> +UFS_WB_OFF_STATE) =23define ufshcd_is_ctmwb_on(hba)
> >>> +((hba).ufs_ctmwb_state =3D=3D UFS_WB_ON_STATE) =23define
> >>> +ufshcd_is_ctmwb_err(hba) ((hba).ufs_ctmwb_state =3D=3D
> >>> +UFS_WB_ERR_STATE) =23define ufshcd_set_ctmwb_off(hba)
> >>> +((hba).ufs_ctmwb_state =3D
> >>> +UFS_WB_OFF_STATE) =23define ufshcd_set_ctmwb_on(hba)
> >>> +((hba).ufs_ctmwb_state =3D UFS_WB_ON_STATE) =23define
> >>> +ufshcd_set_ctmwb_err(hba) ((hba).ufs_ctmwb_state =3D
> >>> +UFS_WB_ERR_STATE)
> >>> +
> >>> +=23define UFS_WB_MANUAL_FLUSH_THRESHOLD	5
> >>> +
> >>> +struct ufshba_ctmwb =7B
> >>> +	enum ufs_ctmwb_state ufs_ctmwb_state;
> >>> +	bool support_ctmwb;
> >>> +
> >>> +	bool support_ctmwb_lu;
> >>> +=7D;
> >>> +
> >>> +struct ufs_wb_ops *ufshcd_ctmwb_init(void); =23endif
> >>>
> >>
> >> -Asutosh
> >>
> >> --
> >> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
> >> Forum, Linux Foundation Collaborative Project
> >
>=20
> -Asutosh
>=20
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum=
,
> Linux Foundation Collaborative Project

