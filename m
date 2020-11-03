Return-Path: <SRS0=0yur=EJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49DC6C388F7
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 15:45:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0061322264
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 15:45:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="m7/KXnMe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbgKCPpq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Nov 2020 10:45:46 -0500
Received: from mail-co1nam11on2087.outbound.protection.outlook.com ([40.107.220.87]:13793
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728083AbgKCPpp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 3 Nov 2020 10:45:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IM7hZ+vD4e4gZPLY7IHlT2pTIQGbBmLF3TysrtCLDfvd7ysHgE2GtyTyPYIFsQrG22hOucNhJKKpLcVdVI8Q9iMUPHFOZdh6kzS/90ct9AOCW9fiOxojsJPloqk2ijf8eevKe2MV7uqLbHZ30ldpeF2+B0ZyHnJVZjhXoktREYChrZzVPg1hI6zx6EuiVA7XRU8Apim2bZ1s8hgR6EcTqcUpjk8m/BVLX3Hd+TmCQlrWZNmdq3Ks2idNto2HBJ/ooHb7+ghGTFYyogHQuxROT61LAZ+6shTFPhPCROQXw46j2ep1bgAVGBSoXSXLa/rgf4Hs8VJ5/POegz2/stz8wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RVQ9C8w/JDdzzHQPurL5pjZcd63xltdgTZYBfgccgO8=;
 b=RtSQzbl6N+zPZt/H44nN9xUP7BN+EgSnHBInU6rrLtRV8fk0mvbE48lmpep07ONLVEzDqVQ/zAnAu5epusV/hE0XxXdFonXgfi+bpRlrXZrHH7X3ISEFR9wR89QHPsZurSHAqQEQuUQcmJcvw/N6ig0QlWfCQoJ8VhPBG8e28nHkNBFNx7ZAETm8dSgyAJXtudb6t1biK1rSobVqptNKTLDYuFMfF6S9I5JCWkf7WhtZ9cTwqi2Wt7ZV4of4qKvYmUvTR5aSetMJTWcKNv0KRMJ0r6MJYfrmPwF25/24CJu2g9QQd7kyIr1K26TrFYFhxj+v6EurZKq+ZjPlnUSICg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RVQ9C8w/JDdzzHQPurL5pjZcd63xltdgTZYBfgccgO8=;
 b=m7/KXnMe7c1fRKALPb5jIayB/mmgN8RvRjFERqtQoey6KwGlg0LBCtAv9yARw6Qbdc/4nfUQzY2hzCsBTgeAc0z1MjcvJlo2JBVolJqrcn8rOecX2IDPbjklsQbbjb/KiLvdwNTiLlDq+QKLDwtp6CogFBFDx4rDwD1/J9ePkNI=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (2603:10b6:408:35::23)
 by BN7PR08MB5682.namprd08.prod.outlook.com (2603:10b6:408:e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Tue, 3 Nov
 2020 15:45:43 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::75eb:84c6:b0b8:b321]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::75eb:84c6:b0b8:b321%7]) with mapi id 15.20.3499.032; Tue, 3 Nov 2020
 15:45:43 +0000
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
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH v1 1/2] scsi: ufs: Fix unbalanced
 scsi_block_reqs_cnt caused by ufshcd_hold()
Thread-Topic: [EXT] [PATCH v1 1/2] scsi: ufs: Fix unbalanced
 scsi_block_reqs_cnt caused by ufshcd_hold()
Thread-Index: AQHWsaoK1IQQRJA1LU+0X4b1eoDW5qm2jSUQ
Date:   Tue, 3 Nov 2020 15:45:42 +0000
Message-ID: <BN7PR08MB5684829C26DD19ED861486BEDB110@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <1604384682-15837-1-git-send-email-cang@codeaurora.org>
 <1604384682-15837-2-git-send-email-cang@codeaurora.org>
In-Reply-To: <1604384682-15837-2-git-send-email-cang@codeaurora.org>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=micron.com;
x-originating-ip: [165.225.203.43]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 29405ca6-8ed1-427d-a4e1-08d8800f85db
x-ms-traffictypediagnostic: BN7PR08MB5682:
x-microsoft-antispam-prvs: <BN7PR08MB5682F55513C63E703E880A0ADB110@BN7PR08MB5682.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:400;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DbMvZ7xilKfDhaAaQiPqk4RRGRZTNpY9C8j+U4iXkAZRf8CM85vDhneIVORfvWbwWyAQgmHBZVjTPTFTmw52kUOE0aoxsbeRoblfJ3n8n2J/pkYfRx8LXTytakFyX58BGPjjep9Tg/6CloKRinhDRZ9hJgidMsgTn7bFHlAnxOOWJhdt8p0bgpBTWqY+ubSpDwx2KFkLskRphD++apR832Xpwtr/e9yBRNYA088pIr64l7D6HTIVMPAhkPUS1hsMRg44UBi65Nm1eyF269PKumPO0Wj8M6voZLSj0nTkj415cDgagOy75r5b3R2zoKpH/ppKhyxkmldA2JC53aE06A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR08MB5684.namprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(366004)(346002)(39860400002)(396003)(5660300002)(9686003)(186003)(55016002)(7696005)(52536014)(4326008)(8936002)(86362001)(558084003)(66946007)(66446008)(55236004)(7416002)(110136005)(478600001)(66476007)(76116006)(64756008)(66556008)(6506007)(33656002)(54906003)(71200400001)(26005)(2906002)(8676002)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: dHGlZBV2bj1WEw9U2jIRv16O5lEBGvVUCA6oLB3vRgXny3/dE9PH/hbAXXV80aciABbiAFBrPxOzGU/Dw1jVpQlHUvIYRGVf1vnfKzEPpQQwcBAJJP/Pun70bbvl187aTqFu/bLDFOyoWSVLVF4lbTMwPfoMN6VvWuG87uQ7pz/Mow6gktGHbZxPG5dcPVp3q71Hm8dDvI4d9wRTp5tVCRQwhTdzVc5qnXXnlNEk5fL7m3Dm4sVtq4I/PpmL2DmgAwPYoE/jUqqVMu+OPTBMpR4oLCKOFJmPdtYWeUyUh8npV4G9tB24m3kQrcmosHJ4BWB3ezGchZ3uoUvP0xv4YYuMryLw8LzlkIGKX0YL5qSsru4cb6YLLQgaBqFwt6VLYwXfwS4/YVGbPfOML/SVNAB0rcWNSgsJtk5pLVTIhLgT8+x4IdCncrdYrkV2dsjzM1h6kbky4vbEaPYAD5ZmENdqpUsRXDmANRtS9MpPS+dZbFd/Sxc5DEVX5PgbvU0fk+nS6KEwYUtcLJchZ/MYfBiaGbl9ek/wLWm9nVilvObY/4eggo0h6Bd9/Cf668xyXfLE7wIlcHYD6btUQspL5Rg7t9RGVozLKVZWSODZUi/iE5DD/bHTqf4Wdsq4zEXpAd1/wPbZLfzCfWh1YoU4ig==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN7PR08MB5684.namprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29405ca6-8ed1-427d-a4e1-08d8800f85db
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2020 15:45:42.9915
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4cUDUbem5JWSl675Z0TCAhOsppqT9kD5AI9Cb1TW0LxkOS4THJ8hHa6dYAqZhpXJmWbJJ6upWqgrE9rNNy3C3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB5682
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> Signed-off-by: Can Guo <cang@codeaurora.org>
> Reviewed-by: Hongwu Su <hongwus@codeaurora.org>

Reviewed-by: Bean Huo <beanhuo@micron.com>
