Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A400C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 15:41:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238498AbiECPpG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 11:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238684AbiECPpB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 11:45:01 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C779E2C127
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 08:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1651592484; x=1683128484;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=cMcdoswh01YFzawx9mTqTnk83Fi68zBrskHjLCAl/sgt8ljrmDalI0YR
   OnfkehMHp6SP+/BpsTgzwAeEjwWVQWftqXBHiPelGOUSw3IVlkH2i0VR6
   pbJc0TnJHQ+7j4ro4e8Lv5gqFCRwEUFsWUQK3ozkXM246149Pe6q1AH9Y
   3jPx02/LFvesvhUsO4DgcYBNgIWQd/oxvn43GYeRc6vhU/NsiJuaMSMAH
   AfkV2Jr0C7eMdfqw0IdnA8r84jcM7aa8rka3pdP4XThcfimVoppTvFNvx
   N+/+YNKCFIDnHzjQzzvFrG7xGQfUkdJrkdaWZcaRsRorDLV+7n2qgVsEz
   Q==;
X-IronPort-AV: E=Sophos;i="5.91,195,1647273600"; 
   d="scan'208";a="204299598"
Received: from mail-bn8nam12lp2173.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.173])
  by ob1.hgst.iphmx.com with ESMTP; 03 May 2022 23:41:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NhbDelrMhu2/wIUU4CWnpVCznYBl4OI/Q7fmWNAMKFreP9eVUu6oW9wiBc9DAaWjB77v3mrm7d2wOovkMal+tVJXboCnkLglGzWGSrX3K7F7ak1ABPlMoLi3UM6QB5orY/A4Jwi9airBwe6Nf37Pm5DWVH6866/FbEj+G/g3/QZ459xEM8cwe/QzSQr9ZA/AZjY4VoPVjagcF5Q704IOCriBvINHElxqgUynXGsjVFXp6+wRVdwvMUCPJG7WqenJLTL5KgoXtBFrj4EO3r/CnhiOk37brtvtGiUbLOvz0JyZ7R72L8OEKcQJJwtZ6z6iiNzZhX3svK+ZFEXNr7rsBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=ksoa30O1BGS8C+yxdSxoBYEixCO65LjvFS9BqBHDRzirfbTDZQbAOPggAJKYrzMZovSsNjqtxuPk44BAD9hMoHkZJoyE/SXVJJcoh/tv03Pd6S6qTm6pRMAyVm37KF4tmdXZV5/yWYeEcrLpD9UaXIG2q936GcA8J/lTK9SJRYah9VQpbGVbZjirc0rqpOBrERneSM1p/hhIgAVJ1kjimYn0aH0F0ASe4ilMHnMxqY7+5s87Nvnh2xzx6tq/XCBdDIQJiX9yvYgtZd+CgtnxFnK8w+8CoMEdqaRRNoQ6tz+PaU5xFMBHWSR2kampD5W2a8hWL8nYp2sGi7cDDrDrvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=QTAG5UI1ZluabnUOqiCdvo7Vk/TXgQy6m0TuJiZT5FN3HwfqyRCcYl95HL2qykRTkCvwU4hmOI9vZxtnD+swvqoCOIP2gTlIJUN9Qmoe8I4m+3v2XXqyoD52ZwdPYgoxl9660JMiYcj+gjBhoDuH/DN9fk/vdXzJCVkuYu3rzFw=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BN6PR04MB1012.namprd04.prod.outlook.com (2603:10b6:405:47::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Tue, 3 May
 2022 15:41:21 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::6cfd:b252:c66e:9e12]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::6cfd:b252:c66e:9e12%3]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 15:41:21 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 17/24] snic: reserve tag for TMF
Thread-Topic: [PATCH 17/24] snic: reserve tag for TMF
Thread-Index: AQHYXm0eb4/OSmjAx0mC7fuvogoV+w==
Date:   Tue, 3 May 2022 15:41:20 +0000
Message-ID: <PH0PR04MB74163777FA65896AF7B3D1279BC09@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220502213820.3187-1-hare@suse.de>
 <20220502213820.3187-18-hare@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3b2ec311-983d-4532-b3ad-08da2d1b5f1f
