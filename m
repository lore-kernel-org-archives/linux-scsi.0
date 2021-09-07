Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71016C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Sep 2021 09:18:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AF5A61100
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Sep 2021 09:18:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244918AbhIGJTn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Sep 2021 05:19:43 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:53552 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S244782AbhIGJTj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Sep 2021 05:19:39 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 186Jx8e0016045;
        Tue, 7 Sep 2021 02:18:18 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-0016f401.pphosted.com with ESMTP id 3awrfut3yy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Sep 2021 02:18:18 -0700
Received: from m0045849.ppops.net (m0045849.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1879IIXV020443;
        Tue, 7 Sep 2021 02:18:18 -0700
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by mx0a-0016f401.pphosted.com with ESMTP id 3awrfut3ys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Sep 2021 02:18:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=odpWHOIIrO/xxqXD5IP/Nb/wBs00rxNqYIJc/aJSM6Q0sdOikJ9vTVZwb5q1n2FOKNWSFhGqd+selwg/yzhmtf542i1vgSEvW/DwyUcEknM3W53on0jxkrAEPs0DOU/2IEJQczmT5+hC+aHc4uzCHz9Uj+kugfcaswbGRHNv8BHAQCHMlHibzpUUhJiEudDwO1bMmaR/0T1JSMXgi1M/6G6rmq7ku3M2kVKGTLO5/Icg0rao/hGGPOjLau530keL/Q4AY+97/+P+HPOrGA9oV6Qz/pcTZD9qmFV3/lZ2jRmXRL9J0Fg7F13kWtvv33Wx4CbJkxm3s14esMHGGfgpPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ZvHYSire3RyPvJnhDnKrL7s1d5CnlLZogIyT4UNww0w=;
 b=KQzZQtL1XjjxXJH4HJj5SMw2l26Eo46ZnTEwEwAPxo0y/Lun3eR824vdQGUFQNbdZaQsC61e4nBj/Vc0wf0evDSNR/Eh8fqziEy4zOknObJYUHO59CUJoW5WhQxJCHd7z27C9qUlKkXDp+g9yxjSiTATf7PfEbcMM2XdQpU6rqe2ImtoEYu1xPe92bPrAw9CfbctlLB4Mx2Sg7AoYlnu68ZIrO/EKw2Ck4enTCK/uBYhlxa4b15etF/m0eBXXRQa8PfhcD9dHC3s/CW6X/lBQsaIfVUfgBP/WIIzXaVWeZeXT4u9dk4FLw6m22FXb02UzEIkD742WXrMIqemodB9Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZvHYSire3RyPvJnhDnKrL7s1d5CnlLZogIyT4UNww0w=;
 b=tAspIbSPBLzzm9xXjJlbJ9YdKEz6hCYioDAkeBr8qV4tNB3Vgrco4RWp/YYNuEl7VKRWSg/+JmEfkUcRTnHWTTLgfdkCWR3fRZpcqUkg+GBUAnjn+C7FkBy7eBQJ9o9XWtqQqPORmJ7AYPFsSqK6fyceJaMcT/D89+YciWm9Tqc=
Received: from DM6PR18MB3034.namprd18.prod.outlook.com (2603:10b6:5:18c::32)
 by DM6PR18MB3305.namprd18.prod.outlook.com (2603:10b6:5:1c4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Tue, 7 Sep
 2021 09:18:14 +0000
Received: from DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::f1e4:800f:dec0:61d3]) by DM6PR18MB3034.namprd18.prod.outlook.com
 ([fe80::f1e4:800f:dec0:61d3%6]) with mapi id 15.20.4478.025; Tue, 7 Sep 2021
 09:18:14 +0000
