Return-Path: <SRS0=r6FR=ZK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5478C432C0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 09:37:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A1E02073A
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 09:37:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="S4zJ//FJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbfKRJhb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Nov 2019 04:37:31 -0500
Received: from mail-eopbgr740072.outbound.protection.outlook.com ([40.107.74.72]:53664
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726461AbfKRJha (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 18 Nov 2019 04:37:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PnOdRyOhtvxS/d6dyGp6YHmccTUxE+Pk1Dmy1c3lokq/Jyq+hYBKrgwm2PoUaJm8YM6PCIWSI4/dzq5Z8W+icVxVrjEyydca7bjzEC5LFjWYtnYEiwlRlwRSw7teEjv0IiADty5Y/FTzyByDHnmD3Mw4SWXWNVQBUy3B5gieIHfCE2IvLMd7FhBcrOeQgpvYssFcObf4xHbfa3YDy2OQ87Vy5pcxx7BqlF2QrjHfiWUIkYCDjBLECsY66zpi0yyuNFFbjtjkGGdNGJyAKtaaKN+Oqoukl1oI8MM+A1KJ13JnmlEHICEL2kXutUV18H8nHkYHXGqAwkycw6vXGopDOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ULOSXUSi+/EsERkJiV9n05O+86O8Cl5+5spjLv17qis=;
 b=A++Es6+9zEOeScDAvF2Am/mBgAGn6yYBfo9NJzeQX7ZMU9OIwoKBmZfn/egQHeweRxevTOww4eC6bzUh6OxKL0v4VVjTSHBU1flzKJKB2g7b+PW8/XiE0xMpz82q3aKSUQRaZeaBuACpmjL69LTfF/+KFgfxn6iMekxz1N3ywUCPeG+e92HMPmaQLzD6V2Y13XobvI/5PTrIvVfEDGvrQmhBLYH/5Oh6KLuYFzWAzWNzq+zXTwRdLpsElQkQNfqBJR3qbQ6GFsA5NzWtZ/Smus2pDZat7L+AM+0elg48tWr6hM1CQxCB/CIFHImfWFzaG0cOCKW78QKLbPXFwmBG6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ULOSXUSi+/EsERkJiV9n05O+86O8Cl5+5spjLv17qis=;
 b=S4zJ//FJUli+odNj88jSPBf9gCm4ugiEtlNybx6meg2HjYNmWcEONfULrkJOVATIhH/4F2zJQ+TCBPsJOVwwi8YV5tBudGHUqXmyZDjOiuxs/o0tOWSRu7Z/gGwfei7z6j+0Pm6BAxvSeJvz5aFICzauaopnsBjKk/VoiYh2UXg=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB4228.namprd08.prod.outlook.com (52.133.222.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.27; Mon, 18 Nov 2019 09:37:27 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285%6]) with mapi id 15.20.2451.029; Mon, 18 Nov 2019
 09:37:27 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Can Guo <cang@qti.qualcomm.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH v2 3/4] scsi: ufs: Avoid messing up the
 compl_time_stamp of lrbs
Thread-Topic: [EXT] [PATCH v2 3/4] scsi: ufs: Avoid messing up the
 compl_time_stamp of lrbs
Thread-Index: AQHVncN0qi6outuzf0O6t+NF9bzRkKeQq7+Q
Date:   Mon, 18 Nov 2019 09:37:27 +0000
Message-ID: <BN7PR08MB5684C8920F081E3463B8BE90DB4D0@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <1574049061-11417-1-git-send-email-cang@qti.qualcomm.com>
 <1574049061-11417-4-git-send-email-cang@qti.qualcomm.com>
In-Reply-To: <1574049061-11417-4-git-send-email-cang@qti.qualcomm.com>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTA2MzA0MmJiLTA5ZTctMTFlYS04Yjg1LWRjNzE5NjFmOWRkM1xhbWUtdGVzdFwwNjMwNDJiZC0wOWU3LTExZWEtOGI4NS1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjQyMyIgdD0iMTMyMTg1NDM0NDQ0NDUyOTkzIiBoPSJQeXU5YU5iV0k2Q2krdmo5VFphQk1nWW9LWm89IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.81.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e2525a6c-806a-4fb4-bd61-08d76c0aecc4
x-ms-traffictypediagnostic: BN7PR08MB4228:|BN7PR08MB4228:|BN7PR08MB4228:
x-microsoft-antispam-prvs: <BN7PR08MB4228BC8A1A3FF0E6A0BAFA3EDB4D0@BN7PR08MB4228.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0225B0D5BC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(376002)(346002)(396003)(39860400002)(189003)(199004)(74316002)(558084003)(55016002)(4326008)(256004)(99286004)(76116006)(9686003)(229853002)(6436002)(8936002)(25786009)(81156014)(7696005)(76176011)(6246003)(81166006)(8676002)(86362001)(5660300002)(6116002)(3846002)(476003)(186003)(55236004)(66066001)(2201001)(71190400001)(71200400001)(7416002)(102836004)(6506007)(316002)(14454004)(110136005)(446003)(11346002)(54906003)(66946007)(66446008)(64756008)(66556008)(66476007)(478600001)(52536014)(33656002)(7736002)(486006)(305945005)(2906002)(26005)(2501003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB4228;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sHV1mF+QPxkYaglTnhRSw3JFZ2ypUPwcaBviHFYOnTO6G/WYzqF57ovTiLFDTVsd7yZBiyoFI24a1joDiI/blp00skxxOhxUBO8tMnyoplWkj6l/cJFEVwdaA7DjXJQU/09G6/11ldBxcAE2r8HWNMiuca0Pz6ElA8WKEfCbN3Z2b/SJtyogRWAq06Q+7Uf79PdKKJuZqTXQSQo+qWFtuxZPvWq1XsHTyy/qn37qJFbrotrCBHu+yYptQwyDh8fZyiRIeG27IUURn0WkuYaHyW+9tBWmnED9Ozg5/TBs0j6AHm7fM8LavoDjVla2Hx4/Co7Ka+Zc8Pup2LuXAAjdDE10mlQI/+PLWA1DLMVIiv/udwDHaCLji4HZ/PfV0mIei0f4xSp98m8xzceUAZ+FRJasGur8yTqBfHq89l2bDqWSd9fmOGtzzbObRAXIzEJu
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2525a6c-806a-4fb4-bd61-08d76c0aecc4
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2019 09:37:27.2144
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f8Eo6UAedSQqyO0ax38LY66eOYXNjCDQuViPLtAes8fbT56eCxSlqDQgSBudu9G6QpOSdahenBB1mt0vCjGdCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB4228
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> From: Can Guo <cang@codeaurora.org>
>=20
> To be on the safe side, do not touch one lrb after clear its slot in the =
lrb_in_use
> bitmap to avoid messing up the next task which would possibly occupy this=
 lrb.
>=20
> Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Bean Huo <beanhuo@micron.com>
