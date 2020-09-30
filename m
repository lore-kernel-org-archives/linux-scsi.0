Return-Path: <SRS0=FF5A=DH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 499EFC4363D
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 20:55:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFCAC2075F
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 20:55:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="DVaOZoZB";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="t+cVpNXw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730178AbgI3Uzd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Sep 2020 16:55:33 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:2562 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725355AbgI3Uzd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 30 Sep 2020 16:55:33 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08UKtMt6020443;
        Wed, 30 Sep 2020 13:55:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0220;
 bh=UiABPHzMfIBV4flpHSe6uSAXF7GWAUBD0DuM38Qwwzg=;
 b=DVaOZoZBnY3PJ/cGTxSTf043MFXYYuo85yq1MTzbVKKwuukJMzEuqe2S0uRTIpfVDIUp
 wU+iwX+KY86CbUse1et8cYzDcWyPhJuvRGYg15f02NPNGKRTlAfeOqJK0FoQII5dYkrT
 rBrhLrE9+gyzGO/3gDJMpW2t45FGjKZO81seWtmq46KCE5EpbyQc3vdU/LeR44XctSVU
 A2H1ZkJJ0rA0lNRMzfutp9W/X+asa2dBvEcym5isc38+7pEl1Pib6hd56If2u0Ychm/b
 Pr5egCfRQQpQl5O698KmRwyQchm1LQaf7i7mucGqQaCRS3O6/ObgwUAp61csa8oqVtmP 0Q== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 33t55pbvvt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 30 Sep 2020 13:55:30 -0700
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 30 Sep
 2020 13:55:28 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 30 Sep 2020 13:55:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bLNJBxWaVP3Wvqx9H7HySzIC2WTFeaRyahzETgi0JtGTKHxjV3L2e+FMrACKwXZXA+TjA7DTMR3iS5RIMFdxoNsibLmJU5KVMH06jG9KKJfppnecigHTxaHQ/QfNTHgCBhStJFb/6VNlTKNFvWBzjdySaMKBw6U1K+bemGIYI4+unVQDzkZSyS8jS26S9dgFQqvu5aM81ktnXVk2QzVpcbwVKNdwLrrEZ6KqCI3DMazFOCwcMf8eHPeN9zIkfj2SjgdCYd1KlzYDrc1PKTV5BgRqsCjbIRh8f5fpfq/APczQctx64ZFemaXdbnmUkRu4/ig1QGLBmnjPGZa+FqpYLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UiABPHzMfIBV4flpHSe6uSAXF7GWAUBD0DuM38Qwwzg=;
 b=EzkrTay9V3Mtkesoy+NTcKMENzxjo0FQObdHG8cgxUncNNiez10ijy0940lzX/DqPvdahivlKWyZbB9WXg2axoQdCeoQHFsR9+L9ifMejgticCKS57Z1RFuWTZx54Imp0HQkweRikm1ctZ25VZopgOMs4lK+kE4z0jJovAPaYddbMNLzf4ucnOOYP92fHQKCBXzcArmGNvL4aZC1MoqRyRbjqw5qC75Sbpew3Z4yxa/rAjd6tZ7iyxe2KHrqwWv5Fz94FWiHjFI9J/NBMsy7Jvlz5YdYNujGTY9Kh1vye03jj0gQ5Ib0jgw9HbQU9yIZJlc+NEUX7vnobg+5LtJLdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UiABPHzMfIBV4flpHSe6uSAXF7GWAUBD0DuM38Qwwzg=;
 b=t+cVpNXwQjmqxbEoIaGkYLHTUvUhoxxx8dw7cB9p+ByAEsI4g+tiWy/b81KmSSqIrTEyvjM9iHmZrzzlo8s7dWns/+rI7Y+RYQgRnHLqmJ5AF098TqgCEuQRlokHjWBYIPJq2muXappyzqtlNsYweM40TRwOVTIo9OZ7gF4Da/k=
