Return-Path: <SRS0=B1Ch=6Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FB00C47255
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 05:09:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42EAA2137B
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 05:09:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="RjleI1PO";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="kf80Kvxl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726082AbgEKFJp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 May 2020 01:09:45 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:24488 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbgEKFJo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2020 01:09:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1589173806; x=1620709806;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=ve020HPTTw1oBR9kx7N9mpC17hwnyMuwGX4YOkcOq+A=;
  b=RjleI1POL8oE+UW4AL/dBfvL5HPSPevAOFSaCwwmx8OB78wLITdWH6Kv
   4Q07pB2t7Dwt7Obz9PWze5FHoFHx5vMK8jbFQuZhypi1TWhwwB4dIwo6S
   zGjj1M2QzB8QLtj7u4lKWjSByyC+7+dcSKZlO2Iwvsk0pURDS4E3KrBZT
   4dxbL4gl+nuWgvzoY/RyjaPMpoUcO2bZmEFg07d0h1wqRWtsMc8PuKyId
   FXlMEoqk7yOxtYS4UTgEAQ/QIm43iIvMxA1Iq9vVecYu2iaS4LJl8HIU9
   ZOBvjIJfs7X80/7SwPSUOxuXZJOlgXdPf6rgVSShNmNaNQYwLHYBOvx60
   g==;
IronPort-SDR: YAu9yd7ZtpxqkTxwMzWNIecyzXzUmtO5K0vcZY7kDP2Y3d40nuog2d6SAf4iDfDX2x00Olh7gb
 JkiG6sRzfHSeVay+WpiuYLfutwQoJgQZNF3RxWWCotY1E/w9l7A70c4A++rbl6WucnxS8Tq957
 CA8whErxzljhQJehD5fkS+DssSeRzZirgDUOuDC+ZvSi7fnzSe2A3UtoQNniuddZOv/wtzGJd9
 ua5y9xI1o2p+80yuFkw4f3nIDSsJeWB76va1NoaFfPV/NlGOdy1O3hvl635KCTioi+KM+GB/gp
 ZCg=
X-IronPort-AV: E=Sophos;i="5.73,378,1583164800"; 
   d="scan'208";a="240059058"
Received: from mail-mw2nam12lp2046.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.46])
  by ob1.hgst.iphmx.com with ESMTP; 11 May 2020 13:10:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HzQgkUXWpjH5aRSbSm/32unPFdNn7pmnAj4+oLPg93HV6bQBy7oNGZgRsgcrY78YmR95JRNw+KK1Ykt3Dtz0lLuJAcVEwB2HfKBtGLQn7TGKRw9BNFAYOhKU9um0FD+FUX0xW8M6SMuQ6ebLqpFOUK43mHY32Kwi7ywPEERhrL0f4urkoCfYjdmFl7XA4HLAE8cFlm1HhMpNNRD5QZvyEdJlT2B3ZUyp2OvY2Sy8s8zMDhscFrQDK/7YgrXi0URu3Q+bM6eXE3Wvt+PQJSfB8Q/yEz5U3oybmLJ14kkQlFtlfA3fp/CZK9nvnjfVhRyFE8a7f+dIZURZjnU5c5QOqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E8I2lRUar34DMc/Ef6H6hNYpkUltXcml+U6su1UC/jk=;
 b=S/7dTfW5ieY1tLAwkGb139IFrbtfqRSCNvnmkFf3wlfBOmW6suPtBMpNidihA/KM2XMu0SGn3e5u+/mho5UPUFrt8Q+Ldjx3q2g6fmZcBoFHL3ZjMKPZzSLNqhBJr+B06lPuV/hdD94Y3l48upF7D/9w5H8OA548Bkn6zZtAVs8a1plShVMLKpOXSSOWnnzwDYPCQtUBgwhRdMF10PBklicr9In2oe8z7lOkLfC7c2iP5n7sOYBzoAVd0jtBEj2kt+9gssUxaBtPVEl4G3XXrsU1xL0VIfsTkSQlgiW25ZwR+QnZPUGo/62Aor0V4UMP7Irdsi+kzsK1DYz6mtKNOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E8I2lRUar34DMc/Ef6H6hNYpkUltXcml+U6su1UC/jk=;
 b=kf80KvxlEo9kB16fzdsi6Es+uyAy2PGn1GB/S3VdbI/7yRGwy6G3/WqWCCgeq0z0+3SYNI2adDtx0OFEo82Ck61F3cxLs6v6Ke5AmUxWcGS1BDQ7ky5ebRqrQBYC+eUeriygc3jIJ1ruJKJeav+ZqDzSqb8CFxrEArjt0SQ85as=
