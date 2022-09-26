Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55065C6FA8E
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Sep 2022 20:53:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbiIZUxY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Sep 2022 16:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbiIZUxV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Sep 2022 16:53:21 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B284AC38D
        for <linux-scsi@vger.kernel.org>; Mon, 26 Sep 2022 13:53:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1664225600; x=1695761600;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CUdIBDYCzGcE9oX192fImxp4iq719tdts98j592No/c=;
  b=dF5pWBHhG5RINv99xH3Lo8OZXZ8tYD3LiYHysiGgzBv2d5+UMydwU2yQ
   chcJvhnm0ZvdJIXvzGS4FWtHcQZKerrUK66PhVQntWJUSNbQ9uwsV9kQt
   /coq4M64lyWzpoCgnOJR5E2K11ROGj3dDQb9LPpCh9y2e9y0VTXgUGRrD
   saCOdPRiSD4uVgdd4jFISi2IU/vm6m4KFMcGsreVbL1X52AzJ+PP3Wu2N
   1WGIGaizGQ0IZl7jprvWbT46qoXK4EBMCPdHBE8rpVpSMfiauCeG9jjVv
   DrzvjuWaH5R0wpLwaIpTZv9bpP2oJW7wLpryomjO0m+LDGUhNvBG1BUgr
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,347,1654531200"; 
   d="scan'208";a="316601444"
Received: from mail-bn8nam04lp2043.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.43])
  by ob1.hgst.iphmx.com with ESMTP; 27 Sep 2022 04:53:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iqYNB2qGrdphxILbRoJTxQRZwdE5S4JQHOW1VPFjyAvcQYYF9drEqe8hXTuuLIFECvRnoyFMk1s9wI5x9v+CaL5OKpdKukPfRNhxAuic6nAm5fSgvlXQWs1tn3QJ034ZwmNYDQ/vxeTiwNaMQhv1vnc2DBllMwLj6ueJWB3SNu2TR/vID/RNHWEdeMw0YVjhgsv/Y9IcEOSsFcgIRjxmHh/UA+k49N+pY9LXP5YRiKmdyUxLJPn5H9IOdjk5T3+umJB1B2WzOOkU/d0yQLhsyPnf3HD8tp8ipC8zADt9hqFBNiG2rHKFWCJqQVlZoE5zkZ55RY4/IXlSLH2DZVa+IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x0tT+n90q25QRJ/6ua9cKh5zmfhWI910JCXGvVGFRZE=;
 b=DsVWl2tOGDSueTflYJVEaUNig1fS80eyfahwX/nZjYoWm17xHQK3LEbsYt/SUFwykwV3s2fOs0hsNGQ2/mooH9TqRAOvdDKlDzbuwFD5NONYM2TTHJoMmNhBjmsV9clBPM1hP50WayN8jvzYLXVaKOMDNNW8c921nHV0cSaAw/y/fuREE9XvmVR2hZHuZ4BYsbESOAqbcFQgJgIrOqag96cygr3z+oLAIGiUqT6/lARUoKl0CWc9Xtp4wNxfU2mlA3eN94a0Oi6Ddzr7GYSw5uWz6ZO8wo4yi/QIObejQS7GpBZVIhGuWCBNFkpEFGMr/JmErTLrUyrRunMfMPG3qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x0tT+n90q25QRJ/6ua9cKh5zmfhWI910JCXGvVGFRZE=;
 b=LSbgzo8FNTOtU2/wCUwLD4GRlEPPEB84fztEUy+5o1xaB9uOkC6Kp/lEA76S98oxruLus8ysc3FEc5hBo5en4jV0JYdSlhM38bNPkmrtDudvkW/Yag5ZLE4CpXecZeZELcyQFBql+adOMK7pHElqi0tnFBjK9s3lqxR/1OH1c4s=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by BY5PR04MB6469.namprd04.prod.outlook.com (2603:10b6:a03:1e4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Mon, 26 Sep
 2022 20:53:05 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::c8bd:645f:364:f7aa]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::c8bd:645f:364:f7aa%5]) with mapi id 15.20.5654.025; Mon, 26 Sep 2022
 20:53:05 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Hannes Reinecke <hare@suse.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: [PATCH 1/5] scsi: Define the COMPLETED sense key
