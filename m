Return-Path: <SRS0=95cY=AR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5589C433DF
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 06:41:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 790552074F
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 06:41:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="iQDlDeBW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbgGFGlY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jul 2020 02:41:24 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:57783 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbgGFGlX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jul 2020 02:41:23 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200706064119epoutp03253eceaca1f5d13da520c7b6f67b90c7~fFqJepArO0859008590epoutp03p
        for <linux-scsi@vger.kernel.org>; Mon,  6 Jul 2020 06:41:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200706064119epoutp03253eceaca1f5d13da520c7b6f67b90c7~fFqJepArO0859008590epoutp03p
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1594017679;
        bh=V0Klo71k/7rAdue/UGf2C0R7LeG17mCEedS4PxSJfJg=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=iQDlDeBWf1frVO8EJlHQxQcZDv/AkyWc2bPQw9UVBJvkUf4KNS7DqiWdqwJbKwd4l
         2xogFjP4ksft/wdXDeXkHCSplzm6JZoHBBYOYuu1CkzCwZgR7naBnI3DYjhLcX7/C0
         gh0Ng5yJIdKTCtW3C25cqkggWgZGJY0MSp/jFaWs=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20200706064118epcas2p39b9f5e87dddc97e98d9db3a398639b30~fFqIfJmok2423824238epcas2p3J;
        Mon,  6 Jul 2020 06:41:18 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.185]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4B0bZ42N7GzMqYlh; Mon,  6 Jul
        2020 06:41:16 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        0E.EC.27441.C87C20F5; Mon,  6 Jul 2020 15:41:16 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20200706064115epcas2p29ee3e8a0da5e0deb539f7ddb958c4ed7~fFqFXHA0r3096530965epcas2p2g;
        Mon,  6 Jul 2020 06:41:15 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200706064115epsmtrp2909d4dbed539fdf06fd4d6e80f3ee26b~fFqFTnRz60224202242epsmtrp2K;
        Mon,  6 Jul 2020 06:41:15 +0000 (GMT)
X-AuditID: b6c32a47-fafff70000006b31-14-5f02c78c3ef1
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        E6.47.08382.B87C20F5; Mon,  6 Jul 2020 15:41:15 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200706064115epsmtip2db44d4ab4c6814640e57d264b649302c~fFqFE76_T2297622976epsmtip2R;
        Mon,  6 Jul 2020 06:41:15 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Avri Altman'" <Avri.Altman@wdc.com>,
        <linux-scsi@vger.kernel.org>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <bvanassche@acm.org>,
        <grant.jung@samsung.com>, <sc.suh@samsung.com>,
        <hy50.seo@samsung.com>, <sh425.lee@samsung.com>
In-Reply-To: <SN6PR04MB464035D0414922EEE0545CA6FC680@SN6PR04MB4640.namprd04.prod.outlook.com>
Subject: RE: [RFC PATCH v3 1/2] ufs: introduce a callback to get info of
 command completion
