Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50C91C7EE25
	for <linux-scsi@archiver.kernel.org>; Mon,  1 May 2023 08:40:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbjEAIkQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 May 2023 04:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232202AbjEAIkO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 May 2023 04:40:14 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D221B10C4;
        Mon,  1 May 2023 01:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1682930411; x=1714466411;
  h=from:to:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=L2wBVPvSKWr0sDdNZtHuZr/hB3JyqpsuDc5WLE9un5Q=;
  b=dIkNMfIVR2RhN4cWX6rmikrl5UOBRzoG3EAsPPnAU5DWRWm2ZNOYbg5V
   JP8WBZdZa/E2fZZMEsd0vcOuobnJZso4PRaMCus1VNLtV6rtCljSkf+4V
   fq/6R8mwa20erHiqxuQOuAUuphW2y7go5SDZIAQFilmBje8FOcTeeTII9
   jPNwobs9DVAl1lggt/fp1q744m8yCL+ofm+2za57nFEYSRQ9INqs5dAOp
   xixs5NwhiENSJRBDff/vRxmPkIH9XTxO2ktRcS8mGJtPJ7FDMyRk1o1Ml
   YeasjU37CCyHkkifxhJwpVUKB+ik6zfAUNYrPidvb8D7W1/dMovXOAuZe
   Q==;
X-IronPort-AV: E=Sophos;i="5.99,239,1677513600"; 
   d="scan'208";a="334056354"
Received: from mail-co1nam11lp2175.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.175])
  by ob1.hgst.iphmx.com with ESMTP; 01 May 2023 16:40:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j++Z4t7r8K5ggmSPK+GxlZ/68jPECFsKJyzpGpbHgp5XvK6idPVLY7s0WMwd4BJyqk7v0fL9Hi7mAHmNvL/CyEIyoNgeP5hr6RUEG4aaX4Z/FHkgMLY2vNEuBZuagD4yQ+hxKdcwYJNiwFZvFcYVT1Jg3xJ8r0wBNXCXbqWPjfSKco7Z1lrr5X4Bn9o+mdSnxBBhE77eEKEazt7lm7pynzb5/JXYsrOFOx2BoB1FRMeMhHDN6N+jdOFqkjShG4hKdkr+LlfsNt+9xpcZAijNNHyMm5lgzI8Gpp3CDdmgoaPmMxPM6oyjif2vE+QxtFJtT+S1eud+v5JkF+f+JK2Abg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SQCW/D3X+EPaVaAP5gKbNU5yk5+ESLW1VL8y124W6lY=;
 b=ToUCWWxUuQwnbNEgv4imlisbs+K68J0zd5eFWr2TPNSKkR+Q0AXP7VgMxaYbDdLw8L0LLowq9gJ49fwaBIAx81GqWH5bixth1pDreSnALg+UqCmAH2AIxtSasDrxg5zOgTV/jY6yvw7bYusUfPJ439h13tPF6mzrdkFcsnUvjy7cbSML8engEZUk8rMfBkeN/wIIMkNNkppKRcJpysBaHA9uvxKckadqp8WJxOq5e34KZ0fHxwsWd56eHrCxHMp8t2OQjQY/qQ4CnA308t+NQyXTlns/oZAcQj7ME/DoidwSdWsELzZeHr5vRaA9tx2iEicG5mIlx68g+iaegFgEIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SQCW/D3X+EPaVaAP5gKbNU5yk5+ESLW1VL8y124W6lY=;
 b=u+4FfFRZlbwvHM+Bg35Qz40Kg0H6l4qFQP7pmXI0wUbLu7JiVPYGbzqAAFvi59FkHY0jXMhvL6PhxEqvN5/8zg26bRCpWi45XDk1j/JqoJZWOT+v8oXzEJbTjw9SR4b0S/qSA4eh6k6G1ZqoEkLcnyxQ1utWP/0uNHAFbUc2Zb4=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 BL3PR04MB8026.namprd04.prod.outlook.com (2603:10b6:208:345::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.30; Mon, 1 May
 2023 08:40:07 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::eb0e:1bef:f266:eceb]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::eb0e:1bef:f266:eceb%9]) with mapi id 15.20.6340.030; Mon, 1 May 2023
 08:40:06 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: blktests failures with v6.3
