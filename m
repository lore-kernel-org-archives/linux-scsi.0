Return-Path: <SRS0=4FRQ=XO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD936C49ED7
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Sep 2019 08:52:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA66621924
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Sep 2019 08:52:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="RcOIwt8c";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="ctZ06m9H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730677AbfISIwS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Sep 2019 04:52:18 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:55504 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725887AbfISIwS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 19 Sep 2019 04:52:18 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8J8o2NO025542;
        Thu, 19 Sep 2019 01:52:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=r1khto52ogzIdvfVQ+MmiHxgznu+76GpQnxu992tHSM=;
 b=RcOIwt8cWpM48gdl4u7CjrBWDhAwn0HLBJV63EX4f4njM8h1TaNMLPm7LZSBMDTlb9Cy
 w9poStHA/0zkABu5BlSyrHOiGdcGY2dNhtV7yzObNhtPVC8VmgqE72bLxhsuvl8Tcdmc
 X17Kr4quNpv4D0LhiJsVNPnNWNl0HAocmH10F1Q4w0hXTEiGCT2nPJSGbTdJZH5rsbEn
 Nk63EZx/LfOEJDnvDehM/B3glYLN9MYmF7T8GWgLxxdM7RSpkhR9IcWzi48vPNUAAnKm
 fVhhi36FbycDF4wBJbASE3IYPR5RG7fWBS9JlkmS7BuZaeTYwcbvlPZdUltkWQZretaB sw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2v3vcfj1qu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 19 Sep 2019 01:52:15 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 19 Sep
 2019 01:52:13 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (104.47.41.58) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 19 Sep 2019 01:52:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HUilyvMcte5gH1CV9Z+uo1Qs0daXhiN/a14hY+GJReis1MM6U1/g+czWDdKawh0GYl6HqUM06LALmf5WwTm8yPGpZtUtd1dIiUec0ptShLsubJs9BD1VZuY472tgJ719xusa7Y6OhpoPQjNgvgT2+JAqf+QAVTUw1m34VFYYvMZSa77cjuTT00j22hIkfkJchclqFmcz5qNqj4L/szCI/AuOQjbn4AZPWd640EUpPvDCuplF/QGgCW6sZtiixU+RuP9vZCArvjfyi+mdtL/rucMr1ZsultZIhROjuAiHqdxt/LVYFN9of/kW+cLP7EQQjENONPC9ryZt/6ps4PTJ8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r1khto52ogzIdvfVQ+MmiHxgznu+76GpQnxu992tHSM=;
 b=oK4cPvzzx91+RMAlZdG0aSHogVwxA7zyAiQ+4HJct7/S66FjrYsxj7syOqXFwhFu4dT9TVx2uR/mzdfsS4xp8ccemFmQunvFta7qsSKZ91weQlFxu4INLyI4Ul3h/HVUHBF0U3T+QYRkpVC2wCdO5OdF4/dUSDCtrCNgQjFZ+S/Ko5knQA7lTNq877BNZ3NIYYFFx08P3KqMx9s4kOjX3Y6n025T15J6Z2KJP2n3u1wfraSdUnHzYDJXlOOTZ8Woy/fCrb0quktO6P7DIpU2wqD8rsQTe6VBb80pD+1OHm3g58KDNEWZf8jAGL4aGDwqHmhiAMUqMm9hShcfvG7foQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r1khto52ogzIdvfVQ+MmiHxgznu+76GpQnxu992tHSM=;
 b=ctZ06m9HsLzvaDjsgSytK0biw8l7oPCYdTF4AZijVNPAn9tDpWLo6rXuIINqGoTsGrr1v7hjx0hHBcihafSAUg0zz4aEMvYPgphmWATJS8PKkuqnc/UUm+x7Wr6EFrCuShRPu5UOlfL1zW9AGmfxggC2Qpb5Mzan2AWVKqh/bRI=
