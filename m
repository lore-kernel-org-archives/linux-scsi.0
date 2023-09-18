Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD373C46CA1
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Sep 2023 19:52:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbjIRTwJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Sep 2023 15:52:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbjIRTvq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Sep 2023 15:51:46 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60ED712A
        for <linux-scsi@vger.kernel.org>; Mon, 18 Sep 2023 12:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1695066699; x=1726602699;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=QclGEW6YpuLJEZiU4QCWWYv0aUKRkzWwq7RQ/iPieAk=;
  b=D5RyV/ltr8RxICzzZPKkVFNXOAYvw1yLCn3LqKJ4JlrV6seS8zeY1n74
   fiahfvNR7rRaLv9nOh/7w98bWEeMc9cpVyJopKjBOLqc37WizSNAFWyrC
   oz6jb5MPRmxVc3soAcRYgBDf277tH68Wf/H8BNZupWz1oLGuRWZ9vftHy
   nke+OoU1KXCHKSh9g1Hu5UeK4LmLslVkzyitWh1wuMfyQHGv9appE7izf
   HcwoJuTuvjjGhT+31/fXy0HlclNjoHncaej4HujferTreI6VX0rB+ywFv
   hjCvTTDT2K3iM9GFKJbIZPfa91QlVpl8vh6mgy7yvcymvxDAm5Y+vbrVz
   A==;
X-CSE-ConnectionGUID: 1Rb+F6tjSnO+xVqNFZkBIA==
X-CSE-MsgGUID: v3Wyh4r4T/+puw8ZdMTLlQ==
X-IronPort-AV: E=Sophos;i="6.02,157,1688400000"; 
   d="scan'208";a="349566887"
Received: from mail-mw2nam04lp2169.outbound.protection.outlook.com (HELO NAM04-MW2-obe.outbound.protection.outlook.com) ([104.47.73.169])
  by ob1.hgst.iphmx.com with ESMTP; 19 Sep 2023 03:51:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JcGz0t3M0IgyE37tnLeWOlnyvMQAEsLIlvfa3TorkT5ybF7JaAQS59ordZ9P7DZaZsh5LFYTK9FerFPoibbtjGE7opTrdNuD6wBDVOqZNXVub2S1z7f6YQCbaNJcBAiR8UQzUM2h9K/3JgjDKTIwTBfJuV49LzGRPCHGmx6V4AsBvyI42W8cm2R189k9ACFladqkYl17ViaF9tY2ea4YAqxTjsVyJVLPjQvP1ANIRMl7eBJNUd2dd3b5F4szDAFOSITwMYv2TT4G2VRNewAYRVzt1467sEo+v27bC8o2az8kU93SylS/lYlcvbC0rx79Q1fSO0wGGeEiRCaTPZe8eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FQWtk4BttIFWzMvbbRoa2N9DbcVaBbZTgRPXtxK2qQI=;
 b=agVeOmYSCj1LdMafQG+81DBRtRcScc/Fe2iSgwMicc/fRrVTn1G89A7q1vzTxQk5EzquaiDPKqoNwss+09e0zW1AXW9vaAZOpzs7T+ppe5xE+q0r2Kxi8jEBoS2+BKxDkO5T3bhusZFLqEpHPjUKT1UzzMR7TO8+okhYyQ/22XWDjZ+0QxTA25X4BjVpkq1vt1Jk4lY0C5rwxxNbKCstyvGVDUjqEYdKMkl2nPF9uPA0n4Wx3AzljrUGfZ57zUja3DsJeYiuOekZ/XyHRDEX4Ab/SHAyaQC1wmQFG3fD19wXvBC3KoolhQ26DZh2UQSUssItLPCMRk7Hsi30mgrfhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FQWtk4BttIFWzMvbbRoa2N9DbcVaBbZTgRPXtxK2qQI=;
 b=n+3xt0ATj6H178SehdY87nI1R8TXbwB8EBHomDx9MUowidwzxRoLFlVMlXnD/YQNbYOSb3NvGZIUVWaZ7cCJJeLlev0+U+3TaTZWRf+a4Tcx+K9xs4ylnFd35S6T8WeN+Ge7IGTvGoeTr4OhdPhYr8+1nEefDGuYT3SHCm4n3+E=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by PH0PR04MB7835.namprd04.prod.outlook.com (2603:10b6:510:e6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.16; Mon, 18 Sep
 2023 19:51:35 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::59a:f2ee:fcb1:4eca]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::59a:f2ee:fcb1:4eca%4]) with mapi id 15.20.6813.014; Mon, 18 Sep 2023
 19:51:35 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <dlemoal@kernel.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        John David Anglin <dave.anglin@bell.net>