Thread-Topic: blktests failures with v6.3
Thread-Index: AQHZfAiHSemkPgZRAESAMETNKTrXBA==
Date:   Mon, 1 May 2023 08:40:06 +0000
Message-ID: <rsmmxrchy6voi5qhl4irss5sprna3f5owkqtvybxglcv2pnylm@xmrnpfu3tfpe>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|BL3PR04MB8026:EE_
x-ms-office365-filtering-correlation-id: 5856d4bc-7821-4f50-82b5-08db4a1faa31
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UO+ngFovhAo/J+q//pUDf4Slv3gUNcl6pN5VFwxpYAqr3CNh+P12rTjVYD5kLo9CzKBYq4boQRJSWHzylBqDUqb573sUEIHzMGAs7g+1bNjrQI4OOivTYnVzGUkMHlWYk8cVvFrAv9fH17cg/WPiRAjE4iEDW/OmliTGjdGisYXMsQwCNghj2yjyT1mz/f0TfJIp7YyCK9DxuHz0lcnPwlXhPsyXStdNtIql8Zzprgfy0phDcCA8AGK5wDaQY6+dCxao9m4q5wN5xFgLUOxymF12cK26nYvgSxVIdob2Uem4U8ETC91bV3BjA+pxoCzjWkZKFMdUMJpF6I6kYUoyZHWNhzOzapYdP375OLNZXtjgHo8nm/oP8/DMo44rn2wtvX3wiMN0pRFDX8sLCA4ytV9FQxczaWPxQyOHqRs9qCwXkL3Lmtc09BVLrcLcWZmg2o4+RVSZ7xggDEYITGpSu4saxZ4L7Y9xvPt0HgtMt4ten2P970M3lA2qri0aDwqhtDese7Huiyr2hYcmWHtdBHio5gKXfMnzebAxTFYraRH7WalCVAvxlBJSaU+yJH5s0NWjUqyBMb2DWDLMz7l/OWZ2xNQWNkfOTBZOD+kUHU9AhQRlrkeoL0/MGnrmrPeYlbeURPSxdMV8Ij/dftF7AQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(346002)(366004)(136003)(39860400002)(396003)(376002)(451199021)(9686003)(6512007)(186003)(6506007)(26005)(2906002)(83380400001)(30864003)(44832011)(966005)(33716001)(6486002)(5660300002)(71200400001)(478600001)(38100700002)(82960400001)(8676002)(316002)(8936002)(122000001)(38070700005)(66446008)(66476007)(91956017)(76116006)(66946007)(86362001)(66556008)(41300700001)(64756008)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8jKcuw57x1HmkF72huyZzwKn64E9wrMgPxoDdD95Oqo28tDUOVocKVdYEdXp?=
 =?us-ascii?Q?m555+zZg5YU6FeAaOh9bMMzgIyaAx31cirihWnUhHWR/CDw41YR5hY45tlYs?=
 =?us-ascii?Q?NZd923pIQ73Hbqdu/lyvNxYVOnAuCubDzrNekmWJm+sbWhCYQE+kYLUmj7HQ?=
 =?us-ascii?Q?bQtEUnK/nEhyuZz/dhefJ/PZNEQ5xhn97mQ8YmUJxRIk79+lv9Hb1EgOBfmb?=
 =?us-ascii?Q?pxW6SQ8ieUlOCP6YLVWwwMHwVvel/wh2LklYKQl7n4Dkd8wPCFwbG05gSKc+?=
 =?us-ascii?Q?f1YF2X+k/AOZlM5qMABjk3lEaYnM6jg9EmgRL20FsI3EWE4gJOcNMMGwv1Nu?=
 =?us-ascii?Q?5g3/G+RLn/h2RCUgu4gqloO5d08aid9Gy6mL8mN8Frd8zdh37MTbDYZD5HER?=
 =?us-ascii?Q?FmzV79lb/oOxTCL1W0L2k6I7Z4WWtIToy+GjOqfLGGTl0fwOjjnSE/gsiQ8y?=
 =?us-ascii?Q?P7muomIDo7lHVEdKea7FcYKuHNhjQYjAsFrDAWitmj+QloSSCyY8Fc50NHss?=
 =?us-ascii?Q?FXjUWce10+YscY4CsIUdR6F26sfnHzpEHg341QT2u/MSTN7JfmXze6liaqHL?=
 =?us-ascii?Q?rj/e6rb7Nk8yRLb30eIpwPsPk7upQghI0t7s/kqLb3q4PJVadTgP6GkSmJiV?=
 =?us-ascii?Q?3c92QW18qBV5x9wMsUtaEh/xlf1xqtHNpE7ux+xMYwqjNG8O7MstSh5x765x?=
 =?us-ascii?Q?WJONNkzMNfpzj3Q8NCY56es5qhqzIX4JFugEZSrBPMuRqBobETrtvSLbCO7n?=
 =?us-ascii?Q?2fdyG7IfWEpTGhoWBANvRHk2YDrxPGfKUDSdHw4wXECTgejmn+QfdqpXzaFh?=
 =?us-ascii?Q?BFj4chaNxeoFgsSMJ/Q2qGEo5ymsAEameZyY4LfyphIWnUDcKRp3DAsOKesM?=
 =?us-ascii?Q?63lyVCHvpl6yqEPC3jWny3lnl7HmAQxpfPHbWJ7Jz7tb89tli4umfF1ACDVp?=
 =?us-ascii?Q?V5ME/uyR2CK+d6kH4sEy19mbpbyRisHFs8wi07kEwssth0WSrVI+M7gVtSjN?=
 =?us-ascii?Q?98nVQGNuxkjt1bx8LOeLSAROZwclmUp9iQaSnpNMRKas99hOJKrHXbpu+tOs?=
 =?us-ascii?Q?JsJECDsNcZdna44D/ZXviwHE+xSd2oJeO5BRtiztWUvVzMNCzpEijxFyCgpz?=
 =?us-ascii?Q?+a8rsFt4BhdGt7bHZOhoxJRo0Y8M5Wnquef+0Erf0ql/4Pur4S4YDQbAhsCi?=
 =?us-ascii?Q?y+xdAc6liJu9HQPiX4FrZbi1AoQKIEoCujm+15tffq4JNCqCXJLtno2SSv+o?=
 =?us-ascii?Q?PoDCV/bAkDFvQBTXuucwlwVxGY1rvfdMZnmeJtDzylNHZcCocrmfxMRuQ9gO?=
 =?us-ascii?Q?mTBaryu/2m4An3+EuNpLWV4inbikFnHBUH3kDB99SO7E3HD2RxCnOc7ognkJ?=
 =?us-ascii?Q?XxI1//PI2njzc6wz2OHXahQAK0tseYbEjtqPyiSIIZb4nxvDDSF6iKJ2XpZ0?=
 =?us-ascii?Q?Gz15P+5Y+dbRgDkpJ9GgC2nSYpCke7QSTrzHvyS+S7y3Wz2ga8U9sTM6P9tD?=
 =?us-ascii?Q?x9FNV07FXzlMbQMaLiRM4DNj3mNWR0hKpQ/4VQOTCwQqszh/LuLwwnx/pVkw?=
 =?us-ascii?Q?VC7XZUVUb8j2Kt77at3x81+kIrR2ZiF1Os70s8OJWFE8zSrBPBVETSQRrRdh?=
 =?us-ascii?Q?UkDF/B6+XUCeqfGxZPTzOVA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <703E19E2B75C8D4BA788035A9C390AEC@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Kr6PxEVPBtp1fSN1j4Yv2eawjFUvKlHSuXuPsi34hsl25ro2xeSKXWiiJgW6B4fVC/XL8O16Nr8tAQS/yQWZfZ5Zsi01f2X6hhuED0wI+evTDjz/gs+on2mxytQDZCVnKeF77/dAGDXucPSlL68i5bl+lw3eUw24M7mQyskbKZ4SmTX+lNT1bQAU4TKtwxr8aCrYeMBo+Pxgn7k4Idox1p2LJ4lF2ln++DMVKc6KQTxDoqJiu4DQU4G6jmfnVvIxeAu+wUTePxnBokONOR5Lwo1lmY+IrhB7wTuJYPa2w5cvnQZU8xm0MtD1bfCc8+FlYfsKu9tuT9U4aGdWyojDiYX4Vc3EMmaGGNdKVqn4JrOBf8B4wexyzq+RQDs4mnxbxVKxge/71YtzuXOsrxY5hhNoTS6HktJ8CgT+bp7QSv6PqS73zxgC3eTkH5nG56f0VRyoLUcbqov9HmNo/7ZFeJI+vUXAFM+Ra3BwYbG3bCPVGhRXWflaKGGDkDZfSFCoNaZclVXFx+DfUDXVp8O6ZJ2glxYzLJdkbU+kesNy/VvAKwRyxw3Y6BvgZyKPy8n5pDrvAAcgn2xY9ZaY5HNfEkpbqSTdeQIHH1vAuV3ewm4RCecw3PWQxeuO4n6mRDRCeVBHAXkqEy6/XgdV9dRSISK+GvWB3dwVmpjqtgDyxfTfRycCfAebj+U6EpAVJwovTaOtn8KbBkzZZIQJwHnXvsqyRSo9nQN8mpy/sn11c21psvpjkMUVf5YMej4bWiJ0zQx/JaG69hUbjbezCaW5g5sgvL31fPTuriEobRhb2yC20mfKIHy5yuGgINJgwExRDdWVZOARequ7VI9phOEq3Q==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5856d4bc-7821-4f50-82b5-08db4a1faa31
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 May 2023 08:40:06.2645
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1fgTdwWZosnycxljsY6wdj3xnmI3LvdVMaOzKx6xtY14jhlxi8/TsvK76tcGfPx3iYqu9z50HTpFpUwfqSydFXYI2ft3yOd1ZFOrky1sUvs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR04MB8026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

