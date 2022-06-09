Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 418A0C43334
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jun 2022 23:53:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237606AbiFIXxj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jun 2022 19:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbiFIXxf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jun 2022 19:53:35 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD5F765C;
        Thu,  9 Jun 2022 16:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1654818813; x=1686354813;
  h=from:to:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=hFkB+PIrqZHeJeKu4b1BOmiypm7r9pvuFOBNZA3Wgcw=;
  b=LsK5iVlZBXH2iBunzaA2UHhXdp2cdek+HAxAyt+7TY90UJ684eY0K0VC
   1Tv6qTgnw7GBToIVUdS8BUUFeAZV5LEwdxw70Mpe5YofXFn7BVYye0Emg
   RCKSYfNU4RBN76HySdAkdTjh6JImprJiGO6d4qtNQC3ZGbgxwMz0dczdU
   N+QKRl09qhMpWPXl37DfKtUwUW05fBFcrLO2K4H8MY83jrTgNeDZqyTtz
   zuiskf9aMB19RbJuLJQ9UNUTqGjnCBFbp6yln/YVRv90ej/mZ0Qq4djo7
   pj8x/eId32W6d+7aLn1/c0BFvPsctXp6xpZZWdh4ekRVSCRXW8lTpGblq
   w==;
X-IronPort-AV: E=Sophos;i="5.91,288,1647273600"; 
   d="scan'208";a="307026387"
Received: from mail-mw2nam10lp2107.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.107])
  by ob1.hgst.iphmx.com with ESMTP; 10 Jun 2022 07:53:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c1i7oepc7duSK2g+7lMkew8ed337pIjpd8s1TkiA/LofL1bkBIILrA/07EAhFB8nc1o82F0fGDwlchZhIM3ffwsH89vQimBtYtAEksfGV6YcmNOyPVu1RXLKcVvE2cFMjnQdkVIdjhiPUuIXzKaVdjs5RwaR+w1NBUnS1abagUsg3NO1YwWlbfY4hIfjTh2RlX4UF6jTh/FKA1c3idYxz79PxR2OjUHPE97k4aFMVyl6s7wZZQeGWplIQMwfiB4CoQ8Zl8oRiABO8OAdXRbs43soqSOToK63wXrhxndkmK433hOmGpkT3rQgfjeqj8oCdqmuOxaF7P3Nyh9/KE/RQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gIWgPtjSBMLq3+xPQOyHsfgIdxMMURTBys7ZJqLTOlo=;
 b=A+Eaiq5+xyqTPKK2SdnjNBnp6JQ606ND8V4MWL+cE2lBTHkH3iaJPFmbVh6FF7wp2S6pjnyev3tv0iwoboiik4ySZ86mdq94CWcgAkEbeptna9dGDnM9fBcY7GnQXs9iXKEX//ywKMb2djld4qFcA5iIbhlloGI9RNqMXuuP5ZigB4qY8FSteOx/+tyAFFFqO0nuYAXTeC4NH2Co5oghsOM9DY/J/Vuna6F9SA78/seNTEcIFVbndGNxqst848/qFZbkX4FbRxuqr7Tj6hAspy+boKpq+OqIEX1cdMglbgA+8eWTqbuejie7NozD26rhcvLAwk9ustDlSj5TaDY/ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gIWgPtjSBMLq3+xPQOyHsfgIdxMMURTBys7ZJqLTOlo=;
 b=Hs8NvbVW12+ByCMtt+uiGnF8rOfpLwjhWDyCg3wmS+AHH6KeBq9EKdtOO4DwauPC4Tbhv5TKUTP6hCeLFU+tsYVWoLmCRbTbWTxT/0d//9IkMYpVLZ6l2/RuvwaUp2m29/zz1wsVv+MtyHiDxQpDdrAqFnmynkS7TH6qHTl7WJY=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 BN3PR04MB2276.namprd04.prod.outlook.com (2a01:111:e400:7bb9::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.12; Thu, 9 Jun
 2022 23:53:30 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::39dc:d3d:686a:9e7]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::39dc:d3d:686a:9e7%3]) with mapi id 15.20.5332.013; Thu, 9 Jun 2022
 23:53:30 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: blktests failures with v5.19-rc1