Date:   Mon, 6 Jul 2020 15:41:14 +0900
Message-ID: <000501d65360$72259600$5670c200$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQGzyCHOhCeJxiopSPNZAUTahmxpDALbRwriAcIz1fABN91Hp6kQhcog
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCJsWRmVeSWpSXmKPExsWy7bCmmW7PcaZ4g965ghYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCy6r+9gs1h+/B+TRdfdG4wW
        S/+9ZXHg9bh8xdvjcl8vk8eERQcYPb6v72Dz+Pj0FotH35ZVjB6fN8l5tB/oZgrgiMqxyUhN
        TEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAE6WUmhLDGnFCgU
        kFhcrKRvZ1OUX1qSqpCRX1xiq5RakJJTYGhYoFecmFtcmpeul5yfa2VoYGBkClSZkJOx9tFH
        poIG4YrDK38xNTDO4O1i5OCQEDCRWDNZqIuRi0NIYAejxMrDx5ghnE+MEnMvL2GEcL4xSqw/
        MYGli5ETrOPgq5NQVXsZJWZd2MoC4bxglDjTuZERpIpNQFti2sPdrCAJEYH7TBJHdj4Aa+cU
        iJXYvuIdE4gtDGRf2jiFHcRmEVCRWLD3AZjNK2ApMfXefhYIW1Di5MwnYDYz0NBlC18zQ5yh
        IPHz6TJWEFtEwE3iVO80ZogaEYnZnW1g50kIHOGQONjykRHiUxeJf3/4IHqFJV4d38IOYUtJ
        fH63lw3CrpfYN7WBFaK3h1Hi6b5/jBAJY4lZz9rB5jALaEqs36UPMVJZ4sgtqNP4JDoO/2WH
        CPNKdLQJQTQqS/yaNBlqiKTEzJt3oLZ6SPQtm8c+gVFxFpInZyF5chaSZ2Yh7F3AyLKKUSy1
        oDg3PbXYqMAYObI3MYKTs5b7DsYZbz/oHWJk4mA8xCjBwawkwturzRgvxJuSWFmVWpQfX1Sa
        k1p8iNEUGOwTmaVEk/OB+SGvJN7Q1MjMzMDS1MLUzMhCSZy32OpCnJBAemJJanZqakFqEUwf
        EwenVAOTz94vS74dvRY52773csU/4SWPLFwDDz4yPXJgwrwp3tvf9pTMObqsY+miCtUX3/PX
        nvR8pbJUM32Sn5D6SfYN/NdlHvCvFvXgDz295PBphu3TGU+5i/4MENcNvJ9y2PVM6GovPd+W
        tc43JSzfsbb9MmK9G9TYuKzg5bsA7iitzv7qlUlvd7w9ULubo602f//7BXYPaxg9LF9suWW9
        2K/e0O7HGtnXRZqP3k2XjNvcXCbosq9hd/JpnjTnk/LZ+3fqOUcGft/7yl1JuMNYRnopJ/PM
        yY8+bbRQ2SA943a7xF9v38Cdd78e6TlT7vG2e//rrccDFCZVTxHRZC0oy5fV45x38OiMR7la
        TUKNN27cU2Ipzkg01GIuKk4EANenqedXBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCIsWRmVeSWpSXmKPExsWy7bCSvG73caZ4g6kdXBYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCy6r+9gs1h+/B+TRdfdG4wW
        S/+9ZXHg9bh8xdvjcl8vk8eERQcYPb6v72Dz+Pj0FotH35ZVjB6fN8l5tB/oZgrgiOKySUnN
        ySxLLdK3S+DK+Hk3uuCqUMWR5qVsDYyveboYOTkkBEwkDr46ydzFyMUhJLCbUeLesjZ2iISk
        xImdzxkhbGGJ+y1HWCGKnjFKPJ17jQUkwSagLTHt4W6whIjAWyaJO7cvM0FUrWaS+PKknRWk
        ilMgVmL7indMILawQLTErMd7wOIsAioSC/Y+AFvHK2ApMfXefhYIW1Di5MwnYDYz0Ibeh62M
        MPayha+ZIU5SkPj5dBnYHBEBN4lTvdOYIWpEJGZ3tjFPYBSahWTULCSjZiEZNQtJywJGllWM
        kqkFxbnpucWGBYZ5qeV6xYm5xaV56XrJ+bmbGMERqaW5g3H7qg96hxiZOBgPMUpwMCuJ8PZq
        M8YL8aYkVlalFuXHF5XmpBYfYpTmYFES571RuDBOSCA9sSQ1OzW1ILUIJsvEwSnVwNSsuqmb
        Y49Sy573TKJntl+f0Z4VUBXYENpVxC6/Ydv3xrBuzccvL2/ryXTk+bXQyPg4x5W8N7VRSVPD
        wsuDP57xZ0+4sOSBTXXlLzY9EfayvbcZvDezFG6ZJP9P1MHvwdcj8vf2Oc6Yrah9t1VSPCaR
        ScT1g+mBhLYponMnRh05b1/A2W4TPlu1m8HlZP8kfzaX9b+LVee4cjNmSlT/PLhvtd1MNr9z
        O7nWW9roPZ29vK0v79SkU2d8HKr0/bbsWMvRkS594N79mUumenjxtuZ8lT9tm+Aw7Uf//OLr
        QsJ9DnkOU5dn2Wf+Xe0l/NawK9xmwec1j4vkbF/Mrsy8dXqn9qos22/vRNyuZuyRV2Ipzkg0
        1GIuKk4EAA23AeU3AwAA
