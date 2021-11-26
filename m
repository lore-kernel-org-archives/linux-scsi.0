Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9978C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Nov 2021 13:00:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236705AbhKZNDQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Nov 2021 08:03:16 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:2592 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235547AbhKZNBP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Nov 2021 08:01:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637931483; x=1669467483;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=uawh6T6Xim9vStSjmO392m9Vpg8CS/1iKqbSt7AYcL0=;
  b=j0vf7Rn/zt+emTYiCq+v1ha1W+/Tz0cdC6sZKgbfo3vHXodZU/0fXbTL
   5Hcy/JP//RfX0nBlggwGyi7bLtgSCuZsLWVfCGqctXqwF40xkMDp3hrmT
   bjcwVQa2l+rT7QvWgRC632144wPVb/YQRTzpLyz0PaiZoP4gLCgeo/MBo
   ucmdwjRskYgaxhkqC9Fhr35ROWPCdRZSfBBPUVl6GnF/k3GHAvOEQ5it8
   p4oPiyfdIiwRWuR9Kswp+ABs2grcHlDo7GSjFhoHWusMycKEr0EXeHNYZ
   ONQi3dDAked/lJrxdtJJ+1D2tLiyNKXiqboklETXnwD0fCKpbCym06xU1
   g==;
X-IronPort-AV: E=Sophos;i="5.87,266,1631548800"; 
   d="scan'208";a="185724645"
Received: from mail-mw2nam10lp2102.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.102])
  by ob1.hgst.iphmx.com with ESMTP; 26 Nov 2021 20:56:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yn/6C92FXQjSfolrobjsw+feSW7Lkaf+M80YYuylWTAg3iONmAP4npSKwgpJDWM64//bn4tHI72MwzSWX2gclcelVyMJKDhh3COLvtvkzkKt2QPulOqExdnh35AALM9dUhiI+EJGPY9rA9Fu5WCtoJ1/9hTsdeXViUI2EVJ6MTL8l27xL1vRo6rWSv29E+huxKAeY6rvfI8d09sP5xmUe0YMD1eR/ID+JmqjgICppYOOrsKvGj9Y1a+BlLlNIxFysNDnqkAW8zwe7Wu/RXtvQszEPU1CWjmwEOHsj/u4dj+8CLiqQhBNzQNNRs00/LU8jCImvEZ/FBJcfFZO1NBg4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yv6kUxBtz9sz/Qd6i2mUDyN7cTdDl/bhBqUgbsgoXtM=;
 b=BjJm6MuqwZGzCZMW5fi+7kbsKX75BlRnLTqZp6n0+hwxV/FWumJT8O1q655aUEJy6J0Nb+gBpe+frT1FdT3rl/cEcjLm7M52tc3yM2rBmcAkQxL+NK5G9gHU0xcf9XrWyA3yr7/oGUIfLJvrlAAV/xrNEIRzKth5OoVXbCutGHm8EHc3gTiVEYvTx6XHOq2jsXci9H6Cfy9r4er4CdMJUTDxJC5oQcZ7bRNrY1lsrzENcnGiKVw3vVbkzG7N8XF4yrqTRUrxYUMLKQgGkynRATeFJ+Ux3vnrLyq7B2wf0KRmEDClSA5LnJ0u1TsNqubmIEntqVlX9IofsRsfinZQ8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yv6kUxBtz9sz/Qd6i2mUDyN7cTdDl/bhBqUgbsgoXtM=;
 b=MgBk6Sm0xBNsqPuCClIFhRW0SRaJI19k8y/P9xN7ErLDlQhm0qgHTUrzpcbh7lBGv2//HxDTM2UdQak+8X9TTPuxSGXJWNqx7tjKI1YDSVzLYX791xCLVVE2ziAFg2RuyCPkHBn7lWMlLI2WLORLDZl/enEAEGvUOzFsnI6FUP8=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7349.namprd04.prod.outlook.com (2603:10b6:510:c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Fri, 26 Nov
 2021 12:55:59 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca%4]) with mapi id 15.20.4734.023; Fri, 26 Nov 2021
 12:55:59 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] scsi: sd_zbc: Compare against block layer enum values
Thread-Topic: [PATCH 1/2] scsi: sd_zbc: Compare against block layer enum
 values
