Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED860C4338F
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Aug 2021 04:58:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D04986128A
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Aug 2021 04:58:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231442AbhHYE7g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Aug 2021 00:59:36 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:21946 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231550AbhHYE7e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Aug 2021 00:59:34 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17OIU6pR023381;
        Tue, 24 Aug 2021 21:58:33 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-0016f401.pphosted.com with ESMTP id 3an63u1wmb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Aug 2021 21:58:33 -0700
Received: from m0045849.ppops.net (m0045849.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17P4wW6R022344;
        Tue, 24 Aug 2021 21:58:32 -0700
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by mx0a-0016f401.pphosted.com with ESMTP id 3an63u1wm9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Aug 2021 21:58:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qmd2fWUvp66DJ/o8vRXpyoNiY8a8lGiLQcwcd2fi+QAzuQU5WxrvhfLhT6b1nemzG86D5+ffmJt+iQPDiBoSobFGRXADdBuAndWTu9A7UVOVCaXhkJqnJcYLTfKJod6XsnihMIZdYWPQjJAsIEF3WzGCgbbBDoBqVA54Op78O/VBpCZ4OqKZF9fZe0CF7Y934wkgXJKTn6O08fZH5lMCqDs3VtVDm4BHc8+kKf0ctRe9NnMBGoBZUgFfsPeqeRdlQEi2NV6KqJT6syvKkFZThGzFgoZ2GLHFaxvPtkmAPVlDvhHBBOD1jN/Vxs1JraEfsEBzJBa8XAdUci44LreSMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=79eFEBpLTouJoMrN421A61/aiJjhvrq9hBDQX0f4nik=;
 b=D0a3A8cOESc1Ffe81ezWeHFpjepmVDB5q60rgqvWdFk9VejboSA8sLCeUcdWnHrVB6GkDqLBWkQ0r5boTrbIQN6IXgLGJNbA31WAo2tGxt+5D744i8nwfZwj+4aU8heR4DsKT30N9+5LsKyH9+xhP03Vl4g3tVcINALG/oe9t2u2k7sV49EiOeu8KrtsyY+Rb2xJf3qbT5vuHdezyfUKVy7kKYsmHWx3UO+/6Rm8R077/MnLa+//fsyx+HIn2E6kS3mMH3vd529ipRx022MQpcZ8lpz8UGaBT6ryR5TseBAo3ypMKwQyFbj9u1RUmKMqvPh3JtIP7JftSjwd30HPdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=79eFEBpLTouJoMrN421A61/aiJjhvrq9hBDQX0f4nik=;
 b=F65CtLkSb5Bmr4RT2w0V/S7lYT4nSDjyNTHrrPaHHRIirxUxdx6PuHXBPtNGsmyZywy9uHSmuuQJtGqn3b47KGEx45vcXSn8KThSZe59zDOzCmhvR92DXkXuQ/sw428wyGMm6H6MB7/+L6lOG6icyfrSM6j50nsAy1x9Ga0fgp4=
Received: from DM6PR18MB3034.namprd18.prod.outlook.com (2603:10b6:5:18c::32)
 by DM5PR18MB0921.namprd18.prod.outlook.com (2603:10b6:3:33::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.21; Wed, 25 Aug
 2021 04:58:30 +0000
Received: from DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::51c2:62c:df04:89db]) by DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::51c2:62c:df04:89db%4]) with mapi id 15.20.4436.024; Wed, 25 Aug 2021
 04:58:30 +0000
From:   Saurav Kashyap <skashyap@marvell.com>
To:     Ming Lei <ming.lei@redhat.com>
CC:     Sagi Grimberg <sagi@grimberg.me>,
        Nilesh Javali <njavali@marvell.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: RE: [EXT] Re: [PATCH 0/2] qla2xxx - add nvme map_queues support
