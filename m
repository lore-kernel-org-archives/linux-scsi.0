Return-Path: <SRS0=pZIS=2X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B382DC2D0DC
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jan 2020 16:41:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7927C206E6
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jan 2020 16:41:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="PAEAVVnb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728721AbgABQlq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jan 2020 11:41:46 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:47249 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728280AbgABQlp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jan 2020 11:41:45 -0500
Received-SPF: Pass (esa2.microchip.iphmx.com: domain of
  Viswas.G@microchip.com designates 198.175.253.82 as permitted
  sender) identity=mailfrom; client-ip=198.175.253.82;
  receiver=esa2.microchip.iphmx.com;
  envelope-from="Viswas.G@microchip.com";
  x-sender="Viswas.G@microchip.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1 mx
  a:ushub1.microchip.com a:smtpout.microchip.com
  -exists:%{i}.spf.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa2.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Viswas.G@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa2.microchip.iphmx.com; spf=Pass smtp.mailfrom=Viswas.G@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: gtSpz3ht0/6ugE/a2FhJHszqn2aehxVbQLVSCyd3L0c6BFm9L2gT+mjDxq42vy2+bjTJMT8vI/
 3a7Sx3NB+7QpjRBj3waFQwHQ3DZmR2SygOCSGOFhOcJPHRXTxctmSIHoYnIWT1//obNgRK+ihI
 BhGvBu+6hroKR2/nVyLo7G4l1gvNVg3QEde59BooMebTvtHlXXXso5cBnl//5G8ynjHNhuKWuD
 TXLUyjOiKyM/Xli/ydludRXHpacNT7wATLcdImID+78+02g6b3Dt0PvmQmhLwXoHYPMLAVA7Rb
 eSI=
X-IronPort-AV: E=Sophos;i="5.69,387,1571727600"; 
   d="scan'208";a="61446520"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Jan 2020 09:41:44 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 2 Jan 2020 09:41:44 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Thu, 2 Jan 2020 09:41:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DUcC3Nplaepcv02Vnc8hQtr1V8BD4ENso5hG8jsA4xkS1mHYV5X1kJLuHnj/uXDtHmJp2JAfQcDXr1d0iyBhho+oWxoldQsWBHTMXkPmIbm4P3Ld8iNd/Px2PdY/9hWQsxwPj5c3d/f/Vf9OY38X7B4jKvpkacjS+5Y1Ccadcj6FRaJ3o1G5cAbIaf3gWsAsP2eN0+EH5HbWNkgvCpXIzNHDrsLOGBaXpgfskDmRf1tWntuMPppuGDEBMOhu7bOC2oP17nqqLfaTvIaUfm1ru/vU+X48zAM05h82brDur7nWvKDh6W7hr65YJU9PlwqHS2EUSrWcHpWe8lTkmbyKoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=alWpchMIt9CyJQs4P7p3uLvh9tz59XbBFZ+RrJAhc3E=;
 b=G8mR37vzPVmU1StKrQ8I4TBJlABAVYl3QrTLcZ4Ujb4QNVdwhTDmrAwvnpzkgXT0b6KpLGQyByN/ch7YKKfGk6wqLiW5C21omSC97dVbU+D89Sunox0f5/Nc8GHaf58R4Q+IMCSuveIRlQMO8JVoodWmYfGo/pUIpxl3hj++fU1itzkbF4UuWrNMYgK6yPBfpcnFQ1rSiNyH1FoQP+DdA1XGEQduGr72IagGtGayBoKNyIAZ2Z9hdlBj92NfPcW12R4HNtpzdKhoCud5f40Kw9J1/EIxCo+4FGtZpeE1mvegr6eEK54vQyvQVDhlaXIrOOl03EeScTNJNyHm0Sq+kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=alWpchMIt9CyJQs4P7p3uLvh9tz59XbBFZ+RrJAhc3E=;
 b=PAEAVVnbeyu7LMTRpWbBfnU3hCPl+53TkNRtWyJJoGnIxLbmprH0SACrrU4Cv1rVxJpI7DyEkyTWXwkntVvXhDVynU/kxv12ObwmlCBIqIMxmuE1W2A5fJICflQF7LBjAsk1DmmFQ/dojkxF6uDxDkBNHZpD9emyC2VJDrErym0=
