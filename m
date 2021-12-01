Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC87EC433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Dec 2021 14:29:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349894AbhLAOcV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Dec 2021 09:32:21 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:3588 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239486AbhLAOcT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Dec 2021 09:32:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1638368938; x=1669904938;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/YtbEjRqt8pwcx3j2btCvVoYzUhUwnUvmjj+uA+znKA=;
  b=Ew44jEizZ78vaCEmvns9qMtsIn/9BTeMYA+RN+2KiRFa9kpMkGT8nkJf
   Ft3wuWwTeQAcWbqKGypdG9Pm0u7ownAPIQ3kaM9re5cUpSVyfXDFGVV53
   nBLlAOeRmPcbcHESkhk1h3DJnKGL9oV7IivCx8f27dTkKlOKWUNfJHzYL
   rpmOVn1uUpLAm0lx5HpVslMJVCZLUuC4eHFYq9rCfewdWh/RB+3uXAHCO
   RCu+Bl0JFwiQ5FkfC17i/HVSoD9UTdTTM04CqKlKjGUipfZM+QG+A9VUY
   JWqBAiTxb1M3vNMA/oyylCrrTzpmgWL3/760uYaXkhr/09GfJwHLWyUg3
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,278,1631548800"; 
   d="scan'208";a="191972081"
Received: from mail-co1nam11lp2171.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.171])
  by ob1.hgst.iphmx.com with ESMTP; 01 Dec 2021 22:28:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WDMrBFImyxp4XMEnGTWkEyBBxYCpPThqSF14U1AchoqZfLHXGGvc7E0IDVZkGrlQCyFbO513SiCbPhbMtEqhQ/Y3850AIvIfIsazoVVlUkcFCCbHYXO7h6unIC39ZiRl0bq5jJBf1he95YkHlIxGBKFSK3aB/rdWT0Ykhmh/Z+L9MzTF8x+m3/zM5l+BMr0HIz9Pc/LEegQXwyTJpNBfp3wIY8SX0NGChlSWnk57rPdvm2qyvfO3glqS0BWOMTtjDK5UXxR+PBzxl7H3DBkCBihaE4gLVjOi0gjpKMDXamZ3DbNXoEdaN1ZMg8maZTYClcTaoHP6xPh/VuIyNN0G8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+IzzvDErfNyHEUPll21SBrTxh4OeeZfTWnyj6aj45kk=;
 b=e0PgxGuxchHJjfBoTVuXois8vF2aOESfI+WwN315YXtL7bwHIWaYvjVB8/sYAhAg/OX14mUL/iQuHgBXwJyd86wO1Abe4BYuT9ZR0BxeEY+WEo4uBA8IA+R6L7QsqnJcSAwehgBQYJphQmu5fPzEVznqq+4Ww1AubF/7xGe68d7zQ2why4kulRHajF4jCpuAgPvv+TNfM1mPx7VKe/L+c6lmuWmuoviygEvQ7uVy24QdGPSMAn+tcEqbDkqeBGpAanaXkKKXaVu69Mx6/dlpdIAx7M3iqhXZVw6WxWw9AssPnX7aSl1nzosxchuNA2PrIngwi1S+/YqC4JHO8FiWfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+IzzvDErfNyHEUPll21SBrTxh4OeeZfTWnyj6aj45kk=;
 b=Q/1cHzWkpLeRwRE5YsSRBoebE/DUoENn0zrwxKU1+CmddtUW3kIFARZNHw1MxR2UA9tXDLgd/+Qx0gEYsjp3BD9whty/uvq5vjrzQNnBdVzyPHqg2qv7QLF9Aq1UIW0QYgOtuQzJVg7Z/3+93Fa8k7SltihQnHcYEL4MOpGGQlA=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7576.namprd04.prod.outlook.com (2603:10b6:510:4e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Wed, 1 Dec
 2021 14:28:31 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca%4]) with mapi id 15.20.4755.011; Wed, 1 Dec 2021
 14:28:31 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: [PATCH v3 2/2] scsi: sd_zbc: Clean up sd_zbc_parse_report() setting
 of wp
Thread-Topic: [PATCH v3 2/2] scsi: sd_zbc: Clean up sd_zbc_parse_report()
 setting of wp