From:   Saurav Kashyap <skashyap@marvell.com>
To:     Ming Lei <ming.lei@redhat.com>, Sagi Grimberg <sagi@grimberg.me>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
CC:     Nilesh Javali <njavali@marvell.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: RE: [EXT] Re: [PATCH 0/2] qla2xxx - add nvme map_queues support
Thread-Topic: [EXT] Re: [PATCH 0/2] qla2xxx - add nvme map_queues support
Thread-Index: AQHXmB5nQhsPGOkOI0qGifl5VUdIxquBVlsAgACqKsCAAAR/AIABpizwgBS26kA=
Date:   Tue, 7 Sep 2021 09:18:14 +0000
Message-ID: <DM6PR18MB30345F9B2131600CDFEA91AFD2D39@DM6PR18MB3034.namprd18.prod.outlook.com>
References: <20210823125649.16061-1-njavali@marvell.com>
 <c72c7669-8818-77f1-2e5d-98bb24308f08@grimberg.me>
 <DM6PR18MB30340DC93DCC82CFFAAE3ACCD2C59@DM6PR18MB3034.namprd18.prod.outlook.com>
 <YSRrmOmrwm5olk0D@T590>
 <DM6PR18MB30341F714429F8552EB4E126D2C69@DM6PR18MB3034.namprd18.prod.outlook.com>
