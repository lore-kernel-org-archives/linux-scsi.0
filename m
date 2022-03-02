Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83EFDC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Mar 2022 14:31:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243097AbiCBOci (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Mar 2022 09:32:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243018AbiCBObQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2022 09:31:16 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2DE342EF0
        for <linux-scsi@vger.kernel.org>; Wed,  2 Mar 2022 06:29:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1646231360; x=1677767360;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=FKw/ys+GNv6V+5GksEhXIXOOxX9p/jCF7wCdAnjtEBfKMpbarAvi+34q
   sj+sjd5ozmgd3a6MALsrmHtarSO0R5tkt/xFeVFuPD4Pb/Asr/WwbR8U1
   FsZVZ64gBP2Xnb/EaTUrQfSOscxu7fVeUhHj1euM0NYLYI5QWfPtnKhm7
   WUuRgdMQOawPUR0eVklJjrgpet1MpLxGkvmsU+ZGhJm85B0+AwDlEaL6v
   hTaJfYu86tNW599je5WwAf/t0omC3iS6slumQNBiHGts3FG43RueQ9Amg
   6wZQvcMLhWEeALmA5qmCG1rtMJ8w0+ja6dnjg4lawea5DWvlWikuYkctf
   w==;
X-IronPort-AV: E=Sophos;i="5.90,149,1643644800"; 
   d="scan'208";a="306200228"
Received: from mail-bn8nam08lp2044.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.44])
  by ob1.hgst.iphmx.com with ESMTP; 02 Mar 2022 22:29:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HLAvBL7J+3dH8Br8hsY8I4inm1UcoSl91fZo6SoXACSPe89FsI5zGGD8cQedMiEyivelLdSKaI6wPvjNRXniy3Vza6XWikhiaYZvbxzOTEqMqSEYJl0moVJSgp3oYIYD1P1Kg4jrl+T2TApphs8o43RCztgAqO2MLrb97VsVVCnzOz+v6LpQyKFBPkNDJ0kaCBDYTVjdiF+rQ2DgUpYQWtcaSXmiqiTo5fR3dBYYdm733gynvQ/bekEzmpb6HjpS1NYG+1SRuaPkkYLJM/nB2FmHLBaEO1HOYbfCgCD0SpwrHpSTKgf5TmRVWTM6+xzg/C0qWGuSCQsNzHN+SO5MiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=SHbn2Ix5HBATH826CQtXN45HaMHgNMZmrcIOhKnQDhan9iRA+tNwoYujIJq3jUp+9hcdbyABU7q60ooU4JhwmLEgvbR/8P1zGsWdoAcfKukK6/ncToWrR56l+xRcMcaCoOwU8WUteDPHKCbAiLxHBGCiNDTajUGy9tVYoe5TJdgCIufSrQyuRx69GD6tQfuKzGA4x47nebLZ4DQbx90k0eoRn+A22nR5N+HkwojfT4jDawU8yOyiuFBD4QJX+QEHUjJLcDUSdai/o4oaWc2FbCt13+IQaHP7N3wBekW33yORX2PlGL7xQkl6m2LeHCsKM0DZ3Eq8ADLtoBUPxFf/Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=X1PRr+O+zNvYLKZPksxTkxR/oyVv5sTSiAUjVADE0Ph4OQpL3KYch+k+0wMazvW9D2OW4AY3EyyfgyF8diO4wxIB5Uvu7isk8mTyYSmPoo7Mg0Sa03hXPBhSk+WsoWw8JrYaUcCtgPJYaIYuQPr7pVnlekGWUGBtfzOr/Nu1hS0=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by MN2PR04MB6637.namprd04.prod.outlook.com (2603:10b6:208:1ef::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 2 Mar
 2022 14:29:18 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::e8b1:ea93:ffce:60f6]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::e8b1:ea93:ffce:60f6%4]) with mapi id 15.20.5038.014; Wed, 2 Mar 2022
 14:29:18 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 04/14] scsi: core: Pick suitable allocation length in
 scsi_report_opcode()
Thread-Topic: [PATCH 04/14] scsi: core: Pick suitable allocation length in
 scsi_report_opcode()
