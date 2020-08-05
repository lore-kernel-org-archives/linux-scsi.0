Return-Path: <SRS0=g50V=BP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AECDC433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 09:10:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE45F22CAD
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 09:10:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="oPYuT+gx";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ia/wV2K6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgHEJKN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Aug 2020 05:10:13 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:7879 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbgHEJKL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Aug 2020 05:10:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1596618610; x=1628154610;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=xn85nVovOiF2bM12FYakvGvHE/8/5xJCknKbsn4c2oM=;
  b=oPYuT+gx2xGVnHi6y6OOSlMLVM8neDhg+pU/nFUd4VhrccM7hFNjdx5J
   xYdk556KVkfbg/F9SdUAvifInxcoQDzxNcmgpJPHbHH+4P0ucE4fChNtp
   XHcHrNK7KWye0vV+Y2GEZA8j9OE/Rf1+ReD+0S7ULTOp4NpES0FHXBwSd
   dlHcyJB+OB7w3Aj+BOlsqtm6wgewWxqGcGLk9ew0qiNXsRtjA594zQSER
   nVsrfGJGgUjizl+NzmINHeZN4i1FgEugFen9wJxeMLl4u5ldNi51x1Vvq
   /MsAqO+N282pgGKwE1oqbWaWrSsjTPPm3L7YE6nO/2Qu5SB5wf6w8aATo
   Q==;
IronPort-SDR: Wzk1N6uw0wEjO9IzYBeHzjpqCVPubwrfQkcUG4LlUfo7KT47vUAl5NCVqnmbDmMaxt1aHxXANH
 1edZ6r6vwSdXYc8EdVI/Hp0hiW8cXT04MUL7csHfFxp37R6EyxatC2KKcBk3Q6i9in+6JQPXkd
 +NRWbz4rEJOjULseNhuU7KzEJbj7Zm4UV7vhjGaWmUqVdui37GvKPqJF1c9ylD5vRN8QtlAMqK
 oWwQrPLv7KYXFIoBxeXvPghxMnBlXpdKqi0WiCK983wfhYYUZi24jKIZMgEFUETCSMCIJIDGmI
 uYI=
X-IronPort-AV: E=Sophos;i="5.75,436,1589212800"; 
   d="scan'208";a="148501588"
