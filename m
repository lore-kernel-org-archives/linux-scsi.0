Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33C8AC71156
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 09:58:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C64B7206C0
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 09:58:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="PPsJiuPw";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="SF5wtwKs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729144AbgLAJ6K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 04:58:10 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:4730 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726828AbgLAJ6J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 04:58:09 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B19qQfX008724;
        Tue, 1 Dec 2020 01:57:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=LvF/hy9o4zTmkZzwGuM0XwW3ZA4P7h/YhSdFzkcD2N8=;
 b=PPsJiuPw3E23SuP35lc0AXUXtMYMQvJibluksjRXhAddTczmVNnxK9hw1oon7Y5Jsv1h
 p3F9VqMdVCphOwO3cMaz6GlsdLyTf5nMDkLevR61xP6h7K+y3A7PkLrC8h5bidid4rQb
 SDhr1Mmq+bNPTfaCZ06AbYeObcXL713MCn6oBo4QaUbuDUAOaFb+PX5TDKhVmSxSCL86
 yOAoLf1Btq/ZUgvHlM9IuYYwvTNBhQd3pfHIHRIBxGHeLq5MHwyPXRhPGmoqMrtQ4eD/
 FUqQ4E3g5YrqyuLUXvC+MsKCk+m9FOjeBCOnBElNctTa9BFFRw4l44xaCaYDT8GNCF45 4A== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 355k8s81vv-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 01 Dec 2020 01:57:26 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 1 Dec
 2020 01:57:24 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 1 Dec
 2020 01:57:24 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.177)
 by SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 1 Dec 2020 01:57:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kftSSjT98PtLMILbww3sxaWVxQ6gf7PK5KXLnCi7CxcpXlQ8HAaXcfmneT7DCxipt19vlLFlo6qIbXqvpFBCvEH+6sFa4A5h/M6XCmc1Lq1G/P2pZxMXx+U2b+t56ZAjrwI57GrhEskPiIvADDw5qli17NozGxwhN0LZRM4kqAUuvRL6e4qpag2U9mm41GWnLvfWz0AY6fotXHz2bcmVAh9PNy/cjY8y6KGdPZ8isrWbo2XK9DZtYOuP038GFLOVhSyLrQNEEUnPT1qJt14kwK6f0Hzlswf05Pg5oE0f1x50QXHt7MqDke4QoI34+G7849QkJJ+Tpf6CELW0eZ5JMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LvF/hy9o4zTmkZzwGuM0XwW3ZA4P7h/YhSdFzkcD2N8=;
 b=C/x0S/8ha0Uv7YVdcNrtEERyAJ05Y7XkTtBPyUmO+DHc/M58JxByaBf6Chb1VS+01ifWa316O+KyyJb2/q7tz8KY6oAagDpqdnAz3qiFfuzpiV8i7jfyGb2Cp4SDduwpOBwpv5gP8PWpA7RgExP04aH9VnIKDyRWH3vStKzqUwfjVj4J2JTdUs0uzFHSPfH5oYJ0/+2L9dEYZtvQOLNTUojzuOEZ5ELReAXvQXWMNLWJ0+f5hgoaOEMWEKbkg5x1Z9ZSHxxgT+s1yqf+W5bduB012+KFSkrmMP9cjSNw8IFV8rdsPjLL2OeeHsXh+35wV5H0EpUxrk+A4ChvnPeEbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LvF/hy9o4zTmkZzwGuM0XwW3ZA4P7h/YhSdFzkcD2N8=;
 b=SF5wtwKsDYYNZCVu76hwcBqzlEZoaJmZHNzRWfaqLCVKthHhQ5rWl8DqT8Hy+ilDE/hMSY4AB3KwY0QFrkWF8rsbfu68Lzw791bng5IJiKbCTZqLTyN1TKx2RonqM+ilp3wkJ6tTJ9VYzItYqMMAn3a9n8y6ngYlxkYZuAPzQlY=
Received: from DM6PR18MB3034.namprd18.prod.outlook.com (2603:10b6:5:18c::32)
 by DM5PR18MB1209.namprd18.prod.outlook.com (2603:10b6:3:bb::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.24; Tue, 1 Dec
 2020 09:57:22 +0000
Received: from DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::a087:2131:1284:66e7]) by DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::a087:2131:1284:66e7%7]) with mapi id 15.20.3611.025; Tue, 1 Dec 2020
 09:57:22 +0000
