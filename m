Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BFAAC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Apr 2022 01:58:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238674AbiD1CBa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Apr 2022 22:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbiD1CB2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Apr 2022 22:01:28 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 142635D1A1
        for <linux-scsi@vger.kernel.org>; Wed, 27 Apr 2022 18:58:14 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23RMf4nS003733;
        Thu, 28 Apr 2022 01:58:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Xmodq7ix8sTsEcWEoP84ATKqUDaLZjhCGuQ5p3uAlUY=;
 b=Ybsk50aitmU1slQWrobHB8qRuqU40qhiXwWhdLhPk4p6OpuhR/obmCObV4/+VZRQWIpy
 xcOJ2ANLgxFFGC69GslqiHhyXukX3vjtjt1emWrommCk4486NM6Ii+h4EWy1agY/TZk8
 eL/sp7sDib/9Ck4mpbnthpDKKFc0F+hRj1opJqzDpRHH23alZPSO5KGk44PTtbSFQNYU
 qwO1d0QfdmKYSi/VoZhNcpKcXbfoqA9r/H8z0Juo20j+p2FHhiyTrTuAtNnTk0sx611b
 fgTUYuFWGC6rxFkJs1s8NtPhj+4/7Ins0EqcE27A9wU0DhE8I/gzLpGJzKtyKXUCP08I 6A== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmbb4t9y9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 01:58:00 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23S1t9Ev032621;
        Thu, 28 Apr 2022 01:57:59 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w5t4yy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Apr 2022 01:57:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mGCQCfL++1OFjxVhbbi3twgqeLbZpKQ1otx1nYD0ApSl+jhwviA9aaVKJan/tIn6zEoPaPyHFhcW4bzCUse4AXfKdFIB72ABkWhgpQ5dQz4jSj9iyM/HFeoxC1ZzTw+zRuknskdhrnv4mBg3cqObr5a+n1Q0Kkj+R+fp8LrirzOKZBgddYJIqgC6VwiQCQf8bZusJ9JMGNKfs+mlFFt6aBZy/MlJLL40ET70tdqstlOms4cy/mg1s+W/thO0roCR6V13jphHRGuPkI8DiAe0vHZXLcan/crVMR07c3f0J0YJui20beta0AxKi3tPpskOIm98sN8aq0WImUDUTnXPPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xmodq7ix8sTsEcWEoP84ATKqUDaLZjhCGuQ5p3uAlUY=;
 b=enbLP2rYEH7NFtjc/LC8kcT34JGwOvgQbdDf18VpfcPjaaVAuXY7MBNQKAmOAKLxzIuQgxGbfd28S48UDwggJUHMPOfKmMHIVY69x+SQgkd4awv1Z51CAOkS3T1hYMj9TbLpCP/tQkO5XfTbEFMj1IavpceN6lLAtNWnP8zgQs16njqkOXL6SuzACJW7CHO/Gmw/fiFFKjel8JyBw/DZpbVQU1N2pFTfeWMcx7NOiyggedyD2ARDIOFqh0RmFe0HRxVfw228D1jauFJibrGLvO3b1G26GiL66gKItXyd6HDp42XzOrt2Ll/PJCMjsvlIglmVVsyAcLwFMn1JXPzijQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xmodq7ix8sTsEcWEoP84ATKqUDaLZjhCGuQ5p3uAlUY=;
 b=V4vjrr6Q18tX03iJEsDH5x9hr+IXxHEUWawXxgRpAufwmCLAPwwIBmw6GZrUEpE9mkMsoXTGbfQCt8B6GECiKpqqOQWCMiv9sHq7YdrvsRUeAqJksQ1dAsPRziwnhcKQ2KW+WKvbYx955SNly/DM4xrb6MFB3WYR5Gl2qnfIyhU=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH0PR10MB4891.namprd10.prod.outlook.com (2603:10b6:610:c1::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Thu, 28 Apr
 2022 01:57:57 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192%9]) with mapi id 15.20.5186.021; Thu, 28 Apr 2022
 01:57:57 +0000
