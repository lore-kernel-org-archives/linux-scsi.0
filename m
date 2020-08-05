Return-Path: <SRS0=g50V=BP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7B9DC433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 01:38:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6D5E2177B
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 01:38:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Mr9MDmyR";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="vzY0UWN5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726011AbgHEBik (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Aug 2020 21:38:40 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:35250 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725863AbgHEBij (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2020 21:38:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1596591519; x=1628127519;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=KnYeCe4K2y2uXNnLBIsYeOCUTwPjvnvmSp39OE6aqTA=;
  b=Mr9MDmyR7I0nnHZ3lTHQ+0xcoWwQ6JrszS65+uBbMXk2TA4DTgK1c14n
   U6aWMo5eLZTXOYoF0m5JegbsmRllt33bw6hf6NjwM4ZfIbaQpqU6992Xg
   sj9zHlGVpSvnZWiIZkP8OKhv91RxaCtwOkrJMS82E56ts1H5TU/nX6qvW
   vzKY7Y+lMTDXbUXDpBDugHDbYHCP8r2FTvuXKoFbPy/rjzw4/nltCuGVP
   QmI7leYRxILFUH8SuVoFRcCbUkmK8Jtq7fvKqgdxm6z/BURSS4E7q132S
   WIZkiePJwe0kXekZSCSgGvKATFQT6XygxxZEeJ8D6RdCNaF0AHLg8TCuZ
   g==;
IronPort-SDR: 6hzIa19E5Xuj3GqZvg4OyN6A7ToodbDO6GWK5ByhAyPf5QyzaIGNlhpOzh8oWlGME6so9vEWBi
 4Iad6TXhNCwSDORBFXj2SIjMasv0Z50wYTg5M3LdigS+DH6YTtYPZ7LmgYKkHFVx0PmQjgWIIa
 dQYwE5diCJQVpDFipfewJ+JZHAegZZOwqSwTcmgiiybPrMkXtQXIVvASTIsepKTvadYpMvzCrV
 9yHHuHQBQulM9953k4cpC0xdH5Ch+NlRKrEkwCLBpNGtoIhG3N4QoZi/E2satOhXr4ashZojKK
 pJU=
X-IronPort-AV: E=Sophos;i="5.75,435,1589212800"; 
   d="scan'208";a="145393722"
Received: from mail-co1nam11lp2172.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.172])
  by ob1.hgst.iphmx.com with ESMTP; 05 Aug 2020 09:38:38 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lAnFdPFvPSZXMvZSlyCUF8w3NKqQaPij60Cn/1HdmYtouzO3zE4ujGb4fC+f11CpwRWlU64UghscCsJoTaEF14YyxY1pqboO2IGCET/HNFjz4oor3YEx8ClPM+HkkSVsq9Eh7HDmgImcy8ZZqc/bw1ZNoYUWMOOU2x0xXvibNmVaHnqD/bL1C08AL/h5cnXFr3bGVnKHfFhy9BjyYQ1sQZh0Tlu2jskZHDHEAfsPESTmIuGe7GwgJFI9UNzunv2+Z78qURBvMsJs3Q6I5UPawtuc5e0T4BswbU7VNA/OumrKOnqqpWkzQDHelY1r3apXqU2RUsXlAwR5KWxb7pyWdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DcfGwDN3sJuF40dzWlmTxDcWvSA3E/pCLZJ0NUdORlg=;
 b=KzMfgr11GQQMSYv9XUE9/79ZfneB5TqX3zJzDng5u6owgRPFMfsot4H9+gB3uOLEHSu69wikyo8+sjYN+c9qK+4sLgYKA+J3z0voy893seGx3/DI4M2ALAxOJHEsj6poaoMvp6YE3zs+VEZc6uUqbWhP17m2c9UidsnEvuu7GUVBFL6Ly+DWMOlSS2iDsMOk8CEMaIhu7eBUYXnERRiQvX3bbma1Twc5oxq+WHwbK7f9+lCGsfYsW4WUv7gUhbbw72BE8sEgcZ8ut0uHO9gsAWfQQ6NOK3hko6FHASTdYIb7gVGlA34vs5n2CsqnvOeHdMpDDt7mEkQNDY3VlkFoCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DcfGwDN3sJuF40dzWlmTxDcWvSA3E/pCLZJ0NUdORlg=;
 b=vzY0UWN5ULJPwd85qFR/1dHVJg4CISJkGIRYdMspJM7eD7W+FFtR/AhbQKiGFRiFXpXGLNyrNkd9s88ZiOxcjAZEyouW80fjQsdvROvzD9s1gdXB8qtARFiShKioORdV9g+D7EVUm2xkHVZfiPrPgparDvr91bomffZRsCrB2gI=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB1030.namprd04.prod.outlook.com (2603:10b6:910:56::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.21; Wed, 5 Aug
 2020 01:38:37 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::7d15:9936:4b3b:f8a2]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::7d15:9936:4b3b:f8a2%12]) with mapi id 15.20.3239.022; Wed, 5 Aug 2020
 01:38:37 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>, Daniel Wagner <dwagner@suse.de>