Thread-Topic: blktests failures with v5.19-rc1
Thread-Index: AQHYfFwe8PMwMXtEZEqIJFDj8WJWFQ==
Date:   Thu, 9 Jun 2022 23:53:30 +0000
Message-ID: <20220609235329.4jbz4wr3eg2nmzqa@shindev>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 580c390f-deaf-453e-3ef5-08da4a734141
x-ms-traffictypediagnostic: BN3PR04MB2276:EE_
x-microsoft-antispam-prvs: <BN3PR04MB22762D8B68550C57D65129C2EDA79@BN3PR04MB2276.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SinYB7m0XDfI+uNXVt9XHCCfLCjGbsenFs15oQK+B/3l7/JOzwNRhf4HLVuP52AGYePj++qy1c/StoW+xooO2C5J6Ke8pRlVjnWQvxyQ8NfnikkZkgsaRHpTXWotpqU1iI1lQlpaKIjW3lfD0AVHU6SAEU+BPKS263CaJbwKjxisiJg080u8HD1MIhFn5czBDlCTly/Lw/ZbDhMC2gTJkrvFW5L6Mz86yCjbK3Ik7ahWQDQNBmN9zUluIK7bcD3Umj15dK5RVpHDOXiKU1dNqv5c36fsrrV21bApEXZUXHM3aiP5uc7Abt2VtDLc8xI0qprUb0t2s7zNGHonl3/ELjQA4xWZGQMB5D3oWi9QIdyF20tw1CpGaLLrXuEHed6lxYNQ6lq/dRrSptrbbfgAud/CG4C0wq3o4zW3WdCuvCYcix8QhEwm2mGpsTUUfsJG+HR+UySyReLpI3DprBhp02XqqahS1QtS9zSZ48bb+m1DXydo1+reavG7fdoLgp/5TrgAMPLm4nhPM3SamcnlbSfkndzzLCTRZ2+YezynEd9LUFXV0oB2Z6GfRlwYjlq6sFP8OkAhvYjmRK1z90ZSpwjS0GpGjVRc1IKdIjoXnN6xL7pH4JzqW3YWXhCoBqOXUgeJU32FsmmCW0S0mbHoVqtc8hpMYcFkFSWd3kcewO03miekgkYaypptc2C0ne61ahCWrQ4MhdzCiP83cmbJqkv0OSrkkWiGWlae8rq7UW4FL4l/nHkr2O/5SvXXL4vIXYQhhZ0w0IAKmsH+/cP4wWYhvuAWi+zvZaZ/JMrXPIE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(110136005)(966005)(30864003)(38100700002)(33716001)(8676002)(64756008)(122000001)(91956017)(5660300002)(6486002)(9686003)(66446008)(66946007)(66476007)(66556008)(76116006)(6506007)(6512007)(26005)(316002)(83380400001)(71200400001)(186003)(508600001)(1076003)(86362001)(38070700005)(44832011)(2906002)(82960400001)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WElf8suAKXBnXhqcaDpiHpKOSahdeXXMouPE/RgV8EPz2emkeF4YMQJSE1fZ?=
 =?us-ascii?Q?ZgUdP7HtxI7GAE/c9gfg3xnH0upJRDYs/ePswYwj8V1pnAkmZ+o5iVYufyk9?=
 =?us-ascii?Q?cMZT7M3kZDTFp6GqxUaeVjeIN7UubNQYTq39uq6rea3zqQONZMCjXqhlFSa8?=
 =?us-ascii?Q?4nT0HYQXep2o1g9j2RmQ+EPClSwD1kXzF9aRSufTgwFBRkkJITAiDQPq+PD5?=
 =?us-ascii?Q?Sz0c0i2dXbZmzIkUxZCDA3BX1aZETFSGCJCh/Aiy0qu88HtD7l1Ip+ToomQL?=
 =?us-ascii?Q?yvyWl3y9N8ZHmJyeD+JuWrovfZ+o1s5xPaHTY3QlZ5YuaBn1Q40tCYKZWXbn?=
 =?us-ascii?Q?yqMSBTJKBRRtNt0gjHRfMFBFz8pabSdIWbMQVV8ZcaRATcJXpNwN857/MVvS?=
 =?us-ascii?Q?nm3DD5kmo0aoVAsSBOrSlpBq3vHBt61ceP0MVWAKMfr9I/YT2oVQbK3C+nqG?=
 =?us-ascii?Q?XkTO+NFYDia1XFymGKa4EE9Mq9DcvzPU0wvjCAyq+ciorrQMwp/uo/9fwQ0V?=
 =?us-ascii?Q?0tMYNrtmm0ltb+Qx0AxZsMY1IB7GPKJwrqcv1f7ShmYsbJpm6ugDe4ccubZ6?=
 =?us-ascii?Q?oYmCtMB5skam2e+QynpRi1rGY8PT2SmycTK42WmJIEG8HJ1wjDiFLsS71V/K?=
 =?us-ascii?Q?RV2S/Ln6hOV2IG8U0QNbG+TCRwJQ/Poinj3c0OUUnRraRjaOBRFe9RhZVF/A?=
 =?us-ascii?Q?yPbwvBKWh2F1My5IgiDsqcb93TPoq/ahIwKPUqVx5O3srt8YV2p0q0Io12Me?=
 =?us-ascii?Q?V4PX1y+QxUp5RNDhHibmgGIrfwEa+/PgHPHH9gyyLMk4F2ZF4x00T3j10/Ca?=
 =?us-ascii?Q?dAuv8XDOAgGe5s/SrM5fSi6XzndXPbrlHD5uUmTppzZL0LNG4tfHxMEK18eo?=
 =?us-ascii?Q?D9kugvr9EP5nwOHgl2AjfiMP53knVczGzEKM/Gv3f1V5wK4h1yoHdUbqlgIy?=
 =?us-ascii?Q?DHJ+QdwuSxzf8CSBS9OqnZmXTCp3JAAnBVLdq2evCFrr/GeCeaaLXvLYe9lm?=
 =?us-ascii?Q?g01AGDEMzOgv2OILR33CRgV1NxUCZw8tZ5TqleKjoXVgW4LMEkT+y5Zg0zOm?=
 =?us-ascii?Q?WGN+Bw9lvfjNaua9BZBZmevZGyUaPidQjx/HpHmYBmiV5b4kVN21JU+DGE5X?=
 =?us-ascii?Q?0vwi8ZmPD9xY11SE9eyqOfYPuP8/cG4YgNz9P4Py2xIVBi/mx91JLilzzHyQ?=
 =?us-ascii?Q?CCaQzRXesKULxswBgTul36KjCmAvmObQSrayhd0gs3Ng6IpHabL1fqJC/P/Q?=
 =?us-ascii?Q?Sybf5QLD1VDf1J91teSyk51BZcjUzLSMcOg22LyZQ24B6/QCLPZZYRbuwMdd?=
 =?us-ascii?Q?C+W9BGb2KmtcglFl7l2KVP7g7AfhC21hzWyyrDede2W2urSulb2NoUGhDe8r?=
 =?us-ascii?Q?RkDv1gTi1MJ2kNG5Vi1mUP/oEOBaY9Fpr78WgLUAqRxOhzaK40TpYOBb9ogv?=
 =?us-ascii?Q?oqyq4hlbW9rVJ0sF0k6HNY/A2rhc5EE4AVoBO02CpKV80oZO8uwoGVq2Td60?=
 =?us-ascii?Q?VC+3gJYya2+/yWqNP0218kVUMISJwwu3nHV8A+aZR70KhRiVO7AbaQbUK+e+?=
 =?us-ascii?Q?JDtTivVFjva8D7SePZC0E2Bs3hdpfxKDWGgnFWliLhMz8AmKk0qziqhma6DJ?=
 =?us-ascii?Q?N/+f8VHlt02eExses3NNJFGcwQJENZwP1Tx9oCr5OlX4alBqnzdlCskb1eNF?=
 =?us-ascii?Q?FIRIBms/meJejcQXwRITn9ibxCJuJtJd/6KVenk+faRIhcSYqjr0ak4sHfj5?=
 =?us-ascii?Q?afZh7B4Njw1ccFnGS8j+5S8EyVpLjwNif8qR4WPiJznfHfpk244M?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5C0BA5CCF1B43945A54DDF418748EDAD@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 580c390f-deaf-453e-3ef5-08da4a734141
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2022 23:53:30.2523
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YqYb2IQKaktluOy1oTNsfxkyUP848tBcoaumb5sRFIBw3pKqL+t88gwgHw8jJ/rKYWMRegswW07/NGytO2x4fXR392VkS1ONEqtKLJsozrE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR04MB2276
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

