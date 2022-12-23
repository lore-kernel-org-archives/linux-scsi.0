Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89253C3DA6E
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Dec 2022 04:50:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbiLWEuu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Dec 2022 23:50:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiLWEus (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Dec 2022 23:50:48 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E40BAC;
        Thu, 22 Dec 2022 20:50:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1671771046; x=1703307046;
  h=from:to:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=T0O25EqAgYOyGBX6Np5wktps2Iso6jV5AUQnjOZjUnc=;
  b=noGnlv/dU13ljv5LlAbosNp7lvyitgY+x8rfYDwtFGhpzJZy5Hc+2yBF
   DmR4YlzGbi/4nprkdzlasv0fhrUHBjR33FO7u1j6WaB0gZAahI0EzC9Ff
   DER7c5iRxGQ2UJrnmxyWp8hKczFPFtudiZFWf3qMbveDKszGSS3bFLyvJ
   lf9DNqlPkcbgEPsPahufawR+Pe4mqLpbBkarsiTZFX90Sz3Fjy6SPFZEe
   4MYzbeNX2J5TvXV8/HE/i8njnbYEm9pUz/WjXMtIEtb5XSh7PIT9VOpl9
   SRKAlETuFjLQE33yZaVqAqsFBbprrmqN8Z0PywFRuvMWW7xDxDjqOECBj
   w==;
X-IronPort-AV: E=Sophos;i="5.96,267,1665417600"; 
   d="scan'208";a="323661537"
Received: from mail-mw2nam12lp2045.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.45])
  by ob1.hgst.iphmx.com with ESMTP; 23 Dec 2022 12:50:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MKdHayFMFP3SDynTzc7VPys7Jp8v9pLxgsmTRLikzNHaGy+KNlB8WaMEALFc/SkrH/wFpPmsYDLJWEjaQ9fsE6zZNW2y11vU4MP4D1H9xFRbus66rsvnQMtbEF5Of/4KwCYXLICyTO6Il4DUG/ktXcHlihEvILUPJ3xB+R+cWT2caikFAiSPsk4Sgv1DWv5DzecUJppBfML6dIwervM/pVkvGVxxRrvSymI4jWJeCx8jX5Snr/7EBybwDKl6VMh+T1D68xngZSaJuUL5TuOu8xcv2293En1ocyTOhNHfDMOEI4v0+dX+u74p6vzhUhKJ5Vb092oUweyiLZOKRPJMug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+ojRaUPUWssuAtF938yB6zffx+lCn6D65IXEE/7Hg/k=;
 b=GkbKu/a/wqr+fHvLz8LbiWe8Fqa1qLi4NIZkHVdn7ebaDGazdRvGSlzxksGpHmEWhHJQHrNjWDMBygnjipV2kZeoyg3lIg/SaZtPqaOK3uFXGcs1YxGFGpMa+PTMZyG/eHZp5cnuHENNFChz3sjRLUFF8auA1GR2xoI9Pdv2+bFlo7W+xCc0j793IeQLxByY2e4FHnmk6ugnFhjcK0N9hevALEkK+xpd4LfZl7saTlzJEZsax0Dpn2KKcCsRHL1Ak1jXx/YYh+aKpu6bVERFBCiRfCuvota06QHDTxAW1E1XJK92kljVsSVNgmRBHbhyesEnXmXm9c1bzPsPWFk1SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ojRaUPUWssuAtF938yB6zffx+lCn6D65IXEE/7Hg/k=;
 b=w/7aRIrgAWYrYSlerNMW2tVh4J+l3HRkEMhfmqDjQj9GmC0R7Co6kqDMPpOYkRxD5wCu+zSUJovq7wHdAhjdOOlKaPwAkHnmT+OxNl2gKO/z8xsG8BXwktFEjgNpK4NVc/kxJinwv8TlCEzp8J5H2DwOipCIWI58922+DccmxnE=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 DM5PR04MB0300.namprd04.prod.outlook.com (2603:10b6:3:74::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5924.16; Fri, 23 Dec 2022 04:50:42 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::e5db:3a3e:7571:6871]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::e5db:3a3e:7571:6871%9]) with mapi id 15.20.5924.016; Fri, 23 Dec 2022
 04:50:42 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: blktests failures with v6.1
