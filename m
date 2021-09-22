Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5460C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 04:28:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A75A611B0
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 04:28:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbhIVEaS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Sep 2021 00:30:18 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:22738 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229495AbhIVEaR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Sep 2021 00:30:17 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18LLFkJl023329;
        Tue, 21 Sep 2021 21:28:23 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-0016f401.pphosted.com with ESMTP id 3b7q5d94q3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Sep 2021 21:28:23 -0700
Received: from m0045849.ppops.net (m0045849.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18M4SMqI003386;
        Tue, 21 Sep 2021 21:28:22 -0700
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by mx0a-0016f401.pphosted.com with ESMTP id 3b7q5d94q1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 21 Sep 2021 21:28:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WCSZM5E6+o35TzPOZivqirqjVCs2uUResTrP5gUgQC1vBJjxyDz9hOQGJu56GF4SbtfOSHpwQEJExF43Dv6TTpTNxqe7OdFJQl2G87RxZ5asnrE8VufcNGhTTAJr6LylqFmaWnDdeu3HZgR6u8AWRBAvbRi7Hi6xaRqE3aoBl2ZfhHDq/5GAwcrAj94Lv99URMRXJSzYg4718xG4vRHlSBn653YQLUu7gOJXh/PsW0giKiyGLnlTtFl5H2GxBj2+c07VCyhFyx2YeokRipCUN5KvgB54oQeLxoaWcy7MS3BByQBSXkz0ccDW3g2XwZy8DVPK1Af7A35iPmdtueVheA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=XQh4aPPcK0Tec1azF3aqkWp/TKLGMwpVfB3m1IOFtiA=;
 b=k1AfsSv0GkzHT9dex7g0go8tzcf2tKCQquzQS/Vvhi5jLQf0oHo7FDLbwWdoQZlCo5l+hP0+ZqwETCy70TC5IAcXCqBgSHPW7bzzL6RuUlCOrw83naXRCGk5wQ7XajAA1khUpPxHDBXssOlaNeoveoa0+iTLCv7TF00gIFH/eyRUP9ZpE6dvKtcgT/zGY8fOSOznGBqwvprZtlQgNAvPrb+FpVCk7lxmfrUVTq7ye6/SLrnuxgZJfBrldGG5fCgmmgZ7LgTsSuu1/flQ5kGfnaHmKxyAc/oX54rGSL1L0sIyngICksaw+JjdLtZdSPWyA+FbrymhMyoWD6FpdtnjHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XQh4aPPcK0Tec1azF3aqkWp/TKLGMwpVfB3m1IOFtiA=;
 b=gyfKdhkTfLFDzGs8oAc9Ldr8tCzcUc6dxRjT7QizDGrlTbFz9h79LoFZ+vUJQLb1nndmfWHOL6Mka6bqj9U3Uj7xSpEpH84Jv3C4cUTk3UmQ5s4zC0k5QNFnqVOfVU+tEp68eusg9OWebVplhoeB7MhRydMIocoQCOLm+dk/x7A=
Received: from DM6PR18MB3034.namprd18.prod.outlook.com (2603:10b6:5:18c::32)
 by DM6PR18MB2538.namprd18.prod.outlook.com (2603:10b6:5:185::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.17; Wed, 22 Sep
 2021 04:28:20 +0000
Received: from DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::75c2:4fd:a07e:fe18]) by DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::75c2:4fd:a07e:fe18%4]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 04:28:19 +0000
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
Thread-Index: AQHXmB5nQhsPGOkOI0qGifl5VUdIxquBVlsAgACqKsCAAAR/AIABpizwgBS26kCACujCgIAACxqAgAxOIiA=
Date:   Wed, 22 Sep 2021 04:28:19 +0000
Message-ID: <DM6PR18MB303494DB5F38C19E0789C138D2A29@DM6PR18MB3034.namprd18.prod.outlook.com>
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
x-ms-office365-filtering-correlation-id: b6f8bf2f-9ea5-43a4-cd95-08d97d8167e9
x-ms-traffictypediagnostic: DM6PR18MB2538:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR18MB253848ED8CFA31DAB1D2E86AD2A29@DM6PR18MB2538.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0dU9P5vBED8NgX5cmbycoeTPmJE9O1tsSyTMGne5qO15YXoXZ+pcTZfZcXitesvXNlMq/yPHZ0V8Jm6NB2SZCKsVuUXqnERw9gR86CMoZOV7sAOo+xcz/7CKqnidcLyD4YKB8C1eCnESLRiduFMLDvrPx+UstBIkD2WU9w5f8Sg3eTZ01oJn+Vuyp7g16ZYCuYFPUxllOuaKCXA5LNftvcuIA+80b+s02rELSbFTTmQ2dmpkrpxSZDpNQ/FWR+ETKF30UPvBzQGVPW5oSCjAL9RXpT0rCCPhp6UXEdfgJg+weHaKFfmiQr97UgEyF+VWBktzWcHrvjUYsCEpr6DT0YKIHYhSTtfvSBc7rZm7nXnXy3D5XvamkT7EttWrU7Fj6MNKQBmqhkiU+ICpKhD6sPWCbwORclmxeqqhgJdakha1QRkmyldlnSQEJksNFlQyCoH8LgmJosFGv92RLYPDKTvrVSLvAgqSn17mpt6/z2ceb95SRCxP6YcsMkOOy4ut4RcHNDXOVSOvrVdc7hnKflLvYGA3HOo/xa4Pcs6sZMo8DuF4uI6+Sh11Y3CWyiAMtjUtJwhXjgka63TGXOSDkY5A8lManvaACYws+A838om0nN/cUqu/kFkxbYeMFJgtScyLwauI3pj9S2GcVmfaXhoF7JiMi4UW+EerTPZ6BLk8crvFugs/JDnQ08+eGgD5CLBHY+SzkcdwyNZvV9o9Qg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3034.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(122000001)(2906002)(4744005)(54906003)(6916009)(66446008)(52536014)(508600001)(33656002)(38100700002)(8936002)(76116006)(38070700005)(66946007)(71200400001)(8676002)(5660300002)(55016002)(316002)(7696005)(66556008)(186003)(6506007)(26005)(64756008)(4326008)(9686003)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?veuLajK/umUrrg/8ZrFcBPJJjf3xRbSyUF0QxPHoFwrJCBBDWbt65xYeofhb?=
 =?us-ascii?Q?xgdJMT5gq4BwDv1vHCMTvJyd0r93CG+31LTgDfJ0hgjZnm5njofoozsXgmXk?=
 =?us-ascii?Q?NT6sny2pZHYnEyVUl7vYUANmYx9BvlA6yXGQZ0bMgMdsLPuriIN9oumDELEe?=
 =?us-ascii?Q?ThXg3ss4K0LKfzEw6jSfL1RJtmyPH1/f/pa1sCxjJj/PuPGWaUOFGsOh5iZ9?=
 =?us-ascii?Q?autKGtPvzY1aLSzi//40Jmt2Hy4cGglua+2TtWnrxgPabOKoIz1Q6EfrYULU?=
 =?us-ascii?Q?paDKphdnPqx3KX1CUJQ2hFtEji3KSdYsoeuye4G7YyZz+G7eiYrtSeXRWuHk?=
 =?us-ascii?Q?+4Sn4BJkTrGrcqevaFf0fWnF8pOMalOoYHpXk4jXPGGV4XUWg/NNUNxcHz5A?=
 =?us-ascii?Q?nJ6LgykK+kY/+1ynMF88rYtwABmrG457Uyy+Y4w2IG1ljnU5bKy0y76snjVu?=
 =?us-ascii?Q?6yoYOMDcbbg1GPo48IFRRqUZ0b7XqUVry4KCJlU4KmyJPT2hpNSeZnDXE1oY?=
 =?us-ascii?Q?kIT6/ir3ItnX3i8XTvUaPfH8S3Ls6K0+57ir4jUiw8YFi4JmJ3sXXKpr/QG3?=
 =?us-ascii?Q?EXUFcEVwwdsA4ndebkF/+okZVSbYaOi6KQyFOg/8DRw3kll7l2t+hWDa0Iv7?=
 =?us-ascii?Q?k8z10719oPc7lMorFgiSCgW7FpGT+iKfQWeFkusaL8BlV0VCryQxcG8wEfHB?=
 =?us-ascii?Q?bZmtOSWGnS4QxisuF0xrJE6PSwRFEEoMUWMg4joN/1SHc4pE9vLfovtUysTW?=
 =?us-ascii?Q?ZLwlgNRPm3q8SOki1mg20x2jvVKquYMVDlYJy2fGK11w10QPGRF2b8qsN1iu?=
 =?us-ascii?Q?3UM/f53HOAiLTviDv0OG3zhxesBd4Bht+vJ331eIfJZbGunTj8d4x3zWs186?=
 =?us-ascii?Q?R4u7Nx5v50MrpXJp/laSmRggojBY7tYVKBUtNNVI0v46C5BBf7F+Y+GnjGXt?=
 =?us-ascii?Q?owHUZdhgtWaLkoUUs3c1x3wM5zf6HHY/ij8qPIwn+xCBdo/uOzjpDbwF7Jjr?=
 =?us-ascii?Q?kkSrYsMIj8tNTOvu2GakdZgq/9LfSIJxxuVmUadcowHmUy/D6RGjmNyK69Bo?=
 =?us-ascii?Q?PuZZ3m1LY8VUsaCQ28Ei3MjIo2iKy+nPwdCBpMKC1D5A/dDQhYq5aNYms7jR?=
 =?us-ascii?Q?H/Do9yezijXE5CrpqbLh8a6XWsyO49Fu53ZqCWgN6xbaYEcMMbbRCAhRGfzM?=
 =?us-ascii?Q?kidTifKQ2ZSZaf1g7+aPl5fsMJvtJAWWMy9ZWMSSXstHPBY5QwqGxoVxcMi6?=
 =?us-ascii?Q?WzygFdzzx6MZrfwILhIIauxRrEV6NY9ieKct+KKDBxzbTcMizmV9QAdeQWIy?=
 =?us-ascii?Q?v8DU+YH/bzlbFbkR+kInJjiR?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3034.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6f8bf2f-9ea5-43a4-cd95-08d97d8167e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2021 04:28:19.5255
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yIwnGOeuNsuyPn/Vf3QfFFhXkyxcletlf6KiPdTJorkg4pIxo14Ozi1TsHjno+BCNIb8RgmjJTUYa+vZ90lk5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB2538
X-Proofpoint-GUID: mWl6ewY4qCLJcQug6B4o5C1xl8WO4PRK
X-Proofpoint-ORIG-GUID: smJm6R_W3-X1N_jPsZLw7IWzhq3Z21_r
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-22_01,2021-09-20_01,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> On Tue, Sep 14, 2021 at 08:07:02AM +0000, Saurav Kashyap wrote:
> > Hi Sagi/Christoph,
> >
> > I haven't heard anything on this and there are no review comments on th=
is
> patch set, kindly include this in nvme tree.
> >
>=20
> I'll queue this up once the 5.16 tree opens unless James voices any
> objections.

Sounds good.

Thanks,
~Saurav
