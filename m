Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C785CA5536
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Sep 2023 10:25:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234854AbjIMKZQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Sep 2023 06:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231998AbjIMKZP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Sep 2023 06:25:15 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61233D3;
        Wed, 13 Sep 2023 03:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1694600711; x=1726136711;
  h=from:to:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=Io1X3LolmHxKozSD6JEPnIlxM2u+MAe0OigEtyGP/LI=;
  b=KSIRZMZ9TbzVfjHto5c869N4VVFBCDlYWylgPZqglAOuKzPrk/KyZ/ly
   LwgSFup1s6m5T3crnQmRt/r6XOpdA+66lsx1PBRRgIqQrfbJYU3U7w95x
   0qLISKZ5EDfBKasHYEEKHKe2JW8L2xOODdvWPuc1aaXqwnDkvMWDUUnxN
   Z+4FDlA+OFDLajE6+39Yzu2/wokrTm9LyNoQa1jhxg0F1r23CUl1nnA2M
   ozxbYnTE86CvnHoKMiDAl+29IlBQ0zPG6tSMfZQhzsGkmGZqi0VdhtNoW
   EB9KSEyboj/X2H90GpS5DGEHDwT/zgGLJbc5RE5GnRwp6lR/BW811OxzP
   g==;
X-CSE-ConnectionGUID: 9CMmP3/XQVStwjCW/wc7jw==
X-CSE-MsgGUID: c8bCzWnXRZ2E9q+RClFUPQ==
X-IronPort-AV: E=Sophos;i="6.02,142,1688400000"; 
   d="scan'208";a="244176767"
Received: from mail-dm6nam12lp2168.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.168])
  by ob1.hgst.iphmx.com with ESMTP; 13 Sep 2023 18:25:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hjy89qm4sbSXIAVJsQ1hX3t6x0djBwwK+3xG8DIMAB5jVnl/FDJaMOokLDMNsTRWIbIiryMiXjliTegXlp2e7PavS3AKLa7DvWzLvrlWQlKQ0ynXuF6D+AWzv0XrrokjO2gmKRaD8g6CoplFvFyrjdW1deJoTnEySa7sTlBU9Imh6mpdMVU5LIUDr4c/Po34K2MQi0IYnXEYOKeb8Kso3OzShbV9Nn3goNzNDnv2n/HDB1yz3xUNk3Ai1jIuqmODQh3Y4sYkJn04Ex3dySV6wkMFk0SRcoSr5RpT6ASDZ64BnWlAF+1MinZEdQ8jiwIBDZEA2TOLy1hjbSsoZlRlpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Io1X3LolmHxKozSD6JEPnIlxM2u+MAe0OigEtyGP/LI=;
 b=gIz6KBqH6OtpMZ6QaKatFnLuDbczg1P+s6m2AEe8vGEtjxYRoeot/V/3qxR6nk9AgiAI/tD/j6ojfrlgKt2thGuppFEEzOyGRZXi5FMV54cFAormNqWbVjUz1MWtRMTDcd+XNMhJvbuBf0kka1IkbmPkmsErk/7wvHZT9IrbyVJG1NjAUc1dAg03qoMlWHgslqEA+7hny2LmqR4+MHF5UeEPsouLQ+MF0Fh+jvwGOXAhAcD4q7/HGkkZgojxXAaNdDt3xD4Q8YIFh8JbLUHL7DAqOghXrrpEeY4AEWafputQ8pX4wgITh4hTMmxgmuOvTZqT1+Wt0EPEUhaogNVx3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Io1X3LolmHxKozSD6JEPnIlxM2u+MAe0OigEtyGP/LI=;
 b=aKi1o9yrf1bhb3pV6LbIxUvGDkbuLrFHOUBB0pDDU4Gw069mytkMYognwBwfcartV2yQ4uGtza8o3m8nfZOV2q0ctKPL2KZsdxSuS8HlB1SJwuRngBeqISzdNpt6nWTNPudOsTHSJw1nz5Hj1kOzIy7LEsrHSfKyM3vLVbsYJQU=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 MW4PR04MB7138.namprd04.prod.outlook.com (2603:10b6:303:64::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6792.19; Wed, 13 Sep 2023 10:25:07 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::f92a:6d40:fe94:34e9]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::f92a:6d40:fe94:34e9%7]) with mapi id 15.20.6792.019; Wed, 13 Sep 2023
 10:25:07 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: blktests: changing rdma default driver from rdma_rxe to siw
