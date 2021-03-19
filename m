Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39135C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 08:15:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0685A64F6A
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 08:15:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234084AbhCSIPO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Mar 2021 04:15:14 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:18635 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234181AbhCSIPL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Mar 2021 04:15:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1616141711; x=1647677711;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=KIxeDzNbJQjltUY8aVfkSJ2yFlsrCJZo8OqCTxRjcXM=;
  b=HXNWqwikrE5tM65xe9bQtqRYIpd9mMxxXGx9qcBCEYjKZ5LFlSt+xSPP
   HEgwNSGKTRcUykKZv5lGfMDgrWiZ+gdSCQlDXSe5j3yov72+8mfyp3PhS
   sAEmrBm31iMlC+o0mpY8/406sRcd8ZT8Ayk4ZV5Wwi+MlVG8WShUMGFPk
   tuA7s/Z707us10d1kNLdvTZJQY/ZFRneyg25F0aMJuRFv6NaaQgFhq1NO
   dWMsA0PRGbI2uoa+Bry4AscTLvoTNGaNY6wK2MuQlJSjGbeIMTryFveDu
   xDfkmVloStDob60rRbhD5t9uAV1O7Ddyr+0/XjRse2IokpIM+vI47cyQP
   g==;
IronPort-SDR: raSR5TtYJCVZdDK4c6gThfatPllEMgYauSXkdLORPSVlvHijBEjsvTrAtUAvzUeRfGK3Fm7efT
 QpIu8AdvblteprOWLR3VTDcUDVEw1Emsi2hGeI96PlzNveGCrBM0GHyLFGMQMnNtiscIXJhsIj
 fOWF1GLjGyl0yyWLvjPrdY9ZBJoRI2eqcBKLLUufFtwcCu9h0pZfJa2ZmScDUvPsgc773ApfAE
 +3MBKKtty6DSl0QDieAbjoLmZeBb9ZAcYukJUXv7PncnGl+PetfxenabQ6etyvo73cOI3tImCS
 FW8=
X-IronPort-AV: E=Sophos;i="5.81,261,1610380800"; 
   d="scan'208";a="162538019"
Received: from mail-bn7nam10lp2103.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.103])
  by ob1.hgst.iphmx.com with ESMTP; 19 Mar 2021 16:15:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NzcG8o9OXTrdre8Lu3CqPN3IL0tOaEJFnVwmLpDhypL6OXXG+HT4XY9Pi0y2rLvo+g7buWmU41l1+XCBJrMRfKbZop+I8HXtGe0pNqw035ljyz046AYKwQeSxt1SmbVGTzV+Pd7Y9/ph5gJplUoq6vDEpiPxG5UxW4nsuXlc2at4O01i/cSg2d2vxJ+wk6i5GtFu+EpM32PT5tqHmeczj4MwCB2aRKBb8i26To4QSQXFNIyDxde1+QmFKU3x53bIM+8ve1OLJoGORJJixxbcGc8+k9lTwB3KvmP0cz4QJMnoZ0BgY+9b81AJk8NLzSSNAuoeV3r1JJdVCgL3jO8t6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SpEuWu8l7rzQbFXAz0gRuez2p3Vij7iWlfYGSTcfHnw=;
 b=OYWKNU3/0V00kTvHdBr6Oj86beOk39dC/gl10MzEbdfhtA750z2hJ0r2KhIa6HTO7ROWTq2YzZNbEAovZufZsNRjb/FtBRIw7ffDRzky5S7gjxfV8DC/6pH0Fk1n0rYfkzLiSB19eYGdnGKAGJav+J1cyo0yppyQKBDVL4jIQMKd80CkSU5B4W+bPEUrV36/+5qi7qhY+Y9Gpn21RbXG8b/gFYQJaUOFo2f637EX+Ebw/+CHkM4L/z/2rvFX5Wk7WppES29YBL6TrbQqyWNIc8pJk91Ink7rZ+dWlGYhc2w1jeyGPhHDz4z+7lUHClCYPH7zpggwOI4pATcGTgMm+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SpEuWu8l7rzQbFXAz0gRuez2p3Vij7iWlfYGSTcfHnw=;
 b=PY52srkPTTgV42DCpmHD/he3n/Igtrg+XlrRmAaVAv8XBtJLeJ/wCNErSVKFtkealjmb5dA9IeJE8pc8DG8EBYaSKmjg9CyIFfIHPlTF9woVt27HsA0AZt7ZFb5FHf7YM2YXhjz+Yaxw/RGBvD719o+SAvElRNuK28UDJgtsjX4=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7735.namprd04.prod.outlook.com (2603:10b6:510:4c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Fri, 19 Mar
 2021 08:15:09 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725%7]) with mapi id 15.20.3955.018; Fri, 19 Mar 2021
 08:15:09 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH] scsi: sd_zbc: update write pointer offset cache