X-CMS-MailID: 20200706064115epcas2p29ee3e8a0da5e0deb539f7ddb958c4ed7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200703053854epcas2p12c65dc7bf34f99354482104f51805b5d
References: <cover.1593752220.git.kwmad.kim@samsung.com>
        <CGME20200703053854epcas2p12c65dc7bf34f99354482104f51805b5d@epcas2p1.samsung.com>
        <93c364a2285a6c8eaaed6e0f68bbc8376ae7519e.1593752220.git.kwmad.kim@samsung.com>
        <SN6PR04MB464035D0414922EEE0545CA6FC680@SN6PR04MB4640.namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > Some SoC specific might need command history for various reasons, such
> > as stacking command contexts in system memory to check for debugging
> > in the future or scaling some DVFS knobs to boost IO throughput.
> >
> > What you would do with the information could be variant per SoC
> > vendor.
> >
> > Signed-off-by: Kiwoong Kim <kwmad.kim=40samsung.com>
> > ---
> >  drivers/scsi/ufs/ufshcd.c =7C 2 ++
> >  drivers/scsi/ufs/ufshcd.h =7C 8 ++++++++
> >  2 files changed, 10 insertions(+)
> >
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index 52abe82..3326236 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > =40=40 -4882,6 +4882,7 =40=40 static void __ufshcd_transfer_req_compl(s=
truct
> > ufs_hba *hba,
> >         for_each_set_bit(index, &completed_reqs, hba->nutrs) =7B
> >                 lrbp =3D &hba->lrb=5Bindex=5D;
> >                 cmd =3D lrbp->cmd;
> > +               ufshcd_vops_compl_xfer_req(hba, index, (cmd) ? true :
> > + false);
> >                 if (cmd) =7B
> >                         ufshcd_add_command_trace(hba, index, =22complet=
e=22);
> >                         result =3D ufshcd_transfer_rsp_status(hba,
> > lrbp); =40=40 -4890,6 +4891,7 =40=40 static void
> > __ufshcd_transfer_req_compl(struct
> > ufs_hba *hba,
> >                         /* Mark completed command as NULL in LRB */
> >                         lrbp->cmd =3D NULL;
> >                         lrbp->compl_time_stamp =3D ktime_get();
> > +
> >                         /* Do not touch lrbp after scsi done */
> >                         cmd->scsi_done(cmd);
> >                         __ufshcd_release(hba); diff --git
> > a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h index
> > c774012..5cf9f99 100644
> > --- a/drivers/scsi/ufs/ufshcd.h
> > +++ b/drivers/scsi/ufs/ufshcd.h
> > =40=40 -307,6 +307,7 =40=40 struct ufs_hba_variant_ops =7B
> >         void    (*config_scaling_param)(struct ufs_hba *hba,
> >                                         struct devfreq_dev_profile *pro=
file,
> >                                         void *data);
> > +       void    (*compl_xfer_req)(struct ufs_hba *hba, int tag, bool
> is_scsi);
> Maybe add it right after setup_xfer_req?
> Makes more sense as it is its counterpart.
>=20
> Thanks,
> Avri
>=20
> >  =7D;

Got it

Thanks.
Kiwoong Kim

