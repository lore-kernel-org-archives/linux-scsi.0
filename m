Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D24FC4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Nov 2023 04:09:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344554AbjKAEJv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Nov 2023 00:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233077AbjKAEJu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Nov 2023 00:09:50 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD6FDDF;
        Tue, 31 Oct 2023 21:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1698811784; x=1730347784;
  h=from:to:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=5WgMviH4BcJ4UlWkS9Ei4+No1NDgff3MmSG/UenmKLA=;
  b=FAs+YIhs/vRzK/YCmrZ1fXRZUtp3PNWV/ZL7e4Nfzwr4YNcwiw4OfX+T
   jPXxzoQaEQkt+QNsqRx6q34WjJNrxXvsWcNtplVjbPkWJFmVwSRusXrwu
   shs2Db1QmpnBUJCA6Hvfl0mKaMWAtYjUigqj6s3W7Un3k4YRKob9EVhQP
   nxG3Kn3b7eSKm6lBU4deWEHF3AmZcboDFvmJFNFN+dhlKUdd+UvdyzleL
   xGFaykTya+WX2eZOpvXYV4CYM3Z4zw0oqlBCGLooX14UIMd1BVEMRVuN/
   6VDpEfmck9qZ0ULLknQRHnNQoKqc4rDxTD8flSNqgsmRbDxGweT29odv+
   w==;
X-CSE-ConnectionGUID: +WGJ7+pJSBSEtgzAlYKXRQ==
X-CSE-MsgGUID: 3yxtEuRDSJ+E5yHUesxGdg==
X-IronPort-AV: E=Sophos;i="6.03,267,1694707200"; 
   d="scan'208";a="1095226"
Received: from mail-dm6nam11lp2169.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.169])
  by ob1.hgst.iphmx.com with ESMTP; 01 Nov 2023 12:09:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RNLUHxFL5fJz0vtUftrl995OYofACvn8BCeZtDZ2dQR5OkYJADyCswXDgzltM1fk0Ti5vUcC3T2Dc7RiFH+GWRRWgxKhxJ71fqRvmguM/oD7ZGt3WUpikr3AJFbcV3Hi8VOSJDHsDXJSDzb+aqrIFIDtW5WlZG4T8kZd56f5zTNmafcf0jos1lFl3w+KDuoR8xLo5JhKiMO/A0d33xrMe4VEzlR/XCD1pvRgSRitkzPKJ2pZtdrPLfKGzu/JGHh80x5cpOT6SZM52EHchXpfBBdOt3wgTuXo9pjeVAVC5ZkJr7l7GnfodfezziW9UvxY0jJXyXeouPHY0qxMy48S7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pfx0hXZeSWu+Uqvbs6TrZsy9cJhGCHfUgrulaPn2iKQ=;
 b=EHr9FpwWireE2i7xdYI5EqJ0WhMULs8n6yxJYTak4iiCaaqVn51sCZWEyya4qnNtZTAD57LoFce95H659RFqoa2X9xtup46iwJqQxOIM3xhgkdzSELep5XgvnQucXyxda8NtgT761fmZnkLgfkffAPovMycvb1bm/NikTiGGC4Ab/bCU10PTZv1FC56dkIh85dozEBIGAZb0y9046/GkX9I2UHfnkjEzC8MilgKl1Bku+BUBedd9pu3xp5mu0vR0q/yRyAtev+TBaPsn1y8rTfB9acDHV4rM8vCeOoVwjCRBhcwpFjFuLQaijRe3/gdFrpAtYltVVBrOALHbofgnDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pfx0hXZeSWu+Uqvbs6TrZsy9cJhGCHfUgrulaPn2iKQ=;
 b=LMyw2gloKw9va1ydvVvlxQk6OttqIh+6H61PJdWoNDoMUM4TvTdjZndGa84koia/btvfAmzvVv811WX/su1Q3J3e80TbOrfKtDOtMDY/7LID+7lntBKl5x51P4eMTHPj9cTh+k/3ojfMFcOuEAr3FDDzZbtBr6IHUoX9off5O/w=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 SJ0PR04MB8514.namprd04.prod.outlook.com (2603:10b6:a03:4e6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.22; Wed, 1 Nov
 2023 04:09:39 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::2256:4ad2:cd2b:dc9e]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::2256:4ad2:cd2b:dc9e%3]) with mapi id 15.20.6954.019; Wed, 1 Nov 2023
 04:09:38 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: blktests failures with v6.6
