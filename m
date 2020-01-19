Return-Path: <SRS0=1Um0=3I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C06BC33CAF
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 22:00:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9908206B7
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 22:00:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="Dh9y9FlX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbgASV76 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Jan 2020 16:59:58 -0500
Received: from mail-dm6nam12on2045.outbound.protection.outlook.com ([40.107.243.45]:6184
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727556AbgASV75 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 19 Jan 2020 16:59:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i3tW48rlgUk2V9rcOMhba4gmmiw5Mj4fp2HK1Vppu+CEI+firDbKuiXD3IWr96/I1qQR0BJ8xtlj7j1ee3uN6IvisDbSeGYYqzsk3Q7NgUv2Ij7z2FEodU0to8GhYlceqcBHeSmpJytGWgEJAmn8Jac+OweOFTdj03A0hdvzjuTDlTsZq7TMOjaNcatZtAX9rUSuMimi8EfHhuWb0QXFvu9RWPVPR9nmkf5bvbroZDAW7eUFpZq5zAO29C4KC94sIE81DpUslgb+1Ql7wXkpG9fyOgwVnL2kx4SjknwNKbDtr0iAdgbPfhfUiAY8FnZuhoGEYwmNTl+7Rsnu7/pSOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=98q5R0TRIPZD3CGPWW5PlixD2HsMQX9jR9+5KQFJ/yY=;
 b=b9mQj089wH0BJPDR4Y8RC1q/QMFPV2MqPL4MqdnXMMnfosh3KQYEixCa9QrrWGKVdOvWt6d28g5VTho7IQJXKgwwdsgSkVG5Q91A8d9HkrYT55m3CRnvcqunZADYW52XOVvW04cYvGtFOIJfuA/AnaCo0VmKAR6LB4LM/VBxxKOQPI8M1diT4kBNmwKdiE6cnWoKYbAw3ne3H6w0rANctubmLJj5PN1iNZZhMPPOCL8yZpbCloTv9dVDk4IYYPxt846TOPoveQ4WSFANfoWIUANFieDJzZGDOCRRveSo3aZcF9uarQP9rI9gDB+hIYoBvG4Qvmd73XAq+aiJ7HaoRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=98q5R0TRIPZD3CGPWW5PlixD2HsMQX9jR9+5KQFJ/yY=;
 b=Dh9y9FlXNvj9OkWG/NHMtRPRfVF+KsrE3xGm5A4SX6NNn3fqVhyaYaVX5OqkQWaLTOEkcF1qzb3ZbjiVACaEd7S1Es5n809OStNG66eNH4LigmAbXFjv6PpCT92DmXpDv5X/EzdPpBK7IB9oe1yZswi2/h2H7WugtsohsWR5IDI=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB4148.namprd08.prod.outlook.com (52.132.218.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Sun, 19 Jan 2020 21:59:55 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11%7]) with mapi id 15.20.2644.024; Sun, 19 Jan 2020
 21:59:55 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Alim Akhtar <alim.akhtar@gmail.com>, Bean Huo <huobean@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Can Guo <cang@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH v3 0/8] Use UFS device indicated maximum LU
 number
Thread-Topic: [EXT] Re: [PATCH v3 0/8] Use UFS device indicated maximum LU
 number
Thread-Index: AQHVzoKXx2RhVm9OD0+j9uX/WAzyH6fyg3mA
Date:   Sun, 19 Jan 2020 21:59:55 +0000
Message-ID: <BN7PR08MB568498ED5D86FAA8098EE1C9DB330@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <20200119001327.29155-1-huobean@gmail.com>
 <CAGOxZ52xHFedU+1DUgL02xjXzG2CtXUk3MRaq=uSUZKX=7AeDw@mail.gmail.com>
