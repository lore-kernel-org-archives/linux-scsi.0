Return-Path: <SRS0=pZIS=2X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53F03C2D0DC
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jan 2020 16:42:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D433206E6
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jan 2020 16:42:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="Y0lmYaKC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728827AbgABQmO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jan 2020 11:42:14 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:59629 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728280AbgABQmO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jan 2020 11:42:14 -0500
Received-SPF: Pass (esa4.microchip.iphmx.com: domain of
  Viswas.G@microchip.com designates 198.175.253.82 as permitted
  sender) identity=mailfrom; client-ip=198.175.253.82;
  receiver=esa4.microchip.iphmx.com;
  envelope-from="Viswas.G@microchip.com";
  x-sender="Viswas.G@microchip.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1 mx
  a:ushub1.microchip.com a:smtpout.microchip.com
  -exists:%{i}.spf.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa4.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa4.microchip.iphmx.com;
  envelope-from="Viswas.G@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa4.microchip.iphmx.com; spf=Pass smtp.mailfrom=Viswas.G@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: T+rSGaBp1wDNjvarAbez7YHU+RrelUa3u8raIWnuo/Gzka79/+EXvXACb8hXlBkK+fnvXKdajy
 FqQH+D60eel4CDumwwqDDBMmBuLKGMRaahgTYT+SLp5stJO3dMrhchjqS/MAlMw0Vc6+uRsX/J
 2QivrqruxAIt9SaKzMx5OkTmnpf1wWUb9QrhwxIrjw44xwqshKweQ9JCQb1Yb8CzYOuQNkfCHi
 0l3P3uT4IPzWcuKvXJoD8Mi8lmmoxuaY/DjAnM++tAceDnF/BWjNcYUW2n4BFhkB3R46AXtlFF
 wWc=
X-IronPort-AV: E=Sophos;i="5.69,387,1571727600"; 
   d="scan'208";a="59998328"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Jan 2020 09:42:10 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 2 Jan 2020 09:42:10 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 2 Jan 2020 09:42:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=avCfCBQBqbteQ4oWNbnaskfsgaoDHmgA0kjDcFTmoqoUj6qLWEkOumyOUk1nA2/TkgxqAA9/46aXxMPuqA1M9xLIL2NBInJ5h5VbLRNMnqks2CPB8xFCO5Et7TgwvPoWzxSGEeLPVmptNgHZI6a6e2gfe/EzGK99tcbdU4WzORUgI6/8i1VffGtiG6WGtYj40j4ekgtS3b9oHdM0IHvullIVT+FdwxKD3MDRas6FEh7eBS8evLd0SQVq2cWjA2IW4k7VLMavM7nzizHa8/La9h5uxTjK3TUKLZ5aw1VIaE2LHX44Dn9q36aDoaET7oQaSTrtjydIgwR1BXsQcKCS4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aWhulQSp5HjhY/96LvYH9XDZ9KdqWnGjgAp/y9veM/4=;
 b=Z/82zXC2ioSCW1CnV4py0C7th8cxvn7mNZ3sqVnphja31Jg8GDhYNen6E6jMhssqGnZXttrxa3xoveW2KRike/igPqErBNykt/UT13xKLnNaeuYzKUtz/PP4RV90p2BqDTdF2+6MTGxUsJQr/d7/8TjHEvfPzLyaaYcbAhpBST0GefbKsoV0GXhqg5e2LDyP04unUvKbl78Ovc2ah+ICNwbAoh6HzxZor500CK10crWlr/srRSs6eESPeHTBCMPivsUKl61WqwFiRwUkpmudqbFT9Ncyn8MKOi3W+hP9KGE3DS2N4OhNUORbp2+2Q9xYNE9cd2urhrMPZx/80rkccw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aWhulQSp5HjhY/96LvYH9XDZ9KdqWnGjgAp/y9veM/4=;
 b=Y0lmYaKCBBcx3zxaBFcV7vs4DBolG03Ioy52BV8zdTd0TbZ+eF46LTMKcgzgGlyByG9erJLpJU0ZBbq63tuSdI6Vx0KLfR7ROhv9HEfEi2/3tYJYiI5KINKobK5rJRzL9diPYCauBP0shkGEvhuVwjMlqnERxsW9bysGTSf5UNg=
