Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8091C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Sep 2021 04:55:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B45AB610A0
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Sep 2021 04:55:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239093AbhIWE5A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Sep 2021 00:57:00 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:44866 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234400AbhIWE47 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Sep 2021 00:56:59 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210923045525epoutp0488e5f3ff78f538f93cea14b56b79deb0~nWobomdPU0509105091epoutp04u
        for <linux-scsi@vger.kernel.org>; Thu, 23 Sep 2021 04:55:25 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210923045525epoutp0488e5f3ff78f538f93cea14b56b79deb0~nWobomdPU0509105091epoutp04u
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1632372925;
        bh=L3xOVlq6Nr8xyR3d+lsJ2AJE4L3Pr96b9MpUe3d68a0=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=m9vM+vURPfghkBpwyOhDnrldLWTZJD24sOjvfwHdsKJuKijCG2VRh0kfthNxRWbct
         LwGolflRyy5udLoWDJnvB9O10Iuw1ATkaeb/xQCDUHj6D7pbhQIrERVlPSKmkL3KHN
         FyV/27tQchNB4y/F5KCV88fr82+wcHRgkmzlrYls=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20210923045524epcas5p49a63a4b854b8b88a6f3a6efecf5187aa~nWobMMbLS2437424374epcas5p4t;
        Thu, 23 Sep 2021 04:55:24 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4HFNBs2LMrz4x9QB; Thu, 23 Sep
        2021 04:55:17 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        2D.E8.38346.0B80C416; Thu, 23 Sep 2021 13:55:12 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20210923045154epcas5p4ac8bbfcb283ef4f2695afb508c74c845~nWlW1iM9n1022910229epcas5p4D;
        Thu, 23 Sep 2021 04:51:54 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210923045154epsmtrp2b5b28292654846cb72aba776fc63fba7~nWlW0ordp2661926619epsmtrp2j;
        Thu, 23 Sep 2021 04:51:54 +0000 (GMT)
