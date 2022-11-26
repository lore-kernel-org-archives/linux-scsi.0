Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31A88C43217
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Nov 2022 00:19:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbiKZATJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Nov 2022 19:19:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbiKZATH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Nov 2022 19:19:07 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 599E750D68
        for <linux-scsi@vger.kernel.org>; Fri, 25 Nov 2022 16:19:05 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2APNlgtc023785;
        Sat, 26 Nov 2022 00:18:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=gg8jDtzXm8jpmzrvRrxKkI3VHfD9Py7AIyjj2oXw9wo=;
 b=kAa+BrdllBtCpEjTb0Ib3KK8nWUZ1JtHK4turEOjogGm00cHOqS2U+qMjZ9O5nEElsum
 TE2ARnLwhcf118hd9mJpk0erK3n+bnLSp/CXM10Qv3QltOx2eGUUSIvI/v4jXWWLdNbI
 Y60uaetMN14uu7EgH+FgPzxWkH7FdqttjFUQtisZFtn5+l1cpQ83NuDTpb0zcr+YU/2b
 9+/4ReSOhlRroy2ThkqmkyBTiYlTTEyqAinlSX2I7o4XOJi4OwRoqKyIhyZjGRm1L+Lv
 qt5qymBu8ItUsMuYmZhVbJpOL00pMXderTmE8f9+fr8wtk2ZfT5/TNXfoUinzNDL+SDE VA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m35d8g4h7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Nov 2022 00:18:57 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2APKvB2k016026;
        Sat, 26 Nov 2022 00:18:56 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2049.outbound.protection.outlook.com [104.47.74.49])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnka1fm1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Nov 2022 00:18:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nqGFdtSHI0SGJPnxWUVsCTzniWj5RyQ+v2dZuZ4gy13QJ79PuORA6lGJY3S8CMc4Qxg2KSM1PJnd5B1p3Lzv6YDf0Ys7mXYMWfE2YVzMm7Zb3FULhtwk/v4dJTfoZ7I18+cee3IXLyPBObYAhHKCCGygvAY7cQF2FVPLB0hfEgv88f+v8WY+ypwNmekvfdXu7T6liA4dvqi3YJ6SHJciURh9COf2ZjYpsVVqFuZNUw40G9/X2+vtLYJF9UT6NuCTuD2gqJCQ2ngFYTBnai5ub0vEZxUNx6oZqISMrIpHXFqUnRIDvclXjAQPc/c0+4mgaebCRX6qC02JnKGskqTE9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gg8jDtzXm8jpmzrvRrxKkI3VHfD9Py7AIyjj2oXw9wo=;
 b=LTjs3+iHanjWc398HSEdYIcLP7FvX8CkfsgVeCYzpD9ttdFZvMgOp93Hxq5sC49znzIddVxIb8xt4yyZpXzvdsqgNQ+ddEtQEhn0sL0gwYDHTeZ9kmg8a1FMxB1UL5kwq2lXsXHCqaaUYmN3BDBLLY8SKKmx9O+/3R/eB3fNN1ohgKpiV9eodhoc+jvcnOvKiAgQOmNmxjkfAhueNR5iFS8V04znqMrE5S7Av2WqD8xKZVzfxGK2JW/lyfoLhR/xWtOvMd5eEEUNjnBb9yRYIzmpxu4LbS0jJiZHFFYpbwxk3tQRHKuZNS14ZD8mQcRnIwxVzyMzBz5J8Rn9g/BkkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gg8jDtzXm8jpmzrvRrxKkI3VHfD9Py7AIyjj2oXw9wo=;
 b=OeCFpxpvKqVypZpY8ihp8JzcFTVAqRRvJx/bDaIbWSS8z9KfSN/rhcGOeNSDCOlMfq09JjJlFqvfhRWL+FurIo7J6T7C5mHMGOvikOWqlNCsJJBOkbYE0lhLzp9uvAHwuhKoFOe49QJEW4xWCrWVQTLgrKASo+4WpWcsqD7i6vg=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA2PR10MB4522.namprd10.prod.outlook.com (2603:10b6:806:11b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Sat, 26 Nov
 2022 00:18:54 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b32e:78d8:ef63:470a]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b32e:78d8:ef63:470a%9]) with mapi id 15.20.5857.020; Sat, 26 Nov 2022
 00:18:54 +0000
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     <linux-scsi@vger.kernel.org>, <storagedev@microchip.com>,
        <don.brace@microchip.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: hpsa: fix possible memory leak in
 hpsa_add_sas_device()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1cz9ash3v.fsf@ca-mkp.ca.oracle.com>