Received: from mail-cys01nam02lp2059.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.59])
  by ob1.hgst.iphmx.com with ESMTP; 05 Aug 2020 17:10:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L5yXqMB+qC6MBFgTsh1MSc9VpTJrsDnPdP7KGN1r7F+VQNmGUtxDDv6nbs/qHBdMs0VOs4RpdXBmHFDJmOeLcD4nsFJ/wCOXhbAWJUWM0Q6WorQdshbhziB8UJcmae4bvL6+QWb4NAbHGjAstRqjwX6zaWmDmde33cmiHQnnFr6unccwb2Jqjo4o9diVb2WAx0fKtLoIFChnXO48GIJauB7L5hq9IJeVuwmB4NwGFpSq6YOCFrOVUWP8lV1OSXGbacEXIS6YlSy7JQlMj/rfYeVONYOusOctVOWaKn9RlaAbxfGwvIcBUofVLbatov279AthYMRidoDuIfedthSplA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SXO4DMQGmIcAqbyQ4ACkLxJ1OTbva1gzYkNdZs9dico=;
 b=Ufq1FMfNxyKyDCCfPnyOBhJT6wxpSnTPs6dwtFQKZVKrSq3aYD7u8akdWiApws8f5YGX4so3pvvQotJ0B8OYg5XvDLOnAt50HVbQnv7ZjLfsh4264teT7lyn06R/4FLxEZTeX4KcQmnimC9WE5zm//nW80P5O7F4IwYSGC4mKNGSsnfSWlK2nQuG/6TKi+yCPjCqH7PUgeHJ4XASK7YYLbDB6eosEykHTFy692JY2dDUE0MjrSg23064metWYdQHajI/5OnWZHAjW1yOZllBqeFhgEJTsTzAcZ+CPizwoZ4JnMOYZhPLqlOv2p0fyIPwKT4X390mFEfKXR6CheYv1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SXO4DMQGmIcAqbyQ4ACkLxJ1OTbva1gzYkNdZs9dico=;
 b=ia/wV2K6kuFG8g6ZTEPP4lkR2mKyFYDz62W9DXgw5/lnh4V21axbsxEd1XIfEArbwNa+D48NgmHBPXqbGUforvhJ5c+pcvxAoZjx2ztIcCaWADd85Vv45wO2S1shKUek+YrHTC5m+TgLBK9p8EimVoGSCTmn1E5iJSGEUs5o7M8=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB1256.namprd04.prod.outlook.com (2603:10b6:910:52::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.21; Wed, 5 Aug
 2020 09:10:08 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::7d15:9936:4b3b:f8a2]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::7d15:9936:4b3b:f8a2%12]) with mapi id 15.20.3239.022; Wed, 5 Aug 2020
 09:10:08 +0000
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
Date:   Wed, 5 Aug 2020 09:10:08 +0000
Message-ID: <CY4PR04MB3751D2A831C76747DADD7C4EE74B0@CY4PR04MB3751.namprd04.prod.outlook.com>
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
x-ms-office365-filtering-correlation-id: 1f928c49-c596-43c9-fae5-08d8391f59e0
x-ms-traffictypediagnostic: CY4PR04MB1256:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR04MB1256AE849F6DA1548C65FBE2E74B0@CY4PR04MB1256.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MrBiZdR9TkKiCL8mia3vwNg1oJVuNgIjjqtOE7LQBXpfsQRd/nWZhCyVCKANy+tHxmr+MmR6Xr/rArgbwH+xCsmnisCeBb7zyLKxGxsjLuoA7x2lnJ36X1GWI3IOUi/c7pkwi4Zmyv3sCiSUDPgP7C8rGHyB2JH/mNge1uoIak07OqI7QwF51huxx3x4JurqZiVa4hYF/9v3C2O7raF3wy/jkQYkmHOqUICQFO2PwLQy6s0WSsl7uINmspU5TbSBCPKuzjtHW+HTANCkmX+kpioo12T7pW2YRDf0DohnXAB2rRSdT5ueN9EJZEHxsJIkahog5KDR7IiDazZisEcTGQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(366004)(346002)(396003)(136003)(5660300002)(186003)(8676002)(52536014)(33656002)(8936002)(26005)(54906003)(110136005)(71200400001)(83380400001)(9686003)(316002)(478600001)(55016002)(76116006)(53546011)(86362001)(91956017)(15650500001)(2906002)(4326008)(7696005)(66476007)(66556008)(6506007)(66946007)(66446008)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: gc3zkJFFXV7N9Sfu9NhFhzXt43CyOpFlKR2L5vNZSk66KHc8d+/Li+Rux3/BmX4OqNLdnhRsazVegydN7gIR+K9bnHE9JDSz1wXkKT68N73wG/M3w7s9txr9JElynB5SJ7qXSe+kvXTzyZ4+XniLWi70VTJ5z3eZvbNyYyCay0XJ+XgSQf9YDMOpu8ZwxVB07rIMX8JmHKwVKHmPYAAIhfRa3Ee8KXqccVXrjtXI3Z/Mfc6veiS9eSPRc7zXOV/WSKY8EJLWntFjDdV6KE894ZeucwZQpFdZO9UYVHnkvEKyNP1AR0rr0vPieGX8HFqB5igtDyzOKVse4+qXSK3AMFZewACp0XMG73a4si7ZMjULdN//+pi0fFlPFciMbZOq7vf2CPkuOzAUq12wvXD5YOw/bA983fq7ANbyLHpzz4UZoVbMpJ7CP69bn0YyZUA1DTdY90oDkSpYWNHymVKAkF7IgWTfjssT6Y4WJHjIMXFCf/Xz2FDOsPYH3iKXmvNJyM0LZzmBLUWiar7YBmQUuGOSTYn5OFnpnZ6qUDnRjMjSoElXrACE9CiiX73Xn98fjJtjGFUL1jCajdeGpN4w2XXJzffQrzSo0wYfUgONpfec8JWDKhrddWn/uYR2btiymSiIULIziBTq6ygOYlrAhQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f928c49-c596-43c9-fae5-08d8391f59e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2020 09:10:08.5562
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7bQInyXoYt2TZEWAy+8Rje5ilm6MUYZKWwiFwy9C0Xm9dTnnkNw+ZARI0xTAtVCHtwBbBoYFtExH95xwxHda8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB1256
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
=0A=
Thinking more about this one, I think it does not work: if rev_mutex cannot=
 be=0A=