I ran the latest blktests (git hash: c1da4a225273) with v6.3 kernel and obs=
erved
test case failures. I call for support to fix them. (I myself is now workin=
g on
some of the block/011 failure symptoms.)

List of failures
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
#1: block/011
#2: block/024
#3: nvme/003 (fabrics transport)
#4: nvme/030 or nvme/031 (rdma transport with siw)
#5: nvme/* (fc transport)

This list excludes failures already resovled: scsi/007 and nvme/{044,045}.

Failure description
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

#1: block/011

   This test case shows three failure symptoms.

   Symptom A:

     The test case fails with NVME devices due to lockdep WARNING "possible
     circular locking dependency detected". Reported in Sep/2022 [1] and
     solution was discussed. Waiting a fix.

     [1] https://lore.kernel.org/linux-block/20220930001943.zdbvolc3gkekfmc=
v@shindev/

   Symptom B:

     When this test case passes for a NVME device, the device is left with
     zero capacity occasionally. It causes following test cases fail. The d=
evice
     capacity change happens due to ENODEV during the test. I'm preparing a=
 fix
     patch for blktests [2].

     [2] https://github.com/kawasaki/blktests/commit/f78ceec0cb95b9b2a9dcbf=
44999e350b740722e8

   Symptom C:

     When system disk and the test device belong to same PCI device, the sy=
