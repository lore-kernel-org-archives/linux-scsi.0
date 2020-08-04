Return-Path: <SRS0=m56l=BO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CAE1C433E4
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Aug 2020 09:51:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7825F22C9F
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Aug 2020 09:51:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="BaQSp383";
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="T2Ht7AdL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729897AbgHDJvV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Aug 2020 05:51:21 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:37194 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729032AbgHDJvU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2020 05:51:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1596534678; x=1628070678;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Lbja9kd853xkbPrBpY9E2mCAT5YKMsj3zhKZ5Om7ls4=;
  b=BaQSp383W5Dmd381O5Tj7WPA4VeUJkryFba3TRPsI/JfvtRL/uHmtIsn
   dO5ToHgL8TP5vZbuSvjcd+hyydcRCO1uYNlyIIFXxz3pZlLUjDGUsvtvR
   y0jxQ03TGuN5JO5dVtKDg0YIZktUVOgN/Y2FMOKELnt+CKxiY6lt4L4ff
   VC/iVzvW7VCzGkBlI4tAv2v6eqEgqnTL3FiFF3ngARz2xPEydisYFY7Eg
   3SR8Y57T0dWWwpz5ZaWlqaBvGDjHB6FgcxgBHhIMh9vSIEDNv3dCT3UN8
   RJlAGpBfD8t3Uv4Ib69n2plUQZIqCpDi4qrJ4A4kBaXWCGRGXcrsmbtAS
   Q==;
IronPort-SDR: 41I58lCWxQi+7NFTNri3wscmxE/m5THNPVkRDSDhjj9GZRg9ttbtaKzu61ryeg5BFTaKJA8dkb
 7EKyyVYjyjKPRbxJCLqNVH66IsEQkqw6+KZApf39qpuu3VR49OdSwyZcvnkIZgfM/8EqBsPHHb
 RkgCYI7H7Iz5bO6P+8L1LG3pCGgwzKStcW3qqz0YUS+CJ2Jofo2UIBay4MV6S2auCsAW7lpL7H
 MBeQngDXhGV1yvay49GGSZS/SCMCcJfUsr1NfZjv179b6RM/dg8OALjxUi8mTyz05rHexHd64E
 6sY=
X-IronPort-AV: E=Sophos;i="5.75,433,1589266800"; 
   d="scan'208";a="21667213"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Aug 2020 02:51:18 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 4 Aug 2020 02:51:15 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Tue, 4 Aug 2020 02:51:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mu6t6dx2Ee+eOSQ675bw6j+/iY3RsY/VEI5juXWw2U5vTR0wZRBqZS0qajHfc0pyd+whNIhv2aFmv76ZwcvRTSP+hLBkWzZBcXXLi+Q0O7oWPxo8Q5jl6fc0wWf6VX9LrroyCxDV/HFykLWQP/pw3Ts5WIJzcsnTrMOpDKgjv1Ey7uyAKUxBaCDmeEUoLw917BlD5om94kNbrRSuXkr5nSyhRgku3QVXAWDwchxIi4e3LJDOutgt8chjyTql8xc5K3xCoeqh3GCvntDb7g6YmuVyapGoLw4Im1BFVo8n/+NSZVT2u/gkxaZcXIbCTtQqdIe+PkULrGCiCsk31xSHmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lbja9kd853xkbPrBpY9E2mCAT5YKMsj3zhKZ5Om7ls4=;
 b=LvlZE+/t5m+vFW6GiOlPI7XxzTxZNYvKfEGmTQ8HwTw3uHdfm5qTXtqkEJz2MNqUQcHDSzwU8pOPuZup0foVNMOsVCHyMvaDyHRsnHQhdSSx1FLqKq5Y0NafVD3NxI8Ehx1jWHlNQmBIh/hXqmH4MS3pwtMOMn6Kh2nkSYVoURzulFovHeXtzyid+64Ze4O3EQEcNyiBUyJYb7uIvFCBqKno5c+yUL2yRDixqJQzxtUrdDebv5OOiGoBVmaSGV21JM7JMRkhZZPcEHXiv6T4VwStTsbE9v/fwe5AkQrbmipSuN3o6ua93anUXEDM3b9/0RybMeW2QzI75FwdBvXw+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lbja9kd853xkbPrBpY9E2mCAT5YKMsj3zhKZ5Om7ls4=;
 b=T2Ht7AdL1bWKURY5z4oBUfrhYOQ35z0bwZc8GipQYyGK9io4FODs84L3D+uMlkjPrwqfebYq/bCl7JA1C/UbLJLNPo0xbRHMM2jxrBrnqB4MhLTKDus49tek6VypqFvZ0kxDWzPrzjdr6S/UnLXNcLSB2+Vd7wdCMW8pmgjl8CA=
