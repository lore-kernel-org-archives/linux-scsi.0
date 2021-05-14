Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B719C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 02:00:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6B426140E
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 02:00:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbhENCBW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 May 2021 22:01:22 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:46130 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbhENCBV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 May 2021 22:01:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1620957612; x=1652493612;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=3xg3Y/MUT/DVA3mjiV2eLlK33w4yNfZrBr80G9imu1w=;
  b=Z5kRHA+LGlY6NzSyNTFSgBy3D7bhHEFE8OIWd6A3w1gjA8Cdw7ZGdtou
   EosUf2/9sMy/s3Wdub9/XS8WDNdwGtX5Fh9kHLF7xhLNsYx6OWdvtQ0wF
   04cLJEU8pi58lYRxEt9CNxSO2K0PTAWfr9Xe2Joe2JQaPtErZMks1XyCM
   CcBF+JZed1nFVGqdpyPjG/2/GIhhGqk7s8xI8ecw6YxGnPrP1QW/nDVV3
   VDzjOhE9SLiNl4NPHrVdCuz526i32vaE9x1FhnK2Uxj1Oa4vv4gYXVn9+
   aTH6DImYpavUTVcSfeT4D0ETKiyv534xg7TNMKuFGn2Y+RYMcrwOSqp+X
   g==;
IronPort-SDR: MRwaELPes+aOqSbWlR2xWqKLnE/xEZq1ELMd0thuzRKKX6RM3a04Y2eu7yN8NtV/ydiyUTfLcs
 MmLiJWf1QzL8vSTkHdRi2T6tlkeBEKb64L1AmptZTrMQa1aS2rcjTRFNDzhX580HZRUeCLwend
 aAEWV9g9y3Y/m64ZUvQCcEgzIgyW4EqzppZr5lQTnFjJbkHrO0gqsfAkXv1nIOjImkrFIowFxr
 qtZFNCD3u8qOtaaiVJeBJdjNGSS0J0d8kieFcRoB2GPmC/9b0lnhjFBAq9ZObXPxKn4STT0JLk
 FUI=
X-IronPort-AV: E=Sophos;i="5.82,298,1613404800"; 
   d="scan'208";a="272101262"
Received: from mail-dm6nam12lp2168.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.168])
  by ob1.hgst.iphmx.com with ESMTP; 14 May 2021 10:00:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UpUTwGRJTeQMAjgyJVPdHncPUrFJddgjXQMSIXyBJEMGExeUQpHngN1/5NY/qj6AZYzsErSJ52nrlKTmvXX4GW3aJnIm3gSzmEt7CnOvIhUiLze5E1qpw5VXK3BhzaRoPaa/hgwm1pmNf4q8GSEfoM8UIalDlvnoGfn2Q/Znxv59hnGWtwIY6zayRw+IXKaMC+f0ojlu1jzUn0GSIpYXztbIYK2PL4tT30LEuYS4KLUx7gd/NWqZvj+m6qR16eWYh8UtR6AT9iB8i2LMgeR7g1u4Dx3lZUaO5oB1IgJVkj1iuRb/FWSchpc4f/I+0w1u2EJUGOXn5tVxpBGnpxFa8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vc3WRSKbu5xN6KwiXiJctkLTZl7cLqaASMgdnMCqXgg=;
 b=QPlrVtaas16CUVYjHJWJrhZNH9/xGlowwGIk+hREI6PkaHL4xpHZMoiJRoz3OoSciNua2ffV/PXxOLBl1S49x6fHxUTwuijSwoVkE0Xqr9BNQbArvqfKaaEsCJ1h0oTdG393+/5cQmdQRJzN6Pj7PEgX2Lm9DZL+GOPhj0Jr9xSsBdQv72JgpOOFwH4zTM9BFM/pjgqATxm3tEkVO1WI/exn6POWv/RuQKqip946sHkWpm6ZPnW9d4AAvAxDTUtJqNPzmctHQJnrdPeeONL9OwLX+MlR9ppsvFgBBuWFFcjP0AhMTXuWvx8qVGB8wQ1B3luKuBgaVIEveV7LjEM46Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vc3WRSKbu5xN6KwiXiJctkLTZl7cLqaASMgdnMCqXgg=;
 b=TFuNNHQClvjiZYgvZQQxmnTDGJvQ4i4upGymPmO1H5o309npxU6bZRr78E1VrEpctIkdz9yn5TC4VQZdZ38ITdN2gNfmBgzDEZD2f1q3VfndLPufsWcyLGvCuNyiDVd48qqIkONhFiUVq1kbv76ctjj2W7dhsrfAq4kc+N1cE5A=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM6PR04MB6828.namprd04.prod.outlook.com (2603:10b6:5:22a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Fri, 14 May
 2021 02:00:09 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::64f9:51d2:1e04:f806]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::64f9:51d2:1e04:f806%9]) with mapi id 15.20.4129.026; Fri, 14 May 2021
 02:00:09 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH v3 5/8] lpfc: Use scsi_get_sector() instead of
 scsi_get_lba()
