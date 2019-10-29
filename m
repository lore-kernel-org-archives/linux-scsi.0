Return-Path: <SRS0=POaH=YW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D61B3CA9EAE
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 14:22:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F0E320659
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 14:22:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="bBSQf7Qa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389233AbfJ2OWv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Oct 2019 10:22:51 -0400
Received: from mail-eopbgr730088.outbound.protection.outlook.com ([40.107.73.88]:58407
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389221AbfJ2OWu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Oct 2019 10:22:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SolIfnsiPDI8mk1w+SCNMQ4AAyFT0R7NCiml6e6yr/HgaE7DtlIOVFUa+rwF3pMVrzz6YQpRndvy7iFkL/+TDXMEkOfJfeeN85533KHOLI5xGftv/syV4hbF6S/FLy0WJgScQQssM61ovXKphuXYzjjr44CZM5G75fC8rQwnx1TNA29vVbIIG3d8jxo7vRJ/atZYxcPPDI0dM2RyX3o0uJn57mJ3pU2eVsxnu2vNFMPWZFB8Tj1+tVNR/MSiBj5SQKWB63SPu1kPDLSXppKoQLZD1CZhi9h1mSW0b0e082V2JK7LYsIVRrCUTezd0DIpvO01XpKf5CfBXHLb3eqJZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BhEFEzWbmccT89U1PX9naUBfUxoTOz3F99AAttG3eCc=;
 b=Je/yZzDxjhHOU4Ut8HZh65IVfEWcePpyqObw6iGkVvnoN2e+1m4+D7WuVYH2g/Kjj2nXeb8x4468FKUetKVT6gqZSOzbloFR6l/cDLMV7qW+X2glD5JFNSUJZEIpYzwzTJlBDOpxNP7DJs2u/pB5+4/4ydxnjInA1OGBBgSH3/sMF44kE3bVEAZyP+llbzBF0aaR7blAAwuEQFufDl0Fn8wwqvgt+lghuLWdbNorON/z4chri6UZlqHdpI/Qj6YknqecVhdkr1PXyNlY01rlrHSfILvdAk6nDq3S8STkdG5rSweHseQU0T2G5eDXKLQZvzIvGHh81jcUB2jHrgew4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BhEFEzWbmccT89U1PX9naUBfUxoTOz3F99AAttG3eCc=;
 b=bBSQf7QaDikjH1ha1R85EVvJDhkdZOrtnu4NgESHLL4P1aUgRL73hnM3uBXuGVykhWxBZ89uKABmrYjBDfLrjyXgAa44gRDNMGayWX1jQX5GmKAixwP0z2L0buz83mX1CAPJ+6M1pAbXR+fW0VMZd1mK+UKRB7fdJ8r+qCEqhFY=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB4868.namprd08.prod.outlook.com (20.176.27.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Tue, 29 Oct 2019 14:22:46 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::8c6f:d978:fcc6:ecad]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::8c6f:d978:fcc6:ecad%4]) with mapi id 15.20.2387.023; Tue, 29 Oct 2019
 14:22:46 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     'Alim Akhtar' <alim.akhtar@samsung.com>,
        'Avri Altman' <avri.altman@wdc.com>,
        'Pedro Sousa' <pedrom.sousa@synopsys.com>,
        "'Martin K. Petersen'" <martin.petersen@oracle.com>
CC:     "'James E.J. Bottomley'" <jejb@linux.ibm.com>,
        'Evan Green' <evgreen@chromium.org>,
        'Stanley Chu' <stanley.chu@mediatek.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>,
        Can Guo <cang@codeaurora.org>
Subject: [PATCH v1] scsi: ufs: delete redundant function
 ufshcd_def_desc_sizes()
Thread-Topic: [PATCH v1] scsi: ufs: delete redundant function
 ufshcd_def_desc_sizes()
