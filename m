Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFE66CA9EB5
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 13:48:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A661C21850
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 13:48:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="NTlZ49IH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728940AbfKDNsU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 08:48:20 -0500
Received: from mail-eopbgr690080.outbound.protection.outlook.com ([40.107.69.80]:21221
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728812AbfKDNsT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Nov 2019 08:48:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ial3vLjUnfYNNClrBp0pCoPqvKaARpB4SknzqLW5rojOIG09WtPhUmWSo8kmhbJXK9RtR8RCOgGrCml+BB1ap+ZnL09Fh3lQM/c9Mk3qlmpkmdc/co1f/fh/hoajNM4u9wHqOfWFAzJRA+7BMYgq0oaucUOu1hyV+akDs1eewVnh4gitBGYTPFEomWBLVjfXh9c7zlcFFfcc97UHO+qN1gR2Jj3qLhrtDw2UuaZVwXzObExOocofuPi4mRcfym3+WcEUnFOHTZkcdw8VdfFBMl19FpBs7ftgv95IdhfDpqDe93J5fUq4hM9CkQhuJxNb4jsw5LTxxawtzW6BqnMvlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=505ZYH2ku9xhNU4gYo/jWaOZHYh+KUDaNrjHcUJoloE=;
 b=eKOMxAR3B/SeXlkXEstCbJ/m2HQua0LX3XaCkvlxG+sY/jhnigS8l2vI0MwxcSJ4k1z2yOWBswSHUYKdpxt0fH9yNJDPx6CTqHThxVX56KAzQclMU75HN7aqJRY/ux7QFcq4UxMvTsd07heMt+Jd/YLm6CVduQwq3oGFXZqEQBjNLnXRVSs94/qOkk//RUrAiZHCfepv7kJ4HcWME9hb+tonaJurZ7/wcQFApnI+MUbXA46VqVL8w0IydzbexGbgMQQ3h8o+qtcnMASaXawmQEGf6b1/18N3DBeU5iYA/H2N52/JDheSGZwlI5Ugy6olFtWGf11LOzrZRP5dOun6lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=505ZYH2ku9xhNU4gYo/jWaOZHYh+KUDaNrjHcUJoloE=;
 b=NTlZ49IHijw2Q6XIJeCt2ILA52Vxhw01tnfNhiBu0HO/eXsHCsUC+uZYOAd4ZwSXz8cp3qkW9cagcHTxH7J5MBNEmlD/lU1pqAsWIYPr8o8OJkYe6xMVEFwGl5uLJVhLikRQguXLqe9TNu8vMtwRSp+lPBQ32Xg5W2LgV81gzvU=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB5092.namprd08.prod.outlook.com (20.176.26.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Mon, 4 Nov 2019 13:48:16 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285%6]) with mapi id 15.20.2408.024; Mon, 4 Nov 2019
 13:48:16 +0000
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
        Subhash Jadavani <subhashj@codeaurora.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH v2 4/7] scsi: ufs: Fix register dump caused sleep in
 atomic context
Thread-Topic: [EXT] [PATCH v2 4/7] scsi: ufs: Fix register dump caused sleep
 in atomic context
Thread-Index: AQHVkrBIJDIFLMJZaUmaGRl7oqgEY6d7B2NQ
Date:   Mon, 4 Nov 2019 13:48:16 +0000
Message-ID: <BN7PR08MB5684D1EF6FD8176E09151716DB7F0@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <1572831362-22779-1-git-send-email-cang@codeaurora.org>
 <1572831362-22779-5-git-send-email-cang@codeaurora.org>
In-Reply-To: <1572831362-22779-5-git-send-email-cang@codeaurora.org>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLWJlODExMjA2LWZmMDktMTFlOS04Yjg1LWRjNzE5NjFmOWRkM1xhbWUtdGVzdFxiZTgxMTIwOC1mZjA5LTExZTktOGI4NS1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjQyNyIgdD0iMTMyMTczNDg4OTM3Njc5MDg4IiBoPSJ5c2hhTFlxbzAzdHM2YUdpT0U4ODlIS2tPZUE9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.81.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eeb51a8d-fe67-4591-0925-08d7612da4eb
x-ms-traffictypediagnostic: BN7PR08MB5092:|BN7PR08MB5092:|BN7PR08MB5092:
x-microsoft-antispam-prvs: <BN7PR08MB5092B21CADC7C21904BBBCDCDB7F0@BN7PR08MB5092.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-forefront-prvs: 0211965D06
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(346002)(39860400002)(136003)(366004)(199004)(189003)(52536014)(2906002)(71200400001)(76116006)(66946007)(11346002)(66066001)(7736002)(6436002)(25786009)(229853002)(5660300002)(476003)(71190400001)(256004)(7416002)(8676002)(66476007)(8936002)(81156014)(64756008)(66556008)(66446008)(33656002)(305945005)(2201001)(55016002)(81166006)(6116002)(3846002)(446003)(2501003)(4326008)(86362001)(7696005)(55236004)(76176011)(6246003)(486006)(110136005)(99286004)(14454004)(478600001)(54906003)(186003)(74316002)(316002)(102836004)(6506007)(558084003)(26005)(9686003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB5092;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TBIKXk/Lfb0tv5qxEusT6uTzBiyW/U13xxatl4ZsW10VvhQnWVq5geRKLX0mGRzB7qU7Bd7sMqHksSWMZHrtPKoMVdx2FfQo15On+YspQV/wMMrqsc88isYgyL8ZWDCuJiPIlDGwwUrY1LqbU3QkTvsOKkPOPdG1phnlV3beY6k64hjAfJoLiYu+yaJPOgbkq/bDLtMDI65u51StGX6cswmePChWXcM8/U8igTbBr+VxWBjQlykcizIFzE/QF2Q0735Irvbd51ZUK2uqSoVGbvNMc2Kpv3/ISlYjtFuy7XPSxGczShoyJQfmWEeYZ/5jrLlrCtPN6o/K4laEAzt0AhkUV6jN4RhT9M4Fk4EnHiLJBPgkjpBBRj94G20z+ofhYqYan6kVaRhDI6Lbn0TLzbMy1GYmd5zIKfd8/E8VZ7a3MUj4LR21d8OoCqikNFK9
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eeb51a8d-fe67-4591-0925-08d7612da4eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2019 13:48:16.2584
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TkXY3olm2aRNLZzHF1ANBCKCGxmlkIP5OvlG0HJoARgA2122jTQd6EITFYdpMM7hgRpyZK40OhlDFoIv4omBAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB5092
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> ufshcd_print_host_regs() can be called by interrupt handler, but it may s=
leep due
> to ufshcd_dump_regs() allocates the dump buffer memory with flag
> GFP_KERNEL. Fix it by changing GFP_KERNEL to GFP_ATMOIC.
>=20
> Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Bean Huo <beanhuo@micron.com>
