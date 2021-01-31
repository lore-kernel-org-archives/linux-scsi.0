Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECF0DC433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 31 Jan 2021 07:28:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3BE864E09
	for <linux-scsi@archiver.kernel.org>; Sun, 31 Jan 2021 07:28:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbhAaH16 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 31 Jan 2021 02:27:58 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:43883 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229474AbhAaH06 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 31 Jan 2021 02:26:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612078016; x=1643614016;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eYbeSiXFevVrHHxSpAeX8x0zGeF3VJwAYE2vhPZgm1E=;
  b=d70ULwL37Eh6gzDhfmkZ8pm3Tt5o+kZ9amyXYTGb71MNIyYGxgCxPIln
   44HpMgCMhfw6x3jVMf6gQ6xJTDyeDVa9gxtrkRXz9XsH3/JJwMwlglAw1
   uQawjhUOQkRCS8pIRw315jLIY90Z+vnxxkGNtCdp7aToUrBXN9DsnclOd
   irC+M8ZF82joqp8xiThyY6fdwhxMpqFKrmB4vOeO7BaJyQPfDsFT2mTpJ
   sxeP7Inr+s2Lc0BswGGxBpwh6E9+PfqEOR90JAyKZufYl/I/qeI+rPCB1
   6zKYA6fjvACGyZOeLHc0UKpW1SvSPkut++mfhBxrFIG60G8hJK5QE/81a
   Q==;
IronPort-SDR: vX3JHFU1M/EfPS+raZifi1SmMtMzsrhmRD6uNAPFkt/QwpNfkSZFqXKfx5s2ug+QW8CrL+hANd
 zKP+8g/ncgRePuCBlcp+75AANkeWAp48saUvKwLATqJ3a5xB8MtY0U1JBNtCBDdC9vxAhin3Zm
 sS8giYs2P3nOdQ2rsTmJMtNp3Ytn320HHk75JOGCTk7CBxKWiZ1p8HuCglbOxRM6U4DzXzM87z
 CbIwdtWXVt3JdMNBdziCUk06TFBcGUnDWbR/DHYb63N50bSRtKO1yR67M72HU1Y/RO2kVBeDe/
 ipc=
X-IronPort-AV: E=Sophos;i="5.79,389,1602518400"; 
   d="scan'208";a="159910740"
Received: from mail-cys01nam02lp2057.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.57])
  by ob1.hgst.iphmx.com with ESMTP; 31 Jan 2021 15:25:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YSIw+jnCGjBdkAMBMMMOgj+r7MNOwreYOxpBK64AHPE3ztkKp/3aVPmD+cLk3u+8sP9Q2GkaSEZBHTfQ2pr6rmbzxX/DiN7yNKJJBVobYmHJgx5AkiyEw+toJdcRVmtCG7eF33XJPFFUBFUKQAB7ZWGYswDkfCJnRMm2RnK0pE0J1QsyBsild12OJOsHEAkPkXJWo62jz0nsOQynoJhZYiwHAwag+lx43e5WwQ8TlFC7tk2shp04qNtY6UQzVX1kYZtZr2IbhymhMz3Xg+MUuvjHQM2bgUM1yNzlyKDB6Qm05+zCIWHRtrEb5wercMr1+ZNxmZcADi133qSacAZ1CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eYbeSiXFevVrHHxSpAeX8x0zGeF3VJwAYE2vhPZgm1E=;
 b=JGc2cWKr3r6VmeSGARsjHL873dlWbaaPohieAvY9ybfDhoxPzwOlFBLUKPBYOoXRCP0MW+gmI/TJHWh9HXOgJxtz22xygiHvZCGGQ5slAxH51spxgMJO+ZiDj+Yw1VLTnidvpBXkKclqDtNGUmhBVcRopefffvDD7EEV9B+0hlNUbKW8ST5zvmXLvDntoCwNmPLxsLf6vtkCgehKERS2bqxHehAQ31Q06aMpxfLhT2wvQzxkPKqDAVNrU2v+HJ67V9yLrCU15/FREYaR58pn7UiGFTi95zM5o1igu4QKB7HG8+k/TfytRXuyIKQdKa6iqJ9fUy+fNiZJvxwTWBcg8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eYbeSiXFevVrHHxSpAeX8x0zGeF3VJwAYE2vhPZgm1E=;
 b=z52WdLuEhn2GNY32Ly83AdU5/xt9ZNVk1BFTCEojIfy2njZNEhLZTDRbj0cUNlXEAvHGzXrjNQugH7jcb99/XiUnUTbfUtfrqAZSaqDH+ECoCL5AO2mIXYblEC+Fb7mQsedjx2jK3fqb9RQvYAPyPAAl3IBN7GrW7LaMdWya0LA=
