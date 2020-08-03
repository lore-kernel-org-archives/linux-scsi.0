Return-Path: <SRS0=9rmj=BN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4900FC433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 20:39:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5233B207DF
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 20:39:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="N4aOvcF2";
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="Bcr2csv/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbgHCUjL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Aug 2020 16:39:11 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:60516 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726693AbgHCUjK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2020 16:39:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1596487150; x=1628023150;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CBA9qNjvjpgD/jh7/N6+rbC5v0P46asRI+a+O0JQmd0=;
  b=N4aOvcF2+v4hhiHkqMeEdITGnmgFixzne2LjT8f6AacZxOj+2e7+ntXo
   5PZ320HHcPAYhduz/5PU+2K701AzOtTmdB6Z0MvHLm7TE9RYOP0jDGT7h
   89y9EQclY9GiJZq3JtpxyPzpgFVSlkRJvJG1momlmLGIy34nIj6H56RCI
   agpsYGDjJDJbuKz4SoDtdGB4syW3HmAyvepyW8WKYviq65YITBlrGi2Fa
   cBlH9VzdvGv1RsAcJre4bDQ1rZplgDsn+z+C9X47ATOg5zznpkU77JyFy
   0JI95HBoreFpljnlS3zPvkJj5aUkj2eeiM+Z+AMV0K3hd/H6mudvlGaJB
   g==;
IronPort-SDR: VmzemIuVOdBr77/Lfl06lhgxu/1SMnHWmu7+ES1qWoPyI0qdpNxCvXSQkkBJruSUHcH+39PcUw
 tXUH8oYZX8qwN3ki4WytDKXgngsviZpH2HBnJqWQFFFbdtMfGGAWLKDCUliAo8Oqe4AgsudxJF
 GwSBpIle5bzZx5SUD0WAX7gmEONN52V2lNxV54U+fTj8iPtmhU0yS0rEj2H3sDu+pUOsJdEEpb
 mN721BM8c4+zvbfCAjowzW92UgHFSmwstoUwgDUEWeeW2E2QCCOVTbuhl2e6JqwBFydM5FihON
 kiw=
X-IronPort-AV: E=Sophos;i="5.75,431,1589266800"; 
   d="scan'208";a="85699735"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Aug 2020 13:39:09 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 3 Aug 2020 13:39:05 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Mon, 3 Aug 2020 13:39:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jHP1uB43Odm62nPqmpr7wi2AVFid5S/CcuNbQlvz4EFhtwOPjGMhLZfU0OMgARoVDiQ/q4VoXyyAYLNsAlbhtP89o2A6in6uygiVf8sszC0HlBzIDUVKyY6/vWCU+SNGCC9rXO+PsSI/xswlIVLkzF3Op1KvqFAWoQSnYN8stVaZEdgQ1fRyfpi1NX4T2xtZcBx9CuBlj1J2VJR4uU2cycvs0geCyKaQtdYAa6KB1rrGfDJ86ecG+3t1b4m0A7xMaQNjpi0v9UpknS7pM4jxhd6e3mkzKyNs1ZUMbADggk8BIUWsNMkDdPFsp0KN/+ujuqThiVlYFpir95EvRVb7mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CBA9qNjvjpgD/jh7/N6+rbC5v0P46asRI+a+O0JQmd0=;
 b=MY8A8Pm9PcSWUSisG2Dtc166DsFDCj3neI7whhodns/w0XtMHmUp3NGs+MkrPyQBpi+AG62cfiZtuKMXFxD0S1U/2FuMSvfOZD3Uy+UBprNZYyEGm9V94lXz1mVrWuIY3FU7Gd4VO/2381Zc5uIIpiK+El8qtoheFGdTCvboVFzTQn/SyAhHIV50eEcyMk+gtnLYa7af8c9tW8aV6zPRgaZtEwM0GQ/Qbp4IrcNDOL4MmkEC9TM2p96uNIqwrkKJtMe7YpCDt097wGfRy3hjZFoOQJbCw6CMnnBXZElY+LYqsF13hHKgJPdR/t7wC/cFAnhOL1Aa1NH42n0kCInm1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CBA9qNjvjpgD/jh7/N6+rbC5v0P46asRI+a+O0JQmd0=;
 b=Bcr2csv/JVmnREXN3IK6AQ9IdcDydFT9FnIAC1cuCFiDz9ku6LDjDVUzVnBCMbWorn9by8fnxNu6kujL22kTPbDiebC9/3aaffU+R2Sy9b8NSAGdnZezhBTLySDIaTWxhQeyD4AwZfF7OpH7w4Dg9Vvl3311VPvZa3t4Y4fcclY=
