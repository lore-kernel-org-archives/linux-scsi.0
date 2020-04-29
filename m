Return-Path: <SRS0=qgw9=6N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36F70C83004
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Apr 2020 10:39:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0ACE9208FE
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Apr 2020 10:39:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="Nyq5Pu9u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgD2Kjx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Apr 2020 06:39:53 -0400
Received: from mail-mw2nam12on2067.outbound.protection.outlook.com ([40.107.244.67]:6212
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726355AbgD2Kjx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Apr 2020 06:39:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UorJrUs4OFmvU5hG9pvaKCDtz8Rh1Eby3CPSXXpxvpo8uK9YPaRHFTHsSLMp3IthuR3HaZojXB9kRFLuFIM9+XXdTdvwKpXVN+R+J0tTgQ2zLx697V7Z0qTuOYBBuEYURUt3OPRujcF3Dx4522AOt+TOpSausv8nQbZ+NRq6DXDJJylh31r7UURaslVvoNDOeAuBzrB6aAbC3OaVC8mi9UQGT79KUvuHnkpHNtNaQ/5lu3dBKWDW+vtGVAKzrjy9JJEnZniiS5mh1QKFdWJRDDKerSEUvtHx++2uzUGnCZ4WzUop3JqtsWj+1uITZ3+ux4UBfQiJs+7oM8sFA0ygpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4dlbxv0UiZp39mFgTpWb+W2ktS+gFZ1x1aaqYDwEgC0=;
 b=coDYuV/oJFoC/oiDmMfVW0ZLNC0Y3vsJR4OdWdbd5lh/V3byRWJA1C0MbVqIHuCZIbGL5yAqe32O1TI1sHqgHHvErW7h0OE+DZgbl7jU1yIQR86Rfl1D2aorCYOtqdEAtNskt7d6DfKkZAynZDSe6CQ7Ntu2Sua+vBBUcUdv59ZsUfr9C0/cCiFt0S09A6B8nTisrsB3cBW/36nWba4DaUUsSXRkVzM02Px5zjVF0V78eR63ZCh8Zy349t+j4Eccxh7C5+o0bOyf9mbZw2ApFPur9RKEfRXuy2EklUVkDwK+UdzcPyJHx9kxICBXKcp34Xn76Nr24AHeNqdzuPW3vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4dlbxv0UiZp39mFgTpWb+W2ktS+gFZ1x1aaqYDwEgC0=;
 b=Nyq5Pu9uza6Me08UqV0tfnQdK07553TmdE1rKNbGeloYAKgzxXLGkvUeCh5AD8IRkKmPhiT4YxGgQRncRoM9PUyj/cXs0MqxmZSDA9QK1ByZkNseYj3+5b+WqcENgAzVzQ3zI3F1JIc5AF1jz1gy1mRk2I0qiCuXULvvN64GEhc=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (2603:10b6:408:35::23)
 by BN7SPR01MB2.namprd08.prod.outlook.com (2603:10b6:406:af::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19; Wed, 29 Apr
 2020 10:39:43 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::9ca2:4625:2b46:e45c]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::9ca2:4625:2b46:e45c%4]) with mapi id 15.20.2958.020; Wed, 29 Apr 2020
 10:39:43 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>
CC:     "cang@codeaurora.org" <cang@codeaurora.org>,
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
Subject: RE: [EXT] [PATCH v1 3/4] scsi: ufs: add LU Dedicated buffer type
 support for WriteBooster
Thread-Topic: [EXT] [PATCH v1 3/4] scsi: ufs: add LU Dedicated buffer type
 support for WriteBooster
Thread-Index: AQHWHU4js/KCzjn0Y0mn6kvIf9GJz6iP5o5Q
Date:   Wed, 29 Apr 2020 10:39:43 +0000
Message-ID: <BN7PR08MB5684630793F03282E4C6F3D7DBAD0@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <20200428111355.1776-1-stanley.chu@mediatek.com>
 <20200428111355.1776-4-stanley.chu@mediatek.com>
