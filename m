Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0DF6C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 04:23:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9A61207E8
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 04:23:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="gplmF9qv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgF3EXw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 00:23:52 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:56257 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726264AbgF3EXv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2020 00:23:51 -0400
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200630042348epoutp045b5b7455045363f715059b27ff6bb8ca~dN6XH1fBY2014320143epoutp04Q
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2020 04:23:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200630042348epoutp045b5b7455045363f715059b27ff6bb8ca~dN6XH1fBY2014320143epoutp04Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593491028;
        bh=h4hpE3FKkVtePSSSMQRCT+rFKhK6RlC6FH2mLfLLni4=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=gplmF9qvbiCOlobgwTBqbYYKX76CZ8chhUtOs2obxuJbzyqgzk+oQLs9p/GiD7IV3
         J2QD+yzLlZBAUoJIolAqiSv1mBmAQ90N0L92lFX2/rB2trZ0YCn2JMezeScOezIEz0
         Q9jFhuZMLIG05ChTmHPRD3WMU5tfTFbM8cDpAKrI=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200630042348epcas1p232c387232e76dd71e9b7864784658650~dN6W9F6nX0634906349epcas1p2D;
        Tue, 30 Jun 2020 04:23:48 +0000 (GMT)
Received: from epsmges1p1.samsung.com (unknown [182.195.40.163]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 49wrp95qwHzMqYks; Tue, 30 Jun
        2020 04:23:45 +0000 (GMT)
Received: from epcas1p3.samsung.com ( [182.195.41.47]) by
        epsmges1p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        FD.B4.18978.15EBAFE5; Tue, 30 Jun 2020 13:23:45 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200630042345epcas1p286198fd196b4a5facf72cbd439105de5~dN6UMfPAs2718027180epcas1p2l;
        Tue, 30 Jun 2020 04:23:45 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200630042345epsmtrp1700fcbf92634967289da254230bcb52e~dN6UL4hzx2668226682epsmtrp1X;
        Tue, 30 Jun 2020 04:23:45 +0000 (GMT)
X-AuditID: b6c32a35-603ff70000004a22-41-5efabe51eb5c
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        93.AC.08303.15EBAFE5; Tue, 30 Jun 2020 13:23:45 +0900 (KST)
Received: from grantjung02 (unknown [10.214.113.116]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200630042345epsmtip28e8e15f1c1bfc653a92af8f9258cc998~dN6UDOu0g1521715217epsmtip2d;
        Tue, 30 Jun 2020 04:23:45 +0000 (GMT)
From:   "Grant Jung" <grant.jung@samsung.com>
To:     "'Kiwoong Kim'" <kwmad.kim@samsung.com>,
        <linux-scsi@vger.kernel.org>
In-Reply-To: <1ca1a52df36ad3393c0487537832cf7f0a7e1260.1593412974.git.kwmad.kim@samsung.com>
Subject: RE: [RFC PATCH v2 2/2] ufs: change the way to complete fDeviceInit
Date:   Tue, 30 Jun 2020 13:23:44 +0900
Message-ID: <047001d64e96$3e3dd970$bab98c50$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQFK3dcLjmJa+k4JeQp1dmQok7cMGwJjn9aGAdeRtSqp5YfbwA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAKsWRmVeSWpSXmKPExsWy7bCmvm7gvl9xBg+e6Fnc3HKUxaL7+g42
        ByaPvi2rGD0+b5ILYIrKsclITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21
        VXLxCdB1y8wBGq+kUJaYUwoUCkgsLlbSt7Mpyi8tSVXIyC8usVVKLUjJKTA0KNArTswtLs1L
        10vOz7UyNDAwMgWqTMjJeDCvvqBbpuLp4hcsDYxbxboYOTkkBEwkWmedYO1i5OIQEtjBKNHf
        f5EdwvnEKLFtYT8TSJWQwGdGiYm7OWA6pm15zQhRtItR4vjSnVDOK0aJmR19jCBVbALaEhN3
        fQbrFhHwlPhz/DY7iM0pECOxeMkzZhBbWMBbYtOx6UC7OThYBFQlrr+WBgnzClhK/Huzmx3C
        FpQ4OfMJC4jNDDRy2cLXzBBHKEj8fLqMFWK8k8TUR1MZIWpEJGZ3tjGD3CMhcIpdYt3j2SwQ
        DS4SWycuYIKwhSVeHd/CDmFLSbzsb2OHaGhnlJg6p40VwulglGg5dBeqylji0+fPjCCXMgto
        SqzfpQ8RVpTY+Xsu1GY+iXdfe8CekRDglehoE4IoUZE4ufEWK8yuB/vmQT3gIXHo9RTWCYyK
        s5D8OQvJn7OQ/DMLYfECRpZVjGKpBcW56anFhgWGyJG9iRGc9LRMdzBOfPtB7xAjEwfjIUYJ
        DmYlEd7TBr/ihHhTEiurUovy44tKc1KLDzGaAgN+IrOUaHI+MO3mlcQbmhoZGxtbmJiZm5ka
        K4nzistciBMSSE8sSc1OTS1ILYLpY+LglGpgivvdsGdVvrHDgY2Lzn3jCJvwSmf9Jdvs2PDn
        zyJOVuo2xX3k0z/T5NoqseKL21Ov7h+L71fumP/g+q51tt+PrXvst3OSqmeNw7Xkr195t39o
        cpmaudv7zMKOkOM7X1lIshcVKDM95g55//qmZ8fSl5eulj6SfDf56ykeV3XWc/MWvOyVfn26
        el0Kxwdro21d75Ry1pzrFvNc+OBurPvxFQ6MpwoPdDassOX8nvswhWdPVNG9+fuX+SppFL0N
        iS5bs2A5i+Dqy2ULsjbJ5T+bJrnzW71wjlB7YE1I2vOu1maxWN/zbfVu27T6OGyZbZlFdzvr
        sB0IE9I/xatUv2WBz70LGgs3P699/onZ/NKet0osxRmJhlrMRcWJAGmfavkDBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsWy7bCSvG7gvl9xBhf+sFrc3HKUxaL7+g42
        ByaPvi2rGD0+b5ILYIrisklJzcksSy3St0vgypg6YQF7wWrpigNrbRoYL4p2MXJySAiYSEzb
        8pqxi5GLQ0hgB6NE/8knjBAJKYnFlx8wdzFyANnCEocPF0PUvGCUmLB8BzNIDZuAtsTEXZ+Z
        QGwRAW+J02/3sEMU3WKUOLXkONggToEYicVLnoE1CAMVbTo2nRVkKIuAqsT119IgYV4BS4l/
        b3azQ9iCEidnPmEBsZmB5vc+bGWEsZctfM0McZuCxM+ny1gh9jpJTH00FapGRGJ2ZxvzBEah
        WUhGzUIyahaSUbOQtCxgZFnFKJlaUJybnltsWGCUl1quV5yYW1yal66XnJ+7iREc4lpaOxj3
        rPqgd4iRiYPxEKMEB7OSCO9pg19xQrwpiZVVqUX58UWlOanFhxilOViUxHm/zloYJySQnliS
        mp2aWpBaBJNl4uCUamDS75xyZe0WgRU1k598fXl3v4Hm4jfsBzIuTO++65f5cLoEv0n1iW+J
        ecy+MiVLz2Rc2nDlZ9AuxRdrLrHd2/jrZWVZDktLbOdFVk1OX5u/Pz9y39f9080tv2bR5Qcz
        ZnmLbdse5W17/+bLORM7VurLr2XfvirGJUbO0lucYWuSK//11t0V9nfezr7NYH9NYse0g+7F
        P2Z2bMyd86XK/VTwDwG/evmKPys/sjsK6fQ/XPJuc8r5hE1cdZNn9iZc3n741kU2yVNC/ps+
        f9/v0On3+EABc+sE9R8u4ZcEf+mlZ3XtM+M9NtM/xbttm9Orgw4NPzi+GjXfn/ZXab9BvtKX
        ypjFi2zCTf553ueXMpHrU2Ipzkg01GIuKk4EAOdT4LXgAgAA
X-CMS-MailID: 20200630042345epcas1p286198fd196b4a5facf72cbd439105de5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200629102355epcas2p13f8714a906291e5444adfb2f5ac2c469
References: <cover.1593412974.git.kwmad.kim@samsung.com>
        <CGME20200629102355epcas2p13f8714a906291e5444adfb2f5ac2c469@epcas2p1.samsung.com>
        <1ca1a52df36ad3393c0487537832cf7f0a7e1260.1593412974.git.kwmad.kim@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Currently, UFS driver checks if fDeviceInit is cleared at several times,
> not period. This patch is to wait its completion with the period, not
> retrying.
> Many device vendors usually provides the specification on it with just
> period, not a combination of a number of retrying and period. So it could
> be proper to regard to the information coming from device vendors.
>=20
> I first added one device specific value regarding the information.
>=20
> Signed-off-by: Kiwoong Kim <kwmad.kim=40samsung.com>
> ---
>  drivers/scsi/ufs/ufshcd.c =7C 36 ++++++++++++++++++++++++------------
>  1 file changed, 24 insertions(+), 12 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
> 7b6f13a..27afdf0 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> =40=40 -208,6 +208,7 =40=40 static struct ufs_dev_fix ufs_fixups=5B=5D =
=3D =7B  =7D;
>=20
>  static const struct ufs_dev_value ufs_dev_values=5B=5D =3D =7B
> +	=7BUFS_VENDOR_TOSHIBA, UFS_ANY_MODEL, DEV_VAL_FDEVICEINIT, 2000,
> false=7D,
>  	=7B0, 0, 0, 0, false=7D,
>  =7D;
>=20
> =40=40 -4162,9 +4163,12 =40=40 EXPORT_SYMBOL_GPL(ufshcd_config_pwr_mode);
>   */
>  static int ufshcd_complete_dev_init(struct ufs_hba *hba)  =7B
> -	int i;
> +	u32 dev_init_compl_in_ms =3D 500;

I think default timeout value is too small. Most UFS vendors which are Sams=
ung, Kioxia, SKHynix, Micron and WD want to set more than 1 seconds for a w=
orst case of fdeviceinit. We need to add many quirks for every ufs vendors =
if the default value is 500ms.

> +	unsigned long timeout;
>  	int err;
>  	bool flag_res =3D true;
> +	bool is_dev_val;
> +	u32 val;
>=20
>  	err =3D ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_SET_FLAG,
>  		QUERY_FLAG_IDN_FDEVICEINIT, 0, NULL); =40=40 -4175,20 +4179,28
> =40=40 static int ufshcd_complete_dev_init(struct ufs_hba *hba)
>  		goto out;
>  	=7D
>=20
> -	/* poll for max. 1000 iterations for fDeviceInit flag to clear */
> -	for (i =3D 0; i < 1000 && =21err && flag_res; i++)
> -		err =3D ufshcd_query_flag_retry(hba,
> UPIU_QUERY_OPCODE_READ_FLAG,
> -			QUERY_FLAG_IDN_FDEVICEINIT, 0, &flag_res);
> +	/* Poll fDeviceInit flag to be cleared */
> +	is_dev_val =3D ufs_get_dev_specific_value(hba, DEV_VAL_FDEVICEINIT,
> &val);
> +	dev_init_compl_in_ms =3D (is_dev_val) ? val : 500;
> +	timeout =3D jiffies + msecs_to_jiffies(dev_init_compl_in_ms);
> +	do =7B
> +		err =3D ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_READ_FLAG,
> +					QUERY_FLAG_IDN_FDEVICEINIT, 0,
> &flag_res);
> +		if (=21flag_res)
> +			break;
> +		usleep_range(1000, 2000);

How about think to increase the value of usleep() to 5 =7E 10ms. I think 1 =
=7E 2ms is too small.

> +	=7D while (time_before(jiffies, timeout));
>=20
> -	if (err)
> +	if (err) =7B
>  		dev_err(hba->dev,
> -			=22%s reading fDeviceInit flag failed with error %d=5Cn=22,
> -			__func__, err);
> -	else if (flag_res)
> +				=22%s reading fDeviceInit flag failed with
> error %d=5Cn=22,
> +				__func__, err);
> +	=7D else if (flag_res) =7B
>  		dev_err(hba->dev,
> -			=22%s fDeviceInit was not cleared by the device=5Cn=22,
> -			__func__);
> -
> +				=22%s fDeviceInit was not cleared by the
> device=5Cn=22,
> +				__func__);
> +		err =3D -EBUSY;
> +	=7D
>  out:
>  	return err;
>  =7D
> --
> 2.7.4

Thanks for this patch. We are changing this code and value for all projects=
.
Fdeviceinit fail is one of most frequently happened defects. So it's import=
ant to set with proper value.

BR
Grant

