Return-Path: <SRS0=2e3T=ZN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B47BC432C0
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 15:43:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0490B206D8
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 15:43:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="uZYecCTp";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="IPh7liaM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbfKUPn0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Nov 2019 10:43:26 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:62274 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726293AbfKUPn0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Nov 2019 10:43:26 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xALFa4kP003418;
        Thu, 21 Nov 2019 07:43:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=fUHhNGvNL+iSHHjVB1Jn25z9kl6hzolMhtCMxrQJVk4=;
 b=uZYecCTpXbeZPHgxvSNVPPh2nVxElptlzNVkV+NnEg1UeVI/xw0gRdkBQqP5qQj71Ypc
 X9Cjkmg8iGhUcoe0ogZG+EjNfIJCpKFxiztlJg0JZcqnGmRlWD2tobHxDZBontDUjcTI
 Le8XuGjXnHK5VTVf1U85iF+TGZe5FCp040FUvexIHxUxfoA2x6f0QV7qtlDdQrBb9LHf
 ZRb6Avc9ZXyRdOl7RTz3gZOpELO7649LTNAkfw01yu0XbRec0LSws/Dq7vZAD361YVlh
 rsUVOKw+JYaHbq4wIJLm//q8cezFDxVgsNXciAxCT2/41bgSo4356sAUVOyTq98ELadV jQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2wd090yj8e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 21 Nov 2019 07:43:24 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 21 Nov
 2019 07:43:22 -0800
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (104.47.48.50) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 21 Nov 2019 07:43:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bNgcRw7qXlDGIm9/ClgIwA77RFedJeBDjf6PSGPNfk2HhcawpCdD3QHh/ufaa0/TmT+VDAAmOBiEku0Ymt6i4ea0G6Y/oFc5aiPXhGwnkzC6YhYaRV+sjGMPWxtBfg50TRYVMCWhpJgCLd0YyLv+befHfacxot6p8mqZdScEeJb56h122H4NaVzl8Y44wbWIr2W2WJjyNcYtUp/CztFzfB0w66yISahSfCkvM1/zDgrfZ/v/lqBk5J3Z80rUvjEOJbJDCpdKqABswlqNCPEaUHyoG2oOmDL8Qi7QMflOQQ2uCDyDQEDD6Hu4AJA9B48vXJ+0vcdY4Ip+qhvmKZW9Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fUHhNGvNL+iSHHjVB1Jn25z9kl6hzolMhtCMxrQJVk4=;
 b=WM1i6nnFmEfrl3ZywiVQ6c4r/Oh+muBN1gYtBqE9SY2qFzF1ZRWEHaTU5ONTiLkKKuynThEDE4/X66PVM82dJefMANcFCYgbmXUDm1DjY6qKJ6RQ4/t2JA2H1YTUPnqX2cs/O2vNNdZTE8MzJGQ3YV4sER3OwwNfZeb89j1jnP+J+MgL/i4fzwm4fK7zgB/Gu8QODRCRY2WE3AUzhQye1Bp4H0Dyz+syKAck47409EWhQ4+KFQ4w39U1xIXP6BxPVxuZ6bVqTXnCRJpktYGZ5lFuKeNYqBZdHQOqB6Rs1tHDiPHFTo5dxWQDgzusBUey+8ay+HEUEPkGUwASWAyBTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fUHhNGvNL+iSHHjVB1Jn25z9kl6hzolMhtCMxrQJVk4=;
 b=IPh7liaMCSpKRa2B+LJ9Io1P7nFTcci2a9MC+5rkSsO1PNL4ygPsCjYM2S3AJSqXZEgVsnnZy0VDD6KxxXCmRzGxT2yyrrJpyH0SRAjuLalgS9GPazn0UrQ+b5X34aaLT5rzlHDHv3EJtvyUQu3yZ/nnHrJWMiyi5ZjOxgSpJmQ=
Received: from MN2PR18MB2719.namprd18.prod.outlook.com (20.178.255.156) by
 MN2PR18MB2816.namprd18.prod.outlook.com (20.179.21.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.30; Thu, 21 Nov 2019 15:43:21 +0000
Received: from MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::1435:34ad:dbff:5089]) by MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::1435:34ad:dbff:5089%7]) with mapi id 15.20.2451.031; Thu, 21 Nov 2019
 15:43:21 +0000
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     Roman Bolshakov <r.bolshakov@yadro.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
CC:     "linux@yadro.com" <linux@yadro.com>,
        Quinn Tran <qutran@marvell.com>
