Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B22A6CD4F5F
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Sep 2023 11:19:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233604AbjIVLTF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Sep 2023 07:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233589AbjIVLTD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2023 07:19:03 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04686139
        for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2023 04:18:55 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20230922111853epoutp0313ec38d8fa76d44acd218815a9527ba1~HNIWRwell2127521275epoutp03i
        for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2023 11:18:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20230922111853epoutp0313ec38d8fa76d44acd218815a9527ba1~HNIWRwell2127521275epoutp03i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1695381533;
        bh=oKk7qxUnsrkIdRAk8ZkwGVU/+6c23mbFsX50ll5YSRE=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=ngIMvN4ypJ3lhMTyAWYqh958pcXPT8ORLcQoiK0J4LSprdSXM0rDgx4sgBvfELIza
         kJfKbv2/lujpzTjUKdr0CMuL8LBdp5NPxZ4ROlCgUXq8YkVcI0xzxeT4qODeLuDomh
         omWNoq+jQOBGIGmseWr0cLmXrJHqvD70CA8WeBqA=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20230922111852epcas5p131261c01fc3975d7a0031d3e210c09db~HNIVnVJP62101821018epcas5p1E;
        Fri, 22 Sep 2023 11:18:52 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.183]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4RsVBy2wwXz4x9Pw; Fri, 22 Sep
        2023 11:18:50 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        07.C3.09023.A187D056; Fri, 22 Sep 2023 20:18:50 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20230922111849epcas5p3d4d9460594e7c0321be1d788b82e4f5d~HNITdd0ML0332303323epcas5p3H;
        Fri, 22 Sep 2023 11:18:49 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230922111849epsmtrp16025df66326b19dc21adf9aa9bb0d016~HNITcfBSD0477504775epsmtrp16;
        Fri, 22 Sep 2023 11:18:49 +0000 (GMT)