Thread-Topic: [EXT] Re: [PATCH 0/2] qla2xxx - add nvme map_queues support
Thread-Index: AQHXmB5nQhsPGOkOI0qGifl5VUdIxquBVlsAgACqKsCAAAR/AIABpizw
Date:   Wed, 25 Aug 2021 04:58:30 +0000
Message-ID: <DM6PR18MB30341F714429F8552EB4E126D2C69@DM6PR18MB3034.namprd18.prod.outlook.com>
References: <20210823125649.16061-1-njavali@marvell.com>
 <c72c7669-8818-77f1-2e5d-98bb24308f08@grimberg.me>
 <DM6PR18MB30340DC93DCC82CFFAAE3ACCD2C59@DM6PR18MB3034.namprd18.prod.outlook.com>
 <YSRrmOmrwm5olk0D@T590>
In-Reply-To: <YSRrmOmrwm5olk0D@T590>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=marvell.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0c4c8ee0-2659-4262-c182-08d96784fba1
x-ms-traffictypediagnostic: DM5PR18MB0921:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB09210558852E190DA143F811D2C69@DM5PR18MB0921.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b+kP54bchDF/RFIUGjMnf/P3Ez0nw0zu9Ys7J6dvMM508zA6xMHK4QwqsV1z5Y+kuDUuGlQAYEoh+GyP9SzDzrgkdeWPppBJWnJIlCW9MxrcjLkpDoglFCEB/r7UPD26yn2TLGR9whuXcfimg2/MP/gNBf/t+WiJhfDFqOjgsSV23YfyU8MyY8TbkXTQ3sQ1xyxNyiV0gAx8e23dNKPsH94fKC/mOfxROvTj2kIQ3KMrdjHbkbHZRn6eSZ5ePWdoFZjPl7kEzGt5wh9ccZbqckJYjaBnsQvcvCr4v2aii5zfWeWFLleg/sVI5fk58EzcHdbbFPniFHVhyevXvBnW3Hcmix9J1AjVup3x7mj0BCHLfoFzq9G5vYv2JabbbmbWyo580VBKUYyBagKNMHH0GoWojeEfkO1giag5HuBFi0oVLJhge9IOEgteD0kxRYd1gepnuJT9wAyYhKCHXCYtlpS7TDvS+2kvzf5YTDA7cLyvd02boOscbkalPuMSN2HwHxNYIR6FkWUtClJGfyCa0IXxeIY9+qxrHjvh2XhBWd9u4OQiND2FhTb5A45SVAh355GwmdFhetlgYEAckEXQHJ45R497VtH/5HJrcFuh+FLqT67aa2iC2TYlr/YQXQg8z/4ZdexV31MkyXoeAP6L3wUOMthJruSnlaTLYjMa+2+hqhwkGXFcgOSabvO1kP5bTeTCTixpyzby3/fK/gnQivf/rXd7UH6dxkGxlWs/ygi5HGmObAnCI09aOep9YZYAohqG/5djxVxvdFUi/yPeeMTivLyKLOoVEcnKkQQLP+o=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3034.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(39850400004)(346002)(396003)(136003)(107886003)(6916009)(8676002)(7696005)(19627235002)(966005)(2906002)(55016002)(38100700002)(122000001)(9686003)(83380400001)(86362001)(52536014)(71200400001)(54906003)(38070700005)(316002)(8936002)(186003)(66446008)(478600001)(64756008)(66556008)(66476007)(5660300002)(66946007)(33656002)(6506007)(4326008)(76116006)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6lI/yGxmCmyWi9MBQQHZb8tkxnigvobQnw+e5PxMt08vR+B1AgtAxlCNj/Rm?=
 =?us-ascii?Q?JrWKBSnL9frHV5UXMOaTHDJAaJDU9Yy7wHJ7sk5kPzJKbeFqy8gfagDftulq?=
 =?us-ascii?Q?dECI5SJRKdlr4ZFgPjEuICnDNQZ5g97IG4AkNIons/ggL+LIRH+DeKd/787U?=
 =?us-ascii?Q?bFtO/cSkiM1b1Z13OM3e7Hk5DkXNPkHsNCH0r5E+lgueScRNGYkVD+1H4K+j?=
 =?us-ascii?Q?Ce9X6V4JfK3XZuDnEQUQk/KzEFSw5XA9JaSrMSSkWYpE8aTYyW+MU8fXJsfX?=
 =?us-ascii?Q?geaSq730BexBQ3+wVS+/cSNwSAymvCYD24w6ZJTcLhb/HFhF4jcluyzkmADx?=
 =?us-ascii?Q?eqETAG/UWBHJFAGrpyi/OT/tMGTQLBn3QqozRht+tbw0rsXdkBpA7ZwQNest?=
 =?us-ascii?Q?huho4BT5XvMY5H+RUM8DcE7Zls7JDXtQDBgAxFzZ+yZQsRp3k7HKcuNvp927?=
 =?us-ascii?Q?1stiXYpKgT/W4E2aw1Wny36UySixhr8JQNfJoNcFYocJ9oC9Ht2pEAQ/4Kv8?=
 =?us-ascii?Q?fcIE2wzbYL/t2aaTF6u1izaX+mipa2/1hSKbjGI7oxQzv2Ykp7L0BGM06usC?=
 =?us-ascii?Q?drFJLk+Gm3pXt38FfxH2Ps23vAhSQkq4OTI8I1phdGz2SD0atScfYw2dgs8l?=
 =?us-ascii?Q?9gCSyudySdb+RUzYYe44i9FcTbC0sTBMQlVu6in42VJIwL/yAse8ebByd80z?=
 =?us-ascii?Q?kAs9YjjGwftq14Y324cK+XtNPCGytN3pGJVgTgPP6KdzbO8jTuiiBqKsNVpW?=
 =?us-ascii?Q?pzoEabinLx+YEZkdaZH2g79gQNigOIWklMaces+jIUpa7fG3/3Ka1ALmXF19?=
 =?us-ascii?Q?YeoQw70D6cLJNkb44KbFiL0sn3kyT9/57MwE6IQKnojTbhdEj5SnQGOPASHz?=
 =?us-ascii?Q?HDbtves4uWbYpeaQOvJUrqKkhDeoi+PiFLcuGTq2ym4wv7LK4TusgGnTA5Ad?=
 =?us-ascii?Q?nf4yRJZTBm/j42LGUmwapvQwGNcXZ28xZk98Ku/amwUb2hK5pDKzvoEAvHQw?=
 =?us-ascii?Q?SEN5Ks/2uyhS6vvY/sIdue0F6zRvnO2XryaRHgZK5ohCq/0sAw270c43Kr0Q?=
 =?us-ascii?Q?Ab7R0MpSF2oYZYeA5ewwYncIrNNk8Q8VksCBz7qvCUlV7/v1uAxYOzL5BcZI?=
 =?us-ascii?Q?N5bB0yqi9pZ6fdfnKH4jGZhvW4aeToK3wvZ01kjeXAHIIUZUgkO0EdJSNNi6?=
 =?us-ascii?Q?xgbFErKWdKXXFnlRJy8k+iT35gY/HhqjR2KaZuE54Kw1LWft1OPR8webMS7l?=
 =?us-ascii?Q?8xfEtVtKlU/FOCzW+/JnnIAwGDlOZATJUjQrbotaa2MiDXsBeShmcG1Owxl5?=
 =?us-ascii?Q?wOthWo92Bvyvpn4XMQwiNZhj5UxlNvZR1qhhjKjPmMc9RoFbkGr9OEHKmQ21?=
 =?us-ascii?Q?ta4kTq4CJiZWUOBnZyO/ArNTw330?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3034.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c4c8ee0-2659-4262-c182-08d96784fba1
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Aug 2021 04:58:30.3392
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jZnwnp4hOVVZgo4TrCjkOajM2qHXwwXh6ilokBocby3gUnT+29YalxANmKWbxmbDgQI6XwXNX3oSv7Oua/VWbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB0921
X-Proofpoint-ORIG-GUID: 3Eywz9FzWWTyBujoY7LvFmmGkwvXqX6G
X-Proofpoint-GUID: DqGp5PoBaoe1UPZc8Y2uh6xMbRrn4c0J
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-25_01,2021-08-25_01,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Ming,
Comments inline

