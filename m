Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12188C4320E
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 09:30:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6EF56023E
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 09:30:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237628AbhHSJbP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 05:31:15 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:53627 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237645AbhHSJbP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 05:31:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1629365437; x=1660901437;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=EZPEkFsJmG4goE+VMBeJnJ23U3O1BYHESAMyf9rDCGo=;
  b=SaB+wmdmospF2xHCSrRoFwUfz4aOhIuqwgxjbecEnnkq7xMHf5I4zqKk
   gPLFlJO0DMFo634GoxV90TU75SVdzZtjVBgnpIialeeY9NcNu7Oz/KNQJ
   SYFyxQusmnojozW4PwqC17h8DhBxp/LnV+GQWGhy4L9tLMHicGB0QqZm0
   icrJN0j87LCnLfTEVb2xhtWCKpNd7uqp+hmgMeA5mLkVn7dR202O47/Fi
   m704BLQp2bHA9+Ak/QOH7x6qCR+4wXPPsiyFmpJNZbLsAMJCJiKEAUZQH
   oUGgQ6HCXVgsYizwXxYBVeApz4H5cH+/FwHJPgbJdaC5Dxv/Bh/m/cLxN
   g==;
X-IronPort-AV: E=Sophos;i="5.84,334,1620662400"; 
   d="scan'208";a="182547494"
Received: from mail-bn1nam07lp2043.outbound.protection.outlook.com (HELO NAM02-BN1-obe.outbound.protection.outlook.com) ([104.47.51.43])
  by ob1.hgst.iphmx.com with ESMTP; 19 Aug 2021 17:30:35 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K0ZzPXMA/tAvRAaodLqWerGza/1MI6BXwNLU1EFITTelKcNH8ALHTb/jinpE5IRebSzKLEBz/CZFPtlbalU5lAVmH/yr3DnstjUqGgFT8XmeviHgmXMymjwpVKuTDjCSAk7MPCgOZsMejblWZ2FC+aJIsCllnJtdpNWNWyGmzYe4Xa6hatJGX5K1yo2fVLnoATCCBZb8Ni89pt7kOeZB6xwS5ebdrCVV204vtmn2QSRF1UyUUs57tODsPc1zD8ff/qZCaqYAoLp5ReopmzR24NJGsb+AIqJbSKGlodYVhh+r5vFBW+eganzecTykLmCOozVWwQKmn+LMxXG2WZJJyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CUI6htDTJCriWlK2M2BNfpZEVBzHY5W40hX00yC2Twg=;
 b=CreOjNL0fm+zwVufOMCqwgRXFA4eVrAqtS4MZA8o7A+JsN63KkxmBdGIHxHAgY3ZDffTPQzJ36pYsgWgMEAPxrmGLwUoU3zC1mf/UK2Zk+oX3QSa9p/mP7muiRIw5wno7n+NZClKAB8IQ4bA65ZYawRbN38LrKfSN1r7Csay0oK5F1k5TY7kda2DzlLWYRYo5N17enieBvMUNDlf9SRUYYB5EyKqSweaeMgRlqZpOwuH9OZvvj6/OeDlpo8Ic2o15nMqT4e+KekKqALjRdQywj5rN/yaObSH6RR7517cAk+LLjO5oz2rMWzyIh4arya8x7Un9oSwFUcasv2LPqgR1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CUI6htDTJCriWlK2M2BNfpZEVBzHY5W40hX00yC2Twg=;
 b=C9MBNQxBRHbL4sbnOayiwSOH6nARlqGLYxeCTojrWbMFOlkyy6zQ3gmolB30fa7mXaMFzdjm2evGz4E9JJ26PysFfTupjJumqrzz/vyKIhJXPHxtP0keAR6qNAgMy4iKjNHNv6xTqOwnRpZNftbA5NqyGHcpn3lzkKU7dLsbfFI=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7558.namprd04.prod.outlook.com (2603:10b6:510:54::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16; Thu, 19 Aug
 2021 09:30:36 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad69:c016:10d5:a3e9]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad69:c016:10d5:a3e9%9]) with mapi id 15.20.4415.024; Thu, 19 Aug 2021
 09:30:35 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: fix scsi_mode_sense()
