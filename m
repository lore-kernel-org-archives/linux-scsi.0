Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A82C0C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Dec 2021 04:45:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233665AbhLWEph (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Dec 2021 23:45:37 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:51552 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229704AbhLWEpg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Dec 2021 23:45:36 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BN0MfHZ015891;
        Thu, 23 Dec 2021 04:45:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=UmFk/4/m+BNKKuq/grktDMzcoGe/9DCo6u9EEAsp4QA=;
 b=dMBhL2j7vNJVEDBpHBC/dP1MB5oHs9EdOcSofh9kLk9Rkd3QCig5Ga3pFdYb+GDlO1wn
 CZcFLRe+CaE9GKgMj9yQWCtCiD+2jnHfPimfNfKxFXaE4QKBxz6jlilCfb5rkwKWX21R
 lD2uxY0hTJybti902IrB94zOdNnmOGU9nsKe85BZmRc0JtL46DG/Qd6SYSMOufh3mzv9
 6fl8FDUwn5FHNN8CVHi+jiMsIndh90KlJ1TU0qvDWmCfYjuZsY/Zxhc0sI59gpmBYgL3
 xZBQJvkH/0+2Fq+TIgjzs3mTQmXYwIV4jGENdQQepqlldiycu2Lb/U2iCOulA/O00FkC /Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3d46rm1nst-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Dec 2021 04:45:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BN4j32n003345;
        Thu, 23 Dec 2021 04:45:31 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2041.outbound.protection.outlook.com [104.47.51.41])
        by userp3030.oracle.com with ESMTP id 3d14ryevsp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Dec 2021 04:45:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R46fT5gMOjGOyMYp/51s9ccH1V+CPhcvfRY7pI3tFSxZmhih9zL0m5VV00hJ0EMknFlB9eKrFTSy8e/X6Ld2yZA9qMKlsDAz/o3Ahhdq8NYuWJcUGhY+6E5tjvFc+HGnhZhm90HSOMWgQ6MLukJvxpxYjThxRoi9aeV/T463HKjhV9vJf22cM+loPztkItUKPHAUBcHuEyYNjb/OTrPFsVLS4doj0qgjEZLi+uM6LiAw6vCQkrwKVeOMVvuQVUjJcuLSrHzRdw0z5iqKcP3nqlF0navYQ5yNAbIDZd27STPvIgcjdXy+B0CxZU9hBs3HD3r5XMWrbMAlojgLt0Vzww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UmFk/4/m+BNKKuq/grktDMzcoGe/9DCo6u9EEAsp4QA=;
 b=AgZ8o6kizsq968WSRJmT4NaOm2k1do3mJBmW5ql964rZ/W5QnYkBm563VNEZLg4Fmu1qdvVz0Cifd6ynA/0xvefZwkAZMl1jraQ4vhQU9dECDk0mCIlyTiVFeGwrlJJwBA1TOk4JyJg6nQc7HXEi+AcaonzBBQ8qF3rEX1a9eSbgiAXwpwec/C9nH8Z8+zc3MNGTQuoTXA+1pxs0MWLyqsjKgCe5dIMiaaRkskjXRuZYK4jbqWZHJZ4v3AANA2l9n9ujmAlXJ2atx+RwrT8hmsjWpILEH8dUxF5X85OeJ/LdfXtvpg3D5h/Mk3/yikMDgtcxQSDevW3BM8w1EGy5pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UmFk/4/m+BNKKuq/grktDMzcoGe/9DCo6u9EEAsp4QA=;
 b=gzoRrxQiVU+2fgN7OKkDEX8S7DXoXRjdZOARQR6sRUk4vqrHbpqaDICPJfCVvimWvk+4SPb24gRm+km7xeT/vgrFJmTERLuHrq2suVlSjyLvSs7J3hDJHDvVd5lUbkYYb+/o2bDPIfaPKQkDOZiSTaDbuQ0zJZCwtk37toNpQaU=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4662.namprd10.prod.outlook.com (2603:10b6:510:38::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.16; Thu, 23 Dec
 2021 04:45:29 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::f4fb:f2ea:bda5:441e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::f4fb:f2ea:bda5:441e%8]) with mapi id 15.20.4823.019; Thu, 23 Dec 2021
 04:45:29 +0000