stem
     disk disappears during the test case run (e.g. a system with two SSDs =
on
     same AHCI controller or HBA). This results in test system hang. I'm
     preparing patches for blktests to avoid this failure [3].

     [3] https://github.com/kawasaki/blktests/commit/662c33048ba1e949348dc2=
fca8b4778f940b7cc5

#2: block/024

   Fails on slow machines. Reported in Dec/2022. Test case side issue is
   suspected. Still need further investigation.

   block/024 (do I/O faster than a jiffy and check iostats times) [failed]
    runtime    ...  4.347s
    --- tests/block/024.out     2022-12-06 20:51:41.525066605 +0900
    +++ /home/shin/kts/kernel-test-suite/sets/blktests/log/runlog/nodev/blo=
ck/024.out.bad       2022-12-07 12:51:03.610924521 +0900
    @@ -6,5 +6,5 @@
     read 1 s
     write 1 s
     read 2 s
    -write 3 s
    +write 4 s
     Test complete

#3: nvme/003 (fabrics transport)

   When nvme test group is run with trtype=3Drdma, tcp or fc, the test case=
 fails
   due to lockdep WARNING "possible circular locking dependency detected".
   Detailed kernel message is attached [4].

#4: nvme/030 or nvme/031 (rdma transport with siw)

   When nvme test group is run with trtype=3Drdma and use_siw=3D1 configura=
tions,
   a failure is observed at nvme/030 or nvme/031 occasionally. The failure
   cause is "BUG: KASAN: slab-use-after-free in __mutex_lock". Detailed
   kernel message is attached [5]

#5: nvme/* (fc transport)

   With trtype=3Dfc configuration, many of test cases in nvme test group fa=
il or
   hang. Daniel Wagner is driving fix work [6].

   [6] https://lore.kernel.org/linux-nvme/20230418130159.11075-1-dwagner@su=
se.de/


[4]

[  134.432456] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
[  134.433289] WARNING: possible circular locking dependency detected
[  134.433806] 6.3.0 #62 Not tainted
[  134.434149] ------------------------------------------------------
[  134.434709] kworker/1:3/455 is trying to acquire lock:
[  134.435141] ffff88813bfd9420 (&id_priv->handler_mutex){+.+.}-{3:3}, at: =
rdma_destroy_id+0x17/0x20 [rdma_cm]
[  134.435986]=20
               but task is already holding lock:
[  134.436554] ffff888131327db0 ((work_completion)(&queue->release_work)){+=
.+.}-{0:0}, at: process_one_work+0x793/0x1350
[  134.437459]=20
               which lock already depends on the new lock.

[  134.438235]=20
               the existing dependency chain (in reverse order) is:
[  134.438914]=20
               -> #3 ((work_completion)(&queue->release_work)){+.+.}-{0:0}:
[  134.439688]        process_one_work+0x7dc/0x1350
[  134.440084]        worker_thread+0xfc/0x1260
[  134.440489]        kthread+0x29e/0x340
[  134.440857]        ret_from_fork+0x2c/0x50
[  134.441251]=20
               -> #2 ((wq_completion)nvmet-wq){+.+.}-{0:0}:
[  134.441885]        __flush_workqueue+0x130/0x12f0
[  134.442328]        nvmet_rdma_cm_handler+0x961/0x39c0 [nvmet_rdma]
[  134.442900]        cma_cm_event_handler+0xb2/0x2f0 [rdma_cm]
[  134.443412]        cma_ib_req_handler+0x1096/0x4a50 [rdma_cm]
[  134.443925]        cm_process_work+0x46/0x3b0 [ib_cm]
[  134.444399]        cm_req_handler+0x20e2/0x61d0 [ib_cm]
[  134.444880]        cm_work_handler+0xc15/0x6ce0 [ib_cm]
[  134.445365]        process_one_work+0x843/0x1350
[  134.445794]        worker_thread+0xfc/0x1260
[  134.446165]        kthread+0x29e/0x340
[  134.447271]        ret_from_fork+0x2c/0x50
[  134.448373]=20
               -> #1 (&id_priv->handler_mutex/1){+.+.}-{3:3}:
[  134.450542]        __mutex_lock+0x186/0x18f0
[  134.451682]        cma_ib_req_handler+0xc3c/0x4a50 [rdma_cm]
[  134.452921]        cm_process_work+0x46/0x3b0 [ib_cm]
[  134.454150]        cm_req_handler+0x20e2/0x61d0 [ib_cm]
[  134.455423]        cm_work_handler+0xc15/0x6ce0 [ib_cm]
[  134.456680]        process_one_work+0x843/0x1350
[  134.457865]        worker_thread+0xfc/0x1260
[  134.458985]        kthread+0x29e/0x340
[  134.460097]        ret_from_fork+0x2c/0x50
[  134.461294]=20
               -> #0 (&id_priv->handler_mutex){+.+.}-{3:3}:
[  134.463349]        __lock_acquire+0x2fc0/0x60f0
[  134.464430]        lock_acquire+0x1a7/0x4e0
[  134.465448]        __mutex_lock+0x186/0x18f0
[  134.466461]        rdma_destroy_id+0x17/0x20 [rdma_cm]
[  134.467569]        nvmet_rdma_free_queue+0x7a/0x380 [nvmet_rdma]
[  134.468735]        nvmet_rdma_release_queue_work+0x3e/0x90 [nvmet_rdma]
[  134.469904]        process_one_work+0x843/0x1350
[  134.470923]        worker_thread+0xfc/0x1260
[  134.471918]        kthread+0x29e/0x340
[  134.472902]        ret_from_fork+0x2c/0x50
[  134.473884]=20
               other info that might help us debug this:

[  134.476264] Chain exists of:
                 &id_priv->handler_mutex --> (wq_completion)nvmet-wq --> (w=
ork_completion)(&queue->release_work)

[  134.479201]  Possible unsafe locking scenario:

[  134.480949]        CPU0                    CPU1
[  134.481941]        ----                    ----
[  134.482871]   lock((work_completion)(&queue->release_work));
[  134.483938]                                lock((wq_completion)nvmet-wq)=
;
[  134.485094]                                lock((work_completion)(&queue=
->release_work));
[  134.486391]   lock(&id_priv->handler_mutex);
[  134.487384]=20
                *** DEADLOCK ***

[  134.489712] 2 locks held by kworker/1:3/455:
[  134.490728]  #0: ffff888127b28538 ((wq_completion)nvmet-wq){+.+.}-{0:0},=
 at: process_one_work+0x766/0x1350
[  134.492084]  #1: ffff888131327db0 ((work_completion)(&queue->release_wor=
k)){+.+.}-{0:0}, at: process_one_work+0x793/0x1350
[  134.493538]=20
               stack backtrace:
