Return-Path: <SRS0=JOtj=5D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEE29C4332E
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Mar 2020 22:11:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8E2020752
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Mar 2020 22:11:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="RvdYJOmQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbgCRWLD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Mar 2020 18:11:03 -0400
Received: from mail-eopbgr750088.outbound.protection.outlook.com ([40.107.75.88]:37470
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726704AbgCRWLD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Mar 2020 18:11:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FC4I5stk2RLRZJQN2BLDlkx3J2COzWLsh0/pHgKxaryRFIm18d0cpzj7MHkOtnvVfFEiGkCs59kbmrU4zoc5x5vgPYPGrR6ehp+IR2sbXGRJa/lOdJ7Bcrb6ffWU9p3rMAFwWBG6IbZ4izZW+tY9NWIY8IRLGrBxHgTV/fxsMmySMAJiymC0lHvyXoKD74l1ckmRVjJmo81D2XEZw22MWaZq71AdW3Kqlu6MezWgR8p7eEdipELlsWzhvxA7c6NMj8L6qu+CwbxZY+E8W6HyQaO2wB4XqXEtGsDxrCmxxL+sWFNtYKNEwKMbFkcPDpw72LQc6choyWfRDXMxYIWkpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=go/vcjLmvP1u+5ACtJC3EOXj+oGcQTyyQCblrOo76HU=;
 b=SOV3GaX4q1MwHo2xMpdvfcoInlinSWQQYLoC3isrDOdMrsRmkaym1Sqf2ucoXC4EAdoqwiR9XJTeldiTap8GOVQntjIiVbvhfLIttiMsh4Wi4wa/43MxbDX2dFpOH/MRmAZ/tledAw29k0TQ+APlhH+pd/fTMx/CwDP+c93gDq9rFJv/zeS5SCQGRncs0Zb9Q0uLVxT1BPqOzTjE75zNHdxAg90mqfIG44PLaQnnbpUlacKcFP1nbXCJgbfQWoqrt5fZm90EVaou/32v8El70t2t2x1wXF2PGEDuOtZ8J7EmaEyFWVKCWCwpacz81gz8Ejqt1ZG8pL6P6M+JNvxNqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=go/vcjLmvP1u+5ACtJC3EOXj+oGcQTyyQCblrOo76HU=;
 b=RvdYJOmQYA+15kV1D5+5Liix1BkmvdDpBFijbAAidswc2oUPvfN35jvtGF5cL1bQbHKkoNmM1VPge5EuLCGK6Lw2zXd4yxRCcDucamdkBoSgyZz+GGCXsE4flLaOIGINBvueD4vk1ITG76nXCYgFgQpgMcEI1P2qP7/3h8UgUys=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (2603:10b6:408:35::23)
 by BN7PR08MB6068.namprd08.prod.outlook.com (2603:10b6:408:36::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.16; Wed, 18 Mar
 2020 22:10:58 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::589d:e16:907b:5135]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::589d:e16:907b:5135%5]) with mapi id 15.20.2814.025; Wed, 18 Mar 2020
 22:10:58 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.peter~sen@oracle.com" <martin.peter~sen@oracle.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>
CC:     "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>
Subject: RE: [EXT] [PATCH v7 3/7] scsi: ufs: introduce common and flexible
 delay function
Thread-Topic: [EXT] [PATCH v7 3/7] scsi: ufs: introduce common and flexible
 delay function
Thread-Index: AQHV/RGnPsqiA4EvtEeou0tltjIAGahO6EyQ
Date:   Wed, 18 Mar 2020 22:10:58 +0000
Message-ID: <BN7PR08MB5684DA8C4FB4304CDAE39440DBF70@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <20200318104016.28049-1-stanley.chu@mediatek.com>
 <20200318104016.28049-4-stanley.chu@mediatek.com>
