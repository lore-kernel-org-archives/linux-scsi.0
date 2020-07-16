Return-Path: <SRS0=lXiU=A3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F21FC433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jul 2020 16:15:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F02A2074B
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jul 2020 16:15:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="WB2q37TI";
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="qd0bN801"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729251AbgGPQPC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jul 2020 12:15:02 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:49053 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728837AbgGPQPB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jul 2020 12:15:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1594916101; x=1626452101;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=85IjhQlADu19zF/1/Eh4+FctzbBDhRTfPp1UNAWG6dI=;
  b=WB2q37TI+GD1uaMgwl/RxpIQ2E6+RG2UKsiwH1WdRzStPo+WxfP5W5yc
   pdU3XSISrTXFI9bNBMrbrgQhlkmEnmJHuWUTY6Gcho122KUZzC3IIVoXR
   SAFrAUGmQjxekjSeWL0kRosXaY6p+H0nAJhzdJo6iT4GUPpElq2XVzd5U
   rXh65ge/ovoTe86Xzyo/62sol+6VKUETvu4EyluuhBNgClyFcTWIi2U8I
   MqYOBL7lIx4gCWKH36j6ncsGiVMOm1hHIECY1Hj45R7hkJVAuHMLXBq2y
   WMJRR8vkzTch5kNSmIgpGE+QE2hf6bywsMs+pQzvLjU+KYA3Mp+0GUfhn
   g==;
IronPort-SDR: ePcySoye561B78YoRoohhEXMz4go1+Nr2B64UXrx4WRhehKHE2uXmfbwjElPk6lUbVdfO8JGKt
 VjkyjL69aFngZNZHiXYAq519EEBwgJg1t9jQZW2VXInZZCnEFyojAITia1Du0DO5BABuvGru84
 ec+1CF2f0jseq5nhot5hNZyVkyUIvt4lp2xRQh6CitoZiympPH0jjPw6MG/fsJSCnQ9iOjg4RO
 HJtui4TudzFiD+GNqmSzeM+dk2R4wAcryrWO8k6xf8cUFTwLV73H6C3llqRMnagDy7vl2Qla5F
 i/g=
X-IronPort-AV: E=Sophos;i="5.75,360,1589266800"; 
   d="scan'208";a="84172113"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Jul 2020 09:15:00 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 16 Jul 2020 09:14:25 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Thu, 16 Jul 2020 09:15:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KATODlGfar7hy4hb5FSoJRnvVJpTz8xegYbHqkLBcOpifTveGHfNrub6SZ7OKVufbJBz1ZPcOBzfkN6oZdxPV4N6F+KD7S1iJgP2r7hnJNid9dOF4XFl2ezGGe+wO4RuJYt8NW/HX84gDSBg+EF5X2FUHHeYCZnASVTPiywuDUPVFHMfRM5nKbcVxBD4ecFsdnutnYdz8xCdCsQVceRCHGd/FYtYp5AwpBKcC9TcV3mqXShtSlL47YXYOooC4YcrvB4KzBxKUhIFvHPxxcPUlP2o90xS2bAoXdaR/OwqS4E8LcWg3sxsDnNVgGKEr/DzvmX++4AsbEcvpLEPjCiJag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=85IjhQlADu19zF/1/Eh4+FctzbBDhRTfPp1UNAWG6dI=;
 b=VywySuj6UaL0Zm7GW9cvHXHOUo4aduMmikPFayIoQvczZODocDqUniT7uS3vrO++xneHDCxXHZyciqmRIT0h3tZfZTdRkTpJG3pvyEjajaqyZyJjZ0G7MejLUlkIxNRORnTWGYumnrir0CdxSDfoLjpYbAoyCYVAs202I4LrPeIvgcxRsLe+VPIn+t+3BQfM/Ge7jMuTdNLuviL5qlTa2iui8ZUVnzNWWWEGZ2ZAgW24ANiSNRXJBJiIf4NnDZ8MGmy0riUSOZ/c40VbDo0c5+NN5J135jNF3IbkYhyWcQcK4Qj+MbGQFSr+jYV6buWjDDWzF+fruTo8tDI6x3mYZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=85IjhQlADu19zF/1/Eh4+FctzbBDhRTfPp1UNAWG6dI=;
 b=qd0bN8010Iovm7tjlphGph5Idtn0C5N8iAnWVVMbUFsKQdXZXiMmSR3O1E738hQGzErNeji2JGj6kLJAyL5YWrrmTFTuzsN0y68+tbkrHPZ1Di+LSEF0IZIDCt7Br74IJDEBVnQUtIS/T/gJfTsa4zIjAzi6rcUVWxmOrf7CoNU=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SA0PR11MB4560.namprd11.prod.outlook.com (2603:10b6:806:93::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.18; Thu, 16 Jul
 2020 16:14:59 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::14d2:e9a7:be92:6dbb]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::14d2:e9a7:be92:6dbb%7]) with mapi id 15.20.3174.025; Thu, 16 Jul 2020
 16:14:59 +0000