Received: from MWHPR11MB1568.namprd11.prod.outlook.com (2603:10b6:301:f::20)
 by MWHPR11MB1645.namprd11.prod.outlook.com (2603:10b6:301:b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.21; Tue, 4 Aug
 2020 09:51:11 +0000
Received: from MWHPR11MB1568.namprd11.prod.outlook.com
 ([fe80::c8ea:a04c:8daa:a503]) by MWHPR11MB1568.namprd11.prod.outlook.com
 ([fe80::c8ea:a04c:8daa:a503%12]) with mapi id 15.20.3261.015; Tue, 4 Aug 2020
 09:51:11 +0000
From:   <Deepak.Ukey@microchip.com>
To:     <john.garry@huawei.com>, <hch@infradead.org>
CC:     <linux-scsi@vger.kernel.org>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <jinpu.wang@profitbricks.com>,
        <martin.petersen@oracle.com>, <yuuzheng@google.com>,
        <auradkar@google.com>, <vishakhavc@google.com>,
        <bjashnani@google.com>, <radha@google.com>, <akshatzen@google.com>,
        <chenxiang66@hisilicon.com>, <yanaijie@huawei.com>,
        <luojiaxing@huawei.com>
Subject: RE: [PATCH V6 2/2] pm80xx : Staggered spin up support.
Thread-Topic: [PATCH V6 2/2] pm80xx : Staggered spin up support.
Thread-Index: AQHWahpYwcBHbbKDcU2nwyxmUYyn4KkndX2AgAAIPuCAAC0kgIAACimw
Date:   Tue, 4 Aug 2020 09:51:11 +0000
Message-ID: <MWHPR11MB1568027073E64A535B278D32EF4A0@MWHPR11MB1568.namprd11.prod.outlook.com>
References: <20200804045628.6590-1-deepak.ukey@microchip.com>
 <20200804045628.6590-3-deepak.ukey@microchip.com>
 <20200804060235.GA28428@infradead.org>
 <DM5PR11MB15637501DB12BE665E81C7FBEF4A0@DM5PR11MB1563.namprd11.prod.outlook.com>
 <1d09bf1a-f555-b5de-a369-9797f96b2e9d@huawei.com>
In-Reply-To: <1d09bf1a-f555-b5de-a369-9797f96b2e9d@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [157.47.60.174]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 25e54001-50cb-415c-39fd-08d8385beb75
x-ms-traffictypediagnostic: MWHPR11MB1645:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB16455CB0418D63C65CDAC967EF4A0@MWHPR11MB1645.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y3Xj9zftizoa6yzCsVVpZGfyHxJBctqWddOV5T+P2YbR8sZIFt1J/bvZy1z7I5AQtjr1JnWfo4+Agz63jRtyYG42/Yit7ihUxTQPU+dBmlFf52S614xsj2JxWKCj1TuIhIDNPxaAGlxhx6awteAo1jMp57Iu1xX24f2sG9OhG8k7vz0hUp/6IhhYLQlgbZ2Qd5hswDaHkfQeRLbQz8B45hG9RBFcNuDianR/8+OqbiL+QhrwNOq4OYhLwmhldyLEQjb6VcpdCWnArYDxxAIaj/aTt9Qs3P0G/JkE+1ssUfKZvF3+3xK7gQRTwb3/HAwu
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1568.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(346002)(366004)(136003)(39860400002)(396003)(316002)(2906002)(8676002)(54906003)(110136005)(26005)(186003)(7416002)(52536014)(8936002)(4326008)(5660300002)(7696005)(86362001)(76116006)(66476007)(478600001)(66946007)(66556008)(64756008)(66446008)(6506007)(33656002)(71200400001)(53546011)(83380400001)(55016002)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: S5thL7pdT14v/XlbOqhVOrZkOWt13P4Rxdc4F4aoWNTN3NWqqD40TpUiS575j9Zn4/2QV2rMxwoyyhGMso2PAX32UXLQ2s9feUAezekE8kQ/M7FftlG69IFh6Np/Y2CRIlgudnvfJXscWhM5xat5NTvzO7j6Xntn2zMZWBFE098WOUKboT7Co4Mz+LvpTUTEmcRdu0f1pmVfM9tddrnp8ShD/BhwKO6uhhViXLJ7KqgQJyo7y1EdkH5ue3CEcV5hdrplY3Ru6Wo9c4JhlVd/BlFxZalq/VzMy67bFdAslz3RDPHcPXXeNA3OYdyJOa0STiH0iGMGXOyZqNss1GEM3108Aoh0Ld2iGLgR7gmJRcxh/LClkuziLQ38QYmFIN/AkG4a4t06eBDyau5CuWOwW2YUO+LUdix7XedTRecbUnbFNtGhGgrSvrXpkw+niEENc3N/W7PY5IIAiT1vDhmE5KjjJSvlo6/YUXheDV3OpWW8gb+M3PnPRInInnXVgbnDJ2dal9ZP8tl39fuviYWU+lLtiHTSKvN0f85kvHMz8PJHAbSmOElOHm9/nZf96vrsO8eIp3Tfr0OOKID1plXN+KUmH8UwweMs/6knkhrJ9eX8hNK5Q8hDICUedI0k/1ho0snbM+uOrXZAAmTT9f0DrQ==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1568.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25e54001-50cb-415c-39fd-08d8385beb75
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2020 09:51:11.4673
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wVGn3965KZJ26kpmkQKEN+UrR930j2326q+A5YGKjTKYOURT9aWECc2nTfEnvnI6EcDZadqmSqsWoGAPaRg5BjeBB8BOBHPRHbMt1sRTRGc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1645
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

RVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVu
bGVzcyB5b3Uga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQoNCk9uIDA0LzA4LzIwMjAgMDc6MzMs
IERlZXBhay5Va2V5QG1pY3JvY2hpcC5jb20gd3JvdGU6DQo+IEhpIENocmlzdG9waCwNCj4NCj4g
WWVzLCBJdCBpcyBiZXR0ZXIgdG8gYmUgaW1wbGVtZW50ZWQgaW4gbGlic2FzLiBTaW5jZSB0aGUg
b3V0IG9mIGJveCBwbTgweHggZHJpdmVyIGhhcyB0aGlzIHN1cHBvcnQsIHdlIHdvdWxkIGxpa2Ug
dG8gcHVzaCB0aGlzIGZvciB0aGUgdGltZSBiZWluZy4gV2Ugd2lsbCBzZWUgaG93IHRoaXMgY2Fu
IGJlIG1vdmVkIHRvIGxpYnNhcy4NCj4NCg0KT3RoZXIgbGlic2FzIHVzZXJzIG1heSBsaWtlIHRo
aXMgZmVhdHVyZS4gQW5kIGxpYnNhcyBkb2VzIGFscmVhZHkgc3VwcG9ydCBTQVRBIHNwaW4tdXAg
aG9sZCBldmVudHMgLSBhcyBkb2VzIHBtODAwMSAtIGJ1dCB0aGVyZSdzIG5vdCByZWFsbHkgbXVj
aCB0byB0aGF0IGluIGxpYnNhcy4NCg0KUXVlc3Rpb246IHdoeSBoYXZlIGEgbW9kdWxlIHBhcmFt
IHRvIGVuYWJsZSB0aGlzIGZlYXR1cmU/IFdoeSBub3Qgc29sZWx5IHJlbHkgb24gdGhlIHNlZXBy
b20gc3Bpbi11cCBpbnRlcnZhbCwgd2hlcmVieSBhIHZhbHVlIG9mIDAgbWVhbnMgbm8gc3RhZ2dl
cmVkIHNwaW4tdXA/DQotIFNldHRpbmcgc3Bpbi11cCBpbnRlcnZhbCBtYXkgaW5jcmVhc2UgdGhl
IHRpbWUgZm9yIGRldmljZSBkaXNjb3ZlcnkuICBDdXN0b21lciB3aG8gaGFzIGEgdmFsaWQgc3Bp
biB1cCBpbnRlcnZhbCAgICAgICAtIGNvbmZpZ3VyZWQgY2FuIHN0aWxsIHR1cm4gb2YgdGhpcyB1
c2luZyBtb2R1bGUgcGFyYW1ldGVyLiBPciBlbHNlLCB0aGV5IGhhdmUgdG8gcmVmbGFzaCB0aGUg
c2VlcHJvbS4gIA0KDQpUaGFua3MNCkRlZXBhaw0KPg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2Ut
LS0tLQ0KPiBGcm9tOiBDaHJpc3RvcGggSGVsbHdpZyBbbWFpbHRvOmhjaEBpbmZyYWRlYWQub3Jn
XQ0KPiBTZW50OiBUdWVzZGF5LCBBdWd1c3QgNCwgMjAyMCAxMTozMyBBTQ0KPiBUbzogRGVlcGFr
IFVrZXkgLSBJMzExNzIgPERlZXBhay5Va2V5QG1pY3JvY2hpcC5jb20+DQo+IENjOiBsaW51eC1z
Y3NpQHZnZXIua2VybmVsLm9yZzsgVmFzYW50aGFsYWtzaG1pIFRoYXJtYXJhamFuIC0gSTMwNjY0
IA0KPiA8VmFzYW50aGFsYWtzaG1pLlRoYXJtYXJhamFuQG1pY3JvY2hpcC5jb20+OyBWaXN3YXMg
RyAtIEkzMDY2NyANCj4gPFZpc3dhcy5HQG1pY3JvY2hpcC5jb20+OyBqaW5wdS53YW5nQHByb2Zp
dGJyaWNrcy5jb207IA0KPiBtYXJ0aW4ucGV0ZXJzZW5Ab3JhY2xlLmNvbTsgeXV1emhlbmdAZ29v
Z2xlLmNvbTsgYXVyYWRrYXJAZ29vZ2xlLmNvbTsgDQo+IHZpc2hha2hhdmNAZ29vZ2xlLmNvbTsg
Ymphc2huYW5pQGdvb2dsZS5jb207IHJhZGhhQGdvb2dsZS5jb207IA0KPiBha3NoYXR6ZW5AZ29v
Z2xlLmNvbQ0KPiBTdWJqZWN0OiBSZTogW1BBVENIIFY2IDIvMl0gcG04MHh4IDogU3RhZ2dlcmVk
IHNwaW4gdXAgc3VwcG9ydC4NCj4NCj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5r
cyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3Uga25vdyANCj4gdGhlIGNvbnRlbnQgaXMg
c2FmZQ0KPg0KPiBBcyBtZW50aW9uZWQgYmVmb3JlIC0gdGhpcyBzaG91bGQgYmUgYSBsaWJzYXMg
b3IgdHJhbnNwb3J0IGNsYXNzIHBvbGljeSwgYW5kIG5vdCBhIG1vZHVsZSBwYXJhbWV0ZXIgaGFj
ayBpbiBvbmUgZHJpdmVyLg0KPiAuDQo+DQoNCg==
