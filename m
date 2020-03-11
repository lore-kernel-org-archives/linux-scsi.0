Return-Path: <SRS0=VRpU=44=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFB0CC10F29
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 12:53:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCF0221D56
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 12:53:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="EgWwWIx+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729409AbgCKMxK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Mar 2020 08:53:10 -0400
Received: from mail-co1nam11on2058.outbound.protection.outlook.com ([40.107.220.58]:6638
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729283AbgCKMxK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Mar 2020 08:53:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F3ma4VJ3oda17loLkEyv6Zy70kYDtDZ1YQ1qzpXpAu4WCLAoGiTtJSE5/zd+ziEyuNJIjWrPsDho2RQaMt8V34WFpltw2f0kN8qWJq3VWM4Qgxxg/npOF71NkAAq0vsfCg8zHryyzsR7PfjPOfH8Evq1Yg6sUzSddCsMpzjSc3wo6s58PC6QGypitAMk1atV7txz1q8SluG5OpBkssEyBgxSYEYMJIXbiHEsyKrOUcemj26vzMNsA0W/aEmvvxYG0y79CCeeP1g8faj/RS+0s9ikXu5BWy2JRDtloQuP8B1gxvL4XxQ2/Ss3ULVtORKCsWtQZj36+MfZ3nuDoTAHfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ViRyt2wALr3pPlYD+ZHkj9qnI/C9+foif2T/IWbn42Q=;
 b=B1o9EDPEnLXbj12difNpm5irNPqMPYuT1g350iUbqgLu9xR0uj9SgL0u30W60RxJkbBJuhHFRvpgMInoYBlSV1OY72xxIxX7mN864AiWW2JrLHvOWbjRbgd5BnxMrTpRT3E1KojcsTTC7/X3as5DYjW5TV0NzIzkyp9KiOfd0C/gA8enq+Q85/dwZHtmDwY+czCutkLtsRfrlW9KokRrY4/GAQSHHR9v1cI8a8S8VLCYe2Qi6FOUuaN2wyafBFaVSAqo7xT+n3+kFpuBVi10NxKshbLWBom/ReRtCYjeck3bRHV5SL9zo92XnrAhzLIjY6m2W+2YqAfYNuo2dJEMHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ViRyt2wALr3pPlYD+ZHkj9qnI/C9+foif2T/IWbn42Q=;
 b=EgWwWIx+DqxP2E5jgS4tGrMSQXqnH9UkPN2TSTXvtnthexjzEZNEVIRg7C1KFmzKl6dCKijXPVVb6v+Ou+39ND4f5QtLUSkc8qu8oHjzQddWZWgzUxfgpTmv7l21J0Jqb1zHw7PyFWtFfISO2Wh8oliZegaviqzdUhYqpRxLq6g=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (2603:10b6:408:35::23)
 by BN7PR08MB4769.namprd08.prod.outlook.com (2603:10b6:408:27::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.13; Wed, 11 Mar
 2020 12:53:07 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::589d:e16:907b:5135]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::589d:e16:907b:5135%5]) with mapi id 15.20.2793.013; Wed, 11 Mar 2020
 12:53:07 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        "huobean@gmail.com" <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] RE: [PATCH 0/1] Revert "scsi: ufs: Let the SCSI core
 allocate per-command UFS data"
Thread-Topic: [EXT] RE: [PATCH 0/1] Revert "scsi: ufs: Let the SCSI core
 allocate per-command UFS data"
Thread-Index: AQHV96A3H5vu8h64PUWShi5i74/3jahDVomg
Date:   Wed, 11 Mar 2020 12:53:07 +0000
Message-ID: <BN7PR08MB5684DBAD57C95A40CB62B24ADBFC0@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <20200311112921.29031-1-beanhuo@micron.com>
 <SN6PR04MB46404175998962B4FA575824FCFC0@SN6PR04MB4640.namprd04.prod.outlook.com>
