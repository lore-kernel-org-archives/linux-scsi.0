Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C396C433DB
	for <linux-scsi@archiver.kernel.org>; Sun, 31 Jan 2021 07:10:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 146D964DD6
	for <linux-scsi@archiver.kernel.org>; Sun, 31 Jan 2021 07:10:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbhAaHKB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 31 Jan 2021 02:10:01 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:20401 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbhAaHJx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 31 Jan 2021 02:09:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612076992; x=1643612992;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bzgRxcTbLhHmNZGL1K38TeV6onGLxKRgI1G2PEz/REU=;
  b=Qt+nrAwtqC6jHRvawBUlf49F7JHJFmMXgqBU+CUHMbnQ8O0k4XziVG17
   x3qOtjGbPK/4BHYvkUA5ZGaG4RACM9DFbsyZsP1kbM1Sy5Qz5+t1avH5c
   k2UkvjXEzV/Ye84HGmzZfZfgmqF1q74Y3du+sdb31rMJul00M7+GiCGmh
   Bwi+91kk8a7ocwVhXm/y9SMHw4HjZielAfhPMCKR8kFLHtKrTFVzTqLxi
   3AbMzm1xh25pK/tEKYUYp3w7MgMhR8owQGqa4IY5l6sCTRleOO/DN9zUJ
   MECBaX8Hw0LMprinC7NOXE3xUreSzCjBoSTib2jzzYsKLeCKI+AxtFqsg
   g==;
IronPort-SDR: 5iqW20c56x8jzTcchfQqCYAS8sVJqw4ZkuSIKPU/+Wk9hmF+VrQWE4QpIfU6f1OZTilacA/nq1
 IATBuZnA+v/P3ssbAVFibmVW6X30kaCg0+phLs8oHSWFXQf0NAQTItZGpFyq5w7SVDPWBoHKRg
 M+t/NtIBM0GcTciHML7Yh23ddWfakskiaUEJ87No4gCqhRbLs1srtLy13zRErbzJ+oZwgdIJfe
 l7RsFEnmSl6BUkRil+acP2Pn1id4xgbc467kVCDq33XlmvpwURNqBxpyGVu+y3ztD2tp7zqkLo
 BzU=
X-IronPort-AV: E=Sophos;i="5.79,389,1602518400"; 
   d="scan'208";a="269130471"
