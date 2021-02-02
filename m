Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA410C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 11:26:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD65964E7B
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 11:26:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbhBBL02 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Feb 2021 06:26:28 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:12448 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231284AbhBBLY0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Feb 2021 06:24:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612265065; x=1643801065;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WdrMpr8GtCJJPbqk5j0nV3Tl0qt0Z8Alqy83XTGwqCI=;
  b=Od88rKskBHmdgYwa/nNh0j4XADJ6j9XjL7ZsAtG/c59QcduNavuR1Ncl
   3DwqBEapkNsD/WzyRApWHPWf0Ixk344wTkYjfwf6+EHnieTNYyxxX00Hk
   FO/M7AwFxEz/8+c2CqmMC015Gqp/BXG9Z7hREId/Ynw8+JxVFWpKqV5bJ
   vO4Vx3Z5gMBXFx4mUKFuSEpmF1sMaB7oqFNZkbAJqXcY1QTWJ7bhNXoaA
   ox8eSbE7VDEKmtMYJ5YzzeRHIn8/S/H+g1XqGRjguTDSPyw4rVvmnCQC2
   +pyiJINMPs9DVGLlhVfafhJDbhbdyyydpQJ1V96xZY6GFYMX+AA5qIVXx
   g==;
IronPort-SDR: wwN8BIac72QHcuxdgj0updM153HKsfMdh2VvteIXCSSANAvGiMTwQMCr26aGySug7YKc3XIsKI
 RvL6qbS86ag1SZbB0Kxn5Dr2x+zsFQn7sx3ydcA89E3RI0ubfLlHMTi+On0oTRoeYjz5wDQnxw
 2X8lHSZyHR4iGCQ4Y20LO9ZeHk2UP22yHJsE6lDc3zW2GTSGpb3nOCQnpK5ufjkyvGbj3G1CX3
 KcPLHKbwdtUMBSQvis5b1c5LnsEeFcwliSpztOTVTskj+eaMIOaIJ2gRq+BI6VZr3oPkqSUksO
 AVg=
X-IronPort-AV: E=Sophos;i="5.79,394,1602518400"; 
   d="scan'208";a="163359846"