From:   <Don.Brace@microchip.com>
To:     <john.garry@huawei.com>, <don.brace@microsemi.com>, <hare@suse.de>
CC:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <kashyap.desai@broadcom.com>,
        <sumit.saxena@broadcom.com>, <ming.lei@redhat.com>,
        <bvanassche@acm.org>, <hare@suse.com>, <hch@lst.de>,
        <shivasharan.srikanteshwara@broadcom.com>,
        <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <esc.storagedev@microsemi.com>, <chenxiang66@hisilicon.com>,
        <megaraidlinux.pdl@broadcom.com>
Subject: RE: [PATCH RFC v7 12/12] hpsa: enable host_tagset and switch to MQ
Thread-Topic: [PATCH RFC v7 12/12] hpsa: enable host_tagset and switch to MQ
Thread-Index: AQHWP01RAs2BRuCN0k+i3rLwgMsJTKkG5J+AgAOy/wA=
Date:   Thu, 16 Jul 2020 16:14:58 +0000
Message-ID: <SN6PR11MB28485EA5F952502968AF8970E17F0@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <1591810159-240929-13-git-send-email-john.garry@huawei.com>
 <939891db-a584-1ff7-d6a0-3857e4257d3e@huawei.com>
In-Reply-To: <939891db-a584-1ff7-d6a0-3857e4257d3e@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [76.30.208.15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c3c964f5-679f-4d09-38a3-08d829a3630b
x-ms-traffictypediagnostic: SA0PR11MB4560:
x-microsoft-antispam-prvs: <SA0PR11MB4560F7F0D859879682748DBEE17F0@SA0PR11MB4560.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zl5GIKr6uIlzNWcgJYBvvw7M55qd0UurRaIuL+F7ecU4a+IZj8OkJZ3uJVRFENo+JrYNURigDarFK5clS0CLVKWPcwBQAabQ39syDxYl2x1Mx5dn8eCunldlWxajElVSpOABMLl+PsJ0dX5miqukX+WrHHSB303iPOtL5JTxMfYp+W7RSE1KgtRXW21kVSdc6JalQDEE08gRk2vj0CE/wRhpID4xgQnxeH77v/ZqbxAWYbhNNsuoRe2IJcM9qMIRn5ReHGw7cKTa7/tx3jCDIr5+1Q3ffnt/jIRE0Jm//1TzeSTpBHCqn08AeEMQd9PDrl8pLXC0U8dwjxJMiN2QNQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(39860400002)(376002)(396003)(366004)(346002)(66946007)(5660300002)(71200400001)(186003)(110136005)(316002)(26005)(478600001)(54906003)(86362001)(2906002)(55016002)(64756008)(52536014)(7416002)(6506007)(83380400001)(7696005)(66556008)(66446008)(66476007)(9686003)(76116006)(33656002)(8936002)(8676002)(4326008)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: WGF9ATL37FchrD2OryTvr577d962OOcSNC3qXo92+DjIYmnxt3rG7+7mSAo8zSwPo8MXVBdxRiJfsMCuLnssJM1DGpzEFwEj8b+j/pWkYrz7M5nnGzzP3tN6yBOE7t4nLbQQ8/PkiogIw5DMna9r9UWtrkrFDPEwREm7ewmKeqpwrxhsTJUL/thqrtlbIgGFbPE7i38GMXb3jb3pcJwV4mueiMSUCRqlERwqbLU5VAnWB2rkVSs3rezI99MQCceZhIhOk3yMGTq1WLXXS8PdTflJkvIRToAlIkeTjmWhr0duR2dQuhshQy9PeVQugb+KyB5PrH8EJ7UZGwMC/vwlEjr0ggZT3694enMTMY5eQwE3k92IleMrjRhvRoLA3AjUVS7126GiBLDhiG8QDutcIU+c1xPlIIOcNseetqA2sAxh8s9v78p0ZY8p735KrpbcRNdUkNHr06j4V7pIodKlW29kZfDDEqcGpT+X9CXSnO8=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3c964f5-679f-4d09-38a3-08d829a3630b
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jul 2020 16:14:58.9763
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EApmvElm8yaHy2rwmbf5wtjYCsZXNysTmHqOCRElpvYoqYfbkDbxFQct6RKCYrhoBVHKsk+rPLZevEqFmuH5qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4560
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

U3ViamVjdDogUmU6IFtQQVRDSCBSRkMgdjcgMTIvMTJdIGhwc2E6IGVuYWJsZSBob3N0X3RhZ3Nl
dCBhbmQgc3dpdGNoIHRvIE1RDQoNCkVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mg
b3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0K
DQpPbiAxMC8wNi8yMDIwIDE4OjI5LCBKb2huIEdhcnJ5IHdyb3RlOg0KPiBGcm9tOiBIYW5uZXMg
UmVpbmVja2UgPGhhcmVAc3VzZS5kZT4NCj4NCj4gVGhlIHNtYXJ0IGFycmF5IEhCQXMgY2FuIHN0
ZWVyIGludGVycnVwdCBjb21wbGV0aW9uLCBzbyB0aGlzIHBhdGNoIA0KPiBzd2l0Y2hlcyB0aGUg
aW1wbGVtZW50YXRpb24gdG8gdXNlIG11bHRpcXVldWUgYW5kIGVuYWJsZXMgDQo+ICdob3N0X3Rh
Z3NldCcgYXMgdGhlIEhCQSBoYXMgYSBzaGFyZWQgaG9zdC13aWRlIHRhZ3NldC4NCj4NCg0KPj5I
aSBEb24sDQoNCj4+SSBhbSBwcmVwYXJpbmcgdGhlIG5leHQgaXRlcmF0aW9uIG9mIHRoaXMgc2Vy
aWVzLCBhbmQgPj53ZSdyZSBnZXR0aW5nIGNsb3NlIHRvIGRyb3BwaW5nIHRoZSBSRkMgdGFncy4g
VGhlID4+c2VyaWVzIGhhcyBncm93biBhIGJpdCwgYW5kIEkgYW0gbm90IHN1cmUgd2hhdCB0byBk
byA+PndpdGggaHBzYSBzdXBwb3J0Lg0KDQo+PlRoZSBsYXRlc3QgdmVyc2lvbnMgb2YgdGhpcyBz
ZXJpZXMgaGF2ZSBub3QgYmVlbiB0ZXN0ZWQgZm9yIGhwc2EsIEFGQUlLLg0KPj5DYW4geW91IGxl
dCBtZSBrbm93IGlmIHlvdSBjYW4gdGVzdCBhbmQgcmV2aWV3IHRoaXMgPj5wYXRjaD8gT3Igc29t
ZW9uZSBlbHNlIGxldCBtZSBrbm93IGl0J3MgdGVzdGVkIChIYW5uZXM/KQ0KDQpUaGFua3MNCg0K
WWVzLCBJJ2xsIHJ1biBteSB0ZXN0aW5nIHNvb24uDQpEb24NCg0KPiBTaWduZWQtb2ZmLWJ5OiBI
YW5uZXMgUmVpbmVja2UgPGhhcmVAc3VzZS5kZT4NCj4gLS0tDQo+ICAgZHJpdmVycy9zY3NpL2hw
c2EuYyB8IDQ0ICsrKysrKystLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+
ICAgZHJpdmVycy9zY3NpL2hwc2EuaCB8ICAxIC0NCj4gICAyIGZpbGVzIGNoYW5nZWQsIDcgaW5z
ZXJ0aW9ucygrKSwgMzggZGVsZXRpb25zKC0pDQo+DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Nj
c2kvaHBzYS5jIGIvZHJpdmVycy9zY3NpL2hwc2EuYyBpbmRleCANCj4gMWU5MzAyZTk5ZDA1Li5m
ODA3ZjliZGFlODUgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvc2NzaS9ocHNhLmMNCj4gKysrIGIv
ZHJpdmVycy9zY3NpL2hwc2EuYw0KPiBAQCAtOTgwLDYgKzk4MCw3IEBAIHN0YXRpYyBzdHJ1Y3Qg
c2NzaV9ob3N0X3RlbXBsYXRlIGhwc2FfZHJpdmVyX3RlbXBsYXRlID0gew0KPiAgICAgICAuc2hv
c3RfYXR0cnMgPSBocHNhX3Nob3N0X2F0dHJzLA0KPiAgICAgICAubWF4X3NlY3RvcnMgPSAyMDQ4
LA0KPiAgICAgICAubm9fd3JpdGVfc2FtZSA9IDEsDQo+ICsgICAgIC5ob3N0X3RhZ3NldCA9IDEs
DQo+ICAgfTsNCj4NCj4gICBzdGF0aWMgaW5saW5lIHUzMiBuZXh0X2NvbW1hbmQoc3RydWN0IGN0
bHJfaW5mbyAqaCwgdTggcSkgQEAgDQo+IC0xMTQ0LDEyICsxMTQ1LDE0IEBAIHN0YXRpYyB2b2lk
IGRpYWxfdXBfbG9ja3VwX2RldGVjdGlvbl9vbl9md19mbGFzaF9jb21wbGV0ZShzdHJ1Y3QgY3Rs
cl9pbmZvICpoLA0KPiAgIHN0YXRpYyB2b2lkIF9fZW5xdWV1ZV9jbWRfYW5kX3N0YXJ0X2lvKHN0
cnVjdCBjdGxyX2luZm8gKmgsDQo+ICAgICAgIHN0cnVjdCBDb21tYW5kTGlzdCAqYywgaW50IHJl
cGx5X3F1ZXVlKQ0KPiAgIHsNCj4gKyAgICAgdTMyIGJsa190YWcgPSBibGtfbXFfdW5pcXVlX3Rh
ZyhjLT5zY3NpX2NtZC0+cmVxdWVzdCk7DQo+ICsNCj4gICAgICAgZGlhbF9kb3duX2xvY2t1cF9k
ZXRlY3Rpb25fZHVyaW5nX2Z3X2ZsYXNoKGgsIGMpOw0KPiAgICAgICBhdG9taWNfaW5jKCZoLT5j
b21tYW5kc19vdXRzdGFuZGluZyk7DQo+ICAgICAgIGlmIChjLT5kZXZpY2UpDQo+ICAgICAgICAg
ICAgICAgYXRvbWljX2luYygmYy0+ZGV2aWNlLT5jb21tYW5kc19vdXRzdGFuZGluZyk7DQo+DQo+
IC0gICAgIHJlcGx5X3F1ZXVlID0gaC0+cmVwbHlfbWFwW3Jhd19zbXBfcHJvY2Vzc29yX2lkKCld
Ow0KPiArICAgICByZXBseV9xdWV1ZSA9IGJsa19tcV91bmlxdWVfdGFnX3RvX2h3cShibGtfdGFn
KTsNCj4gICAgICAgc3dpdGNoIChjLT5jbWRfdHlwZSkgew0KPiAgICAgICBjYXNlIENNRF9JT0FD
Q0VMMToNCj4gICAgICAgICAgICAgICBzZXRfaW9hY2NlbDFfcGVyZm9ybWFudF9tb2RlKGgsIGMs
IHJlcGx5X3F1ZXVlKTsgQEAgDQo+IC01NjUzLDggKzU2NTYsNiBAQCBzdGF0aWMgaW50IGhwc2Ff
c2NzaV9xdWV1ZV9jb21tYW5kKHN0cnVjdCBTY3NpX0hvc3QgKnNoLCBzdHJ1Y3Qgc2NzaV9jbW5k
ICpjbWQpDQo+ICAgICAgIC8qIEdldCB0aGUgcHRyIHRvIG91ciBhZGFwdGVyIHN0cnVjdHVyZSBv
dXQgb2YgY21kLT5ob3N0LiAqLw0KPiAgICAgICBoID0gc2Rldl90b19oYmEoY21kLT5kZXZpY2Up
Ow0KPg0KPiAtICAgICBCVUdfT04oY21kLT5yZXF1ZXN0LT50YWcgPCAwKTsNCj4gLQ0KPiAgICAg
ICBkZXYgPSBjbWQtPmRldmljZS0+aG9zdGRhdGE7DQo+ICAgICAgIGlmICghZGV2KSB7DQo+ICAg
ICAgICAgICAgICAgY21kLT5yZXN1bHQgPSBESURfTk9fQ09OTkVDVCA8PCAxNjsgQEAgLTU4MzAs
NyArNTgzMSw3IA0KPiBAQCBzdGF0aWMgaW50IGhwc2Ffc2NzaV9ob3N0X2FsbG9jKHN0cnVjdCBj
dGxyX2luZm8gKmgpDQo+ICAgICAgIHNoLT5ob3N0ZGF0YVswXSA9ICh1bnNpZ25lZCBsb25nKSBo
Ow0KPiAgICAgICBzaC0+aXJxID0gcGNpX2lycV92ZWN0b3IoaC0+cGRldiwgMCk7DQo+ICAgICAg
IHNoLT51bmlxdWVfaWQgPSBzaC0+aXJxOw0KPiAtDQo+ICsgICAgIHNoLT5ucl9od19xdWV1ZXMg
PSBoLT5tc2l4X3ZlY3RvcnMgPiAwID8gaC0+bXNpeF92ZWN0b3JzIDogMTsNCj4gICAgICAgaC0+
c2NzaV9ob3N0ID0gc2g7DQo+ICAgICAgIHJldHVybiAwOw0KPiAgIH0NCj4gQEAgLTU4NTYsNyAr
NTg1Nyw4IEBAIHN0YXRpYyBpbnQgaHBzYV9zY3NpX2FkZF9ob3N0KHN0cnVjdCBjdGxyX2luZm8g
KmgpDQo+ICAgICovDQo+ICAgc3RhdGljIGludCBocHNhX2dldF9jbWRfaW5kZXgoc3RydWN0IHNj
c2lfY21uZCAqc2NtZCkNCj4gICB7DQo+IC0gICAgIGludCBpZHggPSBzY21kLT5yZXF1ZXN0LT50
YWc7DQo+ICsgICAgIHUzMiBibGtfdGFnID0gYmxrX21xX3VuaXF1ZV90YWcoc2NtZC0+cmVxdWVz
dCk7DQo+ICsgICAgIGludCBpZHggPSBibGtfbXFfdW5pcXVlX3RhZ190b190YWcoYmxrX3RhZyk7
DQo+DQo+ICAgICAgIGlmIChpZHggPCAwKQ0KPiAgICAgICAgICAgICAgIHJldHVybiBpZHg7DQo+
IEBAIC03NDU2LDI2ICs3NDU4LDYgQEAgc3RhdGljIHZvaWQgaHBzYV9kaXNhYmxlX2ludGVycnVw
dF9tb2RlKHN0cnVjdCBjdGxyX2luZm8gKmgpDQo+ICAgICAgIGgtPm1zaXhfdmVjdG9ycyA9IDA7
DQo+ICAgfQ0KPg0KPiAtc3RhdGljIHZvaWQgaHBzYV9zZXR1cF9yZXBseV9tYXAoc3RydWN0IGN0
bHJfaW5mbyAqaCkgLXsNCj4gLSAgICAgY29uc3Qgc3RydWN0IGNwdW1hc2sgKm1hc2s7DQo+IC0g
ICAgIHVuc2lnbmVkIGludCBxdWV1ZSwgY3B1Ow0KPiAtDQo+IC0gICAgIGZvciAocXVldWUgPSAw
OyBxdWV1ZSA8IGgtPm1zaXhfdmVjdG9yczsgcXVldWUrKykgew0KPiAtICAgICAgICAgICAgIG1h
c2sgPSBwY2lfaXJxX2dldF9hZmZpbml0eShoLT5wZGV2LCBxdWV1ZSk7DQo+IC0gICAgICAgICAg
ICAgaWYgKCFtYXNrKQ0KPiAtICAgICAgICAgICAgICAgICAgICAgZ290byBmYWxsYmFjazsNCj4g
LQ0KPiAtICAgICAgICAgICAgIGZvcl9lYWNoX2NwdShjcHUsIG1hc2spDQo+IC0gICAgICAgICAg
ICAgICAgICAgICBoLT5yZXBseV9tYXBbY3B1XSA9IHF1ZXVlOw0KPiAtICAgICB9DQo+IC0gICAg
IHJldHVybjsNCj4gLQ0KPiAtZmFsbGJhY2s6DQo+IC0gICAgIGZvcl9lYWNoX3Bvc3NpYmxlX2Nw
dShjcHUpDQo+IC0gICAgICAgICAgICAgaC0+cmVwbHlfbWFwW2NwdV0gPSAwOw0KPiAtfQ0KPiAt
DQo+ICAgLyogSWYgTVNJL01TSS1YIGlzIHN1cHBvcnRlZCBieSB0aGUga2VybmVsIHdlIHdpbGwg
dHJ5IHRvIGVuYWJsZSBpdCBvbg0KPiAgICAqIGNvbnRyb2xsZXJzIHRoYXQgYXJlIGNhcGFibGUu
IElmIG5vdCwgd2UgdXNlIGxlZ2FjeSBJTlR4IG1vZGUuDQo+ICAgICovDQo+IEBAIC03ODcyLDkg
Kzc4NTQsNiBAQCBzdGF0aWMgaW50IGhwc2FfcGNpX2luaXQoc3RydWN0IGN0bHJfaW5mbyAqaCkN
Cj4gICAgICAgaWYgKGVycikNCj4gICAgICAgICAgICAgICBnb3RvIGNsZWFuMTsNCj4NCj4gLSAg
ICAgLyogc2V0dXAgbWFwcGluZyBiZXR3ZWVuIENQVSBhbmQgcmVwbHkgcXVldWUgKi8NCj4gLSAg
ICAgaHBzYV9zZXR1cF9yZXBseV9tYXAoaCk7DQo+IC0NCj4gICAgICAgZXJyID0gaHBzYV9wY2lf
ZmluZF9tZW1vcnlfQkFSKGgtPnBkZXYsICZoLT5wYWRkcik7DQo+ICAgICAgIGlmIChlcnIpDQo+
ICAgICAgICAgICAgICAgZ290byBjbGVhbjI7ICAgIC8qIGludG1vZGUrcmVnaW9uLCBwY2kgKi8N
Cj4gQEAgLTg2MTMsNyArODU5Miw2IEBAIHN0YXRpYyBzdHJ1Y3Qgd29ya3F1ZXVlX3N0cnVjdCAN
Cj4gKmhwc2FfY3JlYXRlX2NvbnRyb2xsZXJfd3Eoc3RydWN0IGN0bHJfaW5mbyAqaCwNCj4NCj4g
ICBzdGF0aWMgdm9pZCBocGRhX2ZyZWVfY3Rscl9pbmZvKHN0cnVjdCBjdGxyX2luZm8gKmgpDQo+
ICAgew0KPiAtICAgICBrZnJlZShoLT5yZXBseV9tYXApOw0KPiAgICAgICBrZnJlZShoKTsNCj4g
ICB9DQo+DQo+IEBAIC04NjIyLDE0ICs4NjAwLDYgQEAgc3RhdGljIHN0cnVjdCBjdGxyX2luZm8g
KmhwZGFfYWxsb2NfY3Rscl9pbmZvKHZvaWQpDQo+ICAgICAgIHN0cnVjdCBjdGxyX2luZm8gKmg7
DQo+DQo+ICAgICAgIGggPSBremFsbG9jKHNpemVvZigqaCksIEdGUF9LRVJORUwpOw0KPiAtICAg
ICBpZiAoIWgpDQo+IC0gICAgICAgICAgICAgcmV0dXJuIE5VTEw7DQo+IC0NCj4gLSAgICAgaC0+
cmVwbHlfbWFwID0ga2NhbGxvYyhucl9jcHVfaWRzLCBzaXplb2YoKmgtPnJlcGx5X21hcCksIEdG
UF9LRVJORUwpOw0KPiAtICAgICBpZiAoIWgtPnJlcGx5X21hcCkgew0KPiAtICAgICAgICAgICAg
IGtmcmVlKGgpOw0KPiAtICAgICAgICAgICAgIHJldHVybiBOVUxMOw0KPiAtICAgICB9DQo+ICAg
ICAgIHJldHVybiBoOw0KPiAgIH0NCj4NCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9ocHNh
LmggYi9kcml2ZXJzL3Njc2kvaHBzYS5oIGluZGV4IA0KPiBmOGM4OGZjN2I4MGEuLmVhNGE2MDll
M2ViNyAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9zY3NpL2hwc2EuaA0KPiArKysgYi9kcml2ZXJz
L3Njc2kvaHBzYS5oDQo+IEBAIC0xNjEsNyArMTYxLDYgQEAgc3RydWN0IGJtaWNfY29udHJvbGxl
cl9wYXJhbWV0ZXJzIHsNCj4gICAjcHJhZ21hIHBhY2soKQ0KPg0KPiAgIHN0cnVjdCBjdGxyX2lu
Zm8gew0KPiAtICAgICB1bnNpZ25lZCBpbnQgKnJlcGx5X21hcDsNCj4gICAgICAgaW50ICAgICBj
dGxyOw0KPiAgICAgICBjaGFyICAgIGRldm5hbWVbOF07DQo+ICAgICAgIGNoYXIgICAgKnByb2R1
Y3RfbmFtZTsNCj4NCg0K
