Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF60EC64E90
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 16:06:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69A1E206E3
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 16:06:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="XJC5kYYb";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="PPsxXg1Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392010AbgLAQGV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 11:06:21 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:35836 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2392002AbgLAQGU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 11:06:20 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B1G0xDc019675
        for <linux-scsi@vger.kernel.org>; Tue, 1 Dec 2020 08:05:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=Zx3rj8PMAjn+1C2jzG7z47OruA3jZ6SKz+HLgG0gQw8=;
 b=XJC5kYYbmcQ8IJp+yn8vrfv5y+zzVSW9OYSfrY7RSWYSHZJLub0JauVypsV4I1WccMfY
 YXITq2HGOum2diY6jTCEWR9ZUkxPObeGXxHtumO+lmTfBEOTVNc4UI+9hy88dHGmE6gY
 2lrE2d9KGRqi3GV4ww2ZgrNlYj5CL1ScwPAi9Fp2+p8BxrB/hL4IUUkPZA66GnpDQRn9
 pnsBLo1mXBynQh4yAMWTZY2J+zKtmqm89ARAE9ALeU2LxIZGn7TZbdtPJsr0pVhtzzS/
 M35uwQBvFkCzGSe30Y873ZxorsFhJKb7uJkaDRI+IG7aUkPWcRCmtt7tGOWQeKXNlQhu VA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 355k8s970k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 01 Dec 2020 08:05:39 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 1 Dec
 2020 08:05:38 -0800
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.54) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 1 Dec 2020 08:05:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WBvY7ub9S3dJ0jUrFm7mv7zy6OAFPARauuaOxe69FoOZl1oWwCikrvDnkbnom5XdlXy/jUenODgsMjQL/RSe2rAAvy6u+0TXFZaCaIlI1U7YYc71Yhq0GzOUtHVlkfJ7SOZsKec2MJwXZeo79hChifm352XQ7LmfH+hz+I6K7QxlZkPzmN7FAem29v7ZX6+EROzsaLZFFOq2HNYDrPHsh6xAVaNZrYdYMB15ogxPhHfYwwbNkm3MemPt/vnUdupw9GPj77u3JS7fl2W5/unzTcq6k+YWUVG9ZUmJ809fw9ifge/gVbZ+BSy5V4naNAOda6ARSBYMO+bPDzlh6bTWnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zx3rj8PMAjn+1C2jzG7z47OruA3jZ6SKz+HLgG0gQw8=;
 b=X6U++82o6/7pXgE8w/hHjr4JokNsvoZJWqy1KcNfa0JbKCpwANAGd7ipzsdsfzRtIlwIzEb0lBURCykH0cLjYJ+buj1OXT2gwFZUQX01t19gsItHCTeuyhilk0EaQF+jvNDDivI39uVpue7jA+bhuYjLlkoNKmmAxLw5ygvcwEZrLCKh+oJnkcQ3e1WoqyzrlSYzlAjnH8YrStkJCdX0iR+eOLvwRRKxW5UN0n3IJFPHyIU5VpTaCqhHK9HLhMVSpZjYuYr4BeXCreVNrc8Fmujmr43fgr9I6OElx47raP9Tar1D+3uiMfsYigyC8KC1L1xQPuMWlCRamhoALY1nCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zx3rj8PMAjn+1C2jzG7z47OruA3jZ6SKz+HLgG0gQw8=;
 b=PPsxXg1Qfa6rMUMnZbc+vTs4XCTEDtPeynayHnBOgVtkGhq/w74gWsxIFO+ENgxCo+6rMTTQ054/EUCQgcmHaq1t3h2iU2Q2Lai2kvFOYqMSfdDYiQFfQtERj1bhnyoaSZTMIo1kuK/3fwK00ALS6GvsUn8i4jwEkexavXNNsQk=
Received: from DM6PR18MB3034.namprd18.prod.outlook.com (2603:10b6:5:18c::32)
 by DM6PR18MB2409.namprd18.prod.outlook.com (2603:10b6:5:15f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Tue, 1 Dec
 2020 16:05:37 +0000
Received: from DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::a087:2131:1284:66e7]) by DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::a087:2131:1284:66e7%7]) with mapi id 15.20.3611.025; Tue, 1 Dec 2020
 16:05:37 +0000
