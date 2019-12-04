Return-Path: <SRS0=+pba=Z2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D755FC432C0
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Dec 2019 01:45:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98AA22068E
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Dec 2019 01:45:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="eN8Ce7Dd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbfLDBpM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Dec 2019 20:45:12 -0500
Received: from mail-eopbgr790051.outbound.protection.outlook.com ([40.107.79.51]:54144
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726107AbfLDBpM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 3 Dec 2019 20:45:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XsqnFOBq6WmkmmMqjcQIJDVdUY8WBTkFRYRU+EQUoVSdSch+to8x15OnlWeQk9asToNH80Hv37ixw6W5maFSK/j4ayrQbAor7jFeZPTG8AKDb8I+33RtCz0pFuJHXpMb87cuELYacuTtwVBbhJJcKCOrOweKrYGrH+z+QBOpicCyKgGGiuW5ZNkBGHqM1wSGG6DVNtMutL1UOJBY5jAblvg8FpIzdHSPM92WISIvHeTN4umOyYFBO2Z12Uk+GHB3CCMjWD3LFP3bJzposwi5jBvf0x17aDhrJaIB5gYoQZosFLAc20XgCRT2Z+ekdyDDGMZaH6bMLU47COap8TIOeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rvH99oyk+DJnMWdWXtkTMNeZAbblvOP1vZ9RuBX7u60=;
 b=KP0zN+xhq5N7h73q7fl9baaS1mXONHf29ElzJtQJYzLBBiTIJE/hMtXDPEA6apbLKfSH5sO7bMQLMYICvfgs4HLDVwQYCKNhWdH511EWrd24pp5q1oxH0iRocRbwIQsJyWidKnDFcUgTdD2U81uJeYcFuuzFf3mav67VnIBiGLKVZhiUddpp/bR7mhoDKNbBgvNlauSzczRO9e/XvkNYIdyJkVYrfqu26NXSrGkk24Ts03AGJ4tJBBVb3zY2MmKWAb2/xP6TyMEeAlybVqMk9jWmyngdDAjJI/cJ5ISc4WzhF4pTuFLBhuCQONW46elPaZndSqsWbt+kgmRDbSeGQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rvH99oyk+DJnMWdWXtkTMNeZAbblvOP1vZ9RuBX7u60=;
 b=eN8Ce7DdiWxDQDsow+/hT9G3BkMvt1qp9aa0w1ov0lfubigNt9nyeWU0r9PkEv87KE7oRBVaomtyD6+SNkwE2C7xjQZHUk/UAj0ci8Q9KNsCxjV5wH/kcK1bZGCsUwqKWcgcKafWb3e8JT/tdYJn3b/g6nUfgG4499PJhdOTns4=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB6035.namprd08.prod.outlook.com (20.176.28.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.17; Wed, 4 Dec 2019 01:45:09 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::28af:57b0:8402:1d1c]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::28af:57b0:8402:1d1c%5]) with mapi id 15.20.2516.003; Wed, 4 Dec 2019
 01:45:09 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] RE: [PATCH v4 4/5] scsi: ufs: Do not clear the DL layer
 timers
Thread-Topic: [EXT] RE: [PATCH v4 4/5] scsi: ufs: Do not clear the DL layer
 timers
Thread-Index: AQHVqOQNwDcb8USDR0+gqvh+u9nzJqepM5Iw
Date:   Wed, 4 Dec 2019 01:45:08 +0000
Message-ID: <BN7PR08MB56849D5E6A623C1AA37C5F7ADB5D0@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <1573624824-671-1-git-send-email-cang@codeaurora.org>
 <1573624824-671-5-git-send-email-cang@codeaurora.org>
 <0101016ec584a776-2140a805-4b1d-4a3d-af0a-f073425be2d6-000000@us-west-2.amazonses.com>
 <MN2PR04MB69916189C31D58EB6DCB71E9FC430@MN2PR04MB6991.namprd04.prod.outlook.com>
In-Reply-To: <MN2PR04MB69916189C31D58EB6DCB71E9FC430@MN2PR04MB6991.namprd04.prod.outlook.com>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLWIxOTdlOTU3LTE2MzctMTFlYS04Yjg2LWRjNzE5NjFmOWRkM1xhbWUtdGVzdFxiMTk3ZTk1OC0xNjM3LTExZWEtOGI4Ni1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjI1MyIgdD0iMTMyMTk4OTc1MDU3NTA2MzE5IiBoPSJLaDRUNzM3WlYrS2hzY1YxZFR5dEVmc0REUE09IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.86.139]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aa31b492-2a3d-41a7-bb44-08d7785b9861
x-ms-traffictypediagnostic: BN7PR08MB6035:|BN7PR08MB6035:|BN7PR08MB6035:
x-microsoft-antispam-prvs: <BN7PR08MB603555DDBE6CD96DC6F27478DB5D0@BN7PR08MB6035.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:400;
x-forefront-prvs: 0241D5F98C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(346002)(376002)(366004)(396003)(199004)(189003)(316002)(305945005)(5660300002)(81166006)(7736002)(33656002)(74316002)(7416002)(4326008)(99286004)(66476007)(66556008)(54906003)(6436002)(66946007)(64756008)(6246003)(186003)(2501003)(66446008)(76116006)(110136005)(9686003)(55016002)(229853002)(558084003)(25786009)(2906002)(446003)(11346002)(6506007)(256004)(52536014)(14454004)(26005)(478600001)(8676002)(71200400001)(86362001)(6116002)(81156014)(71190400001)(55236004)(102836004)(8936002)(76176011)(3846002)(7696005);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB6035;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UIWMT8WvzujSzERHyaxt7Hb80BM5/BEmjMmTPCZ6pm/aCH223/Qe0MR2kYi/bOHMxKsi0w/9yql/p5k0YOL4aYQHea/uqEHeaWsZRt+oZ3OjnechjJ4xx5c86HjNRYkAUB3Vov7RfSIMIuuUI51tpp18RR2xvDI/KG0gzk03FWbwXi6IeJSb10WBzcTUFahl7c2phRe3M3QkyAMM07CbaQ7QlDhahwu+2hc6/+1+43SNI+NEiTkGLQ7wZ0eDKNS2aRyBnmUrTDgoGrpnSNvPg3f1AKnE6kHFIWz4xT96Wil/bEa7K2Oj0PnIq5u0rQ22+8RYnDV8y3/Ynqq/8fi7E8dLiObvssRzVCN0iNLBfMym1OujftfsdnrLQuhGSr30XKMhFeLaKBPo/C61hE6h2xwQ5HF6KGf21Lu7VB1ybzg6ga1WtYLa+LgFr7z3k26i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa31b492-2a3d-41a7-bb44-08d7785b9861
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2019 01:45:08.8064
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UQ0k+uvChgmSxh1nI+vVk5XF/j375aKW7b+OYQJdH47iLME/9tbI5tohtaRtxQKI0kT9Q2szFqNzLkbuTFA9Pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB6035
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> >
> > Signed-off-by: Can Guo <cang@codeaurora.org>
> Reviewed-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>

