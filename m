Return-Path: <SRS0=RMqd=ZO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1029BC432C0
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 05:05:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A39942068F
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 05:05:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="wzFbSgyQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbfKVFFB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Nov 2019 00:05:01 -0500
Received: from mx0a-002c1b01.pphosted.com ([148.163.151.68]:57916 "EHLO
        mx0a-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725857AbfKVFFB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 Nov 2019 00:05:01 -0500
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAM53nxn020554;
        Thu, 21 Nov 2019 21:04:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version;
 s=proofpoint20171006; bh=QynZnhJSmanBtHu3bU6Nd4fZwVc08F6WF97NQ1oavv4=;
 b=wzFbSgyQOicxH03aQiVisMwmmEX9LE0Uu12CKn2gGYvkEvpT+67l/iMbFOF+ICKKUeun
 f3gkrkFylP0+DpWP2eeEGtvPXR63O9p4JWiuL8UG9nKIhfTt0rtTKq7i9nX9rNObLz6d
 gOxVR929fyb38HPYNJHOEiir6g42uQMdu56ojY7lbP4onJhVGUO0ttkafA7lfRtZCzwa
 wf5XXYUDipafgrFnJJckBtAhMb4z+hw+mLnajF44JP8kUy+PvBfunJxHbn611zc/vKXP
 2sAk8yuy57AIx7dBnQt5PMUTC27+Xw7CUT00aW5+X5BOq0NawTjS2lgys1CWpFmceJ4g BQ== 
Received: from nam03-dm3-obe.outbound.protection.outlook.com (mail-dm3nam03lp2050.outbound.protection.outlook.com [104.47.41.50])
        by mx0a-002c1b01.pphosted.com with ESMTP id 2wah2pw9r6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Nov 2019 21:04:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lvsOQcpYI+awIIZUOFKOgdL6BWnuuh1OEQ0oUPBBIW32QZkTBzzDHpQ7i2wmubaXs782Dc31Aa50jXvaXCIGBRcghJlnPvQ/+waY2x4xPq1Hqf4hXfUrnQSIHcjPBNhIuYGjEn/f9afB+dtUWaCmu4x8hKqZBL1Wu825eYpOkr7ghnsn57MWF7mHxLeT0XLi6H4b+GO8ZPCYL6iopS2FqkSeTqdc+A4UXqPzXsyEHVBE8ak5hHzT154fxHip0xD8pNSXpaR0A37ZlDuxp1o8bUhdk99IbCqXrQtbYRLOvHxKZc7HK6yfMiJrvfa12ea39QQ4BiV8MTvaB2sDsnvwOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QynZnhJSmanBtHu3bU6Nd4fZwVc08F6WF97NQ1oavv4=;
 b=GjNFxEiiqqzKezdi9E1qWmOF3weCRfo87LR6QViQFHInSsTw48ABGucLS51TaC+8pJyDtqz4UPpjmN2dvh0HcGePtF+/FsbuMkTQhu+vzYR7MGb0zLY6cpofKX0B8Vf/8U3VekLyQEpR+lveYlbaH5q3xOygEHJ9SzTiM7ZwEVpgtxBifXW40Pb2mbWYTVVDoS2sZrQQteqMHpvb4vCTHoJYEuYuOk/WP9ZXdYTAVogWCoIok51mEbwVZqOLrksVm+oiEsB6qKIDMAP27RxdqXqtbdSHX8Rw5YgZyc3FDFHIK6bPYUqcfmte++qs+/0hIJP6OgwJ3EmrquPQwP8Yqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from MN2PR02MB5999.namprd02.prod.outlook.com (20.179.85.78) by
 MN2PR02MB6815.namprd02.prod.outlook.com (52.135.49.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.19; Fri, 22 Nov 2019 05:04:55 +0000
Received: from MN2PR02MB5999.namprd02.prod.outlook.com
 ([fe80::807d:c545:461b:b988]) by MN2PR02MB5999.namprd02.prod.outlook.com
 ([fe80::807d:c545:461b:b988%5]) with mapi id 15.20.2474.021; Fri, 22 Nov 2019
 05:04:54 +0000
From:   Mark Harvey <mark.harvey@nutanix.com>
To:     Quinn Tran <qutran@marvell.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
CC:     "linux@yadro.com" <linux@yadro.com>
Subject: Re: [EXT] [PATCH v2 13/15] scsi: qla2xxx: Add async mode for
 qla24xx_els_dcmd_iocb
Thread-Topic: [EXT] [PATCH v2 13/15] scsi: qla2xxx: Add async mode for
 qla24xx_els_dcmd_iocb
Thread-Index: AQHVn/G+YqKT7gZJP0SU2ZoZAt9vVqeWPGMAgAEg3YA=
Date:   Fri, 22 Nov 2019 05:04:52 +0000
Message-ID: <81096D5B-FEC9-4A40-BE7B-ADB8CA1C5CA2@nutanix.com>
References: <20191120222723.27779-1-r.bolshakov@yadro.com>
 <20191120222723.27779-14-r.bolshakov@yadro.com>
 <BYAPR18MB2759E4C4CDDA0D5447D7A5BDD54E0@BYAPR18MB2759.namprd18.prod.outlook.com>
In-Reply-To: <BYAPR18MB2759E4C4CDDA0D5447D7A5BDD54E0@BYAPR18MB2759.namprd18.prod.outlook.com>
Accept-Language: en-AU, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [220.101.117.65]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 662362ad-0d0e-4e71-e139-08d76f09831c
x-ms-traffictypediagnostic: MN2PR02MB6815:
x-microsoft-antispam-prvs: <MN2PR02MB6815D3900E5BB3E3EAEAA3D2EE490@MN2PR02MB6815.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(39860400002)(376002)(396003)(136003)(366004)(189003)(199004)(13464003)(33656002)(102836004)(186003)(6512007)(2501003)(26005)(6436002)(53546011)(229853002)(6486002)(76176011)(8676002)(81156014)(6506007)(81166006)(8936002)(6246003)(3846002)(4326008)(2906002)(6116002)(478600001)(110136005)(316002)(305945005)(7736002)(99286004)(66946007)(66066001)(66446008)(64756008)(66556008)(36756003)(14444005)(66476007)(256004)(14454004)(91956017)(25786009)(71190400001)(71200400001)(2201001)(11346002)(2616005)(86362001)(446003)(5660300002)(44832011)(76116006)(64030200001);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR02MB6815;H:MN2PR02MB5999.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nutanix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: G5Nny4D1aDpxxqrCl41ZaGIr+333pFTlkGhjUKkS8bo0QaPOLcHnLMA0zhIjwuPK+5zQAeNKsBCEGxmYfl8Mwj4A1StwBM12kK3A4GNw7WgRTjfi2n+f/pfbmDSJUQbGVaodY2eVKld35hciQsN8MrKBumKyp0UEjnwiRNRS68Heh6OTqMnpb/5kABFz+6kGNK25CqyeukMUgCE9M7sFnx6ZDdlAexGJ/dKLScHcnMKN2QylaEw/iGU5BKvlaV2bKp1pWh2EUW8oYK6dNSZipb9Dz6bYFKhZVuJmaUcfF9TD2bHm/PHQBnDaYGP5/M+CyzrWcgXZ8zeNpzceH+GyYYfuGPF86cTWE21gMagNCbJo5mPV5smsaUBGI3l3SUdKAg6y6mMcrUrfl3kv+/2d1Sm7jRj7yUn05us9hiYErKSNp7kc6Wn5qm5O9NibZYEE
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <21CBC03EB5A17C4492EB4462CDB5948A@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 662362ad-0d0e-4e71-e139-08d76f09831c
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2019 05:04:53.8382
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NcDouiEDJ3hNp20J3WV6T74yzNi/YvmdmeBQ+qdPLwwcoZaR+PBwJvmb1OH+PFUaFFy/0flud/bxnFmJpnFtGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR02MB6815
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-21_07:2019-11-21,2019-11-21 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

V291bGQgdGhpcyBub3QgcmVzdWx0IGluIGEgbWVtb3J5IGxlYWsgaW4gdGhlICdlbHNlJyBwYXRo
IC0gc2tpcGluZyBzcC0+ZnJlZShzcCk/DQogIA0KICAtCXdhaXRfZm9yX2NvbXBsZXRpb24oJmVs
c2lvLT51LmVsc19sb2dvLmNvbXApOw0KICAgICsJaWYgKHdhaXQpIHsNCiAgICArCQl3YWl0X2Zv
cl9jb21wbGV0aW9uKCZlbHNpby0+dS5lbHNfbG9nby5jb21wKTsNCiAgICArCX0gZWxzZSB7DQog
ICAgKwkJZ290byBkb25lOw0KICAgICsJfQ0KICAgICANCiAgICAgCXNwLT5mcmVlKHNwKTsNCiAg
ICArZG9uZToNCiAgICAgCXJldHVybiBydmFsOw0KICAgICB9DQoNCu+7v09uIDIyLzExLzE5LCA5
OjUxIGFtLCAidGFyZ2V0LWRldmVsLW93bmVyQHZnZXIua2VybmVsLm9yZyBvbiBiZWhhbGYgb2Yg
UXVpbm4gVHJhbiIgPHRhcmdldC1kZXZlbC1vd25lckB2Z2VyLmtlcm5lbC5vcmcgb24gYmVoYWxm
IG9mIHF1dHJhbkBtYXJ2ZWxsLmNvbT4gd3JvdGU6DQoNCiAgICBMb29rcyBnb29kLg0KICAgIA0K
ICAgIEFja2VkLWJ5OiBRdWlubiBUcmFuIDxxdXRyYW5AbWFydmVsbC5jb20+DQogICAgDQogICAg
DQogICAgUmVnYXJkcywNCiAgICBRdWlubiBUcmFuDQogICAgDQogICAgLS0tLS1PcmlnaW5hbCBN
ZXNzYWdlLS0tLS0NCiAgICBGcm9tOiBSb21hbiBCb2xzaGFrb3YgPHIuYm9sc2hha292QHlhZHJv
LmNvbT4gDQogICAgU2VudDogV2VkbmVzZGF5LCBOb3ZlbWJlciAyMCwgMjAxOSAyOjI3IFBNDQog
ICAgVG86IGxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnOyB0YXJnZXQtZGV2ZWxAdmdlci5rZXJu
ZWwub3JnDQogICAgQ2M6IGxpbnV4QHlhZHJvLmNvbTsgUm9tYW4gQm9sc2hha292IDxyLmJvbHNo
YWtvdkB5YWRyby5jb20+OyBRdWlubiBUcmFuIDxxdXRyYW5AbWFydmVsbC5jb20+DQogICAgU3Vi
amVjdDogW0VYVF0gW1BBVENIIHYyIDEzLzE1XSBzY3NpOiBxbGEyeHh4OiBBZGQgYXN5bmMgbW9k
ZSBmb3IgcWxhMjR4eF9lbHNfZGNtZF9pb2NiDQogICAgDQogICAgRXh0ZXJuYWwgRW1haWwNCiAg
ICANCiAgICAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tDQogICAgcWxhMjR4eF9lbHNfZGNtZF9pb2NiKCkgcGVyZm9y
bXMgTE9HTyBhbmQgbWlnaHQgYmUgaW52b2tlZCBpbiBjb250ZXh0cyB3aGVyZSBpdCBpcyBwcm9o
aWJpdGVkIHRvIHNsZWVwLiBUaGUgbmV3IHdhaXQgcGFyYW1ldGVyIHByb3ZpZGVzIGEgd2F5IHRv
IHVzZSB0aGUgZnVuY3Rpb24gaW4gc3VjaCBjb250ZXh0LCBzaW1pbGFybHkgdG8gcWxhMjR4eF9l
bHNfZGNtZDJfaW9jYigpLg0KICAgIA0KICAgIENjOiBRdWlubiBUcmFuIDxxdXRyYW5AbWFydmVs
bC5jb20+DQogICAgQ2M6IEhpbWFuc2h1IE1hZGhhbmkgPGhtYWRoYW5pQG1hcnZlbGwuY29tDQog
ICAgU2lnbmVkLW9mZi1ieTogUm9tYW4gQm9sc2hha292IDxyLmJvbHNoYWtvdkB5YWRyby5jb20+
DQogICAgLS0tDQogICAgIGRyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9hdHRyLmMgICB8ICAyICst
DQogICAgIGRyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9nYmwuaCAgICB8ICAyICstDQogICAgIGRy
aXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pb2NiLmMgICB8IDExICsrKysrKysrKy0tDQogICAgIGRy
aXZlcnMvc2NzaS9xbGEyeHh4L3FsYV90YXJnZXQuYyB8ICAyICstDQogICAgIDQgZmlsZXMgY2hh
bmdlZCwgMTIgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkNCiAgICANCiAgICBkaWZmIC0t
Z2l0IGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2F0dHIuYyBiL2RyaXZlcnMvc2NzaS9xbGEy
eHh4L3FsYV9hdHRyLmMgaW5kZXggNDgxYzA1ZGJlYTA2Li4zNWM3MDNlYzU5YWQgMTAwNjQ0DQog
ICAgLS0tIGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2F0dHIuYw0KICAgICsrKyBiL2RyaXZl
cnMvc2NzaS9xbGEyeHh4L3FsYV9hdHRyLmMNCiAgICBAQCAtODI4LDcgKzgyOCw3IEBAIHFsYTJ4
MDBfaXNzdWVfbG9nbyhzdHJ1Y3QgZmlsZSAqZmlscCwgc3RydWN0IGtvYmplY3QgKmtvYmosDQog
ICAgIA0KICAgICAJcWxfbG9nKHFsX2xvZ19pbmZvLCB2aGEsIDB4NzBlNCwgIiVzOiAlZFxuIiwg
X19mdW5jX18sIHR5cGUpOw0KICAgICANCiAgICAtCXFsYTI0eHhfZWxzX2RjbWRfaW9jYih2aGEs
IEVMU19EQ01EX0xPR08sIGRpZCk7DQogICAgKwlxbGEyNHh4X2Vsc19kY21kX2lvY2IodmhhLCBF
TFNfRENNRF9MT0dPLCBkaWQsIHRydWUpOw0KICAgICAJcmV0dXJuIGNvdW50Ow0KICAgICB9DQog
ICAgIA0KICAgIGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfZ2JsLmggYi9k
cml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfZ2JsLmggaW5kZXggNWIxNjNhZDg1YzM0Li5kZjBmMzQy
MWUzYmIgMTAwNjQ0DQogICAgLS0tIGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2dibC5oDQog
ICAgKysrIGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2dibC5oDQogICAgQEAgLTQzLDcgKzQz
LDcgQEAgZXh0ZXJuIHZvaWQgcWxhMngwMF9jbGVhcl9sb29wX2lkKGZjX3BvcnRfdCAqZmNwb3J0
KTsgIGV4dGVybiBpbnQgcWxhMngwMF9mYWJyaWNfbG9naW4oc2NzaV9xbGFfaG9zdF90ICosIGZj
X3BvcnRfdCAqLCB1aW50MTZfdCAqKTsgIGV4dGVybiBpbnQgcWxhMngwMF9sb2NhbF9kZXZpY2Vf
bG9naW4oc2NzaV9xbGFfaG9zdF90ICosIGZjX3BvcnRfdCAqKTsNCiAgICAgDQogICAgLWV4dGVy
biBpbnQgcWxhMjR4eF9lbHNfZGNtZF9pb2NiKHNjc2lfcWxhX2hvc3RfdCAqLCBpbnQsIHBvcnRf
aWRfdCk7DQogICAgK2V4dGVybiBpbnQgcWxhMjR4eF9lbHNfZGNtZF9pb2NiKHNjc2lfcWxhX2hv
c3RfdCAqLCBpbnQsIHBvcnRfaWRfdCwgDQogICAgK2Jvb2wpOw0KICAgICBleHRlcm4gaW50IHFs
YTI0eHhfZWxzX2RjbWQyX2lvY2Ioc2NzaV9xbGFfaG9zdF90ICosIGludCwgZmNfcG9ydF90ICos
IGJvb2wpOyAgZXh0ZXJuIHZvaWQgcWxhMngwMF9lbHNfZGNtZDJfZnJlZShzY3NpX3FsYV9ob3N0
X3QgKnZoYSwNCiAgICAgCQkJCSAgIHN0cnVjdCBlbHNfcGxvZ2kgKmVsc19wbG9naSk7DQogICAg
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pb2NiLmMgYi9kcml2ZXJzL3Nj
c2kvcWxhMnh4eC9xbGFfaW9jYi5jIGluZGV4IDUzY2NiZDZiNzFlZC4uMTJiMzdiNzExYWU4IDEw
MDY0NA0KICAgIC0tLSBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pb2NiLmMNCiAgICArKysg
Yi9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaW9jYi5jDQogICAgQEAgLTI1NjIsNyArMjU2Miw3
IEBAIHN0YXRpYyB2b2lkIHFsYTJ4MDBfZWxzX2RjbWRfc3BfZG9uZShzcmJfdCAqc3AsIGludCBy
ZXMpDQogICAgIA0KICAgICBpbnQNCiAgICAgcWxhMjR4eF9lbHNfZGNtZF9pb2NiKHNjc2lfcWxh
X2hvc3RfdCAqdmhhLCBpbnQgZWxzX29wY29kZSwNCiAgICAtICAgIHBvcnRfaWRfdCByZW1vdGVf
ZGlkKQ0KICAgICsgICAgcG9ydF9pZF90IHJlbW90ZV9kaWQsIGJvb2wgd2FpdCkNCiAgICAgew0K
ICAgICAJc3JiX3QgKnNwOw0KICAgICAJZmNfcG9ydF90ICpmY3BvcnQgPSBOVUxMOw0KICAgIEBA
IC0yNjAxLDYgKzI2MDEsOCBAQCBxbGEyNHh4X2Vsc19kY21kX2lvY2Ioc2NzaV9xbGFfaG9zdF90
ICp2aGEsIGludCBlbHNfb3Bjb2RlLA0KICAgICAJZWxzaW8tPnRpbWVvdXQgPSBxbGEyeDAwX2Vs
c19kY21kX2lvY2JfdGltZW91dDsNCiAgICAgCXFsYTJ4MDBfaW5pdF90aW1lcihzcCwgRUxTX0RD
TURfVElNRU9VVCk7DQogICAgIAlpbml0X2NvbXBsZXRpb24oJnNwLT51LmlvY2JfY21kLnUuZWxz
X2xvZ28uY29tcCk7DQogICAgKwlpZiAod2FpdCkNCiAgICArCQlzcC0+ZmxhZ3MgPSBTUkJfV0FL
RVVQX09OX0NPTVA7DQogICAgIAlzcC0+ZG9uZSA9IHFsYTJ4MDBfZWxzX2RjbWRfc3BfZG9uZTsN
CiAgICAgCXNwLT5mcmVlID0gcWxhMngwMF9lbHNfZGNtZF9zcF9mcmVlOw0KICAgICANCiAgICBA
QCAtMjYzNyw5ICsyNjM5LDE0IEBAIHFsYTI0eHhfZWxzX2RjbWRfaW9jYihzY3NpX3FsYV9ob3N0
X3QgKnZoYSwgaW50IGVsc19vcGNvZGUsDQogICAgIAkgICAgc3AtPm5hbWUsIHNwLT5oYW5kbGUs
IGZjcG9ydC0+bG9vcF9pZCwgZmNwb3J0LT5kX2lkLmIuZG9tYWluLA0KICAgICAJICAgIGZjcG9y
dC0+ZF9pZC5iLmFyZWEsIGZjcG9ydC0+ZF9pZC5iLmFsX3BhKTsNCiAgICAgDQogICAgLQl3YWl0
X2Zvcl9jb21wbGV0aW9uKCZlbHNpby0+dS5lbHNfbG9nby5jb21wKTsNCiAgICArCWlmICh3YWl0
KSB7DQogICAgKwkJd2FpdF9mb3JfY29tcGxldGlvbigmZWxzaW8tPnUuZWxzX2xvZ28uY29tcCk7
DQogICAgKwl9IGVsc2Ugew0KICAgICsJCWdvdG8gZG9uZTsNCiAgICArCX0NCiAgICAgDQogICAg
IAlzcC0+ZnJlZShzcCk7DQogICAgK2RvbmU6DQogICAgIAlyZXR1cm4gcnZhbDsNCiAgICAgfQ0K
ICAgICANCiAgICBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX3RhcmdldC5j
IGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX3RhcmdldC5jDQogICAgaW5kZXggNjhjMTQxNDNl
NTBlLi4wZjJiYzRjZDU2MmYgMTAwNjQ0DQogICAgLS0tIGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgv
cWxhX3RhcmdldC5jDQogICAgKysrIGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX3RhcmdldC5j
DQogICAgQEAgLTkzMiw3ICs5MzIsNyBAQCBxbHRfc2VuZF9maXJzdF9sb2dvKHN0cnVjdCBzY3Np
X3FsYV9ob3N0ICp2aGEsIHFsdF9wb3J0X2xvZ29fdCAqbG9nbykNCiAgICAgDQogICAgIAltdXRl
eF91bmxvY2soJnZoYS0+dmhhX3RndC50Z3RfbXV0ZXgpOw0KICAgICANCiAgICAtCXJlcyA9IHFs
YTI0eHhfZWxzX2RjbWRfaW9jYih2aGEsIEVMU19EQ01EX0xPR08sIGxvZ28tPmlkKTsNCiAgICAr
CXJlcyA9IHFsYTI0eHhfZWxzX2RjbWRfaW9jYih2aGEsIEVMU19EQ01EX0xPR08sIGxvZ28tPmlk
LCB0cnVlKTsNCiAgICAgDQogICAgIAltdXRleF9sb2NrKCZ2aGEtPnZoYV90Z3QudGd0X211dGV4
KTsNCiAgICAgCWxpc3RfZGVsKCZsb2dvLT5saXN0KTsNCiAgICAtLQ0KICAgIDIuMjQuMA0KICAg
IA0KICAgIA0KDQo=
