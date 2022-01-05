Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A88AC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Jan 2022 04:28:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237353AbiAEE2d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Jan 2022 23:28:33 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:14068 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S237052AbiAEE2c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Jan 2022 23:28:32 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 2051oLQv030858;
        Tue, 4 Jan 2022 20:28:18 -0800
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3dd214sb82-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Jan 2022 20:28:17 -0800
Received: from m0045849.ppops.net (m0045849.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2054S4a5031750;
        Tue, 4 Jan 2022 20:28:17 -0800
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3dd214sb81-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 Jan 2022 20:28:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I/aGr9hNlhKA/6tBLS2pwhlTOaJdN3wtijtR/BelH7ZCuvlj5vY9xofYKQPZ84esnlvfPvVFnwBJN54CdtfEJCfDIcZx8Ei0l7ap+jRHzz8CsG+HF07BGwh6hJjgQs7IQsEZCsg9/5qsL26Kz7w5McCqE96kjettDA9vhp/wNI8qqPVeNuxFdCh0Dv048jcJuYGY61Vr5dxdZNQvKeuLG6Fegt+sVcUDuk+Ff6KnmTc/Zek7Bx0NJtJTde9t3vb6pWoX7XsJ0hk02kz2bFEBNtQtK251S173Dru/DzHESga9EPOpE0dkHYn+Vp7JlX5wNbUr9IM5rvwPPnFz1ScOzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mz7bNwE6SD+KP5l9hl5XWQcqEUdRJ0w+spu7n7mXilM=;
 b=iQklqmhJ3UNujErj4/Dy6dS71vxOT7PtHB9k3jAsbIXo3mEvcfZ8RWvWL+v+K6pLOcaWAi+2KcaBJWCooSdY+VLn2rWZYFmhlhZNH6oh+nwWondfXLmI66nDBTZ8Ly8UbEfisb/fm1slhUf/fAvtFSoHBnzbvLFnWDUHy2xydYsV9sC4scGKElPF5qyWDbcAnpBvSXOv0O67rGMBhH33Qsc2V4zi24QuDjjF0cCM0m3jW3cPozEspZnrYFDmweiVSOnAszucNX/zs5hkXpmtTEc2FCtiIFhAcDKGh69GWRYNUEEvD7IqQqkpxrvKfydo9L9cq79yqeXOIM+6vw5ivw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mz7bNwE6SD+KP5l9hl5XWQcqEUdRJ0w+spu7n7mXilM=;
 b=GPLk5AmYK6YNl9eZrsDKuXMElmPVHLusBcxzwWZ7Doqu8sRPaBT56LgVpWW6EmIr8jTRfCoPErISRcZLHBdCFNklR+ukciBnZm1zi4ehroSggWNYGD7x3ilMAAncWNNo8FQOctb6/jHr09D9Hwh1K3liN/xscVIQJ+Oo41Y7J9c=
Received: from DM6PR18MB3034.namprd18.prod.outlook.com (2603:10b6:5:18c::32)
 by DM5PR18MB0924.namprd18.prod.outlook.com (2603:10b6:3:28::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.21; Wed, 5 Jan
 2022 04:28:14 +0000
Received: from DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::bdc7:54c4:7093:290c]) by DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::bdc7:54c4:7093:290c%5]) with mapi id 15.20.4844.016; Wed, 5 Jan 2022
 04:28:14 +0000
From:   Saurav Kashyap <skashyap@marvell.com>
To:     Himanshu Madhani <himanshu.madhani@oracle.com>,
        Daniel Wagner <dwagner@suse.de>
