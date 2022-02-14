Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16314C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 21:29:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbiBNV3L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Feb 2022 16:29:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbiBNV3H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Feb 2022 16:29:07 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E373BC06
        for <linux-scsi@vger.kernel.org>; Mon, 14 Feb 2022 13:28:58 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21EIZ0QE017063;
        Mon, 14 Feb 2022 20:01:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=ipACSC+W8Pg24lszu5FIISdNuVBjYMhHTv8gja96zaI=;
 b=PA9vgM/rj1TFS3ykXytUjtX/Pd7mTdWVxAFqKgdc4UkwSeJp/dKr+/HyarfHJNrlEGnP
 4AAJ/uV2nQUnswa7lPJDfDEe4kcKmTnZW11aq0NgGCyWEHyYTn4GFtnzofgXeIfaUyFk
 PW+TpP1lcZz1HHuLqI51dTDqyYthhiTRIInTSR6tM1ZLs35xL+Mqoi/iizcA25wn3vJ/
 +NICoSfzBsnQQZlZ73v9qWCYQKDctTMdyCJvHGsWak/UqUv7yIfMs0Wm3JyNzyYfQP6J
 HN8A6dXhs0ZKT8h7D+HQ4lRGk/FIO1Ygpg13xFmKN+uXanoS2k5NPa+9b28CH+bM63aO 8Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e64gt5n9x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Feb 2022 20:01:08 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21EK0alb021429;
        Mon, 14 Feb 2022 20:01:07 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by userp3030.oracle.com with ESMTP id 3e620wg4ub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Feb 2022 20:01:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bzn7NM1PhL1VFfL2av7tIbt3w9euq3mvcuwTNS4GqddpzCtl+Xx91N3tGx8QS18Tny1+RBu2sJrIEzoB147agUTj4IxUDR/QEozbDlvGSABb0+uTmIpzZpvTiJa+L7E8266TLPjhiz5JMlv5mydREg5C3nQpa6LHyv3DUxL8cYLKPgfu9ubdwMAl/Ez/gsK6c22imco4tfmUt0EjjJxfE2WsHAER6Vj2R2usDV8svKxGXNCgQ9sqnH5U632YAou+Xq/fOVK9zFO3f9DvPDPFrB9N1pwsoWpOX/bIHkJVgcDXEP9mQMUQ5jIehqzFAYToLF2lMF68dqth8NHfWGydfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ipACSC+W8Pg24lszu5FIISdNuVBjYMhHTv8gja96zaI=;
 b=FnWmL6QRF5ifHNvkit5FoFThBYR9sW9BlM9tx7Bq8AiVFCf6+D50AdS5oosY+RwmsAmCbihixuDG3YTbkbTqdxUuBM+Y4QKgEXWYzBvwt1tnM5NVhFk2pSJ3cxL6+A/TeCLrA9IL/X+h4hXOjRGMXvkp9D13qxqvAH+8YGe0cXlsR+U33e2paT6t7l9VSWK3TFds1UOPm19x4Xh/nCNTar/FnG3CQZaGaZl8/w+6mK6jPzJb+1KiCunEyiWpoBOCHUWnOnlU0UANl5oqZX1+icfS+MrfxOTyvHsyiX5jAnC8Jao4SlasX2352YFseX1g2ZPdqmcWoQZKrdNo+DNIeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ipACSC+W8Pg24lszu5FIISdNuVBjYMhHTv8gja96zaI=;
 b=FPqttLPGij53ntt8ZNTebDB1WTyKqjCo38hz1hUExt1j273tMYvOwZkPu7IR+VM9/jDU5QUNMxsQ/KX2zJI0AdR4c1Av9avRb6svo+VJNlDqz5AepHg+VhmbwlI51Q8Rm3IELshFvHnCJr2VGOm6+aeGqag4Ls/7QzCCyBSzH0c=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BN6PR1001MB2212.namprd10.prod.outlook.com (2603:10b6:405:2d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Mon, 14 Feb
 2022 20:01:03 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::98be:91a7:9773:9d39]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::98be:91a7:9773:9d39%4]) with mapi id 15.20.4975.017; Mon, 14 Feb 2022
 20:01:03 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        John Garry <john.garry@huawei.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v3 02/48] scsi: ips: Change the return type of
 ips_release() into 'void'
Thread-Topic: [PATCH v3 02/48] scsi: ips: Change the return type of
 ips_release() into 'void'
Thread-Index: AQHYH5dZ2HH4HUcWj0+bKJjq0wCjTayTfAAA
Date:   Mon, 14 Feb 2022 20:01:03 +0000
Message-ID: <6949A9A3-3107-4623-A17C-7B299C81BB3C@oracle.com>
References: <20220211223247.14369-1-bvanassche@acm.org>
 <20220211223247.14369-3-bvanassche@acm.org>
