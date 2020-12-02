Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 222C1C64E7C
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 17:24:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9F2521D42
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 17:24:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389255AbgLBRYP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Dec 2020 12:24:15 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:29141 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389133AbgLBRYN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2020 12:24:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1606929853; x=1638465853;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7HKcziXeCELlpKf+Jh2Rg9DrWKrP0PS+3FbCD6lR9Mw=;
  b=HcRNGAY7uqj0nIcIISKCOxzJne8s84GySbLzL36HI85x8F4uX6lgwx9t
   Z3+dNGgwJMuKdXYH/ZBGTa5ZZ3leth/vI6CNRoA7OJSrNN1KdgfI/z8yQ
   oLbbhICuuXtObnAvQpzOt9+OPilxGYU4BWT328IBaFXj2uQShSHGDYoLt
   ATYhJZFSE8n1i5QyxItMEc3hdHKibiqVGJoz9Ohypjj+XEJqRYnOD6ZAJ
   cI9hPK5tfd6iKvQv8N+3eRo/7yJrm1ThMuMVZuYtEgwGO7n3rx2GXoMyP
   c8fW78zBEVjowKavSs9j2nug57XOgD3Jqe2qXASEJMzZjkraR9+3KCPPW
   A==;
IronPort-SDR: X90gKMyd5lsZgU9Q+J+cqXMyMRzEStJDWydZLabjBFCoAItHE9K12UDoGlnbDtLps5yOZhzcal
 QZ2r5Ei44R8hw9N6M/2IapAShJNUis6Nr3rxqggAQQjg1cdkHOQiIOKLdmg1lHWg80nQuE2s8V
 k3I8XkBy5SVdU6h1A7gemPURXfk7lne5Q93CejCxr0LsPoazMhO6iz4AlNhwzGSIMCMLU6QCTY
 sxi97IKoVTJRi0V7RKAiAj/T2JHbjUCOZZA34tTXuBYN6uwH2i5hxRe0AAhtbRMtUhhd+I6069
 Miw=
X-IronPort-AV: E=Sophos;i="5.78,387,1599548400"; 
   d="scan'208";a="35821833"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Dec 2020 10:23:07 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 2 Dec 2020 10:23:07 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Wed, 2 Dec 2020 10:23:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V+GSw3pXvu6apKpYgr0NcbP6+vLnDsjMzH95y75bi3dDCor44cYYZo2BgHvWrQLMHGk0GeJCwKSFG2dueVH56MisjpgoCpCB3hTiVW6zFb5UbYPqJ+wVCYvFlCefu+W3/SzwIUQ+t/CR5D2sh3rS1xZ+Q5k6eLy40dk5Yg52Yg7jUn1EBjx3QA0sMkAjtBs+4yVZtuKNqJOK66XwV5d6gtmFokFEU1pGwX41vg27O54vJvU3KBjv1uXoG2Fl2hubMOVrX0FX1g3coXn4dMeDDvonwVrliFpmMPrXkb2sFBMCif1WJ6z19RcVsR4Ba8HlpkRHxdtbeAVF9FE4upz/fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7HKcziXeCELlpKf+Jh2Rg9DrWKrP0PS+3FbCD6lR9Mw=;
 b=QPANrdztw7Gea1vOo2kkDBnzX8sl48PjiHdezvpEnzmwLJFKm4Yx9NsUmTkIro7W4rztMDK4O2fCkOoVXdUcj8gcbgdneIhFycD1UArlUFfVVA00O2o6o5AxvIFfIx1VqtCx4+bUOMlGgXhWzEr6aMPSz2CWDhE4fVJwalWciJO+AGCDcBn/tJwnihA5UCBNzkTVegRurqIHbqb9jrQtzpcNJLUfkAmh3i9dZMHCDy0Jn5As3JZEq+rS4Kyl4lYwFHgn0eZDkhHAr5UV/Ulq5q8HSqfTaQu8jk+V9zxRKu4orsAjdkmhv4TjSl8L+7yoRnzFeU4qy/wbnwZEU3rtHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7HKcziXeCELlpKf+Jh2Rg9DrWKrP0PS+3FbCD6lR9Mw=;
 b=gEO+IGNNLMPflMDx50233Rk6fcfhPIoc5xq0CcPAhcAKjdTxML9fnhGhnEmgoCwIxVwEi3tbgs8m0qU2SG5+JL5apDIXLRzzx5d/k8WAGFe3+eg6bFJDg/38WpxHMNPGnN0/KcpCYr+CFySVj/dsbzk7EopHhuiZfGgI5Qky2Vs=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SN6PR11MB3373.namprd11.prod.outlook.com (2603:10b6:805:c6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Wed, 2 Dec
 2020 17:23:06 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::b54c:9e32:8548:9855]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::b54c:9e32:8548:9855%2]) with mapi id 15.20.3611.025; Wed, 2 Dec 2020
 17:23:06 +0000
From:   <Don.Brace@microchip.com>
To:     <hare@suse.de>, <martin.petersen@oracle.com>
CC:     <james.bottomley@hansenpartnership.com>, <hch@lst.de>,
        <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 16/34] hpsa: do not set COMMAND_COMPLETE
Thread-Topic: [PATCH 16/34] hpsa: do not set COMMAND_COMPLETE
Thread-Index: AQHWyKKg4OpPkPC3UkKakQLdWln4bankDfNA
Date:   Wed, 2 Dec 2020 17:23:06 +0000
Message-ID: <SN6PR11MB28481779F11DCB3EA618C03BE1F30@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <20201202115249.37690-1-hare@suse.de>
 <20201202115249.37690-17-hare@suse.de>
