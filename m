Return-Path: <SRS0=0hmW=3X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 412D5C35247
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Feb 2020 21:41:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EC7F20838
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Feb 2020 21:41:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="ynKNAJqY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbgBCVlK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Feb 2020 16:41:10 -0500
Received: from mail-bn7nam10on2088.outbound.protection.outlook.com ([40.107.92.88]:24141
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725372AbgBCVlK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 3 Feb 2020 16:41:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NezgJbBah6UdRGcCBKHn7jg26twZLR1/YB9reKee3YB15ELyuNbKmJs/O/gdjhAUfCvw+u6a7WEw3DB54YVJbodahqWUi14rqGNK4/xykM9Nj0WaC98mJpNVo72sat5a5utt1faPWRlzZR4UXXCW5x4p8uLf7vWLv1xMzdDcZFdBAH6wrfbPlzJeI6Nma87faRj1H1ZTyjuvlTevwrmwHP7Z/MIyc4IPKide5LKyV2WAM5gPVvp3dbWtYAkq0XWi936JPy7CDPiAN/eTW5eS5A7yOjf6jvuaGgyP+Ok/XwwMM7ImNswN78oevTr7i2YB1cvwoT2FPrPWWsqHkLocXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ff15j3nVmeekw8sfRp+LXxz0OGxxg6gML5IyhqaUQIk=;
 b=gvynJZefRcAvp0K5tz5NTcCbn8saJ0C68tW/2RdR/cvSNr7VLnGmzW13clYPLjCmNywGH9ZC0quoa+DYtO5W6huNMVCWCxmZbr8TDTAmdr6Tlk4sokqjfaE975Sx+Ja9hSnTgeBN9GHthPBSDXFO4UuoXJpHT23JHBkzuDS7rQjIA4MgwxDohL2VX92PU50jtj8gYDFsuUAziN6OgPrkSgeMYwZElVgtPJFLtBaWwfvO3sFDBZbtbaq4Tpwhx17A97DtDd4aFuBsfc0V2KThsV7i/tw2T6QPceOXekK4rSs5neRLtzR9KJuOshblgHo1mGw6ZdDUQODezMd93Ih7ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ff15j3nVmeekw8sfRp+LXxz0OGxxg6gML5IyhqaUQIk=;
 b=ynKNAJqYE/4KstjG24Ejmj9jIOG6UVACB+9fcfmbm5dMt/FSUZbeF03o/yz7e1s4XWEW9cVrMzVlp38+BBeCKi6CQwhO3rdmV6XjpPvPsSxd/N1V81Cz/7xaLcPwYgosOZRpjGpAcDPbNNfHscnldCKKFHBupm4HfdpFWM1nYUw=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB5588.namprd08.prod.outlook.com (20.176.30.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.29; Mon, 3 Feb 2020 21:41:06 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11%7]) with mapi id 15.20.2686.028; Mon, 3 Feb 2020
 21:41:06 +0000
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
Subject: RE: [EXT] [PATCH v5 2/8] scsi: ufs: set load before setting voltage
 in regulators
Thread-Topic: [EXT] [PATCH v5 2/8] scsi: ufs: set load before setting voltage
 in regulators
Thread-Index: AQHV2nLgg8B7qAad3E6eCMrXsDrqAKgJ/8Pg
Date:   Mon, 3 Feb 2020 21:41:06 +0000
Message-ID: <BN7PR08MB56849208AA95C352FD0041F4DB000@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <1580721472-10784-1-git-send-email-cang@codeaurora.org>
 <1580721472-10784-3-git-send-email-cang@codeaurora.org>
In-Reply-To: <1580721472-10784-3-git-send-email-cang@codeaurora.org>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLWUwMGRlNGRkLTQ2Y2QtMTFlYS04YjhhLWRjNzE5NjFmOWRkM1xhbWUtdGVzdFxlMDBkZTRkZi00NmNkLTExZWEtOGI4YS1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjMxOCIgdD0iMTMyMjUyMzk2NjM5NzE2ODk3IiBoPSI4ak0vSmJmWFBiKzhjaUg2Nzd6TkpTL0lVWHM9IiBpZD0iIiBibD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFIQUFBQUFoaG1laTJ0clZBUkJ2azhRenJJK1FFRytUeERPc2o1QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUJBQUFCQUFBQTRxMWltZ0FBQUFBQUFBQUFBQUFBQUE9PSIvPjwvbWV0YT4=
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.86.106]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bc9b92cc-bdef-473e-a00a-08d7a8f1c658
x-ms-traffictypediagnostic: BN7PR08MB5588:|BN7PR08MB5588:|BN7PR08MB5588:
x-microsoft-antispam-prvs: <BN7PR08MB5588D403E7DC6C2375A4EDC7DB000@BN7PR08MB5588.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:400;
x-forefront-prvs: 0302D4F392
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(136003)(396003)(366004)(376002)(199004)(189003)(4326008)(186003)(26005)(8936002)(71200400001)(478600001)(86362001)(7416002)(33656002)(9686003)(54906003)(55016002)(66946007)(7696005)(110136005)(55236004)(5660300002)(558084003)(81156014)(66476007)(81166006)(66446008)(52536014)(66556008)(6506007)(316002)(64756008)(2906002)(8676002)(76116006);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB5588;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4PNC1POKgtwf1nvFrrclbszdJqd2X2vTMc57B9wvPZTu639yYb++H/TxxHLQG0qbHtYiNtEJYNWgB9IDfLJppSENPTxISk5TvYFTEFxicZPe2cvjaJe8bYw8TiKvQ7n592cFzx4N2WcAXZAsGHCXebFwesAoCLSyoMeOwdTk7kQeEMPrbQyzxQeMrhI23aYBmj1X+iBIEjojQuRJtj0pwplV28b+8QF1OLykZsvLv6I0to/ctv+nMSsmS2rw3bhX+vq+uasnLhgF7bY79pe/eWDtXrxREfNgXRVsqNs/Iw8BeHE2KkmuZz8Mjm0HGyB/XRpRsHJeRRMdQmRv6keTfh+HFvswGo/Zm6SXTdZ6LWPCcmvoE3gmABU4XolRJfbzo6EHUUE6MqU9kKhJiPECtQybiDCV1Xrb1cuZE7LgimZJYZOscQxiaMvL53wwjOTi
x-ms-exchange-antispam-messagedata: nHs8d9CIlkUu/sYi47tmZw4ccs/TCdK4YyL9+rlR7nDaor5tOwtts5VjucrrNdOsmwmGl+LOwWA5IhBcoG5dzoLTlVWtsf1/ymWS0sjNeMBidPHKxAGltWK71MRxXETguKo3aiFg+9fjEo0rDPgozg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc9b92cc-bdef-473e-a00a-08d7a8f1c658
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2020 21:41:06.2929
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vLAy6srzgBKwR4uXcLEdEnJaUjhtbiUvycYX97gLNkQ1k/JGZTwOE+lwZkHJW+U2YKQOx+c6wVX3+RD9hTEQlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB5588
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
> Signed-off-by: Can Guo <cang@codeaurora.org>
> Reviewed-by: Hongwu Su <hongwus@codeaurora.org>

Reviewed-by: Bean Huo <beanhuo@micron.com>


