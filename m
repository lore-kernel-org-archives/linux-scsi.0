Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30F8BC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 10:15:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E438B206EC
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 10:15:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727372AbhAMKP2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jan 2021 05:15:28 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:42960 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726645AbhAMKP1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jan 2021 05:15:27 -0500
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210113101441epoutp01bf9996020181d6b509d01c9093fdfc99~Zwx9nDl0q2054020540epoutp015
        for <linux-scsi@vger.kernel.org>; Wed, 13 Jan 2021 10:14:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210113101441epoutp01bf9996020181d6b509d01c9093fdfc99~Zwx9nDl0q2054020540epoutp015
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1610532881;
        bh=GtBgGY2uu8S1emKkD17/2NwSO/VizCGoRSWaCbl4FY4=;
        h=From:To:Cc:Subject:Date:References:From;
        b=ViXVfu7DMoc4IDJpETTb1tIaer7K+Qnr2ikhUc7SzxSYGj9S8OhuJozWOBxLiesVy
         j3HltQ2WLefBhx5+Amp9VV6N/Dp0yH/CnMWH0iXURhgvf/iDLm4LnLWyQ5fyjZWTNe
         GeJGybfR3G6OfEjDaoYtEIR8/nldHJZLYN9nGezc=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210113101440epcas1p1c5fb7e83122f74d5f999767b1960651e~Zwx8iZleh1068210682epcas1p18;
        Wed, 13 Jan 2021 10:14:40 +0000 (GMT)
