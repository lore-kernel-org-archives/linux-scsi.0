Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B984C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 15:29:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8B916108B
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 15:29:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240280AbhIMPac (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 11:30:32 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:18286 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242345AbhIMPaU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Sep 2021 11:30:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1631546944; x=1663082944;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qUH7NEqxVw1GVJDUVhFzQYz0wj+OZLHavzA51rk6qFI=;
  b=c2yjbScFiKcKXCnZMsYUYT0HbCqfYMQAi8etU3qxDqyLXA4dplJqjilE
   GTKfxdK4+DZui6k7aSzt02pf2Z/UVqRHcROiCMlPq4D3JFrwB/MV/KlEu
   juRBKMvdqqleUFm0oQCiSzWN/TSeNAniRcl/Rtn7X7OoHO+q3DYCQtnLC
   ExReoDeOjaO7YBcYtlO2RSuQTKTzawFagMbNqj5PKauBg0Yduwav41XDA
   I4xAbcCBBazhl/n68JK0g1zvrPMiu0LNLlf28JijLqwNwZpnKNx7oOOrC
   DU7Eqq3mulFbxsTR4rOB4sEXhsYNI4NPB2Y29DjaTVwt2YfWLYJ203r19
   w==;
X-IronPort-AV: E=Sophos;i="5.85,290,1624291200"; 
   d="scan'208";a="291483109"
Received: from mail-bn8nam11lp2169.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.169])
  by ob1.hgst.iphmx.com with ESMTP; 13 Sep 2021 23:29:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mC0kPaostmdCc4xH5RkMjvhMl6l1p0JGDIHVE6Tupu7XOFpZXctJPIQsP0CZQM9uclFLosSgJA5r+MYCpJ1fLJ2VLCLnY6MS1vgGSlsMevJgBtYGjQxrptiYkpPAN2sWn52c3/HON4Pz1aNHWMg8psRDzeYSisTI0VAj7b37rTM3BBIZM4nR/bRa/e2Zr3QfoKsi18C5u3+MSZ/WqSs0ULVuHt11hzXAzUEUu/Tg2lFknjKyj1YDZPlkNGC7hERiFH1QVSJtyBG7WugoIyOmOdgC8Bnr23JggR6fS25elO4E0HuO9CiHP11sPhiMZ8CzHfbe4BPvNujjzeyz0syvqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=qUH7NEqxVw1GVJDUVhFzQYz0wj+OZLHavzA51rk6qFI=;
 b=mSUzQPKWm1VZkU1ieKsyUfx4gDsUoX+aUjKtLnFsrj9riS9+kG0JyO+fAByKdPb1tcgWAz6YvqOPZ9RtqgUoQkzhYHtvMVOgJsR78QYXrcEuBfIWFwLtCIRLvuJCzYJTXpljMaGRGQ/ac8z60wv1rbr8wIbBwIQvo1xRhaQvuRmlB/WFLCTev5L0F3U/BmWeKA2knpvivoZkFY76nSMvoUTLazLBQEBEqU/7rEdQzCdnzdy/UT7fYwBkUU1OQ2fuVap6ps3H4pnOnCEGjNWLjRTasm9yLq8EVD/5/nM+ydh08IiSTPjjTr6A1AATzm3hGis0ZeRIOkC5JHAnwh4EIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qUH7NEqxVw1GVJDUVhFzQYz0wj+OZLHavzA51rk6qFI=;
 b=UYufkwzss8FxpkvRxMlJPz0kha12YJ3la5JO/aDpKh8Vgjj6XI6RtArloCd4eoY7e5Ox6plxce521gUCzI4q3Mlu/wwEEDY+8wFofovjI+JdT115ktNz6ARrIM359pS71Ts555EfN5gYggumOZzxJ64Ga5P5OTxMKJL8cDxvI1w=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB1117.namprd04.prod.outlook.com (2603:10b6:3:a7::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4500.14; Mon, 13 Sep 2021 15:29:00 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59%3]) with mapi id 15.20.4500.019; Mon, 13 Sep 2021
 15:29:00 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Guenter Roeck <linux@roeck-us.net>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bean Huo <beanhuo@micron.com>
Subject: RE: [PATCH v4 1/2] scsi: ufs: Probe for temperature notification
 support
Thread-Topic: [PATCH v4 1/2] scsi: ufs: Probe for temperature notification
 support
