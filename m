Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB14CC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 08:09:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B29D1610A2
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 08:09:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231454AbhINIKN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 04:10:13 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:12054 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230477AbhINIIy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Sep 2021 04:08:54 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18E5pYrE004455;
        Tue, 14 Sep 2021 01:07:05 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-0016f401.pphosted.com with ESMTP id 3b2ny3gfgw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 01:07:05 -0700
Received: from m0045849.ppops.net (m0045849.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18E84JP0018271;
        Tue, 14 Sep 2021 01:07:04 -0700
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by mx0a-0016f401.pphosted.com with ESMTP id 3b2ny3gfgq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Sep 2021 01:07:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eEdYvlQPG3ZBW7Zf1ckhAhLa63Wy3UrmWfx7npyE9Vly+h9pFnk+74DTCzi2rVU8kGkidb5uoACwBE0td2xeFKobrK4qR/pDqfQH7BqquvdbFlXVxElxPtOUDo84B4cZCeTpydSpRFEFRFCtPFRzfI4NKzaLpGadbymcMEJWUET/tmww5L0QWhXqBsmPr2Z4AsuCYZoZduHPHYDCPN2V1UmWaiC3RPoYYNUyA0E5YW322XNVoeIvfGtkkXvLKluVwKnUWOrOMSQOFDuGPN+1X/MmI3Achhlv5uJscad/PZrx4b+HVFJGJrALHFRegXUUTkCHGK9jonKsfwoRCrj5Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=+bJWdgiySW9nJM5XnjciuAXCU6Ev801urERDAl0nDwk=;
 b=Wcqc75FuagtIT6W4+MTTlQ98HVvDzOhuXZQ/X59OkPttSpBFig86QkYfGBPChr+LOQsPTDIwQQuUEfuT2ugOnICa/L+fLSqs8XqC5r9bs6VTAofAk2mQNy7mviR0coHOWmrAjbiAsy1eGBkOSv0o0JROLDEGFFNLo0quHzmnUi06Kwkpu6pKgmS8H27H+5X4T3Q0s5ZuncSIvwvx2vl5UR23AF/GRrK33wFBPAX15hJrRA1ZkLkoK17ZEbhNa3+K+imSBh3gtisChMRC1s/Pe+NYYSsrbX+5rEE0+ucHrUjjEA8oAnWrLwKhBb0y7PmRg3TjJ+xbHsqV2twTws54Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+bJWdgiySW9nJM5XnjciuAXCU6Ev801urERDAl0nDwk=;
 b=t9TXJBD25EXvRHWECYt23WArcwykGaZlBJ0BlphbAxCY0Y7NJq0DW7rlJAXJfmtRjovFK/Ztz1RhIpBjbxzVA0kBiWBE3PduqzDvH01DFjUrqjvQ5xuIEo2ID/FJGXDuRGVuYFBIV4vKaAiQ2mX+KVK0Ubr+vQvukVYMdPCr15Q=
Received: from DM6PR18MB3034.namprd18.prod.outlook.com (2603:10b6:5:18c::32)
 by DM5PR18MB0988.namprd18.prod.outlook.com (2603:10b6:3:29::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Tue, 14 Sep
 2021 08:07:02 +0000
Received: from DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::f1e4:800f:dec0:61d3]) by DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::f1e4:800f:dec0:61d3%6]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 08:07:02 +0000
From:   Saurav Kashyap <skashyap@marvell.com>
To:     Ming Lei <ming.lei@redhat.com>, Sagi Grimberg <sagi@grimberg.me>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "hch@lst.de" <hch@lst.de>
CC:     Nilesh Javali <njavali@marvell.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "james.smart@broadcom.com" <james.smart@broadcom.com>,
        "axboe@fb.com" <axboe@fb.com>,
        "kbusch@kernel.org" <kbusch@kernel.org>
Subject: RE: [EXT] Re: [PATCH 0/2] qla2xxx - add nvme map_queues support
Thread-Topic: [EXT] Re: [PATCH 0/2] qla2xxx - add nvme map_queues support
Thread-Index: AQHXmB5nQhsPGOkOI0qGifl5VUdIxquBVlsAgACqKsCAAAR/AIABpizwgBS26kCACujCgA==
Date:   Tue, 14 Sep 2021 08:07:02 +0000
Message-ID: <DM6PR18MB3034746DCB33C51D8CA4EEFED2DA9@DM6PR18MB3034.namprd18.prod.outlook.com>
References: <20210823125649.16061-1-njavali@marvell.com>
 <c72c7669-8818-77f1-2e5d-98bb24308f08@grimberg.me>
 <DM6PR18MB30340DC93DCC82CFFAAE3ACCD2C59@DM6PR18MB3034.namprd18.prod.outlook.com>
 <YSRrmOmrwm5olk0D@T590>
 <DM6PR18MB30341F714429F8552EB4E126D2C69@DM6PR18MB3034.namprd18.prod.outlook.com>
 <DM6PR18MB30345F9B2131600CDFEA91AFD2D39@DM6PR18MB3034.namprd18.prod.outlook.com>
