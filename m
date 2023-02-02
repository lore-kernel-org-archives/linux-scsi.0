Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B71B6C636CD
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Feb 2023 01:55:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbjBBBzq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Feb 2023 20:55:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbjBBBzp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Feb 2023 20:55:45 -0500
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 130F23C287
        for <linux-scsi@vger.kernel.org>; Wed,  1 Feb 2023 17:55:42 -0800 (PST)
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20230202015538epoutp025ccce14ad0b03d658ae2751ebbec66f8~-3yWLP3fD2716027160epoutp02d
        for <linux-scsi@vger.kernel.org>; Thu,  2 Feb 2023 01:55:38 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20230202015538epoutp025ccce14ad0b03d658ae2751ebbec66f8~-3yWLP3fD2716027160epoutp02d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1675302938;
        bh=plH77/SP5yPUz/7fA3Dr4hhXAwtkA8TAh9qpBkos/AA=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=dL81A7JqOQpGx7raZ89aFFSu/OYnltubtqYimiPPVreVfFJlZUZrZKfDV1w3AJ6hz
         p6kvOM+/D++Gp7QpfYN9PYl9yrzAhprCLdjYTYbi2lIChhlRLP3Nexd02eNufAU5sz
         ngXJOyLtnl4hAtMb0GWIXneJwhgQo0SvcCnIiwG0=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20230202015538epcas2p16089853c9c93d932a7c0f035ce354ef2~-3yViwqqa0297502975epcas2p1T;
        Thu,  2 Feb 2023 01:55:38 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.36.68]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4P6hh93Zwvz4x9Q0; Thu,  2 Feb
        2023 01:55:37 +0000 (GMT)
X-AuditID: b6c32a48-45bfc70000021624-08-63db18185488
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        FA.10.05668.8181BD36; Thu,  2 Feb 2023 10:55:36 +0900 (KST)
Mime-Version: 1.0
Subject: RE: [PATCH 2/2] scsi: ufs: Use SYNCHRONIZE CACHE instead of FUA
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20230201180637.2102556-3-bvanassche@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20230202015436epcms2p7574c204a66b7cc24b5e1827e9e6d41f4@epcms2p7>
Date:   Thu, 02 Feb 2023 10:54:36 +0900
X-CMS-MailID: 20230202015436epcms2p7574c204a66b7cc24b5e1827e9e6d41f4
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPJsWRmVeSWpSXmKPExsWy7bCmha6ExO1kg5YfehYnn6xhs9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLlIU2LVQ/CLXr7t7JZPFk/i9li0Y1tTBbd13ewWSw//o/JYunW
        m4wOvB6Xr3h7XO7rZfJYvOclk8emVZ1sHhMWHWD0aDm5n8Xj+/oONo+PT2+xePRtWcXo8XmT
        nEf7gW6mAO6obJuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBd
        t8wcoPuVFMoSc0qBQgGJxcVK+nY2RfmlJakKGfnFJbZKqQUpOQXmBXrFibnFpXnpenmpJVaG
        BgZGpkCFCdkZN29eZyk4wl0xcd8X1gbGlVxdjJwcEgImErdPLWLpYuTiEBLYwSjx/P5h5i5G
        Dg5eAUGJvzuEQWqEBTwkFn48xghiCwkoSay/OIsdIq4ncevhGrA4m4COxPQT98HiIgJxEq2z
        XjGCzGQWWMQs0fX6HRPEMl6JGe1PWSBsaYnty7eCNXMKWEl8uPiDESKuIfFjWS8zhC0qcXP1
        W3YY+/2x+VA1IhKt985C1QhKPPi5GyouKXF77iao+nyJ/1eWQ9k1EtsOzIOy9SWudWwEu4FX
        wFdi5vVHYDaLgKrEwgs7WSFqXCTmtSwHizMLaEssW/gaHCbMApoS63fpg5gSAsoSR26xwHzV
        sPE3OzqbWYBPouPwX7j4jnlPoKGgJrHu53qmCYzKsxABPQvJrlkIuxYwMq9iFEstKM5NTy02
        KjCBx21yfu4mRnBK1vLYwTj77Qe9Q4xMHIyHGCU4mJVEeBW5biYL8aYkVlalFuXHF5XmpBYf
        YjQF+nIis5Rocj4wK+SVxBuaWBqYmJkZmhuZGpgrifNK255MFhJITyxJzU5NLUgtgulj4uCU
        amCac9xJ3DlKI1Op0cBSVOLBi2mWrw58faVR5/Hg5OwNZ1kPLAhxLdh47tOFHwbCdteNvA/q
        vqud8vXvsiO/0r+4cDM+bckPubbp0YKZifJFr9/enRO4ZNF67ifiNvffp+lUsp5esPjLR/0e
        phzuDYbdH3fmrLZxy5k/8fAJ/R+vKkI3PhU5fjLOZ4rVF9k9/y0X/GfVC7b64v8ogtuIi/dL
        oWrbi58XVvUeWP5SrOr+lT0ZcQcv2d5Zr7/0xav42sjD4Yb3qs6K/lvw+uf7CUy3mA4Xvqqc
        ObN93/rvNfPd1N5Vn1797+CHlEtFhYVblk/JXD890ODKHiW2zwuv5Fxi4F23Vz+xQ9zCQl/r
        Tt1l4a1KLMUZiYZazEXFiQBYXl2RUgQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230201180714epcas2p44eaa78a0a51443b4c66efdf7637aa82b
References: <20230201180637.2102556-3-bvanassche@acm.org>
        <20230201180637.2102556-1-bvanassche@acm.org>
        <CGME20230201180714epcas2p44eaa78a0a51443b4c66efdf7637aa82b@epcms2p7>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,
> From: Asutosh Das <asutoshd=40codeaurora.org>
>=20
> UFS devices perform better when using SYNCHRONIZE CACHE command
> instead of the FUA flag. Hence this patch.

If you have, could you share the result when using SYNCHRONIZE CACHE comman=
d?

Thanks,
Daejun

>=20
> Signed-off-by: Asutosh Das <asutoshd=40codeaurora.org>
> Signed-off-by: Bart Van Assche <bvanassche=40acm.org>
> =5B bvanassche: modified a source code comment =5D
> ---
>  drivers/ufs/core/ufshcd.c =7C 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index bf3cb12ef02f..461aa51cfccc 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> =40=40 -5056,6 +5056,9 =40=40 static int ufshcd_slave_alloc(struct scsi_d=
evice *sdev)
>  =C2=A0=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0/*=20WRITE_SAME=20command=20is=20=
not=20supported=20*/=0D=0A>=20=20=C2=A0=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0sde=
v->no_write_same=20=3D=201;=0D=0A>=20=C2=A0=0D=0A>=20+=20=C2=A0=20=C2=A0=20=
=C2=A0=20=C2=A0/*=20Use=20SYNCHRONIZE=20CACHE=20instead=20of=20FUA=20to=20i=
mprove=20performance=20*/=0D=0A>=20+=20=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0sde=
v->sdev_bflags=20=3D=20BLIST_BROKEN_FUA;=0D=0A>=20+=0D=0A>=20=20=C2=A0=C2=
=A0=20=C2=A0=20=C2=A0=20=C2=A0ufshcd_lu_init(hba,=20sdev);=0D=0A>=20=C2=A0=
=0D=0A>=20=20=C2=A0=C2=A0=20=C2=A0=20=C2=A0=20=C2=A0ufshcd_setup_links(hba,=
=20sdev);=0D=0A>=20=0D=0A=0D=0A