In-Reply-To: <SN6PR04MB46404175998962B4FA575824FCFC0@SN6PR04MB4640.namprd04.prod.outlook.com>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTNmMGU5YThhLTYzOTctMTFlYS04YjhkLWRjNzE5NjFmOWRkM1xhbWUtdGVzdFwzZjBlOWE4Yy02Mzk3LTExZWEtOGI4ZC1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjExNjMiIHQ9IjEzMjI4NDA0Nzg0NzU0NDU4MyIgaD0icm8xUUlGNDZTWFByWERmZ0xEbG95dWF2VHd3PSIgaWQ9IiIgYmw9IjAiIGJvPSIxIiBjaT0iY0FBQUFFUkhVMVJTUlVGTkNnVUFBSEFBQUFBSFYyY0JwUGZWQVZ6SFEzN2JXMTNxWE1kRGZ0dGJYZW9BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQkFBQUE5cm1ud1FBQUFBQUFBQUFBQUFBQUFBPT0iLz48L21ldGE+
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.86.96]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 404d9a00-1133-407d-fe75-08d7c5bb257a
x-ms-traffictypediagnostic: BN7PR08MB4769:|BN7PR08MB4769:|BN7PR08MB4769:
x-microsoft-antispam-prvs: <BN7PR08MB47692554CB93E26C1BC065F8DBFC0@BN7PR08MB4769.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:883;
x-forefront-prvs: 0339F89554
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(346002)(376002)(396003)(136003)(199004)(2906002)(316002)(4744005)(6506007)(81166006)(8936002)(55236004)(81156014)(478600001)(186003)(54906003)(86362001)(110136005)(26005)(9686003)(71200400001)(8676002)(7696005)(7416002)(4326008)(55016002)(76116006)(66556008)(66446008)(64756008)(66476007)(52536014)(5660300002)(33656002)(66946007)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB4769;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QmydGT6yAVzDZL5HqgHKt0Xe9DA9rXFPxlYew9zZ2ENQ14CQ2Dc/EhO/q88oW76ZmlwypbnKET1M/jM8NQnXpVPpmrUtJzzIBaTEC/MOWFz9vuJrIEQt9nNvl4+fAjXenYCsymcx43iNTqxTuc8UaDrXU1VJRA8Ary4mU18+dIMJZ7dV8ySNBICpsCzTX3iefEQcL52jEfKLGePOjs5VawTMrYkRDO3nYEnbEkPaiZSokrL5X7xJB/ygFlRuMtT1Ox44NaeNJy6bJj/nTS88tWubqinPiuW/+aF5eVJ+++U5gtG98fbQuRcCA+Nv8/ldT2pbCZEVngIP2AvB5hedccv5pwTt0P4WNvTJXNjPy2o4nfWxlQOiRDtI7RBKYMSI5PcXNeJ9bunfwq2SNFiFf+FdxIgp3vj4IY3VIX59aZatrlwaZuusIFpE3lBiXM0b5DyhHaH0VabGCt4yT18z3NLPoai91/z8ldjcLA5DGDwV5+LgL6I/DlYM9QTPNYIZ
x-ms-exchange-antispam-messagedata: 4Vbv8PpJCpRBJvw2mHvadbZpmyWDPbm5nqBoE0WgbDeS4ExStn+ax4h6GX2bqEAcAoXTiXkKibfvBI0ogFjKSWXdDWIU13pQmrrxqA8xEdE1r07d7o7YZqXworOQGtkn30VClVHYTafQgdYnG+EbrQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 404d9a00-1133-407d-fe75-08d7c5bb257a
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2020 12:53:07.2289
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j+Crf06BNVMz0taRzQ0xjwt+e/qrBH4cliKd1W+Lid5+xRu24zF1QHm8NeMC1WBoP6uoau6rd6sxk06sOk5lPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB4769
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi, Avri
Do you want to revert all or two (scsi: ufs: Let the SCSI core allocate per=
-command UFS data,   scsi: core: Introduce {init,exit}_cmd_priv() )?
Because the patches "scsi: ufs: Simplify two tests" and  "scsi: ufs: Introd=
uce ufshcd_init_lrb()" are ok to me.
No problem keeping them. Just this one "scsi: core: Introduce {init,exit}_c=
md_priv()" is not necessary, since no drivers it now.=20

//Bean


>=20
> Hi,
>=20
> >
> > From: Bean Huo <beanhuo@micron.com>
> >
> > Hi, Martin
> >
> > Based on Bart's feedack, the less risky way is to revert commit:
> >
> > 34656dda81ac "scsi: ufs: Let the SCSI core allocate per-command UFS dat=
a"
> >
> > Bean Huo (1):
> >   Revert "scsi: ufs: Let the SCSI core allocate per-command UFS data"
> Maybe it's safer to revert the entire series?
>=20
> Thanks,
> Avri
>=20
>=20
> >
> >  drivers/scsi/ufs/ufshcd.c | 198 ++++++++++++++------------------------
> >  drivers/scsi/ufs/ufshcd.h |   5 +
> >  2 files changed, 75 insertions(+), 128 deletions(-)
> >
> > --
> > 2.17.1