Thread-Index: AQHX4sT1wmIgicv9UkS/qqm8MDen0Q==
Date:   Fri, 26 Nov 2021 12:55:59 +0000
Message-ID: <20211126125533.266015-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.33.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0ac9545a-2374-489e-98d0-08d9b0dc182b
x-ms-traffictypediagnostic: PH0PR04MB7349:
x-microsoft-antispam-prvs: <PH0PR04MB7349104C1CE250292773437CF2639@PH0PR04MB7349.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l5joOwHEyBBQ+elWpwFlAWp030kI/4fUYqaiQ/8evryb3AEk9MRrQLzibVRApR4PVDo82whpThCJWU8hYKquPwtBYrCTNXZZo1jsPKy9xeb3P9QgHVpIl/cyaSHYGkZ3ui6zLiimLH2maUoMLeP+zrtP73/VA8rSWTd3R/WHahvsjCgot6V6knEKcLyq1vG2PDq2F2OiuL8RfA/P4Y/nDCZWlIPEWXjv/MLDMkgrnzjSuUsqviN26eGZeRt6LK/iEO8De7pmGZyqCm3I6Hp5JmSkmY5/5Ovt8KYj3U7TrBzcaY/k3HeDFC+zF2fOtds5LChAORuShHsgnjLNHUCryoFU/z/EAFRIpEj04KUXhky2J4yqzSUW809yJ0CdnPS78EOx4T/ZGsq4HPIWlkXCtfteNgYE5UoVVkDVxC0e5u4ymgArNuBvoeeWiB+xJFMTte0ZFJUgjk6ZCqPvwPHosIhmODfv05iMIzifd5v1xmwlxBX33a+oW8QhZZGexOe1r8Z99XSrlvUKuEsVS/1U3JxfBFpEkxRXxaO0P1uVDbqa0SBcbG8AQojNpBHtKXW3+1sTTXlFP/25OgYym5zPwBNzcvZIAuVlTHm/9k3UoLbmo2ojvJp2yDFcoL60iJEhw/gYbCUK2IoGqgPiLrtSFsdfGcbbd7e9K3pSrnTSyJiixLhDQy9gAc972+M4FDflJ6sqdSIJGsR2BfRXwZeCAw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(4326008)(82960400001)(36756003)(508600001)(6486002)(26005)(122000001)(86362001)(66476007)(8936002)(5660300002)(2906002)(38100700002)(186003)(110136005)(71200400001)(316002)(6512007)(83380400001)(1076003)(38070700005)(54906003)(64756008)(66446008)(6506007)(66946007)(66556008)(91956017)(8676002)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?FyO1E/JUh64aHiQOiFQSoxZQKDhJbuWZ0uAaWE/Z7ygpoaDE4gZCApBts8?=
 =?iso-8859-1?Q?ekiMy5jM0RgzU36/7faJ1vxamWX+r4qo8Yh39HAyoOVeGchiB6kVySG1oZ?=
 =?iso-8859-1?Q?zlPAOg+Rau8/sVhRkLEAMh9EfHTK5HScwvysP3NkwNkMCZs1sc7iNyPTG2?=
 =?iso-8859-1?Q?u3oOntqff0TDfZC2xlDJtZYXspJbq6+KQMeW33nLnzC+OJ3hv6Sl/18Q69?=
 =?iso-8859-1?Q?BrbRyDrO3LmEmDWErAQy4s/vZdwyKEPRNiTCwtGcN2zlmttkgPcW5EO4Ry?=
 =?iso-8859-1?Q?TwWPza3zZl73pG+ZRfFpioB0Isi0XZJpN9vA+q9owQOkFW0pPpebe1dRZg?=
 =?iso-8859-1?Q?mRnfdPtbvqwE7UvD9u03K7q546/AwWJjCEGc5JEGOXikojrweYuwwbt9Zs?=
 =?iso-8859-1?Q?JT+6BKloBInAR+mjk6eh/CI9xGEEe72oeC62fu5wBe3ZaOOO+ZES5SdRZJ?=
 =?iso-8859-1?Q?TJt++TTeiWRNz5d1NYWow1s6awgOg/ITQydK7luqPv5PrUWBN832blWjTN?=
 =?iso-8859-1?Q?HbAehKm6ai9wp6JAtyBN6+fNyzriiS0IwWdKYs2E4EJYGak71vsGlq7Syg?=
 =?iso-8859-1?Q?udDsaqsDgeLIpBWmTPrkPkpzIWw3Tt9nwa1XOMvcVlaAZYiAPFFsV+pjTb?=
 =?iso-8859-1?Q?2XiwJTM4yWny6wuheEyQ7kilLlGcAiFKLeYr1yJYkXanqJpWRKS1+VsZIl?=
 =?iso-8859-1?Q?GCXOS/evupOD53pOxmTsNIMwwnBQCwqAB7cJuyDOVQiNdTr2KfeRxOzADd?=
 =?iso-8859-1?Q?nxlj+Q+b+DkDsA7wF+1zisLEMqosmXJfVU1Qc27UDJFbnL8HRvLU08KLVR?=
 =?iso-8859-1?Q?vrnUYQ9swwOvEHNq2KmK3o7vLHSHQgvbk8uGjMMI06hALsScBbJPvNZJm2?=
 =?iso-8859-1?Q?mnWxQ3Dmr8Wj84Ti+2k3bYZPfz/kC6JLKr78dPS+uS9b/Xfif3drg8dnj7?=
 =?iso-8859-1?Q?yDRp/Dxxz0A9H46pNk4F5zWTdqEA6lohPci1zY/2B6GlWTlLEnc46xOGmT?=
 =?iso-8859-1?Q?u0c6qGIjXFmDq/jSCfbdsFEYJ6KSHe2ckwN21O/82WTuIDGYz0vWGNEyIi?=
 =?iso-8859-1?Q?E3yOuynPVmgKqtFoh+hKfGoj/29rEoKibLPE3aia3szJnFXUb8K+OqXyP3?=
 =?iso-8859-1?Q?Xw24OXruRjTKwl1WyggrUMxg+E9eI0nowhZ4yHFSBLcWFhGe2Qe/K0bUTM?=
 =?iso-8859-1?Q?qpM1UePIH0GSPPtHwRsgr1g40lWFh+y+sgZrUJr/MHyPbTvhj1lp7Vy9cS?=
 =?iso-8859-1?Q?lfXryOlQQf4OGRbz3vOjRxeFc6seVZwmw4jU3LZoRgVa/Pm/fQHea5maCB?=
 =?iso-8859-1?Q?pV+xq8N8ZCJ3UgiPqu+VqUTKCmrfhH+YFZJtfb0cO3RdZI4HVXy/pWbiYf?=
 =?iso-8859-1?Q?4Rji31rPYJ6rTjsb6ozut6N8pPyMPwBOmmjFD6zsua27BSrB/oDc4zjCJT?=
 =?iso-8859-1?Q?3YV3nOLKSHZBR4Vpg5GtSRNo92P44FEwbITLwRkkn8lw/dCTVHRAVa2ynQ?=
 =?iso-8859-1?Q?d70E+0p4MRnw9QhNAPb2dBdtH3H4qcMVzproiudn1h8rjs2tw3+eHLIsA5?=
 =?iso-8859-1?Q?wTe8Ue2N+UDQm1GdJx9RJ7oyL6KeO7AncjbS93kfLK8wpyO4YAZPfDQeWX?=
 =?iso-8859-1?Q?a2XvqV71dAokPUEpBDvYH2B/tpYZzNkjFZPgEZZfyOfess+Ez6cRGvVoTq?=
 =?iso-8859-1?Q?CHjaCa2yMJpbtqQSpR2ZURl4y1NERSP1jtjQUrg/?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ac9545a-2374-489e-98d0-08d9b0dc182b
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2021 12:55:59.3235
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n6vCc1C0iKO8aRG+Qdl1PGA8k1WAALwoUNQNOMW+cefErRaIy+7LmIN2CXK6r/vPf9taFNse7GakKtJ3h3Eirg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7349
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

