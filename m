Return-Path: <SRS0=0hmW=3X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DE1CC35247
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Feb 2020 21:31:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26A6520658
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Feb 2020 21:31:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="M7/x7A5S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbgBCVbr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Feb 2020 16:31:47 -0500
Received: from mail-dm6nam12on2081.outbound.protection.outlook.com ([40.107.243.81]:38848
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726287AbgBCVbr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 3 Feb 2020 16:31:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bRlPhMn6ymKCVpE27HllF9Bv370zgK+MtNTs9+lXAqB7UBiIlDtTsx5B2l1dlIUwgCo0ACF58z2c0t/TjNkC1I0M8lv6UR4GADUVpU+hP4SR9KQhcbjC/saMxp1oUYGZ1Jkw1XkZIoi+n3OkQ+bN/ZGJvWNttM9hCIEUkrpc30kGyfuPc3dcBwJsJGiLTrag/YeUQ+4e70TZq94xj/Eg4hyv27f6q/1snayRGApPgfHZwEa8ZLG8snvy5W1ZH9vISOhA3oD04Mcr689+Ln0qdCD0SbO80pspdZTfRiHldD3W78m6+5zgiBNyw/0fXQr2g93b9w5wo2DDceML6x+yqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5e3TDauonWAyLjxK7T4oBiUW7izsbIiDa8/qrz+MGS0=;
 b=M0JW7rigTEz5RqGok13x+B21GjmkDJipxDFRs8muvK4h1Sn4SNLLHJ0oRQEuUntt+bXNh+Y4C+QxWtqO+LGk49HsYlHzbIqqU4rfhkGPo4Oe3ZPcZyX8LjVp8LQvpq2UZvYeul5xMNw+0b9hdfcDZzrybRX5COexrJbIL7HiF3osudPK9cMfFcfCr2PunESfPseCsInZVVo6MIN95YQq5zbDy4yBnvtnzu/+ZBAsv/DKP1Im7QornclJxuOiyLeOYX1Pk388b2XB8jd+TTAB01rcTuQV1WaYFZa67pMOEUMCP9g+ANPrz+tDehcIYkEpPLG1Lh2tIBBI+kJTlkHYCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5e3TDauonWAyLjxK7T4oBiUW7izsbIiDa8/qrz+MGS0=;
 b=M7/x7A5Sb850iX/yMAoGPzykvdowodFMZ/T2NAwiyKW0b7JqXHbULblDiCYy7O+uSFBYxmpKfXr4hMZVRVz0duFqmAHOX/ibxq9EmzS9hlUiW3QcZn3yr4G6YSFg6yqpkDMF/GszLZ8dZz59jLvr7l2RDRgwrWwX2ZG52vMWO5M=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB5569.namprd08.prod.outlook.com (20.176.29.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.27; Mon, 3 Feb 2020 21:31:33 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11%7]) with mapi id 15.20.2686.028; Mon, 3 Feb 2020
 21:31:33 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Can Guo <cang@codeaurora.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "hongwus@codeaurora.org" <hongwus@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>
CC:     Sayali Lokhande <sayalil@codeaurora.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH v5 1/8] scsi: ufs: Flush exception event before
 suspend
Thread-Topic: [EXT] [PATCH v5 1/8] scsi: ufs: Flush exception event before
 suspend
Thread-Index: AQHV2nLc42EYEs1ALkOcxlBdoGO8qKgJ/X8g
Date:   Mon, 3 Feb 2020 21:31:33 +0000
Message-ID: <BN7PR08MB5684C66AB164C6DECAC88664DB000@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <1580721472-10784-1-git-send-email-cang@codeaurora.org>
 <1580721472-10784-2-git-send-email-cang@codeaurora.org>
In-Reply-To: <1580721472-10784-2-git-send-email-cang@codeaurora.org>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLThhNmRlYzRhLTQ2Y2MtMTFlYS04YjhhLWRjNzE5NjFmOWRkM1xhbWUtdGVzdFw4YTZkZWM0Yy00NmNjLTExZWEtOGI4YS1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjMwOSIgdD0iMTMyMjUyMzkwOTA4MzM1MjgyIiBoPSJKK3g0SkZaeGZNR1cxQ3gyOWlwVjl2UHBuZlk9IiBpZD0iIiBibD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFIQUFBQUN5bE1sTTJkclZBZEJHM0dwZ3BMalEwRWJjYW1Da3VOQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUJBQUFCQUFBQTRxMWltZ0FBQUFBQUFBQUFBQUFBQUE9PSIvPjwvbWV0YT4=
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.86.106]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d15135ff-902f-4deb-2c1a-08d7a8f070f1
x-ms-traffictypediagnostic: BN7PR08MB5569:|BN7PR08MB5569:|BN7PR08MB5569:
x-microsoft-antispam-prvs: <BN7PR08MB5569DB119C981487314B3B20DB000@BN7PR08MB5569.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:400;
x-forefront-prvs: 0302D4F392
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(346002)(376002)(136003)(396003)(189003)(199004)(316002)(9686003)(33656002)(6506007)(26005)(186003)(66446008)(55236004)(55016002)(64756008)(7696005)(52536014)(2906002)(81156014)(81166006)(8676002)(558084003)(66946007)(76116006)(66476007)(66556008)(4326008)(5660300002)(54906003)(71200400001)(110136005)(478600001)(86362001)(7416002)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB5569;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HfGFH9H8RDx4mdr+Y1JrG7TX5TNpSmv4hOnHy9MuoyWDXbkQZZm3CMoRhdyjO60kB1iTyTylK/30+3Rl4R3K/K+9poETT6ytn33qT37MYiTlm7sm7C/VUbR2y2M7qTRhR12kqGWSpG+kUtC8jirSkBbqPlzGNDE3Br5ujC1s/6MajN4GRyS+B2JSEUp+IRPrb6vpYUlm1JyyQEI08FXHdrFkD37LBGhN3b7/WzOilY831VS/sQ98pomsI6GchrM4et7Kk3t+kgT+i9jnVTbq3mgPZZNxYKbjZkpc2ct+kyTqM0cZJ8LTASoKo0Uf/B2QXAikGalzXbqj/m+trtbJeh3i92lnuWpi8GRwgbmtX67dw74W2E8HWrJNfX+C+ToHkaZZySgJ8su5YG6jwm0/qtjbDDmd+elQqDogb+ZkuoMABXSaMYXx2XbnFXYOle8W
x-ms-exchange-antispam-messagedata: Zgd6nZxGRyo0ndq9Yq6p7NBNDUAujlGID3PUsIQsnwjRMs1dgIa0I6e41OVisaueUQ/565vmqyZtAKIugj9LgZdaG4MMvllMaMyic/dbP4EaXd1bHa13PKRPiuK2KVp5A+5JuHZda66MPQ0/LSsHVw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d15135ff-902f-4deb-2c1a-08d7a8f070f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2020 21:31:33.4978
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YNpfkui4VzX6RuGyuQS1KabooxcFkCa/efAkYHhlwS79kmzXFhds41tZOr/t760VDSbJuKy85cWlN3vixcTGVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB5569
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Signed-off-by: Sayali Lokhande <sayalil@codeaurora.org>
> Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
> Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Bean Huo <beanhuo@micron.com>
