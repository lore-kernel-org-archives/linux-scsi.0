Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC4BEC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Nov 2021 08:46:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346139AbhKZItW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Nov 2021 03:49:22 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:28464 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1345567AbhKZIrW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Nov 2021 03:47:22 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AQ8QlkB019216;
        Fri, 26 Nov 2021 00:43:55 -0800
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3cjv2x81r4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Nov 2021 00:43:55 -0800
Received: from m0045849.ppops.net (m0045849.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 1AQ8X9Nn032394;
        Fri, 26 Nov 2021 00:43:55 -0800
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2040.outbound.protection.outlook.com [104.47.51.40])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3cjv2x81qy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Nov 2021 00:43:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Najy4rwO+uakAFDwKMvNqiA0h5AksAam9BANHz2qI6EqMIFYl4DMSDgOiC5DdEMDlnsni96uSzYrhMbo4Ej7dThVPOfUgTCGeVU+n4mXK93dn/FXrb+O8zMFeADWS9s8eFTzqQlMxMRnC8pX4cfL070NRka2sIX3it7ya1b2/Jg3PkoOyNpa4wZPNc+xdJjFkONFbOeH8PpG1DXXBBKk4RjOT7ZXaDWvEHT51EiGnKUxqkOeg93kTThUVg7TMNgbn/1lkYKFBYfk2EvJyBNOXaATbogMry6DjaIYPyww1wLv+ShHYg59WmzG9nQKaFFCBPp9nE7O9ti8ws8ZioIVTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0+BDf39t8kE1lGaZr5hMBNVWtdrmM5DitR3oDKzzs7o=;
 b=SMf/mKd6RNFZ3BQ56lpj/cT0nRaR/WV7oqfaHUK1++FmFKDwKmZJ26xCEp86WyGMPldAWOqjbB+7bcNJoNxIbymxSivbRMpmIbUovNIlK3QKKdGjG2LO2ZapDiQI1TAs+ORe3BYa0lxgbwEk7tj9mFsbsB+PRVTOvNZUXc6umkZgTCslzSolM4zc3WPuwzOXOp6VJbQm7vbjcoiZK0IPXZ0xXe25raes/rNdSpfZUeWjwBOLxP0Q+NNKUKUbFKNbixwE0LSykCmzP3xCMluhwumf+vyPp02NOsGId1kWfwN3349jZOXHtbWO6lZRQg6CmR6L+7kNyzcKRBt3mq4Y+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0+BDf39t8kE1lGaZr5hMBNVWtdrmM5DitR3oDKzzs7o=;
 b=kW6c2c0TND5JUkmp/entuNOvbQXEGniz8VCguWUidhk8L23Qk0Zj616JAltZg/G2fARRrofD5+HKLqhU/EWN4Z2dPb3yiyKQTh3tnCvei1RAovIs9M2HWUw/8Px2QfPZ273X6iSGW3pTgxKkaxtFu2k2Z6wNf7obhCfoYOUKfLA=
