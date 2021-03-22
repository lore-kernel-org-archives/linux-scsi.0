Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 958F3C433C1
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 05:06:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 608BB61919
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 05:06:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbhCVFF3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 01:05:29 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:47530 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229548AbhCVFFE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Mar 2021 01:05:04 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12M51L9p018898;
        Sun, 21 Mar 2021 22:04:54 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-0016f401.pphosted.com with ESMTP id 37dedrby5d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 21 Mar 2021 22:04:53 -0700
Received: from m0045849.ppops.net (m0045849.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12M54rL5024606;
        Sun, 21 Mar 2021 22:04:53 -0700
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by mx0a-0016f401.pphosted.com with ESMTP id 37dedrby59-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 21 Mar 2021 22:04:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jXF9tY44EfN3jDSPCMIHI7sgDcaE0XjI+p36TXGVYeAZJz2XxSVvXsmL8r57sLIQdHhSTEj8bRLeCSey41oSgRhbzRMvj4q29KgM01gPrzpSmsxKjsukWk8I5Zz+JiJcGH+vjzkg//neQnFz4Bn8gxTySd9+fGU7Q87Be7qpZ6BgCeIa3GvXWA5Uh55eVSXjcQaQTEktpiw41fU9aOP2u0Uv0ML+nlPr9tee8ATVR3z5wtGpXdS4JsjOb1A7blceOuh8o2VC5A91BFmtSqMFt53KC4EUA+35R26vaIqqKOZ6mwNwKEzHdz2NKrtg9DNIOhM8L2ErESgiSq5NhuS8Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PKp2q+tMePxuGAV3siPjRjvg2iZ3J6QT9Gng3Y4EJsM=;
 b=ocGfLi7yu5y/5TUaoxSvgMzjBjwXLXRhWiMBCnBQvrbBWHHgciu/+8QgrMuvnvZsz27KcyfF0br1U/U+b766UIbz8vGL2uacuTsHyDlb4J9U4vjy2eCbH0e1ArLWWKwOpTYG6dpgX/MctDmMe6yisErPfkgZqNOUlt+EOAmOq8Gzx3i3wwgb2hq8INr0i7kiL9h2sVkHZJXDdN+z2UgmEelyLSh5+QA/+snlcNgxsVWY3RnkVSa60/nrIafjGF2Y2Ny/0xwG8AaW022pYj5H9ToJ+jXMEPEUZY4XN2QYqDOkG4KCw8/KaZdKcRxzaKxFeJ2M1PcwdlE69xO2YAkpVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PKp2q+tMePxuGAV3siPjRjvg2iZ3J6QT9Gng3Y4EJsM=;
 b=A7VYtUjtjDfbk/tDu31mjpiqAWpMknjemFzL3PCG1M34jTiVBY53+z2mtd3jUMmF6FCxnV2fRgdR1w+gW9xddEE8VW9VRwBviyHh8j+P3/dYTpIt4V4CxzBOHGRg34z7lVnq8iH5vkSxJYP79ncgQESnyUVyYHiUtEHnnaGH2mg=
Received: from DM6PR18MB3034.namprd18.prod.outlook.com (2603:10b6:5:18c::32)
 by DM5PR18MB1164.namprd18.prod.outlook.com (2603:10b6:3:31::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Mon, 22 Mar
 2021 05:04:51 +0000
Received: from DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::4db6:bc53:ff3b:bd85]) by DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::4db6:bc53:ff3b:bd85%7]) with mapi id 15.20.3955.027; Mon, 22 Mar 2021
 05:04:51 +0000
From:   Saurav Kashyap <skashyap@marvell.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Mike Christie <michael.christie@oracle.com>,
        Daniel Wagner <dwagner@suse.de>, Lee Duncan <lduncan@suse.com>
Subject: RE: [EXT] [PATCH v3 7/7] qla2xxx: Check kzalloc() return value
Thread-Topic: [EXT] [PATCH v3 7/7] qla2xxx: Check kzalloc() return value
Thread-Index: AQHXHeAp0FGpcsdzlESs7d9GzLiaMaqPdcqA
Date:   Mon, 22 Mar 2021 05:04:51 +0000
Message-ID: <DM6PR18MB3034B07300BC22F4154E6DEAD2659@DM6PR18MB3034.namprd18.prod.outlook.com>
References: <20210320232359.941-1-bvanassche@acm.org>
 <20210320232359.941-8-bvanassche@acm.org>