Thread-Topic: blktests: changing rdma default driver from rdma_rxe to siw
Thread-Index: AQHZ5iyRs4TPZzRoFkGPI1v+IqhuaA==
Date:   Wed, 13 Sep 2023 10:25:07 +0000
Message-ID: <jcdxryo6o2qbj65m4haw23smz4dvm6a7j75uho2l3u3qmnsgif@ix7hy47uqhw2>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|MW4PR04MB7138:EE_
x-ms-office365-filtering-correlation-id: c5d1695b-4aa0-4961-296f-08dbb443b3c5
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8XtS3ve9f56a9OyHNVyIXw5g4IVCj9REbM79XIvBEYfB4sO/+9zznY0Ci5fwFByvB0fQ+aqhrFNeTTvzl4EhEodccCar1Je7iIS78QjC4LHw1VqgDDAVcbaTF6wx7ZonCVPT64KLkPv2leHa6VSy1SQSTwQmJS/Q9+z4yrwMaMfn8wGnGvsb9YFSV0ehcwArcLdA6kAmfVm4BE/xqy7t+9l/Ia5ZPSWObRuOY1/2bO4K8o25Yv7zzuOMmMH9Q1Nl/NMe+pUdWTS/OS/Qp0bZT3j9qQvgoFXtci/SSixtfepH4FYqcXUwKNPYE1l3M2sZNa6odBf93ghRyG1Ou14qk+3+Gtks3MrHD/g+UzcgYJs9xeZh5g4WWD8kmdsIlR4YkEXaaElxHypN3fUVgntkVrWTgrT653etR1nTlEv4CF10wqCZTrRRVksOCrTliRrBiHUA3TwhTKelIGnCc+c7hxfI6ZKIWCs6IXsj02GOnGfDQo+zwadoefCbqstRmjCpJdBKTIv+yuJa2kgVYCN4msf6lzH9W54M+qD0ozorUBXIIJVGhjuOJ/BzUT5uGAvIfGhmdllZppyCCmE03zaCx+V7W4DFzSlYXWBcytChnqNReEWaJ1e7uQNeRjOLhoAYvkj3UhtVZ/i6KnAK+b1Leg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(136003)(39860400002)(396003)(346002)(366004)(376002)(1800799009)(451199024)(186009)(9686003)(478600001)(6506007)(71200400001)(6486002)(966005)(110136005)(83380400001)(6512007)(26005)(91956017)(4744005)(2906002)(33716001)(41300700001)(66556008)(66946007)(76116006)(66446008)(64756008)(316002)(66476007)(44832011)(8936002)(5660300002)(8676002)(86362001)(122000001)(82960400001)(38070700005)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?W582ZKxKvJpIOxaXNgh4CF+41M6ACWNPc0nHsVjH3r59npPeAa8QgIwk/KKG?=
 =?us-ascii?Q?s8Fz5Dyn1yhkW1HblCy394hJVUa2izXrnVspaPI2uUiCO6kEX8iOTPXhkSu2?=
 =?us-ascii?Q?Y0GHTYt8C0rQsd3HZ8DtnV+xb2mv84IVAX8TauoZ5mYIEtl/ErrJVh8cnqJV?=
 =?us-ascii?Q?0rnn1UNreBftFQLdUWA9ynZnaloGRKCr1+DTQa0Xnidnu8Sjjqv784cQxd5C?=
 =?us-ascii?Q?jjW4QRtKFHxZOuIivi3FxMrDApWA3yjwqz3wfjfSHKWWSrTgiZIu2gRugRF9?=
 =?us-ascii?Q?GfRF4nJDY0nGVCkkBQouuAiiuU7qxI3m9GT+5H7G3sHS80ipK1/1SrtTCgvI?=
 =?us-ascii?Q?/50BWy3ZGPr7ioaR3W/+Ae01SH5PUNRQJZgnEZLE8NRVo1DSOrIhIaNbgxOV?=
 =?us-ascii?Q?2GT6VjNisdYwC7m035XY9OeDuuP7ohU1C2BgAZ5GKvFK5qhjtCBy7YHqcEEa?=
 =?us-ascii?Q?CAFEhyLdNFUnTtU+m8hcXgsEgXjVe9hrHDpufbF2t6TbUXSYoG7eU7gTgBUJ?=
 =?us-ascii?Q?3izs04Q+CicWi2brIs8by4HWfR/sPyRW27D6V0dmqQe2n3V4MeAltqOiZDBg?=
 =?us-ascii?Q?pTEzq549epsST6dAkc1xLA65BCbInPq6cl8rrO1dzinxX5iY0Fy9pTIAhJpd?=
 =?us-ascii?Q?YfAVNSKGCCcW/+vw+BGXhKdLCwt8ElepUoVAdHsUtbwkqqwy0/qG09H83OLN?=
 =?us-ascii?Q?1Qb2Aado7Dk9HrgLJYrrMz4/0MF8xtXZOENL75vU5AMKVQ1Uce09FFvdMRk8?=
 =?us-ascii?Q?tYOaHjwGjHYuIIX6mVoCcQY8y3/txfYDkLItbNumyp9K9SkTcWghly2HQFX0?=
 =?us-ascii?Q?BnDJsYSdIXO8WayYjbVvDJsFNLxr8gdUtFDEJTu1k+nvQ9xC3diWAceZHONz?=
 =?us-ascii?Q?C9YHrl55d1AFL2DhYhT0RXOWkt2T9sJh+JAYruTovP4nG3yFytC/5E9Be8/x?=
 =?us-ascii?Q?OtycT2zc3mXOmPhFLoNpD/cf2fhvf3VhfGw5UvK5gw3ZmBRu5XYfcc63u+yT?=
 =?us-ascii?Q?mURfO1fL+LJVnGUCMDhAGM8CUmhBJhDMbCVlaPEdL86HRLLm2zLoinyCdugW?=
 =?us-ascii?Q?WhrUk0re65PfmFwatLFshbxwe67uRdPBBDaoqRFeNd8ZZty6Nshsf91LBwkr?=
 =?us-ascii?Q?E2lsR+3Kz9ORIvqvgKFMZ87clgZSN2TZ+/pRlnu7U2h8WTx/fP82GLI3LOO5?=
 =?us-ascii?Q?w5Sm9BNEdKDT0GFe4png6yZ2z9VG0bk94cnJMQlBSwKY2HmYgvkb/S6CQ4M8?=
 =?us-ascii?Q?yNxFy8wo5hC2E9T92jM7qDMAHv0qAp50dG94At3hG6DSyJzmTa7fLq0SISg9?=
 =?us-ascii?Q?syfEbmoQX6tcAioFqhGRIH1WYWei9bbdBtE6bkNMW3uKVOVw8tyTgvh5SCp6?=
 =?us-ascii?Q?a/GqnlRp+0ul9i24G2QMDdAawFNMNZzfFGhts1sd6jajb5dZKmifoFf3gbjM?=
 =?us-ascii?Q?c872bAG5ChDaEaYL4yy9E3FEsQAGC9/oeXPHIYVYq2gY8u85iy89uaEjHWBh?=
 =?us-ascii?Q?NUbXnikFHt7pOLz0F+n6etIxNaI6r2BV8IZ15GfydAZMOalrWAhCKFhmCAXk?=
 =?us-ascii?Q?Q3Q+y6iEe8EzuZrtqXgBl/lXVOMHg2En9EW6TVHzuqb9+Y6DYQDBwST6OExM?=
 =?us-ascii?Q?36/DhlTn/puvyUAmXMsivAY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6B0BFA5FFC0DFE4B9D9D60AB50846AD5@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: lOVlriFBDWwsvpRH+y0wxW5gjzPNWBFbKGREg/wPNr+dJtRsWpFVc9jmW2oUfpDaEi5DCqFpKYKP5j2gNRZDMlF7HaVPIUlYFj2lYCf+rZP23/lcRY4M7XoegASA5F9rX6asgzCrTQEYVphBEZ2X/c9Cg9o/qvU898pIKHis/Ih0q0uszY2UaQ+GMmVubrAaDcH9+xS1wqja2wtaH1lXX4eBzhNJlaxsPEg4JbGsBou1anRA5gvHIDhNTShf6YYALCvEnAuVZ4AbEQpdQ7F18o0UK3hxVROyzwKTNyi/UhGMkvCZMwhSyqLYUxkOzrvoWqjzMCfD2lQQbb7RvM2uWl6aFp2Jf+HrthUlKzO3b+mSf4A49limbGbzA5aTyVkS7dn26VXIrPZahJgbfATaXbBeOlj9M9DN0LpHKLCBVLm9X/183+w2IZDvQkhUAsz+2ba5ziTMLkRRiNU1LzkaD5dCj5C5+GidF5o8yQF7pjzd0sip6izmFyCnTwFL9V60jTz7WS7obF2oSwg7bJ1pt4+EwjgtZnj8AS7em3NTXfftEWNwzcjwgZrH8aLuSbpFYZcsLGAzzxwfOM5lZZPfLM9yZemyHR3abW5aIeTHD+S4v7eA5FUfUt8sbdD5Cb90WUOihkVSTISORQMxkbiu/YCkHKFChjrIOp4U/gU2cwdf9ggvuVJF/xKBN/pO3KXrfLvUmC4A9uJlfKPDBwZlawny60k+F4ZcMOTmKc6V9r0VIYkn0RLVkrYPQYmpsLVqsXK4Qgyp4r+15o5Nzb5ILEFXWzXWprbvREnqriPX8SQ74fbw7ZZn7pFqtwpdWaG3BtIQU0aeZ4aZ5A/4Cgj0TQ==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5d1695b-4aa0-4961-296f-08dbb443b3c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2023 10:25:07.4646
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LAFpBlpGx3Ja65ExKMC2twYTBkrzuw5nZUKvUgw3JT7EAvbAvBuQGycwoc1XQZoD0ekE3VTZe3vz2+EPeKETnHi00jXv/hdBdtvYskcTlUo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR04MB7138
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello blktests users,

When you run blktests test "nvme" group with nvme_trtype=3Drdma, or "srp" (=
scsi
rdma protocol) test group, rdma_rxe is used as the default driver for rdma
transport. Recently, some test case failures were observed with the rdma_rx=
e
driver [1], and it is being suggested to change the default driver from
rdma_rxe to siw, which is more stable.

A new GitHub pull request is created for this change and now under review [=
2].
If you don't care the rdma transport driver choice, this change will not af=
fect
your test runs of "nvme" and "srp" groups. If you care the driver choice, p=
lease
be aware of the suggested change. After the change, the config option "use_=
siw"
will be obsolete and "use_rxe" config option will be introduced.

[1] https://lore.kernel.org/linux-rdma/8be8f611-e413-9584-7c2e-2c1abf4147be=
@acm.org/
[2] https://github.com/osandov/blktests/pull/125=
