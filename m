Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66442C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jan 2022 11:37:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377832AbiAaLg7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 06:36:59 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:16636 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378513AbiAaLeV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jan 2022 06:34:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643628861; x=1675164861;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=Om4kDVNmBj+dwieA+ASu8/smHfLzdblJYIves3pQ4W7ZxmGZzBgK6Gyy
   lSPUuCJxuKdnS2haYRKHCgDNpejIDBIzsXBb5Aj1flGSwd3dPFTVig3iU
   e7lm9/pE89Io2ysztp3pH97Ki6/XTiS62o3pfPRcf2aGPtC6Dlv9tLFwE
   QT2qKE7cQxBpxmv6VPPTXvz+CKuBgXVmEKdalNA9PZREilQgsaGtvlwfT
   BhHtSOqbN+NAxVNqEVHTXICvQp6Pw7TWpWFNA6I9ciZk+JqW9/HvaGhLy
   PDMrRkmArshOqvw4Ex+knG6mExzn5nGw58apN19Ger2v5GCycReEuUcbP
   w==;
X-IronPort-AV: E=Sophos;i="5.88,330,1635177600"; 
   d="scan'208";a="303682466"
Received: from mail-co1nam11lp2175.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.175])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jan 2022 19:34:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZUK8dKZYrYtcyLHsisL9DmiyBVGcfBGarABFHhNRTsVrUcV1GbIqaOEBVlZ7fG6LtGye7qO3TXcUUtAYIy1C9xLLW3CiLbany4uvFk+6Wlu6GDC0ZS2KoiL1FUTJLeiTr1JEIn2+xrOerAXwm30lBBWIa2LbYDDD2dYRFYYWY6zW8oL6kps2VapN/N5fU21QUsJdJxn7GwMe4Fj4OAkmxH76yePgkxg0VO1nZs+8IS/U9ld6hxdU258h9233ogjrB32RVGH19OZ+9ONtLdIOLLM8zfKmsV1LcwYuPaiInGaI9UkHhYi/G6SlOVBY7GO+e7jxKi0ZW7+gXaQdbpVDaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=FJmA67ZC3Ftd73hec9ZhSyFui06SXKDxfkD1Z8Unn1TR7Qgzik01T4tJa3qIMZsVRyJOBHbclHJoh8B2uPFumkK8D5djEv/NWTIiKmWqsrsYmsVttMuhILYADPPxC+489MG+XJ+Wwpsd3y00sC6YgYIHK4mFVPUYGVx5cLBHH10hg9XkRM0+H3KoivOACOKqPeKvZDfZRL1joKSVQ24BY4R24GGbD7VfpSObbuhk3r3uKpUzg1cub2Gt5XgU3dcsv3cqevc1TkUWnKl/i7qCUbC8zHHPOOO0iV1sylr6leZGXeZ6nSHGZ8SjcWlZpzqhxYqpzTE3WWk8kWR2aMocIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=n8C67UvIi4crVrMTEzIYVcObTAcYfryNAltFfZtdc5U1oDlR4JpW0z51StYNeAn/O19diilQJFqHekbUqT+Ssw6u0OQhWm2kSAlD2TBvzW+WhISwYr2TjJ0ihbgkG40o8k691pbGfIXe6kAxCO+WimvFB58a2aoQqLDOQVE9M88=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by DM6PR04MB7116.namprd04.prod.outlook.com (2603:10b6:5:242::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.18; Mon, 31 Jan
 2022 11:34:19 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8d9e:d733:bca6:bc0f%5]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 11:34:19 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "bvanassche@acm.org" <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
Subject: Re: [PATCH 31/44] mvumi: Stop using the SCSI pointer
Thread-Topic: [PATCH 31/44] mvumi: Stop using the SCSI pointer
Thread-Index: AQHYFJV+Emo2ZHR20EqGZSj2HrH1HKx9A8sA
Date:   Mon, 31 Jan 2022 11:34:19 +0000
Message-ID: <fadca843164e3b3888b56aed4d6994df62b72688.camel@wdc.com>
References: <20220128221909.8141-1-bvanassche@acm.org>
         <20220128221909.8141-32-bvanassche@acm.org>