Thread-Index: AQHXqKP4leima191EEOYRt+yivFLm6uiCocAgAALv4A=
Date:   Mon, 13 Sep 2021 15:29:00 +0000
Message-ID: <DM6PR04MB6575C0E14F4C6BF0000B770FFCD99@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210913133303.10154-1-avri.altman@wdc.com>
 <20210913133303.10154-2-avri.altman@wdc.com>
 <e6b6d94a-9399-89e7-d9da-810fb9e179d7@roeck-us.net>
In-Reply-To: <e6b6d94a-9399-89e7-d9da-810fb9e179d7@roeck-us.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: roeck-us.net; dkim=none (message not signed)
 header.d=none;roeck-us.net; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0b485fbc-a3b9-41fb-6106-08d976cb35bd
x-ms-traffictypediagnostic: DM5PR04MB1117:
x-microsoft-antispam-prvs: <DM5PR04MB11170B9A4CEF5B47075EC25FFCD99@DM5PR04MB1117.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dC4mtHZC6hj2SzLE4it5ROOJlDX2jdZAjXTOCnSJrFHaoGfZbC039YZNPMC7Z3PAq7T1iC9At+YAQ6kuW+YFXjMM+BIo94C9x43HMXWUsslWDsLfjfhTrmhGBuSpUIDw3Ht3ZaJY04vtN9wyTx6eXCvlEM7Y5sK9PnE6oGVfcotIDRHwEBwV6e+JbiKWhFNoR40WH6aaZya9dvDPW2dcTu+O0o8TtKC2OK9dYfLt5cjCrcN5owLuS6ejdrv9LLvziECFtAsAcDrtS9Qb7KXOY95ADGiB4+vVb/t1k52miH31orvZyJRohqFAnzmEOAN8t2G8rvtOVMnr0Z5SCwY46DqNQPUltY4zXaqXIld40T0TNIza2yPQgqeWtz0f/1kt4tYHyq0PFBta6GzkfI1aUaUuI54HbYaCfsEZo5MxyFXFMmFXYZZ5jxu/SOUoC/eux6JhbVYpjUba3paFoQsVqi7zVcMe1LBcRHGNau1w1E2lsxsOdG456v0s4BBWS5kO+PKjkoZKWQ5eJxRuH4KC9L4ozPZE+SGqdWzPa+IGKP6jT7VqYN8k+ZcYsJvydsdMWNmZUgBIG6XsBuQ7AX9dtHG7PPA1X5irnSktDlWTXmx4gdoE6/OQL3Z6wVR+wNrbFIhs+0KyG1zZKfhoKqTH6sA54OBHVcvUf8STkLu2S/R+qxoj032mN+mKZ8s4c0tyPinPWX3NNj9+UpUiDQFMMg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(376002)(396003)(39860400002)(7696005)(33656002)(38070700005)(83380400001)(8676002)(66446008)(6506007)(86362001)(54906003)(478600001)(71200400001)(64756008)(8936002)(122000001)(186003)(26005)(316002)(2906002)(5660300002)(52536014)(66556008)(9686003)(4326008)(66946007)(110136005)(66476007)(76116006)(55016002)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M2Q1OWY4YStRVTd1bHJadXpKNUU2ci9UN0ZtTmMzMnhWWURDTS9kWGZyV3dN?=
 =?utf-8?B?WThhM2tYMWVYTWJZMlJvK3FQK1F5YmNyUTBwR1RCanFjbHdLWTBzbmowWEps?=
 =?utf-8?B?RDl1bDN3VkdXRytIT0pLbStwMGpJdDhpNTh5cW9rdTU1aEdwcU9OL2ZmZ2g1?=
 =?utf-8?B?UDBsT2hFR3dSMUZRN1JvK2pIdk16M3UvOWxZaEV6V2ZVQVZoU0tJcWFFZWZI?=
 =?utf-8?B?dDQyUDgzMzJicUdNa1VBSjJnZmE4RHg2aTMrSFZnY0VmcHptaVBabEYyWjg0?=
 =?utf-8?B?WmJCaExkYndWNVJNOGwvOVBEb0JvTng5UUpBaGRrV1VwWUVKV3ZudlFsMDV1?=
 =?utf-8?B?YkprdFQzdmthb3ZPYXRFeFFTRXVrNXozWnk0ZjZUYUF5anQ1N2xja1dZcHNi?=
 =?utf-8?B?eW5uV3JyY29OSXdwNFB0aWkzYlRpVzFUMGZic3NYZ1ZsNlkxWjI3ZFJiRCtI?=
 =?utf-8?B?dE9QRGZXMkxhTjVvckIzNnJlYnNsNnVSNUNqb1NjcVovUjBCRHdKOUZJc3VL?=
 =?utf-8?B?bFRvUWdrUU9VRHNVTDdnT2ltM0wyZlJjRWhoYmViZVN3WWZSaWNqQVgzMCsr?=
 =?utf-8?B?Zyt0bEVmc2pSSGk3Tit1L0RZQmdlbmhnOXl6L3Y2SFJFdktSME56bTl6M3cy?=
 =?utf-8?B?Y0lRMUUzMmFZaEhBYTVOV1Jqam9QbGRxdURvQXIyME1XMjQ3MHYyRzhGU3I0?=
 =?utf-8?B?em5GS2d4Mno3YUtzY0FKeW5iZXZyK3hLSHdBNGxzaTF0YldvNmMwUFp6bmxM?=
 =?utf-8?B?T2dOVG5qaXJpdGJ5Z1VTM0dhN0lhOUFraWlMaU1JM3hTQk1VTXd1Y25mUGlt?=
 =?utf-8?B?QjVxUTNxTkZaclQxaVg3VHUzU2NZSmNlZC9Pak0vb1F2OVdYTGFQTlptSjhx?=
 =?utf-8?B?bURGdmlRRjI3SlNVR2tUYUwwZlBmWHd6SWpENWhMY2hWbC9xeXpHK0NlQ0lL?=
 =?utf-8?B?OC92Y2pib2JMbjJocklDZjAzTDUvMmpNbkIreFRvMC9wcnZKNnRTSzUzdExT?=
 =?utf-8?B?NVFvUHBJVnp2QnY5eWhkeWVpcHNOejVySlZ6S1BydEltNUE0TE5MM3VET1FB?=
 =?utf-8?B?NmhaTWJvMi9LcmpVeGFONUZEdlRpT0QrYnZhRHlzVXNwSS9yeEpVMVpsMkFV?=
 =?utf-8?B?d2pqWWNBbCtQR0lLNTkxZy90RDN5MUpFVFM5aHVEL2pSZWExOCtzTHRSdlFn?=
 =?utf-8?B?NnRoM3U4YWhRd2k4Z3lZWmdITlhWZTlYTC9NVHROWk9lZFIvOXlENzUvZFJ6?=
 =?utf-8?B?SUoyMXl2ZGl6ajRRa0lkRE5ldkZIV3BaWVdrUldmRVo3MlBVN0RwSzdvSzVE?=
 =?utf-8?B?YytPY2ZKeGRDaHR0Rnc5cDJZeEthN29laERwL2pNMVNGQ2FSY3NvSkJsQlE5?=
 =?utf-8?B?WDluVkZ1ZWs1Q29MWUREUTQyc0RseGlvRFN3VmRoSmhIZHpPcTdUQVFueHFn?=
 =?utf-8?B?MkEvNEFkRjB1VFRBREZramtLTVpEQVJPSStuOW8rTUNma0FLeWRXdHVwODIx?=
 =?utf-8?B?THZBR2JhK1RhekNWVlVlZWI0YS9SdXhhUHphcWlocHc5dHB1SlRaQ2lsSTNE?=
 =?utf-8?B?bE9hZjlXeW95MDlEeUtkbTJLVXlrdnVmaHV0bTdEdk9vamE2MGtRMEUvM0Nv?=
 =?utf-8?B?aVpPWDB5RGs1MTViY2ZGcm5sVE1WNlEzNjN2UWhCWmpzalFJTjhTVXhYd2Vl?=
 =?utf-8?B?ZGZTZXVaNTlYd1NWV2l0ZWlIMCtmMDBpU1AvbThxS0kxVmZHRGFETWo1aElD?=
 =?utf-8?Q?DjT0aZKrrgCyX/L+hefrc5W3Q5NyJuk6z0TnWXz?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b485fbc-a3b9-41fb-6106-08d976cb35bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2021 15:29:00.0353
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: roPUuRXxdYckM3VKncb3rImdacxi7k3qsPSuwxilBSiEz5P4lkHn3bDkSW5MitN3Dj5LPEeYuLnRrRjYB4Izzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB1117
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiA+ICsNCj4gPiArc3RhdGljIGJvb2wgdWZzX3JlYWRfdGVtcF9lbmFibGUoc3RydWN0IHVmc19o
YmEgKmhiYSwgdTggbWFzaykgew0KPiA+ICsgICAgIHUzMiBlZV9tYXNrOw0KPiA+ICsNCj4gPiAr
ICAgICBpZiAodWZzaGNkX3F1ZXJ5X2F0dHIoaGJhLCBVUElVX1FVRVJZX09QQ09ERV9SRUFEX0FU
VFIsDQo+IFFVRVJZX0FUVFJfSUROX0VFX0NPTlRST0wsIDAsIDAsDQo+ID4gKyAgICAgICAgICAg
ICAgICAgICAgICAgICAgICZlZV9tYXNrKSkNCj4gPiArICAgICAgICAgICAgIHJldHVybiBmYWxz
ZTsNCj4gDQo+IFRoYXQgc2hvdWxkIHByb2JhYmx5IHJldHVybiB0aGUgZXJyb3IgY29kZSBmcm9t
IHVmc2hjZF9xdWVyeV9hdHRyKCkuIEkgZG9uJ3QNCj4gc2VlIGEgZ29vZCByZWFzb24gdG8gaWdu
b3JlIGl0Lg0KRG9uZS4NCg0KPiANCj4gPiArDQo+ID4gKyAgICAgcmV0dXJuIChtYXNrICYgZWVf
bWFzayAmIE1BU0tfRUVfVE9PX0hJR0hfVEVNUCkgfHwgKG1hc2sgJg0KPiA+ICtlZV9tYXNrICYg
TUFTS19FRV9UT09fTE9XX1RFTVApOyB9DQo+ID4gKw0KPiA+ICtzdGF0aWMgaW50IHVmc19nZXRf
dGVtcChzdHJ1Y3QgdWZzX2hiYSAqaGJhLCBlbnVtIGF0dHJfaWRuIGlkbiwgbG9uZw0KPiA+ICsq
dmFsKSB7DQo+ID4gKyAgICAgdTMyIHZhbHVlOw0KPiA+ICsNCj4gPiArICAgICBpZiAodWZzaGNk
X3F1ZXJ5X2F0dHIoaGJhLCBVUElVX1FVRVJZX09QQ09ERV9SRUFEX0FUVFIsIGlkbiwgMCwNCj4g
MCwgJnZhbHVlKSkNCj4gPiArICAgICAgICAgICAgIHJldHVybiAtRUlOVkFMOw0KPiANCj4gdWZz
aGNkX3F1ZXJ5X2F0dHIoKSBhbHJlYWR5IHJldHVybnMgYSB2YWxpZCBMaW51eCBlcnJvciBjb2Rl
LiBJdCBzaG91bGQgYmUNCj4gcmV0dXJuZWQgYW5kIG5vdCBiZSBvdmVyd3JpdHRlbi4gQmVzaWRl
cywgLUVJTlZBTCBpcyB3cm9uZyBpbiBtb3N0IGNhc2VzLiBJdA0KPiBpcyBvbmx5IGFuIGFjY2Vw
dGFibGUgZXJyb3IgY29kZSBpZiBwYXJhbWV0ZXJzIHBhc3NlZCB0byB1ZnNoY2RfcXVlcnlfYXR0
cigpDQo+IGFyZSB3cm9uZywgd2hpY2ggaXMgc3VyZWx5IG5vdCB0aGUgY2FzZSBoZXJlLg0KRG9u
ZS4NCg0KPiANCj4gPiArDQo+ID4gKyAgICAgaWYgKHZhbHVlID09IDApDQo+ID4gKyAgICAgICAg
ICAgICByZXR1cm4gLUVJTlZBTDsNCj4gDQo+IEFzIG1lbnRpb25lZCBpbiBteSBvdGhlciByZXNw
b25zZSwgdGhpcyBpcyBleHBlY3RlZCBpZiB0aGUgc2Vuc29yIGlzDQo+IGRpc2FibGVkLCBhbmQg
dGh1cyBzaG91bGQgcmV0dXJuIC1FTk9EQVRBLg0KRG9uZS4NCg0KVGhhbmtzLA0KQXZyaQ0K