In-Reply-To: <DM6PR18MB30345F9B2131600CDFEA91AFD2D39@DM6PR18MB3034.namprd18.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=marvell.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9c00dde4-8ba0-42e0-fade-08d97756a295
x-ms-traffictypediagnostic: DM5PR18MB0988:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB0988C8B5ACA68DC3F50D9563D2DA9@DM5PR18MB0988.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UCP+LKWMo5cyL3tl70m/P4SogLD7fDZBnJF4mKFvV48Ner8CXhUK0db9ek/Rl6a+jdvBpw42iJofh6fNAA63CCuZQv1z4ndzporX36TJCR/I5N1uoEl/yxQ8TA3pD8V53Z+YyLrNEKi6Jik/e62U36pbaAuLafoXgo/pW5heo+8e+8KxzLljsEAi/EjbuiCEPLsjF8v2Q5lTh5vq3oDt8SMbUPorNKTGzQiP1w/aRBBZXMwRda1eA/6NAVb023aUk0qeeCqBIIWNkMxV7FFcE8lll0zj7RvBro3lUqUCEBu904e4gJab5IJNdXzmIuCYW1FdMM/I4m9NxOIii/CVTeopjMhQfOrA3Aot4kvn8QmTB8/anWk8jDPlqvWND0wXqbbPfoYJCsLehXCVq7uvaa8n9Gm4hmtGlAyyfS2gn+uwHNR2AUapOaVSbzMujG9DM+0Crpl8xAivVDUtv+BgNlSgXNloOZEN8pmsVAuhx5mp8RZXBZJOEzXdVf0Jwjmm5Tii9OAIpRFKFsO5yRnWUYktc5SSTLjfxHZX2H167txlguF/E18QyEyVRfTrO+1+q9VGQRL4Ig8AKvdDGJ+u3XtBOdhn9QMQVFED/cUGkrNmRPmcHl9KekaXtd8mM0eIR1lMYreo6cK3SeS37L8lWK1V61sf+w1It0B/YQFJBdTfiK4/KUQlKFwz/VX9T08/h0vDzjLG1ROZQPfZhOy4C4HVbfx640rEs0FfPVV9yviKCU3do4lGCMTr/TizwoQYu+0gIveX/Byh9lb1xiPv5uHk8LTR30axeKkcmUkRr8M=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3034.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(39860400002)(136003)(366004)(8936002)(52536014)(478600001)(186003)(19627235002)(83380400001)(38100700002)(122000001)(71200400001)(66446008)(7696005)(38070700005)(5660300002)(55016002)(6506007)(8676002)(966005)(110136005)(54906003)(2906002)(4326008)(86362001)(53546011)(66476007)(66556008)(64756008)(66946007)(9686003)(76116006)(316002)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?B1hoo0gzhJatDo0F49NoI5tsgnGTqJMMovmFGGDcH4svDNnXGI5HzeUGWK/E?=
 =?us-ascii?Q?DTRjvChLWvd5qJ2p7mbJ+DcNPwkYzU/oPP5T7dBhDLxauy+ZAQvsEoDRmiBL?=
 =?us-ascii?Q?9cmgCMMGDevSIHYqzQJT4FwrzzD2NngxoGRzMqqY9TVOYRew+TKBzLNtMTUD?=
 =?us-ascii?Q?/R+k68MLIIyifhkbW8FdiQWdAxE2G9iGDwz+g/csqySIiDZ9NEDG/ChD3dJy?=
 =?us-ascii?Q?MGa83JASlNHSYzMPM92xXaXcncqZIUZJ+y/8LjigPvYSkbUHaVL8vMdjnVya?=
 =?us-ascii?Q?izkb1e0MqwbSjVh/jfcIat8dKdeYOEJu/pcx3hCCZ8rvyTlK1n9naa/qdX9k?=
 =?us-ascii?Q?qggNVHnmukSBUoKVTOV/KyBNGMjJXPxtEMgjdep6pAhlTnJ6w67U4DAE06oe?=
 =?us-ascii?Q?geDbfl+8M2HW1a3Z7sCmhEeNCXMEgqyf7AgArLyV9PVV98ZHAqH1JGT4o++D?=
 =?us-ascii?Q?AoOwt3IFotUEezEqFXD7T9+WW1/rzct1bD6lcdj2/q4Hhxjo6Y3kOiAS4P5+?=
 =?us-ascii?Q?TjhtlfyVGaoS/qqbhJEY7MzhZEDTXZqNQCNRtbjZ/B8fSaeEe6Pj50i8SN8D?=
 =?us-ascii?Q?k3qQVtu/tvIeEYL5BF1wCfGTzB0hHlmVpou0V5ojTbOwIPO+/EH8C7wmb6V8?=
 =?us-ascii?Q?Zv6IqXtyK8yxlf6vWn8iFQ6KfcxSCa0s//p/rK6pUgV43UFhoTXBGCIDT8Og?=
 =?us-ascii?Q?LpTymES61NZbGK4jGBMp2JcJK0i1ES3l8isQH4JTTFUsm0YtGE7Q+eBEsYQn?=
 =?us-ascii?Q?zM1EFLOeClR7FtUDHC/kDegYHyikqIgO16sWX+iqmv0V1Ag5OzHp+HryWaQ7?=
 =?us-ascii?Q?GhaDgEaZSoYIrAHDfqZnUvbmlLItxFHGGRT4WlaMxTZYAGZHJ6NZod0H6URr?=
 =?us-ascii?Q?wbUb21wIos0gIt5hHeYC0YVgQTugwQKGo07NNfokz+mXL/Jdr1ukna2w3Il2?=
 =?us-ascii?Q?73C64/na7OTE3HOID5O5R6I2rZ/exYe/dFUI6Q8yH1Wvvde0pKaixflkdhJW?=
 =?us-ascii?Q?rxIpKlbDvIeiJgJES5QnDKftFxbW0YJ8ydAw4CxokhcVIvX45ssuu4wRePwc?=
 =?us-ascii?Q?lxlZ7DBcgHNPJR/WDNGSrPRYExdKgbk4gEro/loKGEpYqxbs74obsscGWcr/?=
 =?us-ascii?Q?NSTzL07+47RiRDxc/1Hsujop+nsKSl24SHOS+Uo2pUKxCBNrZSA7Knv92IAJ?=
 =?us-ascii?Q?TMxrQiBcIcnY3P6mF4ePihSALVlq3b+kgyjPfLhXR4muueOpRxKbFK7/5rhU?=
 =?us-ascii?Q?vGcAF03jIAdUysAwivnLWt1wUMoa3EGvKZdgnbyAKjY6A7X13rcr1bt6CTxV?=
 =?us-ascii?Q?e6OMwpHLrc7iKKTCJplFrYO6YA38IOo2+OMJwyijaeeBJl2JaEh3r7VN5tfM?=
 =?us-ascii?Q?P7uvOD73RJrJTfIAf+cQsMvgo2wV?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3034.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c00dde4-8ba0-42e0-fade-08d97756a295
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2021 08:07:02.6977
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MjSbcE1yo4HmFoKD+U5x8c+NKHzDVKaEuSYYZfOMbzVepw5UcinBI1PByf4x9jYbQTsxPyfeAbvLHTj/ejHUMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB0988
X-Proofpoint-ORIG-GUID: LGG-Mk7Nc6-UELx0s0pTU8h0hVSFlMzh
X-Proofpoint-GUID: agU6KousxLf9zlXeLHYK6FDzJqKBto62
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-14_02,2021-09-09_01,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Sagi/Christoph,