Thread-Index: AQHX5r+3oiMInrqzYEelPeKwBr1i6w==
Date:   Wed, 1 Dec 2021 14:28:31 +0000
Message-ID: <20211201142821.64650-2-Niklas.Cassel@wdc.com>
References: <20211201142821.64650-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20211201142821.64650-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.33.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d0deeb98-e63f-4c09-4367-08d9b4d6d9bd
x-ms-traffictypediagnostic: PH0PR04MB7576:
x-microsoft-antispam-prvs: <PH0PR04MB75767F7536B8F9099D7D2496F2689@PH0PR04MB7576.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1775;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SKJqqhT++5c18VrFhsSyGR2twa91vHTTKOvP9INIWrCS4zyWjlEgVekfH2eIOwVU3MUu0CTMhuzzKbE7ueew+lWRKpL6Wgax8lnJ36ADqMdWmmbEFV0V/XMt/KRJLgt1CWflnwsde/3T0UkSktewcXHmE+PQjJGmOMPUcA3vB8A4aqlJJsrgDb4t1mk80oAzeVUYd1e8Bop99dBwkYsWA+alw04ZFl9ivxZd5YmqoGnZXLZy8mUfb4NUGzC5ZPX4YSQUgACHYQvJgvM9CLk15yUsRJ0AHCASWOsy+9PyEelmdASvA8RTePC/cXjwf5aW9RalE39F8/7ibT0+ND02bB0GQdSURlEYZ7f7Rg8K/n/rlbWXjuQUMfwx3Ir1CWa7hunJBFldRnIL+88lpg9yoo1Btd9TO61lVdeDNWI3/SU/FetF7ex6sSatrwz6s2sIcRZXtDXg1FEGRc2p3gRhh6vI4rsX9F41mu8rCVdasI+PcswlHNpc38CJuG77MFdQaN08mCoWW8DodVthMlCoGIQSZ5GIsrWZMn5KklEVXNfiJPlb+zLkD5cEyi/YdGowRj3UMPWsihFjcnapspv6ejVn+QGhxZqJByJVdpu4SRtINEcqgcalBEg/58OzupmBBFS6JndsvSom+LTkHOfhcBK6pNxaeGjK1sTtF6w8wp4ZI6Jh9Zg69OT24OPx825NZd+2yMcc/XIsqxfE7LinYg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(122000001)(4326008)(86362001)(110136005)(5660300002)(186003)(71200400001)(8936002)(316002)(8676002)(66446008)(2616005)(64756008)(54906003)(66476007)(66556008)(2906002)(76116006)(508600001)(26005)(91956017)(66946007)(6512007)(36756003)(6506007)(82960400001)(83380400001)(38070700005)(6486002)(38100700002)(1076003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?/3WP34ZNgj5WlYdhBF+wp5Tk501g+7pdPxbHeOj7nx2d8xuCsS5Z89wrEK?=
 =?iso-8859-1?Q?lRfGwtl7yuJi3d5NABkFKmI2lSDvyeoMCH6cxNec7Dy1+HR5zJhqwqq8L2?=
 =?iso-8859-1?Q?ARHEj8dokGPq3m2AfMFmXad5Xro1rHDoJu7eil84KizmhjufpxQ939Zx/V?=
 =?iso-8859-1?Q?l3UI/6QuHTU2ISoTMuI7D+S2pb8kvRja7iYhog75/YUohpgbhIPQ0CP9hP?=
 =?iso-8859-1?Q?AOYo8/hUgrORbn8d9I8SmMQ44m5kl8ql3wBl4sI5BJntaRAEHcJztwV9i9?=
 =?iso-8859-1?Q?vTG0msuDWXis3CdugGwTZuRPTjRg0Oj9/OwpVMV2zw/rFUD2o2ZLOlSwrV?=
 =?iso-8859-1?Q?NI6fqEEUM0CsaFisnLtme5/eK35Wheiie6Kpu+1+Hct9OqzcUajNLPTeLY?=
 =?iso-8859-1?Q?fcIsLrkOgnblPly+aoDFlo/bWYRV5PB6LPdI287/Ci69eMbV+vaJPLRLZ3?=
 =?iso-8859-1?Q?/AkfgLPlQJiS4a/iNgrytoeinv5ydUBOfB0lv3WmwmIYGgUz7Cugawp/oR?=
 =?iso-8859-1?Q?MpZS9KGrS/NAo0bhdzAcGNpkLCVixnCEEJiyN9lEna7YPpJl7o3wlqVTeT?=
 =?iso-8859-1?Q?GeQkg2xV6iJ3dSetOMBZiVNxt/kgpTd3bnLvzx4J5rz25mUaEdMucX+fDs?=
 =?iso-8859-1?Q?HUbDcCibwjHHZd/4L/N4nKjuQtQ+fECkJhth1QtMiEgj09j60QRfRKRQc0?=
 =?iso-8859-1?Q?x32YdjrboowKq447vh5RrJSXZPT+MUFU96QlHgTrVo5RW8I4eqnYeJ+leh?=
 =?iso-8859-1?Q?9EnfPOCKgVhsFLHy4zVd8qwRhoIc+ebKrMHnSAtrC+78bpfhanCq2GvVMv?=
 =?iso-8859-1?Q?E8W2EmzK/6XQWZ5cPC64Sio6tzq4GmifHvpELAwh2SLm0TklRVaZqarl6L?=
 =?iso-8859-1?Q?thDFUpKutjm4TnF5+rxN+ftlPg2EZX7h+cwwiCa7eSkEG/SUh/QMDMG8Oz?=
 =?iso-8859-1?Q?7FXrx3xC1eQG/mJiW94w+SlGOE5pzNuZ4MBWkn0MdXErix1XSYGDtInq65?=
 =?iso-8859-1?Q?Sp/8ygz7wskJinTYsEhvwvWTFcGy+P6z4Z4Nr0D9AJowwRBo5Kney7N0UZ?=
 =?iso-8859-1?Q?mOEjdCl1HduNx7KS5/9F08tAHlRUQ9nEtUz2yaeuWKcI77qqA7nV2n76lf?=
 =?iso-8859-1?Q?HM8bTqK5+osRwshs2PbMSpaNuRTnhsr3OQEyuLLsDjARfZsyo+t8Zv9yiO?=
 =?iso-8859-1?Q?mB5fBecDLXtPAxS68foE1iGQ6QIilSnfj2OHmYtXqN646u7YmnBJjXGMNd?=
 =?iso-8859-1?Q?QIP7FBR5ujn/vPQmSNwYHkDLv3cQGN5fX2/ruLM2Z/hu34wiwMKvT3X33f?=
 =?iso-8859-1?Q?3ypUgLQ2IrsmACC3LbSRsAl4/7K4wsNSIrth739Ut4ALuTT5GaPwoHhrqT?=
 =?iso-8859-1?Q?xjk2THPHi6z4y0NNEVHTqQDA5EkLq5l0eyvqHyF32wOZXa/mSIg41qSk8E?=
 =?iso-8859-1?Q?ArHTABRYHqkOkB5vNqWZA4EjcxpiJdhVGq+4vC+xILNoh1HBoF6MdZaEZC?=
 =?iso-8859-1?Q?ejfO704Ay378STcvCGNMAiTfC/bGGMRYeBlBTYWIe18YmpWgX/NqFBwsMG?=
 =?iso-8859-1?Q?+5PSY34TqK1S83X6jB1bo7YZKvimsNiuUWvr3E6CYx/1LRuyZjVg25gAZG?=
 =?iso-8859-1?Q?QsANlzSCqO1196AfiLNtoDoQVggSzwTo5IyimUXKeQK3+7gob/Mta0pFIG?=
 =?iso-8859-1?Q?w/c3AkdTBftRT1jt9XPnOT/UpBMh6l/KVShW83uo?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0deeb98-e63f-4c09-4367-08d9b4d6d9bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2021 14:28:31.7740
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L+hguYw/mr6ZDCZvQbM7eLqsaDiEjHUKJ2e9qUrTbuKnO7oRKzDVLky25qQSq5ZEniVkxkGNQGcWOyDw29qnoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7576
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Make sd_zbc_parse_report() use if/else when setting the write pointer,
instead of setting it unconditionally and then conditionally updating it.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
Changes since v2:
- None, simply rebased on patch 1/2.

 drivers/scsi/sd_zbc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 749c5e5a70c7..4735cc7f682c 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -61,9 +61,10 @@ static int sd_zbc_parse_report(struct scsi_disk *sdkp, u=
8 *buf,
 	zone.len =3D logical_to_sectors(sdp, get_unaligned_be64(&buf[8]));
 	zone.capacity =3D zone.len;
 	zone.start =3D logical_to_sectors(sdp, get_unaligned_be64(&buf[16]));
-	zone.wp =3D logical_to_sectors(sdp, get_unaligned_be64(&buf[24]));
 	if (zone.cond =3D=3D ZBC_ZONE_COND_FULL)
 		zone.wp =3D zone.start + zone.len;
+	else
+		zone.wp =3D logical_to_sectors(sdp, get_unaligned_be64(&buf[24]));
=20
 	ret =3D cb(&zone, idx, data);
 	if (ret)
--=20
2.33.1