In-Reply-To: <20210320232359.941-8-bvanassche@acm.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [122.161.47.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3fbbcfdd-a092-4b8e-c6b1-08d8ecf0064d
x-ms-traffictypediagnostic: DM5PR18MB1164:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB1164DE5DD57C5FFB7EDB63C9D2659@DM5PR18MB1164.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HjBUUYFqwdlK/F8HQG7VTtTe2lYfoJdrCW8KkhuCvbxozLkLA6/T7KPS3xvHbX+3yBQ9A+FE27l40aZjyIAvxdlTpFE0E7BIpHehpK+g8xC3q6FTPMZc+2CaZ04jVjyA6AvQfQ7qdgoJOSvACB4GXqDrG/aSwdffZoaYiBn27sUWVvoxB4RLn1TQPkSc22DUac2mLSB0+/qa4yX6ekijmnnsN76O/cYdQtrNbrKFUGxaKTHAOACwp9JoD/i62CEYpwYTLqIs7UN6lyjTnCVOMuENMh2083Wg/O5eo/nUaY91AfCjKdnxiYs349AlPmPHK4pG4UQVa79wjDgAjZP8XZ7iDE81OTPLHWdFmgdiW4glZSBO2GPg0/NVKFb8Z94Rha0BVaT3hesPEPvo3xELcyl9uVhrZLOaMQk9e0e7sKuIks2jdtgDiBe2u4pQTi6NoL7dwcJnuImSxS+dJfdv2PuO9keDgMP6qN3bf0zkfuBTrYFxPq9VCojgPtStAYzgigjVjAabJV2xM6nqIqbVVYB0YBhQyop/dpmcXZ6DMF03/0GvQQQwIAOx4K3tWwctPczO/fBDunZ9yYslnGiZhw9iheCX97Q3trh9p66nK32aP4xy5ToD4xEEwf95quSINv0IluCmOqoHQx4oa0UCuU7afS02pw3c67mNsNbi1/I=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3034.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(366004)(39860400002)(346002)(2906002)(66556008)(316002)(64756008)(76116006)(110136005)(66476007)(66446008)(5660300002)(54906003)(478600001)(66946007)(71200400001)(38100700001)(55236004)(7696005)(26005)(186003)(8676002)(4326008)(52536014)(9686003)(33656002)(83380400001)(55016002)(8936002)(86362001)(53546011)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?2UJHYFF41RvH/zIhCSIKxt0w3PtmOvEU/jWwgCoHrkOHveWpcHQIOZkuAu6l?=
 =?us-ascii?Q?bKK7M0IMrVyVILPX8a85q5Apucw/zQKrn0XIFw4cHVO6YaH2Z+DZBdQF6snJ?=
 =?us-ascii?Q?EFFcWf8qwIc46G/pAFZZ59wCbnfq9MkB5nyLqRhrPbR+UlT7h/Q6NvmG1n3b?=
 =?us-ascii?Q?NPB2za0BkhuVXl4hD/1gIyfoiqTDuSBJaLVWOWsFJBHgb1mkBzOoRGEnnSsX?=
 =?us-ascii?Q?iuHXyBONSPAOwSKLC7lm6l3O3l319FeQwEKkqxQuAt7WuTZYckDpcRhi2gBT?=
 =?us-ascii?Q?NUGg2EaFjKS/3YVPdneX5GU8FZTNs2KtRpyKqGrIse8Jt/RBLiK/aoVWqNJF?=
 =?us-ascii?Q?Pfw8JeL9gbC6i1ha8HiIL4T1hNmlM/e1xkS6v8cFR9hotlyya/EGAiTL7zOG?=
 =?us-ascii?Q?EKCUPvQRYJl0bufEtz7+6PGzRr5/9Wj5LE8Q2AZ5ikVxW89T5+Mr3sf+7o2z?=
 =?us-ascii?Q?QQAQgC+UilNbUjr6zYtDMeXR1jbHAJcD5/25EOJ5357D6BHiKxZoVAjPWfDs?=
 =?us-ascii?Q?ll5k5vq3MAAJuAJjLFF3H2526lhZ75hoquFkHlK7iKAPS03JhoNaHbbxGYiS?=
 =?us-ascii?Q?3nDzXPa5Vr6lByCl+DpM99pSVN+S3ANtx59sSCQxsqSSLD3mXz3JNcDhLSop?=
 =?us-ascii?Q?q+v+4Tjc87tEVfN3r8iusY93su0fkZ5187bh8cOhVw/sa0XOmLP2c1htbt+G?=
 =?us-ascii?Q?fs/eFOInhPVBPJduSAkNP9mHJjBPwr5Vvb2rvKSyEoN0qfhoKfmCiajdkPKj?=
 =?us-ascii?Q?ml4KdVJl3G3Y42N/TT4YJdgfCBJ3FOwymqBcPX/6lSpZTRsEccEDaMMVrcFr?=
 =?us-ascii?Q?WfU93Wr8DDMnM9RCN7rb5zQLpS3QM6Yd3zn6n9Ly7fsyoPOPSPon6dKZDFQ/?=
 =?us-ascii?Q?4ZmJj6ppU7OcQObzMCfQKnV648MTVVE02Rzfsd1djdUFRdvAJ4NNcj0bYZF1?=
 =?us-ascii?Q?S3Y0Ptjw+mK/q1NFP6kpaShSYKrDDA8ZCWJNfG2RS3uvlPDty0IbijDMgJEH?=
 =?us-ascii?Q?xQr9dH+4xSNcUYw+j144CV5myoraz86ME3dD2K5Tsd8nJwWbulHKCDN/EWUD?=
 =?us-ascii?Q?WtBUWDMq/5ixIUV51ZBiDQYE0NcFGaOXH3GM7gIojIRy54QYL0JaNTtieDHJ?=
 =?us-ascii?Q?InMT8Q+OmEBPFLh6pfj74mNmwCzPBKtmHDUG3ntFh7JL9EYPNWA2598fI/Q6?=
 =?us-ascii?Q?wRsnzqURGqDQF6vw8LrSPf50+StFmbEIUkV0l/KC7D8kZex/Q8uDoW75EFDT?=
 =?us-ascii?Q?HnWOGydxW+RaAtqYzScZ25pYai+eXoCW0zYfWqwjKUWeFRSMo074/eIWtpXz?=
 =?us-ascii?Q?/hPIKZBjqS0hXaZM8jO5Wwn/?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3034.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fbbcfdd-a092-4b8e-c6b1-08d8ecf0064d
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2021 05:04:51.3762
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jUS5+yUWk9fdQq2aWBOupiZPRh3zS75KLlZboTgylE2rfTyebJRKBT+n0PbiKqp3uKrKlq3XCmWZhyQegYmKHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB1164
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-22_01:2021-03-22,2021-03-22 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

> -----Original Message-----
> From: Bart Van Assche <bvanassche@acm.org>
> Sent: Sunday, March 21, 2021 4:54 AM
> To: Martin K . Petersen <martin.petersen@oracle.com>; James E . J .
> Bottomley <jejb@linux.vnet.ibm.com>
> Cc: linux-scsi@vger.kernel.org; Bart Van Assche <bvanassche@acm.org>;
> Himanshu Madhani <himanshu.madhani@oracle.com>; Saurav Kashyap
> <skashyap@marvell.com>; Nilesh Javali <njavali@marvell.com>; Quinn Tran
> <qutran@marvell.com>; Mike Christie <michael.christie@oracle.com>;
> Daniel Wagner <dwagner@suse.de>; Lee Duncan <lduncan@suse.com>
> Subject: [EXT] [PATCH v3 7/7] qla2xxx: Check kzalloc() return value
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> Instead of crashing if kzalloc() fails, make qla2x00_get_host_stats()
> return -ENOMEM.
>=20
> Fixes: dbf1f53cfd23 ("scsi: qla2xxx: Implementation to get and manage hos=
t,
> target stats and initiator port")
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Cc: Saurav Kashyap <skashyap@marvell.com>
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Mike Christie <michael.christie@oracle.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: Lee Duncan <lduncan@suse.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/qla2xxx/qla_bsg.c | 4 ++++
>  1 file changed, 4 insertions(+)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bs=
g.c
> index bee8cf9f8123..bc84b2f389f8 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -2583,6 +2583,10 @@ qla2x00_get_host_stats(struct bsg_job *bsg_job)
>  	}
>=20
>  	data =3D kzalloc(response_len, GFP_KERNEL);
> +	if (!data) {
> +		kfree(req_data);
> +		return -ENOMEM;
> +	}
>=20
>  	ret =3D qla2xxx_get_ini_stats(fc_bsg_to_shost(bsg_job), req_data-
> >stat_type,
>  				    data, response_len);

Thanks for the patch.
Acked-by: Saurav Kashyap <skashyap@marvell.com>

