Return-Path: <SRS0=WdRn=3Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0358C35247
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Feb 2020 15:26:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C6F02082E
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Feb 2020 15:26:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="SpiU8x+V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbgBDP0w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Feb 2020 10:26:52 -0500
Received: from mail-co1nam11on2057.outbound.protection.outlook.com ([40.107.220.57]:6211
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727305AbgBDP0w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 4 Feb 2020 10:26:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dlQquD+IfzzN7yv2s/ogRhudL2+241miFfzXnBJlZvBbLalBs8MpSke1SHmnIgPpypYn20F2kuezNWyygthgKlmPTRdZuujfx5dulraCefokgGkpwxtAMJbX74xgw+C4sn/OoTfJlIgIZ9EHmRWkOgLDqcf93aLZ8WHBB/gZb0pE7R5uNPYq6nh7Mp2wGgwMO8Ak/hVwNWMS433DAFbRs0mVgETVfiCZ68NJpeSKshPEbPKKefU1JaCpkPRE8adiskQDLT+owssVGuM8IX2WsEJgzQ7it5PruJTSgvQp2IPH8RT3imxjAHimevG6kFneVxe2nmwSMTWevfxkd/l88w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mcRwUXMUwiT76jxxZFCdt/zZpVvyqne/5CFJ03mKLaA=;
 b=lcging3dyp9SPcomsIYEi45PVUgxy6/KjkZ3vRS81rwndCuEPN6t6ZVH+SqEgzwdR0Gx/VoNtybVJ8XS0FUjAi8yMWOgyL/l2aoRfta/D4+JQhNpHt/VeiTuvKNhRSse60GUgfzb7kfOZeZV0akuzjnPCmMLgf+5ixPNuQR+DTil2Plwud6m/IqGqvXtdfD9AIRwUzKL27enefyuoRpUA5iXENZq/11pdipXL7TWKog9lro2NdqZeUHvOV0QiOULct8E5J2Fa2TmKSxPgjXHvzkm42adF91tyr2FJ4ZypZAoVr+u9JDQTsW31cy5FEBK95nXuYUJJBMWLSUVY7Ydsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mcRwUXMUwiT76jxxZFCdt/zZpVvyqne/5CFJ03mKLaA=;
 b=SpiU8x+Vfl00MkcTH0Mcd07YsNsvXPT6MlVra0s2+1/ZEU4bxIBeYrsSg2g0VL8t1xqFTM9D6XtcuszBWS/Ak6Le3vZiArNWr1/qweBi8y78tccL0nFg/bx/fXCNfl6CdwPsB7Ere6Ez3dMYKnHPD5KodyCj+vx9sWjgv8iSXC4=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB4227.namprd08.prod.outlook.com (52.133.223.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.32; Tue, 4 Feb 2020 15:26:49 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11%7]) with mapi id 15.20.2686.034; Tue, 4 Feb 2020
 15:26:49 +0000
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
        Allison Randal <allison@lohutok.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pedro Sousa <sousa@synopsys.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH v5 8/8] scsi: ufs: Select INITIAL adapt for HS Gear4
Thread-Topic: [EXT] [PATCH v5 8/8] scsi: ufs: Select INITIAL adapt for HS
 Gear4
Thread-Index: AQHV2nLv+dTQRjz4f0qK4QgoeaM796gLKgdg
Date:   Tue, 4 Feb 2020 15:26:49 +0000
Message-ID: <BN7PR08MB5684198FAD001E147CEFA904DB030@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <1580721472-10784-1-git-send-email-cang@codeaurora.org>
 <1580721472-10784-9-git-send-email-cang@codeaurora.org>
In-Reply-To: <1580721472-10784-9-git-send-email-cang@codeaurora.org>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.80.131]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1f522fd4-80bc-42e5-d29d-08d7a986a765
x-ms-traffictypediagnostic: BN7PR08MB4227:|BN7PR08MB4227:|BN7PR08MB4227:
x-microsoft-antispam-prvs: <BN7PR08MB42274703ECAE604EDD3F8C1BDB030@BN7PR08MB4227.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:608;
x-forefront-prvs: 03030B9493
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(136003)(366004)(396003)(346002)(189003)(199004)(55236004)(6506007)(4326008)(2906002)(478600001)(186003)(33656002)(8936002)(8676002)(81156014)(316002)(81166006)(54906003)(110136005)(86362001)(558084003)(26005)(5660300002)(66946007)(7416002)(52536014)(55016002)(71200400001)(7696005)(66556008)(9686003)(66446008)(66476007)(64756008)(76116006);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB4227;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tL4wDnaTLU1FGYkCIIw2s7dZGABabHOfzlLE0MPXNr5rqdH+1imWSJ8+excSyiHx4eOAyhLRBeRXdxwvFg3npNLTeo1cACSXkBjiaUFEwwROzBCRVtvEcX8Ql4zYKaba2emLJs1LA04k/EAd26EjFqndJV4FpqcBIaGzJJP+QUzvibnPvAo4p6suj1WozaZIrd7worWe6k9tkN6Pl4BLuN6KY5gjdnph5GgXScphkcEMRSnfZ997dm5JGya35Kb7nQ7a3/5YFPr3N6aqNIOq3/JRjbuvDclE1Uk0tvQODkHBKEm679HGVz8mOj4v0BsllEaCO+yMIIpNnfXzw/385xlSAKJJ/ZCxGwsMDANSWsZ52GlJMcbw750AqtIs7hawxZUPQknE0r+5yUNVhMoo6l+8ic8BKrOC0QumZxwjrMCeDL4Gde09e/cCTXQrLdQn
x-ms-exchange-antispam-messagedata: kinerKKcd0ewYWA+CEO4ptUpyzz3pC1aZphNJnURU7P9zgM3qWY+pLsWOGdEp3yJoX8HLASzQzVaCaZziTBCzuZdFG8OMIJi+myOf7TIDmv6gjUz1eNi1NylJb55DWtQrdyGNEufT+wZ82YGfd65hw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f522fd4-80bc-42e5-d29d-08d7a986a765
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2020 15:26:49.2285
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dUN0esfodP0rxSv+FMd2SshLn7pkKaiHU5Wy1LPXKmJpoysUMgDUP3n1YJSWoGdWW6Fv0HL26gDmPzn4qZiM1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB4227
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi, Can

>=20
> Signed-off-by: Can Guo <cang@codeaurora.org>
> Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>

Reviewed-by: Bean Huo <beanhuo@micron.com>

Thanks,=20

//Bean
