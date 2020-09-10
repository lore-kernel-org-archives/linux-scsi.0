Return-Path: <SRS0=aJuI=CT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D83FC43461
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 07:45:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C2CC207DE
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 07:45:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ZJSnNfyB";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="sjKQUaQU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgIJHps (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Sep 2020 03:45:48 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:53827 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726746AbgIJHpn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Sep 2020 03:45:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1599723944; x=1631259944;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=WPVPJxPN/NPXzOvPSlpcCyN72t9PgFdfS0UuY+N3b0k=;
  b=ZJSnNfyBdHQOiI5taOANd/53hGCt2LFU90swPTTWJhDxKIVMmfhgqTAF
   BKqAZi0f/ZaO6IBwnMBPShW3D+vOnX18ezfhNhZZhiybQJlqtce8eTohF
   lcEBkqUcsc+3XCkKPD90HI2n3geBu4KXIL3tMQ7fG2oxQVTn3J2bU2Pvu
   eBf7zDcpEtWIWH02SVrPqQArOVateogB7sfhD7pvho+8h55/4FcgInEsJ
   9HkdBVYjqCC2JNYrBv5fpu57Qkyqujy3bpEAPPdwwJC4s8FkcNq7nhIlg
   0+w4ChNu/Z7phFNXpkB2efB1+WwM1Y5dCQDqmOcxexYHkZc0kDLEti6FQ
   w==;
IronPort-SDR: ZyTo9q2W7kmIjrfk5m3bb9I3kBGUAFY961bxsONeqZ32wpZag5KGGurBNOLin1i0L4BuSByda1
 eWyZxDGocMGUY/exaTmXqf7HDdC3XKwBH3H2/9L7cfIABuFcUyB5joRLJmRdtAnGWiLh7AVz9P
 m9jmZVcKeNOiBR5eMT5/YXj4EviwDxTB1lLqu8RF7MdzlWmAXEVQCF1VxtJogy2xgqYtzEJ93+
 CLntNB8lfOJS7FlJIGqQyJpgBH7cekk027dK9yzQxKuB2GWmQnnAj7uRvZmFwecpwaNFcGWkqo
 +Ks=
X-IronPort-AV: E=Sophos;i="5.76,412,1592841600"; 
   d="scan'208";a="151363819"
Received: from mail-dm6nam10lp2107.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.107])
  by ob1.hgst.iphmx.com with ESMTP; 10 Sep 2020 15:45:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i7pXEVDx7hF9BgY04IEISzYgdTkfzq8T5lSZ6zWW1YXHbIpdDG5Rf1qtoqkhDrU0OCSC0w9PQDxcs4mxG7wyLEnVkWJ/gsAb2dqk5SLev7f+r/0FRjGLoWdPhcfN7q/u2eZ9+rbXKCF5XRkXuGVSBHT+VJ2C/KY5OL3MElsLTJgcG6Bo0/3MqOrA9am1takyQQdZdPGdsZ9z4IpkoebWuvlUUI38lPAnw2adEqXKrc81a/2w8514mPUC0zMS4OBO9ZPVHg0mbKHRJjc4REhOpMVG4hOoQmhps/T8PJ1Wrfyl1kIWBoMztp8iu0gPXIFIpK6OWSEM8UFPhRV4sUaIcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BJx5oeEH0GC8y7+LuLEbbYlqnYX6SNA5rt7GBYIAdgM=;
 b=FCOvggjg0NLyBAMBlUJxDIE5uEmF2CZQKgisKTdk8e/JEElDE/vJdh7iYz7hbjufUff674BodAbDNs1xNy4JP2nIDHS0BnKzlvE5Y2z9bg9vuNaf8j7qpi+7zz0AEYR2QIpiXLuqlkSmrL7SZwbYbTT68GHDy83d7CNQJsmgPQFEwjOHpaG3CtLmWRAlt0KDC725CsppWYuRMxCXDaiMDc6ceW58tpGrKMaGbflxcwXr91CNJUbQBwaoSoICX4tmRNtzFJ47w67Q+MV0B1SNfDJHr1oJos/VsMTRtI2Rw62G9gkTAUcOGBhAsKIpq82iK33qyzNDZY2dAbUm+r/38g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BJx5oeEH0GC8y7+LuLEbbYlqnYX6SNA5rt7GBYIAdgM=;
 b=sjKQUaQUuZO7G4gJQ9Wgx2I05QtwvtToLicRYjguAo6RM4DGhfV3ImeHXnlmUmGL/+gqHdnkEKNsugiDyAZ4cK5+vyB0P0/lkR1HHl/AJg/YTeYbFHJdChhzKEhXDEIdmeXqPz83Uqi+cb0qK/s4sv7Lr8iFZdvhc9oMyQjsdRI=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB1030.namprd04.prod.outlook.com (2603:10b6:910:56::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24; Thu, 10 Sep
 2020 07:45:41 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::9124:2453:fe9c:9a7]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::9124:2453:fe9c:9a7%12]) with mapi id 15.20.3348.019; Thu, 10 Sep 2020
 07:45:41 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 3/3] scsi: handle zone resources errors
