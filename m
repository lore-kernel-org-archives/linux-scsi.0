Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C067C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Sep 2021 04:21:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6136360FC1
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Sep 2021 04:21:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235507AbhIWEXR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Sep 2021 00:23:17 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:15751 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbhIWEXQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Sep 2021 00:23:16 -0400
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210923042144epoutp03f8e79ffdff5e8d90c1b2f70ce9d452db~nWLBMCQp31332613326epoutp03m
        for <linux-scsi@vger.kernel.org>; Thu, 23 Sep 2021 04:21:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210923042144epoutp03f8e79ffdff5e8d90c1b2f70ce9d452db~nWLBMCQp31332613326epoutp03m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1632370904;
        bh=QMOEn4tcTug5Wdj1S6j7qlYxp5CJl1bS/NipwuGC63A=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=IFUIV/CsFc4N3P9ldSVYV3ogPjxFMfWO+GjVZJVN0MnHnIXCzEdW0fN04uy1dbJD6
         1x0eLC81byAxV7vHwguBp1a65N3BFOeBfoybwCviAfhMeLeMeGZetbHOdqy4uiy900
         e+sRDUi0ljAkG5eLJV6X/ZN0VZ+5hSUwyM2wRmPk=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20210923042143epcas5p40b1b9344dbb4068985e3457db3e3a222~nWLAc9ORO0365603656epcas5p4o;
        Thu, 23 Sep 2021 04:21:43 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.177]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4HFMRy1TDfz4x9Q8; Thu, 23 Sep
        2021 04:21:34 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        74.DE.38346.EC00C416; Thu, 23 Sep 2021 13:21:34 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20210923035159epcas5p37a5ea8d4d8b93398b860e0a823c1b410~nVxDeWD460084400844epcas5p3O;
        Thu, 23 Sep 2021 03:51:59 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210923035159epsmtrp1f13ac3ea58e754afa85409ef9a16872e~nVxDdayDm2726127261epsmtrp1v;
        Thu, 23 Sep 2021 03:51:59 +0000 (GMT)