sd_zbc_parse_report() fills in a struct blk_zone, which is the block layer
representation of a zone. This struct is also what will be copied to user
for a BLKREPORTZONE ioctl.

Since sd_zbc_parse_report() compares against zone.type and zone.cond, which
are members of a struct blk_zone, the correct enum values to compare
against are the enum values defined by the block layer.

These specific enum values for ZBC and the block layer happen to have the
same enum constants, but they could theoretically have been different.

Compare against the block layer enum values, to make it more obvious that
struct blk_zone is the block layer representation of a zone, and not the
SCSI/ZBC representation of a zone.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 drivers/scsi/sd_zbc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index ed06798983f8..024f1bec6e5a 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -62,8 +62,8 @@ static int sd_zbc_parse_report(struct scsi_disk *sdkp, u8=
 *buf,
 	zone.capacity =3D zone.len;
 	zone.start =3D logical_to_sectors(sdp, get_unaligned_be64(&buf[16]));
 	zone.wp =3D logical_to_sectors(sdp, get_unaligned_be64(&buf[24]));
-	if (zone.type !=3D ZBC_ZONE_TYPE_CONV &&
-	    zone.cond =3D=3D ZBC_ZONE_COND_FULL)
+	if (zone.type !=3D BLK_ZONE_TYPE_CONVENTIONAL &&
+	    zone.cond =3D=3D BLK_ZONE_COND_FULL)
 		zone.wp =3D zone.start + zone.len;
=20
 	ret =3D cb(&zone, idx, data);
--=20
2.33.1
