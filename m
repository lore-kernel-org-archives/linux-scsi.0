Return-Path: <SRS0=RMqd=ZO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED29DC432C0
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 17:00:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ACB1C2068F
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 17:00:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="lr4qoSXq";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="cESL//IB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbfKVRA0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Nov 2019 12:00:26 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:44046 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726046AbfKVRA0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 Nov 2019 12:00:26 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAMGxuTC008595;
        Fri, 22 Nov 2019 09:00:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=RTtoVfMscvIbGj6Qdy4j3gmb6mUrKcye0smUuSX1z2Y=;
 b=lr4qoSXqaL2ns+hgtFDNRc/bFNe1vyooJq9UtXTZqDK5PpkTf7UVRsKQrcwnItBCXo7G
 euIpwxbe7DG2+Q3/TFsVo7JIh9SH2oR+8SFUKqvyxOrJHE7pqgvtTc5vyWxU3si40b8x
 6jP72L3ATGt61wakSrgPSo0YyU03TxaglJsyYUhdMJrHL4ObW3JoGT7FdJ90Ta5dJFEy
 Wurh/KQwUVcZv/jt/mHRva/caqWGk5Eo5P6YDVvfT0LO3nYMt/vOUK3pTc1G5ZtysCS2
 QeMoXgp5AlXHWrCClwp5ieV2qMcHMN2uY9DbLe98ypBwZsRTSno35JpRY/OvYlsan/W5 2A== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2wearf25sd-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 22 Nov 2019 09:00:23 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 22 Nov
 2019 09:00:22 -0800
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (104.47.32.59) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Fri, 22 Nov 2019 09:00:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HdIEwD9lDTVJFBZXa33wHQ3zN8GdZoz6pS5eDMAKcIgdr+BhoJmbcsZh9DLKx8mA94eFHvd9dNA5vhqbt3oS6/DxwkZsv6yHr0IO3KmBSEzmjbkUZFeKlWs9qAEPVfcUI9BvWfzL4R2a4L8d1a2+m1wUusmKhfFUsC2j4JzO1iYk076UsdMTbFowTJVq/anZJkZ0p2jMCQms0Rrq8WUNx4trIR8JJbxSrRM3TBZmYToIr/37OuGzXw+0capEKW1sT1J1jD3cyM6VttTwj3GnymYe41UAkj4aCtMOWlSahBviamVbZf5AD9MlsV9ttdRrTNUSdzbFZOgaqT55ySgccQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RTtoVfMscvIbGj6Qdy4j3gmb6mUrKcye0smUuSX1z2Y=;
 b=bNCPuEtqSk2nVKOBMHOhUmjS4YnLi5b4A8fm+zse5yNJbwVpA66iljMT/l4cbxcMjtjVfNXV1NXYTaleGleDMQpU0o2Ow2zwkr0dIfEkAayfF8DMsSDw7IeIqPYcou7k2wClYVI3OdFv5FL9S5zWHeubVPjJ1j444m0087j3ejULsdePGe6xE6Q/fpSC6qZhKMhr1mfyHhoiRNtmTuL7Cwf53s9ctD2WGye61t/2cNQ/4dGZDrnagkD9sfoeMeeb34T+L6DfQWbbp76K2GdM+3DTrHUK3s/ldL7gG/oLw1PmLL0FgC0LQZ3mCi8x/n4xmLO7jGe8fkG6SuQ8pmRKjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RTtoVfMscvIbGj6Qdy4j3gmb6mUrKcye0smUuSX1z2Y=;
 b=cESL//IBOiwqrMJr98owzGdR5DALvZ5Foj1K43C5o4/sHJAhYv8uadPtIERd3jp3SbpBZFYOv6KHS8ArgMey1t+2tUhjNLzsa3JudZNOEwWLlM4WzticK0W+RiT2Wd4yx6oq13Ylu3msa96DFomaxvAHj/uFwX7izWDtL8On1To=
