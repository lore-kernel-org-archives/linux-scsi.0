Return-Path: <SRS0=JpCa=WK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C230C32753
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 14:20:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A7CA2133F
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 14:20:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="asWHVqMh";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="Uns3KRJo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbfHNOUA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 10:20:00 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:50046 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726019AbfHNOUA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Aug 2019 10:20:00 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7EECtDO008290;
        Wed, 14 Aug 2019 07:18:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=rJF3vXtvoz2P4/mj0LpHw61gn/Ed4DlDVGbDc3UsgdI=;
 b=asWHVqMheGzsyCYsOY1YFCgxuOY72KopknBeUD564LhLm1+bAXLGF++Ttb9YBZAyU2SK
 15b6S3uD5sqwj6jeuszRwbUtlRMWl/Gwz/41puD5pRGZX9PbtTYqKOoac1OZz0G2+Aj/
 qtZyV2mzFwJ7P770yWd1K4gdbe9wOXAYw0snItMdQoXUrd5f7oMq9eEC8XHIU3oQBUYy
 Wg+IBGJ5GkLXYf8tQdwJGFsdYy81/DVmXWpPb7GORGioRfgprxBwrXzsMhezGd2SSrah
 tu2+XG0SiKVYd8WHYRzi11o+IgbCvb2B2MDq86QCIyMHiIVsvwluD+yjmWCYJRqZDZfF gQ== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2ubfabfbm3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 14 Aug 2019 07:18:59 -0700
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 14 Aug
 2019 07:18:58 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.51) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Wed, 14 Aug 2019 07:18:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f5n36h4J3TA3ZmMUL1hYrohQ84qa7LnyBgZKyxvoOTDU+UlZIXxoVY5rxdXnCOIdYbIr1PH+YZAn7i93hGDg6ZdySOOTiGltgKaf5xzy+TO46mXsaRPr7RS7G5dw86mYr2SuWRlTsh119Mgxqfyqfv/o+1OvyzpP7ZXcV5HVn6aFIrpc/UHy4cKlnxHAKzCSZzYJHTcchfTMi99ynAYy6EAl7i54XRS4AJc//ihSuefHy9SO0kTVKV4hIhSBXD8tpSrtMkxPCTz24Gbu5sSJo0BrZqVsQx4vAumQH+/ZMiuGE0TQ1RIkezPf9Pz7vMjwtyEEOE/QAaYjvUpGK46Neg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rJF3vXtvoz2P4/mj0LpHw61gn/Ed4DlDVGbDc3UsgdI=;
 b=cbFiCQcvBz2gf1VucOzfC9qtw5luzq1jaHya/svoI3jz5cMrJH+cGzwH6n1nX/p0EeiR7F05BUxmqeEeknTvql28IhW/LAXZNHGWLKAz1LZqrOFO/DM0mqsHREMGcEzNR1KdG9H76HZWoN+L48AobiEMtCAVnDG02uDrnLD/CmcRBbUSXR/qRUU+VtZ8f6vO2Xh6PhVJ9hcbtghBEcx3/DvBv5IHr9ssEEQjgTnsQNjit+e1TqaSzWNUG4zymIIztH8iiWtmkzjxeUeSCo+RSDgqYbmqhENvuBmTs7bZOh3nORqfOKUDL8YeGHrGmGJxp/EUHbpHKlDIL3ni6B4rUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rJF3vXtvoz2P4/mj0LpHw61gn/Ed4DlDVGbDc3UsgdI=;
 b=Uns3KRJoHxTfxbZ38NLeYj7FjVD23/q7FyHccP/uKqCvrI6btEQkyKF44VZwIdouZVvH/6ID1bcKP/ESBnmYhlnPff9svreMPtQoLkxH8j5GM21pG52NgI98dD9+W74ogHIK+pO9Om6oLYHgmkStqxEpXIZSJgMHsnuDn10DKO8=
