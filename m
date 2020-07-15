Return-Path: <SRS0=K8op=A2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56226C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 03:09:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32B4420729
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 03:09:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="fs4j+aLr";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="wqoguLH4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728048AbgGODJY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 23:09:24 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:27396 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726782AbgGODJY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jul 2020 23:09:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594782571; x=1626318571;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=c7uP6CNiLriQf15GT3Pg906gB/7/Xi4bXuH9p5E5Brg=;
  b=fs4j+aLrokSl8kLVCAMVnsTsLEgosi9UmrvynQCZ3qKegcGGkcHkrF/u
   wP7CZwTpzcmP4008w/L9fSNzxfJb8ETLTW29BOe/BQBip+i71lB0yoxzj
   u++xr9F+11ylPJl0dobCo2E4wK4t1GeDcgsdqT9dBhDXysGTKAR9X0DSk
   shGbhJn3zuxM0bMXHj5+mZ+f/lP3VI0jZNwaji5ZKUdYWNjbQW2TpnZps
   BvpuEUs/7RXaaJ66D1KtzhL1bl403xgWlkYGXYI49uC66ApM1gXlp5T/a
   14H0CmkA1uLr5Ywi9po08+UHRjbhmFmAfE9rwskC37gigKB5xIci7lGHP
   w==;
IronPort-SDR: ka8pFelQCpZuJbiS/foIK2QRLYWOC/YysYGMPruSCOv76gJaA9ze3iqqXLZBVvjBpPXmx9WBYY
 UmVFBeJrzd1arxpdOeT5iU1Gf4CDne0E4MWy4QCNxglh5pPz71sPKI3wy/uaLPOBljI9XNE+NJ
 iXUk9TjxRK6l9ZnDHNsbcfuKOK3KBet1/Pb5RT4K/WhhXqxmeA6/6wEi271Ibi7CmhfjHwkoTe
 TpvDVTB79aTCJmaQqkkISm4tZH23Wa6ZhSH4yXJjzuuXRTyb7emDCKKa0ilh+s6dPFtlYh638u
 zHc=
X-IronPort-AV: E=Sophos;i="5.75,353,1589212800"; 
   d="scan'208";a="245512846"
Received: from mail-mw2nam10lp2103.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.103])
  by ob1.hgst.iphmx.com with ESMTP; 15 Jul 2020 11:09:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KKUQwOXAGiNxMO7sKPPFF9yHZbWnZ1k2XONgjUbLSOcLxiagImrDZrOTg7SpoS2KvFzKJclDjm7VaU9HSW/BJcXLzbgwJfhu7sUGu4fU/raMa3STD9jgzqvRmL3a3Bv6/QEg3BTODLaujCAAZzgc7d13UaXgo0TAtRR2Na9PvL7nNQrvN7+o2B1xvndVnKRKJyCfdZFRK8np9RIlzzkYwPriB1vG8ztS4NzBKwbTA3yT8zSE96ZTvJD0XcarxBh7SGb0PknEjLR/18Hc4w20cUwEgbSoNO/iFJG9lZKapjx3ME5R1UZ3h+4g36VYLLMyJAUg8I+31PWY7wBJ2m8ysg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=22ltt7OmbMoTALpdMclcynaNURV4JQG3+HJ7LFSQkXk=;
 b=ima2UCOSQMvKUgCt6cca/k+VYMXYaqqRJXig3Xg6NjIQ8PnCWH5X7gE5+Kn9bWbprTE/zgH73CUhzkoXtlQhHj5o/zDR8YfVujwFCnpRjdrriQThQkUva0USug1xpOMNePbEtSd70HW0ynprl2K2Txq3OeKARmVFvbTd5wruZKlEQmziW2t1TW39uvt6b3vTUUfutl75LiIRiqpr9s31DKawSCo4CfUEcaHh9suFKMOj/y5BubOm8zszrIFxviOfInyK2VhX4Q0Zs1zuj16cmUeEhddfVKY9f5BgvBVxzO43l5WT/ZpuZZRMU3ZABesCd7doiD+rj2xIEiMEcXKYxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=22ltt7OmbMoTALpdMclcynaNURV4JQG3+HJ7LFSQkXk=;
 b=wqoguLH4N2gQRWOzYN3P1gQNsblGIqxndlAfouI/ghp/d6JWYT5uTEe0lNFvhBo0PI8lqlYQGeEgR0hkUBr3EGKVl60SQt9gh5LehJrIj+/GH1fDzK6bRSGx3M/Q/hm3AsvP+M42LcuHjtCbsOuRx+mJbm7Zm1fTeLWO8yjRfNI=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB0726.namprd04.prod.outlook.com (2603:10b6:903:e3::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.18; Wed, 15 Jul
 2020 03:09:21 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::d9e5:135e:cfd9:4de0]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::d9e5:135e:cfd9:4de0%7]) with mapi id 15.20.3174.022; Wed, 15 Jul 2020
 03:09:21 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     YueHaibing <yuehaibing@huawei.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] scsi: sd_zbc: Remove unused inline functions
