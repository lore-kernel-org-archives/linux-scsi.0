Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 729EFC433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 20:43:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbiBIUno (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 15:43:44 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:35576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232107AbiBIUnm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 15:43:42 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27CCBE00D10A
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 12:43:44 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 219HFfx4017435;
        Wed, 9 Feb 2022 18:59:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=KIPK5xQezNkBFh9KzXfIPD28QRrkooHgodfJ7S1GI9Q=;
 b=z3L4vnj9G2qRop1aaSPC75D4gmgi7F0z3hh8TNpbVUwm56PWr5x7S4nTBXs31uJsE1cK
 w118OCmpOx+ILBSSd4yHb5S77YqUdPqebh0edDSwSOoTFTqzd/7OSKr95pVQH1+YfS1m
 i6MGi5OiUBG6Oa63HtWgAWVOvT6U4WvgOGve7AnU7RIcjI5dZgmq2WyEshTdF2lLfygX
 T4uECm/xeoyW2BSmxaYhJJ/qA494PHPR9n5bG2V7/tZ+k1zShwkzyhh4O9/xwIpP3Su5
 xvw/34copWoUOkuoVPuNGkbIlWp5izNXFpPcI/HkCmOM8XcJDTwCGMt8fCLsFmag9y9Y xQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e3h28nf6h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 18:59:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 219IqAho070077;
        Wed, 9 Feb 2022 18:59:07 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2046.outbound.protection.outlook.com [104.47.56.46])
        by aserp3030.oracle.com with ESMTP id 3e1f9hvrx0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 18:59:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GKsII/35bbHb4Bq2rOPRA1Oh5D9cX48J3h+TbkZP1TNG/vPjVViwxC9jf/21+tUSjuxKVR2/yJXr1zEhitfGpjepvmZDwK0oXj70J7jWMw7c6ufdtk2yiNVLDewpPhxxYc07vpjP2mGOanmD26n57mdOs2Aqa+H85sPk5l2M223HoGFRyRpP65lxN+NyEyY/FcMUAMoVmVUdUi/vGUwVD6eq9/oUC7eJxdONXG4jCZpFEiKDWh2/fNbe0l8RWgbtDN6KyS9OPvCgaiYKObiVtFIJxwYFV11iiQR38zko/ZpLME3XKvCJ59WmIPEzf2dV3giLd8fxZfnntyrdWv0ylQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KIPK5xQezNkBFh9KzXfIPD28QRrkooHgodfJ7S1GI9Q=;
 b=jKmPIJsJd2uwTXhsEOVlSN8nAKntOyBOVzIDiqnnzPZzuKfMRlvjSOsAR9imPrMHvUkUTkCnX2jLvC9YyRRrwVl6XUr6MLpUtxAd/2QK33LGXrH5T1xsumVHXlV+yx5gSXsfByKsqziO+LhvRZl9W/pncUvWXDZM1Kf2TUk/O7aBVM3sfFFNcfclDDHY0okanCeg4kv31NS9HWNB3R8+oTkM2MtYwkj3OGa2CTaNcFY9AyCHs62qCA+qeoQfaRybA6B7xoLbFK4I9DA40wak9b3OWTu3mz7eNUZnugGSz5uMVQ3hM+P6AybzQGZg79CGeCDyj+38pXeAKU/A+pKIKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KIPK5xQezNkBFh9KzXfIPD28QRrkooHgodfJ7S1GI9Q=;
 b=HW+zzkN/0WbcNgycRIaOOP31W8qKcQ2vdaSGp/5jXMFsLKLdAa/WdZZE1tb+7Ktz4rgDaTtZjXzLzxFjpo44Qt8b2NJ7OUa2R71iQcp/jYfh2dta4Ugl7VXJ2daS4VZ78WCi7zMsgmVckKyHYodmaPm9anaR8WMq3R96Nekz/5k=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by DM5PR10MB1867.namprd10.prod.outlook.com (2603:10b6:3:10b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.16; Wed, 9 Feb
 2022 18:59:05 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 18:59:05 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Don Brace <don.brace@microchip.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v2 38/44] smartpqi: Stop using the SCSI pointer
