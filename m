Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A932C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Nov 2021 12:58:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235902AbhKZNBQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Nov 2021 08:01:16 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:2592 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348845AbhKZM7P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Nov 2021 07:59:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637931362; x=1669467362;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4/q+JY+ZmDh1uNqJvDKYK/AB9nKnNhlCwBVSg9euqi0=;
  b=fydDvjwnxRFz2WL4eYHPS3NUp9wqFpUnx9Ja7PrBfK++47RnFCJgWvTL
   zCw99oNxxlX1l4RdJcSvpB+BLNY6INT9c5gxYIUA/ZBu5yyzWD0LvyUv4
   pQr0i055AYO2BfgxD6uce+3j9Yon8uP5nls1cHzKB7htTo1H7dhAy0kaa
   ep5LMwJxOotUQT2QSNl+DmoJoOoZTH43xgWjjb041Uu10nK5bOdougj7S
   wvvaZvqbidMDUg9NdRBXOZkSwExAXHyib9G54Yz+/17pmZGj/Jsb9FBfe
   wrWYlZGABS8vZIqsu5nrcWvu+2CV6iowpw0mCVZABxUps9U0KLWiZpJot
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,266,1631548800"; 
   d="scan'208";a="185724642"
Received: from mail-mw2nam10lp2102.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.102])
  by ob1.hgst.iphmx.com with ESMTP; 26 Nov 2021 20:56:01 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DIk5m/D/NpFxuCsoBxkt9Rirgs/k4+qLYgMMf9yK/ANWaYYulsz6gn+/9Pl+YWa0BRy/s4g+kYFUtijbVB8608V/2gVYkiRseYGKZJZcSjTAU7AfHrbUBNFmEeRbh5rrsO1XpLm/iqZWPJUILDtA+Jo/tLoflJRVksYDp73Om67NSppAJv6o3bKppdIlpUFKDiYiVO/9O0g1X5ct0RFRMpJ4krhwddaoSzNmZ28jWiLpCSdo9ZTDf6K8/XzkA1dzSGObRthbtgeVe+vtq+tdsZ2E9mzckAWRdjceq6FDAkRQPxXftcSMWqA1E0Pg8n2AL5jmuFuBubvgiOKFtfbr1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TykXflVn2a9ppDebqtHnNPCoBMj34MGrCsSzyEB6D9c=;
 b=SYLHS7MSZkEBp7DspMAnDF5kf/C5BTCR7DZDRlg31Spu8djBvpAoW54ofLfAhKzCZwbusfOJiU70aQkSJk1CF7L08Dh4doX0+zdmCFMIms3WT6B/bbYxJj7lE7WUYw/IUaN7fsrLSkMXKJdaTUQhrfLcVw8W3Br8K4VEYop8ccuy8dgd8ekGBNqjQJ1hvViOasnyBPdIr3hCNzFhbnjRq8AbCPtzsXsDe9iE9D15UjfpbsPr2RX1EMTi1BIrL4P5cpcKBcFWiIOAdL1+L1KvGHbkBZu33L3xxkSXBb4BYaBA2xJcVA26Wy3RELUhxdP3ewfek7DfrY3gIxp81p7ENw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TykXflVn2a9ppDebqtHnNPCoBMj34MGrCsSzyEB6D9c=;
 b=RFCErm1UEODIxy8TbO9lnA+dQD4rRV1qI/XkZyim67uIFUoM4hN5S5wNHmsb0Eg6kkXdSX3M7M9QXSg1V2vUpwdBB3+dQo39qXTIR0Uw/DcqxqBPlyFN6rKCHO77Sl9VEWKjfOfM46a9lBwwMUQIU/CYk/UPIA0hSEcuAGCWQxI=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7349.namprd04.prod.outlook.com (2603:10b6:510:c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Fri, 26 Nov
 2021 12:56:00 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca%4]) with mapi id 15.20.4734.023; Fri, 26 Nov 2021
 12:56:00 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] scsi: sd_zbc: Clean up sd_zbc_parse_report() setting of
 wp
Thread-Topic: [PATCH 2/2] scsi: sd_zbc: Clean up sd_zbc_parse_report() setting
 of wp
