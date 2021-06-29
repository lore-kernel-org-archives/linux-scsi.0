Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08C99C11F67
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 20:39:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E37C7613B4
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 20:39:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235429AbhF2UmD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Jun 2021 16:42:03 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:3986 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234054AbhF2Ul7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Jun 2021 16:41:59 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15TKaMkQ014416;
        Tue, 29 Jun 2021 20:39:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=ZbjiEhAjkx/lo0lrFSCxdx86esRL6/1bF/wamUQD64s=;
 b=tYlHKmg5jeKtMd4ldvAZQI1KW/Zah6uafgpccocB0ygL2Wbe62WaH3kBcHIDha/dl8pC
 KvrmALHXiybh3rwS66L1Z8C3p2tkd2g3UMPzrDSTkr6mNKn4oWi2x+WpA8OrinvpxkqC
 bRUcHMbeF7hxsFGSp4eq5Bf1phsMLa81CPUl01oSwa+YdF1ugOaq86XRlc4xAosjUdx8
 b0/MnPNU8+ke4uTMKCeHLzHSHLq9beP5u4YHPTAhjc1lrK47FZveR/e6F8wUxLGYygqd
 B8sA1+7cjHWR1v59+a+nrfWhj+qCV91+dsYnxo3FYz6gNwGg5mxaKSe0/vfO143DC4yq Uw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 39f7uu4fjq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 20:39:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15TKa6i2080859;
        Tue, 29 Jun 2021 20:39:28 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by aserp3030.oracle.com with ESMTP id 39dt9fkw8b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 20:39:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FEAmJQ5qu+FqDOB41/QpFqeVIkcks//ECCLbBsOOvI06xhxfiTNivMno+E378KrBtkqF/BlVQGnc+QKpOmJwtDhocb+hXSUUL/mpOLP5exW459VVPJnVwKsBcATgH1Cors7nAL3r+bgh08LLHQFV2ildd+cNyZ/gWeu75bJlMrpcvLQSBgUXDwPAPLu2LS4Jo+V1ZKMdfSlKY4SHwVpN7W4zoNRrpq/G1iFV40W7fBA4xwi6Mkf1ABWwZ7BtFRh1Yuz9CqARAEEezHcQqV1QDfeCPM6TDKrnZfSFAV8lGlMPLejQUi709EDYoVwc1c5dez/XgMzSrYF15j112EX6XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZbjiEhAjkx/lo0lrFSCxdx86esRL6/1bF/wamUQD64s=;
 b=GXYMwAJi2oRiSvz2i3DiSRPOHVVoDMrEVoFyxi8t0wBPNzQcOxEW04LBbVt45W1BwOuraNNFZv6/Dtm+SN0kC8DtBuQNlq8cdVtxj7vy430B4Mtze4/Vb/XhyX0gVoDERbX0MX/NyZhAlLRDOWVo9O9RR0EA7MypV1iLSrl8TjZCN+97mNVgaBc/8lyxkyEyWoy4G8G0xHtelwwLnv8Oj2h8Kukx0H1d/23LA4nJ3OzalhXUlJNHCayl7HrilRY+jJZU08QLed4Em0zslCsR0YgpjHlC0ZLaMoSwkWhiH3GmYcpTeURQTExJdYSLKSN1sfQuzwXOqrWxnY99XZa/RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZbjiEhAjkx/lo0lrFSCxdx86esRL6/1bF/wamUQD64s=;
 b=MdOkOksOMkeSMKpmFWe6ODlP9DgyK17zbofOv0H/A4R2dJnxRmu85h+oVDfgjfiIDZaAtO/dnCPX2Hx5rQJ9gbUa1QxU6uHKFTD7YC5ya24KjchW2omHJXdk3Qa484S9JN8j/CXlduNLkp/xmGKPsolGU10DdCjRvXtvPwYQ4X8=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5529.namprd10.prod.outlook.com (2603:10b6:510:106::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22; Tue, 29 Jun
 2021 20:39:26 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4264.026; Tue, 29 Jun 2021
 20:39:26 +0000
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.ibm.com, mpi3mr-linuxdrv.pdl@broadcom.com,
        kashyap.desai@broadcom.com, sathya.prakash@broadcom.com,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] mpi3mr: Fix warnings reported by smatch
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17dicjthm.fsf@ca-mkp.ca.oracle.com>
References: <20210629141153.3158-1-sreekanth.reddy@broadcom.com>
Date:   Tue, 29 Jun 2021 16:39:21 -0400
In-Reply-To: <20210629141153.3158-1-sreekanth.reddy@broadcom.com> (Sreekanth
        Reddy's message of "Tue, 29 Jun 2021 19:41:53 +0530")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: CH2PR18CA0010.namprd18.prod.outlook.com
 (2603:10b6:610:4f::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by CH2PR18CA0010.namprd18.prod.outlook.com (2603:10b6:610:4f::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22 via Frontend Transport; Tue, 29 Jun 2021 20:39:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2f1f980a-1847-4af7-66ec-08d93b3dfc23
X-MS-TrafficTypeDiagnostic: PH0PR10MB5529:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB55292D681669E01E16C49A068E029@PH0PR10MB5529.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ERRMYYAzI+VR9Y7TUBfAvvjqWTTMlb3qCoWPjjdLxLsQDMxG3VMOKTSAzzEClohTOb+BIdsuGk/pE4Q/Um4ylBzqF4RbPA3T82wtPeiMAAZZxJHQtqRBieLCt6Q/1SLgLZVQwLaPyxX5/7F3tdWZDk4RdbPB3Iy5zSpc+pet1Hu90wE9cyc47A2XHYd3x66tp38iK5gQS1JgV/CttJ/4UL77UdgwDr4foN2y4sc2ViZN1Ahb+MV880OKcbW84fr9TD+lvS1fo7kXk1RD9MTIAoUFLUox2crA+U62YBWVLmPazTW0AaFH9/lvVx78g34vtbUELtIoyt6c/LqcfFk6GW8db3ie9IJJ3ZrrGEoyux8ZwxUFE8qVHF0VGq2yPQVt+HcU0hxG9QyzYSOtIgvOoWQ/p6TG6nTdsOyzvPVH7s63HbxYSY2eGler0HrGpDsUxn/iAdZLugTyaQ+Yc15MrGoAg05jg+/aiTyRT6zKEWQ/nbg6IEIdrsE3lSw0SxBo1nATtv6F9md/qee7m0QYNidctOMsfedwLDIWTVCd1f20PjQT3yStzbT7+FC659TvQJcIHY3h838DLmB2uRLI1CRUEWi8CJMizB6WiZGKi+g5pgimEZWhfT+4chLqP6RO+bmyk2lsli2W/e6vdWxxHs3TWQxDnS+x3oLlUvv31CUdVhqlUW0URaGVli7nR2oyQDa8sckYzWmrdNgDbLZo7fWVxCIkMZT63yiZRbyriMw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(376002)(396003)(346002)(136003)(558084003)(2906002)(316002)(4326008)(54906003)(8676002)(8936002)(83380400001)(66946007)(52116002)(7696005)(66556008)(107886003)(66476007)(36916002)(6666004)(86362001)(38100700002)(38350700002)(6916009)(186003)(16526019)(55016002)(956004)(5660300002)(26005)(478600001)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?evsvFIOJOxGHZGC/ADaCHlG1zPq5wvfvU4IdUB5bSijsc75lJZMNMba2F5to?=
 =?us-ascii?Q?aTjBvAsaiGuBYwIcTjLJFoP4A9/JtvKeQaDnvmHVF6ifDpiK7Xtwt1DcyBFQ?=
 =?us-ascii?Q?YQ4CUG6GrcruBVEzwRol+Eio9Rczket9CW9+rXFV5jQbsDF7nGzpJx3MnwVt?=
 =?us-ascii?Q?AuQ+6Ok5TDGGMfXpPVy6ijB0nbWMbHN2AVlOcuWkKf4yvYMZqGjIP2mrKfOO?=
 =?us-ascii?Q?5w30fgG8Dnt0KcW+Q00r5gWTULp8e8cL40Kzip6iGHqSVCCNnSjxG+oIFFNm?=
 =?us-ascii?Q?Y09xteeQrr5j9QQDZ57zg4q6TjS7sJL2ZB5gtf/cPdjTpzaboQO36fozpFa6?=
 =?us-ascii?Q?XZCVcGGB/di/5VaTfe/mKEY2LETj4hOHxmCEANy7CfAXGbjYagKCuWRl6tPd?=
 =?us-ascii?Q?wXMQ9lJGIpvmg77E7RzUMkexIXQtsxQjIVtWNyzF/sQFArGwSCqyDJk5zbw3?=
 =?us-ascii?Q?UMxADl1FqAfUuu6Z0uD3EJI8AmkLl4MIvBAWsKOKPjMohd9DRMvrkgHCaUmf?=
 =?us-ascii?Q?WMYWWYjNYm0LhR6yRDG/itZtPLy1OYByVUFb3FCz1WQU5RIp4VWjNCPkAVfI?=
 =?us-ascii?Q?5gaiHVuEMTsD8jKl3fXMNl2CRb2vObmE+veZ8qQJD1OPUYScja/zLf3NUbFA?=
 =?us-ascii?Q?sfAXbuukPv9Ez8Z9jqZWQ5qxBXcmBMWE5ThF/8xwqWf5J3BjZzozgrwDSEkp?=
 =?us-ascii?Q?/GGhPzhkVh6L6be3DrDof6rJdr/TjXI85wAK4VwF/q6sanxCbPYGgPwGLvP0?=
 =?us-ascii?Q?qQ0zcTdgPNEP9drNcATx1Dv7P2h2f0toLqld0nxHb17ZaSg23hhZlOxxDRRo?=
 =?us-ascii?Q?nZARlAKkyJ0yrakhgyvsXURRPdz/fFOj98gfydCfzPs0qF+ofxp32lyD2XXl?=
 =?us-ascii?Q?br01nyfwWvYMfXEUwT4pHACWtw9qtLT1KMjW3H6JhgmnPUwXS9N2rXkfQEAg?=
 =?us-ascii?Q?qHQQfQ2vlzHnlFV4f7G9qVrcPzrc751mctSYsIKdW8bHKKuRI0oOwp/mUbjk?=
 =?us-ascii?Q?cX9vvYgLS81Fr/krqn3rSNE/t4WQ6zWAmFl4QKpkQVjqmrFlUPuPSFQ06jUS?=
 =?us-ascii?Q?gD0zo59PXmpsp8O2p0g32o5xOmf87plftp4iYfayhlrMSWJXmautBv8m3JhB?=
 =?us-ascii?Q?sRaIcxU87/ChQiYVi4l4NPfOzfoPt6hwFrD6HlBrSkfgGO73aT2lXGefoX5e?=
 =?us-ascii?Q?t2O9RrqrxdLH8I3Exe0xaRMtpswrEbyiKceuqbsRVYdn1iXhA6GRLoHG9qXJ?=
 =?us-ascii?Q?yFsa0U2FmMyOa1uXIh/4hgzZFUSeJt5wZj50YHdKhG/FVbBV3YfYB152MX8c?=
 =?us-ascii?Q?lhcF/b8BEFzBBQFezmMS5SZN?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f1f980a-1847-4af7-66ec-08d93b3dfc23
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2021 20:39:26.0102
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HIgQL45ekI2UVx22a0A0wLa5AIvgv5SFuapJltW96ijz8LTr6GFFGjaK5kpO9T95k0b84nS1WiylEJLV+zw0noKynQloEebBbWWJUST6518=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5529
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10030 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106290128
X-Proofpoint-ORIG-GUID: XQAK-qDyQFaFQ0hwH9Vjfh3861Vy6ETI
X-Proofpoint-GUID: XQAK-qDyQFaFQ0hwH9Vjfh3861Vy6ETI
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sreekanth,

> Fix below warning reported by static analysis tool
> named smatch,

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
