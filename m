Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32E9FC43334
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jun 2022 22:28:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379010AbiFPW2L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jun 2022 18:28:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378915AbiFPW2C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jun 2022 18:28:02 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB555C373
        for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2022 15:27:58 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25GJJBPC022329;
        Thu, 16 Jun 2022 22:27:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=QyxuJzlHxjL19yLMqebv2QVgSb2Xhi9sDKrA/y6F+V0=;
 b=p9AAST60P6t2/GVRQ8p6Y52CL+0K501LVZbpJTBXCHJe2OsxL+nndrj1WaWx0EjYqJd0
 2TbOQ41ueGycQgPsqdzWjBN7ME+kY+WCdlHYyWY3EITa1AByu0MOwwAswAFqI06L7Zbd
 JIkwAbxIdIoe1K80ntqtSUV5I8JjdhcbsdLBkptREoHapl+OVIjTHlKhyQ8oRbTPMq5H
 DYEsQ1dpOmVSGWeaMaQzyKDMs1e8GXFFLl5P4bae0hNiAZ30YKK6b+lUIVFYJyJQUlAA
 c1MXoZl8sKYAY6HgCoX9R+A4wo+z20MS1u4BTwpsGceJepmAE4mlEkqZHEM4hZ3ZmNHm Hw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gmhfcvbum-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jun 2022 22:27:50 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25GMG1fI013371;
        Thu, 16 Jun 2022 22:27:49 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2042.outbound.protection.outlook.com [104.47.51.42])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gpr7qjfvd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Jun 2022 22:27:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NW93emu/nQLH2P0URs9Coj04UhO/1z9EBq3bpHVYcHSpscgKYDs9XCBEVtzqa+EmFEjBL95qNYxpfaf1jNA9cPhhPTqZNCiNMw6oS79lKVYKi0zhZXJQhevtjbXiHHF7M+llYFOm6lcaIWiMBlUZ+kAxh0R26OgCaqHtJdFTYRAG/S743Z7LplxX1B/FA+dg2d7Y8YArZccfkZM/saofjHkjMYtiqBDf8z43b5cDNJ++xxXiRSNoWADpna456J3cAnnJHdnRoTkQYNedAdrGZGx/0QiGrorAFiacOTgACG0lCxxX7WBvOSN6zC9L6FCaeLxgDIlW0W6Fyeq643b4Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QyxuJzlHxjL19yLMqebv2QVgSb2Xhi9sDKrA/y6F+V0=;
 b=cc/maen+7VNqXwXryI41W4Oi7KPrQFypvQFMg+8AJbyj8Ilt9oklygbbuXtVAm5YP3veWws4YtLguHy0NmrEJ1Qp/V3oxWeKkwvqZfIF1TJ4OUkr2rN+J70y8XQV/w944akXJHiXAl1hpwYWrnCJbXp5ap/un0J7Cz6Yp3VAzjTqLk8iaeMsfHP3bCx1MgUahTWoc8Hi1tfmZ5EvVSTb5hG1pspm0AUyAELHRZjT9APw8cdJF3B11dtWLy38SBWcVEFUoPmX8+LW7EWqEWPz89CSyTvEU4R146ndCIc7Lw0HYvgxKpQdg3TJ6tDlp65ZSCVl1O11MZzHCWXYmv8bRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QyxuJzlHxjL19yLMqebv2QVgSb2Xhi9sDKrA/y6F+V0=;
 b=DwB87Y10YZbbLLZZenPsyd+aLBYmrO03QdRHGFl/gRRQkMT7YKUIn4IeAV9OQ8ZfVzlJuqNv99v4M01JYtGyBD+68c8vdL3HyjResYhMjNdlHf7B4ZEZggViygH75uQuabWlz6aOTyFRKkfmfExS3eYC0RnC3R/ylUcnJhfvW2A=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BN6PR10MB1267.namprd10.prod.outlook.com (2603:10b6:405:e::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5353.14; Thu, 16 Jun 2022 22:27:47 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5332.016; Thu, 16 Jun 2022
 22:27:47 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     lduncan@suse.com, cleech@redhat.com, njavali@marvell.com,
        mrangankar@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Subject: [PATCH 0/6] iscsi fixes for 5.19 or 5.20
Date:   Thu, 16 Jun 2022 17:27:32 -0500
Message-Id: <20220616222738.5722-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR18CA0070.namprd18.prod.outlook.com
 (2603:10b6:3:22::32) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 360db289-bcef-4bd1-46f1-08da4fe7707d
X-MS-TrafficTypeDiagnostic: BN6PR10MB1267:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB12673ED833289CAA887111AAF1AC9@BN6PR10MB1267.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fShX0FZxPHXTznoY+zXbeTpOEAmXzb7BbueLcnoiseQ3lMntAJve4aniPY9PIkw4ThSdUYLMoV/9UOmWPyhzvQ2AnCgnnkVxKQSRuGSC9B1c5C+F7XGM7fCoZ63YAANrUHbAzvVPiV6OkZt3YsRDcgAmyEkXByHV6LVuFWtyMmXzs28w3Blv6j6TNvgDdg7nvVFsgJKA52g7aVcrTix1uQXSGrkaGsFCsCpYVrJhw3AmZgc0QDEEwC3iIM93Uy+9qzl1D6c7dhAcwE3D3Apjr1sv4N7DZs9kMu5c+csBunp+IokZY3ohCHJ0CQ28kknrm73/escM7aIdeXvkZjwq/QBgbm+3RKmSt2F/f/fNJmhCPRYo2VwfogjAkh1gtFDTVpv5oUEf4udDYhCa3RLKOgF5MwThLQXjhf5/1H1gxYQR76CyOySyYtF4xze+wFMxKizscKQMbZPz6Q3j3m30Zux+FFEMSC0fV6K14lcwGb4dyFUMOUfajo5bE+coi2HxLL9UahLhZ0rUvTib2hKQEbzun5V348v7q4j15o85U0DFSAEF1ogZw8MjocarOk6Qf4zo4x+LZdBCLqQ+qsdFvqgWAmR0SsZlwPstE4sVlwmWapF52QzMC5N+AjDzwvqWQJwcOVoJceNFqb6JBTZgO43THQVr7qkB94QoxOsgMfbi/fk6goCKTr/G/elJROU897z+tsdkazPUhyE5xo+80g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(4744005)(5660300002)(36756003)(2906002)(86362001)(38100700002)(6506007)(38350700002)(26005)(6512007)(6486002)(1076003)(2616005)(508600001)(6666004)(66476007)(8676002)(186003)(66946007)(66556008)(316002)(8936002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r03ZPq1WTo4irA2zNZaZBIM4rk3QAQARXAOgdH0jDq8D3/bAlbzjBDrLqHHV?=
 =?us-ascii?Q?aya5B2yqkPuvKo673Y8Kqauepz+V/+d+aDTSMqWZdfSiIWNDrwoUW7nV0DCL?=
 =?us-ascii?Q?8nWPNj/iIeIQi2wN6/eI36KqdOu7zOTeEpsADmK+dXvtHftJiMJumk1i6+1S?=
 =?us-ascii?Q?Ji8wAGBtRnzYE7DqzAmHUzRhspVOQaZfiQJTjxQqcRsp2sssYs8YdD8IFLyU?=
 =?us-ascii?Q?TaShbL3nFscObiZQ+ZrCkqDx2spNrOO0Lzk8Sd9rLbvihuFyVrkJmm+x0ys5?=
 =?us-ascii?Q?6yGz7sT+KkBGXD3cNwC63LXucmXCn5BTtyxYXj3H940bp3OUbOQvgCxK3MTq?=
 =?us-ascii?Q?6MMW1UOhJuQxfWg6d9To4DRwfvQzw3R3wkGxSA+GYs2qW4yAF+3sLwCIEBQo?=
 =?us-ascii?Q?pfphy40ru4tobn5ktiSA7y8h2aSppj1MYkfV/I4+YMSvsA3vxpIVwLlq/oAD?=
 =?us-ascii?Q?vyq/mLLUnfRpzJG3sZqJBfD+fMqf0Ny9EBaF7NRnGYLyiPgrTJrLgT6FKwFy?=
 =?us-ascii?Q?OgBdDhVC41n9Q6csJYeAcMkP3YcQ9xkWa4cXYUT92uLBRSMjuTooXuYDCRIW?=
 =?us-ascii?Q?c3i0M50xX3Ejkw3nhCZ5Pq3Bn+rFGk1apIPq3cQMJIUJlvWb6QodsJ9t01ts?=
 =?us-ascii?Q?a1XIyLMpwzWwVJOCEkoI+LV5dqa4m0j48IomsqP29ChbGkSdBXlcVtCTpTcv?=
 =?us-ascii?Q?zRm84s6RpwB1TUD+YUSddtj0L7bDgaZ1BznnDUbeAPWnNdb7ZqpLxX0b1pbJ?=
 =?us-ascii?Q?KbhobcgF0wYXF/yGpYzx1i7zaVmkrU6GKv5/3CA/31oZNTXuaO+sBFM4A/27?=
 =?us-ascii?Q?J3vfGUA3h9gzAFCQLxewwtBDBw+rEid8INBGV+4RXEG++CVV/G05+oiOSoaE?=
 =?us-ascii?Q?pbF88FiQ1Djo2GWjOJgr4xivn1VgPi/dIX9GZXwGXN1rtH/9xDfA35d0yrFb?=
 =?us-ascii?Q?bAT3RRXtGDwDz2oipXMKoqZl3F4K9rpcA3Uygxk19C1Xslqim1UArifKtEO7?=
 =?us-ascii?Q?1VLIEYDiHlF891vDg7tTgTeY78rqdlLC+341+u94YjXxfpT5RV9XgBPLuuQY?=
 =?us-ascii?Q?0Bo7nvCgvKoFcyqYQykIhZzUmHyCzT0inGPo84ILtz2y8h9fV9+WxJVrZ1rs?=
 =?us-ascii?Q?7Vzjl2rZ5PW4b/V7/IOcHFVgHooiXVVRjfe3i6tvW3kdoLTAeyIDnqUrEqxC?=
 =?us-ascii?Q?yWYn4UHevEMCHGo4VQ/KLKwfR361MBhetBrHwkqDm8A3Fq04PLEK13bs6PpC?=
 =?us-ascii?Q?GYAAYXUsBTp0MzDkWrrLWyt6OeX2mkEJeURE+KGuozxtq3kElmEjPza5lpKK?=
 =?us-ascii?Q?wJmTjd5KaKJzcBYyZxcC4QkvtOQiqMKhBzhKNjWPll7citJ9nxtXi0d47ovx?=
 =?us-ascii?Q?33/TQIMdp6VuqI6Aopo9Rgu2sktGRHGSwIYKXhvlpJjalfUwzoZXduR5tMWA?=
 =?us-ascii?Q?O3PAPCXTKOFoZvkth+i+jrOZZ2PrA3gUtjFo3JkvKAgXR0h3Iw+v3OeUODZF?=
 =?us-ascii?Q?Sheo6z7+SxUGDoy+aWVPR0Lq2HUC/A39tP7l4T0YVzuKTQjitLB0mzLiUqJI?=
 =?us-ascii?Q?DUR0X1UUCReAz8am6KId66qZ+PjHcov8qqu6cS37gouMm59BldbvEa/9ZQ+p?=
 =?us-ascii?Q?7qWuxQetwNPanyDt2FlrATGlZoSiQwpKkAYir0pgFXZJil5DJb0EV9C0vGrz?=
 =?us-ascii?Q?l4UZAIxEKhw5p/DbCBYCqhtkK4wNOcO0jtuUB1ASv1/nixfPNu6w12OtjkqV?=
 =?us-ascii?Q?9MKatBXWh8hGD3E7VWykoGm6nQtAg1E=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 360db289-bcef-4bd1-46f1-08da4fe7707d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 22:27:47.1988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l5Z6e3ATMU5BwDryqj9m+Q3v6ytOoVhNUG7web8r4KiNfdGEt2xF5CmMmVYCKiRaHimS71zBUD8d9a39f5kCiIUvfjc3j7Bz63xkn/UxknU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1267
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-16_16:2022-06-16,2022-06-16 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 adultscore=0 suspectscore=0 mlxlogscore=912 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206160090
X-Proofpoint-ORIG-GUID: pLHzHt35e4OFqc-bM28J-XSvGpFJ5NiM
X-Proofpoint-GUID: pLHzHt35e4OFqc-bM28J-XSvGpFJ5NiM
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches are some fixes for qla4xxx and qedi. They were built
over linus's tree, but apply over Martin's staging and queueing branches.
They do not have conflicts with the other iscsi patches that I've ackd on
the list, so they can be applied before or after those patches.

The first patch is trivial and fixes a bug that can only be triggered with
qla4xxx which should be rare. Patches 2 - 6 are more invassive and fix a
regression in qedi where shutdown hangs when you are using that driver for
iscsi boot. I was not sure if this was too much of an edge case and the
pathes were too invassive for 5.19 so the patches do apply over either
of your 5.19 or 5.20 branches.


