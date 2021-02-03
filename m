Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D26D7C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 15:32:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A8CB64E55
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Feb 2021 15:32:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233524AbhBCPby (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Feb 2021 10:31:54 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:21816 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234422AbhBCPbe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Feb 2021 10:31:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1612366294; x=1643902294;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uqvZJ+YJRofOkMeSItWxN85pKXPHMxXstOiyvfXSz3w=;
  b=MtMyEkLu0AXXGyvViSI4VtOymXrdVH8KOmhjdTgcURC4EniSyvsLSBzS
   BmwDMm8dqLCrRZ1GO7mOgcNkBQeLbqjtj5JHmxQeVtRYIw1A4RzHbU3zb
   AnNJpRBmzMMw1cqVitTZuByxSZDMLuCOmHBwOt2naPpjS4y/PvnLPsnXj
   jWK/rwzKCIFvGsCT5SA111uZWfyFCNAlYAmNYivVod/yy5lBotWaQe6x3
   0iDMv0lnLtl02UiWlAEqsEUqFvvUbrgVmy7FCHqsFM4ET/NIJKNnQaPBN
   1AsvWmaRnaRA7Qrbw3NlunAC0ReMGS3wdqJkBpoiZC7qaiT7/XdptEtt/
   g==;
IronPort-SDR: 0ZbVbOgK3pMfEPLptwYTz3F1/3edt3WGBSe+1ftYcvVYxf72Eqjr1mtHJDFepXaEayaRS2Clx/
 LSj1yp8utk9jBz63on+0eOY4hmoOBx0uvRByusnuBcKv7yaJ3pxgXetdKa6SZk+71BvO/b9Uul
 UIYwbL0SryePPx/xTbVaHbsrncNQWZxL4bBaSSa5TJdBvIfra2PvkTx+mjNfPxjIoZJOuFFIPX
 OvZ7gUxrfuk1A7VtEV/XI+yd/W6fpuMrvTYxNrXBPnJoTfZztv5yyOOjrNpLPR9WidGCKoreqV
 39U=
X-IronPort-AV: E=Sophos;i="5.79,398,1602572400"; 
   d="scan'208";a="107877241"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Feb 2021 08:30:16 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 3 Feb 2021 08:30:10 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Wed, 3 Feb 2021 08:30:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VyskOoAh/i8OjAau9xApuhS/LYmAjykr9IyEVChEXVgWKuY8s0IAwrCCbDtHDJVxFVXykTtuGBWeXzl30jVqQq4IoGwIkrC3IQuqDqWkxDQMdLzW3eCQtczWg6a1vvABXrBxcTYqE9rreIkWbPiXS26wUYZKSTH9rQxuYFHd5uJMio7BuC5OK6PcNTdflHcXW2Zgm5mFsUIY9CIWKGbbkpY5AJVv2PhmGP8Hx0bHB5kWCYX+sIAmgQGOBifizJMvmg0qJDwXmYHSmUcVU5ehyZIu/k2UFh8R1VdHxXeBNGUu6HSJpQyx//yLIyXRgbxWdTIqEc9vx5Jac8Jx+L3BhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uqvZJ+YJRofOkMeSItWxN85pKXPHMxXstOiyvfXSz3w=;
 b=JaO+EeqKALstgH+gHm/3QPhxlyJAgNaXZE72fQ+T8oqEqSzluL4UH5sdE9WM44s5VVKFCLMCDjMluvz1q2zNP9MvYCYgKpIFgf3TMV52xh05xY85qfq62yrdDV8aKj5+LmL+Vumu5SKazax4loqib/lAiA7JQoWLJUgvyW4Gv/QPcloTrZ8zhvDQSIYKAtdFbV4Eo5EPi0Up0jdSPmvPz2zUMAgx7wjCVsR8otPKUR5Afqc1tAz1BGHcDHqUFGHLykd+IZS55Kr6wVW/6Md/sa3wtsNJo7St90NNvcRFd5q7Vij6kk2mPNXwxsp1oPbnPf62YGs8OZxWpoTZ1oIU9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uqvZJ+YJRofOkMeSItWxN85pKXPHMxXstOiyvfXSz3w=;
 b=EdKmFgmNE7bSZtG7m4sgiuPE4MKjU6NxS+WMgRJgDqVO62KngTttQJi41zsRFhfd9tRjQzOPamRqEUzwZO6ZaPmBb1nVRSssmbCGp8F2G7THk9CGR8dj0J3fYszMJpJORCnfSQPJ33W+kOIozcp0vjfYrh2NMEUUq6HJtF+kxI0=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SA2PR11MB4908.namprd11.prod.outlook.com (2603:10b6:806:112::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Wed, 3 Feb
 2021 15:30:07 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::ccd1:992c:7bc5:4b00]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::ccd1:992c:7bc5:4b00%3]) with mapi id 15.20.3825.020; Wed, 3 Feb 2021
 15:30:07 +0000
