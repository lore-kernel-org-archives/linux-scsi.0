Return-Path: <SRS0=yW27=AM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DAF7C433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jul 2020 10:32:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 687BE20772
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jul 2020 10:32:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="hclQG4G+";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="VVGlFiyO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730121AbgGAKcR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Jul 2020 06:32:17 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:4956 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729946AbgGAKbz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jul 2020 06:31:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593599514; x=1625135514;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=sUG97u4QlbhGPISZ0h2DlV2hHSxC6myyuG9eNcf1yYM=;
  b=hclQG4G+FmQmZejjjZ84UR2mbNDvoLVRJmzc0WjIAyJZysLrjqSKht+o
   SoDkMaNIZGe2sfMTmv3LVSn7/XPHoVfFB7rfnVz0jmPwDFaIuZIC2vuxq
   jHnyCM4Zyw7Tf9JDAEk9ID3b1vvLbqpTW6LMC57iPPCnkXvzj/18SurQg
   TyLvkgtMwa31L4J3p7JD+6UcdqDr0oYeDhT+9OApqgLWvrTPQOBknE3wL
   D6sjSdrA3vEqrrAIFafb8vx4vrThIlR1KlQq1T4C3FRRXjxKYU0U4baRV
   1v94YNGw/zp5az5vbpDgOyklbawDf16ih4ryJNoZr59/3N933g5/6/9p7
   w==;
IronPort-SDR: PEzuJEKe83Bbp8iV5U4NbIMixTWNyRKzXxgU3UD1Fp8NRSAqJazCThOy8JAma+/ZW2RDr3ReSd
 n68wr26+mGPopw0PgcAqkx5z86pYUahstDOVokt1GjZx+NoQB9c7e2ZTzsWeYrEGp6/rNPVYUl
 OFr/u9XbGGxcCJfo5JTcfXXGcDcTfwZ3GjqIy7e9mTdahDKXz1jtVFxhP7iD6gjGnsg2gu7eu5
 Hnqpbu5Ad07kdHehs0iShc6tRiREoROyJqtHiBidyF+x3Uc3hjHwC29WV1uugmDXkEDL0O7my+
 +bY=
X-IronPort-AV: E=Sophos;i="5.75,299,1589212800"; 
   d="scan'208";a="142721254"
Received: from mail-cys01nam02lp2056.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.56])
  by ob1.hgst.iphmx.com with ESMTP; 01 Jul 2020 18:31:53 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ckWSbA+0w9LPRVxBBddsVag7MBkmMF2s9stet3kmtKE9OevdWXn1RX8wY+eCB+5HvDerkHNRuIPxhqzZE3Q/oEPf8OfEObHxGsLChyFaXEArxfOX+RoH32aBp3lq2RK6UmaRhUHqru/gjX3fJTTRjkqLKq79Y1CUJrZR9sUfC/R0Y3x9YpiqNAbMKg8YVQlucd/EUC03lDlth4woYyjSVZOFkz5GndA04pCQ7xtTwTeJASrYdpBi0JrKwYPVz1rk8URXC+ztX59P+AgLrt/Guz1LrnKE2rlt3RIXMDHBy0vKh0qG8BxmnYI8q5DAcz2/TsIXNZ0eG53ja6F2FPNSSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AYx2/gFeOIkT8z2o2b/af6VOCvofj3UXgiOj0wfIQrU=;
 b=A478/aYYJbGqtzwUocog9HTC4XITpVclrO3dwiVzsagmGbnGre+Bru8Z5zGnF4C+u5PhOr6TH78eL9qBk4LiG3NVSEgWoSsPzuxnFVVsP3yg4iuRVJ2JJfrQ86v0+UoaRPD09nkBbB1MExOFuyV6aDlpY1rsEBtbDI7p3DP48C/YFynMoGQAgWQSv84BPX7M56TTzAgKZnBVS4Y7q1SUVR2XNEvKBxJdYijYkBv2ynPNfmxbRA3zzI/5bjJvc40glmuC+uWI5ufJdBZGjW6yPCURUVczjajPYDX4Og+HICzvzq/mkN3CF5HilOaQVwL0I4fe3CSil0npV2aVcNzR4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AYx2/gFeOIkT8z2o2b/af6VOCvofj3UXgiOj0wfIQrU=;
 b=VVGlFiyO78AysB09gMQd43CRJOSN6lMExJJHV7NWDTcPGbWK4SOk/ZLzOH901h3JuDz3pnc9KdlHXoVU59XzXH+abyZgCVlS1xm+FS/YO2skFcg3ZYqKWF/KfruNZkxtY+lk+gzfLRHuYIGEHCUNpzeTxvuiAQlFdVe6rR9oVn8=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB1257.namprd04.prod.outlook.com (2603:10b6:910:53::34) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.25; Wed, 1 Jul
 2020 10:31:52 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::c593:f271:eebe:ac7%9]) with mapi id 15.20.3153.022; Wed, 1 Jul 2020
 10:31:52 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: mpt3sas: Fix unlock imbalance
Thread-Topic: [PATCH] scsi: mpt3sas: Fix unlock imbalance
Thread-Index: AQHWT4UHjZ+nwNelzkabCRzCpEx2zw==
Date:   Wed, 1 Jul 2020 10:31:52 +0000
Message-ID: <CY4PR04MB3751466FAE8069289AA237A7E76C0@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200701085254.51740-1-damien.lemoal@wdc.com>
 <SN4PR0401MB35981C2AD1B925263A35B3C59B6C0@SN4PR0401MB3598.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1aaac170-b35d-4442-487f-08d81da9f815