I ran the latest blktests (git hash: c17a19d) with v5.19-rc1 kernel and obs=
erved
6 test cases fail. I call for helps to fix them. Please refer the list of t=
he
failure cases and descriptions below.

- I don't know details of these failures. Not sure if they are kernel bugs =
or
  not. Some of them might be test script bugs or test system set up issues.
- All of the test cases failed also with v5.18 kernel, except scsi/007. The
  scsi/007 failure could be a new issue introduced with v5.19-rc1.
- I used Fedora 36 on QEMU for test runs. Related drivers were built as mod=
ules.

If further information is required for fixes, please let me know.


List of failure cases
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
#1: block/002
#2: scsi/007
#3: nvme/002
#4: nvme/016
#5: nvme/017
#6: nvme/032

Failure descriptiion
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
#1: block/002: Failed 3 times with 3 trials.
    Known issue. It is suggested to remove this test case [1].
    [1] https://lore.kernel.org/linux-block/20220530134548.3108185-3-hch@ls=
t.de/

    runtime    ...  1.250s
    --- tests/block/002.out     2022-06-02 10:18:53.526739780 +0900
    +++ /home/shin/kts/kernel-test-suite/src/blktests/results/nodev/block/0=
02.out.bad   2022-06-09 09:44:02.779122029 +0900
    @@ -1,2 +1,3 @@
     Running block/002
    +debugfs directory leaked
     Test complete