Thread-Topic: blktests failures with v6.6
Thread-Index: AQHaDHk7/Y1dbpXpUkmaEvYMjkxaWw==
Date:   Wed, 1 Nov 2023 04:09:38 +0000
Message-ID: <6qycihftrxsdvuvpsvmkbe2swy5u2isrtu6jiyf3khzusdzilc@34kda7iutwdq>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|SJ0PR04MB8514:EE_
x-ms-office365-filtering-correlation-id: e8584477-b580-420e-1724-08dbda905dde
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ocYP7tuSrMV0n63mygGTtJ9U7J+QQvRG6RCXYNt8ByCEDpRiew7GlFL36y4DijbOLPJkITIpopz6IwGp+UXMT3ZHNOkcPQQ2XE32tjd9z7mK/VQN3RghE6z7JAPlLdIO6xHd3CBk83dU42Zedy6L0BzLAxGcVYqUghFJ6xuyhwkdkq978ZOiu0iHuZ+yUnm1/fq7/nKImP+1AO2/o9yBNfaFqjHhMyiSaw3R3cyJj6cq0ydlMJwFji91EaVFV3u1p4jBpYSJMNMzzsAOFtAn7VU8KNWVCJE8Zjw8KwC4rEpIddL+f0eolo3POIeUkhfDbqmzjWruhLX7NoMZaKDzkfehC1ZZHsja3Y70AoYXH005gvMOnoIkHOlbhWHAJ4AElepkBk/WYPqa/0nx9VJuD/+JaCVUYt2Ae1uH6MM0qY7mKLPY+lOlTGd3w+/J0i7qe5Q9pZx5iSxuv/hDOdApe9tSd8VTKBASL1R5tkBrr8UFQPDQLm/yPpfnq70mlxHSFFyQOy4e69tzdfWEfZSix73ZV8A5HfFO5SGDegfPsLGAVfkMrnq9VD/m8lYrrOkK/roXWfu+upPSuVfNezmjEuexMdaI4gbolLWzSqV4lVkEPFRdXCOoFe1ilUCQMlYla91ktTns9dCc2oGccAu76II0AhXCBexBuv4LjtoVgx8JVUJdFV3xoFOyBvMsjZnB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(366004)(39860400002)(346002)(396003)(136003)(376002)(230273577357003)(230173577357003)(230922051799003)(451199024)(186009)(1800799009)(64100799003)(26005)(6506007)(71200400001)(38100700002)(82960400001)(38070700009)(33716001)(122000001)(86362001)(83380400001)(9686003)(6512007)(316002)(41300700001)(64756008)(66476007)(66446008)(66946007)(44832011)(66556008)(6486002)(5660300002)(2906002)(76116006)(110136005)(91956017)(8676002)(478600001)(966005)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PC3af2y7i9l+DnkiZhNUfCOYancBfs26aIYxvhC3GSP38Tjeko5yc0/WQDZC?=
 =?us-ascii?Q?xhqOpT5U0siYZ0XDPYunguCcgaZsbYFAm66gpDpWhJ9EY7pA6v5oWmz87yJF?=
 =?us-ascii?Q?mMAofm4SaXppTByQbtXvfyfTHPPnIuKdQFh6hXS0sa39HLDA5FG6+eb8VO+d?=
 =?us-ascii?Q?I+3TY73bFiH9N0lnuTSfYdecWkixgtbiJP3nti54cxfnXFpRLOyxtezkMS2e?=
 =?us-ascii?Q?3u0ZDBOkk96IhGoLc2+gfOxYsSqOfQVxBGduXdKrK2z7J6tC78dpwKw48JZv?=
 =?us-ascii?Q?hQI3ZCyi7DyOvm1fcqP4OV1WMLWWPL2IHstbsSsiYji656MMwdmcYQKPdI7W?=
 =?us-ascii?Q?hJ4DhMQ76FFwRjGKtt1HZG++hUVPMzlWOOsfKjWEGLIuLpxzfRmJWbyxZ6Ef?=
 =?us-ascii?Q?kurFRXJlCX0zslziwwvoN5lIJMKt/TnaRThxdMezh4hBH/M1SEF0RHbI7j1T?=
 =?us-ascii?Q?r0TbQ+096M+lkpzR0ovpOz7wOV8AJCHrt/4e6EmKJJJ/f+YGMIABZaCz6YMy?=
 =?us-ascii?Q?V/7drvdiSQ3DvaJs54NxtiBgkL5OhnK6UmwBeZzblYLg8Nc0C915xjdkW0Kh?=
 =?us-ascii?Q?hMZq0UZp4+4TJWD3znaS9dbLJ9Ds80feEcVjNc4mG4ejCJiKJnoyT/gJcSyi?=
 =?us-ascii?Q?+WAHoNstroxhWDtoD0mQFM3dXLihtYqD6H5NuAoTlilcB4b+YsJlMNbVgaFx?=
 =?us-ascii?Q?5LN9E5vg78XLfhkJ3BobWYbxV2IHwCtkgIU4MIs1rxhMdblR4zL9KwqU4+bx?=
 =?us-ascii?Q?6Radzm2zOxnaCk/8WAPCo8McUmRaL9acTh9qxreawmBSOJHTZVyVvcGBIvaF?=
 =?us-ascii?Q?VMhKbr5/FkyBA+ADggihmSM4x4Hwyul5oXHrdNtYyyfCAoUvz17Szo85vqcV?=
 =?us-ascii?Q?7ZPA2G9ah4UnLpBPBmXyS7i1Q3Zpt1FBO6am8EXOJe7bnO/3LyL2lAIByrpA?=
 =?us-ascii?Q?zWpY3AMrTdfEWfGmP/1wHTpYEtCM+lGhRBx+nA3rPgy+xlK62YySIgAodyUj?=
 =?us-ascii?Q?5WQ24MlBdJKxCdsNR3y/W3qhkqRyFZsk98/bdZOzK3MjswCusMjF0TlLwR66?=
 =?us-ascii?Q?8uyZKUStML1b7eVsgPIRCwPoYFZct9p2q7YYHv+AVL4kOSv7IebOm9WX8RiK?=
 =?us-ascii?Q?oq8gfnO1ruwxIi1x2u6nH05C4f4YuqpjprX12AvYUc1ATG1W6e1HGYhPER6g?=
 =?us-ascii?Q?Gve6eVBhb+ujR3KGwzyh6CT8CeTShsQeWyo317pmH6eSBjBNOrqCuEfmi4AD?=
 =?us-ascii?Q?+yHNUDEwvp6WXdcaXM20ivS8ZLh9GgDRiv8A+fjEZzsgJR+z3TrPv9UI8EM6?=
 =?us-ascii?Q?6gEodLGzHlda/unzd5uO8ZWB09yHE7gVJZNc8Rf1IWI9wYJTsG9XzLEbXLHo?=
 =?us-ascii?Q?DCGIU6w/e9q162X9QxO5eytfkwM/+O0bfSKQ7TmBMoPCA2djbZt0VcJofGec?=
 =?us-ascii?Q?7QAEH+hMG1oJ5PnwXi5IYniChav1ziX70kgro0eVK7zpVR/rpyFUxWfPIgBQ?=
 =?us-ascii?Q?z3oHQRbTzAGLaMlS6mB71FAx9g8h5EopLwIDO+JwMR2vCXVTNjJGWMcCNrzc?=
 =?us-ascii?Q?hyGd5GuSBtv86rMc/jNlK3EoQRnD2SXbABJlvQCBGi9O0mhmtoRZvMa2hbM3?=
 =?us-ascii?Q?cRwUDdnN+Jm5Rr5JXYiqiK0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A1C943B30AD71C4DBA01A9A319AEA696@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: NgB3f9KgmcjQhV8wGiddncWDAwahT72AIFJqyDPwFwiAu5n6NaQvVRwELpqeODxPvoh1bjPM5lddZPEIX7/lKLbQatfUZZ4SrKRRKcZ3VNX6jT3mRW7/xGXkPASGuCC8aptw9w9fCsYnGuxuZKbVgRZUJM9fe8RTU8Mwzm5188px9/qQm0pVu3ijt705qAdNtcsZXCo14m5uzaDruDdKb9PK6RS8a5S1CKTT19dolgCauPBrpryGjOZiPLdFmHd4wgmwNlWX3o5eefbEoK1frNVylfU3Tx2S9WgmSXLkmtSPAy9YN7Hbf138U4lrVGONZT/2nXtrFXcPYP4H9MYLo2iS4ETt5TMx4zyCR41v1ACh2ayyvaMK179ecUKdU3DIqv8DCaH8YG7CE7Q+NMSLKjN8L24R2mNp9HNFaLXBqxdaaglTKvNpEYK6W6dX3RR1m6RdJxw0R6zNYCWeUuoJaH632O5q9AiO7x8U8NG1HOCGhI82OJiA3fDRa+cajzBtgx2vR1s1d/aD0g8lPcTwspgnDXPpSU8bCJpdIJT/fo4zCbNDbmn2lf26+fsGuc77iZFXZxkJrzpkBpxxz4lfgCLsJKlCYFeVkGNDUkgPtYrdJ0vLeDByobaAGYoQFjgIky/rJuruKsrYLSo4FUUgWGwWNykuOK7XQ/oe+MMRFR4xbifGFUidEztoHKYStmzqbA3012QSW7DPvFLkvGfWKOuw9KL4v+1frYF1QGhoGJ7NBgZJEeeWjOhUfoLNlPPhv0N6MWxCYkUMFIoExHiG+9u7dw42A9glyTWpYyiqDH68Lb5cP5M1PbD4eG7XYE09J+OoGxORRK0a4eY+dHcg+Q==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8584477-b580-420e-1724-08dbda905dde
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2023 04:09:38.7594
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rEz3mSifRNlaFKtps0zkFt3/0yE9/Vn+04foL6aLkOJQH11wFO37jvooJJbB96pw+msTsx0jGTrT05oEXMD3zG7Hh/kLfZjKyUIRdNSub/A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB8514
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

