Return-Path: <SRS0=lXiU=A3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96F2EC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jul 2020 09:34:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5565E2074B
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jul 2020 09:34:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="TX9dC0/K";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="z7wt+tPL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbgGPJez (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jul 2020 05:34:55 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:20963 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbgGPJex (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jul 2020 05:34:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594892093; x=1626428093;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=gyuB6KpyOXxOrIkzdjEOc+YIwBqnXPLRPF0fZKkBQkk=;
  b=TX9dC0/KuSniibEtYEF/emG31XpovhyH6XI9XFQr10huDz/WH9MNu/hB
   Rohru9YaBF6ZTXvYPiUS5Jhvksv/qXR+bktaZWN7Q68WoMOI6marKHqYG
   aYLn2OI4XXbxw1bF26u12NF9bQnjM/K14CmeHrtdpsAXEL3mRXo90A1o8
   cIAfbc9ad3dIgTFMcUMB3V/uVsuNzGqXjlNeAr6E9fdX+d76DFZanJNX3
   W2AJf5/zaf2ZEn0XfQ4QK9NDxwLFbhsPvdKSvq3xswrPWEBCpShIAPo25
   Pnhv32QCHe+1G5kkA6WqMS1IAkpyVW2cJoOhZkSB+V5XALFOnGWof8xz2
   g==;
IronPort-SDR: UTbB2UeEb2hZRX/rrrCS8QBaW1yu2DUpDuANdhXIyohph/Q/9K8gX2PvhlXZmGb+D2qBbLIWpv
 nllg7XMOd7HK1Ky8P1qxUe0qVbHn3CeKCvHz1859N5aw6z1yX8whZF2mKXhUmvBHBk5m/ZoTCI
 Wi9zcl/mi+A1iNG3ydG6U5U6dj434xxktajsHRSain99kr2+oSq+MITlRq6IqAH42nAbE7UNFU
 cO5pcFbdNDY3ciSrXUzx6diQ0UifIcbll1vTzX3mf64H0sUdgd0vD6vcuDgm+wq9tRk37F2C++
 XTg=
X-IronPort-AV: E=Sophos;i="5.75,358,1589212800"; 
   d="scan'208";a="143894434"
Received: from mail-bn3nam04lp2054.outbound.protection.outlook.com (HELO NAM04-BN3-obe.outbound.protection.outlook.com) ([104.47.46.54])
  by ob1.hgst.iphmx.com with ESMTP; 16 Jul 2020 17:34:53 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sp8Vi8/R2+XP2WWMR/aFHBQZrcGmYKivzK3dTe1lk9rOmD4Xca0ADBF4IWIogruZ4Sqzqg0hjVx9Oqb/1qj7GA+j2MNbwaCHGhdRNd3DVd7xem+jSwdNzPMmDTaWpGIxXrUckXzHuImBvI0jppj8ImWn8ZbFztywqIreAvYuECACyDT891ay7jkk355O9529YbfuJ0G/al6xUMID8WNevBmglSfnqieKXGw/dA1d4/mtECGAU5xGTlnEopc1gBz+CB3V/wv+wH5Ce6Sv5r7XPLZshmVe2QdpY+k3LY7xbiuLGF6PiLP7fU2ZYoIFRY3zyH7so+QZe5K0bZL7X4uHbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I1I/ES/r6MDV3JjodMScIRonNbW7RstwnMVPzAUZ9/g=;
 b=SP4jfG6KH3EC7jaDLl0VH+2JBPXYYE49475subkgA7VmQf2oV+U6051GF+5wusm2cXGpa6wZp8o/uuLeFc/KM1911lWIUhCu/iWTqHhXNp1dwCdYGKHxmbFCjgiJxsarInZ64NiPjokmXGz+WaG95+azEQhHQsxc+1iW9ELODo+ROeU89kdJZasl1550dl6bH9PgP/lYfdrg512ni+Mw1mEH/HgvTSUclfeyIH2b7W0moNihekD94LEyBFiHsUOUSZhT6jFjhl+Ba436o2rOjjCDJdFVcCKJxyiDXKUWqffTOu1xSDo7X49znaW7rv0IrpVoXmholvUJlBMmAk663g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I1I/ES/r6MDV3JjodMScIRonNbW7RstwnMVPzAUZ9/g=;
 b=z7wt+tPLf6mXKsN4czyuUppLIFbsUQghdRmqFdu957ye9v75tmef+OU/RF/Vz/cVIQaJbzoFuOMMh0dMzxRiCLFVgc2EXDtbWGUt/5pAcel1vfjpbLKLbP6mRZBh7NgZnSVQ9RPgFik0YhzdQXUVd2fONFfYG6gltI8uGfl0cf0=