Thread-Index: AQHX4sT2GcpwnIKOLkekqsyXmCouYw==
Date:   Fri, 26 Nov 2021 12:56:00 +0000
Message-ID: <20211126125533.266015-2-Niklas.Cassel@wdc.com>
References: <20211126125533.266015-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20211126125533.266015-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.33.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e9ec9ed4-2220-4959-05b1-08d9b0dc18c0
x-ms-traffictypediagnostic: PH0PR04MB7349:
x-microsoft-antispam-prvs: <PH0PR04MB7349597322367C3E0E97F588F2639@PH0PR04MB7349.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1360;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u/+IN7fkZc1Bo8QDj/W/At4WohC5lpomVku4B5phGpg5i6zt+3l/1zSKVYBdWoqcOxpBWh0YLUEg5iluB47qFIu0o/iRd5MI6wgHwBVF6Lu2N7dVQQEpzqYqEDmXza6oyVXuyqKdXF2r/7MkBUzjY7hF+wYpOZw9RSki/hQ5ado9el4xHPHSP/wex96+nguNsaukfgn2neuAqHpIrFlte0cFtTkBoy4Psuf3LUA0d3MBOtGLO3fLoM7GUHTywI2zPsfn7AsuhpaIvim7JMXaws8mpKJWEEqCG77V4yVfllGy24fIUQmzvJSd3wFklEvZG57I65qDuHMbA/aluiXzXplUEiYROUBSMyoAcTu7LghfGecbAgHuXPMNl7Tlj0A9knaj2emT0av+HkZaitsXfPIoK7P43uNztJ8Sxwu8sMb4B1twGqXB9xp3MTQwi7zCk2JZLkT5hlIphCCj7fikDtYsXbpRLehO1FSigfAvXrscilgS1eDxigjxNHIQA48sRK0w/xAswf/4O6hds2M/9zaCvFfywDh72KtsLoqf/NlBATM/RqM/Ry0hqC6sCRfE3Cjol8YGkfQayEFTDW6DOnRqIiQVdYAME3ipymoOPEe0jWWpMCPbSyfjdX5jexb+nfmTXzjdAjCXgtMt230wYXlTtVFHYZ9XMRGGlXQ64TmjPVoBJ+05yjGe7KFngHoufdz494AfQuNNijJt0xxGnQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(4326008)(82960400001)(36756003)(508600001)(6486002)(26005)(4744005)(122000001)(86362001)(66476007)(8936002)(5660300002)(2906002)(38100700002)(186003)(110136005)(71200400001)(316002)(6512007)(83380400001)(1076003)(38070700005)(54906003)(64756008)(66446008)(6506007)(66946007)(66556008)(91956017)(8676002)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?/gPRJDQlV+rrB34X016vbZmhFlO2qNgBpYp15Dfaqalyh0fHWvi6fI0oao?=
 =?iso-8859-1?Q?KSUUfnwYdFO1/csd2R//1k8uv4GQKmJ9NMqb3qd18HuWFWzYluHApO2bnf?=
 =?iso-8859-1?Q?yUADoxzEPC54aadrTBRF2eoU3PQvN3nvPgWk0nMc+j3bMK5ECld75YmA+V?=
 =?iso-8859-1?Q?BMvgtrNp8JLKfkD7PSETJohkz2zLESYeSm70xfCALetfi016CChnkwYHM+?=
 =?iso-8859-1?Q?nzYY4ABlCQUpG556o3CmzhXGY361F3WJ+4/YDWmR/rYf1MD+m/WoY7BTap?=
 =?iso-8859-1?Q?jT282KwA3+lqBp18r4AbCmTG9qF58qqXlU1/mHdZAMPoarI3fyVjcdBGl4?=
 =?iso-8859-1?Q?M/hJSE71B1XR2JQ5IXtd1yNBwKs231lpstrx7VD09lxPQWUo1z4KHoGFMV?=
 =?iso-8859-1?Q?Uz585hAdKCSViolte0aZbUKjH1H2U26DjcGDTNVBUUGMfigYxEyfyjud3L?=
 =?iso-8859-1?Q?fzijPSePIih/YZKmgmMNfK7res3x/sfh0eZefGyWfLnMP39cYNPuKAuuZ5?=
 =?iso-8859-1?Q?Vfz/gR0pTJEFlqNaPlPltvrj1FbyPOmzpoUZ+DgRlPei0cEo6Z9MxkiT6y?=
 =?iso-8859-1?Q?kh8j1Of4dS3TKlb/iiIK3CZMRa8aDC0K19i9G9oD2gKzIUiLpvH7eGEkXO?=
 =?iso-8859-1?Q?zc/zPLnOnzNo51JWWfuBSPepjjyy8V+cLjYEhdP5Usa02mKWF8YStPVQ69?=
 =?iso-8859-1?Q?ZZKW/mUGY3tQBYDH25i0UKmAoVL6lhlk2muPGEEbIF1aP2d2e5DVFMMChm?=
 =?iso-8859-1?Q?eh8hUNn8ZwXC/aZTorn47iyPh4P/MFEUeCectbnTLnzMzFM4Q1sd2Q2knp?=
 =?iso-8859-1?Q?bIDkcNGzBzTHJ4ovr3BVnhhAjdmEuFoPctfttuOAx+FWKXeyVybMHQzFTf?=
 =?iso-8859-1?Q?jI02qRJeaanweYU/sygSnuWS5amGkOtoeLxFuLqwPiJYxmdaqpNwZo019k?=
 =?iso-8859-1?Q?mw+FX9EdqPG7vjttM/XRcJMYSJ8/rj3oM6foPK8dFHs3GydnRbUO9SzVel?=
 =?iso-8859-1?Q?F1zohIW4oQZqQ+h+JEhs34RbaU29tw4L+he3GbS/60GzFh0JC7cTfUqPFU?=
 =?iso-8859-1?Q?Cc4Ef0GCD5jawkOtiiZTijCkW7fCCmxEWC54r9nljC59wsK7yWgJigTTyi?=
 =?iso-8859-1?Q?ixkWda3jrtcJ5YV4mhqxAh2jkdYJFOGU4JAbUv+lCX0/FZAUegUzZXSEL7?=
 =?iso-8859-1?Q?u09WBsLwH/yCZgbLpp9q/Fb41j59zC+3HaDHKtpnGVPzT0zuHRoDEBCQiF?=
 =?iso-8859-1?Q?e7YOb67AsdXy44/oWdCxWFxs+5HFA25SYD14k0exrDpbPYc8naPo7uVOq9?=
 =?iso-8859-1?Q?p0qKiECSy1gkDmzVYGrRUquzp7tLCaF8u7hOydfvqsFg1mZDM3M2Olhvf4?=
 =?iso-8859-1?Q?tTlAuNI+WQsJwHbiOv4Ed8HJXf9Q7FWEr2DLiDez+Qz+Dqh37kna3HiYw+?=
 =?iso-8859-1?Q?H3X8cC3Esnh6+wNSOu7RJqaAfzYsodbYZu46BXDCFG0JxiFFKqzY8WOK2E?=
 =?iso-8859-1?Q?qfWJ0iGpukQsBmkqCsWlD0e+QwPTTNHUnj0zjK05BnQNlTeNWRDbZv08En?=
 =?iso-8859-1?Q?QH9ZG9e3Bhz7gxB0eUvaQ3S0ZcTdeo9hGgAiR6cYzpX0Bue4YDNLE7jugR?=
 =?iso-8859-1?Q?5+V4or+tKkd+WCjJQ/scKBECnVQZWW/AZJjSHn7QXAAGqdgolTYvDanrSq?=
 =?iso-8859-1?Q?nVS3VJkwXFUGOsejyanYF261Wtm6rtHILCrVwy0/?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9ec9ed4-2220-4959-05b1-08d9b0dc18c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2021 12:56:00.2285
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VtxEGgWujgkZMxg/SBRLlwYpO/+xHLzIOH+cZ4R4kluWGoHM0zZzzRN+OS6oqf2dsIn5dD3N2AFDK4PsARPkbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7349
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Make sd_zbc_parse_report() use if/else when setting the write pointer,
instead of setting it unconditionally and then conditionally updating it.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 drivers/scsi/sd_zbc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 024f1bec6e5a..3e25ded3ac0f 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -61,10 +61,11 @@ static int sd_zbc_parse_report(struct scsi_disk *sdkp, =
u8 *buf,
 	zone.len =3D logical_to_sectors(sdp, get_unaligned_be64(&buf[8]));
 	zone.capacity =3D zone.len;
 	zone.start =3D logical_to_sectors(sdp, get_unaligned_be64(&buf[16]));
-	zone.wp =3D logical_to_sectors(sdp, get_unaligned_be64(&buf[24]));
 	if (zone.type !=3D BLK_ZONE_TYPE_CONVENTIONAL &&
 	    zone.cond =3D=3D BLK_ZONE_COND_FULL)
 		zone.wp =3D zone.start + zone.len;
+	else
+		zone.wp =3D logical_to_sectors(sdp, get_unaligned_be64(&buf[24]));
=20
 	ret =3D cb(&zone, idx, data);
 	if (ret)
--=20
2.33.1
