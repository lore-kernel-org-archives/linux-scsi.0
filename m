Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CE27C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Dec 2021 14:29:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349890AbhLAOcU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Dec 2021 09:32:20 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:3588 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349860AbhLAOb6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Dec 2021 09:31:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1638368917; x=1669904917;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=JZuqMzJ+Qg180bNPY8BxMlhDGNRleISKsfmsBCRUwW4=;
  b=laZDImdPzTsECSrVqN8oPSsXbb4uu9aCbfgNbVT0iQKvwExpV69wP500
   Qv8edq0pvGwtXU1oHqnqAEi2k/n/YLNW9WUbNsOKiwSBXLGn09gw88iSp
   rj7yRGEghBJtTyvEuQzQluPVsjNvKCH4fTYysLWmWm8LNk+7ut6VSz2I3
   WsIJFbMULXyU5rcJLbinbZsqEP94YHw8oRxDUZCIc510jOH9uESKxsfBT
   CpmDFEOWII8alddrpUQjJlyolqs4l9aIvjqqegqaXEaisViqk8EhBCkoe
   gQtFo9BqT1D1CdKRBQf76GFfudcQjPzlVBwRMKZLrEOdxXMPCul1upyGG
   w==;
X-IronPort-AV: E=Sophos;i="5.87,278,1631548800"; 
   d="scan'208";a="191972077"
Received: from mail-co1nam11lp2176.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.176])
  by ob1.hgst.iphmx.com with ESMTP; 01 Dec 2021 22:28:31 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gJ7CM6oxm75dqoRCJpI4nUB/or3jKnz+RXxByDQMsprUGSBSc5R5WIhCVXomOG5g6mAIfFk+sndOkvKsMYiNqo/TR2HfkoAofDgzfdCtBC25ZR0hj8mVmTD2AfpzC24pTqmLH6TztQfpGzvCD8zIqTP3L9wClN8DyvcbOLxLbTGBz5//9G9j4MEAb6zVHgsez4E7YGQ+v9Fvr3eS+b8X/HfQiWVvJhR2nbUXIdGyhOc4X2iIkW8+VorArl3i+gSwZEQWd9t1vJZUyZNtO/c+Ya7xTMx2BsUinJGwRkN6GAag4UCNKFqrOXDPn6GLSYSafmTOR2gs5XpGCNRz4Ffvmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/l1Sk1wUnOqmlmQzFgz/awJi17KFY6ua8lGDY3rhxjE=;
 b=G3aYIqq7LShtfGzR54QcdPQc2x3oyBq4kTNPg1gaspcxlKOSC++rRjeQpeP77NpolgezOB1e3G29Ub1miElHC1+44puBAu4abe8EMIQj4uaRRwofXj7CcqXrsL3MffPEb/BTfAyxnlRkNBJnXNXN4K56EHt8sYf0jr5tVB88EzVmrHoKVcPmivb/2LvTGSKKcCcNhkjj0lqRW+tXCGbvDf/4p583GslLiKnAgbyLVDsGTjP/LHcDiBtkqYMmnvQIlqAI1rmPkrYrrZSaGjqAsAW0KHdHn4g8BDD9pCGvgc26/zopVX+5z/SukNOLWPq4Kx/o0OIcXeEuIYKSP8Ck/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/l1Sk1wUnOqmlmQzFgz/awJi17KFY6ua8lGDY3rhxjE=;
 b=khG6DyjkU5gbBgfSLiXwQ1YnxWjPB/leED5ct3Tgk4iN2Ovml7D07aNeYk69Ml2bwVtyW3Q7CnPxUiT4J8rXe3y1JDQqFGRmo9nkTPvXron47QzbF6w+o6E+NDde3bCgaBqePHx18UDCEwSCMJT2l8eKPPBLQm+qfFoseF1e5Jg=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7576.namprd04.prod.outlook.com (2603:10b6:510:4e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Wed, 1 Dec
 2021 14:28:31 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca%4]) with mapi id 15.20.4755.011; Wed, 1 Dec 2021
 14:28:30 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: [PATCH v3 1/2] scsi: sd_zbc: Simplify zone full condition check
