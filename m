Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 890C5C38A2A
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 11:38:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D77E208D6
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 11:38:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="BQH0CBff";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="xkeQVT8y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbgEHLig (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 May 2020 07:38:36 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:20007 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbgEHLig (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2020 07:38:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1588937919; x=1620473919;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fk+YrTCPAYJvAdp2HA96m0j4kUBNbiI+DXcKtH2dJps=;
  b=BQH0CBff3mh2Zs32yVrEZdUgMoLSEMDjGZ6Ao+uVfHKTvYRtaW3WVobx
   Ac2pB1CLSu3m/QIS6qqOpJV9xUW5JxUDWka4QR08uLdfPcSkZwq7xh/uc
   nz8be+FixCtxpGv48/IqSACPcEqc883cQMDGUx0NG4VeTivbgU/mtbHte
   LGnJ5/UlRKdymNf5xZ8lnUI+Xaks3J8kfFytQQEgrT1u6yC1UY/ds2Y98
   An3PIbiJogOkcoXFWfH7iqNytqqWHx4qjh4DMO+aKMTxc8Iicj0EP0QN0
   fZvW+f5i78eOtYAf9/wzHvsRSKMgrkAvwU53/sSo/W5gsbrVIMEU+aVMB
   Q==;
IronPort-SDR: O55y3PDDdFIv1PA7x53xE8BWxRHbzlwzDcTWi3Twz9yIGI2Ev6cWVx6+e8MtQDzziSPvzR78bb
 c0EHYHfcGZFJ5bJbtn0Ryu/+dObWUj8wlxdnYYgqbc0+WBALLDH6ueLCoiepS9KCYUts4jbxFr
 zOTBbiqIK+wSuD+/TTSZw/cgMkHR0aRvC8WmTKSHJnXXVIjdrwAOeu94ybWxme3W/Mdd0OvFW0
 Zv6+Kg6riNNiAFfrC+WflQNjKAu+urP45TFaZkKB+1tD75+dDZo5XcHcf7MIOd4Mrix0VNSh1I
 NK4=
X-IronPort-AV: E=Sophos;i="5.73,367,1583164800"; 
   d="scan'208";a="239876442"
Received: from mail-dm6nam10lp2108.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.108])
  by ob1.hgst.iphmx.com with ESMTP; 08 May 2020 19:38:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WyuKMRC+a/gc4PBIduHNric8To95Nz/E3JrIG/JLZ/aO4wSs9JwSC2JAR7KRy7oR2K/WqsnxeAt9BudFBIPTM9ctc6pNHABshfrL22oHymMVdQgU26zeoquz9T1SN1ClMKu0bniOJhO0gAQTDfW5BOehoUdsjgwpKZqdgts46ONufHU13zh/EtSGgmtaMl9ZD2+LDJsh7iQ+iXO7BLSYtchPhG6gi5VGfuKtb82ZoY0PR+F9KmhL7UZSiVpl+drkmQWYk7qVWh/w6xbVbLN0eLQWJ+Yp6Hu4+029mUQAhXbe9b2C1ZjAbx9xndeQxTg+af2oA5uJmQtHcjRpe1sEKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fk+YrTCPAYJvAdp2HA96m0j4kUBNbiI+DXcKtH2dJps=;
 b=LzhksEXBAa3UFOa8FQCnMDqgf9Vj216gZCneO4s2q3wzieXg8aG/L9dZN+te2guCvpYtxGAeE9FvBbJWOKSYhyd+LleDqd/JmIzH53eS3sL0pzwo/GEMR8wg+Em9TxWQN/ccilf3knPSKQr4kcbhqNUU8Ga4HY/jiRoCVFWva0NsXMrhNt7XWU3E+25awMllVIYCRqIDVaNuOdaTEdh1FN/JABTw4GJCVgNclLOGr51CSdQiMEfnP3CrceFJM87ijBjYiZvcL3f1kx6W4Ed9xsPgyph8Rw+/NlvJgxni5STGnyn+TUM2PRhQoVYPGmSCFU7bStySZ3MJI7AWPaIu0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fk+YrTCPAYJvAdp2HA96m0j4kUBNbiI+DXcKtH2dJps=;
 b=xkeQVT8ysrvHeC5d7sZXWAqDpWvFumjJfbjzXMwTB1xykMGvTS7zVLTd0pcJxyygnD6/Xol3hzZtTfU6WWZe7LUawb1d3PQVL0maVCOUT9J0tCYLB+I9ORii0VmxykAXczC/l717k7c2wWwy88FIREGeuzCEYSbzaPb4OkYq7Ps=