I haven't heard anything on this and there are no review comments on this p=
atch set, kindly include this in nvme tree.

Thanks,
~Saurav


> -----Original Message-----
> From: Saurav Kashyap
> Sent: Tuesday, September 7, 2021 2:48 PM
> To: Ming Lei <ming.lei@redhat.com>; Sagi Grimberg <sagi@grimberg.me>;
> linux-nvme@lists.infradead.org
> Cc: Nilesh Javali <njavali@marvell.com>; martin.petersen@oracle.com; linu=
x-
> scsi@vger.kernel.org; GR-QLogic-Storage-Upstream <GR-QLogic-Storage-
> Upstream@marvell.com>
> Subject: RE: [EXT] Re: [PATCH 0/2] qla2xxx - add nvme map_queues support
>=20
> Hi,
>=20
> Can I get a review for this patch set?
>=20
> Thanks,
> ~Saurav
>=20
> > -----Original Message-----
> > From: Saurav Kashyap <skashyap@marvell.com>
> > Sent: Wednesday, August 25, 2021 10:29 AM
> > To: Ming Lei <ming.lei@redhat.com>
> > Cc: Sagi Grimberg <sagi@grimberg.me>; Nilesh Javali <njavali@marvell.co=
m>;
> > martin.petersen@oracle.com; linux-nvme@lists.infradead.org; linux-
> > scsi@vger.kernel.org; GR-QLogic-Storage-Upstream <GR-QLogic-Storage-
> > Upstream@marvell.com>
> > Subject: RE: [EXT] Re: [PATCH 0/2] qla2xxx - add nvme map_queues suppor=
t
> >
> > Hi Ming,
> > Comments inline
> >
> > > -----Original Message-----
> > > From: Ming Lei <ming.lei@redhat.com>
> > > Sent: Tuesday, August 24, 2021 9:17 AM
> > > To: Saurav Kashyap <skashyap@marvell.com>
> > > Cc: Sagi Grimberg <sagi@grimberg.me>; Nilesh Javali
> <njavali@marvell.com>;
> > > martin.petersen@oracle.com; linux-nvme@lists.infradead.org; linux-
> > > scsi@vger.kernel.org; GR-QLogic-Storage-Upstream <GR-QLogic-Storage-
> > > Upstream@marvell.com>
> > > Subject: [EXT] Re: [PATCH 0/2] qla2xxx - add nvme map_queues support
> > >
> > > External Email
> > >
> > > ---------------------------------------------------------------------=
-
> > > On Tue, Aug 24, 2021 at 03:38:24AM +0000, Saurav Kashyap wrote:
> > > > Hi Sagi,
> > > > Comments inline
> > > >
> > > > > -----Original Message-----
> > > > > From: Sagi Grimberg <sagi@grimberg.me>
> > > > > Sent: Monday, August 23, 2021 10:51 PM
> > > > > To: Nilesh Javali <njavali@marvell.com>; martin.petersen@oracle.c=
om;
> > > linux-
> > > > > nvme@lists.infradead.org; Ming Lei <ming.lei@redhat.com>
> > > > > Cc: linux-scsi@vger.kernel.org; GR-QLogic-Storage-Upstream <GR-
> QLogic-
> > > > > Storage-Upstream@marvell.com>
> > > > > Subject: Re: [PATCH 0/2] qla2xxx - add nvme map_queues support
> > > > >
> > > > >
> > > > > On 8/23/21 5:56 AM, Nilesh Javali wrote:
> > > > > > Currently nvme fc doesn't support map queue functionality. This=
 patch