To:     Sumit Saxena <sumit.saxena@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] uapi: Fix build errors in uapi header scsi_bsg_mpi3mr.h
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a6c6km07.fsf@ca-mkp.ca.oracle.com>
References: <20220427122622.543126-1-sumit.saxena@broadcom.com>
Date:   Wed, 27 Apr 2022 21:57:54 -0400
In-Reply-To: <20220427122622.543126-1-sumit.saxena@broadcom.com> (Sumit
        Saxena's message of "Wed, 27 Apr 2022 08:26:22 -0400")
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0009.namprd13.prod.outlook.com
 (2603:10b6:a03:180::22) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ab60fe6f-8182-481b-bff6-08da28ba83db
X-MS-TrafficTypeDiagnostic: CH0PR10MB4891:EE_
X-Microsoft-Antispam-PRVS: <CH0PR10MB4891710324355F37AA294B258EFD9@CH0PR10MB4891.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xFVyE1c0iQuCgRPPGmQ0u3k44UxUlPqI4aaXDjUZ+GU9LJCWMO+mevHEZMsFd61C4ICLjEEJQY8dx+cp399mkTBMty4GIp8GKULM7JelfHBHt+sdSzeqPX//QfOLVGLoyQ/vhB1Nx+hjR2uzguZd9pB1w7UudEg4MfM7YnLz0rRXq6Axl8QKyHlC43FXsWXAI7qyclgLMPf4MD2boMNVigwdNOszrdDRAdIAmwWKhvju5LF9aKRGbLlkzuo3fKDA/5rGu/8JZywaQMVwGI7AzJJbR4HsElo6dcX1LHPp+WTcCbSaVSwU0MPfI+x7Whd310Yun6Ai6JPgiwJHkyoB6IMj0ub4R5qarN+SJqD6KNUxZUG5IqAZyVYTdkBvvQEZbqpoi3rAg7rEJpumuRimfJKjH7riLzaifv6o2mthw/jtrQRvFRk75NOyLncjIytqB/fcN1GNS1ZXkynnB5TIPV9ERVwzNGOkD6lFprdSraFWbMaPnHxyy+LaxN3I7ltUDW6X7q+9XMtelV35D5OhiBXmHqfKBWOLSLRMqaY3CeAdXjstKLFJVY/D0kCxoQ9mNWbYYDW0g5t/RV4tBgL8r5MF+XPobFmLGRRID2f5AWsKJybvg6pJWwfw/EQQHfhfDzokBHlUM9s/Iz8aTP5IY4LhuK9nXYyelXFZZUk7ukYsQve8Mq+jQ3gaDWidwNfnqUiwxEs9up+zxyKMCvc5ug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36916002)(52116002)(66556008)(38350700002)(6486002)(316002)(38100700002)(86362001)(508600001)(6916009)(26005)(6512007)(558084003)(66946007)(6666004)(8676002)(6506007)(4326008)(5660300002)(66476007)(8936002)(2906002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ykgn/QbLb70iub5EZAXsn/xmPgZvPBaoj69DBTMYTP3wkvxRUw+lDYzEzSgW?=
 =?us-ascii?Q?GB1TWnMQkrGKNEy1QTgjcppx4UHzZBIVHMo96RMKeCR69CReYt95p03X/iaZ?=
 =?us-ascii?Q?s2zATQUYN3ncpsAlFlHao54sxRBSsQ6QWe2WpSCkr6hfSUJwiVPvyoVtZC26?=
 =?us-ascii?Q?br59WvAZm9FT4sk6RqL2iRlYNsb623wgaTRrAEGTtjZdQqdTyO1uMPEg/8En?=
 =?us-ascii?Q?j77RBpuTBMJFoM+fOdbdRS19r/yPF6sUM+KOfb4wFT/DvKSA6wPpBS2AgBOE?=
 =?us-ascii?Q?KO2dYbbxwrqRY/dr5Pu81nW1BILYbaDl2V/Ws8cnByEgUAlGYIaxT4m1tfoq?=
 =?us-ascii?Q?hQQfOjgN0NF+dEYgEmtejkj6lQl3lMpAyNZ/tvR7DqKWfMufxY/+hLN815zN?=
 =?us-ascii?Q?2zypIYRuKiKw9hYPZPfaQZu0DRfhOP9uLyYpHNz9MwwoqiTGjWdwYCAJulDF?=
 =?us-ascii?Q?pM1Bsf5Jujd5t33zed1z4mdp31qaqUEoj6ZcQiFlx5KwsT7cQAr2pYb4aS4j?=
 =?us-ascii?Q?/DKhYJG63cNE5q8rg+9aXXWJUV3GgyqYXBm0nv4z398YigG1J/NiHrK6nF8+?=
 =?us-ascii?Q?F7aQDzoim3xQKdnPj+ib1lgMaI9MOWj5sFGzEDBWDid7w9a/NBzKZRpP5mTs?=
 =?us-ascii?Q?VxhZcW4xNE7F3nJM4qrT3CRI+azbv+tkWk4t64fimdu/48nYBPkWwP+/Fj+9?=
 =?us-ascii?Q?azD140onh0XACbnQjjdTqL7+joX/zB8d0r627kvynHqsvmSlP447RZFlF+b+?=
 =?us-ascii?Q?vwieTvCt0HjnzXNkcejjmmX+z7Y34ip533VWip6vChcbDMZFpraxKxA4Jo1d?=
 =?us-ascii?Q?ypi+rynUyUsGsoiQi6xjIVkaP/64OX+fXL2LPGqwgi4Vr4if1erFdZrKQjj/?=
 =?us-ascii?Q?6D9tnsPYAcut01OXMak4NgKVqqPpBbSpzYAXlvxfAFZ4NrygPRvBfZAOVc/2?=
 =?us-ascii?Q?pH74fJv3sUoGy+tvrFDwgjuiymVjmgINbqKczSFwOSbIoHZRM6xOPSwoxU5h?=
 =?us-ascii?Q?krsm4E9HutVt87xZghoYHNR3XmvEblGgKC7eZaFS+IQqoFoW1SvEpYa2zfNX?=
 =?us-ascii?Q?1vHt5nYoL4I1z+O/R8ignC6d0o7oU6psS8Jd4ddP7pH3pJZMv3+Hwa7QGuA0?=
 =?us-ascii?Q?nneHfPZbHzM6zsm5L7XAIlr1CWgSqcTrQvnbUvOud8jxjoz15sP2+VVZYuss?=
 =?us-ascii?Q?PJFPpRdIDFbZ2OiA863HkX82FhVgJ+kmlcPql10U/gl73UEOe7iGh5hMT8/f?=
 =?us-ascii?Q?H5JQXWyWXRixjypXprkh1iWQUIjBefMn9zlDJBxwDMGh2jDDLtpjRy2odAoA?=
 =?us-ascii?Q?2tLlMd7fC+vMhgsLD5oHxxFlhmf/8t2opFR8+YOjiLpDXhu4VX03MZ4uq6eV?=
 =?us-ascii?Q?c7ly51iuDXl04ZeOsRn4ICDl6Q70NA7HUbzf0qY59nxCca1yLPOCnkGZXX36?=
 =?us-ascii?Q?GOcZ8gtdOCVLZj7Oc/DmiTUS/IGKLDIMan7ie9tBHRUaGhCDY4RLRBfZfNrj?=
 =?us-ascii?Q?epYtMXoyIGvZtGzN1CSKmsi4k+yQkySNRcHMY7oi1GTj7Z5yNb+GsGuIEGPQ?=
 =?us-ascii?Q?HyTQBC6iRdeVjznXLhpWDZzU6M9oHi7Ipcozs/XdcUedEXiciTxx+C/iG4TX?=
 =?us-ascii?Q?lztNFq0LgpVAA6/fD7DuSmtDDlfVk6uEQqpxByNsthPeLTLWaYT2tI/n626V?=
 =?us-ascii?Q?JIt66vtBHuv2DmTpCy9nmT6I2PVRSn2IiKr36CPHPCf2DIhaS28dB8UXHNuC?=
 =?us-ascii?Q?mO8FEskFl/3NQ0+dKQ9HgnBLVN4k7yM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab60fe6f-8182-481b-bff6-08da28ba83db
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 01:57:57.1653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uBZRxPVscij1IP11+CLoRXqr3wFkTLl3EUAGDRy1/GNQGtqyPqbWJQtPELzNRblmuv+LmguIPBBorUsRIKbx0eb0Yk3gRWY/doWCPhgnOl4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4891
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-27_04:2022-04-27,2022-04-27 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=716
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204280009
X-Proofpoint-ORIG-GUID: 6l9xnu0oQnwuEKdcBZc6BY4D7OfNeohp
X-Proofpoint-GUID: 6l9xnu0oQnwuEKdcBZc6BY4D7OfNeohp
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sumit,

> Fixed build errors reported during x86_64 allmodconfig and few spaces to
> tabs conversions.

Applied to 5.19/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