> -----Original Message-----
> From: Ming Lei <ming.lei@redhat.com>
> Sent: Tuesday, August 24, 2021 9:17 AM
> To: Saurav Kashyap <skashyap@marvell.com>
> Cc: Sagi Grimberg <sagi@grimberg.me>; Nilesh Javali <njavali@marvell.com>=
;
> martin.petersen@oracle.com; linux-nvme@lists.infradead.org; linux-
> scsi@vger.kernel.org; GR-QLogic-Storage-Upstream <GR-QLogic-Storage-
> Upstream@marvell.com>
> Subject: [EXT] Re: [PATCH 0/2] qla2xxx - add nvme map_queues support
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> On Tue, Aug 24, 2021 at 03:38:24AM +0000, Saurav Kashyap wrote:
> > Hi Sagi,
> > Comments inline
> >
> > > -----Original Message-----
> > > From: Sagi Grimberg <sagi@grimberg.me>
> > > Sent: Monday, August 23, 2021 10:51 PM
> > > To: Nilesh Javali <njavali@marvell.com>; martin.petersen@oracle.com;
> linux-
> > > nvme@lists.infradead.org; Ming Lei <ming.lei@redhat.com>
> > > Cc: linux-scsi@vger.kernel.org; GR-QLogic-Storage-Upstream <GR-QLogic=
-
> > > Storage-Upstream@marvell.com>
> > > Subject: Re: [PATCH 0/2] qla2xxx - add nvme map_queues support
> > >
> > >
> > > On 8/23/21 5:56 AM, Nilesh Javali wrote:
> > > > Currently nvme fc doesn't support map queue functionality. This pat=
ch
> > > > set adds map_queue functionality to nvme_fc_mq_ops and
> > > > nvme_fc_port_template, providing an option to LLDs to map queues
> > > > similar to SCSI. For qla2xxx, minimum 10% improvement is noticed
> > > > with this change as it helps in reducing cpu thrashing.
> > >
> > > Does this make nvme-fc use managed irq?
> >
> > qla2xxx driver uses pci_alloc_irq_vectors_affinity to have affinity wit=
h each
> MSI-X vector. Currently nvme queue are not mapped based on affinity and i=
rq
> offset. The change is to use blk_mq_pci_map_queues for mapping, this func=
tion
> consider irq affinity as well as irq offset.
> >
>=20
> OK, got it. Even though without this patchset, nvme-fc actually relies
> on managed irq since qla2xxx driver uses pci_alloc_irq_vectors_affinity.
>=20
> Now the patchset[1] isn't good for addressing the issue in
> blk_mq_alloc_request_hctx().

Can you please elaborate on this? Is there something needs to be done from =
my side?

Thanks,
~Saurav
>=20
> [1] https://urldefense.proofpoint.com/v2/url?u=3Dhttps-
> 3A__lore.kernel.org_linux-2Dblock_YR7demOSG6MKFVAF-40T590_T_-
> 23t&d=3DDwIBAg&c=3DnKjWec2b6R0mOyPaz7xtfQ&r=3DZHZbmY_LbM3DUZK_BDO1
> OITP3ot_Vkb_5w-
> gas5TBMQ&m=3DCqFDnfAsZphubKXkUx5gsRF6RZ2Qe6sxWkYq4pBfFD0&s=3D2Nba
> EUI5eB6_R6PxW8ld1Xn2OU3_UdD6D30uvFAWhow&e=3D
>=20
>=20
> Thanks,
> Ming

