Return-Path: <SRS0=/Ihf=62=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61CF5C54E4B
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 07:32:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 121D0206B7
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 07:32:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="IbWLFkC9";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="TsHKwoFu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbgELHcx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 May 2020 03:32:53 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:9718 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725823AbgELHcx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 May 2020 03:32:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1589268810; x=1620804810;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=8z7lWuRza3bjcjv9tnHTVE7mhT515ceBCClNnfNFIUk=;
  b=IbWLFkC9UXn4Vo8jli2xJP+oCRLoqq1tZtHur/AzxUnMtnsMZMdRlZnn
   sCB3St4cRsp3irowfYBVc8z+FO+g+CNtzCD4FSS43PqyOzVu1ezhHEuHD
   nu2A/mYvRu4qDoqQIzu+/W7wUfAI3WuaRBgClFLT3g8KJU4y12DgXbNzZ
   u8XpDTkF5UHOPZIoTc5Ede8LJFMQXQNiJkzvghaKBpquaoDC0ZDx8ez69
   kTG4f7pbcbzPqACsjhfE5dBNOtSYkf9iC73o6LtcmX5eKhgLgACrtl1bD
   fnrnxMFLJtIwQaZSfULjFl8E2jMW9cMZWaDdKKuudHtW0LfCgK0YEVVwu
   w==;
IronPort-SDR: FY4mJ8FfuHnZ5GPwyPplVBn2kpq7UNgsol9F4sJyAeJKWm9tQaLvZ1+LSYHD8NY19gKL6Ocj4X
 MET7/EnVw4LESJTMX4Zatl1f26hnGjtoYFXO/JHvwsUQqugs6Tt/d/PPv35PPTYtUfFnZ24dKx
 1BCpATREuLTU6nYO4pkau2DwJbxAbjog8zSn6r+8A+OPNBWK9IkVw2kMjxTnYahYrwMmva3XLA
 JpzPbas7llvyeVN90qxtjQtdb63LbjjtCyF7yMA2SuFsyQdYu8BOVdLdk+9xODvQ+twYk3DwW4
 SIU=
X-IronPort-AV: E=Sophos;i="5.73,383,1583164800"; 
   d="scan'208";a="240164322"
Received: from mail-dm6nam10lp2105.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.105])
  by ob1.hgst.iphmx.com with ESMTP; 12 May 2020 15:33:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NdNbu5piY/g7oj6b2o0JHW8w3D4TcoGCVxpXUVLjHn0VA0919I1kK4MqmSoXelDuC86qgicaPLMSX3HMKHvwIePtoZCdDstglNuqHpP+jjP15THyX8akJYvtlIsMeEZFSU389SpY6COWE9SvtAUmjXiHI4sJgj/umu8cs4JcgvOxxE9bkdXDEQe73/KJgkYfcnA5uob9vb/uhDQyaPxC/kc01RlFVaUdL45bVdRrXDVTahNdHf02crSF/2RztjCcm6s+DT38adVAGgQeWAP3nYAMrHdkXCC1/FLQiYedLRf8/KK56vbbStTWSGu2rgnlxmC4NeuwQoJlZn0GLYybYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SawqWkbZhrTd0lVtnZMPhET6hCj5foSNbrsfWpoNGWU=;
 b=SbktYl8ayiiiBKNz8Hhz11dUAjfIx2Oi0VS2Z3DpQbufOFp/Wexi8+PcOibnKKXWJU7Q/gvFt7gkFnL/KZv/72QjTarZhU06unSz/TzoWMDaFDT0e4BboWvbv8/GpMFXo3+zD5FZJm6ExFpIWDcmES2PEWjzTi/K1jNB4+ksNUs42caQPTHj+a5mHBfX40mp1P3a/jR+bofk90SNV8bjLPb32nKIEPlicBDf87h4WoBPrZTHuPn5mh/oOxIoBTaOrEhW7klbGcdQ2qymPiTR2aEQ4kLy1kCoi69ZRbyGXG0GHPGkW72WhwqXHhR/hlM0gCng7+FelKbh2GZTlWYEIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SawqWkbZhrTd0lVtnZMPhET6hCj5foSNbrsfWpoNGWU=;
 b=TsHKwoFudaLOYpJsdGLl+1174RKzqQKTbgX1SkLrgwsrq3/GdOmjr5xfwZUWuThocTSY26nyGH8HU400jANdBh7JaERe7WhcV04XVQM0ggh2W+ojfA0Tw1oLalTye11TDegIl8OeVGlxzI/NGaRCoAYoF88FpeB+b0o4kUacPPY=
