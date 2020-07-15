Return-Path: <SRS0=K8op=A2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F305C433E2
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 07:13:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 083952067D
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 07:13:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="WHqI1xFd";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="yZF5XYZP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729129AbgGOHNE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jul 2020 03:13:04 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:3611 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgGOHND (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jul 2020 03:13:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594797183; x=1626333183;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=msjwwbNWKGYFzztsmuet64eAWgkeOd24Upq8nR9hXSQ=;
  b=WHqI1xFdwupA4DVNIY1FD+7PhZhaCexuPbvrrXxaMsfpdoTGFwyrbqL7
   uaWmALcMgVCLoILC5tCxrCZujkKSFVV0VFrsbpwHK8jrLcXdlpGxPGnUo
   4XHAEnUrhKgPq9xMOfvpcbv33LzTjmxzfH8BtkHWNaTfvhQmuppsNuM99
   7wH5/sRqQWD+2rZuSKJ4tbg0P+Xp6/kSHCtQpTBKMryQYRAD2AgE5gr7t
   P7j2MEyJM2YMPUEd+jODKsc6rwMQwlbjZL7C8jw6cM60PPLzviOqESDw1
   RyOITTAZx2qaa1FwM9kNjPv5P5wxlBtKluLITKeJvV+gMhwvtdhQPZzbd
   g==;
IronPort-SDR: opjAh9+4vVesX5rrvdT0reHg03iqFxmoYw2VQ7JTMCSFnjJsXP8FME2H5CTdcJSToDGlbipDWw
 S7eJnbGdYS8lsBkRAmWV5hkhDM+QalJRQCqh6sCMN3x35NlkrGSEoVE2Ltc7ty4QqrVzWqY1CP
 vjaR96/elzry4VceHdvROZvVJeYEKWHfX2ZOepYW/6Sx1BloVyhiSaWSq2ErGZVXdQ2o3G6W3o
 AcDXIWIS0/hUBjAfNwmUTw7NS/oKx+HORXfruWqPZXaX4PEllEmNPGznMngdZSCou0CGzJpUvN
 P0U=
X-IronPort-AV: E=Sophos;i="5.75,354,1589212800"; 
   d="scan'208";a="251758557"
Received: from mail-co1nam11lp2174.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.174])
  by ob1.hgst.iphmx.com with ESMTP; 15 Jul 2020 15:13:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ld2Q8W24sUuNyDby61s/pt6zM7oFxkqPdKYpa3/kZCjsDE0v32IDbjTgIFnMmQKKiKWtB7j0Fej7XxXDubLOnY6aC8MH1OqoXBbG5dJNcWI4uUdsf3FEUvxuMMWIuhCbfQLyqyi0kfvLytyOo2tPLDFk9AnSxQOf3Yt5qZVPADj5BLD9EiVOSzn1Igt+2NOyV8U6lFuOsnHl6kcvITOiWnpwYPCokhCJ3zisqm/Jsutue750ZVJQz+U/irjbI3Z4AcFa520ur+tf4ew770ZRzdgeJhDjEfZUgRdukU/VtzsbPIXF25U6Zb2yt0n0UcImHnCcCx3gxIgL1hKP9cA1sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x34sS4202OAoCMMR9DMEl7bdSI97NwkEZ7mNYmQw770=;
 b=b4hFcRBQacF3oFyspchC+GZxs48eF0gbHUds2VqnaT5z1D/k3v6VVCBb207If/240CxfI33912FZkeK6Gw5elqiXnPIc6qA3REhFXzNp7diavaKWZfDrhHdIkjRJwp1vkAQvOrBOINGQbZJlKlCZlLMuVZa8a5cTijYLF1fkgLlymSDJOVLG7/nvrCzlIDz43/6Sq1J9O+dZ4RyAyH/lATB0L2cTqpjs7jVD5Kk5BjEPvaXyMBGWC3hIZCWJUJ78bIFCo11tvwSWCNAVAKGPOZHoCJMArhlUu07lEJA9rkk6/ypQeJj8JO/vd8d711bEl4zcuRSaw+Py+zObZ+Dbyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x34sS4202OAoCMMR9DMEl7bdSI97NwkEZ7mNYmQw770=;
 b=yZF5XYZPnAtPITU6ul/F6rd5vYS7xr1n8ILIRsSUOCILItXPZvYQXCYVpcpbGbGym7OxCkUJbt17WYF1RQVFAq6sjFNc1ORuJtKFEv5znRWwUqoG0Emu0OWXtR4JUZifNaG4NaS+tWAIs7ws+f4tbmQDbj2aHZ4CWhE6eHb4rHc=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN6PR04MB5117.namprd04.prod.outlook.com
 (2603:10b6:805:93::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Wed, 15 Jul
 2020 07:13:01 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2%7]) with mapi id 15.20.3174.026; Wed, 15 Jul 2020
 07:13:01 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     YueHaibing <yuehaibing@huawei.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] scsi: sd_zbc: Remove unused inline functions