Received: from MN2PR18MB2527.namprd18.prod.outlook.com (20.179.82.202) by
 MN2PR18MB3165.namprd18.prod.outlook.com (10.255.236.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.21; Thu, 19 Sep 2019 08:52:11 +0000
Received: from MN2PR18MB2527.namprd18.prod.outlook.com
 ([fe80::a409:deb5:4bf4:a789]) by MN2PR18MB2527.namprd18.prod.outlook.com
 ([fe80::a409:deb5:4bf4:a789%7]) with mapi id 15.20.2263.023; Thu, 19 Sep 2019
 08:52:11 +0000
From:   Saurav Kashyap <skashyap@marvell.com>
To:     Austin Kim <austindh.kim@gmail.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "QLogic-Storage-Upstream@cavium.com" 
        <QLogic-Storage-Upstream@cavium.com>
Subject: RE: [PATCH] scsi: qedf: Remove always false 'tmp_prio < 0' statement
Thread-Topic: [PATCH] scsi: qedf: Remove always false 'tmp_prio < 0' statement
Thread-Index: AQHVbsZy+GTAtfgAMkWKAgWFGPs49KcysVLA
Date:   Thu, 19 Sep 2019 08:52:11 +0000
Message-ID: <MN2PR18MB252777FF9E6A250332E70661D2890@MN2PR18MB2527.namprd18.prod.outlook.com>
References: <20190919075548.GA112801@LGEARND20B15>
In-Reply-To: <20190919075548.GA112801@LGEARND20B15>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [114.143.185.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 14b2db94-206e-4005-0a2e-08d73cdea90c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB3165;
x-ms-traffictypediagnostic: MN2PR18MB3165:
x-microsoft-antispam-prvs: <MN2PR18MB3165087F317F6AEEEAE59C1BD2890@MN2PR18MB3165.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 016572D96D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(396003)(136003)(39860400002)(376002)(51914003)(13464003)(189003)(199004)(25786009)(33656002)(486006)(14454004)(99286004)(76116006)(66556008)(66476007)(256004)(66946007)(66446008)(64756008)(102836004)(6436002)(11346002)(446003)(26005)(476003)(186003)(229853002)(52536014)(2501003)(2201001)(86362001)(14444005)(53546011)(7696005)(76176011)(6506007)(478600001)(66066001)(2906002)(74316002)(4326008)(81166006)(8676002)(6116002)(8936002)(3846002)(316002)(7736002)(305945005)(71190400001)(71200400001)(81156014)(6246003)(5660300002)(55016002)(9686003)(110136005)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB3165;H:MN2PR18MB2527.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: TOJYHkthxAGdAEyR/V6lzz1uH3kws4E+6b+ETnAHjJxmiF/JK8v3rAgfjtZmfcVjeoHMJKPkNmtTZmOC6KAtCUYcKH2bv024EGGIs+UrwI55kn+OaE5pVO8Pc8DaudrAT/VxhaCB535og51AtsXq/m7e7jmOVyl8hYUm77U7yiy90I+aNm95mJIF1X5Gif+UcTH0JiqimgTt9h3eGNCj0z2QWD9d/QPDHrpaqLCD4cFgYx9MfQJd0Vm98e0jst8+HCRHLDvylU8HOohcH+1AvgjoUS8/XvK6nwA3quDheNV7dSWHjEQ55s0lPSihu/MvUSEfiqS+vF5Ud5SJqyRpI4XwPrmaIxGU7VOU2dLdWrzQKuQr95W7tT1tye27jkCyMag7c2XuxsyRAhB9e+3GMkh0hzoAuYSDoe/64so9PFc=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 14b2db94-206e-4005-0a2e-08d73cdea90c
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2019 08:52:11.0800
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AejeRIinHCnv79huZltpVgxwnkEWHxvE+My92gDQAJBGck4WxpsCOkEUJE7sQdC40LxLsRc64wr3/0py4P2hGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3165
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-19_03:2019-09-18,2019-09-19 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org <linux-scsi-owner@vger.kernel.org>=
 On
> Behalf Of Austin Kim
> Sent: Thursday, September 19, 2019 1:26 PM
> To: jejb@linux.ibm.com; martin.petersen@oracle.com
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; QLogic-Stor=
age-
> Upstream@cavium.com; austindh.kim@gmail.com
> Subject: [PATCH] scsi: qedf: Remove always false 'tmp_prio < 0' statement
>=20
> Since tmp_prio is declared as u8, the following statement is always false=
.
>    tmp_prio < 0
>=20
> So remove 'always false' statement.
>=20
> Signed-off-by: Austin Kim <austindh.kim@gmail.com>
> ---
>  drivers/scsi/qedf/qedf_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.=
c index
> 1659d35..59ca98f 100644
> --- a/drivers/scsi/qedf/qedf_main.c
> +++ b/drivers/scsi/qedf/qedf_main.c
> @@ -596,7 +596,7 @@ static void qedf_dcbx_handler(void *dev, struct
> qed_dcbx_get *get, u32 mib_type)
>  		tmp_prio =3D get->operational.app_prio.fcoe;
>  		if (qedf_default_prio > -1)
>  			qedf->prio =3D qedf_default_prio;
> -		else if (tmp_prio < 0 || tmp_prio > 7) {
> +		else if (tmp_prio > 7) {
>  			QEDF_INFO(&(qedf->dbg_ctx), QEDF_LOG_DISC,
>  			    "FIP/FCoE prio %d out of range, setting to %d.\n",
>  			    tmp_prio, QEDF_DEFAULT_PRIO);
> --
> 2.6.2

Hi Austin,
Thanks for the patch.

Acked-by: Saurav Kashyap <skashyap@marvell.com>

