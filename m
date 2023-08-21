Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EF33EE4996
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Aug 2023 20:28:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbjHUU2P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbjHUU2P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Aug 2023 16:28:15 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFF0611C
        for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2023 13:28:13 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37LFxuun013645;
        Mon, 21 Aug 2023 20:28:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=2MhJo/OxtnVesu6VFaaLP4mQPV2Dv75ExXJnT37zMrw=;
 b=BLJnAUzJTS1W5MdS8vXUgzXnoWvLfWxDo7pUFS0t2otklVA5pzG1c5jjGYnec06Jdiih
 0ZOQaZ5PbB+Gxl92X4Gynu96dK5Co20WyfUK8VQPGPBDRjua0oVevRQoHYLYingsPbea
 qQmyXtRXVN9Bx4zmLL2G+EDjdyJ+IVNZo1v3EnPkA/LWQ2j39RFls/la+h4s8JIpint+
 V4DJ9xozfr9WIochz16wboOcnyy+1Hz2aGzBUoNPxMv88oNUUR6Mzn+I8x4dx9dLXoXt
 S0u2X/y6BSIoL//lHb7APCt+5YQOgoZiqr3DWYKCYJcApYAYJdKZeYfh2+rF+ZqxTnoj RA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sjmb1uuj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Aug 2023 20:28:08 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37LJnuPb026633;
        Mon, 21 Aug 2023 20:28:07 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3sjm646d8v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Aug 2023 20:28:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VzFa0K7Bg233Qwa7F3edrcuLBFfCQ313n7bYUVYCJKHI5OCEnmx34IoiMjuWv2jbUFFPWd+cdhG0DIblxS9q5c8mxv667UBHGxFCaWMpJHXsXn73wnrhAuJr8nvx4z5JK6r8t1h98Cmxsbj8Xbxhp/bv0Tp2o2rjYgXmloQMbz20Psu8kCFgtTMofvPUSQhhctv6TGeINx55ykucMGRbBr5sJDBg/PtsH92vPWrhXlFmwdMeuY+qPnZmnM8OGOC7LuCAglDcHpm0vVS1I+xs2Z/jXf6daRlD4AbFSEkbTaqU1KOOkfeuvTjqkYIajG5Mo1UfO429auuSrZlq8m1AXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2MhJo/OxtnVesu6VFaaLP4mQPV2Dv75ExXJnT37zMrw=;
 b=ZzF8jFT6ZdPngxVdJedvMbXJxrMgDfQenIQ63W2ddMTdPfrkDu0/jPGstIRpPhZtaZ+d5ZZDT+F30hL02cR9bKYUvY40EdRHzs67uri3JxQ5Zk/+WmUBKcUHK0MtQ26BJlmkpZu2sXXt3C6EIWE8Uro4CFUx+jXRgpQGbNs7+aXOMoWaYLXpd6D2E+cuYpiJznWdK6ckUcQGzFg1KBD4rqG73rS9lMj7/xvAjPxYi+UWG5ZnvA0RRuxt6d9/p+sL7vW7gLlbfqGEzQFrdTJYscdz7xYWDmf/NyFsRyb4akx3IEHxysTmXVHEUsplFue2lb6PEx82cAnWdMmBnpbB3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2MhJo/OxtnVesu6VFaaLP4mQPV2Dv75ExXJnT37zMrw=;
 b=zKHDfY7k8TA0AekpYzT3gNcPR8ONMkmgvd3YiNj3HPanOCERd0sr1zQWBvoiBIDKA7FxI1brFSbiV84bORd/zp/u9xFuanljb5B8357cURnFDVXKq8qsLMOHY2nAWDo9s0oNYBCDOOyszNlteYZDxSQJQzfVY1ySI+aD1tiV7v8=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CH2PR10MB4376.namprd10.prod.outlook.com (2603:10b6:610:a7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.24; Mon, 21 Aug
 2023 20:28:04 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be%7]) with mapi id 15.20.6699.022; Mon, 21 Aug 2023
 20:28:04 +0000
To:     Xiang Yang <xiangyang3@huawei.com>
Cc:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH -next] scsi: arcmsr: Add __init and __exit for
 arcmsr_module_{init,exit}
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1cyzg9m47.fsf@ca-mkp.ca.oracle.com>
References: <20230804022913.1917023-1-xiangyang3@huawei.com>
Date:   Mon, 21 Aug 2023 16:28:02 -0400
In-Reply-To: <20230804022913.1917023-1-xiangyang3@huawei.com> (Xiang Yang's
        message of "Fri, 4 Aug 2023 10:29:13 +0800")
Content-Type: text/plain
X-ClientProxiedBy: SA1PR02CA0008.namprd02.prod.outlook.com
 (2603:10b6:806:2cf::13) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CH2PR10MB4376:EE_