To:     Christoph Hellwig <hch@lst.de>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        bhe@redhat.com
Subject: Re: [PATCH v2] sr: don't use GFP_DMA
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r1a4gc9q.fsf@ca-mkp.ca.oracle.com>
References: <20211222090842.920724-1-hch@lst.de>
Date:   Wed, 22 Dec 2021 23:45:27 -0500
In-Reply-To: <20211222090842.920724-1-hch@lst.de> (Christoph Hellwig's message
        of "Wed, 22 Dec 2021 10:08:42 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SN6PR04CA0079.namprd04.prod.outlook.com
 (2603:10b6:805:f2::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0ce86556-3ce4-40e1-48bc-08d9c5cf0ba3
X-MS-TrafficTypeDiagnostic: PH0PR10MB4662:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB4662D47B19D587C4809AC8888E7E9@PH0PR10MB4662.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c8/HetLWFOGWxpezCfhiPtgBfaIV4C6FZCtPBMzMY6GBDADkczcFF76ASN4KFu0NF5koNCBCGo8TFS/Mlf7nh5NJDQx+3zu67ZO3Eo78Z7qHSUDgmRjKiESzpm3ViYI07JTEWvlI+dqBvv7eaWEL2FjqJemAYqwCquCRHzCJpw4IilwltkkGaAPNO3JHy49+0ZucN3PlxjwP1h4E/cpMfkFq+93SNnQWdiF2/qqRvQW5oiG0JzDFBdMJyUrs6qQYKlt/ZzOWtlVZUlmLwDza4PTcnR7RwJCfrg4La+z//LHoFbYK6bPw50sBUhyM/IdfSZ75PBrapOvG/hOGzSvlkEphbTm8g0TKAH0ZSDcS6ZfLUmDqGdepPbU0I5p3Hr5fmJ5t1bXx34aIzA2+mloE3xcSnzl2de9YFxE5L8zMv4XbjDK9HE3Yy2KoSwTUihT5URLbLipDSTqVia71SZuSsq9rBCRC35Ei4tLFHCHUzsNyMaAx+WTKyJwTdXpG8DCL1b7eB+h1CmqjmuXXfHUYxvLQ9KR+2wmVZDpQ4ggTjXKA2D229aqcTQVw7SCTeVjb7PdAFBHx2AcpfbIusspiBKxy/rZQ0souPRRQlwf8rO5Zr9hy4FFJUz9k7TL5STRy/D2NKPSfI2WjPfWBCrYNNL4142rZGdHSKxgjZDXgeR6soEdK2nA8b8ztJfHfpgmnohZSTFLi1dH9YHhQYq4Xog==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36916002)(52116002)(316002)(86362001)(38100700002)(2906002)(6512007)(83380400001)(66556008)(66476007)(38350700002)(6916009)(26005)(186003)(8676002)(4326008)(8936002)(5660300002)(6506007)(66946007)(508600001)(6486002)(558084003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Pk5IOlOUYrv77TfO3GPzqqRm3mo5E5YffWzXb4YfGNJyRH5V2tfgjKkNJXtB?=
 =?us-ascii?Q?rLV71t47ORVUNBhxdtoAW8xpTQeC879+zviRbS7ui/KF0tjF8iGbxKrOrvna?=
 =?us-ascii?Q?1A0raLUC+rrkmgSFr1EUDInggH4IgT3Sy9M8n8KPAJljF2AE0j/X+qMh3BaE?=
 =?us-ascii?Q?nqWetTQtiEy95M+ZpAUee30VtQWu7dquF7CvowmKyXrZJ5QEYrxoj8E038ij?=
 =?us-ascii?Q?Idac022Vxtgpek27WbZBrf9v3LuCSf1kCZkFMAbEj5uILruMkXi4LTSP3VfF?=
 =?us-ascii?Q?md55PFxmmernPAcwCHSDLrwc+tsQe9iD1ezhTx40hc6hvY0FGp68Ucqp4CUC?=
 =?us-ascii?Q?TuwNEVsxN2PzsrF0GYl1dDB0mqkYh7uX/M8Jd7RnA0AjBkuEXA7NFnUrrxTh?=
 =?us-ascii?Q?5ZDkRrQR/r3hegNEPQ4kyePguFgciC527NNOLeQ2rdVypz78dUplDdEVMx9X?=
 =?us-ascii?Q?3VeIFod9YkFALBTQihLBjtMjspmD5rwfbb5ALKeuGIdsRV+xLJ56DmujuNXH?=
 =?us-ascii?Q?d88IyJ/pR/3RLzO2C52XfYrIbSSQmoy//UDDyjtLQkKI5GVnsWNnKSN4fMVA?=
 =?us-ascii?Q?c+C54HBLe5g5fA5zk0Etq9kddPTdjxCMSWTMqG1J1qb+35UtRKv0etymoR3h?=
 =?us-ascii?Q?jFD0ZJ9+zEG3xRr37qrSaexD+d1Kfeo1vZDn24E6OcTUk/49ItjDG+6RbsOn?=
 =?us-ascii?Q?Rtv9QePEvcRMiuhqHx83FsewjEDChEXFesYlfPhZCZxFir3ux9rkHHj60iWL?=
 =?us-ascii?Q?CKZzVr634IZuxe3MAxBa/z7E0xNQ5d/04wH4TVxZwOzHiZZBr95djXHRsEii?=
 =?us-ascii?Q?x40wtPXnfvCuXaKQ/WKkA05TfF6OE6Wgx3KRsbp/Dnsaczm1x7nE5kOQFDzI?=
 =?us-ascii?Q?m+iV9EM06i83oua3En4l1RoZpivNBr4RhIOj88kNWOAWthYiqw997DKLtoUl?=
 =?us-ascii?Q?qUAeUQmPSpuSXvphRK6h5TsG1Z2n+AGBVmhn4aEQ3XEDyYbKE1pdEJbrzWnD?=
 =?us-ascii?Q?rcPVUkqTmOwvliae2/CPo86hKc30vToPr0dXehd6EdMZuC6wsX2Z8FuGfgQD?=
 =?us-ascii?Q?qIfC00ABQnb0m9NoARvE7FlgV9c3I8+E5ma6Qh1wyFcRT9z8ONxaGyZVDDAL?=
 =?us-ascii?Q?UjjFq/1l+alkiAR5Wv45BvoqgwJ7Qv4t5KQombl7GTO4MfLmsmsYG92dqYoe?=
 =?us-ascii?Q?OJa+8kueqjI94J5Az8KWmV9aIkWCCJ+WEmRPJfg52Johhi4udM0qgBxpazMu?=
 =?us-ascii?Q?92ElXdpV3YYxDTbenatoIh5GmlV1cKfZfsR4r0j/++f1SEtqt32OG5FTsRMN?=
 =?us-ascii?Q?hLDwh5UtuzrTN8QRFvBH+5gzBWnnbYc28baL2W+jzCehH/6W0HRoJ6Dn+A8N?=
 =?us-ascii?Q?49Vu56TiMRSlPOnLI8B7vyo3pPQETiGtjNgHWY1OIS7C8R/Dw192VJvzoGuc?=
 =?us-ascii?Q?SiQY7Aq98WHLcPqw6iHNCSHBgqIuxRYRKuMji+lnJ52CQx1lShhRB+cYLFI2?=
 =?us-ascii?Q?E0orDWP+zlHfSE9q4Oo7dJoqmemvgQ6rN1dSZ+i4ehyBbRKokEeHdkfL3ZFL?=
 =?us-ascii?Q?lRXmbiV8Ba/NO2OFY8eilI1QlmoS5Ruqr0ctsMD4Gq+IYCnovyF6ZWQZa5eH?=
 =?us-ascii?Q?jpqvHZUSG5aFul5PsJvEwPiiPYYr+cHqBsobNK+D/khiWtgMiVMEpc4dPyEo?=
 =?us-ascii?Q?Q9Mv2w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ce86556-3ce4-40e1-48bc-08d9c5cf0ba3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2021 04:45:29.5195
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gGbYnTr/YhxWkuNgW5rOqNlTRO5Wu3lLSrzMjKHPdTAHvms9Pzrqgf5tjNxGJ3ll+n+qNdzAjFfKk070/W84G8eMJNXHMpGzqoM/EgUC/TM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4662
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10206 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 adultscore=0
 phishscore=0 suspectscore=0 mlxscore=0 mlxlogscore=421 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112230025
X-Proofpoint-GUID: baOPYHxXwdgXDopo4zPpAhOLQH-mCB13
X-Proofpoint-ORIG-GUID: baOPYHxXwdgXDopo4zPpAhOLQH-mCB13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christoph,

> The allocated buffers are used as a command payload, for which the block
> layer and/or DMA API do the proper bounce buffering if needed.

Applied to 5.17/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
