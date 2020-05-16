Return-Path: <SRS0=EJvX=66=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C70FC433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 16 May 2020 16:10:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5992B207CB
	for <linux-scsi@archiver.kernel.org>; Sat, 16 May 2020 16:10:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="NisQnGhF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbgEPQKt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 May 2020 12:10:49 -0400
Received: from mail-eopbgr690058.outbound.protection.outlook.com ([40.107.69.58]:6981
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726212AbgEPQKt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 16 May 2020 12:10:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TpaFjVkbCNWUPTBoqiBi2rpieacgr0pDOTvi9EHPtlchOzPZht4YFbWmi0eU3Xg9CpflP6bV+XCEURnJt4JChu9b7fJ13ISyVVcjXC6QZFrygJsObBRvDQjYUC+xFEsevS7WMYL9dIDdsGb2ohIFJrBKVzi3gI7VgjRuDZfr1APj0RfhmRRtz/yaJMFpYL2hso7XkPmBRn1prqvVn1DxkutFjfznuFogkNe5JRGhg3MhBO4tLRsBvxXNC5HDMA3jm6P9ia5zZrr4EemRpD2+ivR1B76xR3xL6rRloqVzjSU7Obo2ntewCCDVkMM/9DQGKgcoRwJcoD6bqTUVJRU2KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ilKdzipZMsi5lfmH5jehFqdxh/9/riaQ2sALAGPjSqs=;
 b=mp6JngSN1uOmaw/N3WtoyrBtUZ77N+2moU8pPrb8SP1n9P2KnZuKRIShLyA8SGFiakkca7mTe1MS/1gV8PgyFBpkKAoRuwqbKhD9xs71Y0rKwj/VZ0AJNrP3RJxdQk305pFZRPXdaYBYpOLdvjtXtoYo5ELdWbUACAyIVb7mgvTx7OG8dkw5UGdm1KvD01m2LpskNnaEGnMWqtYPkPbIhsxjqhDEy6tsNYR+OBPxkSSaMxkNV5g91skpfenE7CSqkN7rL52wbx0obRLVOIXJk5JrjmZQAe/oeBHr2yZ/SqO9sZ7ApaQ4uQbf+Q8AUa0SyKaMpHZ8KUqpdbUiJ763Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ilKdzipZMsi5lfmH5jehFqdxh/9/riaQ2sALAGPjSqs=;
 b=NisQnGhFd99y94jIkRBWdJGLraJ5TDubKdAtTT/dFKaR3jvvIYq5CGkpdU2nfVenVtv0Jm482swC0Vw6BOKtEemUZfwP3xSUbDTyKdBW01xRjgSr7Wt545faMN5oDriV2cQhisy18K6vs2Dye0d75xda26jFDAxWMwF8q6OOiAo=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (2603:10b6:408:35::23)
 by BN7PR08MB4867.namprd08.prod.outlook.com (2603:10b6:408:27::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.26; Sat, 16 May
 2020 16:10:46 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::9ca2:4625:2b46:e45c]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::9ca2:4625:2b46:e45c%4]) with mapi id 15.20.2979.033; Sat, 16 May 2020
 16:10:46 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Asutosh Das (asd)" <asutoshd@codeaurora.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: RE: [EXT] Re: [PATCH RFC] ufs: Make ufshcd_wait_for_register() sleep
 instead of busy-waiting
Thread-Topic: [EXT] Re: [PATCH RFC] ufs: Make ufshcd_wait_for_register() sleep
 instead of busy-waiting
Thread-Index: AQHWJVWjClMqL4p0T0io9BqnliNXaqipk2aAgAFaw3A=
Date:   Sat, 16 May 2020 16:10:46 +0000
Message-ID: <BN7PR08MB5684DAE992082615202BA428DBBA0@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <20200507222750.19113-1-bvanassche@acm.org>
 <198a1467-09db-f846-e153-a9681ff15b71@codeaurora.org>
 <16bb7e00-abbd-060c-c775-ae49a024d7de@acm.org>