Received: from BL0PR04MB6564.namprd04.prod.outlook.com (2603:10b6:208:17d::11)
 by BL0PR04MB4882.namprd04.prod.outlook.com (2603:10b6:208:58::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Sun, 31 Jan
 2021 07:25:38 +0000
Received: from BL0PR04MB6564.namprd04.prod.outlook.com
 ([fe80::59d5:c6a9:57e7:15f7]) by BL0PR04MB6564.namprd04.prod.outlook.com
 ([fe80::59d5:c6a9:57e7:15f7%7]) with mapi id 15.20.3805.024; Sun, 31 Jan 2021
 07:25:38 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>
Subject: RE: [PATCH 3/8] scsi: ufshpb: Add region's reads counter
Thread-Topic: [PATCH 3/8] scsi: ufshpb: Add region's reads counter
Thread-Index: AQHW9L7x4iaxfLLWbU2VlJGMVSiCUao7lsOAgAXCCIA=
Date:   Sun, 31 Jan 2021 07:25:37 +0000
Message-ID: <BL0PR04MB6564C0EB1584AE599A13E120FCB79@BL0PR04MB6564.namprd04.prod.outlook.com>
References: <20210127151217.24760-1-avri.altman@wdc.com>
 <20210127151217.24760-4-avri.altman@wdc.com> <YBGFC+XcibjRg7Y/@kroah.com>
In-Reply-To: <YBGFC+XcibjRg7Y/@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 40fe79ca-7d32-4bb0-4238-08d8c5b9684c
x-ms-traffictypediagnostic: BL0PR04MB4882:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR04MB4882B6DC27354DCFC94C5E1EFCB79@BL0PR04MB4882.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: S61lC60Ws9ttUNs2C9yRhzbDmSzaAbZgLZluCpr8k5V63+NVJveBn5cgevsXdDfAQrV7e/++5IMPzHK0aCAuOVeEk/qOU4jb8f2Rixr1L8EL4UQZtYQNGt9r6gAeh4OTJ/QIJMIIoi/lXJEm8R/pHpquNJl4Z5hAshkYgQnPSkanc02TzPbxVgas2zpNV0yQGifYvipWA/WXiZBl7c6EjBFJiSF9Qli78NKMAyX3TjJD0CG9lppfUF6HVOuVrfI0gq2npZJlehFojfj17t/Cj5g/48h9wt59DBl+uJpyOcakmqqzc0+d/ywSciI1+8SxkaBYF2pVhwQx0tpE3YHAvuI6qPBI10v/RNPrO+tfyRJIzQwjGiIz9zS4znbCmEW08JaovAl5yDqv3Hhrnhn/JeNg79zAGm8cZZan3h2Mv7UyAoyva2cx7tYSwMVmgYC8k7Ax2HpuOFamdvrGteN2odCEamlweCZpb9Gnqqdk0Jdu64z3zI0Gp8+sIKQkWgIBjoUSC1Cf6AkuD1A5lOTeJQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR04MB6564.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39850400004)(346002)(366004)(396003)(376002)(9686003)(55016002)(71200400001)(76116006)(478600001)(4326008)(8936002)(5660300002)(66476007)(66946007)(26005)(6506007)(66446008)(64756008)(66556008)(52536014)(186003)(2906002)(7696005)(316002)(54906003)(33656002)(6916009)(7416002)(86362001)(83380400001)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?VU1BQXJwTTV0azZKd04wR1dzYkVEVFBwZkdBdTA1NmVaMXIyc0N5ZlRtNWRG?=
 =?utf-8?B?THJKNFNmSnVac0lMZlFDblJkcHVIcUV1Sis4dDVWWTUzODdXNzBMTkhqT3J4?=
 =?utf-8?B?Z2JWNERxa2pwQk5Hd0lkU3k3K0hpQ1lEdFB4WnZBYU85VXdlMTU1eHhEa1NB?=
 =?utf-8?B?OVhxMkdoQkUyS1AxWDBiRWhaa1M4TWh0T29GeFh4YWxFeWlQV252cmcrQnVX?=
 =?utf-8?B?a1hHaDBrSzdzUWNvcmg3TzBVcTBBcmVIQ203STZLOUdyeDk2dWl3QWxsQjVZ?=
 =?utf-8?B?bFZGa3J0U2pxVjEycTN6bjFRSll2M3hKaTd4ZE5LT2tSYlM1NW9xVC9uR1hJ?=
 =?utf-8?B?OU00blhHWXI1dnZ2aHNRMzVGMnlpdXRPVmFXUEtPMEtlMzRxYU54STBBMjNu?=
 =?utf-8?B?eW9RTHVXTTZLK3FSL2NoS3kzcnN4ck5TblhNL1BZOEEzWkhZWWtHWk83WjF6?=
 =?utf-8?B?YnFOSlRXcW1tMVJ3aSt0RThQVFVFUHozeU5XM1VPSm1XUDRFbU1hbmkzbmdV?=
 =?utf-8?B?cGlIVDkrTWgxbnAxa3FQQm41ZjBucjF0eC90N1hScmNoaW1ab2thYUZoYTB0?=
 =?utf-8?B?aVF5eldyNTJJelFCaWJVN0Z5VkRBSU1DajYreE5tLzV6VWxDemFOUUZ6WEw5?=
 =?utf-8?B?cys4K1ZVYy9ibGltWEhhakdPdEhwTmVKa05SVVcxMFBFWjRzK1NPN0hSa2sy?=
 =?utf-8?B?UGIrN29SQUpKanlqOHZpdDdFSS9UTTREWFhjUnpCS0Z4czlLVW9IMk9GdS9h?=
 =?utf-8?B?eXg0ZHFkd1htc0FaTktkYWpIckNabVZUaFhOVW9aSEdySGJ5YUxMeDF3aWt3?=
 =?utf-8?B?M0pYeDdDNHZXa0w5bnlnQVRtMVM0MHpZa1ZiY0RJTXZJVnJEd3QzTUtvMVZJ?=
 =?utf-8?B?cjErYkRFYXF3RmNlMDJmcjhxQk4xcW52cXVBUE1VZ1U5NmhpcTVhcU9ZTEFs?=
 =?utf-8?B?bDlmQ0pZRW1hZHJBUFlXWEZWclhQVmRlSEwxZ3N0eXZ6bGxuZE5wRWk2bmN3?=
 =?utf-8?B?bytYV2p6ZUxhNDVETnpCcllWRGJRck1wdWk5cHhDRkdKRVQvS3YwV0QxS2k5?=
 =?utf-8?B?S2hnVUs0ellGdi9ZU29wWTNSUnNFSU90eE4wZ3JtM3pFeklzK3VucnNvbkxT?=
 =?utf-8?B?Yjh0bG1meUdMU091ZFFsU2ZlVExHUXJ6VndNSGUyL3JpdHhLcTg1bCtrTktw?=
 =?utf-8?B?c0x3b0ZScGxuYUJRam85VWpEZis3dWxJVWNkN3FPUGduZHIvSnFmUS9tbU1R?=
 =?utf-8?B?OHdxVE5mekQwcDVYVStRandkMzJYU1o0QVp3aTdBeWNoa1plT05IcFZ1MjhL?=
 =?utf-8?B?ZEdhVjBaK0JiNjRPcTZvSkxLNFdya3JsaDg2SU9XYkhCa0NyNnk3eXNOZ203?=
 =?utf-8?B?TnYwU1E3QzQ5RStzK2RNVEdCY1V2MXE2MGhSSUIyN1gvQTJoK2NHbVc0YUdC?=
 =?utf-8?Q?0y1M2+su?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6564.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40fe79ca-7d32-4bb0-4238-08d8c5b9684c
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2021 07:25:38.0154
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hpkn1m4j9rVHu4RjcXBTuwzKXKBvxf93JAQWQYiwDP3Oq52bPEvR63mw/NUKBAus/JnoZ/SYa+6KfwmVcwgLtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB4882
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