In-Reply-To: <20220211223247.14369-3-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 683c434d-a327-420b-c638-08d9eff4ba9c
x-ms-traffictypediagnostic: BN6PR1001MB2212:EE_
x-microsoft-antispam-prvs: <BN6PR1001MB2212F280AFC2B126C38DAF3EE6339@BN6PR1001MB2212.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sBt3kMTou2AnD+UzxN7DfryqQH2PyKwnf+pgZ1TB/zQeUUn7v6vR+OsB7ww4RkD+BGFBH6pjDQEh2lbvWSAH/vD83c4RlRY1xuyoYzNc/96wCeAs81wSXDR2b1Al6HOj2Km6wrCivI/QGJf6xYzSzMWt1IbkmRMkuEmlkohEMocUEomszjb7YrOwdncmkQG5hvDB6O4CYic8f5VpVCIzVfyFQRerYFyXeveWse/xDpu5pQhKFuynZGt7/gkBbgb3jkVgOAS6qKAESqMIWIHrpW2FMZdqW6v6cqhJUSzmlMaVFyoR2lY2GOnIduo3n/oUYlDuvp/mnebnCI8XRoICPvbrfPaHO18cRQK7creK5oVXRorGK5V40Q0Tt+ef0MFpXzZYPss/4YMscjUMa9g+8kzM1VgV1Br74NahWsNx4bTDKmv3H7LFHrGN26COhq0Z5FCKlmqZrrF2x2EyM3a1m2XfE1DWwX17AcvOrFNwic+ppIaNzQ3wkTNqGLhK3QUYtRyzOC+S/WnziN44Sk/T+U8HHq9A5SlsiPbBcPL+RRPeEI0peAnza564mYTYsvPZOH3g6ZWMtSu8m7lGYrqNo+HAQHc8J3Y2PJL/Q8SXNTfTSZdv5uGPvdpl+Pp66u6D9MI8AZKS38cnlnenL4wQUG4zo83kLq0Pl0zxl1wpeRzmArX9AAGQaUk3DP6QCWSEA9PzGsWKVgqrLqT5mDivlypxyeoKukjqUg98G6chgYL4X0/6lCOHefiGOT/HsKeo
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(122000001)(71200400001)(38100700002)(38070700005)(44832011)(53546011)(8936002)(6486002)(66946007)(76116006)(66556008)(36756003)(33656002)(8676002)(64756008)(66476007)(508600001)(4326008)(66446008)(6506007)(186003)(2616005)(316002)(86362001)(83380400001)(54906003)(2906002)(6916009)(5660300002)(6512007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DU5itJCW1q7pAL0/uDaLFNuvlBEdIC2SyN2QYmzyxfAA8tDs+KJv5qslNphH?=
 =?us-ascii?Q?q7W36RTQAofJ42NT8TmuruqSKHJiw2ebVMg9u2+Fr2EaybPtVDoVtrikw53k?=
 =?us-ascii?Q?/yxhiaWcX5CheY7nxRwz2US/mu2oOn8NrmxWF3ScQ/MeNwxrodycwWh281s3?=
 =?us-ascii?Q?JPDaNCWmijvP/wd6HlpRPDGQQFckIJo1IcB83bb8THx/JT+CpgR4PxX05878?=
 =?us-ascii?Q?vnOE91e1DCTo8imEPmmU+ZfZttFjFxBCG2JpEa+L/xmUmnHfK6wFtmlMh9gw?=
 =?us-ascii?Q?eFLrXGMddBl6FoLnii62wI26Vn7/bnSNGq9g8Lm+xL5pwcL+Qes866GywBhv?=
 =?us-ascii?Q?X0po9KhSsmdCpw/MsoBDNz9Ug0Hdv+ED3jcXMhYY/SJ8/iV6lv/TokG7hT2N?=
 =?us-ascii?Q?FfMOIk8t4YdpHajFvMFNoIuUGW6NF00gVT5sLIKIfplBBEOInLub+tzEe8JH?=
 =?us-ascii?Q?ptGXgDOgM7c7QBz/vQDosUI/EyEo/pYjCZ1WqvyLh/9JydRFLcFem0cdqhGz?=
 =?us-ascii?Q?+mD6uRBoO12N3jB+STZU+a3vd5MispG4XYNr+vMOSTUjpQF4ZpQfgM4dQGlq?=
 =?us-ascii?Q?bWQT6X0k9yBjx6htgITk4iR2Rf+4eTazGFZ9XTbHLHoYYLlwcBN5zc1eAxlA?=
 =?us-ascii?Q?IrIuuQuaa6y2G0BPIK2fanIkx6kUN66+2oQlLY0uPVYMhfWR5t/J5+4nueZ3?=
 =?us-ascii?Q?ZGA2CKj/rAdmyab49Jr0ahS5QTQhK0ENx7p7AG994EbYZXsV2w6jPkmd3sNm?=
 =?us-ascii?Q?JsHkbjMIrsC0oeGW2IAEN4U7sbAufps7ixOuOQGhFcK4r4klTzWV4nk+poPx?=
 =?us-ascii?Q?LFP46DmBbxN2cY42Lw+sXGeVLV5pUwk87z5+AEAZLt8vRGE0dkCYBeAuVaZi?=
 =?us-ascii?Q?msj6AJB/+fZTagJcagktXYEZdtAA7fmAI5VARDzTifbp/3wXS7iD57O38pCB?=
 =?us-ascii?Q?OcrCI7oZpLmQ1CfyDgh2CULGn8xpSQuEojhNnDdzGG9CyPnrzofxjhJ8fpAZ?=
 =?us-ascii?Q?/GsGo3UGr2xO2cxIi5iZc8XWKHQ5c0+mJ5+DyT06Zou9Yooe3kPnUrMpK84h?=
 =?us-ascii?Q?BlBezBOoVdG+Mfn14j1dwUHPy8020WOxzt92bAref8cI6EyuIAWamZOAh5YD?=
 =?us-ascii?Q?K4W10ij5eeov9dhaxKSA4ft/6SS66AFygyWj/wD6iYp5h5UNhfd8Mjbi0mPp?=
 =?us-ascii?Q?Uat5RYoHKb9Di0hDrHi3jYFNcupkgMKX7ezxbXDalKa2KRy5mYkBMhAaYSJW?=
 =?us-ascii?Q?1TuB22SWireUx25xCWRXN6TDmMV+5IiJ1QPouHKJjjO6tGRAP/AsaVu3a2ia?=
 =?us-ascii?Q?5wL/YgRly9vXmlel40L+OloqOVhVPCWdP+4NcZTemr66znmY4aQXOtc+v2JV?=
 =?us-ascii?Q?4WLeZSFPbHGMz8nSVcHrPcIzzecsTHlNNNeoqrSOdstz04IwRepDKbhux4gA?=
 =?us-ascii?Q?x+nqgfPVGjNlkdmRNji4aJ7QCm4SK8WCraS342kKiwNTsB77nWjAVAzXBFwc?=
 =?us-ascii?Q?QUlT3b11A7rdGF2qwxjXwRmJsDgDaIzeSEHt7z7y210OH8hbvcBlFrP2hKt7?=
 =?us-ascii?Q?e22t8UV1UQT0Blk4K8Sh1cIbFKtp05wsTPUCUOKz+WmPX3UYXjx/U2PcDZIE?=
 =?us-ascii?Q?YBy6Sm23sB1V3zze7bTiwZfxyZlI1u4aoLZ8/CD8PZsGTkx/54h30Bl3idC+?=
 =?us-ascii?Q?cqVvBo+PR+YfMiN0ZhRs+D1ddXHSeAxIQ367C4DVozdrpcCa?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BDFA582EC5314548B9B659502CF6FEC3@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 683c434d-a327-420b-c638-08d9eff4ba9c
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2022 20:01:03.0749
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rVlAxIpE22DyaRy8cnyxLkXUHoh/Zdg+Na9RLW5RhxF2sF+ia1hE1AUOm4sqSmiZnhdyuxTpd2EUd5FNYPFHqCBMTUw9o7Va3os/4iu3QeU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1001MB2212
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10258 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 adultscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202140116
X-Proofpoint-GUID: qBV8bOXUwh06sERdLZ4G34lmV0zcSrhQ
X-Proofpoint-ORIG-GUID: qBV8bOXUwh06sERdLZ4G34lmV0zcSrhQ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Feb 11, 2022, at 2:32 PM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> ips_release() has one caller and that caller ignores the value returned b=
y
> ips_release(). Hence change the return type of that function into 'void'.
>=20
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Cc: John Garry <john.garry@huawei.com>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/ips.c | 7 ++-----
> 1 file changed, 2 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
> index 0db35e97ce8f..59664e92ec8a 100644
> --- a/drivers/scsi/ips.c
> +++ b/drivers/scsi/ips.c
> @@ -638,8 +638,7 @@ ips_setup_funclist(ips_ha_t * ha)
> /*   Remove a driver                                                     =
   */
> /*                                                                       =
   */
> /************************************************************************=
****/
> -static int
> -ips_release(struct Scsi_Host *sh)
> +static void ips_release(struct Scsi_Host *sh)
> {
> 	ips_scb_t *scb;
> 	ips_ha_t *ha;
> @@ -660,7 +659,7 @@ ips_release(struct Scsi_Host *sh)
> 	ha =3D IPS_HA(sh);
>=20
> 	if (!ha)
> -		return (FALSE);
> +		return;
>=20
> 	/* flush the cache on the controller */
> 	scb =3D &ha->scbs[ha->max_cmds - 1];
> @@ -698,8 +697,6 @@ ips_release(struct Scsi_Host *sh)
> 	scsi_host_put(sh);
>=20
> 	ips_released_controllers++;
> -
> -	return (FALSE);
> }
>=20
> /************************************************************************=
****/

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

