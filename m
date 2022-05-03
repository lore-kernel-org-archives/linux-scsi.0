Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D16F5C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 15:20:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238215AbiECPYV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 11:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238422AbiECPXy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 11:23:54 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D50ED633F
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 08:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1651591221; x=1683127221;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=RcZOuWDXu1lv/+lz6bnweIWXt1SagV/sa8/EedNEnGfMzeuajK/xlNB5
   64smZ/vQ3m7PyjFVFJ/3IzZUG8isWlExT8vZMKuRW4KshYDH0WKJGIBJG
   hMl+zvFbdGS4VBEMJkf/XzWpbrXiIt5oshylGjMvtYUHnbnsBmH6jWoHK
   W82TpbSpl61F1BHAkdWkDwS7pk3Cw3tzmT5mF7uZ+8ECscn9KIvieD7vv
   gqNfO2F6rM7flZWiccYkF2W3z6HTtBg5QyrNLnAyPsbXN4hjYW3OEJXoK
   aF3vcj4WMrHLwke1jmniGgdj4F2Jmti8RGiYHosZxd5+b2bWqaCZNPEYw
   A==;
X-IronPort-AV: E=Sophos;i="5.91,195,1647273600"; 
   d="scan'208";a="198264718"
Received: from mail-bn8nam08lp2044.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.44])
  by ob1.hgst.iphmx.com with ESMTP; 03 May 2022 23:20:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lDDsx9BhZ+MpIDjTvVzB5lB0Rq4WEznqkE1SMFLiW8osa4mOksw5O/dKVtXWIdcFUMfmOyrXZy1YdBPQimmTgZCNK5pFfDAw9oOhoc8U17bEIxcPdZsn3f+HyGlDEPzBuuBVntLINB5I7cIAEVEoXantGAVoWZiH9+fBHJW9LP4gkENh8OE85iHj0FWFZrHbKmoRzSHImyI5xRxmMQMu1rImzErZZQgEc5ZdSFiS1uxofSTljw1nMidBgDAJapmTDjq91BaQ8iQNWZ+UzvIpo6yi1ZW5DqeQ+jPUb+Qi34mlJP/1ptuOWVRm3M90Z5ncP7jV5EfYC869hg2wmGavdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=f5hYAEXwgB9C7hdh2jTW2NsmIbd4CrZuor6tRsiyZHxcR6xzaVfdBZnE+A71W30FHyUUgJJYdQdceCsUhSEU3HHi/etVQypt/NgQcOsFZ9nHyLWMbPzKDp0wNUdWvSBoQHNVF1gWsBSb6tr7bywNGI9zJNjziaURFw1oxpNfCGUIdmWyyOqFSi2QKu2vAItQUOIyD+HBlbesarHPalj3dZqDgJ2Ak/CTvxyhcw/hpg6AHT0s+uNcIC69+b+TGim1Ox/vVf7Fibqhi3r7gfnY0a2G6y+Dzbe5ytsLggasCL4P0jfshrVAwjo+wF7nZYxH33SCBPVOlpdykxJt/OueiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=rn2b0QIgrN2PIpP7JF7NTW2QBO42WcWW8ZjadExEd7b6T92xDvIPoX3qo1hwE/yKUS02r1nYvwkLLJHf4jJGJ0UayBkfpv3y9TeLvLn3jVrgf/L32UBNzl3fSU5wh9Vnha7ns52DEPr4gtX8xOdA74d8JbvMnp3hXECS9nsLiP8=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by DM6PR04MB5115.namprd04.prod.outlook.com (2603:10b6:5:fe::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.20; Tue, 3 May
 2022 15:20:18 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::6cfd:b252:c66e:9e12]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::6cfd:b252:c66e:9e12%3]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 15:20:18 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 10/24] ibmvfc: use fc_block_rport()
Thread-Topic: [PATCH 10/24] ibmvfc: use fc_block_rport()
Thread-Index: AQHYXm0Lg1zVZboN80ijdMz12mELZQ==
Date:   Tue, 3 May 2022 15:20:18 +0000
Message-ID: <PH0PR04MB741697BEC0D325B9F9009DD69BC09@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20220502213820.3187-1-hare@suse.de>
 <20220502213820.3187-11-hare@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 75fc8999-1b12-4f13-e9bc-08da2d186ea3