PiA+DQo+ID4gKyAgICAgaWYgKHVmc2hwYl9tb2RlID09IEhQQl9IT1NUX0NPTlRST0wpDQo+ID4g
KyAgICAgICAgICAgICByZWFkcyA9IGF0b21pYzY0X2luY19yZXR1cm4oJnJnbi0+cmVhZHMpOw0K
PiA+ICsNCj4gPiAgICAgICBpZiAoIXVmc2hwYl9pc19zdXBwb3J0X2NodW5rKHRyYW5zZmVyX2xl
bikpDQo+ID4gICAgICAgICAgICAgICByZXR1cm47DQo+ID4NCj4gPiArICAgICBpZiAodWZzaHBi
X21vZGUgPT0gSFBCX0hPU1RfQ09OVFJPTCkgew0KPiA+ICsgICAgICAgICAgICAgLyoNCj4gPiAr
ICAgICAgICAgICAgICAqIGluIGhvc3QgY29udHJvbCBtb2RlLCByZWFkcyBhcmUgdGhlIG1haW4g
c291cmNlIGZvcg0KPiA+ICsgICAgICAgICAgICAgICogYWN0aXZhdGlvbiB0cmlhbHMuDQo+ID4g
KyAgICAgICAgICAgICAgKi8NCj4gPiArICAgICAgICAgICAgIGlmIChyZWFkcyA9PSBBQ1RJVkFU
SU9OX1RIUlNITEQpIHsNCk9vcHMgLSB0aGlzIGlzIGEgYnVnLi4uDQoNCj4gPiArDQo+ID4gKyAg
ICAgLyogcmVnaW9uIHJlYWRzIC0gZm9yIGhvc3QgbW9kZSAqLw0KPiA+ICsgICAgIGF0b21pYzY0
X3QgcmVhZHM7DQo+IA0KPiBXaHkgZG8geW91IG5lZWQgYW4gYXRvbWljIHZhcmlhYmxlIGZvciB0
aGlzPyAgV2hhdCBhcmUgeW91IHRyeWluZyB0bw0KPiAicHJvdGVjdCIgaGVyZSBieSBmbHVzaGlu
ZyB0aGUgY3B1cyBhbGwgdGhlIHRpbWU/ICBXaGF0IHByb3RlY3RzIHRoaXMNCj4gdmFyaWFibGUg
ZnJvbSBjaGFuZ2luZyByaWdodCBhZnRlciB5b3UgaGF2ZSByZWFkIGZyb20gaXQgKGhpbnQsIHlv
dSBkbw0KPiB0aGF0IGFib3ZlLi4uKQ0KPiANCj4gYXRvbWljcyBhcmUgbm90IHJhY2UtZnJlZSwg
dXNlIGEgcmVhbCBsb2NrIGlmIHlvdSBuZWVkIHRoYXQuDQpXZSBhcmUgb24gdGhlIGRhdGEgcGF0
aCBoZXJlIC0gdGhpcyBpcyBjYWxsZWQgZnJvbSBxdWV1ZWNvbW1hbmQuDQpUaGUgInJlYWRzIiBj
b3VudGVyIGlzIGJlaW5nIHN5bW1ldHJpY2FsbHkgcmVhZCBhbmQgd3JpdHRlbiwNCnNvIGFkZGlu
ZyBhIHNwaW4gbG9jayBoZXJlIG1pZ2h0IGJlY29tZSBhIHNvdXJjZSBmb3IgY29udGVudGlvbi4N
Cg0KQWxzbyBJIGFtIG5vdCB3b3JyaWVkIGFib3V0IHRoZSBleGFjdCB2YWx1ZSBvZiB0aGlzIGNv
dW50ZXIsIGV4Y2VwdCBvZiBvbmUgcGxhY2UgLSANClNlZSBhYm92ZS4gIFdpbGwgZml4IGl0Lg0K
DQpUaGFua3MsDQpBdnJpDQo=