Received: from BL0PR11MB2980.namprd11.prod.outlook.com (20.177.206.153) by
 BL0PR11MB3348.namprd11.prod.outlook.com (10.167.235.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.10; Thu, 2 Jan 2020 16:42:03 +0000
Received: from BL0PR11MB2980.namprd11.prod.outlook.com
 ([fe80::3da1:76a6:1e2e:ec89]) by BL0PR11MB2980.namprd11.prod.outlook.com
 ([fe80::3da1:76a6:1e2e:ec89%5]) with mapi id 15.20.2602.010; Thu, 2 Jan 2020
 16:42:03 +0000
From:   <Viswas.G@microchip.com>
To:     <jinpu.wang@cloud.ionos.com>, <Deepak.Ukey@microchip.com>
CC:     <linux-scsi@vger.kernel.org>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <jinpu.wang@profitbricks.com>, <martin.petersen@oracle.com>,
        <dpf@google.com>, <yuuzheng@google.com>, <auradkar@google.com>,
        <vishakhavc@google.com>, <bjashnani@google.com>,
        <radha@google.com>, <akshatzen@google.com>
Subject: RE: [PATCH 07/12] pm80xx : IOCTL functionality to get phy profile.
Thread-Topic: [PATCH 07/12] pm80xx : IOCTL functionality to get phy profile.
Thread-Index: AQHVuhRuc9TLVhjegU654Iikjo6XOqfXVzQAgABLt0A=
Date:   Thu, 2 Jan 2020 16:42:03 +0000
Message-ID: <BL0PR11MB298053646F73149793BA78649D200@BL0PR11MB2980.namprd11.prod.outlook.com>
References: <20191224044143.8178-1-deepak.ukey@microchip.com>
 <20191224044143.8178-8-deepak.ukey@microchip.com>
 <CAMGffEng1=4KJbNheW4gX562FU+1qfh-HU_Qfm0R_Jw6OWrORA@mail.gmail.com>
In-Reply-To: <CAMGffEng1=4KJbNheW4gX562FU+1qfh-HU_Qfm0R_Jw6OWrORA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [103.6.156.112]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d6e2129d-5dd1-4de5-d341-08d78fa2b26d
x-ms-traffictypediagnostic: BL0PR11MB3348:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR11MB3348AE74D7E06A04311CCAF79D200@BL0PR11MB3348.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0270ED2845
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(396003)(346002)(39860400002)(366004)(136003)(13464003)(189003)(199004)(5660300002)(52536014)(6636002)(26005)(66446008)(110136005)(76116006)(186003)(66556008)(66946007)(54906003)(64756008)(4744005)(66476007)(8936002)(55016002)(33656002)(4326008)(53546011)(8676002)(7696005)(7416002)(71200400001)(81156014)(81166006)(86362001)(55236004)(2906002)(6506007)(9686003)(316002)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR11MB3348;H:BL0PR11MB2980.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Zl7pTUefzfSmEOwWQt6rqcFZDn8rZoKjGwELg9XIBuO/LOB159PKdw183CeuE8h1ywM0moDcFgIvkJcRCBYn/g/h8WValUNR3Aw4Z1sc2+rNw7cS8EQqvvitIbeJokUaxATsPtZUFeAj2ok+/HRHMq7qTLMAGmD1uSx4WPQhOvdiadNFKYqgRTJVVAznODtNGeBJAfXZx5ITVPXzjwYwG8wiX8MILefiB6gxf57+a5EpKq6NOF0/5TfhKtx3MinONrB7bCI9zMdNg72QUYg2NjAasrBR0K2JVgmxxtNkaFYrz5LVsI59qEwFilsJX3qM5grmV9zhiBD5euGSrgAIZR5K+y6oGgEf55lapvUEQZeX+Xe5M0DPuDafdFfhfigcqBmWRWl22KHQwdAY/odUxbn24uVXi41BIbLmQSjceKHMqTMzzUtQZm3dvPzevocjqCnhUF1dpIt6n6fq3GqbuuNKQTyKSIDYSTqy+VPajCtu4URD3qA4HBP5a5EWN0Cq
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d6e2129d-5dd1-4de5-d341-08d78fa2b26d
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jan 2020 16:42:03.6270
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dWV6B5gCLRYk8gzrHPrGXfbMW7nv+vLP0BxAIx6DUEeZH9vH1zcSFzeCMIi4LHNt3XtQNdD6fCsQAvcu0MVJ7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3348
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

VGhhbmtzIEppbnB1IFdhbmcgLiBXZSB3aWxsIGFkZHJlc3MgdGhpcyBpbiB0aGUgdjIgcGF0Y2gg
c2V0Lg0KDQpSZWdhcmRzLA0KVmlzd2FzIEcNCg0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0N
CkZyb206IEppbnB1IFdhbmcgPGppbnB1LndhbmdAY2xvdWQuaW9ub3MuY29tPiANClNlbnQ6IFRo
dXJzZGF5LCBKYW51YXJ5IDIsIDIwMjAgNTo0MSBQTQ0KVG86IERlZXBhayBVa2V5IC0gSTMxMTcy
IDxEZWVwYWsuVWtleUBtaWNyb2NoaXAuY29tPg0KQ2M6IExpbnV4IFNDU0kgTWFpbGluZ2xpc3Qg
PGxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnPjsgVmFzYW50aGFsYWtzaG1pIFRoYXJtYXJhamFu
IC0gSTMwNjY0IDxWYXNhbnRoYWxha3NobWkuVGhhcm1hcmFqYW5AbWljcm9jaGlwLmNvbT47IFZp
c3dhcyBHIC0gSTMwNjY3IDxWaXN3YXMuR0BtaWNyb2NoaXAuY29tPjsgSmFjayBXYW5nIDxqaW5w
dS53YW5nQHByb2ZpdGJyaWNrcy5jb20+OyBNYXJ0aW4gSy4gUGV0ZXJzZW4gPG1hcnRpbi5wZXRl
cnNlbkBvcmFjbGUuY29tPjsgZHBmQGdvb2dsZS5jb207IHl1dXpoZW5nQGdvb2dsZS5jb207IFZp
a3JhbSBBdXJhZGthciA8YXVyYWRrYXJAZ29vZ2xlLmNvbT47IHZpc2hha2hhdmNAZ29vZ2xlLmNv
bTsgYmphc2huYW5pQGdvb2dsZS5jb207IFJhZGhhIFJhbWFjaGFuZHJhbiA8cmFkaGFAZ29vZ2xl
LmNvbT47IGFrc2hhdHplbkBnb29nbGUuY29tDQpTdWJqZWN0OiBSZTogW1BBVENIIDA3LzEyXSBw
bTgweHggOiBJT0NUTCBmdW5jdGlvbmFsaXR5IHRvIGdldCBwaHkgcHJvZmlsZS4NCg0KRVhURVJO
QUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5
b3Uga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQoNCk9uIFR1ZSwgRGVjIDI0LCAyMDE5IGF0IDU6
NDEgQU0gRGVlcGFrIFVrZXkgPGRlZXBhay51a2V5QG1pY3JvY2hpcC5jb20+IHdyb3RlOg0KPg0K
PiBGcm9tOiBWaXN3YXMgRyA8Vmlzd2FzLkdAbWljcm9jaGlwLmNvbT4NCj4NCj4gQWRkZWQgdGhl
IGlvY3RsIGZ1bmN0aW9uYWxpdHkgdG8gY29sbGVjdCBwaHkgc3RhdHVzIGFuZCBwaHkgZXJyb3Iu
DQoNClBsZWFzZSBzcGxpdCBpdCB0byAyIHBhdGNoZXMsIG9uZSBmb3IgcGh5IHN0YXR1cyBhbmQg
b25lIGZvciBwaHkgZXJyb3INCg0KVGhhbmtzDQo=
