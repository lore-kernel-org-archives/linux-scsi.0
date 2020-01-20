Return-Path: <SRS0=2tGB=3J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDA63C2D0DB
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 13:12:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4F1D22522
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jan 2020 13:12:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="fOeScMRd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbgATNMc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jan 2020 08:12:32 -0500
Received: from mail-dm6nam12on2079.outbound.protection.outlook.com ([40.107.243.79]:6086
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726589AbgATNMc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Jan 2020 08:12:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iVwkC3SOXr3LbWw2d8fcXzPonhJ2cZVmF9ds3LC9QGl9yeujHax9GlnN9suMZpc8FSyWN83fYMm6F5bmRCA4cLBULJCasisu7gI+xs7VDFb8bkiT5OHLu4JdPRMzV9aCU34+LIXaAJmt1cak4gLgqf57t9GyUjrtAegQ+EOc2GmupRviyCnl/c28oP9RCI5W0+d6fqYmKPl2qmX6MjKldlJKkHM4daNqaDmuifz5WY3bH6ZRRJjWs+c3tTcOY+9FctbxbcBnFTZlgaWhswA41HntL+MCb1j80KrLl26rv2emRpyqPDiGzWyv4b3gglrYovFQomj6OVHLAwq4P8UUVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LWXtRO0oxX0CosugYUHVLQvvqGYOC/0ceyj03DSd7h8=;
 b=TezXfhhLZY55uJYpTJImv5XKv0sVoObpZBtCpCu0RxdrS+0ki2TMvJIYmwPUdWBEVcJuxasd0FKvREkRH/GZxbcnnlp8mP6viu5/SHOIV5Gm1yQOmaWvIqVEouhLkC/2H579J5a7rdFq9u6pKFO/x5TjonEGdmnxosHYqzvdp5o0gP0qfsmBtXORKqpPVxNRyW44wRpx8MLqphWtW+iq8wZLW81dvy05NkuQRON6EA8pTy9Tj0l8fseQ/ENPWPrlMYJeB+JvESqKAU7fp3IPeky5DKxuWB8qdJJrfotqAm7vIKcGAQwHalJpLqMdUSjwAHmH0+YL8iFYVfuKsWBZ0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LWXtRO0oxX0CosugYUHVLQvvqGYOC/0ceyj03DSd7h8=;
 b=fOeScMRdsJY03wbEg3NRFvUCZnirOQVkTkgkHGjlgK6zsAbMr+yop027SOKOxkt3dzYVDakRGUxDh4uIsoDjoiot2ic2KpUv9COSaTriURB6grIV0wYeXYiiogRnMSqUhLuZtlCHI/VNK+8hC0yNiEGDvCjv1cMZOYnyTjuc0rQ=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB5060.namprd08.prod.outlook.com (20.176.27.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.23; Mon, 20 Jan 2020 13:12:29 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11%7]) with mapi id 15.20.2644.024; Mon, 20 Jan 2020
 13:12:29 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Alim Akhtar <alim.akhtar@gmail.com>
CC:     Bean Huo <huobean@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
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
Thread-Index: AQHVzoKXx2RhVm9OD0+j9uX/WAzyH6fyg3mAgABiEICAAKOPIA==
Date:   Mon, 20 Jan 2020 13:12:29 +0000
Message-ID: <BN7PR08MB5684126151178FB8BBB39A11DB320@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <20200119001327.29155-1-huobean@gmail.com>
 <CAGOxZ52xHFedU+1DUgL02xjXzG2CtXUk3MRaq=uSUZKX=7AeDw@mail.gmail.com>
 <BN7PR08MB568498ED5D86FAA8098EE1C9DB330@BN7PR08MB5684.namprd08.prod.outlook.com>
 <CAGOxZ52qVH4M=dSa3ynhzToki-TPN5D5YevvvuuKyJtepp2zMg@mail.gmail.com>
In-Reply-To: <CAGOxZ52qVH4M=dSa3ynhzToki-TPN5D5YevvvuuKyJtepp2zMg@mail.gmail.com>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTdlNDkzNmQ4LTNiODYtMTFlYS04Yjg5LWRjNzE5NjFmOWRkM1xhbWUtdGVzdFw3ZTQ5MzZkYS0zYjg2LTExZWEtOGI4OS1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjM2NiIgdD0iMTMyMjM5OTk1NDI4OTA3NzczIiBoPSJ2Nytic0p2TDdDa2EvamE2YTM1dHVpL1oyZ0k9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [195.89.176.137]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 952d23fa-98b3-4531-e3b8-08d79daa6748
x-ms-traffictypediagnostic: BN7PR08MB5060:|BN7PR08MB5060:|BN7PR08MB5060:
x-microsoft-antispam-prvs: <BN7PR08MB5060E4E88AB1D5FCB1D50B0BDB320@BN7PR08MB5060.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:820;
x-forefront-prvs: 0288CD37D9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(39860400002)(376002)(136003)(396003)(189003)(199004)(6916009)(4326008)(5660300002)(54906003)(81166006)(81156014)(7416002)(558084003)(2906002)(478600001)(8676002)(6506007)(86362001)(316002)(7696005)(33656002)(9686003)(66946007)(66556008)(66446008)(64756008)(186003)(66476007)(26005)(55016002)(76116006)(8936002)(71200400001)(52536014);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB5060;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e/pFjsExfK2KFWA0zLd688F1xtDxo7VU53pm/fVQjWp1IFldwNEaprL6yUlUT9CsZIZzadRaHmjIMMoa0QjaNgxvw5jiWvdYCtUb44Qs4DmyXpz4i/toSAGka5FBvePsxF6CpWu7bk4bSlxzGGTkXCHUQKfroIuC9SJIgrIWHBii0tzXxW2oeCZgw0Gxh3A8I5RVwWOePDKfLx66+XhVCumswlpbzo2EScjU1aWl5ui1ytsbxr/jHzFfSrEh4bZRWX+cruziCqyHIROnNJJyWAqbsOVg6Qqj2ANrKzp4N++r/GQ9jrAOZl51yAPt3nmV7EnlN8f0KSwUuReRDgg987ed3S5+XP6TJkgJhKXlCZFuX0Iy7p/p4cPPLQFqn6FnHQKPnqEyuDuesYnbTZkASRX0+NDbSKQbKA8yuNlej/M7LvuBSLFquNFyKWkI0pFb
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 952d23fa-98b3-4531-e3b8-08d79daa6748
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2020 13:12:29.7606
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u20PIgQI9c3QCS/EWwYbOQbXwVQ4TF867h+MZ39rZWk9TPbPQLNrc0mtToOTTfMw2+3eFijPNSIOuASTcOhjlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB5060
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SGksIEFsaW0NCg0KPiBJIGFtIG9uIGdjYzogYWFyY2g2NC1saW51eC1nbnUtZ2NjIChVYnVudHUv
TGluYXJvIDcuNC4wLTF1YnVudHUxfjE4LjA0LjEpDQo+IDcuNC4wDQo+IA0KPiBBbSBJIG1pc3Nl
ZCBhbnkgcGF0Y2hlcyB3aGljaCBpcyBuZWVkZWQ/DQoNCllvdSBkaWRuJ3QgbWlzcyBhbnkgcGF0
Y2gsIEl0IGlzIG15IGZhdWx0LCBJIGhhdmUgZml4ZWQgaXQgaW4gbXkgbmV3IHZlcnNpb24uIFlv
dSBjYW4gY2hlY2sgbm93Lg0KVGhhbmtzLA0KDQovL0JlYW4NCg==
