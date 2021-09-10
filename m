Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7432C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 15:58:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9741E611CC
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 15:58:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234634AbhIJP7T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Sep 2021 11:59:19 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:49982 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234553AbhIJP7S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Sep 2021 11:59:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1631289486; x=1662825486;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zfjuogO2D1iKkQU+9x7EOJYF7T0Vx+7hoXavneBtUVo=;
  b=P9ruq7xnUT16h6f5yOcfhZcd1z4W9w/2cd05MBw8CiiOqXUAaFs41i1R
   AzwsQ3/lNLH47wGuG7P8zdL3mBYRaCspo5xYtIAGp72yNpOXKlZIuClvF
   NZ9pf/MpJ/lenr9YfuW/EpU64i1zB/KvVx94eSKEdc3Fda9kBFG4gogPn
   QYfjE4XcCFeC+2Z8ic92KmoK5wWtm+qND7Ce4QQTaTTB6T0dqW2AxOvZE
   wvvLgYsE6tCiVgElIj/4qkmlN6/8oC1I22a4mbXLx+3LlseRY9R7tbbAM
   5xKBEt6t80+uPZ/tqpseV309dJoodN3LZaeNbfihkNUHTzgMO1kuN4rPx
   g==;
X-IronPort-AV: E=Sophos;i="5.85,283,1624291200"; 
   d="scan'208";a="184477184"
Received: from mail-mw2nam12lp2042.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.42])
  by ob1.hgst.iphmx.com with ESMTP; 10 Sep 2021 23:58:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X0PzTMgSIYQCyLezYfqzM1BKewD+ZAh8+jXvAGeN4shki21NNZ8O9cAt4vpVclyws+C90tZA69TvkcuDFJF+iHphOt/fxCP845KcZjK8EXUBS8LNZA1R68urxuchNfojDrHaOPz8d7iExfyMSKgTQfoxbE4h4PmtCF/cgo0kbgnf97Hn2DOHjax/hmJ4Kl7mwE2/OJqGFG0XVoaClPEwATzsg61TP7NccC6b/He5cHueM52VnKC2TqUb4dsVL6RetvONevGZZxLruxoNcxOgxRQCckNPqnr8j/P0kE7KUWysCTvB72J8nJ5F0sI/vMct76/l4A8tD8kALsEzFRm3Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=zfjuogO2D1iKkQU+9x7EOJYF7T0Vx+7hoXavneBtUVo=;
 b=UmOgrZmPx09n6E8uoQSR84uSFP77kzTPA4mRvjSX6XVEv+HrzxG6c4lXP/9vwabHxBPWMai3RKKQj4T+z30JN0KXON5RPHZRq4FDSZmMbQG4KBEY1yUNWSe6a7q9ZUIevZfaush1xpfWue4rKpEefhJnHie8xfqorsm1a9bF7mkq2Vf9/kL/sZIb3k1JgvdxynrJ48/oFvfl2Pje32DUNnaw4gk0wKflfa0RQtaG+8fwEgM0aTpXeJMJT9dBC5EGvKuFmEua0DHLAMNhL8KFhtXSRu40iEHnPzbLrUFZ/NaF+XkgNdIjLgzZAQshwCoSWDS8EENZEl4StYDpzUR3IA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zfjuogO2D1iKkQU+9x7EOJYF7T0Vx+7hoXavneBtUVo=;
 b=dYxtCFEeVgW6j6IBAHNUPtxRAUAhzI6kCmrKKVXfp8AwD1GYacukFLTTdXme5VBVIYNqIGorJfL/vRZh9f4SXlNiBDKRAd+UKzJYqiEwoGCz0FDCS/LBZNh89+IWjagmynOB6N6vgtqRsNXZDjJ4ll5GftgGdzqA/J6I4zRB7LQ=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB0859.namprd04.prod.outlook.com (2603:10b6:3:f6::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4500.14; Fri, 10 Sep 2021 15:58:04 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::8848:bb12:e9dd:af86]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::8848:bb12:e9dd:af86%7]) with mapi id 15.20.4457.024; Fri, 10 Sep 2021
 15:58:04 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: RE: [PATCH v2 1/2] scsi: ufs: Probe for temperature notification
 support
