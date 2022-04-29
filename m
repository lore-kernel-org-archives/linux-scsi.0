Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17D69C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Apr 2022 05:44:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354191AbiD2Frt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Apr 2022 01:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354197AbiD2Frs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Apr 2022 01:47:48 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 639B0703E9
        for <linux-scsi@vger.kernel.org>; Thu, 28 Apr 2022 22:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1651211072; x=1682747072;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/MEbHX6+4vworHaUz0+mcKUn416oMUz5CmPhJJwI2Es=;
  b=P+cFF6Qj1WTDEKnjP9Zw9ID9VyRF4E4PbK7pvFSFc5Tnfl0k3nZ72pPa
   5X5Q+D2TpshGFDchKB7kVb00QEO9FsjrhrANBQQ+rZgzZEryEqF3/wxTj
   1bAf05u87N8JmgeAP8XBF37zpbNvDypEAxt04Lte4rT2kABuNIXn24pUt
   xqCt7ro6zpnHAjyrK8Ln4J1Rm6u1+zWmqLTrkS9Uca7liaWTI9FvhpuVr
   wSQc+EKivsTiHHs8he++/IsoUUtd/tTdJCiT9UajbBZzU3Udt3at7HHgj
   oMstFi1RgFDKiv78KXYdJMortY/UZbcQ56PXmaD4xuT330awb3PGvv8qE
   g==;
X-IronPort-AV: E=Sophos;i="5.91,297,1647273600"; 
   d="scan'208";a="200014955"
Received: from mail-bn8nam12lp2171.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.171])
  by ob1.hgst.iphmx.com with ESMTP; 29 Apr 2022 13:44:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hpXvSnKNHKphHCANET3LtI/Qgt6ZeZ9rGAziC2WSD0yy/aAtTH881T5CQvjAh4UzanbwikgD7YINaZoKv1Ei5D0jEZojUU4Ube63apsVkIMIoXw5W/xXwAtQz0AOJxNPHdZXuG3hngE2yg3h1jApKos5REAEjTJ0XLQcE0tvJKyjcUEfBY6oebQourDe6QidD9R9qRtCe9FEBU3jpmu716hTX2FYzUOv1+wlpkJDFibogcYkNxVaDZIZlTZAVcQfHrwSJ4DYvXAWvJqvwOiNHbCSHwlFrtZqbTPCBnlolzOoNDvzxF/emgv3J95+fh6+w1294+WV9LST0KWb9eTurA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/MEbHX6+4vworHaUz0+mcKUn416oMUz5CmPhJJwI2Es=;
 b=e2w2WNeH1Q/1nVW816E9JqztYIXpSgJ3hMabLsPaHT/oXP2cEfqkL6p/HnqLlqAlNZYdFwRg9tQl5qbTFGnrkJtCMUKn0xYToN+QgIPvkUCA+4Q9tY2Ls0rfF5E+B53TDqMRLTj5/dqwwxdKWYYDC06zI9s39rVLVtL+QuXcYbm2pcVNcojuRrkjc5D2iKe1woi/CQxs2Mk+oRI0IJmfgnIs0OMG0YD29stLn3mProrUQ7FcmCEOjNxZbJVsFUC5GcyTcUNyrWUcXjuHOKRXx2qrRqwOIX8OSh0rHh9nKW3MPF54oSSlLnX9WBReL7X2jLqvF4iXEp5Icl6vzQp6sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/MEbHX6+4vworHaUz0+mcKUn416oMUz5CmPhJJwI2Es=;
 b=SoxD+sVpwwNchF/1pCkOkFCfXxwE93rMPPoI1yaygCI+L0pinGMjgVwWOXGCWYOPgXFuDP+nhisrqfsbB6WV0cyhp7J5p/ZTS1CaK3wq/CLeXIoKkr/VSoy2ENxPFqDSPoDh8IXL/SUY7mxlgVeGiLGmWY2hap2+j4tWdwEM3s0=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 BN7PR04MB4259.namprd04.prod.outlook.com (2603:10b6:406:f3::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.15; Fri, 29 Apr 2022 05:44:28 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::b049:a979:f614:a5a3]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::b049:a979:f614:a5a3%3]) with mapi id 15.20.5206.013; Fri, 29 Apr 2022
 05:44:28 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH 1/4] scsi: ufs: Reduce the clock scaling latency
