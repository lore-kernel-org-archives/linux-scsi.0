Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C07D7C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Dec 2021 04:48:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234415AbhLWEs1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Dec 2021 23:48:27 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:43698 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229704AbhLWEs0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Dec 2021 23:48:26 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BN0JQsc016934;
        Thu, 23 Dec 2021 04:46:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=3HcyYOZQkJLVInvFYlZf2JUWCBF906NIjzHSOdAENgU=;
 b=J1cWtV0nzX9ZI+NaGEj0ej0R4ZSj7tk281I8WCs7yynqwAM0Iz0JrPp9NHzfTZ7C0j1h
 jqCeVD6aPOSRqEwARDTBhSxAIUQl4749Nxp5q2avLwYyYuS58oX9Gqy73PR3pVnupG3Q
 332RMssfmIU74ZHxTRvrqMMqRncGXrusQmfgwUKnXyN2prorjaECV9Gtb6TugaLe5hG5
 6InGWB/8WswIM+rOMI2Z6VAPPayNQ7LrX+Gx4pv508Ef7lSb0mnC1E1BLK+DxQtOjt0V
 uiOKxW9dDNbDp8hqmAoL6RSnMHfQc7LEu7ILtVTwM6cWXphoIU00caQPyEiWnmzrwOLd Cw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3d46qn1mkx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Dec 2021 04:46:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BN4j1I2036124;
        Thu, 23 Dec 2021 04:46:23 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by aserp3030.oracle.com with ESMTP id 3d15pfkmm6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Dec 2021 04:46:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nneOQj5C7Zg8Xacc3V38H+Qhoeof8VvHLPhSzCTE82DQxFjwqLE2q7jvzLXF7ny4Kplq5vD/uwGRBP5r4fzR0O4u2uAczLODB+x3Yw1MWBKkB+whw1uEqH+K1GJxKxFf3wsiR2kRGOEL9/9zfoakvSyA6bwf7xNDccFMmMjWGXct+UvBMwmnZ/IRQ3X117APkhiCrJ87TP4y6qGxLoyWyUmnSe4j0swRdRMjL6SCsK0s93SmrnaJOW4HeJJy9p41dYE3N0cNODYSdQZ0T7NVdISRZp4y3q/mMwunnXi3w1tHw07jgiW/AKSYYrVz13k/9XBxngNenloyZWFCOrZ1Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3HcyYOZQkJLVInvFYlZf2JUWCBF906NIjzHSOdAENgU=;
 b=mJ9Sid2LQRJDceZCEIQoXEMeVj36JOXSgpyRiImIdt5d1bK4vI9fy1lOtFCcrHSkgAP1em5RpMFWJdwGcXxQKvirciMQJ56fsK34Wg+TOPwanrtwvwnXtryf84feONeeooN/EBi/UoAGlyLsGmKt5sWCedStc9KPXKWsSv2l7b3kkKhbNrqhEjmKEQPt515kdL2fRWZCPLC08WFGilHIEJULb7nrxW78hn+1S00tu8JNK/F6EOqzt3aQdi14CoirYrbgSyTYhf83fOacq4AZs/8h99jIZr4CFCB3Uj2w+W8nYNsClXauc8a1i8YShbqXrTU4ywTTvMXC0aSYZCVDCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3HcyYOZQkJLVInvFYlZf2JUWCBF906NIjzHSOdAENgU=;
 b=z6dISNhpMMkgt1pgVgmIHfbK+fAK2gqg6dyiuFPntizCIhh7ctNzE87mT95jsYiRikOzD3SkoE9nC+9J/3YyT6UimVGZBw1ncYaUgwigNMAb0tO9/BUidVs+Cozuywr3VKcfqt4ixgn4O+aWeWZAnUqErV0Rp4Htpzn+yez1PKY=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4599.namprd10.prod.outlook.com (2603:10b6:510:39::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.19; Thu, 23 Dec
 2021 04:46:21 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::f4fb:f2ea:bda5:441e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::f4fb:f2ea:bda5:441e%8]) with mapi id 15.20.4823.019; Thu, 23 Dec 2021
 04:46:21 +0000