In-Reply-To: <CAGOxZ52xHFedU+1DUgL02xjXzG2CtXUk3MRaq=uSUZKX=7AeDw@mail.gmail.com>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTA0YzJlNjM1LTNiMDctMTFlYS04Yjg5LWRjNzE5NjFmOWRkM1xhbWUtdGVzdFwwNGMyZTYzNi0zYjA3LTExZWEtOGI4OS1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjkwNSIgdD0iMTMyMjM5NDQ3OTI5NzE3Nzk5IiBoPSJUOStYVFo0OTJieTNtRTNTaU5TRS9VbW1mWmM9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.86.100]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2e4cb49a-7803-438e-16c0-08d79d2aeb13
x-ms-traffictypediagnostic: BN7PR08MB4148:|BN7PR08MB4148:|BN7PR08MB4148:
x-microsoft-antispam-prvs: <BN7PR08MB4148E278A375E02B3A94BF49DB330@BN7PR08MB4148.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:1417;
x-forefront-prvs: 0287BBA78D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(396003)(346002)(39860400002)(366004)(189003)(199004)(55236004)(6506007)(7696005)(9686003)(54906003)(33656002)(110136005)(26005)(52536014)(186003)(5660300002)(66446008)(64756008)(76116006)(2906002)(4744005)(7416002)(81166006)(81156014)(8936002)(8676002)(478600001)(66476007)(86362001)(55016002)(4326008)(71200400001)(66946007)(66556008)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB4148;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZEQN7XznhRx64+tiBUtFfeSpZEmz/3in6dLv5B5iYqCFJ0nTUb7G7DPmM43BPVs/DCg57tDOBAhIkoRHT6fqt3Uyg9ZZ2DsK1co/twZdqzZLvs4NiJUTq9Ive6Zjf6+VXD9lXBWzfeQdBcw8HimtwvRN++0lAvz5UtRAkGydvZgGSwfUy3fw556oComv1nTmJu4J8KpdD58/cDCIeCE2bvzuznCcNdQA7mLMqPpsis8VhH5CJFaaqv+UIWfPxy6bK0P+jVTvrQIvecg1sel+MHX3YfMRczCm6IxNNonXWe4vroZX8CI5yStDbSxdDrxXPDaqdJcu5A/meB7s4S2e33CS85J4MVm56d6+mPtEyjLFZlrVMG4fvHF/yY2vIMwFH8q5LBPkwcey7jTkw9Ct94V4zB80I0jJ8OcIBlsAl3wROTa+Su9sRCZjh9lcV14q
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e4cb49a-7803-438e-16c0-08d79d2aeb13
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2020 21:59:55.2329
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RvYGbuKfX7rkizNR29no83TgMEsIfki+Cc4tXQ4NUDH+eP1tH7u/UPxw0JhPe+HJgrFiZsQffKThY28Nd1jz6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB4148
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksIEFsaW0NCg0KPiANCj4gSGkgQmVhbg0KPiANCj4gWW91ciBwYXRjaGVzIGJhc2VkIG9uIHdo
aWNoIHRyZWU/IEF0IGxlYXN0IG9uIEphbWUncyBmb3ItbmV4dCwgaXQgZ2l2ZQ0KPiBjb21waWxh
dGlvbiBlcnJvcnMuDQo+IChnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5l
bC9naXQvamVqYi9zY3NpLmdpdCkNCj4gTG9va3MgbGlrZSBwYXRjaC0yIGludHJvZHVjZXMgYmVs
b3cgZXJyb3I6DQoNCk15IHBhdGNoZXMgYXJlIGJhc2VkIG9uIHRoZSBNYXJ0aW4ncyB0cmVlIDUu
Ni9zY3NpLXF1ZXVlLiBJIHRlc3RlZCBteSBwYXRjaGVzIG9uIEphbWVzJyB0cmVlLg0KRGlkbid0
IGZpbmQgdGhlIGNvbXBpbGF0aW9uIGVycm9yIGFzIHlvdSBtZW50aW9uZWQuICBZb3UgY2FuIGNo
ZWNrIHlvdXIgc291cmNlIGNvZGUgaWYgaXQgaXMgcHJldHR5IG5ldywNClRoZSBsYXN0IFVGUyBk
cml2ZXIgdXBkYXRlZCBjb21taXQgaWQgc2hvdWxkIGJlIDoNCg0KDQpjb21taXQgZWE5MmMzMmJk
MzM2ZWZiYTg5YzViMDljZjYwOWU2ZTI2ZTk2Mzc5Ng0KQXV0aG9yOiBTdGFubGV5IENodSA8c3Rh
bmxleS5jaHVAbWVkaWF0ZWsuY29tPg0KRGF0ZTogICBTYXQgSmFuIDExIDE1OjExOjQ3IDIwMjAg
KzA4MDANCg0KIHNjc2k6IHVmcy1tZWRpYXRlazogYWRkIGFwcGx5X2Rldl9xdWlya3MgdmFyaWFu
dCBvcGVyYXRpb24NCg0KIEFkZCB2ZW5kb3Itc3BlY2lmaWMgdmFyaWFudCBjYWxsYmFjayAiYXBw
bHlfZGV2X3F1aXJrcyIgdG8gTWVkaWFUZWsgVUZTIGRyaXZlci4NCg0KDQpUaGFua3MsDQoNCi8v
QmVhbg0K