Received: from BYAPR18MB2805.namprd18.prod.outlook.com (2603:10b6:a03:108::25)
 by BYAPR18MB2840.namprd18.prod.outlook.com (2603:10b6:a03:112::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.35; Wed, 30 Sep
 2020 20:55:27 +0000
Received: from BYAPR18MB2805.namprd18.prod.outlook.com
 ([fe80::fc12:a6a9:5e02:cfa9]) by BYAPR18MB2805.namprd18.prod.outlook.com
 ([fe80::fc12:a6a9:5e02:cfa9%6]) with mapi id 15.20.3412.029; Wed, 30 Sep 2020
 20:55:27 +0000
From:   Shyam Sundar <ssundar@marvell.com>
To:     James Smart <james.smart@broadcom.com>,
        Nilesh Javali <njavali@marvell.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [EXT] Re: [PATCH 1/2] scsi: fc: Update statistics for host and
 rport on FPIN reception.
Thread-Topic: [EXT] Re: [PATCH 1/2] scsi: fc: Update statistics for host and
 rport on FPIN reception.
Thread-Index: AQHWZvHMYsYd/GGqgEmobmWmo+FBnal1q3sAgAi3TACAAh+gAIABEmcA
Date:   Wed, 30 Sep 2020 20:55:27 +0000
Message-ID: <05745075-014E-4C56-AD69-8F428D658CA7@marvell.com>
References: <20200730061116.20111-1-njavali@marvell.com>
 <20200730061116.20111-2-njavali@marvell.com>
 <31d735ac-90d6-a601-0d8e-c15739684d23@broadcom.com>
 <1230F28E-B730-4022-B4CA-6A47C49F15FD@marvell.com>
 <a0ace8fd-eaec-bb53-11d1-b686a90e16f4@broadcom.com>
In-Reply-To: <a0ace8fd-eaec-bb53-11d1-b686a90e16f4@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.40.20081000
authentication-results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [45.24.93.147]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0ed8dcc7-62e4-4293-7df7-08d8658328d3
x-ms-traffictypediagnostic: BYAPR18MB2840:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB28403E3D14DAD6C26C079A79B4330@BYAPR18MB2840.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xHb6WH/sww9scjdhX7DmxQCWPBGoka/IYnflmQICnog1Cdelau4TPuJ3Rmy9/4XgQj4yqVCzxWnHAu4GULmCZdePKJbMJpdQkw1HRFMNmIhQ7nCrZlNooI8q+AsmdKoFuiIE+wNNlhqe3FB1Ymq7S/+MjQBNEaWwbMB/CMRPxHg4vyCCauECwoknwzOy4V/IpKB4XER9p/vQP/mZ8fVHg0ytTg3NAsKUI2RKzNLD8ZE0LMh/Yd8OluGejQWUDSxj8itGA5x8cUmDeAmv0shgpZ47lDdPzutKHvRbzRfygGssi9F+frSejnWbNgCkBY3rTZDqcx475Mk81qzfMkkOXSsMjlELvCwN0Bdosq50YvvX+0AMtShQJPlV6btaroAn
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2805.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(366004)(396003)(376002)(346002)(66476007)(64756008)(6512007)(8936002)(83380400001)(6486002)(71200400001)(86362001)(2616005)(2906002)(4326008)(26005)(107886003)(33656002)(66446008)(66556008)(8676002)(4744005)(6506007)(76116006)(110136005)(316002)(66946007)(54906003)(36756003)(478600001)(186003)(15650500001)(5660300002)(61000200002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: QWO1sukGmB83r/Ok8glKZcnlxbcHY3vv2NZFY2D6v7OxL1blrsIxSYX/mbO6h3jvdaXIF4qbgwFFFrztIgGSNr5lD0w4PzpQZpublq+ME0yNS6EOYJLN4nxvPh3GsWPG8i7txeVE/qTbJ8QjXTqjP8twixP2O3TQy/nmpqp77QjGSj/xImqsl+e1ziSg5XqZs5nJJk+bMANx46HQwUrPtcaoeGZALBdLzg1e+oYg4VsnJObegwwtzQyLb9tXZK1YrVNKXuX8koW9e/i1TEP0eNWb9BeD1mafkppEqKKdS5GbBxEfausNVCHb3OsYHqiX3vwwRrijlVZ4YpBHMLDXxZcaY7HqAtZR16BzTP3ziw3FNUH980FfZQfQrUHHaukMghQixcalhic96WnEzU31dzOy5y5j8yOEcbl/w93AJqAb+zRTe6FqimLieAd1ho7nf7JzzDa85qp3oIlVtfXC8FE277OErdZw3V1RBUOKx85mzKAI1lC/xo3v65BcVyhH85HTwYkKIApW4Mprcxv1zj0kJDJFHNMwzOonJgu6b3UMpjpmSuJ8TLHqKgLsNbj9C7+yYIwEC7+hBI8VfVHIWxTyo1TTaSJBKC3g0yZg8RVDdIGdxM56ikI3t+oX3LuhI94Z215y+O2qH3i6qiYKLg==
Content-Type: text/plain; charset="utf-8"
Content-ID: <7CFB9257C06A0D4DB50E8410B18A3FAE@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2805.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ed8dcc7-62e4-4293-7df7-08d8658328d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2020 20:55:27.2605
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3WU49qTSnI5fXmvtmjDKvrq2ZmP6P1aH19XgXqIjEj1DamDpXdeiOUUHUB8+fhAxEaE61t+MpmTLXtm6ebF+fQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2840
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-30_13:2020-09-30,2020-09-30 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQogICAgSSdtIHNheWluZyB0aGF0IHdlIGhhdmUgbm8gaWRlYSB3aG8gdGhlICJkZXRlY3Rpbmci
IHBvcnQgd2FzIGluIGFsbCBvZiANCiAgICB0aGUgc3RhdGlzdGljcy4gQXQgbGVhc3QsIGJ5IG5v
dCBjb3VudGluZyB0aGUgZGV0ZWN0aW5nIHBvcnQsIHdlIGtub3cgDQogICAgdGhhdCBhbnl0aGlu
ZyB0aGF0IGhhcyBjb3VudGVycyBpbmNyZW1lbnRpbmcgd2FzIGdlbmVyYXRpbmcgdGhlIGlzc3Vl
LiAgIA0KICAgIEkgZG9uJ3Qga25vdyBob3cgaW1wb3J0YW50IGl0IGlzIHRvIGtub3cgdGhlIGRl
dGVjdGluZyBwb3J0IC0gaWYgDQogICAgc3dpdGNoL2ZhYnJpYywgaXQgcHJvYmFibHkgZG9lc24n
dCBtYXR0ZXIuIElmIGFuIE54UG9ydCwgaXQgbWF5IGJlIA0KICAgIGludGVyZXN0aW5nIHRvIGtu
b3cuICBXZSBhbHNvIGhhdmUgbm8gaWRlYSBpZiBhbGwgdGhlIGNvdW50ZXIgdXBkYXRlcyANCiAg
ICBvY2N1cnJlZCBpbiAxIGZwaW4sIG9yIGluIE4gZnBpbnMuICAgIFdoYXQgSSB3YXMgc3VnZ2Vz
dGluZyB3YXMgdG8gbG9nIA0KICAgIHNvbWV0aGluZyBsaWtlICJGUElOICA8dHlwZT4gPGRldGVj
dGluZz4gPGF0dGFjaGVkPiIsIHdpdGggb25lIHBlciANCiAgICBkZXNjcmlwdG9yIHR5cGUgaW4g
dGhlIEZQSU4uICBXZSBjb3VsZCBkZWZhdWx0IHRoaXMgbG9nZ2luZyBvZmYsIGFuZCANCiAgICBj
aGFuZ2UgYSB0dW5hYmxlIHRvIHR1cm4gaXQgb24uDQoNCiAgICBIb3dldmVyLCBJIGZlZWwgbGlr
ZSBJJ20gdHJ5aW5nIHRvIGhhcmQgZm9yIHRoaXMgLSBzbyBsZXQncyBqdXN0IGlnbm9yZSANCiAg
ICBpdC4gV2UgY2FuIGFsd2F5cyBhZGQgaXQgaW4gdGhlIGZ1dHVyZS4NCg0KU2h5YW07IEdvdCBp
dC4gVGhhdCBtYWtlcyBzZW5zZS4NCkknbGwgbWFrZSBhIG5vdGUgb2YgdGhhdCBhbmQgc2VuZCBv
dXQgYSBwYXRjaCBmb3IgdGhpcyBzZXBhcmF0ZWx5Lg0KICAgID4NCiAgICA+IEFsbCB0aGUgb3Ro
ZXIgY29tbWVudHMgbWFrZSBzZW5zZSB0byBtZS4gSSdsbCByb2xsIHRoZW0gaW4gYW5kIHNlbmQg
b3V0IGFub3RoZXIgcGF0Y2hzZXQgc2hvcnRseS4NCiAgICA+DQogICAgPiBSZWdhcmRzDQogICAg
PiBTaHlhbQ0KICAgID4NCiAgICA+DQogICAgU291bmRzIGdvb2QuICBUaGFua3MNCg0KICAgIC0t
IGphbWVzDQoNCg0K
