Return-Path: <SRS0=nNaJ=Y3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CB16C47E49
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Nov 2019 21:48:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40CC221D56
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Nov 2019 21:48:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="Ypuu2IDe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728168AbfKCVsZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 Nov 2019 16:48:25 -0500
Received: from mail-eopbgr720075.outbound.protection.outlook.com ([40.107.72.75]:31778
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727380AbfKCVsY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 3 Nov 2019 16:48:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I6rXaW0cWt/OEdmRSPX0uEcOwcumCzz0Q1q5oxaUBMJEiz1o2Jr2L8Nt06r2xdouxRUt/NEDyZ/nhMhL7QpMc7IGj8kLFEooaQ9tHNCExKJc/oh90UcLIEpujvNxWlpymvs02IFV+lRCPa2f81UolWiyHhJ1lTPmItSdW74BDky/IqEI9StFiDj/01x11KfiKz5mwCB7ms9Ejq2xP9IoNN6Mi7wVyCwSn4aHmRzwHP/TP09rTda28e7e72xxbHmXTKt+jKy4dVWfByAdb/5qLuz+KiHJ7H8qluZ8ALdxzJ+d5+o1MxHgEFTROayThwCWkKAQl+ePAWRjveLV+2vbPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zejbrqEKQGDYF/KIwYBptiqiFlWq9BFmXv/lk+2w4J4=;
 b=S5dL0l0TavrQDEzakk/+zz/4KkpsRgNSPpatoso4Tj3jBC1p05my6RBQKaAx97AgnnWZI8UTyDQK+G3/04gg6lgxxQ63yYRY1VV4tLPtiOvGEwqs15QUXNm3OOd6kHoqawRSFmZ2oKxWga72LXixRitS0eJbkU1NG65uPtkBLsT1CwslYIqLdPYdLzAO/pcrX5uwWAyrnKi/j4XE2qOw7XYD1d6HTmlJSZUKC/dCtXl6l8v17eys5LvPe63Ria7B7R1rqyyaHRH4+YpyvNQYMLIh0IbCuCcr6oXBRzQY1Jt7eAa8hk58R5NUJZp2mwePIOEAwc7y61KZwb7oash59w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zejbrqEKQGDYF/KIwYBptiqiFlWq9BFmXv/lk+2w4J4=;
 b=Ypuu2IDehUdmULwUKHS39y+LxdbXBrUgovwgEcKqVtRXNM3CU4Hao7j3iesMr5e+CnGNNhN4qah4zxL4W5C8nfIWJhusEEJfKs0x/vPuZzIfth43HhgbRk6VvnH2c3QEEv9G72476weZwrX7ss5shsZOy/M6Br0zzIKjy55L7uw=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB4243.namprd08.prod.outlook.com (52.133.223.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Sun, 3 Nov 2019 21:48:12 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285%6]) with mapi id 15.20.2408.024; Sun, 3 Nov 2019
 21:48:12 +0000
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
        Subhash Jadavani <subhashj@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH v1 1/6] scsi: ufs: Add device reset in link recovery
 path
Thread-Topic: [EXT] [PATCH v1 1/6] scsi: ufs: Add device reset in link
 recovery path
Thread-Index: AQHVkTrz6+VE0soB0Uye9d1xl2uesqd5/YiQ
Date:   Sun, 3 Nov 2019 21:48:12 +0000
Message-ID: <BN7PR08MB56845B4A5F206A319CAFD3B1DB7C0@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <1572671016-883-1-git-send-email-cang@codeaurora.org>
 <1572671016-883-2-git-send-email-cang@codeaurora.org>
In-Reply-To: <1572671016-883-2-git-send-email-cang@codeaurora.org>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLWEwMTlkMDA2LWZlODMtMTFlOS04Yjg1LWRjNzE5NjFmOWRkM1xhbWUtdGVzdFxhMDE5ZDAwOC1mZTgzLTExZTktOGI4NS1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjEyNDgiIHQ9IjEzMjE3MjkxMjkwMTg4Nzg2MyIgaD0iQk5wL2N5Tk5PdmVaSUEzWHF2ODhTVTJwdkpBPSIgaWQ9IiIgYmw9IjAiIGJvPSIxIi8+PC9tZXRhPg==
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.80.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f56c60cf-14ca-42a1-f629-08d760a78649
x-ms-traffictypediagnostic: BN7PR08MB4243:|BN7PR08MB4243:|BN7PR08MB4243:
x-microsoft-antispam-prvs: <BN7PR08MB4243AA86F2394957ADE0664ADB7C0@BN7PR08MB4243.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:660;
x-forefront-prvs: 0210479ED8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(136003)(396003)(376002)(366004)(189003)(199004)(71190400001)(26005)(446003)(2501003)(76116006)(76176011)(7696005)(25786009)(66946007)(64756008)(66476007)(66066001)(2906002)(99286004)(55016002)(2201001)(14454004)(86362001)(66446008)(6506007)(110136005)(186003)(316002)(55236004)(102836004)(54906003)(229853002)(7416002)(5024004)(14444005)(476003)(11346002)(5660300002)(8936002)(478600001)(66556008)(81166006)(9686003)(81156014)(6246003)(33656002)(305945005)(4326008)(486006)(74316002)(256004)(6436002)(8676002)(71200400001)(6116002)(3846002)(52536014)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB4243;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oo+NqyPxcJcrZ02y0xPhOpDl+ee/ZpARE+iR4hQNrKXRimZYaMooyvS78XtYMml+11BLBeEhCgt/+g2ctLLL39zjxmycnHtjMbLStmmz394ms8Vs7/bGWel1s7s7jDnie48e9hzvsQ1nnTJB8FMTwrcTLYrEOKDsN+Du5onpb6vDclBtUSSbkSa8rbNMK9CgEiOQybbN2yKytIgyHh7pdJKisMPRZdLg/7NLAWldF9qfoQJ9WRyzu+Kp+uwVWn6M7SNseL3mWLyhin6appOrSLhj9ky1fBRhCfgSEjGoRCPGBwYe+QRomLcprJ6F04VFuxBc0QmGXk/NmNwApNwVygwMiMIO8ThaEv7PByVghvjUEKVM+lMcYMqSDliV8ozGl2VNWasjQ2j2/jP4CKoK4Id/k9mgPb9+TxFBj/AM88uv9kJfnm4UKMcj82eAccee
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f56c60cf-14ca-42a1-f629-08d760a78649
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2019 21:48:12.2614
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SuPm61+DRUIRHRw0GSxoGRpDCiAyFFBmkXgJ83RbVOOmgiwglVWK2DLWysIbsCeB7gtklZEs8aVLEe4F15WXkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB4243
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi, Can Guo

> In order to recover from hibern8 exit failure, perform a reset in link re=
covery
> path before issuing link start-up.
>=20
> Signed-off-by: Can Guo <cang@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c index
> c28c144..525f8e6 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -3859,6 +3859,9 @@ static int ufshcd_link_recovery(struct ufs_hba *hba=
)
>  	ufshcd_set_eh_in_progress(hba);
>  	spin_unlock_irqrestore(hba->host->host_lock, flags);
>=20
> +	/* Reset the attached device */
> +	ufshcd_vops_device_reset(hba);
> +
>  	ret =3D ufshcd_host_reset_and_restore(hba);
>=20
There is time consumption in reset,  It is true that reset can hide/solve s=
ome issues.
I don't know if you experienced issue resulting from an absent reset in thi=
s case mentioned in
Patch commit comment.

>  	spin_lock_irqsave(hba->host->host_lock, flags);
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum=
,
> a Linux Foundation Collaborative Project