Subject: Re: [RFC PATCH] scsi: sd_zbc: prevent report zones racing rev_wp_ofst
 updates
Thread-Topic: [RFC PATCH] scsi: sd_zbc: prevent report zones racing
 rev_wp_ofst updates
Thread-Index: AQHWamsof27WULy8qkaZjfAao5GmhQ==
Date:   Wed, 5 Aug 2020 01:38:37 +0000
Message-ID: <CY4PR04MB3751D3876B133B764134DED5E74B0@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200804142541.17126-1-johannes.thumshirn@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9006ae4f-bf24-48fa-0601-08d838e04633
x-ms-traffictypediagnostic: CY4PR04MB1030:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR04MB103095CB0923B4E7595F7FD2E74B0@CY4PR04MB1030.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7+p0ecr9KUz0nAKDUQTM9fKdLQohqTvIJcu6c0SOEQyMXdeLyGOQX9ZwVcyNhGwafFJX+VPCrviLKqIOmlZK88bHoiTvzFvApt8Ud7K8TCu/g3qz1g0ztKKFXzutk1wB+GGLbT9ijBc89KHp9ME6h0X+MXPi9VY7Yp4lofRFcAD8FmGxl7fcF4rjTeKxeFrKYmynZRLTny+tE9X1aJBWQPC260abMPKFNF1enjowEeKtANwpQaIli3TFt0AW9hjQgWX7IhZapabWUywLlIfB2iAVxFar/sFspJhzkvK6EwRKUELgKPXpSNOFQBI9g3T6qcJsR9rQeJFL+TxIGuCKOQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(366004)(39860400002)(346002)(376002)(478600001)(7696005)(54906003)(2906002)(71200400001)(110136005)(33656002)(86362001)(53546011)(66556008)(66476007)(76116006)(91956017)(66946007)(6506007)(66446008)(64756008)(15650500001)(8936002)(83380400001)(4326008)(55016002)(26005)(186003)(5660300002)(9686003)(8676002)(52536014)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: ypd1b6ahXH4xglT7H1tBPEDTLR49kYP4jpbvQ4ICJXifAC/vYJ5T5O8D3LgEvPfcoOAoLFFwKCDNv7q+m8eX9bwaFrBvwhlSobyhH+KCuiFKsma+ZNiYNt/gYaXdjd4HwRwwi7+Mtjmq2DYW5x0LiFsZE6GycQEkaSO+DWpxbKw20VyAYzGsS4whEwuSVm0/X3b19exrmp79ab2lwfH4tT78uj1e//j2Ujy8gESXXBI3utVFe7ZG2Kiq/J/RUKvtclO5VlA6m+keczn3ON/OfHFRK0OdaBraf9BEX2RUNrWaTBKptzwAnXoqbpBu/8fvBIaWsS0P6/Maenr1/qI5vhwuBm5ZU6QWAgoODE7UFyYmCJ9VXgbhv+A1AGMZtcSQBRDIRtkw50mr5A6LsBOY53jt9ZGns+1oQw0LGWb99SZRnfBCvgptulu9KibawL2HvxQOrbU61+HKWAn5QXvC8gj4kExD5nZ/VxA2VeeDFXUXfxLxbZqCZ/kWEyneVpCNlx7pkFeYLLUkvwuqcPpGt/wwXxlTEScJ4Vn9b1a4Q+sPQg0mrp20bcijM+PEwKopFH6E1dlqwcO67q6YNprC2EatycrMWq6cn5TBNtXS8nraz0iQktjk47IYpP0H0CY/1mgSBiE4W5HufZnNBi/3qw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9006ae4f-bf24-48fa-0601-08d838e04633
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2020 01:38:37.2604
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tVPjOrhlPErrPH/hCIejYSkt5e1KxAVAHHzk5UZipqPnitEnKtZciPYNcOwPam1pDxQRbjNaGehi/iDHhocEdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB1030
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/08/04 23:25, Johannes Thumshirn wrote:=0A=
> When revalidating a zoned SCSI disk, we need to do a REPORT ZONES, which=
=0A=
> also updates the write-pointer offset cache.=0A=
> =0A=
> As we don't want a normal REPORT ZONES to constantly update the=0A=
> write-pointer offset cache, we swap the cache contents from revalidate=0A=
> with the live version.=0A=
> =0A=
> But if a second REPORT ZONES is triggered while '->rev_wp_offset' is=0A=
> already allocated, sd_zbc_parse_report() can't distinguish the two=0A=
> different REPORT ZONES (from revalidation context or from a=0A=
> file-system/ioctl).=0A=
> =0A=
>                  CPU0                             CPU1=0A=
> =0A=
> sd_zbc_revalidate_zones()=0A=
> `-> mutex_lock(&sdkp->rev_mutex);=0A=
> `-> sdkp->rev_wp_offset =3D kvcalloc();=0A=
> `->blk_revalidate_disk_zones();=0A=
>    `-> disk->fops->report_zones();=0A=
>        `-> sd_zbc_report_zones();=0A=
>            `-> sd_zbc_parse_report();=0A=
> 	       `-> if (sdkp->rev_wp_offset)=0A=
>                    `-> sdkp->rev_wp_offset[idx] =3D=0A=
> =0A=
>                                            blkdev_report_zones()=0A=
>                                            `-> disk->fops->report_zones()=
;=0A=
>                                                `-> sd_zbc_report_zones();=
=0A=
>                                                    `-> sd_zbc_parse_repor=
t();=0A=
>                                         	       `-> if (sdkp->rev_wp_offs=
et)=0A=
>                                                            `-> sdkp->rev_=
wp_offset[idx] =3D=0A=
> =0A=
>    `-> update_driver_data();=0A=
>       `-> sd_zbc_revalidate_zones_cb();=0A=
>           `-> swap(sdkp->zones_wp_offset, sdkp->rev_wp_offset);=0A=
> `-> kvfree(sdkp->rev_wp_offset);=0A=
> `-> sdkp->rev_wp_offset =3D NULL;=0A=
> `-> mutex_unlock(&sdkp->rev_mutex);=0A=
> =0A=
> As two concurrent revalidates are excluded via the '->rev_mutex', try to=
=0A=
> grab the '->rev_mutex' in sd_zbc_report_zones(). If we cannot lock the=0A=
> '->rev_mutex' because it's already held, we know we're called in a disk=
=0A=
> revalidate context, if we can grab the mutex we need to unlock it again=
=0A=
> after sd_zbc_parse_report() as we're not called in a revalidate context.=
=0A=
> =0A=
> This way we can ensure a partial REPORT ZONES doesn't set invalid=0A=
> write-pointer offsets in the revalidate write-pointer offset cache when a=
=0A=
> partial REPORT ZONES is running concurrently with a full REPORT ZONES fro=
m=0A=
> disk revalidation.=0A=
> =0A=
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
> ---=0A=
>  drivers/scsi/sd_zbc.c | 11 +++++++++++=0A=
>  1 file changed, 11 insertions(+)=0A=
> =0A=
> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c=0A=
> index 6f7eba66687e..d19456220c09 100644=0A=
> --- a/drivers/scsi/sd_zbc.c=0A=
> +++ b/drivers/scsi/sd_zbc.c=0A=
> @@ -198,6 +198,7 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_=
t sector,=0A=
>  	unsigned char *buf;=0A=
>  	size_t offset, buflen =3D 0;=0A=
>  	int zone_idx =3D 0;=0A=
> +	bool unlock =3D false;=0A=
>  	int ret;=0A=
>  =0A=
>  	if (!sd_is_zoned(sdkp))=0A=
> @@ -223,6 +224,14 @@ int sd_zbc_report_zones(struct gendisk *disk, sector=
_t sector,=0A=
>  		if (!nr)=0A=
>  			break;=0A=
>  =0A=
> +		/*=0A=
> +		 * Check if we're called by revalidate or by a normal report=0A=
> +		 * zones. Mutually exclude report zones due to revalidation and=0A=
> +		 * normal report zones, so we're not accidentally overriding the=0A=
> +		 * write-pointer offset cache.=0A=
> +		 */=0A=
> +		if (mutex_trylock(&sdkp->rev_mutex))=0A=
> +			unlock =3D true;=0A=
>  		for (i =3D 0; i < nr && zone_idx < nr_zones; i++) {=0A=
>  			offset +=3D 64;=0A=
>  			ret =3D sd_zbc_parse_report(sdkp, buf + offset, zone_idx,=0A=
> @@ -231,6 +240,8 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_=
t sector,=0A=
>  				goto out;=0A=
=0A=
You need to unlock rev_mutex if unlock =3D=3D true before this goto, otherw=
ise zones=0A=
revalidation will deadlock.=0A=
=0A=
>  			zone_idx++;=0A=
>  		}=0A=
> +		if (unlock)=0A=
> +			mutex_unlock(&sdkp->rev_mutex);=0A=
>  =0A=
>  		sector +=3D sd_zbc_zone_sectors(sdkp) * i;=0A=
>  	}=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
