Return-Path: <SRS0=qgw9=6N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8D7AC83007
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Apr 2020 10:19:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE5DB2074A
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Apr 2020 10:19:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="V6Bl6Mg8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbgD2KTn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Apr 2020 06:19:43 -0400
Received: from mail-eopbgr690056.outbound.protection.outlook.com ([40.107.69.56]:55394
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726625AbgD2KTa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Apr 2020 06:19:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i2br6Dy6CljlW2VRorth7yEsx5OyCR8Vomi3VnY8DRhKkR4DzxIum+E/bzJPYOr0L3dJHYUYyxmQxFGd1mQ60UmGUVHaEY/zsw4Vb2aGn/f1vfqXA1CybK+VJmypIyCvJnWxV1DwCCViE6cLrZaHgHQHUuvYKuxDwYoA2eRXxiruh/8Xdx6JWMv0eKwSQVaDuzJILVr0ZI6DqniN6RnetH7Siicuu4ZgLJAhOYwVSMGgcJ5HuX11I6XjkwuM37CxJYeGehYoF+5nZeIUxJYJpcYQH6Nri+0ZkgAtZKVHYRTA6dwwJfvuY0NLk/j890zbVXqKw2RUTNsP51gI+8JvXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3hrjxsBHiSrJukurep1+xddXg60vu3XEDZmrQeLfhw0=;
 b=U7KLTeAJZUJy1PIxuXLkt7hk2uAHU/aSFkB3NnRItIbxaPrZfnu+Iv0/xSxnYzjKi9cK9RHnp4ZOqYjrEkn5Hv9uBR2Gomi+qi46foI1t5zIBcS8NjnAKE6XNQ6NLXvZKggpVmVfvG6q7N7lXIUk82lbtp9V5hKqGIgE6dWCZvHNZ3L5LhTttAqBPTKYrDFM5AqrGlMya4t3G5jNntO2GISDezhvaiDABs/ctIL9ibFjQNZsOO02kyMgNCIOrCCc/tCIxOweYf9FXWqXEkWxaeJ8wOtqhy+USpvVUOuacET5hvgxeQcNEa6nbzC+rxdiwWgVxmpuS9hFtu+4wcabtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3hrjxsBHiSrJukurep1+xddXg60vu3XEDZmrQeLfhw0=;
 b=V6Bl6Mg8HBJBUihJgYyatp860tEZvf7dPnUSM8eSKjEvps5FLxQYM23OGdqO0AYz27a+AAcj14OOqECs4Cpff9F87h/F+BVgMFhcA/RY0d4WJOk9S1ygpso57n9+0rsUtQ/oiLyJUXGgeQSnqSKWzSNI1lhDZWRwuEO5TJ32mKA=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (2603:10b6:408:35::23)
 by BN7PR08MB4210.namprd08.prod.outlook.com (2603:10b6:406:fb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Wed, 29 Apr
 2020 10:19:13 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::9ca2:4625:2b46:e45c]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::9ca2:4625:2b46:e45c%4]) with mapi id 15.20.2958.020; Wed, 29 Apr 2020
 10:19:13 +0000
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
Subject: RE: [EXT] [PATCH v1 4/4] scsi: ufs-mediatek: enable WriteBooster
 capability
Thread-Topic: [EXT] [PATCH v1 4/4] scsi: ufs-mediatek: enable WriteBooster
 capability
Thread-Index: AQHWHU4ihpQ3MTM+9UKTJOebA4liOaiP5HcQ
Date:   Wed, 29 Apr 2020 10:19:13 +0000
Message-ID: <BN7PR08MB56845966D744DA36404FF054DBAD0@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <20200428111355.1776-1-stanley.chu@mediatek.com>
 <20200428111355.1776-5-stanley.chu@mediatek.com>