Thread-Topic: [PATCH] scsi: fix scsi_mode_sense()
Thread-Index: AQHXlNzd5bdnrtYLiU+fUz+vbOlmiA==
Date:   Thu, 19 Aug 2021 09:30:35 +0000
Message-ID: <YR4kuT0Rg+sQiKJK@x1-carbon>
References: <20210819073750.132601-1-damien.lemoal@wdc.com>
In-Reply-To: <20210819073750.132601-1-damien.lemoal@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4ccdcad0-3032-4f45-447d-08d962f3ffbb
x-ms-traffictypediagnostic: PH0PR04MB7558:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB7558ED4BFBA3141573C4DDC8F2C09@PH0PR04MB7558.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pmAvJbI5NrUK9QPiGGpVX+cngYvqrSVEMNf5i7wWc6tIsubhIwuby5GPSCiV8yKmpWUvjjOMFgMqDPAM8TeHbevJMQFjNwf5IhZjrH/JSkOfD59a0+ujtJuX2nGmhxxe+PfDzD9oZ89GVM/TV0N9moH+Qoc/hE3f4gh/DEBRrE63duRV62d9MxvGJCjbE4Ji87ckRkbKKtQtNapyQDA1h8pt9jQ89iCvkdxXkbL97+w87nHZWGbB7twXvtbxFJJpISxgFE0mCnViWPPnqUc0H8yxROqwZoQ861MKFtKBq/HO1FYzhh/u6XtGMdd1aJd0skLFmo0A9VDyde43GhhPP5Go1AQw+D75INRqXBzU5bQ2XEO1mU9PbShgpYtjwkWPnqGlysHuLUvCFTO5bGWrlFHEy5BAXkSPMmjd3v3XMpDJX9wqPK+/iRYFErOWcuAs2u3MNo3zSA1xeFHKKYYwUHGKpeM73SlqK6Kma9VMYLjDP/NlfcRiiCP62xtN4LAwMXxScVC8lEa/u/9tNxMTEM3hW3vPuHLlRtU6gCbs3A6vrkx/4RPz1GcPz3a22l8pTPE5LOTP5ObC5q4lzXtqjH1iA7qaMcGZzKpHxGfDRx7iUcDj/SNgfDbWFW0ZsRwVz1t0oyaMPUFHL9MGEwoLAFEWGfU4NomJH0wNyfju+HlIV4It4DG1+4NPxtOKJ6nq4OP40sjf0nZOC+9OHBqrrXiiPyZLZxrfZXrNLrzQ/u0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(346002)(39860400002)(376002)(136003)(396003)(366004)(83380400001)(54906003)(38070700005)(8936002)(186003)(26005)(6506007)(2906002)(4326008)(6486002)(66446008)(66556008)(9686003)(33716001)(6636002)(478600001)(86362001)(6862004)(66946007)(91956017)(6512007)(5660300002)(122000001)(38100700002)(316002)(76116006)(64756008)(71200400001)(66476007)(8676002)(67856001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4TvP7tuavjMJ2B324Z6HymI1AvDlE0/YNZ4Z9O1y05p3ntH/qL1Q2yt1iJeD?=
 =?us-ascii?Q?rMzxV9vtIJ7JivoZXj6B5Y36Xw3HI5qQtMzS5OOZF/ijrAxls62FwX8KTonn?=
 =?us-ascii?Q?9g/kh4TllZko44/mU7KeoNZCbM0LYtFhEqtDbcU9kBibsyIeUTP5FCAvI0FZ?=
 =?us-ascii?Q?rUmRg+UEmS+WeMQ2SSmxzM8Z29GvvA76RQ5kB2PaGcWQ+aq/KEg+fDB3rV7s?=
 =?us-ascii?Q?dR5M+/lzmkoWMty6kwkmwjH1b/n2773S6fXas0RviXP/pfV9he/gl4hEKi+c?=
 =?us-ascii?Q?rtDQgoUFFqB39QPJRTOFW3nRxwYBfDeYqdShU4EK1PyrfGzjb8l3gpVGVHRR?=
 =?us-ascii?Q?2jp03ozTppiYzARsW488VUieq46y9TG4SvWVD6fwy3O11+5kWEFYJcG/Q+pp?=
 =?us-ascii?Q?U+B+M7t6qBtSoTBD7wesoZcjSqFk4tEda4zppY3l09oDn0iRaLrziOTLscJe?=
 =?us-ascii?Q?qOCWPF0i54WnBJ6HIlql6/DFVuIp05mm+adsyNs6wPwttdawapwN4ajXru6z?=
 =?us-ascii?Q?ajNXMEh8YC3CFu8NdcxocgLXIPeFzBSHO71S2bSp1SngoPBzf+rN8bRVzWl6?=
 =?us-ascii?Q?IULodzgFxNNOMVVoctZPoqNpW679VsQ5EuLyXgQQ20sA6xGdH/o2oBDZg0EI?=
 =?us-ascii?Q?maFFHguL3mvyCJaSUf39wKanRhlLnT9PkwqFJJBIcGG+Ja/nv7QeAsIbJzO5?=
 =?us-ascii?Q?5DqI8XKf6uMNdwpk74xBXx1WaVXen8M3pv2SatjndFUg1Ly2BUgBFQ/Ra5Zo?=
 =?us-ascii?Q?1lQok8czxmVOkYC9lfbiA3MK47HZaPzZGkg2mOxiYympuJ+w7rf296b7bkVW?=
 =?us-ascii?Q?FMpF7a4mN8PrKlbfsZ2m9eVST2K6gKQM2Hoj8NKyS1KR0kcmKmffa1+dP84X?=
 =?us-ascii?Q?vStJby4nnI2/29eQCtIXPLNFryqo8wbib4P34RttH/lUboQ+jOQsHaEeRIWj?=
 =?us-ascii?Q?LKYSIiwmh4YBmlhC+UZcyg6ZtT0kq7MyM7nuV+9oJ31hxUyN3ZvlKyvku5qX?=
 =?us-ascii?Q?BK98EpJBtQRcsJ+vhLCUnzT7s/j7IuZUrN3LWsiPjyBIJLRgwkltUjt5q9yL?=
 =?us-ascii?Q?N0INgQ+PjaYJV+MA6XOHpShuzCsyt+RKgKfJ2hDEGb0W306T6sVDOu63dnu9?=
 =?us-ascii?Q?Qdn/OFcC80IsvhploWsaMG3opb9I0JqrvE7EYS65l9iBrgRnodX/OfbYTuUe?=
 =?us-ascii?Q?90GqiU/2Fhno5vigDWo7AebL7SHn+dOik7h4ipsf3m4yrURh1kWJrgUv+lk0?=
 =?us-ascii?Q?+Fhz6xPGSXmTD24fFE0MB96rb66gPM/JSpQCpFaAKRJCP1f7F4/bCmqzEoJy?=
 =?us-ascii?Q?+kC8nbQK7OV8s0YQgZOEKW5J?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6F883CFC57304A4C9F1ADA9C55288DFD@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ccdcad0-3032-4f45-447d-08d962f3ffbb
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2021 09:30:35.3826
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9CpACjZBpNtPCKyMXfZqLebFlxYAUJ1PvGly7K4pk4Q+zHubjtJUgHEy5TkXMqxI6Gy2U0q53Emzmhe+2je0UA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7558
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Aug 19, 2021 at 04:37:50PM +0900, Damien Le Moal wrote:
> The allocation length field of the MODE SENSE 10 command is 16-bits,
> occupying bytes 7 and 8 of the CDB. With this command, access to mode
> pages larger than 255 bytes is thus possible. Make sure that
> scsi_mode_sense() code reflects this by initializing the allocation
> length field using put_unaligned_be16() instead of directly setting
> only byte 8 of the CDB with the buffer length.
>=20
> While at it, also fix the folowing:
> * use get_unaligned_be16() to retrieve the mode data length and block
>   descriptor length fields of the mode sense reply header instead of
>   using an open coded calculation.
> * Fix the kdoc dbd argument explanation: the DBD bit stands for
>   Disable Block Descriptor, which is the opposite of what the dbd
>   argument description was.
>=20
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>  drivers/scsi/scsi_lib.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 7456a26aef51..92db00d81733 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -2070,7 +2070,7 @@ EXPORT_SYMBOL_GPL(scsi_mode_select);
>  /**
>   *	scsi_mode_sense - issue a mode sense, falling back from 10 to six byt=
es if necessary.
>   *	@sdev:	SCSI device to be queried
> - *	@dbd:	set if mode sense will allow block descriptors to be returned
> + *	@dbd:	set to prevent mode sense from returning block descriptors
>   *	@modepage: mode page being requested
>   *	@buffer: request buffer (may not be smaller than eight bytes)
>   *	@len:	length of request buffer.
> @@ -2112,7 +2112,7 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd, =
int modepage,
>  			len =3D 8;
> =20
>  		cmd[0] =3D MODE_SENSE_10;
> -		cmd[8] =3D len;
> +		put_unaligned_be16(len, &cmd[7]);
>  		header_length =3D 8;
>  	} else {
>  		if (len < 4)
> @@ -2166,12 +2166,11 @@ scsi_mode_sense(struct scsi_device *sdev, int dbd=
, int modepage,
>  		data->longlba =3D 0;
>  		data->block_descriptor_length =3D 0;
>  	} else if (use_10_for_ms) {
> -		data->length =3D buffer[0]*256 + buffer[1] + 2;
> +		data->length =3D get_unaligned_be16(&buffer[0]) + 2;
>  		data->medium_type =3D buffer[2];
>  		data->device_specific =3D buffer[3];
>  		data->longlba =3D buffer[4] & 0x01;
> -		data->block_descriptor_length =3D buffer[6]*256
> -			+ buffer[7];
> +		data->block_descriptor_length =3D get_unaligned_be16(&buffer[6]);
>  	} else {
>  		data->length =3D buffer[0] + 1;
>  		data->medium_type =3D buffer[1];

(Nit:
When the subject contains "fix", I think that people automatically look
for a Fixes-tag. However, AFAIK, there isn't a caller that sends in a
length > 1 byte. So a slightly better subject might have been:
"scsi: allow scsi_mode_sense() to read more than 255 bytes")

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
