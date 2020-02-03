Return-Path: <SRS0=0hmW=3X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56E46C35247
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Feb 2020 22:07:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AE5020674
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Feb 2020 22:07:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="URUZVZFn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbgBCWHU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Feb 2020 17:07:20 -0500
Received: from mail-co1nam11on2089.outbound.protection.outlook.com ([40.107.220.89]:23754
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726984AbgBCWHU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 3 Feb 2020 17:07:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BetFCXGBjZGdypIJ7k6MoCPuUrbGXuyu1QZonOAAMvHrxh7HF08XDVc7cUIvaThQrltn9omJaD9JR0vGp2hGaKrBPpHoYvHUa0AYHX3ZOfil+KywDMq3gKBj921WFOE1HvS6vmjRnRPfLbjh3hPgDI3FXWV6HIXmbNNhmat1ZUcRY6TFcG5d+g98FgVMHr3VMI9I4SFQ+zPF5+URwTJvD9udtOIEUXO71qFxYIv/ZrvBQJTL/VWySzVpM5MfZ6KOTyYWFvL1hCRiSyOXimQ10D5gzb0XhSmct/+abir07dMGVrSZEFwLFJCWU3iTJ0RCs6Mhtg28gmphOcIf3bCSyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TSSXzT7npiTfhrvAMrPhePWe26mXwJJv3NfITrgpg6w=;
 b=XSY3JAk+he/ZrNo+cGPCz9wdhebuMGpvtCeNSXk9GA/TkJvdtqZKniqmuPuQAXuk9kIMJQqNcoleb6IrtKhhA887PugZLY2KhRWKb6hKSp9b2arAMYjq6jJJAV7LOhls2fq5hnD4MmS8XSqfw0UHelwTENk5KX1ECYHGpri2680fRj/jxEbmC52BDSB/ErKZA0LF2ePbkXMKMQv0WNgt0DwUDh8WHqkUk3sCmVbNi4T6rulhF6SZzYGP/cBcjnsb/Lt08hn80ew0GwWJDPZO339IkJZlKXdI/bs8SfIXveYFEAIq6UEXkJjaMidRmYKkZxAgacmsLjsB1xmfVJdBOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TSSXzT7npiTfhrvAMrPhePWe26mXwJJv3NfITrgpg6w=;
 b=URUZVZFn33UrTDmjpvFtCqmqGpTfa5CzpVDMogr5TQyyi/FhCLVg2BwlJ7B7+dqlqgctAI7c1h060abRUvctgTZuSOtFu5EFN5ISWvHaIHQ0VTB1zuSaiJsxvkRv4tvCZkMH5VZL3V4ICTTUC5M4fu5LpaWs8AJPMvKACZ7vAJc=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB3891.namprd08.prod.outlook.com (52.132.4.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.26; Mon, 3 Feb 2020 22:07:17 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11%7]) with mapi id 15.20.2686.028; Mon, 3 Feb 2020
 22:07:17 +0000
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
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH v5 5/8] scsi: ufs: Fix ufshcd_hold() caused
 scheduling while atomic
Thread-Topic: [EXT] [PATCH v5 5/8] scsi: ufs: Fix ufshcd_hold() caused
 scheduling while atomic
Thread-Index: AQHV2nLjjhKx+HbiykOub6suIynkHKgKB4HA
Date:   Mon, 3 Feb 2020 22:07:17 +0000
Message-ID: <BN7PR08MB5684AC6701E471E60421FBA1DB000@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <1580721472-10784-1-git-send-email-cang@codeaurora.org>
 <1580721472-10784-6-git-send-email-cang@codeaurora.org>
In-Reply-To: <1580721472-10784-6-git-send-email-cang@codeaurora.org>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTg4NjA0YTQ5LTQ2ZDEtMTFlYS04YjhhLWRjNzE5NjFmOWRkM1xhbWUtdGVzdFw4ODYwNGE0Yi00NmQxLTExZWEtOGI4YS1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjMxMSIgdD0iMTMyMjUyNDEyMzQ4NjEyNTEwIiBoPSI1aGI5TlRFcHlNTG5YNGNYeGhqOUdadENXbjg9IiBpZD0iIiBibD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFIQUFBQUNlUDdwSzN0clZBZmt5aEYvUnpNRm0rVEtFWDlITXdXWUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUJBQUFCQUFBQTRxMWltZ0FBQUFBQUFBQUFBQUFBQUE9PSIvPjwvbWV0YT4=
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.86.106]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f9103b63-3183-4d7f-abfa-08d7a8f56ec6
x-ms-traffictypediagnostic: BN7PR08MB3891:|BN7PR08MB3891:|BN7PR08MB3891:
x-microsoft-antispam-prvs: <BN7PR08MB389162CBB883E58B94F40DE6DB000@BN7PR08MB3891.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:400;
x-forefront-prvs: 0302D4F392
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(346002)(376002)(396003)(39860400002)(199004)(189003)(186003)(86362001)(26005)(33656002)(4326008)(76116006)(5660300002)(64756008)(66556008)(52536014)(7696005)(66476007)(71200400001)(66946007)(7416002)(66446008)(6506007)(55016002)(54906003)(2906002)(316002)(81166006)(478600001)(8676002)(110136005)(9686003)(558084003)(81156014)(55236004)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB3891;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oXuiZadB0E5mFSwUz3IJX7JKMgTMf1veObw9+RJOokhMuVPZtIxQo2CmPML+SgNP8MgtO170EREM9TAd88fE7hxufBO27F8B8IpNPgrPnrQkTqun3/Lihievu7UbHb/IHmJykxkNp2ep1Xfvhtz4okZ5lPtzUMq51GoUiV7ssuJn1lUilfLVUYNEHj9+zoPBxFa7AilmPuEBXQSQ/kIUq37N9ipSTCFYgZkC0DZVFPN6oBYPeKMhVgyV4w/UFAt/O2OKdXgJQVezMh2BT73UBFxSl5QzSNusV1PWtPlOQ1rR38bbR6oi3ZDrHCq9js1Cu2ILZdBpBLtK1UaFcagSOX0UtNM8Nf4l92wRAdHyeq6KeGwbrmb7d2ivgzEX6iU1VN5UcBN6bbrsGVdIQSx6ADe5whugoWxD10mElrNIvHRKehCzRnwCG8L3ZNGZ0E/M
x-ms-exchange-antispam-messagedata: GYT2fUdTtp8gY5zxrBevP2rfzfN7aHUGlg2gHN23D126o+3Pqe7BiBymMm+L8c2tv6AV67ZK3tw7WGre2e5qw960UdgKFTh2QpXxl/nEh3YDYHGtPBwD8d8Mrl8w8xzGY6KBi8f0Cco1MX/J0D8y9g==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9103b63-3183-4d7f-abfa-08d7a8f56ec6
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2020 22:07:17.4748
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: epMmxLATeubjb+1N6nsIx2Ai0aX4ksrcWQNkdYZYQO+kmokC2FQgSdeS/HA4/ENvDVRhH5yim6eTZOhP8Sp/fw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB3891
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Signed-off-by: Can Guo <cang@codeaurora.org>
> Reviewed-by: Hongwu Su <hongwus@codeaurora.org>
> Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
Reviewed-by: Bean Huo <beanhuo@micron.com>
