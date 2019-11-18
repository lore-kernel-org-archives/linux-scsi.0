Return-Path: <SRS0=r6FR=ZK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF246C432C3
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 09:51:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96EC32071C
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 09:51:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="wyGuP1LE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbfKRJvv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Nov 2019 04:51:51 -0500
Received: from mail-eopbgr720049.outbound.protection.outlook.com ([40.107.72.49]:36928
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726562AbfKRJvv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 18 Nov 2019 04:51:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G9N9ZpE5jVrm3pJSvARTlFUcyZ3d9n4AnRY4DscWWT3AybEjjyf5swG3poQUdyE/BonQwHsk4O9RNfIvIrXCirL/Ftj1dAGYmSjY/Ih3n7XGKxceJNGx/E8yCxswV18X86Sm9k6HbfqWTh1p5jR3jviAh0HlW8Nbu3jHbMpgtvOmU6FfS1W3KJJn6iRQqS8Ua2Al7VrvvgFHnlm0gXMWDB9gDKA1qyuojMxDQCoqnYqUZbGUylbcVvvAy/IzRV8VcNxQh5fmk2CKw03r6OSSxOombF6EAdPxdbOLy0FOoD1wuGwS1WqeklYeIkArwCKpeBOQBRrNwEWFUj565/s+3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yyhV1P2tssMclxUu2Ui8GkhmjLwLzRZkjwcvpDTnLyA=;
 b=Y+tpkvIWpUvAPe2HFGk7uIe+p2x3pjyinr4c6g/zKGE6gp8bJURxE9pusqn/NPvz9WS7mwF2FDEGCFiYYrIDA0/QjEu67cSfetuYnRjrsexmbg5eB+QuRV+cUDPrw5bztOCRSatSTdLN5aKFm1rEZu9V9NAM9jzBG9ELgvkXoeV7VZy5sKrnOW47HVuU6wdCqlzSkLwrmbA/liklm8OWVXyIuNwEOVQy7DMdffNshYkgn0mg4oEqPJoHnIG8xRCjfCiOQAz/AUiwiqGVbS4ACAtO6fEt1MKJtCJTEof69GxRKeVT48WgTi82c5J+Qm4RmeO/ATS70EfkCxUgqXeQ4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yyhV1P2tssMclxUu2Ui8GkhmjLwLzRZkjwcvpDTnLyA=;
 b=wyGuP1LE1zZUySkd/VfgJl2WAJyKJhI5xgAJMBRcvVs6Ons7oQYlf352QVK7jc0gviwHgellrkpsawc3VhyFB67Nmt4RxAG7bfgCOItwxiG+pDZCjOJ4Z2GAiiuzy3R+ne2ydNM1iRcbZpz4gpZfA8E8iF2dXj2Izq/KUJtfcE4=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB3937.namprd08.prod.outlook.com (52.132.219.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.28; Mon, 18 Nov 2019 09:51:47 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285%6]) with mapi id 15.20.2451.029; Mon, 18 Nov 2019
 09:51:47 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Can Guo <cang@codeaurora.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH v2 4/4] scsi: ufs: Complete pending requests in host
 reset and restore path
Thread-Topic: [EXT] [PATCH v2 4/4] scsi: ufs: Complete pending requests in
 host reset and restore path
Thread-Index: AQHVncP572OrDbW7VUC/JPUH6UNuzKeQr6BA
Date:   Mon, 18 Nov 2019 09:51:47 +0000
Message-ID: <BN7PR08MB568412CDD5492F15BC573433DB4D0@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <1574049277-13477-1-git-send-email-cang@codeaurora.org>
 <0101016e7ca65c00-b8ca2b79-8dd5-40cc-ac78-35a9cfb8a08b-000000@us-west-2.amazonses.com>
In-Reply-To: <0101016e7ca65c00-b8ca2b79-8dd5-40cc-ac78-35a9cfb8a08b-000000@us-west-2.amazonses.com>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTA3MWMzMjNiLTA5ZTktMTFlYS04Yjg1LWRjNzE5NjFmOWRkM1xhbWUtdGVzdFwwNzFjMzIzZC0wOWU5LTExZWEtOGI4NS1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjM5OCIgdD0iMTMyMTg1NDQzMDQ5NzQ5NDM3IiBoPSJQRUZWVmk1UlRLREdIQWZyeXJHaUk0TGg4dlk9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.81.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f425e9a5-441a-4588-3ea0-08d76c0ced83
x-ms-traffictypediagnostic: BN7PR08MB3937:|BN7PR08MB3937:|BN7PR08MB3937:
x-microsoft-antispam-prvs: <BN7PR08MB39379D5B061287A26C345B98DB4D0@BN7PR08MB3937.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:873;
x-forefront-prvs: 0225B0D5BC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(346002)(376002)(136003)(396003)(199004)(189003)(6436002)(99286004)(26005)(5660300002)(33656002)(256004)(14444005)(478600001)(8676002)(486006)(316002)(558084003)(476003)(186003)(7696005)(446003)(102836004)(11346002)(54906003)(55236004)(6506007)(110136005)(76116006)(81156014)(81166006)(8936002)(229853002)(2201001)(66066001)(4326008)(76176011)(7416002)(55016002)(6246003)(6116002)(14454004)(3846002)(52536014)(71190400001)(71200400001)(66556008)(66476007)(66446008)(64756008)(66946007)(2906002)(2501003)(86362001)(74316002)(305945005)(25786009)(9686003)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB3937;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h+4zW7UASIpTRmrdj+yXQXyFRcb6tbZSvBdwlBtxr4VuhASBEaXUsbLODPTn6ZYthJJ7mLBsEL9RTKVmKkgh1ITnp09DK/PIGcVwWmKefMgr+yGhzGl79sQl0iZdh3dvqzDalYa2+Sv5aMoUsuO/ac3cJ3cuIEAWcMpQlMygaqTAH+hpwnhikB11F1t6sNYxto7izYulSnJETs/V0YqsTRkVqylsnPv5scy7By5t2MfnO3QlRfczTjL4D/mm4Dg0gBZ5ug/Ne7UlkSYcTY5UxMP7c/eez3xybQsArotti9Nq25UVmtV4dPGq9YoYfNXsdGe/SDJ9fFOuYGTexdZ6e1rrn+5XhQwTGvqy3fA64Ii7WB/jqWX0NIIK9JZeSul4qWwiuGA3Ttj4lxtakMB3QTTMGQUEhPZ/eWUz4n9oEM1E2K+zpZGPjkk/127sBJCU
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f425e9a5-441a-4588-3ea0-08d76c0ced83
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2019 09:51:47.4894
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0vJ/KXN9NCspe7hR8e3HUsKVFaPrEuSHfuQ+WZjh00gOhgjG/CKsX5+NF2Mbqt8x5AxXdgBot9dwr0whCk4ySA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB3937
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Therefore, before probe, complete these pending requests right after host
> controller is stopped and silence the UPIU dump from them.
>=20
> Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Tested-by: Bean Huo <beanhuo@micon.com>