> > > > > > set adds map_queue functionality to nvme_fc_mq_ops and
> > > > > > nvme_fc_port_template, providing an option to LLDs to map queue=
s
> > > > > > similar to SCSI. For qla2xxx, minimum 10% improvement is notice=
d
> > > > > > with this change as it helps in reducing cpu thrashing.
> > > > >
> > > > > Does this make nvme-fc use managed irq?
> > > >
> > > > qla2xxx driver uses pci_alloc_irq_vectors_affinity to have affinity=
 with
> each
> > > MSI-X vector. Currently nvme queue are not mapped based on affinity a=
nd
> irq
> > > offset. The change is to use blk_mq_pci_map_queues for mapping, this
> > function
> > > consider irq affinity as well as irq offset.
> > > >
> > >
> > > OK, got it. Even though without this patchset, nvme-fc actually relie=
s
> > > on managed irq since qla2xxx driver uses pci_alloc_irq_vectors_affini=
ty.
> > >
> > > Now the patchset[1] isn't good for addressing the issue in
> > > blk_mq_alloc_request_hctx().
> >
> > Can you please elaborate on this? Is there something needs to be done f=
rom
> my
> > side?
> >
> > Thanks,
> > ~Saurav
> > >
> > > [1] https://urldefense.proofpoint.com/v2/url?u=3Dhttps-
> > > 3A__lore.kernel.org_linux-2Dblock_YR7demOSG6MKFVAF-40T590_T_-
> > >
> >
> 23t&d=3DDwIBAg&c=3DnKjWec2b6R0mOyPaz7xtfQ&r=3DZHZbmY_LbM3DUZK_BDO1
> > > OITP3ot_Vkb_5w-
> > >
> >
> gas5TBMQ&m=3DCqFDnfAsZphubKXkUx5gsRF6RZ2Qe6sxWkYq4pBfFD0&s=3D2Nba
> > > EUI5eB6_R6PxW8ld1Xn2OU3_UdD6D30uvFAWhow&e=3D
> > >
> > >
> > > Thanks,
> > > Ming