Thread-Topic: [PATCH v2 1/2] scsi: ufs: Probe for temperature notification
 support
Thread-Index: AQHXpUTh8Dhuh0oH5EaZbJTkdwCAEaub5HyAgAGJiZA=
Date:   Fri, 10 Sep 2021 15:58:04 +0000
Message-ID: <DM6PR04MB6575DF7D8FDE8D476157337BFCD69@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210909063444.22407-1-avri.altman@wdc.com>
 <20210909063444.22407-2-avri.altman@wdc.com>
 <1b31a30a-cf2d-240c-78c1-ff348178f259@acm.org>
In-Reply-To: <1b31a30a-cf2d-240c-78c1-ff348178f259@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ba984f8f-088e-4ff2-0677-08d97473c64c
x-ms-traffictypediagnostic: DM5PR04MB0859:
x-microsoft-antispam-prvs: <DM5PR04MB08599C7D44D4294B3FE38A95FCD69@DM5PR04MB0859.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Rt1SHyhohF3k+61gz3vQEnq/fP8gTR9L2SS6Ijc/rWEaj6NptEEoPU/JagwX+PdU5Ym0/oUX8+RBzqSamOGLNe+TXadunaMCgPwRuBNggKKGajx+hvkIAvalXvsPZ+JA4dqDN2mLB0TMmrtPTNcJKHlGjQzeD2dEyVfRXdwLteJolwI7QkSoHjR7+UPHnjFa55HuwzgA1JoRGi1vhObBS9jcWPLv1lgla4Q9l9CnjsgJ5xBPBds6YkUHINWKzOrGeTc6Ee+dlcp503Ap2OR1h9RBdTFQE3TyQ2tx+8fhPVm3XFMiHNkiWHUTRnFtNexugJs7YyvpKvi9s6Eq4S11dD35vmvZKreJbbcj2rVElrrb11D+BP0nEWitP1RJCaZ3PoK1cxEom3X5ipaGNxbCDe57lC2faF3SDFwqiwKBjIDb45bt2XNreFC3NABvNsYuVw09sCuLPlwZ/lGlhy0xNWTciFy7kHOo+6WPBFqPttFnJStjnzT/mQx+oOMpzguXZgbns32XE1n5duMyvBxT7pxJbea3R9bizCV3uzdigmG9SXwy+igoDGfbWDjHFbL9cZ37ukOWM1VquxeSh/lcrIsHZJl3wv15CVjlJOAm07oWvttcIny/3yFagztyG4q8vt0xfDRHVcptyJcFcwjmeL4uQSc5CqVrFEqD/NnD8ZTCzWXjRzx2YZ4PfRXIz7erNhSZjs6KXrxnIV3fMoBjqA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(39860400002)(346002)(366004)(7696005)(38070700005)(66476007)(26005)(66946007)(8676002)(33656002)(55016002)(9686003)(186003)(6506007)(53546011)(52536014)(478600001)(38100700002)(4326008)(66556008)(76116006)(122000001)(8936002)(316002)(71200400001)(2906002)(54906003)(110136005)(66446008)(86362001)(5660300002)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NEJxeXo0aHlhNlkzQm9rVGRIaVBuMUU3SkxaemhVTko0aGRZK004dTlVY29D?=
 =?utf-8?B?Rk9wM3JsYXlHdmFGY0swbFN4MXgySXZjend3VjhBWUxIMElsSzdqeXlYQkx2?=
 =?utf-8?B?VytYQWtUZTYrTVNrbEl3VVF6Y2pnY0ZVWTdnS3FobXpHRzdjZTlYeEtKY0R3?=
 =?utf-8?B?ZlY0K2xZbkozcmhFMW1QVzhBNlEvZEJiT2VKby9TbmlvYm1DdzNCTzU3anpX?=
 =?utf-8?B?RStkcWhwb29DSHhMbzBsMTdVcW9yMWNQS3F3czFjYUN3VU11YUQ4dWgrOFVS?=
 =?utf-8?B?bU5pV2swTVQwT3FtUEI4b0p2UzkvdkJFbThIOTl0NWlvRFI1eWRreUI1MjNp?=
 =?utf-8?B?cU1zZWJBQ0tUT09ScEhlNWYybXhsTHFyMlhkK2hjUEtHNlV3Zm9KK1F2WlZp?=
 =?utf-8?B?SEpvWXFuZFB3NFNQSXM4VmNmakJMT1ZaQUFLdTByb1FXNjh0Yk5hV0xSQnRt?=
 =?utf-8?B?VHFUaSs1V0paN0FNV01ETVFqUW9kTUExUjZyNkFYbTRRMDRjS0VLd1o2cEN3?=
 =?utf-8?B?U2xxTGxZNS9oTll0RnJRY0hQbTVnb3lIV3JzeU5jOVhFN1BHYUY5em5yZGRt?=
 =?utf-8?B?aTlTS0tZR3pyOWVTcXpaWW1jMkhvVGhTM0hMQTg5NXBMZzhmTEZOaXQvbUdj?=
 =?utf-8?B?WXpKcWVqTFdkNll2Q0c3ZE4rdVFtcUprL3kremxTZTd2VWxXaVFWdDQzVjNG?=
 =?utf-8?B?anhpNCtjRTVEZjN1eDFRdVpLUjI4cDBiNlQwcEVVYWQ3RHJiMFRWSFBKblJ1?=
 =?utf-8?B?Qmh5aEZadzF0cDBRSTNmT2J2T1RsOGFVMEg2a1BrVzFSd1V1RjVoNGJoRGRH?=
 =?utf-8?B?Tjk3dFhEd3NiWUE5QzZZNVYxRG9QODQ1Uk5hWWlPTzI4V3EwdDA0QTkwSzZv?=
 =?utf-8?B?L3VYRlFqTXlKUjVQUklWemNnWGU4c09PbkRodVBsQnVCbDgvZ0RpdWNrYzBJ?=
 =?utf-8?B?Q05uSEpsRTFFMkx3a3ZKNFVDdUVIZmM2MU5MUC80eU9rVjV4ay94bE1INEVP?=
 =?utf-8?B?TWIzYlk5VERWbjFYYUJHM2pldkpSb0pBaXd5SjJXbzZBdTlKRUFQaXRSUWNa?=
 =?utf-8?B?bDJKWGJHM0pmRFprSUZsNXNBa3E5YTRRUmNzMjUvUGpzMmJmbkJkOTlmVkp0?=
 =?utf-8?B?TkMvekNZN1JLV0EvTGJhaDNQME1DZGFWRjdPbXg5ZzdJa0ZTQ2prQjBlRlFE?=
 =?utf-8?B?VS8vR3VvdDZFTk13ZVdaZlJOM2JuMTJ0THlDenlxVFNzTi9NMmswcnQycmxF?=
 =?utf-8?B?WE1IaWlrN0RKbUd1SXFkL3JoNmpremJvWWQ3dHU1UnZTSzh1bWlCbFdLZys3?=
 =?utf-8?B?Rkc2dUlDcUlCclloT1JJSm05aXJ5MkE5eGxKUjhxd3NMN0VFQ2FuY05rU0Ja?=
 =?utf-8?B?MnRkSUNnbzIvOGYxdm5qWjBuOWMza3VCeElSTHRsT1h4ZmlDbGJzUGRpSFFp?=
 =?utf-8?B?V3R4WVBPUkV3dnBOTDZ5Q3JNaU9rbnhpUENGNHFDZC9hUEoraFpZYWlKejZK?=
 =?utf-8?B?S2lmeHFaeXRJaWpqVWZ2OGRlMnpyZ1o3MlkyRU9xNzE4enVBSXlEYmxQSEVS?=
 =?utf-8?B?bXF3MGxGeHNGdWNja01hWHRVRysyWmxGZjI3T0hoNGJUZnlid0JRajlibE5P?=
 =?utf-8?B?VWFpVmtiSWVuY3VPYXBkSVRmbG1LcEdRYXhVMVJxdUhVa0F6S2RwV28rTmRO?=
 =?utf-8?B?NmpJd2RkTzF2b0J3R0xRNDVncUVJUzNzV1hmUnp4VFd3NFpqalNxSVVZY3k2?=
 =?utf-8?Q?XdCFCwJqorWy8cP7erIocqAWRR8AYdvbEsQYMuB?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba984f8f-088e-4ff2-0677-08d97473c64c
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2021 15:58:04.4955
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bPQUw6JLhX5ABJyPwRSmUlUqTUFFRrqf6MiB9cINi+l1JmxYnixfE4QSdOway/n6rg4t0YGGIK68vUpJDct/FA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0859
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IA0KPiANCj4gT24gOS84LzIxIDExOjM0IFBNLCBBdnJpIEFsdG1hbiB3cm90ZToNCj4gPiArc3Rh
dGljIGJvb2wgdWZzX3RlbXBfZW5hYmxlZChzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBzdHJ1Y3QNCj4g
PiArdWZzX2h3bW9uX2RhdGEgKmRhdGEpIHsNCj4gPiArICAgICB1MzIgZWVfbWFzazsNCj4gPiAr
DQo+ID4gKyAgICAgaWYgKHVmc2hjZF9xdWVyeV9hdHRyKGhiYSwgVVBJVV9RVUVSWV9PUENPREVf
UkVBRF9BVFRSLA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICBRVUVSWV9BVFRSX0lE
Tl9FRV9DT05UUk9MLCAwLCAwLCAmZWVfbWFzaykpDQo+ID4gKyAgICAgICAgICAgICByZXR1cm4g
ZmFsc2U7DQo+ID4gKw0KPiA+ICsgICAgIHJldHVybiAoZGF0YS0+bWFzayAmIGVlX21hc2sgJiBN
QVNLX0VFX1RPT19ISUdIX1RFTVApIHx8DQo+ID4gKyAgICAgICAgICAgICAoZGF0YS0+bWFzayAm
IGVlX21hc2sgJiBNQVNLX0VFX1RPT19MT1dfVEVNUCk7IH0NCj4gDQo+IFRoZSBhYm92ZSBmdW5j
dGlvbiB1c2VzIGRhdGEtPm1hc2sgYnV0IG5vdCBkYXRhIHNvIGl0J3MgcHJvYmFibHkgYmV0dGVy
IHRvDQo+IHBhc3MNCj4gZGF0YS0+bWFzayBkaXJlY3RseSBhcyB0aGUgc2Vjb25kIGFyZ3VtZW50
Lg0KRG9uZS4NCg0KPiANCj4gPiArc3RhdGljIGJvb2wgdWZzX3RlbXBfdmFsaWQoc3RydWN0IHVm
c19oYmEgKmhiYSwgc3RydWN0IHVmc19od21vbl9kYXRhDQo+ICpkYXRhLA0KPiA+ICsgICAgICAg
ICAgICAgICAgICAgICAgICBlbnVtIGF0dHJfaWRuIGlkbiwgdTMyIHZhbHVlKSB7DQo+ID4gKyAg
ICAgcmV0dXJuIChpZG4gPT0gUVVFUllfQVRUUl9JRE5fQ0FTRV9ST1VHSF9URU1QICYmIHZhbHVl
ID49IDENCj4gJiYNCj4gPiArICAgICAgICAgICAgIHZhbHVlIDw9IDI1MCAmJiB1ZnNfdGVtcF9l
bmFibGVkKGhiYSwgZGF0YSkpIHx8DQo+ID4gKyAgICAgICAgICAgKGlkbiA9PSBRVUVSWV9BVFRS
X0lETl9ISUdIX1RFTVBfQk9VTkQgJiYgdmFsdWUgPj0gMTAwDQo+ICYmDQo+ID4gKyAgICAgICAg
ICAgIHZhbHVlIDw9IDI1MCkgfHwNCj4gPiArICAgICAgICAgICAoaWRuID09IFFVRVJZX0FUVFJf
SUROX0xPV19URU1QX0JPVU5EICYmIHZhbHVlID49IDEgJiYNCj4gPiArICAgICAgICAgICAgdmFs
dWUgPD0gODApOw0KPiA+ICt9DQo+IA0KPiBTYW1lIGNvbW1lbnQgZm9yIHRoaXMgZnVuY3Rpb24g
LSBpZiB0aGUgYWJvdmUgY29tbWVudCBpcyBhZGRyZXNzZWQgJ21hc2snDQo+IGNhbiBiZSBwYXNz
ZWQgYXMgYW4gYXJndW1lbnQgaW5zdGVhZCBvZiAnZGF0YScuDQpEb25lLg0KIA0KPiA+ICtzdGF0
aWMgaW50IHVmc19nZXRfdGVtcChzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBzdHJ1Y3QgdWZzX2h3bW9u
X2RhdGENCj4gKmRhdGEsDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgIGVudW0gYXR0cl9pZG4g
aWRuKSB7DQo+ID4gKyAgICAgdTMyIHZhbHVlOw0KPiA+ICsNCj4gPiArICAgICBpZiAodWZzaGNk
X3F1ZXJ5X2F0dHIoaGJhLCBVUElVX1FVRVJZX09QQ09ERV9SRUFEX0FUVFIsIGlkbiwgMCwNCj4g
MCwNCj4gPiArICAgICAgICAgJnZhbHVlKSkNCj4gPiArICAgICAgICAgICAgIHJldHVybiAwOw0K
PiA+ICsNCj4gPiArICAgICBpZiAodWZzX3RlbXBfdmFsaWQoaGJhLCBkYXRhLCBpZG4sIHZhbHVl
KSkNCj4gPiArICAgICAgICAgICAgIHJldHVybiB2YWx1ZSAtIDgwOw0KPiA+ICsNCj4gPiArICAg
ICByZXR1cm4gMDsNCj4gPiArfQ0KPiANCj4gU2FtZSBjb21tZW50IGhlcmUuDQpEb25lLg0KIA0K
PiA+ICt2b2lkIHVmc19od21vbl9yZW1vdmUoc3RydWN0IHVmc19oYmEgKmhiYSkgew0KPiA+ICsg
ICAgIGlmIChoYmEtPmh3bW9uX2RldmljZSkgew0KPiA+ICsgICAgICAgICAgICAgc3RydWN0IHVm
c19od21vbl9kYXRhICpkYXRhID0NCj4gPiArICAgICAgICAgICAgICAgICAgICAgZGV2X2dldF9k
cnZkYXRhKGhiYS0+aHdtb25fZGV2aWNlKTsNCj4gPiArDQo+ID4gKyAgICAgICAgICAgICBod21v
bl9kZXZpY2VfdW5yZWdpc3RlcihoYmEtPmh3bW9uX2RldmljZSk7DQo+ID4gKyAgICAgICAgICAg
ICBoYmEtPmh3bW9uX2RldmljZSA9IE5VTEw7DQo+ID4gKyAgICAgICAgICAgICBrZnJlZShkYXRh
KTsNCj4gPiArICAgICB9DQo+ID4gK30NCj4gDQo+IFBsZWFzZSB1c2UgdGhlICJlYXJseSByZXR1
cm4iIHN0eWxlIHNpbmNlIHRoYXQgaXMgdGhlIG1vc3Qgd2lkZWx5IHVzZWQgc3R5bGUgaW4NCj4g
dGhlIExpbnV4IGtlcm5lbCAoaWYgKCFoYmEtPmh3bW9uX2RldmljZSkgcmV0dXJuKS4NCkRvbmUu
DQoNCg0KPiANCj4gVGhhbmtzLA0KPiANCj4gQmFydC4NCg==