Thread-Topic: [PATCH 1/4] scsi: ufs: Reduce the clock scaling latency
Thread-Index: AQHYWpAN08aEayJanUS/vdFdW40KL60E585QgADcA4CAAJ8SQA==
Date:   Fri, 29 Apr 2022 05:44:28 +0000
Message-ID: <DM6PR04MB6575B1EF6F41CA69BB816EA7FCFC9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20220427233855.2685505-1-bvanassche@acm.org>
 <20220427233855.2685505-2-bvanassche@acm.org>
 <DM6PR04MB6575F913911C61D7853F5A25FCFD9@DM6PR04MB6575.namprd04.prod.outlook.com>
 <f3c2d9a1-f36e-1da3-4568-67214ed43886@acm.org>
In-Reply-To: <f3c2d9a1-f36e-1da3-4568-67214ed43886@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3c14a2d8-4ef4-499a-f07e-08da29a35393
x-ms-traffictypediagnostic: BN7PR04MB4259:EE_
x-microsoft-antispam-prvs: <BN7PR04MB4259DB900D6F67FABB5E3E05FCFC9@BN7PR04MB4259.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6d44ZUDp8McjzCaZiCwCty0E+Aljao19qMxmx1kVIZ8m2pf6S8H1IPjySWneDaV1bqTv9+IxRfELNJi8At5AXGLmMqukuMlHgufgmI0g3PG5m1nRUw/EHjTa+tYTgNlSYDCDGsjrs10QxakzOhThTjIk1tvtu9+1ZxOogJsA5+rvgqQI//N2R4+THI10I6mX2auuQ85oX5iZ6GUalGhIlAuWSQ5fsUVsfAbHmP2vQwyz0bgSbcNhh6BnYuH/oAVc5dor8N4gsWWrc9lQYqaCkTaC7ydIEvoMvFpg3g1SqwDyUFkBjE0Vbf6TjOYrMA6qJB5QDDfngmXpAxIZIra8U1DODrlzpG4PqXiGSklN+cmeZ3Hw2pdKUhWEDBBoKHhMU2HS51UZfBVKhg9p+nSTqmRqPTgQ8nm/TjLFJt1CXSosOytDsI86EJm3I75qQ8uqi4fifyevj0TOWMPuAPjnJrAzka/GoHNuEr/tVVYboTS7L5z3nP76v3PHeuhAQ29HXg7SX2cURoRl7HwLwy5hoU8IDwvV+Wjw22beAcyrlSKMw+1zGcRqU6I2u7JObc/+/RK7O73ln57zWsOGGWAxkRC07LBcA/+3xODkshfV6ve10AtD1WLT3r0vQdHSbUuEh+FyglKBnO1LYrBkTJaZ8cv1hihYQM4J4qnghXII1CVbzVaZXJRTjOA7E34e3jtx3rb0OfqqF7DJGeqlMDam1g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(33656002)(6506007)(38070700005)(55016003)(26005)(508600001)(66476007)(76116006)(71200400001)(7696005)(83380400001)(82960400001)(9686003)(66446008)(8676002)(64756008)(4326008)(86362001)(316002)(66946007)(66556008)(122000001)(53546011)(110136005)(38100700002)(54906003)(5660300002)(4744005)(52536014)(8936002)(2906002)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UzNnOS91RnlGMzFLYzFLZGloMmZtV0Z1bUpEdWwrc3kxdmhpb1hpVGVrZkZE?=
 =?utf-8?B?Q29neVhybFZaTUQ4TmlUT2d5RzZCVU5JMy96T0xCV2hYdHVxV1pudUtRMHFT?=
 =?utf-8?B?M1ZyRmZkTzJaK2pjMHRQVE82eWVTQnhzVjk3MWNnckJXUS9RUGxETWxYcERs?=
 =?utf-8?B?L2YrMThacDJ5N2o4T2habkgzZHpCMjBMc1V4cHZwUFl2WnppS0RlK1pwTm4w?=
 =?utf-8?B?K2p5MUZPalJMeTRrZWxWaFJmRGJLNGlJdGNnT1lTTHErdEFMa01xODFORzRz?=
 =?utf-8?B?QmY3MVRpNGdDZjFRU01GZTBUdWgvRkQyekFwZGFNSm1ETi9Tby9WUDlqazI5?=
 =?utf-8?B?dUo5ZUl3YVRSbytkNldJRk1aTjdWWHRiTHd6bHFvUXhBcnk0bkZQVlJxSVdI?=
 =?utf-8?B?aVlYYTJVOFFtWkExQzBqZlY1SXdLNVVCbG05NW00aDB2R3VyYmlkS2lvalAv?=
 =?utf-8?B?SFVjNU53L0hCb05DOUZISjF3YllJdHk4ZVl4MWdwWTN1RlNEMGcvcmhjcldi?=
 =?utf-8?B?V2VJMkYrZFhWb3F0c2hkTEttUjI4ei81aUZMSVNHV0gra3dtTC9LVWhLeTVj?=
 =?utf-8?B?OVVRNkw3OFJDblN5V3pHZjVQUnRPY0xpWDZVakV3aGh5Yk5lTlpDSGRkYkVS?=
 =?utf-8?B?TXpRcEZ0NkkwMWhTSitZOHh1emJVMDRGQ2xiY3B5UVhDMzUyZkFQcXdnaEVN?=
 =?utf-8?B?d2tqTHdCOE8rMFZsQ2hRem9JUXU2cEtrVDVheHhnRFk2YlpkaVloQjNmSys0?=
 =?utf-8?B?RlJSQnpFZlJnK3M5RGd2WTFFa2tmUjFzOGxSb1lxWlNhY2lVQ0VoZ1A5REZv?=
 =?utf-8?B?NXQ0dnhLdXRnbklYcU5qM3V0b2ZvOUlIdmdqNHhKaktVMEhzazV5dWlSOS9l?=
 =?utf-8?B?ZHZ3bmR3M205Nmp1RUlxMlFwajl3bkpjVjN2MFVTL2hQQnRCaWJpelBXRlRL?=
 =?utf-8?B?WHkxK3htN1VDWUhKSnZXNWxvZTQyeXl2ZmJLcjQxOTVxQTNweldXMFp4YlJY?=
 =?utf-8?B?ajJOeU1yU29vdS9zRGJEcWFvWDRIN2pMbTl4QXpxQ0R6UnR3MnZqZjRKVDVF?=
 =?utf-8?B?d0hNbDAxWEJYVmNqcVJaWVFFeFVra3lTeVVNL3lJTnVCL1JoR3UxaFRrS0x4?=
 =?utf-8?B?MWh0REZHK3cyN0M3VnpBK1hiRWFFN1J3eVBQb3FRQ21XNGZJeE9YbUJuQThM?=
 =?utf-8?B?VVRmWlBuTGljUjVFR3ZzRkk1UFR1b05VV1haTGZHRXF5UExqMk1kYnJURXJG?=
 =?utf-8?B?SkJhdHcvZndhalhKcXZibXRoN3QyQ000RTlxek1GdmNVQzd0b002NjZRbVZH?=
 =?utf-8?B?OVpCWDFBVExpNFJTVTA5elVxKzhXUFNBekNQY2IrR1ZTSVEvejZpUzliOUdz?=
 =?utf-8?B?cm5rQ3Mwc3FiaVkxNU5Zb1BjNGxwZnNqZzBucCs5UVlVTzJnWW5SU1BJcjBh?=
 =?utf-8?B?bXFuNjZiaVhLbk9RSWVZdHpDMG9JU1B6OXFkc1M1MHladUFUR25pcFNMeHVK?=
 =?utf-8?B?bUpySElKYzMwV1FHdzR0a0pMLzl5NHlQSXB6aVpoOURuK08vdWJmV3BYaUJl?=
 =?utf-8?B?M0JGZld0eityTEVPL3lkQWplcjJQSzVHTzJOUHA0eUVEYk5HSFJNYXVkdVVa?=
 =?utf-8?B?aFdaellldzdwaXZBaFF3Qno0dXFrTTk3VkxTck1ONmhlWUFzKzVqSGRtQTlr?=
 =?utf-8?B?TUJIU1FSODlBbTdqV2ZKWWRkNmR2VDlxOStOelI3N1kxZXFoYW14czI5Y3h6?=
 =?utf-8?B?SjVXTm5tSlc3bGhzRnErOTV2V3pzM21SL3l0UlBrZnFRMnNRVUpkT3hTOTJy?=
 =?utf-8?B?UjljNEVUakJWaXBzRjRHYUNZNVkzcUJJYkNlNzNBNWdjMElaZDJFRFZvM3du?=
 =?utf-8?B?cEtyVStmdHR6UkFncENneHkwMEIyN0JxOW5Sb1JFMnB2ZXVTbFpJQTNDTkFp?=
 =?utf-8?B?L01IWHYzY242aWJobGpBZVNSaVo0WC82K0dxY3VCZjRnUlRkZmI1NjRhL01l?=
 =?utf-8?B?UWJyc09JVGowSFQwRUEvN2tkcU92bmRGNjZxeDlVaHJTNCtORXhMdUZpa0ph?=
 =?utf-8?B?em5QeU1tK0F4QkxYM0d5NXUwSnF4TDVjaEh5QTR6RWJTQStabHZqZjFwL25I?=
 =?utf-8?B?bGVaSjgxekhvMzVOOUJRa3NGVGhZS1NobkNhQkxTWjVLS1hseDZCN0h1YzVH?=
 =?utf-8?B?WjExTTRzS3J4QmUvbnpJU2NDWmR0ZVRDYm0wbXlSZmJ1clg5R0l2QXdsMncy?=
 =?utf-8?B?cW5aWU4xY2lCOFo0OFZYTGdkRlp2cU5NOGNNMnlsU2lodk5qakc3VmdyRGE5?=
 =?utf-8?B?dkFweU8zdEhYOWVMbmwyQ2UwZ1hHVFRIaU14VHNJYkVwWExCY2ExQT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c14a2d8-4ef4-499a-f07e-08da29a35393
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2022 05:44:28.4646
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gq7OxKavEbHtEMiJQqJjkHSuGw9dvVhmrt0VXbe72zjvIAqwW3NGFE/7PfRfgud6v2+kENX4QtlUW1WJg6Wc5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR04MB4259
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiBPbiA0LzI4LzIyIDAwOjA5LCBBdnJpIEFsdG1hbiB3cm90ZToNCj4gPiBNYXliZSB3ZSBzaG91
bGQgY3JlYXRlIHNvbWUgbGlua2FnZSB0byBET09SQkVMTF9DTFJfVE9VVF9VUz8NCj4gDQo+IEhp
IEF2cmksDQo+IA0KPiBEbyB5b3UgcGVyaGFwcyB3YW50IG1lIHRvIGNoYW5nZQ0KPiANCj4gICAg
ICAgICBpb19zY2hlZHVsZV90aW1lb3V0KG1zZWNzX3RvX2ppZmZpZXMoMjApKTsNCj4gDQo+IGlu
dG8gc29tZXRoaW5nIGxpa2UgdGhlIGZvbGxvd2luZz8NCj4gDQo+ICAgICAgICAgaW9fc2NoZWR1
bGVfdGltZW91dChtc2Vjc190b19qaWZmaWVzKG1pbigyMCwgcmVtYWluaW5nX3RpbWUpKSk7DQo+
IA0KPiBEb2N1bWVudGluZyB0aGF0IHdhaXRfdGltZW91dF91cyBtYXkgYmUgZXhjZWVkZWQgYnkg
MjAgbXMgc2VlbXMgbGlrZQ0KPiB0aGUNCj4gZWFzaWVyIHNvbHV0aW9uIHRvIG1lIDotKQ0KSSBt
ZWFudCBzb21lIGZyYWN0aW9uIG9mIERPT1JCRUxMX0NMUl9UT1VUX1VTIGJ1dCB0aGF0J3MgZmlu
ZSAtIA0KSXQgaXMgZ29pbmcgYXdheSBhbnl3YXkuDQoNClRoYW5rcywNCkF2cmkNCg0KPiANCj4g
VGhhbmtzLA0KPiANCj4gQmFydC4NCg==
