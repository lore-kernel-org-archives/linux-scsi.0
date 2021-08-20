Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23798C4338F
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 05:16:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFEC060E93
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 05:16:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233925AbhHTFQf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Aug 2021 01:16:35 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:26728 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231524AbhHTFQe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Aug 2021 01:16:34 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17JHBB4d005960;
        Thu, 19 Aug 2021 22:15:52 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-0016f401.pphosted.com with ESMTP id 3ahftmmxjt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Aug 2021 22:15:51 -0700
Received: from m0045851.ppops.net (m0045851.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17K5C6po007465;
        Thu, 19 Aug 2021 22:15:51 -0700
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by mx0b-0016f401.pphosted.com with ESMTP id 3ahftmmxjp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Aug 2021 22:15:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RZTknKaW9VaXzb62P3smuTlYhKisjH6HFRO24Cz8hCOhiDvY1d7cotS6Q1uaJNXpc71bZoZd5uBtTiZPsI7TXKXvZGg7neYxGQEdjfLsryh9ttaOuOcZrisOBOEY81vveJwkS0CUlaZ6oUZKsq2PAxC3LmoMhhwk3WIihTYYx2tIL1ny950sVXJ31pT4TOB19WXAX87RmZxAtR0nt1KLJcpQaM/aW/k/NMYxsVaEVkRGUNNFPHspo+2X8Juy+B+ByuYxcsi4mjBJGxK3a94D+3Ot5jTYtAxLJ3QE4hRWrxELOOQRam0QyXPSjCN9Ka+Kd7sFoxThNjBtIN5AQFPVWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1pRKRAozvICgzpGFHDVEruTMSPNIsOl5aCAhRqHcRvg=;
 b=Z3dUFD0iKrSYGcBVPbgMrgEqE3avczjlu3T7N6jMBPHcvoaVsdDLSnBFXOOg7KcBegqVsNqpzpxB4i563GY65Q+UiA/bsvTZUXNQoUsUFzAqSEakTCwOFbItqzyuc0/bZX0ckBVsdmjjNysio0Mcso+QA+OPYbx7WWrlIm6gxw+8vdKvpWx+5gBGaANQ+Xes2uPKTHozPz1374GjINuHhjPVKhievKNzoOCgcB4WIYtkBLDuztDUstAvaopW0mDzwYs3pY3XosFtfupDjmAYsdqw4Ogzi+oCOUdXz3P70Uvrt4hVO7gjLAAsXBUG6ORdy2SqpeDVHBeJuyqAhXLNIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1pRKRAozvICgzpGFHDVEruTMSPNIsOl5aCAhRqHcRvg=;
 b=vCB92c5teIGUHX7bbTkd4bu6fe0/0OL43VkqBLN53++aXJE0knZs7CkgRuHCnj2fORcZWCnPnz5rJorVGxq+QyIlnKNf/6sQssdWgzqg51DwKSozFh5lv/tOeTlfcHU9Gy1ZJw3h7Luks1/W7SgqgH5EO1kKKpYhyw3BY/2Jju0=
Received: from CO6PR18MB4500.namprd18.prod.outlook.com (2603:10b6:5:356::24)
 by CO6PR18MB4452.namprd18.prod.outlook.com (2603:10b6:303:13e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 05:15:49 +0000
Received: from CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::ec6d:161f:8ac4:9ba8]) by CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::ec6d:161f:8ac4:9ba8%4]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 05:15:49 +0000
From:   Nilesh Javali <njavali@marvell.com>
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [EXT] [PATCH 1/3] qla2xxx: Do not call fc_block_scsi_eh() during
 bus reset
Thread-Topic: [EXT] [PATCH 1/3] qla2xxx: Do not call fc_block_scsi_eh() during
 bus reset
Thread-Index: AQHXlNtQy67LB2S8/06X6m7wMHUymKt6vrng
Date:   Fri, 20 Aug 2021 05:15:49 +0000
Message-ID: <CO6PR18MB4500025F81D2DFCAAADA9147AFC19@CO6PR18MB4500.namprd18.prod.outlook.com>
References: <20210819091913.94436-1-hare@suse.de>
 <20210819091913.94436-2-hare@suse.de>