X-AuditID: b6c32a4b-251ff700000095ca-66-614c08b00aa4
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        17.53.09091.9E70C416; Thu, 23 Sep 2021 13:51:53 +0900 (KST)
Received: from alimakhtar03 (unknown [107.122.12.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210923045151epsmtip1031310d7c15adac9f7c99ada82f02e47~nWlUiOFQC1952719527epsmtip1Q;
        Thu, 23 Sep 2021 04:51:51 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Chanho Park'" <chanho61.park@samsung.com>,
        "'Avri Altman'" <avri.altman@wdc.com>,
        "'James E . J . Bottomley'" <jejb@linux.ibm.com>,
        "'Martin K . Petersen'" <martin.petersen@oracle.com>,
        "'Krzysztof Kozlowski'" <krzysztof.kozlowski@canonical.com>
Cc:     "'Bean Huo'" <beanhuo@micron.com>,
        "'Bart Van Assche'" <bvanassche@acm.org>,
        "'Adrian Hunter'" <adrian.hunter@intel.com>,
        "'Christoph Hellwig'" <hch@infradead.org>,
        "'Can Guo'" <cang@codeaurora.org>,
        "'Jaegeuk Kim'" <jaegeuk@kernel.org>,
        "'Gyunghoon Kwon'" <goodjob.kwon@samsung.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        "'Kiwoong Kim'" <kwmad.kim@samsung.com>
In-Reply-To: <20210917065436.145629-14-chanho61.park@samsung.com>
Subject: RE: [PATCH v3 13/17] scsi: ufs: ufs-exynos: add pre/post_hce_enable
 drv callbacks
Date:   Thu, 23 Sep 2021 10:21:49 +0530
Message-ID: <002f01d7b036$baab25a0$300170e0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKr0ifVbQZWZSl2xwEUfL3y5isNhQFRFGeDAJTj8Vip+ZkjgA==
Content-Language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ta1ATVxTH5+5ulsU2dsG0uYB1MjsDyptIoAsVLGA7W6GdCP2kHcOWbIES
        kpANbe3wAWsraoDGURhMHTQoSAFLeQwDCpRnaYSOTZERa2m1RjopD4HMFBkcacJCy7ffOed/
        7rn/+yBQXwfuT+RqjZxBy2oofBvWMRi8J/w7Io2NMtultM3RhNPOlQmc7n94GqMrF1ZQeqm5
        TkSPfx9Kl3al0KPmGoR2NFtQumayA6Fb5p4i9L32YYyuut2L0Ka7nTh9beQ58sZLzPidVMZS
        XIYz4+VlCNNWH8Jc6XYiTGvDaZwx1/QBZrn5FM4sPv4VY8rbGwDjat3FlPSZEOWLh/P25XCs
        mjPIOG2WTp2rzU6gUjNUKaqY2Ch5uDyOfo2Sadl8LoE6kKYMfytX43ZDyT5mNYXulJLleSoy
        cZ9BV2jkZDk63phAcXq1Rq/QR/BsPl+ozY7QcsZ4eVTU3hi3MDMv55u2Xi99o/TTy0NdomJw
        UnIGeBOQVEB7VyVyBmwjfMmbAJYv27yEYAnAzhHbRuUfAJ88mvLabKkcngZCoQfAmRNmkRA4
        Abw/Pb+uwslw2HnlJO4pSMjjCBx91IZ6ApSsQKHlehXqUXmTSdDV1Y15eAf5PjSNOhAPY2Qg
        bHp+bZ3FZBy891MJKrAPtF1wrOtRMhTWWWdQYU8yuPK4TuRhCZkMZ22TiKCRQufw0LojSK4R
        8OvaRZHQcAAu2X5EBN4B/x5p3zDnD13zPe5tE27Og6U3ooV0Eayt/gETeD/su3MR80hQMhg2
        34gU0q/CilvfbozdDstWHRuri2Fn9SYHwhPzExvLBMCzJpPIDCjLFmeWLc4sWxxY/p92GWAN
        wI/T8/nZHB+jj9Zyn/x35Vm6/Faw/txDUjvBnw8WIgYAQoABAAmUkohdkwdZX7GaPfYZZ9Cp
        DIUajh8AMe7jPov6v5ylc/8XrVElV8RFKWJjYxVx0bFySipenIljfcls1sjlcZyeM2z2IYS3
        fzHih0cajjyIz7E3Dx07fyk9+cNBFeIMucVMyRaOcG/DpT8OrynTfaxhFNVIHP9Fu3Not3L8
        undHX32wWn1e42fC0i9OvP7uV8+K8JbEXmuBT9Klm8q2gtbexuQ3y8feu6CwfRH0+9Q7Twbp
        gLEF1QdW5pWgaWqXtWm5pd4Vs2jnjpZl9CyQprDVxB5CV6WrPWSlmCCxn89fH5UU/GYJSzsk
        HUtL+vIgsQZuHw2oSN/eFfizXa3gV1tqvfZK988msHkT9vjyDLOl//65/tlS07OixtCQ2n67
        9W5mz0PJC37c03anjBZ/vigqHaqY3tNNnmKvzvVnGqo7dsrmbKvBKRTG57DyENTAs/8CFHSv
        h3cEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsWy7bCSnO5Ldp9Eg2O9JhYnn6xhs3j58yqb
        xcGHnSwW0z78ZLb4tH4Zq8Xl/doWPTudLU5PWMRk8WT9LGaLRTe2MVlsfPuDyeLmlqMsFjPO
        72Oy6L6+g81i+fF/TA78HpeveHvMauhl87jc18vksXmFlsfiPS+ZPDat6mTzmLDoAKPH9/Ud
        bB4fn95i8ejbsorR4/MmOY/2A91MATxRXDYpqTmZZalF+nYJXBlbPr1nLzgkVjH7/hnGBsbF
        wl2MnBwSAiYS044+Y+xi5OIQEtjNKDF9zWJmiIS0xPWNE9ghbGGJlf+es0MUPWeUODfxOCNI
        gk1AV2LH4jY2kISIQDOTxMyGM2CjmAXmMkusnLsfquUYo8SteR/B5nIKOEp83rmHBcQWFoiS
        +Hd4MhuIzSKgKrHm33ImEJtXwFLi5tl2ZghbUOLkzCdg9cwC2hJPbz6Fs5ctfA11q4LEz6fL
        WEFsEQEniTcnbzBB1IhLvDx6hH0Co/AsJKNmIRk1C8moWUhaFjCyrGKUTC0ozk3PLTYsMMxL
        LdcrTswtLs1L10vOz93ECI5xLc0djNtXfdA7xMjEwXiIUYKDWUmE9/MNr0Qh3pTEyqrUovz4
        otKc1OJDjNIcLErivBe6TsYLCaQnlqRmp6YWpBbBZJk4OKUamEzfBUT2vph6S8roa++EqRqn
        xSepHWOpMBYSepqzr05Vfu1vtpB1WUrpB8Vu2bolTjePUki6ExQtztzS01Mtcujey5CK8O9b
        338SdFVIm6VU3Ln84Jun0fLfhA70a0z2bJT4s5Z7peGTub9TOI4cn3ump/HI8xin/t8MUgtM
        nl4stNtq8Krhdlax5e5VnlXenh06v++kfv0vuK3okkvqn8Z5v86s4WLvXjXZbiK/tfm2baYF
        Iul5l66r3Vf96v1IzdryT/nNm3xJTq3JXvuzsyKCpjNF/7qx0+2gxiel4yI+WYsmVhyZylBZ
        sfCRYJqG3JcNWsXPusPD+T83tC54YqXfk7zo8YaNBb+Vbux/ocRSnJFoqMVcVJwIAIOl+lBg
        AwAA
X-CMS-MailID: 20210923045154epcas5p4ac8bbfcb283ef4f2695afb508c74c845
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210917065523epcas2p4fc1be41c739361dd6ae9d167cfc631dc
References: <20210917065436.145629-1-chanho61.park@samsung.com>
        <CGME20210917065523epcas2p4fc1be41c739361dd6ae9d167cfc631dc@epcas2p4.samsung.com>
        <20210917065436.145629-14-chanho61.park@samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Chanho

>-----Original Message-----
>From: Chanho Park =5Bmailto:chanho61.park=40samsung.com=5D
>Sent: Friday, September 17, 2021 12:25 PM
>To: Alim Akhtar <alim.akhtar=40samsung.com>; Avri Altman
><avri.altman=40wdc.com>; James E . J . Bottomley <jejb=40linux.ibm.com>; M=
artin
>K . Petersen <martin.petersen=40oracle.com>; Krzysztof Kozlowski
><krzysztof.kozlowski=40canonical.com>
>Cc: Bean Huo <beanhuo=40micron.com>; Bart Van Assche
><bvanassche=40acm.org>; Adrian Hunter <adrian.hunter=40intel.com>; Christo=
ph
>Hellwig <hch=40infradead.org>; Can Guo <cang=40codeaurora.org>; Jaegeuk Ki=
m
><jaegeuk=40kernel.org>; Gyunghoon Kwon <goodjob.kwon=40samsung.com>;
>linux-samsung-soc=40vger.kernel.org; linux-scsi=40vger.kernel.org; Chanho =
Park
><chanho61.park=40samsung.com>; Kiwoong Kim <kwmad.kim=40samsung.com>
>Subject: =5BPATCH v3 13/17=5D scsi: ufs: ufs-exynos: add pre/post_hce_enab=
le drv
>callbacks
>
>This patch adds driver-specific pre/post_hce_enable callbacks to execute e=
xtra
>initializations before and after hce_enable_notify callback.
>
>Cc: Alim Akhtar <alim.akhtar=40samsung.com>
>Cc: Kiwoong Kim <kwmad.kim=40samsung.com>
>Cc: Krzysztof Kozlowski <krzysztof.kozlowski=40canonical.com>
>Signed-off-by: Chanho Park <chanho61.park=40samsung.com>
>---

Reviewed-by: Alim Akhtar <alim.akhtar=40samsung.com>


> drivers/scsi/ufs/ufs-exynos.c =7C 10 ++++++++++  drivers/scsi/ufs/ufs-exy=
nos.h =7C  2
>++
> 2 files changed, 12 insertions(+)
>
>diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c=
 index
>753b22358186..7fb4514f700d 100644
>--- a/drivers/scsi/ufs/ufs-exynos.c
>+++ b/drivers/scsi/ufs/ufs-exynos.c
>=40=40 -1141,6 +1141,12 =40=40 static int exynos_ufs_hce_enable_notify(str=
uct
>ufs_hba *hba,
>
> 	switch (status) =7B
> 	case PRE_CHANGE:
>+		if (ufs->drv_data->pre_hce_enable) =7B
>+			ret =3D ufs->drv_data->pre_hce_enable(ufs);
>+			if (ret)
>+				return ret;
>+		=7D
>+
> 		ret =3D exynos_ufs_host_reset(hba);
> 		if (ret)
> 			return ret;
>=40=40 -1150,6 +1156,10 =40=40 static int exynos_ufs_hce_enable_notify(str=
uct
>ufs_hba *hba,
> 		exynos_ufs_calc_pwm_clk_div(ufs);
> 		if (=21(ufs->opts & EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL))
> 			exynos_ufs_enable_auto_ctrl_hcc(ufs);
>+
>+		if (ufs->drv_data->post_hce_enable)
>+			ret =3D ufs->drv_data->post_hce_enable(ufs);
>+
> 		break;
> 	=7D
>
>diff --git a/drivers/scsi/ufs/ufs-exynos.h b/drivers/scsi/ufs/ufs-exynos.h=
 index
>a0899aaa902e..c291ae51dd41 100644
>--- a/drivers/scsi/ufs/ufs-exynos.h
>+++ b/drivers/scsi/ufs/ufs-exynos.h
>=40=40 -154,6 +154,8 =40=40 struct exynos_ufs_drv_data =7B
> 				struct ufs_pa_layer_attr *pwr);
> 	int (*post_pwr_change)(struct exynos_ufs *ufs,
> 				struct ufs_pa_layer_attr *pwr);
>+	int (*pre_hce_enable)(struct exynos_ufs *ufs);
>+	int (*post_hce_enable)(struct exynos_ufs *ufs);
> =7D;
>
> struct ufs_phy_time_cfg =7B
>--
>2.33.0


