Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E0E0C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Dec 2021 07:22:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240892AbhLBHZj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Dec 2021 02:25:39 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:44953 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235587AbhLBHZi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Dec 2021 02:25:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1638429737; x=1669965737;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=kLV9VVNH79NrqmOpppTDbFV2hH72sMBbPFSLQ90ZXwZMYY6pdZI9Ek+8
   PfcZ7UB5Aa/2JGizM4YuH7H+WIeusl8002xOqdOgEaCXJz3QlU2g2rts8
   HJPdH154kgm1L2y/p9TVppPnIQDnF+qyIT2f/XbXrj0QY0zitRjYZ2/Q9
   ca9UgjCpLjnwmu6O6lNYTxyZJUSB+oUCzTOwUnmziqb3rRUeGOleDb1AQ
   d+ooTdatr+glNLboWWEZfZ0AR1IAOtZxZlLdl2auG6YO48V+5T/NBxSvM
   ULllGrljFhSBhsAWofXq2wnu3m8yVKghs5j4QIchYVScQcq6af0XrMQOy
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,281,1631548800"; 
   d="scan'208";a="188273452"
Received: from mail-mw2nam12lp2044.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.44])
  by ob1.hgst.iphmx.com with ESMTP; 02 Dec 2021 15:22:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y/MrO6wyJgoMSj5IAmLwzwaf5I7u7eEHuyNP9iSz65Sl7ElPtA6cNsyvopCMpIkBG/H2ANq7EEiyPmz1Qkpw/qzPBDVuNLrpoJj4adi4ReFlfFjxRXfkiQSktKvnFgVH+EMHD9srU9aJ4okuiOP/emwpF3oAk1LLqXqMy9suDil6wBvidPSFIWAcbmy7kIgxVjGTHLGtTdFNFoNvEuOJGDy087RqSHCSpG4rLfs1e5eYRXjwvVXZ+7uCr6RCcK4HV0QRIjNUdtBsRGTgqXTeFeB01zxER5BCX/N5KmIjN5pIyFKIE7MJmF92zzhvL8WuIsIJg3Ld0Y2V7xW9WR9G7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=LUtkzagpOBOJ3MEUeOe6lRXiiC9sz4bsq5rNSZWOqLFTXCXvNcEobCnoZDCg7QfJinmhLLh//jRHwSTVVcg2gU/VQgEmRqrp4PVME95cGrQZ//H4OaZbIYqa+V34nGZQCNET37PppByDpMuB9yhYtuM5EfND3Ivjz38JPOFGpJnOqRXkLiE6z7sz4tp6IXL5wJOp1Nfre0XO1ojqJQnqHG06SBovtz1RHH1vmkM2gWegZHRT2IIoxG02knKimmTWG6Wp7Gdl5v5dP4DeA4RlspYjeMDGRuEDK8K77MsT7JrGYZMwlcjQBVwTzcBQS9my7XeyFdz9gbig25mzSjU4Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=WStXgAdCBp0tT76RO45xn5i5h9e+y5zEXgak6LDp7X9XCpdrPALawsWmWmtkc+IXBu7kUyV3GxfH+ZMuAxRvJzVIlPKijeWLadM87j7zE3RJYCnAY/F0d+MxizAakb4HFbdrguA5lDV/Mx0lpS5dEYhkmkQ5R1IWDxA6NzYFfNI=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7383.namprd04.prod.outlook.com (2603:10b6:510:13::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Thu, 2 Dec
 2021 07:22:14 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3418:fa40:16a4:6e0c]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3418:fa40:16a4:6e0c%3]) with mapi id 15.20.4755.011; Thu, 2 Dec 2021
 07:22:14 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] scsi: sd_zbc: Simplify zone full condition check