Thread-Topic: [PATCH v3 1/2] scsi: sd_zbc: Simplify zone full condition check
Thread-Index: AQHX5r+2diDciWhRHkSViLgVDTPYbg==
Date:   Wed, 1 Dec 2021 14:28:30 +0000
Message-ID: <20211201142821.64650-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.33.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bd6d5f99-a72e-4dc8-0450-08d9b4d6d933
x-ms-traffictypediagnostic: PH0PR04MB7576:
x-microsoft-antispam-prvs: <PH0PR04MB75766E893561AC961A41D8F9F2689@PH0PR04MB7576.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ag26zYz0h3VvtwOhF8dOGB/mz5LGJKWujkRUH8oelS7f2DK6B7e45W3d8xjdc51TO2nmlERrLkxzHdlkmRPHwtwCiI10dSa24h0241IoZd28dUPsKxeF6jweqUqAlqqjnvDMrJ7BHGJRfiR+E1gKrbnH8zYszIbWKAgX3KKIjo0EG5dA/X54VZnjvIUlu/eTDE7N9cpevCNart+JWEZuwDgxr7H4uzRU/hhGabBJCP+xCj/Qw8+b0uecZRlQ983ofkFqjNnX5m/rGeFg/5z49RyoJk9QyaE8kmBAEAGqrdL9xFoyOWVm7/986hKgisOEo1wmbYmv896EEQabQH7BhAeupoTC8/t+1n11CzvdKq5iJMcIwsFeUi6mRVgrTi76c9AqvvNjeL9WT+Aj0vNC0Gv4xYg3fuSd75U4q2dq58tS6NH9O6qG6f3M6SRnWDlxDDrsUEkO55hwIQHf8BLiC2/hwX6k6ViEI+jfpnfN5KZm6eF2/3BIonhdSNmIvlC2fYSZ8V3nctrlAwJzQtVXhtDPZ64P/ew3yBVDrh9tOT8qEQynk0cV1UBtOOlbI6zBqFKn3BFeWQxBcIiyWRV8rqBg/RHBitm6H4QHUWFtKOGxlx0XGGt1jJH8pta1iqklrs03RTn5VsOc9Jhw10U+7PsQGKMlCPD3V7yddsM2u4ORHyZ8+mHh66NBpvNERWdpg72V7sMxgBaqXOMe4N9+pw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(122000001)(4326008)(86362001)(110136005)(5660300002)(186003)(71200400001)(8936002)(316002)(8676002)(66446008)(2616005)(64756008)(54906003)(66476007)(66556008)(2906002)(76116006)(508600001)(26005)(91956017)(66946007)(6512007)(36756003)(6506007)(82960400001)(83380400001)(38070700005)(6486002)(38100700002)(1076003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?/lIrLW0AS7YVsSTz6cqMNcWm+L/UwJTVGtdxcHpRO5LKdfCGYj8EPqk2Ou?=
 =?iso-8859-1?Q?+RCGKHLyT6h3OMMCZkcVftSSTBpGN3imrBS7V7lZcWuSgWLzshd9jd4fyJ?=
 =?iso-8859-1?Q?IzGho9dWX8Us5QEz7mzrZX3HyV3T6LmeiW4kcsby7RTuy6lnUHlIO6JmEy?=
 =?iso-8859-1?Q?qOtOAc8HBZ63Zi3ckTR82amTHYg5tFIucBpBdGNAQT2W/jssZNbcDNRW2g?=
 =?iso-8859-1?Q?yaoUowmORc3HBKmPlDdcjL6j5ePxAxy0JLD1i/KuHo2sMauv/EpaSjt3AQ?=
 =?iso-8859-1?Q?y6l5N1iGQhDsf4t9hJkHSg+xLp+oA1LTph27qM/SLh53odfiNsTIRxPoWK?=
 =?iso-8859-1?Q?lhzvdeO9CgqshuX9VBc+S3uwHpcE6jaHHPsuLdsLwBWavmRamha1KqY9qV?=
 =?iso-8859-1?Q?PmYYrZBc+59Vcb28Prjw7OffKwMODkuSD41ZC9FUvoxJp01VUU8ymLLVFU?=
 =?iso-8859-1?Q?ZFXqhY88nQenY20v7xwY2S+QS0+s5jfpeG6dHjyHm2g7L4Yyp9A+wfGntW?=
 =?iso-8859-1?Q?f2A3NIdd/GfS7SJYEjwtADb22SJFKhDyjX1hOojAs4APpjRINAFEFgYSb6?=
 =?iso-8859-1?Q?hjwwv2SFFm9+rwgCkWvJoi3NZFWwcBg9GYTTWgnYkOTh7gv1rE7YOyhRBR?=
 =?iso-8859-1?Q?XVlQZ+Te2Ahbgh+7Xto35X3uxf6YJlVv0Ejsb9L/Zvw0Y0FQYnrPmwYqLF?=
 =?iso-8859-1?Q?C8ABISz7aFj6u8Y7S5RT2TQzb+JZjvnmts4YzrrfyokcfvDQjN7H3/soR4?=
 =?iso-8859-1?Q?OowN2Wl9ehFlIyXL/RD/T8Jv0K5xwFe05cHcL6HKG2SF/vfr7+HYA/zEL+?=
 =?iso-8859-1?Q?naYjpN8OoUor+NoU/2lzFVhqjcgr2t0HIkiXgipk4PKkzbmwQk/gso/DJz?=
 =?iso-8859-1?Q?/rp7tYGAoEtze6npj3v3uIkr9nbG05Zi+ojniTJ4UZDMxFisO0m2undKsw?=
 =?iso-8859-1?Q?/Evtnf3tTlEw5Snv6f94H5RVFVlhGtDlkrW83XeRt2b5aWAxx7YnSOnWiN?=
 =?iso-8859-1?Q?YyD7tw7wmq4NMiJpCJTe5CBifF+8xezkqKcYqORFsy7dGE1wBxQ+dxNkbC?=
 =?iso-8859-1?Q?u3manXnaYZkmBY7/aj0kMrSw+yXbhWOtRxQcUoYK1BGbPELkfkYJz8OTDx?=
 =?iso-8859-1?Q?CKNkX71HwjGCefw2VBr8PhJTiD5igdGBLDAM5oJU3vaZzhc2Ow/RWOxjW6?=
 =?iso-8859-1?Q?km7DM/dYmqNy8JfqTnxVlHjJAUBWVZfdZEzLLONmEu5wEAUffBMs1c2esA?=
 =?iso-8859-1?Q?VHuJJ3kxzQx1UYRe7LijHaxGxMCyg13IPF1jIwU4qBRHYdD78mcbVaj2X2?=
 =?iso-8859-1?Q?m0NBq/ZJTuwSm3V3uI+2UlAh0wNY3uAwt+A3ocyuGTv44nBSfuvINMlB4V?=
 =?iso-8859-1?Q?DxqkYCC4c78/KktrOjc4rlv92/gDGBviJJZ1TW7YZI5xikGEn4XrJWSzYo?=
 =?iso-8859-1?Q?pgWLJth7ppe4ePZhxf/nR1pS1diDL24hPbibJd73Rz5F4JTPGQOjGiJJao?=
 =?iso-8859-1?Q?1aNncXAdhNfuL70/2FeEyqX331gQ7Ttxo31QdH6dRnPNrbj2pqO7muDpbP?=
 =?iso-8859-1?Q?yEislsYnshS93Q3NigbWRmgXyh53Tz8TE1d/L6FTh9RnpjzB5LAvhqKSTg?=
 =?iso-8859-1?Q?ntvaKXziM24sWsUH5Iq6PY3aKQevGNmTcSWgSnvKL03s+fCar+ITOD1FtZ?=
 =?iso-8859-1?Q?ChEdcZ3XuouZ3zrPN6YwihQqbqK/ugEYiOt2b4L0?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd6d5f99-a72e-4dc8-0450-08d9b4d6d933
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2021 14:28:30.8202
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0viO6LrCdWrUsYA5gp9q+TwP8xlI/i9c85aTGQRrtqbUtPdBKwBLSA5ogbQf5PdXA31iERgf3OeoWnv2BzLvlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7576
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

According to the ZBC (and ZAC) specification, a zone that has Zone Type set
to Conventional, must also have its Zone Condition set to
"Not Write Pointer".

Therefore, a conventional zone will never have Zone Condition set to
"Full", which means that we can omit the non-conventional prerequisite from
the zone full condition check.

Suggested-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
Changes since v2:
- New patch in series, as suggested by Damien.

 drivers/scsi/sd_zbc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index ed06798983f8..749c5e5a70c7 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -62,8 +62,7 @@ static int sd_zbc_parse_report(struct scsi_disk *sdkp, u8=
 *buf,
 	zone.capacity =3D zone.len;
 	zone.start =3D logical_to_sectors(sdp, get_unaligned_be64(&buf[16]));
 	zone.wp =3D logical_to_sectors(sdp, get_unaligned_be64(&buf[24]));
-	if (zone.type !=3D ZBC_ZONE_TYPE_CONV &&
-	    zone.cond =3D=3D ZBC_ZONE_COND_FULL)
+	if (zone.cond =3D=3D ZBC_ZONE_COND_FULL)
 		zone.wp =3D zone.start + zone.len;
=20
 	ret =3D cb(&zone, idx, data);
--=20
2.33.1
