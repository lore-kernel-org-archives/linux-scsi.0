Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55907C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Nov 2022 09:29:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbiKIJ3L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Nov 2022 04:29:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbiKIJ3H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2022 04:29:07 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFBBE2125C
        for <linux-scsi@vger.kernel.org>; Wed,  9 Nov 2022 01:29:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1667986146; x=1699522146;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=YPu8jGRpLuNG1ulITjlsnpHdLUqeY7wNdh73qwooei0=;
  b=rqKNUUcLZXvEKkdb/N6pW9hJwJJi9mC7VGRJVaLYOcpKn6MQ0csnfRKm
   6ntJUpkDxEh3X5ZVHPsWwVvSzTB71GMDJIuh67IyoRlEpbnl9JY0b26tg
   8FnJ56zwinRyNGNrLrXNwRKjvrUKYn1HI2oj8qyB+3+UXY6VBdsKiQIe1
   AnNpuTt002FWJCm7YLBg3rHXNqab434n50AE2eGna2L/T929+P0FGZi9f
   chseBM175UZaESqPKWMz8t8osTlj2HM1IRfaLwW7MyRxrhSE2/GdeC0bS
   eezf5Dyf+Fl6kVDDOOlA6sQyCc8mGKqtzffZN2/qSyJwrV0M2LjNK4LAZ
   g==;
X-IronPort-AV: E=Sophos;i="5.96,150,1665417600"; 
   d="scan'208";a="216181934"
Received: from mail-dm6nam12lp2172.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.172])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2022 17:29:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OjFv6N0yYNu7eMEMDEBlH/u83AZ8rKKBYqtY+oWEWmSoTMZntlPxuzagFqCtp83c/QByNuhWYC+i3vmh/Fd1MhbauYGVA2cQyc6P5XERzJfAHRmA4hif0nU03Ouc3MdlMEuj0LnBa6TbtSCUMQTZwPw8981IgFpMUBKMi4lvulo/iR/PLz9g1LQOW9xCkoH3u3egIRSjL3PBmYUn6ho2FVpKlvcahZTuZ8Es9fIX9qp1FowlGP7c6jA9pbFCtdwvfWsqnULozk7zJzP8kvAJqi/1p6zRpLdoSFUr3xByJjKfniQvpE4b2CjQSNdJyVWemnBiC2PoKB/Z37RXbOu/MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4McRW1pS1ssLOYdtCjIgHM4MY1AQ6bJKD/aVH8mCXOM=;
 b=aERowKgUl5cUt83PUZ02HZP/9bBj/dGlGeis3myXTOHt/aQT3dQKWr9Iow80oeXwUMhzY1sDU6lX9c5GWujqQeuIfbWcWCAL70Jx1w01OOTyYY01JmVhEKByhEDKBp7t+17BM1M83EdnzYjyidjoBc4hml+PWOPu3QHSXcbrwQEnhNt2nsPESZ0Y8L/ePOBQDzg0025wsYsQl+G8WiTddUEz6ZVaba1vSKIKvM2jpZw4oudy55PGDHCkbsuBMjjmW5QhGCCyReI4HWKNQ6F2WfaPXZ8A/Lb3tZEytjX/pVX8yGY9eVs2PEOfxrwrMqm/aukRfWwQLUx5YDewGt1gVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4McRW1pS1ssLOYdtCjIgHM4MY1AQ6bJKD/aVH8mCXOM=;
 b=V1e59JltFvLojFAMVCbpdSjp+tsdYqB0Dzm/3oznA2ADI2VbrPxbK0aYCer1XteJE2JO09TQzpLZnM1b9Z3eC1LNfcra7FRq9G8muCF/YZp8UyBGYyoqt8Obl1g4dI+JuCSl8L3646awZMmI2lNiKY1AiKlbjW+mIhlTUH8v6RU=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by SJ0PR04MB7840.namprd04.prod.outlook.com (2603:10b6:a03:3ae::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Wed, 9 Nov
 2022 09:29:01 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::cb5e:7ea3:2482:80f8]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::cb5e:7ea3:2482:80f8%7]) with mapi id 15.20.5791.022; Wed, 9 Nov 2022
 09:29:01 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Hannes Reinecke <hare@suse.de>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        John Garry <john.garry@oracle.com>
Subject: Re: [PATCH] scsi_error: do not queue pointless abort workqueue
 functions
Thread-Topic: [PATCH] scsi_error: do not queue pointless abort workqueue
 functions
