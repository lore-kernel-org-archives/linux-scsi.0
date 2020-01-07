Return-Path: <SRS0=hsTv=24=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12BAAC33C99
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jan 2020 09:16:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D33422081E
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jan 2020 09:16:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="33/ltGgV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727642AbgAGJQK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jan 2020 04:16:10 -0500
Received: from mail-co1nam11on2065.outbound.protection.outlook.com ([40.107.220.65]:18479
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726558AbgAGJQJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Jan 2020 04:16:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=agBsy/jrPf0B4Iab4vSo/C8LcPjxR5ChO3ZCtloAQOBiBO6Ks0nDqDz/XCIKMgmEsOYF30KtPSjTDJ6bx06KZcifvBmQgmH5ll+u77p4UTe0q94/1Vp9mUBqoRTTyCOKxyNLFqMo4X6UeqD+WSOnbsK7ewBRnLqV8V7eMJUAW33QkpvTLU6AyVslkb2lbfWe42xGqHG53Oln7h4ZVkWcJpDRUrHD+WW8SA0+Bp+WoWagMtla05OUn1Q4TA0GitPcF4pL1sXxL95149C+qShzSRQnzvRu2bz/h0ifqT8w5RBL+/5J2GUUANZhajduTA3scLk3Gw5IDuHoETND6ZP/dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZTDomqYrN/WvPtLGjg+YTjp+hmq3bXyMaVRmPL8Oag4=;
 b=g/upcJ483i6Ci92rvop/3QQxVba/Nv1pw4VhgOHPWQVOujORxFakAygz+STFnU+ltedRlxiXIiBxMnWIvqXu5gBsQ8SZFpS3qt+Oq0WSoynZ36mbZieB7LUU7JAWfCF7O0l7dbcqjGIm/ObUydH7O0C7WLmEN7dpeawkd2qNXArvOftRhcWwgKngDi2rzMwe8KXfy5kXaVDMnARrJsmpVS71hjqsVS+FMa5zgKsATgftilFbzHn4xuoK+c5OBdZDd0fqljcsT/zLnxGQ2TDhx0HbdUXHQSfYyvFHRzLHpax6lewT13X55i4LLsxz8H9KmDzAUrdIS45oJUY2ivCUqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZTDomqYrN/WvPtLGjg+YTjp+hmq3bXyMaVRmPL8Oag4=;
 b=33/ltGgVCCo6FgNd5PkEowut976MktMlyHyTKIlTUbJbtcZbTxchgiIHhBeygtOMNIeie9h7e5LQtNRNY82T8flW9kj1/MPB3eu+WsBQ4FTN89XJdA9ls1XxQun2e6wvObgLDzmSSkMf3KbvazCvAgaw+gDTZSm9NDOHUQDBQs8=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB5123.namprd08.prod.outlook.com (20.176.176.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.12; Tue, 7 Jan 2020 09:16:06 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11%7]) with mapi id 15.20.2602.016; Tue, 7 Jan 2020
 09:16:06 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
CC:     "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>
Subject: RE: [EXT] [PATCH v2 2/2] scsi: ufs-mediatek: add apply_dev_quirks
 variant operation
Thread-Topic: [EXT] [PATCH v2 2/2] scsi: ufs-mediatek: add apply_dev_quirks
 variant operation
Thread-Index: AQHVxCgRQlkyWmeZCES6JiJKGQMiW6fe3rgA
Date:   Tue, 7 Jan 2020 09:16:06 +0000
Message-ID: <BN7PR08MB568474ADD8C6853D26A361C8DB3F0@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <1578270431-9873-1-git-send-email-stanley.chu@mediatek.com>
 <1578270431-9873-3-git-send-email-stanley.chu@mediatek.com>
In-Reply-To: <1578270431-9873-3-git-send-email-stanley.chu@mediatek.com>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTU0MjUwYTU4LTMxMmUtMTFlYS04Yjg3LWRjNzE5NjFmOWRkM1xhbWUtdGVzdFw1NDI1MGE1OS0zMTJlLTExZWEtOGI4Ny1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjI2NCIgdD0iMTMyMjI4NjIxNjQ4ODE0MzMwIiBoPSJQL2NaaTdVVjR3MWVrTHZvMVF6eFViZElOZW89IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.81.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 87e5fbcf-08f7-4293-2010-08d793523a36
x-ms-traffictypediagnostic: BN7PR08MB5123:|BN7PR08MB5123:|BN7PR08MB5123:
x-microsoft-antispam-prvs: <BN7PR08MB5123D89C7AD1F5D6B8205B82DB3F0@BN7PR08MB5123.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:400;
x-forefront-prvs: 027578BB13
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(346002)(136003)(396003)(366004)(189003)(199004)(66476007)(64756008)(66446008)(9686003)(66556008)(7416002)(55016002)(55236004)(86362001)(66946007)(76116006)(4326008)(478600001)(33656002)(6506007)(316002)(7696005)(71200400001)(558084003)(81166006)(81156014)(8676002)(52536014)(26005)(54906003)(8936002)(186003)(5660300002)(110136005)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB5123;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VMrzhLhCJtl3OJDL+Frn0kTSYHMmjX/BMLz2O95EU401IUIGElq1kH92QuSlTVNpSN8MUa7N9X0j3myiWQLtCm5QzVvxOjtjUX0u4ffS+CrWKpt5MsxBQ8DtiItswDiJF/NFKHG3/tgNPsDWS0r0NkO/D94d7nKIiCwqKHpPUgfDkBYwRVu1irq9TeWGlFnf2wAndbMIuuT7IiiHUrz2bd1qlLsgfXnnZWhis00kboO9qSY9eKqAzjHKdh3rt/njSrLbOrjjfPjvNdb+kb9ITXZcKVTFdBRsUJt7Xg3ZT+IDAsDb0G+7W9b1GzIAQ7E+8Kteovsn4HasXwwOnfiOvVzlFSfy2k/y4t5OHE7B6a7hpBCbLOn6QjG4313Xp3NoLZ3b5kD8cbVYO+Y7zbUrlHIAlPkfy2bUxDglPoFXIFfnOstZr7Uh9+kpO4mPI4bq
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87e5fbcf-08f7-4293-2010-08d793523a36
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2020 09:16:06.8548
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d8k7CVfXqvkRqJ3EXrI0HOw2kk0BraYrRvnmchuIKUy3aHHZ8uo7reUGzMpSMWV3QBYESOaRerioz5MMuK3rfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB5123
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Reviewed-by: Avri Altman <avri.altman@wdc.com>
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
