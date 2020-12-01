Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA610C64E7A
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 09:40:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47953206D8
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 09:40:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Ht2CA3zC";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="fdYVufxw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbgLAJjy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 04:39:54 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:56864 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725955AbgLAJjy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 04:39:54 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B19ZEep011440;
        Tue, 1 Dec 2020 01:39:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=5mcArXIithi/d62NIpmFtWGitxi4GPvvurXuST1q0fk=;
 b=Ht2CA3zCrjso3ZYLFKIEosBQS40bH0x75bmgFUelINfp3AZR8tayJ5aCzQlBXVg0T2Fg
 ZSsnwSHCYtYktJLcErivX4Nft0yeTN9gKEA+HekZKXRH4CxrSUuQpF1a+jix0+o1aZFP
 u0WCI5WzRfbwGETCfOK0ehvldNHJ/Xmh8jNqwt+GlEbnO/L6O5c5L3O8UANfKReiw8JN
 L61vMbiI9RohjI9L+kYBres7UCEOo7VwQvQYaV7NtUr1CC0rfyB5VaOAO8j5dGC3v8wT
 Ca4+hijR++c4C7yxppiAJCJJLjeUd47pfytLV4Jua/3MjgWLhqjdHiYhZLNXneh05QG7 /A== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 353pxsfcwa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 01 Dec 2020 01:39:10 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 1 Dec
 2020 01:39:08 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 1 Dec
 2020 01:39:07 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 1 Dec 2020 01:39:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HS7bnCSEus3CDe5fvZmtjApISyOJKYbH72tpLUpYvloRf/xjKV/wijC/MMuTp11/QnxBX4XZvo8Gd7rUHdsqNw3RdCVDmwsfFM71ue0ebl5MtlWXbd5Nupy6gO4g9XrulwB6MEWku/zUU95OB8OqTsViBCxiv1FE2fPexxKUWmy2E2vTY5y/uXn6quHI/ANuQmgf5GG0YZsuV60y2NXfZckdD5MMvzprFlcdEKm9WHpjVCf1S0ricFjRMUV8QcaaUz+CbVEcF2AtJntQVgKqLUyaXpYWZnrjxpINyQXwO39V4+kIT4rPROzkaQIVlmYca+cB6hbPq/A3l4gznXLAxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5mcArXIithi/d62NIpmFtWGitxi4GPvvurXuST1q0fk=;
 b=QBJO1Pg66uDK9I34HeL5JQDikz0plIarRw6cw/ecSuhxLrmxVhpBuMNA+GTkLuFrW8I1HHVw8jNUzSnuNV7recvI0kXMrEJQFrlCxwQ1Fo3M8z7piHwK25/F5GzQtbvf1JmM9oiGLFBKxtzUftivKtc8Id0BXoH5GcESwFuBxmnrFX3A6/dvs5z4jWeQCxm546UvFoMH1cr0h8GrX8PfCVMvSrBWOlsRbE0eEaBmDK3lQcmBN/BNdqdF/xo4c6AUuYvvYkZSchD2ilVoSCJpBuSE129aLLLzmxB2hcgnX2b05nSdGXsJL0wksYyHub3iHLZHP/WUhoXXDA2NP/wlEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5mcArXIithi/d62NIpmFtWGitxi4GPvvurXuST1q0fk=;
 b=fdYVufxwMOfCbWYjMxOJqRSwsE5koY9ZI1eYrFw66l9E3m0OFAX4SfcD/Jk/umOSajOf05CitPiYFLcQyqZa1voCOisWufKQF4H1vwbEFmBUpvXrl1GPKsImiFFaZBVyNxGFeC1JR3RyJxEGevDbuESurY5Rh0jHwhQt9tPrkOg=
Received: from DM6PR18MB3034.namprd18.prod.outlook.com (2603:10b6:5:18c::32)
 by DM6PR18MB2601.namprd18.prod.outlook.com (2603:10b6:5:187::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Tue, 1 Dec
 2020 09:39:05 +0000
Received: from DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::a087:2131:1284:66e7]) by DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::a087:2131:1284:66e7%7]) with mapi id 15.20.3611.025; Tue, 1 Dec 2020
 09:39:05 +0000