Received: from CY4PR04MB3751.namprd04.prod.outlook.com (2603:10b6:903:ec::14)
 by CY4PR04MB0727.namprd04.prod.outlook.com (2603:10b6:903:e5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17; Thu, 16 Jul
 2020 09:34:51 +0000
Received: from CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::d9e5:135e:cfd9:4de0]) by CY4PR04MB3751.namprd04.prod.outlook.com
 ([fe80::d9e5:135e:cfd9:4de0%7]) with mapi id 15.20.3174.022; Thu, 16 Jul 2020
 09:34:51 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi: sd_zbc: don't check max zone append sectors for max
 hw sectors
Thread-Topic: [PATCH] scsi: sd_zbc: don't check max zone append sectors for
 max hw sectors
Thread-Index: AQHWW1HCI10BzQvyP0aM5P+L416gmQ==
Date:   Thu, 16 Jul 2020 09:34:50 +0000
Message-ID: <CY4PR04MB3751B27C9E6AFE0CE90DD85BE77F0@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200716091606.38316-1-johannes.thumshirn@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 20fc9aa2-f2a0-4145-169e-08d8296b7d22
x-ms-traffictypediagnostic: CY4PR04MB0727:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR04MB07273351D49345BFF717C0A8E77F0@CY4PR04MB0727.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ruWLJrUmcu7e66UToqCtyxuCj3BLYGb4H7UWfn5TMCFHtbsn3u3B4dASOwGdEtYG+FZ01MR7a7UN++Pe/kp2dwxJ3RYovyjczCSDtICWCY3rVfDV7PKSEuheR0Tb2V5V2nOERsU1CNzbKx1sbqGL0ou/Ekg+Px5cPN4rH9T+hBjjuqr6T9gkaAj4eWoG9ci27vajHQZrhzKUslf/O2j6CYbJSIKAumGF8M+PgKXq8EKA/0j0HSL3l4nuEgeh0nWvzJuCUp87EwI4vR9TRDzeR/yeWUOHDprvi50/EuShU30NYHXRvm9p8k2+QrdrkxlcRKeVaytOj3l4phYAZhxxow==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR04MB3751.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(39860400002)(366004)(396003)(376002)(136003)(7696005)(316002)(33656002)(110136005)(9686003)(83380400001)(52536014)(2906002)(66446008)(66476007)(66946007)(478600001)(4744005)(64756008)(55016002)(91956017)(66556008)(5660300002)(76116006)(4326008)(71200400001)(186003)(26005)(86362001)(6506007)(8936002)(8676002)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: li7L8Wp0U19UStUvioefz+7EoZGNKRGXOeu2WlXPizuf4p32Rg3AGT3f5HXPLMZ52u7DagTdJTQ2Yxf8BhFqSnYcOM1ircy/AlaasG/n3XSrdFFPCWIdgasi0p7zNAkvllZRWKTS/Bs3/FWv/OKlgnjqyQW/S5VxTxV7oU3cScmD0ZIt110LaUOPF6cVXuQ6UMQsZYBrm4Ev4t9DxWsZ4/He8EaA/cCgsxg7CDAG81HMgUcE/QJs0IfJZNQMJjvO6IFPpCfRQiYgr2ixZJJagzJ9XpyXI1G/AoJNtyfZQr2/TO0abrFfSu4Br/diBONR0NyWce+1OTBdkPu5knqOaaXMwguaZtXIxqVmiyxxfFc5oRF/liMphcVjSAzOYmQJDbch0z95NMPnbWgbrjkUqBAd8W0OXnDzc1a/gV63yh1/Sus2e2dhr9gsDFyPuGkjmJVFoGtTK/s3fj63k3tmiW1KDLlBiM9upOAX+Qco435pKwr1SsBHI8+rfWGmLgUh
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR04MB3751.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20fc9aa2-f2a0-4145-169e-08d8296b7d22
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jul 2020 09:34:50.9791
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: myssQvspL3M+BHQYYWoTlhbrA7symFJSS+bQNDNS6PuqqWIVjN7oV1FDbrnD/XuOB81YRP3eF65THifEK9BkaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR04MB0727
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/07/16 18:16, Johannes Thumshirn wrote:=0A=
> Don't check for the maximum zone append sectors to be not bigger than the=
=0A=
> maximum hardware sectors in sd, as the block layer is already enforcing=
=0A=
> this limit when setting the max zone append sectors.=0A=
> =0A=
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
> ---=0A=
>  drivers/scsi/sd_zbc.c | 1 -=0A=
>  1 file changed, 1 deletion(-)=0A=
> =0A=
> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c=0A=
> index 6f7eba66687e..4c90911545b6 100644=0A=
> --- a/drivers/scsi/sd_zbc.c=0A=
> +++ b/drivers/scsi/sd_zbc.c=0A=
> @@ -736,7 +736,6 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigne=
d char *buf)=0A=
>  =0A=
>  	max_append =3D min_t(u32, logical_to_sectors(sdkp->device, zone_blocks)=
,=0A=
>  			   q->limits.max_segments << (PAGE_SHIFT - 9));=0A=
> -	max_append =3D min_t(u32, max_append, queue_max_hw_sectors(q));=0A=
>  =0A=
>  	blk_queue_max_zone_append_sectors(q, max_append);=0A=
>  =0A=
> =0A=
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