Thread-Index: AdWOYNFUHmkvcAl2Q/qT6qb+uQ79WA==
Date:   Tue, 29 Oct 2019 14:22:45 +0000
Message-ID: <BN7PR08MB5684A3ACE214C3D4792CE729DB610@BN7PR08MB5684.namprd08.prod.outlook.com>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTkyMWYzYmNkLWZhNTctMTFlOS04Yjg1LWRjNzE5NjFmOWRkM1xhbWUtdGVzdFw5MjFmM2JjZS1mYTU3LTExZTktOGI4NS1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjE5OTkiIHQ9IjEzMjE2ODMyNTY0MjUxOTk5MCIgaD0iREZwWlZqUmNjMjhDaVE4ckxJNyt0WU82TWJZPSIgaWQ9IiIgYmw9IjAiIGJvPSIxIi8+PC9tZXRhPg==
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.81.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f5e0c7ad-7f8e-46f8-bb99-08d75c7b780c
x-ms-traffictypediagnostic: BN7PR08MB4868:|BN7PR08MB4868:|BN7PR08MB4868:
x-microsoft-antispam-prvs: <BN7PR08MB4868F797A2E9376A722A5F43DB610@BN7PR08MB4868.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-forefront-prvs: 0205EDCD76
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(39860400002)(396003)(366004)(346002)(199004)(189003)(66066001)(316002)(6436002)(66946007)(25786009)(66476007)(3846002)(6116002)(76116006)(7416002)(7696005)(52536014)(486006)(86362001)(256004)(9686003)(64756008)(476003)(2906002)(66446008)(8936002)(55016002)(54906003)(26005)(66556008)(478600001)(110136005)(99286004)(8676002)(71200400001)(4326008)(71190400001)(14454004)(6506007)(102836004)(55236004)(33656002)(5660300002)(74316002)(186003)(81156014)(305945005)(7736002)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB4868;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nohWSX36H2u9UPR1LuLqE3iBbxj1LYpum8kGsnOEnbN7nJcs+tteOBa1iEQzRNzFOjaImd/G53PiEDDd6PlOmttYOjF7mAacmCHmcvZC7IAPP2EkH9ZXtTXpW8Vca9oagpoYU6rbcHuR8sorTj/6FQkoIG7kf/1iIvFDiU7aB2PCSNcNYDP10Ftp84kE24vDouxO6keUS6XftYBvWvf8n2oqeNcc/MeqjjSD9DCcKrGWRDlygkUJRsaDHdP/V2muOD2RgUa6FDJnTy2Sf8FXguimun7kUAkuJfg0oWXMMWj2OA1oTp/mCJ9Q50bPNlsMlGZPiWJHZjwIhZOPR9Tg6YzIxBxxR9TLUAYMv5zhuv/UJNELMq5is8wTUctEy1+kJVKEpGZ7R4s0eev8K3a/B07V6As4EThrwFMFk2X0gwdUa9zpqvcfuJaWZxaKij1B
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5e0c7ad-7f8e-46f8-bb99-08d75c7b780c
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2019 14:22:45.9958
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vHiE6yIckNvR/BDdz/QYfIR+UF+dXyd48t0NdVYyP+mMDgtkgBmYm3cyjdXx3skh/nl2eXXUpnSHi5vxz3AvQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB4868
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

There is no need to call ufshcd_def_desc_sizes() in ufshcd_init(),
since descriptor lengths will be checked and initialized later in
ufshcd_init_desc_sizes().

Fixes: a4b0e8a4e92b1b(scsi: ufs: Factor out ufshcd_read_desc_param)=20
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c28c144d9b4a..21a7244882a1 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6778,23 +6778,13 @@ static void ufshcd_init_desc_sizes(struct ufs_hba *=
hba)
 		&hba->desc_size.geom_desc);
 	if (err)
 		hba->desc_size.geom_desc =3D QUERY_DESC_GEOMETRY_DEF_SIZE;
+
 	err =3D ufshcd_read_desc_length(hba, QUERY_DESC_IDN_HEALTH, 0,
 		&hba->desc_size.hlth_desc);
 	if (err)
 		hba->desc_size.hlth_desc =3D QUERY_DESC_HEALTH_DEF_SIZE;
 }
=20
-static void ufshcd_def_desc_sizes(struct ufs_hba *hba)
-{
-	hba->desc_size.dev_desc =3D QUERY_DESC_DEVICE_DEF_SIZE;
-	hba->desc_size.pwr_desc =3D QUERY_DESC_POWER_DEF_SIZE;
-	hba->desc_size.interc_desc =3D QUERY_DESC_INTERCONNECT_DEF_SIZE;
-	hba->desc_size.conf_desc =3D QUERY_DESC_CONFIGURATION_DEF_SIZE;
-	hba->desc_size.unit_desc =3D QUERY_DESC_UNIT_DEF_SIZE;
-	hba->desc_size.geom_desc =3D QUERY_DESC_GEOMETRY_DEF_SIZE;
-	hba->desc_size.hlth_desc =3D QUERY_DESC_HEALTH_DEF_SIZE;
-}
-
 static struct ufs_ref_clk ufs_ref_clk_freqs[] =3D {
 	{19200000, REF_CLK_FREQ_19_2_MHZ},
 	{26000000, REF_CLK_FREQ_26_MHZ},
@@ -8283,9 +8273,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mm=
io_base, unsigned int irq)
 	hba->mmio_base =3D mmio_base;
 	hba->irq =3D irq;
=20
-	/* Set descriptor lengths to specification defaults */
-	ufshcd_def_desc_sizes(hba);
-
 	err =3D ufshcd_hba_init(hba);
 	if (err)
 		goto out_error;
--=20
2.7.4