Received: from SN6PR11MB2848.namprd11.prod.outlook.com (2603:10b6:805:5d::20)
 by SN6PR11MB3437.namprd11.prod.outlook.com (2603:10b6:805:db::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.22; Mon, 3 Aug
 2020 20:39:03 +0000
Received: from SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::14d2:e9a7:be92:6dbb]) by SN6PR11MB2848.namprd11.prod.outlook.com
 ([fe80::14d2:e9a7:be92:6dbb%7]) with mapi id 15.20.3239.021; Mon, 3 Aug 2020
 20:39:03 +0000
From:   <Don.Brace@microchip.com>
To:     <john.garry@huawei.com>, <hare@suse.de>, <don.brace@microsemi.com>
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
Thread-Index: AQHWP01RAs2BRuCN0k+i3rLwgMsJTKkG5J+AgAABKwCAAAMVAIAgQ/rQ
Date:   Mon, 3 Aug 2020 20:39:03 +0000
Message-ID: <SN6PR11MB28489516D2F4E7631A921BD9E14D0@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <1591810159-240929-13-git-send-email-john.garry@huawei.com>
 <939891db-a584-1ff7-d6a0-3857e4257d3e@huawei.com>
 <3b3ead84-5d2f-dcf2-33d5-6aa12d5d9f7e@suse.de>
 <4319615a-220b-3629-3bf4-1e7fd2d27b92@huawei.com>
In-Reply-To: <4319615a-220b-3629-3bf4-1e7fd2d27b92@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [76.30.208.15]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ac6b5731-1533-41f7-3029-08d837ed42a1
x-ms-traffictypediagnostic: SN6PR11MB3437:
x-microsoft-antispam-prvs: <SN6PR11MB3437F9E3E2B13CEE9A8D63BFE14D0@SN6PR11MB3437.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:2150;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P+NxL8ZxE3OOz5ghIKv85t6VABOxiBRkzMXA1LlPLPNMRniEV2STpfsVC9khqtIoQ2wmRX9he91k8yBgkmeWQaXYJZoi0DG7qgidFnxpA0wp8iI4f1ed7fM56k5O6a5tJ+h3Fmctvfo8KbHke9Ez3BKR21GFwPTChBy6/GOofO3GEIaCICJokbeRjKT7Yj8IR2PNDSFkfllbj/2lJDUVJsbOdNbKQHNT54if2rvcfBgRfHnjadMpmmtBDGcpYPIRlMiLgRRhJPc0fJMbwLGEIwY7Am0u9vzq8Scl+AWUzh9kupjh4Y32kN0xrc8YVdliYE6woRAfTmt67dZeyFLt4d3Tdt8OtpPHOGRo0BJtlMdCt0QkwE/RmiJ147dW6HN2V9hsmMHwAqy5BxDX9R+nBQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2848.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(376002)(396003)(136003)(39860400002)(366004)(478600001)(76116006)(66946007)(33656002)(66476007)(64756008)(66446008)(66556008)(8936002)(4326008)(8676002)(966005)(9686003)(316002)(55016002)(186003)(54906003)(7696005)(2906002)(110136005)(71200400001)(26005)(83380400001)(7416002)(5660300002)(6506007)(52536014)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Of8Mang8cfHxzmfhw/+A9ff1ILjOq6bVG9gtB2lSQ6CTeYy6K4KCEutiELcu+L2+a+jrwpqE4RCyFRLK4hEtVkBYuC4PODIoux84//dR9QYpl75UuSvi/ylJNDO+v88lQx1z5gC8u81AiYqiEHMhVgMwy3R0xqg8NBmlG6hDq7TSoBde0xooRqruO+9Gv4gH7WMMOHPhC5Km9lHN/c7FryqhT5gSdSv+jdKn+N6Q1cdzCJ9D7ir3Zw91EGh83eFKDLy0zvVMch5uxpidUEpFA35JrgRqIo95IGfKdZ2TBTpvloee2KbsDfgSDWALHl/XefO9m49qTeiJWzkrg9rt60A/UCK7ogQJz0yEToprjINuOl7lP3JWWz8ZeeYzZowki5aDgf03PosW/jbSsjolK5/C5UtcGyGCUJ8kzc2k5t/VmSxjxd3ReFf51QPEEVOa1XqCX4+cmQwtczBuWFjuKsSv9qKy/4WVDFinb98XsGY=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2848.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac6b5731-1533-41f7-3029-08d837ed42a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2020 20:39:03.5722
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3XrodmpWwIfKmzTtzMcrfGXDvHPOsqBWQ1Icn0tmfUFhggaZwYje8PUISGoDWLL8lTMW9NL11gygxBFUmpDxiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3437
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

