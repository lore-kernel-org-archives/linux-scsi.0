Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9E8EC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 05:09:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4A1B60F23
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Oct 2021 05:09:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231625AbhJMFLh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Oct 2021 01:11:37 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:22542 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229603AbhJMFLg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Oct 2021 01:11:36 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19CMeSFK003710;
        Tue, 12 Oct 2021 22:09:07 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-0016f401.pphosted.com with ESMTP id 3bnkc5scnc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 22:09:06 -0700
Received: from m0045849.ppops.net (m0045849.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19D4nQfJ030466;
        Tue, 12 Oct 2021 22:09:06 -0700
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by mx0a-0016f401.pphosted.com with ESMTP id 3bnkc5scn5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 22:09:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vl4DSGumMWb92uL4hLqBc1Tzqoix0EGFgo5+HL32KO1oG/jBtRND072UbPjkNXSYtdBkdhago4gVdq9kHQbBMJJv6GNhrb83Hcb7KU5Zr3u5+Jx0H6OqqNABpAvmVuMpYk5Tx9m8vep4CyvfmG5knftaGnHFmll0cFz4XBU8J2B19gIV5eHZKZVBnOjzl9M16k+0g9QuGMtk5UDPxYEEr2xSXFG0Tzt5NNMKV25uMaecHOss+kAX1CyE76KFlfpfWUfDV8GeFv+9QVM/CEUfUkdXycLCx+vALjNgUt5VT2fgVjcu6E8TQaREPWNdFtt6QASXh2XQzS5ukk6FTZUyMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qf72BZMNVJ9RcnAFLZAXPAcrCo11MM1vrWRZ+OdTQMg=;
 b=Tky4s8zaLPIVf0dCKlcgdydHCDJ1SNouWueQlWd42gfZi9NOA0XaqOwseVFgPS9/wXBealRssQP1onDYHbL5s4k/GpjlHoFCWH7Hr+oft5oPtc0fVQmv6K7vrS/rZTY9XXOixnJuFnJTaKaK5cXdvuVVz4ESkFzIDQQUg73DkoKMDWEvPwSDVHngl6OusJv2QbyLfBdx1XGHmocvoBwZXW4N1EtE7PX+grrVxKjeNY5GFzIx7UbP5ZIZhhqaKuLO0+l+LvSgROFOlY1fABI9tOsS4nN4pI2ESefYn2AZsvBUPM1eE0ydu7c7lwYPCrjXlB+/ocWmsIXmWXM5s0ozRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qf72BZMNVJ9RcnAFLZAXPAcrCo11MM1vrWRZ+OdTQMg=;
 b=i9gz86eCoouDQHiAYmTqUozHpuIKYBsQfzgxjonnWCnM+lGxMer2PG29xEAPd9Vkzf5OrK1Uawa4VwmsMOE7eV9tlQU6R5etY+vSOtdUAWa2wYPeOZ1FQFzcN2oCTmxTc5+HBnLPOsr5kCh7yENqXTW/t8vlfPYtxqLP7tTGEZM=
Received: from DM6PR18MB3034.namprd18.prod.outlook.com (2603:10b6:5:18c::32)
 by DM6PR18MB3308.namprd18.prod.outlook.com (2603:10b6:5:1c6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.22; Wed, 13 Oct
 2021 05:09:04 +0000
Received: from DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::75c2:4fd:a07e:fe18]) by DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::75c2:4fd:a07e:fe18%4]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 05:09:04 +0000
From:   Saurav Kashyap <skashyap@marvell.com>
To:     "hch@lst.de" <hch@lst.de>
CC:     Ming Lei <ming.lei@redhat.com>, Sagi Grimberg <sagi@grimberg.me>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Nilesh Javali <njavali@marvell.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "james.smart@broadcom.com" <james.smart@broadcom.com>,
        "axboe@fb.com" <axboe@fb.com>,
        "kbusch@kernel.org" <kbusch@kernel.org>