x-ms-traffictypediagnostic: BN6PR04MB1012:EE_
x-microsoft-antispam-prvs: <BN6PR04MB1012CC9C2221D8E222304C9A9BC09@BN6PR04MB1012.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3ZQ00ab2BEDE2Q25o6ArRMxeZleAkcDl5d+zIWo5Q71W8kJnJCLQ8ez7YW5oTV+GAjHgncYHWxycCjqR8lnLhtuhDJsqO2k7zbL2NlVPRzGUPEa1CZ8kYP3aipc4KHVYjq04UVMcpFEATqxkEc2lKPp1NHsMt2pM8eSgmjceZnWWg8x/w/9p78ZD9zrSwNLKXdzqJckhQq36HugDe5VoMKfn/pvecRMZxgif9gHSdxnSx/WMj2g3nJllGsEdJUrtvO7QZt4O23G7sJvG9A0nUvqF3iwMPt7vvvZAn2xXP5HDjqYK6lSWQl3O3rn/zrzqcy6qA0ZNTYOlVB1EY78WmetEaLKqGQgHKoGiJMVlLDPB/VVEs26+vfETdWIijSucCpeR59NlEA8PE6RxCrZuNS9Eum7P2FOj5mxXwSDhnQAx4UN1DIg3lgYmRShWW/MukuFFHxlu9IkHte1VmzhrJogYV9wKbHbiPx5FcqFXhgKa5RXVUqbeSQj1Q10gw/Ah7xO+SbM2l/tMMphJk7uv/YAC+XI3YdN38ax3C55IeA1FDQvD5rPq1YZ0B5Rt4QgzVfnCa7Lcjo1BHIoeBYL7EqzP9ADlAdns/GWZB6mFzWYkFHCfqEt73iYpSugImwXVClEz69NXc23nBn69WY0HbaAJwq0NTe1UEt1YW8ayDil4FYmYq5g2fo3D9qPR5dlM/bM+3TCrNCWVQSrgQE9LYA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(54906003)(55016003)(2906002)(71200400001)(7696005)(38070700005)(38100700002)(19618925003)(6506007)(82960400001)(33656002)(122000001)(4270600006)(26005)(558084003)(9686003)(8676002)(4326008)(316002)(5660300002)(186003)(8936002)(66946007)(76116006)(66556008)(110136005)(86362001)(64756008)(66476007)(52536014)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?EIfDEMau+ToNyy7y/STePsglQRnz9pCbFCe2AkF12ezY6d9wskESOg2azg8c?=
 =?us-ascii?Q?tDLUw7aR5XRwBrq1+vUV6qawj0bCBFr4qdtBWfz9etjSignX4L8LP73Rv1pb?=
 =?us-ascii?Q?FgOnzqyns4GXa5t9J/SGcFLmbzaaTTG8vba3RGmenU2+O97ai+rxvHu4bpuw?=
 =?us-ascii?Q?ENnQA/zEEhUFrPsoQY6vyRKvp2a2IVdK0P32RZBBWhauUgQQsQxFBmSS5fZT?=
 =?us-ascii?Q?0ZQdzH04k1S0aApoMD+iJqwJOMZMuQsYUtYFt7zH3daLHwxdFbLmE+16/qXD?=
 =?us-ascii?Q?x4SGiz9iQnatI1VXmLbph2cL6XeKwr+YcDmWSAmxKRNXtCszVLM98J6RL43e?=
 =?us-ascii?Q?0sXrF2hV0B4gtc1SbU+S6qeJHqxAjSEfNsZ0VANJlu8sIq4cFX+G0RwTUoKD?=
 =?us-ascii?Q?sojSQGyz71aQ76g2V4+6llXWepxjSq4bqQEozWtJeQMKDFzcADkOOrWyyCFL?=
 =?us-ascii?Q?NDqtEvF/5xsI8u/eJxnJ3dPKwc1n9iC8Rw08MS4ox+4d6XlOJ+HUv99xvbpS?=
 =?us-ascii?Q?xC+yT2W4G2BG33nifb3R2y27otDr1pFqMOeBkKC1pbwonVN24bv9gxIS1DK/?=
 =?us-ascii?Q?W7jx4u0W3iYXf2L3s4w0sqXskyaUjU3IW9xQbq22h13M2kN+RGnwMX26giG8?=
 =?us-ascii?Q?MwKxOsIuk5vzx3qW0zOZkmGk4Xz9FWDBtZfIpgTXnALRppNvAH7e2KsvohMD?=
 =?us-ascii?Q?oj7LAH27Z8qxTi3LWfdwPbADCTGzayNfkJTqqHnKGCPc+jWWjBJ9M3/7HG4+?=
 =?us-ascii?Q?n5dV0a5BQhuGu4MRxi8Da5lxC/Ha6YQJECHahqGh/wyTgKJ4rgxoFaH2Qb3w?=
 =?us-ascii?Q?RIxkIYWAljEhMxMCGYKxMvUeWt+mYP74yEIC3D8jfgQd2Lj7aEliJQB9SHNI?=
 =?us-ascii?Q?pcpmenAl2C6YAZ+PFxt1x0abp7059fI6DtgVuNjRBEvmet+nZkmFEIj4NQWE?=
 =?us-ascii?Q?0/Cd5JAS9M4PED+3VcYaoHRWqFAUWbjwfimxA7XbW8bC2yUDRRGTeyf3UKM8?=
 =?us-ascii?Q?Al2NMQPu7niWHuxjrUJZQrTTqJdTlyFON5st9qPCCE28rLm/6wlYVYexKGCQ?=
 =?us-ascii?Q?JtPSao2fojQbR3vZnIl7+5HPB0rFvclwypK+FlWZnfitQhtnJOG0FqFoOqJT?=
 =?us-ascii?Q?tjNkpkEEc8gsn7IeUidULQhkUrQMCR8Jleu+mjLSuak7lVWbFlUssBGoQJjQ?=
 =?us-ascii?Q?yahZ5By0SzTk4VEnaajGTEpaT+iR10A/odLvemm4dUN4WYZls3rp+vU5BgvN?=
 =?us-ascii?Q?bYP0eX0dtEMEg7daVcqcIyQumVVPhC03gxTfmpsf5pjLtpM2QvIbkDFT7PqV?=
 =?us-ascii?Q?Ri4pn8wuQ3QDPgvfm5H1ibHd/FoAQO7mXQzqq3xENTohIJoR+vHGzEWvPolU?=
 =?us-ascii?Q?3MEsUhQWzJnUQihZtCMTLLkpm7SnDYEDrvdQQR9SRNKo3d2z98JR2msVLost?=
 =?us-ascii?Q?TIZfEa99c+WhhIQTqy29ziSZjmiu6wUicg/3V2nZmeFutyZynnC8EIL+8vED?=
 =?us-ascii?Q?DeLRLB9Q5ZxCagCxOUjteDEN5mT/eOIJ6cW19qNJ82uMDDTO3WKZGqSHKOA3?=
 =?us-ascii?Q?PUyDg7q1BEGnuPbLi2uyutG1pRKdLPX96NK1ZNXre13CQ+Sf5X1oWbuWEYbY?=
 =?us-ascii?Q?xX+4TQJcqLEs/FAUJg95ynds+ldb2OjqhsbcvwVJ0VepdgDre9Cc6BW94ziZ?=
 =?us-ascii?Q?0OGkoZNqmg+BogTEZg6hfhg4exjBM5nVza6sYbKnoxdkYk/9BHoFOPscKBIh?=
 =?us-ascii?Q?zzVmbw3JDllSlrb7IEVzdzRFxzWNV2M=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b2ec311-983d-4532-b3ad-08da2d1b5f1f
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2022 15:41:20.9314
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 44Yo6gkRePYVB+UEtq5ZaTxMISoTAInoRLfZ1f9G9Jg8OdCopfQHqtSU7AEaKdxHVUJicXAOgDA0pnnPfdG0VKOOeAwVCoepZ2I53Gs3sb8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR04MB1012
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