Thread-Topic: [PATCH -next] scsi: sd_zbc: Remove unused inline functions
Thread-Index: AQHWWlN7NKge4SNix0SXkuH3KHfQTg==
Date:   Wed, 15 Jul 2020 03:09:20 +0000
Message-ID: <CY4PR04MB3751AB30CAB7C9012D2FC4E3E77E0@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200715025523.34620-1-yuehaibing@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1be8309b-0225-43ac-ad95-08d8286c782e
x-ms-traffictypediagnostic: CY4PR04MB0726:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR04MB0726CE98727A8567C7936909E77E0@CY4PR04MB0726.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:324;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KBKEP3tk7nNj1YcHhQg2RklnHu0vTy2f5WK9xncXjcY2wAedWyEBkiZO8By1xw9qbPjiD6hphAFti0uVGnRcxTDADRXjilebWTWo2OQnn6skTYIf9QsCcxhAP+rUQZCPF4HZHIqWhPzfRnWkY0YZMExuggU53FaUm4WHC1S8NUdqQdNy0K7CiiUXtBeGPZX8AWAgNBzxg4lZavqfF4xezBCofpCMW/e26M/0ptVQu0ASc9KgAdxt/ivfUxdtXeMXSqemy2A1KRUuUdbYx0jVG8HPLE+/O6qyEBf4hAa/mBxiNT40Klm9g7TottzDOhOW29mgFF6lSCPRZZohfI7ulw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(366004)(396003)(376002)(39860400002)(136003)(66946007)(91956017)(76116006)(9686003)(8676002)(8936002)(33656002)(7696005)(52536014)(83380400001)(6506007)(53546011)(66446008)(66556008)(66476007)(64756008)(4744005)(4326008)(26005)(186003)(5660300002)(71200400001)(6636002)(55016002)(2906002)(478600001)(110136005)(316002)(54906003)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: /iTJCBXJfHmSsEkENxwauBODbgpLw4bd8n/t8DwGNu22Oo+byYImD1SzWg8gjOEO9aSMzX8OkvpsjLrNr8YNe8wG+qA7nYDpRvEDf3tFr+aBZvmhQZSCOQwnjYUEi7Li6R+426HoUp35/dnZR3Lu68JXwMJGtyHs4HN1Y6eap6QMdKmwc4HUqwlzpSfLQA8rMVWtHK69GYEgcfcyna5tuiu4VvKY1yoD0VEJD0jxFGfnjrT78fbuPmtU5+dp1PJRCRmtfdKZvXquKj1Q60DAis1vGdz6uQbjbbk6RPsRPFLaJ5pXqdiqKURboH1BWO6pqyZBdMgyHhRDKWStnOg3THp5dzfjL7988IU1D9YZ53jvrXZPguum53AGnT2A90A0r267TjS1fZEKLoDmts+jDWWJUi4aZqZB5EysDYvoXwgGoU53nz+7iAoyuW6ESJjDOyy1uUgNtgFHjbn2Irwd3hfXto/rwHK1gVem1eqa1+7o4P9rYVwnd8hhchP9UESL
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1be8309b-0225-43ac-ad95-08d8286c782e
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2020 03:09:21.0069
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3bz9kbCVupz9TTymCmsyE95ve35zLI5PafQ4rN2jB4V/1c+VVbwHYYt5OArY77ilfSvn0vBhyi01FGdfqyA0TA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB0726
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/07/15 11:56, YueHaibing wrote:=0A=
> They are never used, so can remove it.=0A=
> =0A=
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>=0A=
> ---=0A=
>  drivers/scsi/sd.h | 6 ------=0A=
>  1 file changed, 6 deletions(-)=0A=
> =0A=
> diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h=0A=
> index 3a74f4b45134..27c0f4e9b1d4 100644=0A=
> --- a/drivers/scsi/sd.h=0A=
> +++ b/drivers/scsi/sd.h=0A=
> @@ -229,17 +229,11 @@ blk_status_t sd_zbc_prepare_zone_append(struct scsi=
_cmnd *cmd, sector_t *lba,=0A=
>  =0A=
>  #else /* CONFIG_BLK_DEV_ZONED */=0A=
>  =0A=
> -static inline int sd_zbc_init(void)=0A=
> -{=0A=
> -	return 0;=0A=
> -}=0A=
> -=0A=
>  static inline int sd_zbc_init_disk(struct scsi_disk *sdkp)=0A=
>  {=0A=
>  	return 0;=0A=
>  }=0A=
>  =0A=
> -static inline void sd_zbc_exit(void) {}=0A=
>  static inline void sd_zbc_release_disk(struct scsi_disk *sdkp) {}=0A=
>  =0A=
>  static inline int sd_zbc_read_zones(struct scsi_disk *sdkp,=0A=
> =0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
