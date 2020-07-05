Return-Path: <SRS0=7Ct3=AQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11A9FC433E0
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Jul 2020 11:14:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D43762075B
	for <linux-scsi@archiver.kernel.org>; Sun,  5 Jul 2020 11:14:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="JkkNfOk+";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="VcAebqCQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbgGELOZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 5 Jul 2020 07:14:25 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:29964 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbgGELOZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Jul 2020 07:14:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593947663; x=1625483663;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=zOF7vBY4f/8TDlS4v32vVXCiJApReqPPQHenuTTLL0g=;
  b=JkkNfOk+oZFPoVLyb4ut6tJ7GMxIy4rAmOrtXtE54NoGpmnP3+bAoQSi
   1ebdhf8IB8qS3DiYbjunn1kfhiui933I4qo7zpKXUMQfocFxKOrYHvzLF
   IDDi74CbQMylphCApn05TYHO0j+BCtcideOXOsTFyRu3lqzgW506BgLiM
   fM1++Rx0tkBhgj+ER1k4zz5jWqgOXMO0u3RG4hf8pXe0zA9ft8mkXW3LU
   ssU11DBvwNA/jo1tnB4f2LAf44Bi+yWAd+Fc/5TUkMzEIpoYtBxcI9pgA
   oZp+SXtgBsOgrw8cyhAiLkkCZtzlwtJnh2WJmyntfskD4gaVCCYIP+WYh
   g==;
IronPort-SDR: Eg4dSACsUUKokK+tcALGvn1djMmFoxbsTWLYGmbr8R7tBCFr3lP/vcM94VsN7W2XRUl8ba7QVF
 oyXIJ15K+q/fLOEG6cf4Dwp+0UDYVd3VAaNSW8AMWmNioHJCqxfsfdZx9gKKjN0xtdyBi3J8tX
 6XzKz6FUbPHkrbYpo9HRhIHoVSTF4iWtdWQj9RUnsZfZ09odSiYxVFbaknQy4Sans4i+zdSLNx
 4uw/6gX2Nzrztolp3LkikoPEfgn5LZaS5x++kT6ss1JNS5LnQu1dswbcTqnOFi27m3GCPARy3b
 +bs=
X-IronPort-AV: E=Sophos;i="5.75,314,1589212800"; 
   d="scan'208";a="141674477"
Received: from mail-dm6nam12lp2174.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.174])
  by ob1.hgst.iphmx.com with ESMTP; 05 Jul 2020 19:14:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QGXjXdfBleA0GWAVsUSsRTjQGYrBOmQuRj14D/nj0cvuYA85jmeN+bUtZ0qSGJ9rkxndKnKDElCnKGnkzvLTOprR3An1iRtqTz32TBoq5fwX8ZBLZgx+1wB6mQuZ+Jn7X1mL1YdvRIFRQ7uaIbP1Ue4zpqLjIl5XQm3oCBKi2eRTETGsWj6r2Od70A4TIXMpuzk3wvYA0A+Spo065LUCDL/ZFV0JYcbOz7hZLHjdlKPmxc6421Lh0CZhOFOVkM0SbM03jLlBX4a9IJ9J4UeQWxWgyxtq9c36aDgvn5eW9IhK91REgN/BES+0PQn8YWRttChcJeDX5e/jwaUY3AL9RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zOF7vBY4f/8TDlS4v32vVXCiJApReqPPQHenuTTLL0g=;
 b=OBP9bRsciL8bR3BfZllpdGLAQjkkc0YyKehcGuC9p0QQd7fuifG9kQ1sAsh6eVjA8DU9+S8Hk/6BbFB7+zXjzk7mntxRTDIn3dqkjIC6Z9yxMJNOV+jEGQl8XfumXYsvDmYuZXVMp/WfG/gfb+oSaJ4QjnStzrVK5n7UCHEQifRR4OI7JOtL422TtoMFd6dXfQHnGNCDAWWG7nowyfeI5ImeXT9QTRU5lNafsNqrmrWZk1FBRn+m9Lqhqlr4s2+pYweL2up3H5d+ySUEFnuZBlYZevfPqLvo2MjEia0OfjVW4SUOv7uIYZDMjFclMZQmbTzz7bRXkDKxRfgvi+tbhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zOF7vBY4f/8TDlS4v32vVXCiJApReqPPQHenuTTLL0g=;
 b=VcAebqCQUxTwdICKjqwLaqySVBEOmy/1Sq2hTYH/MYsZHu10E7gR/jO2lnRG7mGBj63pabofvCN//U9CXXSUt2EV6cYRCqNdBMIfr+jHNIziJfi8jklplU6YlZ0JKuna4bgp3K8uX6anZCPkwmfK0l3Cpllv9jSu4MTL4SRqF5A=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB5199.namprd04.prod.outlook.com (2603:10b6:805:ff::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.23; Sun, 5 Jul
 2020 11:14:19 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2%4]) with mapi id 15.20.3153.029; Sun, 5 Jul 2020
 11:14:19 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Kiwoong Kim <kwmad.kim@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "grant.jung@samsung.com" <grant.jung@samsung.com>,
        "sc.suh@samsung.com" <sc.suh@samsung.com>,
        "hy50.seo@samsung.com" <hy50.seo@samsung.com>,
        "sh425.lee@samsung.com" <sh425.lee@samsung.com>