In-Reply-To: <20200318104016.28049-4-stanley.chu@mediatek.com>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTU1ZTUwZTVhLTY5NjUtMTFlYS04YjhkLWRjNzE5NjFmOWRkM1xhbWUtdGVzdFw1NWU1MGU1Yy02OTY1LTExZWEtOGI4ZC1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjgyMCIgdD0iMTMyMjkwNDMwNTUyMzY1ODI1IiBoPSJEWDJGckVFYmpaRVV1RVFzY2s1cERYRVl0aHM9IiBpZD0iIiBibD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFIQUFBQUFCMjBFWWN2M1ZBWGpSM0EwTWlBNHNlTkhjRFF5SURpd0FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUJBQUFCQUFBQTlybW53UUFBQUFBQUFBQUFBQUFBQUE9PSIvPjwvbWV0YT4=
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.86.143]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cba44085-4b41-4600-d544-08d7cb893cb2
x-ms-traffictypediagnostic: BN7PR08MB6068:|BN7PR08MB6068:|BN7PR08MB6068:
x-microsoft-antispam-prvs: <BN7PR08MB60686D84E1CA98919A7C8CA1DBF70@BN7PR08MB6068.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-forefront-prvs: 03468CBA43
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(39860400002)(136003)(346002)(366004)(199004)(7416002)(54906003)(86362001)(7696005)(8936002)(6506007)(316002)(33656002)(55236004)(110136005)(81166006)(81156014)(8676002)(4744005)(55016002)(9686003)(4326008)(71200400001)(478600001)(26005)(66476007)(5660300002)(66556008)(52536014)(64756008)(2906002)(66446008)(66946007)(76116006)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB6068;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IIqAvuigpFmNvdL0ij2tUSPjCADACWDOu5XU7WW8eVsXw+oFRxlPooZ7vA5wwlkDzaPI5GaKgjwEFfIWHxRBQCNK0rUTyrDv6xTkxeTn7JQbgg0WyMbV38zKaa3cRnAvnAy7N2Mb5oBfZvqnVRUFN1/mBq4hqJ24fpfQISZJL/nkiKXigXBg3irqZJkT4YHBbOp4RdmDuVkEcaeJMswQT9cWqRp9mjdr6cUa+bY36HGLqM4bSpP07CIZx0YJzpuZmXucRJOfzpduuL+AP6BfFtxs1zxGP9FcLXjI2MiMzpr+AgAa48i1CNsQotLnyGRXFLEY7UZf+goSNbwtBz6YW+UDzOPVsSQNx7gcGAbYns81WY5o+2CotQVDG5J8mzShrL4d91WwNp2I5zNvyd2uauqKEzS1I5mSZ5RtaNBjj7x9w/vAVBj0TE/rH8fRyqxt
x-ms-exchange-antispam-messagedata: OIe5Mtomfad8gWM8IcNIT832OfApL/tlGsdoPIKtm6Q1AgAlrTS1ymCVfehSxDxE7zzRYqh7sF2GpYUurlbpGVx4DU1hpmyGeDYmQTf57tkQAJCguUoluuDhFz0X4+U4yrua+vkB28SqJT+6k9LX9w==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cba44085-4b41-4600-d544-08d7cb893cb2
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2020 22:10:58.3886
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nI483cqyW9nl0yQ0mJobtnpRJTr2PZiQNx5vm1/XIQ9Jyerx5h3hT9BREhpq+rEIT34CH0YgySYK8qR/I1Q4eA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB6068
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi, Stanley
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
> 314e808b0d4e..a42a84164dec 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -597,6 +597,18 @@ static void ufshcd_print_pwr_info(struct ufs_hba *hb=
a)
>  		 hba->pwr_info.hs_rate);
>  }
>=20
> +void ufshcd_delay_us(unsigned long us, unsigned long tolerance) {
> +	if (!us)
> +		return;
> +
> +	if (us < 10)
> +		udelay(us);
> +	else
> +		usleep_range(us, us + tolerance);
> +}
> +EXPORT_SYMBOL_GPL(ufshcd_delay_us);
> +
In this way, the callers of ufshcd_delay_us(), can directly call udelay() o=
r usleep_range(), what is exist meaning of ufshcd_delay_us()?

//Bean