From:   Saurav Kashyap <skashyap@marvell.com>
To:     Daniel Wagner <dwagner@suse.de>
CC:     Nilesh Javali <njavali@marvell.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: RE: [EXT] Re: [PATCH 05/15] qla2xxx: Don't check for fw_started while
 posting nvme command
Thread-Topic: [EXT] Re: [PATCH 05/15] qla2xxx: Don't check for fw_started
 while posting nvme command
Thread-Index: AQHWx8DVESh5J9dIkEigRcrPMKNUrqnh+GGggAAHz4CAAADjEA==
Date:   Tue, 1 Dec 2020 09:57:22 +0000
Message-ID: <DM6PR18MB3034A49F5629A1A5C5C38045D2F40@DM6PR18MB3034.namprd18.prod.outlook.com>
References: <20201201082730.24158-1-njavali@marvell.com>
 <20201201082730.24158-6-njavali@marvell.com>
 <20201201090151.bdyeliawhpps7wd7@beryllium.lan>
 <DM6PR18MB303409D3CEC61DBF206FD257D2F40@DM6PR18MB3034.namprd18.prod.outlook.com>
 <20201201095341.lrckuwzmy22iwg2h@beryllium.lan>
In-Reply-To: <20201201095341.lrckuwzmy22iwg2h@beryllium.lan>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [103.103.215.19]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1dafd824-84af-4c00-a4d1-08d895df7fea
x-ms-traffictypediagnostic: DM5PR18MB1209:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB12092EDCF9D0074C08F3DFC8D2F40@DM5PR18MB1209.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8lBxsZipp/SYTYG47KmHi2itSzxai3+EcKElpaF4MvPos7r49LbM4D339lUZgBr7ObfBz5ZGZ4lrV+xfpABut/xtcvEi8Jh/0uyhGmQDLW5gPohLVquwC34Ps0ZIzWfyODTsVoNtjrjk6S0hAVn2+QRw2ibIJi1Sj8wOMDYTvWRDFdHxdIac1bnnj2oTHgCKK7Zmy5VZyAfA008OYoTLqmfjEIR2bx6nlwCD/5ZuJkhhwyOvCe1hwuXAhqpwouS2eKE/Um/HRJUvk1wSvT/LjTLCO7zHMSJUTScdEdUl4ny34CzZcwMr3jWrUuOltArJ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3034.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(366004)(376002)(136003)(396003)(7696005)(478600001)(26005)(53546011)(66446008)(66946007)(66476007)(6506007)(76116006)(66556008)(64756008)(107886003)(186003)(83380400001)(6916009)(55016002)(5660300002)(71200400001)(9686003)(33656002)(8936002)(8676002)(2906002)(52536014)(86362001)(54906003)(4326008)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?D8KFt19vtJV791klap2Q2aqnyeSiIK4jef4TLUJigSVsDiimpHTOi9YJNtyn?=
 =?us-ascii?Q?GJ/RR9bI8ZmVRulC9pmJYjX+G3zpsUWIXNNAEZDgCwHs6EUWxmYZelWhsvod?=
 =?us-ascii?Q?5dFd2HO7Osb3AOWq2ZwSrdDfMEr+B/pvOW4/bawLZcF7xYIJyBiEe/DvGI6r?=
 =?us-ascii?Q?9bD6ZlzudQunbmH7LJMUobNYgjtLlSHLdQnRiL7TYLM6E9eQvC4QXfLGcfsu?=
 =?us-ascii?Q?XuZtURscLtO2EKYtdEkyxXi/5cAw7YueXkpOjDoKx+wA02s7wLLiX2tgAPtK?=
 =?us-ascii?Q?Es9f9Y8g+b2KgF5PJZYWwAyPHSOy5yGjaenSCf311DuaUSTCQbmSp+KQ1z+a?=
 =?us-ascii?Q?gJg6krq6j2jNyxUZytIh9Scz4yOEDJqT72MBQgAL4bM7MKJa4Xpj/BSzJ1Qr?=
 =?us-ascii?Q?DbKeV3RSfmOyOLF4IsKZUyf0/8bx8y4TUKNPo/zMLwPm4ek+oqjdmnQAIrpv?=
 =?us-ascii?Q?LxnF3f6Qh3qjINccptk0Gh79IiZ0OAu1pZYQt55gdrkm+QbS+Q+JweqWOWnb?=
 =?us-ascii?Q?XwYH15IDW7My4EJmMgVjAQUUjK6ISsbupi2X0+5NDX2pSg9qbBMTgBBOs8E7?=
 =?us-ascii?Q?+a1ty1jHvdr0JmywNLOpvAz4T7L4JdFDjQVBjtZQR1KpEsGsLNdZIY5camAT?=
 =?us-ascii?Q?Kfg+j+bcSIvvMxB7BrJs60ARbLocQRfBhqFHHyRAussCk7cEXpiwKmbxKEnS?=
 =?us-ascii?Q?jy7F/LXoQVTag4cmv0oO2WGLc//UEd2/+Jp8oIBV/Oueg/M/VA7zG5+W8k3Q?=
 =?us-ascii?Q?OEoL+V1SHYCbFV5FWSw0Frb/GfmaUCPTockUrhQPY831aTsCk8uR7m8hlbqS?=
 =?us-ascii?Q?hj8u9tw3YOiUcKVZQUU4W6XdoXTHnsiYhHcqHorZWdNamZZzt6BOTCj8j87E?=
 =?us-ascii?Q?gLqJib7v6HPFxkd6L3Vgl/70qgGOPQId/5KUlFXv4JckzavLbElGbr35mbFb?=
 =?us-ascii?Q?nl0g5sO92Yq8+OcLEQi0jLL7cOESqZsVEh7Locamdaw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3034.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dafd824-84af-4c00-a4d1-08d895df7fea
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2020 09:57:22.8495
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tuzovK5uKgOBG9fYWv+W5j/XrKvAqFNZmAZ7gCVD3ZTLlue2a+jTff4L04+Hk7if9cBNKKwgqZ8fgdxRVAcpMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB1209
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-01_04:2020-11-30,2020-12-01 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Daniel,