#2: scsi/007: Failed 3 times with 3 trials.

    runtime  29.867s  ...  40.688s
    --- tests/scsi/007.out      2022-06-02 10:18:53.550739780 +0900
    +++ /home/shin/kts/kernel-test-suite/src/blktests/results/nodev/scsi/00=
7.out.bad    2022-06-09 09:18:38.644237681 +0900
    @@ -1,3 +1,3 @@
     Running scsi/007
    -Reading from scsi_debug failed
    +Reading from scsi_debug succeeded
     Test complete

#3: nvme/002: Failed 3 times with 3 trials.

    runtime    ...  85.697s
    --- tests/nvme/002.out      2022-06-02 10:18:53.538739780 +0900
    +++ /home/shin/kts/kernel-test-suite/src/blktests/results/nodev/nvme/00=
2.out.bad    2022-06-09 09:51:45.714027241 +0900
    @@ -1,3003 +1,3006 @@
     Running nvme/002
    -Discovery Log Number of Records 1000, Generation counter X
    +Discovery Log Number of Records 1001, Generation counter X
     =3D=3D=3D=3D=3DDiscovery Log Entry 0=3D=3D=3D=3D=3D=3D
     trtype:  loop
    -subnqn:  blktests-subsystem-0
    +subnqn:  nqn.2014-08.org.nvmexpress.discovery
    ...

#4: nvme/016: Failed 3 times with 3 trials.

    runtime  36.240s  ...  35.984s
    --- tests/nvme/016.out      2022-06-02 10:18:53.541739780 +0900
    +++ /home/shin/kts/kernel-test-suite/src/blktests/results/nodev/nvme/01=
