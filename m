Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E7A4C25B06
	for <linux-scsi@archiver.kernel.org>; Sun, 14 Aug 2022 12:54:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbiHNMyP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 14 Aug 2022 08:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231326AbiHNMyO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Aug 2022 08:54:14 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62B7926E6
        for <linux-scsi@vger.kernel.org>; Sun, 14 Aug 2022 05:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1660481653; x=1692017653;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=noGk/A3xuk3SO5kg3EVC4ssOHFWElO2uMTTemHAkQoY=;
  b=DEQg0oBydavXMh+amWKQr4oe9sLZUbPEmyyG0jNq+u7kOsMCZ3YpWfM6
   vxtRqDtpSm+acwC8KM5Nixf/+8z88yVja9Rui125ppY23ENnPtvibeHAX
   w+7nJ5aFsHOtyXuCTatbF/3dMZsl9HpSb47URWNCg6B7jeGz4DL1aYHwd
   CTAHHmR4PLOLDUdY6ZxLMaMJ68tBhWKiGtYnZzuioNZwKjOugA8R58EX6
   xDu2Edbh9Czn/rIXLTkdfeditFD+l3LRjbw6sBt9Noka0NujNwdAvoTyM
   iA50HiKv3A1yrRHob2kAmtf5pdi+6fcIFm+kyVyK2zyhL8SllpJkVRTmb
   w==;
X-IronPort-AV: E=Sophos;i="5.93,236,1654531200"; 
   d="scan'208";a="207143725"
Received: from mail-bn7nam10lp2104.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.104])
  by ob1.hgst.iphmx.com with ESMTP; 14 Aug 2022 20:54:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OZFbqcb9Zl6WBWgP/nmFAtPIdjp7x5QMhDMMsCo99HddaW+byJAD5iUEru7gBNmKuuJjSjCqPC6AhKLJekqgUABffrDLjZWlWk5NQHQQBYInaBWopA0o3o5fGom4ie4G5iE2/wYHvA5wsF5vGKQKegaQ4hoxa/fVmq25bW5aW7X2O7Zw9by1OIhl22V49BJcNivaXlSbXtLdmrZWEpFW31MRIs/bZfhXiSHgr85G95Ukwtmk0BgSvWH/0TkCe7QDI7yT09Lje4vXP6zatVIBjmW8/8LhfjiEUdsB+b+j9UCoxKc9xW5Ok3IttE/Bhy/ub3mc7bSs0bDdCoXNobDf8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=noGk/A3xuk3SO5kg3EVC4ssOHFWElO2uMTTemHAkQoY=;
 b=WmeqdXBvAvlJcg4NTEaccfiB7F51HP1HVnDIHAlpI4FAY2TWz2chvITvGZKQ7Q6XZTM212fuNPzCzVPhyFlAIwTN3w3H86i2Z6A2WqxzuVybU1bo80MMGJF+RRo8D7WwxfQFPFVUJcZFmUiG/YXp4O44OXQLjAO2zGhv6MYfoWTeulmEefEBL9EpJ2A8FUF6WS6N1M68eMR1ss4cLssqwvkfAjWpgAOjT143dB0NzcJVk+wdyYb6GZLKG92M77x+3qQ2gPnwTwDDSp3MhOTc3wGkawcjmhG/J03iAhG94K/mS2nrtAgjviVkyFnPDExhF6rNcWB2STZvalaj1eVd+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=noGk/A3xuk3SO5kg3EVC4ssOHFWElO2uMTTemHAkQoY=;
 b=jUEN39BjTpV+FLCyU4jtmYFRlE6tIczsZ4a9s2xY6mt/FVJXQKEJmPgO9t1lomhkXun3hYokwWXHoTtbVOhzwFwZFuHvDoVMgtnklAmV9WWCtt1vp3XK0IzVVWPELGirTDZWKpsgtQ+lKadKbSPaJfnloFB8lYU/95cG2c/oE0A=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 PH0PR04MB7638.namprd04.prod.outlook.com (2603:10b6:510:52::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5525.11; Sun, 14 Aug 2022 12:54:07 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5d26:82d8:6c89:9e31]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::5d26:82d8:6c89:9e31%9]) with mapi id 15.20.5525.010; Sun, 14 Aug 2022
 12:54:07 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Mike Christie <michael.christie@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 0/4] Remove procfs support