Thread-Index: AQHYLfd+9KgLhWMcfUiXukLYMrX+IQ==
Date:   Wed, 2 Mar 2022 14:29:18 +0000
Message-ID: <PH0PR04MB74168DB1817CE3405B1023E29B039@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
 <20220302053559.32147-5-martin.petersen@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c225fadf-a2f0-4320-7486-08d9fc59091f
x-ms-traffictypediagnostic: MN2PR04MB6637:EE_
x-microsoft-antispam-prvs: <MN2PR04MB663725725D75B1CCD96ECA7D9B039@MN2PR04MB6637.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: i9P33Yd5mJiAYTpWXnytMtXCdBaUAC8NxJwdwEqiflMFNYEMj/4yPfMwv9TQK4Gk/8/E/SF3Qt0vl2R0YLxCpOUt8Aq8htgdxeg/ihT8ErHf5s/kE3uEoWrr4AFD8jd7axCSRtq7SQkRvKUI9T1xvkn23p08erdeyS3p2+HZsA/wQPLtC/rbsZL6QYExsdnH0h4rwq79j3oAgAnptek4Kqy6V4gmjWv/q68opxEroxVMUcUVaG5wpePBNIW8X1iJhXd8waGIouXjeMSTbiWhtMgqpQO6CjnIuu/gIj+o2OhDUo1M3EilQVxuvE8FZWl+dcmypLxr9U8OnqXHfM6MB2qRphMjAjjdA8tUheEiMG1T7qb9TVvxhwJsQdZpnnDbtwqi6V16p/7z+Ol/QKgYvGcvlsxbAHqG7lWIdi4eyae9CjqTR2qsPZmCgMPg7QuYJ+6gRxJRXVAHsekWfcn9epZgeJOaLhs2H6/p+a/AxL+Lnuz/y+Rc363Lf7BloDex7CZda6z+AFRZDv1UlZhqZT1Z2Rdp6FWQiPqSb6h5nkltOd6gX7/HUqRSRxeCHEBSnHirMgS6qryk9wpHf2p2Tk5N61NlGs6V/o56PF8sYb6PjAtMkb/OI0ARt9YaIKUWDDiJipGfM/fL6sXbMfvRoz5pSQukLJTTZwcOaHmh+kjWG+UFzTLjYH1uE/QU2VxbUgAozFpl7Tye8UYLiLv/5Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38070700005)(558084003)(316002)(19618925003)(2906002)(71200400001)(186003)(110136005)(55016003)(7696005)(6506007)(66946007)(66476007)(66556008)(64756008)(66446008)(8676002)(76116006)(38100700002)(82960400001)(9686003)(122000001)(5660300002)(52536014)(86362001)(33656002)(508600001)(8936002)(91956017)(4270600006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vmM6Pp1YzkA6iTgGpvbgOJ0uiKlmUSHwja3j3xI8ItjZmRfHBWaDB8+6/AFC?=
 =?us-ascii?Q?ofEeS2rNM/c3zF+N+AP+8+YbexPaGUj+cAUs8lGqFHRuASZfAaI8S0k+ET3U?=
 =?us-ascii?Q?RI3moBBSkyMIZ1dKQIwaRq1x9pCha9oQ4xG5+UNUNB4jfnQ4GugtG2Jw7Dug?=
 =?us-ascii?Q?VvhcukcD4q47y+RrNKbIEyvb6bvwAPKZp7KgjZLzXP2cf5nyah41zyDJTmPo?=
 =?us-ascii?Q?/ct9DQEy8tRHIqle1vqkF3ZOcvJ4uR3jIuc+Z6mJFUUn+XIRlm+MqcsfZdmd?=
 =?us-ascii?Q?TG7lBdegKuhfw+21JFC9TV97/WfKLIWslKxoeuXwnevHUmfK6UIsPhZ9ToDq?=
 =?us-ascii?Q?EjkFT+Uh7EKMPIxpE1ekc0Rmyn+luubBUPjSjsUTHJuAtHK/ZpB+awyaluNp?=
 =?us-ascii?Q?qj1OFwaxV2LZV+9oyAOIesD6I1eudhxQoKKiVvPiArrp77VtLGQjvDoz2DJi?=
 =?us-ascii?Q?UrCiV0/iNl9DbNKMYf957J4inmdNzbTrxfgRciizKc3v8Vcgc+JUhrrXeYiu?=
 =?us-ascii?Q?IT0y4j18LDzcsyYB7Mn5rJ3t5zv0ErYHFA9Gfy40ns0X75wREc3jW5i3EYq6?=
 =?us-ascii?Q?8p/JUq95X0Pec4TIY3fVxgnnmY3uTzqrK6tCCivWdVpBxhrt5Z+FGEQqYVnc?=
 =?us-ascii?Q?97maj2Y+hwrfaWWXrczMsXYG9bbIBmLiXJ07gRU607X9aUDbjgX80PaigCKf?=
 =?us-ascii?Q?qPbLcxMTbaaK9pDrJdacreWNuItCyWmWGwuXtvSLrpljCrJxDq0rMst9s8uM?=
 =?us-ascii?Q?u2hRIPUNWyWcHlRSs1QxTwC9sehAP55aNceOSCnCJF0HkeeKTzn7VsDE1hcs?=
 =?us-ascii?Q?r/x07A2k13Zi7HBfkI7OXo5mm6qJCFEibvmMc7pgab6rkpofZRe+50K7Yo1S?=
 =?us-ascii?Q?ATzWb/wa/PkZIgw4m/jCVPodY0yosOv4HYz7o1Noj7aNq8oZMw15tcMAA1t8?=
 =?us-ascii?Q?+HyHfCY/jYXsexKBKxEIm1s41NYEQVadGWHD26o6bjh3U7VIDhgh19xCUvKI?=
 =?us-ascii?Q?84MgXcIashkeM1LOxzM3QDLJAHpJkl0Jxxz6ZsfvjkJymS9PGAJy1Rpoxww2?=
 =?us-ascii?Q?2FuP4JiJVGRj6Faz0ECtDFh0xmzDbJeEuo55S2N+B7brhubo3UrtQDnjM9nL?=
 =?us-ascii?Q?HqFduNdjCkwCL6nqdTmzdVZo02fMHCI9wapdI2ZvAsvCxrPaIrXCzDJFUO2l?=
 =?us-ascii?Q?1+m2RcQ763BN/K9ehDaUBZhkRStFhhY9sKGglDeL7hdt+irIBPON7P3Ekx7m?=
 =?us-ascii?Q?hHLUgy+6gPQjL4iw1JdLF7C504UGMaP+Y0z6+2QbHM+n9iPq6BjIQt208Pqi?=
 =?us-ascii?Q?yKViBbuZQoBjD6EWj6uz1Ar3XpFiHrvs7AFcZW/OSHnneCERcogis/mbCGEO?=
 =?us-ascii?Q?IwBqOYoGTFWusZJ5RZInS61JgVSxk6D1IBj7DH6uTtB4BKc9JhdIfD3GdfHY?=
 =?us-ascii?Q?Nsc2YRP53xf781hWmihB6kmtgF0DkAKhR5K3vKoWjkzChYv70psi97P8Ipdp?=
 =?us-ascii?Q?GeWgXVAKtQSRzh4lAI80u6S8WR6SC+FaBpp0iQdm/9zhbDzYQujKspE7jMNI?=
 =?us-ascii?Q?J5Ff+K+41+PIxe8enWYW3PADweBAqdXOeplYv0ZMrvLliwbIfByQr6QA2AKL?=
 =?us-ascii?Q?mkalxmBtIVAvev5O9rDvsdYKDQMq6Ep/IQpgLrY1PhruiqchwftYYWr9nZIF?=
 =?us-ascii?Q?KVg7POR4R2FdDanamxhjRcyB8nz2V12Xeu4TIR6VYY/yeAwudtzintWcygsV?=
 =?us-ascii?Q?jUTvkzIEHyyww+54omMuV4ERW/toB3M=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c225fadf-a2f0-4320-7486-08d9fc59091f
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2022 14:29:18.3575
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: njj3Z4Ckp6taQtEVjaxRF7b1zrGfMc4tRgZOmY+CuZTb50hdkVi+ykxRC1Q0c9smq/M2Wcww8G+e2moqSjFy4X3oLkGdjnNQUEqNJMePSS4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6637
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
