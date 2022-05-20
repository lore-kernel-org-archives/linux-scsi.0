Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5EBFC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 20 May 2022 00:28:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344011AbiETA2s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 May 2022 20:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234585AbiETA2r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 May 2022 20:28:47 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B7A29CF5F
        for <linux-scsi@vger.kernel.org>; Thu, 19 May 2022 17:28:46 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24K0JFID023927;
        Fri, 20 May 2022 00:28:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=UFEQUeIVZ8DL2jdGpIrF+uSGuaE4CI9IfKNb6ZLqKfo=;
 b=lcaV8gAwify7lMU/EJ2IXOgHjNDDDcWRA4aqAKU2CJRsaHqlCRDxR7Xv+jmnYsSSTx/q
 muJfZLsshviiingd3Kj0AQeVQgc5UOmYW04WWRygT6BFBWmNvfUAJsNULMPVc1OZ7AeH
 kFFrGPUe0fJJoIYJkAsULoPJMyEc9jeP1Qcmaau/DUpSLrE4lSu7sRIUgr3vEqZeb7TG
 /sCyBaxZZucF3N5rWTvBWX0lN4MiXdQTcu0+kkd3dMYj6s0ooz7NiIa79w8ACNrI76qH
 NcFxU15lMh2HrnO3oU2eAX15xCenZp7NoVMrmaW5WtDLj8HlfNN2nr2XaWlpYR61oCZK Bw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g24aand9n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 May 2022 00:28:38 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24K0Q75G006648;
        Fri, 20 May 2022 00:28:37 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22vbas2c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 May 2022 00:28:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jQAhENXI+MEVA22aM05gzqCklyUsfHLneVK/L000fwRBAMs8BhJ+rEPko+zUsWO7xvHoP9Nrqg+v3fAw+R3qt1aOUrUiC9+ktvcrlRU2fp9qflCVm+fGBliQyDdin7S69fgmiCxhgFmYx+EwXYTaYG5dxDbrb6A1WrD9dfJv3ykAvf/ASdT/7mSxP0hD/Inga3z9D2X6nzF8sxzXU/PQaZk4pry5lASSiXke/QgCquMRddqKvc5FC4lEPrvIsFEmSChqtPma3M+MSLiI4+y9g+TemAJJNxXP/OvBKL6KV/+tkFca5sh4Sv1ZnhcaXu9K2noryXtEDWJXwb6R8KbGog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UFEQUeIVZ8DL2jdGpIrF+uSGuaE4CI9IfKNb6ZLqKfo=;
 b=eJRDrjBIp57DLSMwLB92YPwOqyDL6oDe8jOEN7ffZqrbymsDpsGIF8nt6uH8YJSDZxVEJt7o5gZyCLd02Gft8oHsCgBN1JBjP/fww7n64UYxlYaYsqHkO7RQJAxFMSTTXjeJYLKIqSpujF+XgUxFbOtD7PPAKGvrQVHd/SN6fe+oA7lEvZXLSOdD79NjvhiY8EZYy43ggomd7UbFJ7kIb3iOKBjfthk6u4g8ua+xVW1/bCDKh/v0Gwvd7Hz1S8qiOccxew69SpSRr3EExdeo27J3oMWMnYtaPfputVo9MKniLG+6otDuKA3LQGFNvgKNG2YPrBRKuwSrw1MUKNXLhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UFEQUeIVZ8DL2jdGpIrF+uSGuaE4CI9IfKNb6ZLqKfo=;
 b=LxJIRwHmtmZB7TUeaugq7XC4eIrjL5IJLATSW2VXoE5IsJB2yAgWEijdgOKC5gP528mz2wL5hLFlhEiX1JOMQ7eTpNsi6zhCHWsU/dwsnavBux/ZDh1o047wxv+uC5MCwe/bz1kOLEkPGFk+T18aqawEBiKmrTdnXVuJy3u2xh0=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BL0PR10MB2883.namprd10.prod.outlook.com (2603:10b6:208:73::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Fri, 20 May
 2022 00:28:33 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192%9]) with mapi id 15.20.5273.017; Fri, 20 May 2022
 00:28:33 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Keoseong Park <keosung.park@samsung.com>