Thread-Topic: [PATCH 0/4] Remove procfs support
Thread-Index: AQHYroyWPigJYF3bpEil4sOvTR7I962uXANg
Date:   Sun, 14 Aug 2022 12:54:07 +0000
Message-ID: <DM6PR04MB6575F397E1B519922D3C2C5AFC699@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20220812204553.2202539-1-bvanassche@acm.org>
In-Reply-To: <20220812204553.2202539-1-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 08c32f6e-dd1e-4e45-964c-08da7df41307
x-ms-traffictypediagnostic: PH0PR04MB7638:EE_
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TLwIdKCnc02hEWAViyDDmpvWjpSktpIFvMOIYQi/WV57ELhPQ6eAEhB/HQ1HcNT81GQuMO2q1VPuzFwA+p4GYJ8mnwtNjPlEbEHzrAmHOHzjARg+Ug5aZsZ9WAfMBYMsRxqODe7eXsZi0GQFqb8UgqtMLxrh27o5EV9N4V2fH1QLBQHh9pGc6frg8i2u9Rc5IitQVFPIzp4ITzIaeTygbyTrLFOCPkT9vZGqsExv7tu5JIyvfPFEhXrZqF21Us1RqKrr6cAGq462JKX0W+0a4PSQVdSl5VAtHwDPbqwNJdRm6jkkoO/IzBO8yajC2PLDhOqm5p3cGtle4tYLT9UgT0en71Cu2E4fTos6wUWIJwZKCvAVwJPIQdKlQBc8fXnyOhdPp4JL2d97RGiKYjqMeB07lmuOQpBBglVQ1cRH2hHRM8uTZ+wdDgqq/3kLliHhEDXWwoSqUIe/Ggxwhb1T/0D37lUzCgay6ro2L99sssYxMG6GA+tesPo8+RRBL4Tv6MgzadLQAp52I8l1E37agyVqWPmCczjx6bygKynnrOQvuBA9AgPteeBQder5viPF3Cna68tFUbqMj9WDpNGh/XHFoLZd+7axGdo47IMhDgKsftZkTLP3buWJhsJLXY3rW+NQZ6pNazeXgkNZ/t/ZVv6J2ux5GA3/Ecdv5e4B9eVn3pSPgQKqK7N9hLMreopC2XuzA68ek++vXnvCAstpMZQOJOkIIuA5oxcQ9NoHI49Te2Hc6UXGputKlY/CLzdvXfkUqgyDG8j7/C5frT18ZzAe8dRFR+ADzvvBtEcQd+UPmPcXZ3hFl6i/A9c+2QbrRSc4CfPKNG4OlIJq3sPUaQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(366004)(376002)(346002)(396003)(9686003)(41300700001)(26005)(52536014)(2906002)(6506007)(55016003)(33656002)(122000001)(110136005)(8936002)(7696005)(71200400001)(478600001)(86362001)(558084003)(54906003)(82960400001)(186003)(64756008)(76116006)(66946007)(66556008)(5660300002)(316002)(66446008)(8676002)(38100700002)(66476007)(4326008)(38070700005)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?rWUftFFshR+BBZ9OYu2r6PsLyHR9JRFQMfOmhKTPmNmuiCWyVPPGrg2ml3hR?=
 =?us-ascii?Q?iPBQCdkXmzDf0sH1KiALX5fD2DjIV2tS8lFSQYejCinu40SEA2MaKTySAw3F?=
 =?us-ascii?Q?bmIIV8GXC3C/GVhLtYoPUIywkdXNJwNnEGeB+5fLNDDdthd3KkLWgnMYKL/5?=
 =?us-ascii?Q?KOz8kdlA+GHUjeSqcYc/6rs8TyyV5dC5cWZ4hy/Agrr+57bTPuJgs/d4gU3Q?=
 =?us-ascii?Q?UtkcHObj29tf/gFybwrk/isYgTTTowHlTIQ7xBvjFf4az+ysYVBEYPEn3NVi?=
 =?us-ascii?Q?BjNRO4+slsiZGlNMZucr456+p6qLbwECbT61P+t0dfa87zbKHxvUJmqdJBcm?=
 =?us-ascii?Q?1KS/UTLOslQjM75TDJwA7Zazi02pPtHCC7qFhvH7ofvIHbb7NAFR/MlU2Msy?=
 =?us-ascii?Q?5PO7FNTFRwwAEH3k0448A1Q4N0dT69ItDeK3XvPb+899yz8FXuIRN/D8UjyU?=
 =?us-ascii?Q?CYfzoJuzbdcedImnrdzHrzA2eVLmRX1+W/rBXd2xW3xiwzj2Tmre68qIyruu?=
 =?us-ascii?Q?5C+9/QmUrhzDphfZUkknLMywwSTf85UShvxJU95vmYVbruGtsEtAGWZg5b42?=
 =?us-ascii?Q?RN8mLoPbyKDmYRMQ15FsKLBfh1vRB/eIws4KMJcSj0f+t13nkEfEiuPWfzhp?=
 =?us-ascii?Q?W5VzbYD4DI9wMQ5fiG0oodS+p4ftCgjN1nfP87L6oX9TP3Ma45WwE7r/oTzv?=
 =?us-ascii?Q?hoWgTZcM389AD1rKbLyBdh8GWxDsCfnTAbRh87CjIgfPPia/rZn63KQNhWKE?=
 =?us-ascii?Q?WtnGt/Gy8Q+oQ0UDKVmMn/kNT0xSfUhSyY5wtKpwgxG7sBIOOw0NwVfCN43M?=
 =?us-ascii?Q?DklTKWxXzDghvVP/7eWa1nNfV2UDfU4PuUkFUSnLg0VihB7xjJh4wNqYsgHr?=
 =?us-ascii?Q?jZ3QDhPLzrhij9FMvDuUgeCYve5E0EnTYh3QyDI1WEDIFAqTETXV8gViyC2f?=
 =?us-ascii?Q?fl/qsgc9NFL61QpKowJpSajT3oVP1SyQF3kL0pxgroF/f8lyTqw1MooPbhUF?=
 =?us-ascii?Q?PBkSr3mC40NDJ/5ON7be/P8lgyru9gkK+AxYCZpzt6BWIiHRW552oo6L90zg?=
 =?us-ascii?Q?KPTxRfgZE+zkx5VV5yYA8xVA/myMzLdD42zGKYCWoSTEoJDwYlFwHhZoKJHK?=
 =?us-ascii?Q?2MDWCGRqOGP6gFinXvSCPFgPP91UWZUgmHERZ2uu9AREhwahy3XmUeTc5PxF?=
 =?us-ascii?Q?ue/12u0dQ7qv9pb/3sWNcJ9hvT+JEK38J4UOUuD4zbfNdMLqdMlK5XLGNT5w?=
 =?us-ascii?Q?FerCxRi/RL00ZP3sHk0U+CKQmumaSSyq6+pOGtW6X2XXZsi0+QD+8NXFQZlX?=
 =?us-ascii?Q?RxGey1hyDFO+BqYNcStz7J0YeUv6MZzezEIab6BMKmTBB0hh6dizyu/zBqW2?=
 =?us-ascii?Q?HwhVho65wNRMMBdlndsQRp73kkr4w7e1IcKwrKuC1VoKKNBTMCylzWtddn2u?=
 =?us-ascii?Q?umIhnYKP3HQXGJfy7dnlYG+Dhzw0MyKFciile3/jYbFhTV7jYYvgXGNJMQhW?=
 =?us-ascii?Q?0NXR1zwoSoaNpFRoBENVu2X6GCJ5DBQF2CUCXOxSX40Hs3Gsa36girp0i6VL?=
 =?us-ascii?Q?4NZjptzU+pembXJN3ciRl/KlRKb3pJtkf6p0HV7h?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?n5MP6R8Fh1sS0JbNxNXF09cIBfcPhDob/Byd9jiwBPGpawJcoMCKU5D+VjGF?=
 =?us-ascii?Q?fVsHMpF9/7LdEixBfhbNW0O0abtAazSdtDI8Hfz2zdiV46riLGHCeruI/hlv?=
 =?us-ascii?Q?xl+tN49ibVI8CgBwSVbBQ+6AYudqxxP/50HvSY1lIxfabRIm4Kea9ZeHLWMl?=
 =?us-ascii?Q?4fHh1M5EQ0qiRW41Gbb/zXRT2WeGayHCxQiHXZa99bTEt00EllwfMr/mnQih?=
 =?us-ascii?Q?dn0NMOAfjsfCuLMYCcX8SjMXyik4c9yJUSC/CScwj7F+VjkDb+w3553IAtrx?=
 =?us-ascii?Q?YkjybLiMU6KCP6P6yfFfTwM7yqDtYb35sdeMv0/fM4UqzqgaF9G9BWagAqM+?=
 =?us-ascii?Q?tiiWwtH0wPMwyfAAhVgtNObOahkArWISUgQje/BMKxgzwqxOGUGgXBbqVUAB?=
 =?us-ascii?Q?36j0t4Dcx4f8OaGc8YuqK1LlOdP3MiOJZBuoPH29fA99XkNKmPEFwgUFOgPM?=
 =?us-ascii?Q?nB6P281ay91XnmaiS2Ay6mmXlFMniL6rH45Lq8iFpHsf8uY5q1iZmSMyIHay?=
 =?us-ascii?Q?wrbHrU94cdjmo96vReC/FK2eNjO0b1WqAn+/5UNQHANKXOHY8/npQwv0jfr2?=
 =?us-ascii?Q?1hkJWxd8bG4vaARVLRPjFIzupqMyh3Wy0W9h26LzkNb2vYJEJMOJfHZIIvsG?=
 =?us-ascii?Q?FXg2j0/ZCwEYeJweaYO57VWp2GO5kQDtnuFLBaOVLTjQN5L5JKlZOoTcVF9P?=
 =?us-ascii?Q?EwylimuZiU/kmh7ynMtvYR9pRc4HFxOh+ad8zIB+iPYUL8gy1Hu9pVJvt64W?=
 =?us-ascii?Q?8Lj2D+5t7aCkSVDdUg1faPYyRPyZng7W/uh4skmwgu2bBjVe7eSodsEvU+ET?=
 =?us-ascii?Q?uWEkEwn+YDWvZLafsYQTbHmxWO2yWzz4r5GeRqLh0sSSdY+Zt9FrF1rM5JNX?=
 =?us-ascii?Q?iJd1hczomXEwdKRwBG1p+WJEHPXZw/4wlP9CIEwD2Dj6UdVUW3jEnFCcC+cl?=
 =?us-ascii?Q?q3mMTqNWIXZp9mkOgZJLtY3QWt0wytJpFvQyoIXUW+UmZPt0+68q1Cwmbek1?=
 =?us-ascii?Q?vWqjbBn9CCaHcXEWO7FxrS7o421xWkA9KMOP8PoW5X5FHawSdqfQZEMcIue3?=
 =?us-ascii?Q?+9T86AbxYId9BuI2KqTiDMmq/YrVOoEdheplOCy3qKZxZQ/ANR8=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08c32f6e-dd1e-4e45-964c-08da7df41307
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2022 12:54:07.0946
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UDgDts57q8zV22Iv4COizCXWLz6iCoKXptKKOf2ZxdnUXNd37Wjl1IXiyiruu5S3qW5YbIPKSis+z5f0uuu9pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7638
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> Hi Martin,
>=20
> The SCSI sysfs interface made the procfs interface superfluous. sysfs sup=
port
Field application engineers are using #cat /proc/scsi/scsi to get the devic=
es's fw version - Rev: xxx
Where should they look for that now?

Thanks,
Avri