References: <20221111043012.1074466-1-yangyingliang@huawei.com>
Date:   Fri, 25 Nov 2022 19:18:51 -0500
In-Reply-To: <20221111043012.1074466-1-yangyingliang@huawei.com> (Yang
        Yingliang's message of "Fri, 11 Nov 2022 12:30:12 +0800")
Content-Type: text/plain
X-ClientProxiedBy: BY5PR16CA0023.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::36) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SA2PR10MB4522:EE_
X-MS-Office365-Filtering-Correlation-Id: a760947e-43bd-40b2-f66f-08dacf43cd60
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G1yCNyo/yudtu0p19hsF2OyDXDcif4kZ+Hcyl7JeaHtF2w6vjGeF6NjzssY6eSuPy8YPisYlvEAIE2c0w0xEEoTe+q2CN6WoQhZD7oHPMwE1xCEEc0v3LAXqLBHjjDuEkbi2kOlXf6cjpl3qW3gozViyqfd2FX4dEwTRSSLFHhqEjpgJJImM1VCLfyMgIPB3ZLQqTLLGuX6SPF2gWkkZzIiRSC+80Cykd7OW9ktsku/9KD4kwiiNoeqMB3hv5hC5rmDNw1L/pWF+w5MzW6BN1PECXuz0CqoRSwAbFD/gzRqcxg8sMXOfk6PQxtcPI2Rx0AJimrBnaJ0VTXaEwq7RhmBASYyWhXdpuJphZ8uwwCb9ILX6Jq3n5+2gWcH9unrDhv62jOKgPCYdL2KQ56SpuksaIkakIb3tbjR65gTtfozuQ8QMDexT8pTp7XmLSqDQmIexVhy5v6IpWP3FaFlPfgCHex6kF0rz3wwrPGVrtXDb5cp2Q/MnV1c+JhWe0ybQ9n9DGl77ZVJ/cvVPEeFNi8z6zkpANTEySZ4/cyZotVgm9of1uI9UQtpGWdTTvvatwLkR6U0VIj+LKbROLTWoOrCaQKOXBHZ/X2itUU3d0fLB7ZkwzrXOXMlNQhmbGdnQg00Molr9lB6IKMdqM3wZrg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(39860400002)(366004)(396003)(346002)(451199015)(2906002)(26005)(6916009)(6506007)(6512007)(8936002)(6666004)(54906003)(316002)(107886003)(186003)(5660300002)(66476007)(41300700001)(86362001)(478600001)(558084003)(38100700002)(8676002)(6486002)(66556008)(36916002)(66946007)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ICRKHgOTYNm4S9fiDeLjJIPRTUW/+hZrDH5FMo1NN416indmAYiRxlXUXus2?=
 =?us-ascii?Q?egGx/ED3aZELSETNzE0kG6x25Chc20nXkqoHNTWJQ6HHyyDavlJkm6m8Ngyk?=
 =?us-ascii?Q?yERtLOJIs2RxPrH+y6pFTqofJVOkKjW1fEFk01lzGN5OkDOSqODlTE2Dhkgi?=
 =?us-ascii?Q?Ib4JSjK+e0PM3tVJvjwVTJepvqVOStbmhLzn9CHGttDEL01GSKVhyfXysbOt?=
 =?us-ascii?Q?t/GAkJhHXUlFUGdzp+mZDh+nebL9mDqQgfmS4E6OGclK4cQgAkA3kVQucgIB?=
 =?us-ascii?Q?iTnOF2F9tWrh0gPQOMejXrrfkVjiIVj9iYfCyZZgfe1jpKAuVOpDXAWzTviy?=
 =?us-ascii?Q?mz7UcNtIrOmI+u0Km0/lmgBYIrldUTlVbMBPA40OOpZJGsLtp/igVTi6qjSp?=
 =?us-ascii?Q?SDaeTDGl5JSwfSS1GKhUEzZn9AVdQ06NGxj16ZF7+yY7jkYHFzWJ0dJYe5p9?=
 =?us-ascii?Q?L6E8t7CQ3FPaPlmpUkAT8BzCe58XozttFj7PGUbtrf6/pqzdPa2YVYU/FRnS?=
 =?us-ascii?Q?/0a5oD0kWCHjm4QVvnFN8RUBOD3zU9TAvONTMpSLP6+IrpU6jF2cIWDuWAxo?=
 =?us-ascii?Q?bnA2bM/GFon12taoRyxVDtGJd6HtePXnjumE0zS48tSGoZDHsi1RedsKCl33?=
 =?us-ascii?Q?oA6z15kceYjaoKR0TceymNfAFaq/52Wf4wtSkUlfBa6H7HpSQVwhfavnQb/k?=
 =?us-ascii?Q?vyk/+R4ombwsHBb/by8sAOEKYlD3cYoG8NPb77hdfS2UW2GFdmB43ROPCUS8?=
 =?us-ascii?Q?dwz2Q7netHLe9NHAYLwJF/5iVx1w76jBVPgIqBqmyVOQTfLEx6OOyxgvT6vT?=
 =?us-ascii?Q?K1uR01R7e7FRRqLsmmdQIlU5YvSb8mVLyFkt6GhDJvVUpmffmHzwsEDdJZLk?=
 =?us-ascii?Q?3wIQO13YvI0btfhqPwUEo8reA3AIdF5EHytCYhVUQLRlw7b1+2QZh6Mcb1m0?=
 =?us-ascii?Q?sYYyFuHbgaAs9NuP9FpBjqlQW9iLA4dc3uEsu+LXS46gRw4afXs+aBG2pao0?=
 =?us-ascii?Q?5Hn5VghZ0xvi5HftT1TJdBJWPmc5tTVXbSoqCNVpNwgM1ycoE/zvLoiCIcbH?=
 =?us-ascii?Q?o9fIaumXbh1CdLAiWYzSPSXk/KwFCmbcQrPz/Igdz+M36I6Fr/905ciEtxmk?=
 =?us-ascii?Q?21p4UiZt1i5k32VFElboGv787Aytr0FZczDE6qoI6MtggRZ/E3NxMuWzolkX?=
 =?us-ascii?Q?TELELK0bW6Pgmzj80KtX91itgSeNO4XYx6Vd2fPpD3JHxGZvAm0dkFNiXBbK?=
 =?us-ascii?Q?cyacaK/B0D08w50P4zOHieEel+iHWwlGGsNPYobRr+dtwNUb91dy9qIGHYvr?=
 =?us-ascii?Q?r28Pa+QGg2d+fMn0wbUTh/YJokOzhYPA5yAlro0mhlDrOixXhJKlwmt+Vyl7?=
 =?us-ascii?Q?NEFXmYRFYGjRes4ex31WDnwHFCyxpoSGwHAxlNz0zfzqGXKAr7sZgsZ3eR4A?=
 =?us-ascii?Q?PQwUNUQUM2ataurYohUAFiSRYh0qI7dsx7BSZQ4QYdxB7ODZz3Ii0onr4c6y?=
 =?us-ascii?Q?1ZrLld/uxk19gqWdKflcX67hpAKPeVqnBWFwrY4hqHuLVfpH0iZPRtNRPPqF?=
 =?us-ascii?Q?pMTCzo2gJGeKvj2uwrZSELWSeArwFt6oQJXzCwX0jBhR7kCTEHQmtFy8ondj?=
 =?us-ascii?Q?Eg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Tc+Vy/XcRiR1aMHlkizhdXl3vNFIyDcnlfdhzBYC7ohyAm8xMXX5Od4o5f6+l0O2A4KlNuP/4TWL8K4mzcjpixO9jt12/F2KvLHzL394heljAjlTrkRbESARaRLCzGZzkUJeFR4NSjjpCy0ClSkek0KzvSOj5WXBLij64hNwMvGFLFMYSCb82si7FfUYsxkKzC/wtA6G+BheZWkExGubv+CcM8wzzOoQz1tQ61YWefN6KaMEfwk+2PyM4NecWWJr1+Wy80+f9+08L48lm9WYOxFzlGYqeG5NBKvIz8tvTfj8drtA4y9bk7byWXlFVFuC3xoGcxf6M+9IucG8JhSr7YCxPLatam1Kr6XF9gY7aJmVCA1LLkiqtmzRohV8m9dFW3NNL+PBCyw6yF4bgTj/DqDbBIu6NbNkfffwQ4qwYaIDoQ4YvPFs/O71s66Bsjw9HKeG7KPvt+UmTIXiqsDI0qf/L1vEd6T+nK1wh1RqSkzhQ8Zlq2kJ7oBo3lz3wgGqkP8VsEeSjaF1BAiRw1pCZTYN7BowQoJ/yPBGADCYcARR+18TjkRSmAoK3ImFEi/Wjn2q5NgSWAuBX6kGwt+V1NSfn1tTgqqy6S1lUfCw+Z52fM9hzAGQRQsLjV3yjgA4vFpOS+mICgb5RxfXJNmQjnHvVjCl5ZGsurzuCW2GbCYRfj+dJ4y9fHN1jqjqxFdtSByPbaVG2z8n4DmBBZ+FDZC+Q1MEnFZwKa8gw9tBEoud5lCgUtw5keSNNcqerOGtGJRaxdvopOyUgBFJsjQNRgnoWxIK9g8OQgvWjw8zo/f3iSqkoBzxMMkbv5WTrzQXk0Csfqyjp8Np6VJlky4hC6SL+GFpzokRoyfGaDauy6DHAKxLmhlFgiG+1gXiKdONGzr94JaAHXGh3Vjblzh6uw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a760947e-43bd-40b2-f66f-08dacf43cd60
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2022 00:18:54.3364
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A3lJIOaoJuLZgiYJG523iTPEzAMSfNspy9qER1uNe0W31ZE44s9w75rmVJoZtyJycMGg6BcPO1GlEXOZQmGOJSAWUBlrZnHGY/ALeX6yRFc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4522
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-25_12,2022-11-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxlogscore=974 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211260000
X-Proofpoint-GUID: eKQAmdYHDOQSNZaC_ptrq36A1u62CIBk
X-Proofpoint-ORIG-GUID: eKQAmdYHDOQSNZaC_ptrq36A1u62CIBk
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Yang,

> If hpsa_sas_port_add_rphy() returns error, the 'rphy' allocated
> in sas_end_device_alloc() need be free, fix this by calling
> sas_rphy_free() in the error path.

Applied to 6.2/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