locked, it simply means that revalidate zones is on-going. It does not=0A=
necessarily mean that sd_zbc_report_zones() is being called from revalidate=
=0A=
context. Eg: when revalidate is ongoing with rev_mutex locked, if a user ca=
lls=0A=
blkdev_report_zones() which then calls sd_zbc_report_zones(), the try lock =
will=0A=
fail for the user context, and the execution will not change from before.=
=0A=
sd_zbc_parse_report() calls in the user context will still update the wp of=
fset=0A=
array as it sees rev_wp_offset !=3D NULL...=0A=
=0A=
And with the report_zones method interface as it is, I still have no idea h=
ow to=0A=
differentiate revalidate context from regular report zones user context. Un=
like=0A=
user space, we do not have recursive lock on mutexes, so can't use that eit=
her=0A=
to serialize parse calls.=0A=
=0A=
May be something like this would do (not pretty...):=0A=
=0A=
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h=0A=
index 999f54810926..fba312c8725d 100644=0A=
--- a/drivers/scsi/sd.h=0A=
+++ b/drivers/scsi/sd.h=0A=
@@ -84,6 +84,7 @@ struct scsi_disk {=0A=
        u32             *zones_wp_offset;=0A=
        spinlock_t      zones_wp_offset_lock;=0A=
        u32             *rev_wp_offset;=0A=
+       struct task_struct *rev_task;=0A=
        struct mutex    rev_mutex;=0A=
        struct work_struct zone_wp_offset_work;=0A=
        char            *zone_wp_update_buf;=0A=
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c=0A=
index 33221d8e9f8f..53f0489c3433 100644=0A=
--- a/drivers/scsi/sd_zbc.c=0A=
+++ b/drivers/scsi/sd_zbc.c=0A=
@@ -69,7 +69,7 @@ static int sd_zbc_parse_report(struct scsi_disk *sdkp, u8=
 *buf,=0A=
        if (ret)=0A=
                return ret;=0A=
=0A=
-       if (sdkp->rev_wp_offset)=0A=
+       if (sdkp->rev_wp_offset && current =3D=3D sdkp->rev_task)=0A=
                sdkp->rev_wp_offset[idx] =3D sd_zbc_get_zone_wp_offset(&zon=
e);=0A=
=0A=
        return 0;=0A=
@@ -688,10 +688,13 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)=
=0A=
                goto unlock;=0A=
        }=0A=
=0A=
+       sdkp->rev_task =3D current;=0A=
+=0A=
        ret =3D blk_revalidate_disk_zones(disk, sd_zbc_revalidate_zones_cb)=
;=0A=
=0A=
        kvfree(sdkp->rev_wp_offset);=0A=
        sdkp->rev_wp_offset =3D NULL;=0A=
+       sdkp->rev_task =3D NULL;=0A=
=0A=
        if (ret) {=0A=
                sdkp->zone_blocks =3D 0;=0A=
=0A=
=0A=
This is totally untested...=0A=
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