In-Reply-To: <20220128221909.8141-32-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f61726e0-be84-4fda-01d0-08d9e4ad9ea4
x-ms-traffictypediagnostic: DM6PR04MB7116:EE_
x-microsoft-antispam-prvs: <DM6PR04MB711618DB662FA4B8FDA497429B259@DM6PR04MB7116.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: s9SIat7kvYyKEi7aWJCc7r21ZPp8XE8JjZT+6hkQbBCbTQvNzmqcd87dnypqcXyXQEDJg+J6swm6DUbuB8HEW07Ebr6WbFf8/UI/eFCxP6KulHGvRiEgp1ITEFRAOzNOhvWByBchke/VZPkGdAzNretyxSJGVy1SQzIqeTCMZGzXwfOsI8tPkFaMTeGiZO30XWueEVe5T+2agfvNaBbmIKq5/epEXtvxEUZx3ViEl2ksJdDlalnf+V0b6DjizfwxG2TywwoKmB/MV0XiRMNs+y4DI+6suRjFkzQJLG+8j5G7sZoD0Tygcx515qSVHYkY1NACeb3xfZBn6Gkyop1KyJ/ks630zvEFhCFERy3wB9zw3EOh0k97gxZLB9ZFjlIhCWLrZMV22kPe87L0lBq9r4Wi0JPDJEbFYU5UHIdsQLR+mUWcHx7C+kgxRhTwnRhfeHW0L6oXyhsz4p6aF2GqDYMuRK4MRFHmmnCDv1rQSql/5m7dM5HyHZ2XgS+uV0Wj2i8/IH9qb34kxCrCw41gTTulZvENmP+a8cxkuF0jQAUPbgAvxc2M3+do4uimdzlD5tLQ0q/XsPrJvHqT6zIDeTHHBUeMVBrVNLOoPF/PaAhJ0nKRfygSyjiTDe+AIQqsyxtkE851EgyteuIeRoLdNwy+Wvb897iwHBIZdD4hACJsBiBD3rQnYhRO+jptUA7K+YFZvW/ORl3k+MxZsyei8A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(54906003)(6512007)(5660300002)(110136005)(558084003)(38100700002)(6486002)(122000001)(71200400001)(19618925003)(82960400001)(4270600006)(26005)(186003)(508600001)(66476007)(8676002)(8936002)(66446008)(64756008)(76116006)(6506007)(91956017)(2906002)(36756003)(66946007)(38070700005)(316002)(86362001)(4326008)(2616005)(66556008)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WE1sWjVwb1dRZDN5Ymgza3JGb05VbEF6QmIxUVNjQUlBLzcrVVpRVjIyL2lm?=
 =?utf-8?B?dEtXN0UwY3krZXpDL2RGbXFIeGxWY2JLYXRGZFJrdXU1cUZOZm1RaGFqM0tn?=
 =?utf-8?B?THdocjdKOW5lUVFRVUpYMHc5Ry8rczZFSXh4cHVzWWdWeitqYjUvVUFTNk1y?=
 =?utf-8?B?U2M3TUhYN1pXNmhFMkt0bDRUQzJIdmZoY2YySmRnMEI1bm4wZkN6VkFJR0tO?=
 =?utf-8?B?bkZOd01RMWdWekRzV1VGK0M5cENSVnMyaTdSdHRIVStZL3BXOENIVzR0dUV4?=
 =?utf-8?B?bHVVUDJYQUU4Q3o1QkpIZnFTakhTWlNFYVpCNkNwWjVqYW14d2FPaE9IQXI1?=
 =?utf-8?B?TWgrWCtaMWNVVmNJZmk1REovN2tOTXBsbXhLdE9uaCtZRTZkOExTUUpnYUlC?=
 =?utf-8?B?Nk9DL3ErUEloK0lPZlZSdkpKeHk1NlF0YnRqV2hJRXJWNHk1dVp5cXBETkxB?=
 =?utf-8?B?UDc5ZEF4bE51RCtELzRHU0VtSEJkZ3d2Y2J0VnN2Y0NRemJsanYrN3RmU0Nl?=
 =?utf-8?B?eVhZbmxKdFlVV0VXTGJaWUhzWUpZRElaYzVkUW8yY2FuSHJ2cFZPVzErOWdi?=
 =?utf-8?B?eGcvWHF3WkpGYzlsckhERmVtMVo3MkhCOWRiUERwUWdubUxMVG04WmhUbURQ?=
 =?utf-8?B?QlVHY2x2cFZxRXQxOXN6eXF6S1g3ZW1rOVRHWkc3R1NvMDlycU9kemFjWXRJ?=
 =?utf-8?B?WTBNTGd0L1dxeWNpRERQNXJkVk8vMU5sc1c5YTlmMm83SUlEdlg1NlNtV01H?=
 =?utf-8?B?TnVZajJQcUc0aU1GRUhKSVdLMW9VcHFJMHhObW9xQ25SYWxQNG5CekRicFJL?=
 =?utf-8?B?RS9lTDVTN1E0YkhsQWQvVUhScGVvWmR5MjFjY0wwQUIvRVFUTEJET0tESTB1?=
 =?utf-8?B?WUNhVEVFVTN0RFhPbm5DUXlKZGxQTHUwQlRoVmtDazAyeFlUYU1oblRZOFIr?=
 =?utf-8?B?Uk9Pblg2RnhNdzU1MUsxRTZ4T3JNZ0QraCt5OHRuUkhNeUZHN3RkVUVMTVE2?=
 =?utf-8?B?bTBmaUFjVmNmazMrNmVlWGgyeXUvL1NwZS9zS2hFazFFRG42YWVibnhJK3Ir?=
 =?utf-8?B?dFdKQXlWNitWY0xTVHJJWm5VU2pTc0ZPRnpWOCs3ZElub3RGV3o1dkFBaGxH?=
 =?utf-8?B?VVJ1YTJkZnRJRklkdDdUOEtMa2JQMG9HWDdYTm00aVR5S0pYbnROWXdYZTdj?=
 =?utf-8?B?dFpjQk9PT29wUkU5Q1RhQjZUK01WaEo1Tm9WS3lCdEdLUGtxTGRUeHdOMXg2?=
 =?utf-8?B?WFFabWNRczZSY3RuZFFmeTE4OWhZM3NvQWN4eWxuVGdGRlBqNzYwdUdKN3M3?=
 =?utf-8?B?T2x3UkI3Y2FYMkpHTS9VWmw2TlFjcWJ1ejkzTVRjaVF2a3dqQlFHVmM4cXpI?=
 =?utf-8?B?MGhSZkNzeEhZSDNHQkNURGNjc2ZiZE43bXFQYWg5SDArd2VFWklOOHZwWCtO?=
 =?utf-8?B?REZQNzlxK2xSWDFuQUVBZ1J6TXdGaFRnM0FhUTFLUkNjNXM1RXdvbVZFZ0VD?=
 =?utf-8?B?dUtvUFlJSGNnVTV4RVJhdS9ESXlGY3Q2ZWJuRUlYWGg0YVdicThOWmlFbFln?=
 =?utf-8?B?Z3YyTUpCbmsybnYvRVRlWm1qTFZEQ0d4UEc1MFcwdjVCV0NBbGE4a2hUMmUy?=
 =?utf-8?B?cTdzcTRyRm1uVXZ1dTRGK0Y4U3h1citOSVlIN0x6R1c3Vnh1MzhtUXZibFdr?=
 =?utf-8?B?L3lKUlRQSjNLZ1p4N1NFcTJvcE10MjUvVHhaTktLSENkbnpZWEU0VkpTN1or?=
 =?utf-8?B?QXVUWUdwWnNmT1hGN1cvY0NrL1FSbUY2WXZBeWh6UldnQ3REMXh0bEhxZDVs?=
 =?utf-8?B?K2RHc0gyVVp3YkRodzYxK2RuLzZ2SWZYSHFMLzNCZW9vZWJBdnh3bFdHeWJV?=
 =?utf-8?B?NWVHZDFObHRvdGdzSUxyekxpeGdrNVA2S1QwRU9zMUhWNEpLSjVoanNYYjUv?=
 =?utf-8?B?elhrem1sSFVyYWM4dHRUNWR3Q3VTK3NWcXl6Q0ZqMG9FUTBWdVpGbnE2UFFq?=
 =?utf-8?B?emhxKzZ5ajJsSjczRnhSL3lsV3NORHB5cmlNbkg0bUdyZlphU01mUlo0aWVy?=
 =?utf-8?B?bERCRHFDL1B3N0J3RjFiZCsyRzd2Z0Q0Q25mWmZFbCtXTjhsNWVJZU50YUh3?=
 =?utf-8?B?UkUzZ2lSVUVtNjZXZ3BKWDExUEVaUzlTU2ZsNjRkYVRYUUE4VTlvbVNBUDh6?=
 =?utf-8?B?R29GU0RHd29Yemo4SGMrbXJIUENRTjRlWVN4NHUwWHFBKzVkME0zWW1EK1Fy?=
 =?utf-8?Q?fggXR+wkuzvbacNaPtUxKI1myND+F4Zu0uxDJHQThA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BD59499BD6115F448F73A569DD0C98B2@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f61726e0-be84-4fda-01d0-08d9e4ad9ea4
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 11:34:19.0409
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AyWShaPJ3Pc9AId5TcM+294aMauxazdGOpV3gWNqSlMdHFMAlCL7uVvKI2PBQzGQPxKEyxbc33T4Kug1yDaXlhHBNMb8xJcBa+v1D1HKsrI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB7116
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