Subject: RE: [RFC PATCH v3 1/2] ufs: support various values per device
Thread-Topic: [RFC PATCH v3 1/2] ufs: support various values per device
Thread-Index: AQHWUPwhGei/mSSMqke6lbLQtkKSIaj402IA
Date:   Sun, 5 Jul 2020 11:14:19 +0000
Message-ID: <SN6PR04MB464046C39B0B2AC5E36A7BF5FC680@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <cover.1593753896.git.kwmad.kim@samsung.com>
        <CGME20200703053756epcas2p1f32da04da87c8f56a6052caada95fb9a@epcas2p1.samsung.com>
 <dc21b368f44c8a9a257d1b00549e3b5aeec00755.1593753896.git.kwmad.kim@samsung.com>
In-Reply-To: <dc21b368f44c8a9a257d1b00549e3b5aeec00755.1593753896.git.kwmad.kim@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c6230d5a-0bb5-4fcb-a7d1-08d820d49026
x-ms-traffictypediagnostic: SN6PR04MB5199:
x-microsoft-antispam-prvs: <SN6PR04MB519953E8A72EC2D65DCA23F3FC680@SN6PR04MB5199.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 045584D28C
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IoJLJKnY6cCeH2EWdFyrrcRN/mC7Y6gftpB7zDaI+xebiSfHfzloJT65mW9X++WyTc9ILHvsj51LdHcg+j7wh2wI8zsYns8VyCodS9ASogEE690h24RtBA1TMEa86gT/lfRBxZ+e7fjLi0g2jxvJpcC4OW9SthhZEbnWD5kY9otgPHD2PMBqtUd6wdel872RnsNwWNOxKf2eq0nx+QRm5qaUytrPIdx74LioA0MFb5YoKDcFRXO8VxTVamQ37gQ+BFy/BMyAB6RLagyJR2R+Nhyfkd/fm6sguSzOISIm0QyEushzuTVhAJwHbByXBIBsxBKKe233pDjNB+Fwvj5XrHkNplvYeuS2gARdGzeefP4HwyCH9a+wZC6uVJ91AzZcRMAuGd1e+q9lAUPdAjCHkA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(136003)(366004)(39850400004)(396003)(66946007)(52536014)(76116006)(64756008)(66556008)(66476007)(66446008)(9686003)(7416002)(2906002)(55016002)(8936002)(478600001)(316002)(110136005)(5660300002)(8676002)(7696005)(26005)(33656002)(71200400001)(86362001)(186003)(6506007)(461764006)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: vC7wCHsHt40gCts10LZpDwefwOQN9RdTvpD10+le66VG76Wun/Bg7sELTfnGh3Yp2QIU3rG1gWbRG961axf5BrqcUJCRPViiBQfmBoKFLKwq5cWS/AlxhvSl5ch8UnKzgCuzu1xK20lp5v9nrdLuK+o470WdiWv2/z92OsvKHM2WYPi8nQOJo64iW3p8nLZ355ysKfBECLyHBlHOklwcGtQeqWDhsEbVHIX1r9K/TnFGaQriRNbqIdERarkBYbOU/3k87RP1QBIPHlArYxd4fkZ4o1mHmPUInegPPSklc0Dn4O48ivfP2RuV8U3aou6lefQ0/jZmTJCLAEjaOqSztIWVIwiGKfV4SYK4GlJKcwwvfDzUHLbj8GCQXefqTBOmvW88OaMvhYRbvF6EAKp5sgpfc5kKIU/Ud8Fm8p04xT9XPZklEmLDYDn/NlgivXg0zyfx5zswPnhaelYq3WkRW0/3XIDDR+lrMoZSScevB4c=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6230d5a-0bb5-4fcb-a7d1-08d820d49026
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2020 11:14:19.4584
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A+7HRVVYs+j4jhNqnUtNEFVZ52F5KcuD4ZNls49afX+gcNkRK3Zf0oQRUl7NfDlmOjpUZDrBpefbNDSPXE3D3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5199
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

