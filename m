Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9F4FC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Apr 2022 06:19:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbiDEGV0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Apr 2022 02:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiDEGVY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Apr 2022 02:21:24 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1504A13E06
        for <linux-scsi@vger.kernel.org>; Mon,  4 Apr 2022 23:19:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1649139567; x=1680675567;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DRFv10rkSeXJUIQW6Bb3cTAWOgYmxD1cP/9Z2Zao6go=;
  b=qjM9YW1IXupOBxD0Dd+7Zxlf5Ratc+9xLDt6e1mkrV3FfQgHU3jMXF/M
   jIPLaexkhSkY2ysWbg3CXSaCvsVp77rtKD/zSrK01j/sM6lUqtp43VZbG
   VG9XPNWitfvrjhB+63rjqMLfOZFIYMSQzt0aSFJyUpIa4ajz8KLqoYKag
   ABbWot9XojppzcT2fbbZsJb53eY41osVMZFiWPTRdcGkZeMIdfAun90ro
   MB25bqd3xOrheNXAh47dRInL0gUDwpCw2wKb2omMQCyQuxjcXswK3wep7
   xl4M+uGspf9ninla/pVzyCG/7/s6MXzNUh0XQfawNeJateToH4HHFrvD3
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,235,1643644800"; 
   d="scan'208";a="301274985"
Received: from mail-bn8nam08lp2047.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.47])
  by ob1.hgst.iphmx.com with ESMTP; 05 Apr 2022 14:19:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gL43wGWPPYiguXxaoeEMRTX9fpYT1IfELWZtmosHofCKTAYG03YBi5JMLIxPk/0lkafIzZvlWDxp4DCcAG01s/bQJzoZZe4M9hhTdH2Q6/nUAlBIQWzoPN54h6N5/AmnhtL1sPLI9s/+bYS5h2T/hiGNRPpYN7rSNOkLUYR/E0sh0dXyOo/k+Q4CCFy9YPG7hXYBmPwKlkqI6uczTTDTDqQ3F/5IsE6JJviN38ZyClmhdrQWCFwg8rHxpaeoLQHswd6EX1NSSxG8lwRWTujDPbTPWcXDc7XA+qPhcuQHxcdfl0FJFcvMKDdktoZlFp9COgU+zcsQQMwB0awV7UMs8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DRFv10rkSeXJUIQW6Bb3cTAWOgYmxD1cP/9Z2Zao6go=;
 b=H6GilUt/J1a/8EOttmKqW8KavlSO5eICUWQ3MzKnxyT5hNf8xZFXsq7gHx4RtemKtdXXCGzKwVJjQ8lNLElRETX2yYaG9NA4S173IKfVELijeOBCdKDiBelM+DLFf161UuBDizsOnMKpfubsyeCfOTCJ6iZwQKsdxmygwKkCvEW0pFiC/VMfJQ/dETto/9TlCG5Qiwc8mqoRiwPPKvCFTOwl+qGOUoFOD/05e0LJxWcksewHjIu/fN07hMxd14paYwLH103/rki98AlNwV5gcZ4s/+4adak29Rhm5uoFl+FMm9Q6NCTfNHqokUK60qQVOEIR1C9GM6xcG1LEgW4/mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DRFv10rkSeXJUIQW6Bb3cTAWOgYmxD1cP/9Z2Zao6go=;
 b=NOXzm094U76oYS2z8SR2qtYuaKDpzxbKAUBwZHXbDdmBEVGOiJ1cLBD3EY77qSJmaPza9z/YE1JrGkGNZzEoGFCgKylS8Ze7uqb3+xTDb1Lt3ikXtlLIsgb7q6Gw2CGh6p5OYhnKLyySJMIo5K4zXx/7zBe/Xmr/YRDV8TAc/nk=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 SJ0PR04MB7197.namprd04.prod.outlook.com (2603:10b6:a03:291::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 06:19:22 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::941d:9fe8:b1bd:ea4b]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::941d:9fe8:b1bd:ea4b%5]) with mapi id 15.20.5123.031; Tue, 5 Apr 2022
 06:19:22 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: RE: [PATCH 20/29] scsi: ufs: Remove locking from around single
 register writes
Thread-Topic: [PATCH 20/29] scsi: ufs: Remove locking from around single
 register writes