Received: from MN2PR18MB2719.namprd18.prod.outlook.com (20.178.255.156) by
 MN2PR18MB3357.namprd18.prod.outlook.com (10.255.238.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Wed, 14 Aug 2019 14:18:53 +0000
Received: from MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::c8fc:cffe:3499:b43a]) by MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::c8fc:cffe:3499:b43a%6]) with mapi id 15.20.2157.021; Wed, 14 Aug 2019
 14:18:53 +0000
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     Martin Wilck <Martin.Wilck@suse.com>,
        "hare@suse.de" <hare@suse.de>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "joe.carnuccio@cavium.com" <joe.carnuccio@cavium.com>,
        "Bart.VanAssche@sandisk.com" <Bart.VanAssche@sandisk.com>,
        Quinn Tran <qutran@marvell.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>
Subject: Re: [PATCH 2/3] scsi: qla2xxx: unset RCE/EFT fields in failure case
Thread-Topic: [PATCH 2/3] scsi: qla2xxx: unset RCE/EFT fields in failure case
Thread-Index: AQHVUhYKQMcVI/ohF0qhHmiduV8LJqb6LZgAgABRBYD//9/KAA==
Date:   Wed, 14 Aug 2019 14:18:53 +0000
Message-ID: <F8C2B434-EC6C-439C-AF47-B1C289B02421@marvell.com>
References: <20190813203034.7354-1-martin.wilck@suse.com>
 <20190813203034.7354-3-martin.wilck@suse.com>
 <9d479501-27bd-7932-9517-4545231e6ae9@suse.de>
 <1e0d71830c1b37d8b60df58ea76b0d07e1b893eb.camel@suse.com>