Received: from BY5PR04MB6900.namprd04.prod.outlook.com (2603:10b6:a03:229::20)
 by BY5PR04MB6360.namprd04.prod.outlook.com (2603:10b6:a03:1ef::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.34; Mon, 11 May
 2020 05:09:38 +0000
Received: from BY5PR04MB6900.namprd04.prod.outlook.com
 ([fe80::b574:3071:da2f:7606]) by BY5PR04MB6900.namprd04.prod.outlook.com
 ([fe80::b574:3071:da2f:7606%6]) with mapi id 15.20.2979.033; Mon, 11 May 2020
 05:09:38 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Douglas Gilbert <dgilbert@interlog.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>,
        "hare@suse.de" <hare@suse.de>
Subject: Re: [PATCH] scsi_debug: improve error reporting, zbc+general
Thread-Topic: [PATCH] scsi_debug: improve error reporting, zbc+general
Thread-Index: AQHWJIXVloik+L+MvkGVwKUvERf1xA==
Date:   Mon, 11 May 2020 05:09:38 +0000
Message-ID: <BY5PR04MB6900438A5B557D982C0FE43AE7A10@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200507154011.19151-1-dgilbert@interlog.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: interlog.com; dkim=none (message not signed)
 header.d=none;interlog.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: dba19cce-bff2-4d32-8609-08d7f569816f
x-ms-traffictypediagnostic: BY5PR04MB6360:
x-microsoft-antispam-prvs: <BY5PR04MB63606421DCDC69659AFB376EE7A10@BY5PR04MB6360.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 04004D94E2
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YjtJpSH1sRfStmgUsL7p9KKFDWnEfH2jWzcG6flqx9TbgIYl3WtToKUWbjgylvzBDaV0qzATka5HDn69j340lWPhrUH02HjM6cd8kV4+PYuop70+Es6Opq+2e0k1BwWDajc5BjnfkgTC0jeLKUU2BXIZN90D/dPQGzLz2KpjmyNozKwpTf4dvCp1Zc4+SOwd70TCTBR4TSL39gY37iiZ2sMxX3jts14vUZWcdoDU1hxfm5JZkavQUth7KrDHSeefpOzDV3Emnx+f5s9UKlD3KZZV3wcuLluTrufPZXIS+lvILwGbF/PlTuWLdFaEqTfhyp8Hn/z1YCR2233yUL0llW25UAqWjs/OyxvkKkHi600qBrYPKADDD46Dqk1d2GQPrg+rLhcNO6x1BLClrR0bAQPyM7zB0kzRhCiGxlKdFvPXxXxDE4zBuHS2tfgtnvhEfFetQQPa6/388sag/Jh6cMgxRCVgMOCbO4kxcdhrD+ho0DLP3cjnW7mPjudS2B53MYmizo2Hvzjw+YeOIoQzfg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR04MB6900.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(346002)(39860400002)(376002)(366004)(33430700001)(6506007)(53546011)(8676002)(8936002)(4326008)(66476007)(86362001)(26005)(110136005)(30864003)(54906003)(66946007)(76116006)(5660300002)(7696005)(71200400001)(64756008)(66556008)(186003)(55016002)(52536014)(316002)(33656002)(66446008)(2906002)(33440700001)(9686003)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: dIhiVBrQ9SjLYyS1fL/ZdUin8LmnXW/IYU6CVGPykjjEZtLtCcEArhz07waR+39txG4OAIbrCZ5C7JQzjCXGMC+4aQ+NjtWfqKlAQKWW233Fdai0HGkrTv7Nkh3V+y0V+WkKDL5Q372tmpkq2/7gKjXZ1j+oTHHo1Y9+fQf/H/+jhVmh19OfTU/i82zkpCIyBjpzIU5n0K1oU9OEEdPFxDpGoZ5HrF/KhWME6GNM9lJHbDQw8/OygPFWk6tDWsxQkKOSO1m5gkdUGrZSbT6AOuzoAgT6opZ0SLzhVyyd7/YFjcoARr/LbM8T0IxDSDSfI9hWWslpqs+F8sp+nGs85OnZKm2Y9p+Pb9fgfS7rSXV6ZTWuJ6liroUYRtdwSUYO1wb31uTP/TwUW4+8l83Xm+RY2sCl2SlH7XDyR7apfg3b611lH+BhLrmR422ZBzRvfvLtgQU5WqT6Fo8EF08D5ti9gdfhV/m2YFtjb1aoB2mf/fy3Wzb6QXtVDQTWkgtw
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dba19cce-bff2-4d32-8609-08d7f569816f
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2020 05:09:38.7040
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +gTrHtgk6ixxLXBGSU5dHGOq6HF75ybGCqUzPyGVHku0hfte1EkOjVSvwkHZ5ISiiMJWr3WHOlApDmypyAJ2fQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6360
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/05/08 0:40, Douglas Gilbert wrote:=0A=
> This driver attempts to help the application client in the case of=0A=
> ILLEGAL REQUEST by using the field pointer information mechanism=0A=
> to point to the location in a cdb or parameter block that triggered=0A=
> an error. Some cases of the ILLEGAL REQUEST sense key being issued=0A=
> without field pointer information snuck into the recently added zone=0A=
> commands. There were also pre-existing cases that are picked up by=0A=
> this patch.=0A=
> =0A=
> The change is to use mk_sense_invalid_fld() rather than =0A=
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
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>=0A=
> ---=0A=
>  drivers/scsi/scsi_debug.c | 164 ++++++++++++++++++++++++++------------=
=0A=
>  1 file changed, 115 insertions(+), 49 deletions(-)=0A=
> =0A=
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c=0A=
> index 79a48dd1b9e4..420145af1e5c 100644=0A=
> --- a/drivers/scsi/scsi_debug.c=0A=
> +++ b/drivers/scsi/scsi_debug.c=0A=
> @@ -61,7 +61,7 @@=0A=
>  =0A=
>  /* make sure inq_product_rev string corresponds to this version */=0A=
>  #define SDEBUG_VERSION "0189"	/* format to fit INQUIRY revision field */=
=0A=
> -static const char *sdebug_version_date =3D "20200421";=0A=
> +static const char *sdebug_version_date =3D "20200506";=0A=
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
> @@ -937,29 +936,28 @@ static void mk_sense_invalid_fld(struct scsi_cmnd *=
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
> +	else=0A=
=0A=
No need for the else here.=0A=
=0A=
> +		return ((scp->sense_buffer[2] & 0xf) =3D=3D ILLEGAL_REQUEST &&=0A=
> +			scp->sense_buffer[12] =3D=3D INVALID_FIELD_IN_CDB &&=0A=
> +			scp->sense_buffer[13] =3D=3D 0);=0A=
> +}=0A=
> +=0A=
>  static void mk_sense_buffer(struct scsi_cmnd *scp, int key, int asc, int=
 asq)=0A=
>  {=0A=
>  	unsigned char *sbuff;=0A=
> @@ -2777,14 +2775,14 @@ static void zbc_inc_wp(struct sdebug_dev_info *de=
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
> @@ -2820,8 +2818,8 @@ static int check_zbc_access_params(struct scsi_cmnd=
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
> @@ -2848,9 +2846,10 @@ static int check_zbc_access_params(struct scsi_cmn=
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
> @@ -2861,16 +2860,16 @@ static inline int check_device_access_params=0A=
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
> @@ -3462,6 +3461,36 @@ static int resp_write_dt0(struct scsi_cmnd *scp, s=
truct sdebug_dev_info *devip)=0A=
>  	write_lock(macc_lckp);=0A=
>  	ret =3D check_device_access_params(scp, lba, num, true);=0A=
>  	if (ret) {=0A=
> +		if (have_sense_invalid_fld_cdb(scp)) {=0A=
> +			bool is_zbc =3D (sdeb_zbc_model !=3D 0);=0A=
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
> @@ -3568,7 +3597,7 @@ static int resp_write_scat(struct scsi_cmnd *scp,=
=0A=
>  			sdev_printk(KERN_INFO, scp->device,=0A=
>  				"%s: %s: LB Data Offset field bad\n",=0A=
>  				my_name, __func__);=0A=
> -		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);=0A=
> +		mk_sense_invalid_fld(scp, SDEB_IN_CDB, (is_16 ? 4 : 12), -1);=0A=
>  		return illegal_condition_result;=0A=
>  	}=0A=
>  	lbdof_blen =3D lbdof * lb_size;=0A=
> @@ -3577,7 +3606,7 @@ static int resp_write_scat(struct scsi_cmnd *scp,=
=0A=
>  			sdev_printk(KERN_INFO, scp->device,=0A=
>  				"%s: %s: LBA range descriptors don't fit\n",=0A=
>  				my_name, __func__);=0A=
> -		mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_FIELD_IN_CDB, 0);=0A=
> +		mk_sense_invalid_fld(scp, SDEB_IN_CDB, (is_16 ? 8 : 16), -1);=0A=
>  		return illegal_condition_result;=0A=
>  	}=0A=
>  	lrdp =3D kzalloc(lbdof_blen, GFP_ATOMIC);=0A=
> @@ -3607,8 +3636,16 @@ static int resp_write_scat(struct scsi_cmnd *scp,=
=0A=
>  		if (num =3D=3D 0)=0A=
>  			continue;=0A=
>  		ret =3D check_device_access_params(scp, lba, num, true);=0A=
> -		if (ret)=0A=
> +		if (ret) {=0A=
> +			if (have_sense_invalid_fld_cdb(scp)) {=0A=
> +				bool is_zbc =3D (sdeb_zbc_model !=3D 0);=0A=
> +				int off =3D is_zbc ? 0 : 8;=0A=
=0A=
is_zbc is not really needed here, I think.=0A=
=0A=
> +=0A=
> +				mk_sense_invalid_fld(scp, SDEB_IN_DATA,=0A=
> +						     (up - lrdp) + off, -1);=0A=
> +			}=0A=
>  			goto err_out_unlock;=0A=
> +		}=0A=
>  		num_by =3D num * lb_size;=0A=
>  		ei_lba =3D is_16 ? 0 : get_unaligned_be32(up + 12);=0A=
>  =0A=
> @@ -3703,7 +3740,7 @@ static int resp_write_same(struct scsi_cmnd *scp, u=
64 lba, u32 num,=0A=
>  	write_lock(macc_lckp);=0A=
>  =0A=
>  	ret =3D check_device_access_params(scp, lba, num, true);=0A=
> -	if (ret) {=0A=
> +	if (ret) {	/* illegal request fixup next level up */=0A=
>  		write_unlock(macc_lckp);=0A=
>  		return ret;=0A=
>  	}=0A=
> @@ -3755,6 +3792,7 @@ static int resp_write_same_10(struct scsi_cmnd *scp=
,=0A=
>  	u32 lba;=0A=
>  	u16 num;=0A=
>  	u32 ei_lba =3D 0;=0A=
> +	int res;=0A=
>  	bool unmap =3D false;=0A=
>  =0A=
>  	if (cmd[1] & 0x8) {=0A=
> @@ -3770,7 +3808,13 @@ static int resp_write_same_10(struct scsi_cmnd *sc=
p,=0A=
>  		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 7, -1);=0A=
>  		return check_condition_result;=0A=
>  	}=0A=
> -	return resp_write_same(scp, lba, num, ei_lba, unmap, false);=0A=
> +	res =3D resp_write_same(scp, lba, num, ei_lba, unmap, false);=0A=
> +	if (have_sense_invalid_fld_cdb(scp)) {=0A=
> +		bool is_zbc =3D (sdeb_zbc_model !=3D 0);=0A=
> +=0A=
> +		mk_sense_invalid_fld(scp, SDEB_IN_CDB, is_zbc ? 2 : 7, -1);=0A=
> +	}=0A=
> +	return res;=0A=
>  }=0A=
>  =0A=
>  static int resp_write_same_16(struct scsi_cmnd *scp,=0A=
> @@ -3780,6 +3824,7 @@ static int resp_write_same_16(struct scsi_cmnd *scp=
,=0A=
>  	u64 lba;=0A=
>  	u32 num;=0A=
>  	u32 ei_lba =3D 0;=0A=
> +	int res;=0A=
>  	bool unmap =3D false;=0A=
>  	bool ndob =3D false;=0A=
>  =0A=
> @@ -3798,7 +3843,13 @@ static int resp_write_same_16(struct scsi_cmnd *sc=
p,=0A=
>  		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 10, -1);=0A=
>  		return check_condition_result;=0A=
>  	}=0A=
> -	return resp_write_same(scp, lba, num, ei_lba, unmap, ndob);=0A=
> +	res =3D resp_write_same(scp, lba, num, ei_lba, unmap, ndob);=0A=
> +	if (have_sense_invalid_fld_cdb(scp)) {=0A=
> +		bool is_zbc =3D (sdeb_zbc_model !=3D 0);=0A=
> +=0A=
> +		mk_sense_invalid_fld(scp, SDEB_IN_CDB, is_zbc ? 2 : 10, -1);=0A=
> +	}=0A=
> +	return res;=0A=
>  }=0A=
>  =0A=
>  /* Note the mode field is in the same position as the (lower) service ac=
tion=0A=
> @@ -3878,9 +3929,16 @@ static int resp_comp_write(struct scsi_cmnd *scp,=
=0A=
>  	    (cmd[1] & 0xe0) =3D=3D 0)=0A=
>  		sdev_printk(KERN_ERR, scp->device, "Unprotected WR "=0A=
>  			    "to DIF device\n");=0A=
> -	ret =3D check_device_access_params(scp, lba, num, false);=0A=
> -	if (ret)=0A=
> +	ret =3D check_device_access_params(scp, lba, num, true);=0A=
> +	if (ret) {=0A=
> +		if (have_sense_invalid_fld_cdb(scp)) {=0A=
> +			bool is_zbc =3D (sdeb_zbc_model !=3D 0);=0A=
> +			int off =3D is_zbc ? 2 : 13;=0A=
=0A=
Same here, is_zbc is not really needed.=0A=
=0A=
> +=0A=
> +			mk_sense_invalid_fld(scp, SDEB_IN_CDB, off, -1);=0A=
> +		}=0A=
>  		return ret;=0A=
> +	}=0A=
>  	dnum =3D 2 * num;=0A=
>  	arr =3D kcalloc(lb_size, dnum, GFP_ATOMIC);=0A=
>  	if (NULL =3D=3D arr) {=0A=
> @@ -3959,8 +4017,17 @@ static int resp_unmap(struct scsi_cmnd *scp, struc=
t sdebug_dev_info *devip)=0A=
>  		unsigned int num =3D get_unaligned_be32(&desc[i].blocks);=0A=
>  =0A=
>  		ret =3D check_device_access_params(scp, lba, num, true);=0A=
> -		if (ret)=0A=
> +		if (ret) {=0A=
> +			if (have_sense_invalid_fld_cdb(scp)) {=0A=
> +				bool is_zbc =3D (sdeb_zbc_model !=3D 0);=0A=
> +				u8 *offp =3D (u8 *)&desc[i].lba +=0A=
> +					   (is_zbc ? 0 : 8);=0A=
> +=0A=
> +				mk_sense_invalid_fld(scp, SDEB_IN_DATA,=0A=
> +						     (offp - buf), -1);=0A=
> +			}=0A=
=0A=
This pattern:=0A=
=0A=
if (have_sense_invalid_fld_cdb(scp)) {=0A=
	bool is_zbc =3D ...=0A=
	=0A=
	mk_sense_invalid_fld(scp, SDEB_IN_DATA, ...values...);=0A=
}=0A=
=0A=
is repeated multiple times. It would be nice to have it as a helper functio=
n=0A=
that sorts out all the values based on the scp. Even if that repeats some c=
ode=0A=
for parsing, overall, the code would be cleaner I think.=0A=
=0A=
>  			goto out;=0A=
> +		}=0A=
>  =0A=
>  		unmap_region(sip, lba, num);=0A=
>  	}=0A=
> @@ -4230,7 +4297,7 @@ static int resp_verify(struct scsi_cmnd *scp, struc=
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
> @@ -4367,8 +4434,7 @@ static int resp_report_zones(struct scsi_cmnd *scp,=
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
> @@ -4458,12 +4524,12 @@ static int resp_open_zone(struct scsi_cmnd *scp, =
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
> +		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 2 /* z_id */, -1);=0A=
=0A=
You added the /* z_id */ comment only here and not to the other cases for c=
lose=0A=
etc. So may be be consistent and remove it here ? I do not think it is real=
ly=0A=
needed.=0A=
=0A=
>  		res =3D check_condition_result;=0A=
>  		goto fini;=0A=
>  	}=0A=
> @@ -4528,12 +4594,12 @@ static int resp_close_zone(struct scsi_cmnd *scp,=
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
> @@ -4601,12 +4667,12 @@ static int resp_finish_zone(struct scsi_cmnd *scp=
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
> @@ -4676,12 +4742,12 @@ static int resp_rwp_zone(struct scsi_cmnd *scp, s=
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
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
