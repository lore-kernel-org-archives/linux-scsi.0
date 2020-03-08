Return-Path: <SRS0=held=4Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49FB9C10DCE
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Mar 2020 13:31:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 159C920880
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Mar 2020 13:31:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="3toOL8Si"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbgCHNbi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 8 Mar 2020 09:31:38 -0400
Received: from mail-bn8nam11on2086.outbound.protection.outlook.com ([40.107.236.86]:6024
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726401AbgCHNbi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 8 Mar 2020 09:31:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VYL2qaGRiAEbWcm1Q/uB9Bv/y6LnVTiAbF4zeIE6I58vRAcezsI/77hFVAigMRsOabJhLTI1P6/WREHLLbvxsvnoQ9fiMbtqDhoMKhJqbnKRoAarGTxxfp726RNQjuI+bqYoPcI/Mp8tEz+VrvlJnZRrGEO99/0UgZu8bpgY7GpWsJ5safIajG+icx05vOlmcApxkHHbZ3yhv58Hmn/8r9R01EnaQaF6+glNgj5iRMmP7H+/TzzxEVfVtk09yS5OsqlLoF8onalllEFgqd5lHzpvMb/q/800l3AserkdI4KROEqZF3WMu6v5gn3yzHaKXonIUyEKDJnsRw4gAuRgTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hKYdSC3KdGfooM9wYg2ghrErjRdr7ycuJ58Uc/q3hpc=;
 b=Yb7D0ex1/hss9tjCT8H3YGCuy5fVS+nxokBvJ+o/ZFfAHsjYMrQX8gsW2M8l2PT3QS/9akXCJ+DypvRdEw7nzhz//aQ3VEzh3WOdPmbYm8Drwxna19hprZZF2f24f5wkWzTj9+buZZo1UsJ3geTurl4DHyKpx8I6BjZ9Bj80dlQAkjzH9CmKFDyUJ8KldSogAAwqdjHyu9LRFy4P+91rbBTYH1kaJHLolfDCHjd1cf8LPGbPjOTp36/OxPu6/wMY9l3jTpIfAlMXIPyZS3uM/6az4rzRRmoc3P/vALZ7erUHpRCQiEcsToJWCRBxqdwoN7AS2I1bz+odxuvfJQybPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hKYdSC3KdGfooM9wYg2ghrErjRdr7ycuJ58Uc/q3hpc=;
 b=3toOL8SigsQ2+jjg5CK5V13+KaVzWfNKaljDOVLHaBqlCHDAK6QpDbb5i17dYTss8QnK0rUeanim4U5WpRzh2Ai8H2dTdZ3uU4mEzEtuls+nu14zk12HKMkY7qhL7caD3cGMTXQLm38NmAMgtf3uibUA0dn7DxZPgO+89tPAKz4=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (2603:10b6:408:35::23)
 by BN7PR08MB5249.namprd08.prod.outlook.com (2603:10b6:408:2b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.19; Sun, 8 Mar
 2020 13:31:35 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::589d:e16:907b:5135]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::589d:e16:907b:5135%5]) with mapi id 15.20.2793.013; Sun, 8 Mar 2020
 13:31:35 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>
CC:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH v2 0/4] ufs: Let the SCSI core allocate
 per-command UFS data
Thread-Topic: [EXT] Re: [PATCH v2 0/4] ufs: Let the SCSI core allocate
 per-command UFS data
Thread-Index: AQHV7qUfcYlebiAbjEeNQNXmc4+4G6g+uwsA
Date:   Sun, 8 Mar 2020 13:31:35 +0000
Message-ID: <BN7PR08MB56844C7D0198E487B9F31A03DBE10@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <20200123035637.21848-1-bvanassche@acm.org>
 <yq1v9nq5enp.fsf@oracle.com>