Subject: Re: [PATCH] scsi: ufs: Split the drivers/scsi/ufs directory
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1pmk9kpy3.fsf@ca-mkp.ca.oracle.com>
References: <20220511212552.655341-1-bvanassche@acm.org>
Date:   Thu, 19 May 2022 20:28:31 -0400
In-Reply-To: <20220511212552.655341-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Wed, 11 May 2022 14:25:52 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0601CA0018.namprd06.prod.outlook.com
 (2603:10b6:803:2f::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b32637cd-7041-4637-419c-08da39f7ac33
X-MS-TrafficTypeDiagnostic: BL0PR10MB2883:EE_
X-Microsoft-Antispam-PRVS: <BL0PR10MB2883AB5F1BB48DB6006554A88ED39@BL0PR10MB2883.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2bY0t5bmPUHCxCw8ygRnqH5KaBCbqv7F9+YD0uaCxTHXl92k6qe8uJZZ8nX9e0jVanGPFX5ope69pPAGUcRFjgEWzI6PDkt3AiD5DHD5mNHcXSdkw4a0bZqu7bSq8yO3ag3DsWg1im0y056HJxCVDIKXFe/BpqZb9KKQPzMzQG3NuC0kaRy2Gsh/CuRxnwyXKxbPaZc1CgBGw5hJqZ6hxjcg02PqGcAoHs1hOEq5tUfxJMoNcX9dEULmPDi7S2STd+z+t2KYSQUQiWzlcx+aHo2rzXDYy0ZPDA5wNhZUsOZd5c4Zyn7/0nJGVp4OHlKgejtmwbOmuK+jTuln1V7+tK8U0/BAiSLdLgKClkVdPzKc2hoXZKOAG7P+bnUL/mVrcyYxOeXJkJ2Ad6eagF5HMydNO9KFO1U20KCxuE2VoiiTl8XNu4arCF66rwX4seBIdQ9YlZ/WwlYwanjIqWk9NvLa87+OlZKXTTan4vexkw2hK/1Lt/GxTACz/JP3TolnZ9scj9fKg3oBVRc+mYK6i51oZLJmpfOZ8EKZ+09PAy9C7j1nSggXUcEmwdLaUBRJRr579IWqV85fVJYQKqAX4eoXKCTqS09WuwYOqO1tbzrMRzxHZPvillQDhZI6VFffBK0eiR8aewaylw6IapTFx+qhWktlemXb2Gx8mn0YukL9ZBJyymohz4Irfpne6a530T5nO4Fc1P3ogfySe1OjRA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(54906003)(4326008)(316002)(6512007)(52116002)(36916002)(8676002)(26005)(6506007)(6916009)(66556008)(6486002)(508600001)(5660300002)(86362001)(4744005)(186003)(38100700002)(2906002)(66946007)(66476007)(8936002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r9rdVxMMHicq30xIywaw1mw2DeH0Pc0/3HZJqFGj+wvRnGt9mooHk6gLJfa3?=
 =?us-ascii?Q?XfmxG0JgMVZu7yrntT1AJkEToJAmGGSYmexoSOmvC5hNAdB12bk19+rjQmpp?=
 =?us-ascii?Q?OSuBeXMfY2GX5REB3Uu7pOzprLkUQR1s5Ybgj9T+or3IO+L9h9K1GOsxcjth?=
 =?us-ascii?Q?1rJF5z602suexbbNhxOSLviswPLqA3+D2JRUe5/dJiOjLJda1rR1i8b87dPy?=
 =?us-ascii?Q?ukKMdVCav4Kf9+H+s801lbOt5nCgvRpEbUyheiX4V6D0RkJwbjRYsJT8TphC?=
 =?us-ascii?Q?VD/XTbRAhCBuccpV2ylmX73gpPCy3L5mMUAR0MAXjJVFZRpWH1fnI79hMTm2?=
 =?us-ascii?Q?32liDoQ8nJ3sYuVixS/jchOKprnaMycStfWLIfy/YkgeUDPFJJv1RX3wYbjE?=
 =?us-ascii?Q?PBnnBJZpCXqLlOsUpEVxMDargIU91WID8onO+6JRjsQ5ZWUzi7znAosHILHg?=
 =?us-ascii?Q?+qHE0OygHKpZdHg+FEA2k1aXVCEo6WWF76FhRvZCS17NYzmu4t0seMvDaLjK?=
 =?us-ascii?Q?77TGJCf6KjYijeTEgDrY1CWS/dvhJy61BJAjw/nqGyNPf03HTUQnhGkYEUkI?=
 =?us-ascii?Q?MwovkYPkjzrWhX21MDhzobHIzhY7fKmCRryVBoR54lm48FHCirtKx7zwFn6l?=
 =?us-ascii?Q?Fwo72Y5SuFV9jqTO+8uBE7ZRYvi4MaJPjm0O3RVd7gSk9h0sZyLe3Ti9WoqW?=
 =?us-ascii?Q?NkjYx9GH6ZwMqqZ9KET62w+NTyALsBLjZ0YmgTa7ucPFlCs7VDrwtv2+ABsq?=
 =?us-ascii?Q?Q0KBDNDUA6AI0BFCDiNGwL9onmdlJUihW4qDgmg0BmAkxG8jtZ/zxD23N4l1?=
 =?us-ascii?Q?lSoVj0z23W9E4860R3AlyWYYJ1I/JVSYLK1FELzPq59MKnhte+rsYexeCnC7?=
 =?us-ascii?Q?OC5qQHQqghDPSY/tbZcqAX8uwU9EraRHuYpyHNM9085xv/ABLUY3/Etjn7fz?=
 =?us-ascii?Q?ntTn9s8ifxWM3O1liUHjPBxZjqEd1e3DtzVH1nC+EktrXJOAgnJ/jBRc34yW?=
 =?us-ascii?Q?JIWWiiAbnNHiTxDHZvaJOP2Fo5SmBBdU2Jv/j18Vos75RwZZW/A91fZFfrrk?=
 =?us-ascii?Q?MRJW/xTuw5ycOS6SM7N5F+bGNlxaKcLpJgn0+hrYJhAoaegC0DPT7HjQftnu?=
 =?us-ascii?Q?GyeNd1soK/spMww28sZq2sYA/Evn1OcR53d1dVtEPvPESH/o7GmbkoSR5iv5?=
 =?us-ascii?Q?pMTSRc9QkCqqLi4fiIkUT5L2F1XsKezNJfo6nb66990IUZFbLsMYZ8njWcwU?=
 =?us-ascii?Q?byQaEDyJOD5Dv7Yut7hm3waf4yvddL2b6+RRfoYROyKuyYvlA6kW4mJ7W4gw?=
 =?us-ascii?Q?2Z++Cid7ZYMDtzC8dn2zaHgU4SMAdJYa6szHeu9mYnTajAUdUlyv0y3kK1PI?=
 =?us-ascii?Q?AhZiwfRlz4HHFZovO7nU4t8n7umqN1NpUB+VbaaFvuuKJa4I/JAJid2L4plK?=
 =?us-ascii?Q?8vbDKxTPqs6Pl+w5VYxda33sjjZAT1h5OP22WcE3MS9nkKk+Z7JNCaNlw2Qv?=
 =?us-ascii?Q?U5h1JHs3PyUcm0nmE0ij7XP2oWYnfYHdnYgkmtuswPmday5rTq4zpcKruqV9?=
 =?us-ascii?Q?gIa5TE1Vq2Ptis6TQRM7lOJh9ur4awAZD6iMNpPtGGAN0Mv54+1QZi/iesmM?=
 =?us-ascii?Q?SifZjL7944Q7G3EIuZlutiSpwAOCCl8Rgqw4PnF+3+4+a7CX46rqatNTyVzI?=
 =?us-ascii?Q?cghiIuYaj4W7H2Rv0pRs80f3QL5OQMRjaDnDqN4xP5N6RvTgLzBe0JYSbaad?=
 =?us-ascii?Q?1Ak3gZYH07sgkCdlI3sDG3hF/JHV7q4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b32637cd-7041-4637-419c-08da39f7ac33
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 00:28:33.6798
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QQv8OjtujOVgK8sHenHVP3Q30VxQ9lBIvGMLWgDztX2TJgdY3j/lL29KKLnGCvz1LJ93hasO/BGADTFR63sIgmOIHuN1G03peVIlaX0TOC8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2883
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-19_06:2022-05-19,2022-05-19 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 suspectscore=0 mlxlogscore=684 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205200001
X-Proofpoint-ORIG-GUID: _zMJtRSgm3koWcVoIOzjq9k84yPtwiQZ
X-Proofpoint-GUID: _zMJtRSgm3koWcVoIOzjq9k84yPtwiQZ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> Split the drivers/scsi/ufs directory into 'core' and 'host'
> directories under the drivers/ufs/ directory. Move shared header files
> into the include/ufs/ directory. This separation makes it clear which
> header files UFS drivers are allowed to include (include/ufs/*.h) and
> which header files UFS drivers are not allowed to include
> (drivers/ufs/core/*.h).

Applied to 5.19/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
