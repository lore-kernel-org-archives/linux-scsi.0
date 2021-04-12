Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FEE6C433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 10:28:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B7BC6109E
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 10:28:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238896AbhDLK2x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Apr 2021 06:28:53 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:11198 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S238293AbhDLK2w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Apr 2021 06:28:52 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13CAQVrx011811;
        Mon, 12 Apr 2021 03:28:25 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-0016f401.pphosted.com with ESMTP id 37vcu9959y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 03:28:25 -0700
Received: from m0045849.ppops.net (m0045849.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13CASO3a016100;
        Mon, 12 Apr 2021 03:28:24 -0700
Received: from nam04-bn3-obe.outbound.protection.outlook.com (mail-bn3nam04lp2058.outbound.protection.outlook.com [104.47.46.58])
        by mx0a-0016f401.pphosted.com with ESMTP id 37vcu9959w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 03:28:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SpNGOiT8ESOifsn1TZzwQGXDYyC3gbpGzcSPb4Qf1xVftEv2Wni3jM2PmmqK/HNLo7eXEAuMe8LCbThr2GkodYyLIJtaJtL0cVPo0g9gpTDTy4QtMCdcfIrOZhhWiSzBluz/CLXlhF/+20TQ7FRceoUNDVy4Pub+4d50KqRwP1/0JyFdhJSCxk4rjRBMsWu1EUL+Y76tyMbil7obYNCREs4bsltnxT9UIFzNAcKVypwqrhkh00oKeQJw9RDwFOvNhmsBu/23W7VV8eH/CkaWoBNf99aWIrCiAXJEhkbbEFI4m6jmkCz+6J4uv5/Jr0ynd38MftEvpKxjBQQ4GlADQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iKWq/87f5wntQS6RZtb/fQhlYW55woITm2DA7ycFCXg=;
 b=LoOr/m4cW5pk8ju/HTmdfoHSe07awvJojSrv1MZdVcSyTWtG1suszZd+LXkddXitq138Zvcs2k4Eu5AVXtwBIyDDynCc1FejxViJ/23+2PXE46U0yvSEJ37fYWmk0Yd//0444oqrxTu/AuSOqPPSTQZ09m8KQxA4evfTXFYEknzssPixZFUnrZ0cH06P7fc2KW86SO1jz/5wxrDY9Sj9Mo2UDZu0PQr68ULBQjV1cp2z6ZyT5p0j6djBP2ExYnCSGBARMPAATY8C1O6+ob28F4+K2H+PHFHBIyhy1YZt5nLFU69PFB2odmSYMT8LUcPtjK9ODVT/o6ttjkwxnCsQ5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iKWq/87f5wntQS6RZtb/fQhlYW55woITm2DA7ycFCXg=;
 b=iYEeN8Z87lipguHtCuPWEI1ntQ+guzuNWcRBH2epoqOQfo/K9WDQT+mnx12g1okXeR72X38zLijwEIpDEAN9uG7HUUTU+e/O+RgV9ebFoinrcAgfznOVNNJVENh81cwT4PYGD3RntjcTya8acgsHM6Ry5GL0Kjr1uTIE2/8dLno=
Received: from BYAPR18MB2998.namprd18.prod.outlook.com (2603:10b6:a03:136::14)
 by BY5PR18MB3219.namprd18.prod.outlook.com (2603:10b6:a03:1a9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Mon, 12 Apr
 2021 10:28:22 +0000
Received: from BYAPR18MB2998.namprd18.prod.outlook.com
 ([fe80::8d7f:5a91:7edb:3621]) by BYAPR18MB2998.namprd18.prod.outlook.com
 ([fe80::8d7f:5a91:7edb:3621%4]) with mapi id 15.20.3999.037; Mon, 12 Apr 2021
 10:28:22 +0000
From:   Manish Rangankar <mrangankar@marvell.com>
To:     Mike Christie <michael.christie@oracle.com>,
        "lduncan@suse.com" <lduncan@suse.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Santosh Vernekar <svernekar@marvell.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
Subject: RE: [EXT] [PATCH 07/13] scsi: qedi: use GFP_NOIO for tmf allocation
Thread-Topic: [EXT] [PATCH 07/13] scsi: qedi: use GFP_NOIO for tmf allocation
Thread-Index: AQHXLjkBU7acPmnx+Eqq5Vr7N3j6dKqwsJZQ
Date:   Mon, 12 Apr 2021 10:28:22 +0000
Message-ID: <BYAPR18MB2998BA6AC28B41044DF0CD64D8709@BYAPR18MB2998.namprd18.prod.outlook.com>
References: <20210410184016.21603-1-michael.christie@oracle.com>
 <20210410184016.21603-8-michael.christie@oracle.com>
In-Reply-To: <20210410184016.21603-8-michael.christie@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [34.98.205.117]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fc365cea-543d-41d7-3993-08d8fd9db312
x-ms-traffictypediagnostic: BY5PR18MB3219:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR18MB321988CD7AB30786D77EFEC1D8709@BY5PR18MB3219.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:901;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: J6HEmNHVYEhoWLgTYe0a1U8F4P3M7e+1INIvfQJZDghql9cUA8QuHqWAQ/WkJXmUzMJJ5AhowPIB0MT0VASONnODOUf8zVjE+eifprQdZ1KbSPyhBmy9Cr1tnfPvTDS2USp1bHir68BeY8fLzoRmPxPucSCo6UWIfakiX/dvn5gMwO1BE0GpbSSlzULS+llIFif86D0/MVOCIxP9OEWBLhYCjhPNOHglu9GQXt2deUsSOpcLho6F/44MKXANLnD7UCMJ0s0HdeUUAqfSGyoTPsNQLHYb1Zfe7jQuPiJuyyrnjW0rZiSn5KU94G9rhccCHVzi2W+w1+oHWiq5OBFPOEfkNfz9EmPLEEiQhFmwZ++5CDC+lgRB+VwGVwGJzHaY84fv60TXo/MoLkk2TbrRJL3+4q/tHbit26x4sS0v7IBoELEEIOxdNbAkFfFiS0SfBR3wr8uRjPosHY+HNMv7zDUp8Cxz0XqNbXkZKAn2O4WnOGpRSKSp6zsjRlTZR8dS8x8oO4N8ANAcSPlWNOETeWk7uZpEfFeHQSEopx3Y5Rvzi7EqZ+0MeXlJh78dZNV9U+Hk/t0Uc5DFLoxP/Ahh6BCs5R6f1ox3FsDcWaEY3Rg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2998.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(39860400002)(376002)(366004)(396003)(76116006)(66476007)(66946007)(64756008)(66446008)(316002)(186003)(2906002)(7696005)(38100700002)(26005)(52536014)(110136005)(8676002)(53546011)(6506007)(8936002)(66556008)(33656002)(5660300002)(9686003)(478600001)(86362001)(71200400001)(83380400001)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?oaHwP+Z0zWOQGgP3rqfVsPtVIlNxGvJNvlE9TRYU2WJLJruB4x4x+u0Asly2?=
 =?us-ascii?Q?LLb9P8TIpwodGCK0T096bCF2AUN52fW+xEJR51Sfx/x1Vq4ALf7mTEAwWOqr?=
 =?us-ascii?Q?Nrj5/2o0rGekZ273pFJsgXhYGiw69Axb3IRSSiHHROe+AAoxArnWXmlY9Czs?=
 =?us-ascii?Q?0iUaVXtO+b7OyEpxTAFicZKvFW6i7CPgw9hP0ilmxlOQkxIC/9GU+sGV5qbQ?=
 =?us-ascii?Q?QAob0P+9DeaVPeh56f56v2U5N4PaZEqyM6KTXF0AOo+/bZawd99xraRozLC7?=
 =?us-ascii?Q?d0eIF315tt5NjdhtlVXRRdvdoHxLGc9XmMMUERJycTEH7P/HQQDNCfvAATaj?=
 =?us-ascii?Q?aAO8h2YnJ8f5INLGdU6D2ACjakgRGUVBfBOQTtQjDcKto8wQTMlF/ApApLS7?=
 =?us-ascii?Q?XNGlsO2cljJwLChFoBj+IYqqX+frctL/ztSND/4/ccqqD6TB3BMf245iz01s?=
 =?us-ascii?Q?+5sm4irVVTaagWGR4YE+EBkXK4QCCr3wQgGTPgc2NSkhtzPTRP0h9GhTwFQc?=
 =?us-ascii?Q?cqcPaM8lsTxZ2+MHvtrVV6PkvM7ZrfAI0Nsf0wvv8fWxURbhDelJ6txgNAPJ?=
 =?us-ascii?Q?JCzgWDrgL7h+l44svvrdBquUuh+B44JKV2ib0RUjxPAWCGRuysG6F5Mr3DqD?=
 =?us-ascii?Q?LqD1eDD1PRIyOa9thlbEdt7Of6r04ehs4Jfl/z8EAEKOyDoasGrjb775Vw0p?=
 =?us-ascii?Q?XDig5Qs1n7lwNp5UA56YqK1LczlowIMyA+4EhLctMzkm1crvOM98KrXHCnW1?=
 =?us-ascii?Q?jKueXMDDhj7hNMsgQCn/mr4ufYkQnBDnxdnRNrS+lNMY9XZ3CpT7yQ/Vu4s2?=
 =?us-ascii?Q?03xgfLErGlSRCbzTuviv7ond6VDEN4uSGs9PIvZppYPD/4hEgG0MJ6LeaC2f?=
 =?us-ascii?Q?HCOZG4B0dTz9pjiU3/SriFS9WnS/ZP+0PgGJCq6EUqh8qOH/K/cnBHGyNAad?=
 =?us-ascii?Q?3xb1O/NBbkM/+VG5iq2BhxlgyydPFJupSGZ0mez3YfKaTNorBWiL8SvhSNgq?=
 =?us-ascii?Q?B25RpBywCORo+UKlNrbG0xI6JOoktCRrbMunV8KvGC/hW3jV7HUYWzhv0gsK?=
 =?us-ascii?Q?nqTAnlxVUwfi3wXNOFbjYMHwDrF6XRpawcPuTM9UjVRUtlX2JWpmAJJfCzCF?=
 =?us-ascii?Q?Rx/CX9wHKQ6PZ/1vX08WYroDj+gXqIAe04N0NmdiXWwtgbTMrDu6SuJ2fknD?=
 =?us-ascii?Q?FJx+JtnjJKkfpUsdyzn1ctPSQmGz1ebBznK3DywtFstUZOQSU6SLZIk/brCJ?=
 =?us-ascii?Q?ZQJu2x/0YaTRZ8Orsu8iLFdOCu9rz5ymKTQKa183xH0uI3bOgo/VYZTKqvpE?=
 =?us-ascii?Q?C+SsbupEQc/fOeyCKMDxRaBV?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2998.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc365cea-543d-41d7-3993-08d8fd9db312
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2021 10:28:22.7195
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 38eO9w6hNxXdOYHQiDvK6s5iGO7ot3E3PE63PZCyqfjeZ9B4f7q0JGMNUW043XpXqkJaapkjeJcxF19rZ2SjJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR18MB3219
X-Proofpoint-GUID: GRd8Ci9_pFpoP4XrLYAZLnkuomZdyMKL
X-Proofpoint-ORIG-GUID: uCL8JCmlJr3f9GbsBs3DVNR0OqO8imG6
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-12_09:2021-04-12,2021-04-12 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Mike Christie <michael.christie@oracle.com>
> Sent: Sunday, April 11, 2021 12:10 AM
> To: lduncan@suse.com; martin.petersen@oracle.com; Manish Rangankar
> <mrangankar@marvell.com>; Santosh Vernekar <svernekar@marvell.com>;
> linux-scsi@vger.kernel.org; jejb@linux.ibm.com
> Cc: Mike Christie <michael.christie@oracle.com>
> Subject: [EXT] [PATCH 07/13] scsi: qedi: use GFP_NOIO for tmf allocation
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> We run from a workqueue with no locks held so use GFP_NOIO.
>=20
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/qedi/qedi_fw.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c in=
dex
> 542255c94d96..84402e827d42 100644
> --- a/drivers/scsi/qedi/qedi_fw.c
> +++ b/drivers/scsi/qedi/qedi_fw.c
> @@ -1396,7 +1396,7 @@ static void qedi_abort_work(struct work_struct
> *work)
>  		goto put_task;
>  	}
>=20
> -	list_work =3D kzalloc(sizeof(*list_work), GFP_ATOMIC);
> +	list_work =3D kzalloc(sizeof(*list_work), GFP_NOIO);
>  	if (!list_work) {
>  		QEDI_ERR(&qedi->dbg_ctx, "Memory allocation failed\n");
>  		goto put_task;
> --
> 2.25.1

Thanks,
Reviewed-by: Manish Rangankar <mrangankar@marvell.com>

