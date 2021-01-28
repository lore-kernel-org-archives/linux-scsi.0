Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D109C43381
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 11:30:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AA8164DDB
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 11:30:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbhA1LaK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jan 2021 06:30:10 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:55354 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbhA1L3u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2021 06:29:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611833389; x=1643369389;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=nNqYD2ex81roIatSXVhfCwPrNTx9MbYHRJ9dPGnW5/0SImF2HFNriXSb
   nCfuqxNAuwxjCmuADDDSqCAWmEA0+DrEiq2ZlCLbn0o/4gIkLLOiZNfce
   1SqwYgMyC0jh4lpJ+WMA08ftcdHkuJaEJBROaqQ9Eu7cAuMcAMra2GSl0
   BFDHmqQwd/4FCwp+QYH4jfb1uwIqwQ66CvsVWFK1piIVz/lXIGHbsE0Nt
   0V8rmsJhFva7p7VR2lFi2kaos1uud+xlKPY3XaHjzU//BHT2F8cwzv3vP
   M0tsGHiZ6MkrJTq/TXMocFtj36U9JIlAiW/oYfO0oTvn8VBpp0igdFFri
   w==;
IronPort-SDR: TR47ym8iKjiDE3G+IWMxEzaKqS8usIzp4WoJlH6no4VpZAChQMQffKl0/7j2+/Rgbi3faSPEvd
 TtTaqsJtAiFQVwLCdZfBfQyeWrVQBUzvrzC9b4Eo0oM4TGHDcN4DGSxYfqCwd3yyDU/e2h1fak
 MPIOqSM/d94Z4HwY+9mQD4Ot7s0kUQ1KiVpkVYWXX1+vmWSWkwS+DF1dNa9EFVnN87D4gS6E29
 KvtJLXmFq86gTOSpnUz+HkBGkPgXnvYJWiBT+2JjgOeBv1+VvSjL7GCdXMyYRe1ZkCd6/EaNwf
 0/s=
X-IronPort-AV: E=Sophos;i="5.79,382,1602518400"; 
   d="scan'208";a="158535814"
Received: from mail-mw2nam10lp2103.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.103])
  by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 19:28:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gDQGFlsH8/ail6+iCm1hNdOAam5BIp/SYCzPcD5f96jdfjMzkicdGax1BqRTllXPs51u4hc4xCSTyLxaFch7nPgACGXo0lKmhGHsyApOvyOs0ChXX7D6HvD/vLykquF26FDxfB5TZgO5d2r4C9hlNpyfamXoVMB8O+7SYSjdpdbTxAaqQ3V+gaFfhfw9rO5h2RCNZBE633aC5j24TMpANNXiuaBAROBofvTOUJdqKgTO5l9YSAjyIDOpliG1favktE9NB+8M+Dsxs47IQVQQ2QmXpgAPtc1joMXcmagch10OAhFYb21vWy2+6O+Jd98kLpSGz6Iy6JoZZinQTTIoYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=kl3D/jhGDLrRgw/bBbD69sZlteeZi3wNL/GbzM8DN7vhAx4hIBFfdaaIvm/clzC8RxWQvLgKNqCP45hn1xzDWQ3/V2AE3R6obBET865vO3LGJr1n+eTyKeL11OR73HM769Kwp9VIKT2KOMEP5JkgVxnrgcB5W14L9Xdxx9Q4RG+8Ida8aSUrUH59wliNm+NLinKHsYexFare5Z+C8uKKWXCVKzqBvNxqaTYT8camQDAgnUXE4myZ0MIQs2C5poK5dezXL40Px/AkOHDM97h44Usxz0PoN2tzI3F5c56WTS8QOgZ7oQQZILnr2K+iK8y6Jva+T8Ce/P1EiNWSj5/9pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=cNYL0ardtlCVIhePIOJuGqVCHo8lqFNRGuyrSjS/6xocCcRJa9MEaraoKjIyCSOxPPcUahQRXe1JfUwwk/2ttfWVyptd0L3OnRyXyPS0Efgaw5rN2KNsMa+4HLkDvsVEYLk4Q5tqHOW+r4zxF1Uq1rDi4/0tJ1vIu1xjL2RrI6A=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN2PR04MB2143.namprd04.prod.outlook.com
 (2603:10b6:804:e::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Thu, 28 Jan
 2021 11:28:40 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::c19b:805:20e0:6274]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::c19b:805:20e0:6274%6]) with mapi id 15.20.3784.017; Thu, 28 Jan 2021
 11:28:40 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <Keith.Busch@wdc.com>,
        Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Subject: Re: [PATCH v4 4/8] block: use blk_queue_set_zoned in add_partition()
Thread-Topic: [PATCH v4 4/8] block: use blk_queue_set_zoned in add_partition()
Thread-Index: AQHW9TEkjJ7c+Ue7XEW6Y/F1m8erHQ==
Date:   Thu, 28 Jan 2021 11:28:40 +0000
Message-ID: <SN4PR0401MB35983F79650FF07FEE3DDA3C9BBA9@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20210128044733.503606-1-damien.lemoal@wdc.com>
 <20210128044733.503606-5-damien.lemoal@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f93df0e9-b262-4f79-9a85-08d8c37fdc8a
