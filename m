Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0049CC4320E
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 09:12:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA0B561159
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 09:12:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244360AbhHFJM4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 05:12:56 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:41232 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244303AbhHFJMy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 05:12:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628241159; x=1659777159;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=qWwISQWRGTJlgI7zExFXTcgmTUcMJ5IrozCg2GVS4cU=;
  b=SVrUXIZZaIlYnqimW+UDf+y043L+++fOXtQWj7OvBn2aprQeePn86mGL
   1fYV8ix11dSubsEjQ+D9BxRKFxwRjdoZdmyapuVz7ztGQFhZQItDlL13k
   NtTERu9eXStNG+MDRPEqUVTOhigsH4q6kRse2bNRfHzdxqMDebP6vYKt1
   v6g4DSLuX5lwXB/3MxTAItnoGmH9M7NWnWFhvzQcEV4vukVFBJBQvJkYf
   yqUuUbhlTe33FgZQN9C/dx54CHFbwKkQFnJe28IBOlbNVf8u+E+iaMdaB
   tZohVJgcQCocF6mv7Bs/hMS0hrWI61lok5EtuaNw9gahRfPNaL3hdBhUv
   A==;
X-IronPort-AV: E=Sophos;i="5.84,300,1620662400"; 
   d="scan'208";a="280333062"
Received: from mail-co1nam11lp2168.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.168])
  by ob1.hgst.iphmx.com with ESMTP; 06 Aug 2021 17:12:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QGg7ufKYRkaQw4h9f8NU36z6sHcs5ng6hDW6ScwEJF9H0HozEjQrTlvQcJcM+QN0tPjlgBPflgsK9aHntIITH8TOtqt8pseOSW4iAnWo8YkCACbI9Pj21yMAW3HpY4369BiZZWpL2LqFbbe9QnynUJksafbQRqVW+yIAx0CIcDPlPVbFsjqh7IFclu0J0vJY+X4R54OpwZ8w/+67BVJnIBA5WWuTWEGb8zyYvLTVKVIJyzhYYCl0FzMU9PLEt76eXLznJ2I1yn/FZ44Y5zR5amIN9AW+hk4GQ6jp6vFp0sYWj8MSceBfr4eCw+nyF/iDFgO28tH4qVzHGMFhStKW0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fOj47r7+PCPkJTxf4592mklnTraV90kE2OTRRMoxcas=;
 b=bM2IOZca58+uuGh1TUpx83gzngB2990YWBfxG8y+BK3tbur2lojzIuxXBuRQ9ZYbiKGbb4w0523mUPh7lAJzpE/vb3CrErPBYDZUFGyIyAk+wtubryWFPN3vHLK3cTiKtp6Fj4IfH5EFqWYrAm41CgoLAIAuF8fMtZh4Mg7aTpjElvFawq1bEan1xhvrhxSi5RMbtTC7VKQyDPYoiG3RVu4nQjI695UjTk1GIkSWOg5z1VU3P4MF+IyQPb9hBzD8Nbl5XgxC9gE/CPnm896e8qIDPpMvxYXr06f89/Z574Mt9/gaYGosU8s+OTuhCPYQ7uq43SfiQGgfOQXnY9G2Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fOj47r7+PCPkJTxf4592mklnTraV90kE2OTRRMoxcas=;
 b=nOD4CGZsYHYptdjhIGOlmmiP9ImNmykZmTZQPUJwQMvgp5ZCN5GDxyCOs7H6SiA2mNmWDFvqfciMg2dRyMgqFJFlQ6lemZO2cmpgLMC3ylDMegkX8NKV5F+s7ej1BddQ+Kn+sZCwC2YT6eT+h7aX/gX00KNY5nuUhzBVjVi0PNg=
Received: from DM6PR04MB7081.namprd04.prod.outlook.com (2603:10b6:5:244::21)
 by DM5PR04MB0445.namprd04.prod.outlook.com (2603:10b6:3:9e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Fri, 6 Aug
 2021 09:12:36 +0000
Received: from DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::e521:352:1d70:31c]) by DM6PR04MB7081.namprd04.prod.outlook.com
 ([fe80::e521:352:1d70:31c%7]) with mapi id 15.20.4394.018; Fri, 6 Aug 2021
 09:12:36 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
