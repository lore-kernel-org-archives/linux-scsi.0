Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D54E8C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 12:47:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3AB064E60
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 12:47:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232556AbhBWMrW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Feb 2021 07:47:22 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:8537 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232441AbhBWMrV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Feb 2021 07:47:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614084440; x=1645620440;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YTqUfpuoVgvbjE9ODbYyhVCCcYLCe1W8dJyzhz+nsm8=;
  b=WRuDQZBPIKz+tSZl6/DFb86C7qlvZo3gS8OpgBZaQJPnRa9HLC9UMaCg
   yhlmWDNM53LVTl2+c69bZ6kXdK9au7n0/DP6LxIZzCrPVuFeCYeWx4XJa
   E3N7OnnuAWQh/Cz9bfQPnpHoHpbfOWyBDp+7izT+Tv/0LsV/iPt3O4tJG
   uyEswaVn+///PIo0TTZE+50WUApbxcyf8UDrubWIV4i3V3BZaMAaA3FxB
   6BcG9y8wAJgDEwCkLCQ+qtZr62HFVEa63WXikfmY+22P/ves99P9h/sy3
   tj7Z8cLoWFWGDA3Om1QY7Ww4sLWWr7AWPDjK7XFq+95hsROywW4MB9SW4
   g==;
IronPort-SDR: 7DM2/f6gVhsPWpmaJk9ZA7T7Byom5AZ/PJsbA2gtqNGJAE2yl8edzHTc8Zf618psYeXpkwToyB
 tm0Hyjd7lhgJV/AzjNpAn1vzsMa0N5ICrmrU5itrHZ55sCOX+kX4+IJ4t79b5MWe1xkm8LHDFV
 zP8L+Be67GdZpv5RpssCPydcceltCZBWU6TQduvqN/7SSF14y9LyfN6pNXumEXy8f61rdsoD/i
 kZVo8MTdVv5nHfCWYuoZXaZwpLtlQvazpXrLsuI+ARa/zYiQwcXo2HYIzseAc33FRsRs+cIG93
 2ow=
X-IronPort-AV: E=Sophos;i="5.81,200,1610380800"; 
   d="scan'208";a="160576901"
