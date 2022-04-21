Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06F42C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Apr 2022 20:10:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350012AbiDUUNG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Apr 2022 16:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232968AbiDUUND (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Apr 2022 16:13:03 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B88D4DF4C
        for <linux-scsi@vger.kernel.org>; Thu, 21 Apr 2022 13:10:12 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23LHNPLJ024809;
        Thu, 21 Apr 2022 20:10:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=QBjT/X+g/UujHxXuU6bTDS2NiegKJQtrn2jSsaRi7Oc=;
 b=GnXLePz8rUMMTm9FIwiPPg+GCcpSnhDso3QAADX7RsQz+03pd4EB374ZoAGo6MJ56Bem
 vJlYRYJDgD8pQisg2kwZr4y9RODYKSEo0rfpFBpY5zFYdiyEofiqjKNQfeebkZOVd3hx
 k2GeBzkZW+IaTSf9fcB4tBknMgBDmD1U98uPz2dVudkBfijzd22LkRI5xX8V3lOI0qV2
 7VinF/j1gBw/xfVCqpYqjK/ioJg+KgqPkeL5vkEBADx4UrrYjkcjg5hbcCInwCotze5S
 DSaOeV1P/EK3aw520V6gENkDcdrw7p5HCQ+Rt5hv1VLyTjpOGQbM7T3jq2ZuiXvrESlE 3Q== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ffnp9mr2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Apr 2022 20:10:00 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23LK2EaR023050;
        Thu, 21 Apr 2022 20:10:00 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3ffm8cqqvj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Apr 2022 20:10:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m0L/PbTuYvSKV82DV/g6Lf0raLKdGH9wQ5qj8pYt9vaykziTlw8MIUBca5gmG9hqj4W2FammpkyLOLBbphWxBAmmhzwl2Zx653AuKbmkqZwhKnejq2KmaojYs0qwzL8Nb/2Yq8Oyge29rwhdZ0ozx8+XgOeg8A2OyRw4HxLRoDHUL7plcRMRxrwObxVKDfXUNj+fyUZM+q7A2pMYp4tEyHGq+uHSNatyTWkuviCJu4A463RsueP+UyxuYdRfs6r1Gb1QaijoVRRCNVvaaek56FdXyD0yXMEW5dPHj4yzYHwmurVmJBLV6mWdMEPXHennnQB5uYLPAB7Pyev7087F7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QBjT/X+g/UujHxXuU6bTDS2NiegKJQtrn2jSsaRi7Oc=;
 b=UoOpNne0IBes0IzSOVPH6GRtHsPgKhb8FI4trOB7i59n/lejCvHMnk8pIqsjE+jrxuMhP8TKaTuZPH/7rbLFx+TlDwCdiB+EdfaugRS6FOXFj5WuDwUP3GEAQDqXwBJhziz9Q9I0JmlPc13mBWxPyTJCZ05mrmwGX3ZIRdw4FX15pgSfPabrtkeL5l3d0IgxXS/KM0gGB0bA0OR7SZtG1PEEjZZrXzPydEhpF1pxoNPHmF4VGG6Rb4FrvbF2LJ4n5jltVaBTStvFswi/aGrwjylMn9lgrWwG8cqCcN0yG6UzUucXws6inXQfBnnpu/jqc7kOocZR9IE/jPHG5yIz7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QBjT/X+g/UujHxXuU6bTDS2NiegKJQtrn2jSsaRi7Oc=;
 b=i+viRq5G5O8DFj3fRUlYO/krU0QYZzHT7x5EQuKUQ8XaItb6v0svWOh+ZSi2TVJhJSRX3oRMZTqjvQyap+v9uZdDqCJUNnU2T2bnaCKfqCZGRc/bbJpkc/3lndlt6/QS4H9RqAPq0GBmm18eUPn586nTgj65qTGRteZEL/3g1/E=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by CY4PR10MB1910.namprd10.prod.outlook.com (2603:10b6:903:123::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Thu, 21 Apr
 2022 20:09:57 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::a0bc:ec02:3bba:830c]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::a0bc:ec02:3bba:830c%7]) with mapi id 15.20.5164.026; Thu, 21 Apr 2022
 20:09:57 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Shaun Tancheff <shaun.tancheff@seagate.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v2 3/9] scsi: sd_zbc: Use logical blocks as unit when
 querying zones
