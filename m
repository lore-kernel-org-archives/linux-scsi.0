Return-Path: <SRS0=wQ7u=5W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65633C2BA18
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Apr 2020 04:55:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BF3A206C0
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Apr 2020 04:55:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="VM2OyPmJ";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="sjAEga1/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgDFEzv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Apr 2020 00:55:51 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:59702 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725884AbgDFEzv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Apr 2020 00:55:51 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0364seuj007515;
        Sun, 5 Apr 2020 21:55:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=gC4tkQzRILORwAyCm5Ih6GeffYmLyDRzOGWiGxKiJKw=;
 b=VM2OyPmJz+Gc1u8RNbFFn2U4BUZEb53vTca7iv4grZkufMFrGJ7DgnEqa08Gsu9m56ja
 FeMmaEsfM44xMmIFaF+TP7UihBUEoCFQr9Ja5ci5MR7rt9upGSziqxYZKTk+Fk8zkfnW
 V9a9PtzUhPVKxfV2G1yOJnUaKSN2e+mtEg1ArkfIRPeDNio6LJDvj2PBRAx8S53ZgPmt
 KtTRb5ogbHL2QlAt37bq4r6ONVDK13AyQ7Yh4AePpMu0u3TvYJRT/fE5hQcu9ORDrRPc
 AHMR31YWxCJVAuYG/ohW9MUL8OP8f4bM9RfNQ9ELbBDcj4ZsjuTql5trSTNKjsKgBVv7 CQ== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 306qkqvu8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 05 Apr 2020 21:55:40 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 5 Apr
 2020 21:55:39 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 5 Apr
 2020 21:55:38 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 5 Apr 2020 21:55:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J5PKzlEqs3mEGBtxjXSEvg+0hM8Bsy1MkTyvV0yC0e2cmfUmrnIRMsCie/abf1wa+urT5q8/N4JQOELKMPkPz0VPihhHkxSqBKaMKOovk4iUFCv4G66pMAeBsDb7aRt1Mar1hxlt4evEZ4B25KjlBOa7SeWe6yYXn5YrrKariZLVhagIQS5jxOIuCFvEevHxOPuIGM+LqBbvtUIlFXRmXfE15rIuJWvifFLJKQ8bzfNB/QWJDgIsa5pGOd1D1j3wrOX/YCqLG1Jv+BuCp9WSBEcY5UMp+Ly96fTP0N7Morcu02UNnwyHFMpeynJtTL4GTy9EX7vv4fbB+O9CTZ7VOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gC4tkQzRILORwAyCm5Ih6GeffYmLyDRzOGWiGxKiJKw=;
 b=OLTc2dhyNvRZ9utqr6yewGStU761Vsh8L97wIFRDfGJHJjzTUWcpS+UxvxpJinDYH9Fp06s3iMjNaNLibv6qC862DmF4iYa8n/VBq1zz7l0IFd911RZ/2+9VCrAUe+walJKXw+rOfmTfQjLQJ4xLxAyUxm+8fOrGABPCUU4ii8hMvb94lRwtlLv1T1CnircJ5Wff0ibvMJJ6Nwj3TgJNoF69yAXkynXwyPc0eCAnaJVfceeONfiHW0WsFPH4QKXq/CeBhlcrXBEtKxDOyCQX3dj8c7zUoggl1obgnT7ZTm+CqEuiLG64aoq01r23ZCnND+pHH68GxdYhrZHa6RB68g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gC4tkQzRILORwAyCm5Ih6GeffYmLyDRzOGWiGxKiJKw=;
 b=sjAEga1/mbfFff296aQ/Bu+PZz8qTHxaICNsmKsm9Bx4nj6mySCZ0dk3b4JsK+MEQykE7WWdybaDXF8berXj5rGoNLa8sWE1dCbXEU01bDIELoioZJ9ou06Y/6SjDZ/A7FATaklLZy0pqXRIqvlsYnjUeV1hPoE/LT9FbvDxapM=