Subject: Re: [PATCH v2 4/9] libata: cleanup ata_dev_configure()
Thread-Topic: [PATCH v2 4/9] libata: cleanup ata_dev_configure()
Thread-Index: AQHXipazgzKCJe3fBk22G/vppECdlA==
Date:   Fri, 6 Aug 2021 09:12:36 +0000
Message-ID: <DM6PR04MB708145CEBEF79D709B679090E7F39@DM6PR04MB7081.namprd04.prod.outlook.com>
References: <20210806074252.398482-1-damien.lemoal@wdc.com>
 <20210806074252.398482-5-damien.lemoal@wdc.com>
 <cbba17af-a35e-a837-a5a6-1b12d6445f0a@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 302e41f3-608c-4040-f91d-08d958ba5513
x-ms-traffictypediagnostic: DM5PR04MB0445:
x-microsoft-antispam-prvs: <DM5PR04MB044526C36A00608DE04D25CEE7F39@DM5PR04MB0445.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:69;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: omf3xNewyJWcqC0zmPRF1J+C0KKfaOj/1LADGtBVgLssve88d+hX8FgIwJm5EdsyNsUOTsCglDr1jvAtD0doepDYWL8C7u0tENaVCzocizCcxIOQAFMnSMc2e5asA30uiZq6yLJnr6+QNNqK+6yeA9rPSzLpanRLm/XBUO2Vy1thjsJsBkbEOrqQaWMDCjUByDyeUKCt/gMICRnbp2s614ucscgkZ5kwI/dNPcX/kPbX1VOy/tRC5D5wdthVHezYl017hK5fBo3lVRzT1L20w6LBXdS23zkHSMvIjI4FkT+wzZAUFZD9j+HQdOcDcX1eg1WZIZD5i33lJ+xctz1x+2wc/yiFw8bFVhn1gKI2qeDc+WaRrETMr7TqGLbdVCaeOHkcU1cc4s3azryGr0YdZc3KxmL5vqkR32MEWKQE/2SVAi2xaZKIgGmxf6gfhAQfY6YKzzNrKSv/uoI/RqTHcIfOYz5BVBPnEqFaw9lVbPNaxzggqdi2p4xL7+lZi6lSNJOI2f4aI3PguKNpPc+w5MmfcPzeWNmwWxMcOikCE/pj2ORbokM+oZ6ehz77CxgpJHzsQUv0MrfMInAmwwaeOq7OGq5R2pva5EJtp4M/4JSFCs56YQ501deyZTC97d4f2N2K2vKCYFhhaLyBvCG3NVvcHsSsfEoh/fIhkFAUF0PBsLgt4fOrmhiXQQCIU8UfL7PljrlE/jMVnTO4TWAaVA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB7081.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(366004)(39850400004)(396003)(376002)(8676002)(122000001)(66476007)(38100700002)(38070700005)(5660300002)(64756008)(66946007)(66556008)(33656002)(71200400001)(4326008)(66446008)(83380400001)(86362001)(52536014)(7696005)(316002)(54906003)(110136005)(8936002)(9686003)(55016002)(2906002)(91956017)(478600001)(76116006)(186003)(53546011)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?F2ml9kVTYLg8B07Wk1LXCL6/jvXkrB8KziUmVAjkXNv5ryihrmvG7EDEVWoz?=
 =?us-ascii?Q?ELifZE6/fltjgmyDEi2OQO2fRRlcZSHBEavAToEtFTm+SHj0LQ50bkFPUtTs?=
 =?us-ascii?Q?mShWw3Wp+bS3LYycE0hBy6pStLOLxzOMNt6DKYBX5catg3G1paMS84OMnam6?=
 =?us-ascii?Q?qIAU3/iua/s/tYogMmeMV/SyWoZBmVIgzDIDNmTuckgIDmIysfCpDXTmFNXE?=
 =?us-ascii?Q?RyAZxJ+wKJcdgXzJFgSaGNEdRF4n5qQZ15xDsAH3Dyq2hZk7xGM8jWm8k4fA?=
 =?us-ascii?Q?tz1s45iY+Y+I+Czb/cuv4JWDXdW96BldiHv3HS5lAdT8SuCgaq6IDx9LAXf6?=
 =?us-ascii?Q?D8zc/HlbQtqbTmnA8knwOQpCUAUwd5szqm0IvNWpp93qpHQeEosV9doD9VCL?=
 =?us-ascii?Q?+fU9eJUH6cQGIR3j+EGCNmEAhOxxrqkKYNNeLYhTxRqnYpdqtm42m9qfD0vZ?=
 =?us-ascii?Q?zG3LeDxb1UezSgDIcPSVaV+oKYAp5yNBQ+3li7KK2X+6HBVmjv2Bq5M/Z8XZ?=
 =?us-ascii?Q?Xs+C/LD5Q9y6Huhiec1OPAwWMKwPCFirXob79K0WBEovmiElKW5rClAFFmH+?=
 =?us-ascii?Q?DQv6YFhAXzJ5LGSxI0t5cfkgPy+PKzLQds0bBTNmEjtgekfKpuJ3QhrPaHQf?=
 =?us-ascii?Q?e9s+F5MrN2K6CbizGC8Frcx30yD97Dnhrqf4quSVFqgq1KCEEc2VwT0x6sW9?=
 =?us-ascii?Q?jNUstEXfKOwTY5tbVrS+WkTbGx9AtVo/k0qzWR+L0L3rkotnwTfCfXOSbEX2?=
 =?us-ascii?Q?tsWFklcJKswYUGct9yvEMyaFs7f+tUKmtKnPVGmhT2onZtd2MubCaNn7WprU?=
 =?us-ascii?Q?X+OLdIFbM18LwEfCfcspKhdsZKSA+BujFyBrstMsEeWuv1LyHloF2QzT9PCb?=
 =?us-ascii?Q?rp90SIwrCvPt3U1afjub4ifY6xxBioJipgeKKpM9Iy35G5TYwGyPY/HeGfFX?=
 =?us-ascii?Q?F+54sW95EeipvmXtM9IYENFSp5xZ3er9GJkQ3iSaq5Ilxv1RvV95DtC8UKfx?=
 =?us-ascii?Q?S4VAzrFMiUwP6UfRiJmNMwR4pwckLf1Sppo20FEMv7LFrh2KfBR4T7yZAPsw?=
 =?us-ascii?Q?3nwReXflPFalcl3BSRRuuKc/404G/pB0yh2MvhZnpVvHU2/NQe5tq784UUMF?=
 =?us-ascii?Q?xNuIgDh+29kxfo3MBFZttFw2lKRZgoz0EvOIkO+M7KXVIxhYP4b0rvrv0bXG?=
 =?us-ascii?Q?3GlWSEkEmKNzVC5JjLpNd3UfFtZ0ndDUZGvEjCYEJ0o3rndMnKPsdSB5/huB?=
 =?us-ascii?Q?zrJswZi12Doh+crtU3orLB55/WJ2xYWQrnNYv6oENMqvT42K6WM1l3xDpgc+?=
 =?us-ascii?Q?akV/I9I7uIGQHjQxm8X2S1jET4qJiSl8JOIvaQNyCCCYCVg27BrdTJ/ZJoT6?=
 =?us-ascii?Q?JKtQd33x2HcvNNIuEnROwY6bkWZugs5OOU0zUoEl/+JL3Wx5zA=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB7081.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 302e41f3-608c-4040-f91d-08d958ba5513
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2021 09:12:36.2148
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PwegWrDwrHcCGeaOJaMoMDCjaSpB+37BGZlfIq/USdElE3oYE6JzIFcRBFy47+JkhjBa3Qo0wl1xRsuoZqDYUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0445
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/08/06 18:07, Hannes Reinecke wrote:=0A=
> On 8/6/21 9:42 AM, Damien Le Moal wrote:=0A=
>> Introduce the helper functions ata_dev_config_lba() and=0A=
>> ata_dev_config_chs() to configure the addressing capabilities of a=0A=
>> device. Each helper takes a string as argument for the addressing=0A=
>> information printed after these helpers execution completes.=0A=
>>=0A=
>> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
>> ---=0A=
>>  drivers/ata/libata-core.c | 110 ++++++++++++++++++++------------------=
=0A=
>>  1 file changed, 59 insertions(+), 51 deletions(-)=0A=
>>=0A=
>> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c=0A=
>> index b13194432e5a..2b6054cdd8fc 100644=0A=
>> --- a/drivers/ata/libata-core.c=0A=
>> +++ b/drivers/ata/libata-core.c=0A=
>> @@ -2363,6 +2363,52 @@ static void ata_dev_config_trusted(struct ata_dev=
ice *dev)=0A=
>>  		dev->flags |=3D ATA_DFLAG_TRUSTED;=0A=
>>  }=0A=
>>  =0A=
>> +static int ata_dev_config_lba(struct ata_device *dev,=0A=
>> +			      char *info, size_t infosz)=0A=
>> +{=0A=
>> +	const u16 *id =3D dev->id;=0A=
>> +	int info_ofst;=0A=
>> +=0A=
>> +	dev->flags |=3D ATA_DFLAG_LBA;=0A=
>> +=0A=
>> +	if (ata_id_has_lba48(id)) {=0A=
>> +		dev->flags |=3D ATA_DFLAG_LBA48;=0A=
>> +		strscpy(info, "LBA48 ", infosz);=0A=
>> +=0A=
>> +		if (dev->n_sectors >=3D (1UL << 28) &&=0A=
>> +		    ata_id_has_flush_ext(id))=0A=
>> +			dev->flags |=3D ATA_DFLAG_FLUSH_EXT;=0A=
>> +	} else {=0A=
>> +		strscpy(info, "LBA ", infosz);=0A=
>> +	}=0A=
>> +	info_ofst =3D strlen(info);=0A=
>> +=0A=
>> +	/* config NCQ */=0A=
>> +	return ata_dev_config_ncq(dev, info + info_ofst,=0A=
>> +				  infosz - info_ofst);=0A=
>> +}=0A=
>> +=0A=
>> +static void ata_dev_config_chs(struct ata_device *dev,=0A=
>> +			       char *info, size_t infosz)=0A=
>> +{=0A=
>> +	const u16 *id =3D dev->id;=0A=
>> +=0A=
>> +	/* Default translation */=0A=
>> +	dev->cylinders	=3D id[1];=0A=
>> +	dev->heads	=3D id[3];=0A=
>> +	dev->sectors	=3D id[6];=0A=
>> +=0A=
>> +	if (ata_id_current_chs_valid(id)) {=0A=
>> +		/* Current CHS translation is valid. */=0A=
>> +		dev->cylinders =3D id[54];=0A=
>> +		dev->heads     =3D id[55];=0A=
>> +		dev->sectors   =3D id[56];=0A=
>> +	}=0A=
>> +=0A=
>> +	snprintf(info, infosz, "CHS %u/%u/%u",=0A=
>> +		 dev->cylinders, dev->heads, dev->sectors);=0A=
>> +}=0A=
>> +=0A=
>>  static void ata_dev_config_devslp(struct ata_device *dev)=0A=
>>  {=0A=
>>  	u8 *sata_setting =3D dev->link->ap->sector_buf;=0A=
>> @@ -2418,6 +2464,7 @@ int ata_dev_configure(struct ata_device *dev)=0A=
>>  	char revbuf[7];		/* XYZ-99\0 */=0A=
>>  	char fwrevbuf[ATA_ID_FW_REV_LEN+1];=0A=
>>  	char modelbuf[ATA_ID_PROD_LEN+1];=0A=
>> +	char lba_info[40];=0A=
>>  	int rc;=0A=
>>  =0A=
>>  	if (!ata_dev_enabled(dev) && ata_msg_info(ap)) {=0A=
>> @@ -2539,61 +2586,22 @@ int ata_dev_configure(struct ata_device *dev)=0A=
>>  		}=0A=
>>  =0A=
>>  		if (ata_id_has_lba(id)) {=0A=
>> -			const char *lba_desc;=0A=
>> -			char ncq_desc[24];=0A=
>> -=0A=
>> -			lba_desc =3D "LBA";=0A=
>> -			dev->flags |=3D ATA_DFLAG_LBA;=0A=
>> -			if (ata_id_has_lba48(id)) {=0A=
>> -				dev->flags |=3D ATA_DFLAG_LBA48;=0A=
>> -				lba_desc =3D "LBA48";=0A=
>> -=0A=
>> -				if (dev->n_sectors >=3D (1UL << 28) &&=0A=
>> -				    ata_id_has_flush_ext(id))=0A=
>> -					dev->flags |=3D ATA_DFLAG_FLUSH_EXT;=0A=
>> -			}=0A=
>> -=0A=
>> -			/* config NCQ */=0A=
>> -			rc =3D ata_dev_config_ncq(dev, ncq_desc, sizeof(ncq_desc));=0A=
>> +			rc =3D ata_dev_config_lba(dev, lba_info, sizeof(lba_info));=0A=
>>  			if (rc)=0A=
>>  				return rc;=0A=
>> -=0A=
>> -			/* print device info to dmesg */=0A=
>> -			if (ata_msg_drv(ap) && print_info) {=0A=
>> -				ata_dev_info(dev, "%s: %s, %s, max %s\n",=0A=
>> -					     revbuf, modelbuf, fwrevbuf,=0A=
>> -					     ata_mode_string(xfer_mask));=0A=
>> -				ata_dev_info(dev,=0A=
>> -					     "%llu sectors, multi %u: %s %s\n",=0A=
>> -					(unsigned long long)dev->n_sectors,=0A=
>> -					dev->multi_count, lba_desc, ncq_desc);=0A=
>> -			}=0A=
>>  		} else {=0A=
>> -			/* CHS */=0A=
>> -=0A=
>> -			/* Default translation */=0A=
>> -			dev->cylinders	=3D id[1];=0A=
>> -			dev->heads	=3D id[3];=0A=
>> -			dev->sectors	=3D id[6];=0A=
>> -=0A=
>> -			if (ata_id_current_chs_valid(id)) {=0A=
>> -				/* Current CHS translation is valid. */=0A=
>> -				dev->cylinders =3D id[54];=0A=
>> -				dev->heads     =3D id[55];=0A=
>> -				dev->sectors   =3D id[56];=0A=
>> -			}=0A=
>> +			ata_dev_config_chs(dev, lba_info, sizeof(lba_info));=0A=
>> +		}=0A=
>>  =0A=
>> -			/* print device info to dmesg */=0A=
>> -			if (ata_msg_drv(ap) && print_info) {=0A=
>> -				ata_dev_info(dev, "%s: %s, %s, max %s\n",=0A=
>> -					     revbuf,	modelbuf, fwrevbuf,=0A=
>> -					     ata_mode_string(xfer_mask));=0A=
>> -				ata_dev_info(dev,=0A=
>> -					     "%llu sectors, multi %u, CHS %u/%u/%u\n",=0A=
>> -					     (unsigned long long)dev->n_sectors,=0A=
>> -					     dev->multi_count, dev->cylinders,=0A=
>> -					     dev->heads, dev->sectors);=0A=
>> -			}=0A=
>> +		/* print device info to dmesg */=0A=
>> +		if (ata_msg_drv(ap) && print_info) {=0A=
>> +			ata_dev_info(dev, "%s: %s, %s, max %s\n",=0A=
>> +				     revbuf, modelbuf, fwrevbuf,=0A=
>> +				     ata_mode_string(xfer_mask));=0A=
>> +			ata_dev_info(dev,=0A=
>> +				     "%llu sectors, multi %u, %s\n",=0A=
>> +				     (unsigned long long)dev->n_sectors,=0A=
>> +				     dev->multi_count, lba_info);=0A=
>>  		}=0A=
>>  =0A=
>>  		ata_dev_config_devslp(dev);=0A=
>>=0A=
> Hmm. Can't say I like it.=0A=
> Can't you move the second 'ata_dev_info()' call into the respective=0A=
> functions, and kill the temporary buffer?=0A=
=0A=
That would reverse the order of the messages... And I wanted to avoid havin=
g an=0A=
"if (ata_id_has_lba(id))" again just for the print. Moving the 2 ata_dev_in=
fo()=0A=
calls into the respective functions was the other solution I tried, but the=
n the=0A=
functions require *a lot* more arguments (revbuf, modelbuf, fwrevbuf, ...) =
wich=0A=
was not super nice.=0A=
=0A=
This one is the least ugly I thought... Any other idea ?=0A=
=0A=
> =0A=
> Cheers,=0A=
> =0A=
> Hannes=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
