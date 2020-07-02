Return-Path: <SRS0=HQac=AN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52B2CC433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 01:06:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12385207E8
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 01:06:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="UZxvhVyt";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="0I6uq5YR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgGBBGy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jul 2020 21:06:54 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:20840 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727008AbgGBBGx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jul 2020 21:06:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593652013; x=1625188013;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G3POPu+TKJuEu9/hAz5nIvWu0fU/L6mKlZDWu+2w4nk=;
  b=UZxvhVytN/x9iDRLlQijgAdplwlBk/tw0Sr7o1nSZPGsg68h3BSUYT33
   O17OyYO31wm6DcyL+NTHFTeXkg1nJhF+y/ZAqmux3Hbx0wmv1/tRdQx1F
   ahfGrZ02Y89dju29DXFqfyPe/TyLuQdHB12F1KxLZfwAA+DTXQCyRtyDs
   TJK/KEEXvNKzibMZ/NXiaDJZGxGrDff69JqNNomqNyDYAMdswArBHL5/K
   pKvbE26VJq9TPuQ+XcYxleaOBhoSi7NBfMhr0d1/9BwPetK07suizQDJT
   z5db0G1V6aWJLMYWOJFgxJMAHdM+3VyaTEd/cdU1j4t/o1DquIl1XyE/6
   A==;
IronPort-SDR: FP4knnXej6dox9N2COSvnrQjPkwQo/MHmJXr2v7szWg97rEXPv6INUeiifV96tL/M5+3AmHwHA
 jMapeYO3UnhfFZPd1zdUWad4+WTcKfCSz8qYsLZYLwWjBntpmj1CocZG+FOl1mg6iO/ku1kY2s
 rhdbYfwMuiXuccPHZ3HDGPTfKEszvBbE/MYpt8qxoSZI/SYkBK3iaCtPyAFKYPIu8QGR1LDEdI
 niPSlFsvDu2A1fSCMU+kGFnHNoYAmIJ14QFQR6ycffUA+5ZFFcwloawUIH+MgKlmtOnjAsSHjB
 VJQ=
X-IronPort-AV: E=Sophos;i="5.75,302,1589212800"; 
   d="scan'208";a="145764571"
Received: from mail-bn8nam11lp2172.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.172])
  by ob1.hgst.iphmx.com with ESMTP; 02 Jul 2020 09:06:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PnHTa6snrvf8+i4YXdkp/tebCgJW7rEc8AMLIe6QpQyBZfaEWyZmGvh0I8y/b6soLPJ3rzOUf8F6cXfSLqPDfrNvr2hACPITRzti7AZbQjl9zJNdAsVPRLWusbztWxrfYpG7mOPTga+vQNtRT2HmqprDtHRNSJDNr61kIuADAFhfvrBhraKd/F1nI2tsCCoYdGb9WhcOtv7VVCaWqjR2nD/nGIXQPXMWz1D5lC7uFB1IcCesdwxPzG6nu7AUd31elvbm589J0e/5Z2Nf/JFO+/WRxmSSm55uqJpAev+xZrjKx4GAuEj3YjzEdTSchHtjKahLuT/jnCuuGtk/Ofo+wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ttbGvm80TxyBd/cs5wiLppS036Wu6Kz410iTH9JplWY=;
 b=IaorWuMhYg45U43Egs+00/WfKugD+Xjsq+aw8haCa8cngij8wr4zP/r1PpffEeMOOVfBA4I6RvhBT294p44qA0rKoqCs3M0fzLPonqJHdIfoCFEXAkESX/9l9POMCiC6GIe56CpX8IAk40oF2iv8Vto8VtQzp2puzXS2MJRU4zhFds6eNOFRrUZvQOvFIgEyK/fj8q/7ZdqgFCVBhO6o1uaNonSn/xFJn9g4XGrf+VNl+F3xpeSpGyAGhW2qlIwlGZBf01Fb5fPNnXr00NhZnW1LkYiZ83J82bK3irTXTk5+ZgTg3LCCh+/mRN7VTBu/JdhUsrSlcgHVZDyqkBqkwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ttbGvm80TxyBd/cs5wiLppS036Wu6Kz410iTH9JplWY=;
 b=0I6uq5YRSqcNbrro7fyRDrek0lg9lmZxosa1UX91W1JWI6IaFX07LID589kPA773+B8mZ8+k89sIlqOp6A77qZK92+k3WaRbOVCJlI9OC4KdLXiUKjFgSS7RQpequr5MyysrBSYIGcT9C2+bz4arZSFIHDl5QDMXJtxDx/l5apc=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR0401MB3586.namprd04.prod.outlook.com (2603:10b6:910:8e::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.25; Thu, 2 Jul
 2020 01:06:51 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7%9]) with mapi id 15.20.3153.022; Thu, 2 Jul 2020
 01:06:51 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi: mpt3sas: fix error returns in BRM_status_show