In-Reply-To: <yq1v9nq5enp.fsf@oracle.com>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTFlZmFkZTBhLTYxNDEtMTFlYS04YjhkLWRjNzE5NjFmOWRkM1xhbWUtdGVzdFwxZWZhZGUwYi02MTQxLTExZWEtOGI4ZC1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjEyNDQiIHQ9IjEzMjI4MTQ3ODkxOTk3NzQ1NSIgaD0iVVdCRlBON1FNM2tMOFNPV1NIWGZSeTVTdUJzPSIgaWQ9IiIgYmw9IjAiIGJvPSIxIiBjaT0iY0FBQUFFUkhVMVJTUlVGTkNnVUFBSEFBQUFEdmVXUGhUZlhWQVdsV0I1MkFWeUxZYVZZSG5ZQlhJdGdBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQkFBQUE5cm1ud1FBQUFBQUFBQUFBQUFBQUFBPT0iLz48L21ldGE+
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.86.106]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 39e74da2-9429-44a0-6001-08d7c36505bd
x-ms-traffictypediagnostic: BN7PR08MB5249:|BN7PR08MB5249:|BN7PR08MB5249:
x-microsoft-antispam-prvs: <BN7PR08MB52496FB1B76871BE77DFBA1DDBE10@BN7PR08MB5249.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 03361FCC43
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(366004)(39860400002)(346002)(376002)(199004)(189003)(33656002)(76116006)(55236004)(66476007)(66946007)(66556008)(64756008)(66446008)(478600001)(4326008)(54906003)(110136005)(71200400001)(52536014)(9686003)(4744005)(55016002)(53546011)(6506007)(81156014)(8676002)(81166006)(7696005)(5660300002)(86362001)(26005)(2906002)(316002)(8936002)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB5249;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9VvRoo3W00xHvWxb5YkGehKVunQzCQIfkikswxuoQogqURkLzPPKGnDRhusTHJ4yrGeg2a7xqylapqCcH/DdEUhjZr8itvFOhxdSvJR/FBKUPbVgROyqzpWrV76Rstg457fKkKSiUDwTGqLGi0m4Ks3voWoI5jo+GtR63lX1CUiH0SXKjWmdgAxftpGV1Id/8Y6G1Ba+MaI+TlYQx1IKzl1aNl05Le8oByy+qj/Aflp/2Xtvm51A4KCxUzvQMIqAYygN3nYFVmYoYx7Le3ECla7g4OPxhjQ3+5/OUmQad5oHEuzTHKriH4KKZwZKKF1bKWW6USQ8LivsLL4SniRWor5FVap8LrmJCy0eWnhTgD5yAtwAU9648mmn/13ug+FOxGUgNE2T225u/uQbvF2nLN9SS29YPrB8IUUUJEYVCTBQitey2jAzirleM8Ba1U5S
x-ms-exchange-antispam-messagedata: XhSPFDMPTGBYrSBvmQWn9WaQhD8Hif4OA+IdBJREFPoxMeqmg4gAQoJnl1BoBvT4SSl3yzNhwlswBHEn9UwotTNZY75leNsEccfR3k6I6bJ56aLec+iwi8TUjg/UoAKB1dRhJ9ZN/OSwWYk/x6Z6CA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39e74da2-9429-44a0-6001-08d7c36505bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2020 13:31:35.1254
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eGLBNiP5hi+Uu13mabla/0/KSVG7xgQjWishPJYnENgLEwvFJsSSut9IsZ5+5pNtQjeIkx3RJquhUaMXxEQXCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB5249
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi, Martin & Bart
The 4/4 of this series patch has huge impact on UFS driver, we didn't test =
yet and thoroughly review it.
It has been mainlined. After the  4/4 patch, UFS device probe failed and th=
e root case is the incorrect lrbp.
I submitted a workaround patch for this.
we can now either withdraw this 4/4 patch, or need fixup patch.


//Bean

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org <linux-scsi-owner@vger.kernel.org>=
 On
> Behalf Of Martin K. Petersen
> Sent: Saturday, February 29, 2020 3:08 AM
> To: Bart Van Assche <bvanassche@acm.org>
> Cc: Martin K . Petersen <martin.petersen@oracle.com>; James E . J . Botto=
mley
> <jejb@linux.vnet.ibm.com>; linux-scsi@vger.kernel.org
> Subject: [EXT] Re: [PATCH v2 0/4] ufs: Let the SCSI core allocate per-com=
mand
> UFS data
>=20
>=20
> Bart,
>=20
> > This patch series lets the SCSI core allocate per-command UFS data and
> > hence simplifies and micro-optimizes the UFS driver. Please consider
> > this patch series for the v5.6 kernel.
>=20
> Applied to 5.7/scsi-queue. Thanks!
>=20
> --
> Martin K. Petersen	Oracle Linux Engineering