Subject: Re: [PATCH] scsi: Do no try to probe for CDL on old drives
Thread-Topic: [PATCH] scsi: Do no try to probe for CDL on old drives
Thread-Index: AQHZ6mmHOyq07ec/ZEe4yf7C3XewtA==
Date:   Mon, 18 Sep 2023 19:51:35 +0000
Message-ID: <ZQiqRXuygIWaUux8@x1-carbon>
References: <20230915022034.678121-1-dlemoal@kernel.org>
In-Reply-To: <20230915022034.678121-1-dlemoal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|PH0PR04MB7835:EE_
x-ms-office365-filtering-correlation-id: 1eb37e5f-e5d0-4fa7-4b40-08dbb880aa53
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RCNgVRkrkidmAbodHYSGxwtsifx5uWEk8QQYWKNibadHXrR46yxUBZGBNm5gPLGyZG/o3v80YvgbL5yFbwQlkWCtbd18b+IArhAy6NRuj4CcFdFl1r0sJhxgaJU5/BMSGfRIv2Cc6UrIlNa9SJuNMFIWFdgaV8axc/S2BCQ7HHPWS11u4FKmNmDk2UVJM7ANDAMcDM4LLW4bFGgwjPysxw4C2IDl8s5tM8vRDLoufZTIGqclfwhFmIG/ENaa7j4COD9cGGdUa6LppQHSLKXj9s0ZTc6AuJ9Pwt7tngy3gHeVLFLPTK9szS1DA2atYKP9zAED5XGRKnbFEQtw3wSf0+7E2KuscgpDyN4vYcJOahurnIh3dXsbxveuwhE+/GoxS1FVZ7DTTNuGLcLOLD9yEOy+neFyxdO7K6cs5a2k/dPdW/l9rFy9CB1o5tArX/zmAe14shM7iBFAGo91bAxiP69UVZoMQ7eEVeS54Vces0zSp5lmTK1hHRrZRnzgVJ/6XJDrhroe+ai0KzgHjFxpbawXbYnKxRR0BMKBsEWYUzbbUrhDlXTwe9sS0actUKyZowwpTO2MbBNNeQyPAMTo3ceaHCauoPp2Ik7W8XrsGVmH/trihh22V519obrH8Ws5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(39860400002)(346002)(366004)(396003)(376002)(136003)(451199024)(1800799009)(186009)(6512007)(9686003)(4326008)(6486002)(6506007)(26005)(8676002)(8936002)(83380400001)(33716001)(38100700002)(82960400001)(2906002)(122000001)(38070700005)(41300700001)(86362001)(66476007)(64756008)(66446008)(66556008)(66946007)(76116006)(6916009)(54906003)(316002)(91956017)(71200400001)(5660300002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HGsjrjZ4e2/48y9nI94j/31bS2XNvqMXHMsOf7VZ264tSeO4OvFooTU9/9yr?=
 =?us-ascii?Q?uvJwt386aa1gWZYSiGm5IHfAc+U9ghg81mn+B3mlOA88cX83BLXev/FtMjAE?=
 =?us-ascii?Q?9hWBZbZpXW6Kx/KQVZrEYujiZ046IcudiGCI3F4nNRAOHbphu0xEGHH98bEL?=
 =?us-ascii?Q?ttm0bZPQ5Xx6PisnIawLbwAPr0qkonV5icktjFCag9QqxTdRZnc8u68pq9ui?=
 =?us-ascii?Q?rXl+PW/4gz+0Rz9c88H1soaekPhxY8NJQaAC7BPSe1Ze2rykHHE/ARleiRjj?=
 =?us-ascii?Q?uZxD13SIgmUh7oPbW9jUcW8Bku10XM+Pdr670R3e2JytqkenEShW8Hc9Xzfy?=
 =?us-ascii?Q?K26DCy2qfQDBZZYKT3oxrIj4oRr8kPxJ7dcTIldHcyhHIXUo7/w/sqCSg6/v?=
 =?us-ascii?Q?Cte4+NU2exV5mH/0fctIoDagLqF3KxQ/1YjhBJ57pNtkGfK8V9JtRXZMK4yM?=
 =?us-ascii?Q?d5MH8NlsKxzaGh9t+x7ZhPQRX85crSgRzlYsZEqrdYWJmaUjQURoLcDjPQUU?=
 =?us-ascii?Q?FaZBhVjGxrzFRo/2TEZ6ZPFNVL5IEPDXNBb9FPIOGo8h/TO7efe7Z7aKp3gP?=
 =?us-ascii?Q?cTIIjx0HH1ifxPrYtfcnUWKHA6BemhH0MyXx1NVyW/K214pqbnmDNQjYC1Gk?=
 =?us-ascii?Q?TmxcBOtwp1I4xyUABVp2DQZocJHmcsvWQbDpWwMwEiOBLaCLUW8bZ9Ia0VFo?=
 =?us-ascii?Q?N3MpdeFJ9+Qw6XkgtGfVQOc0UuY/fifLVVreg1HBHLqtyCtUD7oEo/qOHnvg?=
 =?us-ascii?Q?oUp20vxcGmXPBU5rszcYBthxYtB030kGkZlLQDN6k+JT/feNEr3Rg4HyPlm/?=
 =?us-ascii?Q?xol8mHFHLDebV+bFUhddVI+beq8gbJl1sa36Ah5Zo2JtQ4WZZAgW0/UbwRZN?=
 =?us-ascii?Q?55KpVvcc/N+k4nvQ3xta6ep/j0ZYTY9yGI/2bK13STxmnA1eulxDZIIVCHPm?=
 =?us-ascii?Q?niWk7D3cAJc/YxpjwMFXgkHssP5v5btreCYRG/daXqReiahM+IgfmcJLSRVC?=
 =?us-ascii?Q?2/GgXPvTyc/zrWocO1v3QTkDkb987s6O/u9ZH4YNthc7gGxafi8VimZuj9PN?=
 =?us-ascii?Q?kYGhbF8AFUZP2RcdH/uk6bZrYWw1JfjVKxcNR1K+a7vtNywsprWGXwsc0cfa?=
 =?us-ascii?Q?q/wkkhPGwyZU2edTiS+FRMmYM6Q/aFxHl/gTR4t7p2a4bS9ZzV5GXPHXfxpW?=
 =?us-ascii?Q?Q9kY8IBTi6S9fUbctTLtNXQDE54pC+2L/wKZeV++VpzUpWIr8Jr/Tn33p/Nw?=
 =?us-ascii?Q?1LarfDc6o3bW1CRxU+BRLy0aLZV1lS1n4/ZJh+fPT4A1qveEALU+qARfi1KS?=
 =?us-ascii?Q?8QPGnLTAnBH0ol6FiSk8wLsF+3JHVpvJFSf9icLGqxO1sPrdSeKNvL8Ydjt7?=
 =?us-ascii?Q?772vTXSQ9LrC5upaBi63QSM1aFR0w5oULgNYqKfNzY3L9/Q1dRssdTRI7JJ8?=
 =?us-ascii?Q?ixtn1FWunHiF+rrQqTOMjtFfC5ZHufUzgAPMtllejXgMvImBmgjTRWvdyvb/?=
 =?us-ascii?Q?rT4/3aLGdfk6uar8JBzjsbFUop7o3fS1ncIdRN1FQbpIf3fYefwoQaBoMRSd?=
 =?us-ascii?Q?lcuNzxoPlcnheeo5bnSN8NTNmvdxmKRYQwKhU24UZdIHPD/7yTYBpTPW8+AJ?=
 =?us-ascii?Q?LA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8DBF4FB3EF4BDB488CCDAF15BD805C0B@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: sD/nzsYxQmuLHnBQEL1GYQGGPjUK+cQ8AY2g0F9iPrFv9T+cfbWBKwWA9NSneKKu3bbH/VPGrj8G9OsO0S+N5bvyRStaeLhSx+twId5OibPRMJ+8zCi68iV3wM1kfhxMXZnV6pThc5DMlq5vrMgHg3KWcuHWPUTbDYlkQ7SQ8upW7M3rUZxGhb1i1tALvM/tCvYJIjaW9Godm5Kwdu+XnWMrCT8GVc+ynPhJdr8LyoDEndbqjqbsZoUktZnP4h6WeH334hn0OsrZxOWtsz7LJ8euPq4Yyv5SAAAiffN1EVjBY9flbq35bq60oxCp8PsdiRqm+YlKX5SST4X92YZUwY7CdOmK5+tvp+Puskm/MZZzgToM4WU+34mpf29ovNtu3COLupFq5kwwpKiCK3spxu525FIG8EdNfXF0PdnzieUZX2E9IzidHD9YN2WXo3qS+fv36Fyg8ssZAPsAeVITk3mizq8uefcUivchVg2RX/rzEUAadDfMaroIHgZkeCbL28eN0Bv8Rf3Vv6IZ5RqPWN3ByFEcUIzDTeZvF7JBGSX47sLyMKR76OcNkJVynEuExQ7tIlFH4UztgnrrS34stJztPHOf20e+ldR/8zixKT1u3LlUw72SLC6cqdNCLzyRg8hwXEN9PkJZ7EJttDsbkfxqFHn1/xVy3HtOqNr/6hyU+b53EL3EXqhIbMOywYIhZ/zveWBhQ0UfRy778WFH4TpY3szfa8DeURZ+rx589fEcaE1ADFyosy6rGJ6wNbCenomdswRacbW+x4EtiFV0poQ4yQrvB3t9ZHhjQqfgzsEwjHYO1nJUTivsHxG4jDWQdr+UOFXjaEQYGeykCJfr/lVWc49JW5OXUtxxFhH1u7Q=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1eb37e5f-e5d0-4fa7-4b40-08dbb880aa53
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2023 19:51:35.5485
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PHiXCE8mGIMVMTGFTq0VD8VKH6CfYHz1wOrA3Od1cTRphiCgS66BMgW5oOmo8q2O3u8PsgV3SqKAxfpB0vWmzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7835
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Sep 15, 2023 at 11:20:34AM +0900, Damien Le Moal wrote:
> Some old drives (e.g. an Ultra320 SCSI disk as reported by John) do not
> seem to execute MAINTENANCE_IN / MI_REPORT_SUPPORTED_OPERATION_CODES
> commands correctly and hang when a non-zero service action is specified
> (one command format with service action case in scsi_report_opcode()).
>=20
> Currently, CDL probing with scsi_cdl_check_cmd() is the only caller
> using a non zero service action for scsi_report_opcode(). To avoid
> issues with these old drives, do not attempt CDL probe if the device
> reports support for an SPC version lower than 5 (CDL was introduced in
> SPC-5). To keep things working with ATA devices which probe for the CDL
> T2A and T2B pages introduced with SPC-6, modify ata_scsiop_inq_std() to
> claim SPC-6 version compatibility for ATA drives supporting CDL.
>=20
> SPC-6 standard version number is defined as Dh (=3D 13) in SPC-6 r09. Fix
> scsi_probe_lun() to correctly capture this value by changing the bit
> mask for the second byte of the INQUIRY response from 0x7 to 0xf.
> include/scsi/scsi.h is modified to add the definition SCSI_SPC_6 with
> the value 14 (Dh + 1). The missing definitions for the SCSI_SPC_4 and
> SCSI_SPC_5 versions are also added.
>=20
> Reported-by: John David Anglin <dave.anglin@bell.net>
> Fixes: 624885209f31 ("scsi: core: Detect support for command duration lim=
its")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>  drivers/ata/libata-scsi.c |  3 +++
>  drivers/scsi/scsi.c       | 11 +++++++++++
>  drivers/scsi/scsi_scan.c  |  2 +-
>  include/scsi/scsi.h       |  3 +++
>  4 files changed, 18 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 92ae4b4f30ac..7aa70af1fc07 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -1828,6 +1828,9 @@ static unsigned int ata_scsiop_inq_std(struct ata_s=
csi_args *args, u8 *rbuf)
>  		hdr[2] =3D 0x7; /* claim SPC-5 version compatibility */
>  	}
> =20
> +	if (args->dev->flags & ATA_DFLAG_CDL)
> +		hdr[2] =3D 0xd; /* claim SPC-6 version compatibility */
> +
>  	memcpy(rbuf, hdr, sizeof(hdr));
>  	memcpy(&rbuf[8], "ATA     ", 8);
>  	ata_id_string(args->id, &rbuf[16], ATA_ID_PROD, 16);
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index d0911bc28663..89367c4bf0ef 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -613,6 +613,17 @@ void scsi_cdl_check(struct scsi_device *sdev)
>  	bool cdl_supported;
>  	unsigned char *buf;
> =20
> +	/*
> +	 * Support for CDL was defined in SPC-5. Ignore devices reporting an
> +	 * lower SPC version. This also avoids problems with old drives choking
> +	 * on MAINTENANCE_IN / MI_REPORT_SUPPORTED_OPERATION_CODES with a
> +	 * service action specified, as done in scsi_cdl_check_cmd().
> +	 */
> +	if (sdev->scsi_level < SCSI_SPC_5) {
> +		sdev->cdl_supported =3D 0;
> +		return;
> +	}
> +
>  	buf =3D kmalloc(SCSI_CDL_CHECK_BUF_LEN, GFP_KERNEL);
>  	if (!buf) {
>  		sdev->cdl_supported =3D 0;
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 6650f63afec9..37dd6bbcffd3 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -822,7 +822,7 @@ static int scsi_probe_lun(struct scsi_device *sdev, u=
nsigned char *inq_result,
>  	 * device is attached at LUN 0 (SCSI_SCAN_TARGET_PRESENT) so
>  	 * non-zero LUNs can be scanned.
>  	 */
> -	sdev->scsi_level =3D inq_result[2] & 0x07;
> +	sdev->scsi_level =3D inq_result[2] & 0x0f;
>  	if (sdev->scsi_level >=3D 2 ||
>  	    (sdev->scsi_level =3D=3D 1 && (inq_result[3] & 0x0f) =3D=3D 1))
>  		sdev->scsi_level++;
> diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
> index ec093594ba53..4498f845b112 100644
> --- a/include/scsi/scsi.h
> +++ b/include/scsi/scsi.h
> @@ -157,6 +157,9 @@ enum scsi_disposition {
>  #define SCSI_3          4        /* SPC */
>  #define SCSI_SPC_2      5
>  #define SCSI_SPC_3      6
> +#define SCSI_SPC_4	7
> +#define SCSI_SPC_5	8
> +#define SCSI_SPC_6	14
> =20
>  /*
>   * INQ PERIPHERAL QUALIFIERS
> --=20
> 2.41.0
>=20

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=
