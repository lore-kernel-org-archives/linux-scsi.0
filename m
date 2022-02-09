Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A388C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 18:05:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238417AbiBISFD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 13:05:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238519AbiBISFB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 13:05:01 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FBB4C05CB87
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 10:05:03 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 219HAbaH027666;
        Wed, 9 Feb 2022 18:05:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Jh4qNHVdUz4Qrj19TvVC/WqEOEqgHHUhfFADurm8/jM=;
 b=GIFqApDyIfURvniyWLOsyt4ENRssUSsHOZimBFMOE3bnHEINoSS8pY4nvvaZ8trKJmwl
 CWn94aTE6J5vxWJui+bIY3hN8Y1fD9hkERDbQwHaOT62Qftd4s8gu8awAiOEBWj/3lCi
 15NzzgiIp1XSsqP7rXFujUj3V4jau8Y688pE4/wA7SShI0QbectQBNZ41Upm3iEBx7gl
 laQD43iKe6JcXD5AOMsyy2tnMNMRwiiGwbydjEyStBo/7ZuDBMYxZkvHZXHhz9UWjyH5
 5R5QSUbtl6DrGZzplwZeOILU8M3nERzC8w+wfievmSiHubZ8l3XABMdPcfh/jVYwPyAm 9w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e3hdswbr9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 18:04:59 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 219I29k4067027;
        Wed, 9 Feb 2022 18:04:59 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by aserp3030.oracle.com with ESMTP id 3e1f9hsfye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 18:04:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P6B9AsJrSGUfSnL0wzX7VmrwT0IxUcgA2k6ypBAMkDl8OhAAIa5iJxHytQM3h3BQgaCJUM71tk86g6JZx0uUyY7z5UHzu3aJtqlV5mRG7SOJz98wLEzNt3seeU8aznoL2aZGrehI+x0+q+L1nXYa4Ispd0PPC0PdATv/BdyNwCn+SjSiZ2Suc1CwF7LBmq5prSvBYTLcVcu6/FMbcJGnbbH2YyvKg/JyN/MUA8SD2FvPn2e/0MVfrIy6BtFfJHBevE9yw7WaGircr4GcCn6t/kny1kc7E0Q/GcszTjlRtHII98l+lQxk0x3s+pXlz8ZRbppzHj8exHJ+/QgFsSZ+fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jh4qNHVdUz4Qrj19TvVC/WqEOEqgHHUhfFADurm8/jM=;
 b=TSxNos8UdDVUuoba3PggaYPXN9OsP2idnE3EBYPyrlcd37d9L8eAl2SDvlR919QcxisjpdSdiElfJ9Z2pmijaOn2p9KkZy3n9faHfwf2tbXacsCDw9a2Pqh1yiiQQ4I94J8HZMwk0si4bkZ5KgCm2db7dqjKLjAf/E0RReMCXM34czwduzVRmSeFrleTtDnCH+moYIF23Iq++AXaQYXFOdvQhqQLwAjX008i1W0srLwIuDIul88gEw3UzQfOZvb7qTAL0ohOLYbIMeo68pRjTpemFnR6mZOF1ZbLtNMVRgqpPG0U5xikiubrjvbyVTRnyL0KUAj5u0m95nqBkVQW9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jh4qNHVdUz4Qrj19TvVC/WqEOEqgHHUhfFADurm8/jM=;
 b=oSltLXJyDq9rhxN/Esouht/xN80+g0FoaUXx/t3hC+RPXuUNaJHeaZNp1LTF++ZCNvc28ir8SOzHK2/e/ZZWo627CiKcsleoyf4uF92S2lDjdLjD+jEjeCojZnEFW8wdPOWMjbaKJ5isejgr0kkhfvtyHptiX4R6YKoijhwIVh0=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by DS7PR10MB5150.namprd10.prod.outlook.com (2603:10b6:5:3a1::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Wed, 9 Feb
 2022 18:04:57 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 18:04:57 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v2 16/44] esp_scsi: Stop using the SCSI pointer