Thread-Topic: [PATCH v2 38/44] smartpqi: Stop using the SCSI pointer
Thread-Index: AQHYHRFFZ/lWeCd+C0Cc1N5axT8ucayLlBQA
Date:   Wed, 9 Feb 2022 18:59:05 +0000
Message-ID: <48C2AB10-7E2D-4487-890C-CBCAE76DF355@oracle.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-39-bvanassche@acm.org>
In-Reply-To: <20220208172514.3481-39-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 23758953-4d77-4007-14b4-08d9ebfe3e99
x-ms-traffictypediagnostic: DM5PR10MB1867:EE_
x-microsoft-antispam-prvs: <DM5PR10MB18672FB28F726AC6198403F5E62E9@DM5PR10MB1867.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5/+Nqx65wrw7uBc2h/77pH/hCc5bY8wvH8gNPff3ypnnLv7a8LKjPPYjVpTRc5zTFHm2TZV0Ey9vO0lTJkd/EYgDEiOYzevSGvJ/Ywbt16vrevnBBnsLyvoRiL7B0VJrVk2tXskEtsfzHMYsvHJVzhfLDSxrOnZ4d02GkJTsgfja3rBGLmOhzocsb42RROcJ+cFeIXDYFMg1dE3dpZ6VsfOMRckQmStcZ3uZqr0maDdzb3sSIM3Djtkf8qTCrw9VKS9h/WvJdLKiwYD7utBMES9G3yJYJiI3TBGNtw5d8FaE83HLGS2RxW3vzEsj6dBjsydmyJvvBi9lIFsw9gaDnUuvxF8yA6ZnTUA2sMC99sVdzngc3/9UXA3YUvASzXXiWYQe5rjiD72oGmTkS3Z44/zPbNtyRrkxLE6IF5o40/KC9Xvon7G5F0lVd4CdaqsB729bvpNinru6fH2vJGSBTiFafF6r1Tq90pf1qJmHXNStPLc3sX1FSMbti+rsFzsWGoE+HQS679Au1l6tDNYHM5vrv/Y4M0dtLt3CvI8uQKkee3eafI+GfzfNRQZIqW/uGRW4Ktuq990Q+1fKDR+NiFWCUeS6g036v9E7QoppKuSFzyvWHP+f+kiKEOu4Idpj1qN6YUDZHm80qj7pow2KKbxl8NCuCFb3Qm2ObD/0Mca7eUnJvHdlR0+J+jnRtt4oLQRnpHDOb123rO/SqVYI2lmqqzGaBwaA1tmJsM9xgbZScGOeJLEGUdrS3T8QAx2o
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(122000001)(44832011)(5660300002)(186003)(64756008)(4326008)(6512007)(8676002)(8936002)(66476007)(6506007)(91956017)(66556008)(33656002)(2616005)(66446008)(86362001)(53546011)(508600001)(54906003)(6916009)(316002)(66946007)(71200400001)(36756003)(83380400001)(2906002)(6486002)(38100700002)(76116006)(38070700005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Twov65jr7JnmqMu8a4ApcXFIsxH+GMzpW6j6whIg2GZ/EM/WFWdi01PTD3qQ?=
 =?us-ascii?Q?EvQaeYpzjROR1l5OFE9eaBD5ctThi8P+jhxfaLja8mC0VAV7RmJaPMz9JXOV?=
 =?us-ascii?Q?B+Q+HVRe+L/tA2SV/oQ4Y70ld2AeAGLzNbrqyvdFSkgfjg9vl1KoI0Fr91gN?=
 =?us-ascii?Q?/Jy2Da43jpbDayfIBiD3MYggFMh7Pe/Cm0BK4ToYCN41l4W+mUvGgEjzMtiv?=
 =?us-ascii?Q?+lo4PlQ+dKfghhpEIETYV+MB3CaSaNiehw1hKqQ7Ic0f/f1qZM0r1B7Uq2R1?=
 =?us-ascii?Q?o2eMB8caiJz8S+RSmu4Jj9+a+U3N8f8VNHqG1NM3Jw7zL8rPpPaJ0UPzlNE/?=
 =?us-ascii?Q?L/DOflnSToq5A7Yv1hixbtPluSvDP0peovVisT5tQ+hcOVhGfY6kFG+AP+Tf?=
 =?us-ascii?Q?ukR//fd3D1JaOdsH0rJ6QU9JJXPrIn3ellhEzmjuYtutMELq4152Z2MulVr1?=
 =?us-ascii?Q?df5sJ9xCXpvce9pfPUJsyjKgGQW+i4dayhyOc+SMGcYr/Og1AhgihJkc9Mno?=
 =?us-ascii?Q?hSmhElZYgXNuUAXF9Si8ikk38amgA2tJJlXOgHsTZ9VyKjnlBOtiutecd2jj?=
 =?us-ascii?Q?znqHEe2IWawLFZxXUgktckyPIT1ABpqnG25IrK07ebS9z7uw4FPDXlkzDE23?=
 =?us-ascii?Q?46AN9jLvcFlZQhGFzOOJg8s3QT8ra+IQlGj1W0lKzxM24OEk139wfKoio5eJ?=
 =?us-ascii?Q?rSV8sTSoWkvtiSbF1HC7f8EZ7K75C0eVP4GfWeb/nh64JIo1nLx24paRsNZv?=
 =?us-ascii?Q?aookUNGibeEE91YIwAY11ZZDeqkOQrLIZU6uR9gC3xLE8nBXklLaW0dZ5EZl?=
 =?us-ascii?Q?VdzGL3B31sXhKTwDPB4gY3d0iXT3u8CyLi2XI5wamVHIOh74/xKpRBgD8jqv?=
 =?us-ascii?Q?Efrbyv8VW3UVffUXCZywvGcA0kcRCTc6sQLUpTLvu8nCuzLAa977qQruIh5v?=
 =?us-ascii?Q?mIvdsk3znY7MPFEJKWirfL/ifZnaVj/DxP3xDZNZmZF6nu+qY01geuij2453?=
 =?us-ascii?Q?b/xKFCVos1ETVlbo79up0oI7GI+AULx0ukt205fyrPt1M49W5o6/GKAno/mR?=
 =?us-ascii?Q?nbaJoqXv3yBTcbyEnPl/+mk5h55wY0hsnZmqkexVSXqeLG3DUMpxx4ufzlzd?=
 =?us-ascii?Q?3nQbEvcBHCRVgqWj1INsmDmBd6zR/GUuSQ6MDmyuP98MaOZ1EtxLefjxPLxY?=
 =?us-ascii?Q?RpANJ3TouwGBUx/o8gSiVmFDxUcN0+421z974Tga0YcdcSr2LTw7aLmmIqsc?=
 =?us-ascii?Q?Ea8PJONt70CEUld4qp71Ua4IofMixP9Bf+J2LRbH9k/ASH0FM7jADqJb89Z9?=
 =?us-ascii?Q?yyYb6lFJz/QDpsuTwrGyxYLtSfWVT3c5Qh/M7sGKsM3OQw3sezlIHogMXKy5?=
 =?us-ascii?Q?wNpj//+k64F30/roYmxwwMcjz+exsn+X+5Upu0bm6LSvoge2qu9umDSLQKoW?=
 =?us-ascii?Q?kjoBpTPwJE27tT2DN19WDp3pTgUH+klS3e6JKGB9WzDJfSOE4BG/s8DaW5W5?=
 =?us-ascii?Q?bgRCuRZiVSaXCrepwxVXPLitMBNYNfOmsRHVGGlJJx/9tGo/lFIKvavHq0QG?=
 =?us-ascii?Q?7V0pFVweMMeVmagpJL66nkLxDzDdU5tUm420lAD1/9Q/CuYCFpbDPL94MG3j?=
 =?us-ascii?Q?rTn82rVBD+0sGYzxaCG3YaNH+z9cnK8QZVxKcO00xEiNJc61BHkvsVFlo5hU?=
 =?us-ascii?Q?QZpn1Hyk8K3gwUifmU7wIFIRWRmh/s6HsmytHCYd4AwtXa0M?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4E655EA73E73D94CB2624819F38E03F5@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23758953-4d77-4007-14b4-08d9ebfe3e99
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 18:59:05.2982
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lQT7ggbAa9hqDNqdKvsoGQ+uZfqiMzorzDBOE1zT8ctX3wxIrwMn0VSL+UPoFv6F2hCM0hcfDE2p0wiNso4OV3B+OR2QKJ1lltYtut7zi+U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1867
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10253 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202090099
X-Proofpoint-ORIG-GUID: rDSiqjGQ-z2pGTxKbVaLtMrQtaepa1yE
X-Proofpoint-GUID: rDSiqjGQ-z2pGTxKbVaLtMrQtaepa1yE
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Feb 8, 2022, at 9:25 AM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> Set .cmd_size in the SCSI host template instead of using the SCSI pointer
> from struct scsi_cmnd. This patch prepares for removal of the SCSI pointe=
r
> from struct scsi_cmnd.
>=20
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/smartpqi/smartpqi_init.c | 14 ++++++++++++--
> 1 file changed, 12 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpq=
i/smartpqi_init.c
> index f0897d587454..74426974309f 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -54,6 +54,15 @@ MODULE_DESCRIPTION("Driver for Microchip Smart Family =
Controller version "
> MODULE_VERSION(DRIVER_VERSION);
> MODULE_LICENSE("GPL");
>=20
> +struct pqi_cmd_priv {
> +	int this_residual;
> +};
> +
> +static struct pqi_cmd_priv *pqi_cmd_priv(struct scsi_cmnd *cmd)
> +{
> +	return scsi_cmd_priv(cmd);
> +}
> +
> static void pqi_take_ctrl_offline(struct pqi_ctrl_info *ctrl_info,
> 	enum pqi_ctrl_shutdown_reason ctrl_shutdown_reason);
> static void pqi_ctrl_offline_worker(struct work_struct *work);
> @@ -5555,7 +5564,7 @@ static void pqi_aio_io_complete(struct pqi_io_reque=
st *io_request,
> 	scsi_dma_unmap(scmd);
> 	if (io_request->status =3D=3D -EAGAIN || pqi_raid_bypass_retry_needed(io=
_request)) {
> 		set_host_byte(scmd, DID_IMM_RETRY);
> -		scmd->SCp.this_residual++;
> +		pqi_cmd_priv(scmd)->this_residual++;
> 	}
>=20
> 	pqi_free_io_request(io_request);
> @@ -5779,7 +5788,7 @@ static inline bool pqi_is_bypass_eligible_request(s=
truct scsi_cmnd *scmd)
> 	if (blk_rq_is_passthrough(scsi_cmd_to_rq(scmd)))
> 		return false;
>=20
> -	return scmd->SCp.this_residual =3D=3D 0;
> +	return pqi_cmd_priv(scmd)->this_residual =3D=3D 0;
> }
>=20
> /*
> @@ -7159,6 +7168,7 @@ static struct scsi_host_template pqi_driver_templat=
e =3D {
> 	.map_queues =3D pqi_map_queues,
> 	.sdev_groups =3D pqi_sdev_groups,
> 	.shost_groups =3D pqi_shost_groups,
> +	.cmd_size =3D sizeof(struct pqi_cmd_priv),
> };
>=20
> static int pqi_register_scsi(struct pqi_ctrl_info *ctrl_info)

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

