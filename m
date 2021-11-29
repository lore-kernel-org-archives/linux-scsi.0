Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 599ADC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Nov 2021 13:17:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377353AbhK2NU5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Nov 2021 08:20:57 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:26922 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235896AbhK2NS4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Nov 2021 08:18:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1638191739; x=1669727739;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=04t+K5EEj5Rvf297p1C8w9VZS432qSxSQ6NE/9OauMI=;
  b=BfY8KVfma+s+wGdvsWIksNDniMsT/TH2tXZ7sf7UGBgVKf2yZVS5CxI9
   vBfVb6K20WmJkwoXSITcbIJL0uSQGWE6QSZ3C5Acwam0LtpZtl9tagFdL
   C5GbhaE0ZXV4sH+LVFL7quJzEsZRjWCk8t2WkzNeNQF/RxWRq5nlAyDaU
   pAAOqTA9ESmMxmv+5UD7KpYfLO5grQ3WVv2Kl1ZbD53e5WwyL39qOAU++
   gEFK+lQzApCIakLqHcXJdoKsfDQgss3tuff3eeLxGrnkNHSSEp0JTYABZ
   bA2Zwq9Z7r74e9eJemyeHAZUXDBoGpCe38GbL7mvSEf6wWFRXt2swEUUt
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,273,1631548800"; 
   d="scan'208";a="290909479"
Received: from mail-bn8nam12lp2177.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.177])
  by ob1.hgst.iphmx.com with ESMTP; 29 Nov 2021 21:15:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hxhCuYOsPwHXD8U9f07YPFX++CXQC0w44TqxWOPhyOjMAJ0DkCWdXucWcXSd1ImF8BP2VGC/QyD+t8eTGHyhBpPyjNpj8fswPdlvdvA3p5IzW1HguzpYFvaC07jSXcOzgidi3/Su5eDLpr9UUB5mFb4ijO+QRNT+aqE4er2b1QeBBA3Qk52bJ7h9KIr008NGVwlki0j/6gcH614cdJRHGHTWCuyYUYapqqRGsnn9CaXAv0bKL7WGOP7byZVKX1y2DzVJ9zrlWJ9ozFvyAWx999iIk0PuNstvPKzhbqH41PQmBmbggwGy5vbx7fbBqxBhEACscR7YypgXkvJpIpJJCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5rx42QRRJWR1JumR+w7sPHzfRYTDjz2mCAXKfSRK7Bk=;
 b=NzB1XvDuz5J2JnviSOjDJqgF3XDQ95LBqxPEhVqTbwfacwbwNsP8siSgqiEOU38Rms315yHpac5Sib0iMylKVQ+bZbzXXK7hkeDl9IP4ljqYRtdRo8D2gcvf+3OHJCezfzjI9h6AE3CfMcJ7WOK6IcjfAT2t3Q4lTItv3OGGgORIMH5iEvNhY83UlDbrv46YPPbyzoUshj8oFnQnKpIkWRmXIlZSX6rzHzl1WUFg0h7ntN9gfGImjbYWcfaX8XcDR/ssPpdbmykhMqykeeX2gd+J8P4pWHPbJLInJvIHFfa9x4FH6M6Mz/kHUHqGYgDP+3xZFUUJN3dIOR9rMz8olA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5rx42QRRJWR1JumR+w7sPHzfRYTDjz2mCAXKfSRK7Bk=;
 b=D+4jF1mUvjGA8hTbF/HqQVe9Y6SyCdobcOSoOI3hdoA5p4+fudCsX3AryW2MMVPwEgVHiVZKcD+HMPZAXh6fbJJtQ7rGdc8gSNIUWTyPAdxqLyaqXaV19uorWS0YfLEp7r2htbNto0lKZW45vm+tyIRfdnjDTbeYhbeLC1atJqo=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7703.namprd04.prod.outlook.com (2603:10b6:510:5c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Mon, 29 Nov
 2021 13:15:37 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca%4]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 13:15:37 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: [PATCH v2] scsi: sd_zbc: Clean up sd_zbc_parse_report() setting of wp
Thread-Topic: [PATCH v2] scsi: sd_zbc: Clean up sd_zbc_parse_report() setting
 of wp