Subject: Re: [PATCH v2 06/15] scsi: qla2xxx: Don't call qlt_async_event twice
Thread-Topic: [PATCH v2 06/15] scsi: qla2xxx: Don't call qlt_async_event twice
Thread-Index: AQHVn/G/TzGaSB9+Bky3X5m2gm9lDqeVYFKA
Date:   Thu, 21 Nov 2019 15:43:20 +0000
Message-ID: <54622BCF-5D5B-4D7F-870B-D5B04E4030FB@marvell.com>
References: <20191120222723.27779-1-r.bolshakov@yadro.com>
 <20191120222723.27779-7-r.bolshakov@yadro.com>
In-Reply-To: <20191120222723.27779-7-r.bolshakov@yadro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1f.0.191110
x-originating-ip: [2600:1700:211:eb30:e5e4:c939:a3a3:4c5b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5753f8d8-d972-42d2-b714-08d76e998961
x-ms-traffictypediagnostic: MN2PR18MB2816:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB281635183A3766891019E3E7D64E0@MN2PR18MB2816.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 0228DDDDD7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(396003)(366004)(136003)(346002)(199004)(189003)(6436002)(14444005)(8936002)(71200400001)(256004)(186003)(76176011)(7736002)(305945005)(54906003)(6246003)(71190400001)(107886003)(66946007)(2906002)(36756003)(99286004)(25786009)(2201001)(86362001)(14454004)(58126008)(2501003)(316002)(110136005)(76116006)(81166006)(4326008)(33656002)(229853002)(102836004)(81156014)(2616005)(11346002)(91956017)(478600001)(46003)(8676002)(66556008)(5660300002)(66476007)(64756008)(66446008)(6116002)(446003)(6512007)(6506007)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2816;H:MN2PR18MB2719.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oDGj6nxlhz/ktnAzAKwo5dW+WMZsClzT6IIain8jbozQiCIV0Pom2vhzd4X38Q53tGyjtYG4tauHVI6DD4jF7Mg2IfAx3rEVh2whjQEMsTkUVtInSA37jAu/FZzwyt2+qnr53IiZz0N4ywVk7T5La0VB+4pSr/ANQyu6o0jxTTEB5wKJjpzh+IC0ZkHIiV7ZrLoUZQW2kXopGS3xBctpiHA7FLRERpvRpKRb1D8kqPwaLiZTH2I2r0y1EP+qSBtPQ+07qdbYdkPn35A5ug0KItEwfKUh2OuWknaIuJzXnJlP6JLnGWBkDFCrBTbg+QwTohq03CkrIS7Wq+xuVVVFUGkD0UCg1+v0rfammP/hJ9YhatbSlXrUNivGLUdrRckF+yy0ipfXAVJDTVkEETi84RM8kNzAhqEB4THAA9EPh3FbkVqEW4JXNfFzYL6Ta+Xf
Content-Type: text/plain; charset="utf-8"
Content-ID: <D1BA9039893127439D11149F0FB5B3DF@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5753f8d8-d972-42d2-b714-08d76e998961
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2019 15:43:20.8449
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e+THRwRM+rfdvZzU1SD5gAI1RWIDXp3q043+ov3uThmOqTKMZMeOubxLeRCJbu+Y5kZGKg2UwHY0xtPGnL4jig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2816
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-21_03:2019-11-21,2019-11-21 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCu+7v09uIDExLzIwLzE5LCA0OjI3IFBNLCAidGFyZ2V0LWRldmVsLW93bmVyQHZnZXIua2Vy
bmVsLm9yZyBvbiBiZWhhbGYgb2YgUm9tYW4gQm9sc2hha292IiA8dGFyZ2V0LWRldmVsLW93bmVy
QHZnZXIua2VybmVsLm9yZyBvbiBiZWhhbGYgb2Ygci5ib2xzaGFrb3ZAeWFkcm8uY29tPiB3cm90
ZToNCg0KICAgIE1CQV9QT1JUX1VQREFURSBnZW5lcmF0ZXMgZHVwbGljYXRlIGxvZyBsaW5lcyBp
biB0YXJnZXQgbW9kZSBiZWNhdXNlDQogICAgcWx0X2FzeW5jX2V2ZW50IGlzIGNhbGxlZCB0d2lj
ZS4gRHJvcCB0aGUgY2FsbHMgd2l0aGluIHRoZSBjYXNlIGFzDQogICAgdGhlIGZ1bmN0aW9uIHdp
bGwgYmUgY2FsbGVkIHJpZ2h0IGFmdGVyIHRoZSBzd2l0Y2ggc3RhdGVtZW50Lg0KICAgIA0KICAg
IENjOiBRdWlubiBUcmFuIDxxdXRyYW5AbWFydmVsbC5jb20+DQogICAgQ2M6IEhpbWFuc2h1IE1h
ZGhhbmkgPGhtYWRoYW5pQG1hcnZlbGwuY29tPg0KICAgIFNpZ25lZC1vZmYtYnk6IFJvbWFuIEJv
bHNoYWtvdiA8ci5ib2xzaGFrb3ZAeWFkcm8uY29tPg0KICAgIC0tLQ0KICAgICBkcml2ZXJzL3Nj
c2kvcWxhMnh4eC9xbGFfaXNyLmMgfCA0IC0tLS0NCiAgICAgMSBmaWxlIGNoYW5nZWQsIDQgZGVs
ZXRpb25zKC0pDQogICAgDQogICAgZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3Fs
YV9pc3IuYyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pc3IuYw0KICAgIGluZGV4IDFiOGYy
OTc0NDljZi4uYzYyNzQxNzhiMGIwIDEwMDY0NA0KICAgIC0tLSBhL2RyaXZlcnMvc2NzaS9xbGEy
eHh4L3FsYV9pc3IuYw0KICAgICsrKyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pc3IuYw0K
ICAgIEBAIC0xMDYxLDggKzEwNjEsNiBAQCBxbGEyeDAwX2FzeW5jX2V2ZW50KHNjc2lfcWxhX2hv
c3RfdCAqdmhhLCBzdHJ1Y3QgcnNwX3F1ZSAqcnNwLCB1aW50MTZfdCAqbWIpDQogICAgIAkJCXFs
X2RiZyhxbF9kYmdfYXN5bmMsIHZoYSwgMHg1MDExLA0KICAgICAJCQkgICAgIkFzeW5jaHJvbm91
cyBQT1JUIFVQREFURSBpZ25vcmVkICUwNHgvJTA0eC8lMDR4LlxuIiwNCiAgICAgCQkJICAgIG1i
WzFdLCBtYlsyXSwgbWJbM10pOw0KICAgIC0NCiAgICAtCQkJcWx0X2FzeW5jX2V2ZW50KG1iWzBd
LCB2aGEsIG1iKTsNCiAgICAgCQkJYnJlYWs7DQogICAgIAkJfQ0KICAgICANCiAgICBAQCAtMTA3
OSw4ICsxMDc3LDYgQEAgcWxhMngwMF9hc3luY19ldmVudChzY3NpX3FsYV9ob3N0X3QgKnZoYSwg
c3RydWN0IHJzcF9xdWUgKnJzcCwgdWludDE2X3QgKm1iKQ0KICAgICAJCXNldF9iaXQoTE9PUF9S
RVNZTkNfTkVFREVELCAmdmhhLT5kcGNfZmxhZ3MpOw0KICAgICAJCXNldF9iaXQoTE9DQUxfTE9P
UF9VUERBVEUsICZ2aGEtPmRwY19mbGFncyk7DQogICAgIAkJc2V0X2JpdChWUF9DT05GSUdfT0ss
ICZ2aGEtPnZwX2ZsYWdzKTsNCiAgICAtDQogICAgLQkJcWx0X2FzeW5jX2V2ZW50KG1iWzBdLCB2
aGEsIG1iKTsNCiAgICAgCQlicmVhazsNCiAgICAgDQogICAgIAljYXNlIE1CQV9SU0NOX1VQREFU
RToJCS8qIFN0YXRlIENoYW5nZSBSZWdpc3RyYXRpb24gKi8NCiAgICAtLSANCiAgICAyLjI0LjAN
CiAgICANCiAgICANCg0KTG9va3MgR29vZC4gDQoNCkFja2VkLWJ5OiBIaW1hbnNodSBNYWRoYW5p
IDxobWFkaGFuaUBtYXJ2ZWwuY29tPg0KDQo=