Subject: RE: [EXT] Re: [PATCH 0/2] qla2xxx - add nvme map_queues support
Thread-Topic: [EXT] Re: [PATCH 0/2] qla2xxx - add nvme map_queues support
Thread-Index: AQHXmB5nQhsPGOkOI0qGifl5VUdIxquBVlsAgACqKsCAAAR/AIABpizwgBS26kCACujCgIAACxqAgC1abUA=
Date:   Wed, 13 Oct 2021 05:09:04 +0000
Message-ID: <DM6PR18MB30342CF2C3CB23EE3B947841D2B79@DM6PR18MB3034.namprd18.prod.outlook.com>
References: <20210823125649.16061-1-njavali@marvell.com>
 <c72c7669-8818-77f1-2e5d-98bb24308f08@grimberg.me>
 <DM6PR18MB30340DC93DCC82CFFAAE3ACCD2C59@DM6PR18MB3034.namprd18.prod.outlook.com>
 <YSRrmOmrwm5olk0D@T590>
 <DM6PR18MB30341F714429F8552EB4E126D2C69@DM6PR18MB3034.namprd18.prod.outlook.com>
 <DM6PR18MB30345F9B2131600CDFEA91AFD2D39@DM6PR18MB3034.namprd18.prod.outlook.com>
 <DM6PR18MB3034746DCB33C51D8CA4EEFED2DA9@DM6PR18MB3034.namprd18.prod.outlook.com>
 <20210914083249.GA5341@lst.de>