U3ViamVjdDogUmU6IFtQQVRDSCBSRkMgdjcgMTIvMTJdIGhwc2E6IGVuYWJsZSBob3N0X3RhZ3Nl
dCBhbmQgc3dpdGNoIHRvIE1RDQoNCj4+DQo+PiBIaSBEb24sDQo+Pg0KPj4gSSBhbSBwcmVwYXJp
bmcgdGhlIG5leHQgaXRlcmF0aW9uIG9mIHRoaXMgc2VyaWVzLCBhbmQgd2UncmUgZ2V0dGluZyAN
Cj4+IGNsb3NlIHRvIGRyb3BwaW5nIHRoZSBSRkMgdGFncy4gVGhlIHNlcmllcyBoYXMgZ3Jvd24g
YSBiaXQsIGFuZCBJIGFtIA0KPj4gbm90IHN1cmUgd2hhdCB0byBkbyB3aXRoIGhwc2Egc3VwcG9y
dC4NCj4+DQo+PiBUaGUgbGF0ZXN0IHZlcnNpb25zIG9mIHRoaXMgc2VyaWVzIGhhdmUgbm90IGJl
ZW4gdGVzdGVkIGZvciBocHNhLCBBRkFJSy4NCg0KPj52NyBpcyBoZXJlOg0KDQo+Pmh0dHBzOi8v
Z2l0aHViLmNvbS9oaXNpbGljb24va2VybmVsLWRldi9jb21taXRzL3ByaXZhdGUtdG9waWMtYmxr
LW1xLXNoYXJlZC10YWdzLXJmYy12Nw0KDQo+PlNvIHRoYXQgc2hvdWxkIGJlIGdvb2QgdG8gdGVz
dCB3aXRoIGZvciBub3cuDQoNCmNsb25lZCBodHRwczovL2dpdGh1Yi5jb20vaGlzaWxpY29uL2tl
cm5lbC1kZXYNCglicmFuY2ggb3JpZ2luL3ByaXZhdGUtdG9waWMtYmxrLW1xLXNoYXJlZC10YWdz
LXJmYy12Nw0KDQpUaGUgZHJpdmVyIGRpZCBub3QgbG9hZCwgc28gSSBjaGVycnktcGlja2VkIGZy
b20gDQoNCmdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9oYXJl
L3Njc2ktZGV2ZWwuZ2l0IA0KCWJyYW5jaCBvcmlnaW4vcmVzZXJ2ZWQtdGFncy52Ng0KDQp0aGUg
Zm9sbG93aW5nIHBhdGNoZXM6DQo2YTlkMWE5NmVhNDEgaHBzYTogbW92ZSBocHNhX2hiYV9pbnF1
aXJ5IGFmdGVyIHNjc2lfYWRkX2hvc3QoKQ0KZWViNWNkMWZjYTU4IGhwc2E6IHVzZSByZXNlcnZl
ZCBjb21tYW5kcw0KN2RmN2Q4MzgyOTAyIGhwc2E6IHVzZSBzY3NpX2hvc3RfYnVzeV9pdGVyKCkg
dG8gdHJhdmVyc2Ugb3V0c3RhbmRpbmcgY29tbWFuZHMNCjQ4NTg4MWQ2ZDhkYyBocHNhOiBkcm9w
IHJlZmNvdW50IGZpZWxkIGZyb20gQ29tbWFuZExpc3QNCmM0OTgwYWQ1ZTVjYiBzY3NpOiBpbXBs
ZW1lbnQgcmVzZXJ2ZWQgY29tbWFuZCBoYW5kbGluZw0KMzRkMDNmYTk0NWMwIHNjc2k6IGFkZCBz
Y3NpX3tnZXQscHV0fV9pbnRlcm5hbF9jbWQoKSBoZWxwZXINCjQ1NTZlNTA0NTBjOCBibG9jazog
YWRkIGZsYWcgZm9yIGludGVybmFsIGNvbW1hbmRzDQoxMzgxMjVmNzRiMjUgc2NzaTogaHBzYTog
TGlmdCB7QklHXyx9SU9DVExfQ29tbWFuZF9zdHJ1Y3QgY29weXtpbixvdXR9IGludG8gaHBzYV9p
b2N0bCgpDQpjYjE3YzFiNjliMTcgc2NzaTogaHBzYTogRG9uJ3QgYm90aGVyIHdpdGggdm1hbGxv
YyBmb3IgQklHX0lPQ1RMX0NvbW1hbmRfc3RydWN0DQoxMDEwMGZmZDVmNjUgc2NzaTogaHBzYTog
R2V0IHJpZCBvZiBjb21wYXRfYWxsb2NfdXNlcl9zcGFjZSgpDQowNmI0M2Y5NjhkYjUgc2NzaTog
aHBzYTogaHBzYV9pb2N0bCgpOiBUaWR5IHVwIGEgYml0DQoNClRoZSBkcml2ZXIgbG9hZHMgYW5k
IEkgcmFuIHNvbWUgbWtlMmZzLCBtb3VudC91bW91bnQgdGVzdHMsDQpidXQgSSBhbSBnZXR0aW5n
IGFuIGV4dHJhIGRldmljZXMgaW4gdGhlIGxpc3Qgd2hpY2ggZG9lcyBub3QNCnNlZW0gdG8gYmUg
Y29taW5nIGZyb20gaHBzYSBkcml2ZXIuDQoNCkkgaGF2ZSBub3QgeWV0IGhhZCB0aW1lIHRvIGRp
YWdub3NlIHRoaXMgaXNzdWUuDQoNCmxzc2NzaQ0KWzE6MDowOjBdICAgIGRpc2sgICAgQVNNVCAg
ICAgMjEwNSAgICAgICAgICAgICAwICAgICAvZGV2L3NkaSANClsxNDowOi0xOjBdICB0eXBlPz8/
IG51bGxudWxsIG51bGxudWxsbnVsbG51bGwgbnVsbCAgLSAgICAgICAgDQpbMTQ6MDowOjBdICAg
c3RvcmFnZSBIUCAgICAgICBIMjQwICAgICAgICAgICAgIDcuMTkgIC0gICAgICAgIA0KWzE0OjA6
MTowXSAgIGRpc2sgICAgQVRBICAgICAgTUIwMDIwMDBHV0ZHSCAgICBIUEcwICAvZGV2L3NkYSAN
ClsxNDowOjI6MF0gICBkaXNrICAgIEFUQSAgICAgIE1CMDAyMDAwR1dGR0ggICAgSFBHMCAgL2Rl
di9zZGIgDQpbMTQ6MDozOjBdICAgZGlzayAgICBIUCAgICAgICBFRjA0NTBGQVJNViAgICAgIEhQ
RDUgIC9kZXYvc2RjIA0KWzE0OjA6NDowXSAgIGRpc2sgICAgQVRBICAgICAgTUIwMDIwMDBHV0ZH
SCAgICBIUEcwICAvZGV2L3NkZCANClsxNDowOjU6MF0gICBkaXNrICAgIEFUQSAgICAgIE1CMDAy
MDAwR1dGR0ggICAgSFBHMCAgL2Rldi9zZGUgDQpbMTQ6MDo2OjBdICAgZGlzayAgICBIUCAgICAg
ICBFRjA0NTBGQVJNViAgICAgIEhQRDUgIC9kZXYvc2RmIA0KWzE0OjA6NzowXSAgIGRpc2sgICAg
QVRBICAgICAgVkIwMjUwRUFWRVIgICAgICBIUEc3ICAvZGV2L3NkZyANClsxNDowOjg6MF0gICBk
aXNrICAgIEFUQSAgICAgIE1CMDUwMEdDRUhGICAgICAgSFBHQyAgL2Rldi9zZGggDQpbMTQ6MDo5
OjBdICAgZW5jbG9zdSBIUCAgICAgICBIMjQwICAgICAgICAgICAgIDcuMTkgIC0gICAgICAgIA0K
WzE1OjA6LTE6MF0gIHR5cGU/Pz8gbnVsbG51bGwgbnVsbG51bGxudWxsbnVsbCBudWxsICAtICAg
ICAgICANClsxNTowOjA6MF0gICBzdG9yYWdlIEhQICAgICAgIFA0NDAgICAgICAgICAgICAgNy4x
OSAgLSAgICAgICAgDQpbMTU6MTowOjBdICAgZGlzayAgICBIUCAgICAgICBMT0dJQ0FMIFZPTFVN
RSAgIDcuMTkgIC9kZXYvc2RqIA0KWzE1OjE6MDoxXSAgIGRpc2sgICAgSFAgICAgICAgTE9HSUNB
TCBWT0xVTUUgICA3LjE5ICAvZGV2L3NkayANClsxNToxOjA6Ml0gICBkaXNrICAgIEhQICAgICAg
IExPR0lDQUwgVk9MVU1FICAgNy4xOSAgL2Rldi9zZGwgDQpbMTU6MTowOjNdICAgZGlzayAgICBI
UCAgICAgICBMT0dJQ0FMIFZPTFVNRSAgIDcuMTkgIC9kZXYvc2RtIA0KWzE2OjA6LTE6MF0gIHR5
cGU/Pz8gbnVsbG51bGwgbnVsbG51bGxudWxsbnVsbCBudWxsICAtICAgICAgICANClsxNjowOjA6
MF0gICBzdG9yYWdlIEhQICAgICAgIFA0NDEgICAgICAgICAgICAgNy4xOSAgLSAgICAgICAgDQoN
Cg0KDQo=
