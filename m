Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D6C9CE79A8
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Sep 2023 22:58:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbjISW6N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Sep 2023 18:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjISW6M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Sep 2023 18:58:12 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93AB0C0
        for <linux-scsi@vger.kernel.org>; Tue, 19 Sep 2023 15:58:06 -0700 (PDT)
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20230919225803epoutp011ed347b7ca2940da82ecfd5d043dbdf3~Gbu9JYnbo1242012420epoutp01J
        for <linux-scsi@vger.kernel.org>; Tue, 19 Sep 2023 22:58:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20230919225803epoutp011ed347b7ca2940da82ecfd5d043dbdf3~Gbu9JYnbo1242012420epoutp01J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1695164283;
        bh=3J97XRH02sYDsImNUqLuFSNGgUl+jzzvU8ej2mmtNBA=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=bR7aU9rnMC9jVxqZicMd5D/VOcC3Kfz9JmEkLapTRUjIcW/CtqMq0iP44LeXs9NK4
         1kZyECP8IKKruWiVtzI4w7RKZ8vE6JhfMOUsgnJe4nftgUulBuTmGuK+D4k6ETrmgG
         dJLuDebXTAnEFRs/okl1GO/UIJ5DPuIzzif9WEu8=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20230919225803epcas2p2573920bb4a61b8d74820f4c02bae1823~Gbu8mJJOK0222202222epcas2p2M;
        Tue, 19 Sep 2023 22:58:03 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp4.localdomain
        (Postfix) with ESMTP id 4Rqxs70y5Yz4x9Pw; Tue, 19 Sep 2023 22:58:03 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: [PATCH 1/4] scsi: ufs: Return in case of an invalid tag
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <quic_cang@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Bean Huo <beanhuo@micron.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20230918162058.1562033-2-bvanassche@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1461149300.81695164283129.JavaMail.epsvc@epcpadp4>
Date:   Wed, 20 Sep 2023 07:47:22 +0900
X-CMS-MailID: 20230919224722epcms2p419e728d234b29e5dab5e4bad2eb257eb
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20230918162757epcas2p24a62d5f284e643a4f9e4da50ce0bd605
References: <20230918162058.1562033-2-bvanassche@acm.org>
        <20230918162058.1562033-1-bvanassche@acm.org>
        <CGME20230918162757epcas2p24a62d5f284e643a4f9e4da50ce0bd605@epcms2p4>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

> If a tag is invalid, instead of only issuing a kernel warning, also
> return. This patch suppresses Coverity warnings about left shifts with a
> negative right hand operand.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/ufs/core/ufshcd.c | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index dc1285351336..5fccec3c1091 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -2822,7 +2822,8 @@ static int ufshcd_queuecommand(struct Scsi_Host *ho=
st, struct scsi_cmnd *cmd)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int err =3D 0;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct ufs_hw_queue *hwq =3D NULL;
> =20
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0WARN_ONCE(tag < 0 || tag >=3D hba->nutrs, "I=
nvalid tag %d\n", tag);
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0if (WARN_ONCE(tag < 0 || tag >=3D hba->nutrs=
, "Invalid tag %d\n", tag))
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;

As far as I know, a return 0 from a queuecommand means that the request was=
 accepted by LLD.=20

Thanks,
Daejun