Thread-Topic: [PATCH v2 16/44] esp_scsi: Stop using the SCSI pointer
Thread-Index: AQHYHREhsqo0tdBk3UuqGAXsy+OTGayLhPQA
Date:   Wed, 9 Feb 2022 18:04:57 +0000
Message-ID: <F3F9B225-EACE-4ADF-8FB9-592491ACB464@oracle.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-17-bvanassche@acm.org>
In-Reply-To: <20220208172514.3481-17-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1e1cd643-b761-45ce-a197-08d9ebf6ae80
x-ms-traffictypediagnostic: DS7PR10MB5150:EE_
x-microsoft-antispam-prvs: <DS7PR10MB515071B0B691BB7F86515180E62E9@DS7PR10MB5150.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H/ZevzuEH7P4Qimy/V7gTBj2YRU1n/yXj4k4npHuJu+UgNyl3Eq8JrVfEkBsYkfS3uJ+JtxVqr3qchneGDOSNdiTXIL+aAMRd6syVXQ2EuYDFRMYimuR0us19Nd8LuFYlNVpGDLCYmrIlLne1nRAQ9Za1YrcCIvrE7W7eq9wxSFCSIWFyYGR3a3mlrHB4yIYZIV0KtrV12EWXPSo++ybb2VABM87TMaXP14v64o63DBudTAxKbzEmJ+TcMgbJrEf/ZB9SD6qcAhD36mozBTuT/IWx/GBgq+y71A84NESSuloJx0/00VWk/L8b1lfUbTijYjTROthM0JesuMjRcNILU+LgxTdQPhgWoh4C2lGL+cAss4fh3QtwwUxdhBr+ejkzlGIido4ZKo/HPrQ0nAHfepcC3sT+bpl18rerO4dQco6Oah4nKaGkd+x9vYGJsg9a94dKNb9TIkaK6D1P7WqmjdQTOAqlDP5TBhARIL1eHujqn8j7mbcTiIY8dYKZYmn305kp+UZIzxAUca1Kcz1wAhKZFZdz/ovAX+rTxpwr3g11kHW6YtWfpxnDFb30FO/stZjJm3GxSfuXCANzRvCnTRjAhxk54e5u3BBm9NVXkqHj1KhpNkXn76wJgywZC68O5/SDHIol+aSMKP0Vx6hFPuKX6QCfEHeHlFbdbR44VVRsul7Ms3des3vndh8ZY+w5WMRTn3XacnK5SU9fh1xUdeE4F19hWyqp7x280GEm4/mFNjJIyX1lFeWCXOvgPSq
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(508600001)(2616005)(6486002)(53546011)(6506007)(6512007)(71200400001)(86362001)(83380400001)(66946007)(66556008)(66476007)(64756008)(66446008)(38100700002)(122000001)(8676002)(76116006)(4326008)(33656002)(316002)(54906003)(36756003)(6916009)(2906002)(44832011)(38070700005)(5660300002)(8936002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1dlDjXKqhsAsi69u6+3Sm6AIeLu5fNfcOuTFKmz7RyshX7WdBElfmZh0zp2u?=
 =?us-ascii?Q?WWOtAK/XZJWWEls5pE09ru7IrZXlaRCZuRWbyypMnyL0KKj0dqJeJ9JTMfYw?=
 =?us-ascii?Q?2ftQt/TDFy/4QwWFA9VeZEljkMBd0WAHi7Br66VvAKODBnqZjR3SnALZHs0N?=
 =?us-ascii?Q?DM+74quaF+hCu2DyaW2VQLWQp2IcdzrJyv4xheKTp4e7Asz+z/skHDduintc?=
 =?us-ascii?Q?VswLdopNttOdMOxlMkBtZIUXUl3TT1GfyM0UnUnQVBESQzjY90zc480Tf5se?=
 =?us-ascii?Q?5n6rpZfrrh1j11AX39eNNWspI6Bo/UNHNi+IvhnEtFbFuytRQFf+GEm9u2Hd?=
 =?us-ascii?Q?L61mdkMVv5SzfzChKfABPbvZZEh6S42AKUDaV+KHf1xJCqxQpXPD83HDrNi2?=
 =?us-ascii?Q?ogLLZOdfM4a/EXEhSJ8oFRHmlpZLkChlFH2CwHOFRLYl654xPIyWtHtBX9nB?=
 =?us-ascii?Q?n+8dh8R2PVghYJAWWXq4D6A/gNQi4mjEtYLnH0eR2/oyeLwS0qCx6yaFpVV8?=
 =?us-ascii?Q?su3Y3ptf6wYb7l5/KJ4mI4SlVz/liZkPaV0cmBsvLmzntwxg7ruhY89JkFVL?=
 =?us-ascii?Q?RU/fihDb3dLBTKGyxIBwt03/sjnpFxprUn5gryF3LAUB9Oii1SHPYA9iTlAs?=
 =?us-ascii?Q?1TZXBUb+colKJZ876WDj9hEBtuL3lstCvHiMPJQjxbUOaxuN1tQATqnooGKn?=
 =?us-ascii?Q?mmfFtZWlRi4QLe5felFb1+R0s9YciitV7CLmYB4lZsqx1LX9R7WYSoMj2ZeP?=
 =?us-ascii?Q?xTUCi7ih7wLajmsB+kvllMZCPE+7x5r8jRsaIb0lHs4uwJHT6PtP2qfvnNxK?=
 =?us-ascii?Q?OGOpRoaQjXpZ4Dzp9N6td8n56CsaR1W9tw592bxScqpYFSbjPHtBjnaewfST?=
 =?us-ascii?Q?OQ2SlcU2z7T+XSeyvJfu5AZNUCH5KcSRud9+CCZN0GJ9AaXZnF/ro/z7rADi?=
 =?us-ascii?Q?rajk8bkIYy8oCvLPKZREe/7xVvdCTnFvrkKF9JF5X0zAfT/RvI2M/aOTXUIQ?=
 =?us-ascii?Q?wpWsp/e4n0qeO024GkY/6/zSAA3AHNdsrzWjzIBVu0DiXMN9kuHiHl+4oCo4?=
 =?us-ascii?Q?B6QjB0z5F01QYvv9RQ61QB5Vlu1E/2WlTRmLjsMsuX/AtUbKb3cSxaHSa5ZA?=
 =?us-ascii?Q?llsyza0pSwCrXNz5PLKWujvTjizA7NxBV5WNWQklkzcdaUUDnY6yZHBpUhT4?=
 =?us-ascii?Q?0gkl9o3BMZdlqAcBcyPveu38DT1O7aZqDe83zsv0O6LYfD3TxWPAWUbhQoTy?=
 =?us-ascii?Q?ii3H/ggq/IHxNJcqUylYTpUbsu4ls4mJW+72GrJBnYxuZvXFAvJn5zuAUGqc?=
 =?us-ascii?Q?gzFxwWmwLYTlP4gmCK1XRgI4ochrYKLxsj589ZIwZoydRexRfMN7fTFOFv8K?=
 =?us-ascii?Q?6hmM1NGZMdg5fKMFFF5LwVIiK3Inry02kbq+rU8Ht7OimNErvuaUvysSnccE?=
 =?us-ascii?Q?RK2cLCip29EjJHO251Wwr1MrV/iZGa37FkVoQFyy1RIp/zKxYSGcRyc7U7yp?=
 =?us-ascii?Q?T2/a6o0tsACPuNIVxAbCqRW8Dw/N6SIKG+uctRIU7/Bt/PAtWF4BJzwMK/TL?=
 =?us-ascii?Q?vipqXjOr7971K/rQHuUd1QVDJrUhMmILUXcbz4Cyp61GUyladejW3IqLHYKt?=
 =?us-ascii?Q?HtWPqp0T/SIpeM6E30bMKsXD/Ni4Emx5tG1m6TkotVokweftoSXhc/VFOTfK?=
 =?us-ascii?Q?7buIfHJ7xWSPyx2GjFKxCYm/ZqUUZ2Ta+EhMmGPSUliKXqF8?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1FC33BC4550F9942B3E0019EEEBE8F7A@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e1cd643-b761-45ce-a197-08d9ebf6ae80
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 18:04:57.1158
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UulP7Ux4CSqZl7XUULm5mPvHdJXof0LkzG7PTX7aBk7hWmK8r6InCLKdwHAGlUV53+ne2nadUmNmbblAN613RisFouwgyKAzbkmavqi9VIU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5150
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10252 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202090097
X-Proofpoint-GUID: iXt9bjFmi3lNV1IrrNvJcG9tgcw7jDST
X-Proofpoint-ORIG-GUID: iXt9bjFmi3lNV1IrrNvJcG9tgcw7jDST
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Feb 8, 2022, at 9:24 AM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> Set .cmd_size in the SCSI host template instead of using the SCSI pointer
> from struct scsi_cmnd. This patch prepares for removal of the SCSI pointe=
r
> from struct scsi_cmnd.
>=20
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/esp_scsi.c | 4 +---
> drivers/scsi/esp_scsi.h | 3 ++-
> 2 files changed, 3 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
> index 57787537285a..64ec6bb84550 100644
> --- a/drivers/scsi/esp_scsi.c
> +++ b/drivers/scsi/esp_scsi.c
> @@ -2678,6 +2678,7 @@ struct scsi_host_template scsi_esp_template =3D {
> 	.sg_tablesize		=3D SG_ALL,
> 	.max_sectors		=3D 0xffff,
> 	.skip_settle_delay	=3D 1,
> +	.cmd_size		=3D sizeof(struct esp_cmd_priv),
> };
> EXPORT_SYMBOL(scsi_esp_template);
>=20
> @@ -2739,9 +2740,6 @@ static struct spi_function_template esp_transport_o=
ps =3D {
>=20
> static int __init esp_init(void)
> {
> -	BUILD_BUG_ON(sizeof(struct scsi_pointer) <
> -		     sizeof(struct esp_cmd_priv));
> -
> 	esp_transport_template =3D spi_attach_transport(&esp_transport_ops);
> 	if (!esp_transport_template)
> 		return -ENODEV;
> diff --git a/drivers/scsi/esp_scsi.h b/drivers/scsi/esp_scsi.h
> index 446a3d18c022..c73760d3cf83 100644
> --- a/drivers/scsi/esp_scsi.h
> +++ b/drivers/scsi/esp_scsi.h
> @@ -262,7 +262,8 @@ struct esp_cmd_priv {
> 	struct scatterlist	*cur_sg;
> 	int			tot_residue;
> };
> -#define ESP_CMD_PRIV(CMD)	((struct esp_cmd_priv *)(&(CMD)->SCp))
> +
> +#define ESP_CMD_PRIV(cmd)	((struct esp_cmd_priv *)scsi_cmd_priv(cmd))
>=20
> /* NOTE: this enum is ordered based on chip features! */
> enum esp_rev {

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