In-Reply-To: <20200428111355.1776-5-stanley.chu@mediatek.com>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLWRjZTQ3OTJiLThhMDItMTFlYS04YjkzLWRjNzE5NjFmOWRkM1xhbWUtdGVzdFxkY2U0NzkyZC04YTAyLTExZWEtOGI5My1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjE2NTYiIHQ9IjEzMjMyNjI5MTQ5ODk5MjQ5MyIgaD0iNHV5VFd1S2hPcVdHYUJGNmpEZDB6Sm9VKzVzPSIgaWQ9IiIgYmw9IjAiIGJvPSIxIiBjaT0iY0FBQUFFUkhVMVJTUlVGTkNnVUFBSEFBQUFCdEF6NmZEeDdXQWNSVUhzWG5iZ1Q2eEZRZXhlZHVCUG9BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQkFBQUFmM09FS1FBQUFBQUFBQUFBQUFBQUFBPT0iLz48L21ldGE+
x-dg-rorf: true
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=micron.com;
x-originating-ip: [165.225.81.119]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b9b0a53e-0dd7-43ca-842a-08d7ec26c3fe
x-ms-traffictypediagnostic: BN7PR08MB4210:|BN7PR08MB4210:|BN7PR08MB4210:
x-microsoft-antispam-prvs: <BN7PR08MB4210A9F9230DCBED625D5F7DDBAD0@BN7PR08MB4210.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:972;
x-forefront-prvs: 03883BD916
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /nYFDACwLFqDb17xxsAfjRlg90OBCysEP144xSW1f/vEVqKL8hF6K8F+vy/4HBDq1BNnuQGWPsdYOGmWs6sC0oPtJRmmRsblQaPZ8GC4168qSh2Mchtk6yKazT4jIlqcuWl8+R0vsMNj9hasY5ImKCCBUlxeKw83gQ9xHOmXyx3Utw+60wDegLJdEE+ZkTO6ZJzxpLQO+RSca23MR/VKXZBep8tKSq40cEFYy098pZ+lMA++72DBtpDouQLbKbC9vFjxnSxSx+kTSdQs4OdnwDVaqjDP77OkLn5oiBmvgosVjP7I50qVnBfbjQmibGDRk//7wiZ5VcseJ6aEKl0QrUjsPSXoWxtNoFngh+v2lt9I/h91C9zfoYoJHxbsAXUi6hdVVAH3f+T57BQf0/TbrSI2X/D90r1LuX2j9lfx9TASycFE/VdIWxNN9n/G7N97
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR08MB5684.namprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(366004)(39860400002)(376002)(396003)(5660300002)(71200400001)(54906003)(8936002)(86362001)(316002)(55016002)(66946007)(9686003)(76116006)(7696005)(110136005)(8676002)(64756008)(33656002)(66556008)(66476007)(478600001)(66446008)(52536014)(7416002)(186003)(55236004)(26005)(4326008)(6506007)(53546011)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 1TRRHh2QrQllKaiwsWyyZV3Xgjhw0C24sE4nf3wITHm7gNQ2KhFB41FHS1EUjdHZCXafAbVJfxX/PSVdlfe98CqrHpKSVPj+ImWX7fB4ljtCyygLVPngQ5TA41fO3r5+1MtPSZJOx5yFHBxYkdm5pOcandFaad01kBFQksIU3ESl7HcoVAPYIKSxDuqrcMDfIEbbiBo6uG9QhsEMbMaTFG32KL5at8nkFbrV0PAxiIxaCK76P6OL7P6tURwe6nCOTQw7mZ6+yV7EncmwHpzLKRhROtDRjWGiIxDN6rXopPR58vHgU3zc0+eBhbBtFjEKKKzeRQkhPOaRwME3xCq0haaTT1od0/nl7OWydqEpRPvFS/IQB5JAAT/AoXgNryk1ebBh9Vua8ZssXdotfn0D6LDWDxNvfTcemaiVE+vF+0tWYeIIy1uqWBYTQ3qiiA28hSkmYFVgyN5fX+M9adMm+QGqULnsukVdPHPVJnleS9iwePnDpYLWmqEbQFzML7hW9zexRH4eAhIhvnWgeSxQUnbJk1mGJ/ZUaAP0JIEMU0/SdFUD5Yx5UdoCtvD1A8w50SEsz8N31DG8RW4YnH5CT9QBTpafR/UmNmg85jOxzLuevepkyaYvqXJKE+vn6aRA6QGqp5P5REkI+ufg3A3ruZk5Jv6ZUwF3pJ/lLXzlO/9cBZQ+AA0r4u6YXwqvCr2PeHNtS9l/02VVwJvbZlIMi3jqTrO/zk08p2uSNdvVOONglRQbiNI3/Yao2t2xGnRgO0T/tzjcLRzb6FH9g83iD31YW/sHxeE0P16cMw2/Lj0=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9b0a53e-0dd7-43ca-842a-08d7ec26c3fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2020 10:19:13.5934
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uvqyrgC/1tcWyb9MRA1v5eHqsXiUM8A6i3AzOb3ePCKSjYKdBr7AD5y378+1TEmZ7Hy9WT8h1t22q+k6WVVqbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB4210
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Stanley Chu <stanley.chu@mediatek.com>
> Sent: Tuesday, April 28, 2020 1:14 PM
> To: linux-scsi@vger.kernel.org; martin.petersen@oracle.com;
> avri.altman@wdc.com; alim.akhtar@samsung.com; jejb@linux.ibm.com;
> asutoshd@codeaurora.org
> Cc: Bean Huo (beanhuo) <beanhuo@micron.com>; cang@codeaurora.org;
> matthias.bgg@gmail.com; bvanassche@acm.org; linux-
> mediatek@lists.infradead.org; linux-arm-kernel@lists.infradead.org; linux=
-
> kernel@vger.kernel.org; kuohong.wang@mediatek.com;
> peter.wang@mediatek.com; chun-hung.wu@mediatek.com;
> andy.teng@mediatek.com; Stanley Chu <stanley.chu@mediatek.com>
> Subject: [EXT] [PATCH v1 4/4] scsi: ufs-mediatek: enable WriteBooster cap=
ability
>=20
> Enable WriteBooster capability on MediaTek UFS platforms.
>=20
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> ---
>  drivers/scsi/ufs/ufs-mediatek.c | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-media=
tek.c
> index 673c16596fb2..15b9c420a3a5 100644
> --- a/drivers/scsi/ufs/ufs-mediatek.c
> +++ b/drivers/scsi/ufs/ufs-mediatek.c
> @@ -263,6 +263,9 @@ static int ufs_mtk_init(struct ufs_hba *hba)
>  	/* Enable clock-gating */
>  	hba->caps |=3D UFSHCD_CAP_CLK_GATING;
>=20
> +	/* Enable WriteBooster */
> +	hba->caps |=3D UFSHCD_CAP_WB_EN;
> +
>  	/*
>  	 * ufshcd_vops_init() is invoked after
>  	 * ufshcd_setup_clock(true) in ufshcd_hba_init() thus
> --
> 2.18.0

Reviewed-by: Bean Huo <beanhuo@micron.com>