Thread-Topic: [PATCH 3/3] scsi: handle zone resources errors
Thread-Index: AQHWh0WozMaHZqBYmUGA3Kt7Awy17g==
Date:   Thu, 10 Sep 2020 07:45:41 +0000
Message-ID: <CY4PR04MB37510219AB930DE95573A4A2E7270@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200910073952.212130-1-damien.lemoal@wdc.com>
 <20200910073952.212130-4-damien.lemoal@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2400:2411:43c0:6000:dc48:bbfc:f5cc:32c6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c828814e-7c1e-4d8d-c523-08d8555d844a
x-ms-traffictypediagnostic: CY4PR04MB1030:
x-microsoft-antispam-prvs: <CY4PR04MB1030807C401AF13B8E43C23BE7270@CY4PR04MB1030.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l3AYBVYBfZzaIRjbMsgc26mXutFRdZUuhVzREidY+rIAnB6laVs6lxMq6qhtvXdvQfnailjzpP4I8Q7mhZbSZCs+ltcQYiA3JLWEa5j6dmF52zjiLk0hurglAcvYJpJnygbdG5jt3Zx1AxlU1EFHvRvqONra98JX5hVU5wIY13XLV3j1eJCZL/tgiZBLjEzbM3JkIsPyTDQKsvoF7oReZveiHgTjUttzgy04V0XN+j70Hmz0lC+P+7WK6ux9eeSKXYw6HejZ0ec7MTl2TcWsyeaVkdq7OA+wp1TRdFO7lfKPy1Q/iBoNZtyn4Ii0hP9MsMmB/4g6SYyyMwexQTvgPw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(39860400002)(366004)(376002)(396003)(66476007)(66946007)(5660300002)(316002)(478600001)(66556008)(66446008)(91956017)(2906002)(76116006)(52536014)(33656002)(83380400001)(86362001)(186003)(55016002)(71200400001)(64756008)(6506007)(8936002)(7696005)(110136005)(53546011)(8676002)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: yR93yuFBK08jjX9UhGcaYKxig3lbnvm2qtR97crcMOvVuFJJDNQNn6FsUvKNtKi4fqVmeAEA616+IfAy8X0kEl0L27FHgRGDPejj1zlT97uFsEGZ4Fs/a/wjfsS+RxguJQJ296ZmYjIlVXbCoZ5+m4oXp3jxPWdddah1nIM1v0uJEoSiQ/MjzwoxEsG16vAbxW7J94YMXjAbuuhO5i9u9ou/t+Korjz+yM1WjhXjJql3kKCNalUIIM4LVLm+bDO1qwe/z5/1VpP+hEgnnDxd872YxooMuGPAmHzehHzmqGj8gNvBmq6EfbWhwMyGPDc/8XxyQtwHFm5i1o0slgMlG0o18WGH4JLGGf/gqRlt5NaUT0oZ3OgyORcG3cTxVYo9kfARh6vNlxJNjE9ZQdWp2KZeuDbTnFdaCFhEyYNURsKSY8MPeOXdQnaFggpqaM/TN3iY2mulPlKn6jX1GrY5yykYIgSz7U8wybKQmmpyfm3EviwiWzXbP/lsEHuY3cmxT02bq9IsEACa2EcIbotXyx9EfDdbBeEeOdk/UlOIIOs9pv2xOxdPru/GHSCPrEnDezw/dFuCjXT4ypTRqPyyGsbHYgJSxTplNfM18Avo0wkx65XoNd5eapmG9b3bexG1di3x3DspubYPl7m2d6dhKmBqkyrjQJyVcHrcv1rAN10Rs3LRus3RQ/wG2u4ZUYGz8odXOAUVtbtieW2FdXydQw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c828814e-7c1e-4d8d-c523-08d8555d844a
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2020 07:45:41.1827
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ynUqglC+Hzk9QZ7UWSpEilLm0PzlmmWQpyZeXyLWHQbheyzlO+k1VcotF6jCE+SYQ0SY0THWTd4AuP7DDeGzJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB1030
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/09/10 16:40, Damien Le Moal wrote:=0A=
> ZBC or ZAC disks that have a limit on the number of open zones may fail=
=0A=
> a zone open command or a write to a zone that is not already implicitly=
=0A=
> or explicitly open if the total number of open zones is already at the=0A=
> maximum allowed.=0A=
> =0A=
> For these operations, instead of returning the generic BLK_STS_IOERR,=0A=
> return BLK_STS_DEV_RESOURCE which is returned as -EBUSY to the I/O=0A=
> issuer, allowing the device user to act appropriately on these=0A=
> relatively benign zone resource errors.=0A=
> =0A=
> With this change the NVMe (ZNS) and sd drivers both return the same=0A=
> error code for zone resource errors, facilitating the implementation of=
=0A=
> IO error handling by the user with a common code base for both device=0A=
> types.=0A=
> =0A=
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
> ---=0A=
>  drivers/scsi/scsi_lib.c | 12 ++++++++++++=0A=
>  1 file changed, 12 insertions(+)=0A=
> =0A=
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c=0A=
> index 7c6dd6f75190..7eb4a80c3bbb 100644=0A=
> --- a/drivers/scsi/scsi_lib.c=0A=
> +++ b/drivers/scsi/scsi_lib.c=0A=
> @@ -758,6 +758,18 @@ static void scsi_io_completion_action(struct scsi_cm=
nd *cmd, int result)=0A=
>  			/* See SSC3rXX or current. */=0A=
>  			action =3D ACTION_FAIL;=0A=
>  			break;=0A=
> +		case DATA_PROTECT:=0A=
> +			sdev_printk(KERN_INFO, cmd->device,=0A=
> +				    "asc/ascq =3D 0x%02x 0x%02x\n",=0A=
> +				    sshdr.asc, sshdr.ascq);=0A=
=0A=
Oops... Forgot to remove my debug message. Re-sending without it.=0A=
=0A=
> +			action =3D ACTION_FAIL;=0A=
> +			if ((sshdr.asc =3D=3D 0x0C && sshdr.ascq =3D=3D 0x12) ||=0A=
> +			    (sshdr.asc =3D=3D 0x55 &&=0A=
> +			     (sshdr.ascq =3D=3D 0x0E || sshdr.ascq =3D=3D 0x0F))) {=0A=
> +				/* Insufficient zone resources */=0A=
> +				blk_stat =3D BLK_STS_DEV_RESOURCE;=0A=
> +			}=0A=
> +			break;=0A=
>  		default:=0A=
>  			action =3D ACTION_FAIL;=0A=
>  			break;=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