Received: from CH2PR18MB3160.namprd18.prod.outlook.com (2603:10b6:610:24::30)
 by CH2PR18MB3255.namprd18.prod.outlook.com (2603:10b6:610:27::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.20; Mon, 6 Apr
 2020 04:55:37 +0000
Received: from CH2PR18MB3160.namprd18.prod.outlook.com
 ([fe80::10e7:f4e9:face:3455]) by CH2PR18MB3160.namprd18.prod.outlook.com
 ([fe80::10e7:f4e9:face:3455%7]) with mapi id 15.20.2878.017; Mon, 6 Apr 2020
 04:55:37 +0000
From:   Nilesh Javali <njavali@marvell.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: RE: [EXT] Re: [PATCH 1/2] qla2xxx: Fix regression warnings
Thread-Topic: [EXT] Re: [PATCH 1/2] qla2xxx: Fix regression warnings
Thread-Index: AQHWCZOKOOkxpw5fk0mLo2WMJ9xIvqhncb0AgAQZhVA=
Date:   Mon, 6 Apr 2020 04:55:37 +0000
Message-ID: <CH2PR18MB3160E3AC9C32145932EA427AAFC20@CH2PR18MB3160.namprd18.prod.outlook.com>
References: <20200403084018.30766-1-njavali@marvell.com>
 <20200403084018.30766-2-njavali@marvell.com>
 <701a1483-bd97-3088-2d08-57d1795bd95a@acm.org>
In-Reply-To: <701a1483-bd97-3088-2d08-57d1795bd95a@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [59.98.120.60]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 53f0ce7a-b6c1-4409-af49-08d7d9e6bf69
x-ms-traffictypediagnostic: CH2PR18MB3255:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR18MB32550A861276FEA17DBA5CA4AFC20@CH2PR18MB3255.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0365C0E14B
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR18MB3160.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(136003)(396003)(39850400004)(366004)(376002)(66946007)(107886003)(5660300002)(186003)(71200400001)(52536014)(4326008)(64756008)(55016002)(9686003)(66446008)(66556008)(66476007)(4744005)(86362001)(478600001)(7696005)(81156014)(54906003)(110136005)(53546011)(6506007)(8676002)(8936002)(33656002)(76116006)(2906002)(316002)(26005)(81166006);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tL/z8uewIQbgJQWR+woPXWPGAPpOSiTJZJ7tAQVEWqXSOiGUlq3/81vN+19B7egbkNe+/1jMPYlP0zhClzttc0SsjXTXPeuFMALhNiSGrVtmA4KpZ60mNAUABq4VaE5V7NbYEZZzq12IVVd5HLa/qNuImJPJZHte2fJAdjAiwvZGdA5nKhF9sR8ywIsBzeZidoy9Q8q14OxyQqCtB5qaPD3LsKy4ovJX3gQB+OqsEKw5t6IZCy4V5y4QoSuo7N9iOonNqp6ggzV3W7VIRHik8HfCWnagCsMa3+7UNuaNPX4NFhj2MWZqdHkGzEhl4T6f/hfrCeq1so++6jR32QHIbVZtn4U5KfinX704YkqEwdtN70edxgX1eiSzqjecCk0+ChoaOGAYSbPvXYpforPeSurRm0nuLlNZWM6yxH4B43Xk5UBBeef6wb4QGvwQB2uS
x-ms-exchange-antispam-messagedata: H+fB4Cizli6raDtwNhhu92TuQING+zgiG6qpmk/MG2cwBm4HMAUIKPfuuzNS2BD0EegCcKSLvFykRYhNSyWEKdAFTlye6oAfjsOv/C3vENEYiOMNgF4ZIflOiFWftx66U0hWE7XtXxROL7xyClh4QQ==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 53f0ce7a-b6c1-4409-af49-08d7d9e6bf69
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2020 04:55:37.2704
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5iR2ziuGn9lDqoQqvyIG6DbdRhwKVkCHFn6kBt7S58fTRU2BTZ7vZNZ5u1oeBKtjnTSaTkooHwCBlRP1gYJ5Pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR18MB3255
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-06_01:2020-04-03,2020-04-06 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQmFydCwNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBCYXJ0IFZh
biBBc3NjaGUgPGJ2YW5hc3NjaGVAYWNtLm9yZz4NCj4gU2VudDogRnJpZGF5LCBBcHJpbCAzLCAy
MDIwIDc6NDYgUE0NCj4gVG86IE5pbGVzaCBKYXZhbGkgPG5qYXZhbGlAbWFydmVsbC5jb20+OyBt
YXJ0aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbQ0KPiBDYzogbGludXgtc2NzaUB2Z2VyLmtlcm5lbC5v
cmc7IEdSLVFMb2dpYy1TdG9yYWdlLVVwc3RyZWFtIDxHUi1RTG9naWMtDQo+IFN0b3JhZ2UtVXBz
dHJlYW1AbWFydmVsbC5jb20+DQo+IFN1YmplY3Q6IFtFWFRdIFJlOiBbUEFUQ0ggMS8yXSBxbGEy
eHh4OiBGaXggcmVncmVzc2lvbiB3YXJuaW5ncw0KPiANCj4gRXh0ZXJuYWwgRW1haWwNCj4gDQo+
IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0NCj4gT24gMjAyMC0wNC0wMyAwMTo0MCwgTmlsZXNoIEphdmFsaSB3cm90
ZToNCj4gPiBAQCAtMjU0Nyw2ICsyNTQ2LDcgQEAgcWxfZGJnKHVpbnQgbGV2ZWwsIHNjc2lfcWxh
X2hvc3RfdCAqdmhhLCB1aW50IGlkLA0KPiBjb25zdCBjaGFyICpmbXQsIC4uLikNCj4gPiAgCXZh
Zi52YSA9ICZ2YTsNCj4gPg0KPiA+ICAJaWYgKCFxbF9tYXNrX21hdGNoKGxldmVsKSkgew0KPiA+
ICsJCWNoYXIgcGJ1Zls2NF07DQo+ID4gIAkJaWYgKHZoYSAhPSBOVUxMKSB7DQo+ID4gIAkJCWNv
bnN0IHN0cnVjdCBwY2lfZGV2ICpwZGV2ID0gdmhhLT5ody0+cGRldjsNCj4gPiAgCQkJLyogPG1v
ZHVsZS1uYW1lPiA8bXNnLWlkPjo8aG9zdD4gTWVzc2FnZSAqLw0KPiANCj4gSGFzIHRoaXMgcGF0
Y2ggYmVlbiB2ZXJpZmllZCB3aXRjaCBjaGVja3BhdGNoPyBEaWQgY2hlY2twYXRjaCByZXBvcnQN
Cj4gIk1pc3NpbmcgYSBibGFuayBsaW5lIGFmdGVyIGRlY2xhcmF0aW9ucyI/DQoNClllcywgdGhl
IHBhdGNoIHdhcyB2ZXJpZmllZCB1c2luZyBjaGVja3BhdGggYW5kIHNob3dlZCBubyB3YXJuaW5n
cy4NCg0KVGhhbmtzLA0KTmlsZXNoDQo=