Thread-Topic: [PATCH v2 3/9] scsi: sd_zbc: Use logical blocks as unit when
 querying zones
Thread-Index: AQHYVa47lUZHN8C8/06fyYRwsCRZVqz6zC6A
Date:   Thu, 21 Apr 2022 20:09:57 +0000
Message-ID: <469DD2BB-AECC-4560-9125-DF5F7BBEA008@oracle.com>
References: <20220421183023.3462291-1-bvanassche@acm.org>
 <20220421183023.3462291-4-bvanassche@acm.org>
In-Reply-To: <20220421183023.3462291-4-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e1f28d0a-8f3f-4d35-ec88-08da23d2e88d
x-ms-traffictypediagnostic: CY4PR10MB1910:EE_
x-microsoft-antispam-prvs: <CY4PR10MB1910D6FE6AFE263F04D392EEE6F49@CY4PR10MB1910.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: khTYzjrPHqJ91wFA8BE6M6c05cWEu8t9rJbPebiqI7iok5VVganeV7OfnHVPtBDeEZ2ZhbeocIvvXhhnktOZhgWX1JntTTNsLDDEPn/xM1oRR2ETX2I3cNOem27AvODZbec2dvbTCx9aEqYCIRk8/T7hIVqhvbuuNPnbRFnPlD/ph0bFe9DQBUvzt3I1KOqxUVLcIGATSArh1OJh4HyiwUPdik81FYZMHPZbKbBKJHOorWh/V5GHVet40ArlnTETExHxwTbqOAKG7gO/XS3zvm6JUQirtnJ6Ml7/JVY4XMgm9tkFJ4vnsjqZRnbaTPkU0/uOrxtNWn5+eAYAcjYCz0i2qKN3/Dgc7/KJB/tjqMG44jwtbyi9o9vrKzd2UyVTrMUpfnSMnIydSKD3Q0LzXajVRbIZ3ItY0jNqejUerYREA5xx6lZRhUuOQfFE1gQ50thEvbp+Dl2HiEAWeNc3zJ3ypEDZ02aLQJI5VImDM5q6g90BuKacKiVZPngOENPSlaMb6tnDgMN7aLqdaOXI0mQriVaTRCiaB6o32++A0LnhJ9Qv6ot7m9oSQy5aZif0SkfiX1K/Xh6WUuCygTO1vWZg1y2aEIyONEWIDThR8Yx/INTu3BEqyDDWiOYZhxukcAFzSp9M9BK9R19Jn2kWMwJNsCr5snEvBEBkBU9om+kSYjlgEjNlehpXnun0a/2602Qp9blxzSHMgozXSUbS3XJWqF0zc6KbbdxvzHD+sdSH92K4WZs+lMvUKpg7mHeV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(6506007)(4326008)(53546011)(71200400001)(2906002)(36756003)(91956017)(26005)(64756008)(38070700005)(6486002)(186003)(508600001)(2616005)(122000001)(5660300002)(8676002)(6512007)(83380400001)(66946007)(86362001)(8936002)(316002)(33656002)(44832011)(76116006)(66556008)(66446008)(66476007)(6916009)(54906003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+wUVZnPrjAJze9PhqMdeBbvgn1c1+0CHRNHw/eQw36OeRiQSmMEB0tTRg4IS?=
 =?us-ascii?Q?/j89/dEwOX3CIvmqKZzsqVSSB0kl0v4JfyWph+02aJkUh7C1cpEPtzZ2gzZ/?=
 =?us-ascii?Q?zIzB1aBgh3KHLO7MmcU9Wykl0yZjYeXk9hqYuOnXq7Vlf1puASVpj2edC2QT?=
 =?us-ascii?Q?m/EF+idYc8ON8XIbmnMBSIHvTZDhlKOLyb55PNnX3ACpLglIUCU0wL52xWLD?=
 =?us-ascii?Q?W1yadG3stbAZx1Fz1rb5Zy7J/333mK3azQxEbO+oLkqdIRQhf9htj+iUiiH5?=
 =?us-ascii?Q?khk2x12Vr7zHOSFLELPx7HpS/r1WxCWRQsamp45fqdDptCh4dt39IDwZ+LTX?=
 =?us-ascii?Q?7fC3uJfHhzaV0ZgNbN9WlPLn98rMixSHRIO3UgesorRlMx+j1gG/f2iqPeQy?=
 =?us-ascii?Q?xHCfz0q0nuaLzaFGWS9F+cLYdObQ5iVMAc+Lm5y7kPEpPDigW92+Km+iFZRT?=
 =?us-ascii?Q?EqADzoyP2VsUA/AfrEILjPbb7YosWmFp8hS4SbLCRPlw2xpBAtvynl/yqsGU?=
 =?us-ascii?Q?pFyNKwBURX7skAbeQJhpNzOJdQgA4/85a2EGfbeJVss4MFCbPFmfefXW0zHg?=
 =?us-ascii?Q?8kmP5/0Z5B/o4LeS4ttY/DB0+KhWRenShoXK5iKxoN30vRfTjz/T9sytcugV?=
 =?us-ascii?Q?8Anw1CK75YOCBUyOZS4RfIMFYP27ErUs9zM95ZqOLJPrIWpkWae6FSNyGI4C?=
 =?us-ascii?Q?Y1xyTvHTv85edAFvA891vaj8SzV1Vm2ftuNnLBVdfqe1KpvGPJNKvmKL8S7p?=
 =?us-ascii?Q?cWJWEMluLzjQYonsTqFazKS0721/Qe+xvJhSj5HM5GT1GaR361wAU1nQdV0I?=
 =?us-ascii?Q?JIjoBf+jjWqdZiVG1SUIGDJ16Gy4PGN0Zy06YMcIFelHJgGOrPL8GS9MlpHa?=
 =?us-ascii?Q?LG8bt2DFW+BpcrsJbaspu3BVYCyJTFOSuKNJy06ETzoNOimTu62T40HddWxq?=
 =?us-ascii?Q?ftvpnA+oJMG22B9kSvrPNR5Mhs7FkNo/v2sGarVd7aoFeb+HWXv14J8HtOgo?=
 =?us-ascii?Q?uktXF0QvkHpRAq9zUkaskPkzIQ2ooblg3ZNfhbYksBoD0NcdeT2UH25Hwehl?=
 =?us-ascii?Q?PaIzcaqWuKeqiehm7lV8neLxOZ6pJMnrECAA+vq3WNpUOoz4fgJSRV/ejoaN?=
 =?us-ascii?Q?nFfbxQJCprIHjj0X0ZqBmaSfYyTAvkcGMPTsVs1Fe8IYnc27slxbccJIwngo?=
 =?us-ascii?Q?5x0hrbxcwLkr5iew81TDzozgtLwLnKVy3csfQTZAYK6hwbX9/rV70pJ3mY7Y?=
 =?us-ascii?Q?AOFaAWbLGio8WdnXgP2iK7x4O/AjA5diy2GKQKqEOHAjtjh3m5YHvVZwZ9nd?=
 =?us-ascii?Q?9HwnX/huTCs03934TGhY1UQa0mCwQOjTNON4PbUWIXdeRd9d9Yu8yWUmVa2t?=
 =?us-ascii?Q?lTYvjSyCZW2Hw3AuYFJSKhdkRudeZnahHRI8fJOSxWgijnjmA4n0xkNTwWDF?=
 =?us-ascii?Q?W3S+oPM9lAfcMNzU6gvELQzK90yqKSDCoK4C0md2Cl2GojMhp4CFQFGCtPf+?=
 =?us-ascii?Q?3nDEwwGjvgX7rBlqu0YYgbKIPrvuvg9fkZcW3TTvWHT/SoeoPkz6agSzjKQ5?=
 =?us-ascii?Q?vJLNwJN549brteYcoBHa+OpYoPvKqGHB3THuAdo7bhaXXWrRzwbI3tmC6Ez9?=
 =?us-ascii?Q?aDwIsabMB91QeoYgOj0v7YAcAuYFYfEUOY7FbordDOqWx2PHpvlP8cd83Scc?=
 =?us-ascii?Q?p9AyKXm1l0VrpLrx/WyVfgrd0eLeDpVFmpnSPeQRmOFHImvI/tslko6906Ip?=
 =?us-ascii?Q?2p2J+hoolAcPKJp98OzN9CNC+6hli5Pb578gjHN/S4dapXuThPOx?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0AECC510101D604D8A124C01BBE6943E@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1f28d0a-8f3f-4d35-ec88-08da23d2e88d
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2022 20:09:57.7128
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B6dW5SW4w4LpE4LedzGqrkzSaQj2tjcAzS8+csqkAtQ67e4snl51FrxYyvvyQqa+Uk7GZrNFVOjPPGCgMlWAWjR50vgl9x6ZVzuENy71VxM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1910
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-21_04:2022-04-21,2022-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204210106
X-Proofpoint-ORIG-GUID: lk34SmqC2UiGmK_Id1yTj8VlHBN-ukqp
X-Proofpoint-GUID: lk34SmqC2UiGmK_Id1yTj8VlHBN-ukqp
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Apr 21, 2022, at 11:30 AM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> When querying zones, track the position in logical blocks instead of in
> sectors. This change slightly simplifies sd_zbc_report_zones().
>=20
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> [ bvanassche: extracted this change from a larger patch ]
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/sd_zbc.c | 11 +++++------
> 1 file changed, 5 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
> index 9ef5ad345185..e76bcbfd0d1c 100644
> --- a/drivers/scsi/sd_zbc.c
> +++ b/drivers/scsi/sd_zbc.c
> @@ -224,7 +224,7 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_=
t sector,
> 			unsigned int nr_zones, report_zones_cb cb, void *data)
> {
> 	struct scsi_disk *sdkp =3D scsi_disk(disk);
> -	sector_t capacity =3D logical_to_sectors(sdkp->device, sdkp->capacity);
> +	sector_t lba =3D sectors_to_logical(sdkp->device, sector);
> 	unsigned int nr, i;
> 	unsigned char *buf;
> 	size_t offset, buflen =3D 0;
> @@ -235,7 +235,7 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_=
t sector,
> 		/* Not a zoned device */
> 		return -EOPNOTSUPP;
>=20
> -	if (!capacity)
> +	if (!sdkp->capacity)
> 		/* Device gone or invalid */
> 		return -ENODEV;
>=20
> @@ -243,9 +243,8 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_=
t sector,
> 	if (!buf)
> 		return -ENOMEM;
>=20
> -	while (zone_idx < nr_zones && sector < capacity) {
> -		ret =3D sd_zbc_do_report_zones(sdkp, buf, buflen,
> -				sectors_to_logical(sdkp->device, sector), true);
> +	while (zone_idx < nr_zones && lba < sdkp->capacity) {
> +		ret =3D sd_zbc_do_report_zones(sdkp, buf, buflen, lba, true);
> 		if (ret)
> 			goto out;
>=20
> @@ -263,7 +262,7 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_=
t sector,
> 			zone_idx++;
> 		}
>=20
> -		sector +=3D sd_zbc_zone_sectors(sdkp) * i;
> +		lba +=3D sdkp->zone_blocks * i;
> 	}
>=20
> 	ret =3D zone_idx;

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	Oracle Linux Engineering