From:   Saurav Kashyap <skashyap@marvell.com>
To:     Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: RE: [PATCH 02/15] qla2xxx: Change post del message from debug level
 to log level
Thread-Topic: [PATCH 02/15] qla2xxx: Change post del message from debug level
 to log level
Thread-Index: AQHWx/lkg4LKfycnQUap8eyy38ZRyqniZrdg
Date:   Tue, 1 Dec 2020 16:05:37 +0000
Message-ID: <DM6PR18MB303442AE6B84810FE6604CC5D2F40@DM6PR18MB3034.namprd18.prod.outlook.com>
References: <20201201082730.24158-1-njavali@marvell.com>
 <20201201082730.24158-3-njavali@marvell.com>
 <3CCE1C90-64DB-46C7-A49D-9378077CA083@oracle.com>
In-Reply-To: <3CCE1C90-64DB-46C7-A49D-9378077CA083@oracle.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [103.103.215.19]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fae43331-e54f-46fb-ed79-08d89612f149
x-ms-traffictypediagnostic: DM6PR18MB2409:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR18MB24091018509562BC36F909A6D2F40@DM6PR18MB2409.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1091;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E3HD9QpD07XBimFOGNReYAJkhQUk+2fAM4vQd7slHwKLWJ3cj+uryMzJ8w7/UwDgd005PPuw+HdQKVd0nXWbPvIXjniQEFLx//PZaz1CA9RySz9+w7FkBZ7XW3IkawLg6BfTgIdNWmzzmYwbCi+sNl2vSsMXBQZL3rgmB379FELGgmvWlmAnxfPs6Pd03cAFBtIQwkPicFND4Bg+OohuRm0TU6GF5rKiF/QUGVnfQltKZBMP85ZZfVqA0kx4Y78z4eoZ9pM5VOfbrKgQ219nTvgEXUs0qt6BL8pB15k/QdXZudBN7eRtKy3yMBbnGvLa
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3034.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39830400003)(366004)(396003)(346002)(376002)(8936002)(478600001)(8676002)(53546011)(6636002)(107886003)(110136005)(316002)(7696005)(4326008)(54906003)(26005)(55016002)(9686003)(15650500001)(186003)(33656002)(86362001)(5660300002)(83380400001)(76116006)(52536014)(6506007)(2906002)(66946007)(71200400001)(66476007)(66556008)(64756008)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?6qSgLCIyyllxWLi/2C9fgAG3Xbc7yi6xTkXjYJO7DG28ORbxYuUMMjDuwZoA?=
 =?us-ascii?Q?LOGOF/nzgXpFUnaR9nM5Q1cUyrtjO+0CJaJbC+JIw7Pa8cWP1ky3Dyvl1Eyd?=
 =?us-ascii?Q?UHddMzA1tqiHoO8GQ1yt9Ivm1KjfOf+7Ht3ApqsE7Lf/6tnZx8PaNJWi/4dN?=
 =?us-ascii?Q?SrQMtG/+iyeoPqEppOMmzFtu5DWsMFLII0LJzKUYGWDM9J7uwVNxWw3f5h/N?=
 =?us-ascii?Q?bdMhzMOAF7Pi0X6omVKSyBaBvQpVvrAjgV7YBmTwZXv/3O3OH22NKgO/EuLv?=
 =?us-ascii?Q?5m0U74b0kpJra2aUsfGK/2IlpahaqMVl6rV/yZesR3wijoZPS2MfN7GQLGez?=
 =?us-ascii?Q?otewPFG2Syh6Xa9kw+8v/gIbDsDEIb0K/LcdQfuNdW0FMnrMAKKuIdEL5DvS?=
 =?us-ascii?Q?acnNYs0g8tKvSEC7XNmoHLT4Hf5a0w+Qj86U69VKQm5RMUp0rw5Ssvj3D87+?=
 =?us-ascii?Q?MEGZmJGuqAPLwnwDPZpG9a6kY+H4It9ae7YdKqjFBQ/A8LzPVZOXuGhRUdPO?=
 =?us-ascii?Q?5QjzuPXZv0wNmh8qc2LTSaZK4MfMRF0roZlhADgdkenqwyDJgm/kBQFeYoVE?=
 =?us-ascii?Q?sbL7oe+KJvcAHffZZTgVL8wArowAnFBMx6wol20chcJu5iR56gj//WV6utx0?=
 =?us-ascii?Q?ckySJy+kf3h3asJL3n9CkEHq0X72bpGa+CbgoN1UU8PHKeKQ/28SgVaJAWh1?=
 =?us-ascii?Q?kH1H35rDMUdQik+A2GNiOAaT8lEj6Kaj39H43oB1/X0P8l8ELIWlZKOkpr8d?=
 =?us-ascii?Q?zr0pA1lOoia2Q0wM70bzTE/xtqCCVxd1jixwlFJTJnToUwushOFRqHMM4XyB?=
 =?us-ascii?Q?H3yUMOh+0ueo8Fi+M93TVwyV3Qmu99zKOu8CT6CoODrhqygyDL45SZKqW+et?=
 =?us-ascii?Q?BHgyDeCzDTLhb4n+FrOVSPNprue+PdfpqKYjU0qb29aOYVQMzpG/5YScsaeT?=
 =?us-ascii?Q?3YIJqG4nnXp0ny560dVammNzzKzf4wzrv2veDE7oUkc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3034.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fae43331-e54f-46fb-ed79-08d89612f149
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2020 16:05:37.3477
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WNAxfakcM5BMK4hGqH7XFsEVL2cYcvVLXzRDVB0w94kD+lT8Scl7LAP4OalSvufScQ7svumRTJTI7AhRxggnLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB2409
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-01_07:2020-11-30,2020-12-01 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Himasnhu,
Comments inline