In-Reply-To: <20210819091913.94436-2-hare@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=marvell.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 52897450-7b7c-42f9-9a5a-08d9639992fd
x-ms-traffictypediagnostic: CO6PR18MB4452:
x-microsoft-antispam-prvs: <CO6PR18MB44527A8338FBD048AF290E9AAFC19@CO6PR18MB4452.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 10jHnnXsX/tbfKxs7/PUO6Z3PaMZPdC9zEsBf3oeVAou2VadXyd4XAQYg4KKNZkaAWP+5PC0ptWEchb4bzKvtJ0x7Y1S07IaSny/KTnyxpbXGhKMhm8Mbb2SMRsKjZje3/4TCUhlRmUJNk6jDURuFgEV641dLv8sU4eCj3jN8x8CKVfLPfh3v9XBkV6tEfoz3eNEAw4QQGSAiwBcONQZ0/KpnNrtoSsfRL3OomvbDvTcJcVFKAYnRjNHTB9iDJhLivUMBzagbctTmXMcSLKt3MtZJOCb7KjuQWGlv6LsNbMitK5a/ztkkbzL1nj03DWplpwBhE8lgMu0rgmQ7vjqWu3ybOvj/ro4bG9n9HrogYBeGDA0JICdledv3FI02pnwfoj1O584MbDnwDgo0swIsDbEBDytijsHelM5w2UqlfWrSi+3kXc6auUsI/VA/m/Fq//TwDsiqH6Q3cr7kiHADxy/2W1FroAORbdEKvC9JWxbcSalrZ66su9HDvdhRy4tOtMxJvNcQ3rfXUUj97j7KCkV0imQH20lUMqroQql4frRpGiyMHIHKurMvh0rRTNvG72fiuZrrwdnY3WtETmYllhzObYkvYaR1Fr3fJwvgiX0PxQ2rM3NLFsAxYJlTjzRs7FPMZIhMdmAqUSm+zWr6dWNAldoxYUQtr/K6WKW7JRgBHguCFcNYPWdcflks6yjFiKRExorubkqayVTKsMP5w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB4500.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(366004)(376002)(39860400002)(396003)(76116006)(66946007)(8676002)(55016002)(83380400001)(122000001)(86362001)(110136005)(33656002)(38070700005)(38100700002)(54906003)(2906002)(71200400001)(5660300002)(316002)(26005)(4326008)(478600001)(8936002)(7696005)(186003)(53546011)(6506007)(66476007)(66446008)(9686003)(64756008)(52536014)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YsFgvzxzQzDxPlLcu/BSgsL1sQsHAlH4crwdtI7PfCspi1aezJeGuBMMkGiz?=
 =?us-ascii?Q?KHIoZrbTa4hR1XzLPb5+5oq5rJvwFRI6gfYWTtMb0Qu1Z7wUtn+C4bskYQg1?=
 =?us-ascii?Q?crvdBrjfiHQHssLHDtkBh1iWgMpWkBRyyAIB9SCLk5rglIekoT2zNrQ2usET?=
 =?us-ascii?Q?1VgOOuF4ztEYCl9KLSiMjTZK1mHy4Cw0NEwOJzQmcsYQXMO7CWCBJcSm9T0f?=
 =?us-ascii?Q?XJrjRXZwWkknYJmnhJ/11TaR655s8pmNDKns/y99mT416CS3ufAQas6eq6yg?=
 =?us-ascii?Q?msJOMqmM/tkHb5WrTdvv2iSDtxF9T1cCEcV2zG4U3tHuM2KPunDf6poe6+Tg?=
 =?us-ascii?Q?OZKo6NxMMLvS7l1KjseA/RxrviPs1k+Hd2LKv7cxa2Qd7G5uFg1od/IcUubF?=
 =?us-ascii?Q?vECQfOTKBLwonbFffbDNotpEOZVJ3LsEHwaJC7/nHEPf083ThrdueKuH/otq?=
 =?us-ascii?Q?yZz1TTPG4/vflrRnMq6MMwyg8k0FpZT/k/GF/YkUcWSFT5gMtGbKka82jBQh?=
 =?us-ascii?Q?P0/Na1SDwhFh8y7zW5CYMKr5IcbQ3SpU5PvUZRuZsxHcGY3LV6o+5RUb2xkj?=
 =?us-ascii?Q?1Ha+LGP8mVkS1uoQsWTjugnvb5LrWZGeeMH2dpPuwCGNldB9aOUxeZvif78m?=
 =?us-ascii?Q?lmbJOxU/hJXvV2SD9DQ5MCypYBLYCJcBvc6czb1X3kn1Jfbxy8gpNx8viiaT?=
 =?us-ascii?Q?px+Xyc/6a98SFOvdMpgj5w21LjtzM5vNfCZsXsEyXXrrjG1DQRf69O4tWqB3?=
 =?us-ascii?Q?RvmB67vNSk4TLoJnyTjxrdVq/r3QjoE/EcLbWDYg5jeNQvwMnj1Pxu+H/Jvr?=
 =?us-ascii?Q?h/D1ENOnN2H0zYyos8nZlcKvDIiayl4LySuI+2dTtWctSSmQFOmYiY0BhYaz?=
 =?us-ascii?Q?TaVjgjxVyoryHRFPZyfI8WOPhZy7yp9EO1L9z1l9CUjUUpNAOJqbO8bQaOnl?=
 =?us-ascii?Q?O5ZIAxBnM+W8SazbSELlxWYIRsgUzNcz77BN5kGxoQbIF8wzwyrXiDtMjb0L?=
 =?us-ascii?Q?3DfBOAYKgx98g9P1hnGY7y8e0GDYcQ9f8G0jclyFno9oD9MOM9zJrvZ4/tMa?=
 =?us-ascii?Q?bvbnuOR8Q+Sq8M9gIhx0JVBezL9inVgXsmsAivHKY3+RAs1vnUZlqeW5RwD5?=
 =?us-ascii?Q?zkPFriBOvuxS4AaR9cLG3kxajZkm4DwsCw3tGlQlQg7qu7DtUE0pkVXJ/tZf?=
 =?us-ascii?Q?0wjdEL6tDd8fue7FaWq1l1wct0XOFZWfkuZ+8NH1xOh8mFqD1ImY6FLwgqXR?=
 =?us-ascii?Q?B94+hCa2jT3d+HiHR2TpCHaGKr+FABRUhVCFCQ72HIpFhURNGeQodcjtaV+j?=
 =?us-ascii?Q?oTntCWZ17Y7VHozDYEy4lsxR?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB4500.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52897450-7b7c-42f9-9a5a-08d9639992fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2021 05:15:49.5103
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t6sYQixWfzZLhdzizJeLhgAY/CPuzck3MyRsMaRy2vSxANpSF7XcZ0q+iv4/bpQgHYvLvkZe7KQxeQrqZfhBYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR18MB4452
X-Proofpoint-GUID: Vr2iqOPZsxnuSuLIMuPCdFrOz9u_tzT-
X-Proofpoint-ORIG-GUID: iN72yOY_tYcJQwIEQ8sE_QBfBvY001SN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-20_01,2021-08-20_02,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hannes,

