Return-Path: <SRS0=QZQu=BU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8904C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 10:08:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7799D20709
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 10:08:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="MgC6+tmQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbgHJKIG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Aug 2020 06:08:06 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:43817 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726092AbgHJKIG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Aug 2020 06:08:06 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200810100802epoutp01439c9e04c51045e36f798cf1e78d7dd0~p4DneZ-5y0965809658epoutp016
        for <linux-scsi@vger.kernel.org>; Mon, 10 Aug 2020 10:08:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200810100802epoutp01439c9e04c51045e36f798cf1e78d7dd0~p4DneZ-5y0965809658epoutp016
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1597054082;
        bh=g3vVFLTqRH93Y5pDG9XSbAH1P0G/Re9NDnnA/VJA034=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=MgC6+tmQ6ktCcrs4GKyFk9bWqYxBE8KrazXdmHzXp9yPaRCOy41M5bw/VzLWhlhuD
         kLAxsYGIrMrn09mogT8olqU+FpG5jTabk9hpSkiYiUFD7ly1htCNiTer6MMXwbkKRA
         QYfQKl975J4oQHxfTq7jUJTxFPUilaFtjRs9C1Yk=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20200810100801epcas2p47e84129f71c69456a193045eb29da4e7~p4Dm2vP7g0811708117epcas2p4Y;
        Mon, 10 Aug 2020 10:08:01 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.189]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4BQBVS0whVzMqYkX; Mon, 10 Aug
        2020 10:08:00 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        B8.94.19322.08C113F5; Mon, 10 Aug 2020 19:08:00 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20200810100759epcas2p2d1887e22d66420dee66fc0b8f46b0b6b~p4Dk85u6d0671606716epcas2p2b;
        Mon, 10 Aug 2020 10:07:59 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200810100759epsmtrp26fe231934ead443f7b1e3bd199646b87~p4Dk8HvML1224712247epsmtrp2v;
        Mon, 10 Aug 2020 10:07:59 +0000 (GMT)