Thread-Topic: [PATCH] scsi: mpt3sas: fix error returns in BRM_status_show
Thread-Index: AQHWT6mik4YDJEAuqU2c5oRzAa63FQ==
Date:   Thu, 2 Jul 2020 01:06:50 +0000
Message-ID: <CY4PR04MB3751A35F8324DC1D0B949720E76D0@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200701131454.5255-1-johannes.thumshirn@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 656228e7-8681-4672-d845-08d81e2433d7
x-ms-traffictypediagnostic: CY4PR0401MB3586:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR0401MB3586441DFF7DEAA1BCF72FFEE76D0@CY4PR0401MB3586.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 0452022BE1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m6Nyl11ZXbNRkufe08/YvEUIr07FTedUd1Zx3Z1InKGASO7ezEuo0eFZo1UVCwuJ7YK5LC+y7mhdDpIsfBRy5cj5AljYT8O6lUB31d6gDfgzcSfk6+s5YN4HB2P/Yj8t5WgW/GcHotVDMRLRfj+ZJYRvYsniwyuHe/oj2nCtRbQKX8TCzfwnz2+YlH+Vt17VScg9rJtGTiu+JJlpytOvxDIt2EXbueb/tYKKh7wB8F4WzkiYJ1TJbFs4L5usCvBR3N2BZqIVrrGoy5EFrCB16gA8fujFhusgCsgpkP5vAKOM40jRaH0vISiMNXwgjUUudYf/KuxJtAKtuKrK3nE4T6VJMc7gTv3UMMVCM5tpVXx7h773dKqTc6LXIYYOU0Xs
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(396003)(376002)(346002)(39860400002)(66946007)(86362001)(33656002)(8676002)(8936002)(55016002)(9686003)(5660300002)(4326008)(478600001)(2906002)(52536014)(7696005)(83380400001)(53546011)(91956017)(66476007)(66556008)(76116006)(66446008)(64756008)(26005)(186003)(316002)(6506007)(110136005)(54906003)(71200400001)(32563001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: lgpexQnPu8rEd8Ys2RmWCB8Ks9zSTux4l70I3oiX+NH52Z/q0au8+T0vv2qinhS+uzeKyJLmpmOH4kQgG05wNtalkQkZ6okk5kQMRDups8BQkzwPmRbCHFdiQQ4+A1Fro/+0h8heYtQVBq/8JbUXb3jOXTWP1plePHMFzr45xT/IglNZ+E2D6O1WEwEY7DHLkykc7tRjntJFo/bVcpP3C7YowOe6rTVI5zB9x0RUwtEEUvfzeVwepxlHkoVFGLZSNLK9DrplZJmuxXQ/WvhOFfj6QdGTaJBja7m2/p6G8WggCzag3Iw1qmDp0YqL9R4LcnLXck/cQs1beD7fLRGZYJDh9KewLDato5cof5O5D/ORtbaXHlPhMKXVOHdy00FP0JqaHjd5l2/mKG7K6qH8Vb6lBstUvsac83A2k7xjNUgmvm5LKNx5aSfuob3OfRJdQfFYziJcRkYtR/Cp7p74tH/6B1wo1OIK+Mj2WJgwfyYJSMN0/1glxH9PPjGDBa33
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 656228e7-8681-4672-d845-08d81e2433d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2020 01:06:50.9924
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SIGyasY7Fe0SFutOeEdOSftsBBK/A2J1r3NrOHLxSwIChFxhFLrIxkU3p6Rvu2Y3nOPyCJE2aDmXorE6bFQiGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR0401MB3586
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/07/01 22:15, Johannes Thumshirn wrote:=0A=
> BRM_status_show() has several error branches, but none of them record the=
=0A=
> error in the error return.]=0A=
> =0A=
> Also while at it remove the manual mutex_unlock() of the pci_access_mutex=
=0A=
> in case of an ongoing pci error recovery or host removal and jump to the=
=0A=
> cleanup lable instead.=0A=
> =0A=
> Note: we can safely jump to out as from here as io_unit_pg3 is initialize=
d=0A=
> to NULL and if it hasn't been allocated kfree() skips the NULL pointer.=
=0A=
> =0A=
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
> ---=0A=
>  drivers/scsi/mpt3sas/mpt3sas_ctl.c | 8 ++++----=0A=
>  1 file changed, 4 insertions(+), 4 deletions(-)=0A=
> =0A=
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mp=
t3sas_ctl.c=0A=
> index 62e552838565..70d2d0987249 100644=0A=
> --- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c=0A=
> +++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c=0A=
> @@ -3149,20 +3149,20 @@ BRM_status_show(struct device *cdev, struct devic=
e_attribute *attr,=0A=
>  	}=0A=
>  	/* pci_access_mutex lock acquired by sysfs show path */=0A=
>  	mutex_lock(&ioc->pci_access_mutex);=0A=
> -	if (ioc->pci_error_recovery || ioc->remove_host) {=0A=
> -		mutex_unlock(&ioc->pci_access_mutex);=0A=
> -		return 0;=0A=
> -	}=0A=
> +	if (ioc->pci_error_recovery || ioc->remove_host)=0A=
> +		goto out;=0A=
>  =0A=
>  	/* allocate upto GPIOVal 36 entries */=0A=
>  	sz =3D offsetof(Mpi2IOUnitPage3_t, GPIOVal) + (sizeof(u16) * 36);=0A=
>  	io_unit_pg3 =3D kzalloc(sz, GFP_KERNEL);=0A=
>  	if (!io_unit_pg3) {=0A=
> +		rc =3D -ENOMEM;=0A=
>  		ioc_err(ioc, "%s: failed allocating memory for iounit_pg3: (%d) bytes\=
n",=0A=
>  			__func__, sz);=0A=
>  		goto out;=0A=
>  	}=0A=
>  =0A=
> +	rc =3D -EINVAL;=0A=
>  	if (mpt3sas_config_get_iounit_pg3(ioc, &mpi_reply, io_unit_pg3, sz) !=
=3D=0A=
>  	    0) {=0A=
>  		ioc_err(ioc, "%s: failed reading iounit_pg3\n",=0A=
> =0A=
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