In-Reply-To: <DM6PR18MB30341F714429F8552EB4E126D2C69@DM6PR18MB3034.namprd18.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=marvell.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 436f6bcc-c91f-4782-94c0-08d971e06b96
x-ms-traffictypediagnostic: DM6PR18MB3305:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR18MB33054E03DEBA3FDBD741E4E2D2D39@DM6PR18MB3305.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7NwoHdiRO9g3rvLziWT/NVWUoQ7yab9fVGjpzTCrNrDg430Hn4eMSmp2g0+pW+lkvRhW9MzPUP1X52sX+dA2mNJ4/GvgRdFittx60Z9kMDig+ZnfizivkYRv4RwSvbqIrn+om/LG2A5mTazUiuy82RAGx5m8U9DCW6fqqKyp5Ztc2tmwkaeZ/eEbZtqgN+arANhoqb0VAJfPDN7qEpcM2Z/zR755AT+4YfqHcyDig7JSvuTAqv3Q6+uKojqVqMCgUFLmKc61Ad+ggij9aaKmDVPpCuJYzr3QtL01MMJ0i6YB6vdk53PnidnPQNYXEZ0w1cTIadMPDIQVi2uhdMCnIVA+p+jHPJdsnCDGzO9ThR9hiUm7LtCxwrpaqsBlda4Y8oqtjOMawgpOvL86yEhnuOgTnbMf+rXYLYDHIdY1xpLlp8LNbgOydjrIvMakDTB1IKSUMNMPifmZ4SootL5eCIJUDIjLWIc5BwzovKKb+WruGQaeySzgCfaHIuKAnKZsSbzA4ghrRWTPnNkFk72TY7IoURwpNdwGUhCZVDk576a1iRCjj5CsTndiCbMURVtYHyRfOnhp2AFL5Y73NVoo8KE1kXlFDtTGcHg0i2LcTjk4FpQVbSzUHpGX/5ZSd4A0x33p9KgCQXwIZ9D5sbkPnqsg87D8dGazVl8syt8atHf1sRjuNpV8tK4ikHpQHTv2FkYRdt6IHKsLAC5FWlvsO6jF2jokqQV4KIJZzoquO2W+poFPqgMZ9H3+98jC52gd6lMhHpHHcRqqZcXyNyN3EPHcoE5e0ahwLIaDZkxAVK0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3034.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(55016002)(38070700005)(2906002)(66556008)(8936002)(53546011)(52536014)(71200400001)(9686003)(6506007)(66476007)(19627235002)(8676002)(86362001)(64756008)(316002)(66446008)(5660300002)(7696005)(107886003)(508600001)(966005)(110136005)(76116006)(38100700002)(122000001)(83380400001)(33656002)(186003)(54906003)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7yGNHvcHfsFfL/4xKfNMHN8Tbjs+G/ltqv4sWaPga3McDhlDGGqatpIrUu55?=
 =?us-ascii?Q?zsSfLtBOYNrB403yfZyb93UPassJtkgL+h1Sy2N6vF8jZLQ1vTF1g6vRmORb?=
 =?us-ascii?Q?CRzg/zT05B4UrW5COtpLIN4JnoqsN7iDJXjhXMlrY9122hzP6Q8HYxI2DPJu?=
 =?us-ascii?Q?FG0sD6CGZtnroBmewpQGwocffwzwnUt5D4btguNHyUnvy9U5mVkCgph8Q0tC?=
 =?us-ascii?Q?0mwtAKFfFqps5soEAoBRcCqZ3a/B90nSWNBFnt+ZHpY26Zn9KIslK+nrRRBi?=
 =?us-ascii?Q?e+Cb3VeUJnL+gnbUQyvf4EgbILL0MlV/33Bmm0IRzgyj71skhzzN01fD6i/l?=
 =?us-ascii?Q?kNrF9nx+zI0OzaT1KGggOIFLrHG16xWocGXc7h6O/LE8peHBLZHLOlT2SSJS?=
 =?us-ascii?Q?KXJLOfu20bH+DnVRR1nMN9UPnkku/bHzlXQ7gJYg+IGksnGa45DZEutdAC6m?=
 =?us-ascii?Q?YftcNorAP5erD+FsyDghDy82Vh+VkCCilzLCNw46BDDaZrto3HgTXHPmk621?=
 =?us-ascii?Q?cOg6lfe/SQimi1JY7if2VNPxSQB+fZfpPC/66tFaSkMxxlHmTc2PgV/PG32Q?=
 =?us-ascii?Q?1/kciy8/4/G4xRz9Ufn2gJLkg+pruGY4QXBDSaOIgsB1pJcKDXk6e+TbU2x+?=
 =?us-ascii?Q?0dw7+IH3po21aUMlEA7EGLfsF0dYsxwoRUur5XQOlZm9UrVVOMYW2o9byx0J?=
 =?us-ascii?Q?EbBd1LbHyiWTSNfh22pvu5G3r/PxKO2ptCZT2szliKsbVVzWoKdxjrMLlRM0?=
 =?us-ascii?Q?/DMYfVzKizfM/Gp/9bskzD9foFRC59oeRPQrCNrLguykAhT93mKFF/lgxuSI?=
 =?us-ascii?Q?71lB2SGQFEFDs8f8yj/H40qar7wINqanKA7fLwPJ1x93LCzqJOb8ULCnYK3r?=
 =?us-ascii?Q?gmTTlcLtCWWJ982YLfxgSQiabxGtLfKZD5jbyslM2oXDuu5xQPzAL/NwZSIq?=
 =?us-ascii?Q?fU1sP4R/NG7OxTY5TI+0UJN30t+C2nhUrIJxdYF+hzRT9O3Tt4fmaYvJmFIk?=
 =?us-ascii?Q?nDDTutqlgZjeeQ2+n9QvngfVcLxLKa78kqJW1Hq+eqLnMrCRFPgHlgDjJIA6?=
 =?us-ascii?Q?+JEUUyZDgqgdFcwjjO5PSAC1tiSnF+yFWDSpcJofIY70JAqzhWvkn6hF+ISJ?=
 =?us-ascii?Q?xbL3L7uEBfG7/LSkOh0HWCjKoEVu/29f/5wrz9s5DobTR7JGQiUwojFuABE3?=
 =?us-ascii?Q?BRomF+FAbF2AjLTIwfdCSxmfHYxjByDGHEDsEny7tAAW0aRU8P59c1QEY+yw?=
 =?us-ascii?Q?qcfSz8337SBZo/ZQ8mIvTe5aDIhmaea5z/FG8RtKt5J2gc7wrDQIq1j7SEhi?=
 =?us-ascii?Q?qeSxA1T1qJK86aHzrlcFpdcPqKqbbmfrB+BuOtMUNwQPxXV/+ttZi+qX7xro?=
 =?us-ascii?Q?IQYTW8fuH09vquYruJIzXjxlslSG?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3034.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 436f6bcc-c91f-4782-94c0-08d971e06b96
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Sep 2021 09:18:14.0449
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NC7lSB8jjnpV7vURaeR3KlXIsn4mTvwu5bQCKsFvGBbnGtrtYr0Q3nexSfzrzaMZNJuJLEL7z2v+JnPAQhfjcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB3305
X-Proofpoint-GUID: PSxJlUe_CpRVktG_Ob1q_zyXt6TsbU6z
X-Proofpoint-ORIG-GUID: zIFFhnrbZxjPpHKAEVLazKgWpNm5p-2W
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-07_03,2021-09-03_01,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

Can I get a review for this patch set?

Thanks,
~Saurav

