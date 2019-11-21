Return-Path: <SRS0=2e3T=ZN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EEE1C432C0
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 16:38:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A16120692
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 16:38:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Csp5Yv7R";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="M7gxeK6x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbfKUQio (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Nov 2019 11:38:44 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:53912 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726541AbfKUQio (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Nov 2019 11:38:44 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xALGUK3l024378;
        Thu, 21 Nov 2019 08:38:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=C4TPW7tT0hG7jr409iBUF5O7jvvvaC1KCq5B8+rJ9Cw=;
 b=Csp5Yv7RLlNgp6WdSF/XADRTrPPGMPeHAcrZ7l3eoIYKQYxwvCKp2QkRrTPFriC+gZf0
 2rskzvo3Ng4RgujWaUHHRP0iF6KOqCkiN05Sj95E63OJW2Bc8Gwep5O3KzZYNrxMgBah
 O7cWbP3ph3iJlV4vsJBSR7pmHj0IGAVU6E7iRmduT+riEqQhM/05AD8mnGPEbYEDJPb1
 8UtLpFsbfU3ZSwWbhi6Thu61pSsYzynu10JNHeTv4TOdiespD9TT8IHoO6DqQREc6ytg
 AP7bdSAkGcrdPG3YGreUmuGHg2k0OPBYX8dBB1HXn72AGHG9tJcFNio0oSsBGB3tmcM/ ZA== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2wc842efv6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 21 Nov 2019 08:38:43 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 21 Nov
 2019 08:38:42 -0800
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (104.47.40.56) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 21 Nov 2019 08:38:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oda5n/R1sipONH4zyFNa/x2EGugd2+xIWZRUEr5eL/mAPq+QVdxxwneXqNUP174esHScPU4ZVj5hgBJQn1pw4GnmIhlToy2mk3VQnn2Z4mVqshnlYacsTB0aDk6a2Btf71c4ty+iDMcPXDWo/C2mljgww74LAEc4VrnYT3KuZxmd086t10DhYApOhG3cKMnCII1AHXYysQr9iEO6PWpgS0ftZC3ArrEwKMdE5BLZkH6/OxQbWAjlh0rIMfUzh+V3WYnwQrwncoqMZctt6qkxFPCjLxNBU3q66CJG3b7e3aGzy/bC07yt1YKVjhg8jI3jDqPEMiQr4JJDWv+fwSLtjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C4TPW7tT0hG7jr409iBUF5O7jvvvaC1KCq5B8+rJ9Cw=;
 b=Ddc3Sr41BOPt7VaqlpwfBWhjHybSNJu3zsGcB+W1QWcdBa3hqquJT++MZPqBpljQuNPCB2BOmJDtQ8OeQiPEoxzkDX/KjXAui4+ht2rGCmseiFsLBFzTjlHV1x6TcIrwHRMa7scDq07zPBpFXu3TcsW/Vw4s6/oxTC9U3P3+LR5dNZlvEbdtJ3cak4aWgvppFWGk5IR+tlNIED2yVP7LMLWJpA2ztBUBfFZDMllkLa17va4rU0oeiAmrw4dx9S38i0e2e+cu570xLPexZE8OHo75ko4peIm5AVTptvvSXEgJ+PJ8e+8PoCx0zi4x20G96FRwLx1wc9wR621K7VKOzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C4TPW7tT0hG7jr409iBUF5O7jvvvaC1KCq5B8+rJ9Cw=;
 b=M7gxeK6xnQe9Hpq5toL5TvL562k4QwXBMcQZ0ha+8a2tRQDFAzIOqYwAlUQ3dKAla/g9r5r2gw1BoUAbLQ17WTeYrcEPCisibfwiajIl6/ZfSDbwTl0Ylu5LlfmMmZvX7nrhxcLTsfdWGLRuxW5XDCgLYlJV1dkaBlWuiR4B3vk=
Received: from MN2PR18MB2719.namprd18.prod.outlook.com (20.178.255.156) by
 MN2PR18MB2989.namprd18.prod.outlook.com (20.179.23.97) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.27; Thu, 21 Nov 2019 16:38:41 +0000
Received: from MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::1435:34ad:dbff:5089]) by MN2PR18MB2719.namprd18.prod.outlook.com
 ([fe80::1435:34ad:dbff:5089%7]) with mapi id 15.20.2451.031; Thu, 21 Nov 2019
 16:38:41 +0000
From:   Himanshu Madhani <hmadhani@marvell.com>
To:     Quinn Tran <qutran@marvell.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
CC:     "linux@yadro.com" <linux@yadro.com>
Subject: Re: [EXT] [PATCH v2 05/15] scsi: qla2xxx: Allow PLOGI in target mode
Thread-Topic: [EXT] [PATCH v2 05/15] scsi: qla2xxx: Allow PLOGI in target mode
Thread-Index: AQHVn/G8Cq2ZxTvGbE+bw0zLXWGmmqeUqm2AgADFW4A=
Date:   Thu, 21 Nov 2019 16:38:41 +0000
Message-ID: <02BC133C-1758-4FD7-AD39-5B97AD4C6158@marvell.com>
References: <20191120222723.27779-1-r.bolshakov@yadro.com>
 <20191120222723.27779-6-r.bolshakov@yadro.com>
 <BYAPR18MB2759F79A6F217771C44CDF0BD54F0@BYAPR18MB2759.namprd18.prod.outlook.com>