CC:     Nilesh Javali <njavali@marvell.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: RE: [PATCH 02/16] qla2xxx: Implement ref count for srb
Thread-Topic: [PATCH 02/16] qla2xxx: Implement ref count for srb
Thread-Index: AQHYAddYR3bSg4N5iEuof7n2vXio7KxT1UYw
Date:   Wed, 5 Jan 2022 04:28:14 +0000
Message-ID: <DM6PR18MB30342BD812998EA2EC06DEC5D24B9@DM6PR18MB3034.namprd18.prod.outlook.com>
References: <20211224070712.17905-1-njavali@marvell.com>
 <20211224070712.17905-3-njavali@marvell.com>
 <02990604-CC38-42ED-B3D6-11CCA0C5D43E@oracle.com>
 <DM6PR18MB30347380BBCF7EAF7EDA92C1D2499@DM6PR18MB3034.namprd18.prod.outlook.com>
 <20220104123204.tkfn5jfknhns67i3@carbon.lan>
 <B4E26038-022C-4495-9043-055D12BA34F6@oracle.com>
In-Reply-To: <B4E26038-022C-4495-9043-055D12BA34F6@oracle.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: feceafde-ca2c-4837-6e02-08d9d003ca2c
x-ms-traffictypediagnostic: DM5PR18MB0924:EE_
x-microsoft-antispam-prvs: <DM5PR18MB092474D85E92188D3D88CB35D24B9@DM5PR18MB0924.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Vi3yPiw9rY6l8Hqv17QjW/j6hm/JvgOp7mgZeiXRJ6k8OENafEINp1yvMSxmglKMhLaU0lUF2krOAZckuYQ0Ean2xGEqmJgT7CQRg/vUu3QQ/3cRppceHM9W5bPUDDgm/fFrmgtE+pkvbh4YRRS207QFpjclFdC9vydOyWUOx6iFJal5oeCiychv57tc/+ERNBE8yDo1k4Sf3rbJsVzjK3x40Xcr8zW0qt9EvNQSgUDVVZJEXNXPuneKL8STAWvvr4Qjm3Q57ZXvlNLA8vOxFKfdNhLI3SdtQNyRvicvT0H+1yEBcfXZBRJFNblNOdtNpN4FJFqJGzNn3TpcqTrwiWbTlbIMs6yh5U5JrFgBPiwY1gPXhbXwkIjvpS6dB52t5cxKK9jHAdV0Su+OfD9HBaoPWZyv64actlOS1cMEosXJZDVGeM2IN8/1ilVgFqpjQ+hutb5k+lg9AisT0eTjdqBdvDEvI+k7lPq4QMX/Q4RBSmw01RxS8zn/n5Web/n/Bttx/Sc9dkeXxaH9VYJGGc3yOj+pYO+1FSGwACKOf7oS5C8xWHfoBKcqU39TtY0RbyNK0ko2qPPNQf8ey8H0ZbMRMXDxHZQO8rnA6PqKh3qUNF4yCChJeMvkHzpytjhKhDUUSOd7yFSfOJjAEHjmRCi7lRGIc6pwBd9inRaFpLDH/drffom5zqxF36AClCSRUsQQFTJxVZczgvs/ZjDj3okh3I/qcdwFgk04pMdKLA+IVsjB217WvFCzO1zmjnhkzyioYYvV0LGKANpwJF2B2kco/ZFVIORvvS0RVrWBs8s=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3034.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(33656002)(55236004)(55016003)(7696005)(6506007)(508600001)(9686003)(8936002)(83380400001)(86362001)(38070700005)(71200400001)(2906002)(53546011)(8676002)(54906003)(966005)(110136005)(316002)(38100700002)(52536014)(4326008)(26005)(66946007)(76116006)(186003)(64756008)(122000001)(66556008)(66476007)(66446008)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Yyvb+JSUbGANPrciiQiiGBNR0qbDDbAJXMqScpUyzv8NusyE2jZo5qftuxAE?=
 =?us-ascii?Q?+/zUOWqNehxzPFNN4/uf5pabxDT+8fiimXqr/UbQKRrs8jFqv+m9BDmJ3PyW?=
 =?us-ascii?Q?GebOBPm3Gh1kNC7WNyZens/f9/B25yQQPVIPAXSDMhjAPBi1wKXjRffY7SVa?=
 =?us-ascii?Q?Ttq4NU62ngjPWHf0s8danrzb8hlvliulpn6lvMn/eZLaLlABoSsh3LiuELE6?=
 =?us-ascii?Q?RVMoygo8fAWBC2XIpdZRVImv8N8nTdeyaBM4s8QFn980/Dvse+12H4Oq59fs?=
 =?us-ascii?Q?afngtOt0Beicz+m4+ADrZ0Wv+2Son+nvzbGv3zrsPwFblUQRLxTcY5Bj2803?=
 =?us-ascii?Q?PM6uGwPFGkUIzlDOh8yZTv1S+QEXnEvxobsmP4yx2/ePXwrXKQNfTmPwoIEt?=
 =?us-ascii?Q?RfJmljMMlzegSUyQzqfwyYKhZBVgczgA6bSTbIRxATq2XINeM/HskhVeYFU9?=
 =?us-ascii?Q?pxIoBDySTPsJGJiJ/i9UVibpcIgve2ElHV91HuHnCTuky6T2qPak/kTFyDjM?=
 =?us-ascii?Q?CRPNj7LyRXnU1cmkM5U5ScV4ZlJeAzNyT3g2D1L9kMOJfFzuiJxcg6H1wJXj?=
 =?us-ascii?Q?nbiuoN+ttinwD6cddtYV6dklVqxOfOXNUmG2eKnNTNVjWydkESdrwVEirtAf?=
 =?us-ascii?Q?NLG1/W6vbjt28maosY13za6piyLwIORqIQvRu77WTgayKMGNsZH7ZGVVYk7h?=
 =?us-ascii?Q?tqFkK97Im+X4N+dGK/58cOyy27gLQ7VZUUauAYrUKcnqVL540l9Bse11kgVt?=
 =?us-ascii?Q?avCCpYfH5pjqe3iVxqvadOzld8b62kjXtMz2WHuDY0KpSlre8pJXP+MsfXiD?=
 =?us-ascii?Q?7dAb/DBJtpPZ/kTruyw27ddusvHQ6IjoQdHeFMD4CNqqmW2RylRVOGKAtbu7?=
 =?us-ascii?Q?DuJZBpNbj5Tai5wuueI0YcLbv2P62//T02SHijp88iXRxhFw0SkitylKquEa?=
 =?us-ascii?Q?gCDidmtOB9cCwYHAvxtvJfrBRXWS0NLbmiAY/PC1bBIS4LMW0TdsY4E4b4ml?=
 =?us-ascii?Q?C+m8mU81hyaTX+Q1Ft7NObHUL5ZWj5IbYBbLIoKgUV4jfy2ZgPlHugQ0jk0d?=
 =?us-ascii?Q?silx0MELOdX8NHYvumnN18CuKyDcAFHR9WXg9A8DDu4qslo0FG3PEDxcsBdx?=
 =?us-ascii?Q?7MRYpmaglK/ksQWQLlrRYoXw5q4VqaUgtAYtht4YYREqigxEeOEnOdaUPrs/?=
 =?us-ascii?Q?8hD5Z/9LiDvIWtj5mlz45U54SLM/4+yXoITK8sE9cQFzX2M6cnfs1j+Vt+n4?=
 =?us-ascii?Q?RzD0NhQwERn5+KjjybwRIIWAPFDzp4kuGZM0GGQflK3eC9cu3Iyr8CTJIjaL?=
 =?us-ascii?Q?p0eY6hFzbFKgtFS6fgMuZciqkQ1z2k9lalkHFGqCx5gf0liIl+WxF9TAJG7Q?=
 =?us-ascii?Q?evBggLQMkKuTcbkyz/pj2rxSFCTG7N2oGrURiolgI9mBoS9W/3GbCmYjr2lA?=
 =?us-ascii?Q?yoDQFtYn+Cx5qOe3FtLODjT7uz3WuOYWmSCssc/onabRGBH7dV7g2NNfEAEK?=
 =?us-ascii?Q?81/vvgvdAutL4dQ/j6hkBhKV71Lzfa5maljWjyELHBfJkECTZXHG4f+qbeDr?=
 =?us-ascii?Q?3rHsfcHfT79pkt7LzM/i0OalYW5LYUFoF/AMb1Skh1u9efU5Ux+sdihodCxh?=
 =?us-ascii?Q?xZph8k5kpQ7EJAtoo7/QEO0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3034.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: feceafde-ca2c-4837-6e02-08d9d003ca2c
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2022 04:28:14.3930
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6ATxDtn92hgeJMr7vVjjwhhUbuEpEndol7Ck8rNuLZdI2XTKnigivVGyyXKydgizYifQbdX+dYL/cdU7Y2lwsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB0924
X-Proofpoint-GUID: Zqk2PtZHrnVJdVC1UsSbYNBaGjYba0ac
X-Proofpoint-ORIG-GUID: 0oVsN8Wf-53a3wVGeRuLD_fytUKyvZcX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-05_01,2022-01-04_01,2021-12-02_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Himanshu,