From:   <Don.Brace@microchip.com>
To:     <pmenzel@molgen.mpg.de>, <john.garry@huawei.com>, <mwilck@suse.com>
CC:     <jejb@linux.vnet.ibm.com>, <linux-scsi@vger.kernel.org>,
        <hare@suse.de>, <Kevin.Barnett@microchip.com>, <hare@suse.com>,
        <ming.lei@redhat.com>, <martin.petersen@oracle.com>,
        <buczek@molgen.mpg.de>, <it+linux-scsi@molgen.mpg.de>
Subject: RE: [PATCH] scsi: scsi_host_queue_ready: increase busy count early
Thread-Topic: [PATCH] scsi: scsi_host_queue_ready: increase busy count early
Thread-Index: AQHW71yKurA1STNSk0C6miEuXSSEDaow9juAgAEFWACAAAlxAIAAAq6AgAAFxoCAE1AKoIAADVGAgADJTwCAAAKPgIAAbPTg
Date:   Wed, 3 Feb 2021 15:30:07 +0000
Message-ID: <SN6PR11MB284853B4E54C9F3626C0F17BE1B49@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <20210120184548.20219-1-mwilck@suse.com>
 <37579c64-1cdb-8864-6a30-4d912836f28a@huawei.com>
 <231d9fcd-14f4-6abf-c41a-56315877a3dc@molgen.mpg.de>
 <87b7f873-46c4-140b-ee45-f724b50b6aca@huawei.com>
 <d48f98a9-77e3-dfe3-af5c-91b0ef45586b@molgen.mpg.de>
 <361d5a2f-fb8e-c400-2818-29aea435aff2@huawei.com>
 <SN6PR11MB2848BC0AF824B45CA39A6348E1B59@SN6PR11MB2848.namprd11.prod.outlook.com>
 <2e4cca87aaa27220e186025573ae7c24579e8b7b.camel@suse.com>
 <475c5b49-7a75-3ee7-6f8d-de5f400856da@huawei.com>
 <e60ed23d-676f-a1f9-81a1-44d2ca97f9da@molgen.mpg.de>
In-Reply-To: <e60ed23d-676f-a1f9-81a1-44d2ca97f9da@molgen.mpg.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: molgen.mpg.de; dkim=none (message not signed)
 header.d=none;molgen.mpg.de; dmarc=none action=none
 header.from=microchip.com;