X-AuditID: b6c32a44-c7ffa7000000233f-d0-650d781a71bd
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        4E.B6.08742.9187D056; Fri, 22 Sep 2023 20:18:49 +0900 (KST)
Received: from INBRO000447 (unknown [107.122.12.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20230922111847epsmtip161ebe4cb12c001d3f38d685d391d8f87~HNIRYtBTI3061830618epsmtip1g;
        Fri, 22 Sep 2023 11:18:47 +0000 (GMT)
From:   "Alim Akhtar" <alim.akhtar@samsung.com>
To:     "'Bart Van Assche'" <bvanassche@acm.org>,
        "'Martin K . Petersen'" <martin.petersen@oracle.com>
Cc:     <linux-scsi@vger.kernel.org>,
        "'James E.J. Bottomley'" <jejb@linux.ibm.com>,
        "'Krzysztof Kozlowski'" <krzysztof.kozlowski@linaro.org>,
        "'Stanley Chu'" <stanley.chu@mediatek.com>,
        "'Can Guo'" <quic_cang@quicinc.com>,
        "'Manivannan Sadhasivam'" <mani@kernel.org>,
        "'Asutosh Das'" <quic_asutoshd@quicinc.com>,
        "'Bean Huo'" <beanhuo@micron.com>,
        "'Bao D. Nguyen'" <quic_nguyenb@quicinc.com>,
        "'Arthur Simchaev'" <Arthur.Simchaev@wdc.com>,
        "'Po-Wen Kao'" <powen.kao@mediatek.com>,
        "'Eric Biggers'" <ebiggers@google.com>,
        "'Keoseong Park'" <keosung.park@samsung.com>
In-Reply-To: <20230921192335.676924-3-bvanassche@acm.org>
Subject: RE: [PATCH v2 2/4] scsi: ufs: Move the 4K alignment code into the
 Exynos driver
Date:   Fri, 22 Sep 2023 16:48:46 +0530
Message-ID: <000001d9ed46$8f898bb0$ae9ca310$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQFq9CyXdSVblb5MdUF86SNOOilpMgHc0Z6lAeUO/Kmw5pTVQA==
Content-Language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIJsWRmVeSWpSXmKPExsWy7bCmuq5UBW+qwfnDIhadE5exWhx82Mli
        Me3DT2aLi6tbWC0W3djGZHH85DtGi72vt7JbdF/fwWZx4MMqRovlx/8xWby9+5/FYmHHXBaL
        Sdc2sFlMfXGc3WLp1puMDvwel694eyzYVOqxaVUnm8eda3vYPCYsOsDo0XJyP4vH9/UdbB4f
        n95i8Zi4p86jb8sqRo/Pm+Q82g90MwXwRGXbZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjq
        GlpamCsp5CXmptoqufgE6Lpl5gC9o6RQlphTChQKSCwuVtK3synKLy1JVcjILy6xVUotSMkp
        MCnQK07MLS7NS9fLSy2xMjQwMDIFKkzIzjg8cSlbwSHVilkTprI1MN6U62Lk5JAQMJF4uOQP
        SxcjF4eQwG5GiaazHewQzidGiZf/HjBCON8YJU63NTPCtFx6uoEVIrGXUeLUp19Q/S8YJZ6/
        PcYEUsUmoCuxY3EbWxcjB4eIQIrE/geSIDXMAkdZJHb3LGcGqeEUsJTo+gBSw8khLBAlcXdh
        B9gGFgFVieZXe8FsXqCaLVNboGxBiZMzn7CA2MwC8hLb385hhrhIQeLn02WsILaIgJPE+QVP
        oWrEJV4ePQL2j4RAM6fEsfkn2EEOkhBwkWh84QHRKyzx6vgWdghbSuJlfxtUiYfEoj9SEOEM
        ibfL10M9by9x4MocFpASZgFNifW79CE28Un0/n7CBNHJK9HRJgRRDfTIu6ssELa0xMTublYI
        20Pi+pFutgmMirOQ/DULyV+zkNw/C2HZAkaWVYySqQXFuempyaYFhnmp5fDoTs7P3cQITuta
        LjsYb8z/p3eIkYmD8RCjBAezkghv8ieuVCHelMTKqtSi/Pii0pzU4kOMpsDAnsgsJZqcD8ws
        eSXxhiaWBiZmZmYmlsZmhkrivK9b56YICaQnlqRmp6YWpBbB9DFxcEo1MK3QPHQtI6pSwjK0
        0s+378LX6ZN3Td/ddUujYd/vvg2nK5IOuP9YESq2TE+qZXJxz/ryeLXtfZWVfBX+hVN5TzlJ
        fWUt3ljzLYTt15q7eilhFcL9pdPfvPecdvOMfRJ39L2/BiuyRQ5d2zc1ePsupcWTZpUvNLHg
        tftaGX5bYEXX98U3RedYsO98ErI84lez1fOcA1JPr8ppbW/edfO++7OI5e8m3f24eOrOVevY
        9rJLx/bdnWvo2+w+IdJEUD/7SueP6erF/3tr3jJc0F/3vTo6brWigbChuvaJbd1r8lr0F7So
        bj77pWHHgmkflpy4KPY7wr3j0GWF7s1x4QYtr2KVGsvC7ygf372wOf3HqudKLMUZiYZazEXF
        iQB2qy+1dAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsWy7bCSnK5kBW+qwYZmY4vOictYLQ4+7GSx
        mPbhJ7PFxdUtrBaLbmxjsjh+8h2jxd7XW9ktuq/vYLM48GEVo8Xy4/+YLN7e/c9isbBjLovF
        pGsb2CymvjjObrF0601GB36Py1e8PRZsKvXYtKqTzePOtT1sHhMWHWD0aDm5n8Xj+/oONo+P
        T2+xeEzcU+fRt2UVo8fnTXIe7Qe6mQJ4orhsUlJzMstSi/TtErgyDk9cylZwSLVi1oSpbA2M
        N+W6GDk5JARMJC493cDaxcjFISSwm1Hixeq1jBAJaYnrGyewQ9jCEiv/PWeHKHrGKHG8+wcL
        SIJNQFdix+I2NhBbRCBFYsaCj2BFzAKnWSQ2tS5khOjYzigxcc0LJpAqTgFLia4PEB3CAhES
        7+c0gU1iEVCVaH61F2w1L1DNlqktULagxMmZT4BqOICm6km0bQQLMwvIS2x/O4cZ4joFiZ9P
        l7FCHOEkcX7BUxaIGnGJl0ePsE9gFJ6FZNIshEmzkEyahaRjASPLKkbJ1ILi3PTcYsMCw7zU
        cr3ixNzi0rx0veT83E2M4PjW0tzBuH3VB71DjEwcjIcYJTiYlUR4kz9xpQrxpiRWVqUW5ccX
        leakFh9ilOZgURLnFX/RmyIkkJ5YkpqdmlqQWgSTZeLglGpgWnHwhv7OHxunRa+7oHtqQUvB
        tpNe8w5pfPO80FX54dApnxnM58RmVtUsS10yM0+/NUa8Ndn0/9eX21ZWSW1oTdDKmWtTcdxw
        XuuyDx9e729X3cvwQ/qB3rmL/zbOiGvNW3e4/r3+Bau4fd7LIri61n++/zmX/aJH5NX9jxKi
        J6/ibz2qbywV9WBWUlhoxAqTqd/uZX+Jk1m8d356ewl77K5Jcasyesvmf47cePMR58GEDrN5
        f9S+pvc87rVTfj/h28aVwScO/HR6YbJyOve/45rqi9q05thsiDSft3KfzWmdpB184utkvvvX
        rTsZW21sMCFjYULyvZP6bR9absRtKjC7lnfB26vtJ0fcBm/T13OUWIozEg21mIuKEwEbwm6k
        XgMAAA==
X-CMS-MailID: 20230922111849epcas5p3d4d9460594e7c0321be1d788b82e4f5d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230921192521epcas5p3f66f36eefc23366cf3dc131c6259f626
References: <20230921192335.676924-1-bvanassche@acm.org>
        <CGME20230921192521epcas5p3f66f36eefc23366cf3dc131c6259f626@epcas5p3.samsung.com>
        <20230921192335.676924-3-bvanassche@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart

> -----Original Message-----
> From: Bart Van Assche <bvanassche@acm.org>
> Sent: Friday, September 22, 2023 12:53 AM
> To: Martin K . Petersen <martin.petersen@oracle.com>
> Cc: linux-scsi@vger.kernel.org; Bart Van Assche <bvanassche@acm.org>;
> Alim Akhtar <alim.akhtar@samsung.com>; James E.J. Bottomley
> <jejb@linux.ibm.com>; Krzysztof Kozlowski
> <krzysztof.kozlowski@linaro.org>; Stanley Chu
> <stanley.chu@mediatek.com>; Can Guo <quic_cang@quicinc.com>;
> Manivannan Sadhasivam <mani@kernel.org>; Asutosh Das
> <quic_asutoshd@quicinc.com>; Bean Huo <beanhuo@micron.com>; Bao D.
> Nguyen <quic_nguyenb@quicinc.com>; Arthur Simchaev
> <Arthur.Simchaev@wdc.com>; Po-Wen Kao <powen.kao@mediatek.com>;
> Eric Biggers <ebiggers@google.com>; Keoseong Park
> <keosung.park@samsung.com>
> Subject: [PATCH v2 2/4] scsi: ufs: Move the 4K alignment code into the
> Exynos driver
> 
> The DMA alignment for the Exynos controller follows directly from the PRDT
> segment size configured in ufs-exynos.c. Hence, move the DMA alignment
> code into the Exynos driver source code.
> 
> Cc: Alim Akhtar <alim.akhtar@samsung.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---

Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>

Tested on exynos7 platform, able to use ufs with this change, so

Tested-by: Alim Akhtar <alim.akhtar@samsung.com>


>  drivers/ufs/core/ufshcd.c     | 6 ++++--
>  drivers/ufs/host/ufs-exynos.c | 9 +++++++--
>  include/ufs/ufshcd.h          | 7 ++-----
>  3 files changed, 13 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c index
> f48a65fa3bf7..379229d51f04 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -5095,8 +5095,7 @@ static int ufshcd_slave_configure(struct scsi_device
> *sdev)
>  	struct request_queue *q = sdev->request_queue;
> 
>  	blk_queue_update_dma_pad(q, PRDT_DATA_BYTE_COUNT_PAD -
> 1);
> -	if (hba->quirks & UFSHCD_QUIRK_4KB_DMA_ALIGNMENT)
> -		blk_queue_update_dma_alignment(q, SZ_4K - 1);
> +
>  	/*
>  	 * Block runtime-pm until all consumers are added.
>  	 * Refer ufshcd_setup_links().
> @@ -5112,6 +5111,9 @@ static int ufshcd_slave_configure(struct scsi_device
> *sdev)
>  	 */
>  	sdev->silence_suspend = 1;
> 
> +	if (hba->vops && hba->vops->config_scsi_dev)
> +		hba->vops->config_scsi_dev(sdev);
> +
>  	ufshcd_crypto_register(hba, q);
> 
>  	return 0;
> diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
> index 3396e0388512..e5d145a2676e 100644
> --- a/drivers/ufs/host/ufs-exynos.c
> +++ b/drivers/ufs/host/ufs-exynos.c
> @@ -1511,6 +1511,11 @@ static int fsd_ufs_pre_link(struct exynos_ufs *ufs)
>  	return 0;
>  }
> 
> +static void exynos_ufs_config_scsi_dev(struct scsi_device *sdev) {
> +	blk_queue_update_dma_alignment(sdev->request_queue, SZ_4K -
> 1); }
> +
>  static int fsd_ufs_post_link(struct exynos_ufs *ufs)  {
>  	int i;
> @@ -1579,6 +1584,7 @@ static const struct ufs_hba_variant_ops
> ufs_hba_exynos_ops = {
>  	.hibern8_notify			=
> exynos_ufs_hibern8_notify,
>  	.suspend			= exynos_ufs_suspend,
>  	.resume				= exynos_ufs_resume,
> +	.config_scsi_dev		= exynos_ufs_config_scsi_dev,
>  };
> 
>  static struct ufs_hba_variant_ops ufs_hba_exynosauto_vh_ops = { @@ -
> 1680,8 +1686,7 @@ static const struct exynos_ufs_drv_data
> exynos_ufs_drvs = {
>  				  UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR |
> 
> UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR |
> 
> UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL |
> -
> UFSHCD_QUIRK_SKIP_DEF_UNIPRO_TIMEOUT_SETTING |
> -				  UFSHCD_QUIRK_4KB_DMA_ALIGNMENT,
> +
> UFSHCD_QUIRK_SKIP_DEF_UNIPRO_TIMEOUT_SETTING,
>  	.opts			= EXYNOS_UFS_OPT_HAS_APB_CLK_CTRL |
> 
> EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL |
>  				  EXYNOS_UFS_OPT_BROKEN_RX_SEL_IDX |
> diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h index
> 7d07b256e906..e0d6590d163d 100644
> --- a/include/ufs/ufshcd.h
> +++ b/include/ufs/ufshcd.h
> @@ -28,6 +28,7 @@
> 
>  #define UFSHCD "ufshcd"
> 
> +struct scsi_device;
>  struct ufs_hba;
> 
>  enum dev_cmd_type {
> @@ -371,6 +372,7 @@ struct ufs_hba_variant_ops {
>  	int	(*get_outstanding_cqs)(struct ufs_hba *hba,
>  				       unsigned long *ocqs);
>  	int	(*config_esi)(struct ufs_hba *hba);
> +	void	(*config_scsi_dev)(struct scsi_device *sdev);
>  };
> 
>  /* clock gating state  */
> @@ -596,11 +598,6 @@ enum ufshcd_quirks {
>  	 */
>  	UFSHCD_QUIRK_SKIP_DEF_UNIPRO_TIMEOUT_SETTING = 1 << 13,
> 
> -	/*
> -	 * Align DMA SG entries on a 4 KiB boundary.
> -	 */
> -	UFSHCD_QUIRK_4KB_DMA_ALIGNMENT			= 1 <<
> 14,
> -
>  	/*
>  	 * This quirk needs to be enabled if the host controller does not
>  	 * support UIC command