> -----Original Message-----
> From: Himanshu Madhani <himanshu.madhani@oracle.com>
> Sent: Wednesday, January 5, 2022 7:26 AM
> To: Daniel Wagner <dwagner@suse.de>
> Cc: Saurav Kashyap <skashyap@marvell.com>; Nilesh Javali
> <njavali@marvell.com>; Martin Petersen <martin.petersen@oracle.com>;
> linux-scsi@vger.kernel.org; GR-QLogic-Storage-Upstream <GR-QLogic-Storage=
-
> Upstream@marvell.com>; Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Subject: [EXT] Re: [PATCH 02/16] qla2xxx: Implement ref count for srb
>=20
> External Email
>=20
> ----------------------------------------------------------------------
>=20
>=20
> > On Jan 4, 2022, at 4:32 AM, Daniel Wagner <dwagner@suse.de> wrote:
> >
> > On Mon, Jan 03, 2022 at 03:56:06AM +0000, Saurav Kashyap wrote:
> >>>> -	sp->free(sp);
> >>>> +	/* ref: INIT */
> >>>
> >>> IMO, There is no need for this comment spread in this patch. Please e=
xplain
> If
> >>> you think there is need for comment.
> >>
> >> <SK> Thanks for the review. The sp reference can be taken and released=
 on