In-Reply-To: <20210914083249.GA5341@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7f3e68a6-9d38-4b7d-e29d-08d98e0793fd
x-ms-traffictypediagnostic: DM6PR18MB3308:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR18MB3308E5BCF8334CF26917ECDFD2B79@DM6PR18MB3308.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: g8dLqbtyzlspKExa396WUZN6L76RoLGiPkPgE+7mflrOUN02bn8Vl1odZ1mkIml3gr+8Syp0d6933uTdUfvnET6ldekQJihbZLGB+/X67x3qcRKZsktLxuTtMWMZqAj7IdQBqITmIhyiDRAqpNAKFOqz9es1Hg9Dzvad15mT9Jh/rpZ1pvCIUFx+hlbBvWYYwZzpfXwRe9qhAVwHWVBI8tS0OGWWQh5dZOEpxHJg3sK/tNh/0iD+6vxp9h7XjmcHOX53VPKkJnP1A6RxbzGB1y2LfjFvlz1toU+FROMjSg3Zsd00U1MCzJBaD/wsUkwxFx1EZ1S4Gs1zOup/lGxS0tPcDAZVjkiOpDlbvGrilPlWfhRbMQSkOTHdZApCSFZ8Fp6gG7uBEAbYA9GX0cBrBFZ5cLCMR0/GzvMl7oQtvvK7zRAlXgMtuRxYBZ5zM4l/mPTe48CP/RHV/sM7uvBVGcCvTexUZokxT3vfKY/e/EL8YLQRNMaE0OhpP6US7UjDmwo42Fvnw7xxWKeh+zhnO8QHw0+jInY4e5zQU40xiZBv++0vfSWT2FuosUQ3qe7EKUiBglzuQT+1T0JN2r8iJa+E/DSyTn0aCHL7ZjiwrEbBbkwyn/5BPLMtdy3QGEzeD3+37NmCZiGXjEeZfodH0iejrErRpRG12aSptoB/EiMXBX/Cf16COXZ33dODWVMSE0z/9DdLxovqVJ6n92f/LA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3034.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(55016002)(38070700005)(33656002)(66946007)(508600001)(2906002)(558084003)(66446008)(7696005)(5660300002)(71200400001)(122000001)(86362001)(64756008)(9686003)(38100700002)(6506007)(76116006)(8936002)(66476007)(186003)(4326008)(54906003)(316002)(83380400001)(6916009)(66556008)(52536014)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?80LgYoSWhQLGqX6phjBRufmVtuLJwIMKM1IP5nRgO5TNfoUVdEtousba5whT?=
 =?us-ascii?Q?Mxrc+6jSHa7n1YyBzuku7rmJxTgbrrwh9v/9imrHTg0GX6YOP3gQjdCBr+Eg?=
 =?us-ascii?Q?tLzi/qFD2fGSlXvkC8Ck/ByfzbLs+41GRQ+KaAeF44uiXS/nGC6zikyB1wvx?=
 =?us-ascii?Q?q3j6QAExPgTSYJVhAI1fnjD8l6pEWSInuZ+2aL9Q/yvl5Wiek3rYYLn+bbQ9?=
 =?us-ascii?Q?WD4SzHOhzTe3AzuMml79AQHoQl2coY+edEeLMDbpEpIDg42sblecUQ6PwrQy?=
 =?us-ascii?Q?X9g1+j0PjaHHeuYWCKgdO5d2W4r50FAhD/u6rEVB9pmA/ohncDSMp2lKy9a8?=
 =?us-ascii?Q?FkDPdMf2Nkj5vqw6rcXNbPcwIZx+ZxNfbxYZFrCoZivPa4ACANBCg+D1Yo57?=
 =?us-ascii?Q?SwzqpMAPBttmW+S9c0lHeS98kW+Zt8dV1UB51U3ffJ4+czQu9u8hpOz+ayGt?=
 =?us-ascii?Q?lf9iYUDXlAQfxAbeiLiOPRy2YOAovKVMXJRa1WdvbGPvoNfvXiKoP1bkfO6f?=
 =?us-ascii?Q?RkXwcYTer3hXTf5lvh3ZM1U1vd+r2oLv1HC22kQUFsBNTdhNZT2jMh9yvtY0?=
 =?us-ascii?Q?TmDiR587NZr2g78oS2aS3lZa4of47fB+v5QqOVF136NocSfQd4gD8H7E3L0z?=
 =?us-ascii?Q?CmCH5Yi4KLPGsPRFYDnIwa4ZEDNszdFjZUn4hZLblRAE39a6sPQCZeGjdx7c?=
 =?us-ascii?Q?qOJqHvK69+5EkApy20PQ1F81JPeM7pmKrWSY/Hj9I73ONOTXbaxpU3vhhXrL?=
 =?us-ascii?Q?9oGjigSMvt+ERpg8PPP3kbK3tLdRwJWC+ITEJv4Xd0CUP5Qagtjmxf0zE2Mi?=
 =?us-ascii?Q?5OxtVAItB6hwb4AyLHdlVtEWQXUkazNVAnZQMcMmaGJWCKIyKR52vH+Gy6Fq?=
 =?us-ascii?Q?gpk+Dfz2INPrPheIotO5jtn1d12FZpahU4pNSGYrIcJdyjZuZtG+YJEwZIhx?=
 =?us-ascii?Q?zoA9xmKddx6iilVSvkr9TR5no55iTYfogYU2T4lLT+xFqvzgIlnKHa00gc7Z?=
 =?us-ascii?Q?Ugxj4K0YoX1Srg6QBfCWpXFOL9DeEhVt4cDWYpoRQVlzjOXvKkxRBwugFWXg?=
 =?us-ascii?Q?mvXk9ScxpXCiEg97XLimxnBuxqN41C+HceglCIVyWmqgdyd9j5q3S4PkAm+R?=
 =?us-ascii?Q?7hek0c1H1/duMmx1Peb1YCEx634sICIn8n9+sF/lUO0srsXHr33dug5FXSdj?=
 =?us-ascii?Q?jrl/i0kNtll0Q3gxLeL8nuMRkVfR61812mU4I/upfEGakj3aK93MDEU2OQFd?=
 =?us-ascii?Q?YkvtrME6DcfP9XAW7l8QUbrhcPjtZ8PCvTZknEP9E34Z0W/Xeo96PwqgLM2c?=
 =?us-ascii?Q?LNHDiY9sON2OZbhecZEyNoMK27Sczgm+LTqHMRQZqSJ04PqY5R+LFfXKTkSB?=
 =?us-ascii?Q?wlKjpoZnyuMAronXllFTzRKp6cFJ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3034.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f3e68a6-9d38-4b7d-e29d-08d98e0793fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2021 05:09:04.7121
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IlYdcoKdw9/C1I2gVDLEzIRD9B/OeEBgDUulm4auAh3PYM/QYlaYk2fOMaJ+bYFbPeSDUalavbzpdTNkDxr7Cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB3308
X-Proofpoint-GUID: P2qREXiwFLn1ApUkZ6Ywr5kZLQZ14KcI
X-Proofpoint-ORIG-GUID: LaCrECF88LZL2Xr7aCCbQG6-7HXje0cN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-13_01,2021-10-13_01,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Christoph,

> > Hi Sagi/Christoph,
> >
> > I haven't heard anything on this and there are no review comments on th=
is
> patch set, kindly include this in nvme tree.
> >
>=20
> I'll queue this up once the 5.16 tree opens unless James voices any
> objections.

Any updates on this one?

Thanks,
~Saurav