Received: from epsmges1p5.samsung.com (unknown [182.195.40.162]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4DG3G71NkSz4x9Q7; Wed, 13 Jan
        2021 10:14:39 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
        epsmges1p5.samsung.com (Symantec Messaging Gateway) with SMTP id
        8A.B0.09577.E08CEFF5; Wed, 13 Jan 2021 19:14:39 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20210113101438epcas1p21192b49fa1a079353ab36555478f32d8~Zwx6qlsWh1972119721epcas1p20;
        Wed, 13 Jan 2021 10:14:38 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210113101438epsmtrp1c25ee3a672055e6013578803f612bde0~Zwx6pE6HR2677826778epsmtrp1a;
        Wed, 13 Jan 2021 10:14:38 +0000 (GMT)
X-AuditID: b6c32a39-bfdff70000002569-33-5ffec80eedbd
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        C6.6E.08745.E08CEFF5; Wed, 13 Jan 2021 19:14:38 +0900 (KST)
Received: from dh0421hwang01 (unknown [10.253.101.58]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210113101437epsmtip295e6e151b66a4e7ccb5aa49773559265~Zwx6YSJyB1780517805epsmtip2V;
        Wed, 13 Jan 2021 10:14:37 +0000 (GMT)
From:   =?UTF-8?B?7Zmp65GQ7ZiE?= <dh0421.hwang@samsung.com>
To:     <cang@codeaurora.org>
Cc:     <adrian.hunter@intel.com>, <alim.akhtar@samsung.com>,
        <asutoshd@codeaurora.org>, <avri.altman@wdc.com>,
        <beanhuo@micron.com>, <hongwus@codeaurora.org>,
        <jejb@linux.ibm.com>, <kernel-team@android.com>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <nguyenb@codeaurora.org>,
        <rnayak@codeaurora.org>, <salyzyn@google.com>,
        <saravanak@google.com>, <satyat@google.com>,
        <stanley.chu@mediatek.com>, <grant.jung@samsung.com>,
        <jt77.jang@samsung.com>, <junwoo80.lee@samsung.com>,
        <dh0421.hwang@samsung.com>, <sh043.lee@samsung.com>,
        <jangsub.yi@samsung.com>, <cw9316.lee@samsung.com>,
        <sh8267.baek@samsung.com>, <wkon.kim@samsung.com>
Subject: Re: [PATCH v9 1/3] scsi: ufs: Protect some contexts from unexpected
 clock scaling
Date:   Wed, 13 Jan 2021 19:14:37 +0900
Message-ID: <00e401d6e994$e62e1660$b28a4320$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: Adbpi0VvOKpznDNeQeiKo4PsMofnQA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA01TbUxTZxTee/vJp3cV3EtlpjbBBRzQWgsvBtjMmLkGtpDwYw5Jugo3gJa2
        6aWbDjQwt1ooX/MjCtjZYSyEGWtKqRXwq9sCBUZi+ZiYGQHFDXBs0G0EXWGXXsz495xznud9
        zjlvDp8laOQJ+cXqUlKnVqrE3GC28/vYhPhNfSsKyU/dGPI8vcpFE984ueiWoY+HZpZHueje
        ZBUbLdqsHHSh38BBt8c8PPTCb+OhgWfzPGTsPIOhlgdODLl+HeShLv9JGt2IQMNdF7nI9LOL
        i1p7VzC0UN0MkHWkg4OuVNKvV7v9XFT/3SMu+uLf22w0NthHFzrHAerw/sN+dyvh7HZyiOG6
        Woyw2PXE5Z4ZjGhouQuILz132MSSzcglFqYfsok6RzsgfPZtxKm7Jiw7JFeVWkQqC0idiFTn
        awqK1YVp4swcxXsKeZJEGi9NQclikVpZQqaJM7Ky4/cVq+g1iEWfKlV6OpWtpChxYnqqTqMv
        JUVFGqo0TUxqC1RaqUSbQClLKL26MCFfU7JHKpHsktPMT1RFL56scrQWxdHhc6d4FWDqw2oQ
        xIf4bmiodYFqEMwX4C4An3t/YzHBIoDX+gd4TOADcHpsEnslMTsG2UyhC8DWv+zrkjkAjZ5H
        YI3FxVOg3/ScvYYj8Cg4tHw9QGLhLg70NAwFntqM50GL72KAxMZjYPv5ugAOo8X2Ki/G4Neh
        p/FpIM/Cd0Lrt3Mspg0RXJ62chiDBOi0XVrnRMDmKkPADOIdQdA0ynQB8Qw4O3xzXbwZzvY6
        eAwWwpl6wzo2AVjvTmfEDQAO99ZwmYIMLvp89Gh82iEW2roSmfR2ePOlGTDG4XD+7xrOGgXi
        YdBoEDCUHfDyyhJN4dE4GlaGMFkCrlZMgQawvWnDkE0bhmzaMEzT/7YWwG4HW0gtVVJIUlKt
        fONv20HgRuJSXOD8738muAHGB24A+SxxRJjO5FcIwgqUxz4ndRqFTq8iKTeQ02v/miWMzNfQ
        R6YuVUjlu2QyGdqdlJwkl4nfCDskmVAI8EJlKXmEJLWk7pUO4wcJK7Da5hMToLt1r/6sOtZm
        1lKiksPXf2hpDD/geul9J+bNTSZ/bfC9H83mxLzO9sfz5UvnIhP8n7k9p+O0hozymmz9B3li
        31l3k+dSblzuW673c7YFRcz3Jo/CQ1TZXPleKjPmuHd8xWEMik109DhWUztIL2UhQndUtXlj
        iNNtV44MTFXuORgl+NjTe+2Pj0Kqx0O9DyoNM9FLt8IrBoYOnrF2lJcJ99X33Tn+mjmKzd0f
        eTR0Nvqkbn/Lk8MxaQt5Iy0X7Fuq8uKzthqEj/syZQ6L8pdnydbJ9Kz++23BD++X8b66cdWH
        RgQH0AmsRoznGIXhdtvbx4TWpJ4uVW3iznkxmypSSuNYOkr5HxjcaOqsBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0xSYRjHe885HI426mRWb5lZ2NUK09V8a5Vu1nZyrsvauriaUZ7MKWCH
        7OLWLClTGOjWUsNLZkmJJYmBlNcgSop1saL7uixrZLOsrbLAAq3Nb789/8vzfHgoPKiHmESl
        SfewnFScISQDCbNNGDZ/VOdA8oIXX/nI8e4CiV5XmknUmtfJR+7+RyS69qaAQF8NOh4qvZXH
        Q20uBx/98hr46Pb7Xj7KNx3HUPUTM4YsH5x8dNWr8FFTMHpwtZxEqscWEp27OYChPmUZQLqH
        jTxUc9jXrrR6SVRY95JEuZ42ArmcnT7B9BSgxq7vRFwIY24285gHGjXGVBmzmDMtbowpqu4A
        zBFHO8H8MOSTTF/3M4LRXNYD5ptxCnOsQ4WtHZkUuDSFzUjby3KRy7cF7nKe0ZGZiq373b3l
        2CHQlKgEARSkF8KKy05CCQKpINoCoEJrwoeEyVD1qpWvBJSPx0KbTT7kcQNYoikk/R6SXgy9
        qk+En4PpifBO/yXcb8JpFw/WFw8AvzCWToIVzt+Ynwl6BtSXaAYDAl/YWNCFDfEY6Dj5bnCO
        03Oh+s1R8J91p3v+HTQV9nfreEPLRNBsOPXPHwzLCvLwIjBGO6xKO6xKO6xKOyxSBQg9mMhm
        yiWpEnlUZrSU3SeSiyXyLGmqaIdMYgSD/xARYQEt+i8iK8AoYAWQwoXBAk7lTQ4SpIgPZLOc
        LJnLymDlVhBCEcIJgntKR3IQnSrew6azbCbL/VcxKmDSIawpdOc5j8db2wBvLIpZ/U2v6TwY
        H38xPT/7T8oHU4wi4ebZj+7eV4+fTO4l1l9E4aHrRU7tuOuxVbzIxfZlp9WtnuPz1HjO6i/2
        SkOCPrtjtnXNjbjubZE9KZb2tjkzNouN7QXqafV3pyg/901veBtwZMWLWt35ylFcYs7KH9aZ
        Lm94Rdic2B715vyVkcWqEyGfQPrPnKRH+JXm0tqculsjpLLPZVxM0aoGLXL+ibbbN4Tk2n7+
        3uipwerq42LvfW9No4vtale8YufIjGpb2/aZuQkXbEsSw2SjWwT3j9YZx28Zvzs0enlzTGM5
        9fzlLEfhFlPSpihJadd+Zdg6JJUxQkK+SxwVgXNy8V+BPmnufgMAAA==
X-CMS-MailID: 20210113101438epcas1p21192b49fa1a079353ab36555478f32d8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210113101438epcas1p21192b49fa1a079353ab36555478f32d8
References: <CGME20210113101438epcas1p21192b49fa1a079353ab36555478f32d8@epcas1p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> From: Can Guo <cang=40codeaurora.org>
>=20
> In contexts like suspend, shutdown and error handling, we need to suspend
> devfreq to make sure these contexts won't be disturbed by clock scaling.
> However, suspending devfreq is not enough since users can still trigger a
> clock scaling by manipulating the devfreq sysfs nodes like min/max_freq a=
nd
> governor even after devfreq is suspended. Moreover, mere suspending devfr=
eq
> cannot synchroinze a clock scaling which has already been invoked through
> these sysfs nodes. Add one more flag in struct clk_scaling and wrap the
> entire func ufshcd_devfreq_scale() with the clk_scaling_lock, so that we
> can use this flag and clk_scaling_lock to control and synchronize clock
> scaling invoked through devfreq sysfs nodes.
>=20
> Signed-off-by: Can Guo <cang=40codeaurora.org>
> ---
>  drivers/scsi/ufs/ufshcd.c =7C 86 +++++++++++++++++++++++++++++----------=
--------
>  drivers/scsi/ufs/ufshcd.h =7C  6 +++-
>  2 files changed, 59 insertions(+), 33 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 82ad317..64218e6 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> =40=40 -1181,19 +1181,33 =40=40 static int ufshcd_clock_scaling_prepare(s=
truct ufs_hba *hba)
>  	 */
>  	ufshcd_scsi_block_requests(hba);
>  	down_write(&hba->clk_scaling_lock);
> -	if (ufshcd_wait_for_doorbell_clr(hba, DOORBELL_CLR_TOUT_US)) =7B
> +

I think another value is better than -EAGAIN.
Ex) -EPERM because the clk scaling is not allowed state.

> +	if (=21hba->clk_scaling.is_allowed)
> +		ret =3D -EAGAIN;

I think ufshcd_hold() has to be called before access host registers,
so calling ufshcd_hold() is better before calling ufshcd_clock_scaling_prep=
are().

If you want to do not anything when hba->clk_scaling.is_allowed is false,
it is recommended to check hba->clk_scaling.is_allowed before calling ufshc=
d_hold() in ufshcd_devfreq_scale().

> +	else if (ufshcd_wait_for_doorbell_clr(hba, DOORBELL_CLR_TOUT_US))
>  		ret =3D -EBUSY;
> +
> +	if (ret) =7B
>  		up_write(&hba->clk_scaling_lock);
>  		ufshcd_scsi_unblock_requests(hba);
> +		goto out;
>  	=7D
> =20
> +	/* let's not get into low power until clock scaling is completed */
> +	ufshcd_hold(hba, false);
> +
> +out:
>  	return ret;
>  =7D
> =20
> -static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba)
> +static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, bool wri=
telock)
>  =7B
> -	up_write(&hba->clk_scaling_lock);
> +	if (writelock)
> +		up_write(&hba->clk_scaling_lock);
> +	else
> +		up_read(&hba->clk_scaling_lock);
>  	ufshcd_scsi_unblock_requests(hba);
> +	ufshcd_release(hba);
>  =7D
> =20
>  /**
> =40=40 -1208,13 +1222,11 =40=40 static void ufshcd_clock_scaling_unprepar=
e(struct ufs_hba *hba)
>  static int ufshcd_devfreq_scale(struct ufs_hba *hba, bool scale_up)
>  =7B
>  	int ret =3D 0;
> -
> -	/* let's not get into low power until clock scaling is completed */
> -	ufshcd_hold(hba, false);
> +	bool is_writelock =3D true;
> =20