Received: from BYAPR04MB4629.namprd04.prod.outlook.com (2603:10b6:a03:14::14)
 by BYAPR04MB4200.namprd04.prod.outlook.com (2603:10b6:a02:f5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.29; Fri, 8 May
 2020 11:38:31 +0000
Received: from BYAPR04MB4629.namprd04.prod.outlook.com
 ([fe80::75ba:5d7d:364c:5ae1]) by BYAPR04MB4629.namprd04.prod.outlook.com
 ([fe80::75ba:5d7d:364c:5ae1%6]) with mapi id 15.20.2958.034; Fri, 8 May 2020
 11:38:31 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "huobean@gmail.com" <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>
Subject: RE: [RESENT PATCH RFC v3 5/5] scsi: ufs: UFS Host Performance
 Booster(HPB) driver
Thread-Topic: [RESENT PATCH RFC v3 5/5] scsi: ufs: UFS Host Performance
 Booster(HPB) driver
Thread-Index: AQHWIh8+Yeo23fCZxkSCKuyUuKdpgaieD95Q
Date:   Fri, 8 May 2020 11:38:31 +0000
Message-ID: <BYAPR04MB462904DA704A8FD42436BA9FFCA20@BYAPR04MB4629.namprd04.prod.outlook.com>
References: <20200504142032.16619-1-beanhuo@micron.com>
 <20200504142032.16619-6-beanhuo@micron.com>
In-Reply-To: <20200504142032.16619-6-beanhuo@micron.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2a00:a040:188:8f6c:f01a:8dde:ed87:6de1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6f479e63-773a-4ea6-aed8-08d7f34455b6
x-ms-traffictypediagnostic: BYAPR04MB4200:
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
x-microsoft-antispam-prvs: <BYAPR04MB420047BF009786A606DDF338FCA20@BYAPR04MB4200.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 039735BC4E
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +3kF7NLToozq7361n+yef9SBMI27HTkZMcdkyZGoAGeA3xYxxmOJbI9nwcLFDQ4bOU9DnB0jy7+8mfHSzNSJG2NV0rshKxOsvxlcFMlSXu6c/gafSmCYSycyvi8DqVCa5yizAGU6l40zM2qGlZdgp6FbQCUqiJVwJeZNDXgyB25ZeEkf9DzHWPqrp9EKgfLt37t2uqfyoYK+byPl7dDiMHjfOicQhO3/rOdFUmoJaJY/kqkxwqUsJVhakc1O7mK3/PWqPwBstYl2PbWfQNxTM5shUa4C99CZgkefY0sMtI/T+ixdNiCR0soLKIzIRATdZwjoD5mwSdQDypQBqP/N0JVBK3gWQSGzJfs8NKC6InUtZa/ES0agFrdp+SCVsUi8dOJ/LbqHRD6cIvhrVjY1jUOFAWDA8ARJQAj3eeuEODAeI+OpMQggQvX3XnPZ63qPXEPxh8+kIZqWeu5VaVsImOA3urDLiKcKAPEPkYeVmXsO1P+3Gl41p5ssm20kwMJjuitSyYT4pmYl4KhiNvU91HRaXIHV/CEjbWBRRlmpz0o=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4629.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(39860400002)(346002)(366004)(376002)(33430700001)(4326008)(9686003)(2906002)(66476007)(110136005)(54906003)(7696005)(316002)(83300400001)(33656002)(5660300002)(83280400001)(83310400001)(83320400001)(33440700001)(83290400001)(8936002)(66446008)(64756008)(66556008)(76116006)(66946007)(478600001)(52536014)(6506007)(55016002)(8676002)(71200400001)(86362001)(7416002)(186003)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 9JhIoo519rVO+Cbxz/GJilxJdc1MAR8SMhftkRLiaDR6LboOX9tb1PctqXgzg4bvHerN9l3GjryPZfv1iW3/Mn8npoeJLPEVbpK8UzxM25y56n/cfP8X5ZxOSNVsHM5Dc3/dN6apVO7BC52qFNDm83EYA+0Z4sRKsRPfRzGf31KXFHglo+ykzicoIdYvZroL4pujgvVbddvqCIE7luS1s2c97PqB3eL2OVRQW6nRetVb+JTX3INq5hJe+1HnS8rDphE9aemn4C9n1ROWPofzSkoR9JSd2msu+f8cmBFxT1Actn+N7F61omz9oSdC6YjU6sQgPLKoMoB74hschp9docgvMeayUmXIz0yBw6J0qsd2JpC9ixBixrjJNeKelQjeC8zwk7iHkmtYR9PeGob2BnKtcLheKXbjZcTOpeHNy5knWJ8oW9HI1QNcKdRRg1NjuejfUGiqQB+ZBVNzvET22qoVG52vXFwklPvMd3txDnqk46pIckx3X/k/mBmtinDgqj8pOeBqiB7IR7pkvVskuq2BcaQH6lypjbyKTr2CDS8JuhKIQxVxNAN7CY8wn91s
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f479e63-773a-4ea6-aed8-08d7f34455b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 May 2020 11:38:31.5856
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wkO+GYiL6Ui6oOU7RhbeByS7yRNGBJ3n0ZW8z+ZGTpIMAhCOVRkoguAwfwMvNksZJAcKhjxZ8HLWNtCBSoOGOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4200
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGkgQmVhbiwNClRoaXMgcGF0Y2ggaXMgfjMsMDAwIGxpbmVzIGxvbmcuDQpJcyBpdCBwb3NzaWJs
ZSB0byBkaXZpZGUgaXQgaW50byBhIHNlcmllcyBvZiBhIHNtYWxsZXIsIG1vcmUgcmV2aWV3YWJs
ZSBwYXRjaGVzPw0KRS5nLiBpdCBjYW4gYmUgc29tZXRoaW5nIGxpa2U6DQoxKSBJbml0IHBhcnQg
SSAtIFJlYWQgSFBCIGNvbmZpZw0KMikgSW5pdCBwYXJ0IElJIC0gcHJlcGFyZSBmb3IgTDJQIGNh
Y2hlIG1hbmFnZW1lbnQgKGludHJvZHVjZSBoZXJlIGFsbCB0aGUgbmV3IGRhdGEgc3RydWN0dXJl
cywgbWVtb3J5IGFsbG9jYXRpb24sIGV0Yy4pDQozKSBMMlAgY2FjaGUgbWFuYWdlbWVudCAtIGFj
dGl2YXRpb24gLyBpbmFjdGl2YXRpb24gLyBldmljdGlvbiBoYW5kbGVycw0KNCkgQWRkIHJlc3Bv
bnNlIEFQSQ0KNSkgQWRkIHByZXBfZm4gaGFuZGxlciAtIHRoZSBmbG93cyB0aGF0IGNvbnRydWN0
IEhQQi1SRUFEIGNvbW1hbmQuDQpPciBhbnkgb3RoZXIgZGl2aXNpb24gdGhhdCBtYWtlcyBzZW5z
ZSB0byB5b3UuDQoNCkFsc28sIElzIHRoZXJlIGEgd2F5IHRvIGF2b2lkIGFsbCB0aG9zZSAjaWZk
ZWZzIGV2ZXJ5d2hlcmU/DQoNClRoYW5rcywNCkF2cmkNCg0KIA0KPiANCj4gRnJvbTogQmVhbiBI
dW8gPGJlYW5odW9AbWljcm9uLmNvbT4NCj4gDQo+IFRoaXMgcGF0Y2ggaXMgdG8gYWRkIHN1cHBv
cnQgZm9yIHRoZSBVRlMgSG9zdCBQZXJmb3JtYW5jZSBCb29zdGVyIChIUEINCj4gdjEuMCksDQo+
IHdoaWNoIGlzIHVzZWQgdG8gaW1wcm92ZSBVRlMgcmVhZCBwZXJmb3JtYW5jZSwgZXNwZWNpYWxs
eSBmb3IgdGhlIHJhbmRvbQ0KPiByZWFkLg0KPiANCj4gTkFORCBmbGFzaC1iYXNlZCBzdG9yYWdl
IGRldmljZXMsIGluY2x1ZGluZyBVRlMsIGhhdmUgbWVjaGFuaXNtcyB0bw0KPiB0cmFuc2xhdGUN
Cj4gbG9naWNhbCBhZGRyZXNzZXMgb2YgcmVxdWVzdHMgdG8gdGhlIGNvcnJlc3BvbmRpbmcgcGh5
c2ljYWwgYWRkcmVzc2VzIG9mIHRoZQ0KPiBmbGFzaCBzdG9yYWdlLiBUcmFkaXRpb25hbGx5IHRo
aXMgTDJQIG1hcHBpbmcgZGF0YSBpcyBsb2FkZWQgdG8gdGhlIGludGVybmFsDQo+IFNSQU0gaW4g
dGhlIHN0b3JhZ2UgY29udHJvbGxlci4gV2hlbiB0aGUgY2FwYWNpdHkgb2Ygc3RvcmFnZSBpcyBs
YXJnZXIsIGENCj4gbGFyZ2VyIHNpemUgb2YgU1JBTSBmb3IgdGhlIEwyUCBtYXAgZGF0YSBpcyBy
ZXF1aXJlZC4gU2luY2UgaW5jcmVhc2VkIFNSQU0NCj4gc2l6ZSBhZmZlY3RzIHRoZSBtYW51ZmFj
dHVyaW5nIGNvc3Qgc2lnbmlmaWNhbnRseSwgaXQgaXMgbm90IGNvc3QtZWZmZWN0aXZlDQo+IHRv
IGFsbG9jYXRlIGFsbCB0aGUgYW1vdW50IG9mIFNSQU0gbmVlZGVkIHRvIGtlZXAgYWxsIHRoZSBM
b2dpY2FsLWFkZHJlc3MgdG8NCj4gUGh5c2ljYWwtYWRkcmVzcyAoTDJQKSBtYXAgZGF0YS4gVGhl
cmVmb3JlLCBMMlAgbWFwIGRhdGEsIHdoaWNoIGlzIHJlcXVpcmVkDQo+IHRvIGlkZW50aWZ5IHRo
ZSBwaHlzaWNhbCBhZGRyZXNzIGZvciB0aGUgcmVxdWVzdGVkIElPcywgY2FuIG9ubHkgYmUgcGFy
dGlhbGx5DQo+IHN0b3JlZCBpbiBTUkFNIGZyb20gTkFORCBmbGFzaC4gRHVlIHRvIHRoaXMgcGFy
dGlhbCBsb2FkaW5nLCBhY2Nlc3NpbmcgdGhlDQo+IGZsYXNoIGFkZHJlc3MgYXJlYSB3aGVyZSB0
aGUgTDJQIGluZm9ybWF0aW9uIGZvciB0aGF0IGFkZHJlc3MgaXMgbm90IGxvYWRlZA0KPiBpbiB0
aGUgU1JBTSBjYW4gcmVzdWx0IGluIHNlcmlvdXMgcGVyZm9ybWFuY2UgZGVncmFkYXRpb24uDQo+
IA0KPiBUaGUgSFBCIGlzIGEgc29mdHdhcmUgc29sdXRpb24gZm9yIHRoZSBhYm92ZSBwcm9ibGVt
LCB3aGljaCB1c2VzIHRoZSBob3N04oCZcw0KPiBzeXN0ZW0gbWVtb3J5IGFzIGEgY2FjaGUgZm9y
IHRoZSBGVEwgTDJQIG1hcHBpbmcgdGFibGUuIEl0IGRvZXMgbm90IG5lZWQNCj4gYWRkaXRpb25h
bCBoYXJkd2FyZSBzdXBwb3J0IGZyb20gdGhlIGhvc3Qgc2lkZS4gQnkgdXNpbmcgSFBCLCB0aGUg
TDJQDQo+IG1hcHBpbmcNCj4gdGFibGUgY2FuIGJlIHJlYWQgZnJvbSBob3N0IG1lbW9yeSBhbmQg
c3RvcmVkIGluIGhvc3Qtc2lkZSBtZW1vcnkuIHdoaWxlDQo+IHJlYWRpbmcgdGhlIG9wZXJhdGlv
biwgdGhlIGNvcnJlc3BvbmRpbmcgTDJQIGluZm9ybWF0aW9uIHdpbGwgYmUgc2VudCB0byB0aGUN
Cj4gVUZTIGRldmljZSBhbG9uZyB3aXRoIHRoZSByZWFkaW5nIHJlcXVlc3QuIFNpbmNlIHRoZSBM
MlAgZW50cnkgaXMgcHJvdmlkZWQgaW4NCj4gdGhlIHJlYWQgcmVxdWVzdCwgVUZTIGRldmljZSBk
b2VzIG5vdCBoYXZlIHRvIGxvYWQgTDJQIGVudHJ5IGZyb20gZmxhc2gNCj4gbWVtb3J5Lg0KPiBU
aGlzIHdpbGwgc2lnbmlmaWNhbnRseSBpbXByb3ZlIHJhbmRvbSByZWFkIHBlcmZvcm1hbmNlLg0K
PiANCj4gU2lnbmVkLW9mZi1ieTogQmVhbiBIdW8gPGJlYW5odW9AbWljcm9uLmNvbT4NCj4gLS0t
DQo+ICBkcml2ZXJzL3Njc2kvdWZzL0tjb25maWcgIHwgICA2MiArDQo+ICBkcml2ZXJzL3Njc2kv
dWZzL01ha2VmaWxlIHwgICAgMSArDQo+ICBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5jIHwgIDIz
NCArKystDQo+ICBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hjZC5oIHwgICAyMyArDQo+ICBkcml2ZXJz
L3Njc2kvdWZzL3Vmc2hwYi5jIHwgMjc2Nw0KPiArKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrDQo+ICBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hwYi5oIHwgIDQyMyArKysrKysNCj4g
IDYgZmlsZXMgY2hhbmdlZCwgMzUwNCBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQ0KPiAg
Y3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvc2NzaS91ZnMvdWZzaHBiLmMNCj4gIGNyZWF0ZSBt
b2RlIDEwMDY0NCBkcml2ZXJzL3Njc2kvdWZzL3Vmc2hwYi5oDQo+IA0K