> -----Original Message-----
> From: Daniel Wagner <dwagner@suse.de>
> Sent: Tuesday, December 1, 2020 3:24 PM
> To: Saurav Kashyap <skashyap@marvell.com>
> Cc: Nilesh Javali <njavali@marvell.com>; martin.petersen@oracle.com; linu=
x-
> scsi@vger.kernel.org; GR-QLogic-Storage-Upstream <GR-QLogic-Storage-
> Upstream@marvell.com>
> Subject: [EXT] Re: [PATCH 05/15] qla2xxx: Don't check for fw_started whil=
e
> posting nvme command
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> Hi Saurav
>=20
> On Tue, Dec 01, 2020 at 09:39:05AM +0000, Saurav Kashyap wrote:
> > > > --- a/drivers/scsi/qla2xxx/qla_nvme.c
> > > > +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> > > > @@ -554,19 +554,15 @@ static int qla_nvme_post_cmd(struct
> > > nvme_fc_local_port *lport,
> > > >
> > > >  	fcport =3D qla_rport->fcport;
> > > >
> > > > -	if (!qpair || !fcport)
> > > > -		return -ENODEV;
> > > > -
> > > > -	if (!qpair->fw_started || fcport->deleted)
> > > > +	if (unlikely(!qpair || !fcport || fcport->deleted))
> > > >  		return -EBUSY;
> > >
> > > This reverts the fix from patch #1 in this series. What's the reasoni=
ng
> > > that needs to return EBUSY when !qpair || !fcport is true?
> >
> > Ideally driver should not hit (!qpair || !fcport) case.  The patch was
> > to remove fw_started flag and consolidate other checks.
>=20
> Looking again on the patch I think I got confused.
>=20
> > We want IO to retry until remote port is deleted and below condition is=
 hit.
>=20
> The result of this patch is that in EBUSY will be returned in all the
> cases, not just for the case of fcport->deleted. So all is good from my
> point of view. Thanks for explaining.
>=20
> Sorry for the noise.

No problem, most welcome.

Thanks,
~Saurav
>=20
> Thanks,
> Daniel
