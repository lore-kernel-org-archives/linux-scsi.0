Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CF23C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 20:19:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbiBIUTI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 15:19:08 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:39762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiBIUTH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 15:19:07 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD842E00E5A6
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 12:19:09 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 219HMh4c013360;
        Wed, 9 Feb 2022 19:04:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=h6u+ch/+Qc/BMHoME3bYxNNW9wyhUORXKv1LLNLpnPw=;
 b=VaSy+DAOA6BkTpixGp5K+6k6oBiJVGtxfjH20lv8Bqz8uQNIGE7Eq6rc1zty1AhktWy3
 RQIrn0kIJm/eZpf97loIS3db7YVn99KagLMvM2LNqFdGzLKPJD3krEhJO05fV1P0Zxr0
 dnoQIE3qjB7ue57cEEMcP9GgvLesNQ/bpq6dE3njEKIUB9iNie/X25cBG9nEQ+LcpCyg
 VdEcTtNyq8YQjsob284H8ZNTDJhyFEChG0hsbVRsB6AkGPFbxptt3mxzvqDnBVSAVOB2
 Y6TiboYDqSZlCuVKpUGex6nMTzLz2qnbCj8NugWb2G24OiFStLGqERPUUKUTLsgMdREn Jw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e368txr1u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 19:04:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 219J1bFa139243;
        Wed, 9 Feb 2022 19:04:32 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by aserp3020.oracle.com with ESMTP id 3e1h28tqcf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 19:04:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C19SGR62m7INlrY6oZq3SzdicLS+mwTyxwWQ7zG6O34ypITfep+qVwE9dxcD1yVD3mqLkBGtAnNlI4fO78mRkprdIP8e92Yz0Xkt/4ApG2hkhN+fmVymOz3q75O7kfDmlVhmVQY6R9l8bi7ZZPZBRee8EThB3to40dxZZf9Qbn1zhlOpHSQl23cJpgH+b/XFfLhzwq9Xo3PvA37XNJpuSvTBX/wXzTG3Da1N8CyluakOAA6meapY4qYGzKYr5DXdIV85+++GPtN6DllYmgPz6CwqWE0X4cWIPtJ137MPqcJSXcpzdhi5/FhzfZrpE50WANo1qRNbLgZTHHMtj6ENgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h6u+ch/+Qc/BMHoME3bYxNNW9wyhUORXKv1LLNLpnPw=;
 b=oLrxpUb+cfEb8QhptGfExTxGK3ByzAvz4EU7hiv+hzqS20GnjN5Thzffe8pOVKMGaAFb0rEnvXFAXhF28cSHHTo8hnYMSQCVjP95x3i2VaBTTxSu3LZ13nYkL6A2fm2QPxRAsEeL3pvKmG3Dil4XwgbbavtNcXvsKTCDI+fQu1Bdc9inA6Pu54OybdbSpq1FNL9Te46U1F8MJ9SICIo+DxLInzo9ZSTdnSRQ36ZuXjiANDfhdR6arxX8uA5PCIrkIDqWYW631sYUVgWPurs+uR2gXnyucs0LJWTTBIW/4nv7yvkqqRT8sz5sJ6erF5p/DFwTzbnuKkLvcGGtNuGS0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h6u+ch/+Qc/BMHoME3bYxNNW9wyhUORXKv1LLNLpnPw=;
 b=gsWIUSIVVbL4vGLVNdurnDunEHqo42ff68dwqLKEEyj6O7uFgwN0Ck/kVCldfzWZrxqrM4VaG+M7csTu45N0UjVpSygCpG59+Zfv+aDlYF1Cf8xBdGofPRlDuwJivhUdBW73jpEEfGk1OLQa9MH4wWHkc77SSrVl25YDIbcvXnE=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by DS7PR10MB5311.namprd10.prod.outlook.com (2603:10b6:5:297::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Wed, 9 Feb
 2022 19:04:30 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 19:04:30 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Ondrej Zary <linux@zary.sk>, Christoph Hellwig <hch@lst.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v2 41/44] wd719x: Stop using the SCSI pointer