6.out.bad    2022-06-09 10:06:11.797004672 +0900
    @@ -1,6 +1,9 @@
     Running nvme/016
    -Discovery Log Number of Records 1, Generation counter X
    +Discovery Log Number of Records 2, Generation counter X
     =3D=3D=3D=3D=3DDiscovery Log Entry 0=3D=3D=3D=3D=3D=3D
     trtype:  loop
    +subnqn:  nqn.2014-08.org.nvmexpress.discovery
    +=3D=3D=3D=3D=3DDiscovery Log Entry 1=3D=3D=3D=3D=3D=3D
    ...

#5: nvme/017: Failed 3 times with 3 trials.

    runtime  43.724s  ...  42.912s
    --- tests/nvme/017.out      2022-06-02 10:18:53.541739780 +0900
    +++ /home/shin/kts/kernel-test-suite/src/blktests/results/nodev/nvme/01=
7.out.bad    2022-06-09 10:09:18.016394996 +0900
    @@ -1,6 +1,9 @@
     Running nvme/017
    -Discovery Log Number of Records 1, Generation counter X
    +Discovery Log Number of Records 2, Generation counter X
     =3D=3D=3D=3D=3DDiscovery Log Entry 0=3D=3D=3D=3D=3D=3D
     trtype:  loop
    +subnqn:  nqn.2014-08.org.nvmexpress.discovery
    +=3D=3D=3D=3D=3DDiscovery Log Entry 1=3D=3D=3D=3D=3D=3D
    ...