Received: from mail-mw2nam12lp2042.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.42])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jan 2021 15:08:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g5AfPgvFcSTd17MSBLHkN5gz8hpjTpJppyRN+j6F8soK4oRKfTX2uloGFIpsfw44DTZ5eDI3gnkdHchu1z4Lk/jVNaIZ3LPPT0eJww8QeoRxxtE05UVHgqj/FDMTzZzpr7GCyk8gEUfjTsoDAgDqLETBek8kyw9SD7NfOpo7c6DaKWaKSA8z1Jn2qSKNVNmSkEXZaPRjm3TaLWZ4QtmmkHFIr5PUORGrMwFAcSlVUrQdy8J3O5V5VNlsQaHX1bp1umSk33eI+Rozmdmz6gIW2ck1wJHKA/vTgw9K0sKiLXTn1XDFpLm8tx2dRgFHLJv7bzTUfxOVBe4OdI0yBXbf7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bzgRxcTbLhHmNZGL1K38TeV6onGLxKRgI1G2PEz/REU=;
 b=BlFl7zVhh2HMti48E0C3r4q5qBkwgBqC0yxrTnFySIb5sHfMb71L1uQVcx75wZtBAswt6zjSsIGi4nsSAg4BfM7cohqYu7aZdCEUA85+DrVSDuU7spefbiVDlPe1z/7JWbqVFccJsWbXb/eu0l0g4v51+3tWd7ddk8NlGUIJKrI/fSzXcxxZFje56Tp3BV5Lr2purxWn0WiVLH5iTT+j4cNNPBKttMEyib2+8TDkRvTdWfFnB+whXGg5EAsVdNA9Rs7H7ygB2RU9BD8lKO/sNz9QM1hf5KIsvbgF0abX9nLub+evocUoGXx/lfSkQEGDRmRGL/JG/B7DmS9trbP/Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bzgRxcTbLhHmNZGL1K38TeV6onGLxKRgI1G2PEz/REU=;
 b=UNO4bV5JeskD5D+OnBPCnwJQe+vedAmhUB7E5AejBTZH7cCSimtLdPcwh5Vuivu/rfFHS8NjufrhsRY37x7Tv5GC9uQ3Zzm+5SORE8MQ0HnF0LIQ2feC/y81B0OV/130KVkAkvN+6en3bucza7sQ4xmEyBxn9uRHRJXBEKzFAz8=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4154.namprd04.prod.outlook.com (2603:10b6:5:9a::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3784.11; Sun, 31 Jan 2021 07:08:39 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3805.023; Sun, 31 Jan 2021
 07:08:39 +0000
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
Subject: RE: [PATCH 2/8] scsi: ufshpb: Add host control mode support to
 rsp_upiu
Thread-Topic: [PATCH 2/8] scsi: ufshpb: Add host control mode support to
 rsp_upiu
Thread-Index: AQHW9L7muSuASSb4NU6X1O7oK5DLM6o7llWAgAW/4oA=
Date:   Sun, 31 Jan 2021 07:08:39 +0000
Message-ID: <DM6PR04MB6575F3617C7767AAE046DD27FCB79@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210127151217.24760-1-avri.altman@wdc.com>
 <20210127151217.24760-3-avri.altman@wdc.com> <YBGEr4F8LhWpG81S@kroah.com>
In-Reply-To: <YBGEr4F8LhWpG81S@kroah.com>
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
x-ms-office365-filtering-correlation-id: cc40e956-7b93-452e-ca7f-08d8c5b708f1
x-ms-traffictypediagnostic: DM6PR04MB4154:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB41549515B10A551BAAC64065FCB79@DM6PR04MB4154.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zVl+LTNEGqx0dlv73YodOkVdplyk3bS1cHYftFna7lQbO4KCdGAP3Wb8wJs5TD1vrzYzlM23fGU/ioFJqBUdyPtEUwd1h22pfYeG8Ru0bcWKDLpMSASQpHiuuvT38VA0V45GpqkcgiF+K8ntMI8wqT4tWXkwiqLjpPklVXVPsX8g/Wv9/X/QP2W07bwQCKqxIG3erieVRfviLEBPmy2WOV1KwLyCrvM0zzB7KLWjqUzeN5FoQJH1hFCM+7Q+ki6Z4FX9YGDOTyBgi4PYLCVo0fuUO9zebju/N/5klgFL6zeQY/fDghlQVw4utNErFL9XDz9mPTsWr7+hvFlA0oL5LDS3xVzE8LdzY6DZK4KRsw2SKKQ0AnPpuIn/GLNsvMVjR+pj8v1o2o88YTc0ddrXf2005YDfPC7f95UUQEJbPvqZJ5U34Hyb3VKMfThY0THT0E622oV2+nM5zIRodfsE/djHkFZ2X5Q4L9m4CCcxYM7vaN7HnbHBCoRZfiJKjG/GZxN8u3sa4SorC9/uP4cmHg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(39850400004)(366004)(346002)(376002)(54906003)(6916009)(86362001)(6506007)(9686003)(186003)(478600001)(4744005)(8676002)(33656002)(66556008)(4326008)(66446008)(66476007)(52536014)(316002)(66946007)(8936002)(2906002)(64756008)(83380400001)(7416002)(26005)(71200400001)(5660300002)(55016002)(76116006)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?efMCGE+HmLcYPj1S1s4EZkjvhRmkHGXsfNg4XlJBff/LCuyFttFp3cEfZdBd?=
 =?us-ascii?Q?42XZ/jHDTGWL/k1QZBCt1yAat1sghnG5k7SpUk4jIGbx0axcsYceLOTHUoYu?=
 =?us-ascii?Q?0KIgfxYd9/iDhFtoi3Z29+3LZKjtF+ptR68r9kkSlXvXdg3QoOgBJIuJGglw?=
 =?us-ascii?Q?omwRJAXtFIlUqQUkJZMdzsSSxBJI8m3EsVzdEpxBPixc0XOdIIe2Rg5ZjVEc?=
 =?us-ascii?Q?6sX+tqhuk4sh9OQv0femNRsxmOomLQfGPtvmRLXauhIh+rkOJH2tWnCuS9sw?=
 =?us-ascii?Q?7jgsxy+Ir0dRwJ9cW1pIdL4gLagcFlD6tBbOO7PLZbX6Z/YkqyEtGjxpssuu?=
 =?us-ascii?Q?9jspJNFOVLBkYhJO1EF/LnFncMCZg3aKIT1ysehpnyauMmqBe3PvzVaIQeVm?=
 =?us-ascii?Q?J/sYMMRh/a2wWIo+wfhl9352vyekm5FzcShNFDkQ24fy6n89EHDYuEp11pDN?=
 =?us-ascii?Q?gYllsjwJOy3qyScdwAWaw7Gm5riNVY8PuilGDc8tx2SLMzaNMZ+Id5fQ2kR9?=
 =?us-ascii?Q?2L5H47W6Im/3QRwL4Xf8ryPoMIiuOSOChPo4gGCOTERFe98ho2TLsIyr+Z3a?=
 =?us-ascii?Q?nbTZBdiLImc/vK0DKFEwB9pX5YhkxP2toO6JHxeZmch0Banptv91mfYgINB7?=
 =?us-ascii?Q?0/oCnB7t8FL7S7NkwTA7PaZ/o3KYbIJZIYPOnWKetR0w58BidbMP3UZFPuRX?=
 =?us-ascii?Q?6WA6lxgWDw2c9/p3K/ZamqAaANhZ1cOQ2/qDHLxlzrgazavdBZGB5rT7Hgzq?=
 =?us-ascii?Q?gRZglcECEzxa1MLYamI+UaV/a5o5BLNWkwFn3RkV1aPsOkqI8Z2zpmBOwCl0?=
 =?us-ascii?Q?M6Uq0BaCdx3HiqYNFr/T+B/n4LiUgf3Fai+0aF2kMOYr+p+6UjY97n3IAKs+?=
 =?us-ascii?Q?SzGF5Q4NBONNkplqWk3a4THJdoPEJht726e/Zw1F2ui1BLtKDJsxrBLLsdpB?=
 =?us-ascii?Q?dGbWCpE9LOvL7U1fUXgTdtPLsKBrV+M5RnxnIwNv+JERHcyMNySqfYyqGMzE?=
 =?us-ascii?Q?JXio/pnQtnWnUP7Vf4SRnIHKlTneZMY2HwBNUjpzXqvRJO9cdpKGx6ff3SEP?=
 =?us-ascii?Q?NMsCwZOm?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc40e956-7b93-452e-ca7f-08d8c5b708f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2021 07:08:39.2118
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qbeLSQthsg/x9+rml3HQq3VahSMr6gT5hnMuCs8wte5DG64fvQsYf7hHyHlV2pbiEbKRs7HonM2plBHqaZEtTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4154
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
>=20
> On Wed, Jan 27, 2021 at 05:12:11PM +0200, Avri Altman wrote:
> > There are some limitations to activations / inactivations in host
> > control mode - Add those.
>=20
> I can not understand this changelog text, please make it more
> descriptive as I have no way to know how to review this patch :(
Done.
