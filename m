Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFC5FCA9ECF
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 14:34:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 858DB21D71
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 14:34:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="dtaYbMLW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728647AbfKDOeT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 09:34:19 -0500
Received: from mail-eopbgr700059.outbound.protection.outlook.com ([40.107.70.59]:58715
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727861AbfKDOeT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Nov 2019 09:34:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eakboZBWoND4gp8+zriF0MHVYE6QpNTI/sFYK8mNeKG52i2R78vdy/1668nQAhfNrvGaL5I8xhmAjwJKZ2+Ycg6WKhj18RjKUR9Nwy5BMxFmwamCAbdEuv5/ChWzsZjzbouXWUGmGlvLgu1nG8ki3hOqFjop4B9v7ifr6Pn90do+tudt4Zi8MbgqAlutk/xb8oiAHeKhuVStaZ9WZ8aGJA5bdwrEJ3rvd5WAPkcAZlPV+bI5lP/hcllDmAJthsCgSZL0Fi1x9CToyHX73Q+K08w6cKkADklpG9gdShl98NN6P1NMeDT/84STk64SwOd6NRZXEWyzou8umJ1nfAgrYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g0Sbv4N1uRI+TKn+2b0B3gz3DxI5KU7ue81te4NWvAw=;
 b=IfVSdSA+G8FUwkLOMNhEKQPw1V9AOtwP2BcsR871phQnaZH/pkDOKA4qN0wsTT8un5x2M51vNg9Bd8yRLZzQTNWTC9om5JOMKkEqqOtCjthzy8khPJiF+VgsLv5QBdIn10Jqs0RoC9wh9M+vc8o/tk8HWiSzzd2FRca4Lth8Hn77JEy9F265yn3q5Dc5dfWYVbdfNde3BQnKeZ863BMUCTXwVBkWa+oWFeWwtreRvCbFcZo6dfdclab3ff1tZyz5+Q7O2kJsKCESUG+eUiiyt/T2WkluQRwX4ebIAin1EgJfSEZhj7VrnVrhyv1EcyxYyN8CqKGwU/qSk53KJtw4HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g0Sbv4N1uRI+TKn+2b0B3gz3DxI5KU7ue81te4NWvAw=;
 b=dtaYbMLW5q7Uq20155SND4UkfpR/+wrWXFD7qr3zrMS5iOnHcvh7ErBtONbt7es86dcw3mLM5UIrbpdwzyYuy2GVkw44HqTC0e4fa5/SIkvsmiwUZw/+GAaOPxpyxFOolYMqf6/C8FuUrOwoXEUziOVJTjxut10AX/SXDF/2m1g=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB3843.namprd08.prod.outlook.com (52.132.7.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Mon, 4 Nov 2019 14:34:15 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285%6]) with mapi id 15.20.2408.024; Mon, 4 Nov 2019
 14:34:15 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Avri Altman <Avri.Altman@wdc.com>, Can Guo <cang@codeaurora.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] RE: [PATCH v1 1/2] scsi: ufs: Introduce a vops for
 resetting host controller
Thread-Topic: [EXT] RE: [PATCH v1 1/2] scsi: ufs: Introduce a vops for
 resetting host controller
Thread-Index: AQHVkxwcSS9lAYSJrEeDPOcb+f4mvad7EmOA
Date:   Mon, 4 Nov 2019 14:34:15 +0000
Message-ID: <BN7PR08MB568495A62486DBDFDEDE9F20DB7F0@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <1571804009-29787-1-git-send-email-cang@codeaurora.org>
 <1571804009-29787-2-git-send-email-cang@codeaurora.org>
 <MN2PR04MB69911784473463D0926AE3B5FC7F0@MN2PR04MB6991.namprd04.prod.outlook.com>
In-Reply-To: <MN2PR04MB69911784473463D0926AE3B5FC7F0@MN2PR04MB6991.namprd04.prod.outlook.com>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTJiMTIyZmNlLWZmMTAtMTFlOS04Yjg1LWRjNzE5NjFmOWRkM1xhbWUtdGVzdFwyYjEyMmZkMC1mZjEwLTExZTktOGI4NS1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9Ijg0OSIgdD0iMTMyMTczNTE2NTI4OTMyNTMzIiBoPSJvNkV3WHFtdVZOY091SmpxVy9NenpUWHBXS289IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.81.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 55363a7a-5bbd-4d2e-c51c-08d76134117b
x-ms-traffictypediagnostic: BN7PR08MB3843:|BN7PR08MB3843:|BN7PR08MB3843:
x-microsoft-antispam-prvs: <BN7PR08MB3843FE94F5F8EC5DAFBDF353DB7F0@BN7PR08MB3843.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0211965D06
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(136003)(376002)(39860400002)(366004)(199004)(189003)(86362001)(66476007)(316002)(76176011)(4744005)(14454004)(7696005)(66556008)(64756008)(66446008)(8676002)(478600001)(76116006)(5660300002)(110136005)(2906002)(25786009)(99286004)(52536014)(4326008)(2501003)(55236004)(6506007)(8936002)(81156014)(81166006)(26005)(71200400001)(55016002)(71190400001)(54906003)(66946007)(102836004)(3846002)(11346002)(446003)(6116002)(9686003)(6246003)(256004)(2201001)(476003)(7416002)(229853002)(6436002)(33656002)(486006)(66066001)(186003)(305945005)(7736002)(74316002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB3843;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eb6qq/w3uD3XhXyzDah3BaqOGAqsn78S4Z6qjsF4UV24qYEgzZ0ap+eNnWD0bBd0UBOu0yH2fvuYph4yMk04ZddKFDW5riJDoX/vPApjWBPb4KzMQb7BoDoSxuQu2D3I/ejUUs18drm81FmEJd0UFjtGmrZZ5R/gb5YkgxXfTW1EfiKB2SBfQfVzAHduCzpdbIqBLPLZ6VCl5s3q7NUqn3OCsLofjsVLjoent4M7ohsS4AOQ45wHLjdOgbuMff8bwqzUMVKpsXKYWbdjvS/BLK3GOvVUqt5NBm11HEM5QTkc2M29nG6mAYG/W+SgblXBQ1jvvFlypscyuuWwiV7rN5q3AO5gj3kA9H+KuXc0zZWQ6FKUMzD6c57s/6wIdM6lbLZIAAjJF77O9TSTlclaBoS1lleT7fBPEiKXomsKOEQkq9G2zEg7MF0nLaj3lC3S
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55363a7a-5bbd-4d2e-c51c-08d76134117b
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2019 14:34:15.4263
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ehp3R3myvd9OOC1Qq+moUePgdMYECkzKzB+YRe27m62dCEs7qyBWvytyq6MtBmNYHP8FaZiMI9eJfr6fVGLVKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB3843
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi, Can

I agree with Avri, you can add this series patches to your bundle, and that=
 is also easy to review for us.
Otherwise, we are confused by somehow crossing different series patches.=20
Thanks,

//Bean
>=20
> Hi,
> >
> > Some UFS host controllers need their specific implementations of
> > resetting to get them into a good state. Provide a new vops to allow
> > the platform driver to implement this own reset operation.
> >
> > Signed-off-by: Can Guo <cang@codeaurora.org>
> Did you withdraw from this patches and insert them to one of your fix bun=
dle?
> I couldn't tell.
> As this is a vop, in what way its functionality can't be included in the =
device reset
> that was recently added?
>=20
> Thanks,
> Avri