Thread-Topic: blktests failures with v6.1
Thread-Index: AQHZFoocnkF/69AeD02U/IcKNzVbOA==
Date:   Fri, 23 Dec 2022 04:50:42 +0000
Message-ID: <20221223045041.dl6ivxgo25eiwy33@shindev>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|DM5PR04MB0300:EE_
x-ms-office365-filtering-correlation-id: b05d8200-2581-456d-b1a9-08dae4a13f1d
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /SFB4MsmN5T/5Aw+YTleenbGFdCLoDqZcMZi7e3wToh3yRaB0WuLnvGmid1kbGkm0h0EK2ba7m/L6YYi7YuKwdAAH6/7sMP8cexHzUiDszAboUoYJTqij762S9aHh3XSYBHdc2kgIXeHaWNTg804pj01JiHcvjpWRT2RbGvI+nhVxX2qHNj3A8s7u/Utnq0/aOgSNns2aqyj/PdrjW7gCMoPxw7rS2f9C6THYGBD7lSe8afHfryd8CmSysfh2nKjmgvJY0E0Asmw/in8OpkCcJWCHZg4sPRghSmfB9K3XP1YmdA56l4FNF2hSl/5NTv5C/xBMxvW9Wy11cTpcLwceMoMccDOPSfnOhM3VmM7rGZN4o0WT75K5YasmrylQMQ6oq36zsoEAofZsYABEA+CyASfxHL6d+PfgQ1xr+b8aQbg6c9w0IqSLtbIY/JHZX2d+2myiCMNHf9Rr3VmhUm2GHMbkDSw2STVYTSumxqTN6kq9mh/dGN8BTjVoobBVUAmy0Th3HBVAKbb1ecuoN62+WmcP2vvZNK/1pF6RJz5UyI+9DmOITN23vgQIPWHt6t6rNKSRtzeL9NfE4/ow+E2pLq0x9Doju6DCK4MtE3dNkZE6YO0FvFX7ovn6Fil3xw/FdpigQobg+xEw70PgovEkTA4WMZ/EC9LHSoRuAXFVKeDOjjYUb+HIvmFTTwJAO5ml661Pb2g52BP++e8bYg0VrdSDuYh9n0drwaYkue76JQkLnDNUOJrWNJ9iP8K9n37RwfQ5KP5A9QdEfXY/Pfoig==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(39860400002)(376002)(366004)(136003)(396003)(346002)(451199015)(6512007)(478600001)(26005)(9686003)(6506007)(966005)(66556008)(91956017)(6486002)(186003)(1076003)(66476007)(66446008)(64756008)(41300700001)(8676002)(8936002)(5660300002)(2906002)(83380400001)(44832011)(76116006)(66946007)(4001150100001)(86362001)(110136005)(38100700002)(122000001)(71200400001)(316002)(33716001)(38070700005)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2YlyMvBiJu5KmjfCLs4wTRyiDqJqLFvpMr8OwAaUowDc3yWNVxAKWLRuJEnZ?=
 =?us-ascii?Q?gueTDkvMeI3pZavDLRAGuzGz4YDjuUdmrOVOCVD1EkOsLrvbslGrVGOWowei?=
 =?us-ascii?Q?2SXhbP+TtYLkVf2E2xjEoQoum0JdqWSiuW4SJXn+Tv0N5VoWESyuYr/y1pvO?=
 =?us-ascii?Q?oFpgY3upDuYArap77u8LEIhxVF5i0rphKAItw+muKDGLcGWHuhlDaRoIFl3P?=
 =?us-ascii?Q?trR7DvqVpLN7KApn+cjzwRQU+xOnuze6KJkUj8butMtoCzoNvWYWArX/kdWR?=
 =?us-ascii?Q?QtWtoeCyAMOQdh/pCU+Xd2xR9ywiFNFsjIb/y4Q8JLv4oOVjcwQcb5DkYIaw?=
 =?us-ascii?Q?Qd9gTuBH85G1buVFu6tZS9nzlQ35wq1uRE1BBgcCFZkEqjafzEF9Ckl37XRA?=
 =?us-ascii?Q?b2un8anXDuhOHfnOL7Jv21KdeWsK+pTHQr4dCmhDGE1/N+AtXl4fwXElGXQY?=
 =?us-ascii?Q?Q9CkXi2AoUP4ZP5xZULV8kL5PGN/iYvEkYdClsODAJ3jkWL2GmeWr4Hp0JwT?=
 =?us-ascii?Q?rpLx0T03dWVSHUlk9Z2h0gdmwdN5GieKlxhkUJUBfbfx+eoJCKDXNuhKx6wW?=
 =?us-ascii?Q?40HXJWA/Qsprn1tiG5miedBDVlf12a7YdogIJ+H5U1Hl+nzcRHC1glfLTee1?=
 =?us-ascii?Q?YaSvSfeh0eRYZM61yk7pEFH3nXR5f9y4hLshJmqeD7w3DF5xpb9kx1DaHV5V?=
 =?us-ascii?Q?UliPNKQVYTwCDiKYJWIiv/4VQJd0zZGSJe5GL6TejNf4LHnqU90zdDdwx1XY?=
 =?us-ascii?Q?OdpW620jsR7diZxgE+Co7i/3Sy8ACjvAblK7MyFZiuz6uYUKCAm3GOO2HF6Z?=
 =?us-ascii?Q?8DpXX5qr9Lx278h5vgmJ8924hmxcaOwQxuZ1XdrJ5lPuPonv15sTVz/FNYPX?=
 =?us-ascii?Q?Q4Pspd/0HnCyVWlksguH7yigXT1nI1uhO2qq9TRXfVRzjdUJSnIKLzhE9X9e?=
 =?us-ascii?Q?KWgv7sGdi1fl6h/NZC2vEmHeCt+vMu1cRreUP42G0cMag2uMzZN3iHZk/W0X?=
 =?us-ascii?Q?3jmbQJY5QH6dUO080Eqx1KU2At0RT0F1oLvHzD3PFa4Ucu/7Y+SGKoU8veZf?=
 =?us-ascii?Q?6KmuQYlolpOIK9CLBgdIZOVh7/QXRKcwOIxwWzhXlFmBXiYi7rSWZAt7H8Ax?=
 =?us-ascii?Q?w8pWp6DfF5ZnIGlz8Ht7SuNjtKRs+6v9bLRuofE+RaGHO0Rg48Q6r795eRoL?=
 =?us-ascii?Q?HkJoV9ITUCBFmIdW1TnL5q6X1Z1QiiiDRV62piHiEjz1DqoPLUptQUUDb8no?=
 =?us-ascii?Q?ALmPtQM6t7ve+kl9ITcKpQhRPp/vE0vDoZlY9FQHM+R2PsOvul6J+JaH5Nho?=
 =?us-ascii?Q?+34wWnqX4RY3SNvhewj34O6sKUOSJEa7U4bTpiSfvult9oq/DxfaVPax9Ws4?=
 =?us-ascii?Q?MHVBsFejIzHf+Ur147bJWj2Mshy3BUFZrCWRBt8QHZEjGwER4GfsFNUrzWAO?=
 =?us-ascii?Q?Il5gAOTPkC/ZUAoBzt2O+yNhjPP+BuieRu3dIddym9GjenA3uzXOOAzKuvei?=
 =?us-ascii?Q?bz00X7KEMzamwlfZtDN6xcSkpznrF5B7aKiXfEIHhrefD1v1tC3xVbtiIrXo?=
 =?us-ascii?Q?up1b7TpOZIJ/gNg8CBO2cvOUYdpsp9MrKBmFUkAwmK6VS3mPV9kZ6NuCLS2Z?=
 =?us-ascii?Q?nn4Dz9IwQYXq6frKd3gHIq0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <85E430B3C746584189470E5ACAE31D75@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b05d8200-2581-456d-b1a9-08dae4a13f1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2022 04:50:42.5499
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: //SlWFckY60dMHl/iYLuUvA3JcZzvE5UCw0W82OJZEjWbBEVoPkcFR9ZIc1G3L2qwRN8kZPAzL2eH5jsAPHxSYyBDZ0nc2JpktSR47DVV+Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0300
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