x-ms-traffictypediagnostic: SN2PR04MB2143:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN2PR04MB21433A84CDDB8EC42881BA2F9BBA9@SN2PR04MB2143.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: i8XqbngU67VVjU/b8HCbmzdOcddGVbJ2gArUJ2FsgaJzheCXApAyvsK95GyrkzgJ8qxLf1BlNHv0IFLDhQON6oEuIF+HR5wxQiKzt8gaNpVtfVOM8tLjvrpwBgeOckgK+4Ky9x/HA5r6uXS+BdtbtcqsyS5yDs/hDOJJ8Hb6zQvCPoe0YyxAu24/cRUFaUiZ3PqEqlau9EST3vjNQHs4XzwwQMcrtZ3QrNg3z5/BOPtRxptWg87W/OU+TCm9M/s9SgjERITgrfHhdIwFfBx+gKH1xmrhNA4TZYuxLzplZKxnYxV78TlfmQFH9B5o0BhmHMfdqMG1zDba48oBe2VWKB9+QkFI8KKmd8IhvmXEQjJ4It7kF72p7TVmLw2KFaBFAa8IKbr9xWrdg+uQ1Qz+1vaSJLAwvpeuHrKg/xFSwdcuV7V7+qggXdFFulq0kD6XUKWVt3IquNXvH8o4m8CCeyBpO5oUOVMfEeR15oHEP/Pm/CVlfmOWL7AbMqW+tJ0tBrvPD1V9D1te15t2pTzAVA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(376002)(366004)(39860400002)(26005)(91956017)(66446008)(186003)(86362001)(5660300002)(52536014)(66476007)(66946007)(66556008)(76116006)(19618925003)(71200400001)(64756008)(110136005)(316002)(2906002)(6506007)(33656002)(478600001)(4326008)(8676002)(54906003)(4270600006)(558084003)(7696005)(55016002)(9686003)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?WBadFms+LKVMTmVcQpGkd41M9Ml6IAEV1VHPfEKCHH67Og3m4hK00OgH0GgY?=
 =?us-ascii?Q?wUK7m+1JXhJ48OHY2eL/1rKzVFlevy+U5RgWSFBg9Ng+gfMeg1UBxNl/vKJY?=
 =?us-ascii?Q?N0hVrm+FznWOZzYesbAupbQhmvNMJHsRENaHbHZftiGW7EVXTR8eEGXVNK66?=
 =?us-ascii?Q?ac1dpZb8wazFUcfauWvIq+cUAWcboViuf4uiuz6VidntJ1QTz4fkafqw4/H+?=
 =?us-ascii?Q?Z7Uo+6zxPx7zaj5cVG0MrVmyndL8WWNxljApy+TkMg5ta5+ZsXDn5k5q7PUV?=
 =?us-ascii?Q?992M6jxIbcmuJLXesChUdHTWl9WVoxeK+9ApVZeXqM3wQZx1n7S/r3c7svsp?=
 =?us-ascii?Q?GKfF8t3HvapaKiUB3FOcl1a9lLxHSLEn0QPw7U9Tyc+yaZ+JdcfoeYs+N1pk?=
 =?us-ascii?Q?kEt+NDtR0U88ASQXx7y25GllwreTf+X2w4gBwo73+8+0h1L5kqLcwmYxwv5A?=
 =?us-ascii?Q?g3Px5v5bcFYJV1wjMaaYARqz4Zw7BUaFvwdi8DtBSuMB1J+I/b24e0JeU5v/?=
 =?us-ascii?Q?UqBXnuHt+govg7pmI9wJejTJoEwLFuts4HfJB4PTrbnkurioh0t4vOhM3Ph6?=
 =?us-ascii?Q?TOI5lnpxT81qG5/R6oEllS3hluj3sz+bjjxUOlO2P59mYVhSrli/xGV7lX59?=
 =?us-ascii?Q?zxcACZhjG9SEk8hNNVyq8BRQ0nqA0vvREoeT7nhK5OU1mpqfhHJO8pKBHnsh?=
 =?us-ascii?Q?MtKm4LPeU3VBECGH6W5DhOCNb8Ceyu1v/6Q6hX7p6/7cYveU7SyDMM33Qtwk?=
 =?us-ascii?Q?fLVmEQy1MvAxHBEcpA96HwNgUP8ozvTT6w2cCsBJdybwBEQ6v9Cim5fYM2QJ?=
 =?us-ascii?Q?EwR0ZwlguTXUXMoZa7Gzeutb+sAXQNOIAHndll28og4ftQKqCpHafIgTJmlh?=
 =?us-ascii?Q?W60MuEjTQ3gyUg5qugWLnOVM/+k5XDLNYUv7OjzEsmRdxYIK1sMgyIW+zo+4?=
 =?us-ascii?Q?cFFtNwme/AhDS6ps1PVHDil4HU5GrJJ9UBRoErM66/JCB6dZCMuj8UbNcOlp?=
 =?us-ascii?Q?z/4XFHD5A7QS9VBzzmAXvAn/r8i+Zr8u5dsEyqYt+kXWohFQaZdjgSVtuWIK?=
 =?us-ascii?Q?uVFAocaoOasY9aPyXiCbYrD4bV5cqw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f93df0e9-b262-4f79-9a85-08d8c37fdc8a
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2021 11:28:40.0629
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4MEBB9/1W1SuAYxevYJq6gbtaFkU99vq0p27yQRiGSphK+PUS3ONZvxw2/zhlc2bSdeP3zywwnX46cCNxfD4CWo6g8qsY5kLx4yyjV3PUqI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN2PR04MB2143
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