To:     Christoph Hellwig <hch@lst.de>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] pmcraid: don't use GFP_DMA in pmcraid_alloc_sglist
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1y24cexnt.fsf@ca-mkp.ca.oracle.com>
References: <20211222092247.928711-1-hch@lst.de>
Date:   Wed, 22 Dec 2021 23:46:20 -0500
In-Reply-To: <20211222092247.928711-1-hch@lst.de> (Christoph Hellwig's message
        of "Wed, 22 Dec 2021 10:22:47 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SN6PR04CA0098.namprd04.prod.outlook.com
 (2603:10b6:805:f2::39) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e96c15fe-7955-4784-dcfc-08d9c5cf2abd
X-MS-TrafficTypeDiagnostic: PH0PR10MB4599:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB45996BBCBAF0DCFE7F56A5A38E7E9@PH0PR10MB4599.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FDoGAUtE6w6ceZo1KJV5yw0q7PCwdIiuFk6N+Y2mekpVAvb5kvEdkhVWDhTPEZxrE/zYtQiGlvnEpbGQjwQ/76Uo/Yjfk5mph//xvruwHWllbBwtJFtxP2u+I9HgXgqigywwND4iAdsepodWfDSn02/qDltmQucOguHjd20xAC01N6FkbKcuTG2AAydv24ShOm/v7NJ+reCwNiY/gN5LE4WjdfooeqTnGQj2ImS/RmkZ9fRv8GMUl3eED1Kx8BU/TjcuhLfLKu15jSa4r8e6M7tjg/PHeIORbSEzWPj0fmb2UoSyLhrcPIRWBHP7NW49K8Ppko41iD9SEjNfTLqv1o46RA08fV3u3jJEoJ1IFu3l+h/vSyj4FX+z18CdCg4pmZbW2zRVasbEW1a+rBJinUIm6OzixEz+RL9HDkBZQt6zoNI8NYSVLxd6aRlUrMTGRP/2+Y3uVYIRLQTj3BakAUPSPFdDzKDkMz4YlgZbijAmjdq7joC7ttjK2lQDUdVHHgDAV035JkxgvcUSTaqRmwhGO2kRM3dBqdRgND76yhL4rQAltNkjqX2DMWcorSy1k9be3kdUL6L2VDcW7tWoHNfDy56TaE9her0zxexNuMlNE5MISaYfPuYzeOK1fQSv3VGQ0VgEWulyMeyxT2Y16DgeNX6o45lJ7MQyAuQXiCz4QmGCN0qSM/1sLedbuPOrg1Fd2AMSTIJVmrKLdi9DeA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(2906002)(66946007)(38100700002)(66556008)(38350700002)(8676002)(66476007)(4326008)(5660300002)(316002)(508600001)(6512007)(558084003)(52116002)(6916009)(6486002)(36916002)(83380400001)(6506007)(26005)(186003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4//ALshT4MlNcMSBhvXUnbNu5T5HBCehTj9WLi8qG+VCkudc2GrvhziCHpBp?=
 =?us-ascii?Q?hmPJGgQMdN3W+DIlr+IKhJ3hl1ZDJFe/NdYC3gS4k+s/29njQvVEguJsib9C?=
 =?us-ascii?Q?uNCTEOZ336YU+MKl3Kp3lA77loMgHgVj5IUSUp0PcYM1f7h/LIBho8v2xatf?=
 =?us-ascii?Q?0r1aN7t9vYRNzeESz0qwLq7aIrWPNi+9rfHBY+U7Ml28TQXzT1QbLFyDDpQB?=
 =?us-ascii?Q?AeQyV2c0SoXyqRzrT3Z6tyrepzCYakppo4MLQDqwROkUdNsTfiPO6o9NpPSL?=
 =?us-ascii?Q?X/Ekpui5zOz+S3+tQtqPSIp/t6D3HLARZeqhsJScYiW+OW4/DqJE4H6Sqyb3?=
 =?us-ascii?Q?06zP1h6l15GfbPqhPSqH+TBGHqbekhb6XAXZwRyuUk8nfibh0yI8MNu8J9Zl?=
 =?us-ascii?Q?y78nwDKmc4Kv9ChxekzHB0zRNOXB2/jzoislGnBrsShrr51vK33Uq8VnAtA3?=
 =?us-ascii?Q?3mgW7s4/2cD1ARD/fq8Js1uCfC2aGPr+jKPca1vxgoxPcfsaxcB3wnruRc7O?=
 =?us-ascii?Q?aTft/ePXWFRvKdCZdHDvXI28em/sz/uAWagcADGuP/JXuGVBM8KzzobEUtC2?=
 =?us-ascii?Q?MnHr+vQ6+Zg5inV9mJ5MxVmJZqzjZ3ItEegXQFnW7HFRfq0hW9ihkGF3IXwU?=
 =?us-ascii?Q?HhnWt0klBqrSIulqiAB0pyU+NXX3BhHE2/qlBwE4Jolc5NGQqbedhDBgRPf5?=
 =?us-ascii?Q?x/jgJ802bh+SD8vT+PKkuIkejPnwHHLKIo44QD3w/uMUdRSGh3T5HOSI/Qdu?=
 =?us-ascii?Q?5SCfZobeweCfRiYotjldS9e97+5TlhOz6cTZwsA9N4Cbu1CXmS3P9XUjfqlJ?=
 =?us-ascii?Q?gsqGCUHl+dj/0MZdYpPH2Qpxne+eSRFajewi7griW0TKUkzZoPa2nt3nnw1y?=
 =?us-ascii?Q?bnYIXRZnZ9f7cCwILZUOUSi/mJCCMtRwr9J0wlcV7b2L2iUsqH4JhuG75yNO?=
 =?us-ascii?Q?Jnad8kXTsO/HRjUupvlo6ZSe5tTadej3Hh8CMl+t5wCdpBj6FtDH11BSGGdW?=
 =?us-ascii?Q?jI0Y2jzwDi1OIE/ux5D025bMqrJlFkrRc68nfB4k3svddMvNfzyjjVtajuEa?=
 =?us-ascii?Q?vTfUp+1OJT9f7bx9cZ5iBLICSP4ie4VoIFyHguVT9djN2Nl5M9LNspMmXVTw?=
 =?us-ascii?Q?CQ246W11MQmi3wfzGP2aENX4nALtMNtJ7Hqf+uCPHR+4inZC+nsyFrEJctR4?=
 =?us-ascii?Q?5cagXefdH9985p+3MjiaTe64jcV5OF/+tDkEmISUAKsiMFpsIk+H5RneHCgO?=
 =?us-ascii?Q?0Ugdus9BsMhFytH/hLtq4mzrGlPQ6mtw3KK3gs37cU8j7q4AQHbYxFeVgnVV?=
 =?us-ascii?Q?cuzaII6QPpG50KiZmwhUGNx8/2JwvVWciKcqvRQN+I4IDAJPNJiJlIMoUwMT?=
 =?us-ascii?Q?T8RcJ+KT0WYMU1TrOM/lotrKt16rscXEcf6Ai98aYe9AKh2KxEkjUCZ96FnG?=
 =?us-ascii?Q?VqhCQMvySvsqF9Vggvm9NqK/xO8uj/MN2dEu8yJVEhfn3OLCS+GSomquj4Vf?=
 =?us-ascii?Q?Q2d2X7Sx38Pz3FNLdy9Z6w4haSeQu5QgGM9plVFd+DJsGhNCW7mCfDPesv7Z?=
 =?us-ascii?Q?cJvROKPAsa2C6H3iP4LozWluxsnhcpWPkcjb4A638UeoFhJJ5ktpksyU9nEq?=
 =?us-ascii?Q?V1j0K4c0DOcXnEf4hr565XK7NBbgBJWjmdi+nR40qmNH7Cyqqq5knFfkzT2J?=
 =?us-ascii?Q?Kkhwmw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e96c15fe-7955-4784-dcfc-08d9c5cf2abd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2021 04:46:21.6404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dkgmDGthdznlZSGJgQpXhGctubfSeTRBZuulQdAoe1BUzWWNFOXH4CTRdAatVKgzA41OcZqBv3bkTSFSHHDRLJaoA//wpsx/WAwe86dypa8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4599
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10206 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=632 malwarescore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112230025
X-Proofpoint-ORIG-GUID: olGxlu1JmiHNmVgOWL9EIPGu6_fn32cu
X-Proofpoint-GUID: olGxlu1JmiHNmVgOWL9EIPGu6_fn32cu
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christoph,

> The driver doesn't express DMA addressing limitation under 32-bits
> anywhere else, so remove the spurious GFP_DMA allocation.

Applied to 5.17/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