In-Reply-To: <BYAPR18MB2759F79A6F217771C44CDF0BD54F0@BYAPR18MB2759.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.1f.0.191110
x-originating-ip: [2600:1700:211:eb30:e5e4:c939:a3a3:4c5b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e851a471-c096-49aa-581a-08d76ea14475
x-ms-traffictypediagnostic: MN2PR18MB2989:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB298993FDB586FE9C6EDD8C85D64E0@MN2PR18MB2989.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0228DDDDD7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(136003)(39860400002)(346002)(376002)(189003)(199004)(91956017)(5660300002)(6436002)(186003)(76116006)(305945005)(2501003)(33656002)(7736002)(71200400001)(71190400001)(6486002)(86362001)(8936002)(14444005)(6512007)(256004)(2616005)(102836004)(6116002)(58126008)(36756003)(6506007)(508600001)(2906002)(25786009)(99286004)(8676002)(76176011)(46003)(14454004)(110136005)(2201001)(229853002)(4326008)(81166006)(66446008)(66556008)(6246003)(446003)(66946007)(316002)(66476007)(11346002)(81156014)(64756008);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2989;H:MN2PR18MB2719.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pUm5N8eNwcLAVQ8bS81PEoyU0Hh/l+7WP1Ejf9mPf/cGEIB/Ky6lz4jPogpWr329lKmzhEMeepLbWgbDCzhbL8UEyWIDE2wB7UoMsAtZ63M+QQQYEFTROBhaatYFddp9hkpb7f3PhajQwHtxFXOs6K7VBz41tivYalYwLeoAXikRqCOUcECgqvM88RiAL7ijgXGEwSmG4ry0/IqtueKUsRd6KcpafftdK51iDxjMHpfAqc5ubcGesklq/Ezx5iSNfndWTJWEr3sDL5o+o1ILm/OuzrUReRCeOoNET3UXJDWS9UhY1TzISsHIMswhzhR79czbMXmcFw9rprtPFlTpkjzX/MdYbkcejh2CojkpJIQzhNQcz+z5m1e+JMRKqSFHZqA+RVlDD4aL4Zo6VQee2OQOSLA0OYDu77oTaLZEld0TZZ6UnN4+HGMmOZ6anLgp
Content-Type: text/plain; charset="utf-8"
Content-ID: <C8D7B381D317F349A51A110398ECF407@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e851a471-c096-49aa-581a-08d76ea14475
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2019 16:38:41.1316
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yuaJwBhsU5MWxufxo8qmBTmuwxruG406wgtel+Wvebqg/iWtHZNBzT9XXdjlAl/Gn/lLPLxS9i2madO3rxTzMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2989
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-21_04:2019-11-21,2019-11-21 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQoNCu+7v09uIDExLzIwLzE5LCA0OjUyIFBNLCAiUXVpbm4gVHJhbiIgPHF1dHJhbkBtYXJ2ZWxs
LmNvbT4gd3JvdGU6DQoNCiAgICBBY2NvcmRpbmcgdG8gRkMtTFMtMyAoRmlicmUgQ2hhbm5lbCBM
aW5rIFNlcnZpY2VzKSA2LjMuMi40ICJOX1BvcnQgTG9naW4gLSBObyBGYWJyaWMgcHJlc2VudCIs
IGlmIGJvdGggcGFydGllcyBpbiB0aGUgcG9pbnQtdG8tcG9pbnQgY29ubmVjdGlvbiBrbm93IE5f
UG9ydF9OYW1lcyBvZiBlYWNoIG90aGVyLCBOeF9Qb3J0IHdpdGggdGhlIGhpZ2hlc3QgTl9Qb3J0
X25hbWUgc2hhbGwgdHJhbnNtaXQgUExPR0kuIFRoZSBzcGVjaWZpY2F0aW9uIHNldHMgbm8gcmVz
dHJpY3Rpb25zIG9uIHRoZSBwb3J0IHJvbGUgdGhhdCBzaG91bGQgc2VuZCBQTE9HSS4NCiAgICAN
CiAgICBIb3dldmVyLCBGQ1AtNCAoRmlicmUgQ2hhbm5lbCBQcm90b2NvbCBmb3IgU0NTSSwgRm91
cnRoIFZlcnNpb24pIDYuMiAiT3ZlcnZpZXcgb2YgUHJvY2VzcyBMb2dpbiBhbmQgUHJvY2VzcyBM
b2dvdXQiLCBpbnN0cnVjdHMgdGhhdCBpbiBwb2ludC10by1wb2ludCB0b3BvbG9neSwgaW5pdGlh
dG9yIHNoYWxsIHNlbmQgZXhwbGljaXQgUFJMSSBFTFMuDQogICAgDQogICAgVGhlIGNoYW5nZSBm
aXhlcyBzdHVjayBQMlAgbG9naW4sIHdoZW4gdGFyZ2V0IFdXUE4gaXMgaGlnaGVyIHRoYW4gaW5p
dGlhdG9yIFdXUE4uDQogICAgDQogICAgQ2M6IFF1aW5uIFRyYW4gPHF1dHJhbkBtYXJ2ZWxsLmNv
bT4NCiAgICBDYzogSGltYW5zaHUgTWFkaGFuaSA8aG1hZGhhbmlAbWFydmVsbC5jb20+DQogICAg
U2lnbmVkLW9mZi1ieTogUm9tYW4gQm9sc2hha292IDxyLmJvbHNoYWtvdkB5YWRyby5jb20+DQog
ICAgLS0tDQogICAgIGRyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pbml0LmMgfCA4ICsrKystLS0t
DQogICAgIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pDQog
ICAgDQogICAgZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pbml0LmMgYi9k
cml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaW5pdC5jIGluZGV4IGZjYjMwOWJlNTBkOS4uMTIzOTE4
MTViZTA2IDEwMDY0NA0KICAgIC0tLSBhL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pbml0LmMN
CiAgICArKysgYi9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfaW5pdC5jDQogICAgQEAgLTE1Mjcs
MTAgKzE1MjcsNiBAQCBpbnQgcWxhMjR4eF9mY3BvcnRfaGFuZGxlX2xvZ2luKHN0cnVjdCBzY3Np
X3FsYV9ob3N0ICp2aGEsIGZjX3BvcnRfdCAqZmNwb3J0KQ0KICAgICAJCX0NCiAgICAgCX0NCiAg
ICAgDQogICAgLQkvKiBmb3IgcHVyZSBUYXJnZXQgTW9kZS4gTG9naW4gd2lsbCBub3QgYmUgaW5p
dGlhdGVkICovDQogICAgLQlpZiAodmhhLT5ob3N0LT5hY3RpdmVfbW9kZSA9PSBNT0RFX1RBUkdF
VCkNCiAgICAtCQlyZXR1cm4gMDsNCiAgICAtDQogICAgUVQ6ICBOYWNrLiAgTGVhdmUgdGhpcyBo
dW5rLiAgSW5zdGVhZCBkbyB0aGlzDQoNCiAgICANCiAgICBpZiAodmhhLT5ob3N0LT5hY3RpdmVf
bW9kZSA9PSBNT0RFX1RBUkdFVCkgJiYgIU4yTl9UT1BPKHZoYS0+aHcpDQogICAgDQogICAgLS0N
Cg0KQWdyZWUuIFBsZWFzZSByZXNlbmQgd2l0aCB1cGRhdGUuDQogICAgDQogICAgDQogICAgIAlp
ZiAoZmNwb3J0LT5mbGFncyAmIEZDRl9BU1lOQ19TRU5UKSB7DQogICAgIAkJc2V0X2JpdChSRUxP
R0lOX05FRURFRCwgJnZoYS0+ZHBjX2ZsYWdzKTsNCiAgICAgCQlyZXR1cm4gMDsNCiAgICBAQCAt
MTcyMCw2ICsxNzE2LDEwIEBAIHZvaWQgcWxhMjR4eF9oYW5kbGVfcmVsb2dpbl9ldmVudChzY3Np
X3FsYV9ob3N0X3QgKnZoYSwgIHZvaWQgcWxhX2hhbmRsZV9lbHNfcGxvZ2lfZG9uZShzY3NpX3Fs
YV9ob3N0X3QgKnZoYSwNCiAgICAgCQkJCSAgICAgIHN0cnVjdCBldmVudF9hcmcgKmVhKQ0KICAg
ICB7DQogICAgKwkvKiBmb3IgcHVyZSBUYXJnZXQgTW9kZSwgUFJMSSB3aWxsIG5vdCBiZSBpbml0
aWF0ZWQgKi8NCiAgICArCWlmICh2aGEtPmhvc3QtPmFjdGl2ZV9tb2RlID09IE1PREVfVEFSR0VU
KQ0KICAgICsJCXJldHVybjsNCiAgICArDQogICAgUVQ6ICBBY2suDQogICAgDQogICAgIAlxbF9k
YmcocWxfZGJnX2Rpc2MsIHZoYSwgMHgyMTE4LA0KICAgICAJICAgICIlcyAlZCAlOHBoQyBwb3N0
IFBSTElcbiIsDQogICAgIAkgICAgX19mdW5jX18sIF9fTElORV9fLCBlYS0+ZmNwb3J0LT5wb3J0
X25hbWUpOw0KICAgIC0tDQogICAgMi4yNC4wDQogICAgDQogICAgDQoNCg==