Thread-Index: AQHX5SMyRtQXEDl9pEGbEIjTATD2dg==
Date:   Mon, 29 Nov 2021 13:15:37 +0000
Message-ID: <20211129131508.350058-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.33.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eaa8a7a4-e635-446c-bd6f-08d9b33a5582
x-ms-traffictypediagnostic: PH0PR04MB7703:
x-microsoft-antispam-prvs: <PH0PR04MB7703C43B5151148E1EE8DEE2F2669@PH0PR04MB7703.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mLZkUzX42CEPRODJBiLHGnnokLVMMFroqFiEdrV/WrPf/cI++auxoSpCWdwKTHX0L2x8KuoKgtD5BZkeuez/6yCxOMCLLoKiP8u1/jldPkPg9ZCrMlvsB7E4jwMuN4FXwq7J0QUtQEmnHBkoTfdrPRlbjjG5t6ef23LknVKZh/EcOZHIh5ehHcptaxbpmJtGsOaaQ2aPe9x/cwBEbDQTb7rEzvDwA/ZMKeMWyltEfpuAYgbCWXf2rv0MRwpo2vazyH74zbmo+8g4DLPPHIxQZu5dAI2UP6J2g3gq+zM0bR+/tHMAhz0Gwxk7cQgsEUoBZWIRXd3hUT2+KgmfDuoUXV80u30TVACFyRgInwLJxCqDKm/nvAcCYFkB5aCdfBQyCOPBlybmtEGy10KZRIDvNqUxcn8WeR2vV5cg2WPkKM46HSi9hb6Rfh6LV06YatWKPNLOg0XlRoLMFYwoR6felOHANYAI30r3eTFo7HvnHMhj0tMohgTFCGG/HEN87Lo0u4PO2MsReCAdSGh1haVvx3mRxFRi+CrCt22AD0lDY55KOB3wKx5UhRJmhmdXOQ47FMLxYcIlfcih3H5KkjHPt4VHQCbdZogQxV3ufymnqZCu3yhv7eNF9jCgb2Ibs0iFACS3YQsdyoqKsU/KCeK2SiVun4Dh3qw0kC7mlCxXiG7jQkkt5aurmM+bwZmsUJOZYjL1Mw2N0iGRCDWAGP2eqA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(186003)(4326008)(66446008)(66476007)(66556008)(6512007)(64756008)(71200400001)(38100700002)(6486002)(66946007)(86362001)(38070700005)(76116006)(91956017)(6506007)(5660300002)(8936002)(36756003)(26005)(83380400001)(316002)(110136005)(2906002)(1076003)(122000001)(8676002)(54906003)(82960400001)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?6Ex26fty7xRolJ2iAfKddroTn3Wy8lknIeAtAsFaooWk0t6H5iHWGDHlQE?=
 =?iso-8859-1?Q?V8FsL7bk/MstWphMMSJoVPKwierzHOAGBcL/BrGhLuOb17mPk3xn8IUlOM?=
 =?iso-8859-1?Q?m3k7dRTIaopaV6ceRPUzc/F5anceuSanHYjnJf1j5FpgDLz/BDO3Xiblpn?=
 =?iso-8859-1?Q?yr0ZJDKfl+XopXrUMAUawFk65A/sKC262oNC6Fkqe97CpVO57x9InoXki1?=
 =?iso-8859-1?Q?x9vwEjtl218R/alKD3eOF9RAUOYJQwuZc3rufJB0hf4ftNF+lZdnYm60Pa?=
 =?iso-8859-1?Q?gjfZnKEht+Cv+1j1FNhke4nFXsNc6St56/M5Em9sA26vDohHv+08b6NkyJ?=
 =?iso-8859-1?Q?ZQLyCi9WqTCR5Fnvc5qIzQcJq/FS2B/WTXgRXWiAwMBmcpGnoQiXP/uc/B?=
 =?iso-8859-1?Q?aQSlJDC+SKAp3LpqZ3WRJfJ9+HdV6xr6Zcvid6ry7nnfVejyOMyTWavF+D?=
 =?iso-8859-1?Q?T3QG6TqV05VH8NoLe5VWUIgQ3eacNKGt9kn5o+382tET5VmshHEoqfAsow?=
 =?iso-8859-1?Q?0zRZEFy0/BVs+iuzPsEIzC0PkDO8nzsh3pWeIr2h5GSOT1cUuQiIG9R7aU?=
 =?iso-8859-1?Q?yLyRULE2aKhQ+C9qSPwiRSNXDu5iXkj55hiG5sta5BKTclyNVc0cvGPDCE?=
 =?iso-8859-1?Q?z3wIjVLH09fGpX0GcPUIN+ZpfMl1nQEmJTOecyodzC+BpkQNUhcj3TJUg6?=
 =?iso-8859-1?Q?s6KgQkHrmc7nLG2NYKMTPUYK2n9u0FoN7B07uZ+x4cGi17PPKkrLc54y4y?=
 =?iso-8859-1?Q?nrsG5UhqVKPisC9s6wY6VuAQJLw30pk6X05Gjo+s4kFHqIaQjVj2OK+FxW?=
 =?iso-8859-1?Q?K7RgXUdyB5ouSVDRh35aZfkPCn+AU2q1j6HpN6d+aA/Ezu52JHqrKJmaGy?=
 =?iso-8859-1?Q?5fa3QqId4ANWKsryuDM+SMiM5psPe6/4619XBTiEoqrAqoss6+cYwMke6+?=
 =?iso-8859-1?Q?fl1enK9mzfltDiJoL6f/nkcA723VnB4oQQfmOuR1BGmVjuEU95kCKWRp0c?=
 =?iso-8859-1?Q?WXpaHYxpTMobAjzhPUJ5R6OQC0cS3NHidKs6QfW9Ib7pDcTsyCimwzuy+l?=
 =?iso-8859-1?Q?uLxXc75dkay/is6U5I/c467l4YasercTFy0Zt8Q/ICHEQ29nnWYbUtdHR6?=
 =?iso-8859-1?Q?aGaUq73/13+Ui8dnnp4JDZ5JnccN001xN3L7cWVQL5+BL2KFYIW5ZadzCA?=
 =?iso-8859-1?Q?tQOdYcrDRkzfhtnwXDNA9kU9z5lkH7FOWCmPBiHc16mkn3zBv9G0Fq2jD0?=
 =?iso-8859-1?Q?Gb9WfpFbSy0nTXaOoSfofX8YPc8iAzJhQXzp9KbHrQ2aUm9feNV9+cbqvf?=
 =?iso-8859-1?Q?66gM0DmZV9elZA31EhVEJBGiSjPCxLGy8ZQiB82ip6KBo1sQXa2mz47PEQ?=
 =?iso-8859-1?Q?nekCqHAvhllB+c4ytqEcERuRSPosYw5qy1o3kvKskh4zjq7MUawp3vBWLV?=
 =?iso-8859-1?Q?3502AbNYt/fwB7RQh8uP2PIjcmUCgO4Q1RvylHojEa55GK30mfwXoz7nKc?=
 =?iso-8859-1?Q?p4B+sMGmyva3IHW/+UM16BlLaOe1v863oET3n5KupV5Eyh+0jMXh3fI827?=
 =?iso-8859-1?Q?08NWFoU+gACamz3U/ofq7IzfKdDLKk552IKaogLQdROE8MIMAwOAJ0qGFZ?=
 =?iso-8859-1?Q?GUMnjgF6qp63hGNRmM95k81B4EU8MmTbdAjZoIKg0frjQiikbXTcRNfgNJ?=
 =?iso-8859-1?Q?dcYkgxNLQ+iWOXRGrDc=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eaa8a7a4-e635-446c-bd6f-08d9b33a5582
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2021 13:15:37.2189
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CCH8UrMii4FUSuv/cWVL2ElzG2C3C0jlq2c1wNBTpJFSdf3DFtCfYoyTIOmVCPA5X3NySKesrULGaMTrdD0yLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7703
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Make sd_zbc_parse_report() use if/else when setting the write pointer,
instead of setting it unconditionally and then conditionally updating it.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
Changes since V2:
-Picked up Johannes' tag.
-Dropped patch 1/2 from the series. The actual +/- lines of this patch is
 unchanged.

 drivers/scsi/sd_zbc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index ed06798983f8..20e849437687 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -61,10 +61,11 @@ static int sd_zbc_parse_report(struct scsi_disk *sdkp, =
u8 *buf,
 	zone.len =3D logical_to_sectors(sdp, get_unaligned_be64(&buf[8]));
 	zone.capacity =3D zone.len;
 	zone.start =3D logical_to_sectors(sdp, get_unaligned_be64(&buf[16]));
-	zone.wp =3D logical_to_sectors(sdp, get_unaligned_be64(&buf[24]));
 	if (zone.type !=3D ZBC_ZONE_TYPE_CONV &&
 	    zone.cond =3D=3D ZBC_ZONE_COND_FULL)
 		zone.wp =3D zone.start + zone.len;
+	else
+		zone.wp =3D logical_to_sectors(sdp, get_unaligned_be64(&buf[24]));
=20
 	ret =3D cb(&zone, idx, data);
 	if (ret)
--=20
2.33.1