Thread-Topic: [PATCH v2 41/44] wd719x: Stop using the SCSI pointer
Thread-Index: AQHYHRFD4LWnwMy3UkeqVY1ErwDv66yLlZeA
Date:   Wed, 9 Feb 2022 19:04:29 +0000
Message-ID: <FF274719-C326-496B-9859-E2446D1733D7@oracle.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-42-bvanassche@acm.org>
In-Reply-To: <20220208172514.3481-42-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0bd78e20-b010-49aa-48fc-08d9ebff0018
x-ms-traffictypediagnostic: DS7PR10MB5311:EE_
x-microsoft-antispam-prvs: <DS7PR10MB5311D63B929E20D0A3889FE5E62E9@DS7PR10MB5311.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6vECBigUYvdcjT/lzWdr7Iv82ZN7hUsR9dw1hrdXCA/Bj09mPOiVqb6EFu2xi+CX3tSG7T5jdz/ghX1tMTralIXmO7wYt0ccsS6x2mJgUiciVgOwhNHqfPbDeG63/T56ax9vuwCU1eYYEOBTz11qOARW7XJ9/AFo17oqJSs10Y5d8v7UO7R52o8Rq/o+eRm0frtHxKUiuDd4cC0fRb/oNMEqToLM4mdtLK5MhG1Kfuv1y7COSNO7jINQg79MNd44PMydB4dwdzmREM0RMYEaPe8ntyzdrbFlEO2ucisFHxNb+87vod5/ksKNbpIWPyI4tgPMutdtd/zr52/Gg3EGOJr8rTkw4Yj9atEXWogXEm3PQdYOQxXyZbGzaqX6sYnrTAh+KRVpOpsQXXXsjNayPKatUqwI93gsOb9m+3ETE+rtiRNMmWGacj521418jhK264qDr+GTrGd6JWhnTLrjPZ1/4G7b53qT66MlrRZV1nQVtFglFP5PpxJ0bzKfJH1r8uHEA4Wspsjp/mvgQaIV0JkprCbqdvHqkUQX6UjAZA4MuYjjZ06AUvLinVpIgHw9hKTNDWNpFlan6zy0ux2zkNUOlBt8Smf6pT6TWb2RFKfmlSJRk68llHoNMeAU7RdhIUVxAmRX4xYlVNFJXmCD5UhnFgkCLconv4A9Vy7ZRef2K+ig4LDM81zF3elF+UiaYGfHFl/lrgLufU6klXyRBFA1Yvzsm0HgldTlnEm9kryFRo3pXkavGQDL5SfV9js0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8676002)(4326008)(33656002)(76116006)(66946007)(64756008)(66446008)(66476007)(66556008)(122000001)(38100700002)(2906002)(38070700005)(6916009)(5660300002)(8936002)(54906003)(91956017)(316002)(36756003)(44832011)(6506007)(6512007)(53546011)(508600001)(186003)(2616005)(6486002)(83380400001)(71200400001)(86362001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3op053oPt+Ecuq09a0V9of8TepUbAO/BTHb/DmZLwt8YvqJAYO+VUzqRy8VW?=
 =?us-ascii?Q?R3m5NhE/XfE2XE/ZRZiFOJAsFaaKjKmH4Zrr5HP+mnBbVVOef6WgJsFwaidh?=
 =?us-ascii?Q?Cf92Kr6kwGT1yhGtERYYAvkDEhHcZyI6rEMBnryzWPKDD6gQwpg6UqG5zUiX?=
 =?us-ascii?Q?xWwSouE4u6KmsfRhaOGy6Npp6FGTMPm+LiXALlTfhMIiu18sGxU7jPAem4EN?=
 =?us-ascii?Q?1J/tZ6RReQMYDJ8eU0zpVq9MSeWxf4q8zz/LaFwjkxGud7LtPJR92HmNv61s?=
 =?us-ascii?Q?LXGj9OW2YXZeHBR5PUMr9dofXg1V+sxZ29A0oCK9jJHsPzMH7Wof9I6wqMzh?=
 =?us-ascii?Q?z5Y3DR68uGXPaAcCay+GvBK9ZHmrcAEOLEKIl9WEcysvxEEFjmFlJ4VKdknB?=
 =?us-ascii?Q?RF2tfd6xcNE+3PPbVixFq8/i+s4CTv+YGpvBEN7YBaA3Kn/1xau/izk90NtW?=
 =?us-ascii?Q?XdEG2t/ozjCxbqBU/KWsOJMS731GNfiOahZA2FbxiYQ6/3p0TXDINxRGUiED?=
 =?us-ascii?Q?dnMA4F6QpBLjtP8WqHKgUQJBaKFN3P3NUP4/FzP/o9x62bVcHYF1RkX7cQBN?=
 =?us-ascii?Q?kobutJPLmH5+yqo9ZVriWvwOl+zalu8ShgqgWf7HvC2/5jN8FtCkuf8zgrwk?=
 =?us-ascii?Q?54ZSSg97XUEOa/cOO9xHGpl+1cYuGN50HMNDiZ16qUeloFJ8PTYb+P6tM/C8?=
 =?us-ascii?Q?sLLhmOz+ZyYX65UbZ/wQtqMT/UaWzUi0YuTwHadFExv2xwf+3SWIM1IsPt+D?=
 =?us-ascii?Q?aZH0LVh9miScZbuPInWpG7WOaQj/PAiCptBmLPF9o3F8EFr1vEJQxTgtFkM0?=
 =?us-ascii?Q?gE6f3p5EpH4fRCBCL5O5AcDfeGuU9V6Q0fgRUCSC43aWrLmzBJwd4m7n9OeV?=
 =?us-ascii?Q?Fnjfg2kMUIGl0GzTSQs1RnWO/lxQg++VZb7ZRnMsjcNEjS71ZwrKikuQxwVp?=
 =?us-ascii?Q?1z/HirmLdMIpPt3i2YYfXmH00gFxyLEjQgqSjvkGGvzu2CeaBN17os/zZzHW?=
 =?us-ascii?Q?HyeQWJQNsg3h6FtGDYxTP94CuZfW+lNrB/FqElen6QjYfG0s5cZjwVKE45SZ?=
 =?us-ascii?Q?lNoFTIFKRT8RpUB311q88AzWc7enUhrrEFRqdLlsRBGBXWzoJSl3VQybD0JS?=
 =?us-ascii?Q?KGfIymosyrhTKAYTBIFEznAZwjF1tzswyal12a06yk9rDCeA6DtOwwPTc3G1?=
 =?us-ascii?Q?mq9VxQiKRLu5+Tu/MmHK6yYRMVO8U65DkHGiDF2aWiXRGSyG2XUz1HFNDDdu?=
 =?us-ascii?Q?/FQFeOh2BcQ1zGSw5JAmC9/Ha4EquWSqhUXwrk9XmBwKEr0LnFY05FPd6wnO?=
 =?us-ascii?Q?x2MK5qdNW8FTr27zVy3P6iHxP5ZHtdJR8Pj8u4IJrJpsgzoQcdWF4b8MvlO/?=
 =?us-ascii?Q?adERu8nwBOe/EBP44lMpDVK2+o6DQR6kx6knvdz+ZRjWu/vi4UDe5zPO3ECn?=
 =?us-ascii?Q?WE3mqoDESq8+nhAAtB6oTZUlfPGOvEqbd6iqBkjnuRaArUCSIJ64k/mv+zlD?=
 =?us-ascii?Q?fJcUnmVYMsFVU9nIAkv/30upkO/X8luL+/deuXmqwTpeK53WOT2zScn00FLg?=
 =?us-ascii?Q?ZEybAdI7Bnm22B8UdSUz0OiePj1ELeWxe/D/2ofVDAT/ZSmEHqDof6vf4oQv?=
 =?us-ascii?Q?z/Ogq25iUhHFJxx+W4rplUU4H047m0eXituXIHuPT0hinZ+sT1g41Fu45GwM?=
 =?us-ascii?Q?fghxVfrQeG4p0Io0KUF1uWjYjoVCaEFSWMuvGgSfp1wFtgJb?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0D72A2DF0814EC458CFF54A520AE3E39@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bd78e20-b010-49aa-48fc-08d9ebff0018
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 19:04:29.9321
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P9bf78fHGKIV05d2Uv81oe6rxYZjCngdympVW4S7OvQCoHkRIyt3dt+aI8YOGo1Y+79/dHUr01y7oTLjeKtF123VfLQ7XCI40VlCZVdA0NI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5311
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10253 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 bulkscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202090100
X-Proofpoint-ORIG-GUID: W1x-Yw36IuiqeNoCViqjxRcEJ5zHecpV
X-Proofpoint-GUID: W1x-Yw36IuiqeNoCViqjxRcEJ5zHecpV
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Feb 8, 2022, at 9:25 AM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> Move the DMA handle into the per-command private data instead of using th=
e
> SCSI pointer from struct scsi_cmnd. This patch prepares for removal of th=
e
> SCSI pointer from struct scsi_cmnd.
>=20
> Cc: Ondrej Zary <linux@zary.sk>
> Cc: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/wd719x.c | 12 ++++++------
> drivers/scsi/wd719x.h |  1 +
> 2 files changed, 7 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
> index 1a7947554581..f341b79d8036 100644
> --- a/drivers/scsi/wd719x.c
> +++ b/drivers/scsi/wd719x.c
> @@ -196,7 +196,7 @@ static void wd719x_finish_cmd(struct wd719x_scb *scb,=
 int result)
> 	dma_unmap_single(&wd->pdev->dev, scb->phys,
> 			sizeof(struct wd719x_scb), DMA_BIDIRECTIONAL);
> 	scsi_dma_unmap(cmd);
> -	dma_unmap_single(&wd->pdev->dev, cmd->SCp.dma_handle,
> +	dma_unmap_single(&wd->pdev->dev, scb->dma_handle,
> 			 SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
>=20
> 	cmd->result =3D result << 16;
> @@ -229,11 +229,11 @@ static int wd719x_queuecommand(struct Scsi_Host *sh=
, struct scsi_cmnd *cmd)
>=20
> 	/* map sense buffer */
> 	scb->sense_buf_length =3D SCSI_SENSE_BUFFERSIZE;
> -	cmd->SCp.dma_handle =3D dma_map_single(&wd->pdev->dev, cmd->sense_buffe=
r,
> -			SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
> -	if (dma_mapping_error(&wd->pdev->dev, cmd->SCp.dma_handle))
> +	scb->dma_handle =3D dma_map_single(&wd->pdev->dev, cmd->sense_buffer,
> +			       SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
> +	if (dma_mapping_error(&wd->pdev->dev, scb->dma_handle))
> 		goto out_unmap_scb;
> -	scb->sense_buf =3D cpu_to_le32(cmd->SCp.dma_handle);
> +	scb->sense_buf =3D cpu_to_le32(scb->dma_handle);
>=20
> 	/* request autosense */
> 	scb->SCB_options |=3D WD719X_SCB_FLAGS_AUTO_REQUEST_SENSE;
> @@ -288,7 +288,7 @@ static int wd719x_queuecommand(struct Scsi_Host *sh, =
struct scsi_cmnd *cmd)
> 	return 0;
>=20
> out_unmap_sense:
> -	dma_unmap_single(&wd->pdev->dev, cmd->SCp.dma_handle,
> +	dma_unmap_single(&wd->pdev->dev, scb->dma_handle,
> 			 SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
> out_unmap_scb:
> 	dma_unmap_single(&wd->pdev->dev, scb->phys, sizeof(*scb),
> diff --git a/drivers/scsi/wd719x.h b/drivers/scsi/wd719x.h
> index abaabd419a54..966ab0fb4621 100644
> --- a/drivers/scsi/wd719x.h
> +++ b/drivers/scsi/wd719x.h
> @@ -56,6 +56,7 @@ struct wd719x_scb {
> 	u8 flags[2];	/* 62-63 SCB specific flags (local to each thread) */
> 	/* everything below is for driver use (not used by card) */
> 	dma_addr_t phys;	/* bus address of the SCB */
> +	dma_addr_t dma_handle;
> 	struct scsi_cmnd *cmd;	/* a copy of the pointer we were passed */
> 	struct list_head list;
> 	struct wd719x_sglist sg_list[WD719X_SG] __aligned(8); /* SG list */

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

