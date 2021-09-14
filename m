Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4BB6C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 11:53:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 880CB610A2
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 11:53:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232156AbhINLzF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 07:55:05 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:25576 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232065AbhINLzE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Sep 2021 07:55:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1631620425; x=1663156425;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=0JCiC1II5E5/buA8SqNoNBN7S+GAMFaNx52QtpN0KCM=;
  b=JDJzTxNbXajD/psjofm6Map+rJTPScI7bJKe5zzFOArKXEfp88QQ7FpH
   rHcIw83kAXwSJr/vrUjTuD3ri5e6+bn6RH9myTMiXGQ0L9/siph4Hafb0
   nGESQDeNcRhBBKEHEV8ptqhWyYh7375mCRPSfdIOuK8lHqxppERT8El9G
   TpWIVegTh9/Z/BISmUCYWKJAkFLLybGheNhmR72G/Yl0buQ3Lwlw60/fv
   aD7tK2Ju5ZGqrh9fAFfP/5TGz8YZf4PXzIZ3ANZhxBAgGKpaURE9U2owk
   SfdAR2vbTFbYw/CTby2QaE7RAPtXARHBXc1ZqcbU4cRvo1qW3yCzSyUT/
   w==;
X-IronPort-AV: E=Sophos;i="5.85,292,1624291200"; 
   d="scan'208";a="184751345"
Received: from mail-bn8nam11lp2176.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.176])
  by ob1.hgst.iphmx.com with ESMTP; 14 Sep 2021 19:53:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HgKIJCJK5qgLRj2cy55He+WNuQhXMBngmWJajp5QTzRMY7cU2x4tscvRmb3CSvA9X59WtOOUTkRUmH2aOztgKPm6HalZ1SNSCa4OHXq/SXKPuZ7av8Z/gV5LV9VRt69ygD4LIwmqNmTjTVjV4rDw4L59j+F4Z8Z48VsEFu+uXbcdVd26w+DQe9iwl1Pz7QSZlptx9ajP8x9/Pji8DMUXzZ+je5YVevtm8ORCL59HzQBVJWLu9s191+dIf+b07MHFFpx4StI5B7WRLC2XpMBCgd2buUdpM3tgge1pi6s4wGJmL+L9EtGNIJFboYVL5rKD4bMVyRZVF3m8M0mMMd4zqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=0JCiC1II5E5/buA8SqNoNBN7S+GAMFaNx52QtpN0KCM=;
 b=Zp3ukwxpXVt7tzin006HMD/+MfKgsUEBFmT01Bm+VWrx6qfB8rF2WSKiwQyo5lofwJgxoodauTURhw59lBg9JS8gxYyrpUWGsUBR+5TuxAI4lGOo9iayVEscx380zRiFrRg+Z5qEYn5aWGMWPHxe9tbTBs0GomahaS8yXf7h2NO94pFujqbJsYe9ZxFORixDBsCqMEMhJjAQ6860JOtS3UY2itmthFLm0SdB2g4hJ94oZJANqm09ueCzn52D3lLwEZaxKMOPwyIfQzg3dNhY92R1EO6WgF7MY91hkRbfHSDsE7MSFwYAajlTmIo7LXghnrYHYnN+FwtZSKfSRRkC5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0JCiC1II5E5/buA8SqNoNBN7S+GAMFaNx52QtpN0KCM=;
 b=moTf26uN8pSN+m4YJI/D7ftVptBoRw07PITpt7DLaZM46WML2DizePIcKZs7HySvGFkov5FI8038Ivi3/WbnV6mGSppCFM8AdKQ0ezt09exNVEw1PPCSmee4QZWUaTwrsiThiG0UvN16HyBF5VaoxzFXoQ1vxlfXdusRiZirRPo=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4491.namprd04.prod.outlook.com (2603:10b6:5:1f::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4500.18; Tue, 14 Sep 2021 11:53:44 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::edbe:4c5:6ee8:fc59%3]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 11:53:44 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
Subject: RE: [PATCH v2 1/3] scsi: ufs: introduce vendor isr
Thread-Topic: [PATCH v2 1/3] scsi: ufs: introduce vendor isr
Thread-Index: AQHXqHcMN8ipEwPnik6KSX5UOiWXZKui4OUAgACMIoA=
Date:   Tue, 14 Sep 2021 11:53:44 +0000
Message-ID: <DM6PR04MB6575324A3F4E2C040BB46864FCDA9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <cover.1631519695.git.kwmad.kim@samsung.com>
 <CGME20210913081150epcas2p11f98eed5939bf082981e2a4d6fd9a059@epcas2p1.samsung.com>
 <6801341a6c4d533597050eb1aaa5bf18214fc47f.1631519695.git.kwmad.kim@samsung.com>
 <c6b2007b-155b-18b2-e45d-06f600c98797@acm.org>