> -----Original Message-----
> From: Saurav Kashyap <skashyap@marvell.com>
> Sent: Wednesday, August 25, 2021 10:29 AM
> To: Ming Lei <ming.lei@redhat.com>
> Cc: Sagi Grimberg <sagi@grimberg.me>; Nilesh Javali <njavali@marvell.com>=
;
> martin.petersen@oracle.com; linux-nvme@lists.infradead.org; linux-
> scsi@vger.kernel.org; GR-QLogic-Storage-Upstream <GR-QLogic-Storage-
> Upstream@marvell.com>
> Subject: RE: [EXT] Re: [PATCH 0/2] qla2xxx - add nvme map_queues support
>=20
> Hi Ming,
> Comments inline
>=20
> > -----Original Message-----
> > From: Ming Lei <ming.lei@redhat.com>
> > Sent: Tuesday, August 24, 2021 9:17 AM
> > To: Saurav Kashyap <skashyap@marvell.com>
> > Cc: Sagi Grimberg <sagi@grimberg.me>; Nilesh Javali <njavali@marvell.co=
m>;
> > martin.petersen@oracle.com; linux-nvme@lists.infradead.org; linux-
> > scsi@vger.kernel.org; GR-QLogic-Storage-Upstream <GR-QLogic-Storage-
> > Upstream@marvell.com>
> > Subject: [EXT] Re: [PATCH 0/2] qla2xxx - add nvme map_queues support
> >
> > External Email
> >
> > ----------------------------------------------------------------------
> > On Tue, Aug 24, 2021 at 03:38:24AM +0000, Saurav Kashyap wrote:
> > > Hi Sagi,
> > > Comments inline
> > >
> > > > -----Original Message-----
> > > > From: Sagi Grimberg <sagi@grimberg.me>
> > > > Sent: Monday, August 23, 2021 10:51 PM
> > > > To: Nilesh Javali <njavali@marvell.com>; martin.petersen@oracle.com=
;
> > linux-
> > > > nvme@lists.infradead.org; Ming Lei <ming.lei@redhat.com>
> > > > Cc: linux-scsi@vger.kernel.org; GR-QLogic-Storage-Upstream <GR-QLog=
ic-
> > > > Storage-Upstream@marvell.com>
> > > > Subject: Re: [PATCH 0/2] qla2xxx - add nvme map_queues support
> > > >
> > > >
> > > > On 8/23/21 5:56 AM, Nilesh Javali wrote:
> > > > > Currently nvme fc doesn't support map queue functionality. This p=
atch
> > > > > set adds map_queue functionality to nvme_fc_mq_ops and
> > > > > nvme_fc_port_template, providing an option to LLDs to map queues
> > > > > similar to SCSI. For qla2xxx, minimum 10% improvement is noticed
> > > > > with this change as it helps in reducing cpu thrashing.
> > > >
> > > > Does this make nvme-fc use managed irq?
> > >
> > > qla2xxx driver uses pci_alloc_irq_vectors_affinity to have affinity w=
ith each
> > MSI-X vector. Currently nvme queue are not mapped based on affinity and=
 irq
> > offset. The change is to use blk_mq_pci_map_queues for mapping, this
> function
> > consider irq affinity as well as irq offset.
> > >
> >
> > OK, got it. Even though without this patchset, nvme-fc actually relies
> > on managed irq since qla2xxx driver uses pci_alloc_irq_vectors_affinity=
.
> >
> > Now the patchset[1] isn't good for addressing the issue in
> > blk_mq_alloc_request_hctx().
>=20
> Can you please elaborate on this? Is there something needs to be done fro=
m my
> side?
>=20
> Thanks,
> ~Saurav
> >
> > [1] https://urldefense.proofpoint.com/v2/url?u=3Dhttps-
> > 3A__lore.kernel.org_linux-2Dblock_YR7demOSG6MKFVAF-40T590_T_-
> >
> 23t&d=3DDwIBAg&c=3DnKjWec2b6R0mOyPaz7xtfQ&r=3DZHZbmY_LbM3DUZK_BDO1
> > OITP3ot_Vkb_5w-
> >
> gas5TBMQ&m=3DCqFDnfAsZphubKXkUx5gsRF6RZ2Qe6sxWkYq4pBfFD0&s=3D2Nba
> > EUI5eB6_R6PxW8ld1Xn2OU3_UdD6D30uvFAWhow&e=3D
> >
> >
> > Thanks,
> > Ming

