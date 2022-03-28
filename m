Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABD1AC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Mar 2022 10:12:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240178AbiC1KOI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Mar 2022 06:14:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232099AbiC1KOH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Mar 2022 06:14:07 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB4B2546AC
        for <linux-scsi@vger.kernel.org>; Mon, 28 Mar 2022 03:12:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1648462347; x=1679998347;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NrTNhKK0eU9xd3rYWfXNGNJz30b3IYDXHRrln2oJEkE=;
  b=NvFdKtuE9emAqmal9+9Rcra48gtXZZ/HaSnVeIL+B4MeirnnJhTm/NJU
   SVqSampXRDB0FqVA3GIk0/xZw7mTj7UNanJ2H41WPIBX2GCAjjeMfXViv
   qfXKi7kZNM70jiPMLhWSf2Y7FDaOmU1+CzLcEKOr/xwg2LmwFHKI9bErK
   gf7XxtIAI3iEapBcJCLRN0Wx9olcVZhYNfb/lhISoOTk36OoDm05nivbm
   hwgemqIGdomvdX3FE322piIl12QQjWfd9cfkd2BdT7Z8SUbvFNbwLCDlU
   IJTw76ddntM+mTCnCBvt4/qRVZO4+7Nse+6u9dvS4WwdVs7i8qtQsUQEg
   w==;
X-IronPort-AV: E=Sophos;i="5.90,217,1643698800"; 
   d="scan'208";a="150617813"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Mar 2022 03:12:27 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 28 Mar 2022 03:12:25 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Mon, 28 Mar 2022 03:12:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g4dDiN6spGxXIczJ/7/ql3Hkf+ETJlH2OCzpGSXQuI8yB4IAZ6F+PsKBNDT+8bm7F64Ng6qnM7wfnKa+3TuGLKPH7IjnVLJ/o4rU05PI/bOrz0t6qy60PEamNIMnHvlD08lAHrn/i+RV8kb7QJML4rDJRl20vfBWwuTfgiT8xtQpIiZ1icSJgLBdBL+HAFZztEqZ3Al2Lotr2vkoepRLw7c1sH4zDF37OMV0zajRYD/EHY2V4PB68GpBKSydWS6830seVQKSq5FZ730KznLMhH+K2zX+64D4OQxjilQn76VIIoMcN0jlxqYYT9mkSdqSZSLoAGA0ImbrhdX1xM6a8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NrTNhKK0eU9xd3rYWfXNGNJz30b3IYDXHRrln2oJEkE=;
 b=DlUQU789EXJTIoA9vJdF6Uo3HA9RgBDXX98aSu83M+y6hGGF3s52trnXvmEnJ3FB1kZQLa5yrLjpyxJW3jPv+vqmhSwbDFRmCRfkLaZwqVnITNjzsKUIyUAV9qt4xCrgoIbCh67HOKJs7R6dM6zCav2KKxjCsNYiJQi2/UjbjChxEa3H93l6fTQQtlhW7iKZAwRLv6fPgGLe6Ar/m6XFolyjwWBrovcpJoYvZzrXXixa3NbLboDanrd7/YQPnmYH3fEVvZ2eXPF82O6E4pxiQiZK/yRQq/rlYWjfc0118++PZBmW0uunIHzdJwSWPDLw1cg/V4ZtlMjoIRy6kFEIjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NrTNhKK0eU9xd3rYWfXNGNJz30b3IYDXHRrln2oJEkE=;
 b=hpDtPfcRExnXy1nOAD4bt5bmLLQkSrd5sWob76cr+VxX8TlLvKCU4SulrgAWQ+BPIiglJCT+DfySEEw78JzFcxupXPcuIxBcw2CLSjABsCU0ik0dV8OyAKBiLQTIS1ia8iorypo2vCzpIhgi0S7WRLtxGGaszrS1qgZy/TNyMLU=
