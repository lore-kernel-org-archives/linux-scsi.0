Return-Path: <SRS0=xqUt=CC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 814A5C433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Aug 2020 05:04:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22BEE20706
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Aug 2020 05:04:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Yi93uLc0";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="GpOytqJ7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726027AbgHXFEJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Aug 2020 01:04:09 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:49134 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725817AbgHXFEF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Aug 2020 01:04:05 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07O4uh3t018918;
        Sun, 23 Aug 2020 22:03:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=KIYH5gjatkDHjsVjZrizePuF0eF1NLuodmgVd1Q0pRc=;
 b=Yi93uLc0qBq9THVrMxXNOxieyCWp40ieaatVueOaofHDROkhumekAaOxIaoCcl5qPr1l
 XEwgWkNCClFLBMZGWaOldeNPxW2HlpsmGwSOd9ae9HBdpsJHiOt38ObvWVONF9zdM2Gy
 FBAsFoFW04QYd3PJyOe/MUSeA7zouJ00vph4Msmhh+nlXcniw6Xgf1Uil8BGc8/9vDYj
 GsGr4vUBpsie8QRYKpl8XA+jU/g75lpao+l8o+IKubgH0vSMXrD3aPJ7BaFAyUw8LosQ
 yyasc/VQC92xg0sXgql2Gbi3/dX+8itr359yQt2G/QhR9H1jO51dWw60Y6HvGPCMsYYe Vg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3330qpdptt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 23 Aug 2020 22:03:54 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 23 Aug
 2020 22:03:53 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 23 Aug 2020 22:03:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=COdECTlem6WEq+EVom1/YKf3HTjcVI2hlsgyBsFLIV47Jx3Fi+vbocA0m/8lq5uXE+6F6GbXxAE+WTAM3IHCcUQIg+E1nZ7QqcJgZYSqBgjHYTnv8IAHcNC4SEtet9jjntdI18ZLYNYn1CclHZfUnYBz3QcR45C52yuvxR4LCe1QijiCiQLf4DnbS9auD6nVtdtUQhwjwlLoxbTmZI7/6Q9XNzoChbSSD2txuxCEwUC5nHr/NHQj/zzHsNp70KU09rpA+zsDnRHBlOXdf+P9WUMHgZIHo4cp9ba7dDudB+EbijSxgr63A0IQIUdQnnsaHTp/jkDlzF2rISCRe+etmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KIYH5gjatkDHjsVjZrizePuF0eF1NLuodmgVd1Q0pRc=;
 b=dK9xBNbvvwML1u13QhdKGCUU6jUb+Z8E3dpBuiQY49F545mI/3BjSMxqmXkcnfUnbkRHqiMIN7Wu43MiShjvotcnmDC6qBe3OBcEmwoR7wyj+BzZkQW3mwnNXaotDkeFF9Zoc/pc1PoVIs+IhEEGeYI3g+FA5dO0ufe1T0rPcWNC+A8MlK+bdZcUgxWCJdwK7yC930Pjtwn/P7CT8v4afg6QHJZcr3d4bgAtymZ7iozVdDvD8t1ugY/OgEjX53aVG58RkSkh0cWG7uSSAP2T5gSyP5t1UpWfJjU+9TW9Q4fu1YfLn/boFKV95s9dS58fUmB1qmk/a9G8DQG/6kDQZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KIYH5gjatkDHjsVjZrizePuF0eF1NLuodmgVd1Q0pRc=;
 b=GpOytqJ7ek++ianNGcA+1f0RWtdvvHA8M2SBDtN/b0gmxfo+h2uF6j1hmMEsNlUqdEcjpmzjSkSYNgtHId6BAwRW3t8PEvefSHgunG68utxcQmF2vrP4v1Nrr9MpT9LFVQRFSSgfDcUPXe0XCbOAYpHbH2nWlChBaBtUxfBfDDU=
Received: from DM6PR18MB3034.namprd18.prod.outlook.com (2603:10b6:5:18c::32)
 by DM6PR18MB3441.namprd18.prod.outlook.com (2603:10b6:5:2a4::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.26; Mon, 24 Aug
 2020 05:03:51 +0000
Received: from DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::a8f6:e070:a471:e7dd]) by DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::a8f6:e070:a471:e7dd%3]) with mapi id 15.20.3305.026; Mon, 24 Aug 2020
 05:03:51 +0000
From:   Saurav Kashyap <skashyap@marvell.com>
To:     Ye Bin <yebin10@huawei.com>,
        "QLogic-Storage-Upstream@cavium.com" 
        <QLogic-Storage-Upstream@cavium.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH] scsi: qedf: Fix null ptr reference in
 qedf_stag_change_work
Thread-Topic: [PATCH] scsi: qedf: Fix null ptr reference in
 qedf_stag_change_work