[  134.495147] CPU: 1 PID: 455 Comm: kworker/1:3 Not tainted 6.3.0 #62
[  134.496262] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.16.2-1.fc38 04/01/2014
[  134.497573] Workqueue: nvmet-wq nvmet_rdma_release_queue_work [nvmet_rdm=
a]
[  134.498769] Call Trace:
[  134.499649]  <TASK>
[  134.500494]  dump_stack_lvl+0x57/0x90
[  134.501455]  check_noncircular+0x27b/0x310
[  134.502444]  ? __pfx_mark_lock+0x10/0x10
[  134.503413]  ? __pfx_check_noncircular+0x10/0x10
[  134.504431]  ? find_held_lock+0x2d/0x110
[  134.505399]  ? lockdep_lock+0xca/0x1c0
[  134.506351]  ? __pfx_lockdep_lock+0x10/0x10
[  134.507333]  ? mark_held_locks+0x9e/0xe0
[  134.508299]  __lock_acquire+0x2fc0/0x60f0
[  134.509272]  ? __pfx___wait_for_common+0x10/0x10
[  134.510292]  ? __pfx___lock_acquire+0x10/0x10
[  134.511296]  ? rxe_sched_task+0x50/0x70 [rdma_rxe]
[  134.512328]  ? rxe_post_recv+0x1d9/0x250 [rdma_rxe]
[  134.513366]  lock_acquire+0x1a7/0x4e0
[  134.514314]  ? rdma_destroy_id+0x17/0x20 [rdma_cm]
[  134.515353]  ? __pfx_lock_acquire+0x10/0x10
[  134.516345]  ? __pfx_ib_drain_qp_done+0x10/0x10 [ib_core]
[  134.517447]  ? __pfx___might_resched+0x10/0x10
[  134.518455]  __mutex_lock+0x186/0x18f0
[  134.519405]  ? rdma_destroy_id+0x17/0x20 [rdma_cm]
[  134.520436]  ? rdma_destroy_id+0x17/0x20 [rdma_cm]
[  134.521463]  ? __pfx___mutex_lock+0x10/0x10
[  134.522447]  ? rcu_is_watching+0x11/0xb0
[  134.523408]  ? rdma_destroy_id+0x17/0x20 [rdma_cm]
[  134.524434]  rdma_destroy_id+0x17/0x20 [rdma_cm]
[  134.525451]  nvmet_rdma_free_queue+0x7a/0x380 [nvmet_rdma]
[  134.526528]  nvmet_rdma_release_queue_work+0x3e/0x90 [nvmet_rdma]
[  134.527643]  process_one_work+0x843/0x1350
[  134.528600]  ? __pfx_lock_acquire+0x10/0x10
[  134.529562]  ? __pfx_process_one_work+0x10/0x10
[  134.530551]  ? __pfx_do_raw_spin_lock+0x10/0x10
[  134.531537]  worker_thread+0xfc/0x1260
[  134.532471]  ? __kthread_parkme+0xc1/0x1f0
[  134.533428]  ? __pfx_worker_thread+0x10/0x10
[  134.534385]  kthread+0x29e/0x340
[  134.535264]  ? __pfx_kthread+0x10/0x10
[  134.536164]  ret_from_fork+0x2c/0x50
[  134.537058]  </TASK>


[5]

May 01 11:19:44 testnode1 kernel: =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
May 01 11:19:44 testnode1 kernel: BUG: KASAN: slab-use-after-free in __mute=
x_lock+0x1324/0x18f0
May 01 11:19:44 testnode1 kernel: Read of size 8 at addr ffff888197b37418 b=
y task kworker/u8:0/9
May 01 11:19:44 testnode1 kernel:=20
May 01 11:19:44 testnode1 kernel: CPU: 0 PID: 9 Comm: kworker/u8:0 Not tain=
ted 6.3.0 #62
May 01 11:19:44 testnode1 kernel: Hardware name: QEMU Standard PC (i440FX +=
 PIIX, 1996), BIOS 1.16.2-1.fc38 04/01/2014