Thread-Topic: [PATCH v3 1/2] scsi: sd_zbc: Simplify zone full condition check
Thread-Index: AQHX5r+2diDciWhRHkSViLgVDTPYbg==
Date:   Thu, 2 Dec 2021 07:22:14 +0000
Message-ID: <PH0PR04MB7416EB125EE10AA7C86DE84B9B699@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20211201142821.64650-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8040d873-5711-4d12-1d49-08d9b56476d5
x-ms-traffictypediagnostic: PH0PR04MB7383:
x-microsoft-antispam-prvs: <PH0PR04MB73838D820FAFF92DCDA6E43A9B699@PH0PR04MB7383.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +vQ1Z6lbf8/eBxt0Wxl6xnZs26TnWfy88GpXZLxzXuEPlblMUGz+YEXyAtPo/EbN0WxMmcaYz2j0VsvjMqZcRU6lY3UtObpHdF2Y1BZSZVbK3yOZ5ra8L+0CRMXGsq4YORPi+QcyFB2fus93/H9+3QfoECkzTZmtWT+S2M7nS3N4jrZqs0XHJmuHbO7l794zUM7bTgjAn8xiO1Pn8HGdYgf+O3aL75ZVTyICZhVooJsVU23uBbX4tInEGCUfXzMGWKWpj4iU1CMDEHNeh8NHiBpvMHz33o9j6RvT5NR/Z0ZZzKD729grBqWuUMjC1KVEaqGya3svF0HNvyJIL9wScuQEJtXGQzG1MFVjFjuEBCn0sb8qHwTtw9W+RBbCU1RTa4jn2nLxtclqo5ko9ypeNCuotB6v1PjSHpBNe249wqk7QduU+cwxQSwwCMx6YPhmVpZFQgNZd59lNnd1iT30AZlzQ7U4Eq56LqCmheJhXTsKETiB49BSDxoJCUT+3B81sn32FKj36b9faaZQ4Ab4qFdRNhZagWcXXvkRp8ceXWARTJ8TKT0FR7ARclP75gryTbvH1QyK6aLCZbMboIA0Y5jfihLwn1Q42DSoCx9ba1g1SSIkvzPdMVvW/1kNZxFYrrqZ59K8vhZFKs8usrVo76CYrK4PO3gpPx9jCjGFRolni7VaORXaTV7cHCof5Su76bSfjZ3Z+vKrOu7qtwa/eA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(33656002)(52536014)(6506007)(186003)(122000001)(5660300002)(558084003)(2906002)(38100700002)(76116006)(66476007)(54906003)(82960400001)(316002)(19618925003)(7696005)(508600001)(86362001)(8936002)(71200400001)(9686003)(55016003)(66946007)(91956017)(8676002)(110136005)(38070700005)(4270600006)(64756008)(4326008)(66446008)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pMCYfT7rbrmIWI+m095rGRSVyrwuRqEcdL5pzdOVcxSEN+EQhA32E+fI9VYS?=
 =?us-ascii?Q?xngn9c+ov/Jzh4RrM8ft8ZllkSSGOzA6dME2n8h17eOXdqwR6IWvJqYGKuOa?=
 =?us-ascii?Q?zGdKhxSyk+CXwVUdo3g96njWbIY89gaeLs0C0IVw7Sb5EzFIEm2ef3li60/b?=
 =?us-ascii?Q?vC/uucSlodBxTOYGuromIra1azwDV1VG2NZCVHB8tsaYSX/souFvlEjNGjOG?=
 =?us-ascii?Q?pU+CtzFuNxaKaLajQw1hqxKEmM6Htf4R2RZY6lp0QHQQn4xP+rl/gYROgOGX?=
 =?us-ascii?Q?AeZvfW9IhZJzwsRfLy3pr0g6ekatXd+Ya0cvwkdPZ/Birjq7S/zo/qYkBfyk?=
 =?us-ascii?Q?uvpcAl1ohosVVpQKQDyhzH5J4aKgLTlPemnGVjtZjrtzvf6ZMxoVznu8qV7Z?=
 =?us-ascii?Q?z+Ndkw56i67igkkrMtCusZAJmP3JfKJflSyIQ2DyAvWlAzF26jgS93ZuLaWT?=
 =?us-ascii?Q?P4Og6RC6+0wwbHd4WJcaINX3Of4zcTS1Jkaxbt/Vup2/MQ4c4z7znZrtC+Bk?=
 =?us-ascii?Q?RDb/3iKH3WI17O27jDjuA+DnhX4lCXki1HWG5BpQViBLvohkbbkxf01n5TPe?=
 =?us-ascii?Q?03TbHllKyiE5M78D5Gtyx79+Sj0dY31HSLgI+MsQPLqr1KYDOr04e3O1WKiJ?=
 =?us-ascii?Q?3OFf5HpKMibS/6w5czFPw5NhVgh9i2owF1vCxKRzxJ+SC85qG2z6+hW6ppsb?=
 =?us-ascii?Q?EY8w14TZIPwTrCKtVt6ZHC4ktJ3NAyMnXX488mdfE5fLEZH6yEwSCuwTYqRY?=
 =?us-ascii?Q?jQhASs6JwuUY4uifJcS7lDscnLgEtmWfBmw2WN0oiXjc44DIjqH4okFklkz8?=
 =?us-ascii?Q?oIDiZs/E7WBmlfwX6g9CkbscDfG8CksuKwsLWVHBwdtnTH8QFz68up3M9Bld?=
 =?us-ascii?Q?jbJYBl71wYMiLIqXgLtoO/aae+mzX1RFKd1jtGwL/EQ6KOhpuojLDG6xII3f?=
 =?us-ascii?Q?HzUBkQptPEzt7/TVGYG1VcIvId7J60Q+EVvirPSiRphqvv1lcdRfSwkYcBL6?=
 =?us-ascii?Q?GbtfoX1OMr2DMx5CdSBbxFz/wDu9sHCqlXWu3R6mZfxew9G03wu9W+/P9g9P?=
 =?us-ascii?Q?7XvD3wezeaEqztYXwF83WOg9wFkxci6C+l4jepphGgNOrg7cI3oublLv89PS?=
 =?us-ascii?Q?jdohzb2ClVUBddpWFd3Mkr2ieAjn/8rPKemmkDjIlBD7tQSPX4CkJxbJrEOe?=
 =?us-ascii?Q?oC4QpOz0843tUdOzgx+f0NnZp8MQuULZU0AuzaiGi9LrQ7tb1shfn7OHIDad?=
 =?us-ascii?Q?daiRF5XH9BfFVzm5QytBNcj9nujwdzWO/1bzUn8V/1I2oMdEblFFUQ7a4lXk?=
 =?us-ascii?Q?73I7M8pu21k0ZlY0fDIT4ecnxqX2uaYC8Wl1uHCpLA9FV2qTNBb40+yfQofz?=
 =?us-ascii?Q?8O1fc4nBJk/Nv6YWS5rzhgtftwyu2eBhW6OjiGz4nitE9+zyeQmZgcyAa0+U?=
 =?us-ascii?Q?Dso5dj4VQf8VOFHl3LqomzIt5UIiXLe4xLWoC8rou67SsFj/zCc2+eHFtcIO?=
 =?us-ascii?Q?FKeEWdGG5IF3SEW4yYXORA881Gf0IK0RsyEUEMSf6gNEcsUaGeoCoyJzHUt2?=
 =?us-ascii?Q?+WnxE1/clZ8d2jEgzGsLuBdr9XdjJJbHYOHkrAF9hAb/EEUqoGv484ROnn4h?=
 =?us-ascii?Q?OULkzVLGaEZ2S1X+9MrRaaV3NKJFS60Dteb2EoPQsEOWy9qA3fm32y2gNU5u?=
 =?us-ascii?Q?GNIRlZLPSf3erRe0nPunRp6++TfDYS4H+5rfUpWAGjYzr6XBnyaIAxw97Och?=
 =?us-ascii?Q?6EL778KadUgtWEN8++k0jkERGjJRu2I=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8040d873-5711-4d12-1d49-08d9b56476d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2021 07:22:14.3536
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DyoRqD/V3pOLe0HMfEEzpfip9FDwQDznOtUAv3G1AzOyP9qQ5OAGI8uJSY4qkV9PxHsI9HGbG3ddLxH0nYam1EabTWO8ihpY/BDEkDg5nzM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7383
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