Thread-Index: AQHY9A+Zccbne0hZpE2K54tDabFWG642U0YA
Date:   Wed, 9 Nov 2022 09:29:01 +0000
Message-ID: <Y2ty3IYfKH8AY7av@x1-carbon>
References: <20221109074754.24075-1-hare@suse.de>
In-Reply-To: <20221109074754.24075-1-hare@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|SJ0PR04MB7840:EE_
x-ms-office365-filtering-correlation-id: c569fbb2-5d31-4481-28ae-08dac234d652
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vFVZ/h8vMQfJzCTyh0NYzL9XlL9BSGHU6pvLtHmKYf2ONDb1mE0r2JehklVACa9PGhyGXn+6eY3ak2odiwZjHYi50ZybDLjWzCFan2TDP9TPIlCS1InxM+oXbwgCRqrQGxwAMf6yerM/HPUWGplCvwcM1yuAUCszjIYiQjtmBSnSflT+khGKS3StJHbKs+MkuuUpibTu2+Cw4QfHYaS8jpmPsF7OHehNdHeYIrAkO5FiKwjK9NSjwfht88wuw3jbPYaw11O9gv22oZZEX5lTa6+UAhV25GVhDtPJpscgaaTyK4TskjRNkSkJScMRtpu2/eAQYDOTWh2C7vHpirxvOaT4Cl9aF1wSAQA0kfM6zyyJNpuqmzthQzb2mtj0olwrhRQH34iolR6AJy9XNEekpHhUZtjcJvVVMNJN6mh37ZrN3tWvnAuF84r0PIDXkaeh8HX6/9v4w9x8ZBse6eJnPLp7mFt9FaLugnzEg6aiqJsM7yLkVZB0GzFULf0GydtfmGidO/sLbA1x0wCQTE2+kHB5Cq54WcPVD9kMsQ+B9YRBtwnWkiq/pMRQ8zXqH+mnb9h4AMlxfw7vEIlVGiCoLOYL5k3H6hbl7yPyjsxqG4pA1koz/NfSzIxEDiTjCDZZ4En8bezoxRDU6leOb7v1+DUGFYjT3LaFii1+/70H1TOfB/g3zE8qysOt7ajaMnqYR4PP0X8kqioJCejcuhHaDQJnyyaQ1scwK+MuKGODmX9ZiUI4PGePjPEWCyBMALPVSeFJe2jPpqyK8M9tA7veWA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(376002)(346002)(396003)(39860400002)(136003)(366004)(451199015)(76116006)(91956017)(316002)(66476007)(64756008)(66446008)(66556008)(6486002)(66946007)(38070700005)(478600001)(8936002)(71200400001)(4326008)(5660300002)(54906003)(6916009)(41300700001)(2906002)(83380400001)(8676002)(6506007)(122000001)(86362001)(9686003)(26005)(82960400001)(6512007)(186003)(38100700002)(33716001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?TPddSA56mlBbjm3t8P2s+bYT8AyGjUjbXD62CCGDDFH+ydhEGt79fdywzsHU?=
 =?us-ascii?Q?i4cwFOakOuwYXWIVk34OmVNupiK5DfCGl/DWJm+KKgyPs/jFYY6ijLOL2GPl?=
 =?us-ascii?Q?v2SaJi0dnlPLEBr6/ahQPKpQIgPNL1gXmWK8WwL4oJFT8a4ofmKyzqA+vkYj?=
 =?us-ascii?Q?z6jr2V0XhTEzpgTVUTbsqrCTE1h7V+Uijlihq7ULIm/eo+n0vGHoVY6lPbxT?=
 =?us-ascii?Q?jnD5R9U9LdUDDbPIA1dr2WNh2rBexe4vSSFXTRb3O+5cWUupadh8a3sTXKeh?=
 =?us-ascii?Q?ThfaJQCruQhzLJaBtBB+fDbgjCnuoS3ZuAMd0mOxSSoFGLTXZT9MUbK4e3Sn?=
 =?us-ascii?Q?UH8lD47i/DVq+8s2otTHcdtvD+IcEAAhLPGbc6kLNd2FioT5w/LOm+VIn87m?=
 =?us-ascii?Q?QTRWpXFWgohyAiCncLOqXjuKcdwwCuBkEoSVrLuX/AxQwkmWV/Iqb8Smo6Oa?=
 =?us-ascii?Q?eDJSZ6eImKyXCiNwo1txKlZJEZNxYTBWqEm46elqwbiSTP7ulF8wYXF70Zp4?=
 =?us-ascii?Q?zZNY6sSp0QZvj3gjRNoMl0RZuUH5D9bEoPDdfAxZuSdT1z1ex0zE6m9vkRyW?=
 =?us-ascii?Q?yl9g+Fo7EXc0CZvd/265y94zx6R+g3e1dMozn/YWoNAhxnkL1PKFJ+1ju0yg?=
 =?us-ascii?Q?COshmgkiSAV5hYdVbsCMHuNKj3sSYefPWd3l0xm6KC4bSKVl0NDPEwMZqCka?=
 =?us-ascii?Q?3tEJNTKtVgGafvN+1WwldFgfxBuCOJGiJNsW0vTWfwZq6OIcZAqrf8nOsMEI?=
 =?us-ascii?Q?O2l7qd+j455ZSHnwgKktwdP7YUSV178nUzgor324vGV1Vbl/s7yQrD/qEPtt?=
 =?us-ascii?Q?MoicI1UizV7x+0oMPTPqsOIoLEJfbTx0uvknz1+MDk4QpBFncoc81V3ajn7w?=
 =?us-ascii?Q?NrqKSNRdjiyVpf19JnAi/8X39OMUZSrW4VU0YaV+2Tjilk8SwoArFL164cZ9?=
 =?us-ascii?Q?x7ed0B3qsuz2CaWn27WF8KNrv3VHaDA8HURTG04sVFZZrZb2PHJa4gfqyL40?=
 =?us-ascii?Q?r87E8sQqlKwk1LTM8/WWO9IJ/gSiUfjsgnzStgbx/GJDsiF47oOw/d5c9HJq?=
 =?us-ascii?Q?bpIdfPeO5EY2hcNc1Q69ycKkhQEdiGvIdv47QUcQxVC7S7ayyfP02VrVO3Yv?=
 =?us-ascii?Q?02j7ezxqZugG3gIO4GUmXvnt8f36ndEMLm5smyHHvI/UB4ueKgFvJ9g3o9mu?=
 =?us-ascii?Q?tLOsmsTpuLb2G/0vF14WXqTYUCN/L/EqadqfQS8VH1Bqj4Sr60ZHVlL4sU4V?=
 =?us-ascii?Q?N7OEDmqf76UbDhXm8TH81ktStEQLCOgCEQUGYB2NruiXs5IgR/7QXxPziGIz?=
 =?us-ascii?Q?7yBwGbIWdNWAwSVBcvRK2aMJXDO3wPC5VApMF3+x5ABgqfGxqv4idH8C128N?=
 =?us-ascii?Q?5qebB3+w1voxR7gaa3nr1XxhK0gJ+CMozs/mFfbruDVpGCt6fRrY5znhicVO?=
 =?us-ascii?Q?hNZ9zsA+iFQtCrbIfxb5d0ztH0mnO0UgB6H+I31TfeumhYfqZRKqNljb3lz0?=
 =?us-ascii?Q?O0Q1lCp/DlmR4AkEr8oXjFgnkHporGKzCKNEQA/DX96i9rilonDFe15rX6BM?=
 =?us-ascii?Q?z7a6+9JO6GOK/XyCvaPBxW1ZnwOWxCorA/37rkjvONBxFUpxXrwIIEOqqaeD?=
 =?us-ascii?Q?OA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DDED97C3B442D849BF4D7E5C53BC0CDC@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c569fbb2-5d31-4481-28ae-08dac234d652
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2022 09:29:01.5674
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6LR6XlNmTZQ8UPWnWsn2CdpY6r/TlVKcjAe2Ex0yHX54awAFcIMi25iV1b0KoYRFdX0KYZYqNdcWoESDpi7Vqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7840
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 09, 2022 at 08:47:54AM +0100, Hannes Reinecke wrote:
> If a host template doesn't implement the .eh_abort_handler()
> there is no point in queueing the abort workqueue function;
> all it does is invoking SCSI EH anyway.
> So return 'FAILED' from scsi_abort_command() if the .eh_abort_handler()
> is not implemented and save us from having to wait for the
> abort workqueue function to complete.
>=20
> Cc: Niklas Cassel <Niklas.Cassel@wdc.com>
> Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Cc: John Garry <john.garry@oracle.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/scsi_error.c | 5 +++++
>  1 file changed, 5 insertions(+)
>=20
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index be2a70c5ac6d..e9f9c8f52c59 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -242,6 +242,11 @@ scsi_abort_command(struct scsi_cmnd *scmd)
>  		return FAILED;
>  	}
> =20
> +	if (!shost->hostt->eh_abort_handler) {
> +		/* No abort handler, fail command directly */
> +		return FAILED;
> +	}
> +
>  	spin_lock_irqsave(shost->host_lock, flags);
>  	if (shost->eh_deadline !=3D -1 && !shost->last_reset)
>  		shost->last_reset =3D jiffies;
> --=20
> 2.35.3
>=20

Tested-by: Niklas Cassel <niklas.cassel@wdc.com>=
