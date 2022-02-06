Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB068C433F5
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Feb 2022 08:23:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbiBFIXn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Feb 2022 03:23:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231391AbiBFIXm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Feb 2022 03:23:42 -0500
X-Greylist: delayed 63 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 06 Feb 2022 00:23:41 PST
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83193C06173B
        for <linux-scsi@vger.kernel.org>; Sun,  6 Feb 2022 00:23:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644135821; x=1675671821;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=Hlg/IZpuzkz566+mlm6sBsYZlqCe6EPAUCTEQckSh44=;
  b=Jdzmsi+6yN/oiGLUjxuSFAw3DuRXtHBWx8gyZ8165f4jFR2Za7ZHA2xE
   +jgvGGE3en6W7wW0Iyeobt+CfHb/PnFExOrABgP/PtEXGP34LbBdH9hkr
   /eTWQIXqTvTpcKKv1HCQJYxOL24PqaDo/Utc3tBMfOlKwP2VkpW/WU8Oh
   cfzApCTIY+/cxm4D61TGFUVPSiTn/WD3fqSitjeK7u5t1It+QYj3yPCae
   /yKcRrcyZ1Dnqcc/POtPrsdPiUH2mTsZjzhToT+SrbxizqYZ3XSaQ75EH
   JGfpUXZxA0wiyg61dCJnR/FRPZIY60be8buh2V1VDph3K7G1f7kmYOOVU
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,347,1635177600"; 
   d="scan'208";a="191195445"
Received: from mail-dm6nam11lp2174.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.174])
  by ob1.hgst.iphmx.com with ESMTP; 06 Feb 2022 16:22:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EkhAZglCHcKNre0FFWbPT+3q/Fdedc7oiI8n1Quzu7fOD8JyQFYLeCQT/XiVxjokpM4fMGxsxdcKla7jAOmPQPfAvIa39dyOD7x+Pb1OHdtjrCu21FUIi5WGZwxXcuxawh9XGoFm/qlpVG/B2nJP6NZpq554Zah4ZrIuU3AyBDYMHxPM60vwL2nhKO9qyEufEsnB21cPqoew9Rn+a3rkSAEwrdDSDl04rZZ3qQMBha/UmWiST3aPIt/ds3A0v/zfSMHYy6zzyDK8Q3kFomeFJXK69TdwApugyEJuD5tTSS98rLen5ZLt7jfPsjEUul8ounIMfGORvBRJgnRDD4jkNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hlg/IZpuzkz566+mlm6sBsYZlqCe6EPAUCTEQckSh44=;
 b=BGi8Emb5Q7+2GYEoU+aitk2yqU1M2/BsKuoSzdYUtt2CBr1bxjSkQh6V3+9+VIarBzTALIde6NNZ3WTVuaSEQZS2S1/YuwyJYFcAeRvOi9bNuQJD+J+WFK3uzSD+WAx1EHcbcdEFUmKSxF5M6jUw2zwsvUScheZRUGZWce0gDeMEGhJRrOgDrVHYxN4a8FdrOoZaS3HvF3N88KbR7gmZwsucWr5EIMlTv6BfSIJP95FOo8TVSIxpqSJpVHrv0cMhOLb+ps0yJpBFfTT52PIp4F9ZkmIgurVT+uo1zDtDnMQ0r5cpyes368nrhMLsyO+HZHstxF4xaUs+4ZNXNprweQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hlg/IZpuzkz566+mlm6sBsYZlqCe6EPAUCTEQckSh44=;
 b=HjZ4BAHAtVDeHei4gwhmIirZffH9ZmmLa8BLAvszh4GF805iESIMS4kk/t2g6c1RabTa/r+TGnBtEdatDogjZjOPJNrSt+Rzk6bfvZp+yGNDO1zv8r89uWt5Eb9u4atmiaQbW4pMTZXtDRetT5I2LSZqdER5JFjgIp/O2h+6RYE=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 BN0PR04MB8093.namprd04.prod.outlook.com (2603:10b6:408:15c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Sun, 6 Feb
 2022 08:22:34 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::14b1:1b88:427:df7]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::14b1:1b88:427:df7%6]) with mapi id 15.20.4951.018; Sun, 6 Feb 2022
 08:22:34 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Kiwoong Kim <kwmad.kim@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "sc.suh@samsung.com" <sc.suh@samsung.com>,
        "hy50.seo@samsung.com" <hy50.seo@samsung.com>,
        "sh425.lee@samsung.com" <sh425.lee@samsung.com>,
        "bhoon95.kim@samsung.com" <bhoon95.kim@samsung.com>