I ran the latest blktests (git hash: b35866f2d0df) with v6.1 kernel and
observed 5 test cases fail. I call for support to fix them.

List of failure cases
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
#1: block/011
#2: block/024
#3: nvme/002
#4: nvme/016
#5: nvme/017

Failure description
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

#1: block/011

   The test case fails with NVME devices due to lockdep WARNING "possible
   circular locking dependency detected". Reported in September [1] and sol=
ution
   was discussed. A kernel fix patch was posted [2]. It may not be the best=
 fix.

   [1] https://lore.kernel.org/linux-block/20220930001943.zdbvolc3gkekfmcv@=
shindev/
   [2] https://lore.kernel.org/linux-nvme/20221012080318.705449-1-shinichir=
o.kawasaki@wdc.com/

   This test case shows different failure symptom with HDDs. Need further
   investigation.

#2: block/024

   Fails on slow machines. I suspect test case needs improvement.
   Need further investigation.

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

#3: nvme/002
#4: nvme/016
#5: nvme/017

   The test cases fail with similar messages below. Reported in June [3].
   Fixes in the test cases are expected.

   [3] https://lore.kernel.org/linux-nvme/20220609235329.4jbz4wr3eg2nmzqa@s=
hindev/

   nvme/002 (create many subsystems and test discovery)         [failed]
    runtime    ...  119.796s
    --- tests/nvme/002.out      2022-12-13 12:42:53.694306873 +0900
    +++ /home/shin/kts/kernel-test-suite/sets/blktests/log/runlog/nodev/nvm=