Received: from mail-mw2nam10lp2108.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.108])
  by ob1.hgst.iphmx.com with ESMTP; 02 Feb 2021 19:23:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EJjg0WZ6S4pUGEPWlUQqPYwbHk+rZdgL7L7sCexI45R4dSVd1qyAyNXlsFEUfJMwsWboprC1UCet70Gry4M6drTWu93q2T82JJ6mInXAW/AZNp/gYMB6kgcmD9jHwQFBGN70Jt5lfpwkHPqn/fHiMf0MUgrNngPufYOUpIHUfcG1JaS9CRnN2u+smvRd/AHG3M2rABsgxQ+jZ9d65CMTQC35W8qUgCgdk9t0KOSM4cAOGX7hidEjSwXHO1KPH6UlXGFwAVtdgsoJJ9WCVkNeYUTmVMxNCYV2amcM4YEa+bk5hwpwXpZ5VTvcQJeZ1EDiU524M5sw3s2VJoaNldXu3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gczGq+JOuX2fh7JidKvJaobbIE5NvYegNz/J14kE8d4=;
 b=KEIQfOh61mMeWJPtyBZDeBLK3sbfGdV+tr59nr/E/ejhrXqf2tw1DoPbgtYH4CR8IcuevuX+qofqpuJsGzCSu/ZM2lt5aKCA7Roy+ifAiQSFK4aZjOZtUVkaZjmYR8zpQhn4YODnCSSyEtJajlf6KlSxReiB09LITTqL1f9Xa/x4DaDyXj9Z1g/yYUFyRha5mu9L67FWBXPV0DfXIoqdHxfvnKkCoZx4WIfPJClBlE1XIpuA8TqtKA7UWSKFPLNDicRgqPccmo/zjorgJ8Fo5br8qa7TwmXUjjg86BVdZpwxocJvlkz2fxFCu0m+8EWQSdB7o0eEvRfhvxpeOIKENA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gczGq+JOuX2fh7JidKvJaobbIE5NvYegNz/J14kE8d4=;
 b=UuM9IOPN4MjuSYZ0Uh6yYHes2OR851sqcgDmaVjwT2cD1TpdtLWl7ZQ6ylhuZQAXpoSIeVR4msH/nI54yfV4s+tutKFA7SL4mgW9ahBjH57LeONGVL7v1XXU/R+8y5YnPIAenm3JIQP5sQEtFLIkwZWXd/0VL6Nn2X7InvOwhY8=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB5354.namprd04.prod.outlook.com (2603:10b6:5:10b::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3805.19; Tue, 2 Feb 2021 11:23:18 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3805.027; Tue, 2 Feb 2021
 11:23:17 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>
Subject: RE: [PATCH v2 3/9] scsi: ufshpb: Add region's reads counter
Thread-Topic: [PATCH v2 3/9] scsi: ufshpb: Add region's reads counter
Thread-Index: AQHW+T24Unmd4UenDUy75lZ2X5mw2apEttgAgAACGeA=
Date:   Tue, 2 Feb 2021 11:23:17 +0000
Message-ID: <DM6PR04MB65750EECC22CC837D028003DFCB59@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210202083007.104050-1-avri.altman@wdc.com>
 <20210202083007.104050-4-avri.altman@wdc.com> <YBk0PHFW+8klHN8Y@kroah.com>
In-Reply-To: <YBk0PHFW+8klHN8Y@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6e9e4f57-03e3-4df7-011e-08d8c76cf06a
x-ms-traffictypediagnostic: DM6PR04MB5354:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB5354A8674C80D9197656D85EFCB59@DM6PR04MB5354.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:989;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uaV5c0CmPWl6gMT+Bfcvj22XXrVJiwOXaJ6RIMnZeoR5zmY4Ve2wd/UHQXujvx+8Oh4PfIweHgCWyTYnil9iHYVFuznrOt+ktB1npdXBA08AGG9eMgHMXyHKAP+AEi2q697dmXlugtZSn3J659A9YYSoc+0by9u+AQR50f2DdHxmTFBh9B7s8O5ZWSZmw5oC1jgPNjG6AxSCcuW5mdvgvsaqh4SiZI8CCOPIXHVRcqbdCSTBwMzzYHivSJhJKH+1VGTw2qYUXNIv/OkSP5GxqNhBjKu9JhZd68p2fUji214jF+MI8c08Vya2umrgWUm9tid4njMNAIjmLfdFI10aYuaPqwxJhha4t8UngvAxyX7uUMFyBwQahCEKHxonOqoLKzQZ8esCPMWkT5zKVuwbn0gWuuLxROgusnJyst1wuAFwCNUeiso0wQgDqYUWIKxhTnJFnxopLcfL74Z9i4CQBpkW4PzmsDstdxBAJ5GgTWOHd7dQq+SiDV86KOW8eJtbf5u2phMgv7AIC1gLY1vssg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(55016002)(478600001)(66946007)(66476007)(2906002)(71200400001)(66446008)(6916009)(66556008)(54906003)(9686003)(7696005)(64756008)(52536014)(316002)(7416002)(5660300002)(8676002)(8936002)(4326008)(26005)(33656002)(4744005)(86362001)(76116006)(186003)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?YZDyUeYHZIYVPJIeDLAexncwI9Le1kPaIDtUSqmXFXqJELFzs7IfaxIi/OfO?=
 =?us-ascii?Q?54uCVX1hiUuGheVVClmVypw+P4emOC7R/U7BERoIzt7ji7UkgSBcgjAniRm7?=
 =?us-ascii?Q?pz5BBWd2WwEi0c5Sn/mDIoIla9hOb93Rl/8ABCMZqkPZiOXwWHqyKhfpBeUB?=
 =?us-ascii?Q?49zVVGXwaXEXmMl5BEo4IAerEGMMXswWMIFGijUiU7kxz55I5XlBKJPV320C?=
 =?us-ascii?Q?NA/JgZVbVqMKdSJo0i6PSEoOj0ni8I9gMiTrSSdOvGFanVSIYGd1g8jY6AgE?=
 =?us-ascii?Q?EfIHY+ArfPKUf5PYdojMtIIRmvfmEpG36Gwbb/uCRCJbQO0Et52fO17NvRTY?=
 =?us-ascii?Q?OdVzVRetVC7gkxcbp2sGDWstr71Oxq1w42gkYPhkPtXdJPRzYSC1jcPi792t?=
 =?us-ascii?Q?swBRvpDypmb7dJMIcB8MUdn68rxciDcIMrAks8Mm0YUrG67cI7YeahkzWrIC?=
 =?us-ascii?Q?ci/bxoL9UYKquPTF7kcjpB0ifdbyQC9RzaRsIl0roOFDQSOmgdIJHu/3u50y?=
 =?us-ascii?Q?imqAPfpOYFKjr8btFK2PladP5h3KmzyqPRT5RRaZO9z5Zo0vM0hjeoPqHn83?=
 =?us-ascii?Q?cqxBOPtVHXayWlxyYQtfKVUQoWXc0NYkNmG2Ej57pNQKL4AEKnW2oG/hhFjA?=
 =?us-ascii?Q?jPiEWU7fUsmj1HVJr7f4n73Vyx+Ha15jtJR4qv9KagUnibCWWayrQLWH1+x/?=
 =?us-ascii?Q?6IJ6h0QsMoMEVPLkqYOimLQUuLkC+96SN+asWh5VgHYDIoasAtBRfdbJyiSh?=
 =?us-ascii?Q?xim7uMOELQireTbCJRPxOJfHePbJKvj1CmsV/Sdzs5o45Kqx4/6gX5c9P8KP?=
 =?us-ascii?Q?fvk0ccKitgFcLY8vzNWtcvXKNB5UMB/U7p+F1ZHX3JvW5GYMKk94OCp0uZfw?=
 =?us-ascii?Q?W61ftELqWibi7oA0IB6x4lwmbETqyQB+gnjjbY4lHc37HMUERBw4CXa1bJag?=
 =?us-ascii?Q?L2wwxI13h8RKXRxMWeBM3C/zTS1C5ndlFaQuDYP5AtcSkAE2pcA8c1QnzXxx?=
 =?us-ascii?Q?J4lqLhvA3fVYlk+fY6u2M0fT5RFdbEkojctpUw2fzBrdMYMFXQ9bMu5qTp18?=
 =?us-ascii?Q?/fE3fgoU?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e9e4f57-03e3-4df7-011e-08d8c76cf06a
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2021 11:23:17.5345
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 99d+zl2kxlIr5UI0dmZ5PvWsqFZMDtShhttgD5z7DugSf5tRATsiQLKWnJqmZ/1dzH8bESlw/4ymlHPBvBQRgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5354
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
>=20
> On Tue, Feb 02, 2021 at 10:30:01AM +0200, Avri Altman wrote:
> > @@ -175,6 +179,8 @@ struct ufshpb_lu {
> >
> >       /* for selecting victim */
> >       struct victim_select_info lru_info;
> > +     struct work_struct ufshpb_normalization_work;
> > +     unsigned long work_data_bits;
>=20
> You only have 1 "bit" being used here, so perhaps just a u8?  Please
> don't use things like "unsigned long" for types, this isn't Windows :)
I am using it for atomic bit operations.

Thanks,
Avri