Thread-Topic: [PATCH 1/5] scsi: Define the COMPLETED sense key
Thread-Index: AQHY0en5GgcD/3AmgkmFL/kkbRrZvQ==
Date:   Mon, 26 Sep 2022 20:53:05 +0000
Message-ID: <20220926205257.601750-2-Niklas.Cassel@wdc.com>
References: <20220926205257.601750-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20220926205257.601750-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.37.3
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|BY5PR04MB6469:EE_
x-ms-office365-filtering-correlation-id: 47c29854-b0f1-4e6e-cb6b-08daa0011c07
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: f1VM5bdbVXkK6RyxKqn+PzO5rW9yXyU16vVJW3EA9J5gif8bwsqfGxvF2+4wkrsRUVjU24INaEGlbT/AaCtCQUFPS7VAXI27TXKTIEEsnab7FJIt6ugVoQ1PZK8D/sUJkksLzglK5tt2ogK4INSHvWfGYCWUOip7XRMSZ5kM1VHI3Z65fb/8Z8rbgCQpRCnqBFqEQQf7Dp4auv6C4CYdNm9U+hDViRRaMcr4kBkpULPF7gYFZGIEKzOo0ZnZaPj6h3UvRURGgfzEhib3EBzythTebM9MJgn4MZ7InbMiUKedXx7DS5JCU/ngf3kktfDZtnhrk1S4V7RCOqbNXsywFb16EisnQj4f+l/lnW+1DyB3jzeMm8NOTdK3X50UQc1GERj/J55OVRUN7EXKpOuEEgUgp1GJcEtsNjnzjGMXOpRBoQHZ4nojq7RgHKLYsB8sG00O1AuR52D0GoLM1tDb1Ice04k63tEZ5WWJJBumry3/BUEesa8A5T3mDE79G0mXwO24LWnWx1J7YHSU2PZhMYuOyLYWhPnyxQdnZYvXAelR0klktSnWw5Ghrghq3T1ccfVNty5U4En81oZhC74zTtBd05fENvyO2j1OAh7HoR6JqbIpY15wdmRGlPOZ8pzQpZi3nOaLNZKOYAlzjggSeY+AogZFtpcPSW3NU+jI7hUTqhBbzcOr4YZ70RkKgiRzDAWkVcrukZdtnUPqi0vrbBbWo1W3dUpjVJd3k6uMMUvJJgjIl75++d+D1OT1ElZsqXzMtt42pjzQ5sJtjrgNhg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(346002)(376002)(396003)(39860400002)(451199015)(26005)(4744005)(6506007)(5660300002)(8936002)(41300700001)(82960400001)(83380400001)(6512007)(122000001)(186003)(2616005)(1076003)(36756003)(38070700005)(2906002)(38100700002)(110136005)(316002)(6486002)(54906003)(71200400001)(4326008)(8676002)(76116006)(66446008)(66476007)(66556008)(91956017)(64756008)(66946007)(86362001)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?tI71A9ZVBJv8uXWhj2iNFRi5L5hS4c/8sfFrTBCN/B43Yc62kJ0X1a//Ow?=
 =?iso-8859-1?Q?EpqUpWxda5jp4nhj9FyKV+WB6KGeO1R6mUD93nehGz90bmqlXoH1V8yee7?=
 =?iso-8859-1?Q?QCe+rh7oeJcNaVbOozrma3T2LHvljmYrkteRh90eNs8iww1QkmvbtlwQ+t?=
 =?iso-8859-1?Q?tbwzLAqQc87sCQoAhdKw5fT/Uh6KnvwOupe3lTC57EIhz6Ie0gvTn5JhhP?=
 =?iso-8859-1?Q?MPlcMnzWG5jO+oKnQ+5y5ZRUti9TlnJoqSz7fPQMvRdfpdyjMSfS3+9gbI?=
 =?iso-8859-1?Q?IuzXnN/M4oddtYDpZqx8eBQDfWzTN3/xQlZAMcYlujLoVtLT8NaR5u00me?=
 =?iso-8859-1?Q?tolEDyhjdxbkvPjnLV3m8u0MjLoOA7qhmcjQ4UHaOD7k8/NKa4PAoDNb6T?=
 =?iso-8859-1?Q?PK99eucZJkm2pI1D6iy2sLkuE2G4cCfYslyz7IVbKWe5mCxFBuWit4w0Ws?=
 =?iso-8859-1?Q?KNBy4+OiEKpYwFSJGeJzeJ52w41rzyA8jkRDZ3t8UydO20Soo4o/mWGX1Q?=
 =?iso-8859-1?Q?cBJJoXmDSGtuBq1zKaGTRqReh2ouNohfxxTBq60Id/cbDns0RIbH2tce0M?=
 =?iso-8859-1?Q?zRyfKevZYuySjjOKjk8yf76WPhEAztUMAFhfqZ+Ok3ySRkc+A8ILaDX7ZD?=
 =?iso-8859-1?Q?Oe6KqjY3/d36ouBb/B3m0SWSE9K9fCGRj0X0kNhNoCkJyVhVOpFVbsbrFT?=
 =?iso-8859-1?Q?fIjjTh+u0i2zGAjrBhsKYbyt7xh0Llz2T95t+FMpyU8b1lg3PWva8pOgHh?=
 =?iso-8859-1?Q?07YgYZEe5bdx2hNVt+9gEYkOCNyU3nkT08/G8D7OBRD599O4PpyTe51+uy?=
 =?iso-8859-1?Q?Tje3PhhE/59EJKw9jIPwkvUh7pRZWJzu9nRip7EpuxKO9lhHnzdPZE8Zyh?=
 =?iso-8859-1?Q?xUSgTHsD+oN27hnfbEu7OrkKOamEnd/fDfb8PGDS0+6Y6mo4SjmwDuucyy?=
 =?iso-8859-1?Q?uqZ2ku5W/tY3YX8fhCh9w7dIzdw+NmCHqCXZKIF7qtpLEDGCgH0DnVo06a?=
 =?iso-8859-1?Q?NwDh84s+JFihEkC5bkg4FLB6PH8PLXTC7KOktwuCK/tOyHkcGLsFck3MsR?=
 =?iso-8859-1?Q?LmoOYC+/BbChoC/uoDNlY/qiQb54c4u5q0/htd00zqQjgiiVDJOmk0mA/w?=
 =?iso-8859-1?Q?HInHfheMGYUiHOpnkQXQl9gnaoeqDDBoPAUgQwgKy6PydETsWpvTqhfEXc?=
 =?iso-8859-1?Q?ivV3tYFFm182qL1fFqeXqzbyfsMQWfF/aVf7ZpO03zLTVF3ai7taAUq/5K?=
 =?iso-8859-1?Q?QypYBolIOnJ4cL60ZFRQsjb0u7oNKkKWDIZAp0zu+0XcsLdj61K6AAXP8j?=
 =?iso-8859-1?Q?fQ2lkdOaQQZCy2MW5fpZGVH40G+E8L2chJJYFNZhbWmfZPAGHsHfHQNh+F?=
 =?iso-8859-1?Q?Ft73zE5ftSIiys20vXCtsoWxJiRxG5gTCHcnBqP0r4v8QmcwoRG7VTrKC/?=
 =?iso-8859-1?Q?Yw3cTCiLiiAhCdgiEfGhCAsbAIhsHb6VaWYLU6DXzZKuM8eIIy+sAN1Bpy?=
 =?iso-8859-1?Q?mDOaE57TpSJUGnWMD71lC2SkBdbMiTs/6X6L/X8xR0/LdJv5ntOH2Z1t5q?=
 =?iso-8859-1?Q?XnrAOqLHfgJh9c7wKqFyh+Fef2abUr5GuHiMFla8zsUQuEoQL2k4p5TK0K?=
 =?iso-8859-1?Q?J5nj9KfxH7yLUAzqs7bqK3TzLsHDkt4vDVckbNLN1AEniWvgEuKH3Zmg?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47c29854-b0f1-4e6e-cb6b-08daa0011c07
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2022 20:53:05.1562
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m7qa+g+d+TensddV0buF3w4brn9hmlcnbmegWGvJM63P/vuZq84XxgvS8rXfoQCzgdlhbF+I2JqVNm9/pUzqBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6469
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

Add the definition for the COMPLETED sense key in scsi_proto.h. While at
it, cleanup the white lines around the sense keys macro definitions.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 include/scsi/scsi_proto.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index c03e35fc382c..919ed4137f9a 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -205,10 +205,10 @@ enum sam_status {
 };
=20
 #define STATUS_MASK         0xfe
+
 /*
  *  SENSE KEYS
  */
-
 #define NO_SENSE            0x00
 #define RECOVERED_ERROR     0x01
 #define NOT_READY           0x02
@@ -223,7 +223,7 @@ enum sam_status {
 #define ABORTED_COMMAND     0x0b
 #define VOLUME_OVERFLOW     0x0d
 #define MISCOMPARE          0x0e
-
+#define COMPLETED	    0x0f
=20
 /*
  *  DEVICE TYPES
--=20
2.37.3