In-Reply-To: <1e0d71830c1b37d8b60df58ea76b0d07e1b893eb.camel@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1b.0.190715
x-originating-ip: [2600:1700:211:eb30:5871:9d72:f424:86ba]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b9053401-e88d-4be2-ec0a-08d720c255ff
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB3357;
x-ms-traffictypediagnostic: MN2PR18MB3357:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB33575165F2A5A3533D152EE6D6AD0@MN2PR18MB3357.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 01294F875B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(376002)(346002)(396003)(136003)(189003)(199004)(110136005)(76176011)(2501003)(6512007)(71200400001)(71190400001)(186003)(7736002)(2616005)(316002)(305945005)(8936002)(6246003)(102836004)(86362001)(53936002)(2906002)(229853002)(81156014)(81166006)(6116002)(54906003)(36756003)(8676002)(99286004)(446003)(6486002)(6436002)(53546011)(478600001)(5660300002)(6506007)(4326008)(256004)(14444005)(14454004)(11346002)(58126008)(476003)(66946007)(76116006)(91956017)(66446008)(66476007)(64756008)(66556008)(486006)(25786009)(33656002)(46003)(2201001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB3357;H:MN2PR18MB2719.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: WpqiSf3ppmPYvjcDhfQR2eensgUclJUCdazBm3jsyctRrJwcrcx4FNO7/4g8PVdx88rCwYm00b8EYSFK4VSqSJy5K4QsDkOu4qkVQQJ1Fvun3sLEZ6tv2/BGIFGQ8i4coWDL9WXKOz1rldS0xI88ykT5Jlc79aA2B8ue1HiJuE4YtD44c9GL58Th+BGoz8BAp1RMjWD4OmM/czw4WFrva4IHeCJzqdti/robQg2LBLb+SMPCn8D39CxBRQfLl5wS3UYiKLF2VyNUbjMipkEYw4LqVP9UfB/vTs3XLfkDJKGcmsOAKUbNkxitNEadY3M8s8p7QqhIVjcOTDUvJr9cER8UtaCj0upF+c2hO7RaKV/Fi004lLf2SzyTEDHy/VOqoj/IqYym2QCFS6x4UBvENiiiYN2iHrIdCdfH7Km0tXs=
Content-Type: text/plain; charset="utf-8"
Content-ID: <65BEE4EA87158D458DA5FCAB9E1A781C@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b9053401-e88d-4be2-ec0a-08d720c255ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2019 14:18:53.3634
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QDFs5+Pt2uEEm/5GRPzxjGKekehc5tscqt9FzgbBvlXclKNjusOAVRS9GuelByWuQOKLsWCvDdJEgOs4JjkoWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3357
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-08-14_05:2019-08-14,2019-08-14 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCu+7v09uIDgvMTQvMTksIDY6MzAgQU0sICJsaW51eC1zY3NpLW93bmVyQHZnZXIua2VybmVs
Lm9yZyBvbiBiZWhhbGYgb2YgTWFydGluIFdpbGNrIiA8bGludXgtc2NzaS1vd25lckB2Z2VyLmtl
cm5lbC5vcmcgb24gYmVoYWxmIG9mIE1hcnRpbi5XaWxja0BzdXNlLmNvbT4gd3JvdGU6DQoNCiAg
ICBPbiBXZWQsIDIwMTktMDgtMTQgYXQgMDg6MjQgKzAyMDAsIEhhbm5lcyBSZWluZWNrZSB3cm90
ZToNCiAgICA+IE9uIDgvMTMvMTkgMTA6MzEgUE0sIE1hcnRpbiBXaWxjayB3cm90ZToNCiAgICA+
ID4gRnJvbTogTWFydGluIFdpbGNrIDxtd2lsY2tAc3VzZS5jb20+DQogICAgPiA+IA0KICAgID4g
PiBSZXNldCBoYS0+cmNlLCBoYS0+ZWZ0IGFuZCB0aGUgcmVzcGVjdGl2ZSBkbWEgZmllbGRzIGlm
DQogICAgPiA+IHRoZSBidWZmZXJzIGFyZW4ndCBtYXBwZWQgZm9yIHNvbWUgcmVhc29uLiBBbHNv
LCB0cmVhdA0KICAgID4gPiBib3RoIGZhaWx1cmUgY2FzZXMgKGFsbG9jYXRpb24gYW5kIGluaXRp
YWxpemF0aW9uIGZhaWx1cmUpDQogICAgPiA+IGVxdWFsbHkuIFRoZSBuZXh0IHBhdGNoIG1vZGlm
aWVzIHRoZSBmYWlsdXJlIGJlaGF2aW9yDQogICAgPiA+IHNsaWdodGx5IGFnYWluLg0KICAgID4g
PiANCiAgICA+ID4gRml4ZXM6IGFkMGEwYjAxZjA4OCAic2NzaTogcWxhMnh4eDogRml4IEZpcm13
YXJlIGR1bXAgc2l6ZSBmb3INCiAgICA+ID4gRXh0ZW5kZWQNCiAgICA+ID4gIGxvZ2luIGFuZCBF
eGNoYW5nZSBPZmZsb2FkIg0KICAgID4gPiBGaXhlczogYTI4ZDllNGVmOTk3ICJzY3NpOiBxbGEy
eHh4OiBBZGQgc3VwcG9ydCBmb3IgbXVsdGlwbGUgZndkdW1wDQogICAgPiA+ICB0ZW1wbGF0ZXMv
c2VnbWVudHMiDQogICAgPiA+IENjOiBKb2UgQ2FybnVjY2lvIDxqb2UuY2FybnVjY2lvQGNhdml1
bS5jb20+DQogICAgPiA+IENjOiBRdWlubiBUcmFuIDxxdXRyYW5AbWFydmVsbC5jb20+DQogICAg
PiA+IENjOiBIaW1hbnNodSBNYWRoYW5pIDxobWFkaGFuaUBtYXJ2ZWxsLmNvbT4NCiAgICA+ID4g
Q2M6IEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPg0KICAgID4gPiBTaWduZWQt
b2ZmLWJ5OiBNYXJ0aW4gV2lsY2sgPG13aWxja0BzdXNlLmNvbT4NCiAgICA+ID4gLS0tDQogICAg
PiA+ICBkcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaW5pdC5jIHwgMTAgKysrKysrKysrKw0KICAg
ID4gPiAgMSBmaWxlIGNoYW5nZWQsIDEwIGluc2VydGlvbnMoKykNCiAgICA+ID4gDQogICAgPiA+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaW5pdC5jDQogICAgPiA+IGIv
ZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2luaXQuYw0KICAgID4gPiBpbmRleCA2ZGQ2OGJlLi5j
YTljM2YzIDEwMDY0NA0KICAgID4gPiAtLS0gYS9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaW5p
dC5jDQogICAgPiA+ICsrKyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pbml0LmMNCiAgICA+
ID4gQEAgLTMwNjMsNiArMzA2Myw4IEBAIHFsYTJ4MDBfYWxsb2Nfb2ZmbG9hZF9tZW0oc2NzaV9x
bGFfaG9zdF90DQogICAgPiA+ICp2aGEpDQogICAgPiA+ICAJCQlxbF9sb2cocWxfbG9nX3dhcm4s
IHZoYSwgMHgwMGJlLA0KICAgID4gPiAgCQkJICAgICJVbmFibGUgdG8gYWxsb2NhdGUgKCVkIEtC
KSBmb3IgRkNFLlxuIiwNCiAgICA+ID4gIAkJCSAgICBGQ0VfU0laRSAvIDEwMjQpOw0KICAgID4g
PiArCQkJaGEtPmZjZV9kbWEgPSAwOw0KICAgID4gPiArCQkJaGEtPmZjZSA9IE5VTEw7DQogICAg
PiA+ICAJCQlnb3RvIHRyeV9lZnQ7DQogICAgPiA+ICAJCX0NCiAgICA+ID4gIA0KICAgID4gQWN0
dWFsbHksIEkgd291bGQgc2V0IHRoaXMgZWFybGllciBoZXJlOg0KICAgID4gDQogICAgPiAJCWlm
IChoYS0+ZmNlKQ0KICAgID4gCQkJZG1hX2ZyZWVfY29oZXJlbnQoJmhhLT5wZGV2LT5kZXYsDQog
ICAgPiAJCQkgICAgRkNFX1NJWkUsIGhhLT5mY2UsIGhhLT5mY2VfZG1hKTsNCiAgICA+IA0KICAg
ID4gd2hpY2ggaXMgdGhlIGxvZ2ljYWwgcGxhY2UgdG8gY2xlYXIgJ2hhLT5mY2UnIGFuZCAnaGEt
PmZjZV9kbWEnIElNTy4NCiAgICANCiAgICBGaW5lIHdpdGggbWUuDQogICAgDQogICAgPiBBbHNv
ZSB0aGVyZSBpcyB0aGlzIGNhbGwgbGF0ZXIgb246DQogICAgPiANCiAgICA+IAkJcnZhbCA9IHFs
YTJ4MDBfZW5hYmxlX2ZjZV90cmFjZSh2aGEsIHRjX2RtYSwNCiAgICA+IEZDRV9OVU1fQlVGRkVS
UywNCiAgICA+IAkJICAgIGhhLT5mY2VfbWIsICZoYS0+ZmNlX2J1ZnMpOw0KICAgID4gCQlpZiAo
cnZhbCkgew0KICAgID4gCQkJcWxfbG9nKHFsX2xvZ193YXJuLCB2aGEsIDB4MDBiZiwNCiAgICA+
IAkJCSAgICAiVW5hYmxlIHRvIGluaXRpYWxpemUgRkNFICglZCkuXG4iLCBydmFsKTsNCiAgICA+
IAkJCWRtYV9mcmVlX2NvaGVyZW50KCZoYS0+cGRldi0+ZGV2LCBGQ0VfU0laRSwgdGMsDQogICAg
PiAJCQkgICAgdGNfZG1hKTsNCiAgICA+IAkJCWhhLT5mbGFncy5mY2VfZW5hYmxlZCA9IDA7DQog
ICAgPiAJCQlnb3RvIHRyeV9lZnQ7DQogICAgPiAJCX0NCiAgICA+IA0KICAgID4gd2hpY2ggYWxz
byBuZWVkcyB0byBiZSBwcm90ZWN0ZWQuDQogICAgDQogICAgUmlnaHQuDQogICAgDQogICAgPiA+
IEBAIC0zMTExLDkgKzMxMTMsMTIgQEAgcWxhMngwMF9hbGxvY19vZmZsb2FkX21lbShzY3NpX3Fs
YV9ob3N0X3QNCiAgICA+ID4gKnZoYSkNCiAgICA+ID4gIA0KICAgID4gPiAgCQloYS0+ZWZ0X2Rt
YSA9IHRjX2RtYTsNCiAgICA+ID4gIAkJaGEtPmVmdCA9IHRjOw0KICAgID4gPiArCQlyZXR1cm47
DQogICAgPiA+ICAJfQ0KICAgID4gPiAgDQogICAgPiA+ICBlZnRfZXJyOg0KICAgID4gPiArCWhh
LT5lZnQgPSBOVUxMOw0KICAgID4gPiArCWhhLT5lZnRfZG1hID0gMDsNCiAgICA+ID4gIAlyZXR1
cm47DQogICAgPiA+ICB9DQogICAgPiA+ICANCiAgICA+IEkgd29uZGVyIHdoeSB0aGlzIGlzIGV2
ZW4gdGhlcmUuDQogICAgPiANCiAgICA+IFJpZ2h0IGF0IHRoZSBzdGFydCB3ZSBoYXZlOg0KICAg
ID4gCWlmIChoYS0+ZWZ0KSB7DQogICAgPiAJCXFsX2RiZyhxbF9kYmdfaW5pdCwgdmhhLCAweDAw
YmQsDQogICAgPiAJCSAgICAiJXM6IE9mZmxvYWQgTWVtIGlzIGFscmVhZHkgYWxsb2NhdGVkLlxu
IiwNCiAgICA+IAkJICAgIF9fZnVuY19fKTsNCiAgICA+IAkJcmV0dXJuOw0KICAgID4gCX0NCiAg
ICA+IA0KICAgID4gSUUgdGhlIHNlY29uZCBoYWxmIG9mIHRoaXMgZnVuY3Rpb24gcmVhbGx5IHNo
b3VsZCBiZSB1bnJlYWNoYWJsZQ0KICAgID4gY29kZS4NCg0KSSBkbyBhZ3JlZSB0aGF0IHNlY29u
ZCBoYWxmIG9mIHRoZSBmdW5jdGlvbiB3YXMgdW5yZWFjaGFibGUgY29kZS4gDQogICAgDQogICAg
VGhpcyBjaGVjayBpcyBvbmx5IGluIHFsYTJ4MDBfYWxsb2Nfb2ZmbG9hZF9tZW0oKSwgbm90IGlu
DQogICAgcWxhMngwMF9hbGxvY19md19kdW1wKCksIHdoZXJlIEVGVCBhbGxvY2F0aW9uIGlzIGF0
dGVtcHRlZCBhZ2FpbiAoYW5kIA0KICAgIHFsYTJ4MDBfYWxsb2Nfb2ZmbG9hZF9tZW0oKSBpcyBj
YWxsZWQgZmlyc3QpLiBJdCBsb29rcyBsaWtlIGFuDQogICAgb3ZlcnNpZ2h0LCBpbmRlZWQuIElN
TyB0aGlzIHBhcnQgb2YgdGhlIGNvZGUgbmVlZHMgY2xlYW51cDsgZm9yIG5vdw0KICAgIEkgdHJp
ZWQgdG8ga2VlcCB0aGUgcGF0Y2hlcyBzbWFsbC4NCiAgICANCiAgICA+IEhpbWFuc2h1Pw0KICAg
ID4gDQogICAgDQpJIHNlZSB5b3Ugc2VudCBvdXQgdjIgYWxyZWFkeSBvZiB0aGlzIHNlcmllcyB3
aXRoIGNsZWFudXBzIHN1Z2dlc3RlZCBieSBIYW5uZXMuIA0KDQpJJ2xsIHJldmlldyB5b3VyIHYy
IG9uIHRoZSBsaXN0LiANCg0KVGhhbmtzLA0KSGltYW5zaHUNCg0KICAgIFRoYW5rcywNCiAgICBN
YXJ0aW4NCiAgICANCiAgICANCg0K
