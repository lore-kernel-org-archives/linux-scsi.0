Return-Path: <SRS0=GwgI=BR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BD76C433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Aug 2020 11:18:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFA8622C9F
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Aug 2020 11:18:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="gLU0zQzJ";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="w4qNe//h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726159AbgHGLSX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Aug 2020 07:18:23 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:56272 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbgHGLSU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Aug 2020 07:18:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1596799100; x=1628335100;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=JBTjySAW9EdKzFUxu/QIT9Smwafsz0dXcJ9trG53X04=;
  b=gLU0zQzJMWd7J+kRkUhScPU0TVwJWRnR/oQN8On9H/913BRM2zKXGFLW
   xhX6elrWWPTXPr7w42oEFun3Y+kFILJ6MEU8F/6CdQr3o1W+4kjjOsKDY
   4FK5O62oXveUlucMqpS4Kv2pCsOrBgjo7Ibhe8I2latcMcLWscS1wugtr
   d7TfwFJWl+49Xrw+3vWdOnu4QBxtLQpc1X9LOrwwNvMINpWnxa7V9m/KW
   Ai2WrMtZPv5MW4wVzF6r2VBn1MSSzT4Ww9fAh6uP+b96p0hz+zxLM1nbN
   UCQJiV1hBVLzGSZdXTynLG2NrX8KwqVCua+RFFfAF+F+pB01wFrriU9Ce
   w==;
IronPort-SDR: 7SfZHSfc4CI7nt/8tLqHueiUVSvfYHZZQvfa40deeO7uSix42BE3wok1YOg5wmY6QkFGAcrBTb
 OOtaUd3+rqJ07RdufqzJ7snP5fKe3mvDFr49nHJsfSiCh1+DK2v9WHEiCsI4AaBZ0uOkzuPzWP
 Sakb2IFIUcuNCTsgqh1Y6JqXo3HeJ0V73wdgoKoeVEbVJWTIsQsgeljuSd8R4LJLQmaDw+OXVs
 A63jmwPn6cTsEUChxenjXAwxmHjIBZQCp6LTHF0rYBe1Hv9gaxoToWapLaSzql+w6BqHvo0KG3
 xes=
X-IronPort-AV: E=Sophos;i="5.75,445,1589212800"; 
   d="scan'208";a="144389759"
Received: from mail-bn7nam10lp2103.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.103])
  by ob1.hgst.iphmx.com with ESMTP; 07 Aug 2020 19:18:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=idKlb3QQ/9ZfM16YxYUcBD6srY7y6meN6jthQGOR1y4WMT0QT8i1R6K24W0gj4Dx/dSTaI2n1DDzDDrMXxcboSuHsy3uYfrw2vEo/ddqixC+FCE4h83kE4ZLXZkLgv7+ZwsKpX/JLGiw0F8opQ2g/TlAvwvcx2yvL8ijgTR0W7PzH8mi5avVMkOaoH9xvngtUze1n0ssoqoEk1s/sYvR5xyIUIi1V9u+fRY9rRqwQ50oedjA8UHMPl6JfJy/HjWRuzkwk+bSVR6LmNEvs4qOAOIBt6t5pNxgh5gf44VWyl1SyVB6HK1K0ZSi5YsE/w8FFNj3MaLN2luz/qqw/vNz6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=um1z9ROAZGZSKvy6MUeJinoM7CUzJfLljIgLONTTLMQ=;
 b=iv2jEUxNrvuF1vsTAVjEuo3jMKoOUjNUv/h8C/aiNYABMtrbpusovHnZVDJWBDzf7ajbVdQ1tN3LtTVj9vE8La7o3tKFnJdFNBmLuEzqKnWxS6Ma4ZxG7YJwsuHlmRQNzLw9AZJEkztlF9Dtq4cKGrXg9h8JQGUOQyeUVWVDUDda8VcyhsbV0pf2DPCZ4sH2jXRQ7YvqFyQXGCzu+nEGD+Qo5Nxt8CswAVtTLUGluRRcl3qMHUD1TXUS8kT9ZxlLseR11SwO/xuBfnDIDvB3/CZDIEJuCi5KJo3oMbqiLmSNGXJwTuQxUwSNSxEuPINzg0+K/s4N47u4Ipl53oh9ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=um1z9ROAZGZSKvy6MUeJinoM7CUzJfLljIgLONTTLMQ=;
 b=w4qNe//hz9Q+m9RJ/HQrzpP135A5fy/eZm0NkHOdsdWOKKm1i4PtHBzZI9BvnCbIq2iNF/xZCj6KJbnjDUpLF5TGS53vi/SNeQzzct4PFtMdYVoPUVnFS6sxTDpZZYboFCfkufp0/nlF5+5UGB/5urHOSR28fTUH0DwiiHjH1bk=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN6PR04MB5118.namprd04.prod.outlook.com
 (2603:10b6:805:9a::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.18; Fri, 7 Aug
 2020 11:18:18 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::457e:5fe9:2ae3:e738]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::457e:5fe9:2ae3:e738%7]) with mapi id 15.20.3239.024; Fri, 7 Aug 2020
 11:18:18 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>, Daniel Wagner <dwagner@suse.de>