Subject: RE: About reading UECxx in ufshcd_dump_regs
Thread-Topic: About reading UECxx in ufshcd_dump_regs
Thread-Index: AdgaXLxl4uvkEEgnTTyQR5qcIo9yWQA1dBmw
Date:   Sun, 6 Feb 2022 08:22:33 +0000
Message-ID: <DM6PR04MB6575D0551995FE2CE79481E0FC2B9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <CGME20220205070515epcas2p324076e473ad0d955f43fdb3cb409c584@epcas2p3.samsung.com>
 <000001d81a5e$b9907610$2cb16230$@samsung.com>
In-Reply-To: <000001d81a5e$b9907610$2cb16230$@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8d5f9966-3ea2-4254-b512-08d9e949d392
x-ms-traffictypediagnostic: BN0PR04MB8093:EE_
x-microsoft-antispam-prvs: <BN0PR04MB80933DE2874226C149BF002FFC2B9@BN0PR04MB8093.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DWXELlDdIyz1DCTC9u5GBaXb0VmqXJYMPti/CQJvf58IyV3MlL6yhWXTrJxYmsXZy+Us1T6OodIuZoHMXaLSaiyPglN68tVeBY+3QWuUkeRFF2ShlSJJdFMk+fIAUk66PkxaqCl7VZme7SDu104zJlAUihV2bJXREDUwPxmyEnU/QXHm7EBpfVx2cs5tc1VFv70HLY72WDGQpA7d+735SjjWb3sk7kkvFHIB+WBXg7DyyqrkO9OMpRlvuUltGEEaH70c2FgpHLexsxS/x98/dme6LPr3BR781BJVwI3JFcwf00jAWFWEuZt5ECB5tdTzClw62HEmnJVARPaMv+XaU/Kwj/qlMhN38iY045ODFTIzt6Mwr4qmI/pY16IAbfLTKim78sDvFIFvqF8Hcv+gpdmEBVoreafYdd6dRGMnyYEIlrBKY7sMM138l8BS9Tskx2GaBJepY+3IJaQjSr2MGVj4B1ZOLNGDBdTJ+kPeDepzaonlRIPzs5XQNqxSiMlqptTeU31XX0Tq6UY/vDLEnZk3Yir2+ToCsb1Uua9r1mEZQye/lRzJjIw3WcFTQ1Z7sHDHQpgtJdlRYJPI2B487ix/ntNIJ8FfcVOa9Wk7UNFHbO2tgbI7BdzQ0tpWIkgRyEV15cr2kNszIROIJcHBKVSBdVIrGr//x9KYfOSTEJpggL7k8xRPsOMav2u5kBjuKP1BaNNx3JZ9TJ//Sb7AVOui6Vy6gDgUK2+gCiiKArU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(76116006)(66946007)(66556008)(66446008)(66476007)(64756008)(122000001)(8676002)(8936002)(38070700005)(26005)(186003)(316002)(921005)(71200400001)(86362001)(7416002)(5660300002)(38100700002)(4744005)(52536014)(9686003)(33656002)(82960400001)(6506007)(7696005)(83380400001)(55016003)(508600001)(2906002)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NWUzMlNzSzdMemlLVkxiSHUyc1VVanJGS3lPRnovUHRJcnh1cXIyekVkcVJt?=
 =?utf-8?B?N0luTnlpaGw2dlFkcFlBbjk5RGxnZkVuYXZiTW9WY1UxT0dRQW96dWs0THFP?=
 =?utf-8?B?QXdyTlNGd3NQMzZCQmJnclA1aTM1OEl5dzRLTkg2bVp4c21TTDhGUnB6bDZS?=
 =?utf-8?B?TThsV0dQc0dMOVpZZDUvV2pKcDVwWklncWVQdVFjUFN2ZGJaVStmY0U4Yklt?=
 =?utf-8?B?SC9UdHZvZ3QvVWowams2d2dQS2NRMEVtTUd3RDdYaXovN3JpQlRySTZPSUh2?=
 =?utf-8?B?YWI1QXhXUmFZUEN1QStMRW9YV3Y2MXZlRDcvRWN3U3I5c25sYzdUNS83b2sx?=
 =?utf-8?B?b1hiSUZsQUU3SCtqRGFqbXJpMDBwbjdwUG9WVXhpM0E3QUdScWlYcWY3MElJ?=
 =?utf-8?B?WTdSOXliUFZaeHBTZW9mbXJMRVZobFplc0hycHYzNjdPdWRiM3dFdEVqVFFi?=
 =?utf-8?B?QjVhUkxNYUxmUHV3dkY4S3JRK3NHTzQzWlZWMVhBcTlDczZiaHhydFBkYklv?=
 =?utf-8?B?TVkvdE4vYnplNmVGM1Q5Z3RzRUVIa0FJR0U5VElGa09MVzV6Tnhya1h3c25n?=
 =?utf-8?B?WnZFRkh1dUsvN1ozeFU5SmVZM3g5VlZ0bkFYaTkyRmd5QjFmbnYxdHpJVEhu?=
 =?utf-8?B?TGhEWmF3WTdORWVPWjYzaWZSUW5UeXZrTGE3ZUVWanlNUXkxVWpSUlBJbk1N?=
 =?utf-8?B?RlB6NWNIWmRUNnQzVFR5Qk94bzdaQzhyRHFDTzhZS1VDRW5OU3l4ckVuUndZ?=
 =?utf-8?B?OUlLQmIvQmppcU14TU0zZERiVWE4dC9udllDdWRya1BZN1dtYXBXUEdFSnRQ?=
 =?utf-8?B?YWl6Z2FxVURoamR2VkVvb3lPTVJsNWZreDZZWENWazBWdWt6aDhndENLeGNR?=
 =?utf-8?B?MUhNRHlYRGJjdzJHYVdIVDNKVS9CUlpmb2QrYXJRYys4TnFOT3VpRVF0ZGNx?=
 =?utf-8?B?c2Q3SGxBZWJTWWhpZ053UWtORGFXNEVMaTRmVnFLbmxtNVhJd1VVV2p0Zjhr?=
 =?utf-8?B?amZIZ1Z5Y1FMYmxjU0lYTGEvNFAya2grdnAxTmcwLzVXVUZDbitVS09yT0R5?=
 =?utf-8?B?WG13MGlTeW45RjQyZW05MWtiY3Y4YUJJQUVBVktRbTMwUTZiOGRqbHUvNGhz?=
 =?utf-8?B?eksyN1dUUzU4NGM4TXpTSTcwWElDTVNjWGlmL09xRUtETWJ4Yk5lQW8yOVY1?=
 =?utf-8?B?dW40dzBTankzaDQ3Y2pIb29nM0JIN3B5YU14WjhTOXhCSTJjdlYwdDdRcFBx?=
 =?utf-8?B?SkdWVFA3ZEJmQWRXdk9lSFN2WTZ3V1hVZ3BwT05TMlRpOVZBYXhldUZ0WGFh?=
 =?utf-8?B?cU5lNVVwRStEa1B3TklTSnNrU3hYcVVQQytjdDQyMGkzYkZrQ3EveXU2L3NO?=
 =?utf-8?B?NnJQeTN1bXF2RVM1L2xiMWtsRTVKdUZLTCtLVktDdkdta015VlpiY1V1TXdw?=
 =?utf-8?B?ZWllYUZGd2RnWThQQVYrMHJNWWtZR0RHQUtiSnR2eWFDMzFjSXF3Y2Y1Vi9i?=
 =?utf-8?B?U3g0L3U5ak1wRTFTaWhOYk1BOWxIcnhOUkpBTGlVY1hFRXBjNXdDUDA3TGc0?=
 =?utf-8?B?WG85RHkrMzA0aFNhaEVKWUEreWpOekVPYVdvYm9MR0Z0b0RCQzI1WXVJVEZj?=
 =?utf-8?B?bjYwSkd5Rm9NbTF4WGwzaUJLK0tkc0RsaVh6bC83WXFiUlByL0h1QXlDWHcy?=
 =?utf-8?B?ZHVGWkNkRE9ZMEw4SFkza1FWWVR1cHBMNzRMVzMyNDU2K1JUV1JLRFZYSkZG?=
 =?utf-8?B?VTUveDhML3JSVWZFa2I2S2xLUXVKcW4ySnBiWGxpMjVzZWdGM2lvVFVVNU9t?=
 =?utf-8?B?MHozQ2JRYWxvdTVzSloyRFdTSG12dTVnckkzWFhLM3crbjlqd1RLNmFDUHAy?=
 =?utf-8?B?M3AxMzJvcjJ6QjI3eFhhaDBuT3llTmk4UWZJWWxVM3VNQjBSVFA0WXFYZkF5?=
 =?utf-8?B?Q3gwNlJVVm40Wk1EMnY4VkJnTWI1Y2gwTWEweXJzTDcxcHAwVVV1dVZ3dWx4?=
 =?utf-8?B?bk5QRHNGQjhtcWt1TktjTlN3VWVHQ3Z0WE1zUi83aVBaZHU1QmwyaTBJSDds?=
 =?utf-8?B?RFFGVHJjakxyaXlaSmpUUVVENXZiNmFUNVlueDJGcldzVnVmbXU3SXBxSFE0?=
 =?utf-8?B?Q1hxSXJ0ZzdDY1JQcEJUdTcvaEpuVGkxSEtHNGV6MGRsQTNUUGlEY09GTWwz?=
 =?utf-8?B?TlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d5f9966-3ea2-4254-b512-08d9e949d392
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2022 08:22:34.0033
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Clf82oGrIheNg3KxqEhie+AcD7DKCMBaru9egQaQgjbs5JxUVLKXFzMU0dzAfK8zMYtzW7SEZv8djVizbo50Bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR04MB8093
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiBEZWFyIGFsbA0KPiANCj4gSSB3YW50IHRvIGRpc2N1c3MgYWJvdXQgcmVhZGluZyBVRUN4eCBv
ZiBVRlMgU0ZScyBpbiB1ZnNoY2RfZHVtcF9yZWdzLg0KPiANCj4gVGhlcmUgYXJlIGZpdmUgU0ZS
cyAtIFVFQ1BBLCBVRUNETCwgVUVDTiwgVUVDVCBhbmQgVUVDRE1FIHdoaWNoIGFyZSBhbGwNCj4g
Uk9DIHR5cGUgdGhhdCBtZWFucyB0aGV5IGFyZSBjbGVhcmVkIHdoZW4gcmVhZGluZyB0aGVtLg0K
PiBPcmlnaW5hbGx5LCB0aGVzZSBTRlJzIGFyZSB0byBsZXQgVUZTIGRyaXZlciBrbm93IFVJQyBl
cnJvciB0eXBlIHdoaWNoIGEgVUlDDQo+IGVycm9ycyBvY2N1cnMuDQo+IFRodXMsIHdoZW4gVUZT
IGRyaXZlciByZWFkcyB0aGVtIGFmdGVyIGNsZWFyaW5nIElTLlVFLCB0aGV5IGFyZSBjbGVhcmVk
Lg0KPiANCj4gSSB0aGluayB0aGUgcmVhZCB2YWx1ZXMgd291bGQgYmUgemVybyBpbiBtYW55IGNh
c2VzIGJlY2F1c2Ugb2YgdGhlIGZsb3cgSQ0KPiBtZW50aW9uZWQgQW5kIHRoZXJlIG1pZ2h0IGJl
IHNvbWUgY2FzZXMgd2hlbiB1ZnNoY2RfZHVtcF9yZWdzIHJlYWRzIHRoZW0NCj4gYmVmb3JlIHRo
ZSBJU1IgcmVhZHMgdGhlbS4NCj4gZS5nLiB3aGVuIGEgY29tbWFuZCBpcyB0aW1lZCBvdXQgYW5k
IHVmc2hjZF9kdW1wX3JlZ3MgaXMgY2FsbGVkIGluDQo+IHVmc2hjZF9hYm9ydC4NCj4gDQo+IFNv
IEkgd2FudCB0byBhc2sgdGhpczogaG93IGFib3V0IHJlbW92aW5nIHJlYWRpbmcgVUVDeHggaW4g
dWZzaGNkX2R1bXBfcmVncz8NCj4gSSB0aGluayByZWFkaW5nIHRoZW0gaXMgbWVhbmluZ2xlc3Mg
YW5kIG1pZ2h0IGJlIGV2ZW4gYSBsaXR0bGUgYml0IHJpc2t5Lg0KTWF5YmUgc2VuZCBhbiBSRkMg
cGF0Y2ggdG8gbWFrZSB0aGUgZGlzY3Vzc2lvbiBjb25jcmV0ZS4NCg0KVGhhbmtzLA0KQXZyaQ0K
DQo+IA0KPiBUaGFua3MuDQo+IEtpd29vbmcgS2ltDQo+IA0KDQo=