X-MS-Office365-Filtering-Correlation-Id: 60b13926-450e-4947-82ae-08dba2851f6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pgw338gdWROo3+sBBSd1IZCYzQ37gO0N2O5A7kAIr0tAw8VQD1p9G6Z0De+rtFIM3WVy0TF2KPLKCDHRG8c7T9XGsasZWHwyGSB2hxPzdBicMWgR9qb/9QJeMOpI7Lzhxie7hyogG/Wg2XhJGuuG2Y/N8Ni4xOwVZHAFSjzzuZratu4nj4FjN10hzgB1EsB77PRfk8jhUjpEDYCBqkzt0NfB6Y4yH/M8Cv2mnFzcT45+Dys9S4FwXqzkf2G3o7fas31p2KeHrn5DdRU7OeVmmVdgOo/XQY9H8Zy1V1z50yumIwJQEG+IunxvEqWcSSxkF2/TdILQm9WORKM9aQJXPgz6X5AHfqZsF0eTv46NP/Esjjz+/WmgeZKqwrwcR/6YCmCpoGBuEwJT83T6NQgogtvkt8U8J/RxzyOck3gQq4ULgRmMTrgtjLbpC44mwzmaAcetSMs93Iph8xVX2472UmVNzD80HvQUeD1k2r7q+joil5UHfCt7hMzxL8LrNnIFCNQZ3AOVSPuEDDonIegHVBudLgfizgfe61z/mmGb0mabDtVZ+AOnXUdS2vs7dGFP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(136003)(346002)(39860400002)(366004)(186009)(1800799009)(451199024)(54906003)(6916009)(66476007)(66556008)(316002)(66946007)(6512007)(8676002)(8936002)(4326008)(41300700001)(478600001)(38100700002)(36916002)(6506007)(6486002)(558084003)(2906002)(86362001)(5660300002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GdVT/pKfsB9pROyYoOwtphLaQTfAJLB0fgtU0cUFzdRaYV76hVCBz6VD8c9z?=
 =?us-ascii?Q?us3DxBe5FH6HtBh6U9LzXDbyXe6T/h6pkQkYx2s7bstVzuKxYzeG3cKzjawh?=
 =?us-ascii?Q?UEdg7NNvwXNXbdOHXgAEjIcfLgTDyFus+TDLS+EPHnAyV0A37M+6FLQHcEN7?=
 =?us-ascii?Q?eX86Y1T0a6ZX99CnCtEPt9MZeqgff3pHkrbcklNSZf0/zybD3u97erNzNAlu?=
 =?us-ascii?Q?N8wu0dzkSOBTPGgqlvWO1tVgipire+9S8ybaFYCPhQ4PGbd/Q36C2eVpvza+?=
 =?us-ascii?Q?eBoypxHdv7gc/j7ULJR2IFnJFYv9Ij6EEn8KHy7g0dMZOarGzAN7m+6rN4ZU?=
 =?us-ascii?Q?Bhg4yGi/Ugoofaj9PHME3E8XrxNKfY3WTvDAfqO/8O4eWhtJfRKhIlCjsimK?=
 =?us-ascii?Q?zCxUr6sADhbvhI+V8jhyZ57Gz4ZxZmVK4Lb0zNTCV/Hj+7E+Sg2Zua4rUbPu?=
 =?us-ascii?Q?WBvURgbVaecg3HlVLY1un5uuwjS00FZtu6n5NKM7wFSzCef7TVi1pQ4vIPnR?=
 =?us-ascii?Q?rjJpyBhtIsrpDGQXdOTDq5Drah31mkCaVEH3uBTlcPSL0Ds2HfKz/KmB7GUW?=
 =?us-ascii?Q?E47Kf3hLA33bn9DFfkPLxy4WnHJ+pm5fn4Elq5AY+KlNRz/Z4eMLxh0LuN++?=
 =?us-ascii?Q?YUHTVFZ+nFn0EJsA6DL6gcqCzsvjlOilIJNMtDxQsWvdmYU8HA64DyeDALVm?=
 =?us-ascii?Q?1VnZ7XvWXPslaWm7wvgxVVbWi+5UjUO2eX3scZhdIXdzOIoY64wN848f7I6/?=
 =?us-ascii?Q?vg+IRw+bYRieecatdDIewXelLnfj1QhTzr4JYB2BT1IVKU0tpP1w79CZy5za?=
 =?us-ascii?Q?KvbQI7pYitbs/mrUB3gxKbIC86S3CPUptjoG7htPB8ol00zp32ISLbbS+9N2?=
 =?us-ascii?Q?hwU8t3fpinbvLODhFTFJOdQ5YDbwWByYVcH0ajUd5s60KexP5uaGhM50M9wQ?=
 =?us-ascii?Q?CWHaY2rmR7ELQG+CaPDvrckSt0qAxdqbFbctSixEama5J9pdbwUbsUxKtyBd?=
 =?us-ascii?Q?KzxOBkUWAf2HGQ3U3k2ih3PYs7R9jWtvxEeq67kz3EOZC5IPyspJTROEolJH?=
 =?us-ascii?Q?haI7/W/zp0K8V/xBHRvCz6Rp5hi25/9JzWsxrIEdeoK/5lsfCCTgFqM+U0rf?=
 =?us-ascii?Q?birL1koHKnHaR4vl3bgTBJki4UQLyi/0a58DQelTwaJP9qbHjCLeK3CdhR8V?=
 =?us-ascii?Q?XhV+886403nPGqnGShE4GcDiH1O7mKMQlKxY/1rvgLSP+FB9IJ7e1q72FZBR?=
 =?us-ascii?Q?zbxDU4XWpO6EVsNwVxdlBz2semHdeoIDEXDOYRJKXhE1KZt1u7oMTvHaH7rZ?=
 =?us-ascii?Q?sJdfzXOb8AiY8wXv4fC5wYGUMtfH0jlZliwVY9Tm3qDpzPiNctrkmxi7oNbQ?=
 =?us-ascii?Q?M+4Tb7J3NPXe3AzgIKd1ffL2KdQ8ylgn+VregpNEVMto2C9JZ77S2FfC2Cor?=
 =?us-ascii?Q?/9Z6BHnSPbbh1wS6OBfaXYpnxVD01H4KE1+PBO9aRVpZOyG63eNSLrVWHmqE?=
 =?us-ascii?Q?XepDjFjOZdw/8SDmurjYfLVZ7ZZBmatzH7PbtNLlzI9IULzHLec7ULvwI2Ma?=
 =?us-ascii?Q?AuOEY6hNIq2Zuqmq+iS1VCyJd8CNbhlOan1Cik7KlRWp+CpiJT9UWxEvD84+?=
 =?us-ascii?Q?XQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: jQRVLLDoVUPq3uLPGsP4eAEIEpGotJN3m5uxTdqddCcSaTdyjCpbGAKcrmOpbryhgHaqwIxyKPevaF15LliTxNDoKfIM/k18iT4tg6RteMMUBWVIPZwKvKPWal/RkN8g7K2T5P3xcFE93iKtBBmYhQLaViiZdzTjnoUWdVpgckXdmpBhruqkpCedxVm8QlpdxO/tTcbGKtsmH5gq9auImLr5f6ZDkyLrDZk4rFYah4hayAg4bG/65Zpx8p6ywJqOab54mRSHLwRytowuBz9gx1/Lb+5Ile+zr8W4ZzR3amOVa6x3vZdmXF4zXZ3S1Cf20M57r2sVPiNYGxHAjOv/zcP3Y4SOOG1TD9ibyIwyCM5d0BppNfpDlF+nrvYPfDMXz/K+3LcUb25MlpPNewbhImjVNBRGNSX4T/ys+4TKj4ZNUCy9advFv6TVjk8RljiGxGiJarDJUBhfhcsFgQI9f6pub5K6CZ7GgonF+fqixg9LZ8x+prEv2YX3Ih+HwOrGAxbPBQlCO98CnOfVZsQR5lBriiuUMn5RiBZeFjTNvYy+2IRr3ZY9O4ybb4KzGEoMsfjjkwZ9MMSBMTTzQ1KCkSdBsu8YTOTpvbpyqyMHo3ZWn9VRq/TzpXGKuY1S4KVR761d0dpk46A2Ph+NqY9MxX8j+eQUle49wMllZ5RpXK7vybCzgP+CMz1AoJ6peYwWqvSm/1HJa6HEHQtGiCmASleeSLmXY4PZP0s1HQEd5meZ3SdX7+UY+0Api9La4t/El6HVJaXW3WCYKbv49SZWtgefu8TUDnLEayywwIbCd5xU/lTMHcPqhy2UIlBs2gFeWyLYzpLGsxCUHfc8DGboeA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60b13926-450e-4947-82ae-08dba2851f6b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2023 20:28:04.5346
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XEZDeH9D/htFp8fFfBJkxZrkvfQE7l7D49f/dyf0AD4cEzzWvJEz5m02KxL6Yu5QcNzko6QnzEHVS5AZDYotfpM7u/Lre7UXyz0v7TKDMkA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4376
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-21_10,2023-08-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=867 adultscore=0 spamscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2308210189
X-Proofpoint-ORIG-GUID: uLLl-O6wWI0esXUWajGrSn0G_3hpdpdJ
X-Proofpoint-GUID: uLLl-O6wWI0esXUWajGrSn0G_3hpdpdJ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Xiang,

> Add __init and __exit for arcmsr_module_{init,exit}

Applied to 6.6/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