> various paths. These comments make
> >> life simpler during some ref issue and also make code more understanda=
ble.
> For various scenarios, this comments
> >> helps in determining final reference count and check if its released p=
roperly
> or not.
> >
> > I think the better way to address is to get Sebastian's patch working:
> >
> > https://urldefense.proofpoint.com/v2/url?u=3Dhttps-
> 3A__lore.kernel.org_all_20131103193308.GA20998-
> 40linutronix.de_&d=3DDwIFAg&c=3DnKjWec2b6R0mOyPaz7xtfQ&r=3DZHZbmY_LbM3
> DUZK_BDO1OITP3ot_Vkb_5w-
> gas5TBMQ&m=3DpgQzCrwTlIOgowou6VpA1Ntie8bnWsKW6idQUvbA_vrFvKwgX-
> Nh8y6xHCE6ek37&s=3D6cEa2Qr6Pg9kxgvIV7vOvya2xWBK39Zr5XJygiIk5vw&e=3D
> >
> > Daniel
>=20
> This patch would be good to get it working for debugging reference counte=
r.
> However, for the current series, I am okay with this patch if better
> description is provided for the comment.


Thanks for review, will update the description.

Thanks,
~Saurav
>=20
> --
> Himanshu Madhani	 Oracle Linux Engineering