Received: from BYAPR18MB2759.namprd18.prod.outlook.com (20.179.58.88) by
 BYAPR18MB2422.namprd18.prod.outlook.com (20.179.93.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.19; Fri, 22 Nov 2019 17:00:20 +0000
Received: from BYAPR18MB2759.namprd18.prod.outlook.com
 ([fe80::5907:fd6e:ff93:426b]) by BYAPR18MB2759.namprd18.prod.outlook.com
 ([fe80::5907:fd6e:ff93:426b%7]) with mapi id 15.20.2451.031; Fri, 22 Nov 2019
 17:00:20 +0000
From:   Quinn Tran <qutran@marvell.com>
To:     Mark Harvey <mark.harvey@nutanix.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
CC:     "linux@yadro.com" <linux@yadro.com>
Subject: RE: [EXT] [PATCH v2 13/15] scsi: qla2xxx: Add async mode for
 qla24xx_els_dcmd_iocb
Thread-Topic: [EXT] [PATCH v2 13/15] scsi: qla2xxx: Add async mode for
 qla24xx_els_dcmd_iocb
Thread-Index: AQHVn/HNnHFaS7vbK06G1KxyqGbBA6eWPDuggABooACAAMQJ8A==
Date:   Fri, 22 Nov 2019 17:00:20 +0000
Message-ID: <BYAPR18MB2759379EFEA3AAAED43CA114D5490@BYAPR18MB2759.namprd18.prod.outlook.com>
References: <20191120222723.27779-1-r.bolshakov@yadro.com>
 <20191120222723.27779-14-r.bolshakov@yadro.com>
 <BYAPR18MB2759E4C4CDDA0D5447D7A5BDD54E0@BYAPR18MB2759.namprd18.prod.outlook.com>
 <81096D5B-FEC9-4A40-BE7B-ADB8CA1C5CA2@nutanix.com>
In-Reply-To: <81096D5B-FEC9-4A40-BE7B-ADB8CA1C5CA2@nutanix.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.186.1.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2f797db1-cf46-4412-87a8-08d76f6d752e
x-ms-traffictypediagnostic: BYAPR18MB2422:
x-microsoft-antispam-prvs: <BYAPR18MB2422BEC00DE846717795D4EFD5490@BYAPR18MB2422.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(376002)(346002)(39860400002)(366004)(189003)(199004)(13464003)(74316002)(71190400001)(14454004)(71200400001)(25786009)(2501003)(52536014)(110136005)(33656002)(186003)(478600001)(6246003)(5660300002)(55016002)(7696005)(316002)(296002)(4326008)(99286004)(7736002)(2201001)(14444005)(256004)(6506007)(86362001)(9686003)(6116002)(26005)(76116006)(76176011)(3846002)(66066001)(229853002)(102836004)(66476007)(6436002)(81156014)(81166006)(8676002)(8936002)(11346002)(66446008)(446003)(66556008)(305945005)(64756008)(66946007)(53546011)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR18MB2422;H:BYAPR18MB2759.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4bHAYRdASt0/gdis/VqBWRaeTIc9BNfZWGtmTmnLgTWoPVTtxmEPdDrwdYcM6vPzoKTEkrsYqCHKMoHYNkyRSPPV9AS1tsF/ZgNQeGymSj2nmCcwqGMdvfJQgJUXRQ5FFW/Il63q1EzUJecpKm1dYODaLpQeHyEVj4H/ABBRUq/ld6D2P3yOkHK0GUNBM4havA5wkzKV69b7XMjmrYH5FewNAWBrRztNvEcPAHRUfuVCN+ROJns61MJs8+btz3RXY5Yn3A0JdAPVi4bJtKtiBOKLN01lSNGrOFjjrFP3wvpFV3T7nwN6R7yqdd1ro4fTmqd5OhCrTOXAWMSXQa+4Jl+EdJBQXHpOJlmbyUE7pMoVGuuwoHqur3jOFDxQ9udN88gGpKyNzt13TMZGAt+Os12GbF6GNaQjhJhJSdoE8h/5Rv8CiqT3KnF3O3afPuxO
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f797db1-cf46-4412-87a8-08d76f6d752e
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2019 17:00:20.2917
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3y49/NhEzGKGiGkKBWgGubBMf/UzlMB8p+a7q5koaUhjZJIkAkNfDimKVnpSjC5Wb30QqH2P1U9mFTjQY3j30w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2422
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-22_03:2019-11-21,2019-11-22 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

DQpGcm9tOiBNYXJrIEhhcnZleSA8bWFyay5oYXJ2ZXlAbnV0YW5peC5jb20+IA0KU2VudDogVGh1
cnNkYXksIE5vdmVtYmVyIDIxLCAyMDE5IDk6MDUgUE0NClRvOiBRdWlubiBUcmFuIDxxdXRyYW5A
bWFydmVsbC5jb20+OyBSb21hbiBCb2xzaGFrb3YgPHIuYm9sc2hha292QHlhZHJvLmNvbT47IGxp
bnV4LXNjc2lAdmdlci5rZXJuZWwub3JnOyB0YXJnZXQtZGV2ZWxAdmdlci5rZXJuZWwub3JnDQpD
YzogbGludXhAeWFkcm8uY29tDQpTdWJqZWN0OiBSZTogW0VYVF0gW1BBVENIIHYyIDEzLzE1XSBz
Y3NpOiBxbGEyeHh4OiBBZGQgYXN5bmMgbW9kZSBmb3IgcWxhMjR4eF9lbHNfZGNtZF9pb2NiDQoN
CldvdWxkIHRoaXMgbm90IHJlc3VsdCBpbiBhIG1lbW9yeSBsZWFrIGluIHRoZSAnZWxzZScgcGF0
aCAtIHNraXBwaW5nIHNwLT5mcmVlKHNwKT8NCg0KUVQ6IEdvb2QgcG9pbnQuICBUaGlzIG1lYW4g
dGhlIHBhdGNoIGlzIG1pc3NpbmcgcWxhMngwMF9lbHNfZGNtZF9zcF9kb25lIGNoZWNraW5nIGZv
ciBTUkJfV0FLRVVQX09OX0NPTVAgdG8gd2FrZSB1cCBvciBmcmVlIHRoZSBzcC4NCiAgDQogIC0J
d2FpdF9mb3JfY29tcGxldGlvbigmZWxzaW8tPnUuZWxzX2xvZ28uY29tcCk7DQogICAgKwlpZiAo
d2FpdCkgew0KICAgICsJCXdhaXRfZm9yX2NvbXBsZXRpb24oJmVsc2lvLT51LmVsc19sb2dvLmNv
bXApOw0KICAgICsJfSBlbHNlIHsNCiAgICArCQlnb3RvIGRvbmU7DQogICAgKwl9DQogICAgIA0K
ICAgICAJc3AtPmZyZWUoc3ApOw0KICAgICtkb25lOg0KICAgICAJcmV0dXJuIHJ2YWw7DQogICAg
IH0NCg0K77u/T24gMjIvMTEvMTksIDk6NTEgYW0sICJ0YXJnZXQtZGV2ZWwtb3duZXJAdmdlci5r
ZXJuZWwub3JnIG9uIGJlaGFsZiBvZiBRdWlubiBUcmFuIiA8dGFyZ2V0LWRldmVsLW93bmVyQHZn
ZXIua2VybmVsLm9yZyBvbiBiZWhhbGYgb2YgcXV0cmFuQG1hcnZlbGwuY29tPiB3cm90ZToNCg0K
ICAgIExvb2tzIGdvb2QuDQogICAgDQogICAgQWNrZWQtYnk6IFF1aW5uIFRyYW4gPHF1dHJhbkBt
YXJ2ZWxsLmNvbT4NCiAgICANCiAgICANCiAgICBSZWdhcmRzLA0KICAgIFF1aW5uIFRyYW4NCiAg
ICANCiAgICAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KICAgIEZyb206IFJvbWFuIEJvbHNo
YWtvdiA8ci5ib2xzaGFrb3ZAeWFkcm8uY29tPiANCiAgICBTZW50OiBXZWRuZXNkYXksIE5vdmVt
YmVyIDIwLCAyMDE5IDI6MjcgUE0NCiAgICBUbzogbGludXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmc7
IHRhcmdldC1kZXZlbEB2Z2VyLmtlcm5lbC5vcmcNCiAgICBDYzogbGludXhAeWFkcm8uY29tOyBS
b21hbiBCb2xzaGFrb3YgPHIuYm9sc2hha292QHlhZHJvLmNvbT47IFF1aW5uIFRyYW4gPHF1dHJh
bkBtYXJ2ZWxsLmNvbT4NCiAgICBTdWJqZWN0OiBbRVhUXSBbUEFUQ0ggdjIgMTMvMTVdIHNjc2k6
IHFsYTJ4eHg6IEFkZCBhc3luYyBtb2RlIGZvciBxbGEyNHh4X2Vsc19kY21kX2lvY2INCiAgICAN
CiAgICBFeHRlcm5hbCBFbWFpbA0KICAgIA0KICAgIC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCiAgICBxbGEyNHh4
X2Vsc19kY21kX2lvY2IoKSBwZXJmb3JtcyBMT0dPIGFuZCBtaWdodCBiZSBpbnZva2VkIGluIGNv
bnRleHRzIHdoZXJlIGl0IGlzIHByb2hpYml0ZWQgdG8gc2xlZXAuIFRoZSBuZXcgd2FpdCBwYXJh
bWV0ZXIgcHJvdmlkZXMgYSB3YXkgdG8gdXNlIHRoZSBmdW5jdGlvbiBpbiBzdWNoIGNvbnRleHQs
IHNpbWlsYXJseSB0byBxbGEyNHh4X2Vsc19kY21kMl9pb2NiKCkuDQogICAgDQogICAgQ2M6IFF1
aW5uIFRyYW4gPHF1dHJhbkBtYXJ2ZWxsLmNvbT4NCiAgICBDYzogSGltYW5zaHUgTWFkaGFuaSA8
aG1hZGhhbmlAbWFydmVsbC5jb20NCiAgICBTaWduZWQtb2ZmLWJ5OiBSb21hbiBCb2xzaGFrb3Yg
PHIuYm9sc2hha292QHlhZHJvLmNvbT4NCiAgICAtLS0NCiAgICAgZHJpdmVycy9zY3NpL3FsYTJ4
eHgvcWxhX2F0dHIuYyAgIHwgIDIgKy0NCiAgICAgZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2di
bC5oICAgIHwgIDIgKy0NCiAgICAgZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2lvY2IuYyAgIHwg
MTEgKysrKysrKysrLS0NCiAgICAgZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX3RhcmdldC5jIHwg
IDIgKy0NCiAgICAgNCBmaWxlcyBjaGFuZ2VkLCAxMiBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9u
cygtKQ0KICAgIA0KICAgIGRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfYXR0
ci5jIGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2F0dHIuYyBpbmRleCA0ODFjMDVkYmVhMDYu
LjM1YzcwM2VjNTlhZCAxMDA2NDQNCiAgICAtLS0gYS9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFf
YXR0ci5jDQogICAgKysrIGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX2F0dHIuYw0KICAgIEBA
IC04MjgsNyArODI4LDcgQEAgcWxhMngwMF9pc3N1ZV9sb2dvKHN0cnVjdCBmaWxlICpmaWxwLCBz
dHJ1Y3Qga29iamVjdCAqa29iaiwNCiAgICAgDQogICAgIAlxbF9sb2cocWxfbG9nX2luZm8sIHZo
YSwgMHg3MGU0LCAiJXM6ICVkXG4iLCBfX2Z1bmNfXywgdHlwZSk7DQogICAgIA0KICAgIC0JcWxh
MjR4eF9lbHNfZGNtZF9pb2NiKHZoYSwgRUxTX0RDTURfTE9HTywgZGlkKTsNCiAgICArCXFsYTI0
eHhfZWxzX2RjbWRfaW9jYih2aGEsIEVMU19EQ01EX0xPR08sIGRpZCwgdHJ1ZSk7DQogICAgIAly
ZXR1cm4gY291bnQ7DQogICAgIH0NCiAgICAgDQogICAgZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2Nz
aS9xbGEyeHh4L3FsYV9nYmwuaCBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9nYmwuaCBpbmRl
eCA1YjE2M2FkODVjMzQuLmRmMGYzNDIxZTNiYiAxMDA2NDQNCiAgICAtLS0gYS9kcml2ZXJzL3Nj
c2kvcWxhMnh4eC9xbGFfZ2JsLmgNCiAgICArKysgYi9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFf
Z2JsLmgNCiAgICBAQCAtNDMsNyArNDMsNyBAQCBleHRlcm4gdm9pZCBxbGEyeDAwX2NsZWFyX2xv
b3BfaWQoZmNfcG9ydF90ICpmY3BvcnQpOyAgZXh0ZXJuIGludCBxbGEyeDAwX2ZhYnJpY19sb2dp
bihzY3NpX3FsYV9ob3N0X3QgKiwgZmNfcG9ydF90ICosIHVpbnQxNl90ICopOyAgZXh0ZXJuIGlu
dCBxbGEyeDAwX2xvY2FsX2RldmljZV9sb2dpbihzY3NpX3FsYV9ob3N0X3QgKiwgZmNfcG9ydF90
ICopOw0KICAgICANCiAgICAtZXh0ZXJuIGludCBxbGEyNHh4X2Vsc19kY21kX2lvY2Ioc2NzaV9x
bGFfaG9zdF90ICosIGludCwgcG9ydF9pZF90KTsNCiAgICArZXh0ZXJuIGludCBxbGEyNHh4X2Vs
c19kY21kX2lvY2Ioc2NzaV9xbGFfaG9zdF90ICosIGludCwgcG9ydF9pZF90LCANCiAgICArYm9v
bCk7DQogICAgIGV4dGVybiBpbnQgcWxhMjR4eF9lbHNfZGNtZDJfaW9jYihzY3NpX3FsYV9ob3N0
X3QgKiwgaW50LCBmY19wb3J0X3QgKiwgYm9vbCk7ICBleHRlcm4gdm9pZCBxbGEyeDAwX2Vsc19k
Y21kMl9mcmVlKHNjc2lfcWxhX2hvc3RfdCAqdmhhLA0KICAgICAJCQkJICAgc3RydWN0IGVsc19w
bG9naSAqZWxzX3Bsb2dpKTsNCiAgICBkaWZmIC0tZ2l0IGEvZHJpdmVycy9zY3NpL3FsYTJ4eHgv
cWxhX2lvY2IuYyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pb2NiLmMgaW5kZXggNTNjY2Jk
NmI3MWVkLi4xMmIzN2I3MTFhZTggMTAwNjQ0DQogICAgLS0tIGEvZHJpdmVycy9zY3NpL3FsYTJ4
eHgvcWxhX2lvY2IuYw0KICAgICsrKyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV9pb2NiLmMN
CiAgICBAQCAtMjU2Miw3ICsyNTYyLDcgQEAgc3RhdGljIHZvaWQgcWxhMngwMF9lbHNfZGNtZF9z
cF9kb25lKHNyYl90ICpzcCwgaW50IHJlcykNCiAgICAgDQogICAgIGludA0KICAgICBxbGEyNHh4
X2Vsc19kY21kX2lvY2Ioc2NzaV9xbGFfaG9zdF90ICp2aGEsIGludCBlbHNfb3Bjb2RlLA0KICAg
IC0gICAgcG9ydF9pZF90IHJlbW90ZV9kaWQpDQogICAgKyAgICBwb3J0X2lkX3QgcmVtb3RlX2Rp
ZCwgYm9vbCB3YWl0KQ0KICAgICB7DQogICAgIAlzcmJfdCAqc3A7DQogICAgIAlmY19wb3J0X3Qg
KmZjcG9ydCA9IE5VTEw7DQogICAgQEAgLTI2MDEsNiArMjYwMSw4IEBAIHFsYTI0eHhfZWxzX2Rj
bWRfaW9jYihzY3NpX3FsYV9ob3N0X3QgKnZoYSwgaW50IGVsc19vcGNvZGUsDQogICAgIAllbHNp
by0+dGltZW91dCA9IHFsYTJ4MDBfZWxzX2RjbWRfaW9jYl90aW1lb3V0Ow0KICAgICAJcWxhMngw
MF9pbml0X3RpbWVyKHNwLCBFTFNfRENNRF9USU1FT1VUKTsNCiAgICAgCWluaXRfY29tcGxldGlv
bigmc3AtPnUuaW9jYl9jbWQudS5lbHNfbG9nby5jb21wKTsNCiAgICArCWlmICh3YWl0KQ0KICAg
ICsJCXNwLT5mbGFncyA9IFNSQl9XQUtFVVBfT05fQ09NUDsNCiAgICAgCXNwLT5kb25lID0gcWxh
MngwMF9lbHNfZGNtZF9zcF9kb25lOw0KICAgICAJc3AtPmZyZWUgPSBxbGEyeDAwX2Vsc19kY21k
X3NwX2ZyZWU7DQogICAgIA0KICAgIEBAIC0yNjM3LDkgKzI2MzksMTQgQEAgcWxhMjR4eF9lbHNf
ZGNtZF9pb2NiKHNjc2lfcWxhX2hvc3RfdCAqdmhhLCBpbnQgZWxzX29wY29kZSwNCiAgICAgCSAg
ICBzcC0+bmFtZSwgc3AtPmhhbmRsZSwgZmNwb3J0LT5sb29wX2lkLCBmY3BvcnQtPmRfaWQuYi5k
b21haW4sDQogICAgIAkgICAgZmNwb3J0LT5kX2lkLmIuYXJlYSwgZmNwb3J0LT5kX2lkLmIuYWxf
cGEpOw0KICAgICANCiAgICAtCXdhaXRfZm9yX2NvbXBsZXRpb24oJmVsc2lvLT51LmVsc19sb2dv
LmNvbXApOw0KICAgICsJaWYgKHdhaXQpIHsNCiAgICArCQl3YWl0X2Zvcl9jb21wbGV0aW9uKCZl
bHNpby0+dS5lbHNfbG9nby5jb21wKTsNCiAgICArCX0gZWxzZSB7DQogICAgKwkJZ290byBkb25l
Ow0KICAgICsJfQ0KICAgICANCiAgICAgCXNwLT5mcmVlKHNwKTsNCiAgICArZG9uZToNCiAgICAg
CXJldHVybiBydmFsOw0KICAgICB9DQogICAgIA0KICAgIGRpZmYgLS1naXQgYS9kcml2ZXJzL3Nj
c2kvcWxhMnh4eC9xbGFfdGFyZ2V0LmMgYi9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfdGFyZ2V0
LmMNCiAgICBpbmRleCA2OGMxNDE0M2U1MGUuLjBmMmJjNGNkNTYyZiAxMDA2NDQNCiAgICAtLS0g
YS9kcml2ZXJzL3Njc2kvcWxhMnh4eC9xbGFfdGFyZ2V0LmMNCiAgICArKysgYi9kcml2ZXJzL3Nj
c2kvcWxhMnh4eC9xbGFfdGFyZ2V0LmMNCiAgICBAQCAtOTMyLDcgKzkzMiw3IEBAIHFsdF9zZW5k
X2ZpcnN0X2xvZ28oc3RydWN0IHNjc2lfcWxhX2hvc3QgKnZoYSwgcWx0X3BvcnRfbG9nb190ICps
b2dvKQ0KICAgICANCiAgICAgCW11dGV4X3VubG9jaygmdmhhLT52aGFfdGd0LnRndF9tdXRleCk7
DQogICAgIA0KICAgIC0JcmVzID0gcWxhMjR4eF9lbHNfZGNtZF9pb2NiKHZoYSwgRUxTX0RDTURf
TE9HTywgbG9nby0+aWQpOw0KICAgICsJcmVzID0gcWxhMjR4eF9lbHNfZGNtZF9pb2NiKHZoYSwg
RUxTX0RDTURfTE9HTywgbG9nby0+aWQsIHRydWUpOw0KICAgICANCiAgICAgCW11dGV4X2xvY2so
JnZoYS0+dmhhX3RndC50Z3RfbXV0ZXgpOw0KICAgICAJbGlzdF9kZWwoJmxvZ28tPmxpc3QpOw0K
ICAgIC0tDQogICAgMi4yNC4wDQogICAgDQogICAgDQoNCg==