IA0KPiANCj4gUmVzcGVjdGl2ZSBVRlMgZGV2aWNlcyBoYXZlIHRoZWlyIG93biBjaGFyYWN0ZXJp
c3RpY3MgYW5kDQo+IG1hbnkgb2YgdGhlbSBjb3VsZCBiZSBhIGZvcm0gb2YgbnVtYmVycywgc3Vj
aCBhcyB0aW1lb3V0DQo+IGFuZCBhIG51bWJlciBvZiByZXRpcmVzLiBUaGlzIGludHJvZHVjZXMg
dGhlIHdheSB0byBzZXQNCj4gdGhvc2UgdGhpbmdzIHBlciBzcGVjaWZpYyBkZXZpY2UgdmVuZG9y
IG9yIHNwZWNpZmljIGRldmljZS4NCj4gDQo+IEkgd3JvdGUgdGhpcyBsaWtlIHRoZSBzdHlsZSBv
ZiB1ZnNfZml4dXBzIHN0dWZmcy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEtpd29vbmcgS2ltIDxr
d21hZC5raW1Ac2Ftc3VuZy5jb20+DQpUaGlzIHBhdGNoIGxlZ2l0aW1pemUgcXVpcmtzIG9mIGFs
bCBraW5kcyBhbmQgc2hhcGVzLg0KSSBhbSBub3Qgc3VyZSB0aGF0IHdlIHNob3VsZCBhbGxvdyBp
dC4NCg0KDQo+IC0tLQ0KPiAgZHJpdmVycy9zY3NpL3Vmcy91ZnNfcXVpcmtzLmggfCAxMyArKysr
KysrKysrKysrDQo+ICBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jICAgICB8IDM5DQo+ICsrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiAgZHJpdmVycy9zY3NpL3Vmcy91
ZnNoY2QuaCAgICAgfCAgMSArDQo+ICAzIGZpbGVzIGNoYW5nZWQsIDUzIGluc2VydGlvbnMoKykN
Cj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvdWZzL3Vmc19xdWlya3MuaCBiL2RyaXZl
cnMvc2NzaS91ZnMvdWZzX3F1aXJrcy5oDQo+IGluZGV4IDJhMDA0MTQuLmYwNzQwOTMgMTAwNjQ0
DQo+IC0tLSBhL2RyaXZlcnMvc2NzaS91ZnMvdWZzX3F1aXJrcy5oDQo+ICsrKyBiL2RyaXZlcnMv
c2NzaS91ZnMvdWZzX3F1aXJrcy5oDQo+IEBAIC0yOSw2ICsyOSwxOSBAQCBzdHJ1Y3QgdWZzX2Rl
dl9maXggew0KPiAgICAgICAgIHVuc2lnbmVkIGludCBxdWlyazsNCj4gIH07DQo+IA0KPiArZW51
bSBkZXZfdmFsX3R5cGUgew0KPiArICAgICAgIERFVl9WQUxfRkRFVklDRUlOSVQgICAgID0gMHgw
LA0KDQogICAgICAgICAgICAvKiBrZWVwIGxhc3QgKi8NCj4gKyAgICAgICBERVZfVkFMX05VTSwN
Cj4gK307DQo+ICsNCj4gK3N0cnVjdCB1ZnNfZGV2X3ZhbHVlIHsNCj4gKyAgICAgICB1MTYgd21h
bnVmYWN0dXJlcmlkOw0KPiArICAgICAgIHU4ICptb2RlbDsNCj4gKyAgICAgICB1MzIga2V5Ow0K
PiArICAgICAgIHUzMiB2YWw7DQo+ICsgICAgICAgYm9vbCBlbmFibGU7DQo+ICt9Ow0KPiArDQo+
ICAjZGVmaW5lIEVORF9GSVggeyB9DQo+IA0KPiAgLyogYWRkIHNwZWNpZmljIGRldmljZSBxdWly
ayAqLw0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYyBiL2RyaXZlcnMv
c2NzaS91ZnMvdWZzaGNkLmMNCj4gaW5kZXggNTJhYmU4Mi4uYjI2ZjE4MiAxMDA2NDQNCj4gLS0t
IGEvZHJpdmVycy9zY3NpL3Vmcy91ZnNoY2QuYw0KPiArKysgYi9kcml2ZXJzL3Njc2kvdWZzL3Vm
c2hjZC5jDQo+IEBAIC0yMDcsNiArMjA3LDIxIEBAIHN0YXRpYyBzdHJ1Y3QgdWZzX2Rldl9maXgg
dWZzX2ZpeHVwc1tdID0gew0KPiAgICAgICAgIEVORF9GSVgNCj4gIH07DQo+IA0KPiArc3RhdGlj
IGNvbnN0IHN0cnVjdCB1ZnNfZGV2X3ZhbHVlIHVmc19kZXZfdmFsdWVzW10gPSB7DQo+ICsgICAg
ICAgezAsIDAsIDAsIDAsIGZhbHNlfSwNCj4gK307DQo+ICsNCj4gK3N0YXRpYyBpbmxpbmUgYm9v
bA0KPiArdWZzX2dldF9kZXZfc3BlY2lmaWNfdmFsdWUoc3RydWN0IHVmc19oYmEgKmhiYSwNCj4g
KyAgICAgICAgICAgICAgICAgICAgICAgICAgZW51bSBkZXZfdmFsX3R5cGUgdHlwZSwgdTMyICp2
YWwpDQo+ICt7DQpJZiAoQVJSQVlfU0laRSh1ZnNfZGV2X3ZhbHVlcykgPD0gdHlwZSkNCiAgICBy
ZXR1cm4gZmFsc2U7DQoNCg0KVGhhbmtzLA0KQXZyaQ0K