In-Reply-To: <c6b2007b-155b-18b2-e45d-06f600c98797@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f7f03f3b-c73f-4a18-df1c-08d977764db6
x-ms-traffictypediagnostic: DM6PR04MB4491:
x-microsoft-antispam-prvs: <DM6PR04MB4491B5DE33CBDA8A4272C2B5FCDA9@DM6PR04MB4491.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JD7Fbmd9956y4UxxcgUUc5f9IlBpaNwG5nrwgru5qHE+4eyY0CsKt9qzWNjM0ql2z2shdnkuFdIjYGdn59bYJGVqCWd0ERGB5eVPU3vyIYJ8p7CcBCE7oOLBWae59TfmQQLSbPVAzYCcGDYBR3NywCTaKunP3716FyIBkP2ktk4O3sNA42PH1hPyiirZNpu7C26XgFQkt6mSK/siFr71rWY33lO97rcMWPszskpIf4q/Ff9ZanyqeMyYxPTK5YKwnyPVT2B+ZZtkO5mXIqBs8JJrK869yPKmUJud7wh1LzqSDWAb41rwAWAL/HB2bFZcozG3nCYHQ6+JGQpZTB5pkYsoKEAuoZrck8lKho+8z9wMtG16dKsUYZz6ygn1Dj1O81kca9nH5nvPFX8JFYLvXvV+F4EQqZW3YeQc1jvo1S59bFLPF2ZBiHUz2axS0epU6Q8KAUO554cc3yIgDQcsbhVAmOQXPonJjopVKG7ACqammoRZzGthYQupPB8XBpg8Ir48z8ll6C7H/Z4PJjMdEoceXRAE1KF9Lv/cKzdFAOG2AhOtdcpgehj6gO5/3UI3ecFqZ/SBuaOMNIVyEQpLkZhilkjaxM/TrAvYITjMBEPQsbAyWeik+tnSCQQOugEyQnhEMIWekyf8DoCfgfBWPGM+btOxCtAFhrYaDcGhAKGUq5xy+zjokIb4knmWygc93d6AqGA30hIpKCthiktcfp6nC28FAeyTu1sbklzv7R0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(4744005)(76116006)(7696005)(316002)(53546011)(9686003)(110136005)(55016002)(8676002)(7416002)(186003)(38100700002)(921005)(122000001)(33656002)(38070700005)(6506007)(26005)(66446008)(66946007)(2906002)(64756008)(52536014)(8936002)(66476007)(478600001)(66556008)(86362001)(71200400001)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NnlwTFBVVTBwbVViYWxSTFd5TDFmVUdmak1ucjRqZGNCV29ibmRJN3JNdEpD?=
 =?utf-8?B?YkdHSDVySXduOWRyOW1hUSsyZ1lRZjJJZExXMVRVaDFnMmZkTmZqTmxwS0U1?=
 =?utf-8?B?cmpMZFBnWXhhWjFXdVdCWmQxQytQN3JxYVl0TUZmbUNOdTBWazEwb09DeWFS?=
 =?utf-8?B?aTd0Y2ZLcTF4QkFSQWxvdkhlU0Y1UkdRNldKZFhSRVZZMXc3R1RUS1JDZ3dq?=
 =?utf-8?B?Uy9wQllxZnVLazdkTTB6U2x1UURWeUk0akxuUkFUZ21zQjc2UlR1dnBCR041?=
 =?utf-8?B?Wkw0eCtrVkxXeThYa3BiMFVGMDJEVEtUZzI5UVF0M3k5NTVJd0Fad1ZTMXNw?=
 =?utf-8?B?cEhyVG5CNjNtaXRFQUNraVNTT0x4SFpDYWdraXM2c3B5eU9HRVdYTUl0SnRn?=
 =?utf-8?B?Vm5lc1ljSW96SXFRWDA2bW96b3pUV0I1TnY1SnhjZHJQczBoR0ozR0xhYzFX?=
 =?utf-8?B?cnQxdFdJaW5ka0crb0c1ZXNxMmdwSmd6Nll4NW01UDRkSUIzLzNxV2pzZUdD?=
 =?utf-8?B?cXg1VHVHV3pJNkFBQVcvZWJBK1lnbklZZm1YVGUxQXVqTmIzUDltbFJFRUpo?=
 =?utf-8?B?TEpObmxzS0pucnlQNTFUMm4xMTNGZjNEbXlTWDlqak5rbUVFaUFsNGJVL3h1?=
 =?utf-8?B?ZTFycGFiWFhGa2pnRFBQeWxjUjduRTRETW9FamR5L1k0b0R4N3htRytTc3hv?=
 =?utf-8?B?eTlXMllUWWMrelJUR00wcGVLU3RLY0FQRkdvSm96YmlSYXM3WEQ2SisweUNR?=
 =?utf-8?B?YlpiS3FxTkNPTGg3TzNEaVVBbldqQkpBN3RDczBibFFzb0ZRL0FyRHBOU0xp?=
 =?utf-8?B?UFg0bXFYMlVQYXRDZUhiblpsMUo5cVJlYlhWK2VvSTJVYW5vK2REY0VxbkZx?=
 =?utf-8?B?dUdLZXhLVTBjZEdocUo4R1lJYndOM1MvTWN4N3ZjVUExZHo5bkJYRWJLbHI5?=
 =?utf-8?B?NkhQL3Zyb3hpQUJDTENqQTUrcklaK2hwRnptdmZYNGJvSzBuY3NkU2taeHVj?=
 =?utf-8?B?Y01LQnVHRCtsNWRYbGJZQ1BmWmdUK2xaTEE4VXcxZnV2SHdPSW0wRWpRZnNi?=
 =?utf-8?B?aFk3bVZ1VmV4RGhtV3hHcDhDZlJpN0h1dGFBZ1hiWW9vRHpuQW9OYmUvbTA3?=
 =?utf-8?B?SlAwWFBWaEIwNmxuR3dsVElZRHY0VkpBTE5aWllRdGJYeHVjVlF3ODBqcDYz?=
 =?utf-8?B?Q01VcENOb3NtcTZiNDRGbFhxa3JjZDJlamJLZDExdmw0VFptNFRVM1hjcDlo?=
 =?utf-8?B?d2NkeWNwYStwSEI5VXRTMjFCS1hJOHRtQ29JY0k2bWh2R3NkKzFCNkVGQ1U2?=
 =?utf-8?B?UkU3aTNTei9OYXVIMlgyK1MyQzlkNWF4WFpGcW9QeS94dzZDUmp3em5oejYy?=
 =?utf-8?B?RXBKSTR5UDVLakhRS1dHSmFmUytSOXJ1NjI3VEhvOEVjOXpLQkM3bXBjY2M3?=
 =?utf-8?B?WGJ3SWFFZnhOMkR0c0FRUFEvbHMxYlprU3MwM0tLUi9TK2EyNkZoYUorWk55?=
 =?utf-8?B?ajN0SzZxUkU4cVgzVlExWVVKajQzak5vQTRSR05IM2RaRFhWNi8vNDBlSjI2?=
 =?utf-8?B?dmZjZjg1Y3FOZ3FXOGJGQ2VhTW5IcXhPRXgrVlphZWE0aEFTaVIwZHVCbGFE?=
 =?utf-8?B?RmF5YXR5NzVDQ3Z6c3FndmZVK0hlT1JPMlFBOEtSK2p5UW40Y1k1ajNNT282?=
 =?utf-8?B?dm9NaHhsbmZ6Q2tVOE9jUGllSVZWMnlpSnNIK2d2MmxVVnAzdmZWdFJGZzdX?=
 =?utf-8?Q?IheFj6OuKEW0gEArPriQ/+tiQnOaX1e1VEu2Odf?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7f03f3b-c73f-4a18-df1c-08d977764db6
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2021 11:53:44.1948
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ow302PPxPvCKFWCHndJtcGDD/vbYbYGLPcL4Qyq6bVszbKLfjIPnRFhf2GaMqq9gOdtzewfvLUAevm10td+h2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4491
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IA0KPiBPbiA5LzEzLzIxIDAwOjU1LCBLaXdvb25nIEtpbSB3cm90ZToNCj4gPiArc3RhdGljIGlu
bGluZSBpcnFyZXR1cm5fdA0KPiA+ICt1ZnNoY2RfdmVuZG9yX2lzcl9kZWYoc3RydWN0IHVmc19o
YmEgKmhiYSkNCj4gPiArew0KPiA+ICsgICAgIHJldHVybiBJUlFfTk9ORTsNCj4gPiArfQ0KPiAN
Cj4gU2luY2UgInN0YXRpYyBpbmxpbmUgaXJxcmV0dXJuX3QgdWZzaGNkX3ZlbmRvcl9pc3JfZGVm
KHN0cnVjdCB1ZnNfaGJhDQo+ICpoYmEpIiBvY2N1cGllcyBsZXNzIHRoYW4gODAgY29sdW1ucyBw
bGVhc2UgdXNlIGEgc2luZ2xlIGxpbmUgZm9yIHRoZQ0KPiBkZWNsYXJhdGlvbiBvZiB0aGlzIGZ1
bmN0aW9uLg0KYnR3LCBJdCBpcyAxMDAgbm93Lg0KDQo+IA0KPiBUaGFua3MsDQo+IA0KPiBCYXJ0
Lg0K