Thread-Index: AQHYRU/4s8geVy9OlUSu9Ot3rVSI2azg3z1w
Date:   Tue, 5 Apr 2022 06:19:21 +0000
Message-ID: <DM6PR04MB65754D9F6C9A193BE8C9650EFCE49@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <20220331223424.1054715-21-bvanassche@acm.org>
In-Reply-To: <20220331223424.1054715-21-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 69490765-3116-492e-83ac-08da16cc398d
x-ms-traffictypediagnostic: SJ0PR04MB7197:EE_
x-microsoft-antispam-prvs: <SJ0PR04MB719749493E6DCF61F1300C6EFCE49@SJ0PR04MB7197.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jGGsmo9Hze2isvVCqxpGF9LKijpissnbz1UJYj+cmUSiij+ymzx6RLCWUVYfF7oK9mJRcDjVVkP7aM4+nczihV/1sjUBLgRjAu4y3oR19lZsiF7j1cBjL+FPgg1SRusddUr7cIAgYWjLJM6HOiIwg2W345g/Y8SyRgYW6XPOwRFzaeDTO9S0gHGlcnkg64RqT4jXCn87zZrpiLBZ8d/dK8kICzfdBV8B1BIZWFP2dNoSIp2Q/TNB8K+JI+KOFuf0GIJIOkw1RUs+1qVa/1TK7kYOnZJ5+/5jJ8JbMIPNqeTFcijigLSREWFQ50pvdzs8OoY5PfEf4Z0jjTfbJOlciukrQnj+cdrUJlZqtmRWmdQ1UBXNt/kc5O2nfdoESloPxGVDDAKK3Sj8zLBf+kBl/bxAgvYseXw2JRvXXV7+bD17CD1+uFqJedGpqprRaOdoyi/y5LVsw+/NSATtOCeA3bsLoPj45iWX0eHLelisW2u6fcivyOiQeTmLSwCG32WLhqB2VlhZmIlb6aX+EJUK32myfO7xMeveCnoJLGOYsYaCd1ZanIfDNw/n/phxwegL/YcoBZDgqemG8aUO2BR2a45RTA40d3IbAZWLnc0X+ennH9euo0cpA0FCzTZrNT1OH4Wlvp8vSV/FMWAHA9mMSolctKDi1mpyP18wErtcPovBdTh7ta8K/z5SEfWXs6HlZqC+omFCTBVLZwVv2PqWqw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(508600001)(54906003)(33656002)(110136005)(122000001)(316002)(64756008)(66476007)(82960400001)(8676002)(9686003)(7696005)(6506007)(4326008)(55016003)(66556008)(66946007)(66446008)(76116006)(71200400001)(83380400001)(7416002)(8936002)(2906002)(52536014)(86362001)(5660300002)(38070700005)(26005)(186003)(4744005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Oy02jjztl7J2zT0ouBVCVHHXjumLFAft2CbIMzB/aO6CvCrguSJnGJnL1H+z?=
 =?us-ascii?Q?o/pBMxR2US69m73LjYyOzdYjNGR+SW8EPl+u5w9NmhdgfiovYcnUp3k1tH0h?=
 =?us-ascii?Q?jcBzftra1X3FesWyR5iVVq1B7KypBmpRvvgkg2yTAtq9CHfIUNKnwOe1wY/W?=
 =?us-ascii?Q?2JS5bKqY2x/9FT5T0MRWHgvH8T8XHvKah3HBZ05olXFL2+COxniV0B1mG/59?=
 =?us-ascii?Q?s1WjrlitOt6V/xq7hNPh2J8L1Q4QiEjr0sxqO4G4L1SN79G2oxCg931OlF7Q?=
 =?us-ascii?Q?gcQTKGIQoPINh4ffV6ldfmR5F9fzez5WUUd2GOm9BEDpa/kOyvgivrgG00dY?=
 =?us-ascii?Q?aJry9266di6SuGB5qdBDXOk8bOHTtaDUfFNUokx2Ws8bqKZCkYajc7kMXySP?=
 =?us-ascii?Q?xVR+WL1A2A2dDJTyx14QHblM8ZCHVcvYBhLvcydV8ZFVnAkbj8sEnXHvXHeq?=
 =?us-ascii?Q?y1KcWfJJDTpy73DjJ6VEs51XtxhHj9n1bx9rd3kCrUydUsKN1LhnZ5SW+q4Q?=
 =?us-ascii?Q?kXKbOBNOlexsUWKA+Y9IV9adBX5I7hl0XtsSJj0AD3eL/tlEvSUKVyWwXqx9?=
 =?us-ascii?Q?sm4I1b9tFF7LrNxvpbpD4MhAUZ3vm9HY2JfKFC63uKJ/t4ftRAPAUwtQhflQ?=
 =?us-ascii?Q?ptVXybLsPtQVQevpl2D1CLqsFCBCPbUOXCk42moAsUyaBEvrBc+OTunHEA6l?=
 =?us-ascii?Q?uIZxWqKyOMRid06uR+iKdYm/ne57Npnj1Mkyyf0GJbsWlsWwsdfqJPYt+AzD?=
 =?us-ascii?Q?iKh16HZTPG6AOJDB0TNV8iCQm2o7uc8QGk3ihIiC9WoNKB00n4+qNTpi+xpz?=
 =?us-ascii?Q?OZvVsGdcXJ/rUKLciAnftvdF3DJIEf/Y8kuWsHcE4eMnJlPxO7YaKJHSrMgZ?=
 =?us-ascii?Q?3Lj3ZsTOhzhC2Ogz4ByXDUXV4MjdbLsui5pvDtcFjH9sQVDtJHpgJ02A1qx+?=
 =?us-ascii?Q?JJisQyUZwC6yWtbApMYfzDXIRu5A/WIjlqEzzIs/Zf+3/c747sOVNNhiK9GB?=
 =?us-ascii?Q?gQBgYXi5xkn8S+Q6zKc4ungpoXiLkdV8Tns/hXMkvAHTuEcjw0ZxkGyhc+8x?=
 =?us-ascii?Q?ZXmeoCWwBFm+YoN4j2Er+HDgk7cp+v8/MYQmPy2gyRPu0KMLJCYh57+kHP4W?=
 =?us-ascii?Q?EBHFsUKOyS7QbdcAVV8W0cLEaPrgmMcrsfXiSoUDAv1L0iDHpXLI197sE6CU?=
 =?us-ascii?Q?IOWQD6Ldg3mblRdHj8DVqx70WNSfhJUziiH5khQN3H7dsNeKWYKjubhVWIiI?=
 =?us-ascii?Q?tS50D2r0iD9ehJ+OZPdapc9PGrM73oDYO0BZPEiZLQBoVCYkyzA1oOMuj+4y?=
 =?us-ascii?Q?1jXADw4AryqsBkTTHCQ6LNItVjDrx8W3NWm2SwpiOHYT9uQZ3Ih1o7cGEqv6?=
 =?us-ascii?Q?sdlzECEmQQLMkSSafq8LXxUgGmlz3AN6zaNq5GSuqdWQTjJF/Qza8nAUFrj+?=
 =?us-ascii?Q?9BjBXRTZzIf/ivLr/RGj5CFiS7nGxsd22FhLdC+dsXPDkn6jktrj7P8XHUjW?=
 =?us-ascii?Q?GgYyvtuSOdLD3u4q7Nz55xn2ijGBhlqZ+UpjWiegK6sUNognze4u2JPdNaZX?=
 =?us-ascii?Q?QhJ5aGwsA5Liugo7K9q34uchAhjvSJVoNZU77tOKF5y8Q3nrFnLMK/fIvn/y?=
 =?us-ascii?Q?muZmhdkyTruEY2ewAE4/XlEB1/1uab0HWq2kAyWqRnj6+kP7hAVQT5izOilf?=
 =?us-ascii?Q?rHOMxieV1ariqmKrO+XEjAazjPo5O0AI0+8QveexO2sKHx6SPbBf9bvvQi1f?=
 =?us-ascii?Q?qSSwSwvG0w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69490765-3116-492e-83ac-08da16cc398d
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2022 06:19:21.9967
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: snOqKAy2cJW4nGHJFbQACOXY5AIx5f1hzcNgFMeQblIm4tyRwQTk60u4S/HIrw73S/5Da/5VR4PFndScTjbxhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7197
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> Single register writes are atomic and hence do not need to be surrounded =
by
> locking. Additionally, PCI bus writes are posted asynchronously and hence
> there is no guarantee that these have finished by the time the
> spin_unlock*() call has finished.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
(maybe minus the pci reference)
