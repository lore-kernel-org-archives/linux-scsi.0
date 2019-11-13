Return-Path: <SRS0=WAUG=ZF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27B56C432C3
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 21:36:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 079C8206ED
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 21:36:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="f5VmTYBy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbfKMVfz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Nov 2019 16:35:55 -0500
Received: from mail-eopbgr690089.outbound.protection.outlook.com ([40.107.69.89]:11254
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726162AbfKMVfz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Nov 2019 16:35:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b9gAj9Q3XDoDzSBNEwSnjkpUbPw3u6kIcIkws/m5OJJRS5Wqu5dJI5F9ewdgaEZ5xuOaRGtu7sFdYC3Xoj0i42y+Y1sIIU/xb54abq0cwXOspUL2b2G+gx0n3HaznGcoytzjuT+fSW02gE94mYtgJUm2bZJhN+s4LHDbzBxdU5o4g2BKrSoOEliTjA/2RYR38t1HpATFnroyuc3mamuUB9w4H5sDUeRctq51nuZvd6rF7Ck0bd+VbTfK0QzrsPbzyRccejdKbfqzitYVoS7roNHlq++5BgtPvdf1QKPvfsQSfV1jO40MXTezWGmibKyQagjN8rZN3QROGM1T1OHo2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OTM1FccH4BJmJJgiKw6PubKfPhaeyfWDRX+GgnBSJbs=;
 b=i9AT/8XwxKsGqY5JZRKwznCFhU6Bn3f0icBD0JFkHnDa70L/JGq7s99lGn0/FHtpJxcTs64ij/o2K23ZdmX4Pc1Ewta/k8o25xo2WyFt2iCQhPm6ji9gwQAMLfZ0seylzujETes5AUIFQRJzgYOoq8OQ0ZbiwqpHB6kPj/vSTgXpQyYZ8VTiS3Ejh67/JaQnUsEvb2rKX+WhxdAUMa1I5YnbZH8IAOK269cTQScrFMEgP9x+zic6jB8ArjyetAeP0lsIMz7D4wk2nCNp5BZbJ4a4zcF1L5n6fySyn4yhnYhtMPBxmZ6FC9VgctWKWrjTBaE2/5IRlqE1vam6tA2dWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OTM1FccH4BJmJJgiKw6PubKfPhaeyfWDRX+GgnBSJbs=;
 b=f5VmTYByAgUmHFXmLh6ab2GEB6BoonTZ1IViO2NEfkh/MyQWImjGQkdeZPWGK8x8gDwJuR0+V8hii4CRDXcxvL3icamwSH08R3Js/3XgUCJnJP7b/t6uj6sVYU+rlsYEhQI3oqwl9WNiiGQoUSnznhgt3ghi/SCi0R8eyNlz5+Q=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB3859.namprd08.prod.outlook.com (52.132.5.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Wed, 13 Nov 2019 21:35:53 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285%6]) with mapi id 15.20.2430.028; Wed, 13 Nov 2019
 21:35:52 +0000
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
        Subhash Jadavani <subhashj@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH v1 1/5] scsi: ufs: Recheck bkops level if bkops is
 disabled
Thread-Topic: [EXT] [PATCH v1 1/5] scsi: ufs: Recheck bkops level if bkops is
 disabled
Thread-Index: AQHVlgy8Ub+viGdtoUi1bbnuqokAjqeJo3lg
Date:   Wed, 13 Nov 2019 21:35:52 +0000
Message-ID: <BN7PR08MB568425DF74EEE0A1F4DDB119DB760@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <1573200932-384-1-git-send-email-cang@codeaurora.org>
 <1573200932-384-2-git-send-email-cang@codeaurora.org>
In-Reply-To: <1573200932-384-2-git-send-email-cang@codeaurora.org>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLThmMGJkZjQ0LTA2NWQtMTFlYS04Yjg1LWRjNzE5NjFmOWRkM1xhbWUtdGVzdFw4ZjBiZGY0NS0wNjVkLTExZWEtOGI4NS1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjgzMCIgdD0iMTMyMTgxNTQ1NTAwNjI4NTE2IiBoPSJZR3pPdlhVUzZSSDUxSFB4d2xyaWc0YWhmbDA9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.81.26]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c94b769d-9a03-4ebf-9f0d-08d768817594
x-ms-traffictypediagnostic: BN7PR08MB3859:|BN7PR08MB3859:|BN7PR08MB3859:
x-microsoft-antispam-prvs: <BN7PR08MB38593EF7C7D16311C4774808DB760@BN7PR08MB3859.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-forefront-prvs: 0220D4B98D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(39860400002)(136003)(366004)(396003)(199004)(189003)(81156014)(81166006)(8936002)(7416002)(2201001)(110136005)(66446008)(86362001)(3846002)(316002)(6436002)(74316002)(305945005)(9686003)(6116002)(4326008)(2906002)(55016002)(8676002)(66946007)(5660300002)(256004)(14444005)(64756008)(52536014)(99286004)(76116006)(71200400001)(71190400001)(54906003)(66476007)(66556008)(4744005)(66066001)(478600001)(7696005)(102836004)(14454004)(76176011)(229853002)(25786009)(7736002)(26005)(476003)(446003)(11346002)(6246003)(186003)(33656002)(6506007)(2501003)(486006)(55236004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB3859;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nVbMIdeAQrQwiysEYJKPBlK+rDwlIg+a9+HTiamqJl9CjvMlI538MXv2LEGDn/f7yODo3L3oSfugYHds8j5FR3W/khhPnOucealCtD0HIBchm0Of9uYK/HwPOQ7TerQDjjjCergwM0gamp6UHiObvW9cyWzrHPJclavCk5usW8x/zsBIfcez7JCB2odJaZKBlxr0FwpJUBFGQVnggmgM3U2jlkT1UlSMmvnRiTShG4evd+yRztsuMkdFyOqtgkFh3/S7gCUlxoQqoO3SLb5TWDpn1jgy0mwnzcnngQ3oCYv147wIjIoze+FDq0RkMIT8ge5AyTHC5WxgAxUqv6w1bw/BuyrENiFkbmflZTJ5zxG/P9vLJ6LkhJ1fAhRksdqv0lDdvZZNi8sPZdwHkifSvPJplavSLT9yKSmMo57rAEW0zniCuOHB8tlbg33vNaho
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c94b769d-9a03-4ebf-9f0d-08d768817594
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2019 21:35:52.7905
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kwrUkws3HHetzgblvjUEObkRqIAdy+ewy/ZwhX0oW6TXH2ihAEq/bV/IIOJMlBJjOXvNkw5MK5NEhOiPpB6UHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB3859
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Subject: [EXT] [PATCH v1 1/5] scsi: ufs: Recheck bkops level if bkops is =
disabled
>=20
> From: Asutosh Das <asutoshd@codeaurora.org>
>=20
> Bkops level should be rechecked upon receiving an exception.
> Currently the bkops level is being cached and never updated.
>=20

Yes, this makes sense, once receiving a bkops exception, we should recheck =
its level.
Because device side has changed its status.

> Update the same each time the level is checked.
> Also do not use the cached bkops level value if it is disabled and then e=
nabled.
>=20
should use current level.

> Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
> Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Bean Huo <beanhuo@micron.com>
