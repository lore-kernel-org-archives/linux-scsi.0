Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14C05CDB482
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Oct 2023 18:00:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbjJMSAZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Oct 2023 14:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbjJMSAX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Oct 2023 14:00:23 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 393A283
        for <linux-scsi@vger.kernel.org>; Fri, 13 Oct 2023 11:00:22 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39DHhrsX017620;
        Fri, 13 Oct 2023 17:59:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=ZkGxArtqESMEw7NAIrYD+grJsXInOPl2RHV4sdJt6uQ=;
 b=foraLvGzFnE8kEHrFziKR6Qe+iB1aVip4aSW0CeaXUR9L9p88X1gKRwoXstvaooil/nu
 x1PZmYBwNdKdp8rsDkGkXSdqwOJShJ8gOyB928JR4kjca6OrnMe6Nt2aJz91199ZDFKo
 MFJ8MIVe4IqhnhoExRGZoG19N1yxKxVR4O/fd0xY2I22g0tP48U7mmCn9QmOXmILqmGl
 vLD8dF1TisKwsRy75xGN44HLoRh4BLj1sJhpbuaX5bwTTHr7raVou84yWWRGlBcZALUw
 FOP/aK18gl+iu53BImC/IDTbnz65QWWurXFwc47eZ4EDCarannA9lromGtGzr8DLhvTo sg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tjyvuwj2y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Oct 2023 17:59:53 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39DGmWCR021867;
        Fri, 13 Oct 2023 17:59:52 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tptasqf03-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Oct 2023 17:59:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jPxN26MH15coT8PcDMnDcguYSzV0wwyn+0EKNt9wAZv+HAD6G6fZNCa7ltp9ZXhZ+v3mnB3onP8eoOd4QF6APa9yoCtAG1NCyFdY2m1TLSJcAiBw1VUgJDSn7MWFf3poorGXXmVhmqaVh6gS8oqPmtMFW2LftVo+725twcHai8kywnxpj1a1sffkaNSM6SnekiRD8koAy0el3eCoJNYOjVNMBwyYWeTOnY3MoWMKYwFGQEcEsS1q6vh9r03lO3P8A6jYRHH1LIWpListFq4wovbSwE2qXc1Uc/UgONyXUNlyaT1ygVD+SOIwf4uiCz0BZS1axfoOUOzysTKATLqpyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZkGxArtqESMEw7NAIrYD+grJsXInOPl2RHV4sdJt6uQ=;
 b=WxRKYmxeluHoOzPijdqSewd4OH9gteica9IilclZv/rj3mrP3QeHvWzO2k1XoZqkeujq0S53/LiLR27/2MzHcFZ2/+UEm1jxZ0h2nrOtMf4seZMqmSOMerwCWkVXKDw+RF8u1Dp5k8/fSB/WceuNGqhsXMLNOJAXsUTphb8s78vNYoJJMs6swercJeQGf3zzsnUA6CsidnHn1KaXfk/oFW5voDZFeVOOTRSqgRIpIM/uw/1prPPA8IvydsLcaW9mjwjV/t6kfLlYK0NIUNNKvI7AiCPny1MBoOX+opI/+QdL1wNnawhnfzshZzHiIOU5uD6hkupQEztCZM8116IvHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZkGxArtqESMEw7NAIrYD+grJsXInOPl2RHV4sdJt6uQ=;
 b=gtZVqse3LmmSFzZbk/yP+VB+YSsE0+tSjheo9VtNXpLbglhc+7029KDuqjNJ7LQ9tyoMb8Cl/9svNZAaT0g/gsm0lW6MJMMJ0qfePEFP1jw23ML7IZ6/agJ1iYGM3arYpVxwnliX9SMXXcLR6/0uarUzeEi4wd6tXBZpDfE8JdY=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CY8PR10MB6852.namprd10.prod.outlook.com (2603:10b6:930:84::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.45; Fri, 13 Oct
 2023 17:59:50 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1ae3:44f0:f5b:2383]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1ae3:44f0:f5b:2383%4]) with mapi id 15.20.6863.046; Fri, 13 Oct 2023
 17:59:50 +0000
To:     Christoph Hellwig <hch@lst.de>
Cc:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: Re: [PATCH 06/18] aic7xxx: make BUILD_SCSIID() a function
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq134yemmig.fsf@ca-mkp.ca.oracle.com>
References: <20231002154328.43718-1-hare@suse.de>
        <20231002154328.43718-7-hare@suse.de> <20231012082633.GA13230@lst.de>
