Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0E0EC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 17 May 2022 01:48:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232114AbiEQBsF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 May 2022 21:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231584AbiEQBsC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 May 2022 21:48:02 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A86AE27CEF
        for <linux-scsi@vger.kernel.org>; Mon, 16 May 2022 18:48:00 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GKYMbh009889;
        Tue, 17 May 2022 01:47:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=PKUNE/atyb2tumzggU2HuLBgM6cruR4j1tTseoT15sQ=;
 b=SW4H6kDJBRHwOu9YA3ATz/Lzf1Si3i4TLkLcDgpm3z2U/EPQWwgb2EB4Ak5bGy2MQ6Ym
 DLzroxd/N8xXklMzkE5y9yp9DH3DPP/CRP7X0XQliizn2XPdCre5teUYBA7GMzdz+aSN
 rFisQ0LzU5B/aYl4u8CU7b14Idqomgw19vSs6zcv5hX5agb+K7GykqDkij7B4PrJJtx2
 TzMtS1fIkR1OrAFl7aWalc8wl5HZ+2t7/hNvFQJpJIP9zSEC9wkdgmF+xPBLbPubZgga
 QQaPtsLYNXge/QpBeo0HO1IvcJYVYcDQfDJrcJHfDUpnn5JK7lCNNwaiVAVXu3wJVOxH 5g== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g2310mxas-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 01:47:59 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24H1jeEO040594;
        Tue, 17 May 2022 01:47:58 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g37cp39nq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 01:47:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QwqBfFEWn6uTmUU0CzWq6KlA0XJyA2uiXgcAme4URV0l46bJiWra4FMfyQGGzIsTBm8JYRal74SVC+Iwly+jDIpj4NA4cCB6N382fD70XfwKMuj9PCQEAMUQMGazfC70hcHWVpYDwPFTOuqPTbisJK7tq9nqr6hsxVoUw2UnxiDNy3tahVAJG7AH+YP3+jTz359VxFUw8b8gGtb8nmAmIVBpEMsutPJOzClvaID21hQbMuqN02Y1ucWhPDxl7eyygYjELutAwVaSA4nclaiFPe94+vRHME8+GbqNj+C01TByFYGdSwM7+qwyx/fj47M5dSnJ2J5+/9G82uEaKlfYqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PKUNE/atyb2tumzggU2HuLBgM6cruR4j1tTseoT15sQ=;
 b=KDGuUvnc10wb/CCj1fKYsVTGEzm8hwQ41gsf9mRBLerPMhSSBBIgj6F2x8l96h6nbEj85ij5k6uU3CdGJU1B00LQpknwq58HzOlVwlX/+6lM7fnjXfo9SN1v+CWdExvxsHU+kgLc2h+Ho+CQjl3rjF+e75a1E09QJqDDee6Xv0KlreR9YcZ56T12Kd4Hz4f4G47pBSnb53ddkZtNz6Cs7GU5VBRhp/2Mw/tGN/tm8L5lAqEMpWthiKZqho6yFLoiQw3XRJwz8kkCjjr5EzxCeXjfHG5jiDtMUW0FRgXgEn2cyhsQe4LS/odc6wWNN5jjKRJU2sZEeD+oJXRpWFP0LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PKUNE/atyb2tumzggU2HuLBgM6cruR4j1tTseoT15sQ=;
 b=DTZFNyFW/EhEwy1+tH5NvKrYC3MVv4s7eK26wO2V4uduhSC+1cEbRUtpnBJCS12wjsjLTpqudB+8gHDSXB+yUQn9BlmX1zLgZlWfUPPrDJCXDoeFRODWy+yd8lz2mKd/gX4D3ck9DEQEt7wNe64dVNlqxejHpmNQbS2XsLT4sC4=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM6PR10MB3772.namprd10.prod.outlook.com (2603:10b6:5:1ff::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.15; Tue, 17 May
 2022 01:47:56 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192%9]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 01:47:56 +0000
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Subject: Re: [PATCH] mpt3sas: Fix junk chars displayed while printing ChipName
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1zgjhq6bl.fsf@ca-mkp.ca.oracle.com>
References: <20220511072621.30657-1-sreekanth.reddy@broadcom.com>
Date:   Mon, 16 May 2022 21:47:54 -0400
In-Reply-To: <20220511072621.30657-1-sreekanth.reddy@broadcom.com> (Sreekanth
        Reddy's message of "Wed, 11 May 2022 12:56:20 +0530")
Content-Type: text/plain
X-ClientProxiedBy: SA9P221CA0004.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:806:25::9) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a2f2fdb9-a77b-4464-49b2-08da37a743df
X-MS-TrafficTypeDiagnostic: DM6PR10MB3772:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3772FF7DF31C5BB5F2027CC68ECE9@DM6PR10MB3772.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fSSX1/I6cp4IAfpbIMMjF2OnAof4n+mn9KOqyyA4ZVW0ptW0Nfe7udmmgUIKqhhiS7PEYmAE8NVoqxlUgr/m8OuezEWZi8SLv+L9YRt6DKsJc1qrjzCcBNFTBn0D2LAmW54h9cm/0I/nRfzAfBcAacgJB0xSItmobVt6WUIpx271q8K/gaW/jUchZkJuSnGRIHPfqY4rvOv9QLTrniQ2kkpXK9F8Xv7WIIfDkisV0UK8TcFitpqLC5eloEan5XKcT+m1SMrKXpzRz8Is8OaMG+4O9tG2q0mxMnr4SVpM5HKSnU5zyLi3zagZDh9qMeZAmbmVvbPS303MYoV+qjBGCggtdAya60DeFHFytLQbzbt5swq4ImdV52bru1wiW6j3zCWtEsZr+AN/2cm6i30N62/O1tn7IaHCcfqx4zeLVNXQGQNwjRQ3e/1Yz9kdkDkOQ/9BT8Iq4EhxcoR1IUB/jwNN4JYThoFboFd3j4QXpiYQx5lsSoVHFUfAIRKm/6LCptxdTxozA5conwOYjVDBNrzry43fKCCokRZqT3ACeBFL+BOCFLGzKZZghZqckqUbVYkTtGR+c9CVvhJZJ2o/6FTx+D97Q+QfTKON+k+RscAqd1y6ZSw5kPlSECX3fGBUwSh3eC2PLbUasKuW84rxwEwTj4Ckf5k5RgTT8NOwaU49Xzx6clJXXBYJEY8kyUaLx6UqXmWvyQBBVdEFZrc97LvQkbY2w0YDkXSeakUxTp8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(66946007)(508600001)(8936002)(4744005)(4326008)(66476007)(66556008)(8676002)(86362001)(6486002)(186003)(26005)(6506007)(107886003)(2906002)(38100700002)(38350700002)(52116002)(6512007)(36916002)(6916009)(316002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8uasaec7NuC1wMx3GoN5AtiEdnIZwm+L+fH10Hu91UXRbAcEEaxlDLZ1y0tO?=
 =?us-ascii?Q?uk7k6A2tAQkDD1ELUQYc+wXYzZMo0POXR81Nf6LjD2PCVfwPLzqxauHDQPOT?=
 =?us-ascii?Q?DlZa6Kxp1gnUiuTa2w62vHueaarMjK0Adv9Hu9X3vpn1nWT5AyLoOti0+TFt?=
 =?us-ascii?Q?1UvhuIPIwS+HxoH4JE80GvArhAxK5TVaCATf0RvYOwO8kjE7pOfncctD+32Z?=
 =?us-ascii?Q?kO4FTVT/EV/NgDA3IS0v4AxJI7DJw01bbF+JaOKIytoSKT/+JwjxQKH9zOov?=
 =?us-ascii?Q?XxzrMOT9/G0X/fghg6TIUV6JQpFZNSwGzetQgiVrSVdZ2wcnvsV9D6u1KMXE?=
 =?us-ascii?Q?SNMPLjCEu0F3/ZqBl4sUlvN5lANhN9gj8hcEvzD8xCQG9MC1oJm4IHYyNLHi?=
 =?us-ascii?Q?+bSrqV5fsgLanuUcmequ1OOt18tomt/xC3a4+VXhh1C8oS5uK4/nj0NDG/iC?=
 =?us-ascii?Q?c0AyPxzqjGdzlbO9nKHgSaYROImEF2VTZ6K9Z7elh/A7Za4cCc6jDu6TR9Sg?=
 =?us-ascii?Q?j7mewK/uvQEGfKrHjcXVlEyxzEK8IUEuugFtMsxoGsivTHyf7rInkdxQfbS5?=
 =?us-ascii?Q?y4+nwhQAhxM+k+il10tsg2BcVe81lsxPePVHMxBsHUMvqPr0FrBnTiN/o0f2?=
 =?us-ascii?Q?X8eBhGyNOj6C1sv3lQU6Z/rDU6n2XP0z6NQ8CodwqHtoYW+TYPI+/7J9IZl7?=
 =?us-ascii?Q?BNwwAenXSHSGLIKxeW9hJ6jKlT55ivep6c2Hg7DeaYXkO0LiBffb1SycIDS3?=
 =?us-ascii?Q?WVO03ucB24GDS5QiP5lIjwmXuJdMJctpnJ1RMa1N2UWqcdoM7GaekUncfEwb?=
 =?us-ascii?Q?el4w1yOhTIni4oNgFWzjXAvXBIvR5FA8I9tJnSSbkamRGCYrOzO0jlmI4DQd?=
 =?us-ascii?Q?CObKBmJUzUNL1fuVfwrPKJfZVUbTFyWAI3iPdolrTkWrBWuigB+pgERMy7er?=
 =?us-ascii?Q?Ss86i4VRSyUTFWKvo0UOhN7dapKCwQ++tZd/eMxkdEeXFo0GOemOd7Skpr//?=
 =?us-ascii?Q?JGFKUDOQCmLAVqbIcukpYHN5xoHJ94qpWEOnLox/2lcs4dyuloBX3CEaqRnf?=
 =?us-ascii?Q?bBrEfB5AsEPtqPCxMSoqV8av6SLV+UKd+SwK9qIEiehamya2ljNbcoL6G3Dx?=
 =?us-ascii?Q?ww/Wt128JnQah0SEzbc0JwRgjeVaEWhfdq4PNxgJIxB/k8nTqyGtkzSxocBL?=
 =?us-ascii?Q?2I51RGPuSOJkvawP7YSM7i10Dea8YlGM0hQvbSM3Qu95KrmXMKDzX/RDcp8B?=
 =?us-ascii?Q?ywDnb+UtOGAyvUQvQDb8DWB3k+yC2DM8NVowyHyOOWY+Wlmn32OaY4qzy7yo?=
 =?us-ascii?Q?Mwsa8nHnbvFSZkeGJYsLSES+HkfeEy7CLLQJNOt54f+3Li5izpMiuUgPUpt5?=
 =?us-ascii?Q?YmIxeRjutmetlnkzqxltwK4wEp+HuoQv/ywnB+d8aQ25EBbbNL5KoDdlI9MH?=
 =?us-ascii?Q?CXSMJXwkayBUbiWW2ZPkFCUcOCNXWRFqdIrLCuMxyYoDtIo56nMABHkHBmhu?=
 =?us-ascii?Q?DkOX8RfoZO2e465gdCBWmHJD9q20sCqETvNyTOZBm9IvKvGbzFxmnTR50Lpb?=
 =?us-ascii?Q?/8DFAVzBtT5R8S9ZhssrX3wM59vbVMwMhStgeUGxmypdkoFdQrB5DQ+kn+d5?=
 =?us-ascii?Q?hImqKKRg+VzOAn9xZ6FHCpIEVf7HxfZllKUfXJqBbrG6VtI0CHDnroSzHSUT?=
 =?us-ascii?Q?akyOBTDoHVtTsN5HLklIajflSAdPZ8wCanRy/Dy9RTeiCqTCz/RzW+g3XTv4?=
 =?us-ascii?Q?KML29AyirfklKM/lczCy5/oEuEcEg/Y=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2f2fdb9-a77b-4464-49b2-08da37a743df
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 01:47:56.6304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ssZQtK/YswaHXOQ646YYFSmw+CwtXN9Gu1BC1MtWNh2GyC3DF1sHAEuKZWWoGvticQ7Fbnolr/HDaH9gPFynYA3mg+H96BdvwORO/nOnQbI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3772
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-16_16:2022-05-16,2022-05-16 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 bulkscore=0 mlxlogscore=881 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205170007
X-Proofpoint-ORIG-GUID: Lf0Ms05hdzRy6g00I2-iR-3wy2yjoW1d
X-Proofpoint-GUID: Lf0Ms05hdzRy6g00I2-iR-3wy2yjoW1d
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sreekanth,

> Make sure to append '/0' character after copying 16 bytes
> ChipName data from Manufacturing Page0. So that %s won't
> prints any junk characters.

Applied to 5.19/scsi-staging, thanks!

PS. Please fix your patch threading. I always have to apply your patches
by hand.

-- 
Martin K. Petersen	Oracle Linux Engineering