Thread-Topic: [PATCH] scsi: sd_zbc: update write pointer offset cache
Thread-Index: AQHXFZJ9Ugg++iEKb0KOzcBTGpFywA==
Date:   Fri, 19 Mar 2021 08:15:09 +0000
Message-ID: <PH0PR04MB74167FA84C018D3E20B9E8E09B689@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <3cfebe48d09db73041b7849be71ffbcec7ee40b3.1615369586.git.johannes.thumshirn@wdc.com>
 <161612550236.18396.233058887900722742.b4-ty@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2001:a62:1542:e101:e193:b3c8:606b:24d7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a22c4955-0ca2-40e2-2d55-08d8eaaf1cb5
x-ms-traffictypediagnostic: PH0PR04MB7735:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB773532C183E8D25EFBAB02309B689@PH0PR04MB7735.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: C8J1S4TerGNKQb0obZKd/OsUN/T+mMgdozmLs6Ki3NORRfK3cl1Y/5x8RTvpYD6WLJjHx30Fgu3MB/qozQKh2BcfWbxWnTno3Pj+lIDJ68vf11Cl/WyXBzBboutT1ID/R8onVdmIS0bw0+18geU6IKfkpKIaZ7MOI5G0VYcUCD8NxfX0Og6EVaxYWwQ9XFedQHcs5QwBKsQl2HsTsHBrA+3xfUtaShBBs6d6zewJfBDtL6/aLBSzy/yEtNS+RyHyu77txDJyH8jNFoRqVVJeJZJSyYIRKynh9CjzV+k/AvbhVpTfLGtehS54pWYNge6mXp/LqpqiPT4ZI6d5ZJuU/R/LuehCoiPdo5jYu/ZMz5o0sYvhS/PVJASPI6hdWNhT8KBk38Gl9SWZvOfE1sO8ToTvfPN+sHZMjdtP7atKKzYQrmRxT77/+8j0+nbgVaYT+xO7uFtENYpAOtXuOdbfajnfPKgykG+YHQN4vzglGF6YufIBCGW54vQLWdp3cY2HLtxBkHQqKGBbkKnvYjCtgGVHtx6FTDlhgVg5SQHqLiHELpvpsOiqZOAU++zVV7SK9Fr9KFG1b8EjwiJq3bVEb5x8ul0Y78Ewfcwz2GKck5+A463WOZ/YdfOmJHuAl/AnL7vyrxo8wUFyJrI+aZpZZ6gU478rfYu09TEkm4cSmLcrp6jJfLPFB4ruVhsVARzgFn9JmYgW5f1kZOVvYqoMNVgM/Lw7mkjJySfdLV+YlC0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(366004)(346002)(39860400002)(396003)(7696005)(2906002)(966005)(83380400001)(316002)(5660300002)(66476007)(76116006)(8676002)(558084003)(6506007)(64756008)(53546011)(54906003)(8936002)(9686003)(33656002)(66946007)(186003)(38100700001)(66446008)(91956017)(55016002)(478600001)(4326008)(52536014)(66556008)(86362001)(71200400001)(6916009)(15650500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?lk3m1emYebVDheh0qrWbS20XhPs6dUZOD5QympNL7KDW6PgJ0kMmoLIfSnNC?=
 =?us-ascii?Q?lSqCOYbm7g09bb7Ch9H8rBtOCyUWZ11Cl/inniQ/r89XfESv6G3CrarscbYg?=
 =?us-ascii?Q?fjl2Ah1X4I8Mf7sNrYVQ/fm8thYlQfEyX2hJUiZgqRdffDwy0++rMJ0YJZ/s?=
 =?us-ascii?Q?0SbECocO70Zhqh+igbG/eKfeswi5vLxTjn8M3xxY3uaGQWy/nRl/2CRz5yfj?=
 =?us-ascii?Q?+Va4NzAeP4QRVfG6a/QaoCGPNoCPvQkk8q6KmW6Flfgdmye/t5Wn6Mq2TGQX?=
 =?us-ascii?Q?g712jVmmlONyfKFlssmEHHpPrp3jJfXZ/wPeYqzbBj9WtgDbLJwiYihE+fx4?=
 =?us-ascii?Q?7tZEk025lTxUyNI3fNTxz17TZCBmXKQC1kDnIhFVWlXvEmdrJSbCzDZYQPUz?=
 =?us-ascii?Q?Api7W0eWcrkqPm8sGdy4gn/Zu1iyFMl212DYkZG2eZW0Ty/ZhCBPLRu+a5Ov?=
 =?us-ascii?Q?liqqdkFTETCSJ40fg04Nxr6aJBtN8cA47H/vPMbs+Ms7iylE7GsiQMYOVsvk?=
 =?us-ascii?Q?/WQX/nyyPo3zHbGUusVR7U6vSe8Atcg3hCmy617AHO21dd0zGbT70p6/rGVc?=
 =?us-ascii?Q?A4956ICkrtSmufMhwoIZ1eZ2Im5nYH/j6L33/Q+mrLnLzbY8DlEGhnTBYndq?=
 =?us-ascii?Q?BIheWxtYvReM2NpqYV4eRup2nk2mqwnTwZH/kuj3sQ2z7W0IavE3VBjovUQV?=
 =?us-ascii?Q?Ti/qe+qzQ64xUaIidCBkNlxEXPBFHSHsBbfjoGNFTJ3N8EabLcT/Ks2RwNWm?=
 =?us-ascii?Q?R/pLD4zkOqFTfNBUgb/STu98u7J5Fit0hP3MhBlAs30rr2n1P8vBUWvlHbvf?=
 =?us-ascii?Q?caVw7ntweEXnETB+RFSHLmtDrsu3U7eNA2w39j5NjHfjkKY43ftzP7ECr3PJ?=
 =?us-ascii?Q?c168TGYut7BaE4XKuuinixGxDu5yiW5zEHlqp8BdmHGPsj3v6ajcfPsNOrJs?=
 =?us-ascii?Q?qovMMnWG8pYtinupbhaZDh7/y7TURT5F2vxfTiq7OurFuwP/Q5mfl6xobrgP?=
 =?us-ascii?Q?PclUWnS4rkc1mCWHJbQqeadgSN98Edae92R8PzQ/Owsf//+WTzFFpWJAkXXw?=
 =?us-ascii?Q?IMbq+J6kOBt6Z3FW/FwZcdba2ewXt1e9DKT8qIqLC3u/JQ0dv1WukhO/kRha?=
 =?us-ascii?Q?1MKdMn4Wsyb9d4PEgwELsB4pnzmkpMda0S6tvuW7JDl78ojanit8SHLKUU2M?=
 =?us-ascii?Q?Na+4V/FlnuzmaOGgE0woWmuGIX/1kZbI47pSmyuMgSfeR6Omlc+NTiBM72sU?=
 =?us-ascii?Q?wPf2m6L/Cy8lhqF5ETJLwPPiIUtpXMVjwGvx1keREgiM81N89FKzd664HfJU?=
 =?us-ascii?Q?KDQv8Mt1vWo/tg6q5DC0nqzkGpsgZSES7U4MpUOgg97e8U19MAu50hMaX9Rw?=
 =?us-ascii?Q?FQ4ZWgrjek8jlQW/3vrmC3cmuGRKfUeqLiy+unbxoeMUL9I++g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a22c4955-0ca2-40e2-2d55-08d8eaaf1cb5
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Mar 2021 08:15:09.3691
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v8/n5pT5yBJKTX3Es61uaibP1b2S8XDH8uQsY50JBqpbfYGKaWwLEfQq3gYZz4RRQVPaZds6UN7+i4MXWJUf5ly08eNOWXeNmHlW7Vm1QIQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7735
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 19/03/2021 04:46, Martin K. Petersen wrote:=0A=
> =0A=
> Applied to 5.12/scsi-fixes, thanks!=0A=
> =0A=
> [1/1] scsi: sd_zbc: update write pointer offset cache=0A=
>       https://git.kernel.org/mkp/scsi/c/2db4215f4755=0A=
> =0A=
=0A=
Thanks!=0A=