Subject: Re: [RFC PATCH] scsi: sd_zbc: prevent report zones racing rev_wp_ofst
 updates
Thread-Topic: [RFC PATCH] scsi: sd_zbc: prevent report zones racing
 rev_wp_ofst updates
Thread-Index: AQHWamsoltYRlwenV0yPgATAXD6OIw==
Date:   Fri, 7 Aug 2020 11:18:18 +0000
Message-ID: <SN4PR0401MB3598C60888A46ED31A0B94CC9B490@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200804142541.17126-1-johannes.thumshirn@wdc.com>
 <CY4PR04MB3751D2A831C76747DADD7C4EE74B0@CY4PR04MB3751.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8a3dde76-7694-4373-093a-08d83ac395fd
x-ms-traffictypediagnostic: SN6PR04MB5118:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR04MB5118117EFE2128C716684F879B490@SN6PR04MB5118.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IuDUpIt1t4DfbfLSlmrrKHPzwqV2vbPpxvlh1S8sFCRoyZZzPawOU79PYzm3YgERCzj1hXytrKt7fYg+7m/zuhL9UwNxW3MCtEj9TkmrQo00G6u9ltQrCV4XhjBxaR7lHgTerrSSEk4tTb2XHt0EoRpfcrSJacUWQeVkvSA0t+7smh2WstdR0UuwM8PWopsIRGQxulK6hGB5xDneD9pX0qv+rOYnGlKIQKfMf+46DhpKLyCPLpXJPwRo1lG5WUbpGc23VD6PIhSIqvrqddwBKLlQq7iK0Rbe+r5Mai20U7NpwUdW8Tc+x+6+a+HhmKM2
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(39860400002)(376002)(346002)(136003)(5660300002)(2906002)(52536014)(478600001)(83380400001)(8936002)(54906003)(110136005)(86362001)(66446008)(66556008)(64756008)(66476007)(76116006)(91956017)(33656002)(6506007)(316002)(26005)(8676002)(186003)(7696005)(4326008)(53546011)(9686003)(55016002)(66946007)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: jTac6Z6R+FG3p4ooufkxvOwtuh3I4Yw/5C/EM26g4hA/0v6IEgqg8qy784+CDiWabLChnt1vUxwQfMjfrSky9Wjcl3BAsrGfEJmAzw+ZfWkP7vub517qAc9dYnw8Nd8GT8PDCiz6jwyiorE20iAOyKFqBjo+RqgibZbB2916jaDxUhl9HIDruDtIXPTd31UuUFxbYueDoMrUd67STcHZ+XcTaWJQPsseM7eTzkXADIYg32CJY4hCQOBF/JHEKN9zxm4TiRD8es4DqLTdhmAbzpGhPJy6CUCBkgrFsUrgdcQwev3Gk+5miSXOTlwiZOG56FQuLxK8n3Y79TiSbzMgPT/m45wT5E/KwO8m/RLhBLOeqNzsGe2BOhpKwpSffYIxSMOpoyK6uKvnszVlhIO6QK2UmUMzUfvEk1RYOh7Dr8w92JXfH1EqXtakGoG/vH+zBsHrmjg5el5n3d49+7sXEWfDqeKJGSXs8g7igZFAtQvE2zgsGnZFFDA26yToRjvsn5AoSBwlX3tI/OeCok45HJzyyGW4IkSzdMAq9JgeFPaI0fKSg+ZFG0Qc2Ld5O8Pc5akLrGgvOxnptY6Ip2DP2XKok716SaMG/TL6St+J55e3NdFqKlL5W3rpkhOZKrYN5BL0di9M8Y/Awh5LWRnB5A==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a3dde76-7694-4373-093a-08d83ac395fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2020 11:18:18.0767
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ny+kIbyock5byrsDvuF7bWssZE/zNP3Rc0yIWOwHVLP1Mmz7LOhRBDmN4UDGEEgsk9SRQTYOmSQfKyjhFhZguEHHKzuiRtLQMFXvLXlEZa8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5118
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 05/08/2020 11:10, Damien Le Moal wrote:=0A=
[...]=0A=
> =0A=
> May be something like this would do (not pretty...):=0A=
> =0A=
> diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h=0A=
> index 999f54810926..fba312c8725d 100644=0A=
> --- a/drivers/scsi/sd.h=0A=
> +++ b/drivers/scsi/sd.h=0A=
> @@ -84,6 +84,7 @@ struct scsi_disk {=0A=
>         u32             *zones_wp_offset;=0A=
>         spinlock_t      zones_wp_offset_lock;=0A=
>         u32             *rev_wp_offset;=0A=
> +       struct task_struct *rev_task;=0A=
>         struct mutex    rev_mutex;=0A=
>         struct work_struct zone_wp_offset_work;=0A=
>         char            *zone_wp_update_buf;=0A=
> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c=0A=
> index 33221d8e9f8f..53f0489c3433 100644=0A=
> --- a/drivers/scsi/sd_zbc.c=0A=
> +++ b/drivers/scsi/sd_zbc.c=0A=
> @@ -69,7 +69,7 @@ static int sd_zbc_parse_report(struct scsi_disk *sdkp, =
u8 *buf,=0A=
>         if (ret)=0A=
>                 return ret;=0A=
> =0A=
> -       if (sdkp->rev_wp_offset)=0A=
> +       if (sdkp->rev_wp_offset && current =3D=3D sdkp->rev_task)=0A=
>                 sdkp->rev_wp_offset[idx] =3D sd_zbc_get_zone_wp_offset(&z=
one);=0A=
> =0A=
>         return 0;=0A=
> @@ -688,10 +688,13 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)=
=0A=
>                 goto unlock;=0A=
>         }=0A=
> =0A=
> +       sdkp->rev_task =3D current;=0A=
> +=0A=
>         ret =3D blk_revalidate_disk_zones(disk, sd_zbc_revalidate_zones_c=
b);=0A=
> =0A=
>         kvfree(sdkp->rev_wp_offset);=0A=
>         sdkp->rev_wp_offset =3D NULL;=0A=
> +       sdkp->rev_task =3D NULL;=0A=
> =0A=
>         if (ret) {=0A=
>                 sdkp->zone_blocks =3D 0;=0A=
> =0A=
> =0A=
> This is totally untested...=0A=
> =0A=
=0A=
I agree it's not pretty but at least way more readable then what I did. Can=
't test =0A=
though, as I haven't managed to provoke the race yet.=0A=