x-ms-traffictypediagnostic: CY4PR04MB1257:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR04MB12578E65B81A915A0156BCA9E76C0@CY4PR04MB1257.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2043;
x-forefront-prvs: 04519BA941
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: z2YZXAJlCVcpfo1tb4PyNnXADygXHFBW6g89Fdjx0VlF1N58boYqsbvIwitnZ2x0erM4kdhjGoTadftE+CXGdLxvmVTtfY/TZYiq3XwA3xNZ/9KRX6G3UwWi6pyvEoeYmmzIe4sESbj6BO3a/7dtjWbIttTjBZqkNlg74IHaYba/4noudSBzSs1lxjW2jZMLKvKzyrqPFb+Jv/vQsQABpkWlhGfqZJ9AmkWojmFyx43fXpS4L53bi9HtRRk2dd7aMtYuax22oUf06N4ExC6ggruO2Y4l3ywgRQmZ6L2nruqOJQp1XY4+uHhv+5pjkKboqzxYRY2JOELPXUkNfhBdwOpudmElPqecMpta+ggOMZuVVGtabr54lFh3JLgyBYyL
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(376002)(136003)(39860400002)(366004)(9686003)(86362001)(64756008)(66446008)(33656002)(5660300002)(52536014)(53546011)(66946007)(66476007)(66556008)(83380400001)(186003)(7696005)(478600001)(55016002)(6506007)(110136005)(8676002)(26005)(8936002)(2906002)(316002)(71200400001)(76116006)(91956017)(32563001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: LwSxL0CwTml/52WK9KlrEc+Et+KyD966wr8JfNxPCpTrTn4ItZLCcX/yvN0ZSL9E7/Fp7AOfUpW39LtH8iUm0GspnDXURN1BO8ynTElxJEXjjvQUnFXaarNGXrzshzLBNSSbfoev1gYkivlG+Gp6Aj5ilsKExx0B6r1ZsZ9jJe7pvFYt42bQtlO9q8gXCPftRWH2NWhgCeXqW1ZHJSlCcb2yAzz9hfKnzN7c+xr1FjHaphdhbJ6br+KVI3sbNueaErnzqhCAPLlXjSPm1b+YnWDt9KsPOTTta8WeTPlwzfwPlpmOKi2G0YtHBYsnUjvUH3oPCItXIkQrTccOTfciy4x712psx/OsNGoedha1sjIQE6gXzOnJom6GMgEWzqiKtW3nCG77NrhvdoIMDsJu4L/Qlzv0DBQr3XjtSHZVJyBgXVi9q6Nk5SGnf/XG7/rExgaEjvEG8wHxTwJWoovg8w9wDc9putFuf0xMP2XelLlx6oTimZ9NRw2eXm4g8gG9
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1aaac170-b35d-4442-487f-08d81da9f815
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2020 10:31:52.0178
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WNQbznRgMVIZAA3KToL/RX5gbIPQzL/jpgSLAnic2H4F5UqSKJG4SHzou5T4FB3m1qHGh67MYoi/pgVkXUeKpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB1257
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/07/01 19:10, Johannes Thumshirn wrote:=0A=
> Looks good,=0A=
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
> =0A=
> While we're at it the next block does a direct return manually unlocking =
=0A=
> 'ioc->pci_access_mutex' and rc is never set for any of the error paths =
=0A=
> in 'BRM_status_show'...=0A=
> =0A=
> Maybe we should add this one on top of your patch:=0A=
> =0A=
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mp=
t3sas_ctl.c=0A=
> index 62e552838565..70d2d0987249 100644=0A=
> --- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c=0A=
> +++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c=0A=
> @@ -3149,20 +3149,20 @@ BRM_status_show(struct device *cdev, struct devic=
e_attribute *attr,=0A=
>         }=0A=
>         /* pci_access_mutex lock acquired by sysfs show path */=0A=
>         mutex_lock(&ioc->pci_access_mutex);=0A=
> -       if (ioc->pci_error_recovery || ioc->remove_host) {=0A=
> -               mutex_unlock(&ioc->pci_access_mutex);=0A=
> -               return 0;=0A=
> -       }=0A=
> +       if (ioc->pci_error_recovery || ioc->remove_host)=0A=
> +               goto out;=0A=
>  =0A=
>         /* allocate upto GPIOVal 36 entries */=0A=
>         sz =3D offsetof(Mpi2IOUnitPage3_t, GPIOVal) + (sizeof(u16) * 36);=
=0A=
>         io_unit_pg3 =3D kzalloc(sz, GFP_KERNEL);=0A=
>         if (!io_unit_pg3) {=0A=
> +               rc =3D -ENOMEM;=0A=
>                 ioc_err(ioc, "%s: failed allocating memory for iounit_pg3=
: (%d) bytes\n",=0A=
>                         __func__, sz);=0A=
>                 goto out;=0A=
>         }=0A=
>  =0A=
> +       rc =3D -EINVAL;=0A=
>         if (mpt3sas_config_get_iounit_pg3(ioc, &mpi_reply, io_unit_pg3, s=
z) !=3D=0A=
>             0) {=0A=
>                 ioc_err(ioc, "%s: failed reading iounit_pg3\n",=0A=
> =0A=
=0A=
Indeed... I did not look at the other early return path :)=0A=
Can you send something ?=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