I think it would be nice to call ufshcd_hold() here.

>  	ret =3D ufshcd_clock_scaling_prepare(hba);
>  	if (ret)

Below change is not needed if calling ufshcd_hold() is before calling ufshc=
d_clock_scaling_prepare().

> -		goto out;
> +		return ret;
> =20
>  	/* scale down the gear before scaling down clocks */
>  	if (=21scale_up) =7B
> =40=40 -1240,14 +1252,12 =40=40 static int ufshcd_devfreq_scale(struct uf=
s_hba *hba, bool scale_up)
>  	=7D
> =20
>  	/* Enable Write Booster if we have scaled up else disable it */
> -	up_write(&hba->clk_scaling_lock);
> +	downgrade_write(&hba->clk_scaling_lock);
> +	is_writelock =3D false;
>  	ufshcd_wb_ctrl(hba, scale_up);
> -	down_write(&hba->clk_scaling_lock);
> =20
>  out_unprepare:
> -	ufshcd_clock_scaling_unprepare(hba);
> -out:
> -	ufshcd_release(hba);
> +	ufshcd_clock_scaling_unprepare(hba, is_writelock);
>  	return ret;
>  =7D
> =20
> =40=40 -1521,7 +1531,7 =40=40 static ssize_t ufshcd_clkscale_enable_show(=
struct device *dev,
>  =7B
>  	struct ufs_hba *hba =3D dev_get_drvdata(dev);
> =20
> -	return snprintf(buf, PAGE_SIZE, =22%d=5Cn=22, hba->clk_scaling.is_allow=
ed);
> +	return snprintf(buf, PAGE_SIZE, =22%d=5Cn=22, hba->clk_scaling.is_enabl=
ed);
>  =7D
> =20
>  static ssize_t ufshcd_clkscale_enable_store(struct device *dev,
> =40=40 -1535,7 +1545,7 =40=40 static ssize_t ufshcd_clkscale_enable_store=
(struct device *dev,
>  		return -EINVAL;
> =20
>  	value =3D =21=21value;
> -	if (value =3D=3D hba->clk_scaling.is_allowed)
> +	if (value =3D=3D hba->clk_scaling.is_enabled)
>  		goto out;
> =20
>  	pm_runtime_get_sync(hba->dev);
> =40=40 -1544,7 +1554,7 =40=40 static ssize_t ufshcd_clkscale_enable_store=
(struct device *dev,
>  	cancel_work_sync(&hba->clk_scaling.suspend_work);
>  	cancel_work_sync(&hba->clk_scaling.resume_work);
> =20
> -	hba->clk_scaling.is_allowed =3D value;
> +	hba->clk_scaling.is_enabled =3D value;
> =20
>  	if (value) =7B
>  		ufshcd_resume_clkscaling(hba);
> =40=40 -1882,8 +1892,6 =40=40 static void ufshcd_init_clk_scaling(struct =
ufs_hba *hba)
>  	snprintf(wq_name, sizeof(wq_name), =22ufs_clkscaling_%d=22,
>  		 hba->host->host_no);
>  	hba->clk_scaling.workq =3D create_singlethread_workqueue(wq_name);
> -
> -	ufshcd_clkscaling_init_sysfs(hba);
>  =7D
> =20
>  static void ufshcd_exit_clk_scaling(struct ufs_hba *hba)
> =40=40 -1891,6 +1899,8 =40=40 static void ufshcd_exit_clk_scaling(struct =
ufs_hba *hba)
>  	if (=21ufshcd_is_clkscaling_supported(hba))
>  		return;
> =20
> +	if (hba->clk_scaling.enable_attr.attr.name)
> +		device_remove_file(hba->dev, &hba->clk_scaling.enable_attr);
>  	destroy_workqueue(hba->clk_scaling.workq);
>  	ufshcd_devfreq_remove(hba);
>  =7D
> =40=40 -1955,7 +1965,7 =40=40 static void ufshcd_clk_scaling_start_busy(s=
truct ufs_hba *hba)
>  	if (=21hba->clk_scaling.active_reqs++)
>  		queue_resume_work =3D true;
> =20
> -	if (=21hba->clk_scaling.is_allowed =7C=7C hba->pm_op_in_progress)
> +	if (=21hba->clk_scaling.is_enabled =7C=7C hba->pm_op_in_progress)
>  		return;
> =20
>  	if (queue_resume_work)
> =40=40 -5071,7 +5081,8 =40=40 static void __ufshcd_transfer_req_compl(str=
uct ufs_hba *hba,
>  				update_scaling =3D true;
>  			=7D
>  		=7D
> -		if (ufshcd_is_clkscaling_supported(hba) && update_scaling)
> +		if (ufshcd_is_clkscaling_supported(hba) && update_scaling &&
> +		    hba->clk_scaling.active_reqs > 0)
>  			hba->clk_scaling.active_reqs--;
>  	=7D
> =20
> =40=40 -5737,18 +5748,24 =40=40 static void ufshcd_err_handling_prepare(s=
truct ufs_hba *hba)
>  		ufshcd_vops_resume(hba, pm_op);
>  	=7D else =7B
>  		ufshcd_hold(hba, false);
> -		if (hba->clk_scaling.is_allowed) =7B
> +		if (hba->clk_scaling.is_enabled) =7B
>  			cancel_work_sync(&hba->clk_scaling.suspend_work);
>  			cancel_work_sync(&hba->clk_scaling.resume_work);
>  			ufshcd_suspend_clkscaling(hba);
>  		=7D
> +		down_write(&hba->clk_scaling_lock);
> +		hba->clk_scaling.is_allowed =3D false;
> +		up_write(&hba->clk_scaling_lock);
>  	=7D
>  =7D
> =20
>  static void ufshcd_err_handling_unprepare(struct ufs_hba *hba)
>  =7B
>  	ufshcd_release(hba);
> -	if (hba->clk_scaling.is_allowed)
> +	down_write(&hba->clk_scaling_lock);
> +	hba->clk_scaling.is_allowed =3D true;
> +	up_write(&hba->clk_scaling_lock);
> +	if (hba->clk_scaling.is_enabled)
>  		ufshcd_resume_clkscaling(hba);
>  	pm_runtime_put(hba->dev);
>  =7D
> =40=40 -7728,12 +7745,14 =40=40 static int ufshcd_add_lus(struct ufs_hba =
*hba)
>  			sizeof(struct ufs_pa_layer_attr));
>  		hba->clk_scaling.saved_pwr_info.is_valid =3D true;
>  		if (=21hba->devfreq) =7B
> +			hba->clk_scaling.is_allowed =3D true;
>  			ret =3D ufshcd_devfreq_init(hba);
>  			if (ret)
>  				goto out;
> -		=7D
> =20
> -		hba->clk_scaling.is_allowed =3D true;
> +			hba->clk_scaling.is_enabled =3D true;
> +			ufshcd_clkscaling_init_sysfs(hba);
> +		=7D
>  	=7D
> =20
>  	ufs_bsg_probe(hba);
> =40=40 -8650,11 +8669,14 =40=40 static int ufshcd_suspend(struct ufs_hba =
*hba, enum ufs_pm_op pm_op)
>  	ufshcd_hold(hba, false);
>  	hba->clk_gating.is_suspended =3D true;
> =20
> -	if (hba->clk_scaling.is_allowed) =7B
> +	if (hba->clk_scaling.is_enabled) =7B
>  		cancel_work_sync(&hba->clk_scaling.suspend_work);
>  		cancel_work_sync(&hba->clk_scaling.resume_work);
>  		ufshcd_suspend_clkscaling(hba);
>  	=7D
> +	down_write(&hba->clk_scaling_lock);
> +	hba->clk_scaling.is_allowed =3D false;
> +	up_write(&hba->clk_scaling_lock);
> =20
>  	if (req_dev_pwr_mode =3D=3D UFS_ACTIVE_PWR_MODE &&
>  			req_link_state =3D=3D UIC_LINK_ACTIVE_STATE) =7B
> =40=40 -8751,8 +8773,6 =40=40 static int ufshcd_suspend(struct ufs_hba *h=
ba, enum ufs_pm_op pm_op)
>  	goto out;
> =20
>  set_link_active:
> -	if (hba->clk_scaling.is_allowed)
> -		ufshcd_resume_clkscaling(hba);
>  	ufshcd_vreg_set_hpm(hba);
>  	/*
>  	 * Device hardware reset is required to exit DeepSleep. Also, for
> =40=40 -8776,7 +8796,10 =40=40 static int ufshcd_suspend(struct ufs_hba *=
hba, enum ufs_pm_op pm_op)
>  	if (=21ufshcd_set_dev_pwr_mode(hba, UFS_ACTIVE_PWR_MODE))
>  		ufshcd_disable_auto_bkops(hba);
>  enable_gating:
> -	if (hba->clk_scaling.is_allowed)
> +	down_write(&hba->clk_scaling_lock);
> +	hba->clk_scaling.is_allowed =3D true;
> +	up_write(&hba->clk_scaling_lock);
> +	if (hba->clk_scaling.is_enabled)
>  		ufshcd_resume_clkscaling(hba);
>  	hba->clk_gating.is_suspended =3D false;
>  	hba->dev_info.b_rpm_dev_flush_capable =3D false;
> =40=40 -8879,7 +8902,10 =40=40 static int ufshcd_resume(struct ufs_hba *h=
ba, enum ufs_pm_op pm_op)
> =20
>  	hba->clk_gating.is_suspended =3D false;
> =20
> -	if (hba->clk_scaling.is_allowed)
> +	down_write(&hba->clk_scaling_lock);
> +	hba->clk_scaling.is_allowed =3D true;
> +	up_write(&hba->clk_scaling_lock);
> +	if (hba->clk_scaling.is_enabled)
>  		ufshcd_resume_clkscaling(hba);
> =20
>  	/* Enable Auto-Hibernate if configured */
> =40=40 -8903,8 +8929,6 =40=40 static int ufshcd_resume(struct ufs_hba *hb=
a, enum ufs_pm_op pm_op)
>  	ufshcd_vreg_set_lpm(hba);
>  disable_irq_and_vops_clks:
>  	ufshcd_disable_irq(hba);
> -	if (hba->clk_scaling.is_allowed)
> -		ufshcd_suspend_clkscaling(hba);
>  	ufshcd_setup_clocks(hba, false);
>  	if (ufshcd_is_clkgating_allowed(hba)) =7B
>  		hba->clk_gating.state =3D CLKS_OFF;
> =40=40 -9131,8 +9155,6 =40=40 void ufshcd_remove(struct ufs_hba *hba)
> =20
>  	ufshcd_exit_clk_scaling(hba);
>  	ufshcd_exit_clk_gating(hba);
> -	if (ufshcd_is_clkscaling_supported(hba))
> -		device_remove_file(hba->dev, &hba->clk_scaling.enable_attr);
>  	ufshcd_hba_exit(hba);
>  =7D
>  EXPORT_SYMBOL_GPL(ufshcd_remove);
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index aa9ea35..2863af1 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> =40=40 -419,7 +419,10 =40=40 struct ufs_saved_pwr_info =7B
>   * =40suspend_work: worker to suspend devfreq
>   * =40resume_work: worker to resume devfreq
>   * =40min_gear: lowest HS gear to scale down to
> - * =40is_allowed: tracks if scaling is currently allowed or not
> + * =40is_enabled: tracks if scaling is currently enabled or not, control=
led by
> +		clkscale_enable sysfs node
> + * =40is_allowed: tracks if scaling is currently allowed or not, used to=
 block
> +		clock scaling which is not invoked from devfreq governor
>   * =40is_busy_started: tracks if busy period has started or not
>   * =40is_suspended: tracks if devfreq is suspended or not
>   */
> =40=40 -434,6 +437,7 =40=40 struct ufs_clk_scaling =7B
>  	struct work_struct suspend_work;
>  	struct work_struct resume_work;
>  	u32 min_gear;
> +	bool is_enabled;
>  	bool is_allowed;
>  	bool is_busy_started;
>  	bool is_suspended;
> --=20
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linu=
x Foundation Collaborative Project.

--
DooHyun Hwang
Samsung Electronics

