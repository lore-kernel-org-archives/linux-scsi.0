Return-Path: <SRS0=WAUG=ZF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A0D0C432C3
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 16:27:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 659C824066
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 16:27:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="NgUoM1hW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728338AbfKMQ1B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Nov 2019 11:27:01 -0500
Received: from mail-eopbgr770041.outbound.protection.outlook.com ([40.107.77.41]:9955
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727221AbfKMQ1B (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Nov 2019 11:27:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IQHcBRdbcqEQtn81u5su9YA0uqPfOByv/lSNEuhnzgQ1QkyjDsH/+j+bjh+NlEOeyXCzsGRZ0ni4Iy0gSXWjKYv+c50gt7Qwe0FZPy7OHgMjdgwKfpf8lQcLAReAjIF2ugVsntJa2lt76oaQgcltAShpho2kjBjFiMoNJ58jOE70ijFfPSbnmV1rQG5ir04xyJmjA29Im8YxuqGWIuHaoeAjZ9nr7HLq5lgkZm+sfOr1ZWCNaKvBkrgby4Jqf8zsmdLChnKr4MMquB3XcEJDLCsw7eucbMK/LAA2nmM1DCn900RIuTwCOROtAo9/T8A43AUOpSc/Dw7sjQBtsyYNdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5UJc7jMgR5YiYX1Z9f//voCfIJP50JZs1fKrdDss4nQ=;
 b=dkyLZwx+LFcDUr3ASBa482dui/wpTHGDeI/aCil2YPmBoV9fdGZY9AaZDzOtsf+h0qPgWHUPm862qPVNRIe6grIOyXJUDBn1EH2fqhS/lI/pIY95ocpEsnU6/AVSWRJ74Emai4uEQmohSJI+3b0P9J0g3l0IK+9oJgVPxy7OzfF39/zPJT6V7wVnMOHk6M/yLDsRcqJ9lHCmbiepH3ZEANZF3NlGQdKfCwlW5zhwS3eFcWMJeAwbp+gHpMotCemi2P9PJLIvXyE2Y+05yAj5qRWz6Vy+CAzcTkn8pC2LtNaUTYjOMk6/q5YGxy5fX5lzRq5n69Bppkbqf4tP8s01fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5UJc7jMgR5YiYX1Z9f//voCfIJP50JZs1fKrdDss4nQ=;
 b=NgUoM1hWZqXanM/zyxRQPec+MyQjVnqLWtwzSouiL2uqkGkpckd4T+gUEOi0tivGE5QlBRfnrJIW60p46jCkq4F8fe2iKO5HBVRezk0xASmcYD3A4MYWffHg/fzUH/LTYaWSvv2ktMx596Ya2STL+5gHXXVmnSgCQyJc3NbdJyI=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB5683.namprd08.prod.outlook.com (20.176.30.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Wed, 13 Nov 2019 16:26:59 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285%6]) with mapi id 15.20.2430.028; Wed, 13 Nov 2019
 16:26:59 +0000
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
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH v4 3/5] scsi: ufs: Release clock if DMA map fails
Thread-Topic: [EXT] [PATCH v4 3/5] scsi: ufs: Release clock if DMA map fails
Thread-Index: AQHVmeeyXKBE/XJKZkuVruGGiYn+vaeJSkLw
Date:   Wed, 13 Nov 2019 16:26:58 +0000
Message-ID: <BN7PR08MB5684B3516E362FD79B80AA44DB760@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <1573624824-671-1-git-send-email-cang@codeaurora.org>
 <1573624824-671-4-git-send-email-cang@codeaurora.org>
In-Reply-To: <1573624824-671-4-git-send-email-cang@codeaurora.org>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTY4NDFiMWExLTA2MzItMTFlYS04Yjg1LWRjNzE5NjFmOWRkM1xhbWUtdGVzdFw2ODQxYjFhMy0wNjMyLTExZWEtOGI4NS1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjMzMiIgdD0iMTMyMTgxMzYwMTY1Njc4ODgwIiBoPSJNOUpJWGZxdmRyZ01mMmp6N2lvN1Z5cjVUcEk9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [195.89.176.137]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 42dfa3a1-377b-4731-298d-08d768564e99
x-ms-traffictypediagnostic: BN7PR08MB5683:|BN7PR08MB5683:|BN7PR08MB5683:
x-microsoft-antispam-prvs: <BN7PR08MB56832B5BDF29EBE87C22A855DB760@BN7PR08MB5683.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:1332;
x-forefront-prvs: 0220D4B98D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(136003)(39860400002)(376002)(396003)(199004)(189003)(476003)(11346002)(110136005)(478600001)(66066001)(8676002)(54906003)(6116002)(25786009)(3846002)(55016002)(6436002)(486006)(446003)(9686003)(71200400001)(71190400001)(7696005)(5660300002)(305945005)(74316002)(76116006)(7736002)(2201001)(81156014)(26005)(6246003)(52536014)(2501003)(8936002)(186003)(7416002)(86362001)(14454004)(229853002)(256004)(66476007)(66446008)(64756008)(66556008)(316002)(2906002)(81166006)(102836004)(99286004)(66946007)(4326008)(558084003)(33656002)(6506007)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB5683;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 077VHQdVAUsw1XZk0/UpfVpnqVEfz5XCLLuoz8IYWFhPTgZDzVmQYNLeTV1GS5YN3HYBWpyGlV2Yl97MVyrO+q8EAQ2rKAoZ29hoSNcbUC2prONtowbHgcb6H84Y/UsLRxjrynAKZK8xJFRzKvtgUouOAqDfdkG3HnhzPMKEycLPo30yrL+e/0qU+47lzirov/fHrMjITJFDzn0/rQtxz/wNV9yadAcNKZYukG1RihaDBvbfBWL42XvWGvvtxNDxsxslk7mVtaPk7RqP2byor/o6CUZeJon4QwzsO8MJhl79xx4UJLG3KD/MXTuwONSGnpSYqic70QqCZAbpdwr4T8thBoloJWVtNdZbRAl3f/y8rew61KSriVUADnhfsAG160Re/tCFYFWHC6hYnk7mlywaExQa39mgsksHjY++r5u3YjbSEkImurVkFBy3V/pz
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42dfa3a1-377b-4731-298d-08d768564e99
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2019 16:26:58.8681
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6elZNJ5bce8E65jDomF+/79O46sxWGVsU0LrgPK2CewXpmtl19vInJmFf1G40tb5oIbMVo0BwElOt1VXVpqdVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB5683
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> In queuecommand path, if DMA map fails, it bails out with clock held.
> In this case, release the clock to keep its usage paired.
>=20
> Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Bean Huo <beanhuo@micron.com>