> -----Original Message-----
> From: Himanshu Madhani <himanshu.madhani@oracle.com>
> Sent: Tuesday, December 1, 2020 9:15 PM
> To: Nilesh Javali <njavali@marvell.com>
> Cc: Martin K . Petersen <martin.petersen@oracle.com>; linux-
> scsi@vger.kernel.org; GR-QLogic-Storage-Upstream <GR-QLogic-Storage-
> Upstream@marvell.com>
> Subject: Re: [PATCH 02/15] qla2xxx: Change post del message from debug le=
vel
> to log level
>=20
>=20
>=20
> > On Dec 1, 2020, at 2:27 AM, Nilesh Javali <njavali@marvell.com> wrote:
> >
> > From: Saurav Kashyap <skashyap@marvell.com>
> >
> > Change the message debug level.
> >
> > Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
> > Signed-off-by: Nilesh Javali <njavali@marvell.com>
> > ---
> > drivers/scsi/qla2xxx/qla_gs.c | 8 ++++----
> > 1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_g=
s.c
> > index e28c4b7ec55f..391ac75e3de3 100644
> > --- a/drivers/scsi/qla2xxx/qla_gs.c
> > +++ b/drivers/scsi/qla2xxx/qla_gs.c
> > @@ -3558,10 +3558,10 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t
> *vha, srb_t *sp)
> > 					if (fcport->flags & FCF_FCP2_DEVICE)
> > 						fcport->logout_on_delete =3D 0;
> >
> > -					ql_dbg(ql_dbg_disc, vha, 0x20f0,
> > -					    "%s %d %8phC post del sess\n",
> > -					    __func__, __LINE__,
> > -					    fcport->port_name);
> > +					ql_log(ql_log_warn, vha, 0x20f0,
> > +					       "%s %d %8phC post del sess\n",
> > +					       __func__, __LINE__,
> > +					       fcport->port_name);
> >
> >
> 	qlt_schedule_sess_for_deletion(fcport);
> > 					continue;
> > --
> > 2.19.0.rc0
> >
>=20
> I am okay with the change just curious, Would it not flood message file f=
or
> large number of sessions?

This was added mainly for help in debugging, if debug is not enabled. Somet=
imes we get logs
where it's hard to tell what happened to particular session. Moreover sessi=
on deletion is not
very common scenario.

Thanks,
~Saurav
>=20
> --
> Himanshu Madhani	 Oracle Linux Engineering