Received: from mail-dm6nam11lp2171.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.171])
  by ob1.hgst.iphmx.com with ESMTP; 23 Feb 2021 20:46:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ehFGjBTwNjfS/rgJXTJwAOaJUTJOZNM8Y+1Jt8fB2wsEAbG7WnROSUYrcVHoSNs45hQLgOlXPhPHWr0wc5o4wTkwZ8JaRbSG9lBL6nqFK3id17ozqisAi0K79MCXBB3VipeYRnSZSjvntp8eLd/X6rl3mkgLSoVLvjdNvJEAKcDQ9riiProgf6x+bXNX7YMyx7if/bl5lEN3zCY6RnM55HwNL/aNDPFqS6k8yjgJeB/+poF1wglJHYHUH9jROW0za7hSZ6hchL74AylV/PfTRedL5OqEvfon1RvcQnqOx7wJlIvJccyEzCgv+wnEasebpOpXYaNRZdRwX4lTsshf7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YTqUfpuoVgvbjE9ODbYyhVCCcYLCe1W8dJyzhz+nsm8=;
 b=STlgl3HYwiMcovVLFg6sdBBqf9X/VJ8sGJCZeYl/zbo0X3NHkygbu2vDGpXGRdk8Y3cadADgpi4FZoxtiCi3plmlidsBKdP7PI5eRS8I3We7UzM6rSD9ZtUhF6X09zXjEEOFVs8N4f9j7ZwB/0hq3rhXG2nrkWQU05HSjfaqumjjspLEOdVooep8O9imIrHzi8gX197nlqBDGYIcCnbzS6PnwI3aibNYFGi2kj1++ZVUW4VuWqWVw13jMYOxgrQBDMIo5PM7KHjW9LQjae1EybwHvpIWQer7tuRe1qTknOCrax3tVqApzunOf4V9wBTsDp3DviAOVvNR1uK7lqS5gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YTqUfpuoVgvbjE9ODbYyhVCCcYLCe1W8dJyzhz+nsm8=;
 b=gJwuqGH9VfpuRVYyPmcv8o0UAZIEGCLxyiXMVF6aT4Q/dej76075nSCVi9Y/1M/LMUxzUWy8hm3YGBcoHJvoPjqTlqSZADPyZMkEGR201PIBMizSG40hPqg359tTWitMJFS9EnFxLolfUB4HDzoTaLEqryd7cWyoW2ILoJn74Ek=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4028.namprd04.prod.outlook.com (2603:10b6:5:b6::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3868.33; Tue, 23 Feb 2021 12:46:11 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3868.033; Tue, 23 Feb 2021
 12:46:11 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: RE: [PATCH v22 4/4] scsi: ufs: Add HPB 2.0 support
Thread-Topic: [PATCH v22 4/4] scsi: ufs: Add HPB 2.0 support
Thread-Index: AQHXCP2Y/e9Fs0BGVk+8HmhkjtrqFaplnxOQ
Date:   Tue, 23 Feb 2021 12:46:11 +0000
Message-ID: <DM6PR04MB6575DA862FD50130DAF1E573FC809@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210222092957epcms2p728b0c563f3cfbecbf8692d7e86f9afed@epcms2p7>
        <20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p3>
        <CGME20210222092907epcms2p307f3c4116349ebde6eed05c767287449@epcms2p1>
 <20210222093150epcms2p155352e2255e6bfd8f8d71c737ed05e76@epcms2p1>
In-Reply-To: <20210222093150epcms2p155352e2255e6bfd8f8d71c737ed05e76@epcms2p1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 30c1fa4a-61d8-41bb-4a98-08d8d7f8ffc7
x-ms-traffictypediagnostic: DM6PR04MB4028:
x-microsoft-antispam-prvs: <DM6PR04MB4028F74935B0F1E900B909ABFC809@DM6PR04MB4028.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WoSImRn2uwsNl4Wm+6BMVYuQ+7Z+Vz05gG94tpbV4mEQvi0HNDFxi+6jTqrTX0fH/5eC/RgHPsPkUaXrK7kd1gU46TVobHOH6bAWPE9DMzS9WQNC/FXxFZ2Z64AOZYeRv5kzmxd5h8THmJcGK/oQ0a/JEDHTbIh2TNWWSKTTMFfLRWKKELilYZ2GnW72a3rV2qNfQ5VLNrAu67B8t/zk2XbC+xs5/tBt/d3zoVUp3N0hosJM1sngf7UzcZqKqJ98ODcD190CLpzrwI0VRPhTa4O0ol8byVb80uvqo5gBNi3AAPy3lzn/U4MIe/DTrqpX4iqeQYRVd9g6ROmPmSefz+qKtoKRoBnAm7z8hbu+47XnWs81iMcOqSXuJfUco5uxsBRP+5VVmv9WLw7p/mzBSQoSSTX+GNaeM9Hcin7rG1ectLy6NvnRhdL9DoG3CQe0/vFEg4RzsP34lboKDqkjWs8QRBc/em1b0iNICyYt3ozpM6EqER473J5JGWTyrZ2hNR6d0u8QdUJhFMnGckna/eHm0VYUYvweLKOU4dZNa4W6pTnsV/kpToXHId6/2w7u
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(8676002)(8936002)(86362001)(7696005)(110136005)(54906003)(316002)(921005)(6506007)(7416002)(9686003)(33656002)(55016002)(186003)(26005)(4326008)(478600001)(2906002)(83380400001)(71200400001)(66946007)(5660300002)(66556008)(66476007)(64756008)(76116006)(66446008)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?NFl5V21ZWUdVOGI2RG5IK0M5TWQ3QVhoOEFCTDl6UUczMDZ3amFiaDEreFpQ?=
 =?utf-8?B?SVlPaTd3c2JTR0FnUENvcTVtcS9YNS9ONnV0ZGFiZ25xQk9OalcrK2dZajNS?=
 =?utf-8?B?R2tKUzIvbHV0Z1JOUkRIbi82eTNDN3Y0WUFuK2pYL3VrN0VSdW1ZNmhzQ2xl?=
 =?utf-8?B?b1p3bEZQdWhxeldxcFRaeGh2ODdwWlBMRWVnelM0SFNHc2wxY21nWW5BbjJo?=
 =?utf-8?B?V3dWYUM3VVpMUDBMR2VneTRlMjZXMGVWMmlvQ2luSnQ5YkZWRmxGc0liREpn?=
 =?utf-8?B?b3VEVURnNnNPaWxZNWxlcnlnV3FjR0NCZjRWQ2FUUytkRGprSDM2SlN3UTA1?=
 =?utf-8?B?MngzNzdCaHF5bnI1OE9VMXRick9kUkRTS2JTRGZTa1J6bVhUSmFSbzg2R2Z1?=
 =?utf-8?B?N0VHV1JZTndSamlXY1h1M3NIVHZVWjhUTVdoc1czbXNXOFd3Uy9MT2N0TzR1?=
 =?utf-8?B?REM4U25FbUh0cVhEdWtRVEh2MktlU3p0VzBacE9oUnZtSXQva2hKSittZG5B?=
 =?utf-8?B?Qk1Kd1I0SXg1Yyt5VTZOOW5QaHFUTXB1UnpkRy85cE80d1dRWmJZOWVXb3p4?=
 =?utf-8?B?NW1KY2ZJamh6dmNEa3pFZDFpSlRQdTZrSWRSVTcrYkVuWDlpNm42WFFVRUJj?=
 =?utf-8?B?VEVDdC8zTWYxWUxuWkRxR3B5eFdlTlFvNHc0ajJDQkxUZm9zYkhpTjVxT1pB?=
 =?utf-8?B?S2loMlprczBIeXBrR3ZOSGx1d3l4ZFY5QVNLUCsrOW82c2hQQzVWWHdBQXJx?=
 =?utf-8?B?UE1kbm5qOVN3NGh6QzVILzk5YW9YUWxpc3ZielU0UmJURXlKODh3TzVMUkFV?=
 =?utf-8?B?TDBpbkVncE9yTjhxZEhQS2s2eXg1djVxZkNzbU5uQ0g0bzB2SFppcmVJU3VQ?=
 =?utf-8?B?eTh5MmJ2cFUrU2Qvelhuc1pDcGpkK0dHbzV1dlBVVVdUdUtPcUxEbEk4Q1Uz?=
 =?utf-8?B?a3BNR3p5dnhOam1vSFZ3WVVTOWJlZld2aENMbEpjbGk3Q1hydmh1dFFyK0dW?=
 =?utf-8?B?ZE5BaVZoOXFjdERFV25UdllmMU9mZmM4YXVRNC82L09wMGJTa3A4VWQ0SC8w?=
 =?utf-8?B?aFdlMjN2ZVh5Mlowdjc1UGpGUFQ1K3NUNXJQdmNnaTgxaW9oK05hNlpxcHg1?=
 =?utf-8?B?dk1vUlo5aGF3eUJLamhJb2NXeHY0Zmt4NjNsVDR3SUVTdjJVTWRyNm5xZVls?=
 =?utf-8?B?TW5YR2ZjMXN2cjV5S3E0aC9UdEtkRkJtNFRQeGtsRVl3MWhUOTZjeHlwK2tP?=
 =?utf-8?B?WXZjTEFCMzFPNE5wb0RudVhwUzA5cGJ3d3NjQ0s2UXpwSjdoWUVSbktpSUV6?=
 =?utf-8?B?K0tybVV1b1VRZFUzVCtLZDhEUGo1bDRSempYUVhudDl1MHdxenN4SHdqeUZC?=
 =?utf-8?B?M0hyZS9KTUZlR2E0UmNpVEIxR0Z0NUhLbGo3Wi9HRGF1bWo3c0FiVUwrVDIw?=
 =?utf-8?B?YkxXZ0dSVE5nbWdJdzd3bGs1RmwwakN5ZnhkQ3BsN01mUHVyQlltejgrYUsw?=
 =?utf-8?B?M3BFSUFPUG44Q0l5LytWdDFBNjFIRVBGdG9aZlNtM3Nlcmg5RjNWZERVYWQ3?=
 =?utf-8?B?cTl0ekI5eVdlamlTRnV1TFVERUZ3Y2dTYjZOTzNWWFEyZksxb1JiQXcvVFJ0?=
 =?utf-8?B?VUxQV1N3RndCZzNJK1BNS2NUbXJpdS9vTGlHODBObWxhMlFicWlvbmRhYjBW?=
 =?utf-8?B?am9LUG9rbUo5Nm5iSEFpalBCS2VTK2wzUVN6MHhFaUxsVkdhS2dxRkpoSS9E?=
 =?utf-8?Q?A8hIZ6eGMZ+HiSjjW+a/adYt2LiBZTYc7Ka17M+?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30c1fa4a-61d8-41bb-4a98-08d8d7f8ffc7
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2021 12:46:11.5051
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JTXc/+dwNBW8KRLKRDq1ybzLIOVqQCKtw9v3DxptnHymUd7KmUvgI6FDUxp5ZOJ7T5uBIPVU8Ea+WG350bXujA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4028
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQo+IEBAIC0yNjU2LDcgKzI2NTYsMTIgQEAgc3RhdGljIGludCB1ZnNoY2RfcXVldWVjb21tYW5k
KHN0cnVjdCBTY3NpX0hvc3QNCj4gKmhvc3QsIHN0cnVjdCBzY3NpX2NtbmQgKmNtZCkNCj4gDQo+
ICAgICAgICAgbHJicC0+cmVxX2Fib3J0X3NraXAgPSBmYWxzZTsNCj4gDQo+IC0gICAgICAgdWZz
aHBiX3ByZXAoaGJhLCBscmJwKTsNCj4gKyAgICAgICBlcnIgPSB1ZnNocGJfcHJlcChoYmEsIGxy
YnApOw0KPiArICAgICAgIGlmIChlcnIgPT0gLUVBR0FJTikgew0KPiArICAgICAgICAgICAgICAg
bHJicC0+Y21kID0gTlVMTDsNCj4gKyAgICAgICAgICAgICAgIHVmc2hjZF9yZWxlYXNlKGhiYSk7
DQo+ICsgICAgICAgICAgICAgICBnb3RvIG91dDsNCj4gKyAgICAgICB9DQpEaWQgSSBtaXNzLXJl
YWQgaXQsIG9yIGFyZSB5b3UgYmFpbGluZyBvdXQgb2Ygd2IgZmFpbGVkIGUuZy4gYmVjYXVzZSBu
byB0YWcgaXMgYXZhaWxhYmxlPw0KV2h5IG5vdCBjb250aW51ZSB3aXRoIHJlYWQxMD8NCg0KDQoN
Cj4gKyAgICAgICBpZiAoYmxrX2luc2VydF9jbG9uZWRfcmVxdWVzdChxLCByZXEpICE9IEJMS19T
VFNfT0spDQo+ICsgICAgICAgICAgICAgICByZXR1cm4gLUVBR0FJTjsNCldoeSBkaWQgeW91IGNo
b29zZSB0byB1c2UgYmxrX2luc2VydF9jbG9uZWRfcmVxdWVzdCBhbmQgbm90IGUuZy4gdGhlIG1v
cmUgY29tbW9uIGJsa19leGVjdXRlX3JxX25vd2FpdD8NCg0KPiArICAgICAgIGhwYi0+c3RhdHMu
cHJlX3JlcV9jbnQrKzsNCj4gKw0KPiArICAgICAgIHJldHVybiAwOw0KPiArfQ0KDQo+IC0gICAg
ICAgdWZzaHBiX3NldF9ocGJfcmVhZF90b191cGl1KGhwYiwgbHJicCwgbHBuLCBwcG4sIHRyYW5z
ZmVyX2xlbik7DQo+ICsgICAgICAgaWYgKHVmc2hwYl9pc19yZXF1aXJlZF93YihocGIsIHRyYW5z
ZmVyX2xlbikpIHsNCj4gKyAgICAgICAgICAgICAgIGVyciA9IHVmc2hwYl9pc3N1ZV9wcmVfcmVx
KGhwYiwgY21kLCAmcmVhZF9pZCk7DQo+ICsgICAgICAgICAgICAgICBpZiAoZXJyKSB7DQo+ICsg
ICAgICAgICAgICAgICAgICAgICAgIHVuc2lnbmVkIGxvbmcgdGltZW91dDsNCj4gKw0KPiArICAg
ICAgICAgICAgICAgICAgICAgICB0aW1lb3V0ID0gY21kLT5qaWZmaWVzX2F0X2FsbG9jICsgbXNl
Y3NfdG9famlmZmllcygNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGhwYi0+
cGFyYW1zLnJlcXVldWVfdGltZW91dF9tcyk7DQo+ICsgICAgICAgICAgICAgICAgICAgICAgIGlm
ICh0aW1lX2JlZm9yZShqaWZmaWVzLCB0aW1lb3V0KSkNCj4gKyAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICByZXR1cm4gLUVBR0FJTjsNCldoeSByZXF1ZXVlX3RpbWVvdXRfbXMgbmVlZHMg
dG8gYmUgYSBjb25maWd1cmFibGUgcGFyYW1ldGVyPw0KV2h5IHJxLT50aW1lb3V0IGlzIG5vdCBl
bm91Z2g/DQoNClRoYW5rcywNCkF2cmkNCg0KDQo=
