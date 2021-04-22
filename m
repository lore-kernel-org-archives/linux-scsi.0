Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D391C433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 02:31:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 105A36142B
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 02:31:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233964AbhDVCcY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 22:32:24 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40030 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbhDVCcX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Apr 2021 22:32:23 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13M2P6BK044853;
        Thu, 22 Apr 2021 02:31:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=9ekuRftCNd1dAt4Qc1eqQnVp0vbCyKNh+MdOv5eFvG8=;
 b=UT/hruucsZekR4iZXH8SyV2XIJcboExZdrXsoQ8w/4t0t8ShuP5hDLJQTdyWLic97d5V
 pQDJXOa2HAljjQFvNsNT4f4m6mnIayJEM9TZ91Qr4NwpocYXq3eL+Vj8NpCNE/EINgGn
 P1FUm5p58OPEOb2pxKj1/440kGAh2GtlcmNF2PqLycpvoztGPq5RPN+Lo+UL/9chpJl0
 fnSEYz+DCKeJcB0lQL8P6njKP3sOBsVwbcVHrOBxYx+zeGF0yce0tduX2g/bvDbQejWX
 f3spgtyGa/ZlzBpkXoBXyCo7/uHeKUk6/1qLMWZF0xN/sE7n2158BVKhP1IX/rT2Kzjs Iw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 38022y3bx1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 02:31:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13M2UsUq058571;
        Thu, 22 Apr 2021 02:31:43 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by userp3030.oracle.com with ESMTP id 3809m1gffu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 02:31:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ed9naUMVFXMH3wFbBkP0ZZWKUtSPGgmg+Aa6vmRsuzXsYYoaljj9HaofDkidIAEMM3Yn3YlWpWHIsjCdeqiQ3o+XSnBn9GInnKEwtepVvRmtLahXJw8jxx/MhW/YC4eboP9yCciD4GYhEW/64866DAizkQ/PmYh3vTAvFOjppcKUiaAIy0+E0C72jv1rxL+H04SQJb+qjV+m4IrSKt1maDRC3aF891+qN+6oYHuU455I5vGzy7Dy1toFW4vhJjJIJi4aP6HIxgZdloV5uwCCrUq6cO9O1iwQkRk71ik478w2Val1SoGXicEL95tQGMO6cNs4pzoPp2KQu9yCveKjnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9ekuRftCNd1dAt4Qc1eqQnVp0vbCyKNh+MdOv5eFvG8=;
 b=RMisz3EOkPTxTQ8ry4fBQyTG306ahxwcnwDaY4/0udyGh0iUQ8E0u+crvEKYoj2YzJjocs8BOLHt8vdJr9MhuPvPnhMAOAJWeWMtQu/qfBcF/VyRCVHjV1IFVqVtlPAeaNXIP+o1SBXePrJIoxdQeNKCySMOG9lR+C6gka1b3nBKsqSuiXHsTXH3itk23V1Lu+O59Ck/7ombBjAEo7rucG7MaPfqIG6tU+8WuyVM3jTxXJqTmAJaC+RrG09KjEvK8+jrhw0nQW3/fH/Qo2r7w3uExCiG1NoW9lKfVHMqphRonwcwsgbElNDWZmdnGZej01zdyEBhKX6m5OqfJpap0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9ekuRftCNd1dAt4Qc1eqQnVp0vbCyKNh+MdOv5eFvG8=;
 b=IpItNIS9q48HXU8q8yv4GfznEuqr8pnriawWZaDg5MytktsEckB1nug8vORlKz1TgFqMMXtaB+se5rtLFRb+faJou32df3En8NzxnMNsKvwLP7Oh5IyPA/4jysjuQMjLWAUt4utFtKQ8pa6wZxOdIBQVTsul0b70G/FcpVFrA4g=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2720.namprd10.prod.outlook.com (2603:10b6:805:3f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Thu, 22 Apr
 2021 02:31:40 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.4042.024; Thu, 22 Apr 2021
 02:31:40 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Kashyap Desai <kashyap.desai@broadcom.com>
CC:     linux-scsi <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "steve.hagan@broadcom.com" <steve.hagan@broadcom.com>,
        "peter.rivera@broadcom.com" <peter.rivera@broadcom.com>,
        "mpi3mr-linuxdrv.pdl@broadcom.com" <mpi3mr-linuxdrv.pdl@broadcom.com>,
        "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>
Subject: Re: [PATCH v3 12/24] mpi3mr: add bios_param shost template hook
Thread-Topic: [PATCH v3 12/24] mpi3mr: add bios_param shost template hook
Thread-Index: AQHXNQuRKVQS0wruk0+zuEGbM07tlqq/1SeA
Date:   Thu, 22 Apr 2021 02:31:40 +0000
Message-ID: <D15B9EC0-50CD-4401-AE10-F86EE0C2046B@oracle.com>
References: <20210419110156.1786882-1-kashyap.desai@broadcom.com>
 <20210419110156.1786882-13-kashyap.desai@broadcom.com>
In-Reply-To: <20210419110156.1786882-13-kashyap.desai@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c7758db5-3b09-4884-4770-08d90536c2b9
x-ms-traffictypediagnostic: SN6PR10MB2720:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR10MB2720844254A709D6FDF51F4AE6469@SN6PR10MB2720.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1201;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1mhtfZNdZyvaSCHbIH5ZCd9maWWtl6aqOSpGOogGPyqtnIwHGnwvVou8OLDG2dNtX3hy6HWR32P29P1OfGj12B+ymjYEMfcOUpYIiOrtgdyv+aAySZDo7yS18TlEvKy1bmWntTRfdXlBrVLriObj8gmVIcKolFiorsyGDkbfF+pgclGYrPDgh/w1rz1z+Ft60aRSYQB7ZMqByOGZ4n5EryBW1aYnLo+jEwpVYatzTfvcN+/P4yurXZ9+mlpFh4jEygM/23c94vKruLOx5kS6oJ/4xT8EyXt/NDArmKDURhmZHUZoDuKJ29VYYxv3Q0Y7q58NZq2FZmVkj/DMwN1c+8IMmRnT6OWiVw3Bz8OHHdyRXs0T+HLb57HjdWw9FVy3EKJVyBEHVUQgYQnLoF/vg5dJ0gd1NfI4OqN2GYkkMNNt4mACCt/gpzM/oG5fmEA/4V/DlPClD+DHtRzx7TCh2zhs1SA5iJUeH0+yYv7Jw4EOhUmLP7jkwHWNsVBmfJPNS0V2XcoKtyG8pyDbCEuF2Ve4hTB7sv0HQcmBczMUG1AYZKBFwxL/xGyxtDi/qnpVspgpmuw28eNYM6jhdetvpmjs0W5S/969gaYqf0RiuBVbpAta4TzX6P8ndC+uKvZQEixst81NSpV9na+LzzjYZeLr2rLf7rz+86BfUyIPmXz3wcK3yKiDm2CjvXCcMSIE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(39860400002)(136003)(376002)(76116006)(86362001)(71200400001)(54906003)(26005)(8676002)(5660300002)(6486002)(44832011)(8936002)(2616005)(6506007)(186003)(36756003)(53546011)(6512007)(6916009)(316002)(33656002)(64756008)(66556008)(66476007)(66446008)(66946007)(122000001)(2906002)(478600001)(4326008)(83380400001)(38100700002)(32563001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?FmcGUXk6ssrGmpYpWvkoTCxv1pVAvPCgxBRihSo4rLBku3CWTyws9t+GHnnU?=
 =?us-ascii?Q?Svj9xLPoiiSQ8erJxZdjNdNDf9kZNIccZZo9wMuQNcQ+r5BpJr37Czai1nBM?=
 =?us-ascii?Q?+GHT2GbzR3tXZ0lz0sHFUcvmoP4g6CPVxy4/bb5XUuR6BZk3SF6R+IQT6Cpx?=
 =?us-ascii?Q?WovBEj30nbGJpB8AH3BEA+HhnAbVtmDuwOGu+6b/MfDA6/YOyp4jU72Jnzrg?=
 =?us-ascii?Q?Fi+ZOG7MQ622Vjh4qzwCiTBojb1zAh0C7ZPkDEP1cgARjClhVmas8P8mDu+7?=
 =?us-ascii?Q?alOfwWoXysKnXwZwvue7zyL2kstc2C2hTI8IUdu2XflYHWqAhaagHat3hyh7?=
 =?us-ascii?Q?Ye+c+ZM5TFRw2bljPWXRUfZM9l1HixDnw2oJN9BVZBFmToZmMl+gyxXPuDxy?=
 =?us-ascii?Q?54TXDT3Ne3uEL0O54/oQSs6Q3tfwD9hy8cpeAInfbtY/o+Bmc83WVSPfa8M2?=
 =?us-ascii?Q?UiqyzELl66TRJKSsWP0z8dQ4ruGjgVemQLq6bqmazWawbpiDgzk9/wFinFkN?=
 =?us-ascii?Q?eOd8enegp4G3kNPt8fkKhPy+oRq1gH+Sp774M8r4/ZmiY2/zOIUrQTP2RwvK?=
 =?us-ascii?Q?5FKwJmOBzzqibey8RqtJFZjjHQDLCqgB3+UDbWZJQmildOydMwYul15TYocX?=
 =?us-ascii?Q?3a8SW6fS1ma7Sm31CY01DNf8bPQz+13F8wkBnWhdDoOGKpQv6Zapob4B7bda?=
 =?us-ascii?Q?o7rC04U8cMKfyei9SYnNGIqus16mXoG3/lMxOS72FmpdwQdOCLm2Af4e/5To?=
 =?us-ascii?Q?PSgzIKiwetKGWEFTfr8+bMyWWXB2DTE1QJnO88ZRH515FeqEHhG/WVhjg3DK?=
 =?us-ascii?Q?61GycwEaxbagqRWDRJ8linKnox2t8uZ0EqN4xwyzxVdfmaKWBkT90VfleTxs?=
 =?us-ascii?Q?AlR5fMxyNBsuA9J4He8tmk7Vadfy+CkuqyAZDm/HtxYR0NnDnkDMxH+5BiCO?=
 =?us-ascii?Q?cTU/z8CChMdhLkUgQdA1iRgt9fJNt1HZxF7k0YORq72CXF4FOccncOwHxlQ9?=
 =?us-ascii?Q?O9fgS2LjxEyrV7DDRCYUas14RS+cSmXXCybLDwbd4ABVGyirE/kmRGLBI+dG?=
 =?us-ascii?Q?pQWoAhvJYwVrspnwt0EmfiQAIrIg5t/aReXpavbrZm7I4XAtwycdQVcnLZJf?=
 =?us-ascii?Q?UTs9mb0/xnG4GS6NbG0pJcFMjNjJm0sxbVtb8Unjjeh30Refr3hh7GgFyaF2?=
 =?us-ascii?Q?dUXtHHlUU52fSGMMpyMXC6V5ZVzFK/eyKMeTNfwqmTyGSAVQi/rtU7/qIG+z?=
 =?us-ascii?Q?VhRkI/Jk6fXQP48UCCZI4fwrN3X8QDLSI4NsXe4xD/RrtiZbGUbUSae+JagB?=
 =?us-ascii?Q?ZpOPuov9rdCRp3Czx5pSVWcFc3TS5rs2NsmGDKjmfWxLWg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <94B1E9BF1C2FBF4D8958738066D02BAE@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7758db5-3b09-4884-4770-08d90536c2b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2021 02:31:40.1378
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mZJNdpchFJySOYWUhcrmL6juwZbqSC6p7Hu72HqbmCKn9AlbXHZQiJCEpSjA/8Z/jgVdps6iwFlux9UGiqpn1Seylo+6vIOTgw34utU9L2k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2720
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9961 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 spamscore=0
 mlxscore=0 suspectscore=0 malwarescore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220021
X-Proofpoint-ORIG-GUID: xv4xGFHBTfq20zvkjzN5YrsDNKAajHJ7
X-Proofpoint-GUID: xv4xGFHBTfq20zvkjzN5YrsDNKAajHJ7
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9961 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 lowpriorityscore=0
 spamscore=0 bulkscore=0 phishscore=0 clxscore=1015 impostorscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220020
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Apr 19, 2021, at 6:01 AM, Kashyap Desai <kashyap.desai@broadcom.com> w=
rote:
>=20
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Tomas Henzl <thenzl@redhat.com>
>=20
> Cc: sathya.prakash@broadcom.com
> ---
> drivers/scsi/mpi3mr/mpi3mr_os.c | 40 +++++++++++++++++++++++++++++++++
> 1 file changed, 40 insertions(+)
>=20
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index 39928e2997ba..946a62610b55 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -2075,6 +2075,45 @@ static int mpi3mr_build_sg_scmd(struct mpi3mr_ioc =
*mrioc,
> 	return ret;
> }
>=20
> +/**
> + * mpi3mr_bios_param - BIOS param callback
> + * @sdev: SCSI device reference
> + * @bdev: Block device reference
> + * @capacity: Capacity in logical sectors
> + * @params: Parameter array
> + *
> + * Just the parameters with heads/secots/cylinders.
> + *
> + * Return: 0 always
> + */
> +static int mpi3mr_bios_param(struct scsi_device *sdev,
> +	struct block_device *bdev, sector_t capacity, int params[])
> +{
> +	int heads;
> +	int sectors;
> +	sector_t cylinders;
> +	ulong dummy;
> +
> +	heads =3D 64;
> +	sectors =3D 32;
> +
> +	dummy =3D heads * sectors;
> +	cylinders =3D capacity;
> +	sector_div(cylinders, dummy);
> +
> +	if ((ulong)capacity >=3D 0x200000) {
> +		heads =3D 255;
> +		sectors =3D 63;
> +		dummy =3D heads * sectors;
> +		cylinders =3D capacity;
> +		sector_div(cylinders, dummy);
> +	}
> +
> +	params[0] =3D heads;
> +	params[1] =3D sectors;
> +	params[2] =3D cylinders;
> +	return 0;
> +}
>=20
> /**
>  * mpi3mr_map_queues - Map queues callback handler
> @@ -2508,6 +2547,7 @@ static struct scsi_host_template mpi3mr_driver_temp=
late =3D {
> 	.slave_destroy			=3D mpi3mr_slave_destroy,
> 	.scan_finished			=3D mpi3mr_scan_finished,
> 	.scan_start			=3D mpi3mr_scan_start,
> +	.bios_param			=3D mpi3mr_bios_param,
> 	.map_queues			=3D mpi3mr_map_queues,
> 	.no_write_same			=3D 1,
> 	.can_queue			=3D 1,
> --=20
> 2.18.1
>=20

Looks Good

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

