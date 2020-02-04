Return-Path: <SRS0=WdRn=3Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4869C35247
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Feb 2020 15:26:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76C052082E
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Feb 2020 15:26:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="yv91YURh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbgBDP0Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Feb 2020 10:26:25 -0500
Received: from mail-co1nam11on2085.outbound.protection.outlook.com ([40.107.220.85]:27136
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727297AbgBDP0Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 4 Feb 2020 10:26:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RLqu9KIHH2TvcvnFfJOizX3ZAr38a4CCDQUQRHh5kPsABzjaUvFuRc2j6DmY5FmwOs6QIdZJo03BcFodMt0WU5pKNrcf2XrIsXOYPtkmvHyoHctMXgB/OcP7fSf4P8IGH6WKtXz51d1fd9C5lAoYMIxsj+O01w0CRdTQRa78w2bLyMWr2das6Idn37AvMElCnUqMYEDWdx1Hu1VnD3BkM23XpaUdqmQ9ds0HQyy3V6fAUzfmAOK8rcYIwJmj9k6ree3j45dVxq8Ib+RFuVad58GrV4jifc7Yfg/Jd16HiCCqgOm0W/Jrmr0JlhUwH3AIVPKqv5xBdUAiNFDHhUEQ4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j9zdQSYTmm99Hv3TNiq9TkSQbrEWSRLgySpYt46fu8w=;
 b=GHLlJxzyXEOFyvBwE01WNyYY2pbG6w6NlVQavxxaA/cAIpr22oBc2Th1PTtU54MuhFlGD/rGN4VyJ0a+NsxW/Dm9C5ntMQuyWFCQq7h1aHvswllJhCP0rpku74UHC+WUrjVBq5ci/hiMwK6yA5mH491ut0gcct2d6A7OjrvK1dkDzY/zdpFjsGek/O/3w0Up2IHJQqhgiDQfWiPyp9Why9qy6Zvs2JEfEUMbxGtJkxSYFPXfd9d6fMlHvXOfQnhr7wVjClmCo8mvNY2ekSmf9CATlhriN7bOAwXgb5pTNZqLhGfbnaxNuNY7eSVBj18u2s7qvaEglx4EDXd32zq5KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j9zdQSYTmm99Hv3TNiq9TkSQbrEWSRLgySpYt46fu8w=;
 b=yv91YURh3amgwvuHDRI50fPeu7d/km3ky1VknV7865X0ZtvNSe23DFQX1AZZAX8/Rqmuu4er+sy3see5k1Rx79V0XQW/VgQPVrQEcp/yWNnu7SIaXuWksXbpdHa+mBGmB/4nle+WQem1mw0KU87e4yCE54T4RgUuVUj1FG6ypFU=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB4227.namprd08.prod.outlook.com (52.133.223.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.32; Tue, 4 Feb 2020 15:26:22 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11%7]) with mapi id 15.20.2686.034; Tue, 4 Feb 2020
 15:26:21 +0000
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
        Colin Ian King <colin.king@canonical.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH v5 6/8] scsi: ufs: Add dev ref clock gating wait
 time support
Thread-Topic: [EXT] [PATCH v5 6/8] scsi: ufs: Add dev ref clock gating wait
 time support
Thread-Index: AQHV2nLooe/S8vdKakmDvCDWUCrDuagLKLJw
Date:   Tue, 4 Feb 2020 15:26:21 +0000
Message-ID: <BN7PR08MB56841CCE325A2725CCA1A7D2DB030@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <1580721472-10784-1-git-send-email-cang@codeaurora.org>
 <1580721472-10784-7-git-send-email-cang@codeaurora.org>
In-Reply-To: <1580721472-10784-7-git-send-email-cang@codeaurora.org>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.80.131]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0abb0240-0701-4c4b-92d9-08d7a98696ce
x-ms-traffictypediagnostic: BN7PR08MB4227:|BN7PR08MB4227:|BN7PR08MB4227:
x-microsoft-antispam-prvs: <BN7PR08MB422710E989EECF7CD39306E3DB030@BN7PR08MB4227.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 03030B9493
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(136003)(366004)(396003)(346002)(189003)(199004)(55236004)(6506007)(4744005)(4326008)(2906002)(478600001)(186003)(33656002)(8936002)(8676002)(81156014)(316002)(81166006)(54906003)(110136005)(86362001)(26005)(5660300002)(66946007)(7416002)(52536014)(55016002)(71200400001)(7696005)(66556008)(9686003)(66446008)(66476007)(64756008)(76116006);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB4227;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QIh1DYrGFVdqbwB7qnUmSEOEb/vLoXpzGutVlALPmYWdUZAIrj5G7rhDpeUIKR6o79+bscQTHZfdKcs7f9yW+1Ix5VWYTxxV85ojxP+huM0zdniZky7nyde/AlqYKKK2Ft7TQCHuSc1Wp9AuhPwMg5DRkuq7fHdQuO6wcq0xv5QmUN/91aDBJqoDGTE0Cjra6BhAds2NLPm8PBPNM4NofrNyi1WF235mKYDnQ6Xt9TvkwWcwQKFfE9FVnXAFO6cEQ8zQjIpSgFtcRAnfwHaTJ2vqnMKG7EyEBb8KmZ68BmI5SPY1/Qb40ngy+yqBCQHVoDrD96zjDFvU3LdIFORMkucQyn7HHHtniGA8Goxn7LaGBWk7+lFndaBG7vv1reXffNVp+a2x9/rdbW7snsY/GNXd39CsY0W6f/ZMXdNCBJ4BcPf4XqKkAiTwi0jqPf1K
x-ms-exchange-antispam-messagedata: LF0moTazbk7TmrjmRRfBxWRZhtwl3es6TiMa1fuvHLpEkVaY6fEz2jvvoFQAG6K2S0+7IXg2vw3X9qFwtQkWTr9Pi/duaRNG2X5wfLg9Ll5KyZBZxraLguUwlq03D9XucGghfgkmEBD37+2FoBtN+w==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0abb0240-0701-4c4b-92d9-08d7a98696ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2020 15:26:21.4641
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5W++phJLh0NAgEy5Yx7QWLSJZumO7DrWr9XAtXvDfxCWmEwYO4HeW0UiPLfoCczW9aLLyFKT3NzG1wzKdRODDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB4227
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi, Can
>=20
> In UFS version 3.0, a newly added attribute bRefClkGatingWaitTime defines=
 the
> minimum time for which the reference clock is required by device during
> transition to LS-MODE or HIBERN8 state. Make this change to reflect the n=
ew
> requirement by adding delays before turning off the clock.
>=20
> Signed-off-by: Can Guo <cang@codeaurora.org>
> Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>

This looks fine.

Reviewed-by: Bean Huo <beanhuo@micron.com>

Thanks,=20

//Bean
