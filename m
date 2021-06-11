Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C900BC48BE0
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Jun 2021 18:31:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A73A96140B
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Jun 2021 18:31:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbhFKSdE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Jun 2021 14:33:04 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:58090 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230265AbhFKSdD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 11 Jun 2021 14:33:03 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15BITces011349;
        Fri, 11 Jun 2021 11:31:02 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-0016f401.pphosted.com with ESMTP id 393x92kf2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 11:31:02 -0700
Received: from m0045849.ppops.net (m0045849.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15BIV1FJ013039;
        Fri, 11 Jun 2021 11:31:01 -0700
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by mx0a-0016f401.pphosted.com with ESMTP id 393x92kf2t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Jun 2021 11:31:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EcTKM/sEGJ90K0T5VNj0CEr/XslizVuoVGif4XifDHcdFEqwxTnLNrH0Kgfa1BV4wUMw3wAZofUR7KPIBk/TXZHGTrO/NhqCk+W2xvA0uW9C0aeeqRLYP1w/wDvaUIyXljp9D11mNHilrFo/tU/5RRjiZcRb2aNQpf0xmGuYgIisUvob+E4p7Kx2TjkNQttxKNiJtGazQHlb2J1HFHgQlBiOx1/vW1izQHZ/qER9+ebTIFOp4+FhbuqD546wVmEmlilV2edL6O12fmN+HzLRyL+YoZK4pMK46aQfvAYD4nVcQg4OP+J6Ti6aUK3hP6XPIWEAFdUyr1GzVqqe6q3Cqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MCr7znET+JDaiaIjeuziVBKVg513Mj//hhE0bNtl254=;
 b=IktIPhxr3WkyJENntE7eJQCfwsmDyRPK8j0NHBynByfpt+9s5zlhTqC3/+mV9kE6JcfMJatgHrEUiBiDTCyBW7LwekxDxmw9xWqGl9USEtq3UeVVpwnJ2Ya1yLTxrs8hZTCyV5Tj0Gvx9WWq08hd905ZlDksm/lKpjbVy+n6WJU+mZLLvC0HL0KBW4If5+5Ub+p07lirZFs15KWCBNo5MBDg6gsG9nAComrD8gfMjLS/zvqzNLm0b3LCxurPCubauj8O6sPqq4aT/PFmRBPNYgG8FOYQ2B3siEhPUZ3yPtaS0V3fRhIK7OMYWeDZzg7QetNyszRBFZdOeGo0n6b4Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MCr7znET+JDaiaIjeuziVBKVg513Mj//hhE0bNtl254=;
 b=q7HqHf3ECI1iArHBmarJ/YyTVWzrZnS/b5b03f8ky0PRKK4r0la++6eq63eWEbcSiTASd57AixaFGOsLlUn5XDBOxFY33Z2sIjKH8kepkNXI9YY6aFD6IHlnD8PvFgR8zEEF1V6Cqkrd7eWDZUurp48FmPSWJkULN9J7yAwlNNY=
Received: from BY5PR18MB3345.namprd18.prod.outlook.com (2603:10b6:a03:1ae::30)
 by BY5PR18MB3314.namprd18.prod.outlook.com (2603:10b6:a03:1ad::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.23; Fri, 11 Jun
 2021 18:30:59 +0000
Received: from BY5PR18MB3345.namprd18.prod.outlook.com
 ([fe80::a5e6:1262:9d8a:11b8]) by BY5PR18MB3345.namprd18.prod.outlook.com
 ([fe80::a5e6:1262:9d8a:11b8%3]) with mapi id 15.20.4219.024; Fri, 11 Jun 2021
 18:30:59 +0000
From:   Quinn Tran <qutran@marvell.com>
To:     Hannes Reinecke <hare@suse.de>,
        Nilesh Javali <njavali@marvell.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: RE: [PATCH v2 05/10] qla2xxx: Add key update
Thread-Topic: [PATCH v2 05/10] qla2xxx: Add key update
Thread-Index: AQHXVeu8IlP+P0oIL0qYLDMLFPqo0Kr/IO8AgBACjPA=
Date:   Fri, 11 Jun 2021 18:30:59 +0000
Message-ID: <BY5PR18MB3345555E1C0046C92B9CED7DD5349@BY5PR18MB3345.namprd18.prod.outlook.com>
References: <20210531070545.32072-1-njavali@marvell.com>
 <20210531070545.32072-6-njavali@marvell.com>
 <78890a8b-bbd7-44da-0e7b-49d8748a9f62@suse.de>
In-Reply-To: <78890a8b-bbd7-44da-0e7b-49d8748a9f62@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [68.5.10.209]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4ac90231-564f-4f56-6309-08d92d070f46
x-ms-traffictypediagnostic: BY5PR18MB3314:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR18MB33141654475D5C1CF8EC4BC3D5349@BY5PR18MB3314.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: i5H7OY72gqlqP3M3cvQayulPYMwC6sUIe6VxGa9fCnDmeYwJfaoOdSAVDjqCQKPVFh8OR8ZktM62WdVzTGtQk+5mWMYGSDZxg28XSleKRVE/M8o4EyN/n93zMnw/QSC4QE3hTQ5wt2lI9S0bDLiW9AnucxNrOjwngW78fpwmNdCQtbm6pcDN2VUVN8J7xoLJ33vJt4tLC4SbUbkf23Qy+xnt1LfO/T1Nu3NEc1+BfBb2S6/GIgi7+wWA/IjspbULXYWRdfV17BWGcrriGHZ+NnrI2uL+BWn+Gm15H3bvP+BdChVl3HYJfH19yiBoMiijwwS1tn/w3jsp2rD8HZ1gjQ3RagG65iT73yWjZWxXMxLca8jeMlwQkYgODrIEYnZvHkgZqIIPGy58fxWpR+7X2v2iCS8ez4Mr74kYbKK1qJxZDB9ym4CXu/Wri6GvCvsCqwQWFzJzjMnYd1rok8WLezHMEo2q0mis1gd02XcTL7rjBSZjpVv0PReIGiH49HH+uQ0ldwKxNSONbbHbGHWe494DCIcjCGWYg5jm4ImkAEWX0JlJj+RZsCgAhjs+k1Bskw8E8pl61pD7G+Nh46cvKEazYvMihcu1iPedssNpkLs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR18MB3345.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(39860400002)(366004)(396003)(376002)(478600001)(83380400001)(33656002)(66946007)(71200400001)(9686003)(54906003)(107886003)(66476007)(7696005)(52536014)(5660300002)(76116006)(8676002)(8936002)(66446008)(66556008)(64756008)(4326008)(122000001)(2906002)(186003)(86362001)(6506007)(55016002)(316002)(38100700002)(110136005)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RGl2TlBpLzlha1QzVVhNcUlBblhQNWRVamJGZ0c4eTlIWjA0bHRuZXQ4Y3dT?=
 =?utf-8?B?dTVFNks5MWVjaGlzQlRuRXJ5RENIaGFUYTc5YjM2bW1qditMK2FtQkg0eWpW?=
 =?utf-8?B?c1hQanBQMWZLaVFWbkMxWFJ1TkEzbTlOZHk3QVVMYUlIMGtXM0FVcHJHTVNj?=
 =?utf-8?B?NXNINit4czdxc2NDNzhmbnY0SGdhR0cxNWhoUGNUVXIzbFRsYTRZbEZ2cEZo?=
 =?utf-8?B?T1RRNlJLRmlWSjVUSzRIYkJ3RjJNc0pIQ2c5SW9kcXkwZ0RBVXV0cXp6S1Mv?=
 =?utf-8?B?eFVoY2JjUlRtT015T0NiUWxZUmd0TkUyemlnbElETGd6VjZ0Lzd0WjI4bnZF?=
 =?utf-8?B?bGVpVXE0QnVSSGNSNEdiOXJhc3lQWWc0eVRYSDM2WlJDdDVtb0toekNNaTJz?=
 =?utf-8?B?WEswOVBBOUhoNllIU0dBd04vNzRwM0drVEtLTDVUTW5VSzJqV1Zxd3Qya3gy?=
 =?utf-8?B?UmZTYXhncVY0a1NaaDJOdjJZRzRRN3hXdTZESGpqb3o1NVRsaTZiYzFsRU0z?=
 =?utf-8?B?bnFXUXhUNU9DYmNER3JkWkNadFdlRmZCMnpkWGRrbXJRdGNYTXR6VGZIaGds?=
 =?utf-8?B?aUhwVGk5NUpZNWhzeXE5Unh2TURtY0o2ZTJDWG5DSi83UEZZUXFhZzRqVUFJ?=
 =?utf-8?B?Ykt6ZGQxa3FrVHJadS9iQmxiVXdoajBIV3EwaFUzSG5ydUVoa042UXBha1Rn?=
 =?utf-8?B?cWJhTlhqdUhjeGVNQUlkMm90cVdCY0FUR2VuTTZBQUFZUFVKQ3RUR213TGNK?=
 =?utf-8?B?QnNqK0U5MzJJQjVRK2ZVNGhOK01hM3hhOStnaDdET1NCTThtY01GWlZBaGZk?=
 =?utf-8?B?TkErdkpMSENSTWNPSXlHeXlHVFVJeUg0ZUsyZ3ZpaktDNFNPc3JrWEMzNlFk?=
 =?utf-8?B?NDQrV0hlK2htdWNQMURCWS9USnBQdmp3cnU2T1lxbU5HdkZwWWxhZ1lON1FT?=
 =?utf-8?B?TXZqanVZcUFncFp1U1AvM2FVTVFZcEdoKzg1R3lCZFJXRVdrZHZDYk5BcXJC?=
 =?utf-8?B?emdIK2xqbDkralE4V000a2pFa0tGRXJXN3l3ZWlNUTZjUW1LckxJLzk3MHNs?=
 =?utf-8?B?Y1BWMXNkVUNjMElvY25zTHEzNUtGbXp1dGlJQ21QUGJHUlo1ZllTc0Znb3o0?=
 =?utf-8?B?SHJBNXVFWXJCMmlEUE5mSk9rdFVwOVB3K3BpcnlXSkE1a1UwbjZkZEFqVnl0?=
 =?utf-8?B?SnhueE5rM3RmQlprVEtXVEFGTUFPTmxPUkpiZ1BraHptMk9aT0Jab1ByOE9R?=
 =?utf-8?B?TWVuWVdXNWhVeEpKZmJjb2E2dDJJcE85MVE4bW8zSlBiNGFyUmwwc2wwL201?=
 =?utf-8?B?UXV4d0xhRENGVFBiaFM2Y01ReU5VYmxycS9tTkZ2djUrbEtBWmV2c0xmbVJk?=
 =?utf-8?B?NkgvNHRNMlpjUytjYXhpOHhwVThTK3R3MWR2KzlYdWREZmNqVWRIYk5Tekcv?=
 =?utf-8?B?R3AreFFsaGJIeVQzOVh5ZlRCV2NCaDlVTy9TelhhRzc5NzJaUDdEUTl6ZlBz?=
 =?utf-8?B?ajlMRUpuejE0TzRBWlY2eGt6L1RkSk5qTFhzSUNXR2JXOUduVEFhUjFnTkQv?=
 =?utf-8?B?ZjBqMndxMjNSek5nWXZKOUVCVXpocXpoWlgvMlBsWVhCaytpcGppWTJqM3Ax?=
 =?utf-8?B?VkROUXl2bU1td3BDM1U2dXZZTUl2NksvSUdjWjRPWTNNMzNuVmtGenpZVGZx?=
 =?utf-8?B?ZTFzc3gvUVA4Q3ZqR29Ib3UxUnJiZ1o0bFFrTnZWeHFQQXU0eU5wcVgzMkdO?=
 =?utf-8?Q?L5x7v3D9Y//awTyfK0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR18MB3345.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ac90231-564f-4f56-6309-08d92d070f46
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jun 2021 18:30:59.2428
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oaODNKThBeoDNpoqDjnhb9wxbvayxp/mM87DBbQFut0j8ZOgVeAZNtXCtitm5BZDyYtAb3LdkbN4HAwaUOOd5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR18MB3314
X-Proofpoint-ORIG-GUID: 9Mp0xbebGAeH72Akj0CzYT50fCf-dZxD
X-Proofpoint-GUID: kt859mP17OQekRvKmhbgbHKdP3_TCF43
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-11_06:2021-06-11,2021-06-11 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

QWNrIG9uIHN0eWxpbmcgY29tbWVudCB3aWxsIGZpeCB3aXRoIHYzLg0KDQotLS0tDQo+ICsJc3Bp
bl9sb2NrX2lycXNhdmUoJmhhLT5zYWRiX2xvY2ssIGZsYWdzKTsNCj4gKwlmb3IgKHNsb3QgPSAw
OyBzbG90IDwgMjsgc2xvdCsrKSB7DQoNCjIgPyBXaHkgJzInID8NCg0KDQpUaGlzICdzYV9wYWly
JyB0aGluZ2llIGlzIGF3a3dhcmQuDQpXaGF0IGlzIHRoZSAnc2FfaW5kZXgnIGluZGljYXRpbmc/
DQpTb21lIHNvcnQgb2YgaW5kZXggd2l0aGluIGEgbGlzdC9hcnJheT8NCkFuZCB3aHkgaGFzIGVh
Y2ggb2YgdGhlIHBhaXJzIGEgZGlzdGluY3QgJ3NhX2luZGV4JyBmaWVsZD8NCkkgd291bGQgaGF2
ZSBleHBlY3RlZCB0aGF0IHRoZSAncGFpcicgcmVhbGx5IF9pc18gYSBwYWlyIChhbmQgaGVuY2UN
CndvdWxkIHRha2Ugb25seSBvbmUgaW5kZXgpLiBCdXQgdGhlIHdheSBpdCdzIHdyaXR0ZW4gaXQg
bG9va3MgYXMgaWYgdGhlDQpwYWlyIGNhbiBoYXZlIHR3byBkaXN0aW5jdCBpbmRpY2VzIC4uLg0K
UGxlYXNlIGNsYXJpZnkuDQoNClFUOiBlYWNoIHNlc3Npb24gY2FuIGhhdmUgdXAgdG8gMiBzZXQg
b2Yga2V5cy4gIDEgc2V0L3BhaXIgaXMgZm9yIHR4ICsgcnggaW4gZmxpZ2h0IHRyYWZmaWMgKDIg
a2V5cykuICBUaGUgMm5kIHNldC9wYWlyIGNvbWVzIGludG8gcGxheSBhdCByZWtleSB0aW1lICgy
IG1vcmUga2V5cykuICAgNGtleXMgIHBlciBzZXNzaW9uIG9yIDIgcGFpcnMgcGVyIHNlc3Npb24u
ICAya2V5cyBwZXIgZGlyZWN0aW9uLg0KDQpFYWNoIGtleSBpcyB0cmFja2VkIHZpYSBhbiBzYV9p
bmRleC9oYW5kbGUgYmV0d2VlbiBkcml2ZXIgKyBoYXJkd2FyZS4gIDEgc2FfaW5kZXggPSAxIGtl
eS4NCg0KQXQgcmVrZXkvcmVhdXRoZW50aWNhdGlvbiB0aW1lLCB0aGUgMm5kIHNsb3QvcGFpciBj
b21lcyBpbnRvIHBsYXkuICBXaGVuIHRyYWZmaWMgaW4gZWFjaCBkaXJlY3Rpb24gaGFzIHRyYW5z
aXRpb25lZCB0byB0aGUgbmV3IGtleSwgdGhlIG5ldyBrZXkgYmVjb21lcyB0aGUgY3VycmVudCBr
ZXkuICBUaGUgb2xkIGtleSB3aWxsIGJlIGRlbGV0ZWQuICAgc2FfcGFpciBbIDAgfCAxIF0gd2ls
bCBhbHRlcm5hdGUgaW4gaG9sZGluZyB0aGUgY3VycmVudCBrZXksIHdoaWxlIHRoZSBvdGhlciBz
bG90IGlzIGNsZWFyZWQgYW5kIHVzZSB0byBzdGFnZSB0aGUgbmV4dCBrZXkgYXQgbmV4dCByZWtl
eSBldmVudC4NCg0KDQoNClJlZ2FyZHMsDQpRdWlubiBUcmFuDQoNCg==