Thread-Topic: [PATCH v3 5/8] lpfc: Use scsi_get_sector() instead of
 scsi_get_lba()
Thread-Index: AQHXSEitkL9ygEkxDUKZQVKp4XcSlA==
Date:   Fri, 14 May 2021 02:00:09 +0000
Message-ID: <DM6PR04MB7081541366E8AE3E7E833E43E7509@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210513223757.3938-1-bvanassche@acm.org>
 <20210513223757.3938-6-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:38b4:55f3:e349:30b0]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 711f8219-1f42-4414-99ab-08d9167c00b7
x-ms-traffictypediagnostic: DM6PR04MB6828:
x-microsoft-antispam-prvs: <DM6PR04MB68284B0DDF75DC5660BA9BFFE7509@DM6PR04MB6828.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EBrfAx3q9IgCZ7L2svIFlBM5s3iQitfLdyknmfOmLXwo9UfY3+TqjKCdNgtD3mmVPPudjfZqgmAE1Wvp/1VB1sxb2v9EOp8v/tTre15jiyFCzCm2wHkyNUhYyX7NVTSQIirqSAW+bCLHUlQFW4g1SjCgqYVqFYUMuB1/yCZjNVuExqAyDhWi9gD9ajGKR5DAtp2M0eAHkmpi2EPMa8A6TlZp/T9CXV53jk54BjDJlKgh+iavQmUmtzSf2PcNtGujEPdvLzVuQSfmhfwfalmKI1cr7aozJGTY4eOcxz5OpXDC0+zzxzLwHOLmK90GoB+QqI9uXqFTrO2j1aMUhqW3OTfBNi4GST9zMl6V36MgJfxWoB2BepxcFts6XH6+yb5Js3B28tMWxGV+uC3d4eh7GEOZG2KBg102dtFAp5b6SSb79b+JzfJhThpVBuYWRuuw24Uv6G4D4jZZ8zxGgEZvQIqmLnTAERsUANfTi0aEN1P9VRhoEcEjsIuVJ6SEamFs3kbc/HPkPwJGEUXjNa3GV4ydt3061tUM5Ek3Fo1CBNp9B4hp1vKqOBrRJa3UQZcrZ/4h200M1B+ZEVrooy+M6IymEOlqRhxF0hfDzmX70mo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(366004)(346002)(39860400002)(71200400001)(76116006)(2906002)(91956017)(4326008)(122000001)(186003)(83380400001)(52536014)(38100700002)(478600001)(66476007)(66446008)(9686003)(8676002)(66946007)(66556008)(5660300002)(86362001)(55016002)(6506007)(53546011)(7696005)(8936002)(33656002)(54906003)(316002)(110136005)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?fsIKhNuoaAp71ezs/BoqG772OLEHL+O3zE/qIK/SumhjGRMGP80keSSlY0QY?=
 =?us-ascii?Q?sxZM7UEHnyZcbn5Lp/0TqXkI+TRtfB5ocvbeugK42TxE70qTz0YIWOaJx4Ax?=
 =?us-ascii?Q?pMJox/5msi1AI/TUvHRaUznd1dV+F2kJlFF66OkVVLM284Rm79Ff8uE1KXrK?=
 =?us-ascii?Q?B1Fr7uPgjy4H/+Bz9cEY5xQqKTqWSCLakLq2s/LzDnzzc9KFn+UsuHmDplzt?=
 =?us-ascii?Q?viZiTMEAemiNpnfo3qPgZhgmWBk/SlNoIqSvaEEyNtfdYMZi5bP7Hf0C8y6X?=
 =?us-ascii?Q?Y7ihQfgAM97a4tqnvkOy98iuUNoFresbCb0iR7zGo0Ua4qwjr5OU3s8Ux3O/?=
 =?us-ascii?Q?eaL2jkiWANxZnb3gir+GxxFnP+PdhAU6Hm8Q1/Z+3XejyAPMKbcucqJ1AvT/?=
 =?us-ascii?Q?bSsILRroycmrnNTzxoZCJ/Bl+5KKgfkgjL4aqliSoPIPoda9yUEoZjkWJdWp?=
 =?us-ascii?Q?42bK1ZpHM4FJzL1FDUy/SZlOpA8xKHzKyjhr7Zx7knrQmbx0wmv4CSRv/77h?=
 =?us-ascii?Q?8+Nn4trRYcltxPjEKpI5JHvvbIPLZdn8luDJFpMv7GISjcKbVmybFIz6AN7b?=
 =?us-ascii?Q?mdwhztxrXj1q2CMAkKU6zzuPGL6VBVz7yoYvK8m5QoiS0OIhaCcfOBqXNK1O?=
 =?us-ascii?Q?s9GNVbImCh0W+4a9L0f2HW/ZHz/U7qNvRQ9lswSRpbBl3ol5YOteTB9+U5uB?=
 =?us-ascii?Q?41Ccew200vGEyeZIN/wzlHFfWQXfsCV/n65kNH7eRoNUf4k5PSY8wdKpFWTO?=
 =?us-ascii?Q?yvI5sQTlbxGjB/yJQeMmZrTf4Jla+awFH55SPtC92b65m4GCPHGHglwEA7rk?=
 =?us-ascii?Q?Np4IY6ppk5wBc82e0qnzX37IFQVtE0IQB3cuhEI/iS+242N0EdxIrSOhfJFX?=
 =?us-ascii?Q?hdYtdQCmMrE5C0FWa+KGpSvYKUUOap/3MOCAXnaZ6pBa4Di0wVtAZjKHSZSC?=
 =?us-ascii?Q?S7/kbjrtkCFvm+z1Aum9IOxgPjYvaKu3GR5y5VuvgFyMYnHI8BCdBkToqCTe?=
 =?us-ascii?Q?UCB29q5UYOM1Zs/y5kFTGcpz27OKazoq33XP5v40J6rJ0sc1tuJOqZXHyh2X?=
 =?us-ascii?Q?aD/avKXZYbD81w/sirThSqLo8NFtgJsDObK+cZxXN8oATeNkP7CY7fALFxnI?=
 =?us-ascii?Q?d8Gx+YXlinbP6lNjHANsGQS1Sguzwcy8QHHLpkt4GeQic7ABC9Z2hScvX1Vt?=
 =?us-ascii?Q?7/5BdoOvwHXlrRk79uqQfrAPEjSbZXywKL3ioNLFH8CxXjzAptYeJk2twH0K?=
 =?us-ascii?Q?EdOx8Aec9BeOZfn8rER/Hqadm97usabJ+VyApwDwz+cPTiILRx/sIS+Zy4GS?=
 =?us-ascii?Q?GDUGv3icuwTfl1ZvvxXDPb+JTSrW6MIrkkoQDa8MYJCyewh27rXrYKg/Gz5q?=
 =?us-ascii?Q?COOqBUYD8HgmySAkjLf1bWDhsI2+QUr1pyUdpp2SK9owGsOXTQ=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 711f8219-1f42-4414-99ab-08d9167c00b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2021 02:00:09.1527
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n+AXgQriK251tuHZ7d5sm87/jk8CKXv+afjeASECXPD26MSaJARsKlTEQw8i+28ADNgtojAlr3xAAoT4MzOTNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6828
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/05/14 7:38, Bart Van Assche wrote:=0A=
> Use scsi_get_sector() instead of scsi_get_lba() since the name of the=0A=
> latter is confusing. This patch does not change any functionality.=0A=
> =0A=
> Cc: James Smart <james.smart@broadcom.com>=0A=
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>=0A=
> ---=0A=
>  drivers/scsi/lpfc/lpfc_scsi.c | 12 ++++++------=0A=
>  1 file changed, 6 insertions(+), 6 deletions(-)=0A=
> =0A=
> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.=
c=0A=
> index eefbb9b22798..8c6b25807f12 100644=0A=
> --- a/drivers/scsi/lpfc/lpfc_scsi.c=0A=
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c=0A=
> @@ -2963,7 +2963,7 @@ lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struc=
t lpfc_io_buf *lpfc_cmd,=0A=
>  				"9059 BLKGRD: Guard Tag error in cmd"=0A=
>  				" 0x%x lba 0x%llx blk cnt 0x%x "=0A=
>  				"bgstat=3Dx%x bghm=3Dx%x\n", cmd->cmnd[0],=0A=
> -				(unsigned long long)scsi_get_lba(cmd),=0A=
> +				(u64)scsi_get_sector(cmd),=0A=
=0A=
Why the cast ? scsi_get_sector() returns a 64bits sector_t.=0A=
=0A=
>  				blk_rq_sectors(cmd->request), bgstat, bghm);=0A=
>  	}=0A=
>  =0A=
> @@ -2980,7 +2980,7 @@ lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struc=
t lpfc_io_buf *lpfc_cmd,=0A=
>  				"9060 BLKGRD: Ref Tag error in cmd"=0A=
>  				" 0x%x lba 0x%llx blk cnt 0x%x "=0A=
>  				"bgstat=3Dx%x bghm=3Dx%x\n", cmd->cmnd[0],=0A=
> -				(unsigned long long)scsi_get_lba(cmd),=0A=
> +				(u64)scsi_get_sector(cmd),=0A=
>  				blk_rq_sectors(cmd->request), bgstat, bghm);=0A=
>  	}=0A=
>  =0A=
> @@ -2997,7 +2997,7 @@ lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struc=
t lpfc_io_buf *lpfc_cmd,=0A=
>  				"9062 BLKGRD: App Tag error in cmd"=0A=
>  				" 0x%x lba 0x%llx blk cnt 0x%x "=0A=
>  				"bgstat=3Dx%x bghm=3Dx%x\n", cmd->cmnd[0],=0A=
> -				(unsigned long long)scsi_get_lba(cmd),=0A=
> +				(u64)scsi_get_sector(cmd),=0A=
>  				blk_rq_sectors(cmd->request), bgstat, bghm);=0A=
>  	}=0A=
>  =0A=
> @@ -3028,7 +3028,7 @@ lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struc=
t lpfc_io_buf *lpfc_cmd,=0A=
>  			break;=0A=
>  		}=0A=
>  =0A=
> -		failing_sector =3D scsi_get_lba(cmd);=0A=
> +		failing_sector =3D scsi_get_sector(cmd);=0A=
>  		failing_sector +=3D bghm;=0A=
>  =0A=
>  		/* Descriptor Information */=0A=
> @@ -3041,7 +3041,7 @@ lpfc_sli4_parse_bg_err(struct lpfc_hba *phba, struc=
t lpfc_io_buf *lpfc_cmd,=0A=
>  				"9068 BLKGRD: Unknown error in cmd"=0A=
>  				" 0x%x lba 0x%llx blk cnt 0x%x "=0A=
>  				"bgstat=3Dx%x bghm=3Dx%x\n", cmd->cmnd[0],=0A=
> -				(unsigned long long)scsi_get_lba(cmd),=0A=
> +				(u64)scsi_get_sector(cmd),=0A=
>  				blk_rq_sectors(cmd->request), bgstat, bghm);=0A=
>  =0A=
>  		/* Calcuate what type of error it was */=0A=
> @@ -3174,7 +3174,7 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpf=
c_io_buf *lpfc_cmd,=0A=
>  			break;=0A=
>  		}=0A=
>  =0A=
> -		failing_sector =3D scsi_get_lba(cmd);=0A=
> +		failing_sector =3D scsi_get_sector(cmd);=0A=
>  		failing_sector +=3D bghm;=0A=
>  =0A=
>  		/* Descriptor Information */=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