#6: nvme/032: Failed at the first run after system reboot.
              Used QEMU NVME device as TEST_DEV.

    runtime    ...  8.458s
    something found in dmesg:
    [ 1589.976481] run blktests nvme/032 at 2022-06-09 10:57:20

    [ 1597.221547] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
    [ 1597.221549] WARNING: possible circular locking dependency detected
    [ 1597.221551] 5.19.0-rc1 #1 Not tainted
    [ 1597.221554] ------------------------------------------------------
    [ 1597.221554] check/970 is trying to acquire lock:
    [ 1597.221556] ffff8881026f8cb8 (kn->active#227){++++}-{0:0}, at: kernf=
s_remove_by_name_ns+0x90/0xe0
    [ 1597.221580]
                   but task is already holding lock:
    ...

dmesg output:
[ 1589.976481] run blktests nvme/032 at 2022-06-09 10:57:20

[ 1597.221547] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
[ 1597.221549] WARNING: possible circular locking dependency detected
[ 1597.221551] 5.19.0-rc1 #1 Not tainted
[ 1597.221554] ------------------------------------------------------
[ 1597.221554] check/970 is trying to acquire lock:
[ 1597.221556] ffff8881026f8cb8 (kn->active#227){++++}-{0:0}, at: kernfs_re=
move_by_name_ns+0x90/0xe0
[ 1597.221580]=20
               but task is already holding lock:
[ 1597.221580] ffffffff889c0668 (pci_rescan_remove_lock){+.+.}-{3:3}, at: p=
ci_stop_and_remove_bus_device_locked+0xe/0x30
[ 1597.221590]=20
               which lock already depends on the new lock.

[ 1597.221591]=20
               the existing dependency chain (in reverse order) is:
[ 1597.221592]=20
               -> #1 (pci_rescan_remove_lock){+.+.}-{3:3}:
[ 1597.221598]        __mutex_lock+0x14c/0x12b0
[ 1597.221604]        dev_rescan_store+0x94/0xd0
[ 1597.221607]        kernfs_fop_write_iter+0x34f/0x520
[ 1597.221610]        new_sync_write+0x2ca/0x500
[ 1597.221614]        vfs_write+0x62d/0x980
[ 1597.221616]        ksys_write+0xe7/0x1b0
[ 1597.221619]        do_syscall_64+0x37/0x80
[ 1597.221622]        entry_SYSCALL_64_after_hwframe+0x46/0xb0
[ 1597.221625]=20
               -> #0 (kn->active#227){++++}-{0:0}:
[ 1597.221629]        __lock_acquire+0x2875/0x5510
[ 1597.221634]        lock_acquire+0x194/0x4f0
[ 1597.221636]        __kernfs_remove+0x6f3/0x910
[ 1597.221638]        kernfs_remove_by_name_ns+0x90/0xe0
[ 1597.221641]        remove_files+0x8c/0x1a0
[ 1597.221644]        sysfs_remove_group+0x77/0x150
[ 1597.221646]        sysfs_remove_groups+0x4f/0x90
[ 1597.221649]        device_remove_attrs+0x19e/0x240
[ 1597.221652]        device_del+0x492/0xb60
[ 1597.221654]        pci_remove_bus_device+0x12c/0x350
[ 1597.221656]        pci_stop_and_remove_bus_device_locked+0x1e/0x30
[ 1597.221659]        remove_store+0xac/0xc0
[ 1597.221662]        kernfs_fop_write_iter+0x34f/0x520
[ 1597.221664]        new_sync_write+0x2ca/0x500
[ 1597.221666]        vfs_write+0x62d/0x980
[ 1597.221669]        ksys_write+0xe7/0x1b0
[ 1597.221671]        do_syscall_64+0x37/0x80
[ 1597.221673]        entry_SYSCALL_64_after_hwframe+0x46/0xb0
[ 1597.221675]=20
               other info that might help us debug this:

[ 1597.221676]  Possible unsafe locking scenario:

[ 1597.221677]        CPU0                    CPU1
[ 1597.221678]        ----                    ----
[ 1597.221678]   lock(pci_rescan_remove_lock);
[ 1597.221680]                                lock(kn->active#227);
[ 1597.221683]                                lock(pci_rescan_remove_lock);
[ 1597.221685]   lock(kn->active#227);
[ 1597.221687]=20
                *** DEADLOCK ***

[ 1597.221688] 3 locks held by check/970:
[ 1597.221689]  #0: ffff888110106460 (sb_writers#4){.+.+}-{0:0}, at: ksys_w=
rite+0xe7/0x1b0
[ 1597.221697]  #1: ffff888120f69088 (&of->mutex){+.+.}-{3:3}, at: kernfs_f=
op_write_iter+0x216/0x520
[ 1597.221703]  #2: ffffffff889c0668 (pci_rescan_remove_lock){+.+.}-{3:3}, =
at: pci_stop_and_remove_bus_device_locked+0xe/0x30
[ 1597.221709]=20
               stack backtrace:
[ 1597.221714] CPU: 1 PID: 970 Comm: check Not tainted 5.19.0-rc1 #1
[ 1597.221717] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
[ 1597.221723] Call Trace:
[ 1597.221728]  <TASK>
[ 1597.221732]  dump_stack_lvl+0x5b/0x74
[ 1597.221742]  check_noncircular+0x23f/0x2e0
[ 1597.221745]  ? lock_chain_count+0x20/0x20
[ 1597.221748]  ? print_circular_bug+0x1e0/0x1e0
[ 1597.221751]  ? mark_lock+0xee/0x1610
[ 1597.221754]  ? mark_lock+0xee/0x1610
[ 1597.221759]  ? lockdep_lock+0xb8/0x1a0
[ 1597.221762]  ? call_rcu_zapped+0xb0/0xb0
[ 1597.221766]  __lock_acquire+0x2875/0x5510
[ 1597.221773]  ? lockdep_hardirqs_on_prepare+0x410/0x410
[ 1597.221779]  lock_acquire+0x194/0x4f0
[ 1597.221782]  ? kernfs_remove_by_name_ns+0x90/0xe0
[ 1597.221786]  ? lock_downgrade+0x6b0/0x6b0
[ 1597.221791]  ? up_write+0x14d/0x460
[ 1597.221795]  __kernfs_remove+0x6f3/0x910
[ 1597.221798]  ? kernfs_remove_by_name_ns+0x90/0xe0
[ 1597.221803]  ? kernfs_next_descendant_post+0x280/0x280
[ 1597.221807]  ? lock_is_held_type+0xe3/0x140
[ 1597.221811]  ? kernfs_name_hash+0x16/0xc0
[ 1597.221815]  ? kernfs_find_ns+0x1e3/0x330
[ 1597.221819]  kernfs_remove_by_name_ns+0x90/0xe0
[ 1597.221822]  remove_files+0x8c/0x1a0
[ 1597.221826]  sysfs_remove_group+0x77/0x150
[ 1597.221831]  sysfs_remove_groups+0x4f/0x90
[ 1597.221835]  device_remove_attrs+0x19e/0x240
[ 1597.221838]  ? device_remove_file+0x20/0x20
[ 1597.221842]  device_del+0x492/0xb60
[ 1597.221846]  ? __device_link_del+0x350/0x350
[ 1597.221848]  ? kfree+0xc5/0x340
[ 1597.221856]  pci_remove_bus_device+0x12c/0x350
[ 1597.221860]  pci_stop_and_remove_bus_device_locked+0x1e/0x30
[ 1597.221863]  remove_store+0xac/0xc0
[ 1597.221867]  ? subordinate_bus_number_show+0xa0/0xa0
[ 1597.221870]  ? sysfs_kf_write+0x3d/0x170
[ 1597.221874]  kernfs_fop_write_iter+0x34f/0x520
[ 1597.221881]  new_sync_write+0x2ca/0x500
[ 1597.221885]  ? new_sync_read+0x500/0x500
[ 1597.221888]  ? perf_callchain_user+0x7c0/0xaa0
[ 1597.221893]  ? lock_downgrade+0x6b0/0x6b0
[ 1597.221896]  ? inode_security+0x54/0xf0
[ 1597.221903]  ? lock_is_held_type+0xe3/0x140
[ 1597.221909]  vfs_write+0x62d/0x980
[ 1597.221913]  ksys_write+0xe7/0x1b0
[ 1597.221916]  ? __ia32_sys_read+0xa0/0xa0
[ 1597.221919]  ? syscall_enter_from_user_mode+0x20/0x70
[ 1597.221925]  do_syscall_64+0x37/0x80
[ 1597.221928]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
[ 1597.221931] RIP: 0033:0x7f5608901c17
[ 1597.221939] Code: 0f 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f =
00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 01 00 00 00 0f 05 <48=
> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 48 89 54 24 18 48 89 74 24
[ 1597.221942] RSP: 002b:00007fff89480c08 EFLAGS: 00000246 ORIG_RAX: 000000=
0000000001
[ 1597.221945] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f56089=
01c17
[ 1597.221948] RDX: 0000000000000002 RSI: 000055572288f080 RDI: 00000000000=
00001
[ 1597.221949] RBP: 000055572288f080 R08: 0000000000000000 R09: 00000000000=
00073
[ 1597.221951] R10: 0000000000000000 R11: 0000000000000246 R12: 00000000000=
00002
[ 1597.221953] R13: 00007f56089f8780 R14: 0000000000000002 R15: 00007f56089=
f39e0
[ 1597.221960]  </TASK>
[ 1597.227490] pci 0000:00:09.0: [1b36:0010] type 00 class 0x010802
[ 1597.230489] pci 0000:00:09.0: reg 0x10: [mem 0xfebc4000-0xfebc7fff 64bit=
]
[ 1597.278136] pci 0000:00:09.0: BAR 0: assigned [mem 0x640000000-0x640003f=
ff 64bit]
[ 1597.283549] nvme nvme5: pci function 0000:00:09.0
[ 1598.372141] nvme nvme5: 10/0/0 default/read/poll queues
[ 1598.375349] nvme nvme5: Ignoring bogus Namespace Identifiers
[ 1618.928153] run blktests nvme/032 at 2022-06-09 10:57:49
[ 1625.557584] pci 0000:00:09.0: [1b36:0010] type 00 class 0x010802
[ 1625.558348] pci 0000:00:09.0: reg 0x10: [mem 0x640000000-0x640003fff 64b=
it]
[ 1625.577856] pci 0000:00:09.0: BAR 0: assigned [mem 0x640000000-0x640003f=
ff 64bit]
[ 1625.581168] nvme nvme5: pci function 0000:00:09.0
[ 1626.695897] nvme nvme5: 10/0/0 default/read/poll queues
[ 1626.701014] nvme nvme5: Ignoring bogus Namespace Identifiers

--=20
Shin'ichiro Kawasaki=