In-Reply-To: <20201202115249.37690-17-hare@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [76.30.208.15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 28e5985d-043b-4db4-54e6-08d896e6eea9
x-ms-traffictypediagnostic: SN6PR11MB3373:
x-microsoft-antispam-prvs: <SN6PR11MB33735C90892364EB92A81D50E1F30@SN6PR11MB3373.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:913;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IDWDLGvhFUnHRLKjr9B4YvChQVlvO5rttlWA98/4ueHv89UwNJGpilCzOa9f3QRRmUVJt+v6bxs9bvGKtMMHniDKQSModyUZY35AtK6TlN6CJxZpcV/vi/q37NEvhhkYMiHf7BuA6zeOdOCs3n5Et+AIoP1FEQrfMSWzQ+GNjgPWzprGXzXYajO8plCoWpKfF9fR6TDWcBUToUtF7o/U5u0cnU7o9kpFT32HfE4G2mheUBLT1p49OsdSaPq/L1egKoDtlIeaFdR6wDs7qdJ5MR3UEw4acZG7888McPLCVRK1ys1rgWHUjHMpK914mPrX
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(39860400002)(136003)(376002)(346002)(71200400001)(8676002)(83380400001)(52536014)(54906003)(55016002)(9686003)(316002)(110136005)(8936002)(4326008)(33656002)(86362001)(26005)(186003)(478600001)(6506007)(66556008)(64756008)(66446008)(76116006)(5660300002)(66476007)(558084003)(2906002)(7696005)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?GAFjgbaG8iVy+dWppOiTn4YiP9pzA7vZCXtX5nWHw3yW1fZfXZgO/ACfGglG?=
 =?us-ascii?Q?JrF6f0Y11APvDc4IoFwrIPkdyiaHnrqKB/petfy9X9BlncVw+KVupWNENxN+?=
 =?us-ascii?Q?6iyIwLZmDW2a+BP7Hf8gsqN2IggHdwGWM2AuYInB41+b4Lxx7QOZHFbOUt/M?=
 =?us-ascii?Q?aYCmJiS+wmi+dQqynLHWrgPAvG+4+MkXKgOD90o3YCrAELKSeEcNZgXtZ35/?=
 =?us-ascii?Q?0W5S2H9EfrYDHmAjSVdGQgFd95emko0cuZqNV+x6O+ZPz4HiZMhBW4xKVCE1?=
 =?us-ascii?Q?2sGc/zkXWrH+n1afR4serG32ertAZ/a3eDZQHHutOQdROD6Trt9m+8q8Y5JM?=
 =?us-ascii?Q?Rte7sgKaMNc6xikdhA4NT3Oi5WGOhRACgXANqIPVsnFrXat0A6zEg2VUq7RH?=
 =?us-ascii?Q?iMhcgrmrQE+i+VSticnThb9yHSJ9lChtBDFbWJDQ9dgkBqDQGdRPITqtcBdL?=
 =?us-ascii?Q?EX89dPgN3LrxefePgAkMWqYeviZSe79MV/yTAP/4eJaADk6VE6zd860N2FOB?=
 =?us-ascii?Q?GMAj8uKEt5VvuJ7U0xm6yzKYJA4RVM3ClAuG97GOtMQ/Bvl2GCOwGGCAdOPT?=
 =?us-ascii?Q?2sNK2UhVdXsqPaoFRhmxBXd8JpfOm/3C4MhZXISRnSC6eEPddb16iG/kpd0h?=
 =?us-ascii?Q?wGMLUiVzMWWR2Fm+q/vYutHVxTANKoot/0OWFd9kleYR3DjjH07j8X1VieXo?=
 =?us-ascii?Q?3l9TJlMXIHkBeraOlqP4f9GEzmKKezgYxro4JxQq+etEomjVRFseFirF2doX?=
 =?us-ascii?Q?3OYk9+2pMlUnUb7iCLb5rMQv9hCCixzWzJ/WpiACzIFL4+i7EENLafozpuUX?=
 =?us-ascii?Q?X2sdYe3BkngOR6yRnBg0XTRsXEqWowTeyCb2TxTmv3yqGAqe7mGA+VGYCQxg?=
 =?us-ascii?Q?akt3zHeoD+FDF4cdNUNkmp5EvSheS6+18Jx5Air0Vft7YfJeqYuHUcw7wL3z?=
 =?us-ascii?Q?Wm2FJOEdaga9HIkaCSFn9/x8H3uqdMcp3bMLkCrH2tY=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28e5985d-043b-4db4-54e6-08d896e6eea9
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2020 17:23:06.2415
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aMmpzPXnvZDqwhYUwD33c5UdVhliJzmEj6p0ssNF83OxGdHa99UFsJtS1QGcmBDCrKfwA21QcZV7HPhlxvlZ6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3373
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

-----Original Message-----
From: Hannes Reinecke [mailto:hare@suse.de]=20
Subject: [PATCH 16/34] hpsa: do not set COMMAND_COMPLETE

COMMAND_COMPLETE is defined as '0', and it is a SCSI parallel message to bo=
ot. So drop the call to set_msg_byte().

Signed-off-by: Hannes Reinecke <hare@suse.de>

Acked-by: Don Brace <don.brace@microchip.com>