In-Reply-To: <20200428111355.1776-4-stanley.chu@mediatek.com>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLWI5MDUxZjdiLThhMDUtMTFlYS04YjkzLWRjNzE5NjFmOWRkM1xhbWUtdGVzdFxiOTA1MWY3Yy04YTA1LTExZWEtOGI5My1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjQxMiIgdD0iMTMyMzI2MzAzNzgyNDkxNjM1IiBoPSJ5d3Z4Z0JGbStYRXhBZXpVdkRSL0NSRFlGS1E9IiBpZD0iIiBibD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFIQUFBQUR6VldWN0VoN1dBZWU1dk50dGp1b1A1N204MjIyTzZnOEFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUJBQUFCQUFBQWYzT0VLUUFBQUFBQUFBQUFBQUFBQUE9PSIvPjwvbWV0YT4=
x-dg-rorf: true
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=micron.com;
x-originating-ip: [165.225.81.119]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c825b6a6-acf8-4ba2-4a39-08d7ec29a0c9
x-ms-traffictypediagnostic: BN7SPR01MB2:|BN7SPR01MB2:|BN7SPR01MB2:
x-microsoft-antispam-prvs: <BN7SPR01MB20E3FBB7A48688C9823C4DBAD0@BN7SPR01MB2.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 03883BD916
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tQO6dB3Rf7/YoqN5PgjWSjVumBdhqIdmAt/KMDFWumgX77WhAU9SrNxBSJlDsSJoh1LGRfdexWP1o0o/Pk60oxPqI2GRUMl53G66lXEHT5lmOm0I2OiYLOdKKb8zHwz12S460/A98R96fEQZMa8ZY9Zo8VTotOuruIL7VAIF2tw9OptE/viRg9U52JB/qjxn5OeYPg4YiAB6Kg/U6MTsms8HMJaK6uTZ8314PsQGmlIEdKDI8v7ufaAMFvalW5nTmw+0WiXoJdEpMATseFEG7/RcphR0SZzKPseERLExGxkrFbWBro7HIng6yvodHqXCHZ85u4LGiISobuxL61ePgkb8rGXdl3IqfGLf3XZFWzPjQxfxZ0wgnDkRD+DXX9yRXuyksND1SRgLEk4Hn5VQMOau9LIZdmmANMWioeeJIQ6vry+FtpL0QinxGBDh0ypv
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR08MB5684.namprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(39860400002)(376002)(396003)(366004)(33656002)(7696005)(2906002)(8676002)(186003)(26005)(6506007)(8936002)(71200400001)(86362001)(478600001)(7416002)(4326008)(9686003)(55016002)(55236004)(558084003)(76116006)(52536014)(66446008)(54906003)(316002)(66476007)(66946007)(66556008)(64756008)(110136005)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: prMJlFOy4tWXyE6/uo5XiKa3pSWfrxZX3m0E5qaMW0+McYvEeA1DPgZ99f2F62xvWJWV7fu0kh9uTTQQOKtNV7de8tOuABFSxXe1joAQKxaFadqytBjhM1XhrmF8pL/DmA2GSDZlg7mKQr4nc6pIDFBDla7ArayoblohrLzZvuZP380XWyeVMV6GV0lCdNQcDUx7YpB/JVmMssKlWRKtR+zYtuoDJazB8nmyt07zf70Icxt5yNMyevQHNJGqqAYM5Ygdni/HiO77pAA0VCH9LLzXtNbSlntMkHH09a7VvyqduM8/Y3kIv5uxUK7VFFWcHP083nBTTTEXuw5tiDGf3hPSB9tqhv8CCumxZEzc/KePBcnnfUhOF0vQdXkO1whMaJXWv5DAS0nikfjT1L1Uu5y8kaHejTFen9dtV49D9dkf+3D21t1gptsChUUp9yHRMb6IuFQTR8q30zrEBWp79P5mB0LK/ABOHe5VFIKGxl3KEV7P9ER/MQ0uwEd0w1s0XAhqSz0rnXBjPJ3GlX/8VzIhXw6ko+i4/qdzDKNSpvIuQoSdtoYPTr2Pff0NOKLdnT3se3uIx8zBVKwKVb9fJmVPdlSSMAyXx5ieLpOD01wtQ5/OHQ6RVhweF9wgMQ2uIb/fhBNYhNyIhKFixni5bsG1y5Qgg/izZBiOmKlC2oPWs26VzHHvxH6ekRMBGV7E7rQ3cyvkCeyLpAuOC348Fr3xBJHiDWLz1pAKEyjmgWx0zrwnq2vADLnwQ4LyuzqxnxbAE64vsVnJfYYfxY9dIZP3CYk6m5zYTmle0MyI8yw=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c825b6a6-acf8-4ba2-4a39-08d7ec29a0c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2020 10:39:43.0815
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k4nDGO+qbebc+NzePGYf2k6GJayohoBJJdumNBzSri+Wgv9EbqnvCPEpDfGy5jAMRDF2T3KidT2OdstcN9uNsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7SPR01MB2
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> +/* WriteBooster buffer type */
> +enum {
> +	WB_TYPE_LU_DEDICATED	=3D 0x0,
> +	WB_TYPE_SINGLE_SHARED	=3D 0x1
> +};


Hi,  Stanly
WB_TYPE_SINGLE_SHARED might be WB_TYPE_SHARED_BUFFER.  I think,
we should try to make the name definition correspond to Spec


thanks,=20

Bean