Received: from BL0PR11MB2980.namprd11.prod.outlook.com (20.177.206.153) by
 BL0PR11MB3283.namprd11.prod.outlook.com (10.167.235.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.12; Thu, 2 Jan 2020 16:41:41 +0000
Received: from BL0PR11MB2980.namprd11.prod.outlook.com
 ([fe80::3da1:76a6:1e2e:ec89]) by BL0PR11MB2980.namprd11.prod.outlook.com
 ([fe80::3da1:76a6:1e2e:ec89%5]) with mapi id 15.20.2602.010; Thu, 2 Jan 2020
 16:41:41 +0000
From:   <Viswas.G@microchip.com>
To:     <jinpu.wang@cloud.ionos.com>, <Deepak.Ukey@microchip.com>
CC:     <linux-scsi@vger.kernel.org>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <jinpu.wang@profitbricks.com>, <martin.petersen@oracle.com>,
        <dpf@google.com>, <yuuzheng@google.com>, <auradkar@google.com>,
        <vishakhavc@google.com>, <bjashnani@google.com>,
        <radha@google.com>, <akshatzen@google.com>
Subject: RE: [PATCH 12/12] pm80xx : IOCTL functionality for TWI device.
Thread-Topic: [PATCH 12/12] pm80xx : IOCTL functionality for TWI device.
Thread-Index: AQHVuhRtPKqzHms28EqIFCYGtTy/UqfXWf6AgABIifA=
Date:   Thu, 2 Jan 2020 16:41:41 +0000
Message-ID: <BL0PR11MB2980D6586EF46691A76D00DB9D200@BL0PR11MB2980.namprd11.prod.outlook.com>
References: <20191224044143.8178-1-deepak.ukey@microchip.com>
 <20191224044143.8178-13-deepak.ukey@microchip.com>
 <CAMGffE=7egBpma-=KHySYW0QTsqqHhy4yZnZMSnw19ayxYgYMQ@mail.gmail.com>
In-Reply-To: <CAMGffE=7egBpma-=KHySYW0QTsqqHhy4yZnZMSnw19ayxYgYMQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [103.6.156.112]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 901b08f7-fe3b-4ab2-12d1-08d78fa2a559
x-ms-traffictypediagnostic: BL0PR11MB3283:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR11MB3283307AA70917641860071B9D200@BL0PR11MB3283.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:612;
x-forefront-prvs: 0270ED2845
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(376002)(346002)(39860400002)(366004)(396003)(199004)(189003)(13464003)(55016002)(4326008)(6636002)(9686003)(4744005)(33656002)(7416002)(2906002)(71200400001)(8936002)(53546011)(316002)(5660300002)(81156014)(66476007)(66556008)(64756008)(66446008)(52536014)(186003)(7696005)(86362001)(478600001)(8676002)(76116006)(66946007)(54906003)(6506007)(26005)(55236004)(110136005)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR11MB3283;H:BL0PR11MB2980.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HLfD+uXhhUct2FFgh+AoKK7SS23RQh5Im/YuYD2yHjmdJjRb1SGwaZ55qiW2RLXtr8OsVeMLe0gq5eQqhUJet4enFFZO538UIvbGQqyT6WBUP1T9v88CAoCKbQyaf4wr7xnmO412ifdk4gJFvGxaWpaIwDu4p2h8NIKS0egtDBfFxwaMp5z9Uhz3CVB91SepPzkgDZtKsL4LUm3+9f/PKi2nSeIdxz58XvJcYwaZ95CxugyOYwFdK3B1lpg3AdffpqL9HgtiwIBywrWVRIYTWRgJXPssOSrdnv1q/RXAHWve1xHwOk6VAeTobOJJvMaRGWGZwiIYFJ4UXlCMjgDbKfXLnvFfh386vxtPcQKuuSh2KjcJf1HwaaLglOnt3tFudjfy8bix3L58TQ5dtHnhMBIBqBlvkJlzQC98XhqVbfE139TEuyjn9V1wCJwZ3EvxKOvd/XF2YfxQYZu2AnaM2RQ1UHU7MZks8Zlob6r4hUxZA3kKDGc4MbmvxaG7OS5O
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 901b08f7-fe3b-4ab2-12d1-08d78fa2a559
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jan 2020 16:41:41.5497
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h/MY/Jx0DSsQTGqTHHau9gWcXW6ilUbZE3pS/Rou2UuOkm98ReY9USuywhy/HQaO0veqyhvKyT/6pG9P2sT4UA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3283
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

VGhhbmtzIEppbnB1IFdhbmcgLiBXZSB3aWxsIGFkZHJlc3MgdGhpcyBpbiB0aGUgdjIgcGF0Y2gg
c2V0Lg0KDQpSZWdhcmRzLA0KVmlzd2FzIEcNCg0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0N
CkZyb206IEppbnB1IFdhbmcgPGppbnB1LndhbmdAY2xvdWQuaW9ub3MuY29tPiANClNlbnQ6IFRo
dXJzZGF5LCBKYW51YXJ5IDIsIDIwMjAgNTo1MSBQTQ0KVG86IERlZXBhayBVa2V5IC0gSTMxMTcy
IDxEZWVwYWsuVWtleUBtaWNyb2NoaXAuY29tPg0KQ2M6IExpbnV4IFNDU0kgTWFpbGluZ2xpc3Qg
PGxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnPjsgVmFzYW50aGFsYWtzaG1pIFRoYXJtYXJhamFu
IC0gSTMwNjY0IDxWYXNhbnRoYWxha3NobWkuVGhhcm1hcmFqYW5AbWljcm9jaGlwLmNvbT47IFZp
c3dhcyBHIC0gSTMwNjY3IDxWaXN3YXMuR0BtaWNyb2NoaXAuY29tPjsgSmFjayBXYW5nIDxqaW5w
dS53YW5nQHByb2ZpdGJyaWNrcy5jb20+OyBNYXJ0aW4gSy4gUGV0ZXJzZW4gPG1hcnRpbi5wZXRl
cnNlbkBvcmFjbGUuY29tPjsgZHBmQGdvb2dsZS5jb207IHl1dXpoZW5nQGdvb2dsZS5jb207IFZp
a3JhbSBBdXJhZGthciA8YXVyYWRrYXJAZ29vZ2xlLmNvbT47IHZpc2hha2hhdmNAZ29vZ2xlLmNv
bTsgYmphc2huYW5pQGdvb2dsZS5jb207IFJhZGhhIFJhbWFjaGFuZHJhbiA8cmFkaGFAZ29vZ2xl
LmNvbT47IGFrc2hhdHplbkBnb29nbGUuY29tDQpTdWJqZWN0OiBSZTogW1BBVENIIDEyLzEyXSBw
bTgweHggOiBJT0NUTCBmdW5jdGlvbmFsaXR5IGZvciBUV0kgZGV2aWNlLg0KDQpFWFRFUk5BTCBF
TUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlvdSBr
bm93IHRoZSBjb250ZW50IGlzIHNhZmUNCg0KT24gVHVlLCBEZWMgMjQsIDIwMTkgYXQgNTo0MSBB
TSBEZWVwYWsgVWtleSA8ZGVlcGFrLnVrZXlAbWljcm9jaGlwLmNvbT4gd3JvdGU6DQo+DQo+IEZy
b206IFZpc3dhcyBHIDxWaXN3YXMuR0BtaWNyb2NoaXAuY29tPg0KPg0KPiBBZGRlZCB0aGUgSU9D
VEwgZnVuY3Rpb25hbGl0eSBmb3IgVFdJIGRldmljZS4NCj4NClBsZWFzZSBleHRlbmQgdGhlIGNv
bW1pdCBtZXNzYWdlLCB3aGF0J3MgdGhlIG5ldyBmdW5jdGlvbmFsaXR5LCB3aGF0J3MgdGhlIHVz
ZSBjYXNlLg0KDQpUaGFua3MNCg==