May 01 11:19:44 testnode1 kernel: Workqueue: iw_cm_wq cm_work_handler [iw_c=
m]
May 01 11:19:44 testnode1 kernel: Call Trace:
May 01 11:19:44 testnode1 kernel:  <TASK>
May 01 11:19:44 testnode1 kernel:  dump_stack_lvl+0x57/0x90
May 01 11:19:44 testnode1 kernel:  print_report+0xcf/0x660
May 01 11:19:44 testnode1 kernel:  ? __mutex_lock+0x1324/0x18f0
May 01 11:19:44 testnode1 kernel:  kasan_report+0xa4/0xe0
May 01 11:19:44 testnode1 kernel:  ? __mutex_lock+0x1324/0x18f0
May 01 11:19:44 testnode1 kernel:  __mutex_lock+0x1324/0x18f0
May 01 11:19:44 testnode1 kernel:  ? cma_iw_handler+0xac/0x4f0 [rdma_cm]
May 01 11:19:44 testnode1 kernel:  ? _raw_spin_unlock_irqrestore+0x30/0x60
May 01 11:19:44 testnode1 kernel:  ? rcu_is_watching+0x11/0xb0
May 01 11:19:44 testnode1 kernel:  ? _raw_spin_unlock_irqrestore+0x30/0x60
May 01 11:19:44 testnode1 kernel:  ? trace_hardirqs_on+0x12/0x100
May 01 11:19:44 testnode1 kernel:  ? __pfx___mutex_lock+0x10/0x10
May 01 11:19:44 testnode1 kernel:  ? __percpu_counter_sum+0x147/0x1e0
May 01 11:19:44 testnode1 kernel:  ? domain_dirty_limits+0x246/0x390
May 01 11:19:44 testnode1 kernel:  ? wb_over_bg_thresh+0x4d5/0x610
May 01 11:19:44 testnode1 kernel:  ? rcu_is_watching+0x11/0xb0
May 01 11:19:44 testnode1 kernel:  ? cma_iw_handler+0xac/0x4f0 [rdma_cm]
May 01 11:19:44 testnode1 kernel:  cma_iw_handler+0xac/0x4f0 [rdma_cm]
May 01 11:19:44 testnode1 kernel:  ? rcu_is_watching+0x11/0xb0
May 01 11:19:44 testnode1 kernel:  ? __pfx_cma_iw_handler+0x10/0x10 [rdma_c=
m]
May 01 11:19:44 testnode1 kernel:  ? attach_entity_load_avg+0x4e2/0x920
May 01 11:19:44 testnode1 kernel:  ? _raw_spin_unlock_irqrestore+0x30/0x60
May 01 11:19:44 testnode1 kernel:  ? rcu_is_watching+0x11/0xb0
May 01 11:19:44 testnode1 kernel:  cm_work_handler+0x139e/0x1c50 [iw_cm]
May 01 11:19:44 testnode1 kernel:  ? __pfx_cm_work_handler+0x10/0x10 [iw_cm=
]
May 01 11:19:44 testnode1 kernel:  ? rcu_is_watching+0x11/0xb0
May 01 11:19:44 testnode1 kernel:  ? __pfx_try_to_wake_up+0x10/0x10
May 01 11:19:44 testnode1 kernel:  ? __pfx_do_raw_spin_lock+0x10/0x10
May 01 11:19:44 testnode1 kernel:  ? __pfx___might_resched+0x10/0x10
May 01 11:19:44 testnode1 kernel:  ? _raw_spin_unlock_irq+0x24/0x50
May 01 11:19:44 testnode1 kernel:  process_one_work+0x843/0x1350
May 01 11:19:44 testnode1 kernel:  ? __pfx_lock_acquire+0x10/0x10
May 01 11:19:44 testnode1 kernel:  ? __pfx_process_one_work+0x10/0x10
May 01 11:19:44 testnode1 kernel:  ? __pfx_do_raw_spin_lock+0x10/0x10
May 01 11:19:44 testnode1 kernel:  worker_thread+0xfc/0x1260
May 01 11:19:44 testnode1 kernel:  ? __pfx_worker_thread+0x10/0x10
May 01 11:19:44 testnode1 kernel:  kthread+0x29e/0x340
May 01 11:19:44 testnode1 kernel:  ? __pfx_kthread+0x10/0x10
May 01 11:19:44 testnode1 kernel:  ret_from_fork+0x2c/0x50
May 01 11:19:44 testnode1 kernel:  </TASK>
May 01 11:19:44 testnode1 kernel:=20
May 01 11:19:44 testnode1 kernel: Allocated by task 4225:
May 01 11:19:44 testnode1 kernel:  kasan_save_stack+0x2f/0x50
May 01 11:19:44 testnode1 kernel:  kasan_set_track+0x21/0x30
May 01 11:19:44 testnode1 kernel:  __kasan_kmalloc+0xa6/0xb0
May 01 11:19:44 testnode1 kernel:  __rdma_create_id+0x5b/0x5d0 [rdma_cm]
May 01 11:19:44 testnode1 kernel:  __rdma_create_kernel_id+0x12/0x40 [rdma_=
cm]
May 01 11:19:44 testnode1 kernel:  nvme_rdma_alloc_queue+0x26a/0x5f0 [nvme_=
rdma]
May 01 11:19:44 testnode1 kernel:  nvme_rdma_setup_ctrl+0xb84/0x1d90 [nvme_=
rdma]
May 01 11:19:44 testnode1 kernel:  nvme_rdma_create_ctrl+0x7b5/0xd20 [nvme_=
rdma]
May 01 11:19:44 testnode1 kernel:  nvmf_dev_write+0xddd/0x22b0 [nvme_fabric=
s]
May 01 11:19:44 testnode1 kernel:  vfs_write+0x211/0xd50
May 01 11:19:44 testnode1 kernel:  ksys_write+0x100/0x1e0
May 01 11:19:44 testnode1 kernel:  do_syscall_64+0x5b/0x80
May 01 11:19:44 testnode1 kernel:  entry_SYSCALL_64_after_hwframe+0x72/0xdc
May 01 11:19:44 testnode1 kernel:=20
May 01 11:19:44 testnode1 kernel: Freed by task 4227:
May 01 11:19:44 testnode1 kernel:  kasan_save_stack+0x2f/0x50
May 01 11:19:44 testnode1 kernel:  kasan_set_track+0x21/0x30
May 01 11:19:44 testnode1 kernel:  kasan_save_free_info+0x2a/0x50
May 01 11:19:44 testnode1 kernel:  ____kasan_slab_free+0x169/0x1c0
May 01 11:19:44 testnode1 kernel:  slab_free_freelist_hook+0xdb/0x1b0
May 01 11:19:44 testnode1 kernel:  __kmem_cache_free+0xb8/0x2e0
May 01 11:19:44 testnode1 kernel:  nvme_rdma_free_queue+0x4a/0x70 [nvme_rdm=
a]
May 01 11:19:44 testnode1 kernel:  nvme_rdma_teardown_io_queues.part.0+0x14=
a/0x1e0 [nvme_rdma]
May 01 11:19:44 testnode1 kernel:  nvme_rdma_delete_ctrl+0x4f/0x100 [nvme_r=
dma]
May 01 11:19:44 testnode1 kernel:  nvme_do_delete_ctrl+0x14e/0x240 [nvme_co=
re]
May 01 11:19:44 testnode1 kernel:  nvme_sysfs_delete+0xcb/0x100 [nvme_core]
May 01 11:19:44 testnode1 kernel:  kernfs_fop_write_iter+0x359/0x530
May 01 11:19:44 testnode1 kernel:  vfs_write+0x58f/0xd50
May 01 11:19:44 testnode1 kernel:  ksys_write+0x100/0x1e0
May 01 11:19:44 testnode1 kernel:  do_syscall_64+0x5b/0x80
May 01 11:19:44 testnode1 kernel:  entry_SYSCALL_64_after_hwframe+0x72/0xdc
May 01 11:19:44 testnode1 kernel:=20
May 01 11:19:44 testnode1 kernel: The buggy address belongs to the object a=
t ffff888197b37000
                                   which belongs to the cache kmalloc-2k of=
 size 2048