> -----Original Message-----
> From: Hannes Reinecke <hare@suse.de>
> Sent: Thursday, August 19, 2021 2:49 PM
> To: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Christoph Hellwig <hch@lst.de>; James Bottomley
> <james.bottomley@hansenpartnership.com>; Nilesh Javali
> <njavali@marvell.com>; linux-scsi@vger.kernel.org; Hannes Reinecke
> <hare@suse.de>
> Subject: [EXT] [PATCH 1/3] qla2xxx: Do not call fc_block_scsi_eh() during=
 bus
> reset
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> When calling bus reset the driver will be doing a full SAN resync
> anyway, so there is no need to wait for any pending RSCNs; they'll
> be re-issued during resync anyway.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Cc: Nilesh Javali <njavali@marvell.com>
> ---
>  drivers/scsi/qla2xxx/qla_os.c | 10 ----------
>  1 file changed, 10 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index 868037c7d608..54254bd3a7d7 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -1499,7 +1499,6 @@ static int
>  qla2xxx_eh_bus_reset(struct scsi_cmnd *cmd)
>  {
>  	scsi_qla_host_t *vha =3D shost_priv(cmd->device->host);
> -	fc_port_t *fcport =3D (struct fc_port *) cmd->device->hostdata;
>  	int ret =3D FAILED;
>  	unsigned int id;
>  	uint64_t lun;
> @@ -1515,15 +1514,6 @@ qla2xxx_eh_bus_reset(struct scsi_cmnd *cmd)
>  	id =3D cmd->device->id;
>  	lun =3D cmd->device->lun;
>=20
> -	if (!fcport) {
> -		return ret;
> -	}
> -
> -	ret =3D fc_block_scsi_eh(cmd);
> -	if (ret !=3D 0)
> -		return ret;
> -	ret =3D FAILED;
> -
>  	if (qla2x00_chip_is_down(vha))
>  		return ret;
>=20
> --
> 2.29.2

Thanks for the patches.
Reviewed-by: Nilesh Javali <njavali@marvell.com>