Thread-Topic: [PATCH -next] scsi: sd_zbc: Remove unused inline functions
Thread-Index: AQHWWlN7tw0Ukte+lEm+AJYSZqNavQ==
Date:   Wed, 15 Jul 2020 07:13:01 +0000
Message-ID: <SN4PR0401MB3598D09525BDB81C1FDF24E79B7E0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200715025523.34620-1-yuehaibing@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2001:a62:1515:bd01:853f:9b43:c773:dd89]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 79fee731-43d8-4187-9a3e-08d8288e82d9
x-ms-traffictypediagnostic: SN6PR04MB5117:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR04MB511750EC8A24AC1DB19A52BB9B7E0@SN6PR04MB5117.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:489;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8T1x7EC9go/jfrUvv4E+oXEFaFaZBQWRMPJaHV63POX6XkWCTJrFDzF+LpsBcfe0X87BF4/W2HWXEY0cp4IWkdQ9aCOEPkxWmJmjcz8MMTcmoGRuXkodRtUh4r8aQN3azl1KyEJ+QsET3uDU29oSR2h0RibTWmDzFIqsYNupwQK5E7EG7uxGgumlBwq4E61HNC7LhrzGaD3J1E3iEcGBQya7RjQkCe905o34TV0AxLKLvwGeoH1ZJCkYcB/989hdZVLvbs7y8nOF9DSqmG5w3QgBoi8aw39w13/fPcHeYvaXr1UIvmtpKgCv8lKnFFBDwlmdDuDFvw7S97zRrNVNug==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(346002)(366004)(39860400002)(396003)(76116006)(4744005)(4326008)(5660300002)(53546011)(8676002)(83380400001)(33656002)(186003)(91956017)(66946007)(66476007)(52536014)(64756008)(66446008)(66556008)(9686003)(478600001)(8936002)(55016002)(2906002)(71200400001)(110136005)(7696005)(6636002)(54906003)(316002)(86362001)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: YB+kibQ3d9L5Io+K8wX/ph25swuRCLNRN5SC1eLoOfnDCwYYtYXG80K91SDhM9BwlUtFcwsw/oyhdDdD6G7eDbdKlaLqS1LDiUKAbwO2x9xjtpYYkOVqd4RiK4n16PSeMKAmsrbaYZcqR4H9Z3KhGQwAWb/HlhYLXSyIy8sjhtELgmdWafl4QaGI2PuDJizzEJ2X0dC46N3x/0os+kNon/BQt8TBpGPhm5jgLlUHIg6TrbbCozkRuh8f8wolkRhCBl7ekFSchCUWlCvO0cs9eCMjMZFRRrdkM/93Rx6nzRKxSydLFgcsbn0epspA9u8gf4wFsWjjCm6UML8P2D3l/po6/SmyS3W5ScJmRPBjSwSSEkSuPmRplAi66oahoXE9Eo0LaO/qzxRUEeU2O5GbpUHKRE76WL2z/KI4dZ65RoXqSiA/gpR/8u2FyZCx3G6Jxazn2JpRbf/DiNiC0jmiwL8/F8jY/yyP6TrUCInjHb/ShhYTeDtkCqo4eJqPtn1wvlg3Rf9pJCzJR2BZ8Y52ySx1m7U+mym7+IeYGFnLs7L6729pncUL80ySoNFggotw
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79fee731-43d8-4187-9a3e-08d8288e82d9
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2020 07:13:01.7861
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9j1jgt6jw0hvZ6W497UAQk09HsGZjkP8jysWKEGGgflxut+xvfmUcswZKyzoTnCA5+6lCupiy3U78rhseDJDhHwN9XIKX5FGxDfJOT/7Sno=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5117
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 15/07/2020 04:56, YueHaibing wrote:=0A=
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
Woops that looks like some leftover from development. My bad.=0A=
=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