Received: from CH2PR04MB6902.namprd04.prod.outlook.com (2603:10b6:610:a3::24)
 by CH2PR04MB6918.namprd04.prod.outlook.com (2603:10b6:610:95::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28; Tue, 12 May
 2020 07:32:50 +0000
Received: from CH2PR04MB6902.namprd04.prod.outlook.com
 ([fe80::b54c:8c9b:da45:2034]) by CH2PR04MB6902.namprd04.prod.outlook.com
 ([fe80::b54c:8c9b:da45:2034%5]) with mapi id 15.20.2979.033; Tue, 12 May 2020
 07:32:50 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Douglas Gilbert <dgilbert@interlog.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>,
        "hare@suse.de" <hare@suse.de>
Subject: Re: [PATCH v2] scsi_debug: improve error reporting, zbc+general
Thread-Topic: [PATCH v2] scsi_debug: improve error reporting, zbc+general
Thread-Index: AQHWKBwVGZqwpHxFEEGO1vQ4c0YLow==
Date:   Tue, 12 May 2020 07:32:49 +0000
Message-ID: <CH2PR04MB69021E17186423BDCE48157DE7BE0@CH2PR04MB6902.namprd04.prod.outlook.com>
References: <20200512051320.116081-1-dgilbert@interlog.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: interlog.com; dkim=none (message not signed)
 header.d=none;interlog.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 51840f95-87ff-4390-8965-08d7f646ac9a
x-ms-traffictypediagnostic: CH2PR04MB6918:
x-microsoft-antispam-prvs: <CH2PR04MB691813ED8B983730EF5F5C8DE7BE0@CH2PR04MB6918.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0401647B7F
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aKgeFQwYDbc5oqLY4i6QyL8P0ER/uslysAzAEv4keG5nFuIjNImFoxTVf4a9L5QtmxW/BispWrsMylY0g+tNi/CJtYvwH9CGkMGBfbprZCXCvpNLQVuI9bS+fpyLfVDN+j9F6HUU/rhLX2fvUpRSdzAv9zQhV8E0MHNKRz+wDWWyK/YAj7UagtpCx0a1hrkWycB2aFoEdSsgk2qcm/hjUgUrXhYfevCQV2glSR1lev5K9oMQYmJnOiCaqg59ZfWXWDAa5YYNCDeQxcMOiTrv+bHkxmtoutWenS8D+H33euvayK9xkWzVpaeML6B9pKgyXIbCxppbcnhgEM2nu/s4ZxnBHUPfON0VHFy+4Ff/NxL4z7szzukG8xZToFVlyu5zK4zsC39VEDqNy+eqeCL2+dckNKMyF2fV/fIEKLUm37erl9oDuTp0hKDRWr44HyOahcqy52h+ZYQHYtOtkJ6sz5V2Hw20JxMchyrlP4VlWX92sR9EMhBJMqVt+ghxv0IG483pZ+viYIX0XXfqrE5Feg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR04MB6902.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(376002)(346002)(39860400002)(33430700001)(7696005)(4326008)(55016002)(9686003)(86362001)(76116006)(64756008)(66446008)(52536014)(33656002)(66946007)(91956017)(66556008)(66476007)(2906002)(53546011)(30864003)(8676002)(6506007)(26005)(8936002)(5660300002)(33440700001)(71200400001)(316002)(110136005)(478600001)(186003)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 1Wjl4MBM4KCb50ygUkmz/G7zYmFRNOkApfQaQruNnarbJL/6i6DfiASaBIq+ya/FctrFGfcEO2Nkg7L+aJObfVSR/i/1rEDXfps8qjKM+YJFP4205xOPDQeQ8H+e3ptEIG2+HymSOerfpMdjWhURIDq5DH4FSbTPJUaQh0sBbLw2frSLcaHHjrxQHF/6h+P5FBSkXbn7QXqGMvBjbR7wU5eOmvbfRz+/dQEFMusK/ds9cDxL98x1rneL9gs4YHVjw/RISkc3ST0NtN8R01oxTLp6d7VV86FIP2PB4y8tTJyGzajzW7fc3uVhkzlAQD0HXaeT/YbUl4pp61u3jj9Mja4EP0M7dZrkGZkIYwdQO88BI2GUtXpSE7lCe+ptT28nbTZSMOavBYiLMWLSA0dK4kqDAWIpmG8ZykNov85hH84gMfdqmUEhkOqmceBW2xJgymVGxHw4RdMWK9BOOVnw1gQS9j6oOZ7LyvqT38k9JcmkXa52bklhgVcVB+DBIW7Q
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51840f95-87ff-4390-8965-08d7f646ac9a
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2020 07:32:49.9141
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f1iNsr11J8Fh5dHS2AElpil8XPTLZVI3ANbXNTBYdZcigwGUcK749vz06+SWuryltTMm6Lr9tkI/IzBVKZRyWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB6918
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/05/12 14:13, Douglas Gilbert wrote:=0A=
> This driver attempts to help the application client in the case of=0A=
> ILLEGAL REQUEST by using the field pointer information mechanism=0A=
> to point to the location in a cdb or parameter block that triggered=0A=
> an error. Some cases of the ILLEGAL REQUEST sense key being issued=0A=
> without field pointer information snuck into the recently added zone=0A=
> commands. There were also pre-existing cases that are picked up by=0A=
> this patch.=0A=
> =0A=
> The change is to use mk_sense_invalid_fld() rather than=0A=
> mk_sense_buffer() and supply the extra information to the former.=0A=
> Sometimes that is not so easy since the exact byte offset in the=0A=
> cdb for the family of WRITE commands, for example, is "up the stack"=0A=
> when some such errors are detected. In these cases incomplete field=0A=
> pointer information is passed backed to the level that can see the=0A=
> cbd_s at which point the sense data is rewritten in full.=0A=
> =0A=
> Uses the scsi_set_sense_field_pointer() library function to replace=0A=
> open coding of the same logic.=0A=
> =0A=
> This patch is on top of the patchset whose cover pages is:=0A=
>   [PATCH 0/7] scsi_debug: Add ZBC support=0A=
> and=0A=
>   [PATCH] scsi_debug: Fix compilation error on 32bits arch=0A=
> both by Damien Le Moal=0A=
> =0A=
> ChangeLog since first version:=0A=
>   - incorporate changes suggested by Damien=0A=
>     - didn't generalize small pattern to separate helper as after=0A=
>       more pruning there is only 2 simple instances and 2 more=0A=
>       complex ones.=0A=
>   - use BLK_ZONED_NONE instead of 0 to make logic clearer=0A=
> =0A=
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>=0A=
> ---=0A=
>  drivers/scsi/scsi_debug.c | 158 ++++++++++++++++++++++++++------------=
=0A=
>  1 file changed, 109 insertions(+), 49 deletions(-)=0A=
> =0A=
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c=0A=
> index 79a48dd1b9e4..60e84a1cdfac 100644=0A=
> --- a/drivers/scsi/scsi_debug.c=0A=
> +++ b/drivers/scsi/scsi_debug.c=0A=
> @@ -61,7 +61,7 @@=0A=
>  =0A=
>  /* make sure inq_product_rev string corresponds to this version */=0A=
>  #define SDEBUG_VERSION "0189"	/* format to fit INQUIRY revision field */=
=0A=
> -static const char *sdebug_version_date =3D "20200421";=0A=
> +static const char *sdebug_version_date =3D "20200507";=0A=
>  =0A=
>  #define MY_NAME "scsi_debug"=0A=
>  =0A=
> @@ -925,8 +925,7 @@ static void mk_sense_invalid_fld(struct scsi_cmnd *sc=
p,=0A=
>  				 int in_byte, int in_bit)=0A=
>  {=0A=
>  	unsigned char *sbuff;=0A=
> -	u8 sks[4];=0A=
> -	int sl, asc;=0A=
> +	int asc;=0A=
>  =0A=
>  	sbuff =3D scp->sense_buffer;=0A=
>  	if (!sbuff) {=0A=
> @@ -937,29 +936,27 @@ static void mk_sense_invalid_fld(struct scsi_cmnd *=
scp,=0A=
>  	asc =3D c_d ? INVALID_FIELD_IN_CDB : INVALID_FIELD_IN_PARAM_LIST;=0A=
>  	memset(sbuff, 0, SCSI_SENSE_BUFFERSIZE);=0A=
>  	scsi_build_sense_buffer(sdebug_dsense, sbuff, ILLEGAL_REQUEST, asc, 0);=
=0A=
> -	memset(sks, 0, sizeof(sks));=0A=
> -	sks[0] =3D 0x80;=0A=
> -	if (c_d)=0A=
> -		sks[0] |=3D 0x40;=0A=
> -	if (in_bit >=3D 0) {=0A=
> -		sks[0] |=3D 0x8;=0A=
> -		sks[0] |=3D 0x7 & in_bit;=0A=
> -	}=0A=
> -	put_unaligned_be16(in_byte, sks + 1);=0A=
> -	if (sdebug_dsense) {=0A=
> -		sl =3D sbuff[7] + 8;=0A=
> -		sbuff[7] =3D sl;=0A=
> -		sbuff[sl] =3D 0x2;=0A=
> -		sbuff[sl + 1] =3D 0x6;=0A=
> -		memcpy(sbuff + sl + 4, sks, 3);=0A=
> -	} else=0A=
> -		memcpy(sbuff + 15, sks, 3);=0A=
> +	scsi_set_sense_field_pointer(sbuff, SCSI_SENSE_BUFFERSIZE, in_byte,=0A=
> +				     (in_bit < 0 ? 8 : in_bit), (bool)c_d);=0A=
>  	if (sdebug_verbose)=0A=
>  		sdev_printk(KERN_INFO, scp->device, "%s:  [sense_key,asc,ascq"=0A=
>  			    "]: [0x5,0x%x,0x0] %c byte=3D%d, bit=3D%d\n",=0A=
>  			    my_name, asc, c_d ? 'C' : 'D', in_byte, in_bit);=0A=
>  }=0A=
>  =0A=
> +static bool have_sense_invalid_fld_cdb(struct scsi_cmnd *scp)=0A=
> +{=0A=
> +	if (!scp->sense_buffer)=0A=
> +		return false;=0A=
> +	if (sdebug_dsense)=0A=
> +		return ((scp->sense_buffer[1] & 0xf) =3D=3D ILLEGAL_REQUEST &&=0A=
> +			scp->sense_buffer[2] =3D=3D INVALID_FIELD_IN_CDB &&=0A=
> +			scp->sense_buffer[3] =3D=3D 0);=0A=
> +	return ((scp->sense_buffer[2] & 0xf) =3D=3D ILLEGAL_REQUEST &&=0A=
> +		scp->sense_buffer[12] =3D=3D INVALID_FIELD_IN_CDB &&=0A=
> +		scp->sense_buffer[13] =3D=3D 0);=0A=
> +}=0A=
> +=0A=
>  static void mk_sense_buffer(struct scsi_cmnd *scp, int key, int asc, int=
 asq)=0A=
>  {=0A=
>  	unsigned char *sbuff;=0A=
> @@ -2777,14 +2774,14 @@ static void zbc_inc_wp(struct sdebug_dev_info *de=
vip,=0A=
>  }=0A=
>  =0A=
>  static int check_zbc_access_params(struct scsi_cmnd *scp,=0A=
> -			unsigned long long lba, unsigned int num, bool write)=0A=
> +		unsigned long long lba, unsigned int num, bool data_out)=0A=
>  {=0A=
>  	struct scsi_device *sdp =3D scp->device;=0A=
>  	struct sdebug_dev_info *devip =3D (struct sdebug_dev_info *)sdp->hostda=
ta;=0A=
>  	struct sdeb_zone_state *zsp =3D zbc_zone(devip, lba);=0A=
>  	struct sdeb_zone_state *zsp_end =3D zbc_zone(devip, lba + num - 1);=0A=
>  =0A=
> -	if (!write) {=0A=
> +	if (!data_out) {=0A=
>  		if (devip->zmodel =3D=3D BLK_ZONED_HA)=0A=
>  			return 0;=0A=
>  		/* For host-managed, reads cannot cross zone types boundaries */=0A=
> @@ -2820,8 +2817,8 @@ static int check_zbc_access_params(struct scsi_cmnd=
 *scp,=0A=
>  		}=0A=
>  		/* Cannot write full zones */=0A=
>  		if (zsp->z_cond =3D=3D ZC5_FULL) {=0A=
> -			mk_sense_buffer(scp, ILLEGAL_REQUEST,=0A=
> -					INVALID_FIELD_IN_CDB, 0);=0A=
> +			/* want sLBA position in cdb, fix up later */=0A=
> +			mk_sense_invalid_fld(scp, SDEB_IN_CDB, 0, -1);=0A=
>  			return check_condition_result;=0A=
>  		}=0A=
>  		/* Writes must be aligned to the zone WP */=0A=
> @@ -2848,9 +2845,10 @@ static int check_zbc_access_params(struct scsi_cmn=
d *scp,=0A=
>  	return 0;=0A=
>  }=0A=
>  =0A=
> +/* Last argument should only be true when data-out and media modifying *=
/=0A=
>  static inline int check_device_access_params=0A=
>  			(struct scsi_cmnd *scp, unsigned long long lba,=0A=
> -			 unsigned int num, bool write)=0A=
> +			 unsigned int num, bool modifying)=0A=
>  {=0A=
>  	struct scsi_device *sdp =3D scp->device;=0A=
>  	struct sdebug_dev_info *devip =3D (struct sdebug_dev_info *)sdp->hostda=
ta;=0A=
> @@ -2861,16 +2859,16 @@ static inline int check_device_access_params=0A=
>  	}=0A=
>  	/* transfer length excessive (tie in to block limits VPD page) */=0A=
>  	if (num > sdebug_store_sectors) {=0A=
> -		/* needs work to find which cdb byte 'num' comes from */=0A=
> -		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);=0A=
> +		/* want num offset in cdb, fix up later */=0A=
> +		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 0, -1);=0A=
>  		return check_condition_result;=0A=
>  	}=0A=
> -	if (write && unlikely(sdebug_wp)) {=0A=
> +	if (modifying && unlikely(sdebug_wp)) {=0A=
>  		mk_sense_buffer(scp, DATA_PROTECT, WRITE_PROTECTED, 0x2);=0A=
>  		return check_condition_result;=0A=
>  	}=0A=
>  	if (sdebug_dev_is_zoned(devip))=0A=
> -		return check_zbc_access_params(scp, lba, num, write);=0A=
> +		return check_zbc_access_params(scp, lba, num, modifying);=0A=
>  =0A=
>  	return 0;=0A=
>  }=0A=
> @@ -3462,6 +3460,36 @@ static int resp_write_dt0(struct scsi_cmnd *scp, s=
truct sdebug_dev_info *devip)=0A=
>  	write_lock(macc_lckp);=0A=
>  	ret =3D check_device_access_params(scp, lba, num, true);=0A=
>  	if (ret) {=0A=
> +		if (have_sense_invalid_fld_cdb(scp)) {=0A=
> +			bool is_zbc =3D (sdeb_zbc_model !=3D BLK_ZONED_NONE);=0A=
> +			int lba_o, num_o;=0A=
> +=0A=
> +			switch (cmd[0]) {=0A=
> +			case WRITE_16:=0A=
> +				lba_o =3D 2;=0A=
> +				num_o =3D 10;=0A=
> +				break;=0A=
> +			case WRITE_10:=0A=
> +			case 0x53:=0A=
> +				lba_o =3D 2;=0A=
> +				num_o =3D 7;=0A=
> +				break;=0A=
> +			case WRITE_6:=0A=
> +				lba_o =3D 1;=0A=
> +				num_o =3D 4;=0A=
> +				break;=0A=
> +			case WRITE_12:=0A=
> +				lba_o =3D 2;=0A=
> +				num_o =3D 6;=0A=
> +				break;=0A=
> +			default:	/* assume WRITE(32) */=0A=
> +				lba_o =3D 20;=0A=
> +				num_o =3D 28;=0A=
> +				break;=0A=
> +			}=0A=
> +			mk_sense_invalid_fld(scp, SDEB_IN_CDB,=0A=
> +					     (is_zbc ? lba_o : num_o), -1);=0A=
> +		}=0A=
>  		write_unlock(macc_lckp);=0A=
>  		return ret;=0A=
>  	}=0A=
> @@ -3568,7 +3596,7 @@ static int resp_write_scat(struct scsi_cmnd *scp,=
=0A=
>  			sdev_printk(KERN_INFO, scp->device,=0A=
>  				"%s: %s: LB Data Offset field bad\n",=0A=
>  				my_name, __func__);=0A=
> -		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);=0A=
> +		mk_sense_invalid_fld(scp, SDEB_IN_CDB, (is_16 ? 4 : 12), -1);=0A=
>  		return illegal_condition_result;=0A=
>  	}=0A=
>  	lbdof_blen =3D lbdof * lb_size;=0A=
> @@ -3577,7 +3605,7 @@ static int resp_write_scat(struct scsi_cmnd *scp,=
=0A=
>  			sdev_printk(KERN_INFO, scp->device,=0A=
>  				"%s: %s: LBA range descriptors don't fit\n",=0A=
>  				my_name, __func__);=0A=
> -		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);=0A=
> +		mk_sense_invalid_fld(scp, SDEB_IN_CDB, (is_16 ? 8 : 16), -1);=0A=
>  		return illegal_condition_result;=0A=
>  	}=0A=
>  	lrdp =3D kzalloc(lbdof_blen, GFP_ATOMIC);=0A=
> @@ -3607,8 +3635,13 @@ static int resp_write_scat(struct scsi_cmnd *scp,=
=0A=
>  		if (num =3D=3D 0)=0A=
>  			continue;=0A=
>  		ret =3D check_device_access_params(scp, lba, num, true);=0A=
> -		if (ret)=0A=
> +		if (ret) {=0A=
> +			if (have_sense_invalid_fld_cdb(scp))=0A=
> +				/* assume not zbc, point at number of LBs */=0A=
> +				mk_sense_invalid_fld(scp, SDEB_IN_DATA,=0A=
> +						     (up - lrdp) + 8, -1);=0A=
>  			goto err_out_unlock;=0A=
> +		}=0A=
>  		num_by =3D num * lb_size;=0A=
>  		ei_lba =3D is_16 ? 0 : get_unaligned_be32(up + 12);=0A=
>  =0A=
> @@ -3703,7 +3736,7 @@ static int resp_write_same(struct scsi_cmnd *scp, u=
64 lba, u32 num,=0A=
>  	write_lock(macc_lckp);=0A=
>  =0A=
>  	ret =3D check_device_access_params(scp, lba, num, true);=0A=
> -	if (ret) {=0A=
> +	if (ret) {	/* illegal request fixup next level up */=0A=
>  		write_unlock(macc_lckp);=0A=
>  		return ret;=0A=
>  	}=0A=
> @@ -3755,6 +3788,7 @@ static int resp_write_same_10(struct scsi_cmnd *scp=
,=0A=
>  	u32 lba;=0A=
>  	u16 num;=0A=
>  	u32 ei_lba =3D 0;=0A=
> +	int res;=0A=
>  	bool unmap =3D false;=0A=
>  =0A=
>  	if (cmd[1] & 0x8) {=0A=
> @@ -3770,7 +3804,13 @@ static int resp_write_same_10(struct scsi_cmnd *sc=
p,=0A=
>  		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 7, -1);=0A=
>  		return check_condition_result;=0A=
>  	}=0A=
> -	return resp_write_same(scp, lba, num, ei_lba, unmap, false);=0A=
> +	res =3D resp_write_same(scp, lba, num, ei_lba, unmap, false);=0A=
> +	if (have_sense_invalid_fld_cdb(scp)) {=0A=
> +		bool is_zbc =3D (sdeb_zbc_model !=3D BLK_ZONED_NONE);=0A=
> +=0A=
> +		mk_sense_invalid_fld(scp, SDEB_IN_CDB, is_zbc ? 2 : 7, -1);=0A=
> +	}=0A=
> +	return res;=0A=
>  }=0A=
>  =0A=
>  static int resp_write_same_16(struct scsi_cmnd *scp,=0A=
> @@ -3780,6 +3820,7 @@ static int resp_write_same_16(struct scsi_cmnd *scp=
,=0A=
>  	u64 lba;=0A=
>  	u32 num;=0A=
>  	u32 ei_lba =3D 0;=0A=
> +	int res;=0A=
>  	bool unmap =3D false;=0A=
>  	bool ndob =3D false;=0A=
>  =0A=
> @@ -3798,7 +3839,13 @@ static int resp_write_same_16(struct scsi_cmnd *sc=
p,=0A=
>  		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 10, -1);=0A=
>  		return check_condition_result;=0A=
>  	}=0A=
> -	return resp_write_same(scp, lba, num, ei_lba, unmap, ndob);=0A=
> +	res =3D resp_write_same(scp, lba, num, ei_lba, unmap, ndob);=0A=
> +	if (have_sense_invalid_fld_cdb(scp)) {=0A=
> +		bool is_zbc =3D (sdeb_zbc_model !=3D BLK_ZONED_NONE);=0A=
> +=0A=
> +		mk_sense_invalid_fld(scp, SDEB_IN_CDB, is_zbc ? 2 : 10, -1);=0A=
> +	}=0A=
> +	return res;=0A=
>  }=0A=
>  =0A=
>  /* Note the mode field is in the same position as the (lower) service ac=
tion=0A=
> @@ -3878,9 +3925,13 @@ static int resp_comp_write(struct scsi_cmnd *scp,=
=0A=
>  	    (cmd[1] & 0xe0) =3D=3D 0)=0A=
>  		sdev_printk(KERN_ERR, scp->device, "Unprotected WR "=0A=
>  			    "to DIF device\n");=0A=
> -	ret =3D check_device_access_params(scp, lba, num, false);=0A=
> -	if (ret)=0A=
> +	ret =3D check_device_access_params(scp, lba, num, true);=0A=
=0A=
The last argument changed... If this is a bug fix, shouldn't it be a separa=
te=0A=
patch before this one ?=0A=
=0A=
> +	if (ret) {=0A=
> +		if (have_sense_invalid_fld_cdb(scp))=0A=
> +			/* assume not zbc, point at number of LBs */=0A=
> +			mk_sense_invalid_fld(scp, SDEB_IN_CDB, 13, -1);=0A=
>  		return ret;=0A=
> +	}=0A=
>  	dnum =3D 2 * num;=0A=
>  	arr =3D kcalloc(lb_size, dnum, GFP_ATOMIC);=0A=
>  	if (NULL =3D=3D arr) {=0A=
> @@ -3959,8 +4010,18 @@ static int resp_unmap(struct scsi_cmnd *scp, struc=
t sdebug_dev_info *devip)=0A=
>  		unsigned int num =3D get_unaligned_be32(&desc[i].blocks);=0A=
>  =0A=
>  		ret =3D check_device_access_params(scp, lba, num, true);=0A=
> -		if (ret)=0A=
> +		if (ret) {=0A=
> +			if (have_sense_invalid_fld_cdb(scp)) {=0A=
> +				bool is_zbc =3D (sdeb_zbc_model !=3D=0A=
> +					       BLK_ZONED_NONE);=0A=
> +				u8 *offp =3D (u8 *)&desc[i].lba +=0A=
> +					   (is_zbc ? 0 : 8);=0A=
> +=0A=
> +				mk_sense_invalid_fld(scp, SDEB_IN_DATA,=0A=
> +						     (offp - buf), -1);=0A=
> +			}=0A=
>  			goto out;=0A=
> +		}=0A=
>  =0A=
>  		unmap_region(sip, lba, num);=0A=
>  	}=0A=
> @@ -4230,7 +4291,7 @@ static int resp_verify(struct scsi_cmnd *scp, struc=
t sdebug_dev_info *devip)=0A=
>  		return check_condition_result;=0A=
>  	}=0A=
>  	a_num =3D is_bytchk3 ? 1 : vnum;=0A=
> -	/* Treat following check like one for read (i.e. no write) access */=0A=
> +	/* This is data-out but not media modifying, so last argument false */=
=0A=
>  	ret =3D check_device_access_params(scp, lba, a_num, false);=0A=
>  	if (ret)=0A=
>  		return ret;=0A=
> @@ -4367,8 +4428,7 @@ static int resp_report_zones(struct scsi_cmnd *scp,=
=0A=
>  				continue;=0A=
>  			break;=0A=
>  		default:=0A=
> -			mk_sense_buffer(scp, ILLEGAL_REQUEST,=0A=
> -					INVALID_FIELD_IN_CDB, 0);=0A=
> +			mk_sense_invalid_fld(scp, SDEB_IN_CDB, 14, 5);=0A=
>  			ret =3D check_condition_result;=0A=
>  			goto fini;=0A=
>  		}=0A=
> @@ -4458,12 +4518,12 @@ static int resp_open_zone(struct scsi_cmnd *scp, =
struct sdebug_dev_info *devip)=0A=
>  =0A=
>  	zsp =3D zbc_zone(devip, z_id);=0A=
>  	if (z_id !=3D zsp->z_start) {=0A=
> -		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);=0A=
> +		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 2, -1);=0A=
>  		res =3D check_condition_result;=0A=
>  		goto fini;=0A=
>  	}=0A=
>  	if (zbc_zone_is_conv(zsp)) {=0A=
> -		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);=0A=
> +		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 2, -1);=0A=
>  		res =3D check_condition_result;=0A=
>  		goto fini;=0A=
>  	}=0A=
> @@ -4528,12 +4588,12 @@ static int resp_close_zone(struct scsi_cmnd *scp,=
=0A=
>  =0A=
>  	zsp =3D zbc_zone(devip, z_id);=0A=
>  	if (z_id !=3D zsp->z_start) {=0A=
> -		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);=0A=
> +		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 2, -1);=0A=
>  		res =3D check_condition_result;=0A=
>  		goto fini;=0A=
>  	}=0A=
>  	if (zbc_zone_is_conv(zsp)) {=0A=
> -		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);=0A=
> +		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 2, -1);=0A=
>  		res =3D check_condition_result;=0A=
>  		goto fini;=0A=
>  	}=0A=
> @@ -4601,12 +4661,12 @@ static int resp_finish_zone(struct scsi_cmnd *scp=
,=0A=
>  =0A=
>  	zsp =3D zbc_zone(devip, z_id);=0A=
>  	if (z_id !=3D zsp->z_start) {=0A=
> -		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);=0A=
> +		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 2, -1);=0A=
>  		res =3D check_condition_result;=0A=
>  		goto fini;=0A=
>  	}=0A=
>  	if (zbc_zone_is_conv(zsp)) {=0A=
> -		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);=0A=
> +		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 2, -1);=0A=
>  		res =3D check_condition_result;=0A=
>  		goto fini;=0A=
>  	}=0A=
> @@ -4676,12 +4736,12 @@ static int resp_rwp_zone(struct scsi_cmnd *scp, s=
truct sdebug_dev_info *devip)=0A=
>  =0A=
>  	zsp =3D zbc_zone(devip, z_id);=0A=
>  	if (z_id !=3D zsp->z_start) {=0A=
> -		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);=0A=
> +		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 2, -1);=0A=
>  		res =3D check_condition_result;=0A=
>  		goto fini;=0A=
>  	}=0A=
>  	if (zbc_zone_is_conv(zsp)) {=0A=
> -		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);=0A=
> +		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 2, -1);=0A=
>  		res =3D check_condition_result;=0A=
>  		goto fini;=0A=
>  	}=0A=
> =0A=
=0A=
Apart from the comment above, looks OK to me.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