From:   Saurav Kashyap <skashyap@marvell.com>
To:     Daniel Wagner <dwagner@suse.de>,
        Nilesh Javali <njavali@marvell.com>
CC:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: RE: [PATCH 05/15] qla2xxx: Don't check for fw_started while posting
 nvme command
Thread-Topic: [PATCH 05/15] qla2xxx: Don't check for fw_started while posting
 nvme command
Thread-Index: AQHWx8DVESh5J9dIkEigRcrPMKNUrqnh+GGg
Date:   Tue, 1 Dec 2020 09:39:05 +0000
Message-ID: <DM6PR18MB303409D3CEC61DBF206FD257D2F40@DM6PR18MB3034.namprd18.prod.outlook.com>
References: <20201201082730.24158-1-njavali@marvell.com>
 <20201201082730.24158-6-njavali@marvell.com>
 <20201201090151.bdyeliawhpps7wd7@beryllium.lan>
In-Reply-To: <20201201090151.bdyeliawhpps7wd7@beryllium.lan>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [103.103.215.19]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5c8e8ccc-4281-45f8-ea09-08d895dcf1d0
x-ms-traffictypediagnostic: DM6PR18MB2601:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR18MB2601A2E7554033F9A74076B0D2F40@DM6PR18MB2601.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7gLpSQngMkeGOFCXGCYvphcgnsLBGGeKtk1QcTjluCnV4cBj33tMON+jiGEh8rPhMroPC86Ho0aw2e3Ja5EhauUb3GwAdCSW18rU7+gYFNcJe7EJec5o90T9EPK2PtyQMUUDIs1tvT62GwVWLXMK8o7L8cH7XQeD7aW9eFxlmm/+hpQ1mQlnornGckSxaAZYmO9pWS1vjYXcb8uDXVcdyGea489493gXp+qRZGl1Pmf221lpUgWw7IBnBTKLYsRGFk5/BffSCVYQB9+8loUAMAtP4Y78lEgbarqJdKf26ZsXuVhoqV/zVwMe832z1BzSg2LTaSQ1QmsflCAEfW8kyA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3034.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(376002)(396003)(346002)(366004)(55016002)(186003)(71200400001)(8936002)(2906002)(8676002)(6636002)(76116006)(478600001)(9686003)(4326008)(66476007)(64756008)(66556008)(66946007)(107886003)(66446008)(54906003)(52536014)(5660300002)(26005)(7696005)(53546011)(33656002)(83380400001)(6506007)(110136005)(316002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?zVH6/+62Lyw1DPjA4xXreqOr2qAQhNFb7TXqi+239tYOjbwSVQQi6CzCEZwd?=
 =?us-ascii?Q?fXLsp6tG9wvaNEomdgYv0ZCOiYhdE4Pwo2oKXQuOQO0a7Ik1ZMJ4EnK55QIQ?=
 =?us-ascii?Q?idI6fAEcXMZjQqnvOGVa2FVPCt9cowsqsYERz2fhpTSphBxw3rqB7Qyyy8Dk?=
 =?us-ascii?Q?V7jVavbNNz3Fq+xgONf8oeYhKY2A27FfF4yvNDZwfXHvt7ugL4vJOz2MNDjE?=
 =?us-ascii?Q?/cV+ymTPrrR33v/7TxuceMHntHryIu/ouLPHD76/QtYVuQhLwpuguQix2Pho?=
 =?us-ascii?Q?zjVnR3C9uCVt+3O3bhrmAwHqiZG5YG/gxxVK65RtnkXfn09kbsbndA7DPho/?=
 =?us-ascii?Q?EWE0pa5fW+2KB+jcmNYxoPmz5GleNBUAwvWTUlwAmlyzlNhoqZ6wuaEUtz+B?=
 =?us-ascii?Q?xjrlG7DFT0KGFteeIYCQgPwuh3RQYJ5CpknzuYGLQ4HUzWIcSGDtaMkJ55lk?=
 =?us-ascii?Q?SVAdpbsrwrIXnobRIKxEX8bdubwIbnK+HXLYvGg3N+eNElokgV/mqAfSVNkv?=
 =?us-ascii?Q?OwValDj5Im5iVFyaT8S7dfUCIjMzL0CctmNQx9KL53VtoRzcEwNmhIW4H9+D?=
 =?us-ascii?Q?ixZyL3VaYpgbGKpDvxL7ijagiH7hTHYYr4X15cUA0YwnXPkKmVNDm99GybkS?=
 =?us-ascii?Q?ThxIdG/DKFqMQuo+cmnk2Mb57LmZYSnfevwhrKmZWBtmt0wV7zbXlt+kUcMq?=
 =?us-ascii?Q?L5dFufNjQxu/C+sODpFCfGuYaxs2jV6M6XIC3yQ8ulXtyR3Qt0lVLS5rzrr3?=
 =?us-ascii?Q?UTe1WA0eMm5iLg9ysZcCn/sk23vwKQfthPeF47Vyfd9wsYlSycK5Oiw+hp77?=
 =?us-ascii?Q?6fqVKlcfCLTwtnKpvRW88qDYVCw+/Afa5kw0uX8iIcmWVCrDSor/wF0i+AX/?=
 =?us-ascii?Q?v1jPntt2er8L6NqpOAKh8kgoWu4Sl3N2OPitT/Aua57wI2f6ZvUBw/DbQT7B?=
 =?us-ascii?Q?nY0WAxhkgzFIXpZ4EKEY8o27bWUgaCJewtigQIdDZAM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3034.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c8e8ccc-4281-45f8-ea09-08d895dcf1d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2020 09:39:05.4409
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OCtrh2E9mUC8GuuDcceSmeNCvzBEA30dmgfAjtiw1bpYlE1BKNCq9BxVSp6S9AdzZcFnc1wuYUJPGdGK7/5IGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB2601
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-01_01:2020-11-30,2020-12-01 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Daniel,
Comments inline..

> -----Original Message-----
> From: Daniel Wagner <dwagner@suse.de>
> Sent: Tuesday, December 1, 2020 2:32 PM
> To: Nilesh Javali <njavali@marvell.com>
> Cc: martin.petersen@oracle.com; linux-scsi@vger.kernel.org; GR-QLogic-
> Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
> Subject: Re: [PATCH 05/15] qla2xxx: Don't check for fw_started while post=
ing
> nvme command
>=20
> On Tue, Dec 01, 2020 at 12:27:20AM -0800, Nilesh Javali wrote:
> > From: Saurav Kashyap <skashyap@marvell.com>
> >
> > NVMe commands can come only after successful addition of rport and nvme
> > connect, and rport is only registered after FW started bit is set. Remo=
ve the
> > redundant check.
> >
> > Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
> > Signed-off-by: Nilesh Javali <njavali@marvell.com>
> > ---
> >  drivers/scsi/qla2xxx/qla_nvme.c | 12 ++++--------
> >  1 file changed, 4 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/scsi/qla2xxx/qla_nvme.c
> b/drivers/scsi/qla2xxx/qla_nvme.c
> > index b7a1dc24db38..d4159d5a4ffd 100644
> > --- a/drivers/scsi/qla2xxx/qla_nvme.c
> > +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> > @@ -554,19 +554,15 @@ static int qla_nvme_post_cmd(struct
> nvme_fc_local_port *lport,
> >
> >  	fcport =3D qla_rport->fcport;
> >
> > -	if (!qpair || !fcport)
> > -		return -ENODEV;
> > -
> > -	if (!qpair->fw_started || fcport->deleted)
> > +	if (unlikely(!qpair || !fcport || fcport->deleted))
> >  		return -EBUSY;
>=20
> This reverts the fix from patch #1 in this series. What's the reasoning
> that needs to return EBUSY when !qpair || !fcport is true?
<SK> Ideally driver should not hit (!qpair || !fcport) case.  The patch was=
 to remove fw_started flag and consolidate other checks.
We want IO to retry until remote port is deleted and below condition is hit=
.
----------<condition>--------
        if (!(fcport->nvme_flag & NVME_FLAG_REGISTERED))
                return rval;
----------<condition>---------

Thanks,
~Saurav