Received: from CO6PR18MB4419.namprd18.prod.outlook.com (2603:10b6:5:35a::11)
 by CO3PR18MB4847.namprd18.prod.outlook.com (2603:10b6:303:17a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Fri, 26 Nov
 2021 08:43:52 +0000
Received: from CO6PR18MB4419.namprd18.prod.outlook.com
 ([fe80::f960:c2cb:8ca4:e0cf]) by CO6PR18MB4419.namprd18.prod.outlook.com
 ([fe80::f960:c2cb:8ca4:e0cf%4]) with mapi id 15.20.4734.023; Fri, 26 Nov 2021
 08:43:52 +0000
From:   Manish Rangankar <mrangankar@marvell.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "open list:QLOGIC QL41xxx ISCSI DRIVER" <linux-scsi@vger.kernel.org>
Subject: RE: [EXT] [PATCH 2/2] scsi: qedi: Fix SYSFS_FLAG_FW_SEL_BOOT
 formatting
Thread-Topic: [EXT] [PATCH 2/2] scsi: qedi: Fix SYSFS_FLAG_FW_SEL_BOOT
 formatting
Thread-Index: AQHX4oSrHlzIGX32dUqCqnclH72O6qwVfPEA
Date:   Fri, 26 Nov 2021 08:43:52 +0000
Message-ID: <CO6PR18MB4419E1ADDB4D336E83C624FBD8639@CO6PR18MB4419.namprd18.prod.outlook.com>
References: <20211126051529.5380-1-f.fainelli@gmail.com>
 <20211126051529.5380-3-f.fainelli@gmail.com>
In-Reply-To: <20211126051529.5380-3-f.fainelli@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 71109b0c-17a4-4b3f-818a-08d9b0b8dfe5
x-ms-traffictypediagnostic: CO3PR18MB4847:
x-microsoft-antispam-prvs: <CO3PR18MB484720E026CA20866801DE34D8639@CO3PR18MB4847.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 91DBNXc3eKt0WzgN1uFw7QSe7EFi+U/vGy5AAkfuF7eIcFNlYbpV2arTA4jHvaE7SHPE2RmKZc8iXf9WilUICLXVdbQi3Tg225TdhseEN2X4rjKe3Il0/DAQpBH8qzZ8KEieKyFhmP4Vzpmumbs+2dBwmrZDRSvJed1PfwESaBRYtXwiyFJJ+nHYhhDiVLF5ejNITBd6buXhAckXBOXKAWSdndUcYs89pPnht+2olfK/+YmdnCzYzShPcXYu79yzjviJHVyJrpkXlKwsjZwWBj4igt/I5kgQ6MIKJALXhqzeTDKBczhio3zGqMzHcaFEfCH7wNWVkYaykI/317/+G/ti8MN17tZOAULH1MBi9MA8q9dsgdDC4An6U9/0fOikqXrPG/LJ27s7urSXtdVmjJhiNIwVXDeAnpOxFoTuj2GQlqKZrTFaYmzXibTJBVbrcDkGPCh2qSj8WEfOET2OsmePfFj1q/YWqo7F7ts2n12JJI5M5s8AnpvvtYibEoOpi4gE9pLTCchjh2xUGRltBLA9X2Q38Yq4hqyHA61YLZWKst2WwZYCpgeCUgTOOLfqH6094pNeW8Q1SYGPZgiK+ivjR8/U70nndD6XLONHClsXKhnc851c7nbVIG0aZaNY1oDyCHgmclFaeHF/BSvRqnBtl233fvWCGrQ0OPMegZ6np0O4bRnKq+Q5GiOk/AI1NhlGmTlrg/x7wIIJq+hO1A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB4419.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(122000001)(71200400001)(66446008)(6506007)(64756008)(66556008)(66476007)(86362001)(2906002)(4326008)(38070700005)(66946007)(7696005)(33656002)(83380400001)(38100700002)(76116006)(55016003)(52536014)(508600001)(53546011)(26005)(186003)(54906003)(110136005)(5660300002)(316002)(8936002)(8676002)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OyhXHd0sQHo7EhYT+sI0y0ackGsLkhHlwr42qZ+4k3BAaZH510Gx+vCuxJMh?=
 =?us-ascii?Q?26yBKFaKHzrktCbRRZGd6vFq4R2Grc4aYn8kYJURa4ZtK7TwPcYSn7yDTvKt?=
 =?us-ascii?Q?q8hQ2Jhmv5O3zMhcuP6DUu0PQI/rLkZN9hLI3jMvFQISu4ioQlRlxxh+4gnz?=
 =?us-ascii?Q?Tzu4wqJqpTwlC4mkW6audh/zlDoxiRiUcaVvadybmMhhwlD8deOj5xDPvLq+?=
 =?us-ascii?Q?LcNqP950qeaKvUjnn1qyxWf3KsfD0hkieL8lHMmzKIQh+gyQ+RGJWDcFHdAZ?=
 =?us-ascii?Q?jvhJ24ePAmGDHrHuXpu6+wRYgWsxRJ/iVz8gfwl+smhEr616203F8iZ2O9PK?=
 =?us-ascii?Q?WRtm1JLwigqttDqgE8JSGC/exMBC7A8zCKi70iMNpz4iBfax4dvsgYI0tZ8u?=
 =?us-ascii?Q?I0r0ZguOQbzGXePaplTOoulE5kuxDSRRw6EdlF8aXtmV6m+/pwe++3+f3diZ?=
 =?us-ascii?Q?zhCUNYsTU3NMQ8cn51/0TEhVzg8cR7Pi5oLvL4CP2DFoh7hAQ7IF7T/ZTPKc?=
 =?us-ascii?Q?eur7hLplW4T4U5YOPx/k79has52G+fBd/ueYOPie+2FBw6ENalENRow7bCGk?=
 =?us-ascii?Q?DfHHOzE87t5t7SNK5feP43A1pxqZI28D0r6xPUDGpjdI2XIxMxw3nud7LUMU?=
 =?us-ascii?Q?7+9PsusxkDV6el/ehPKoI4ZY/VySLZ/f2P6uBTJ2MrwUs8OZGzNNavQH4hIu?=
 =?us-ascii?Q?LQEq4nDA0Pie4Bg1QsndCdW8owpHHQiTBm0DPMwWkol40VzaZOmiX0UCx35T?=
 =?us-ascii?Q?ljKDMFxyoSPbnIOu0sYrQ9/E/u5WIGuFlpIzYdEVc2eAqSTGCst+xF304o1d?=
 =?us-ascii?Q?+/4Z143aFInmbRGjyONPfY/91J5ofi5oSeNmzLY3zHzfQPqWfgPVsFqfdTZP?=
 =?us-ascii?Q?TAM3Pahrw91Blt+/MY+1xo/ChA03TeSW56xT3opV5x4MQW+AxsOm3cEkLJl5?=
 =?us-ascii?Q?HrnGuTwkG4adoVzvQKU8aUTsNMO4WOrJib6UxXxzq4OY1iIjMd8VYYQX/+CN?=
 =?us-ascii?Q?cnogEfaGpVQyI7eIbFuM/vWwBzRebIJy1eAq/Px0ZZsK/IyLX/V9rvMhJGqu?=
 =?us-ascii?Q?LJVwDea9rA0SZdcjz0qsAjMSuyq6xBWNo9D8HlUehGSPWeK3Ig0heqszk8vs?=
 =?us-ascii?Q?9c6904vEUzCykSJyqgg2F+xOusBMg+rFWIzsKg0ADJNxYae7ro6R8RPgmmMW?=
 =?us-ascii?Q?VF1TDQRjsO5JELrs5LcaGdDr43Q92xmMesJpZYxvP0j/TdOFi8pYCVvGSN8y?=
 =?us-ascii?Q?MIr1dMJkehDYZVsGXLvy2CfJB67gxG8GkliQ8hhGp0MyBxCXyAen+0prB/SZ?=
 =?us-ascii?Q?cirAXgxxIUxloVzSmNCTHL0kh8uAwXgjvdR8VNNVowG9eFgk6meaM1L33Y2F?=
 =?us-ascii?Q?fXfv0THnswDPYy8y3qe8vthg9ix40RJmkvsBVd9spXihs+UsMvk0lMrmGlUQ?=
 =?us-ascii?Q?US2yq1vdpnsXxYBROfK9Lw9b4QSlHQJaN++9r35zs1ZUOXZ2Xmy45T4x11fa?=
 =?us-ascii?Q?4qFEoPoczn3rrAkuhiR0FB5NUysRrYs5J277iUSZ2lVH5z8drB+mcCa6vkvv?=
 =?us-ascii?Q?/1DeAQwpb3+xvYkmumQ0pJqRN1CG/23vWdqaA08ntNWcD7TQFpSUqx25a1pw?=
 =?us-ascii?Q?Og=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB4419.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71109b0c-17a4-4b3f-818a-08d9b0b8dfe5
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2021 08:43:52.4903
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AYQeE7LIzUt0sTVOq+Hm3hI6nXqNIJxVNM4xr/TQ3Q5skiry1jHoy48Tox15OxwVjJKSJ2jO/U5s/skhvoqd6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO3PR18MB4847
X-Proofpoint-GUID: _m-h2XE9IoJagUmA5B5kihLs4ZbjjXsR
X-Proofpoint-ORIG-GUID: agD8F0GtiZfEHkS8aobBQ07GL59XDfJx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-26_02,2021-11-25_02,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Florian Fainelli <f.fainelli@gmail.com>
> Sent: Friday, November 26, 2021 10:45 AM
> To: linux-kernel@vger.kernel.org
> Cc: Florian Fainelli <f.fainelli@gmail.com>; Nilesh Javali <njavali@marve=
ll.com>;
> Manish Rangankar <mrangankar@marvell.com>; GR-QLogic-Storage-Upstream
> <GR-QLogic-Storage-Upstream@marvell.com>; James E.J. Bottomley
> <jejb@linux.ibm.com>; Martin K. Petersen <martin.petersen@oracle.com>;
> open list:QLOGIC QL41xxx ISCSI DRIVER <linux-scsi@vger.kernel.org>
> Subject: [EXT] [PATCH 2/2] scsi: qedi: Fix SYSFS_FLAG_FW_SEL_BOOT formatt=
ing
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> The format used for formatting SYSFS_FLAG_FW_SEL_BOOT creates the
> following warning:
>=20
> drivers/scsi/qedi/qedi_main.c:2259:35: warning: format specifies type 'ch=
ar' but
> the argument has type 'int' [-Wformat]
>                    rc =3D snprintf(buf, 3, "%hhd\n", SYSFS_FLAG_FW_SEL_BO=
OT);
>=20
> Fix this to use %d since this is a plain integer.
>=20
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  drivers/scsi/qedi/qedi_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.=
c index
> f1c933070884..367a0337b53e 100644
> --- a/drivers/scsi/qedi/qedi_main.c
> +++ b/drivers/scsi/qedi/qedi_main.c
> @@ -2254,7 +2254,7 @@ qedi_show_boot_tgt_info(struct qedi_ctx *qedi, int
> type,
>  			     mchap_secret);
>  		break;
>  	case ISCSI_BOOT_TGT_FLAGS:
> -		rc =3D snprintf(buf, 3, "%hhd\n", SYSFS_FLAG_FW_SEL_BOOT);
> +		rc =3D snprintf(buf, 3, "%d\n", SYSFS_FLAG_FW_SEL_BOOT);
>  		break;
>  	case ISCSI_BOOT_TGT_NIC_ASSOC:
>  		rc =3D snprintf(buf, 3, "0\n");
> --
> 2.25.1

SYSFS_FLAG_FW_SEL_BOOT is always going to have value 2, that's why it is gi=
ven %hhd to limit the size to 1 byte.
Is there other way to suppress this warning, such as typecasting or any oth=
er ?