x-originating-ip: [76.30.208.15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 28f130f9-2c35-42a8-0fa6-08d8c8589608
x-ms-traffictypediagnostic: SA2PR11MB4908:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB4908886017F17A0AB27A77BCE1B49@SA2PR11MB4908.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 385lZjE5beopfuANtuHE4opmEmj3+lVyip/gAZbbStgpWhG2DJXZHRmkYE08zl1GcVHCiccpXVuutzj23tPPO4+h20ZBDVbWCXoKTEwis8l4cciJYDutd7Rda6nWRGuZoQd2PMpT+icYs9SD2/A4vk+CRXmmL5SFYlwycXSUMd49/LEJX/slOjKRf04ArK3bKUFo3+PT4rDoB5Cf2yOK/lbVtCVjpbLedzeg2mf1XzEPFprzraaZDXaYE5a2Ac8tkvoz+F/7i0CbDSwthnfMdztMIwACr0Kc+kNN1W5b4jYRd2kXqpRLi1z2MTZT+EouR+erWzp64Zwqcb2aG6mf247CpOHEJxYHFZABaL4PtVp9P+k46ONVSHx5b5dcEN+bEVGMdVxCkmfK3kRmql5pChn9x2yty7I/eT4pxrm8a2HR6gxUGlXCggfgZduKVGcwloYwxgOU0xal8Eu2gPlKcFEzvDcGNiiWdclhZg8Z4baRA4mQXtyZVa74D8dANaF4IQ5K1t8Li1wnIypeDrPjhQlvhSi2OMJsxF4rSqu09UxVwuiIKmWjPfHURxOX/jHNlPxmq05nuToMHNWDZdH7Z2EkGfiphPWaQ33hTXk+cv8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(498600001)(71200400001)(86362001)(6506007)(7696005)(8936002)(186003)(9686003)(54906003)(26005)(55016002)(8676002)(64756008)(5660300002)(66476007)(4326008)(52536014)(76116006)(7416002)(966005)(66446008)(66556008)(110136005)(2906002)(83380400001)(33656002)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?S3NKSWZXZTNqNFdhZnB2SXJSaTliZXlBdHRSM1dqWms1bjc1Um53cVdjQitv?=
 =?utf-8?B?U3M5a2U2a1NlanExc3F5TU1KWGk0RUUwWWo1TUdFdlpjbm1rclNkcEFOMUZP?=
 =?utf-8?B?UGRJeW1lc2NXN3h5MWlwNTRVQUdWRE01Q1ZER3RMRkRBcmY4V2dyTmR3NW1O?=
 =?utf-8?B?dDVwSzhxTWRIbHRMYlFjSUxPRlA2TzN3cmtCVk15OWpkdTl5clJwSEZvaEpt?=
 =?utf-8?B?M1RmQWdkUi93dXI4eFlRUVBnTGkwclBJSDdMejZ6QmV0ajlwWUxjZ2RNaExP?=
 =?utf-8?B?OWdGMURCcTdzbWUyeGNVUXUraERDN3NXdFpnMkNoWnZMaktJanhydkFpR0d5?=
 =?utf-8?B?TEdOMHdjN3RtT2RQdWNRbzd2ZUFxUWlkcWlOQVgwRjV6b1JFM2R0QWpZZlVo?=
 =?utf-8?B?aGFEYVp3VmdvdFJ4UHlQOVRaU3gvUkRWT01RaWdqNUV2MFB6YmFhckpNV0U5?=
 =?utf-8?B?Nm9YRjhJM0prWmxJNEROZVpXNnJRU0E4emVNeTRqRXhLeXVKVEttSW1KK0lY?=
 =?utf-8?B?ZG9VS3M2K3JycHJwbjI3U1M2TzZBa3h0ZThWMmVxUHkzWGo2U1lZZmMzdVdm?=
 =?utf-8?B?QUVSdGF0c2ZhNnF1N3RMajNJOExRU2FKSDNtRjJydEpIcUNrWERiNThOYmhN?=
 =?utf-8?B?bWRFNUNQd2J2dllzbUR1T21lTWk5bGozV2F3UFAwQUlNRHpYSWVDcGRabkJw?=
 =?utf-8?B?OHhOdmxZbG5ScEFDNEMxdGFpeVc0K2srT2VEYmpYRitob2UyYnBCaHE1OENP?=
 =?utf-8?B?OHdZZ3ljbFlPQ0QyTzU2cU15bThKZmNyTVdxalJHaTlxRWJ1MDV1OXdrams1?=
 =?utf-8?B?RWdmZXdYMm9oWk4yRUhyd0ptQWxpTUhHRTdMNlE4OWtkb0M5MXQ4YzVGVTF0?=
 =?utf-8?B?MHhkV1ZQUExIQ3B2QXdFWXNpUGlHUWkrSHZwOHNyWVo5bzBjeE4xbDNVQThu?=
 =?utf-8?B?eUEvMkk0SXA4SitKRi8yZmJRQTMyMXViRXlzTnluc2NtM2RLRkRZek1TVGYr?=
 =?utf-8?B?QktLUVJFVFZETE0zZ2l5SEtZTzNFd0wrN05KS3diOFNHTm5TVlJGSElaMUFk?=
 =?utf-8?B?cVdETU5iS2dLNW5Ocnc0eUVhMWcxcDBuSFBVWHo5ODJkSzBpSHIyNUZNK3JT?=
 =?utf-8?B?Y0tJMWNwRE5RZmdMT2NRV2lGaFRoWERLL3RXZm9heUZxeGQ4aEpxY0ZTMDRG?=
 =?utf-8?B?dURmemd3akhvZm15aEIrMlFSOTlLb3pWWW92eWNwc0hjbFpseVF4NFVUL3Vi?=
 =?utf-8?B?YnIzSHRTMHIramk0cFFlQldweGRMQjlSNmlKelVDTG9vOC9mcnBRMnd6UnN1?=
 =?utf-8?B?YmY2RWNRZjIyL1FjRncvWVlZSUM1azdKRXRPd2FMZ1F0TWFROGIybHZRTHRT?=
 =?utf-8?B?c0JNWjJTbm1SdkJWZWhSTWdYTHc1U3pzNXRhQVZSUjZKUzBqRzBIdEhQcG9w?=
 =?utf-8?B?RW9SYzJWNmxtcFhXR1lHQjlQNGZoZ0JmYU1pci8yVVZkOEtjS2hSNlM1ZUR1?=
 =?utf-8?B?d3lMaFJ0WW84WkZncVFpdUZZY1BEeWhkRHdaNjhVNG5CeFJWcUEvSVdMcTVo?=
 =?utf-8?B?cFo5UVhOMEM2aHJHSlJrSm1MRk1RUk1jbDlzVTZHYmVTQjkwaG9sdktESFJJ?=
 =?utf-8?B?R3UyNWxlK3kvUzNDa2pOemZzUTh5RGtYYW0rdWR2NnJld0FJVWVCK1pVQ0Y2?=
 =?utf-8?B?ajBWbmhnL3ErQ2FCdGZRK05wcFFDczAxWVQxV2tyOEZQK3JqY1NOOEJmcUVh?=
 =?utf-8?Q?Be4iGceGbBR108Zs+A=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28f130f9-2c35-42a8-0fa6-08d8c8589608
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2021 15:30:07.1463
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +VT2BntDc4o73nHmYiBbE52unGslyb8Da2ohQptLDVNc3QnNfdbzUi35ykszMZXBxhKm897BULIGlAFtod0kGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4908
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

LS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IFBhdWwgTWVuemVsIFttYWlsdG86cG1l
bnplbEBtb2xnZW4ubXBnLmRlXSANClN1YmplY3Q6IFJlOiBbUEFUQ0hdIHNjc2k6IHNjc2lfaG9z
dF9xdWV1ZV9yZWFkeTogaW5jcmVhc2UgYnVzeSBjb3VudCBlYXJseQ0KDQo+Pj4gQ29uZmlybWVk
IG15IHN1c3BpY2lvbnMgLSBpdCBsb29rcyBsaWtlIHRoZSBob3N0IGlzIHNlbnQgbW9yZSANCj4+
PiBjb21tYW5kcyB0aGFuIGl0IGNhbiBoYW5kbGUuIFdlIHdvdWxkIG5lZWQgbWFueSBkaXNrcyB0
byBzZWUgdGhpcyANCj4+PiBpc3N1ZSB0aG91Z2gsIHdoaWNoIHlvdSBoYXZlLg0KPj4+DQo+Pj4g
U28gZm9yIHN0YWJsZSBrZXJuZWxzLCA2ZWIwNDVlMDkyZWYgaXMgbm90IGluIDUuNCAuIE5leHQg
aXMgNS4xMCwgDQo+Pj4gYW5kIEkgc3VwcG9zZSBpdCBjb3VsZCBiZSBzaW1wbHkgZml4ZWQgYnkg
c2V0dGluZyAuaG9zdF90YWdzZXQgaW4gDQo+Pj4gc2NzaSBob3N0IHRlbXBsYXRlIHRoZXJlLg0K
Pj4+DQo+Pj4gVGhhbmtzLA0KPj4+IEpvaG4NCj4+PiAtLQ0KPj4+IERvbjogRXZlbiB0aG91Z2gg
dGhpcyB3b3JrcyBmb3IgY3VycmVudCBrZXJuZWxzLCB3aGF0IHdvdWxkIGNoYW5jZXMgDQo+Pj4g
b2YgdGhpcyBnZXR0aW5nIGJhY2stcG9ydGVkIHRvIDUuOSBvciBldmVuIGZ1cnRoZXI/DQo+Pj4N
Cj4+PiBPdGhlcndpc2UgdGhlIG9yaWdpbmFsIHBhdGNoIHNtYXJ0cHFpX2ZpeF9ob3N0X3FkZXB0
aF9saW1pdCB3b3VsZCANCj4+PiBjb3JyZWN0IHRoaXMgaXNzdWUgZm9yIG9sZGVyIGtlcm5lbHMu
DQo+Pg0KPj4gVHJ1ZS4gSG93ZXZlciB0aGlzIGlzIDUuMTIgbWF0ZXJpYWwsIHNvIHdlIHNob3Vs
ZG4ndCBiZSBib3RoZXJlZCBieSANCj4+IHRoYXQgaGVyZS4gRm9yIDUuNSB1cCB0byA1LjksIHlv
dSBuZWVkIGEgd29ya2Fyb3VuZC4gQnV0IEknbSB1bnN1cmUgDQo+PiB3aGV0aGVyIHNtYXJ0cHFp
X2ZpeF9ob3N0X3FkZXB0aF9saW1pdCB3b3VsZCBiZSB0aGUgc29sdXRpb24uDQo+PiBZb3UgY291
bGQgc2ltcGx5IGRpdmlkZSBjYW5fcXVldWUgYnkgbnJfaHdfcXVldWVzLCBhcyBzdWdnZXN0ZWQg
DQo+PiBiZWZvcmUsIG9yIGV2ZW4gc2ltcGxlciwgc2V0IG5yX2h3X3F1ZXVlcyA9IDEuDQo+Pg0K
Pj4gSG93IG11Y2ggcGVyZm9ybWFuY2Ugd291bGQgdGhhdCBjb3N0IHlvdT8NCj4+DQo+PiBEaXN0
cmlidXRpb24ga2VybmVscyB3b3VsZCBiZSB5ZXQgYW5vdGhlciBpc3N1ZSwgZGlzdHJvcyBjYW4g
YmFja3BvcnQgDQo+PiBob3N0X3RhZ3NldCBhbmQgZ2V0IHJpZCBvZiB0aGUgaXNzdWUuDQo+DQo+
IEFyZW4ndCB0aGV5IChkaXN0cm9zKSB0aGUgb25seSBpc3N1ZT8gQXMgSSBtZW50aW9uZWQgYWJv
dmUsIGZvciA1LjEwIA0KPiBtYWlubGluZSBzdGFibGUsIEkgdGhpbmsgaXQncyByZWFzb25hYmxl
IHRvIGJhY2twb3J0IGEgcGF0Y2ggdG8gc2V0IA0KPiAuaG9zdF90YWdzZXQgZm9yIHRoZSBkcml2
ZXIuDQoNCkluZGVlZC4gQXMgcGVyIHRoZSBMaW51eCBrZXJuZWwgV2ViIHNpdGUgWzFdOiA1LjUg
YW5kIDUuOSBhcmUgbm90IG1haW50YWluZWQgYW55bW9yZSAoRU9MKSB1cHN0cmVhbS4gU28sIGlm
IGRpc3RyaWJ1dGlvbnMgZGVjaWRlZCB0byBnbyB3aXRoIGFub3RoZXIgTGludXgga2VybmVsIHJl
bGVhc2UsIGl04oCZcyB0aGVpciBqb2IgdG8gYmFja3BvcnQgdGhpbmdzLiBJZiB0aGUgY29tbWl0
IG1lc3NhZ2UgaXMgd2VsbCB3cml0dGVuLCBhbmQgY29udGFpbnMgdGhlIEZpeGVzIHRhZywgdGhl
aXIgdG9vbGluZyBzaG91bGQgYmUgYWJsZSB0byBwaWNrIGl0IHVwLg0KDQoNCktpbmQgcmVnYXJk
cywNCg0KUGF1bA0KDQoNClsxXTogaHR0cHM6Ly93d3cua2VybmVsLm9yZy8NCg0KSSByZW1vdmUg
cGF0Y2ggc21hcnRwcWktZml4X2hvc3RfcWRlcHRoX2xpbWl0IGFuZCByZXBsYWNlZCBpdCB3aXRo
IGEgcGF0Y2ggdGhhdCBzZXRzIGhvc3RfdGFnc2V0ID0gMSBpbiBmdW5jdGlvbiBwcWlfcmVnaXN0
ZXJfc2NzaQ0KDQpUaGFua3MgdG8gYWxsIGZvciAgeW91ciBoYXJkIHdvcmsuDQpEb24NCg==