X-AuditID: b6c32a4b-251ff700000095ca-30-614c00ce7f9e
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        34.EF.08750.FD9FB416; Thu, 23 Sep 2021 12:51:59 +0900 (KST)
Received: from alimakhtar03 (unknown [107.122.12.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210923035156epsmtip2a2b8fbe9bd9f7479fb4476d820f4018d~nVxAZ8Lhh2371823718epsmtip2d;
        Thu, 23 Sep 2021 03:51:56 +0000 (GMT)
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
In-Reply-To: <20210917065436.145629-9-chanho61.park@samsung.com>
Subject: RE: [PATCH v3 08/17] scsi: ufs: ufs-exynos: add setup_clocks
 callback
Date:   Thu, 23 Sep 2021 09:21:55 +0530
Message-ID: <000801d7b02e$5c2bd680$14838380$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKr0ifVbQZWZSl2xwEUfL3y5isNhQEM/6zlAclUH+Wp8gUwoA==
Content-Language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0xTZxjGPRdOi1o4K7fPLpDmZEyBFNtR6sEIiiicjY6wmUyibuUEzoCU
        XtIWccZldTjkTt1SoZ1roGbAiLOxRcJQxmXjUmFjERvQZUaxJHawTeAPRZlb6YGN/573ze/5
        vvf5LlyE78UE3BK1gdGp6VIC24p2/xC3U/TzFjktbviCQ7q9VzDSt+LByMGH1Sh58ckKQi45
        2oLIqf4Esu67DHLcZIdJr8OKkPaZbpi89sczmLzbNYySzZPfw2TtdA9Gto++hA+EUlN3simr
        sR6jphrqYcrVEU9dvumDKWdnNUaZ7AMQ9dRRhVGLc/dQqqGrE6KWnTHU+YFaOHf7MeW+YoYu
        ZHRCRl2gKSxRF6US2UcUGYpkmVgikqSQewihmlYxqcQhea4os6TUn4YQnqRLy/ytXFqvJ3an
        7dNpygyMsFijN6QSjLawVCvVJupplb5MXZSoZgx7JWLxG8l+MF9ZfMv2GaatF5ya/NSCGaGh
        yBoomAtwKZiYGcdqoK1cPn4DArbPXShbLEHgypQJZotlCFjvTgZtWG6e7V639ELgep2ZwxY+
        CPT7qjhrFIaLQM/lygAVjp+FwfgjF7JWILgZAdZvm5E1Khg/AO61WtA1HYbngr5/rgc0iscC
        h/F8gOHhKaCvaiyI1a8At8UbYBA8AbS1ziPsTEKwMtcWYMLxg+DcqpvDMlHAN/xjYDyAVwQD
        a+UYxhoOgQbP6nqgMPD7aBeH1QLga6z0a65fK0FdbxLbPgO+to2grN4PBu5cQtcQBI8Djt7d
        bDsamG9dhdltQ0D9Cy/M9nmgx7ahY0HFn571ZV4FF2prg0wQYd2UzLopmXVTAuv/u7VAaCe0
        g9HqVUWMPlmbpGbK/7vyAo3KCQWee3x2DzT74EniEARzoSEIcBEinLc88xbN5xXSH51mdBqF
        rqyU0Q9Byf7jvoAIIgo0/v+iNigk0hSxVCaTSVOSZBIiirc4n0Lz8SLawCgZRsvoNnwwN1hg
        hB0PsuTl/F1v3giJH+RnIucWLN5titsRwy0nj1fhkRbTrzHDT5silScKfkOX07Ac1aXEdJ/d
        lS8Kyfvw/uxYzrVVu/DdPTti516P2tnWlFATffXotKl9JMx45vbfC/guc0JsXk2cI+fYUEzU
        C9uUaqLj+XvfQKNRz5uUxred77e6+53T259llaU7wmQj3rRl92y6pbVc0LG3IrQ54h2PiaRc
        5qXpRc6J3saQpdFI3icfIy+/+sWWnzVWdXqi9eGjUWe0ZwvRcrwxdCE1zxfxZQY6uDK/33q0
        ffWDx86lw48P9s28lvnXQpu8elF2JAmWV879NHNRHLLN0uI5VV143ybtJVB9MS2JR3R6+l+5
        nYSFdwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsWy7bCSvO79n96JBgvmilqcfLKGzeLlz6ts
        FgcfdrJYTPvwk9ni0/plrBaX92tb9Ox0tjg9YRGTxZP1s5gtFt3YxmSx8e0PJoubW46yWMw4
        v4/Jovv6DjaL5cf/MTnwe1y+4u0xq6GXzeNyXy+Tx+YVWh6L97xk8ti0qpPNY8KiA4we39d3
        sHl8fHqLxaNvyypGj8+b5DzaD3QzBfBEcdmkpOZklqUW6dslcGU8W36etWCFZMXvZdvZGhjv
        i3YxcnJICJhI7GncxtbFyMUhJLCDUWLyvEYmiIS0xPWNE9ghbGGJlf+es0MUPWeUmDFvIiNI
        gk1AV2LH4jawbhGBZiaJmQ1nGEEcZoG5zBIr5+6HajnKKHG36R4LSAungIPErYUzwWxhAT+J
        ay8usoHYLAKqEusb2plBbF4BS4m9HSdYIWxBiZMzn4DVMwtoSzy9+RTOXrbwNTPEfQoSP58u
        A6sXEXCSaPlzkh2iRlzi5dEj7BMYhWchGTULyahZSEbNQtKygJFlFaNkakFxbnpusWGBUV5q
        uV5xYm5xaV66XnJ+7iZGcIxrae1g3LPqg94hRiYOxkOMEhzMSiK8n294JQrxpiRWVqUW5ccX
        leakFh9ilOZgURLnvdB1Ml5IID2xJDU7NbUgtQgmy8TBKdXAZKh06s9SLi/RA1tmTz/6wX1d
        sNZC68jmpydPpZqYNVu9VkmXvNywcZeIboSlUN/G28tfnjm68uUJSd/Lgc1CU6w8n1Y8r3m3
        f+ka6dUh4qe+uHcdPJP75af+/E8mP2Zyp12eP7fl9+mw4EO7vu2Q7X/yz3OX7dUlJnZuvskV
        bpUFHuf3zAqMCnn0piw+yeapN89iIT61zSdmZtr2Pe0Tmdvidta+cZ32zE0HK1W1Xqgvj2M0
        F1sZKvp75uOyuHlcJa/tjizc+uZr2vSrRrszzng5q3v42T1m3cLEcGrXC67tPEzLW7O2z3wk
        rrVQwObu5Oe3lk/Oz5gVXdU7VX/JvEBpzkl/j/5fYS10Ij9+tqcSS3FGoqEWc1FxIgAjju+E
        YAMAAA==
X-CMS-MailID: 20210923035159epcas5p37a5ea8d4d8b93398b860e0a823c1b410
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210917065523epcas2p1215e9f56482339ca8a9346a0ac2bfe23
References: <20210917065436.145629-1-chanho61.park@samsung.com>
        <CGME20210917065523epcas2p1215e9f56482339ca8a9346a0ac2bfe23@epcas2p1.samsung.com>
        <20210917065436.145629-9-chanho61.park@samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



>-----Original Message-----
>From: Chanho Park =5Bmailto:chanho61.park=40samsung.com=5D
>Sent: Friday, September 17, 2021 12:24 PM
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
>Subject: =5BPATCH v3 08/17=5D scsi: ufs: ufs-exynos: add setup_clocks call=
back
>
>This patch adds setup_clocks callback to control/gate clocks by ufshcd.
>To avoid calling before initialization, it needs to check whether ufs is n=
ull or not
>and call it initially from pre_link callback.
>
>Cc: Alim Akhtar <alim.akhtar=40samsung.com>
>Cc: Kiwoong Kim <kwmad.kim=40samsung.com>
>Cc: Krzysztof Kozlowski <krzysztof.kozlowski=40canonical.com>
>Signed-off-by: Chanho Park <chanho61.park=40samsung.com>
>---
> drivers/scsi/ufs/ufs-exynos.c =7C 24 ++++++++++++++++++++++++
> 1 file changed, 24 insertions(+)
>
>diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c=
 index
>627edef4fbeb..2024e44a09d7 100644
>--- a/drivers/scsi/ufs/ufs-exynos.c
>+++ b/drivers/scsi/ufs/ufs-exynos.c
>=40=40 -795,6 +795,27 =40=40 static void exynos_ufs_config_intr(struct exy=
nos_ufs
>*ufs, u32 errs, u8 index)
> 	=7D
> =7D
>
>+static int exynos_ufs_setup_clocks(struct ufs_hba *hba, bool on,
>+				   enum ufs_notify_change_status status) =7B
>+	struct exynos_ufs *ufs =3D ufshcd_get_variant(hba);
>+
>+	if (=21ufs)
>+		return 0;
>+
>+	if (on) =7B
>+		if (ufs->opts & EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL)
>+			exynos_ufs_disable_auto_ctrl_hcc(ufs);
>+		exynos_ufs_ungate_clks(ufs);
>+	=7D else =7B
>+		exynos_ufs_gate_clks(ufs);
>+		if (ufs->opts & EXYNOS_UFS_OPT_BROKEN_AUTO_CLK_CTRL)
>+			exynos_ufs_enable_auto_ctrl_hcc(ufs);
>+	=7D
>+
>+	return 0;
>+=7D
>+
> static int exynos_ufs_pre_link(struct ufs_hba *hba)  =7B
> 	struct exynos_ufs *ufs =3D ufshcd_get_variant(hba); =40=40 -813,6 +834,8
>=40=40 static int exynos_ufs_pre_link(struct ufs_hba *hba)
> 	exynos_ufs_config_phy_time_attr(ufs);
> 	exynos_ufs_config_phy_cap_attr(ufs);
>
>+	exynos_ufs_setup_clocks(hba, true, POST_CHANGE);

For consistency and better understanding, may be PRE_CHANGE?

>+
> 	if (ufs->drv_data->pre_link)
> 		ufs->drv_data->pre_link(ufs);
>
>=40=40 -1203,6 +1226,7 =40=40 static struct ufs_hba_variant_ops ufs_hba_ex=
ynos_ops
>=3D =7B
> 	.hce_enable_notify		=3D exynos_ufs_hce_enable_notify,
> 	.link_startup_notify		=3D exynos_ufs_link_startup_notify,
> 	.pwr_change_notify		=3D exynos_ufs_pwr_change_notify,
>+	.setup_clocks			=3D exynos_ufs_setup_clocks,
> 	.setup_xfer_req			=3D
>exynos_ufs_specify_nexus_t_xfer_req,
> 	.setup_task_mgmt		=3D exynos_ufs_specify_nexus_t_tm_req,
> 	.hibern8_notify			=3D exynos_ufs_hibern8_notify,
>--
>2.33.0