X-AuditID: b6c32a45-797ff70000004b7a-f5-5f311c80638f
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        6D.D7.08382.F7C113F5; Mon, 10 Aug 2020 19:07:59 +0900 (KST)
Received: from KORCO011456 (unknown [12.36.185.54]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20200810100759epsmtip2bf1a43ed87846b0cc74984eaf6590271~p4Dktzb2o1225812258epsmtip2h;
        Mon, 10 Aug 2020 10:07:59 +0000 (GMT)
From:   "Kiwoong Kim" <kwmad.kim@samsung.com>
To:     "'Avri Altman'" <Avri.Altman@wdc.com>,
        <linux-scsi@vger.kernel.org>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <beanhuo@micron.com>, <asutoshd@codeaurora.org>,
        <cang@codeaurora.org>, <bvanassche@acm.org>,
        <grant.jung@samsung.com>, <sc.suh@samsung.com>,
        <hy50.seo@samsung.com>, <sh425.lee@samsung.com>
In-Reply-To: <SN6PR04MB464091A87323AD75C4453BE9FC440@SN6PR04MB4640.namprd04.prod.outlook.com>
Subject: RE: [PATCH v2] ufs: change the way to complete fDeviceInit
Date:   Mon, 10 Aug 2020 19:07:58 +0900
Message-ID: <006101d66efe$200279b0$60076d10$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQCaigg8XwKd3RNoHscW3UQG4Xl7FgFCLeM9AZYWwfWrkiWX8A==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMJsWRmVeSWpSXmKPExsWy7bCmuW6DjGG8wdrVrBYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCy6r+9gs1h+/B+TRdfdG4wW
        S/+9ZXHg9bh8xdvjcl8vk8eERQcYPb6v72Dz+Pj0FotH35ZVjB6fN8l5tB/oZgrgiMqxyUhN
        TEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAE6WUmhLDGnFCgU
        kFhcrKRvZ1OUX1qSqpCRX1xiq5RakJJTYGhYoFecmFtcmpeul5yfa2VoYGBkClSZkJPx/fV8
        xoIenopzuzYzNTBO4+hi5OCQEDCRmHM0r4uRi0NIYAejxLHtJ9ghnE+MEmcOv2WCcL4xSmz6
        f4QNpuPYZvkuRk6g+F5GiU9bZCBqXjBKdDevYQFJsAloS0x7uJsVJCEicJ9J4sjOB2AJToFY
        iW03D7KD2MICzhKn3iwFi7MIqEqs+tDNBmLzClhKLJqxnwXCFpQ4OfMJmM0MNHTZwtfMILaE
        gILEz6fLWEFsEQEniZ/XW9ggakQkZne2MYMslhC4wCGx6zjEAgkBF4ndi06xQdjCEq+Ob2GH
        sKUkPr/bCxWvl9g3tYEVormHUeLpvn+MEAljiVnP2hlB3mcW0JRYv0sfEhLKEkduQd3GJ9Fx
        +C87RJhXoqNNCKJRWeLXpMlQQyQlZt68A7XVQ2L2xzPMExgVZyH5chaSL2ch+WYWwt4FjCyr
        GMVSC4pz01OLjQoMkeN6EyM4NWu57mCc/PaD3iFGJg7GQ4wSHMxKIrx2d/XjhXhTEiurUovy
        44tKc1KLDzGaAsN9IrOUaHI+MDvklcQbmhqZmRlYmlqYmhlZKInz5ipeiBMSSE8sSc1OTS1I
        LYLpY+LglGpgmvzHd77MEa9laXers3TePUn6eanbiks44XjLB/MqgcLb69n3nP428fk09bg/
        ieF6CwqOLFJZ/cahVen6If23hvfZD1gxB7zofDFPb8ORxHd/65LKmZO/755y/9X7RbFsF8+E
        iHNqLP2YrD4jb6Hi3c/nhBNNBZbr+i+XZ49YZrzaWT1fYXmYZfJD/iXfNR/67k5z/v4+Ny2m
        Xo8jnMWRIy7dz4C9donIFFvW0MD/JeFKoumG1SmFd9UY5poGxFRLnbz4WPXYwUeZzzhV5gsJ
        ZavOTQ9ceUxvnQ+vVN/RrY72pjNUElaKXznz7dZl3ac67WW7twhP2HXYLMNa88bfFX8SZ+W7
        tyX8+XzU47CWEktxRqKhFnNRcSIAM/qz+FYEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMIsWRmVeSWpSXmKPExsWy7bCSvG69jGG8waTvvBYP5m1js9jbdoLd
        4uXPq2wWBx92slhM+/CT2eLT+mWsFr/+rme3WL34AYvFohvbmCy6r+9gs1h+/B+TRdfdG4wW
        S/+9ZXHg9bh8xdvjcl8vk8eERQcYPb6v72Dz+Pj0FotH35ZVjB6fN8l5tB/oZgrgiOKySUnN
        ySxLLdK3S+DKWN24jrHgF3fF+Xc9TA2MLRxdjBwcEgImEsc2y3cxcnEICexmlPix7Q9jFyMn
        UFxS4sTO51C2sMT9liOsILaQwDNGifuNeiA2m4C2xLSHu1lBmkUE3jJJ3Ll9mQli0ktGiQOL
        3jODVHEKxEpsu3mQHcQWFnCWOPVmKQuIzSKgKrHqQzcbiM0rYCmxaMZ+FghbUOLkzCdgNjPQ
        ht6HrYww9rKFr5khLlKQ+Pl0GdhFIgJOEj+vt7BB1IhIzO5sY57AKDQLyahZSEbNQjJqFpKW
        BYwsqxglUwuKc9Nziw0LDPNSy/WKE3OLS/PS9ZLzczcxguNRS3MH4/ZVH/QOMTJxMB5ilOBg
        VhLhtburHy/Em5JYWZValB9fVJqTWnyIUZqDRUmc90bhwjghgfTEktTs1NSC1CKYLBMHp1QD
        U/PTzZtmmVxV1LB+eVtxntX2jedYzTRUrgUfurP0o/yKore+JxtCjls/UE4+bZw207qYQ+XH
        rdnR+8Tdt62veae0s/XRuy+KMwWvqe/5e/LUArOnAtveprwv+rFF6VLMqRk6E8w+NjU+Wl95
        eUGkj5jprbtNnzQN2Xtnc1SqzJu37dHPAxpHncoqJfyiNzcWBm526ORtKp5hUVVVWW24aa35
        k877b1fqzObIZ9wXo79+ia++o/NWibVnK5Yn9VY/i3/8hGXRrsVLbu/5xV8vOHPeDqffazdV
        1zgv2LEilE1eJYm59av18rlNrCs5EzgmFl6zqzE18pOquVwWOffeiXWuN/55rfq8hHGtfnN4
        eZgSS3FGoqEWc1FxIgDFoVOBNgMAAA==
X-CMS-MailID: 20200810100759epcas2p2d1887e22d66420dee66fc0b8f46b0b6b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200810060457epcas2p3023e61584089a0f285338d7e04ccaefe
References: <CGME20200810060457epcas2p3023e61584089a0f285338d7e04ccaefe@epcas2p3.samsung.com>
        <1597038989-192527-1-git-send-email-kwmad.kim@samsung.com>
        <SN6PR04MB464091A87323AD75C4453BE9FC440@SN6PR04MB4640.namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> > +       ktime_t start;
> > +       s64 time;
> Can this be done with less variables?  e.g is this working?
> ktime_t timeout;=20
I checked it worked. Nevertheless, I'll replace with your style.

Thanks.
Kiwoong Kim
>=20
> >
> >         err =3D ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_SET_FLAG=
,
> >                 QUERY_FLAG_IDN_FDEVICEINIT, 0, NULL); =40=40 -4161,20
> > +4165,27 =40=40 static int ufshcd_complete_dev_init(struct ufs_hba
> > *hba)
> >                 goto out;
> >         =7D
> >
> > -       /* poll for max. 1000 iterations for fDeviceInit flag to clear =
*/
> > -       for (i =3D 0; i < 1000 && =21err && flag_res; i++)
> > -               err =3D ufshcd_query_flag_retry(hba,
> > UPIU_QUERY_OPCODE_READ_FLAG,
> > -                       QUERY_FLAG_IDN_FDEVICEINIT, 0, &flag_res);
> > +       /* Poll fDeviceInit flag to be cleared */
> > +       start =3D ktime_get();
> timeout =3D ktime_add_ms(ktime_get(), FDEVICEINIT_COMPL_TIMEOUT);
>=20
> > +       do =7B
> > +               err =3D ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_READ_F=
LAG,
> > +                                       QUERY_FLAG_IDN_FDEVICEINIT, 0, =
&flag_res);
> > +               if (=21flag_res)
> > +                       break;
> > +               usleep_range(5000, 10000);
> > +               time =3D ktime_to_ms(ktime_sub(ktime_get(), start));
> > +       =7D while (time < FDEVICEINIT_COMPL_TIMEOUT);
> while (ktime_before(ktime_get(), timeout));
>=20
>=20
>=20
> Thanks,
> Avri