Date:   Fri, 13 Oct 2023 13:59:44 -0400
In-Reply-To: <20231012082633.GA13230@lst.de> (Christoph Hellwig's message of
        "Thu, 12 Oct 2023 10:26:33 +0200")
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0038.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ac::6) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CY8PR10MB6852:EE_
X-MS-Office365-Filtering-Correlation-Id: cb9cc368-ca0f-432a-f6b2-08dbcc1631b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gYj5NFNqmhcJtikKokucfzj1a5iYtMeIX32X3Z4vX3AXcxqr7rpzY2pPqN8qPf+iervc/XFtyvLlaeaDtA5nLyiKemJ0X3q3aH1OASil8c8qynI0ITTXory8y7Oulxus6vFhjHDFThWtdsCG4nhG/NdS6R+GE9UAE8CRADgHbmOi5sGXw1CapYGiAv0yTyEt4UStZPLKfiTB183YCj6w7GkQxqhCUlc2Tn0QsnUofBRO3vN5wZn+iHtxpVcSFFojlRPb2jLi87c0w2geBMtAHXLTi5hWAksNbr9Bx7AY2Fa/hi2Pg+N79VZgypooX7eWu/sUbN+be9i5HC6/bvwjfmpDXUUC1ThpMesXB/iYSdY/0+a8xcbzOWJ6Kk+Xk8/Ngj7vqAmPSzXqu0rLc+rCkx/QozUD+lhsgTttzgO0bYRrxhR6myvTFeCGGC39ARF6BJgk/ieCLsq6NrPBX1emKWF1pqgT86r6VjriBCndAgYcYdNNu2aU+9OdVdHW5YAhlef2T3laP6OhS5oT6X2RTwREUYWZusqDOVGCm8xKrh0sqk4vgBkjWqv6HPe4/d7j
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(136003)(396003)(39860400002)(376002)(230922051799003)(186009)(1800799009)(451199024)(64100799003)(36916002)(6512007)(6486002)(86362001)(558084003)(6506007)(38100700002)(6916009)(478600001)(6666004)(41300700001)(26005)(8936002)(8676002)(4326008)(316002)(2906002)(66476007)(54906003)(66946007)(66556008)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VnWXT9SxwnbfVNYyR8WQ64OQmgpZWi8kwwYhWfLSExUvcapD87ANODFXl9HW?=
 =?us-ascii?Q?i+ACJ5SF5zTMvEt6EGHBvfy82S2UYN1pq/1C1Z1ropUuhZC4sX4pVlZDo6vD?=
 =?us-ascii?Q?jFQmrD6p2dDc6XZGQ/SpPGGfpnU0eEG3s7BqmkvuGGZQ27gVVfCM5wQlPxhX?=
 =?us-ascii?Q?CJaSCWdymaai8DYA0CU2Cv9Ylheo/VdBhW68SH0W0CQ2BPT91rX/CMykEYSm?=
 =?us-ascii?Q?QxnyD7juS1E1FvyS/mZ0sfIIgLLi8XPyu9eC9oeQlhIVA6uQ9P+W9nFprUCu?=
 =?us-ascii?Q?TaXEhe39D6DarrhL1SZpx/9ea5c/ZYnOZT10VDneNg1i06k0voAezG5M4g7z?=
 =?us-ascii?Q?YXQ1yEmomkwPDiBldA1IG6ntYfdSJqvAjtUYeTfsScBb/fYU2mmn/16XxgpO?=
 =?us-ascii?Q?MDtF4mi9w/SyYdgQxv9B4bKkSWwKxXHGuRJReN26LuGowxY2cWYAkzUdXRt3?=
 =?us-ascii?Q?DLzo2YjPkFtSiChZwt1Owp/3LPCw/EdvgnkJyPv4z30eK5sbkhrY5ETU+Qnq?=
 =?us-ascii?Q?I/5+dZ9A4m0yy6HisuX3UXtBWYjfV96+Nw+4ZJwly+vt7TbKq8Pf6wQWbsmP?=
 =?us-ascii?Q?tqLtnR7WJHxHqcHDxzymwg4Cawkcy5zv3ItNlAv0U3pvHdwzzSc/j58dm8MF?=
 =?us-ascii?Q?fwcxF2zXZxxsKmW5eUd3VqGVqIn5HoamcKOYZTVkA2vNqsAjUiywejb/P6/m?=
 =?us-ascii?Q?LWPJMcVWxw29530dWrhcpy8tZZpNCzT9/y75/Gg0Sp9Lj8dDE6xbfFqyTbzg?=
 =?us-ascii?Q?SMfgNKfI4Fx3O56TpP4lQtJUr62q2hGpDrTVzkbNHasvNAkHlHGfkpEK4jPd?=
 =?us-ascii?Q?a29U02BuuFu5TtOBiJE8ACdnotNcnpg3J6Xmu9nQ+iPdY/KOkqrocyshtLfY?=
 =?us-ascii?Q?suamd37VvpUa3q/A0KOq4O7d5DCs0kn2MKxgYlAB5lYoGm1ig3UxXVIEDkW4?=
 =?us-ascii?Q?e6wVkQaqAHB98zaa+VUOmmtin42qdZg5kyG8B+FeFVNvfOtjeHymT+b84wV0?=
 =?us-ascii?Q?uFaYeX4Q7XO2pAhoMEVE0OoTZsxZ4lq7jPMWQDdtCairsUhpZ0UQM9H3Lpmf?=
 =?us-ascii?Q?Ho67/+MJWezZq6NgV311QDuVBpwYxs5s9Xv0P6H/ICrpd8N3Yf+OcmUNtmdo?=
 =?us-ascii?Q?GQ3+wsUFzwCCrA38P4Arw+TmgqC9L+5vZWq+CBnpxGMKW/7TmUO3sp3qmZIo?=
 =?us-ascii?Q?lEO6HXnzVLONNvZn2SsTrxio7BUGTHdlv4+vNT+jfYZH+EZroLEghrxbsalp?=
 =?us-ascii?Q?V61lm26Qkaq7OJh0xGawn0WhGEGFI5u7PRRNS1RfFxt084Lp0q9RTH8WR3B3?=
 =?us-ascii?Q?S/qxfGkyc0vTI2FwPLmCQ2v7zlpW3YfpPz+GSS4KpVAA9uJgIN/DiK6KYL6k?=
 =?us-ascii?Q?E/EYEeLs2lufd16FthYpQ1e722ocHXy5MpahZ1Eq04DCHOBTx+lFJdR9x3At?=
 =?us-ascii?Q?0ZdS7rDgsxK97AMr6QkU7dxJdg71FIn9tO/0Ftw1RJ+LFtTl8G74UTh1oVxP?=
 =?us-ascii?Q?CtxAuPtgCWvdx2TigRuv2OWQgIfkCFdqXj0X+6bGjRrB9nbyao2xmaFAojDU?=
 =?us-ascii?Q?gisJJn5j6HluSXXKyy52NpNHPKMYDU398sP4UYyBbKGZODOeD0HcNrXbKYWu?=
 =?us-ascii?Q?4A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: cPcoNsv2Dq363ZV5r0yn2Xx3u+hV4RnI+lqlvphppF29fGnpAzXBcJnYBUsc9jF/l+3oiDP2cvP0NETqmY+rbdX63r2LYND34+KcBk6xjkrIecTCWNN7Z9AVzB4W4J5X43i4AbWEFCAdoiGdGb2jLsd97KjU7cHucDdSrBFpxHhAatA4RkNfyHSQyRBktlovNXq+ZqhKU9gCk6ETxyF/XzWzemnam4P1jUpfDo06PROBx6B+tbIir3H3h7FNfGTqVvwh6o1+UkZ3NFh1VMy5G78x27Rb6J76HzUeGk4YwzHyek6I1EskpJ4jPDohPevzJ5/3c/bOnJ60PH2rpK1Mz+zs/8osj4Q4wJxEOTJlNXfPKnw2AQutuPnLtMWrwp+6o30dvN9FlK8/qsWOp6BM1UrqKkvvOd0b5VqrIMfkeWxsCy7BFSDNayDpCw4kGKFpENawn+3Zod6gTFCPZ7WkwtLTs3El2X/rWV2o3I+Spe+xrg3PprKdsrSvwnO8tMFPr4lnJ+cqW92kOi3XSi8KD7j4xyajL9v5/X7lfWwORJD9oMc3uA9L9db805HfoOIoDEf+OkyfGPmqFPAu1EV9XrOlL7IlCSASRBnEpF2FU6TOSAeC5cWWE3FBD7++tMnq1UrnGn5x0OKLpgd+1YDcIgF1T0ufu7jzYMhgi72bxofTXHr6T+NIZ98cv/VmkVXivV0f5B9K5jUzspYXxUbz+AW/1Bo+tKtOjFqqFWxzmYkk9wCBjiQQjH8O9diIQ/TAfWZHTqtOLJ9+Cn1k1kdgq9Cl6KlOBKnWYeHIGESDqqgcj0DJqBn5SmGu54Sfsj0VThTrl7gg7xcjR6yc3VJaW1MSVd2OzIjX5rdF8BQREC/t3CsZKs9ZB+vQHfIDcEjBMX5JPOdIfBvDuH+4Xkv2RkI75IdCp9Sgmm8QyDGfGWg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb9cc368-ca0f-432a-f6b2-08dbcc1631b8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2023 17:59:49.9524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UsdKV19olZeIxawXzAx0PitElH/5wa/mGP9njvARVSBxiFAiRIE46ShOQvsw6tZ2fTLSjg5hQZjIphUAWAo/YNGXhRo8//hclg7k1BZ70Qg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6852
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-13_09,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 spamscore=0 mlxlogscore=530 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310130154
X-Proofpoint-ORIG-GUID: dnA5tT_K2aYX7mudrMhOXMvdrSXKt9bf
X-Proofpoint-GUID: dnA5tT_K2aYX7mudrMhOXMvdrSXKt9bf
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christoph,

> Looks good:
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Applied to 6.7/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