Received: from PH0PR11MB5112.namprd11.prod.outlook.com (2603:10b6:510:3b::18)
 by BY5PR11MB4212.namprd11.prod.outlook.com (2603:10b6:a03:1cb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.16; Mon, 28 Mar
 2022 10:12:15 +0000
Received: from PH0PR11MB5112.namprd11.prod.outlook.com
 ([fe80::e0b4:5341:c860:9e0c]) by PH0PR11MB5112.namprd11.prod.outlook.com
 ([fe80::e0b4:5341:c860:9e0c%9]) with mapi id 15.20.5102.022; Mon, 28 Mar 2022
 10:12:15 +0000
From:   <Ajish.Koshy@microchip.com>
To:     <damien.lemoal@opensource.wdc.com>, <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <john.garry@huawei.com>,
        <jinpu.wang@cloud.ionos.com>
Subject: RE: [PATCH 1/2] scsi: pm80xx: mask and unmask upper interrupt vectors
 32-63
Thread-Topic: [PATCH 1/2] scsi: pm80xx: mask and unmask upper interrupt
 vectors 32-63
Thread-Index: AQHYQoUSzWnn/sUJi02WWvj0FJklO6zUkX0Q
Date:   Mon, 28 Mar 2022 10:12:14 +0000
Message-ID: <PH0PR11MB5112F86334F1684057790AA6EC1D9@PH0PR11MB5112.namprd11.prod.outlook.com>
References: <20220328084243.301493-1-Ajish.Koshy@microchip.com>
 <20220328084243.301493-2-Ajish.Koshy@microchip.com>
 <6f377bbf-9797-7838-e0f0-631c38f85faf@opensource.wdc.com>
In-Reply-To: <6f377bbf-9797-7838-e0f0-631c38f85faf@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1cac36af-3722-44b5-59b8-08da10a36ebf
x-ms-traffictypediagnostic: BY5PR11MB4212:EE_
x-microsoft-antispam-prvs: <BY5PR11MB4212A584A0FBD8582771B318EC1D9@BY5PR11MB4212.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YVvjPfJdvaxUv6W5MvHZNGdx3sM1uvbQNi5h1HaICU5nKUd2+2LLqqF+46VpsEKbs2ws5Z/FEvO2jgbFixeR5m9lbx8ByvkfS6msmn5QL6qxTQLF64Q8XevQf4nipleGeBOy97tCcYloaNO1oeSlNF4mHQKSh97wvIlGcTBPBf7rxHEKeXOhlyG/1ks0Rw6Zw52iWLZljsdpXbWprTYEViEgOuWLMVorROFbYoRuQbB+pYRtSv9TmKQTJDhLDi/mdAaN2SNizsNfUAvf9buaICBcNobT/6F+l8OaIBYmf1ZvRvi5tCJIGMv7Rv9a+waQyqqxfpAseStqgRhPEgIc6QsEF0UUSF2PP1dZDghSDH/1nIIZxoQ2D6hPNhipqSUVWRpEbyX5yZ0CCYU/CJUl3DAP5AuBW39oKmQhtP4GE+zYa1j2gV8pz35DJKv/OAgl7xKlEmxqUcPo/cnNwmtSQYOrQFSNMytWN4tLsVa7ExfDz3tpYvuXqwQKbRaTajONW31SLQindllKHcKec/lH5xmpS/sWjZdHCpxAuMHCgu2gL3Ht8DgNupe9lFupLOa2o9tpmYlc+/3Wo7CDujejcgKLCfKZbTR8BnfJdYY4IRKXGxGFn3HtAEL+93tfVKrtMTNq/jMgq8EFMDOu/EFREeox3VS3kuOJdxEOF4Vihf1JYUKiH08qU8wRXhEQwKGUnlcc7dMfrBaXkCFvr4ZfIw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5112.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(122000001)(110136005)(2906002)(54906003)(38100700002)(33656002)(316002)(55016003)(76116006)(5660300002)(66946007)(186003)(26005)(86362001)(8936002)(83380400001)(4326008)(52536014)(71200400001)(64756008)(66556008)(508600001)(66476007)(66446008)(8676002)(53546011)(9686003)(7696005)(6506007)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RzFZN2tESVhkeklEd2RWZmljeDR6b1h5UmpmTGtzUW56N2lOcStSYVdvQXlR?=
 =?utf-8?B?UW5oejRlM1UyMDBjekY3Z0NJYUx3YmtDRTVITlNUcUZaVzF4TlFQWCt6OU5F?=
 =?utf-8?B?aXFzN0pLOCs1RzNVUnp1dFh3eHMzeHNrNUh2dlp1UjdWSllITVBSRG5UK01D?=
 =?utf-8?B?NW1lRkc5SHBTZngyMWxRTWxES1RCZkhyRm1lZjBGbGdQem54SGlTdGtITGt4?=
 =?utf-8?B?YU9UOEEzYVUremdobkpVR2w3WDE0TXk4WDNHY2VWajBuTjFEQ1RLSVR5Mm1k?=
 =?utf-8?B?ZEV6NkdRbWdHRjVwcUtPbnpTQUlWRXJiSXNTMnpDV3ZJRHVZRVhOTmRadFlN?=
 =?utf-8?B?YTNlTllSZGNWZFhyNE1nTE5tWHhoNEVzMm9scVFlOFhTdEo1Vkk1b0VTS3JG?=
 =?utf-8?B?NFB2clNXblVPQjAwckVFQnh0MkdXb3lNaXphNkUranNYSEtOQzlFV3lNTDhG?=
 =?utf-8?B?VG0yUWd5MnAwYmx6MEwzZnFoblUzUW5sVFlCRTYwVkhOQlBSaWRwdGcrQVBK?=
 =?utf-8?B?RzNTb01SS0JEenRYdGowK3RUODNaeGhJRHlob0d4R2JxcjY3TFlwOFRiUHFO?=
 =?utf-8?B?aEE4a2x6cjd0WEN0WWtLTllTamNvdHNWQXNwTG9TZ0kxeTVWMEZyNHdNbVkz?=
 =?utf-8?B?cldyeXdGd0ZhQTMyMHZEWCtIK3NCMDB0dXhMemhmRXdQOHk1NEVUUXhvRjJN?=
 =?utf-8?B?VDdBcTVXaDJXTnliTldjaHJkaFlPNlpINzgzUmlVdzh6VXBrMlJmR2JaVXpl?=
 =?utf-8?B?MUx2dkVHYnpvK2lWOVkyVTh4YStURjVNWmxkQ1MyS1FodmZXMnkrUTdHMnVM?=
 =?utf-8?B?ZTA1cmo0d0NSOHRxSmVST29kdndJaUR2a2FIYVFWR0tMSy9jUzFmSGl4Z3Vm?=
 =?utf-8?B?OEpXZnk0bi84eDJ3akszVUk0dXljOE0wTGlTcFFlNXl0WFpNcUxGak8xaDJI?=
 =?utf-8?B?MERiK3NKanZ1cWk4MkFKa0VRYjZQSG9NRDI4NnBwQWR0ZC9JbWpzZGJIWERK?=
 =?utf-8?B?cTRBVVF6dlU2WjJLN2lMVTB1b3FzaGE4VktKZ2NXZHdUUnkrTG1vaVJNVzl6?=
 =?utf-8?B?dGZsRk1DZ3g2eGFWbnZEUGRPVnN6eXdmUFdsajVZM0VBRkYyUW5zNFZrNjAv?=
 =?utf-8?B?Y0JiTVZ2WHlmQUpnZmNNekNWV2M0bXRVZC9hc3RMNFFBdUcrNWpIaDczdXVF?=
 =?utf-8?B?dEhQbStvRzFyRitjK3I3ckhHbGNnNWVuYXpVTThvc3IvS0NOdjYzVzRuSnVj?=
 =?utf-8?B?OEdIYWJTSWpka203S0RiRW9JQlNqTnJDZk9NaWFqbXhiMTNqYUhoRk1HSGFs?=
 =?utf-8?B?MGs5TXZpeGNsZGpIVHF6MGtWZXFNRy9yV0c2VlVuSTlhRVpUMlBhUDVoUnBG?=
 =?utf-8?B?bVl3dUQxWmJzUXowY01wT3pWUTlDd3FyQXRXamhQM05QZnFKbEVyb3dDTWs1?=
 =?utf-8?B?SGNhcG9RZng1c091ZllEUXJBK2pmd3hpL29aQlVEY1YrSWM3em1KRmtIZTdk?=
 =?utf-8?B?cjUvSmRUOWxnbWk0S2dPbUp4aVBKbTN5ZG9sUzZ6cU9keGpyUUxHdDJZbFFE?=
 =?utf-8?B?R05qWmxFT2ZWMTB3ZUxKaDBpazc4RXJBM01QbU1vK2J4RVhsMWFLNDFIak81?=
 =?utf-8?B?VC9NQUp6ZHF6MlBwejFCNlNCajVtS0psYzd4VVNldXZ1S2MzQ0lNanJPdTFW?=
 =?utf-8?B?WWhBS0tvZ2FpV2xtc0xuOUF0VU9JYjRZbmZNUnMyWFNweGdzaDM0dGw1SUkz?=
 =?utf-8?B?MVJhT0lxTlJTamtzcnluTXVOZ2RxaHdEOVlwSFJmakhKQUxMcnNGdzVMNWs4?=
 =?utf-8?B?Mk9ubnF6ekhVaEJTNjNsZjUzdGUxc1dGYzZTa0ZQYy9TUS9iMmJQTUZYenov?=
 =?utf-8?B?Q1Eya1lXaGVmcC9USUF4VkNrZFhVcWJLeWpnTEFJZ3FKTjRaaTJGcTJlTXAy?=
 =?utf-8?B?UHhGSHpwTWNRQmVsODVWTDBGdEVyU2thaTlDRmY2cGlRSFFyZkFwUFBVcEdD?=
 =?utf-8?B?VkdoS3dCTnNNU0Z1aGVPTFBQaDBCVzlSZDJtNkVCVWx6SEIxKzVnVThrVEF5?=
 =?utf-8?B?N0t4bEpFRGJJbDBRbkZxcW9iR21ZV001eUd4ZStzaldlMEN5SFZwQ1JkUWlD?=
 =?utf-8?B?VkFuL1c1ckdUR0JncWtiZTBUUHd0bXZwMW5SbUFQU3JOaFVVRXZIR1lrclUr?=
 =?utf-8?B?ODFodzEwQWdKWUZmRCsvZ2JPTmJZb0JEWmNMNTdueDRnQkUwQ3daYUkzY1Zn?=
 =?utf-8?B?MmI1S0V0VkVQSnZLa3NvUUxlUXRnbjJyeTJZOFBldEZ2cm8ycFpycERwSG9T?=
 =?utf-8?B?SEh3dXUzK1B5STA1MDVad3FaZFVpT3hiTExFa0F3eHZqNUNiWjU4dGVUbGkw?=
 =?utf-8?Q?x15an4mlMSIKUAnc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5112.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cac36af-3722-44b5-59b8-08da10a36ebf
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2022 10:12:14.9000
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kQcpH4r12Ez6QGTWdSb5zUb6JkH7fuJuA3NxrXLQ9bjEvEBujajKD6sGmeVUnMaGN+rMAV7k+GCmT8BKFXX6pMv5KN3keuV2Yw7FAAtv/Yw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4212
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQpUaGFua3MgRGFtaWVuIGZvciB5b3VyIGNvbW1lbnRzIGhlcmUuIFdpbGwgbWFrZSB0aGVzZSBj
aGFuZ2VzIGluDQpQQVRDSCBWMi4NCg0KPiBFWFRFUk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxp
bmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlvdSBrbm93IHRoZQ0KPiBjb250ZW50IGlz
IHNhZmUNCj4gDQo+IE9uIDMvMjgvMjIgMTc6NDIsIEFqaXNoIEtvc2h5IHdyb3RlOg0KPiA+IFdo
ZW4gdXBwZXIgaW5ib3VuZCBhbmQgb3V0Ym91bmQgcXVldWVzIDMyLTYzIGFyZSBlbmFibGVkLCB3
ZSBzZWUNCj4gdXBwZXINCj4gPiB2ZWN0b3JzIDMyLTYzIGluIGludGVycnVwdCBzZXJ2aWNlIHJv
dXRpbmUuIFdlIG5lZWQgY29ycmVzcG9uZGluZw0KPiA+IHJlZ2lzdGVycyB0byBoYW5kbGUgbWFz
a2luZyBhbmQgdW5tYXNraW5nIG9mIHRoZXNlIHVwcGVyIGludGVycnVwdHMuDQo+ID4NCj4gPiBU
byBhY2hpZXZlIHRoaXMsIHdlIHVzZSByZWdpc3RlcnMgTVNHVV9PRE1SX1UoMHgzNCkgdG8gbWFz
ayBhbmQNCj4gPiBNU0dVX09ETVJfQ0xSX1UoMHgzQykgdG8gdW5tYXNrIHRoZSBpbnRlcnJ1cHRz
LiBJbiB0aGVzZSByZWdpc3RlcnMgYml0DQo+ID4gMC0zMSByZXByZXNlbnRzIGludGVycnVwdCB2
ZWN0b3JzIDMyLTYzLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogQWppc2ggS29zaHkgPEFqaXNo
Lktvc2h5QG1pY3JvY2hpcC5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogVmlzd2FzIEcgPFZpc3dh
cy5HQG1pY3JvY2hpcC5jb20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvc2NzaS9wbTgwMDEvcG04
MHh4X2h3aS5jIHwgMzUNCj4gPiArKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLQ0KPiA+
ICAxIGZpbGUgY2hhbmdlZCwgMzAgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkNCj4gPg0K
PiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvcG04MDAxL3BtODB4eF9od2kuYw0KPiA+IGIv
ZHJpdmVycy9zY3NpL3BtODAwMS9wbTgweHhfaHdpLmMNCj4gPiBpbmRleCA5YmIzMWY2NmRiODUu
LmI5MmU4MmE1NzZlMyAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL3Njc2kvcG04MDAxL3BtODB4
eF9od2kuYw0KPiA+ICsrKyBiL2RyaXZlcnMvc2NzaS9wbTgwMDEvcG04MHh4X2h3aS5jDQo+ID4g
QEAgLTE3MjgsOSArMTcyOCwyMCBAQCBwbTgweHhfY2hpcF9pbnRlcnJ1cHRfZW5hYmxlKHN0cnVj
dA0KPiA+IHBtODAwMV9oYmFfaW5mbyAqcG04MDAxX2hhLCB1OCB2ZWMpICB7ICAjaWZkZWYgUE04
MDAxX1VTRV9NU0lYDQo+ID4gICAgICAgdTMyIG1hc2s7DQo+ID4gLSAgICAgbWFzayA9ICh1MzIp
KDEgPDwgdmVjKTsNCj4gPiArICAgICB1MzIgdmVjX3U7DQo+ID4NCj4gPiAtICAgICBwbTgwMDFf
Y3czMihwbTgwMDFfaGEsIDAsIE1TR1VfT0RNUl9DTFIsICh1MzIpKG1hc2sgJg0KPiAweEZGRkZG
RkZGKSk7DQo+ID4gKyAgICAgaWYgKHZlYyA8IDMyKSB7DQo+ID4gKyAgICAgICAgICAgICBtYXNr
ID0gKHUzMikoMSA8PCB2ZWMpOw0KPiA+ICsgICAgICAgICAgICAgLyp2ZWN0b3JzIDAgLSAzMSov
DQo+ID4gKyAgICAgICAgICAgICBwbTgwMDFfY3czMihwbTgwMDFfaGEsIDAsIE1TR1VfT0RNUl9D
TFIsDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAodTMyKShtYXNrICYgMHhGRkZGRkZG
RikpOw0KPiA+ICsgICAgIH0gZWxzZSB7DQo+ID4gKyAgICAgICAgICAgICB2ZWNfdSA9IHZlYyAt
IDMyOw0KPiA+ICsgICAgICAgICAgICAgbWFzayA9ICh1MzIpKDEgPDwgdmVjX3UpOw0KPiA+ICsg
ICAgICAgICAgICAgLyp2ZWN0b3JzIDMyIC0gNjMqLw0KPiA+ICsgICAgICAgICAgICAgcG04MDAx
X2N3MzIocG04MDAxX2hhLCAwLCBNU0dVX09ETVJfQ0xSX1UsDQo+ID4gKyAgICAgICAgICAgICAg
ICAgICAgICAgICAodTMyKShtYXNrICYgMHhGRkZGRkZGRikpOw0KPiA+ICsgICAgIH0NCj4gPiAg
ICAgICByZXR1cm47DQo+ID4gICNlbmRpZg0KPiA+ICAgICAgIHBtODB4eF9jaGlwX2ludHhfaW50
ZXJydXB0X2VuYWJsZShwbTgwMDFfaGEpOw0KPiA+IEBAIC0xNzQ3LDExICsxNzU4LDI1IEBAIHBt
ODB4eF9jaGlwX2ludGVycnVwdF9kaXNhYmxlKHN0cnVjdA0KPiA+IHBtODAwMV9oYmFfaW5mbyAq
cG04MDAxX2hhLCB1OCB2ZWMpICB7ICAjaWZkZWYgUE04MDAxX1VTRV9NU0lYDQo+ID4gICAgICAg
dTMyIG1hc2s7DQo+ID4gLSAgICAgaWYgKHZlYyA9PSAweEZGKQ0KPiA+ICsgICAgIHUzMiB2ZWNf
dTsNCj4gPiArDQo+ID4gKyAgICAgaWYgKHZlYyA9PSAweEZGKSB7DQo+ID4gICAgICAgICAgICAg
ICBtYXNrID0gMHhGRkZGRkZGRjsNCj4gPiAtICAgICBlbHNlDQo+ID4gKyAgICAgICAgICAgICAv
KiBkaXNhYmxlIGFsbCB2ZWN0b3JzIDAtMzEsIDMyLTYzKi8NCj4gPiArICAgICAgICAgICAgIHBt
ODAwMV9jdzMyKHBtODAwMV9oYSwgMCwgTVNHVV9PRE1SLCBtYXNrKTsNCj4gPiArICAgICAgICAg
ICAgIHBtODAwMV9jdzMyKHBtODAwMV9oYSwgMCwgTVNHVV9PRE1SX1UsIG1hc2spOw0KPiA+ICsg
ICAgIH0gZWxzZSBpZiAodmVjIDwgMzIpIHsNCj4gPiAgICAgICAgICAgICAgIG1hc2sgPSAodTMy
KSgxIDw8IHZlYyk7DQo+ID4gLSAgICAgcG04MDAxX2N3MzIocG04MDAxX2hhLCAwLCBNU0dVX09E
TVIsICh1MzIpKG1hc2sgJg0KPiAweEZGRkZGRkZGKSk7DQo+ID4gKyAgICAgICAgICAgICAvKnZl
Y3RvcnMgMCAtIDMxKi8NCj4gPiArICAgICAgICAgICAgIHBtODAwMV9jdzMyKHBtODAwMV9oYSwg
MCwgTVNHVV9PRE1SLA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgKHUzMikobWFzayAm
IDB4RkZGRkZGRkYpKTsNCj4gDQo+IG1hc2sgaXMgYSB1MzIsIHNvIHRoZSAiJiAweEZGRkZGRkZG
IiBzZWVtcyB0byBiZSBjb21wbGV0ZWx5IHBvaW50bGVzcy4uLg0KPiBBbmQgcG04MDAxX2N3MzIo
KSB0YWtlcyBhIHUzMiB2YWx1ZSBhcyBsYXN0IGFyZ3VtZW50IHNvIHRoZSBjYXN0IGlzIGFsc28N
Cj4gcG9pbnRsZXNzLg0KDQpPSw0KPiANCj4gPiArICAgICB9IGVsc2Ugew0KPiA+ICsgICAgICAg
ICAgICAgdmVjX3UgPSB2ZWMgLSAzMjsNCj4gPiArICAgICAgICAgICAgIG1hc2sgPSAodTMyKSgx
IDw8IHZlY191KTsNCj4gDQo+IENhc3Qgbm90IG5lZWRlZCBhbmQgdGhpcyBzaG91bGQgcHJvYmFi
bHkgYmUgIjFVIDw8IHZlY191Ii4NCj4gQWxzbywgdGhlIHZlY191IHZhcmlhYmxlIHNlZW1zIGNv
bXBsZXRlbHkgdW5uZWNlc3NhcnkuDQoNCk9LDQo+IA0KPiA+ICsgICAgICAgICAgICAgLyp2ZWN0
b3JzIDMyIC0gNjMqLw0KPiA+ICsgICAgICAgICAgICAgcG04MDAxX2N3MzIocG04MDAxX2hhLCAw
LCBNU0dVX09ETVJfVSwNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICh1MzIpKG1hc2sg
JiAweEZGRkZGRkZGKSk7DQo+IA0KPiBTYW1lIGhlcmU6IFRoZSBjYXN0IGFuZCBtYXNraW5nIGFy
ZSBub3QgbmVlZGVkLg0KDQpPSw0KPiANCj4gPiArICAgICB9DQo+ID4gICAgICAgcmV0dXJuOw0K
PiA+ICAjZW5kaWYNCj4gPiAgICAgICBwbTgweHhfY2hpcF9pbnR4X2ludGVycnVwdF9kaXNhYmxl
KHBtODAwMV9oYSk7DQo+IA0KPiANCj4gLS0NCj4gRGFtaWVuIExlIE1vYWwNCj4gV2VzdGVybiBE
aWdpdGFsIFJlc2VhcmNoDQo=