x-ms-traffictypediagnostic: DM6PR04MB5115:EE_
x-microsoft-antispam-prvs: <DM6PR04MB5115495368C0A2983F592F3C9BC09@DM6PR04MB5115.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GzXg3n57WrbYQHS7daJaXOZ77xpyP5VHm7AJ5+yV1i3rgotxzRlUMQuXYZPwNMLYyWHvgNtg1MYxaYaD/wkGgy02TZz5fGxPM4vKZ5o+Y1gTi9Q1Esy44zHn8ulTEaDhSaF5e9+qzKW09+iFQTUg3QNfwU47D1IXnxCsq8mczMgkcrDMD3jHve5svAPgvViOBr+dt3D/aHH8sj3iZm1A3cmKQwu6uzisc0bXc9QvzMm6asKYlXrDzrAaxMH1LoTLFEF4PIjTlm+yyQoHtr5jDsOvemIFWWNzDYcExb3WUSBc02cD2LpAvCbILgi4vxlz9VUSX88BOZXOTGUZ9qzsrdTz/H9ruHWT1uUf1M6akDymBJlsNiQLlknuwSoWA1JpIQbfXyKjKBxDnMXPpO95gtkVjUK43MAHqd/90JqtBNy7mbbFDpbClJeG+ET5/IpZwQhUwbabBrsfoa4Crs6v/2lIJlReDN1KL05JWHuCJU0Cwcwfacl1NK6KyvQxNTw9Dd8ahsvcSZ/CK+7zITN+nRn9JqnuHWceQqgjsfD9zMBXE7l6CBiBZkCLKoGylAr5g9fM0Nv/nTuvpLFu7fF9UmfeeTU/+2mvdHxNMuiQr2rY8c1+cC6kqX/zd8fWSVQVJq02R6k48P7juZF/AinAdrCsjO8tTWKJTsjOjsv59OXoreVugHDBOavLdF6SeUg57UDaL9e2JKUV7OiQHo5k/g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(26005)(4326008)(7696005)(2906002)(4270600006)(9686003)(52536014)(6506007)(66946007)(82960400001)(66446008)(76116006)(66556008)(66476007)(122000001)(8676002)(19618925003)(38070700005)(5660300002)(38100700002)(110136005)(86362001)(71200400001)(54906003)(316002)(558084003)(55016003)(508600001)(186003)(33656002)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?A+wf8imhvGaV/Mo8/BZe0RDpCf+2CISfhCyUgOKkw9TpsTM3JJ3G2rsnHnUv?=
 =?us-ascii?Q?jUV490dTvWD1FHb+cAqmrcBweNYFsX5n+6xE4OCfNwDyXxDjbjHXt4bE7iwh?=
 =?us-ascii?Q?U8NkRkkC41RsdFhaUv4TPRzv89rB00D1hGv1kjFFJO0GpQ8Rd6hCPGShkkst?=
 =?us-ascii?Q?M/WwuM1/2Dh0yVeKgrUMNO28P2roffP2d/6Lkqrt4OCjwth58TufHLDfjh1F?=
 =?us-ascii?Q?7z2Ef1SpDO7rp/Q2DJfMgC/Y8f0amrgSBBTjliMc4jzyTSW6kk5CCpg5Hw+u?=
 =?us-ascii?Q?MzVpCKscyxn++t4Pnmyo7Cg5mu8AkP6YsNUZUrJ4xpysKLsmdc/7GJVxsQ5F?=
 =?us-ascii?Q?rkAZU1+ND81/Espd7HdQUu/at/r1+MYvsHnIM3CbKRn6rhnDzQsoGZx/3pQv?=
 =?us-ascii?Q?V9nQL8igF//E/rPvTFWMFsS98vBZL7g7TL3nI2xehl8hvpAxUL4sdki1Rn94?=
 =?us-ascii?Q?qreMIxHFVL7/hAy3sMJc94KFsU6Yep7Ji0KU5BDIiwGF+e/4x0vouZoHMaNB?=
 =?us-ascii?Q?SMftJWfoIU92LFbTF9CMA+Jilja/t9+Bw+c/h5cpQ1/Ch/yCuFHxm///kHiQ?=
 =?us-ascii?Q?6I672E9U28qtTGV3DaSbWrQwe1TAHVRi7wAMMVAqVdFplx1jNHfrqF5XiY0y?=
 =?us-ascii?Q?s8IDquE53Qwh0nOrH3E9tgEPnAA3b7XfRow6rwo3ldEzyqtjcG7NUDA6Sg2c?=
 =?us-ascii?Q?xmJCEfBTx5uDDXdhQoydrRBu7YoqKWbrsVhqHr5P/IdLXOEb0HTWRWCDKWd9?=
 =?us-ascii?Q?EVZZL0t+bwCJnoaXbrS8lEPphmTJUPFoaCKQAueWxNfhqPXN5MCHxLzoKw35?=
 =?us-ascii?Q?lrehv7q4LJN83iFZtCyxuutbeU51uMOW0ExqSufxX/r6WAgAZ51jv/yz2LpQ?=
 =?us-ascii?Q?SvkMhr95k0oaYfQUOWJB3xpBBl9MeOcGP6gMdHqRjfoa4U8g/DQfsq18+39l?=
 =?us-ascii?Q?8cCtd/cQq6EdS+BcKd02Zeh+D8rzMQFtBRIlg0flEF9hw0YdMMohQeq5NWm0?=
 =?us-ascii?Q?98V74s+YlmDX4dZuq8gezdMysUfCPnjMSIt11PUOVqcOxYewcL3kGhqmIFIr?=
 =?us-ascii?Q?UkPouhpWG/FAyCFZpVt93ie6uyqM5FlBsMaYSOWbCAazfweDUre4YlyT0epU?=
 =?us-ascii?Q?9eT18L4jLIPmW39mxHD3XTosXl4dOo3PK+uZ3V8vIxnEIA+5AN243A2/oBXa?=
 =?us-ascii?Q?InfI1pb6yElJ3tdl6mFryDt/HM4eOjwC5U+cfAH3I4gIMYs1AuQT7EnUIJHC?=
 =?us-ascii?Q?nD4C9qMRw9MlcVL5Wz8Glg9gwy6yVuMwGG7121K581/tX7YGR4uOiZ8NKxhR?=
 =?us-ascii?Q?XXM0i8rLkgyDIeGOzicPDeUso23FvCQfnXgBZVbTe9uD1Ne4jsxgnpXgukMG?=
 =?us-ascii?Q?pGx9N6PecRuHNRu7YFgdo8eu4ALjxVclbki3aWaYeScrb5i+ax99CWbSsWFX?=
 =?us-ascii?Q?mpAsNSCDtUaanBAPcGnUQUr5l4PuYLl5DlIFxM2ReMdAR9WfD1vJEwLVXsVc?=
 =?us-ascii?Q?5Z2IT/HQkggETM3n0c/RxSot5aaRSOn4CFcIgxvgBPwKbZmqPqJhTJR6GMmD?=
 =?us-ascii?Q?c1F96ZOa3YQsWP/h2kNGZQIYSbPHnpa1eyeIZeDnOndzZ/pxJrJ61lSjEOK0?=
 =?us-ascii?Q?o/PpsP5jLjitj1ORM5CTpSHV3IBUc6vAMgr07L2vQMPGMeOC7ToPs6OFFkgQ?=
 =?us-ascii?Q?QPmyl+XpuAZbsN7P772zg5hTJ9d1KVKMYsFrYCSPhHqkjuY2i80jCISTiMPQ?=
 =?us-ascii?Q?HIY+P6KQ+wzmiINlYV8w4OfNmZh2qAo=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75fc8999-1b12-4f13-e9bc-08da2d186ea3
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2022 15:20:18.4422
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ec/yH+VnvK3wQqAkwuAz+rVA2TvVf+ia/2JMqU1ZhyyxKcUV481h1RBgRmM38qH3PTwEGgWMQTycpMbLm1nwWUYz9UOMjVrEKlpu1c+nk2E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5115
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