Thread-Index: AQHWedK6m0zbBmLF902S2+AXqAB79KlGs/lw
Date:   Mon, 24 Aug 2020 05:03:51 +0000
Message-ID: <DM6PR18MB30341FC305EC1B0C0469B550D2560@DM6PR18MB3034.namprd18.prod.outlook.com>
References: <20200824033436.45570-1-yebin10@huawei.com>
In-Reply-To: <20200824033436.45570-1-yebin10@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [42.107.68.30]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f30c50dc-b443-4ad6-dd33-08d847eb17bc
x-ms-traffictypediagnostic: DM6PR18MB3441:
x-microsoft-antispam-prvs: <DM6PR18MB3441F0520B315B86481C1627D2560@DM6PR18MB3441.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:826;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5maDXbvr2lRPBZAwhd8O8SkNK8Qp/b9ERIK+ugH3VlChBWoMaRMPNxGKsXCNgRN6EL6TDdlc1DKw26yLvrC63nd51lONk0mpvhfXD89elDoBR3BylsvIWqNnH61T3J6G1wbWdEr4f7RRoNutUgHBo1T5a26ogsk8tqnYT2Cq0iQy0eJ7QHOTp2TIVyXKwaHBd1HalPRsw1mdPOlCk+wZmSyqRKOYjjbKFITEGQ2ymlESGfvAJ9FZgIkjv0w6mBnkidXf34wlF30I/SkF/jAKeNagu69Uze/RNoElZsznIlYyzY4P8Oxx0+czgaMK1VoORQDqylIxyRvlwS14Ec9zJg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3034.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(136003)(396003)(39850400004)(8676002)(2906002)(52536014)(478600001)(186003)(33656002)(55016002)(5660300002)(7696005)(26005)(8936002)(316002)(86362001)(9686003)(83380400001)(53546011)(66446008)(66556008)(64756008)(66476007)(76116006)(71200400001)(66946007)(6506007)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: AYCYyWZK9c4zbDd6M7fduIuKa4PAd/6l7hmV6TBsQH0ENJatNSSAzIo8MFJihCONWEga/MTsB3lw/tOiZjRQblfqlTP8rpoD2ItwZwDWolfru8Y6XusjI7MUK2mr3S2u8fai3nguTsXxvOkbhevv0sgEssqrkSBmPG70qzCAMR6895mtzkHaS3tP/m3PA2ypfA13GjtD5EqlUuMbRODs+NCDyF9thJnBr2hyXe85v35RY8i/b2RSkFOy0z7xP86+e0LM+XNseCmJNbeJvXXVj6nhBxWmOpEwHHAZIWK+1Iaauw24t3LAdD92zAiw7cnpqe+m4bqJ2wZBNTEyEfxkTCpT+cW52RwC5E92/T1WDgFysRhZYwmtNL6cn7sAlTNiBCzC24e263zXfnKTSigiiUjsJJXzBGXXwvdJINaQnIJ2yHDxSlH6HN1fDCBHuQLdfS5U674J90ZbNVTrWX6HTRzE8Np1MCqH352SoGSnwImpfMzh03hXOKqK30H0kJXQMjJ2Ytpwx/t4oNJjIrmlrJrLPcZxizaVT5hn75Kl8PZeAzqf1hYmzNLO0G4o5XPyDyxWEhRU5zNfWV4fGU3VJ4RqmAijWBtEZQjzoH4fCbYt9gVfU4miNdEPC1SSWxB/ecPgfZeSTcaxdifFXi2SXA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3034.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f30c50dc-b443-4ad6-dd33-08d847eb17bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2020 05:03:51.2795
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zRg/tBcT5KGwXfwUCS1x7kRA4HVAKjlwUjpTuHPrh9kUIjA6B1xyYmOciKpT8x8XyvzPbKgcw9cAHS0mDtYc4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB3441
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-24_03:2020-08-24,2020-08-24 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bin,
Thanks for an patch.

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org <linux-scsi-owner@vger.kernel.org>
> On Behalf Of Ye Bin
> Sent: Monday, August 24, 2020 9:05 AM
> To: QLogic-Storage-Upstream@cavium.com; jejb@linux.ibm.com;
> martin.petersen@oracle.com; linux-scsi@vger.kernel.org
> Cc: Ye Bin <yebin10@huawei.com>
> Subject: [PATCH] scsi: qedf: Fix null ptr reference in qedf_stag_change_w=
ork
>=20
>=20
> Signed-off-by: Ye Bin <yebin10@huawei.com>
> ---
>  drivers/scsi/qedf/qedf_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.=
c
> index 39c4bdc89937..c855ff3ad232 100644
> --- a/drivers/scsi/qedf/qedf_main.c
> +++ b/drivers/scsi/qedf/qedf_main.c
> @@ -3874,7 +3874,7 @@ void qedf_stag_change_work(struct work_struct
> *work)
>  	    container_of(work, struct qedf_ctx, stag_work.work);
>=20
>  	if (!qedf) {
> -		QEDF_ERR(&qedf->dbg_ctx, "qedf is NULL");
> +		QEDF_ERR(NULL, "qedf is NULL");
>  		return;
>  	}
>  	QEDF_ERR(&qedf->dbg_ctx, "Performing software context reset.\n");
> --
> 2.25.4

Acked-by: Saurav Kashyap <skashyap@marvell.com>