I ran the latest blktests (git hash: 3f75e6241f6b) with v6.6 kernel, and ob=
seved
four failures below. They are all known for months.

As for the two other failures observed with v6.6-rc1 kernel [1], they are n=
o
longer observed with v6.6 kernel. Good.

[1] https://lore.kernel.org/linux-block/u4g3jh6dnowouthos3tdex2pflzo3hat55e=
5dc4j6pul3a3uov@y2axtbiura2q/

List of failures
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
#1: block/011
#2: nvme/003 (fabrics transport)
#3: nvme/* (fc transport)
#4: srp/002, 011 (rdma_rxe driver)

Failure description
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

#1: block/011

   The test case fails with NVME devices due to lockdep WARNING "possible
   circular locking dependency detected". Reported in Sep/2022 [2]. In LSF
   2023, it was noted that this failure should be fixed.

   Also, it was found recently that this test case still causes failure of
   following tests. Fix work is ongoing [3].

   [2] https://lore.kernel.org/linux-block/20220930001943.zdbvolc3gkekfmcv@=
shindev/
   [3] https://github.com/kawasaki/blktests/commit/f540cbb0eeb66e2c76a88efb=
e65a2b59d55630fd

#2: nvme/003 (fabrics transport)

   When nvme test group is run with trtype=3Drdma or tcp, the test case fai=
ls
   due to lockdep WARNING "possible circular locking dependency detected".
   Reported in May/2023. Fix discussions were held [4][5].

   [4] https://lore.kernel.org/linux-nvme/20230511150321.103172-1-bvanassch=
e@acm.org/
   [5] https://lore.kernel.org/linux-nvme/5cb63b10-72ab-4b7c-7574-48583ea8f=
fd1@grimberg.me/

#3: nvme/* (fc transport)

   With trtype=3Dfc configuration, test run on nvme test group hangs. Danie=
l is
   driving fix work.

#4: srp/002, 011 (rdma_rxe driver)

   Test process hang is observed occasionally. Reported to the relevant mai=
ling
   lists in Aug/2023 [6]. Blktests was modified to change default driver fr=
om
   rdma_rxe to siw to avoid impacts on blktests users. Root cause is not ye=
t
   understood. Bob and Bart have spent time to chase it down (Thank you).

   [6] https://lore.kernel.org/linux-rdma/18a3ae8c-145b-4c7f-a8f5-67840feeb=
98c@acm.org/T/#mee9882c2cfd0cfff33caa04e75418576f4c7a789=