May 01 11:19:44 testnode1 kernel: The buggy address is located 1048 bytes i=
nside of
                                   freed 2048-byte region [ffff888197b37000=
, ffff888197b37800)
May 01 11:19:44 testnode1 kernel:=20
May 01 11:19:44 testnode1 kernel: The buggy address belongs to the physical=
 page:
May 01 11:19:44 testnode1 kernel: page:00000000fbe33a6e refcount:1 mapcount=
:0 mapping:0000000000000000 index:0x0 pfn:0x197b30
May 01 11:19:44 testnode1 kernel: head:00000000fbe33a6e order:3 entire_mapc=
ount:0 nr_pages_mapped:0 pincount:0
May 01 11:19:44 testnode1 kernel: anon flags: 0x17ffffc0010200(slab|head|no=
de=3D0|zone=3D2|lastcpupid=3D0x1fffff)
May 01 11:19:44 testnode1 kernel: raw: 0017ffffc0010200 ffff888100042f00 00=
00000000000000 dead000000000001
May 01 11:19:44 testnode1 kernel: raw: 0000000000000000 0000000000080008 00=
000001ffffffff 0000000000000000
May 01 11:19:44 testnode1 kernel: page dumped because: kasan: bad access de=
tected
May 01 11:19:44 testnode1 kernel:=20
May 01 11:19:44 testnode1 kernel: Memory state around the buggy address:
May 01 11:19:44 testnode1 kernel:  ffff888197b37300: fb fb fb fb fb fb fb f=
b fb fb fb fb fb fb fb fb
May 01 11:19:44 testnode1 kernel:  ffff888197b37380: fb fb fb fb fb fb fb f=
b fb fb fb fb fb fb fb fb
May 01 11:19:44 testnode1 kernel: >ffff888197b37400: fb fb fb fb fb fb fb f=
b fb fb fb fb fb fb fb fb
May 01 11:19:44 testnode1 kernel:                             ^
May 01 11:19:44 testnode1 kernel:  ffff888197b37480: fb fb fb fb fb fb fb f=
b fb fb fb fb fb fb fb fb
May 01 11:19:44 testnode1 kernel:  ffff888197b37500: fb fb fb fb fb fb fb f=
b fb fb fb fb fb fb fb fb
May 01 11:19:44 testnode1 kernel: =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=