e/002.out.bad        2022-12-13 14:06:35.864050520 +0900
    @@ -1,3003 +1,3006 @@
     Running nvme/002
    -Discovery Log Number of Records 1000, Generation counter X
    +Discovery Log Number of Records 1001, Generation counter X
     =3D=3D=3D=3D=3DDiscovery Log Entry 0=3D=3D=3D=3D=3D=3D
     trtype:  loop
    -subnqn:  blktests-subsystem-0
    +subnqn:  nqn.2014-08.org.nvmexpress.discovery
    ...
    (Run 'diff -u tests/nvme/002.out /home/shin/kts/kernel-test-suite/sets/=
blktests/log/runlog/nodev/nvme/002.out.bad' to see the entire diff)

   nvme/016 (create/delete many NVMeOF block device-backed ns and test disc=
overy) [failed]
    runtime    ...  46.695s
    --- tests/nvme/016.out      2022-12-13 12:42:53.706306913 +0900
    +++ /home/shin/kts/kernel-test-suite/sets/blktests/log/runlog/nodev/nvm=
e/016.out.bad        2022-12-13 14:12:30.566239949 +0900
    @@ -1,6 +1,9 @@
     Running nvme/016
    -Discovery Log Number of Records 1, Generation counter X
    +Discovery Log Number of Records 2, Generation counter X
     =3D=3D=3D=3D=3DDiscovery Log Entry 0=3D=3D=3D=3D=3D=3D
     trtype:  loop
    +subnqn:  nqn.2014-08.org.nvmexpress.discovery
    +=3D=3D=3D=3D=3DDiscovery Log Entry 1=3D=3D=3D=3D=3D=3D
    ...
    (Run 'diff -u tests/nvme/016.out /home/shin/kts/kernel-test-suite/sets/=
blktests/log/runlog/nodev/nvme/016.out.bad' to see the entire diff)

   nvme/017 (create/delete many file-ns and test discovery)     [failed]
    runtime    ...  81.274s
    --- tests/nvme/017.out      2022-12-13 12:42:53.707306917 +0900
    +++ /home/shin/kts/kernel-test-suite/sets/blktests/log/runlog/nodev/nvm=
e/017.out.bad        2022-12-13 14:13:52.828515799 +0900
    @@ -1,6 +1,9 @@
     Running nvme/017
    -Discovery Log Number of Records 1, Generation counter X
    +Discovery Log Number of Records 2, Generation counter X
     =3D=3D=3D=3D=3DDiscovery Log Entry 0=3D=3D=3D=3D=3D=3D
     trtype:  loop
    +subnqn:  nqn.2014-08.org.nvmexpress.discovery
    +=3D=3D=3D=3D=3DDiscovery Log Entry 1=3D=3D=3D=3D=3D=3D
    ...
    (Run 'diff -u tests/nvme/017.out /home/shin/kts/kernel-test-suite/sets/=
blktests/log/runlog/nodev/nvme/017.out.bad' to see the entire diff)

--=20
Shin'ichiro Kawasaki=