In-Reply-To: <16bb7e00-abbd-060c-c775-ae49a024d7de@acm.org>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLWNiMjRjOWUwLTk3OGYtMTFlYS04Yjk2LWRjNzE5NjFmOWRkM1xhbWUtdGVzdFxjYjI0YzllMi05NzhmLTExZWEtOGI5Ni1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjIxMCIgdD0iMTMyMzQxMTkwNDQyNzA1MTQwIiBoPSJLT051VEtiaHdGUUxPZEtYYWNWQzRYajZGWWc9IiBpZD0iIiBibD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFIQUFBQUQwWUgyTm5DdldBYWpsekdwSVowUkRxT1hNYWtoblJFTUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUJBQUFCQUFBQTlvN0IxZ0FBQUFBQUFBQUFBQUFBQUE9PSIvPjwvbWV0YT4=
x-dg-rorf: true
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=micron.com;
x-originating-ip: [165.225.81.101]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b7ad578b-e942-4f17-b6fb-08d7f9b3b17b
x-ms-traffictypediagnostic: BN7PR08MB4867:
x-microsoft-antispam-prvs: <BN7PR08MB4867E0DC3F2C314B5758665FDBBA0@BN7PR08MB4867.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-forefront-prvs: 040513D301
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jr57Oiw18r1vN7oxOUjfi0oUYjd/H1ICCc57yC7WrMPFqRHcI2sKLliE8u1LPrONy5DThxZSaH2hp3V6egvoEn1lpLdju4hNmKTnMNj/pyJI27XFFZFuLBz1Ye7EvpiCmYDzi1wmohuYh33Tetc1b/Fm1sTZIqhCrMhdq2YZ6zJB5K1MA4VsjzBthWmPuhvpz8xgNDavOvl9ULWQukZeYWWTePzlK9TA80g4ysXJm/7n31PLjVeXl3LZ0cmvIE1PIx79Rv9DkiW20dOUdAL2KKSwcdpMbZKXN1DLT2YXXTwqcbsgivGqFWOrR9nTkcZK16AeVco8lsIrCbSSdH0FjEcDmfZ83rF+EU6phGFhYrq7+d4gAwyUeMx6TB7hsfhOmXVxtJYzkMBKxq5780rgvV5MSCa7NKOEGWY+TXo4lJbrKYfYwMQqVbOCE1CUyXZc
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR08MB5684.namprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(136003)(346002)(376002)(39860400002)(396003)(55236004)(6506007)(26005)(5660300002)(110136005)(54906003)(7696005)(186003)(316002)(4326008)(76116006)(9686003)(478600001)(33656002)(55016002)(66946007)(8676002)(2906002)(86362001)(66446008)(64756008)(4270600006)(66556008)(66476007)(8936002)(71200400001)(52536014)(558084003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: jAm2KcUkY0UM3DSHP49vCRKoj+STc2z+PFUpHxYxG1uwR6CBYYsUtapLbnJuPlVQ0A6QBe2DfPvzNvFjfISPGlJFJ45GKTVjzdvFPDEOHHlbtCT16wE7pTpGbNY2QzUkMuVxaU3UOgWIQuYMr27SfU21GCkMc74AGX3sEwU6plyFqxnniiMk8jEYnQWi6Ec5f6SDtvLxDFGzE39jot+waJdGf/XeueUnzE9VR5IOZPesebB+eMEr1c3XHpedZSaQ6jHQCSXs8S5CZcMwSeEljyNQdV+EnMA82sGFZrPGf2FcvNnbzV8Pe2sGHvXrSm2/q3RUVD2Pm087hT48eIJ+RWK7FCqVjn/V9b4LgO0+WnnfOxZDpXHfhnt7QOq9/105tUZnq0O3S5vbadqrGQDtnsoh//lmO6Ys0y8cGB+1SxrgBtDzAq6c9mfTC0WwnoF7mAo1av3UjFmZzj68oGBl2HBFyUFbVwVZz9OLJp/uZMyzBcHorKtClCcQzf0kHwh+
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7ad578b-e942-4f17-b6fb-08d7f9b3b17b
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2020 16:10:46.7002
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o6CC4tyTGDatu0FmvK2JzS6SHM+H9BTI/Zn73wgtr91sOa0vrn9008znnx3MGk5cBou9agmZugnxxXeYkCknCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB4867
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

UmV2aWV3ZWQtYnk6IEJlYW4gSHVvIDxiZWFuaHVvQG1pY3Jvbi5jb20+DQpUZXN0ZWQtYnk6IEJl
YW4gSHVvIDxiZWFuaHVvQG1pY3Jvbi5jb20+DQoNCg==
