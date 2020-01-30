Return-Path: <SRS0=Owrj=3T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 533D0C2D0DB
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jan 2020 17:45:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11D8C20661
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jan 2020 17:45:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="1yf6UXye"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727500AbgA3Rpu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jan 2020 12:45:50 -0500
Received: from mail-dm6nam10on2074.outbound.protection.outlook.com ([40.107.93.74]:6098
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727338AbgA3Rpt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Jan 2020 12:45:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hTfTz4Wf/Me47SGJ5Ocy5MMeTonahR8GCX1/vnF/hBecMrXDCRP9TMISSTcWNsqIs0VWMrJa4IeyS8xaa/Ai89G8BKGkRqWfpHZMlLkBEgeIygc5xlB/CzV76dcTJDTm0j1Y1nGZ22ZrPCAz/4VPOagMDjzlGzXk8mJoLAUYiCvhZQn3N9gDzZxvpOyZ7/L19H6fyn5cwNkwWONnTiTRBsOY6lnpFXalCkARiJkmtAHANLlEmxcxXIxbg8/wOQQV9D538FPXlUIMwQQ/6J6BswFXnLEe9mfU30L+ZcSJykSc+QnFAiFpNpOL5bGxsqO6QmB57rsOcLHa2xzvB8SaWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8/JnzXaOOoCJiiMGaih0Wb8tuXqF3Ptj5bX8IwG3mDI=;
 b=Xf8/c9L+Y9sTqVC/BQuq+ac9T0LIByR835eC12YG5WvfifFJllyNGjmkw9zWMyLVNd/kwELWtHTP0MV0Vqe4moH9uEqzDWXpkeLp0DMax/GThu6thzj/kNNmgjLAJBEyeqAbAWB4zeUMVZVHVSUvg75XpjmgSvOjPwz+tx0odMb0JPHRCHv5TKle0CkSMC/Tky6q2JsuJq3mgbAp6Mswd54JdNIgUTwEhN+xsolOFSJx9XnnOzsf5aLHQHx5Rzv7+23gktFqf1WyQowy9NRiv43SqshMZrH5jZ6VC8Upq8bvrrK9gI16/qZ+7AatWSG8B5QIQjwSqe/mutux9J7bcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8/JnzXaOOoCJiiMGaih0Wb8tuXqF3Ptj5bX8IwG3mDI=;
 b=1yf6UXyeVnEDqGcxxRbRI98qEipPp8DJufjae1mhfZPW0N/Nqusv8I0nZ4nCtCNXdHmFxHu/cDUQCrmm0NoWm/UKnyK8NppUz91zGY+7B2TUXM67GZKmzpVkbuZlcEfmKWiaFhzrFRdE3ELlJZcOLsWnvF2eOHFfi7yEQFMO2V8=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB4468.namprd08.prod.outlook.com (52.133.222.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.27; Thu, 30 Jan 2020 17:45:43 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11%7]) with mapi id 15.20.2686.025; Thu, 30 Jan 2020
 17:45:43 +0000
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
Subject: RE: [EXT] [PATCH RESEND v3 1/4] scsi: ufs-mediatek: ensure UniPro is
 not powered down before linkup
Thread-Topic: [EXT] [PATCH RESEND v3 1/4] scsi: ufs-mediatek: ensure UniPro is
 not powered down before linkup
Thread-Index: AQHV1pJHfu2kpVWabEi+eWXlrU2PdqgDfLbA
Date:   Thu, 30 Jan 2020 17:45:43 +0000
Message-ID: <BN7PR08MB56845828CE1FEAD6A5CB4E61DB040@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <20200129105251.12466-1-stanley.chu@mediatek.com>
 <20200129105251.12466-2-stanley.chu@mediatek.com>
In-Reply-To: <20200129105251.12466-2-stanley.chu@mediatek.com>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.80.131]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 70aee559-bbbc-4e77-a6f7-08d7a5ac3ae9
x-ms-traffictypediagnostic: BN7PR08MB4468:|BN7PR08MB4468:|BN7PR08MB4468:
x-microsoft-antispam-prvs: <BN7PR08MB4468BC2C8AEE22FDF405101BDB040@BN7PR08MB4468.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:400;
x-forefront-prvs: 02981BE340
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(376002)(136003)(396003)(39860400002)(189003)(199004)(55236004)(6506007)(8676002)(5660300002)(76116006)(26005)(9686003)(81156014)(81166006)(52536014)(66946007)(66476007)(66556008)(64756008)(66446008)(71200400001)(7416002)(8936002)(186003)(7696005)(55016002)(86362001)(316002)(2906002)(33656002)(558084003)(110136005)(4326008)(54906003)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB4468;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: X9utKxbvMKmAEFPz5gIfMbt2ouNJjrpEdtHc+VNC0llvECerTrFnMa66r3aJJ7o6ijLLENnynQdn6NqMMnn/9bc/JVBdvzMB8WdQEaw/X5Oxpf+f67CmE1ZrFGpVxlCZ6eoU5Bb5qfPOk5Jdiy/ixtw1GQCMoiyfWFWZekPsCqEYDtP0Xg70mJ80KVhhUgOhE8/YPZvKca9rLKKN8B0ERdyYtlMMXofUah3O5A51IdetTjpf9/jMTndWb+5L5WtEUP6cIBqBDcEmtYAeF1YHIwHil6IAlUf5Gj54lRaWcK/I9Fw5FRC1pX/Fk/pL32yj8dbd2MsSAyZU8s8QFKcE10qUJOFl+yaBWhq8Qtiu2lQZEe5qUGkw2Tp1V/EgQmHGkJfKRCAQ7aNYf6WwbPvcBUywz5hFwlf4s8k455iJXyUImOhdRttxx5FGHXL03XZN
x-ms-exchange-antispam-messagedata: 9/9k4avfESXSpqfopRcl2Fq2n1OLX7Pk7sWWQNOgVTTkytontykB7aV6gFCGW7LDKZ19fGnIwIr6CpH9enbO7OPyBMFjsFXZjiZbyYNq6qmgvPZhd5KLsrnJVTIoDrlBijqPlVn7YB7/OEvUYABl0g==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70aee559-bbbc-4e77-a6f7-08d7a5ac3ae9
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2020 17:45:43.6251
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +lcqulMvbDhiLT9n2SQbjAMO2WyPhwBiOE6ZaBaLVOongPzjZMUeAaNOyJ5krOtcNDZtfq6Ee+RcjTMkTZjR0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB4468
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
